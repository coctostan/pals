---
name: pals:help
description: Show available PAUL commands and usage guide
---

<objective>
Display the complete PAUL command reference.

Output ONLY the reference content below. Do NOT add:

- Project-specific analysis
- Git status or file context
- Next-step suggestions
- Any commentary beyond the reference
</objective>

<reference>
# PAUL Command Reference

**PAUL** (Plan-Apply-Unify Loop) is a structured AI-assisted development framework for Claude Code.

## The Loop

Every unit of work follows this cycle:

```
┌─────────────────────────────────────┐
│  PLAN ──▶ APPLY ──▶ UNIFY          │
│                                     │
│  Define    Execute    Reconcile     │
│  work      tasks      & close       │
└─────────────────────────────────────┘
```

**Never skip UNIFY.** Every plan needs a summary.

## Quick Start

1. `/pals:init` - Initialize PAUL in your project
2. `/pals:plan` - Create a plan for your work
3. `/pals:apply` - Execute the approved plan
4. `/pals:unify` - Close the loop with summary

## Commands Overview

| Category | Commands |
|----------|----------|
| Core Loop | init, plan, apply, unify, help, status |
| Session | pause, resume, progress, handoff |
| Roadmap | add-phase, remove-phase |
| Milestone | milestone, complete-milestone, discuss-milestone |
| Pre-Planning | discuss, assumptions, discover, consider-issues |
| Research | research, research-phase |
| Specialized | flows, config, map-codebase |
| Quality | verify, plan-fix |

---

## Core Loop Commands

### `/pals:init`
Initialize PAUL in a project.

- Creates `.paul/` directory structure
- Creates PROJECT.md, STATE.md, ROADMAP.md
- Prompts for project context and phases
- Optionally configures integrations (SonarQube, etc.)

Usage: `/pals:init`

---

### `/pals:plan [phase]`
Enter PLAN phase - create an executable plan.

- Reads current state from STATE.md
- Creates PLAN.md with tasks, acceptance criteria, boundaries
- Populates skills section from SPECIAL-FLOWS.md (if configured)
- Updates loop position

Usage: `/pals:plan` (auto-detects next phase)
Usage: `/pals:plan 3` (specific phase)

---

### `/pals:apply [plan-path]`
Execute an approved PLAN.md file.

- **Blocks if required skills not loaded** (from SPECIAL-FLOWS.md)
- Validates plan exists and hasn't been executed
- Executes tasks sequentially
- Handles checkpoints (decision, human-verify, human-action)
- Reports completion and prompts for UNIFY

Usage: `/pals:apply`
Usage: `/pals:apply .paul/phases/01-foundation/01-01-PLAN.md`

---

### `/pals:unify [plan-path]`
Reconcile plan vs actual and close the loop.

- Creates SUMMARY.md documenting what was built
- Audits skill invocations (if SPECIAL-FLOWS.md configured)
- Records decisions made, deferred issues
- Updates STATE.md with loop closure
- **Required** - never skip this step

Usage: `/pals:unify`
Usage: `/pals:unify .paul/phases/01-foundation/01-01-PLAN.md`

---

### `/pals:help`
Show this command reference.

Usage: `/pals:help`

---

### `/pals:status` *(deprecated)*
> Use `/pals:progress` instead.

Shows current loop position. Deprecated in favor of `/pals:progress` which provides better routing.

---

## Session Commands

### `/pals:pause [reason]`
Create handoff file and prepare for session break.

- Creates HANDOFF.md with complete context
- Updates STATE.md session continuity section
- Designed for context limits or multi-session work

Usage: `/pals:pause`
Usage: `/pals:pause "switching to other project"`

---

### `/pals:resume [handoff-path]`
Restore context from handoff and continue work.

- Reads STATE.md and any HANDOFF files
- Determines current loop position
- Suggests exactly ONE next action
- Archives consumed handoffs

