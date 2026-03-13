---
phase: 35-fix-and-hotfix
plan: 01
subsystem: kernel
tags: [fix-loop, fast-forward, hotfix, retroactive-unify, compressed-loop, escape-hatch]

requires:
  - phase: 34-competitive-research
    provides: gap analysis identifying fix loop as #1 friction gap

provides:
  - /paul:fix command (3-mode fix entry point)
  - fix-loop workflow (standard/fast-forward/hotfix modes)
  - fix-types reference (classification guide + decision matrix)
  - retroactive UNIFY support in unify-phase.md

affects:
  - kernel workflows (unify-phase.md modified)
  - future module hooks (fix-loop dispatches post-apply/post-unify)

tech-stack:
  added: []
  patterns:
    - "Compressed loop: PLAN+APPLY+UNIFY in single workflow pass"
    - "Side-loop: fixes don't advance phase progression"
    - "Mode classification with auto-recommendation heuristics"
    - "Retroactive UNIFY: detect flag in STATE.md, generate SUMMARY from git history"

key-files:
  created:
    - kernel/commands/paul/fix.md
    - kernel/workflows/fix-loop.md
    - kernel/references/fix-types.md
  modified:
    - kernel/workflows/unify-phase.md

key-decisions:
  - "Decision: 3 fix modes (standard/fast-forward/hotfix) covering all ad-hoc scenarios"
  - "Decision: Fast-forward intentionally skips ALL hooks (zero overhead by design)"
  - "Decision: Fixes are side-loops — they don't advance phase progression"
  - "Decision: Retroactive UNIFY is an early branch in unify-phase.md, not a separate workflow"

patterns-established:
  - "Pattern: Side-loop fixes tracked in STATE.md Accumulated Context, not Loop Position"
  - "Pattern: Mode classification via signal detection (uncommitted changes, urgency keywords, file count)"
  - "Pattern: Retroactive documentation from git history when no plan exists"

duration: ~15min
started: 2026-03-13T20:00:00Z
completed: 2026-03-13T20:15:00Z
---

# Phase 35 Plan 01: Lightweight Fix & Hotfix Summary

**3-mode fix system (`/paul:fix`) closing the #1 competitive friction gap — standard compressed loop, zero-overhead fast-forward, and execute-first hotfix with retroactive UNIFY.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~15min |
| Tasks | 3 completed |
| Files created | 3 |
| Files modified | 1 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Fix Command Entry Point | Pass | fix.md with signal detection + mode recommendation |
| AC-2: Standard Fix Mode | Pass | Compressed loop: lightweight FIX.md → auto-execute → auto-SUMMARY |
| AC-3: Fast-Forward Mode | Pass | No plans, no hooks, no summaries — commit + one-line log |
| AC-4: Hotfix + Retroactive UNIFY | Pass | Execute first, flag STATE.md, UNIFY generates SUMMARY from git |
| AC-5: Fix Types Reference | Pass | Decision matrix, heuristics table, /paul:plan-fix comparison |

## Accomplishments

- Created `/paul:fix` command — direct entry point for ad-hoc fixes bypassing full PLAN ceremony
- Implemented 3 fix modes with auto-classification heuristics (uncommitted changes → hotfix, trivial keywords → fast-forward, default → standard)
- Added retroactive UNIFY to existing unify-phase.md as non-breaking early branch
- Established "side-loop" pattern: fixes tracked in STATE.md but don't advance phase progression

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `kernel/references/fix-types.md` | Created | Classification guide — 3 modes, decision matrix, heuristics, /plan-fix comparison |
| `kernel/commands/paul/fix.md` | Created | `/paul:fix` command — gather description, detect signals, classify, route to fix-loop |
| `kernel/workflows/fix-loop.md` | Created | Fix execution — standard (compressed loop), fast-forward (zero overhead), hotfix (execute first) |
| `kernel/workflows/unify-phase.md` | Modified | Added detect_retroactive + retroactive_unify steps as early branch |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| 3 fix modes | Covers all scenarios: structured (standard), trivial (ff), urgent (hotfix) | Users always have an appropriate fix path |
| Fast-forward skips ALL hooks | Zero overhead is the point — users accept no quality gates for trivial fixes | Clean separation: ceremony when it matters, none when it doesn't |
| Fixes are side-loops | Fixes shouldn't advance phase counters or trigger transitions | Main loop integrity preserved |
| Retroactive UNIFY via early branch | Keeps one unify workflow instead of two — detect flag, branch, or proceed normally | No workflow proliferation |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- Fix system complete — all 3 modes implemented and verified
- Kernel workflows extended without breaking existing behavior
- Phase 36 (Brownfield & Codebase Intelligence) can proceed independently

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 35-fix-and-hotfix, Plan: 01*
*Completed: 2026-03-13*
