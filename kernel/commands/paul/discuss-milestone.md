---
name: pals:discuss-milestone
description: Explore and articulate next milestone vision
argument-hint: ""
allowed-tools: [Read, Write, AskUserQuestion]
---

<objective>
Facilitate vision discussion for the next milestone and create context handoff.

**When to use:** Before creating a new milestone, when scope needs exploration.
</objective>

<execution_context>
kernel/workflows/discuss-milestone.md
</execution_context>

<context>
.paul/PROJECT.md
.paul/STATE.md
.paul/ROADMAP.md
.paul/MILESTONES.md
</context>

<process>
Follow workflow: kernel/workflows/discuss-milestone.md
</process>

<success_criteria>
- [ ] MILESTONE-CONTEXT.md created with vision
- [ ] Key themes and goals articulated
- [ ] Ready for /paul:milestone command
</success_criteria>
