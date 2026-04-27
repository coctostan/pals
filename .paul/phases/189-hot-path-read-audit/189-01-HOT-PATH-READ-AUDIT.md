---
phase: 189-hot-path-read-audit
plan: 01
type: research
artifact: HOT-PATH-READ-AUDIT
generated_by: paul-apply
generated_at: 2026-04-27
---

# Phase 189 — Hot-Path Read Audit

> Goal: Measure the recurring read cost of normal PALS PLAN / APPLY / UNIFY / resume / milestone work after Phase 188's wrapper slimming, and identify the highest-value next reductions for Phase 190 (artifact simplification) and Phase 191 (validation + anti-regrowth).
>
> Boundaries: This is an audit. It does not change runtime behavior, workflow semantics, module dispatch contracts, GitHub Flow gates, or Pi context injection logic. It does not compact `.paul/ROADMAP.md`, `.paul/STATE.md`, or workflow files. It does not add telemetry or hidden runtime state. It does not expand Claude-specific support surface.

---

## How "hot-path" is defined here

A surface is **hot** if a normal PALS lifecycle turn (resume, plan, apply, unify, status, milestone) reads it as part of its required-reading or transitive-reference contract. **Warm** means it is read on phase transitions, milestone boundaries, or fix loops. **Cold** means it is only read on rare events (init, debug, archive lookups).

Trigger frequency below is an explicit assumption derived from the workflows' `<required_reading>` / `<references>` sections — there is no telemetry. Counts are captured as of this audit (line counts via `wc -l` semantics; bytes via filesystem size). Every claim about "is read" is an inference from the loaded skill / workflow contract, not from runtime measurement.

---

## Hot-Path Inventory

### Aggregate totals

| Category | Files | Total lines | Total bytes | Class | Trigger (assumed) |
|----------|------:|------------:|------------:|-------|-------------------|
| `.paul/*` lifecycle artifacts (active) | 5 | 1,058 | 52,089 | Hot | Every PLAN/APPLY/UNIFY/resume/status turn |
| Core lifecycle workflows (`plan/apply/unify`) | 3 | 1,632 | 71,666 | Hot | Once per matching loop step |
| Warm lifecycle workflows (resume / transition / milestone / pause / fix / roadmap) | 7+ | 2,721+ | 85,013+ | Warm | Phase or milestone boundary, or fix loop |
| Hot kernel references (loop-phases, module-dispatch, checkpoints, subagent-criteria, context-management, plan-format, git-strategy) | 7 | 1,461 | 44,809 | Hot/Warm | Loaded transitively from core workflows |
| Pi skill wrappers (full set, post-Phase 188) | 13 | 359 | 15,144 | Hot (one per command) | First read at command activation |
| Claude command wrappers (full set) | 12 | 1,339 | 38,668 | Cold/Reference | Only read on Claude harness; thin pointers per Phase 188 |
| Pi adapter / context injection | `drivers/pi/extensions/pals-hooks.ts` | 1,331 | 47,667 | Hot (Pi runtime) | Loaded once per Pi session, dispatch-driven thereafter |
| `.paul/archive/*` (cold authority) | 4 | 1,475 | 143,435 | Cold | Only on explicit historical lookup |
| `.paul/handoffs/archive/*` (cold) | 113 | 12,092 | — | Cold | Only on resume fallback when no active handoff |

### Top hot lifecycle artifacts

| Path | Lines | Bytes | Class | Trigger | Notes |
|------|------:|------:|-------|---------|-------|
| `.paul/ROADMAP.md` | 744 | 29,888 | Hot | PLAN, APPLY, UNIFY, resume, status, milestone | 4 active phase rows; **~690 lines are completed-milestone history below the active window**. Top of file is the active slice. |
| `.paul/PROJECT.md` | 110 | 7,783 | Hot | PLAN, resume, milestone, status | Project brief; mostly stable prose. |
| `.paul/STATE.md` | 89 | 6,632 | Hot | Every turn (lifecycle truth) | Already compacted in Phase 185 — historical accumulated context lives in `.paul/archive/state/STATE-HISTORY-v0-v2.43.md`. |
| `.paul/MILESTONES.md` | 74 | 5,589 | Warm | Milestone boundaries | Compact index; historical detail lives in `.paul/archive/milestones/MILESTONES-v0-v2.42.md` (852 lines cold). |
| `.paul/SPECIAL-FLOWS.md` | 41 | 2,197 | Warm | Plan posture decisions / required-skill checks | Already small. |

