---
name: paul-pause
description: "Create a handoff file for session breaks. Captures current state, in-progress work, decisions, and next actions so a future session can resume cleanly."
---

# PAUL Pause

Prepare for a session break with a handoff document.

## What This Does

Creates a HANDOFF.md file capturing:
- Current state and position
- What was done this session
- What's in progress
- Key decisions made
- Next actions for resume
- File tracking (recent changes)

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`

2. Read the full workflow definition:
   - File: `../workflows/pause-work.md`

3. Follow the pause-work workflow:
   - Gather session context
   - Create `.paul/HANDOFF-{date}-{context}.md`
   - Update STATE.md session continuity section
   - Point resume file to the handoff

## Key Behavior

- Handoff must be self-contained (reader has no prior context)
- Include git state (branch, uncommitted changes)
- Include file tracking for key modified files
- Update STATE.md to point to handoff for resume

## Output

- `.paul/HANDOFF-{date}-{context}.md`
- STATE.md updated with session continuity
