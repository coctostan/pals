---
phase: 132-smart-question-gating
plan: 01
completed: 2026-03-26
duration: ~10 minutes
---

## Objective
Add conditional question gating to init-project.md so irrelevant questions are skipped based on prior answers (Items 6, 7, 11 from v2.25 actionable items).

## What Was Built

| File | Purpose | Change |
|------|---------|--------|
| kernel/workflows/init-project.md | Init workflow | Brownfield detection, git gating, SonarQube/skills removal |

**Net change:** 914 → 854 lines (-60 lines, net reduction)

### Task 1: Brownfield Detection Fix
- Added two-stage detection: (1) directory/file indicators, then (2) actual source file check via `find`
- Empty scaffolding (e.g., `mkdir src test` with no source files) now falls through to greenfield path
- Added explicit "scaffolding only" messaging

### Task 2: Git Automation Question Gating
- Direct-to-main now skips Questions 3 (worktree) and 4 (automation), sets all to false
- Feature-per-phase without remote skips Question 4
- Added explicit notes explaining when/why each question is asked or skipped
- GitHub Flow path unchanged (already correct)

### Task 3: SonarQube + Specialized Skills Removal
- Replaced interactive SonarQube question with silent default (disabled)
- Replaced interactive specialized skills question with silent default (skipped)
- Removed SPECIAL-FLOWS.md from init confirmation display
- Added notes pointing to `/paul:config` and `/paul:flows` for later configuration

## Acceptance Criteria Results

| AC | Description | Status |
|----|-------------|--------|
| AC-1 | Brownfield detection uses source files, not directory existence | ✅ PASS |
| AC-2 | Git automation questions gated on prior answers | ✅ PASS |
| AC-3 | SonarQube and specialized skills removed from init | ✅ PASS |

## Verification Results
- `detect_existing_code` step: two-stage check with find command ✓
- `configure_git` step: direct-to-main skips Q3+Q4, no-remote skips Q4 ✓
- `prompt_integrations` step: no interactive question, silent default ✓
- `check_specialized_flows` step: no interactive question, silent default ✓
- `confirm_and_route` step: SPECIAL-FLOWS.md line removed ✓
- All other steps verified unchanged ✓

## Module Execution Reports

| Module | Hook | Result |
|--------|------|--------|
| TODD | pre-plan | skip (no test files for workflow markdown) |
| DEAN | pre-plan | skip (no package manager lock file) |
| IRIS | pre-plan | 1 flag: init-project.md 913 lines (large workflow) |
| RUBY | pre-plan | 1 flag: monitor for growth |
| IRIS | post-apply | 0 concerns (net size reduction: 914→854) |
| DOCS | post-apply | 0 drift (internal workflow change) |
| RUBY | post-apply | 0 debt (reduced) |
| SKIP | post-apply | 1 decision captured |

## Deviations
None. All three tasks executed exactly as planned.

## Key Patterns/Decisions
- Kept step names and structure intact — only changed step contents
- SonarQube and specialized skills functionality preserved (just moved to /paul:config and /paul:flows)
- Brownfield detection is additive (source-file check added as second stage, not replacement)

## Next Phase
Phase 133: Greenfield Fast Path + Explicit Milestone Creation (Items 8, 9, 10, 12)
