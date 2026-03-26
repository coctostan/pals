---
phase: 135-module-instruction-wording
plan: 01
completed: 2026-03-26
duration: ~15 minutes
---

## Objective
Rewrite all 40 module hook descriptions across 18 modules from descriptive/passive to imperative phrasing with explicit "MUST run:" commands.

## What Was Built

| File | Purpose | Change |
|------|---------|--------|
| modules/arch/module.yaml | Architecture module | 2 hooks → imperative |
| modules/aria/module.yaml | Accessibility module | 1 hook → imperative |
| modules/dana/module.yaml | Data module | 1 hook → imperative |
| modules/dave/module.yaml | Deploy module | 1 hook → imperative |
| modules/dean/module.yaml | Dependency module | 1 hook → imperative |
| modules/docs/module.yaml | Documentation module | 2 hooks → imperative |
| modules/gabe/module.yaml | API module | 1 hook → imperative |
| modules/iris/module.yaml | Review module | 2 hooks → imperative |
| modules/luke/module.yaml | UX module | 1 hook → imperative |
| modules/omar/module.yaml | Observability module | 1 hook → imperative |
| modules/pete/module.yaml | Performance module | 1 hook → imperative |
| modules/reed/module.yaml | Resilience module | 1 hook → imperative |
| modules/ruby/module.yaml | Refactor module | 2 hooks → imperative |
| modules/seth/module.yaml | Security module | 1 hook → imperative |
| modules/skip/module.yaml | Knowledge module | 2 hooks → imperative |
| modules/todd/module.yaml | TDD module | 5 hooks → imperative |
| modules/vera/module.yaml | Privacy module | 1 hook → imperative |
| modules/walt/module.yaml | Quality module | 3 hooks → imperative |

**Net change:** +27 lines across 18 files (descriptions slightly longer due to explicit commands)

### Transformation Applied
- Every pre-plan hook now starts with "MUST run:" + backtick-quoted command
- Every post-apply hook uses "For EACH file ... MUST run:" pattern
- Every hook has explicit "If no issues/concerns: '{MODULE}: No {concern}'" fallback
- BLOCK/WARN output formats are explicit in every enforcement hook
- 0 → 73 MUST markers in source module.yaml files
- 0 → 29 MUST markers in installed modules.yaml

### Weakest Hooks Strengthened
| Hook | Before | After |
|------|--------|-------|
| iris.pre-plan | 111 chars, no commands | Explicit grep + wc -l commands |
| todd.pre-plan | 98 chars, no commands | Explicit find + grep commands |
| todd.post-plan | Passive "If" start | "MUST restructure" imperative |
| walt.post-unify | Passive "Compute" | "MUST compute" + "MUST append" |

## Acceptance Criteria Results

| AC | Description | Status |
|----|-------------|--------|
| AC-1 | All pre-plan hooks start with imperative verb | ✅ PASS |
| AC-2 | All post hooks use "For EACH" + "MUST" pattern | ✅ PASS |
| AC-3 | 4 weakest hooks strengthened with explicit commands | ✅ PASS |

## Verification Results
- 16/16 pre-plan hooks use imperative "MUST run:" pattern ✓
- 0 hooks start with passive "Scan"/"Check"/"Detect" ✓
- All 4 weakest hooks have explicit commands ✓
- No hook priorities changed ✓
- No hook refs changed ✓
- Installer ran successfully ✓
- Installed modules.yaml: 0 → 29 MUST markers ✓

## Module Execution Reports
No module dispatch needed for YAML config edits.

## Deviations
None. All 40 hook descriptions rewritten as planned.

## Next Phase
Phase 136: Post-Apply/Post-Unify Enforcement (Items 2, 4)
