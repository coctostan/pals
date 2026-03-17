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
.paul/PRD.md (selectively, if present and deeper product framing / deferred items / open questions matter)
.paul/STATE.md
.paul/ROADMAP.md
.paul/MILESTONES.md
</context>

<process>
Follow workflow: kernel/workflows/discuss-milestone.md

Key collaboration behavior:
1. Read the project default collaboration level from `pals.json` when available
2. Offer a per-run override (`low` / `medium` / `high`)
3. Decide whether the run is exploratory or direct-requirements
4. Treat `PROJECT.md` as the hot-path reminder of current scope and use `PRD.md` selectively for deeper shaping context
5. Offer the review menu before writing `.paul/MILESTONE-CONTEXT.md`
</process>

<success_criteria>
- [ ] MILESTONE-CONTEXT.md created with vision and planning posture
- [ ] Key themes and goals articulated
- [ ] `PRD.md` consulted only where deeper milestone context helped
- [ ] Review menu offered before handoff
- [ ] Ready for /paul:milestone command
</success_criteria>
