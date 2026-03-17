# Recommended Artifact Model for Phase 67

## Goal
Define the durable information model PALS should use for richer onboarding and product-definition work, while preserving artifact-first authority, portability, and practical context usage.

## Recommendation Summary
PALS should move to a **layered durable model**:
- keep **`PROJECT.md`** as the compact, hot-path project/product landing artifact
- add a deeper **`PRD.md`** as the selectively-read product-definition artifact
- use temporary onboarding/discussion handoff artifacts to gather raw thinking, then sync durable conclusions into these two artifacts

This is **one conceptual model with two read layers**, not two unrelated truths.

That recommendation changes my earlier instinct that `PROJECT.md` alone might be enough. Given the current hot-path usage of `PROJECT.md` and the repo's already-large live file, the stronger fit is a layered model with explicit ownership.

## Why This Direction Fits the User Guidance
This recommendation honors the user decisions made during planning:
- **greenfield and brownfield converge to the same durable schema**
- **context efficiency matters**, but as a **soft preference** rather than a hard cap
- **content model and read model should be decided before file count**
- **research should precede implementation**

## Content Model

### Principle
The durable model should preserve the same core product-definition concepts for both greenfield and brownfield projects. The **intake path differs**, but the **durable schema converges**.

### Durable concepts PALS should preserve
These are the concepts that should exist in long-lived form after onboarding or major product-definition work:

1. **Identity & framing**
   - what this is
   - core value
   - why now / strategic context

2. **Users & outcomes**
   - primary users / operators
   - important secondary users
   - problem / opportunity being addressed
   - desired outcomes

3. **Scope & requirements**
   - must-haves / required outcomes
   - active scope / next scope
   - out-of-scope items
   - explicitly deferred items

4. **Constraints & dependencies**
   - technical constraints
   - business constraints
   - compliance / security constraints
   - known dependencies / integrations

5. **Questions & uncertainty**
   - assumptions
   - open questions
   - unresolved risks

6. **Current-state understanding**
   - current system / current workflow context
   - existing capabilities or notable gaps
   - brownfield evidence links when relevant

7. **Success measurement**
   - success metrics
   - adoption / value indicators

8. **Decision memory**
   - key durable decisions
   - links to related research / summaries / codebase docs

### Shared schema, different intake
#### Greenfield intake should emphasize
- users
- problem/opportunity
- desired outcome
- success signals
- must-haves vs deferred ideas
- assumptions / risks

#### Brownfield intake should emphasize
- current system capabilities
- dependency and integration reality
- constraints from the existing codebase and operations
- what is changing vs what must remain stable
- the future product direction beyond today's implementation

Both flows should still populate the same durable concepts listed above.

## Read Model

### Principle
Not every durable fact belongs on the hot path.

PALS should treat durable information in **three read bands**:

### 1. Hot path — read frequently
This is the information many lifecycle flows can legitimately need often.

**Read by default in:**
- resume/status/help-style orientation
- planning entry points
- pause / continuity views
- milestone transitions where a quick project reminder is needed

**Should stay concise and structured:**
- what this is
- core value
- status / current state summary
- top users (summary level)
- scope snapshot (validated / active / planned / out-of-scope summary)
- top constraints
- key metrics summary
- key decisions summary
- links to deeper artifacts

### 2. Warm path — read for planning and discovery work
This is useful during:
- onboarding continuation
- discuss / milestone / plan work
- research phases
- assumption review

**Includes:**
- detailed requirements buckets
- deferred items
- assumptions
- open questions
- richer user/problem framing
- current-state / future-state framing

### 3. Cold path — read only when needed
This includes:
- detailed brownfield evidence
- codebase map artifacts
- research notes
- interview notes
- extensive rationale and appendices

**Read only when a workflow genuinely needs it.**

### Practical rule
PALS does **not** need a hard size limit for every durable artifact, but it **should**:
- keep hot-path artifacts intentionally concise
- use headings, tables, and lists
- avoid duplicating deep rationale in the frequently-read layer
- prefer links/references to appendices and discovery artifacts when detail grows

## File Model

## Recommended file model: layered two-document durable design

### `PROJECT.md` — hot-path landing artifact
**Role:** the compact, durable operating brief for the repo/product.

**Canonical responsibilities:**
- what this is
- core value
- current state summary
- target users (summary)
- scope summary (validated / active / planned / out-of-scope)
- top constraints
- key success metrics
- key durable decisions
- links to `PRD.md`, codebase artifacts, and milestone/phase summaries as needed

**Should not become:**
- the full design appendix
- a giant running transcript of every product conversation
- the place where every open question and alternative lives forever
- a chronological ledger of every phase-level accomplishment

### `PRD.md` — selectively-read product-definition artifact
**Role:** the deeper durable product-definition layer.

