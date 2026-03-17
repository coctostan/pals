# PRD.md Template

Template for `.paul/PRD.md` — the deeper, selectively-read product-definition artifact.

**Purpose:** Preserve richer product context that should remain durable but does not belong on the hot path: problem framing, desired outcomes, detailed requirements, deferred scope, assumptions, open questions, dependencies, and supporting references.

---

## File Template

```markdown
# Product Requirements: [Project Name]

## Problem / Opportunity
[What problem, opportunity, or unmet need this work addresses.]

## Why Now
[Why this matters now — urgency, strategy, timing, market, user pressure, or operational need.]

## Current State / Existing System Context
[For greenfield: what exists today outside this product, if anything.]
[For brownfield: current capabilities, gaps, operational realities, and evidence from the existing system.]

## Desired Outcome
[What success looks like if this work lands well.]

## Target Users and Needs
### Primary Users
- [Who they are]
- [What they need]
- [What success looks like for them]

### Secondary Users
- [Who they are]
- [What they need]

## Requirements
### Must Have
- [Required capability or outcome]

### Should Have / Nice to Have
- [Important but not first-wave capability]

### Explicitly Deferred
- [Deferred item] — [why deferred]

### Out of Scope
- [Excluded item] — [why excluded]

## Constraints & Dependencies
### Constraints
- [Technical / business / compliance constraint]

### Dependencies / Integrations
- [Dependency, system, partner, or external integration]

## Assumptions
- [Assumption 1]
- [Assumption 2]

## Open Questions
- [Open question 1]
- [Open question 2]

## Recommended Direction
[Chosen direction so far, including major rationale and notable tradeoffs.]

## Supporting References
- [.paul/PROJECT.md] — compact landing brief
- [.paul/codebase/] — brownfield evidence and codebase map artifacts (if available)
- [Research / interview / design reference]

---
*PRD.md — deeper product-definition context; read selectively*
*Last updated: [YYYY-MM-DD]*
```

---

## Section Specifications

### Problem / Opportunity
**Purpose:** Anchor the work in the real problem, not just the requested implementation.

### Why Now
**Purpose:** Capture urgency, timing, or strategic context that influences prioritization.

### Current State / Existing System Context
**Purpose:** Preserve the current-system reality, especially for brownfield adoption.
**Include:** Existing capabilities, constraints, dependencies, and what must remain stable.

### Desired Outcome
**Purpose:** Describe the future state in product terms.

### Target Users and Needs
**Purpose:** Preserve richer user/problem framing than the hot-path brief needs.

### Requirements
**Purpose:** Hold deeper requirement buckets without overloading PROJECT.md.
**Include:** Must-have, should-have/nice-to-have, explicitly deferred, and out-of-scope distinctions.

### Constraints & Dependencies
**Purpose:** Preserve the constraints and integrations that materially shape planning and implementation.

### Assumptions
**Purpose:** Make hidden assumptions visible so planning and discovery workflows can revisit them.

### Open Questions
**Purpose:** Preserve unresolved items across sessions without turning STATE.md into a backlog dump.

### Recommended Direction
**Purpose:** Record the chosen direction and the rationale behind it.

### Supporting References
**Purpose:** Link to source material rather than duplicating it.

## Authoring Guidance

`PRD.md` should hold the **deeper durable product-definition layer**. It should **not** become:
- a replacement for `STATE.md` or `ROADMAP.md`
- a chronological execution log
- a raw transcript of every brainstorming session
- a dumping ground for temporary notes that were never synthesized

Keep it durable, structured, and selectively readable.
