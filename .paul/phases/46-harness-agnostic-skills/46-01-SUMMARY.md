---
phase: 46-harness-agnostic-skills
plan: 01
subsystem: kernel
tags: [portability, reference-resolution, harness-agnostic, v2.0, workflows, templates]

requires:
  - "45-01: ARTIFACT-SPEC.md, LIFECYCLE-SPEC.md, HOOK-CONTRACT.md — normative contracts this plan builds on"
provides:
  - "docs/REFERENCE-RESOLUTION.md — portable reference convention for all PALS workflows"
  - "Core loop workflows (plan/apply/unify) using portable references"
  - "PLAN.md and SUMMARY.md templates using portable references"
affects:
  - 46-harness-agnostic-skills (remaining plans follow this convention)
  - 47-pi-adapter (adapter resolves kernel/ paths)

tech-stack:
  added: []
  patterns:
    - "kernel/ logical prefix for kernel resources (adapter resolves to install path)"
    - "Plain paths without @ prefix in required_reading/references sections"
    - "Generic verbs instead of Claude-specific tool names in workflow prose"

key-files:
  created:
    - docs/REFERENCE-RESOLUTION.md
  modified:
    - kernel/workflows/plan-phase.md
    - kernel/workflows/apply-phase.md
    - kernel/workflows/unify-phase.md
    - kernel/templates/PLAN.md
    - kernel/templates/SUMMARY.md

key-decisions:
  - "Decision: Two reference categories — project artifacts (.paul/) and kernel resources (kernel/) — no third category needed"
  - "Decision: Adapters resolve kernel/ to install location transparently — zero change for Claude Code users"
  - "Decision: modules.yaml referenced as kernel/modules.yaml (logical, not install path)"

patterns-established:
  - "Pattern: @~/.pals/X → kernel/X in all workflow reference sections"
  - "Pattern: @.paul/X → .paul/X (remove @ prefix, path unchanged)"
  - "Pattern: ~/.pals/modules.yaml → kernel/modules.yaml in hook dispatch instructions"
  - "Pattern: Generic verbs (Read, Run, Search) instead of tool-specific names"

duration: ~5min
started: 2026-03-14T00:00:00Z
completed: 2026-03-14T00:05:00Z
---

# Phase 46 Plan 01: Convention & Core Loop Summary

**Portable reference resolution convention defined and applied to 3 core loop workflows + 2 primary templates — zero @~/.pals/ references remain in the PLAN/APPLY/UNIFY path.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~5min |
| Tasks | 3 completed |
| Files created | 1 |
| Files modified | 5 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Reference Resolution Convention Documented | Pass | 115-line doc with logical paths, adapter table, migration examples |
| AC-2: Core Loop Workflows Use Portable References | Pass | Zero @~/.pals/ or @.paul/ in plan-phase, apply-phase, unify-phase |
| AC-3: Templates Use Portable References | Pass | Zero @ prefixed references in PLAN.md and SUMMARY.md templates |
| AC-4: Claude Code Zero-Regression | Pass | Installed symlinks unchanged, adapter resolves kernel/ transparently |

## Accomplishments

- Created docs/REFERENCE-RESOLUTION.md defining the portable convention: two reference categories (project artifacts as .paul/ paths, kernel resources as kernel/ logical paths), adapter responsibility table, and migration reference
- Updated plan-phase.md, apply-phase.md, unify-phase.md — removed all @~/.pals/ and @.paul/ patterns, replaced ~/ install paths with kernel/ logical paths in hook dispatch instructions
- Updated PLAN.md and SUMMARY.md templates — removed @ prefix from context section paths

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `docs/REFERENCE-RESOLUTION.md` | Created | Portable reference convention (115 lines) |
| `kernel/workflows/plan-phase.md` | Modified | 4 edits: references, required_reading, modules.yaml paths, context description |
| `kernel/workflows/apply-phase.md` | Modified | 2 edits: references/required_reading, 4x modules.yaml paths (replace_all) |
| `kernel/workflows/unify-phase.md` | Modified | 4 edits: references/required_reading, modules.yaml paths, transition-phase ref |
| `kernel/templates/PLAN.md` | Modified | 1 edit: context section @ removal |
| `kernel/templates/SUMMARY.md` | Modified | 1 edit: frontmatter description @ removal |

## Decisions Made

None — followed plan as specified.

## Deviations from Plan

None — plan executed exactly as written.

## Next Phase Readiness

**Ready:**
- Convention doc establishes clear pattern for plans 46-02 and 46-03
- Core loop is fully portable — remaining work is applying same pattern to peripheral files

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 46-harness-agnostic-skills, Plan: 01*
*Completed: 2026-03-14*
