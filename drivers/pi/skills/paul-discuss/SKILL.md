---
name: paul-discuss
description: "Explore and articulate vision before planning. Facilitates discussion about the next milestone or phase scope, then creates a context handoff file."
---

# PAUL Discuss

Think through scope before committing to a plan or milestone.

## What This Does

Acts as a thinking partner to explore what the user wants to build:
- Presents prior accomplishments for context
- Asks about features and goals (features first, not structure)
- Synthesizes scope from discussion
- Creates a context handoff file for the next step

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`
   - File: `.paul/ROADMAP.md`
   - File: `.paul/PROJECT.md`
   - File: `.paul/MILESTONES.md` (if exists)

2. Detect scope:
   - If no active milestone → milestone discussion
     - Read: `../workflows/discuss-milestone.md`
   - If active milestone, no active plan → phase discussion
     - Read: `../workflows/discuss-phase.md`

3. Follow the appropriate workflow:
   - Present context (prior work, shipped features)
   - Ask: "What do you want to build next?"
   - Follow up to refine scope
   - Synthesize into phases/tasks
   - Write context handoff file

## Key Behavior

- Features first — derive structure from what user wants to build
- Ask ONE question at a time
- Confirm synthesis before writing context file
- Do NOT skip to creating milestone/plan without discussion

## Output

- Milestone discussion: `.paul/MILESTONE-CONTEXT.md`
- Phase discussion: discussion context for `/skill:paul-plan`
