# Current-State Audit: Onboarding & Artifact Model

## Goal
Document how PALS currently handles onboarding and durable project context, where the current flow loses product-definition depth, and why Phase 67 should treat artifact design as a first-class concern before implementation.

## Surfaces Reviewed
- `kernel/workflows/init-project.md`
- `kernel/templates/PROJECT.md`
- `.paul/PROJECT.md`
- `kernel/references/brownfield-onboarding.md`
- `kernel/references/context-management.md`
- `kernel/workflows/plan-phase.md`
- `kernel/workflows/discuss-phase.md`
- `kernel/workflows/discuss-milestone.md`
- `tests/cross-harness-validation.sh`
- `grep` usage scan of `.paul/PROJECT.md` references across `kernel/` and `tests/`

## Executive Summary
PALS already has the beginnings of a strong product/project brief model, but the current onboarding flow does not populate it well enough and the live `PROJECT.md` has drifted into a mixed-purpose artifact.

The core problems are:
1. **Onboarding is too shallow** for both greenfield and brownfield work.
2. **The current init prompts partially duplicate each other** (`core value` vs `what are you building?`) while still missing key product-definition questions.
3. **The template promises a richer artifact than init actually creates.**
4. **The live `PROJECT.md` is already large and broadly referenced**, so blindly deepening it would create hot-path context pressure.
5. **Brownfield guidance is good at adoption safety, but not yet strong at product-definition capture.**

## Findings

### 1. Greenfield onboarding currently asks for identity, not real product definition
`init-project.md` currently establishes planning posture, then asks:
- "What's the core value this project delivers?"
- "What are you building? (1-2 sentences)"
- project name confirmation

That is enough to initialize a repo brief, but not enough to create a durable product definition.

What is missing from the greenfield intake:
- target users / audience
- problem statement / pain point
- why now / business context
- success metrics
- explicit must-haves vs deferred ideas vs out-of-scope
- assumptions
- open questions
- risks or notable constraints beyond a placeholder

**Implication:** the current flow produces project identity, not a real product brief or PRD-quality foundation.

### 2. The current onboarding questions partly overlap
The user's observation is accurate: "core value" and "what are you building?" are not the same, but in practice they are close enough that the current conversation can feel repetitive while still staying shallow.

Today the flow asks for:
- a single-sentence value statement
- a 1-2 sentence description

This creates a weak tradeoff:
- enough overlap to feel repetitive
- not enough depth to clarify users, outcomes, or scope

**Implication:** Phase 67 should not just "add more questions." It should redesign the intake sequence so each question has a distinct job.

### 3. `init-project.md` creates a much smaller artifact than `PROJECT.md` template suggests
`kernel/templates/PROJECT.md` already defines a richer durable structure than init actually uses. The template includes:
- What This Is
- Core Value
- Current State
- Requirements: Validated / Active / Planned / Out of Scope
- Target Users
- Context
- Constraints
- Key Decisions
- Success Metrics
- Tech Stack
- Links

But `init-project.md` currently writes a much simpler structure:
- Description
- Core Value
- Requirements (`Must Have`, `Should Have`, `Nice to Have` placeholders)
- Constraints
- Success Criteria

**Implication:** the architecture already points toward a richer durable artifact, but the actual onboarding flow under-populates it. Phase 67 is not inventing a brand new need so much as reconciling the workflow with the artifact ambition.

### 4. The live `PROJECT.md` has drifted into a mixed-purpose artifact
The current repo's `.paul/PROJECT.md` is:
- **266 lines**
- **4,515 words**
- **29,054 characters**
- approximately **"~7k tokens" class** in practical LLM terms

It currently functions as a mix of:
- durable project brief
- requirements ledger
- shipped-features history
- milestone changelog
- architecture constraints list
- long-running decisions register

At the same time, the live file does **not** currently expose several product-definition sections the template suggests, such as:
- `## Target Users`
- `## Success Metrics`
- `### Out of Scope`
- richer `Context` sections

So the current file is already large, but not yet optimally structured for product-definition clarity.

**Implication:** Phase 67 should optimize for information shape and access pattern, not just add more prose.

### 5. Important requirement buckets are still weak or missing in durable form
The live onboarding and durable artifact model still under-represents several distinctions the user explicitly cares about:
- required vs optional
- deferred vs forgotten
- assumptions vs facts
- open questions vs resolved decisions
- hot-path summary vs deep product context

Phase 65 already identified these as gaps, and the current live state still reflects that diagnosis.

