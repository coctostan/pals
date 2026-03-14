---
name: paul-resume
description: "Restore PALS context after a session break. Reads STATE.md and handoff files to determine current position and suggests exactly one next action."
---

# PAUL Resume

Restore project context and determine where to continue.

## What This Does

Reads project state and any handoff files to:
- Restore understanding of current position
- Detect handoff files from prior sessions
- Determine the single correct next action
- Present status with clear routing

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`

2. Read the full workflow definition:
   - File: `../workflows/resume-project.md`

3. Check for handoff files:
   - Look for `.paul/HANDOFF*.md` files
   - Use most recent if found

4. Follow the resume-project workflow:
   - Load STATE.md (position, loop state, session continuity)
   - Load handoff content if detected
   - Determine exactly ONE next action based on loop position
   - Display resume status with routing
   - Archive handoff after user proceeds

## Key Behavior

- Suggest exactly ONE next action, not multiple options
- Trust STATE.md as authoritative
- If handoff conflicts with STATE.md, trust STATE.md
- Archive consumed handoffs after work proceeds

## Output

- Context restored
- Single next action suggested
- User can proceed or redirect