### Top core workflows (loaded by skill activation)

| Path | Lines | Bytes | Class | Trigger | Notes |
|------|------:|------:|-------|---------|-------|
| `kernel/workflows/apply-phase.md` | 694 | 29,981 | Hot | Every APPLY | 13 `<step>` blocks; extensive duplicated GitHub Flow preflight/postflight (`jq -r '.git…` repeated 13× in this file alone). |
| `kernel/workflows/unify-phase.md` | 589 | 22,687 | Hot | Every UNIFY | 18 `<step>` blocks; merge-gate + transition + post-unify dispatch. |
| `kernel/workflows/plan-phase.md` | 349 | 18,998 | Hot | Every PLAN | 15 `<step>` blocks; CODI seeding + advisory/enforcement dispatch. |

### Top warm lifecycle workflows

| Path | Lines | Bytes | Class | Trigger | Notes |
|------|------:|------:|-------|---------|-------|
| `kernel/workflows/transition-phase.md` | 583 | 19,477 | Warm | Phase transitions | Repeats GitHub Flow logic (`jq -r '.git…` ×13). |
| `kernel/workflows/complete-milestone.md` | 481 | 13,499 | Warm | Milestone close | Repeats milestone authority + GitHub Flow stanzas. |
| `kernel/workflows/roadmap-management.md` | 471 | 14,706 | Warm | Roadmap edits | Heavy GitHub Flow repetition. |
| `kernel/workflows/fix-loop.md` | 347 | 11,241 | Warm | `/paul:fix` only | Specialized; not on the PLAN/APPLY/UNIFY hot path. |
| `kernel/workflows/pause-work.md` | 299 | 7,866 | Warm | Session pause | Repeats GitHub Flow stanzas. |
| `kernel/workflows/resume-project.md` | 268 | 10,127 | Hot at session start | Resume | Single-shot per session boundary. |
| `kernel/workflows/create-milestone.md` | 272 | 8,097 | Warm | Milestone start | Stable. |

### Top hot/warm kernel references (loaded transitively)

| Path | Lines | Bytes | Class | Trigger | Notes |
|------|------:|------:|-------|---------|-------|
| `kernel/references/git-strategy.md` | 272 | 9,769 | Warm | Github-flow gate decisions | Source of truth; workflows duplicate fragments. |
| `kernel/references/plan-format.md` | 263 | 5,968 | Hot | PLAN | Plan template grammar reference. |
| `kernel/references/context-management.md` | 227 | 6,758 | Hot | Resume / PLAN | Already centralized; phase 187/188 anchor. |
| `kernel/references/loop-phases.md` | 216 | 5,458 | Hot | All lifecycle workflows | Stable. |
| `kernel/references/checkpoints.md` | 211 | 6,554 | Warm | APPLY only when plan has checkpoints | Conditional. |
| `kernel/references/subagent-criteria.md` | 185 | 5,896 | Hot during APPLY delegation | APPLY | Phase 155 delegation contract. |
| `kernel/references/module-dispatch.md` | 87 | 4,406 | Hot | All lifecycle workflows | Phase 186 anchor; well-sized. |

### Pi skill wrappers (full set, post-Phase 188)

13 files / **359 lines** total. Top: `paul-review` 90, `paul-help` 51, `paul-config` 45, others ≤ 20 lines each. Total wrapper read at activation = a single skill (median ~17 lines) plus the canonical workflow file the skill points at.

> Phase 188 baseline reference: the *selected* hot wrapper subset (resume/plan/apply/unify/status/init/pause/fix/discuss + Claude equivalents tracked in 188-01) was 296 lines after slimming, vs 406 before.

