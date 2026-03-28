---
name: paul-unify
description: "Reconcile plan vs actual results. Creates a SUMMARY.md documenting what was built, deviations, decisions, and lessons learned. Closes the PLAN-APPLY-UNIFY loop."
---

# PAUL Unify

Close the loop by reconciling plan vs actual execution.

## Canonical workflow
- `../workflows/unify-phase.md`
- `../modules.yaml`

## Command-local notes
- Compare the executed plan with the actual results and write `SUMMARY.md` beside the plan.
- Record deviations, execution decisions, and lessons learned for future context.
- Update `STATE.md`, refresh `ROADMAP.md` when phase/milestone state changes, and run shared post-unify module/reporting steps.
- A successful unify closes the current loop and routes to the next planning decision.
