---
name: pals:milestone
description: Create a new milestone in the project
argument-hint: "[milestone-name]"
allowed-tools: [Read, Write, Edit, Bash, Glob, AskUserQuestion]
---

<objective>
Create or complete a milestone with defined scope and phases.

**When to use:** Starting a new milestone cycle after completing the previous one.
</objective>

<execution_context>
kernel/workflows/create-milestone.md
</execution_context>

<context>
$ARGUMENTS

.paul/PROJECT.md
.paul/STATE.md
.paul/ROADMAP.md
</context>

<process>
Follow workflow: kernel/workflows/create-milestone.md

For create mode, milestone setup now:
- carries forward collaboration metadata from `.paul/MILESTONE-CONTEXT.md` when present
- falls back to the project planning default when no handoff metadata exists
- allows a quick per-run collaboration override before roadmap changes
- offers the 4-option review menu before writing milestone structure into ROADMAP.md
</process>

<success_criteria>
- [ ] Milestone created in ROADMAP.md
- [ ] Phase directories created
- [ ] STATE.md reflects new milestone
- [ ] Review menu offered before commit to milestone structure
</success_criteria>
