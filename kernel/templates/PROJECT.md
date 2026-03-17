# PROJECT.md Template

Template for `.paul/PROJECT.md` — the compact hot-path project brief.

**Purpose:** Provide the concise landing context many workflows can read quickly: what this project is, why it matters, what is currently in scope, the most important constraints, and where to find deeper product-definition detail.

---

## File Template

```markdown
# Project: [Project Name]

## Description
[1 short paragraph describing what this project/product is. Focus on the product or capability, not the implementation details.]

## Core Value
[Single sentence: what problem does this solve for whom?]

## Current State
| Attribute | Value |
|-----------|-------|
| Version | [current version] |
| Status | [Discovery / Prototype / MVP / Beta / Production] |
| Last Updated | [YYYY-MM-DD] |

**Current system summary:**
- [For greenfield: "New project"]
- [For brownfield: concise current-system reality, notable capabilities, or migration posture]

## Scope Snapshot
### Validated
- [x] [Already shipped capability or requirement]

### Active
- [ ] [Current must-have outcome or near-term priority]

### Planned
- [ ] [Next likely scope item]

### Out of Scope
- [Explicitly excluded item] — [reason]

## Target Users
**Primary:** [Main user or operator]
- [Key need or job to be done]

**Secondary:** [Optional secondary audience]
- [Relevant note]

## Constraints
- [Top technical / business / compliance constraint]
- [Existing-system constraint or pattern to preserve]

## Success Metrics
- [Outcome or signal that shows the project is succeeding]
- [Optional adoption / business / operational metric]

## Key Decisions
| Decision | Rationale | Date | Status |
|----------|-----------|------|--------|
| [Decision] | [Why] | [YYYY-MM-DD] | Active |

## Links
- `PRD.md` — deeper product definition, assumptions, deferred items, and open questions
- `.paul/ROADMAP.md` — milestone and phase structure
- [.paul/codebase/] — brownfield evidence and codebase map artifacts (if available)

---
*PROJECT.md — compact landing brief; keep it intentionally concise*
*Last updated: [YYYY-MM-DD]*
```

---

## Section Specifications

### Description
**Purpose:** Short product/project framing.
**Length:** One paragraph.
**Focus:** What it is, not the full rationale or design history.

### Core Value
**Purpose:** The one-line value statement used across orientation and planning flows.
**Format:** Single sentence answering “what problem for whom?”

### Current State
**Purpose:** Fast situational awareness.
**Include:** Version/status plus a brief current-system summary.
**Why:** Helps orientation flows and planning entry points without forcing deep reads.

### Scope Snapshot
**Purpose:** Show scope posture at a glance.
**Include:** Only concise bullets for Validated, Active, Planned, and Out of Scope.
**Why:** This is the hot-path replacement for dumping deep requirement detail into PROJECT.md.

### Target Users
**Purpose:** Keep the main audience visible on the hot path.
**Include:** Summary-level user notes only.
**Detailed user/problem framing belongs in PRD.md.**

### Constraints
**Purpose:** Surface the highest-impact limits and must-preserve realities.
**Include:** Only the most important constraints. Put deeper dependency or environment detail in PRD.md.

### Success Metrics
**Purpose:** Keep project success anchored to outcomes.
**Include:** A few top signals or measurable goals.

### Key Decisions
**Purpose:** Preserve durable, high-signal decisions.
**Include:** Only decisions that materially affect planning or execution.

### Links
**Purpose:** Point to deeper artifacts instead of duplicating them.
**At minimum:** Link to `PRD.md` and roadmap/state artifacts as relevant.

## Authoring Guidance

`PROJECT.md` should remain the **compact landing brief**. It should **not** become:
- the full product-design appendix
- the home for every assumption or open question
- a dump of brownfield codebase findings
- a chronological ledger of every phase accomplishment

When detail grows, summarize here and move the deeper material into `PRD.md`, research files, or codebase artifacts.
