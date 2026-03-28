---
name: paul-status
description: "Show PALS project status with smart routing. Displays current milestone, phase, loop position, git state for github-flow projects, and suggests exactly one next action."
---

# PAUL Status

Show project status and the next routed action.

## Canonical workflow
- `../workflows/roadmap-management.md` (`show-status`)

## Command-local notes
- Read-only wrapper; it reports state and does not modify lifecycle files.
- Surface milestone/phase progress plus loop position from authoritative shared artifacts.
- Show the git block only when `pals.json` uses `git.workflow: "github-flow"`.
- Suggest exactly one next action, using the same git-aware routing model as resume.
