---
phase: 163-roadmap-workflow-prose-cleanup-validation
plan: 01
completed: 2026-03-28T02:59:04Z
duration: ~1 session
---

## Objective
Trim the remaining high-frequency roadmap/planning workflow prose so the warm-path shared workflows stay authoritative but carry less duplicated explanation, then lock the preserved contract into validation.

## What Was Built

| File | Purpose | Lines |
|------|---------|------:|
| `kernel/workflows/roadmap-management.md` | Compressed status-routing prose while preserving current-milestone slicing, git-aware routing, and exact-one next-action behavior | 434 |
| `kernel/workflows/plan-phase.md` | Tightened planning workflow narration around target-phase-detail reads, collaboration posture, and review-menu behavior | 344 |
| `kernel/workflows/discuss-phase.md` | Removed repeated explanation while preserving selected-phase-detail discussion context and planning-mode prompts | 259 |
| `kernel/workflows/create-milestone.md` | Slimmed milestone-creation prose while keeping insertion-slice reads, review flow, and one-question-at-a-time prompting | 272 |
| `tests/pi-end-to-end-validation.sh` | Added durable semantic checks for the installed shared-workflow prose contract | 928 |

Total repo-source output updated for this phase: **2237 lines** across **5 modified source files**.

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Warm-path workflow prose is thinner without losing route semantics | PASS | All four shared workflow files are smaller than their pre-phase sizes while preserving the required routing, planning, and milestone markers |
| AC-2 | Preservation targets remain explicit after cleanup | PASS | The edited workflows still carry slice-based roadmap reads, `PROJECT.md`-first / `PRD.md`-selective planning, exact-one routing, guided-marker-safe behavior, and one-question-at-a-time milestone prompting |
| AC-3 | The slimmer shared-workflow contract is deployed and regression-proofed | PASS | `PALS_DRIVER=pi bash install.sh`, `bash tests/pi-end-to-end-validation.sh`, and `bash tests/cross-harness-validation.sh` all passed after redeploying the repo-source updates |

## Reconciliation: Plan vs Actual

### Task 1 — Trim roadmap-management and plan-phase to one strong statement per behavior
**Planned:** remove duplicated warm-path prose from the core status/planning workflows without changing route semantics.

**Actual:** completed as planned.
Key outcomes included:
- `roadmap-management.md` now uses tighter status-routing language while keeping the current-milestone read model, git-aware override table, and exact-one next-action rules
- `plan-phase.md` now keeps the same collaboration, exploratory/direct-requirements, and review-menu behavior with less repeated explanation around those rules
- existing guided markers, git-routing precedence, and plan-review/state-update semantics remained intact

### Task 2 — Apply the same prose cleanup discipline to discuss-phase and create-milestone
**Planned:** tighten the discussion and milestone workflows without weakening planning posture or milestone semantics.

**Actual:** completed as planned.
Key outcomes included:
- `discuss-phase.md` still validates against the current milestone section and selected phase detail, but no longer repeats the same setup rationale nearby
- `create-milestone.md` still carries planning posture, review flow, and one-question-at-a-time prompts with reduced surrounding narration
- the phase stayed bounded to the warm planning cluster and did not reopen broader `ROADMAP.md` redesign

### Task 3 — Add durable validation for the slimmer shared-workflow contract and run regression suites
**Planned:** extend Pi validation so the installed shared workflows are checked semantically, then redeploy and run the existing suites.

**Actual:** completed as planned.
Key outcomes included:
- `tests/pi-end-to-end-validation.sh` now checks the installed shared workflow copies for preserved marker presence and removed filler absence
- the validation contract stayed semantic rather than brittle line-count based
- repo-source changes were redeployed through the installer, then validated in both Pi and cross-harness suites

## Verification Results

### Ground-truth reconciliation
- `git --no-pager diff --name-only main...HEAD` matched the expected five repo-source files in `files_modified`, plus normal lifecycle artifacts for the phase (`STATE.md`, `ROADMAP.md`, handoff archive, `163-01-PLAN.md`) before UNIFY artifacts were added
- `git --no-pager diff --numstat main...HEAD -- kernel/workflows/roadmap-management.md kernel/workflows/plan-phase.md kernel/workflows/discuss-phase.md kernel/workflows/create-milestone.md tests/pi-end-to-end-validation.sh .paul/STATE.md` confirmed the planned repo-source edits landed in the correct files
- No installed runtime copies under `~/.pi/agent/...` were edited directly; all changes stayed in repo source and were deployed through `install.sh`

### File and contract checks
- `grep -q 'current milestone section' kernel/workflows/roadmap-management.md && grep -q 'exactly ONE' kernel/workflows/roadmap-management.md && grep -q 'target phase detail' kernel/workflows/plan-phase.md && grep -q 'planning.default_collaboration' kernel/workflows/plan-phase.md && grep -q 'Would you like to see the plan?' kernel/workflows/plan-phase.md && test "$(wc -l < kernel/workflows/roadmap-management.md)" -lt 452 && test "$(wc -l < kernel/workflows/plan-phase.md)" -lt 376` ✅
- `grep -q 'selected phase detail' kernel/workflows/discuss-phase.md && grep -q 'direct-requirements' kernel/workflows/discuss-phase.md && grep -q 'one question at a time' kernel/workflows/create-milestone.md && grep -q 'Would you like to see the plan before I update ROADMAP.md?' kernel/workflows/create-milestone.md && test "$(wc -l < kernel/workflows/discuss-phase.md)" -lt 286 && test "$(wc -l < kernel/workflows/create-milestone.md)" -lt 279` ✅
- `PALS_DRIVER=pi bash install.sh && bash tests/pi-end-to-end-validation.sh && bash tests/cross-harness-validation.sh` → **Pi install successful, 149/149 Pi checks passed, 60/60 cross-harness checks passed** ✅
- Phase plan count vs summary count after summary creation: **1 / 1** ✅

