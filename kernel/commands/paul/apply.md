---
name: pals:apply
description: Execute an approved PLAN
argument-hint: "[plan-path]"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion]
---

<objective>
Execute an explicitly approved PLAN.md and leave the loop ready for UNIFY.

Use only after PLAN is complete and the user has approved execution.
</objective>

<execution_context>
kernel/workflows/apply-phase.md
kernel/references/checkpoints.md
kernel/references/subagent-criteria.md
</execution_context>

<context>
Plan path: $ARGUMENTS

.paul/STATE.md
@{plan-path}
</context>

<process>
Follow workflow: kernel/workflows/apply-phase.md

Command-local obligations:
- Confirm the plan exists and has not already been executed.
- Require explicit approval; do not infer approval from context.
- Execute tasks sequentially, verifying each task's `<verify>` and `<done>` criteria.
- Handle checkpoint tasks by pausing for the required user decision, verification, or action.
- Parent APPLY owns verification, module gates, fallback judgment, and `.paul/*` lifecycle writes even if bounded delegation is used.
- When all tasks complete, report APPLY complete and route to `/paul:unify`.
</process>

<success_criteria>
- [ ] Plan approval confirmed
- [ ] All tasks executed and verified
- [ ] All checkpoints handled
- [ ] Parent verification/module ownership preserved
- [ ] Next action clear: run /paul:unify
</success_criteria>
