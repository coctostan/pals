# CONTEXT.md Template

Template for `.paul/phases/{NN}-{name}/CONTEXT.md` - phase discussion context handoff.

**Purpose:** Captures the user's planning posture, goals, and approach before executable planning. Created by `/paul:discuss`, consumed by `/paul:plan`.

---

## File Template

```markdown
# Phase Context

**Phase:** {NN} — {phase_name}
**Generated:** {date}
**Status:** Ready for planning | Needs more discussion
**Planning Mode:** exploratory | direct-requirements
**Collaboration Level:** low | medium | high
**Suggested Review Path:** Quick recap | Detailed recap | Full plan | No review needed

## Goals

{user's goals as bullets}
- Goal 1: [description]
- Goal 2: [description]
- Goal 3: [description]

## Approach

{user's approach notes}
- Pattern/library preferences
- Technical direction
- Constraints mentioned

## Constraints

{any limitations or requirements}
- Constraint 1
- Constraint 2

## Open Questions

{items still unclear or needing research}
- Question 1
- Question 2

## Additional Context

{any other notes from discussion}

---

*This file is temporary. It informs planning but is not required.*
*Created by /paul:discuss, consumed by /paul:plan.*
```

---

## Field Descriptions

| Field | Purpose |
|-------|---------|
| `Phase` | Phase number and name from ROADMAP.md |
| `Generated` | Date context was created |
| `Status` | Whether context is complete or needs more discussion |
| `Planning Mode` | Whether the run was exploratory or direct-requirements |
| `Collaboration Level` | low / medium / high planning depth used for the run |
| `Suggested Review Path` | The review option the user preferred before handoff |
| `Goals` | User's objectives for the phase |
| `Approach` | Technical direction, patterns, preferences |
| `Constraints` | Limitations or requirements |
| `Open Questions` | Items needing research or decisions |
| `Additional Context` | Other notes from discussion |

---

## Usage Pattern

1. User runs `/paul:discuss <phase>`
2. Discussion workflow decides the planning mode and collaboration level
3. CONTEXT.md is created in the phase directory
4. `/paul:plan` reads CONTEXT.md to inform planning and review routing
5. Later planning runs may keep the project default collaboration level or override it per run

---

## Relationship to Other Files

| File | Relationship |
|------|--------------|
| ROADMAP.md | Source of phase definition |
| CONTEXT.md | Discussion output (this file) |
| PLAN.md | Consumes context for planning |
| RESEARCH.md | May inform context or result from questions |
