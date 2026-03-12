---
phase: 11-kernel-extraction
plan: 01
subsystem: infra
tags: [kernel, modules, migration, restructure]

requires:
  - phase: 10-architecture-module-interface
    provides: KERNEL-MANIFEST.md file classification, MODULE-SPEC.md manifest schema
provides:
  - kernel/ directory with 85 PAUL core files
  - modules/ directory with 28 files (TODD, WALT, CARL + manifests)
  - migrate.sh one-time migration script
  - Updated install.sh for kernel/modules paths
affects: [11-02-decouple-workflows, 12-module-manager]

tech-stack:
  added: []
  patterns: [kernel-module-separation, git-mv-migration, symlink-aware-restructuring]

key-files:
  created: [migrate.sh, modules/todd/module.yaml, modules/walt/module.yaml, modules/carl/module.yaml]
  modified: [install.sh]

key-decisions:
  - "Migration script approach instead of raw file moves — prevents breaking live infrastructure"
  - "git mv for all moves — preserves git history and enables easy revert"
  - "Symlink update inside migrate.sh — atomic with file moves"

patterns-established:
  - "Never move live files without updating all references in the same operation"
  - "Migration scripts over manual restructuring for infrastructure changes"

duration: ~20min
completed: 2026-03-11
---

# Phase 11 Plan 01: Kernel/Module Restructure Summary

**Restructured PALS repo from flat layout into kernel/modules directories using a migration script with atomic symlink updates.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~20min |
| Completed | 2026-03-11 |
| Tasks | 3 completed (2 auto + 1 checkpoint) |
| Files moved | 113 (85 kernel + 28 modules) |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: migrate.sh pre-flight validation | Pass | Checks repo root, existing dirs, symlink detection, file count |
| AC-2: Files in correct kernel/modules locations | Pass | 85 kernel, 28 module files verified |
| AC-3: Live references updated atomically | Pass | Symlink at ~/.claude/hooks/carl-hook.py → modules/carl/hooks/ |
| AC-4: install.sh works with new structure | Pass | Re-ran install, zero errors, 25 paul + 8 carl commands |
| AC-5: No files lost | Pass | All 113 files accounted for, top-level + docs/ unchanged |

## Quality

Not tracked — no code changes, file restructure only.

## Accomplishments

- Built migrate.sh with pre-flight checks, git mv moves, symlink updates, and post-migration validation
- Moved 85 kernel files into kernel/ (workflows, references, templates, rules, commands)
- Moved 28 module files into modules/ (TODD: 4 refs, WALT: 6 refs + 1 workflow, CARL: 5 config + 1 hook + 7 commands + 3 manifests)
- Updated install.sh to reference kernel/ and modules/ paths
- Verified install.sh runs cleanly on new structure

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| migrate.sh | Created | One-time migration script — git mv + symlink + manifests |
| modules/todd/module.yaml | Created | TODD module manifest |
| modules/walt/module.yaml | Created | WALT module manifest |
| modules/carl/module.yaml | Created | CARL module manifest |
| install.sh | Modified | Updated all source paths from flat to kernel/modules |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Migration script instead of raw moves | Previous attempt broke live CARL hook | Safer, repeatable, revertible |
| git mv for all file moves | Preserves rename history in git | Clean `git log --follow` |
| Guard empty module dirs in install.sh | TODD workflows/ empty (plan-phase-tdd.md doesn't exist yet) | Prevents install failure |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 1 | Essential fix, no scope creep |
| Deferred | 1 | Known pre-existing issue |

**Total impact:** Minimal — one install.sh fix for empty dir edge case.

### Auto-fixed Issues

**1. install.sh empty directory glob failure**
- **Found during:** Task 2 (run migrate.sh + update install.sh)
- **Issue:** `cp -R modules/todd/workflows/*` failed because plan-phase-tdd.md doesn't exist
- **Fix:** Added `ls` guard before cp for TODD and WALT workflow/reference dirs
- **Verification:** Re-ran install.sh — zero errors

### Deferred Items

- plan-phase-tdd.md does not exist as standalone file — needs creation as TODD module workflow (pre-existing from Phase 10)

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Previous Plan 11-01 attempt broke live CARL hook | Reverted, re-planned with migrate.sh approach |
| /dev/tty not available in sandbox for legacy cleanup prompt | Non-blocking — defaults to skip |

## Next Phase Readiness

**Ready:**
- Repo fully restructured — kernel/ and modules/ directories in place
- module.yaml manifests created for all 3 modules
- install.sh validated against new structure
- Foundation set for Plan 11-02 (decouple hardcoded TODD/WALT refs in kernel workflows)

**Concerns:**
- @-reference paths inside workflow/reference file contents still point to old flat paths (e.g., `@references/tdd.md` not `@modules/todd/references/tdd.md`)
- This may or may not matter depending on how the installed layout works (files merge into ~/.pals/ flat structure)

**Blockers:**
- None

---
*Phase: 11-kernel-extraction, Plan: 01*
*Completed: 2026-03-11*
