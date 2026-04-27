---
name: paul-apply
description: "Execute an approved PALS plan. Runs tasks sequentially, verifies each step, handles checkpoints, and records results for reconciliation."
---

# PAUL Apply

Execute an approved PLAN.md.

## Canonical workflow
- `../workflows/apply-phase.md`
- `../modules.yaml`

## Command-local notes
- Start only after explicit user approval of the selected plan.
- `pals-implementer` delegation is optional for bounded work, including single-task work the parent can still verify.
- Parent APPLY owns official verify steps, module enforcement, fallback, and `.paul/*` writes; fall back inline when delegation is unavailable, ambiguous, exploratory, or non-equivalent.
- Successful execution routes to `/skill:paul-unify`.