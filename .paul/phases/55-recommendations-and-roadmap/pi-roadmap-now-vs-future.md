# Pi Roadmap — Now vs Future

## Purpose
This roadmap translates the completed audit and gap analysis into implementation guidance.

It separates future Pi work into three buckets:
1. **Safe-now improvements** — low-risk, adapter-only, strongly artifact-compatible
2. **Careful adapter layering** — valuable work that needs stronger design discipline
3. **Future-state divergence ideas** — concepts that should remain deferred unless PALS intentionally broadens its platform strategy

This split is intentional. The adapter should improve in stages, not through a single maximal redesign.

---

## Roadmap principles

1. **Shared artifacts remain authoritative**
   - `.paul/*`, workflows, templates, and references stay canonical.

2. **Pi-native improvements should be additive first**
   - Improve discoverability, visibility, and flow before changing deeper runtime behavior.

3. **Sensitive runtime improvements need explicit guardrails**
   - Especially around context injection and runtime persistence.

4. **Do not confuse native feel with semantic divergence**
   - A more Pi-native shell is good.
   - A Pi-only workflow truth source is not.

---

## Track 1 — Safe-now improvements

These are the best near-term candidates because they offer clear value while staying solidly in the adapter layer.

### A. Command routing and discoverability improvements
**Why this belongs here:**
- high user value
- low-to-medium implementation risk
- strong artifact compatibility

**Includes:**
- clearer `/paul-*` descriptions
- command argument completions where useful
- command discovery helpers or selectors
- better lifecycle command guidance

**Dependencies / sequencing:**
- can begin immediately after v2.2
- benefits from the Phase 54 prioritization work already completed

### B. Lifecycle visibility UI
**Why this belongs here:**
- strong Pi-native value
- mostly presentation-layer work over shared artifacts
- low compatibility danger if kept lightweight

**Includes:**
- status/header/widget indicators
- clearer phase/loop/next-action visibility
- stronger resume/status visibility

**Dependencies / sequencing:**
- pairs naturally with command/discoverability improvements
- can follow or run alongside command work

### C. Adapter consistency cleanup
**Why this belongs here:**
- low risk
- fast clarity win
- removes maintenance drag before deeper improvements land

**Includes:**
- help text alignment
- installer comment cleanup
- extension docs alignment
- skill/command wording consistency

**Dependencies / sequencing:**
- can start immediately
- best done early so future changes build on accurate operator-facing docs

### D. Installation strategy clarification
**Why this belongs here:**
- mostly product/packaging clarity
- limited architecture risk

**Includes:**
- decide whether global-only is intentional
- document the rationale clearly
- optionally define future support for local install without implementing it yet

**Dependencies / sequencing:**
- can be decided during the same milestone as command/UI improvements

---

## Track 2 — Careful adapter layering

These improvements are valuable, but should not be treated as casual polish. They touch deeper runtime behavior and need explicit boundaries.

### A. Workflow-state injection redesign
**Why this belongs here:**
- highest-value improvement overall
- directly affects how coherent PALS feels in Pi
- easiest place to accidentally create hidden or duplicated runtime logic

**Includes:**
- evaluating `context` vs `before_agent_start` vs hybrid approaches
- improving trigger quality
- refining what lifecycle context gets injected and when

**Guardrails:**
- `.paul/STATE.md` remains authoritative
- no hidden Pi-only lifecycle state machine
- prompt additions stay concise and recoverable from artifacts

**Dependencies / sequencing:**
- should likely be the centerpiece of the next implementation milestone
- should precede deeper checkpoint or persistence experiments

### B. Guided approval/checkpoint flows in Pi UI
**Why this belongs here:**
- meaningful usability gain
- interacts with lifecycle semantics more directly than passive UI

**Includes:**
- guided plan approval
- decision checkpoints
- better resume routing and confirmation moments

**Guardrails:**
- UI must guide existing artifact-grounded steps, not replace them with Pi-only semantics

**Dependencies / sequencing:**
- best done after or alongside improved workflow-state injection

### C. Bounded Pi persistence for convenience metadata
**Why this belongs here:**
- potentially useful
- easy to misuse
- lowest-confidence compatibility area in near-term work

**Includes:**
- optional transient session annotations
- non-authoritative convenience state
- UI/navigation helpers only if clearly bounded

**Guardrails:**
- no authoritative lifecycle truth in Pi persistence
- no required resume state outside `.paul/*`

**Dependencies / sequencing:**
- should follow the event/state-injection redesign, not precede it

---

## Track 3 — Future-state divergence ideas

These are ideas worth keeping visible, but they should **not** drive near-term implementation.

### A. Pi-only semantic workflow behavior
**Why deferred:**
- would weaken cross-harness parity
- risks moving canonical logic into adapter code

### B. Pi-managed lifecycle truth
**Why deferred:**
- directly conflicts with artifact authority
- creates resume/audit/reconciliation ambiguity

### C. Deep Pi specialization that weakens portability
**Why deferred:**
- may improve native feel locally
- but would erode the core value of PALS as a harness-agnostic system

### D. Aggressive runtime/state experiments before adapter basics are mature
**Why deferred:**
- the current adapter still has safer, higher-leverage work available first
- premature advanced behavior would increase risk without solving the most visible weaknesses

---

## Suggested sequencing

## Milestone 1: v2.3 Pi Interaction Model Refinement
Focus on the most important and safest high-value work:
- workflow-state injection redesign
- command routing and discoverability improvements
- adapter consistency cleanup

**Why first:**
This directly addresses the most important Phase 54 findings while staying close to the adapter layer.

## Milestone 2: v2.4 Pi Native UX Layer
Layer in stronger presentation and guided interaction once the interaction model is clearer:
- lifecycle visibility UI
- guided workflow and checkpoint affordances
- resume/help/status polishing

**Why second:**
UI quality will be better if it sits on top of a clearer activation and context architecture.

## Milestone 3: v2.5 Pi Advanced Runtime Options
Only after the adapter shell is more mature, evaluate:
- installation scope options if still open
- bounded persistence experiments
- packaging/distribution refinement

**Why third:**
These are valuable, but less urgent and easier to mis-sequence if attempted before the interaction model is stable.

---

## What should be deferred and why

### Defer full adapter redesign
Because Phases 53 and 54 showed the architecture is fundamentally correct.

### Defer Pi-only lifecycle semantics
Because they would create a competing workflow truth source.

### Defer deeper runtime state until boundaries are proven
Because persistence and runtime control are the easiest places for hidden divergence to appear.

---

## Roadmap summary table

| Track | Focus | Example items | Why now / later |
|------|-------|---------------|-----------------|
| Safe-now | High-value additive adapter improvements | command ergonomics, lifecycle visibility UI, docs cleanup, install-strategy clarification | Strong value with low compatibility risk |
| Careful layering | Runtime-sensitive adapter improvements | context/event redesign, guided checkpoints, bounded persistence | Important, but needs stronger guardrails |
| Future-state divergence | Concepts that risk platform-specific truth | Pi-only lifecycle semantics, deep specialization, competing state sources | Keep deferred unless platform strategy changes |

---

## Bottom line
The roadmap should not be interpreted as:
- “everything Pi can do should be used now”
- or “the current adapter is too flawed to build on”

Instead, it should be read as:

> **Build a better Pi-native shell in stages, starting with the safest and highest-leverage improvements, while preserving shared artifact authority at every step.**