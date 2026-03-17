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
- Review routing before APPLY

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`
   - File: `.paul/ROADMAP.md`
   - File: `.paul/PROJECT.md`
   - File: `.paul/PRD.md` (selectively, if present and deeper product framing / deferred scope / assumptions / open questions matter)
2. Read the full workflow definition:
   - File: `../workflows/plan-phase.md`
3. Read the plan template:
   - File: `../templates/PLAN.md`
4. Read the plan format reference:
   - File: `../references/plan-format.md`
5. Follow the plan-phase workflow:
   - Validate preconditions (loop ready for PLAN)
   - Identify which phase is next
   - Reuse discussion handoff metadata when available
   - Apply project default collaboration with per-run override
   - Distinguish exploratory vs direct-requirements mode
   - Treat `PROJECT.md` as the hot-path brief and `PRD.md` as selective deeper context
   - Create PLAN.md in `.paul/phases/{NN}-{name}/`
   - Offer Quick recap / Detailed recap / Full plan / No review needed
   - Update STATE.md loop position to PLAN complete

## Key Behavior

- Read-only constraint: plan phase must not modify source files
- Target 2-3 tasks per plan
- Every task needs: files, action, verify, done
- Clarity test: could someone with no context execute this plan?
- If more than 3 tasks needed, split into multiple plans
- Review menu happens before APPLY routing, not after execution begins
- Not every workflow should read both artifacts; load `PRD.md` only when it materially helps planning

## Output

- `.paul/phases/{NN}-{name}/{NN}-{plan}-PLAN.md`
- STATE.md updated with PLAN complete
- Ready for `/skill:paul-apply`