### Skill audit
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for Phase 163 |
| /carl | ✓ | Session-boundary routing remained active while the phase moved across planning, apply, and unify boundaries |
| TODD | ✓ | APPLY/UNIFY validation path preserved regression handling even though the work was workflow markdown plus shell validation |
| WALT | ✓ | Validation suites were run during APPLY and quality-history reporting was updated during UNIFY |

## Module Execution Reports

[dispatch] pre-unify: 0 modules registered for this hook

### Carried forward from APPLY
- `[dispatch] pre-apply: TODD(50) → SKIPPED | WALT(100) → baseline recorded`
- `[dispatch] post-apply advisory: SKIPPED — workflow markdown + validation-shell changes only`
- `[dispatch] post-apply enforcement: WALT(100) → PASS | DEAN(150) → SKIPPED (no supported package manager or audit target detected) | TODD(200) → PASS`

### Post-unify
- WALT (p100): PASS — quality delta **improved**. Added `163-01` to `.paul/QUALITY-HISTORY.md` with tests moving from **143 pass + 60 pass** to **149 pass + 60 pass**, coverage/lint/types unchanged (`—`), trend `↑ improving`
- SKIP (p200): PASS — captured durable knowledge from this phase:
  - **Decision Record:**
    - **Title:** Prefer semantic shared-workflow contract checks over brittle line-count assertions
    - **Type:** decision
    - **Phase:** 163 — ROADMAP/Workflow Prose Cleanup + Validation
    - **Related:** `tests/pi-end-to-end-validation.sh`, `kernel/workflows/roadmap-management.md`, PR #72
    - **Context:** This phase intentionally reduced prose density, so exact line-count assertions would have frozen wording instead of protecting behavior.
    - **Decision:** Validate the installed shared workflow contract by checking critical marker presence and selected removed filler absence rather than pinning exact line totals.
    - **Alternatives considered:**
      - Keep line-count assertions — rejected because harmless wording changes would create noisy failures and discourage safe cleanup.
      - Skip new validation entirely — rejected because the slimmer contract still needs durable regression proof from the installed Pi surface.
    - **Rationale:** Semantic contract checks preserve behavioral guardrails while allowing bounded wording improvements.
    - **Impact:** Future workflow cleanup can stay evidence-backed without calcifying prose.
  - **Decision Record:**
    - **Title:** Finish the workflow-first context reduction pass with prose cleanup before structural artifact redesign
    - **Type:** decision
    - **Phase:** 163 — ROADMAP/Workflow Prose Cleanup + Validation
    - **Related:** `kernel/workflows/plan-phase.md`, `kernel/workflows/discuss-phase.md`, `.paul/phases/160-findings-recommendation-package/context-reduction-recommendations-ranked.md`
    - **Context:** Phases 161 and 162 had already shown that wrapper slimming and read-discipline changes could reduce pressure without touching artifact authority.
    - **Decision:** Close v2.36 with bounded prose cleanup in the warm-path workflow cluster instead of reopening `ROADMAP.md` or `STATE.md` structural redesign during this pass.
    - **Alternatives considered:**
      - Redesign `ROADMAP.md` now — rejected because it is broader risk with weaker evidence than the remaining prose cleanup.
      - Compress module-dispatch protocol in the same phase — rejected because it is a separate higher-risk candidate.
    - **Rationale:** The safest remaining high-value win was still workflow-side amplification reduction, not hotter artifact redesign.
    - **Impact:** Any future structural artifact change should require fresh evidence after this full workflow-first pass.
  - **Lesson Learned:**
    - **Title:** Semantic validation is the durable companion to prose reduction
    - **Type:** lesson
    - **Phase:** 163 — ROADMAP/Workflow Prose Cleanup + Validation
    - **Related:** `tests/pi-end-to-end-validation.sh`, PR #72
    - **What happened:** The phase succeeded by tightening wording while adding installed-surface checks that verify preserved behavior instead of exact wording.
    - **What we learned:** Workflow prose can be reduced safely when regression proof is anchored to route semantics rather than formatting or line totals.
    - **How to apply:** Keep future workflow cleanups tied to marker-level behavioral assertions and avoid brittle size-only gates.
- RUBY (p300): WARN — the workflow files are slimmer at **434 / 344 / 259 / 272** lines, but `tests/pi-end-to-end-validation.sh` grew to **928** lines and remains the largest local debt hotspot after this phase. Keep future cleanup focused on validation-surface structure and remaining roadmap/planning prose density rather than broad artifact redesign.

## Deviations
None.

## Key Patterns / Decisions
- Shared-workflow cleanup is safest when each route keeps one strong statement per behavior instead of repeated nearby rationale
- Semantic installed-surface validation is a better durability mechanism for workflow cleanup than exact line-count assertions
- The workflow-first reduction sequence now has a complete first pass: wrappers, read discipline, then prose cleanup + validation
- Structural `ROADMAP.md` or `STATE.md` redesign should remain evidence-gated follow-on work, not an automatic next move

## Merge Gate Status
- PR `#72` merged successfully: https://github.com/coctostan/pals/pull/72
- Reviews were not required by `pals.json`
- CI passed before merge and the branch was resolved back to `main`

## Next Phase
After merge and transition, **v2.36 Context Reduction Implementation - Workflow-First Pass** is complete and the project is ready for the next milestone decision.