Usage: `/pals:resume`
Usage: `/pals:resume .paul/HANDOFF-context.md`

---

### `/pals:progress [context]`
Smart status with routing - suggests ONE next action.

- Shows milestone and phase progress visually
- Displays current loop position
- Suggests exactly ONE next action (prevents decision fatigue)
- Accepts optional context to tailor suggestion
- Warns about context limits

Usage: `/pals:progress`
Usage: `/pals:progress "I only have 30 minutes"`

---

### `/pals:handoff [context]`
Generate comprehensive session handoff document.

- Creates detailed handoff for complex session breaks
- Captures decisions, progress, blockers, next steps
- More thorough than `/pals:pause`

Usage: `/pals:handoff`
Usage: `/pals:handoff "phase10-audit"`

---

## Roadmap Commands

### `/pals:add-phase <description>`
Append a new phase to the roadmap.

- Adds phase to end of ROADMAP.md
- Updates phase numbering
- Records in STATE.md decisions

Usage: `/pals:add-phase "API Authentication Layer"`

---

### `/pals:remove-phase <number>`
Remove a future (not started) phase from roadmap.

- Cannot remove completed or in-progress phases
- Renumbers subsequent phases
- Updates ROADMAP.md

Usage: `/pals:remove-phase 5`

---

## Milestone Commands

### `/pals:milestone <name>`
Create a new milestone with phases.

- Guides through milestone definition
- Creates phase structure
- Updates ROADMAP.md with milestone grouping

Usage: `/pals:milestone "v2.0 API Redesign"`

---

### `/pals:complete-milestone [version]`
Archive milestone, tag, and reorganize roadmap.

- Verifies all phases complete
- Creates git tag (if configured)
- Archives milestone to MILESTONES.md
- Evolves PROJECT.md for next milestone

Usage: `/pals:complete-milestone`
Usage: `/pals:complete-milestone v0.3`

---

### `/pals:discuss-milestone`
Explore and articulate vision before starting a milestone.

- Conversational exploration of goals
- Creates milestone context document
- Prepares for `/pals:milestone`

Usage: `/pals:discuss-milestone`

---

## Pre-Planning Commands

### `/pals:discuss <phase>`
Articulate vision and explore approach before planning.

- Conversational discussion of phase goals
- Creates CONTEXT.md capturing vision
- Prepares for `/pals:plan`

Usage: `/pals:discuss 3`
Usage: `/pals:discuss "authentication layer"`

---

### `/pals:assumptions <phase>`
Surface Claude's assumptions about a phase before planning.

- Shows what Claude would do if given free rein
- Identifies gaps in understanding
- Prevents misaligned planning

Usage: `/pals:assumptions 3`

---

### `/pals:discover <topic>`
Research technical options before planning a phase.

- Explores codebase for relevant patterns
- Documents findings for planning reference
- Lightweight alternative to full research

Usage: `/pals:discover "authentication patterns"`

---

### `/pals:consider-issues [source]`
Review deferred issues with codebase context, triage and route.

- Reads deferred issues from STATE.md or specified source
- Analyzes with current codebase context
- Suggests routing: fix now, defer, or close

Usage: `/pals:consider-issues`

---

## Research Commands

### `/pals:research <topic>`
Deploy research agents for documentation/web search.

- Spawns subagents for parallel research
- Gathers external documentation
- Creates RESEARCH.md with findings
- Main session vets and reviews results

Usage: `/pals:research "JWT best practices 2026"`

---

### `/pals:research-phase <number>`
Research unknowns for a phase using subagents.

- Identifies unknowns in phase scope
- Deploys research agents
- Synthesizes findings for planning

Usage: `/pals:research-phase 4`

---

## Specialized Commands

### `/pals:flows`
Configure specialized workflow integrations.

- Creates/updates SPECIAL-FLOWS.md
- Defines required skills per work type
- Skills are enforced at APPLY time

