---
phase: 40-testing-tdd
plan: 01
subsystem: modules
tags: [competitive-research, testing, tdd, todd, frameworks, test-quality, deep-dive]

requires:
  - phase: 39-execution-deep-dive
    provides: research methodology (parallel subagents), framework coverage list

provides:
  - testing-research.md with 12 frameworks analyzed across 7 testing dimensions
  - 6 concrete improvements to TODD module files (anti-pattern injection, failure classification, contract guard, reflection loop, structural coverage, quality heuristics)
  - Adopt/adapt/reject decision table for 18 candidate techniques

affects:
  - Phase 41 quality & validation deep dive (WALT improvements)
  - Phase 42 UNIFY & continuity deep dive
  - All future TDD execution via improved TODD references

tech-stack:
  added: []
  patterns:
    - "Anti-pattern injection: load test anti-patterns contextually during RED phase"
    - "Failure classification: CORRECT vs WRONG failure in RED phase verification"
    - "Contract guard: explicit rule against modifying tests to match implementation"
    - "Reflection loop: pipe test output for LLM diagnosis during GREEN retries"
    - "Structural coverage advisory: check test file exists for modified source files"
    - "Test quality heuristics: assertion density, behavior vs impl, edge cases, mock hygiene, isolation"

key-files:
  created:
    - .paul/phases/40-testing-tdd/testing-research.md
  modified:
    - modules/todd/references/tdd-execution.md
    - modules/todd/references/tdd.md
    - modules/todd/references/tdd-detection.md

key-decisions:
  - "Decision: Adopt anti-pattern injection from Superpowers — prevents test quality issues at creation time"
  - "Decision: Adopt 'failing for the right reason' from SWE-agent/Superpowers — strengthens RED phase validation"
  - "Decision: Adopt contract guard from Cline anti-pattern — explicit rule against weakening tests"
  - "Decision: Adapt reflection loop from Aider — test output diagnosis with PALS's 2-retry bound"
  - "Decision: Adapt structural coverage from Continue.dev — advisory signal, not blocking"
  - "Decision: Adapt test quality heuristics from BMAD — advisory scoring dimensions"
  - "Decision: Reject 10 techniques (cross-agent, recursive debug, CI auto-fix, delete-before-test, surrogate patches, fleet execution, multi-hypothesis, dual-agent, risk-based, browser E2E)"

patterns-established:
  - "Pattern: Research phases use parallel subagents (4 batches of 3 frameworks)"
  - "Pattern: Every competitive finding gets adopt/adapt/reject with rationale"
  - "Pattern: Improvements merge into existing content, not added as new files"

duration: ~20min
started: 2026-03-14T00:30:00Z
completed: 2026-03-14T00:50:00Z
---

# Phase 40 Plan 01: Testing & TDD Deep Dive Summary

**Deep competitive research across 12 frameworks' testing mechanics — 6 improvements shipped to TODD module files covering test quality, failure diagnosis, and structural coverage.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~20min |
| Tasks | 3 completed (1 research, 1 checkpoint, 1 implementation) |
| Frameworks researched | 12 |
| Research subagents | 4 (parallel batches of 3) |
| Files created | 1 |
| Files modified | 3 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Research Breadth | Pass | 12 frameworks analyzed (Aider, Superpowers, GPT Pilot, SWE-agent, OpenHands, Devin, OpenSpec, BMAD, MetaGPT, Cursor, Cline, Continue.dev) |
| AC-2: Research Depth | Pass | All 7 dimensions covered per framework with specific techniques and source citations |
| AC-3: Adopt/Adapt/Reject Decisions | Pass | All 18 candidate techniques have decisions with rationale in decision table |
| AC-4: TODD Module Improvements | Pass | 3 reference files improved; RED/GREEN/REFACTOR cycle preserved and strengthened |
| AC-5: Coverage & Test Quality Gaps | Pass | Structural coverage advisory added; test quality heuristics section added |

## Accomplishments

- Researched 12 frameworks across 7 testing dimensions using 4 parallel subagent batches
- Identified 18 candidate techniques, decided: 3 adopt, 3 adapt, 10 reject, 2 already-adopted
- Implemented 6 improvements across 3 TODD reference files (all within 150-line budget)

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `.paul/phases/40-testing-tdd/testing-research.md` | Created | 12-framework research with comparison matrices and decision table |
| `modules/todd/references/tdd-execution.md` | Modified | Anti-pattern injection in RED, failure classification, contract guard in GREEN, reflection loop, enhanced anti-patterns (89→98 lines) |
| `modules/todd/references/tdd.md` | Modified | Test quality heuristics section: assertion density, behavior vs impl, edge cases, mock hygiene, isolation (83→92 lines) |
| `modules/todd/references/tdd-detection.md` | Modified | Structural coverage advisory section for execute-type plans (119→139 lines) |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Adopt anti-pattern injection (Superpowers) | Prevents test quality issues at creation time by loading awareness during RED | execute_red loads anti-pattern checklist |
| Adopt failure classification (SWE-agent/Superpowers) | Distinguishes CORRECT vs WRONG failure — missing impl vs syntax/import errors | execute_red classifies failure reason explicitly |
| Adopt contract guard (Cline anti-pattern) | Explicit rule prevents agents from weakening tests to match broken implementation | execute_green has CONTRACT RULE block |
| Adapt reflection loop (Aider) | Test output piped for LLM diagnosis, using PALS's 2-retry bound (not Aider's 3) | execute_green reads test output for diagnosis |
| Adapt structural coverage (Continue.dev) | Advisory signal: test file exists for modified source? Not blocking. | tdd-detection advisory during pre-apply |
| Adapt test quality heuristics (BMAD) | Advisory dimensions: assertion density, behavior vs impl, edge cases, mock hygiene | tdd.md quality heuristics section |
| Reject 10 techniques | Cross-agent (multi-agent), recursive debug (over-complex), CI auto-fix (pre-CI), delete-before-test (too aggressive), surrogate patches (too complex), fleet execution (multi-instance), multi-hypothesis (IDE-specific), dual-agent (single-agent), risk-based (adds complexity), browser E2E (platform-specific) | No unnecessary complexity |

## Deviations from Plan

None — plan executed as written. User chose "review-findings" at checkpoint, approved all recommendations.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- TODD module improved — Phase 41 (Quality & Validation Deep Dive) can proceed
- Research methodology proven across three phases (38, 39, 40)

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 40-testing-tdd, Plan: 01*
*Completed: 2026-03-14*
