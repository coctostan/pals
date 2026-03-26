---
phase: 133-greenfield-fast-path
plan: 01
completed: 2026-03-26
duration: ~12 minutes
---

## Objective
Reduce greenfield init to ~8 questions, add explicit default milestone, and improve module question with grouped descriptions for brownfield.

## What Was Built

| File | Purpose | Change |
|------|---------|--------|
| kernel/workflows/init-project.md | Init workflow | Greenfield fast path, milestone, module groups |

**Net change:** 854 → 883 lines (+29, from grouped module descriptions for brownfield)

### Task 1: Greenfield Fast Path (~8 Questions)
- `determine_planning_posture`: greenfield defaults silently to direct-requirements/medium (no question)
- `gather_identity_and_framing`: merged "what are you building" + "what problem" into one question for greenfield; brownfield keeps both as separate questions
- `gather_constraints_questions`: greenfield gets simplified optional prompt ("Any constraints? Enter to skip"); brownfield keeps full 6-field capture
- `configure_modules`: greenfield skips entirely (all enabled, silent default)

**Greenfield question flow (8 interactions):**
1. What are you building + why? (merged)
2. Who are the primary users?
3. Must-have vs deferred?
4. Constraints? (optional, Enter to skip)
5. Project name confirm
6. GitHub repo?
7. Git workflow? (only if GitHub)
8. Confirm and create

### Task 2: Explicit Default Milestone
- `create_roadmap_md`: added comment explaining v0.1 is explicitly created during init
- `create_state_md`: milestone reference shows "(created during init)"
- `confirm_and_route`: added milestone line with customize note

### Task 3: Module Question Improvement
- Greenfield: silent "All 18 modules enabled by default" — no question asked
- Brownfield: grouped modules by concern (Quality & Testing, Security & Dependencies, Code Quality, Architecture & APIs, UI & Accessibility, Data & Infrastructure, Observability & Resilience, Privacy & Session, Knowledge)
- Toggle logic unchanged — numbers still work

## Acceptance Criteria Results

| AC | Description | Status |
|----|-------------|--------|
| AC-1 | Greenfield init asks ~8 questions | ✅ PASS |
| AC-2 | Init creates explicit default milestone | ✅ PASS |
| AC-3 | Module question improved (skip greenfield, groups for brownfield) | ✅ PASS |

## Verification Results
- Greenfield question count: 8 ✓
- Brownfield retains all original questions ✓
- `determine_planning_posture`: greenfield defaults silently ✓
- `gather_identity_and_framing`: merged for greenfield, split for brownfield ✓
- `gather_constraints_questions`: simplified for greenfield ✓
- `configure_modules`: greenfield skips, brownfield has groups ✓
- Milestone referenced in ROADMAP, STATE, and confirmation ✓
- No duplicate step names ✓

## Module Execution Reports

| Module | Hook | Result |
|--------|------|--------|
| IRIS | post-apply | 0 concerns (+29 lines from descriptions, acceptable) |
| DOCS | post-apply | 0 drift |
| RUBY | post-apply | 0 debt |
| SKIP | post-apply | 1 decision captured |

## Deviations
- **Minor:** `gather_users_and_needs` step was accidentally removed during the identity/problem merge edit. Detected during verification and restored immediately. No impact on final result.

## Key Patterns/Decisions
- Greenfield/brownfield branching is step-level (not separate workflows) — keeps one file, reduces maintenance
- Module grouping by concern makes the 18-module list scannable without reducing module count
- Default milestone eliminates the ambiguity of implicit milestone creation

## Next Phase
Phase 134: Quick Mode + Validation (Item 13 + E2E test)
