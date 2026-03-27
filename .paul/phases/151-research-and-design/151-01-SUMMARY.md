---
phase: 151-research-and-design
plan: 01
completed: 2026-03-27T00:00:00Z
---

# Phase 151 Plan 01: Research & Design — Summary

## Objective
Design the REV code review module: prompt structure, module interface, config schema, subagent dispatch, UX, and PR-level hook.

## What Was Built

| File | Change | Lines |
|------|--------|-------|
| `.paul/phases/151-research-and-design/rev-design.md` | New file. 7-section design doc covering review prompt (8 dimensions), module interface, IRIS bug fix, pals.json schema, Agent() dispatch pattern, /paul:review UX, and Phase 152 roadmap. | 456 lines |

## Acceptance Criteria Results

| AC | Result | Evidence |
|----|--------|----------|
| AC-1: Review Prompt Designed | ✅ PASS | 8 dimensions documented (correctness, edge cases, naming, architecture, performance, security, tests, rollback). Context assembly table. Output format with severity levels. Full prompt template with placeholders. |
| AC-2: Module Interface Defined | ✅ PASS | module.yaml designed with on-demand hook (no lifecycle hooks). Dependency detection flow for pi-subagents. Graceful degradation (in-session fallback). IRIS comparison table. |
| AC-3: Config Schema Decided | ✅ PASS | Exact JSON: enabled, description, model, pr_review, pr_review_block_on_critical. Model resolution order documented (pals.json → agent .md → session default). |
| AC-4: Dispatch Pattern Documented | ✅ PASS | Agent() call with foreground mode, model override. 10-step prompt assembly flow. Error handling table (5 scenarios). |
| AC-5: UX Designed | ✅ PASS | /paul:review 4-option scope flow. Merge gate integration as step 3 (between CI and reviews). 5-step merge gate display. Skill structure defined. |

## Verification Results

```
7 main sections present ✓
8 review dimensions documented ✓
pals.json JSON schema with exact structure ✓
Agent() call examples (5 references) ✓
/paul:review UX flow (9 references) ✓
Phase 152 roadmap: 7 tasks, 2 plans ✓
IRIS bug fix documented ✓
No source files modified ✓
```

## Key Decisions

| Decision | Rationale |
|----------|-----------|
| REV has NO lifecycle hooks (on-demand + PR-level only) | IRIS handles post-apply. REV is expensive — should be deliberate, not automatic. |
| Always foreground mode for Agent() dispatch | Both on-demand and merge gate need the result before proceeding. |
| model field in pals.json is nullable | null = use agent .md default. Allows user control at both PALS and pi-subagents layers. |
| pr_review defaults to false | Opt-in for PR-level review. On-demand is always available. |
| Remove `any` from IRIS grep entirely | TypeScript any detection belongs in ESLint, not grep. False positive rate is unacceptable. |
| In-session fallback as degraded mode | If pi-subagents missing, user can still get a review — just without isolation benefit. |

## Module Execution Reports

All modules correctly skipped — research phase, .paul/ artifacts only.

## Deviations
None.

## Next
Phase 152: Core Implementation — build the REV module, fix IRIS, wire /paul:review + merge gate.
