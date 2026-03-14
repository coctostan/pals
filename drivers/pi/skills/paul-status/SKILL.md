---
name: paul-status
description: "Show PALS project status with smart routing. Displays current milestone, phase, loop position, and suggests exactly one next action."
---

# PAUL Status

Display project status and suggest the next action.

## What This Does

Shows a dashboard of current project state:
- Active milestone and progress
- Current phase and loop position
- Recent activity
- Suggests exactly ONE next action

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`
   - File: `.paul/ROADMAP.md`

2. Read the full workflow definition:
   - File: `../workflows/roadmap-management.md`

3. Display status:
   - Project name and milestone
   - Phase N of M with progress bar
   - Loop position (PLAN/APPLY/UNIFY markers)
   - Last activity timestamp
   - Single next action with command

## Key Behavior

- Read-only — does not modify any files
- Suggest exactly ONE next action based on loop position
- Show progress bars for milestone and phase

## Output

- Status display with routing
- No files modified