**Canonical responsibilities:**
- problem / opportunity framing
- target users and jobs-to-be-done style context
- current-state vs desired-state framing
- detailed requirements buckets
- explicit deferred items
- assumptions
- open questions
- dependencies / integrations / environment needs
- chosen direction and rationale
- links to supporting research, interviews, codebase evidence, and design references

**Should not become:**
- a dump of every temporary exploratory note
- a replacement for `STATE.md` / `ROADMAP.md`
- a place to track lifecycle execution status

### Temporary handoff artifacts
PALS should also support a temporary onboarding/discovery artifact for raw shaping sessions.

**Recommended role:**
- capture the conversational output of onboarding/discovery
- preserve alternatives, unresolved questions, and collaboration posture across session boundaries
- be consumed into `PROJECT.md` + `PRD.md`

This mirrors how `CONTEXT.md` and `MILESTONE-CONTEXT.md` already work elsewhere in PALS.

## Why not the alternatives?

### Why not one big `PROJECT.md`?
This is the simplest conceptual model, but it fights the observed usage pattern:
- `PROJECT.md` is already broadly referenced
- the live file is already large
- humans and LLMs both tend to read whole files unless the workflow discipline is very strong

A single giant file would likely re-create the same problem the user identified.

### Why not completely separate "project" and "product" worlds?
That would create unnecessary semantic drift. PALS works best when there is one durable understanding of what the repo/product is trying to achieve. The split should be by **read depth and artifact responsibility**, not by competing truth models.

## Recommended durable schema layout

### `PROJECT.md` suggested sections
- `## What This Is`
- `## Core Value`
- `## Current State`
- `## Scope Snapshot`
  - Validated
  - Active
  - Planned
  - Out of Scope
- `## Target Users`
- `## Constraints`
- `## Success Metrics`
- `## Key Decisions`
- `## Links`

### `PRD.md` suggested sections
- `## Problem / Opportunity`
- `## Why Now`
- `## Current State / Existing System Context`
- `## Desired Outcome`
- `## Target Users and Needs`
- `## Requirements`
  - Must Have
  - Should Have / Nice to Have
  - Explicitly Deferred
  - Out of Scope
- `## Constraints & Dependencies`
- `## Assumptions`
- `## Open Questions`
- `## Recommended Direction`
- `## Supporting References`

## Workflow Implications for the Follow-On Implementation Plan
The next plan after this research phase should implement at least these changes:

1. **Init / onboarding workflow changes**
   - redesign the intake conversation so questions are distinct and purpose-built
   - add stronger greenfield discovery prompts
   - add brownfield evidence-to-product bridging prompts
   - write durable outputs into `PROJECT.md` and `PRD.md`

2. **Template changes**
   - update `kernel/templates/PROJECT.md` to reflect the hot-path landing role
   - add a new `kernel/templates/PRD.md`
   - potentially add an onboarding/discovery handoff template

3. **Workflow reading changes**
   - keep many workflows reading `PROJECT.md` as the first stop
   - read `PRD.md` selectively in onboarding, discuss, planning, research, and assumption-oriented workflows
   - avoid reflexively loading both artifacts everywhere

4. **Brownfield integration changes**
   - map-codebase evidence should feed brownfield onboarding fields more directly
   - preserve current-system context without letting it overwhelm future product direction

5. **Validation changes**
   - extend artifact/validation rules beyond the current minimal `Description` / `Core Value` / `Requirements` contract
   - validate the new durable schema and artifact roles
   - protect portability by keeping the new artifact model shared across harnesses

6. **Migration strategy for existing projects**
   - define how legacy `PROJECT.md` files are normalized or split
   - prefer additive migration over destructive rewrites

## Implementation Guidance
### What to preserve from current PALS
- `.paul/*` remains the authority
- shared markdown remains the workflow truth
- collaboration level and planning mode remain shared workflow behavior
- brownfield mapping remains evidence-first

### What to change
- onboarding should capture product definition, not just project identity
- the durable model should explicitly preserve assumptions / open questions / deferred items
- the hot-path artifact should be concise by design
- deeper product definition should be durable but selectively loaded

## Final Recommendation
PALS should adopt a **layered durable artifact model**:
- **`PROJECT.md` = compact landing brief / hot path**
- **`PRD.md` = deeper product-definition layer / selective read**
- **temporary onboarding context = raw shaping, later distilled**

This is the cleanest way to satisfy all of the constraints discovered in Phase 67 planning:
- richer onboarding
- explicit requirement preservation
- greenfield/brownfield convergence
- context efficiency as a design concern
- no Pi-only or harness-specific truth

## Bottom Line
Project and PRD are **conceptually related**, but they are **not operationally identical** in a context-sensitive system like PALS.

For PALS, the right move is:
- **one conceptual product model**
- **two durable read layers**
- **shared schema, different intake paths**

That gives Phase 67 a strong foundation for implementation without forcing either oversimplification or runaway artifact sprawl.
