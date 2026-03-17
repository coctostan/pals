---
name: pals:init
description: Initialize PAUL in a project with conversational setup
argument-hint:
allowed-tools: [Read, Write, Bash, Glob, AskUserQuestion]
---

<objective>
Initialize the `.paul/` structure in a project directory through conversational setup.

**When to use:** Starting a new project with PAUL, or adding PAUL to an existing codebase.

Creates PROJECT.md, STATE.md, ROADMAP.md, and `pals.json` populated from conversation - user does not manually edit templates.
</objective>

<execution_context>
kernel/workflows/init-project.md
kernel/templates/PROJECT.md
kernel/templates/STATE.md
kernel/templates/ROADMAP.md
</execution_context>

<context>
Current directory state (check for existing .paul/)
</context>

<process>
**Follow workflow: kernel/workflows/init-project.md**

The workflow implements conversational setup:

1. Check for existing `.paul/` (route to resume if exists)
2. Create directory structure
3. Decide whether onboarding is exploratory or direct-requirements
4. Set `planning.default_collaboration` (`low` / `medium` / `high`, fallback `medium`)
5. Ask the user about their project (name, description, goals)
6. Populate PROJECT.md, ROADMAP.md, STATE.md from answers
7. Configure modules in `pals.json`
8. Display ONE next action: `/paul:plan`

**Key behaviors:**
- Ask ONE question at a time
- Wait for response before next question
- Populate files from answers (user doesn't edit templates)
- Capture a project-level planning default while keeping later per-run overrides available
- End with exactly ONE next action
- Build momentum into planning phase
</process>

<success_criteria>
- [ ] .paul/ directory created
- [ ] PROJECT.md populated with core value and description from conversation
- [ ] STATE.md initialized with correct loop position
- [ ] ROADMAP.md initialized (phases TBD until planning)
- [ ] pals.json created with module selections and `planning.default_collaboration`
- [ ] User presented with ONE clear next action
</success_criteria>