### Claude command wrappers (full set)

12 files / **1,339 lines** total — **3.7× the Pi wrapper total** for the same command set. Largest: `kernel/commands/paul/help.md` 501 lines, `review.md` 248, `config.md` 126. These should not load on the Pi hot path; they only matter when a user is on the Claude harness. Phase 188 already classified them as legacy/reference thin pointers.

### Pi adapter (runtime)

`drivers/pi/extensions/pals-hooks.ts` — **1,331 lines** (1,141 code, 31 comment, 159 blank), 73 top-level declarations. Loaded once per Pi process, dispatch-driven thereafter. Not re-read per turn, so its read cost is amortized — but its size affects extension review/edit cost and any "load full extension into context" operation a developer or agent performs.

### Cold archive surfaces (read only on explicit lookup)

| Path | Lines | Bytes | Notes |
|------|------:|------:|-------|
| `.paul/archive/milestones/MILESTONES-v0-v2.42.md` | 852 | 46,707 | Authoritative milestone history. |
| `.paul/archive/project/PROJECT-HISTORY.md` | 371 | 53,531 | Project history. |
| `.paul/archive/state/STATE-HISTORY-v0-v2.43.md` | 231 | 41,075 | State decisions/fixes/audits pre-v2.44. |
| `.paul/archive/INDEX.md` | 21 | 2,122 | Pointer index. |
| `.paul/handoffs/archive/*` | 113 files / 12,092 lines | — | Resume fallback only. |

---

## Per-turn assumed read budget (PLAN / APPLY / UNIFY)

A normal turn reads:

1. The Pi skill wrapper for the command (≤ 20 lines for hot lifecycle commands).
2. The canonical workflow it points at (PLAN 349, APPLY 694, UNIFY 589 lines).
3. `<required_reading>`:
   - `.paul/STATE.md` (89) — every command.
   - PLAN.md or SUMMARY.md path for the active phase (per-phase, not whole roadmap).
   - For APPLY: `modules.yaml` (the installed registry — kernel-side; not present in repo as a single file; lives under installed Pi skills directory).
4. `<references>` loaded transitively (loop-phases, module-dispatch, checkpoints when applicable, subagent-criteria, context-management).
5. `.paul/ROADMAP.md` — read for context by `paul-status`, `paul-resume`, and milestone-management workflows. **At 744 lines (~690 of which is below the active window) this is the single largest per-turn re-read.**

Estimated worst-case **per-turn** read for an APPLY (no checkpoints): wrapper (20) + apply-phase.md (694) + STATE.md (89) + module-dispatch.md (87) + loop-phases.md (216) + subagent-criteria.md (185) + plan-format.md (263) + active PLAN.md (~200–400) ≈ **1,750–1,950 lines**, plus whatever portion of `ROADMAP.md` (744) the agent re-loads to confirm phase context.

---

## Ranked Findings

> Each finding lists: paths, approximate recurring cost, *why* it is repeatedly read, what authority/safety must be **Preserve**d, and a safe reduction pattern. Quick wins first; larger architectural shifts last.

### F1 — `.paul/ROADMAP.md` is mostly historical and read every turn  *(QUICK WIN)*

- **Paths:** `.paul/ROADMAP.md` (744 lines / 29.9 KB).
- **Why hot:** Read by resume, status, plan, milestone-management, and during PLAN/APPLY/UNIFY for phase context. Active window is the top ~50 lines (Overview + Milestones index + Current Milestone). The remaining ~690 lines are 13 successive `## Completed Milestones` sections.
- **Cost:** ~690 lines × every turn that loads the roadmap. By far the largest unforced per-turn cost in the active `.paul/*` set.
- **Preserve:**
  - Roadmap remains authoritative — no deletion.
  - Completed milestone history must remain findable and editable.
  - Phase 185 archive-link convention already exists for STATE history.
