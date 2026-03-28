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
- Starts only after explicit user approval of the selected plan.
- `pals-implementer` delegation is optional, bounded to eligible auto tasks, and never changes lifecycle ownership.
- The parent APPLY flow keeps official verify steps, module enforcement, checkpoints, fallback judgment, and `.paul/*` state/report writes.
- If delegated execution is unavailable, ambiguous, or non-equivalent, fall back to inline APPLY.
- Successful execution leaves the loop ready for `/skill:paul-unify`.
