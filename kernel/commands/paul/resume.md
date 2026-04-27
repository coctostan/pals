---
name: pals:resume
description: Restore context from handoff and continue work
argument-hint: "[optional: handoff path, e.g., '.paul/HANDOFF-phase10-audit.md']"
allowed-tools: [Read, Glob, Bash]
---

<objective>
Restore PAUL context after a session break and suggest exactly one next action.
</objective>

<execution_context>
kernel/workflows/resume-project.md
</execution_context>

<context>
$ARGUMENTS (optional handoff path)

.paul/STATE.md
</context>

<process>
Follow workflow: kernel/workflows/resume-project.md

Command-local obligations:
- Prefer an explicit handoff argument, then newest active `.paul/HANDOFF*.md`, then archived handoff fallback.
- Treat STATE.md as authoritative when state and handoff disagree.
- Surface GitHub Flow state only when configured.
- Present exactly one next action.
- Archive only a consumed active handoff after work proceeds; leave archived handoffs in place.
</process>

<success_criteria>
- [ ] Context restored from STATE.md and/or handoff
- [ ] Loop position correctly identified
- [ ] Exactly one next action suggested
- [ ] Handoff lifecycle handled when work proceeds
</success_criteria>
