---
name: paul-pause
description: "Create a handoff file for session breaks. Captures current state, in-progress work, decisions, and next actions so a future session can resume cleanly."
---

# PAUL Pause

Prepare a self-contained resume point for a session break.

## Canonical workflow
- `../workflows/pause-work.md`

## Default output
- Concise by default: confirm the handoff path, loop position, git state summary, and exact resume action.
- Expand only for blockers, conflicting state, fragile evidence, or user-requested detail.

## Command-local notes
- Create an active `.paul/HANDOFF-{date}-{context}.md` that assumes the next reader has no prior context.
- Capture current loop position, work in progress, decisions, git state, and recent file changes.
- Update `STATE.md` session continuity and point resume routing at the fresh handoff.
