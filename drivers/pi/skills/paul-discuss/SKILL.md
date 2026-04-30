---
name: paul-discuss
description: "Explore and articulate vision before planning. Facilitates discussion about the next milestone or phase scope, then creates a context handoff file."
---

# PAUL Discuss

Explore scope before locking a plan or milestone.

## Canonical workflows
- `../workflows/discuss-milestone.md`
- `../workflows/discuss-phase.md`

## Default output
- Concise by default: answer first, capture only decision-relevant context, and show one next action.
- Expand for ambiguity, review decisions, blockers, or user-requested detail.

## Command-local notes
- Detect whether the discussion is for milestone creation or the next phase inside an active milestone.
- Use the shared collaboration model: project default from `planning.default_collaboration`, optional per-run override, and low / medium / high depth.
- Keep `PROJECT.md` as the hot-path brief and read `PRD.md` selectively when deeper framing materially helps.
- Distinguish `exploratory` shaping from `direct-requirements` capture.
- Offer the shared 4-option review menu before writing the handoff/context file.