- **Reduction pattern:** Apply the existing `.paul/archive/*` pattern that v2.43 used for STATE to ROADMAP: keep an active window (Overview + Milestones index + Current Milestone + the next planned milestone) inline, and move `## Completed Milestones` history to `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md` with a single inline pointer line. Phase 185 Plan 185-03 already defined a process-level "active-window/archive convention" — Phase 190 implements it for ROADMAP.
- **Maps to:** Phase 190.

### F2 — Three core workflows duplicate GitHub Flow preflight/postflight bash blocks  *(QUICK WIN)*

- **Paths:** `kernel/workflows/apply-phase.md` (jq `.git` ×13), `kernel/workflows/transition-phase.md` (×13), `kernel/workflows/unify-phase.md` (×10), plus `roadmap-management.md`, `pause-work.md`, `complete-milestone.md`, `progress.md` all repeat the same 4-tier `GIT_WORKFLOW` resolution + `git fetch`/`rebase`/`gh pr` stanzas.
- **Why hot:** Every APPLY/UNIFY turn re-reads the full preflight/postflight prose. Same logic, rewritten inline 5+ times across the kernel.
- **Cost:** Conservatively ~80–120 lines per duplicate × 5+ files = ~500–600 lines of pure duplicated specification, half of which is loaded on every PLAN/APPLY/UNIFY turn.
- **Preserve:**
  - GitHub Flow merge-gate enforcement remains call-site responsibility (Phase 186 anchor decision).
  - Each call-site keeps the obligation to actually run the gate.
  - `kernel/references/git-strategy.md` is already the source of truth (272 lines, well-sized).
- **Reduction pattern:** Phase 186 centralized module-dispatch mechanics in `references/module-dispatch.md` while workflows kept hook-local call-site obligations. Mirror that pattern for GitHub Flow: keep the resolved-input + decision contract inline (10–20 lines per call-site listing what to check and what to block on), and reference `kernel/references/git-strategy.md` for the bash recipe and 4-tier resolution rules. Net hot-path reduction: ~60–80 lines/workflow × 3 hot workflows ≈ **~200 hot-path lines saved** without weakening any merge gate.
- **Maps to:** Phase 190.

### F3 — `.paul/ROADMAP.md` and other artifacts already have indexed cold archives — but ROADMAP didn't get the treatment yet

- **Paths:** `.paul/ROADMAP.md` (active) vs missing `.paul/archive/roadmap/`.
- **Why hot:** v2.43 archive-link mechanics (Phase 184–185) already proved out for `STATE.md`, `MILESTONES.md`, and `PROJECT.md`. ROADMAP is the last hot lifecycle artifact still carrying full historical detail inline.
- **Cost:** Co-extensive with F1. Listed separately because the *mechanism* (archive-link convention validated in v2.43) is already proven; F1 is just applying it.
- **Preserve:** Same as F1 plus the validated v2.43 archive-link contract.
- **Reduction pattern:** Use the `STATE-HISTORY-v0-v2.43.md` pattern verbatim. Active milestone slice + linked archive index. The Phase 185 plans (185-01 / 185-02 / 185-03) are reusable templates.
- **Maps to:** Phase 190.

### F4 — Pi adapter (`pals-hooks.ts`) is a single 1,331-line module  *(STRUCTURAL)*

- **Paths:** `drivers/pi/extensions/pals-hooks.ts` (1,331 lines / 47.7 KB / 73 top-level declarations).
- **Why hot:** Not re-read per turn (Pi loads it once and dispatches), so its *runtime* read cost is amortized. But its size:
  - Inflates any "show me the extension" or "edit the activation logic" agent turn to ~1.3k lines.
  - Increases the cost of v2.44+ guardrail validation that scans the extension file.
  - Increases cognitive cost of any bug-fix or activation tweak.
- **Cost:** Variable. Hot whenever the extension itself is being modified or audited (Phase 188 / 187 work touched it; Phase 190+ likely will).
- **Preserve:**
  - Pi context injection logic, activation-window contract, and quick-action hooks are non-negotiable.
  - Module dispatch entry points stay intact.
  - No behavior change.
