---
name: paul-help
description: "Show available PALS commands and usage guide. Explains how Pi /paul-* commands relate to canonical /skill:paul-* skills."
---

# PAUL Help

Pi exposes convenience wrappers on top of the canonical PALS skill layer.

## Use the right surface
- Use `/paul-*` for the fastest Pi-native command experience.
- Use `/skill:paul-*` when you want the canonical underlying skill entry directly.
- The canonical skills and shared workflows remain authoritative; `/paul-*` is a convenience wrapper layer.
- Shortcut-enabled entry points are available for high-frequency actions: `Ctrl+Alt+N`, `Ctrl+Alt+S`, `Ctrl+Alt+R`, `Ctrl+Alt+H`, `Ctrl+Alt+M`.
- The visible lifecycle surface stays centered on milestone, phase, loop, and next action; shortcuts are entry points, not persistent panel rows.
- Pi installs enabled modules beside the skills in `~/.pi/agent/skills/pals/modules.yaml`; TODD and WALT are module overlays, not standalone Pi skills.

## Pi command layer
| Command | Purpose |
|---------|---------|
| `/paul-plan` | Plan the next PALS phase |
| `/paul-apply` | Execute the approved PALS plan |
| `/paul-unify` | Reconcile completed work and close the loop |
| `/paul-init` | Initialize PALS in a project |
| `/paul-milestone` | Create or complete a milestone |
| `/paul-discuss` | Explore scope before planning |
| `/paul-status` | Show project status and next action |
| `/paul-resume` | Restore context after a session break |
| `/paul-pause` | Create a handoff for a session break |
| `/paul-fix` | Run a quick fix flow |
| `/paul-help` | Show this help screen |

## Canonical skill layer
| Canonical entry | Typical use |
|-----------------|-------------|
| `/skill:paul-init` | Start or migrate a PALS project |
| `/skill:paul-plan` | Build the next approved plan |
| `/skill:paul-apply` | Execute the approved plan |
| `/skill:paul-unify` | Reconcile plan vs actual |
| `/skill:paul-resume` | Restore context and route to one next action |
| `/skill:paul-status` | Inspect lifecycle state without modifying it |
| `/skill:paul-discuss` | Shape milestone/phase scope before planning |
| `/skill:paul-milestone` | Create or complete a milestone |
| `/skill:paul-pause` | Capture a self-contained handoff |
| `/skill:paul-fix` | Run the side-loop fix flow |
| `/skill:paul-help` | Re-open this guidance |

## Shortcut routing
- `Ctrl+Alt+N` routes the visible next PALS action.
- `Ctrl+Alt+S`, `Ctrl+Alt+R`, `Ctrl+Alt+H`, and `Ctrl+Alt+M` route to status, resume, help, and milestone shortcuts.
- These shortcuts are Pi convenience entry points only; canonical lifecycle ownership stays with `/skill:paul-*` plus the shared workflow markdown.
