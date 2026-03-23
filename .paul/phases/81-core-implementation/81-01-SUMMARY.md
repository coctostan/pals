---
phase: 81-core-implementation
plan: 01
completed: 2026-03-19T14:15:00-0400
duration: ~15 minutes
---

## Objective

Implement production CARL session boundary manager core logic in `drivers/pi/extensions/pals-hooks.ts` — command context stashing, phase-completion detection, context usage decision model, autonomous session creation + auto-resume, and mid-phase safety valve.

## What Was Built

| File | Purpose | Lines Added |
|------|---------|-------------|
| `drivers/pi/extensions/pals-hooks.ts` | CARL session boundary manager core logic | +173 |

### Additions breakdown

| Component | Description |
|-----------|-------------|
| 4 constants | `CARL_NEW_SESSION_TIMEOUT_MS`, `CARL_DEFAULT_CONTINUE_THRESHOLD` (0.4), `CARL_DEFAULT_SAFETY_CEILING` (0.8), `CARL_DEFAULT_STRATEGY` ("phase-boundary") |
| 2 types | `CarlConfig` (strategy + thresholds), `CarlState` (stashedCmdCtx + dispatching + previousLoopSignature + pauseAtNextBoundary) |
| `loadCarlConfig()` | Reads pals.json `modules.carl` section with safe defaults; tries `.paul/pals.json` then `pals.json` |
| `extractLoopSignature()` | Extracts ✓/○ marks from state.loop as compact string (e.g., "✓✓✓") |
| `buildCarlBootstrapPrompt()` | Builds the markdown bootstrap message injected into fresh sessions |
| `carlCreateFreshSession()` | Reentrancy-guarded, timeout-protected session creation via stashed ExtensionCommandContext + auto-resume via `pi.sendUserMessage("/skill:paul-resume")` |
| `carlEvaluatePhaseCompletion()` | Detects loop-complete state via signature comparison, computes context ratio, applies decision model |
| `carlMonitorSafetyCeiling()` | Monitors context usage in `turn_end`, sets `pauseAtNextBoundary` flag at safety ceiling |
| Command stashing | Every `/paul-*` command handler now stashes `ctx` into `carlState.stashedCmdCtx` before routing |
| Session start seeding | `session_start` seeds `previousLoopSignature` to prevent spurious session creation on resume |
| Agent end wiring | `agent_end` calls `carlEvaluatePhaseCompletion` + checks `pauseAtNextBoundary` for safety breaks |
| Turn end wiring | `turn_end` calls `carlMonitorSafetyCeiling` after `syncLifecycleUi` |

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Command Context Stashing | ✅ PASS | `carlState.stashedCmdCtx = ctx;` in command registration loop |
| AC-2 | Phase Completion Detection | ✅ PASS | `carlEvaluatePhaseCompletion` compares `previousLoopSignature` against current, triggers on "✓✓✓" |
| AC-3 | Session Boundary Decision Model | ✅ PASS | Ratio computed from `ctx.getContextUsage()` / `ctx.model.contextWindow`; compared against `continue_threshold`; "always-fresh" forces break |
| AC-4 | Mid-Phase Safety Valve | ✅ PASS | `carlMonitorSafetyCeiling` in `turn_end` sets `pauseAtNextBoundary`; `agent_end` consumes flag and triggers session break |
| AC-5 | Loop Signature Seeding | ✅ PASS | `session_start` calls `extractLoopSignature(state)` into `carlState.previousLoopSignature` |

## Verification Results

| Check | Expected | Actual |
|-------|----------|--------|
| `grep -c "CARL" pals-hooks.ts` | 15+ | 20 |
| CARL_DEFAULT constants | 3 | 3 (threshold, ceiling, strategy) |
| CarlConfig + CarlState types | 2 | 2 |
| Core functions (5) | 5 | 5 (loadCarlConfig, extractLoopSignature, buildCarlBootstrapPrompt + 3 closure fns) |
| `pi.on(` count | 5 | 5 |
| COMMANDS array entries | 11 | 11 |
| `registerQuickActionShortcut(` count | 5 | 5 |
| `export default function palsHooks` | present | present |
| Brace balance | balanced | 272/272 ✓ |
| Paren balance | balanced | 614/614 ✓ |
| All existing helpers preserved | yes | yes (parsePalsState, readFileOr, detectGuidedWorkflowMoment, etc.) |

## Deviations

None. All three tasks executed exactly as planned. No unexpected files modified, no approach changes.

## Key Patterns/Decisions

| Decision | Rationale |
|----------|-----------|
| CARL functions as closure members inside `palsHooks()` | Per Phase 77 decision — shares `pi`, activation state, guided-workflow scope without module-level exports |
| `loadCarlConfig` reads `modules.carl` path | Consistent with Phase 78 decision to use existing module config pattern |
| Bootstrap prompt uses compact markdown format | Matches carl-pi-design.md spec; minimal but sufficient for `/skill:paul-resume` to continue |
| No `pi` parameter on `carlCreateFreshSession` (captured from closure) | Avoids passing `pi` through every call; `pi` is already in closure scope |

## Next Phase

Phase 82: Config & Integration — pals.json carl config section with defaults, pause/resume wiring, bootstrap message format, auto-resume chain.