**Implication:** the Phase 67 artifact model should explicitly preserve:
- requirements
- constraints
- deferred items
- assumptions
- open questions
- out-of-scope items

### 6. Brownfield onboarding is stronger on adoption safety than on product-definition depth
`brownfield-onboarding.md` is directionally strong. It emphasizes:
- map first
- adopt, don't rewrite
- preserve conventions
- protect stable areas with boundaries
- scope the first milestone narrowly
- use hubs/clusters/dependencies to reduce risk

That is good brownfield discipline.

But the brownfield guidance is still mostly about:
- understanding the existing system
- setting boundaries
- choosing safe first milestones

It is not yet equally strong on:
- articulating user/problem/outcome framing for the product's next evolution
- preserving durable product intent separately from technical observations
- distinguishing the current system from the future product direction

`init-project.md` does mention that brownfield init can pre-populate stack, architecture, and discovered constraints, but the actual conversation remains shallow and still centers on the same core-value/description pair.

**Implication:** brownfield onboarding should stay evidence-first, but it also needs a better bridge from current-system understanding to future product intent.

### 7. Greenfield and brownfield already differ in intake source, but not in a designed shared schema
Today the difference is mostly this:
- **greenfield** starts from user answers only
- **brownfield** can enrich those answers with codebase mapping output

That is useful, but not yet a complete model.

The current system does **not** clearly define:
- what durable fields both flows should converge to
- which fields come from user discovery vs codebase evidence
- which information is permanent vs temporary vs selectively-read

**Implication:** the durable schema needs to be explicitly designed, with greenfield and brownfield treated as different intake paths into the same long-lived structure.

### 8. `PROJECT.md` is on the hot path often enough that read-cost should influence design
A repo scan shows `.paul/PROJECT.md` is referenced broadly across kernel commands, workflows, templates, rules, and tests.

Representative hot-path or near-hot-path usage includes:
- `plan-phase.md`
- `discuss-phase.md`
- `discuss-milestone.md`
- `pause-work.md`
- `resume`/`help`/`research`/`knowledge` command surfaces
- milestone completion and transition workflows
- validation checks in `tests/cross-harness-validation.sh`

This matters because `context-management.md` explicitly says:
- load what you need
- avoid kitchen-sink context
- prefer summaries over full historical artifacts
- use progressive detail

But the workflow conventions still often name `PROJECT.md` as a default context source.

**Implication:** if PALS deepens product-definition capture, it should think in terms of:
- **hot-path fields** that are frequently useful
- **selectively-read detail** used for onboarding, planning, or research

Even if compactness is a soft preference rather than a hard cap, access pattern should shape the artifact design.

### 9. Validation currently assumes only a minimal `PROJECT.md` contract
`tests/cross-harness-validation.sh` currently checks only that `PROJECT.md` has:
- `Description`
- `Core Value`
- `Requirements`

That is a very small contract compared to the template and compared to the product-definition needs discussed in Phase 65/67.

**Implication:** any richer durable model will require validation changes, and the design should be deliberate about which sections are mandatory, optional, or selectively present.

## Design Tensions Exposed by the Audit

### Tension A: richer onboarding vs low friction
PALS should gather more than it does today, but "more questions" alone is not a win. The right target is a better structured intake, not a heavier ceremony for every project.

### Tension B: one durable truth vs hot-path context cost
A single durable artifact is attractive for simplicity, but current usage patterns mean a large catch-all document can become expensive and noisy.

### Tension C: brownfield evidence vs product strategy
Brownfield onboarding must start with codebase reality, but the durable artifact should still preserve product direction, not just architectural facts.

### Tension D: flexible collaboration vs durable structure
Phase 66 made planning more collaborative. Phase 67 now needs a durable schema strong enough to preserve what those conversations produce.

## What This Means for Phase 67
Phase 67 should not jump straight into rewriting init prompts or expanding `PROJECT.md`.

The correct order is:
1. define the **content model** (what durable information should exist)
2. define the **read model** (what is hot-path vs selectively-read)
3. define the **file model** (one doc, two docs, or a layered hybrid)
4. only then update workflows, templates, docs, and validation

## Bottom Line
PALS already has the right instincts:
- shared durable artifacts
- brownfield mapping
- progressive planning collaboration
- context-efficiency awareness

But today it still has a gap between:
- what onboarding collects,
- what templates imply,
- what the live project artifact has become, and
- what the lifecycle can afford to read frequently.

That is the real Phase 67 design problem.