- **Reduction pattern:** Split by responsibility into 3–5 sibling files (e.g. `activation.ts`, `injection.ts`, `quick-actions.ts`, `lifecycle.ts`, plus a thin `pals-hooks.ts` orchestrator that re-exports). This is structural, not lifecycle, work — recommend deferring to **Phase 190 stretch or a dedicated future Pi-driver phase** rather than blocking artifact simplification on it.
- **Maps to:** Phase 190 stretch / future driver-quality milestone.

### F5 — Claude command wrappers are 3.7× the Pi wrapper total but were declared legacy/reference in Phase 188  *(STRATEGIC)*

- **Paths:** `kernel/commands/paul/*.md` — 12 files, **1,339 lines**. Largest: `help.md` 501, `review.md` 248, `config.md` 126.
- **Why hot:** They are **not** on the Pi hot path. They are only loaded if the user is on the Claude harness. Phase 188 explicitly decided to treat them as legacy/reference thin pointers and not invest in Claude-specific polish.
- **Cost:** Zero on the Pi hot path. Real cost is maintenance + git noise + cross-harness validation surface (90 cross-harness checks).
- **Preserve:**
  - Cross-harness validation (90/90) must keep passing.
  - Claude harness must remain functional for users on Claude Code.
  - Strategic decision in Phase 188: do not expand Claude-specific support surface.
- **Reduction pattern:**
  - Confirm at the product level whether Claude Code is supported, deprecated-with-care, or fully legacy. **This is a product decision, not a context-diet decision.**
  - If "supported": keep wrappers, slim the largest (`help.md` 501 lines is far heavier than its Pi sibling — it can drop to a thin pointer at low risk).
  - If "deprecated-with-care": keep them frozen and skip future slimming work.
  - If "fully legacy": move wrappers to `drivers/claude/` (currently they live under `kernel/commands/paul/`, conflating kernel and driver) and stop counting them in kernel hot-path budgets.
- **Maps to:** Future product decision; not Phase 190.

### F6 — Resume reads 113 archived handoffs as fallback  *(LOW-PRIORITY HOUSEKEEPING)*

- **Paths:** `.paul/handoffs/archive/HANDOFF*.md` (113 files / 12,092 lines).
- **Why hot:** Resume workflow falls back to `.paul/handoffs/archive/` if no active handoff exists. The directory listing read is cheap (just sorted ls), but the *count* keeps growing — 113 files indicates handoffs are accumulating without compaction.
- **Cost:** Currently negligible (only one file is read on fallback, not all 113). Risk is operational: discoverability of *which* archived handoff is relevant.
- **Preserve:**
  - Handoff archive authority (Phase 185 archive-link convention).
  - Don't delete history.
- **Reduction pattern:** Optionally roll up older handoffs into a `HANDOFF-INDEX.md` summary file per quarter or per milestone, similar to STATE archive. Not urgent. Could pair with Phase 190 ROADMAP archive work or be deferred.
- **Maps to:** Phase 190 stretch or future maintenance.

### F7 — Hot kernel-reference set carries some warm-only content  *(SMALL WIN)*

- **Paths:** `kernel/references/checkpoints.md` (211 lines, only relevant when a plan has checkpoints) and `kernel/references/subagent-criteria.md` (185 lines, only relevant when APPLY considers delegation).
- **Why hot:** They appear in the `<references>` block of `apply-phase.md` and are loaded transitively even when the current plan has no checkpoints and no delegation candidate.
- **Cost:** ~400 lines of references read on every APPLY turn even when irrelevant.
- **Preserve:**
  - Checkpoint contract integrity (no hidden reduction of what a checkpoint means).
  - Phase 155 delegation contract (subagent-criteria) integrity.
- **Reduction pattern:** Mark these as *conditionally* loaded references in `apply-phase.md` — load only when `<tasks>` contains a `checkpoint:*` or when `agents.implementer.enabled = true` and a candidate auto task exists. Encode the trigger inline so the workflow remains self-describing.
- **Maps to:** Phase 190 (small) or Phase 191 (validation that conditional references stay correct).

