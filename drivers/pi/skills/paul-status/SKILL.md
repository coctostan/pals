---
name: paul-status
description: "Show PALS project status with smart routing. Displays current milestone, phase, loop position, git state for github-flow projects, and suggests exactly one next action."
---

# PAUL Status

Display project status and suggest the next action.

## What This Does

Shows a dashboard of current project state:
- Active milestone and progress
- Current phase and loop position
- Git state for github-flow projects (branch, PR, CI, sync status)
- Recent activity
- Suggests exactly ONE next action (git-aware for github-flow)

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`
   - File: `.paul/ROADMAP.md`
   - File: `pals.json` (for git workflow detection)

2. Read the full workflow definition:
   - File: `../workflows/roadmap-management.md`
   - Execute the `show-status` operation

3. Display status:
   - Project name and milestone
   - Phase N of M with progress bar
   - Loop position (PLAN/APPLY/UNIFY markers)
   - Git State block (if `pals.json` has `git.workflow: "github-flow"`)
   - Last activity timestamp
   - Single next action with command

## Key Behavior

- Read-only — does not modify any files
- Suggest exactly ONE next action based on loop position
- Surface git/PR/CI state for github-flow projects (mirrors resume routing)
- Show progress bars for milestone and phase
- If github-flow: git-aware routing overrides take precedence (behind-base, CI failing, etc.)

## Output

- Status display with routing
- No files modified
