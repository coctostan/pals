---
phase: 136-post-apply-unify-enforcement
plan: 01
completed: 2026-03-26
duration: ~8 minutes
---

## Objective
Add structural enforcement to ensure post-apply and post-unify module hooks actually fire, even on weaker models.

## What Was Built

| File | Purpose | Change |
|------|---------|--------|
| kernel/workflows/apply-phase.md | Apply workflow | 2 MANDATORY markers + evidence check |
| kernel/workflows/unify-phase.md | Unify workflow | 1 MANDATORY marker + dispatch audit |

**Net change:** +24 lines across 2 files

### Task 1: Apply-Phase Enforcement
- `advisory_module_dispatch`: Added "⚠️ MANDATORY — DO NOT SKIP" + SKIPPED evidence requirement
- `enforcement_module_dispatch`: Added "⚠️ MANDATORY — DO NOT SKIP" + SKIPPED evidence requirement
- `finalize`: Added dispatch evidence check warning if both show SKIPPED/absent

### Task 2: Unify-Phase Enforcement
- `post_unify_hooks`: Added "⚠️ MANDATORY — DO NOT SKIP" with explanation of why (persistence layer)
- `finalize_summary`: Strengthened evidence validation to MANDATORY, added post-unify dispatch audit

## Acceptance Criteria Results

| AC | Description | Status |
|----|-------------|--------|
| AC-1 | Post-apply dispatch steps have MANDATORY markers | ✅ PASS |
| AC-2 | Post-unify dispatch has MANDATORY marker + evidence | ✅ PASS |
| AC-3 | UNIFY dispatch audit warns on empty evidence | ✅ PASS |

## Verification Results
- apply-phase.md: 2 MANDATORY markers (advisory + enforcement) ✓
- apply-phase.md: 3 SKIPPED evidence requirements ✓
- apply-phase.md: finalize dispatch evidence check ✓
- unify-phase.md: 1 MANDATORY marker (post_unify_hooks) ✓
- unify-phase.md: 2 SKIPPED evidence requirements ✓
- unify-phase.md: finalize_summary dispatch audit ✓
- No step logic, priorities, or module lists changed ✓

## Module Execution Reports
No module dispatch needed for workflow markdown edits.

## Deviations
None.

## Next Phase
Phase 137: GitHub Flow Merge Gate Simplification (Item 5)