### F8 — `apply-phase.md` and `unify-phase.md` carry verbatim post-apply / post-unify hook prose that already lives in `module-dispatch.md`  *(SMALL WIN)*

- **Paths:** `kernel/workflows/apply-phase.md` (steps `pre_apply_hooks`, `advisory_module_dispatch`, `enforcement_module_dispatch`), `kernel/workflows/unify-phase.md` (`pre_unify_hooks`, `post_unify_hooks`), and `kernel/references/module-dispatch.md`.
- **Why hot:** Phase 186 centralized dispatch mechanics in `module-dispatch.md`, but the call-site contracts in `apply-phase.md` and `unify-phase.md` still re-spell the priority lists, the evidence-line patterns, and the SKIPPED-warning language. This is required redundancy *only* for the call-site obligations; the priority lists themselves can reference the registry.
- **Cost:** ~30–60 lines per workflow that could become reference pointers.
- **Preserve:**
  - Call-site evidence requirement (`[dispatch] …`) must remain inline so workflows fail loudly if dispatch is skipped.
  - Phase 187 line-ceiling guardrail must hold.
- **Reduction pattern:** Keep the `[dispatch] …` evidence requirement and the SKIPPED warning inline. Move the priority lists and verbose hook taxonomy fully into `references/module-dispatch.md`, leaving only the call-site obligation in the workflow. Net: ~60–80 lines saved across hot workflows without weakening dispatch.
- **Maps to:** Phase 190.

---

## Recommendations

### Phase 190 — Artifact Structure Simplification (primary)

In priority order:

1. **R1 — Apply STATE archive pattern to ROADMAP** *(addresses F1, F3)*
   - Move completed-milestone history to `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md`.
   - Keep active window (Overview + Milestones index + Current Milestone + next-planned milestone) inline.
   - Add inline pointer link, mirroring `STATE-HISTORY-v0-v2.43.md` precedent.
   - Acceptance: `.paul/ROADMAP.md` ≤ 100 lines; archive file holds historical milestones; both are findable and editable.

2. **R2 — Centralize GitHub Flow stanzas** *(addresses F2)*
   - Replace the duplicated 4-tier `GIT_WORKFLOW` resolution + `git fetch`/`rebase`/`gh pr` blocks across `apply-phase.md`, `unify-phase.md`, `transition-phase.md`, `complete-milestone.md`, `roadmap-management.md`, `pause-work.md` with a short call-site contract (resolved inputs + decisions + block conditions) plus a reference to `kernel/references/git-strategy.md` for the bash recipe.
   - Mirror Phase 186's "module-dispatch" pattern: shared mechanics in references, call-site obligations inline.
   - Acceptance: each hot workflow loses ~60–80 lines; merge-gate behavior unchanged; `git-strategy.md` carries the recipe.

3. **R3 — Hoist module-dispatch priority/taxonomy verbiage out of workflows** *(addresses F8)*
   - Move priority lists and verbose hook taxonomy from `apply-phase.md` / `unify-phase.md` into `kernel/references/module-dispatch.md`.
   - Keep `[dispatch] …` evidence and SKIPPED warning inline.
   - Acceptance: hot workflow line counts drop while Phase 187 dispatch-evidence guardrails still pass.

4. **R4 — Conditional references in `apply-phase.md`** *(addresses F7)*
   - Mark `references/checkpoints.md` as load-only-if-plan-has-checkpoints.
   - Mark `references/subagent-criteria.md` as load-only-if-delegation-considered.
   - Encode the trigger inline so behavior stays self-describing.

5. **R5 — Stretch: split `pals-hooks.ts`** *(addresses F4)*
   - Optional. Only if Phase 190 has slack. Otherwise defer to a dedicated Pi driver milestone.

### Phase 191 — Validation + Anti-Regrowth Update

