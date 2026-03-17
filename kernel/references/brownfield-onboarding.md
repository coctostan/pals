<brownfield_onboarding>

## Purpose
Guide for adopting PALS into an existing codebase. Covers the 3-step adoption process, boundary-setting, first milestone scoping, and how brownfield evidence now feeds the layered `PROJECT.md` + `PRD.md` model.

**Core philosophy:** Adopt, don't rewrite. PALS enhances your existing project — it doesn't replace your architecture.

## The 3-Step Adoption Process

### Step 1: Map (`/paul:map-codebase`)
Run `/paul:map-codebase` to understand what exists before making planning or onboarding decisions.

**What it produces:**
- 8 documents in `.paul/codebase/` covering stack, architecture, conventions, testing, integrations, concerns, structure, and reference graph
- GRAPH.md identifies hub files (most-referenced), entry points, and clusters
- ARCHITECTURE.md and CONVENTIONS.md include "Brownfield Quick Start" sections with patterns to preserve

**Key outputs to review:**
- **Hub files** — high-impact targets; changes here affect many files
- **Conventions** — naming, import ordering, patterns to follow
- **Concerns** — existing technical debt to be aware of (not necessarily to fix first)
- **Integrations / stack** — dependencies and environment realities that should inform onboarding

### Step 2: Init (`/paul:init`)
Run `/paul:init` after mapping. Init detects the codebase map and uses it to bridge **current-system evidence** into a shared durable schema:
- `PROJECT.md` becomes the compact landing brief / hot-path artifact
- `PRD.md` becomes the deeper product-definition artifact
- both greenfield and brownfield projects land in the **same durable model**, even though the intake flow differs

**During brownfield init, use the codebase map to:**
- summarize the current system, notable capabilities, and must-preserve patterns
- capture dependencies / integrations / operational realities from the evidence
- confirm constraints discovered in the map instead of guessing
- still ask about the future product direction, user needs, problem/opportunity, and desired outcome

**Important brownfield principle:**
Do not let onboarding become only a codebase dump. The existing system explains today's reality; the user still defines tomorrow's intent.

### Step 3: First Plan (`/paul:plan`)
Create a carefully scoped first milestone. See "First Milestone Scoping" below.

Because `PROJECT.md` is now intentionally concise, use `PRD.md` when the first milestone needs deeper context such as:
- richer problem framing
- deferred items
- assumptions or open questions
- current-state vs desired-state tension
- dependency / integration implications

## Brownfield Durable Artifact Guidance

### `PROJECT.md` should capture
- short description and core value
- concise current-state summary
- scope snapshot (validated / active / planned / out of scope)
- top constraints
- top success metrics
- links to `PRD.md` and `.paul/codebase/`

### `PRD.md` should capture
- problem / opportunity and why now
- current-state / desired-state framing
- detailed requirement buckets
- explicitly deferred items
- assumptions and open questions
- dependencies / integrations
- supporting brownfield references

### `.paul/codebase/` should remain
- the evidence layer
- detailed enough for discovery and implementation support
- linked from durable artifacts instead of duplicated into them wholesale

## Setting Boundaries
Boundaries protect existing code from unintended changes during PALS-managed work.

**How to define boundaries in your first milestone:**
- List directories/files that should NOT be modified: `<boundaries>## DO NOT CHANGE\n- src/auth/* (stable auth system)\n- database/migrations/* (schema locked)</boundaries>`
- Use CONVENTIONS.md findings as implicit boundaries — follow existing patterns
- Start narrow: protect everything except the area you're working on

**Gradual adoption strategy:**
1. Start with ONE subsystem or feature area
2. Protect everything else as boundaries
3. As confidence grows, expand scope in subsequent milestones
4. Eventually the whole codebase is PALS-managed

## First Milestone Scoping

**Recommended first milestones (pick one):**

| Type | Best For | Scope |
|------|----------|-------|
| Bug fix backlog | Projects with known issues | 2-3 phases, each fixing 1-2 related bugs |
| Small feature | Active development | 2-3 phases, one vertical slice |
| Test coverage | Untested codebases | 2-3 phases, adding tests to hub files first |
| Documentation | Complex codebases | 2-3 phases, documenting architecture and APIs |

**Anti-patterns to avoid:**
- Don't refactor everything first — earn trust with small wins
- Don't scope a milestone with more than 3-5 phases initially
- Don't try to fix all CONCERNS.md issues in the first milestone
- Don't change established conventions — follow them
- Don't treat the current implementation as the whole product definition

**Use GRAPH.md to prioritize:**
- Hub files = highest-impact targets for testing and documentation
- Clusters = natural scope boundaries for milestones
- Entry points = good starting points for understanding flow

## Common Scenarios

### Monorepo
- Run `/paul:map-codebase` at the repo root first for overall structure
- Scope milestones per package/service — one `.paul/` per package if needed
- Use GRAPH.md clusters to identify natural package boundaries
- Boundaries: protect other packages while working on one

### Legacy Codebase
- Start with documentation and testing phases, not feature work
- Use CONCERNS.md to create a prioritized tech debt backlog
- First milestone: add tests to the top 5 hub files
- Don't try to modernize everything at once
- Use onboarding to separate current-system facts from desired future outcomes

### Mid-Project (work already in progress)
- Map what exists, identify what's done vs remaining
- Create a milestone for the remaining work only
- Treat completed code as boundaries (protect it)
- Use `/paul:fix` for ad-hoc issues that come up during adoption
- Capture active/deferred scope clearly in `PROJECT.md` + `PRD.md`

### Team Adoption
- One developer starts with PALS, shares `.paul/` via git
- Team reviews first milestone's SUMMARY.md to see the value
- Gradually expand: each developer takes a subsystem
- PALS's session continuity (STATE.md + handoffs) enables async collaboration

## Quick Reference

```text
Brownfield adoption in 3 commands:

1. /paul:map-codebase     → Understand what exists
2. /paul:init             → Create layered PROJECT.md + PRD.md from evidence + product intent
3. /paul:plan             → Create first milestone (start small)

Key files after adoption:
- .paul/codebase/GRAPH.md     → Hub files, clusters (scope guide)
- .paul/codebase/CONVENTIONS.md → Patterns to follow
- .paul/codebase/CONCERNS.md   → Known issues (future milestones)
- .paul/PROJECT.md             → Compact landing brief / hot path
- .paul/PRD.md                 → Deeper product-definition context
```

</brownfield_onboarding>
