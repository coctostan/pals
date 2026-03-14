---
name: paul-milestone
description: "Manage PALS milestones. Creates new milestones with phase structure, or completes the current milestone. Detects intent from project state."
---

# PAUL Milestone

Create or complete a milestone.

## What This Does

**Create mode** (no active milestone or user requests new):
- Define milestone name, theme, and phases
- Create phase directories in `.paul/phases/`
- Update ROADMAP.md with milestone section
- Update STATE.md with new position

**Complete mode** (all phases done):
- Verify all phases in milestone are complete
- Update MILESTONES.md with accomplishment record
- Collapse milestone in ROADMAP.md
- Clear STATE.md for next milestone

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`
   - File: `.paul/ROADMAP.md`

2. Detect mode:
   - If no active milestone or user says "create" → create mode
   - If all phases complete or user says "complete" → complete mode

3. For create mode, read:
   - File: `../workflows/create-milestone.md`
   - File: `.paul/MILESTONE-CONTEXT.md` (if exists, from prior discussion)

4. For complete mode, read:
   - File: `../workflows/complete-milestone.md`
   - File: `.paul/MILESTONES.md`

5. Follow the appropriate workflow

## Key Behavior

- Check for MILESTONE-CONTEXT.md handoff from /skill:paul-discuss
- If context exists, skip interactive questions
- Clean up MILESTONE-CONTEXT.md after creating milestone
- On complete: update all tracking artifacts

## Output

- Create: ROADMAP.md updated, phase dirs created, STATE.md updated
- Complete: MILESTONES.md updated, ROADMAP.md collapsed, STATE.md cleared
