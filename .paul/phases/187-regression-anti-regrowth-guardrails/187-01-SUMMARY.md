---
phase: 187-regression-anti-regrowth-guardrails
plan: 01
subsystem: validation
tags: [context-diet, regression-guardrails, validation, cross-harness, module-dispatch]
requires:
  - phase: 186-workflow-module-prose-compression
    provides: Phase 186 hot workflow baseline and shared module-dispatch contract
provides:
  - Hot workflow line-envelope guardrail using the 1711 Phase 186 pre-compression ceiling
  - Semantic marker guardrails for PLAN/APPLY/UNIFY and module-dispatch evidence
  - Cross-harness context-diet parity checks for Claude Code and Pi installs
affects:
  - v2.43 PALS Context Diet
  - future workflow prose edits
tech-stack:
  added: []
  patterns:
    - Semantic marker regression checks over brittle exact-prose checks
    - Practical line-envelope ceiling for hot-path workflow regrowth
key-files:
  created:
    - .paul/phases/187-regression-anti-regrowth-guardrails/187-01-PLAN.md
  modified:
    - tests/pi-end-to-end-validation.sh
    - tests/cross-harness-validation.sh
    - .paul/STATE.md
    - .paul/ROADMAP.md
key-decisions:
  - "Use 1711 as the hot workflow ceiling rather than exact current 1632."
  - "Guard semantic lifecycle markers instead of exact prose."
patterns-established:
  - "Context-diet validation should catch real regrowth and evidence loss while tolerating harmless wording movement."
duration: one APPLY/UNIFY session
started: 2026-04-26T21:43:48Z
completed: 2026-04-26T21:55:36Z
---

# Phase 187 Plan 187-01: Regression + Anti-Regrowth Guardrails Summary

Lightweight validation guardrails now protect v2.43 context-diet gains by checking hot workflow line envelopes and durable lifecycle/module/merge-gate markers across Pi, Claude Code, and repo source surfaces.

## Performance

| Metric | Value |
|--------|-------|
| Duration | one APPLY/UNIFY session |
| Started | 2026-04-26T21:43:48Z |
| Completed | 2026-04-26T21:55:36Z |
| Tasks | 3 completed |
| Files modified | 2 implementation files plus PALS lifecycle artifacts |

## Objective

Add lightweight regression checks to existing validation scripts so hot PALS artifacts do not silently regrow past the Phase 186 pre-compression baseline or lose key semantic evidence markers for PLAN/APPLY/UNIFY, module dispatch, GitHub Flow, and artifact authority.

## What Was Built

| File | Purpose | Result |
|------|---------|--------|
| `tests/pi-end-to-end-validation.sh` | Pi-installed validation guardrails | Added `tap_hot_workflow_line_ceiling` and a `CONTEXT-DIET REGRESSION GUARDRAILS` section checking installed hot workflow total ≤ 1711 plus PLAN/APPLY/UNIFY/module-dispatch semantic markers. |
| `tests/cross-harness-validation.sh` | Cross-harness validation guardrails | Added matching line-envelope and marker checks for Claude Code installed kernel, Pi installed kernel, and repo source kernel. |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|-----------|--------|----------|
| AC-1: Hot Workflow Anti-Regrowth Guard | PASS | Pi validation now checks installed `plan-phase.md + apply-phase.md + unify-phase.md` total against ceiling `1711`; final Pi run passed. |
| AC-2: Semantic Marker Regression Guard | PASS | Pi and cross-harness validation now check markers for targeted planning reads, parent-owned APPLY, checkpoint/delegation safety, post-unify evidence, GitHub Flow merge gates, and shared module-dispatch evidence. |
| AC-3: Cross-Harness Guardrail Parity | PASS | Cross-harness validation checks Claude Code installed, Pi installed, and repo source workflow/module-dispatch surfaces. |
| AC-4: Existing Validation Remains Green | PASS | `bash tests/pi-end-to-end-validation.sh` passed 177/177; `bash tests/cross-harness-validation.sh` passed 90/90. |

## Task Results

| Task | Status | Evidence |
|------|--------|----------|
| Task 1: Add Pi validation anti-regrowth checks | PASS | Pi validation guardrail section reports checks 95-99 passing. |
| Task 2: Add cross-harness context-diet parity checks | PASS | Cross-harness guardrail section reports checks 31-45 passing. |
| Task 3: Run full validation and record results for UNIFY | PASS | Final validation runs passed: 177/177 and 90/90. |

## Verification Results

| Command | Result |
|---------|--------|
| `bash tests/pi-end-to-end-validation.sh` | PASS — 177 passed, 0 failed |
| `bash tests/cross-harness-validation.sh` | PASS — 90 passed, 0 failed |
| `wc -l kernel/workflows/plan-phase.md kernel/workflows/apply-phase.md kernel/workflows/unify-phase.md` | PASS — source hot workflow total remains 1632, below 1711 ceiling |

## Module Execution Reports

### PLAN/APPLY carry-forward

- `[dispatch] pre-plan advisory`: ARCH identified the tests layer and large validation scripts; SETH found no security concerns; TODD recommended standard `execute` plan; IRIS found no anti-pattern markers; DAVE noted no CI config; DOCS found related validation docs; CODI skipped because no TS/JS symbols were extractable; RUBY flagged file-size debt risk and encouraged localized additions.
- `[dispatch] pre-plan enforcement`: DEAN passed/skipped because no dependency manifest or lock file exists.
- `[dispatch] post-plan`: TODD left plan type as `execute`.
- `[dispatch] pre-apply`: Existing shell validation baseline was 172/172 Pi and 75/75 cross-harness before implementation.
- `[dispatch] post-task`: TODD/WALT-style checks remained green after implementation; final validation rose to 177/177 Pi and 90/90 cross-harness because new guardrail checks were added and passed.
- `[dispatch] post-apply advisory`: DOCS advisory only; validation-script docs proximity exists and no user-facing docs update was required. IRIS/RUBY concerns were limited to keeping additions localized in already-large shell files.
- `[dispatch] post-apply enforcement`: WALT and TODD validation passed; DEAN skipped gracefully because no dependency manifests changed.

