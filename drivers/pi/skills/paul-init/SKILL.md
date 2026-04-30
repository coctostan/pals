---
name: paul-init
description: "Initialize PALS in a project. Creates .paul/ directory with STATE.md, PROJECT.md, PRD.md, ROADMAP.md, and configures modules. Supports greenfield and brownfield projects."
---

# PAUL Init

Initialize PALS in the current project.

## Canonical workflow
- `../workflows/init-project.md`
- `../templates/PROJECT.md`
- `../templates/PRD.md`

## Default output
- Concise by default: ask one onboarding question or show one migration/resume next action.
- Expand for stale config migration, destructive choices, blockers, or user-requested detail.

## Command-local notes
- Supports both greenfield and brownfield onboarding while converging on the same layered artifacts: `PROJECT.md`, `PRD.md`, `ROADMAP.md`, `STATE.md`, and `pals.json`.
- Ask for onboarding inputs one question at a time.
- Set or preserve `planning.default_collaboration` during initialization.
- If `.paul/` already exists, migrate stale `pals.json` data first; otherwise route to resume/plan behavior instead of reinitializing blindly.
