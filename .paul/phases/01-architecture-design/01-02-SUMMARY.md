---
phase: 01-architecture-design
plan: 02
subsystem: infra
tags: [architecture, design, structure, migration]

requires:
  - phase: 01-architecture-design
    provides: Complete file inventory (111 files) from plan 01-01
provides:
  - Unified PALS directory tree design (~/.pals/)
  - Source-to-destination file map for all 111 files
  - Naming conventions and namespace mapping (/pals:*, /carl:*)
  - 6 key design decisions with rationale
  - Migration notes for Phases 2-5
affects: [02-fork-restructure, 03-merge-todd-walt, 04-carl-integration, 05-install-distribution]

tech-stack:
  added: []
  patterns: []

key-files:
  created: [".paul/phases/01-architecture-design/pals-structure-design.md"]
  modified: []

key-decisions:
  - "Flat workflows directory — no TODD/WALT subdirectories"
  - "CARL gets its own subdirectory (~/.pals/carl/)"
  - "Commands use /pals:* namespace; CARL keeps /carl:*"
  - "TODD workflows merge inline into parent workflows (not kept as separate files)"
  - "manifest-parser.md merges into manager.md"
  - "Deprecated status.md removed, not migrated"

patterns-established:
  - "Source-to-destination mapping: every file gets explicit action (copy/merge/remove)"
  - "Component identity via prefix, not directory: tdd-*, quality-*"

duration: ~10min
started: 2026-03-11
completed: 2026-03-11
---

# Phase 1 Plan 02: Unified PALS Structure Design Summary

**Complete directory tree and file mapping for unifying 111 source files into ~/.pals/ with 105 destinations, 6 design decisions, and migration roadmap for Phases 2-5.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~10 min |
| Tasks | 1 completed |
| Files created | 1 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Complete Directory Layout | Pass | Full ~/.pals/ tree with 8 top-level directories, all with stated purposes |
| AC-2: Source-to-Destination File Map | Pass | All 111 source files mapped — 73 copy, 25 copy+rename, 3 copy+merge, 3 merge-into, 1 remove |
| AC-3: Namespace and Naming Conventions | Pass | /pals:* replaces /paul:*, /carl:* retained, file naming patterns defined for all categories |

## Quality

WALT: SKIP (no test runner — documentation-only plan)

## Accomplishments

- Designed complete ~/.pals/ directory tree with 8 top-level directories (workflows, references, templates, rules, carl, commands, hooks, install.sh)
- Mapped all 111 source files to 105 destinations with explicit actions and notes
- Defined 6 key design decisions: flat workflows, CARL subdirectory, /pals:* namespace, TODD inline merge, manifest-parser merge, status.md removal
- Documented migration order dependencies and content-update requirements for Phases 2-5

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `.paul/phases/01-architecture-design/pals-structure-design.md` | Created | Complete unified structure design with file map |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Flat workflows/ (no TODD/WALT subdirs) | Only 3 TODD/WALT workflow files, all merge into parents | Phase 3 merges inline, no directory moves needed |
| CARL in own subdirectory | Architecturally independent, runtime config not docs | Phase 4 copies to ~/.pals/carl/ cleanly |
| /pals:* namespace | Unified brand for new users, CARL independent | Phase 2 does batch /paul: → /pals: rename |
| TODD merges inline | TDD is a mode, not a system — removes indirection | Phase 3 inlines 2 files into parent workflows |
| manifest-parser.md inlined | Single-use utility for one command | Phase 4 merges into manager.md |
| status.md removed | Already deprecated for progress.md | Phase 2 skips this file |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- pals-structure-design.md provides the complete blueprint for Phase 2
- Every source file has an explicit destination and action type
- Migration order documented (Phase 2 → 3 → 4 → 5)
- Content update requirements identified (reference rewiring, namespace rename)

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 01-architecture-design, Plan: 02*
*Completed: 2026-03-11*
