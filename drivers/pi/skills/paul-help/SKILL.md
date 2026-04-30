---
name: paul-help
description: "Show available PALS commands and usage guide. Explains how Pi /paul-* commands relate to canonical /skill:paul-* skills."
---

# PAUL Help

Pi exposes convenience `/paul-*` wrappers over the canonical `/skill:paul-*` layer. Use `/paul-*` for the fastest Pi-native command experience; use `/skill:paul-*` when you want the canonical underlying skill entry directly.

## Default output
- Concise by default: show the relevant command mapping, shortcut if useful, and one next action.
- Expand for onboarding, command comparison, shortcut detail, or user request.

## Command-local notes
- Canonical skills and shared workflows remain authoritative; `/paul-*` is convenience routing.
- TODD and WALT are module overlays installed beside skills, not standalone Pi skills.
- The visible lifecycle surface stays centered on milestone, phase, loop, and next action.

## Pi command layer
| Command | Purpose |
|---------|---------|
| `/paul-plan` | Plan the next phase |
| `/paul-apply` | Execute the approved plan |
| `/paul-unify` | Reconcile completed work |
| `/paul-init` | Initialize PALS |
| `/paul-milestone` | Create/complete milestones |
| `/paul-discuss` | Explore scope before planning |
| `/paul-status` | Show status and next action |
| `/paul-resume` | Restore context |
| `/paul-pause` | Create a handoff |
| `/paul-fix` | Run a quick fix |
| `/paul-help` | Show help |

## Canonical skill layer
Use `/skill:paul-*` for the canonical entry directly; names mirror the Pi command layer (`paul-plan`, `paul-apply`, `paul-unify`, etc.).

## Shortcuts
`Ctrl+Alt+N` next action; `Ctrl+Alt+S` status; `Ctrl+Alt+R` resume; `Ctrl+Alt+H` help; `Ctrl+Alt+M` milestone.