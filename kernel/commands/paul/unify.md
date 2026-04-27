---
name: pals:unify
description: Reconcile plan vs actual and close the loop
argument-hint: "[plan-path]"
allowed-tools: [Read, Write, AskUserQuestion]
---

<objective>
Close the current loop by reconciling planned work against actual APPLY results.

UNIFY is mandatory after APPLY; never skip it.
</objective>

<execution_context>
kernel/workflows/unify-phase.md
kernel/templates/SUMMARY.md
</execution_context>

<context>
Plan path: $ARGUMENTS

.paul/STATE.md
@{plan-path}
</context>

<process>
Follow workflow: kernel/workflows/unify-phase.md

Command-local obligations:
- Confirm PLAN exists, APPLY completed, and SUMMARY does not already close the loop.
- Compare planned tasks/acceptance criteria with actual results.
- Create SUMMARY.md beside the PLAN with results, deviations, decisions, deferred issues, changed files, and module execution reports.
- Update STATE.md and ROADMAP.md as needed so loop position becomes PLAN ✓ / APPLY ✓ / UNIFY ✓.
- Route to the next single lifecycle action.
</process>

<success_criteria>
- [ ] SUMMARY.md created beside PLAN.md
- [ ] Plan-vs-actual reconciliation recorded
- [ ] STATE.md updated with loop closure
- [ ] ROADMAP.md refreshed if phase/milestone state changed
- [ ] User knows the next action
</success_criteria>
