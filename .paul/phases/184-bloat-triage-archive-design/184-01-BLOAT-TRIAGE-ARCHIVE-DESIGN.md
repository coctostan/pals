# Phase 184 Bloat Triage + Archive Design

_Date:_ 2026-04-26  
_Phase:_ 184 — Bloat Triage + Archive Design  
_Output:_ Practical design report for v2.43 Phase 185 implementation

## Executive Summary

PALS' context problem is no longer just "too much markdown." It is a layering problem:

1. **Hot Path cost** comes from files that are repeatedly read or parsed during daily workflow (`STATE.md`, then `ROADMAP.md` and `PROJECT.md`).
2. **Warm Path cost** comes from large workflow/module/validation surfaces that are read during specific lifecycle phases.
3. **Cold Archive cost** comes from historical accumulation (`.paul/phases/`, handoffs, milestone rollups) that should stay durable but should not live in hot artifacts.

The highest-leverage Phase 185 move is to introduce an indexed `.paul/archive/` convention and migrate cold historical density out of live artifacts while preserving exact links back to authoritative history.

Recommended Phase 185 focus:

- Create `.paul/archive/INDEX.md` as the single archive entry point.
- Compact `.paul/MILESTONES.md` into a live milestone index plus archive links.
- Compact `.paul/PROJECT.md` back to a true project brief.
- Compact `.paul/STATE.md` to routing/current state plus short latest decisions only.
- Keep `.paul/ROADMAP.md` focused on current/near-future planning, moving older milestone detail to archive files.

Do **not** change PLAN/APPLY/UNIFY semantics, guided markers, dispatch logs, checkpoints, merge gates, or artifact authority.

## Current Measurements

Lightweight current observations:

| Surface | Size | Lines | Class | Read-pressure note |
|---------|------|------:|-------|--------------------|
| `tests/pi-end-to-end-validation.sh` | 53.2 kB | 1162 | Warm | Large validation surface; not hot artifact state |
| `.paul/PROJECT.md` | 52.8 kB | 355 | Hot/warm | Intended compact brief has drifted into dense history/product ledger |
| `.paul/MILESTONES.md` | 46.0 kB | 837 | Cold-adjacent live | Large history ledger; usually not daily hot-path, but still live root artifact |
| `tests/cross-harness-validation.sh` | 42.1 kB | 795 | Warm | Validation surface, not lifecycle authority |
| `.paul/STATE.md` | 42.0 kB | 251 | Hot Path | Runtime/resume/status authority; recurring read pressure is high |
| `kernel/workflows/init-project.md` | 37.1 kB | 1039 | Warm | Heavy route-specific workflow |
| `kernel/workflows/apply-phase.md` | 31.8 kB | 725 | Warm | Heavy route-specific workflow; dispatch wording must stay reliable |
| `.paul/ROADMAP.md` | 29.1 kB | 731 | Hot/warm | Main planning/milestone frame; repeatedly referenced |
| `kernel/workflows/unify-phase.md` | 24.7 kB | 614 | Warm | Heavy route-specific workflow; merge/module gates are sensitive |

Current corpus shape:

| Area | Files | Size | Interpretation |
|------|------:|------|----------------|
| `.paul/` total | 629 | 4.9 MB | Durable history is now substantial |
| `.paul/phases/` | 482 | 3.9 MB | Main total-footprint driver; mostly cold history |
| `.paul/handoffs/archive/` | 110 | 444.3 kB | Cold resume/history support; needs indexing, not hot-path reads |
| `.paul/milestones/` | 20 | 252.7 kB | Useful rollups; should be linked from a compact index |

Phase 158 measured the earlier shape at 534 `.paul/` files and 3.66 MB. The current 629 files / 4.9 MB confirms continued historical accumulation, but raw footprint still should not be treated as equal to recurring context pressure.

## Leverage Ranking

### 1. `STATE.md` hot-density reduction

**Class:** Hot Path  
**Leverage:** Highest for repeated resume/status/Pi lifecycle work  
**Risk:** High if authority or parser expectations are changed

