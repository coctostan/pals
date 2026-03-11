---
phase: 02-fork-restructure
plan: 01
subsystem: infra
tags: [migration, restructure, workflows, namespace]

requires:
  - phase: 01-architecture-design
    provides: Complete directory tree design and source-to-destination file map (pals-structure-design.md)
provides:
  - PALS repository directory structure (8 top-level dirs)
  - 23 workflow files migrated with @-references rewritten to ~/.pals/ paths
  - /paul: → /pals: namespace rename across all workflow files
affects: [02-fork-restructure, 03-merge-todd-walt, 04-carl-integration, 05-install-distribution]

tech-stack:
  added: []
  patterns: []

key-files:
  created:
    - "workflows/*.md (23 files)"
    - "hooks/.gitkeep"
  modified: []

key-decisions:
  - "TDD overlay files (plan-phase-tdd.md, apply-phase-tdd.md) copied as-is for Phase 3 to merge"

patterns-established:
  - "Batch sed replacement for @-reference rewiring and namespace rename"
  - "Source files at ~/.claude/paul-framework/ are read-only — never modified during migration"

duration: ~5min
started: 2026-03-11
completed: 2026-03-11
---

# Phase 2 Plan 01: Create Directory Structure and Migrate Core Workflows Summary

**PALS repository structure created with 12 directories and 23 workflow files migrated from ~/.claude/paul-framework/, all @-references rewritten to ~/.pals/ and /paul: renamed to /pals:.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~5 min |
| Tasks | 2 completed |
| Files created | 24 (23 workflows + 1 .gitkeep) |
| Directories created | 12 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Directory Structure Created | Pass | 12 directories including nested paths (templates/codebase, commands/pals, commands/carl/tasks, commands/carl/templates) |
| AC-2: All Workflow Files Migrated | Pass | 23 files copied, all non-empty (spot-checked: plan-phase 235 lines, apply-phase 327 lines, resume-project 200 lines) |
| AC-3: @-References Rewritten | Pass | 0 paul-framework refs remaining, 0 /paul: refs remaining, 18 files with /pals: refs, 8 files with ~/.pals/ refs |

## Quality

WALT: SKIP (no test runner — file migration plan)

## Accomplishments

- Created complete PALS directory structure with 12 directories matching Phase 1 design
- Migrated all 23 PAUL workflow files to workflows/ directory
- Rewrote all @-references from ~/.claude/paul-framework/ paths to ~/.pals/ paths
- Renamed all /paul: command references to /pals: namespace

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `workflows/*.md` (23 files) | Created | Core lifecycle workflows migrated from PAUL |
| `hooks/.gitkeep` | Created | Placeholder for Phase 4 CARL hook wiring |
| `references/` | Created (empty) | Ready for plan 02-02 |
| `templates/` | Created (empty) | Ready for plan 02-02 |
| `templates/codebase/` | Created (empty) | Ready for plan 02-02 |
| `rules/` | Created (empty) | Ready for plan 02-02 |
| `carl/` | Created (empty) | Ready for Phase 4 |
| `commands/pals/` | Created (empty) | Ready for plan 02-03 |
| `commands/carl/tasks/` | Created (empty) | Ready for Phase 4 |
| `commands/carl/templates/` | Created (empty) | Ready for Phase 4 |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Copy TDD overlay files as-is | Phase 3 handles inlining — keeps Phase 2 focused on migration | Phase 3 will merge plan-phase-tdd.md and apply-phase-tdd.md into parents |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- Directory structure in place for plans 02-02 (templates/references/rules) and 02-03 (commands)
- Workflow files provide foundation that Phase 3 (TODD/WALT merge) will modify
- All paths already point to ~/.pals/ — no re-rewiring needed later

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 02-fork-restructure, Plan: 01*
*Completed: 2026-03-11*
