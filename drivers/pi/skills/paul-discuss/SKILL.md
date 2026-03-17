---
name: paul-discuss
description: "Explore and articulate vision before planning. Facilitates discussion about the next milestone or phase scope, then creates a context handoff file."
---

# PAUL Discuss

Think through scope before committing to a plan or milestone.

## What This Does

Acts as a thinking partner to explore what the user wants to build:
- Presents prior accomplishments for context
- Decides whether the run is milestone or phase discussion
- Applies the selected collaboration depth (low / medium / high)
- Distinguishes exploratory vs direct-requirements shaping
- Uses `PROJECT.md` as the hot-path brief and `PRD.md` selectively for deeper product framing
- Creates a context handoff file for the next step

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`
   - File: `.paul/ROADMAP.md`
   - File: `.paul/PROJECT.md`
   - File: `.paul/PRD.md` (selectively, if present and deeper framing / deferred scope / assumptions / open questions matter)
   - File: `.paul/MILESTONES.md` (if exists)
2. Detect scope:
   - If no active milestone → milestone discussion
     - Read: `../workflows/discuss-milestone.md`
   - If active milestone, no active plan → phase discussion
     - Read: `../workflows/discuss-phase.md`
3. Follow the appropriate workflow:
   - Load `planning.default_collaboration` from `pals.json` when available
   - Offer a per-run override
   - Decide exploratory vs direct-requirements mode
   - Ask follow-up questions at the chosen depth
   - Read `PRD.md` only where deeper context materially helps the discussion
   - Offer the 4-option review menu before writing the handoff file

## Key Behavior

- Features/goals first — derive structure from what the user wants to build
- Ask ONE question at a time
- Confirm synthesis before writing the context file
- Do NOT skip the review menu before routing forward
- Do not reflexively load both artifacts for every discussion

## Output

- Milestone discussion: `.paul/MILESTONE-CONTEXT.md`
- Phase discussion: `.paul/phases/{NN}-{name}/CONTEXT.md`
- Both handoffs carry planning mode, collaboration level, and suggested review path
