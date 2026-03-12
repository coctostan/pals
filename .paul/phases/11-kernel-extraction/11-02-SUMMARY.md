---
phase: 11-kernel-extraction
plan: 02
subsystem: infra
tags: [kernel, modules, hooks, lifecycle, decoupling]

requires:
  - phase: 11-kernel-extraction (plan 01)
    provides: kernel/ and modules/ directory structure, module.yaml manifests
  - phase: 10-architecture-module-interface
    provides: MODULE-SPEC.md hook contract, lifecycle hook point definitions
provides:
  - Module-agnostic kernel workflows with generic hook dispatch
  - Generic SUMMARY template with Module Execution Reports section
affects: [12-module-manager, 13-driver-architecture]

tech-stack:
  added: []
  patterns: [generic-hook-dispatch, modules-yaml-driven-dispatch, no-op-when-absent]

key-files:
  created: []
  modified: [kernel/workflows/apply-phase.md, kernel/workflows/unify-phase.md, kernel/workflows/plan-phase.md, kernel/templates/SUMMARY.md]

key-decisions:
  - "Hook dispatch reads modules.yaml at each hook point — no hardcoded module checks"
  - "Pre-plan hooks run before scope analysis so modules can suggest plan types"
  - "Post-plan hooks run after plan creation so modules can restructure tasks"
  - "SUMMARY template uses generic Module Execution Reports with example formats in HTML comments"

patterns-established:
  - "Kernel never checks if_module_installed — only checks if_hooks_registered"
  - "Consistent 6-step hook dispatch pattern across all workflow files"
  - "Module-specific sections in templates use HTML comments for format examples"

duration: ~10min
completed: 2026-03-12
---

# Phase 11 Plan 02: Decouple Kernel Workflows from WALT/TODD Summary

**Removed all hardcoded WALT/TODD references from kernel workflows and replaced with generic lifecycle hook dispatch driven by modules.yaml.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~10min |
| Completed | 2026-03-12 |
| Tasks | 2 completed |
| Files modified | 4 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: No WALT references in kernel workflows | Pass | grep returns zero matches |
| AC-2: No TODD/TDD hardcoded references in kernel workflows | Pass | grep -i returns zero matches |
| AC-3: Generic hook dispatch points exist | Pass | pre/post hooks in all 3 workflows, modules.yaml referenced 9 times |
| AC-4: SUMMARY template uses generic module sections | Pass | "Module Execution Reports" replaces WALT/TDD sections |

## Module Execution Reports

No modules contributed annotations — infrastructure-only changes (markdown workflow files).

## Accomplishments

- Replaced 2 hardcoded WALT steps in apply-phase.md (walt_baseline, walt_post_apply) with generic pre_apply_hooks and post_apply_hooks
- Replaced 3 hardcoded steps in unify-phase.md (audit_tdd_execution, audit_quality_delta, append_quality_history) with generic pre_unify_hooks and post_unify_hooks
- Added pre_plan_hooks and post_plan_hooks to plan-phase.md, replacing hardcoded TDD detection/generation references
- Updated SUMMARY.md template with generic "Module Execution Reports" section preserving format examples as HTML comments

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| kernel/workflows/apply-phase.md | Modified | Replaced walt_baseline/walt_post_apply with generic hook dispatch; removed TDD execution overlay; updated finalize step |
| kernel/workflows/unify-phase.md | Modified | Replaced audit_tdd_execution/audit_quality_delta/append_quality_history with generic hook dispatch; added post_unify_hooks |
| kernel/workflows/plan-phase.md | Modified | Added pre_plan_hooks/post_plan_hooks; replaced TDD detection heuristics with module-suggested types |
| kernel/templates/SUMMARY.md | Modified | Replaced "TDD Execution" and "Quality (from WALT reports)" with generic "Module Execution Reports" |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Consistent 6-step dispatch pattern | Same structure across all hook points makes kernel predictable | Future modules integrate identically |
| Pre-plan hooks before scope analysis | Modules need to inject context (e.g., type suggestions) before scope is decided | Plan type selection is now module-driven |
| Example formats in HTML comments | Modules need to know expected report format without the kernel hardcoding it | Template is module-agnostic but informative |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 1 | Cleaned up example reference to "tdd" in plan-phase.md hook description |

**Total impact:** Minimal — one generic example text adjusted to remove module-specific terminology.

### Auto-fixed Issues

**1. Residual "tdd" reference in hook description**
- **Found during:** Task 1 verification
- **Issue:** Pre-plan hooks step mentioned "e.g., a module could suggest `type: tdd`" — still referencing specific module behavior
- **Fix:** Changed to generic "modules may suggest alternative types based on their own heuristics"
- **Verification:** grep -ri "tdd" kernel/workflows/ returns zero matches

## Issues Encountered

None

## Next Phase Readiness

**Ready:**
- Kernel is fully module-agnostic — hook dispatch reads modules.yaml dynamically
- MODULE-SPEC.md hook contract (from Phase 10) aligns with implemented dispatch pattern
- Phase 12 can build module-aware installer knowing kernel workflows are clean

**Concerns:**
- The installed workflow files at ~/.pals/ still have old hardcoded versions — install.sh must be re-run to update them
- ci-generation.md still references WALT (out of scope, flagged as future module candidate)

**Blockers:**
- None

---
*Phase: 11-kernel-extraction, Plan: 02*
*Completed: 2026-03-12*
