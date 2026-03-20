---
phase: 82-config-integration
plan: 01
completed: 2026-03-19T14:35:00-0400
duration: ~5 minutes
---

## Objective

Wire CARL session boundary manager into PALS configuration and lifecycle artifacts: update pals.json with config fields, update init workflow for new projects, remove dead Claude Code-era `modules/carl/` directory, and update SPECIAL-FLOWS.md.

## What Was Built

| File | Purpose | Change |
|------|---------|--------|
| `pals.json` | Add CARL config fields, update description | +4 lines modified |
| `kernel/workflows/init-project.md` | Update CARL display + pals.json template | 2 lines changed |
| `modules/carl/` | Remove dead Claude Code-era files | -17 files, -2,393 lines |
| `.paul/SPECIAL-FLOWS.md` | Already correct — no changes needed | 0 |

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Project pals.json has CARL config | ✅ PASS | `jq '.modules.carl' pals.json` shows all 5 fields |
| AC-2 | Init workflow creates CARL config | ✅ PASS | Display line and template both updated with session_strategy, thresholds |
| AC-3 | Dead CARL files removed | ✅ PASS | `ls modules/carl` returns exit 1; 17 files removed |
| AC-4 | SPECIAL-FLOWS.md updated | ✅ PASS | Already showed "Session boundary manager" — no changes needed |

## Verification Results

| Check | Expected | Actual |
|-------|----------|--------|
| `jq '.modules.carl' pals.json` fields | 5 | 5 (enabled, description, session_strategy, continue_threshold, safety_ceiling) |
| `grep "Session boundary manager" init-project.md` | 2 matches | 2 (display + template) |
| `grep "Context rules" pals.json` | 0 matches | 0 |
| `grep "Context rules" init-project.md` | 0 matches | 0 |
| `ls modules/carl` exit code | 1 | 1 (directory gone) |
| `grep "session_strategy" init-project.md` | 1 match | 1 |

## Deviations

| Deviation | Impact |
|-----------|--------|
| SPECIAL-FLOWS.md already correct — no changes needed | Minor: file was updated in a prior session; plan expected it needed updating but it didn't |

## Key Patterns/Decisions

| Decision | Rationale |
|----------|-----------|
| Inline carl config in pals.json template (one line) | Keeps the init workflow template readable; fields are short enough for one line |
| Full `modules/carl/` removal (not archive) | 17 files of dead Claude Code hook-based CARL; fully replaced by pals-hooks.ts CARL |

## Next Phase

Phase 83: Validation & Docs — end-to-end manual testing, threshold calibration, update Pi extension README and PALS docs to reflect the two-CARL model.