`STATE.md` is hot because it is repeatedly consulted for phase, loop, current plan, git state, and session continuity. Its current size is driven mostly by long decision/fix/audit history. That history is valuable but does not need to be in the operational read path every time.

**Phase 185 target:** keep the top operational state compact and move older accumulated history into linked archive files.

### 2. `PROJECT.md` compact-brief restoration

**Class:** Hot/warm  
**Leverage:** High because planning and orientation read it as the project brief  
**Risk:** Medium if current product facts are accidentally removed

Phase 158 found `PROJECT.md` was behaving reasonably as a compact brief at the time. It is now 52.8 kB and is the largest root `.paul` file. That means the compact-brief invariant has drifted.

**Phase 185 target:** restore it to product identity, current posture, active requirements summary, and durable links. Move old validated/history lists into archive.

### 3. `ROADMAP.md` active-window compaction

**Class:** Hot/warm  
**Leverage:** High for planning/status/milestone routes  
**Risk:** Medium-high because roadmap semantics drive future planning

Phase 160 identified `ROADMAP.md` as the strongest combined artifact + workflow amplifier. Phase 163 already completed a workflow-first prose/read-discipline pass, so Phase 185 can safely design the artifact side: a smaller active window with archive links for old milestone detail.

**Phase 185 target:** keep current milestone and near-future phase plan live; move older milestone detail to archive or existing `.paul/milestones/` rollups.

### 4. `MILESTONES.md` live-index conversion

**Class:** Cold Archive / live index  
**Leverage:** Medium-high for root-artifact cleanliness; lower for daily hot path  
**Risk:** Medium

`MILESTONES.md` is large and mostly historical. It belongs as a compact index to milestone rollups and archive entries, not as a forever-growing narrative ledger.

**Phase 185 target:** keep a concise milestone table with links; archive detailed completed milestone narratives.

### 5. Workflow/module prose and validation surface compression

**Class:** Warm Path  
**Leverage:** Medium-to-high, but not Phase 185's first archive task  
**Risk:** High where model compliance depends on explicit wording

`kernel/workflows/apply-phase.md`, `unify-phase.md`, `init-project.md`, and validation scripts are large. But Phase 160/163 already showed workflow changes need semantic validation, not size-only cuts.

**Phase 185 target:** only record candidates and preserve guardrails. Phase 186 should own actual workflow/module compression.

### 6. `.paul/phases/`, handoffs, and milestone rollups

**Class:** Cold Archive  
**Leverage:** Medium for browseability and storage; lower direct hot-path relief  
**Risk:** Low-to-medium if links are preserved

These dominate total footprint, but most are not recurring prompt pressure. They need indexing and predictable discovery, not deletion.

**Phase 185 target:** create index conventions and migrate only the live-root history that currently forces cold content into hot files.

## Hot Path / Warm Path / Cold Archive Classification

### Hot Path

Read or parsed during common session routing, resume/status, plan entry, or Pi lifecycle surfaces.

- `.paul/STATE.md`
- `.paul/PROJECT.md`
- active slices of `.paul/ROADMAP.md`
- current plan file during APPLY/UNIFY
- active root handoff, if present

**Shape target:** short, current, directly actionable, and link-rich. Hot files should answer "where are we and what happens next?" rather than preserve full history.

### Warm Path

Read for specific lifecycle routes or verification surfaces, but not every session.

- `kernel/workflows/init-project.md`
- `kernel/workflows/apply-phase.md`
- `kernel/workflows/unify-phase.md`
- module references and manifests
- validation scripts such as `tests/pi-end-to-end-validation.sh`
- `.paul/ROADMAP.md` older active-milestone planning detail

**Shape target:** explicit enough for reliable model behavior, but avoid duplicated prose after a contract is already stated once.

### Cold Archive

Durable history, prior evidence, completed milestone details, old decisions, and handoff history.

- `.paul/phases/**`
- `.paul/handoffs/archive/**`
- `.paul/milestones/**`
- old decision/fix/audit ledger rows from `.paul/STATE.md`
- completed milestone narratives from `.paul/MILESTONES.md`
- old validated/product history from `.paul/PROJECT.md`

