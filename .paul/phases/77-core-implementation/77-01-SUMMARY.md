---
phase: 77-core-implementation
plan: 01
subsystem: extensions
tags: [carl, session-boundary, phase-detection, context-ratio, fresh-session, auto-resume, safety-valve, pals-hooks]

requires:
  - phase: 76-01
    provides: "Validated API patterns (getContextUsage, newSession, sendUserMessage) and GSD2 safety patterns"
provides:
  - "Production CARL session boundary manager in pals-hooks.ts"
  - "Phase-completion detection via STATE.md loop signature changes"
  - "Context usage ratio decision model with configurable thresholds"
  - "Autonomous session creation + bootstrap + auto-resume chain"
  - "Mid-phase safety valve monitoring in turn_end"
  - "loadCarlConfig helper reading pals.json carl section"
affects:
  - "Phase 78 (Integration & Configuration) — needs pals.json carl config creation and pause/resume wiring"
  - "Phase 79 (Validation & Documentation) — needs end-to-end testing and threshold calibration"

tech-stack:
  added: []
  patterns:
    - "Loop signature extraction and change detection for phase-completion sensing"
    - "Context ratio computation via ctx.getContextUsage() / ctx.model.contextWindow"
    - "CARL state object (stashedCmdCtx, dispatching, previousLoopSignature, pauseAtNextBoundary) scoped to palsHooks closure"
    - "Config-driven session strategy: phase-boundary (default), always-fresh, manual"

key-files:
  modified:
    - "/Users/maxwellnewman/.pi/agent/extensions/pals-hooks.ts"

key-decisions:
  - "Decision: CARL logic lives inside palsHooks() closure, not as a separate module"
  - "Decision: Loop signature ('✓✓✓') change detection avoids false positives from repeated agent_end calls"
  - "Decision: Session start resets CARL state and seeds loop signature to prevent stale detection"

patterns-established:
  - "Pattern: carlState object groups all CARL mutable state in one place"
  - "Pattern: carlEvaluatePhaseCompletion runs after maybePresentGuidedWorkflow in agent_end"
  - "Pattern: carlMonitorSafetyCeiling runs in turn_end; flag consumed in agent_end"

duration: ~20min
started: 2026-03-18T16:20:00-0400
completed: 2026-03-18T16:45:00-0400
---

# Phase 77 Plan 01: Core Implementation Summary

**Production CARL session boundary manager implemented in pals-hooks.ts — phase-completion detection, configurable decision model, autonomous session creation with bootstrap and auto-resume, plus mid-phase safety valve.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~20min |
| Started | 2026-03-18T16:20:00-0400 |
| Completed | 2026-03-18T16:45:00-0400 |
| Tasks | 2 completed |
| Files modified | 1 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Command Context Stashing | Pass | Every /paul-* command handler now stashes ctx into carlState.stashedCmdCtx before routing |
| AC-2: Phase Completion Detection | Pass | agent_end extracts loop signature, compares against previous, triggers evaluation on ✓✓✓ transition |
| AC-3: Session Boundary Decision Model | Pass | Reads pals.json carl config, computes ratio, applies phase-boundary/always-fresh/manual strategy |

## Accomplishments

- Implemented 3 CARL core functions: `carlCreateFreshSession`, `carlEvaluatePhaseCompletion`, `carlMonitorSafetyCeiling`
- Added 4 helper functions: `loadCarlConfig`, `extractLoopSignature`, `isLoopComplete`, `computeContextRatio`
- Added 4 CARL constants: `CARL_DEFAULT_CONTINUE_THRESHOLD` (0.4), `CARL_DEFAULT_SAFETY_CEILING` (0.8), `CARL_DEFAULT_STRATEGY` ("phase-boundary"), `CARL_DEFAULT_CONTEXT_WINDOW` (200K)
- Added `CarlStrategy`, `CarlConfig`, and `CarlState` types
- Wired command context stashing into existing command registration loop (1 line addition)
- Extended session_start with CARL state reset and loop signature seeding
- Extended turn_end with safety ceiling monitoring
- Extended agent_end with phase-completion detection and safety flag consumption
- Removed Phase 76 test command cleanly (~100 lines removed)
- TypeScript compiles with zero errors; all 5 handlers, 11 commands, 5 shortcuts preserved

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `pals-hooks.ts` | Modified (+~120 lines CARL, -~100 lines test) | Production CARL session boundary manager |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| CARL logic inside palsHooks() closure | Shares pi reference, activation state, and guided workflow infrastructure without module-level exports | Keeps CARL self-contained within the existing extension pattern |
| Loop signature change detection | Prevents false positives from repeated agent_end calls within the same loop state | Ensures CARL only triggers once per actual phase completion |
| session_start seeds previousLoopSignature | Prevents CARL from triggering on the first agent_end after session start when loop is already complete | Avoids spurious session creation on resume |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- CARL core logic is complete and structurally verified
- Config loading reads pals.json but gracefully defaults when absent
- All Phase 78 work (config creation, pause/resume wiring, dead file removal) can build on this

**Concerns:**
- Stashed command context lifetime across agent_end is implemented but not yet empirically tested in a real phase-completion scenario (will be validated during Phase 79 end-to-end testing)
- pals.json does not yet have a `carl` section — Phase 78 adds it

**Blockers:**
- None

---
*Phase: 77-core-implementation, Plan: 01*
*Completed: 2026-03-18*
