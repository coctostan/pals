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

## Command-local notes
- Use the shared planning model: `planning.default_collaboration`, optional per-run override, and low / medium / high collaboration depth.
- Distinguish `exploratory` planning from `direct-requirements` planning.
- Keep `PROJECT.md` on the hot path and read `PRD.md` only when deeper framing materially helps.
- Offer the shared 4-option review menu before finalizing the plan for APPLY.
- The wrapper stays thin; the shared workflow owns plan structure, module dispatch, and lifecycle rules.
