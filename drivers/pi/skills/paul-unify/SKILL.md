---
name: paul-unify
description: "Reconcile plan vs actual results. Creates a SUMMARY.md documenting what was built, deviations, decisions, and lessons learned. Closes the PLAN-APPLY-UNIFY loop."
---

# PAUL Unify

Reconcile what was planned vs what was actually built.

## What This Does

Creates a SUMMARY.md that documents:
- What the plan intended
- What was actually built
- Deviations and why they happened
- Decisions made during execution
- Lessons learned
- Deferred issues for future phases

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`

2. Read the plan that was executed:
   - File: `.paul/phases/{NN}-{name}/{NN}-{plan}-PLAN.md`

3. Read the full workflow definition:
   - File: `../workflows/unify-phase.md`

4. Read the module registry (if it exists):
   - File: `../modules.yaml`
   - This drives pre-unify and post-unify hook dispatch for WALT, SKIP, RUBY

4. Follow the unify-phase workflow:
   - Compare plan tasks to actual results
   - Document deviations
   - Record decisions to STATE.md
   - Create SUMMARY.md alongside the PLAN.md
   - Check if phase is complete or needs more plans
   - Update loop position (close loop or ready for next plan)
   - If phase complete, trigger transition

## Key Behavior

- Always compare plan vs actual — do not just summarize
- Record decisions in STATE.md Accumulated Context
- Detect offline changes (files modified outside the plan)
- Create retrospective artifacts (lessons learned)
- If all phases in milestone done, suggest milestone completion

## Output

- `.paul/phases/{NN}-{name}/{NN}-{plan}-SUMMARY.md`
- STATE.md updated with loop closed
- Routes to next action (next plan, next phase, or milestone complete)
