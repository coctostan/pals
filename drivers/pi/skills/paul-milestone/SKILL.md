---
name: paul-milestone
description: "Manage PALS milestones. Creates new milestones with phase structure, or completes the current milestone. Detects intent from project state."
---

# PAUL Milestone

Create or complete a milestone.

## Canonical workflows
- `../workflows/create-milestone.md`
- `../workflows/complete-milestone.md`

## Command-local notes
- Detect create vs complete mode from project state and user intent.
- Reuse `.paul/MILESTONE-CONTEXT.md` when a prior discuss step prepared milestone context.
- Create mode preserves the shared collaboration and review behavior before writing milestone structure.
- Complete mode verifies the milestone is actually closed before updating roadmap/history artifacts.
