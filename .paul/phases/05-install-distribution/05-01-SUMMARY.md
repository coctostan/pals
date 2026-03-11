---
phase: 05-install-distribution
plan: 01
subsystem: infra
tags: [bash, installer, deployment, symlink]

requires:
  - phase: 04-carl-integration
    provides: CARL files and hook in PALS repo
provides:
  - install.sh script for complete PALS deployment
  - Idempotent fresh install and upgrade support
affects: [06-end-to-end-validation]

tech-stack:
  added: [bash, python3 (JSON manipulation)]
  patterns: [cp for framework files, cp -n for user config, symlink for hooks]

key-files:
  created: [install.sh]
  modified: []

key-decisions:
  - "Copy framework files (overwrite on upgrade), cp -n for CARL user config"
  - "Symlink hook script to keep it auto-updating from repo"
  - "Use python3 for settings.json manipulation (more reliable than jq)"

patterns-established:
  - "Install script validates repo structure before proceeding"
  - "User config (CARL domains) preserved on upgrade via no-clobber copy"

duration: ~10min
started: 2026-03-11
completed: 2026-03-11
---

# Phase 5 Plan 01: Create Install Script Summary

**Bash installer that deploys PALS from git clone to ~/.pals/ and ~/.claude/ with idempotent fresh install and upgrade support.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~10min |
| Started | 2026-03-11 |
| Completed | 2026-03-11 |
| Tasks | 2 completed (1 auto + 1 checkpoint) |
| Files created | 1 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Fresh Install Works | Pass | Creates ~/.pals/ with all subdirs, installs 25 pals + 8 carl commands, symlinks hook, registers in settings.json |
| AC-2: Upgrade Preserves User Config | Pass | Uses cp -n for CARL domains (manifest, global, context, etc.) — skips existing files |
| AC-3: Script Is Idempotent | Pass | Re-running produces no errors, hook registration checks for existing entry |

## Quality

Quality: not tracked (shell script, no test runner)

## Accomplishments

- Created install.sh (155 lines) handling complete PALS deployment
- Fresh install creates ~/.pals/ structure and copies all framework files
- Upgrade path preserves user CARL config while updating framework files
- Hook symlinked (auto-updates from repo) and registered in settings.json via python3

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `install.sh` | Created | Complete PALS installer — fresh install, upgrade, validation |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Symlink hook, copy everything else | Hook benefits from auto-update; framework files are stable per release | Users get hook fixes without re-running install |
| python3 for JSON manipulation | More reliable than jq (may not be installed), macOS ships with python3 | No additional dependencies required |
| Validation section checks all critical paths | Catches partial installs early | Users get clear error on failure |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- install.sh is the core deliverable for Phase 5
- Phase 5 has only 1 plan — phase is complete

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 05-install-distribution, Plan: 01*
*Completed: 2026-03-11*