Usage: `/pals:flows`

---

### `/pals:config`
View or modify PAUL configuration.

- Shows current config.md settings
- Allows toggling integrations
- Manages project-level settings

Usage: `/pals:config`

---

### `/pals:map-codebase`
Generate codebase map for context.

- Creates structured overview of project
- Identifies key files and patterns
- Useful for research and planning

Usage: `/pals:map-codebase`

---

## Quality Commands

### `/pals:verify`
Guide manual user acceptance testing of recently built features.

- Generates verification checklist from SUMMARY.md
- Guides through manual testing
- Records verification results

Usage: `/pals:verify`

---

### `/pals:plan-fix`
Plan fixes for UAT issues from verify.

- Reads issues identified during verify
- Creates targeted fix plan
- Smaller scope than full phase plan

Usage: `/pals:plan-fix`

---

## Files & Structure

```
.paul/
├── PROJECT.md           # Project context and value prop
├── ROADMAP.md           # Phase breakdown and milestones
├── STATE.md             # Loop position and session state
├── config.md            # Optional integrations config
├── SPECIAL-FLOWS.md     # Optional skill requirements
├── MILESTONES.md        # Completed milestone archive
└── phases/
    ├── 01-foundation/
    │   ├── 01-01-PLAN.md
    │   └── 01-01-SUMMARY.md
    └── 02-features/
        ├── 02-01-PLAN.md
        └── 02-01-SUMMARY.md
```

## PLAN.md Structure

```markdown
---
phase: 01-foundation
plan: 01
type: execute
autonomous: true
---

<objective>
Goal, Purpose, Output
</objective>

<context>
@-references to relevant files
</context>

<skills>
Required skills from SPECIAL-FLOWS.md
</skills>

<acceptance_criteria>
Given/When/Then format
</acceptance_criteria>

<tasks>
<task type="auto">...</task>
</tasks>

<boundaries>
DO NOT CHANGE, SCOPE LIMITS
</boundaries>

<verification>
Completion checks
</verification>
```

## Task Types

| Type | Use For |
|------|---------|
| `auto` | Fully autonomous execution |
| `checkpoint:decision` | Choices requiring human input |
| `checkpoint:human-verify` | Visual/functional verification |
| `checkpoint:human-action` | Manual steps (rare) |

## Common Workflows

**Starting a new project:**
```
/pals:init
/pals:plan
# Approve plan
/pals:apply
/pals:unify
```

**Checking where you are:**
```
/pals:progress   # State + ONE next action (recommended)
```

**Resuming work (new session):**
```
/pals:resume     # Restores context, suggests next action
```

**Pausing work (before break):**
```
/pals:pause      # Creates handoff, updates state
```

**Pre-planning exploration:**
```
/pals:discuss 3       # Articulate vision
/pals:assumptions 3   # See Claude's assumptions
/pals:research "topic"  # Gather external info
/pals:plan 3          # Now create the plan
```

**Managing roadmap:**
```
/pals:add-phase "New Feature"    # Add phase
/pals:remove-phase 5             # Remove future phase
/pals:milestone "v2.0"           # Create milestone
/pals:complete-milestone         # Archive milestone
```

## Key Principles

1. **Loop must complete** - PLAN -> APPLY -> UNIFY, no shortcuts
2. **Commands are thin** - Logic lives in workflows
3. **State is tracked** - STATE.md knows where you are
4. **Boundaries are real** - Respect DO NOT CHANGE sections
5. **Acceptance criteria first** - Define done before starting
6. **Skills are enforced** - Required skills block APPLY until loaded

## Getting Help

- Run `/pals:progress` to see where you are and what to do next
- Read `.paul/PROJECT.md` for project context
- Read `.paul/STATE.md` for current position
- Check `.paul/ROADMAP.md` for phase overview

---

*PAUL Framework v0.4+ | 26 commands | Last updated: 2026-01-29*
</reference>
