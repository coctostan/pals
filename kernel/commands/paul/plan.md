---
name: pals:plan
description: Enter PLAN phase for current or new plan
argument-hint: "[phase-plan]"
allowed-tools: [Read, Write, Glob, AskUserQuestion]
---

<objective>
Create or continue a PLAN for the specified phase.

**When to use:** Starting new work or resuming incomplete plan.
</objective>

<execution_context>
kernel/workflows/plan-phase.md
kernel/templates/PLAN.md
kernel/references/plan-format.md
</execution_context>

<context>
$ARGUMENTS

.paul/PROJECT.md
.paul/STATE.md
.paul/ROADMAP.md
</context>

<process>
Follow workflow: kernel/workflows/plan-phase.md

The planning workflow now:
1. Reuses discussion handoff metadata when available
2. Applies the project default collaboration level with per-run override
3. Distinguishes exploratory vs direct-requirements planning mode
4. Builds the executable plan at the appropriate collaboration depth
5. Offers the review menu before APPLY routing:
   - Quick recap
   - Detailed recap
   - Full plan
   - No review needed
</process>

<success_criteria>
- [ ] PLAN.md created in correct phase directory
- [ ] Collaboration level and planning mode determined for the run
- [ ] Review menu offered before APPLY routing
- [ ] STATE.md updated with loop position
</success_criteria>
