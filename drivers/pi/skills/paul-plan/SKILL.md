---
name: paul-plan
description: "Create an executable plan for the current PALS phase. Reads project state, analyzes scope, and produces a structured PLAN.md with objectives, acceptance criteria, tasks, and verification steps."
---

# PAUL Plan

Create an executable PLAN.md for the current phase.

## What This Does

Produces a plan that contains everything needed for execution:
- Objective (goal, purpose, output)
- Acceptance criteria (Given/When/Then)
- Tasks with files, action, verify, and done criteria
- Boundaries (protected files, scope limits)
- Verification checklist

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`
   - File: `.paul/ROADMAP.md`
   - File: `.paul/PROJECT.md`

2. Read the full workflow definition:
   - File: `../workflows/plan-phase.md`

3. Read the plan template:
   - File: `../templates/PLAN.md`

4. Read the plan format reference:
   - File: `../references/plan-format.md`

5. Follow the plan-phase workflow:
   - Validate preconditions (loop ready for PLAN)
   - Identify which phase is next
   - Analyze scope and estimate tasks
   - Create PLAN.md in `.paul/phases/{NN}-{name}/`
   - Update STATE.md loop position to PLAN complete

## Key Behavior

- Read-only constraint: plan phase must not modify source files
- Target 2-3 tasks per plan
- Every task needs: files, action, verify, done
- Clarity test: could someone with no context execute this plan?
- If more than 3 tasks needed, split into multiple plans

## Output

- `.paul/phases/{NN}-{name}/{NN}-{plan}-PLAN.md`
- STATE.md updated with PLAN complete
- Ready for `/skill:paul-apply`
