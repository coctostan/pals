---
name: paul-milestone
description: "Manage PALS milestones. Creates new milestones with phase structure, or completes the current milestone. Detects intent from project state."
---

# PAUL Milestone

Create or complete a milestone.

## Canonical workflows
- `../workflows/create-milestone.md`
- `../workflows/complete-milestone.md`

## Default output
- Concise by default: identify create/complete mode, key evidence, and one next action.
- Expand for milestone review choices, blockers, validation failures, or user request.

## Command-local notes
- Detect create vs complete mode from project state and user intent.
- Reuse `.paul/MILESTONE-CONTEXT.md` when present.
- Preserve collaboration/review behavior before writes; verify closure before completion.