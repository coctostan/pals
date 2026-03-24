# Two-Step Dispatch — PROVEN ✅

**Date:** 2026-03-24
**Model:** Kimi for Coding K2.5

## Test Setup
Deliberately introduced:
- Complex function (6 params, 60 lines) → RUBY debt + IRIS smells
- Unused import → WALT lint block
- Code change without README update → DOCS drift
- Decision in STATE.md → SKIP extraction

## Results

### STEP 1: Advisory Module Dispatch ✅ ALL OUTPUT VISIBLE
```
IRIS (p250):  Code smells detected — god-function, 6 parameters
RUBY (p300):  Debt flags raised — complexity, line count
DOCS (p250):  Drift warning — tool.ts changed, README not updated
SKIP (p300):  Decision extracted from STATE.md
```

### STEP 2: Enforcement Module Dispatch ⛔ BLOCK
```
TODD (p100):  26/26 tests passing ✅
WALT (p100):  ⛔ BLOCK — lint warnings (unused import)
```

### KEY RESULT
Advisory output WAS visible before enforcement block — **the structural two-step fix works where the prose "DO NOT stop" fix failed.**

## Comparison

| Approach | Advisory visible when WALT blocks? |
|----------|-----------------------------------|
| Original (single loop) | ❌ No — dispatch halted |
| Fix 1: Prose "DO NOT stop" | ❌ No — model ignored prose |
| **Fix 2: Two explicit steps** | **✅ Yes — structurally impossible to suppress** |

## Lesson Learned
Models follow **structure** (separate `<step>` blocks), not **prose qualifiers** ("DO NOT stop"). When you need guaranteed ordering, use separate named steps instead of conditional logic within a single loop.
