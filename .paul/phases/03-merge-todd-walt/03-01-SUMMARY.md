---
phase: 03-merge-todd-walt
plan: 01
subsystem: infra
tags: [todd, tdd, reclassify, references]

requires:
  - phase: 02-fork-restructure
    provides: Workflow and reference files in place
provides:
  - TDD overlay files reclassified as reference docs
  - Parent workflows updated to reference specs natively
  - Zero overlay terminology remaining
affects: [03-merge-todd-walt]

tech-stack:
  added: []
  patterns: []

key-files:
  created:
    - "references/tdd-plan-generation.md"
    - "references/tdd-execution.md"
  modified:
    - "workflows/plan-phase.md"
    - "workflows/apply-phase.md"
    - "references/tdd.md"
    - "references/tdd-detection.md"
    - "references/quality-runner.md"

key-decisions:
  - "Reclassify overlays as references instead of inlining — keeps files readable"
  - "Matches existing pattern: quality-runner.md, quality-lint.md are reference specs"

patterns-established:
  - "TDD specs as references, not workflow overlays — 'follow spec' not 'delegate to overlay'"

duration: ~5min
started: 2026-03-11
completed: 2026-03-11
---

# Phase 3 Plan 01: Merge TODD (TDD) into Plan/Apply Workflows Summary

**TDD overlay files reclassified as reference docs (tdd-plan-generation.md, tdd-execution.md). Parent workflows updated from "delegate to overlay" to "follow reference spec." All dangling refs fixed across 5 files.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~5 min |
| Tasks | 2 completed |
| Files created | 2 (references) |
| Files deleted | 2 (overlays) |
| Files modified | 5 (dangling ref fixes) |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: TDD Overlays Reclassified | Pass | tdd-plan-generation.md and tdd-execution.md in references/ |
| AC-2: Parent Workflows Updated | Pass | plan-phase.md and apply-phase.md reference specs natively |
| AC-3: Overlay Terminology Removed | Pass | Zero "overlay" mentions in modified files, zero dangling old-name refs |

## Quality

WALT: SKIP (no test runner)

## Accomplishments

- Moved plan-phase-tdd.md → references/tdd-plan-generation.md with updated framing
- Moved apply-phase-tdd.md → references/tdd-execution.md with updated framing
- Updated plan-phase.md and apply-phase.md delegation → reference pattern
- Fixed 4 dangling references in tdd.md, tdd-detection.md, quality-runner.md

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Reclassify instead of inline | Keeps workflow files readable, matches existing reference pattern | TDD content stays self-contained at ~300 lines each |

## Deviations from Plan

None.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- Plan 03-02 (WALT quality native) can proceed
- references/ now has 4 TDD files: tdd.md, tdd-detection.md, tdd-plan-generation.md, tdd-execution.md

**Concerns:** None
**Blockers:** None

---
*Phase: 03-merge-todd-walt, Plan: 01*
*Completed: 2026-03-11*
