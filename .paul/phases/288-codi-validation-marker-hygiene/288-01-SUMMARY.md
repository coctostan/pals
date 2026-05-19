---
phase: 288-codi-validation-marker-hygiene
plan: 01
subsystem: testing
tags: [pi-validation, codi, semantic-helpers, validation-hygiene]
requires:
  - phase: 278-module-instruction-audit-closure
    provides: semantic CODI helper pattern in tests/helpers/module_instruction_semantics.sh
provides:
  - Pi e2e CODI validation checks backed by semantic helper assertions
  - RED/GREEN evidence that inherited CODI marker drift is cleared while PROJECT budget drift remains deferred
affects:
  - Phase 289 Hot Artifact Budget Hygiene
  - Phase 290 Validation Closure
tech-stack:
  added: []
  patterns: [semantic validation helper reuse]
key-files:
  created: []
  modified:
    - tests/pi-end-to-end-validation.sh
key-decisions:
  - "Decision: Validate CODI behavior groups semantically instead of stale literal marker phrases."
patterns-established:
  - "Pattern: Pi e2e CODI installed-resource checks should reuse tests/helpers/module_instruction_semantics.sh where possible."
duration: ~1h
started: 2026-05-19T00:00:00Z
completed: 2026-05-19T00:00:00Z
---

# Phase 288 Plan 01: CODI Validation Marker Hygiene Summary

Pi end-to-end CODI validation now checks current CODI behavior contracts through shared semantic helpers instead of inherited stale literal-marker prose.

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~1h |
| Started | 2026-05-19 |
| Completed | 2026-05-19 |
| Tasks | 3 completed |
| Files modified | 1 implementation file plus lifecycle artifacts |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Pi CODI validations use semantic helpers | PASS | `tests/pi-end-to-end-validation.sh` sources `tests/helpers/module_instruction_semantics.sh` and uses CODI semantic helper assertions for installed CODI resources. |
| AC-2: CODI drift failures are cleared without product/runtime changes | PASS | Pi e2e validation improved from inherited CODI failures to `334/335`; CODI checks 15, 205, 208, 210, and 212 pass. Remaining failure is PROJECT byte-budget drift reserved for Phase 289. |
| AC-3: Cross-harness parity is preserved | PASS | Cross-harness validation passed `246/246`; no helper or installed CODI behavior changes were required. |

## Module Execution Reports

### APPLY Dispatch Evidence

| Module / Hook | Result |
|---------------|--------|
| TODD pre-apply | Skipped enforcement: plan type is `execute`; RED baseline already captured in PLAN for existing validation failures. |
| WALT pre/post-apply | PASS with baseline comparison: Pi e2e improved from `329/335` with 5 CODI failures + 1 PROJECT failure to `334/335` with only the PROJECT failure; cross-harness stayed green at `246/246`. |
| Post-task hooks | PASS: task verification used `bash -n tests/pi-end-to-end-validation.sh`, full Pi e2e validation, and cross-harness validation. |
| Advisory post-apply cohort | No source/API/UI/data/runtime behavior changes; documentation/code-review style hooks not applicable or no concerns for shell validation-only scope. |
| Enforcement post-apply cohort | PASS: no new strict-mode quality regression; no dependency manifest changes. |

### UNIFY Dispatch Evidence

| Module / Hook | Result |
|---------------|--------|
| pre-unify | `[dispatch] pre-unify: 0 modules registered for this hook` |
| CODI post-unify | skipped-no-symbols; appended `288-01` row to `.paul/CODI-HISTORY.md`. |
| WALT post-unify | appended `288-01` row to `.paul/QUALITY-HISTORY.md` with improving validation trajectory. |
| SKIP post-unify | no durable knowledge entry beyond this SUMMARY; decision is phase-local validation hygiene captured here. |
| RUBY post-unify | NOT_APPLICABLE: validation-shell change, no code-debt concern. |
| Plannotator UNIFY code review | unavailable: `plannotator` CLI not found (`command not found`); advisory only, no lifecycle or merge-gate override. |

## Accomplishments

- Added the shared semantic helper source to Pi e2e validation for CODI installed-resource checks.
- Replaced inherited brittle literal CODI marker checks with semantic helper assertions and `MIS_LAST_MISSING` diagnostics.
- Preserved cross-harness parity and intentionally left the PROJECT byte-budget failure untouched for Phase 289.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Source semantic helper in Pi e2e validation | `442121d2` | test | Added `module_instruction_semantics.sh` sourcing and Phase 288 explanatory comment. |
| Task 2: Replace stale CODI literal-marker checks with helper assertions | `442121d2` | test | Converted CODI checks 15, 205, 208, 210, and 212 to semantic helper/grouped checks. |
| Task 3: Run parity validation and record scoped outcome | `442121d2` | test | Verified Pi e2e CODI checks and cross-harness validation; PROJECT budget drift remains deferred. |

Plan metadata: pending UNIFY commit.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `tests/pi-end-to-end-validation.sh` | Modified | Source semantic helper assertions and replace stale CODI literal-marker checks. |
| `.paul/phases/288-codi-validation-marker-hygiene/288-01-SUMMARY.md` | Created | Record plan reconciliation and validation evidence. |
| `.paul/STATE.md` | Modified | Route from Phase 288 UNIFY to Phase 289 planning after phase transition. |
| `.paul/ROADMAP.md` | Modified | Mark Phase 288 complete and Phase 289 as the next phase. |
| `.paul/PROJECT.md` / `.paul/MILESTONES.md` | Modified | Keep compact milestone/current-phase pointers aligned. |
| `.paul/CODI-HISTORY.md` / `.paul/QUALITY-HISTORY.md` | Modified | Append post-unify durable module evidence. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Use semantic helper assertions for CODI installed-resource validation | Current CODI behavior contracts are better represented by grouped semantic checks than by stale Phase 174/176 literal phrases. | Future CODI validation should prefer reusable semantic helpers over brittle prose markers. |
| Defer PROJECT byte-budget failure | Phase 288 scope explicitly excluded PROJECT/ROADMAP budget hygiene. | Phase 289 remains focused and measurable: resolve hot-artifact byte-budget drift. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None |
| Scope additions | 0 | None |
| Deferred | 1 | PROJECT byte-budget failure remains Phase 289 scope as planned. |

**Total impact:** Plan executed as scoped; no product/runtime behavior changes.

### Auto-fixed Issues

None.

### Deferred Items

- Phase 289: `.paul/PROJECT.md` byte-budget drift remains the only Pi e2e validation failure after Phase 288.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Pi e2e still exits non-zero because of PROJECT byte-budget drift | Classified as expected/out-of-scope; Phase 289 owns hot-artifact budget hygiene. |

## Next Phase Readiness

**Ready:**
- Phase 288 CODI marker drift is cleared in Pi e2e validation.
- Cross-harness validation remains green.
- Phase 289 can focus exclusively on hot-artifact budget hygiene.

**Concerns:**
- PROJECT byte-budget drift still fails Pi e2e until Phase 289 resolves it.

**Blockers:**
- None for Phase 289 planning.

---
*Phase: 288-codi-validation-marker-hygiene, Plan: 01*
*Completed: 2026-05-19*
