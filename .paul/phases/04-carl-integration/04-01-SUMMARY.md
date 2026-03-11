---
phase: 04-carl-integration
plan: 01
subsystem: infra
tags: [carl, domains, rules, manifest, commands]

requires:
  - phase: 02-fork-restructure
    provides: PALS repo structure with empty carl/ and commands/carl/ placeholders
provides:
  - All 5 CARL core files (manifest, global, context, commands, example-custom-domain) in carl/
  - All 8 CARL command files in commands/carl/ with paths updated to ~/.pals/carl/
  - manifest-parser.md inlined into manager.md
affects: [04-02, 05-install-distribution]

tech-stack:
  added: []
  patterns: []

key-files:
  created:
    - "carl/manifest"
    - "carl/global"
    - "carl/context"
    - "carl/commands"
    - "carl/example-custom-domain"
    - "commands/carl/manager.md"
    - "commands/carl/tasks/add-rule.md"
    - "commands/carl/tasks/create-domain.md"
    - "commands/carl/tasks/create-command.md"
    - "commands/carl/tasks/edit-rule.md"
    - "commands/carl/tasks/toggle-domain.md"
    - "commands/carl/templates/domain-template.md"
    - "commands/carl/templates/manifest-entries.md"
  modified: []

key-decisions:
  - "CARL_RULE_5 and CARL_RULE_6 updated to ~/.pals/ paths (global CARL location in PALS)"
  - "Project-local .carl/ paths preserved as-is in task files (project CARL stays at .carl/)"
  - "manifest-parser.md inlined as section in manager.md rather than separate utils/ file"

patterns-established:
  - "Global CARL path: ~/.pals/carl/ (not ~/.carl/)"
  - "Project-local CARL path: .carl/ (unchanged)"
  - "No utils/ subdirectory — inline reference content into parent command files"

duration: ~10min
started: 2026-03-11
completed: 2026-03-11
---

# Phase 4 Plan 01: Migrate CARL Core & Commands Summary

**Migrated 13 CARL files (5 core + 8 commands) into PALS repo with all global paths rewritten from ~/.carl/ to ~/.pals/carl/ and manifest-parser inlined into manager.md.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~10 min |
| Tasks | 2 completed |
| Files created | 13 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Core CARL Files Present | Pass | All 5 files in carl/, content matches source with path updates |
| AC-2: Command Files Migrated with Path Updates | Pass | 8 files in commands/carl/, manifest-parser inlined, no utils/ dir |
| AC-3: No Broken Internal References | Pass | Zero grep hits for ~/.carl/ or ~/.claude/commands/carl/ in migrated files |

## Quality

WALT: SKIP (no test runner)

## Accomplishments

- Migrated 5 core CARL domain files (manifest, global, context, commands, example-custom-domain) to carl/
- Migrated 8 CARL command files to commands/carl/ with all ~/.carl/ → ~/.pals/carl/ path updates
- Inlined manifest-parser.md reference content into manager.md, eliminating utils/ indirection
- Updated CARL_RULE_5 (overview path) and CARL_RULE_6 (file structure) to reflect PALS locations

## Files Created

| File | Purpose |
|------|---------|
| carl/manifest | Domain registry controlling which domains load and when |
| carl/global | 9 universal GLOBAL rules (always injected) |
| carl/context | Context bracket rules (FRESH/MODERATE/DEPLETED) |
| carl/commands | 8 star-commands (*dev, *review, *brief, *plan, *discuss, *debug, *explain, *carl) |
| carl/example-custom-domain | Template for users creating custom domains |
| commands/carl/manager.md | Root /carl:manager command with manifest-parser inlined |
| commands/carl/tasks/add-rule.md | Add rule to existing domain |
| commands/carl/tasks/create-domain.md | Create new domain with manifest entries |
| commands/carl/tasks/create-command.md | Create star-command in COMMANDS domain |
| commands/carl/tasks/edit-rule.md | Edit or delete existing rule |
| commands/carl/tasks/toggle-domain.md | Toggle domain state in manifest |
| commands/carl/templates/domain-template.md | Template for domain file creation |
| commands/carl/templates/manifest-entries.md | Template for manifest entry types |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Update only global CARL paths, keep project-local .carl/ as-is | Project-local CARL dirs remain .carl/ per project; only global install location changes | Task files work unchanged for project-level CARL management |
| Inline manifest-parser into manager.md | Reduces indirection, keeps all manager reference in one file | No commands/carl/utils/ directory needed |
| Update CARL_RULE_5 and CARL_RULE_6 | These rules teach users about CARL file locations — must reflect PALS paths | Users get correct paths when using *carl help mode |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- All CARL files now in PALS repo
- Plan 04-02 (hook wiring) can proceed
- commands/carl/ fully populated for skill registration in Phase 5

**Concerns:** None
**Blockers:** None

---
*Phase: 04-carl-integration, Plan: 01*
*Completed: 2026-03-11*
