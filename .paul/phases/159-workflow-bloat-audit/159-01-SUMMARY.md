---
phase: 159-workflow-bloat-audit
plan: 01
completed: 2026-03-28T00:55:00Z
duration: ~1 session
---

## Objective
Produce an evidence-backed audit of how Pi-facing workflow layers, skill wrappers, and shared workflow prose amplify recurring context cost around hot artifacts, especially `.paul/STATE.md` and `.paul/ROADMAP.md`.

## What Was Built

| File | Purpose | Lines |
|------|---------|------:|
| `.paul/phases/159-workflow-bloat-audit/workflow-read-surface-inventory.md` | Inventoried Pi-era entry points, workflow layers, and authority-artifact pull paths with hot/warm/cold context classifications | 113 |
| `.paul/phases/159-workflow-bloat-audit/prompt-shape-duplication-audit.md` | Isolated repeated required-reading bundles, wrapper/workflow restatement, and prompt-shape duplication patterns with citations | 134 |
| `.paul/phases/159-workflow-bloat-audit/159-workflow-bloat-report.md` | Synthesized confirmed, plausible, and open workflow-side findings plus bounded reduction directions for Phase 160 | 191 |

Total new audit artifact volume: **438 lines** across **3 files**.

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Workflow read surfaces and artifact pull points are inventoried with evidence | PASS | `workflow-read-surface-inventory.md` maps Pi skills, shared workflows, and hot-artifact reads while distinguishing required-reading, support references, and guided UX support |
| AC-2 | Prompt-shape duplication and recurring context-expansion patterns are isolated | PASS | `prompt-shape-duplication-audit.md` documents repeated required-reading bundles, wrapper/workflow restatement, and repeated authority/continuity prose with file-backed examples |
| AC-3 | Workflow-side findings produce bounded reduction directions for Phase 160 | PASS | `159-workflow-bloat-report.md` separates confirmed workflow amplification from open questions and hands bounded cleanup directions to Phase 160 |

## Reconciliation: Plan vs Actual

### Task 1 — Build a workflow read-surface inventory for Pi-era lifecycle entry points
**Planned:** inspect repo-source Pi entry points and the highest-signal shared workflows, then classify how they pull `STATE.md`, `ROADMAP.md`, `PROJECT.md`, handoffs, and related authority artifacts into context.

**Actual:** completed as planned.
Key findings included:
- Pi wrapper skills and shared workflows repeatedly reintroduce the same authority artifacts in close succession
- `STATE.md` remains the dominant hot artifact while `ROADMAP.md` remains the main warm-path companion
- Several entry surfaces re-pull the same files for routing, continuity, and guided UX reasons rather than because the artifacts themselves are unusually large

### Task 2 — Audit prompt-shape duplication and recurring context-expansion patterns
**Planned:** identify concrete duplicated wording, broad required-reading lists, repeated authority/continuity framing, and marker/prose patterns that inflate recurring context cost.

**Actual:** completed as planned.
Key findings included:
- wrapper skill shells frequently restate the same workflow purpose and file-reading expectations already present in shared workflows
- repeated lifecycle markers are mostly acceptable, but the surrounding explanatory prose is a stronger reduction target
- copied module-dispatch scaffolding and repeated hot-artifact bundles appear to be meaningful workflow-side amplification factors

### Task 3 — Synthesize workflow-side findings into a bounded reduction report
**Planned:** classify workflow-side findings as confirmed, plausible, or open and provide bounded reduction directions without redesigning artifacts or implementing changes.

**Actual:** completed as planned.
The report:
- separated workflow-side amplification from the artifact-side pressure already isolated in Phase 158
- identified wrapper preambles, repeated hot-artifact read bundles, copied dispatch scaffolding, and duplicated continuity/authority prose as the strongest workflow-side bloat candidates
- kept recommendations bounded to wording, read-discipline, and surface simplification directions for Phase 160 rather than implementation work in Phase 159

## Verification Results

### Ground-truth reconciliation
- `git show --stat --name-only --oneline HEAD` matched the documentation-only APPLY scope for Phase 159
- Planned `files_modified` entries were all `.paul/phases/159-workflow-bloat-audit/` artifacts, and the created outputs matched that plan
- Additional lifecycle artifacts (`.paul/STATE.md`, `.paul/ROADMAP.md`, archived handoff) changed as expected for plan/apply bookkeeping; no product or runtime implementation files were modified

