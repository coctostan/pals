---
name: pals:assumptions
description: Surface Claude's assumptions about a phase before planning
argument-hint: "<phase-number>"
allowed-tools: [Read, Bash]
---

<objective>
Surface Claude's assumptions about a phase to validate understanding before planning.

**When to use:** Before planning to catch misconceptions early.
**Distinction from /paul:discuss:** This command shows what CLAUDE thinks. The discuss command gathers what USER wants.
</objective>

<execution_context>
kernel/workflows/phase-assumptions.md
</execution_context>

<context>
Phase number: $ARGUMENTS (required)

.paul/PROJECT.md
.paul/PRD.md (selectively, if present and deeper product framing / deferred items / assumptions / open questions matter)
.paul/STATE.md
.paul/ROADMAP.md
</context>

<process>
Follow workflow: kernel/workflows/phase-assumptions.md

The assumptions workflow should:
- read `PROJECT.md` as the hot-path project brief
- consult `PRD.md` selectively when richer product framing, deferred scope, dependencies, or open questions materially affect the assumptions being surfaced
- keep the output conversational and scannable
</process>

<success_criteria>
- [ ] Assumptions presented across 5 areas
- [ ] Confidence levels indicated
- [ ] `PRD.md` used selectively when it materially improved the analysis
- [ ] User can provide corrections
- [ ] Clear path to planning after validation
</success_criteria>
