---
name: paul-plan
description: "Create an executable plan for the current PALS phase. Reads project state, analyzes scope, and produces a structured PLAN.md with objectives, acceptance criteria, tasks, and verification steps."
---

# PAUL Plan

Create the next executable PLAN.md.

## Canonical workflow
- `../workflows/plan-phase.md`
- `../templates/PLAN.md`
- `../references/plan-format.md`
- `../modules.yaml`

## Default output
- Concise by default: state plan path, goal, key tasks, preserved constraints, and one apply decision.
- Expand for blockers, module warnings, review choices, validation ambiguity, or user request.

## Command-local notes
- Use `planning.default_collaboration` with low / medium / high override support.
- Distinguish exploratory vs direct-requirements planning.
- Keep `PROJECT.md` hot; read `PRD.md` only when materially useful.
- Offer the shared 4-option review menu before APPLY routing.
