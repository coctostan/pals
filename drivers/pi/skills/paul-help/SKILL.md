---
name: paul-help
description: "Show available PALS commands and usage guide. Explains how Pi /paul-* commands relate to canonical /skill:paul-* skills."
---

# PAUL Help

Available PALS Pi command and skill surfaces.

## How to use PALS in Pi

- Use `/paul-*` for the most convenient Pi-native command experience.
- Use `/skill:paul-*` when you want the canonical underlying skill entry directly.
- Both surfaces route into the same shared PALS workflow model; only the skills are canonical entry points.
- Shortcut-enabled Pi entry points are also available from the lifecycle surface: `Ctrl+Alt+N` (next), `Ctrl+Alt+S` (status), `Ctrl+Alt+R` (resume), `Ctrl+Alt+H` (help), `Ctrl+Alt+M` (milestone).
- Pi installs enabled modules beside the skills and records them in `~/.pi/agent/skills/pals/modules.yaml`; TODD and WALT are module overlays there, not standalone Pi skills you need to invoke separately.

## Pi command layer

| Command | Purpose |
|---------|---------|
| `/paul-plan` | Plan the next PALS phase |
| `/paul-apply` | Execute the approved PALS plan |
| `/paul-unify` | Reconcile completed work and close the loop |
| `/paul-init` | Set up PALS lifecycle files in a project |
| `/paul-milestone` | Create or complete a milestone |
| `/paul-discuss` | Explore scope before planning |
| `/paul-status` | Show project status and next action |
| `/paul-resume` | Restore context after a session break |
| `/paul-pause` | Create a handoff for a session break |
| `/paul-fix` | Run a quick fix flow |
| `/paul-help` | Show this help screen |

## Shortcut layer
- Use `Ctrl+Alt+N` to trigger the current next PALS action from the visible lifecycle surface.
- Use `Ctrl+Alt+S` for `/paul-status`, `Ctrl+Alt+R` for `/paul-resume`, `Ctrl+Alt+H` for `/paul-help`, and `Ctrl+Alt+M` for `/paul-milestone`.
- These shortcuts are Pi-native convenience entry points only; canonical workflow ownership remains with `/skill:paul-*`.

## Canonical Pi skill layer

| Command | Purpose |
|---------|---------|
| `/skill:paul-plan` | Canonical entry for phase planning |
| `/skill:paul-apply` | Canonical entry for approved plan execution |
| `/skill:paul-unify` | Canonical entry for reconciliation |
| `/skill:paul-init` | Canonical entry for project initialization |
| `/skill:paul-milestone` | Canonical entry for milestone management |
| `/skill:paul-discuss` | Canonical entry for pre-plan discussion |
| `/skill:paul-status` | Canonical entry for project status and routing |
| `/skill:paul-resume` | Canonical entry for session resume |
| `/skill:paul-pause` | Canonical entry for handoff creation |
| `/skill:paul-fix` | Canonical entry for quick fixes |
| `/skill:paul-help` | Canonical entry for this help screen |

## Common Workflows

**Starting a new project:**
1. `/paul-init` (or `/skill:paul-init`) — set up PALS
2. `/paul-discuss` — explore what to build
3. `/paul-milestone` — create milestone structure
4. `/paul-plan` — plan first phase

**Daily work loop:**
1. `/paul-resume` — restore context
2. `/paul-plan` → `/paul-apply` → `/paul-unify`
3. `/paul-pause` — save state before a break

**Quick fixes:**
- `/paul-fix` — bypass the full loop for small changes

## About PALS

PALS (Project Automation & Lifecycle System) provides structured project management through the PLAN-APPLY-UNIFY loop. PAUL is the kernel, with modules for testing (TODD), quality (WALT), context rules (CARL), and more.
In Pi, those modules are installed into the shared skill tree and surfaced through workflow dispatch, not as extra `/skill:*` commands.
For more information, read the project README or `.paul/PROJECT.md`.