**Shape target:** durable, indexed, discoverable, and linked from hot files only when needed.

## Archive Convention

### `.paul/archive/INDEX.md`

`.paul/archive/INDEX.md` should be the single archive entry point. It should not duplicate full archive content. It should point users and agents to the right cold artifact quickly.

Recommended structure:

```markdown
# PALS Archive Index

## Purpose
Cold historical material moved out of hot lifecycle artifacts. These files remain durable project truth, but are not required for normal resume/status/plan routing.

## Current Hot Artifacts
| Artifact | Role | Archive Links |
|----------|------|---------------|
| `.paul/STATE.md` | Current state/routing | decisions, fixes, skill audits |
| `.paul/PROJECT.md` | Compact project brief | product history, validated legacy list |
| `.paul/MILESTONES.md` | Compact milestone index | detailed milestone history |
| `.paul/ROADMAP.md` | Active roadmap window | completed roadmap windows |

## Archive Catalog
| File | Contains | Source | Last moved |
|------|----------|--------|------------|
| `decisions/DECISIONS-0001-0183.md` | Historical decisions through Phase 183 | `STATE.md` | YYYY-MM-DD |
| `milestones/MILESTONES-v0-v2.42.md` | Completed milestone narratives | `MILESTONES.md` | YYYY-MM-DD |
| `project/PROJECT-HISTORY.md` | Historical validated/product lists | `PROJECT.md` | YYYY-MM-DD |
```

### Required archive entry fields

Each archive file should begin with:

- `# Title`
- `Source:` original live artifact(s)
- `Archived on:` date
- `Scope:` phase/milestone/date range
- `Still authoritative?` yes/no and for what
- `Return link:` the live artifact that points here

### Link style from hot artifacts

Use short explicit links:

- `Historical decisions through Phase 183: .paul/archive/decisions/DECISIONS-0001-0183.md`
- `Completed milestone narratives: .paul/archive/milestones/MILESTONES-v0-v2.42.md`
- `Legacy validated requirement history: .paul/archive/project/PROJECT-HISTORY.md`

Avoid vague phrases like "see archive" with no exact file.

## Migration Candidates

### Recommended Phase 185 migration list

| Priority | Source | Move to | What moves | What stays hot |
|----------|--------|---------|------------|----------------|
| 1 | `.paul/MILESTONES.md` | `.paul/archive/milestones/MILESTONES-v0-v2.42.md` plus existing `.paul/milestones/*` links | Completed milestone narrative/detail older than current milestone | compact milestone index: version, title, status, link |
| 2 | `.paul/PROJECT.md` | `.paul/archive/project/PROJECT-HISTORY.md` | long validated legacy lists and old phase-by-phase product history | description, core value, current active requirements, current validated summary, archive links |
| 3 | `.paul/STATE.md` | `.paul/archive/decisions/DECISIONS-0001-0183.md`, `.paul/archive/fixes/FIXES-0001-0183.md`, `.paul/archive/audits/SKILL-AUDITS-0001-0183.md` | old decision/fix/deviation/audit rows not needed for active routing | current position, loop position, latest relevant decisions, blockers, git state, session continuity |
| 4 | `.paul/ROADMAP.md` | `.paul/archive/roadmap/ROADMAP-v0-v2.42.md` or existing `.paul/milestones/*` | completed milestone details and old roadmap windows | current milestone, next immediate phases, compact completed-milestone link table |
| 5 | `.paul/handoffs/archive/` | `.paul/archive/handoffs/INDEX.md` or keep current location with index link | no bulk move required initially; add index/segmentation if needed | active `.paul/HANDOFF*.md` only |

### Stays Hot

- `STATE.md`: current position, current loop, current plan, blocker/current git state, session continuity, latest few decisions only when they affect the current phase.
- `PROJECT.md`: identity, core value, compact active requirements, current product posture, links to history.
- `ROADMAP.md`: current milestone details and immediate next phases.
- `MILESTONES.md`: one compact milestone table, not narrative history.

### Moves Cold

- Old decision tables beyond the currently relevant window.
- Long completed-milestone narratives.
- Legacy validated requirement checklists that no longer guide daily planning.
- Historical handoffs, trial data, prior plan outputs, and older milestone rollups.

