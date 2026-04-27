---
name: pals:plan
description: Enter PLAN phase for current or new plan
argument-hint: "[phase-plan]"
allowed-tools: [Read, Write, Glob, AskUserQuestion]
---

<objective>
Create an executable PLAN.md for the selected phase.

Use when starting new work or resuming a phase that needs an approved plan before APPLY.
</objective>

<execution_context>
kernel/workflows/plan-phase.md
kernel/templates/PLAN.md
kernel/references/plan-format.md
</execution_context>

<context>
$ARGUMENTS

.paul/PROJECT.md
.paul/PRD.md (selectively, only when deeper framing materially helps)
.paul/STATE.md
.paul/ROADMAP.md
</context>

<process>
Follow workflow: kernel/workflows/plan-phase.md

Command-local obligations:
- Determine planning posture from `planning.default_collaboration`, with `low / medium / high` override support.
- Distinguish `exploratory` vs `direct-requirements` planning mode.
- Keep PROJECT.md on the hot path; read PRD.md only when materially useful.
- Create the PLAN artifact, update STATE/ROADMAP, then offer the review menu before APPLY routing.
</process>

<success_criteria>
- [ ] PLAN.md created in correct phase directory
- [ ] Collaboration level and planning mode recorded
- [ ] PROJECT.md used as hot-path brief; PRD.md read selectively if needed
- [ ] Review menu offered before APPLY routing
- [ ] STATE.md updated with loop position
</success_criteria>
