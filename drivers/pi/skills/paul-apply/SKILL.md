---
name: paul-apply
description: "Execute an approved PALS plan. Runs tasks sequentially, verifies each step, handles checkpoints, and records results for reconciliation."
---

# PAUL Apply

Execute an approved PLAN.md by running its tasks.

## What This Does

Reads the current plan and executes each task:
- Runs auto tasks (create/modify files, run commands)
- Pauses at checkpoints for user input
- Verifies each task with its verify step
- Records deviations from plan
- Updates project state on completion

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md` (find current plan path)

2. Read the plan to execute:
   - File: `.paul/phases/{NN}-{name}/{NN}-{plan}-PLAN.md`

3. Read the full workflow definition:
   - File: `../workflows/apply-phase.md`

4. Read the module registry (if it exists):
   - File: `../modules.yaml`
   - This drives pre-apply, post-task, and post-apply hook dispatch for TODD, WALT, DEAN, DOCS, IRIS, SKIP, DAVE

4. Follow the apply-phase workflow:
   - Confirm user has approved the plan
   - Execute tasks in order
   - Run verification for each task
   - Handle checkpoints (decision, human-verify, human-action)
   - Track deviations from plan
   - Update STATE.md loop position to APPLY complete

## Key Behavior

- Never start without explicit plan approval
- Every task MUST have its verify step run
- Respect boundaries (DO NOT CHANGE protected files)
- On failure: retry up to 2 times, then escalate
- Check for divergence after each task
- Stop at checkpoints and wait for user response

## Output

- Modified files as specified in the plan
- STATE.md updated with APPLY complete
- Ready for `/skill:paul-unify`
