---
phase: 37-resilience-and-isolation
plan: 01
subsystem: kernel
tags: [worktree, git, isolation, resilience]

requires:
  - phase: 34-competitive-research
    provides: Superpowers worktree analysis

provides:
  - Optional git worktree isolation during APPLY phase
  - Worktree config in pals.json git section
  - Worktree reference documentation

affects:
  - All future APPLY executions (worktree option available)
  - map-codebase output (now includes worktree isolation)

tech-stack:
  added: []
  patterns:
    - "Config-driven optional behavior (worktree_isolation: true|false, default false)"
key-files:
  created:
    - kernel/references/worktree-isolation.md
  modified:
    - kernel/workflows/apply-phase.md
    - kernel/workflows/init-project.md
    - kernel/workflows/transition-phase.md

key-decisions:
  - "Decision: Worktree isolation must be optional (default off) — zero behavior change for existing users"
  - "Decision: Worktree branches use worktree/ prefix (distinct from feature/ branches)"
  - "Decision: Fix loop excluded from worktree isolation (lightweight by design)"

patterns-established:
  - "Pattern: Optional features use pals.json config with false default and no-op fallthrough"

duration: 8min
started: 2026-03-13T22:30:00Z
completed: 2026-03-13T22:38:00Z
---

# Phase 37 Plan 01: Resilience & Isolation Summary

**Optional git worktree isolation for APPLY phase — config-driven, default off.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~8min |
| Started | 2026-03-13 |
| Completed | 2026-03-13 |
| Tasks | 1 completed |
| Files modified | 4 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Worktree defaults to off | Pass | pals.json `worktree_isolation: false`, apply-phase skips when false/absent |
| AC-2: Worktree creates isolated copy when enabled | Pass | setup_worktree step in apply-phase with `git worktree add` |
| AC-3: Worktree merge-back on transition | Pass | transition-phase step 0 checks for worktree, merges + cleans up |
| AC-4: Init offers worktree config | Pass | Question 3 added with default No |
| AC-5: AGENTS.md | Removed | Deferred to future interoperability milestone — duplicates CLAUDE.md |

## Accomplishments

- Added optional git worktree isolation to APPLY phase (Superpowers' 27K-star feature, now in PALS as opt-in)
- Created worktree lifecycle: create in apply → merge in transition → discard on failure
- All changes are additive — zero behavior change for existing users with default config

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `kernel/references/worktree-isolation.md` | Created | Reference doc: what, when, how, config, interactions (77 lines) |
| `kernel/workflows/apply-phase.md` | Modified | Added setup_worktree step between skills check and pre-apply hooks |
| `kernel/workflows/init-project.md` | Modified | Added worktree config question + pals.json worktree_isolation field |
| `kernel/workflows/transition-phase.md` | Modified | Added worktree merge-back logic before feature branch check |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Worktree isolation defaults to off | User requested optional; existing users unaffected | Config-driven, zero regression risk |
| worktree/ branch prefix | Distinct from feature/ branches to avoid confusion | Clear namespace separation |
| No worktree in fix loop | Fix loop is lightweight by design; worktree overhead contradicts fast-forward | Consistent with Phase 35 design |
| AGENTS.md deferred to interoperability milestone | Duplicates CLAUDE.md; convention not standardized yet | Removed from Phase 37 scope |

## Deviations from Plan

AGENTS.md (AC-5) removed post-execution — duplicates CLAUDE.md, deferred to future interoperability milestone. Template deleted, map-codebase generation step removed.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- Phase 37 is the LAST phase in v1.0 milestone
- All v1.0 phases complete (35: fix loop, 36: brownfield, 37: resilience)
- Ready to run `/paul:complete-milestone`

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 37-resilience-and-isolation, Plan: 01*
*Completed: 2026-03-13*
