---
name: pals:discuss
description: Explore and articulate phase vision before planning
argument-hint: "<phase-number>"
allowed-tools: [Read, Write, AskUserQuestion]
---

<objective>
Facilitate vision discussion for a specific phase or upcoming milestone and create a context handoff.

**When to use:** Before planning, when goals, constraints, or scope need collaborative shaping.
</objective>

<execution_context>
kernel/workflows/discuss-phase.md
kernel/workflows/discuss-milestone.md
</execution_context>

<context>
Phase number: $ARGUMENTS (required for phase discussion)

.paul/PROJECT.md
.paul/PRD.md (selectively, if present and deeper framing / deferred scope / assumptions / open questions matter)
.paul/STATE.md
.paul/ROADMAP.md
</context>

<process>
Follow workflow: the discuss command detects whether to run milestone discussion or phase discussion.

Shared planning behavior now includes:
- a project default collaboration level with per-run override (`low` / `medium` / `high`)
- explicit exploratory vs direct-requirements mode selection
- `PROJECT.md` as the default hot-path brief
- selective `PRD.md` reads when richer product framing or unresolved depth helps the discussion
- follow-up depth that matches the chosen collaboration level
- a 4-option review menu before the handoff file is written:
  - Quick recap
  - Detailed recap
  - Full plan
  - No review needed
</process>

<success_criteria>
- [ ] Correct discussion workflow selected
- [ ] Context handoff file created with planning posture metadata
- [ ] Goals and/or milestone themes articulated
- [ ] `PRD.md` consulted only when deeper context materially helped
- [ ] Review menu offered before routing forward
</success_criteria>
