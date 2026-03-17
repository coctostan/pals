---
name: pals:init
description: Initialize PAUL in a project with conversational setup
argument-hint:
allowed-tools: [Read, Write, Bash, Glob, AskUserQuestion]
---

<objective>
Initialize the `.paul/` structure in a project directory through conversational setup.

**When to use:** Starting a new project with PAUL, or adding PAUL to an existing codebase.

Creates `PROJECT.md`, `PRD.md`, `STATE.md`, `ROADMAP.md`, and `pals.json` populated from conversation - user does not manually edit templates.
</objective>

<execution_context>
kernel/workflows/init-project.md
kernel/templates/PROJECT.md
kernel/templates/PRD.md
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
5. Ask the user about layered product-definition inputs one question at a time
6. Create a compact `PROJECT.md` plus deeper `PRD.md`
7. Configure modules in `pals.json`
8. Display ONE next action: `/paul:plan`

**Key behaviors:**
- Ask ONE question at a time
- Wait for response before next question
- Populate files from answers (user doesn't edit templates)
- Store `planning.default_collaboration` so later planning flows can keep or override it per run
- Keep `PROJECT.md` concise and place deeper framing / deferred items / assumptions in `PRD.md`
- Brownfield onboarding should bridge codebase evidence into current-state, dependency, and constraint fields without losing future product intent
- Set loop position to ready-for-plan after init
</process>

<success_criteria>
- [ ] .paul/ directory created
- [ ] PROJECT.md populated as the compact landing brief
- [ ] PRD.md populated with deeper product-definition context
- [ ] STATE.md initialized with correct loop position
- [ ] ROADMAP.md initialized (phases TBD until planning)
- [ ] pals.json created with module selections and `planning.default_collaboration`
- [ ] User presented with ONE clear next action
</success_criteria>