### Suggested directory shape

```text
.paul/archive/
  INDEX.md
  decisions/
    DECISIONS-0001-0183.md
  fixes/
    FIXES-0001-0183.md
  audits/
    SKILL-AUDITS-0001-0183.md
  milestones/
    MILESTONES-v0-v2.42.md
  project/
    PROJECT-HISTORY.md
  roadmap/
    ROADMAP-v0-v2.42.md
```

Phase 185 should create only the files it needs for the first migration wave. Do not overbuild the archive tree before content exists.

## Guardrails

### Do Not Weaken Lifecycle Behavior

The archive split must preserve:

- `.paul/*` artifact authority
- PLAN/APPLY/UNIFY rigor
- visible module dispatch logs
- checkpoint behavior
- GitHub Flow branch/PR/merge gates
- exact next-action routing
- guided workflow marker stability
- resume handoff discovery, including active handoffs before archived handoffs

### Do Not Replace Artifact Truth

Do not use hidden runtime state, telemetry, Pi-owned persistence, local memory, or implicit caches as the answer to bloat. Archive files are still explicit durable artifacts.

### Do Not Treat Size Alone As Failure

Some warm workflow files are long because they encode model-compliance contracts. Compression should be semantic and validated, not a blanket line-count cut.

### Do Not Delete Cold History

Cold does not mean disposable. Historical decisions and milestone records remain useful for audits, regressions, and product continuity. Move and index them; do not erase them.

## Anti-Regrowth Checks

Phase 185/186 validation should use semantic checks such as:

- `PROJECT.md` contains a compact brief and archive links, not a long phase-by-phase history.
- `STATE.md` begins with current routing data and keeps historical tables either short or linked to archive files.
- `MILESTONES.md` remains an index table with archive links.
- `ROADMAP.md` keeps current milestone detail and does not re-accumulate old milestone narratives.
- `.paul/archive/INDEX.md` links every archive file created during migration.
- Resume/status/plan workflows still find the exact next action and current phase after compaction.

Avoid requiring over-scientific benchmarking. A good enough validation suite should prove that hot artifacts are compact, links are present, and lifecycle routing still works.

## Phase 185 Handoff

Recommended implementation sequence:

1. Create `.paul/archive/INDEX.md` with the minimal catalog and archive policy.
2. Convert `.paul/MILESTONES.md` to a compact index first; it is large, mostly cold, and lower-risk than `STATE.md`.
3. Restore `.paul/PROJECT.md` to compact-brief shape; move legacy validated/history detail to archive.
4. Compact old `STATE.md` decision/fix/audit density only after the archive link pattern is proven by the first two files.
5. Trim `.paul/ROADMAP.md` completed-history detail into archive links while keeping v2.43 and immediate next phases live.
6. Run semantic validation that resume/status/plan still route correctly and archive links resolve.

Recommended Phase 186 deferral:

- compress `kernel/workflows/apply-phase.md` / `unify-phase.md` dispatch prose
- split or restructure large validation scripts
- trim module manifests/references

Out of scope:

- hidden Pi/runtime state as a substitute for artifacts
- CODI validation changes without real usage evidence
- broad `.paul/phases/` deletion or rewriting
- parser/guided-marker changes without explicit validation

## Acceptance Criteria Mapping

| AC | Result |
|----|--------|
| AC-1: leverage-ranked inventory | PASS — report ranks Hot Path, warm workflow, and Cold Archive candidates by recurring-context leverage rather than raw size alone |
| AC-2: actionable indexed archive design | PASS — report defines `.paul/archive/INDEX.md`, archive fields, link style, directory shape, and Migration Candidates |
| AC-3: process-quality guardrails | PASS — report names lifecycle behaviors to preserve and lists anti-regrowth validation ideas |

## Bottom Line

Phase 185 should not try to shrink everything. It should build the archive index and move cold history out of hot/live root artifacts first. That gives immediate context relief while keeping PALS' core process — explicit artifacts, PLAN/APPLY/UNIFY, visible dispatch, and exact routing — intact.
