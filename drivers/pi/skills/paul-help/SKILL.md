---
name: paul-help
description: "Show available PALS commands and usage guide. Lists all Pi skill commands with descriptions and common workflows."
---

# PAUL Help

Available PALS commands for Pi.

## Core Loop

| Command | Purpose |
|---------|---------|
| `/skill:paul-plan` | Create execution plan for current phase |
| `/skill:paul-apply` | Execute an approved plan |
| `/skill:paul-unify` | Reconcile plan vs actual, close loop |

## Project Management

| Command | Purpose |
|---------|---------|
| `/skill:paul-init` | Initialize PALS in a project |
| `/skill:paul-milestone` | Create or complete a milestone |
| `/skill:paul-discuss` | Explore scope before planning |
| `/skill:paul-status` | Show project status and next action |

## Session Management

| Command | Purpose |
|---------|---------|
| `/skill:paul-resume` | Restore context after session break |
| `/skill:paul-pause` | Create handoff for session break |

## Utilities

| Command | Purpose |
|---------|---------|
| `/skill:paul-fix` | Quick fix (standard/fast-forward/hotfix) |
| `/skill:paul-help` | This help screen |

## Common Workflows

**Starting a new project:**
1. `/skill:paul-init` — set up PALS
2. `/skill:paul-discuss` — explore what to build
3. `/skill:paul-milestone` — create milestone structure
4. `/skill:paul-plan` — plan first phase

**Daily work loop:**
1. `/skill:paul-resume` — restore context
2. `/skill:paul-plan` → `/skill:paul-apply` → `/skill:paul-unify`
3. `/skill:paul-pause` — save state before break

**Quick fixes:**
- `/skill:paul-fix` — bypass full loop for small changes

## About PALS

PALS (Project Automation & Lifecycle System) provides structured project management through the PLAN-APPLY-UNIFY loop. PAUL is the kernel, with modules for testing (TODD), quality (WALT), context rules (CARL), and more.

For more information, read the project README or `.paul/PROJECT.md`.
