---
phase: 83-validation-docs
plan: hotfix
type: hotfix
completed: 2026-03-21T19:13:47-0400
duration: ~10 minutes
commit: 2ceeed0
---

## Hotfix Summary

**Issue:** Add token-based CARL session thresholds so phase-boundary rollover can be driven by absolute token counts instead of percentages.
**Mode:** Hotfix (retroactive UNIFY)
**Commit:** `2ceeed0`

## Context

The existing CARL behavior used ratio-only thresholds (`tokens / contextWindow`). That works reasonably on smaller context windows, but it becomes too permissive on 1M-token models. The requested behavior was to keep CARL phase-boundary rollover and safety rollover anchored to practical absolute thresholds instead: roughly 60k tokens for normal phase completion and 120k tokens for the safety boundary.

## What Was Built

| File | Purpose | Change |
|------|---------|--------|
| `drivers/pi/extensions/pals-hooks.ts` | CARL runtime logic and config parsing | Added optional `continue_threshold_tokens` / `safety_ceiling_tokens`, token-aware threshold checks, and token+percent notifications |
| `drivers/pi/extensions/README.md` | Pi extension operator docs | Documented token-threshold behavior, fallback semantics, and example config |
| `pals.json` | Project CARL config | Set `continue_threshold_tokens: 60000` and `safety_ceiling_tokens: 120000` |
| `.paul/SPECIAL-FLOWS.md` | PALS special-flow reference | Updated CARL config description to include token-based settings |

## Files Changed

| File | Change |
|------|--------|
| `.paul/SPECIAL-FLOWS.md` | 2-line config reference update |
| `drivers/pi/extensions/README.md` | 16-line doc update for token threshold support |
| `drivers/pi/extensions/pals-hooks.ts` | 41-line implementation update for token-aware thresholds |
| `pals.json` | 4-line config update with 60k/120k defaults |

## Verification Results

| Check | Expected | Actual |
|-------|----------|--------|
| `npx -y esbuild drivers/pi/extensions/pals-hooks.ts --bundle --platform=node --format=cjs --outfile=/tmp/pals-hooks-check.js --external:@mariozechner/pi-tui` | Bundle succeeds | ✅ PASS |
| Config path | CARL reads token thresholds from `modules.carl` | ✅ PASS |
| Fallback behavior | Ratio thresholds still work when token thresholds are unset | ✅ PASS |
| Project defaults | 60k/120k token thresholds present in `pals.json` | ✅ PASS |

## Deviations

| Type | Impact | Notes |
|------|--------|-------|
| Process deviation | Minor | Change was implemented first, then reconciled through retroactive `/paul-fix` hotfix + `/paul-unify` |

## Key Patterns/Decisions

| Decision | Rationale |
|----------|-----------|
| Support both token and ratio thresholds | Absolute token thresholds are more stable across very large context windows, while ratio thresholds remain a sensible fallback |
| Keep ratio settings as fallback instead of replacing them | Preserves backward compatibility for existing CARL configs and smaller-window models |
| Set project defaults to 60k / 120k | Aligns CARL rollover behavior with practical operating limits on 1M-token models |

## Result

Hotfix applied and documented retroactively. The pending retroactive UNIFY flag can now be cleared, and normal milestone work can resume.