1. **R6 — Update guardrails to lock the new hot-path budgets**
   - Re-baseline the Phase 187 wrapper line ceiling against post-190 totals (estimated active `.paul/*` ≤ 400 lines, hot core workflows ≤ 1,400 lines combined).
   - Add an anti-regrowth check that fails CI if `.paul/ROADMAP.md` exceeds N lines without a corresponding archive update.
   - Add a check that `kernel/references/git-strategy.md` is referenced (not duplicated) by the workflows that previously inlined it.
   - Add a dispatch-evidence regression check (already exists post-Phase 187; confirm coverage).

2. **R7 — Validate cross-harness 90/90 still green**
   - No expansion of Claude-specific surface. Confirm by snapshotting `kernel/commands/paul/*.md` line totals as part of validation; flag any growth without explicit approval.

### Future / out-of-scope for v2.44

1. **R8 — Product decision on Claude Code support tier** *(addresses F5)*
   - Decide: supported / deprecated-with-care / fully legacy.
   - The decision determines whether `kernel/commands/paul/*.md` continues to grow, freezes, or moves to `drivers/claude/`.
   - Until decided, do not invest in Claude-specific polish (Phase 188 boundary).

2. **R9 — Optional handoff-archive index** *(addresses F6)*
   - Roll up `.paul/handoffs/archive/*` into a quarterly or per-milestone `HANDOFF-INDEX.md` summary. Low priority.

3. **R10 — Pi adapter modularization** *(addresses F4)*
   - Dedicated driver-quality milestone if not absorbed by Phase 190 stretch.

---

## Do Not Do

These reductions look tempting but would violate v2.44 boundaries or PALS authority. Listed so future work explicitly rejects them.

- **Do not delete `.paul/archive/*` history** to "save space". Archive files are authoritative historical truth (Phase 185 decision). They are cold by design — they cost nothing on the hot path.
- **Do not replace `.paul/STATE.md` or `.paul/ROADMAP.md` with hidden runtime state, telemetry, or a database.** Artifact-first truth is non-negotiable. v2.44 reduces inline volume by archive-linking, not by hiding state.
- **Do not weaken module evidence.** The `[dispatch] …` lines and the SKIPPED-warning prose stay inline at every call-site. Phase 186/187 settled this.
- **Do not skip GitHub Flow gates** as a side effect of centralizing the bash recipe. Each call-site keeps the obligation to run the gate; only the recipe text moves.
- **Do not collapse `kernel/references/module-dispatch.md`** back into workflows. Phase 186 centralized it deliberately.
- **Do not expand Claude-specific support surface.** Phase 188 boundary. Slim or freeze; don't grow.
- **Do not change runtime behavior, workflow semantics, module dispatch contracts, GitHub Flow gates, or Pi context injection logic** as part of an artifact-simplification phase. Behavior changes need their own plan.
- **Do not reopen the settled Phase 69/70 contract** without new evidence (parent-owned APPLY, lifecycle authority).
- **Do not delete `kernel/commands/paul/*.md` wrappers** until a product-level decision on Claude Code support is made. Until then they are legacy/reference per Phase 188 — frozen, not removed.

---

## Validation evidence

Run as part of Plan 189-01 APPLY.

- `bash tests/pi-end-to-end-validation.sh` → **177/177 passed** (pre-apply baseline).
- `bash tests/cross-harness-validation.sh` → **90/90 passed** (pre-apply baseline).
- Audit is documentation-only; no source files changed; no new lint/typecheck regression possible.
- Post-task and post-apply re-runs documented in Plan 189-01 SUMMARY.

---

## Module Notes (for UNIFY)

- ARCH: no architecture boundary risk; output is a `.paul/phases/*` audit doc.
- TODD: no test-conversion candidates for documentation-only audit; existing shell validation suites are the official verification path.
- WALT: pre-apply baseline 177/177 + 90/90; post-apply re-runs must match.
- IRIS / RUBY / SKIP / DOCS: advisory annotations apply at UNIFY time.
- DEAN: no dependency manifest changes.
- CODI: no extractable symbols in audit scope (documentation phase).
- SETH: no secret/auth surface.

---

## Header markers (for verification)

- Hot-Path Inventory ✓
- Ranked Findings ✓
- Recommendations ✓
- Do Not Do ✓
