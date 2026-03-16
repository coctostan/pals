---
name: paul-init
description: "Initialize PALS in a project. Creates .paul/ directory with STATE.md, PROJECT.md, ROADMAP.md, and configures modules. Supports greenfield and brownfield projects."
---

# PAUL Init

Initialize the PALS project automation system in the current directory.

## What This Does

Creates the `.paul/` project directory with core artifacts:
- `STATE.md` — live project state and loop position
- `PROJECT.md` — requirements, constraints, decisions
- `ROADMAP.md` — milestone and phase tracking
- `pals.json` — module and git configuration

## How to Execute

1. Read the full workflow definition:
   - File: `../workflows/init-project.md`

2. Read the project template:
   - File: `../templates/PROJECT.md`

3. Follow the init-project workflow steps:
   - Check if `.paul/` already exists (brownfield detection)
   - Ask the user about their project (name, description, goals)
   - Create artifacts from templates
   - Configure modules in `pals.json`
   - Set initial STATE.md with loop position

## Key Behavior

- If `.paul/` exists, offer brownfield init (preserve existing state)
- If `.paul/` does not exist, run greenfield init
- Ask questions ONE at a time, not all at once
- Create first milestone if user provides enough scope
- Set loop position to ready-for-plan after init

## Output

- `.paul/` directory with STATE.md, PROJECT.md, ROADMAP.md
- `pals.json` configuration file
- Project ready for `/skill:paul-plan`