### File checks
- `test -f .paul/phases/159-workflow-bloat-audit/workflow-read-surface-inventory.md && grep -q "Workflow Read-Surface Inventory" ... && grep -q "STATE.md" ... && grep -q "drivers/pi/skills" ...` ✅
- `test -f .paul/phases/159-workflow-bloat-audit/prompt-shape-duplication-audit.md && grep -q "Prompt-Shape Duplication Audit" ... && grep -qi "required-reading" ... && grep -q "kernel/workflows/plan-phase.md" ...` ✅
- `test -f .paul/phases/159-workflow-bloat-audit/159-workflow-bloat-report.md && grep -q "Confirmed Findings" ... && grep -q "Candidate Reduction Directions" ... && grep -q "Phase 160 Hand-off" ...` ✅
- Phase plan count vs summary count after UNIFY draft creation: **1 / 1** ✅

### Scope / regression checks
- No existing workflow, skill, extension, or authority artifact files were modified as part of the Phase 159 audit deliverables themselves
- APPLY remained audit-only; no workflow reduction, artifact redesign, or runtime implementation work was performed

### Skill audit
- Required lifecycle skill `/paul` was invoked for PLAN → APPLY → UNIFY ✅
- Project-level `/carl`, TODD, and WALT remain configured in `.paul/SPECIAL-FLOWS.md`, but this documentation-only audit did not require TDD execution or quality gating beyond stable reconciliation notes

## Module Execution Reports

[dispatch] pre-unify: 0 modules registered for this hook

### Carried forward from APPLY
- Module hooks were effectively non-applicable during this research-only APPLY pass: there was no root test runner/config for WALT execution, no TDD path for TODD, and no meaningful enforcement/advisory work beyond documentation artifacts
- APPLY still produced durable evidence in the three Phase 159 audit artifacts and left the PR in a clean, passing state for UNIFY

### Post-unify
- WALT (p100): PASS — quality delta is **stable**. Added `159-01` to `.paul/QUALITY-HISTORY.md` with tests unchanged at **123 pass + 60 pass**, coverage/lint/types unchanged (`—`), trend `→ stable`
- SKIP (p200): PASS — captured durable knowledge from this phase:
  - **Decision Record:** Separate workflow-side amplification from artifact-side cost during context-bloat analysis. Context: Phase 158 already isolated artifact growth and hot-path recurrence, so Phase 159 needed a clean workflow-only evidence lane. Decision: keep the audit Pi/workflow focused and avoid reopening artifact measurement. Alternatives considered: merge both audits immediately (rejected: would blur evidence lanes), re-measure artifacts during workflow review (rejected: redundant). Rationale: Phase 160 needs two distinct evidence streams before ranking fixes. Impact: recommendation work can combine artifact and workflow findings without confusing root causes.
  - **Decision Record:** Treat repeated markers as mostly intentional duplication and surrounding prose/read bundles as the primary workflow reduction target. Context: the audit found both recurring markers and broader explanatory repetition. Decision: preserve canonical markers like `Would you like to see the plan?`, `Continue to APPLY?`, `Continue to UNIFY?`, `CHECKPOINT:`, and `▶ NEXT:` while targeting wrapper preambles, repeated hot-artifact bundles, and copied continuity prose first. Alternatives considered: trim markers aggressively (rejected: harms guided UX consistency), leave all duplication untouched (rejected: misses credible workflow-side savings). Rationale: markers provide bounded workflow structure, while surrounding prose creates most of the avoidable context mass. Impact: Phase 160 can prioritize safe wording and read-discipline reductions without destabilizing guided workflow semantics.
  - **Lesson Learned:** Workflow layering can make compact authority artifacts feel more expensive than their raw size alone suggests. What happened: Phase 159 showed that repeated wrappers, read lists, and restated lifecycle framing can amplify pressure around `STATE.md` and `ROADMAP.md`. What we learned: repeated-read discipline matters alongside artifact size. How to apply: Phase 160 should rank fixes that reduce repeated workflow pulls before considering artifact redesign.
- RUBY (p300): PASS — debt scan on changed artifact files via `wc -l` found **113 / 134 / 191** lines; all are below the 300-line warning threshold. No technical-debt concern from file size in this changed set.

## Deviations
None.

## Key Patterns / Decisions
- Workflow-side context cost comes mainly from repeated entry-surface layering, not from unusually large authority files
- `STATE.md` and `ROADMAP.md` remain the hot and warm artifacts, but workflow wording and read discipline amplify how often they are pulled back into context
- Canonical guided-workflow markers look mostly intentional; wrapper preambles, repeated hot-artifact bundles, and duplicated continuity/authority prose are the more credible reduction targets
- Phase 160 should combine Phase 158 and Phase 159 evidence rather than reopening measurement

## Merge Gate Status
- PR `#68` exists and CI is currently passing
- Reviews are not required by `pals.json`
- Merge gate is ready for final PR merge resolution in UNIFY

## Next Phase
Phase 159 is complete. Transition to **Phase 160 — Findings & Recommendation Package** once the merge gate is cleared.
