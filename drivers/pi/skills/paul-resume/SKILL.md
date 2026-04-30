---
name: paul-resume
description: "Restore PALS context after a session break. Reads STATE.md and handoff files to determine current position and suggests exactly one next action."
---

# PAUL Resume

Restore project context and route to the next move.

## Canonical workflow
- `../workflows/resume-project.md`

## Default output
- Concise by default: show lifecycle state, Git State when routing-relevant, and exactly one next action.
- Expand for blockers, stale/conflicting handoffs, failed git checks, or user request.

## Command-local notes
- STATE.md remains authoritative when handoff and state disagree.
- Check active `.paul/HANDOFF*.md` first, then `.paul/handoffs/archive/`.
- Present exactly one next action; Archive an active consumed handoff after work proceeds.