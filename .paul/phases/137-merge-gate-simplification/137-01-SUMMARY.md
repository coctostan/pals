---
phase: 137-merge-gate-simplification
plan: 01
completed: 2026-03-26
duration: ~8 minutes
---

## Objective
Break the monolithic merge gate (~150 lines, 1 step) into 4 focused, individually executable sub-steps.

## What Was Built

| File | Purpose | Change |
|------|---------|--------|
| kernel/workflows/unify-phase.md | Unify workflow | 1 step → 4 sub-steps |

**Net change:** +7 lines (111 insertions, 104 deletions — restructuring, not new logic)

### Merge Gate Sub-Steps

| Sub-Step | Purpose | Gates | MUST Markers |
|----------|---------|-------|-------------|
| merge_gate_resolve | Config + skip logic | — | 3 |
| merge_gate_pr | PR + CI + reviews | 1, 2, 3 | 3 |
| merge_gate_merge | Merge PR + sync | 4, 5 | 2 |
| merge_gate_cleanup | Branch + state | 6 | 2 |

### Why This Helps Weaker Models
- Each sub-step is ~30-40 lines (vs ~150 for the monolith)
- Clear "Step N of 4" headers orient the model
- MANDATORY markers on steps 2-3 prevent skipping
- Each step has explicit BLOCK or proceed outcome
- Config variables are resolved once in step 1, used in steps 2-4

## Acceptance Criteria Results

| AC | Description | Status |
|----|-------------|--------|
| AC-1 | Merge gate split into 4 focused sub-steps | ✅ PASS |
| AC-2 | Each sub-step individually executable with MUST markers | ✅ PASS |

## Verification Results
- 4 merge_gate_* sub-steps exist ✓
- Each has own `<step>` tag with priority chain ✓
- 10 MUST markers across merge gate section ✓
- All 6 original gates preserved ✓
- Retroactive UNIFY exemption note preserved ✓
- No logic changes — same behavior, different structure ✓

## Module Execution Reports
No module dispatch needed for workflow markdown restructuring.

## Deviations
None.

## v2.27 Milestone Summary

All 4 actionable items for module dispatch hardening are now addressed:

| Item | Description | Phase | Status |
|------|-------------|-------|--------|
| 1 | Module instruction wording audit | 135 | ✅ Done |
| 2 | Post-apply dispatch enforcement | 136 | ✅ Done |
| 4 | Post-unify hook enforcement | 136 | ✅ Done |
| 5 | GitHub Flow merge gate simplification | 137 | ✅ Done |

## Next
Milestone v2.27 complete → /paul:milestone to close
