---
name: pals:milestone
description: Create or complete a project milestone
argument-hint: "[milestone-name]"
allowed-tools: [Read, Write, Edit, Bash, Glob, AskUserQuestion]
---

<objective>
Create the next milestone or complete the current one based on project state and user intent.
</objective>

<execution_context>
kernel/workflows/create-milestone.md
kernel/workflows/complete-milestone.md
</execution_context>

<context>
$ARGUMENTS

.paul/PROJECT.md
.paul/STATE.md
.paul/ROADMAP.md
</context>

<process>
Follow the matching workflow:
- Use create-milestone when the prior milestone is complete or the user requests a new milestone.
- Use complete-milestone when the current milestone still needs finalization.

Command-local obligations:
- Reuse `.paul/MILESTONE-CONTEXT.md` when present.
- Preserve collaboration/review behavior before writing milestone structure.
- Verify all phases are complete before milestone completion unless user explicitly overrides.
</process>

<success_criteria>
- [ ] Correct create vs complete mode selected
- [ ] ROADMAP.md and STATE.md reflect milestone state
- [ ] Phase directories created for new milestones
- [ ] Single next lifecycle action offered
</success_criteria>