### Post-unify reports

- `[dispatch] pre-unify: 0 modules registered for this hook`.
- `[dispatch] WALT post-unify: appended improving row for 187-01 to .paul/QUALITY-HISTORY.md`.
- `[dispatch] SKIP post-unify: captured one validation-guardrail pattern for context-diet work`.
- `[dispatch] CODI post-unify: hook body entered for 187-01`.
- `[dispatch] CODI post-unify: appended skipped-no-symbols row for 187-01`.
- `[dispatch] RUBY post-unify: shell validation files remain large, but changes were localized helpers/check sections; no new refactor candidate required in this phase`.

## Quality

| Metric | Before | After | Delta | Trajectory |
|--------|--------|-------|-------|------------|
| Pi validation | 172 passed, 0 failed | 177 passed, 0 failed | +5 passing checks | ↑ improving |
| Cross-harness validation | 75 passed, 0 failed | 90 passed, 0 failed | +15 passing checks | ↑ improving |
| Hot workflow total | 1632 lines | 1632 lines | 0 | stable |
| Lint | — | — | — | not tracked |
| Types | — | — | — | not tracked |

**Overall:** improving. Validation coverage gained 20 context-diet guardrail checks without changing hot workflows or adding dependencies.

## Accomplishments

- Added a reusable shell TAP helper for hot workflow line-envelope checks.
- Added Pi-installed validation checks for hot workflow ceiling and semantic lifecycle/module-dispatch markers.
- Added cross-harness parity checks covering Claude Code installed, Pi installed, and repo source surfaces.
- Preserved the Phase 186 hot workflow total while protecting against future regrowth above 1711.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Tasks 1-3 | `47234075` | feat | Added context-diet validation guardrails and created Plan 187-01. |
| APPLY state/PR update | `0d5fad13` | chore | Recorded PR #99 state in `.paul/STATE.md`. |

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `.paul/phases/187-regression-anti-regrowth-guardrails/187-01-PLAN.md` | Created | Executable plan for Phase 187. |
| `.paul/phases/187-regression-anti-regrowth-guardrails/187-01-SUMMARY.md` | Created | This reconciliation summary. |
| `tests/pi-end-to-end-validation.sh` | Modified | Adds installed Pi context-diet guardrails. |
| `tests/cross-harness-validation.sh` | Modified | Adds cross-harness and repo-source context-diet guardrails. |
| `.paul/STATE.md` | Modified | Lifecycle state, APPLY/UNIFY routing, PR state. |
| `.paul/ROADMAP.md` | Modified | Phase 187 planning/completion lifecycle updates. |
| `.paul/handoffs/archive/HANDOFF-2026-04-26-phase-187-ready.md` | Moved | Consumed active handoff archived after resume. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Use `1711` as the hot-workflow ceiling | Phase 186 proved a reduction from 1711 to 1632; the guardrail should catch real regrowth without pinning exact current counts. | Future edits may make small harmless movements but cannot erase compression gains unnoticed. |
| Guard semantic markers rather than exact prose | Exact prose checks would make validation brittle and discourage useful wording cleanup. | Validation protects lifecycle behavior and evidence obligations while allowing refactors. |
| Keep implementation in existing validation scripts | The project already uses shell validation suites as regression harnesses. | No new dependencies, package manifests, or CI generation required. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None |
| Scope additions | 0 | None |
| Deferred | 0 | None |

**Total impact:** No implementation deviations. Lifecycle bookkeeping also archived the consumed handoff and updated PR state as required by PALS flow.

### Deferred Items

None from this plan. CI workflow generation remains a broader deferred DAVE topic and was intentionally not added here.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| GitHub checks were pending after PR creation | Recorded pending CI state; merge gate will enforce before phase completion. |

## Knowledge Captured

### 2026-04-26 Context-diet guardrails should validate shape and semantics, not exact prose

**Type:** validation pattern  
**Phase:** 187 — Regression + Anti-Regrowth Guardrails  
**Related:** `tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh`, `kernel/workflows/*`, `kernel/references/module-dispatch.md`

The context-diet work needs protection against future hot-path regrowth and evidence loss, but exact current line counts or full prose snapshots would make maintenance brittle. A practical line-envelope ceiling plus semantic marker checks gives a better signal.

**Key factors:**
- Phase 186 reduced hot workflows from 1711 to 1632 lines.
- Some future prose movement below 1711 is acceptable.
- PLAN/APPLY/UNIFY safety depends on durable markers: targeted planning reads, parent-owned APPLY, checkpoint/delegation boundaries, post-unify evidence, and merge-gate commands.

**Impact:** Future validation should prefer semantic obligations and practical envelopes when guarding markdown workflow artifacts.

## Next Phase Readiness

**Ready:**
- Phase 187 implementation and local validation are complete.
- PR #99 is open and carries the validation guardrail changes.

**Concerns:**
- GitHub Socket Security check was pending during initial UNIFY; merge gate must wait for passing CI before merge/transition.

**Blockers:**
- Phase completion cannot proceed until PR #99 CI passes and the GitHub Flow merge gate completes.

---
*Phase: 187-regression-anti-regrowth-guardrails, Plan: 01*
*Completed: 2026-04-26*
