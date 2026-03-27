---
name: paul-apply
description: "Execute an approved PALS plan. Runs tasks sequentially, verifies each step, handles checkpoints, and records results for reconciliation."
---

# PAUL Apply

Execute an approved PLAN.md by running its tasks.

## What This Does

Reads the current plan and executes each task:
- Runs eligible checkpoint-free auto tasks inline or through the repo-local `pals-implementer`
- Keeps official verify steps, module enforcement, fallback judgment, and `.paul/*` lifecycle writes in the parent
- Pauses at checkpoints for user input
- Records deviations from plan
- Updates project state on completion

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md` (find current plan path)

2. Read the plan to execute:
   - File: `.paul/phases/{NN}-{name}/{NN}-{plan}-PLAN.md`

3. Read the full workflow definition:
   - File: `../workflows/apply-phase.md`

4. Read the module registry (MUST — installed at ../modules.yaml):
   - File: `../modules.yaml`
   - This drives pre-apply, post-task, and post-apply hook dispatch for TODD, WALT, DEAN, DOCS, IRIS, SKIP, DAVE

5. Follow the apply-phase workflow:
   - Confirm user has approved the plan
   - Determine whether each eligible auto task may use parent-controlled `pals-implementer` delegation
   - Fall back to inline APPLY whenever delegation is unavailable, ambiguous, or non-equivalent
   - Run the official verify step for every task in the parent
   - Handle checkpoints (decision, human-verify, human-action)
   - Track deviations from plan
   - Update STATE.md loop position to APPLY complete

## Key Behavior

- Never start without explicit plan approval
- Delegated APPLY is task-bounded only; the parent keeps verification, module gates, fallback judgment, and `.paul/*` authority
- Every task MUST have its verify step run
- Respect boundaries (DO NOT CHANGE protected files)
- On failure: retry up to 2 times, then escalate
- Check for divergence after each task
- Stop at checkpoints and wait for user response

## Output

- Modified files as specified in the plan
- STATE.md updated with APPLY complete
- Ready for `/skill:paul-unify`
