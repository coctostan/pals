---
name: paul-resume
description: "Restore PALS context after a session break. Reads STATE.md and handoff files to determine current position and suggests exactly one next action."
---

# PAUL Resume

Restore project context and route to the next move.

## Canonical workflow
- `../workflows/resume-project.md`

## Command-local notes
- STATE.md remains authoritative if a handoff and state disagree.
- Check active `.paul/HANDOFF*.md` files first, then archived handoffs under `.paul/handoffs/archive/`.
- Present exactly one next action based on loop position and git-aware routing.
- Archive an active consumed handoff after the user proceeds; leave archived handoffs in place.
