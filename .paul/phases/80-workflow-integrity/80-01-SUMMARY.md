---
phase: 80-workflow-integrity
plan: 01
subsystem: kernel-workflows
tags: [workflow-integrity, commit-staging, ground-truth-verification, hallucination-prevention]

requires: []
provides:
  - "Post-stage sanity check in transition-phase.md preventing documentation-only commits"
  - "Ground-truth git diff verification in apply-phase.md execute_tasks step"
  - "Repo-source-only constraint in plan-phase.md create_plan step"
  - "Reconciliation mismatch detection in unify-phase.md gather_results step"
  - "Canonical edit rule documentation in Pi extension README"
affects:
  - "Every future phase — commit staging now covers all project directories"
  - "Every future APPLY — tasks with <files> are now ground-truth verified via git diff"
  - "Every future PLAN — out-of-repo edit targets are now rejected"
  - "Every future UNIFY — reconciliation cross-checks git diff against files_modified"

tech-stack:
  added: []
  patterns:
    - "Post-stage sanity check: git diff --cached --name-only vs files_modified before commit"
    - "Ground-truth file check: git diff --name-only after each task verify step"
    - "Repo-source-only constraint: ✗/✓ examples with deploy step requirement"
    - "Reconciliation mismatch: git diff --stat vs files_modified at UNIFY start"

key-files:
  modified:
    - kernel/workflows/transition-phase.md
    - kernel/workflows/apply-phase.md
    - kernel/workflows/plan-phase.md
    - kernel/workflows/unify-phase.md
    - drivers/pi/extensions/README.md

key-decisions:
  - "Decision: Use git add -u plus explicit directory staging instead of git add . to avoid accidental inclusion of untracked files"
  - "Decision: Sanity check is advisory (3 options) not blocking — allows legitimate documentation-only phases to proceed with override"
  - "Decision: RECONCILIATION MISMATCH in UNIFY is advisory (2 options) — investigation preferred but override available"

duration: ~15min
started: 2026-03-19T11:45:00-0400
completed: 2026-03-19T12:05:00-0400
---

# Phase 80 Plan 01: Workflow Integrity Fixes Summary

**Five structural workflow gaps closed — the v2.9 hallucination cascade would now be caught at 4 independent checkpoints.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~15min |
| Started | 2026-03-19T11:45:00-0400 |
| Completed | 2026-03-19T12:05:00-0400 |
| Tasks | 3 completed |
| Files modified | 5 (+ 2 .paul/ state files) |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Commit staging covers all project directories | Pass | `git add -u` + explicit `drivers/ kernel/ modules/ tests/ docs/ src/` replaces old `src/`-only staging |
| AC-2: Post-stage sanity check catches documentation-only commits | Pass | New step 3a between staging and commit creation; compares `git diff --cached` against `files_modified` |
| AC-3: apply-phase requires ground-truth file verification | Pass | New step 5a in execute_tasks; `git diff --name-only` confirms files actually modified; zero changes = FAIL |
| AC-4: plan-phase enforces repo-source-only edit targets | Pass | New constraint in create_plan with ✗/✓ examples and deploy step requirement |
| AC-5: unify-phase cross-checks git diff in normal reconciliation | Pass | New step 0 in gather_results; `git diff --stat` compared against `files_modified`; mismatch halts SUMMARY |

## Accomplishments

- Widened commit staging from `.paul/` + `src/` to all 6 project directories plus `git add -u` for tracked file changes
- Added post-stage sanity check that would have caught all 4 hollow v2.9 commits (Phases 76-79 each had non-`.paul/` files in `files_modified` with zero staged)
- Added mandatory ground-truth `git diff` verification after every task's verify step — zero file changes now fail the task regardless of what the agent claims
- Added repo-source-only constraint that would have rejected Phase 77's plan targeting `~/.pi/agent/extensions/pals-hooks.ts`
- Added UNIFY reconciliation mismatch detection that would have caught the discrepancy between claimed and actual changes
- Documented canonical edit rule for `pals-hooks.ts` in the Pi extension README

## Files Modified

| File | Change | Lines | Purpose |
|------|--------|-------|---------|
| `kernel/workflows/transition-phase.md` | Modified | +37 | Widened staging + post-stage sanity check |
| `kernel/workflows/apply-phase.md` | Modified | +16 | Ground-truth file check (step 5a) |
| `kernel/workflows/plan-phase.md` | Modified | +11 | Repo-source-only constraint |
| `kernel/workflows/unify-phase.md` | Modified | +31 | Reconciliation mismatch detection (step 0) |
| `drivers/pi/extensions/README.md` | Modified | +11 | Development Workflow section |

## How v2.9 Would Have Been Caught

| Checkpoint | Where | Would have fired on |
|------------|-------|---------------------|
| Repo-source-only constraint | plan-phase.md | Phase 77 plan targeting `~/.pi/` instead of `drivers/pi/` |
| Ground-truth file check | apply-phase.md | Phase 77 task claiming PASS with zero `git diff` changes to `pals-hooks.ts` |
| Post-stage sanity check | transition-phase.md | All 4 phase commits (76-79) — `files_modified` listed extension file but nothing staged |
| Reconciliation mismatch | unify-phase.md | All 4 UNIFY runs — `git diff --stat` shows only `.paul/` changes vs claimed extension work |

## Deviations from Plan

None — plan executed exactly as written. All 3 tasks completed with ground-truth `git diff` verification confirming each target file was actually modified.

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Use `git add -u` + explicit dirs instead of `git add .` | Avoids staging untracked/temporary files while still catching all tracked modifications | Safer than a blanket `git add .` which could include build artifacts |
| Sanity check is advisory (3 options) not hard-blocking | Legitimate documentation-only phases exist and shouldn't require workarounds | Override path with deviation recording keeps the audit trail |
| RECONCILIATION MISMATCH is advisory (2 options) | Same reasoning — but investigation is strongly preferred over override | SUMMARY must document the mismatch if user overrides |

## Issues Encountered

None.

---
*Phase: 80-workflow-integrity, Plan: 01*
*Completed: 2026-03-19*
