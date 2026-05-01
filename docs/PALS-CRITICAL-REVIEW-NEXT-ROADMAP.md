# PALS Critical Review and Proposed Next Roadmap

**Status:** exploratory planning artifact, not an approved PALS milestone yet  
**Created:** 2026-04-30  
**Context:** v2.54 Contextual Verbosity Paring is complete. This document steps back from implementation detail and records a critical product/architecture review plus a proposed multi-phase next milestone.

## Executive Take

PALS is strong as a lifecycle/governance system and weaker as a maintainable product surface.

Its biggest strengths are artifact-first lifecycle truth, explicit authority boundaries, durable evidence, and dogfooded process discipline. Its biggest weaknesses are process weight, brittle marker-based validation, large source gravity wells, and limited real-world usefulness evidence outside its own lifecycle artifacts.

The next milestone should not add another major feature. It should make the existing system cheaper to maintain, easier to validate, easier to explain, and harder to drift.

Recommended next milestone:

> **v2.55 Maintainability & Product Reality Hardening**

One-sentence goal:

> Keep PALS' safety and traceability, but make that safety cheaper, more maintainable, and easier for a new user to feel.

## Strengths

### 1. Artifact-first lifecycle truth

PALS' best architectural decision is that `.paul/*` artifacts, shared workflows, installed module registry evidence, git/PR evidence, and validation output remain authoritative.

Pi/runtime helpers are explicitly derived aids. They can orient, summarize, route, and reduce repeated context cost, but they do not own lifecycle state.

This keeps the project portable, auditable, and recoverable across sessions.

### 2. Clear safety boundaries

PALS is unusually explicit about what must remain protected:

- explicit user approval before APPLY
- PLAN/APPLY/UNIFY lifecycle authority
- parent-owned APPLY verification
- module dispatch evidence
- command-output validation truth
- GitHub Flow gates
- no helper-owned `.paul/*` lifecycle writes
- no Pi-owned lifecycle/module/validation ledger
- full authoritative read fallback before consequential work

These boundaries are a real product asset.

### 3. Strong dogfooding and historical memory

The project records decisions, phase summaries, validation counts, merge evidence, module reports, scope checks, and deferred boundaries. That history makes the project explainable and lets future agents understand why choices were made.

For a process product, this is especially valuable.

### 4. Coherent Pi-native direction

The support-tier reset to "Pi supported, Claude Code / Agent SDK frozen historical surfaces" reduced product ambiguity.

The current target architecture is coherent:

- Pi improves UX, routing, context loading, guided prompts, and bounded delegation.
- Markdown artifacts and shared workflows remain lifecycle authority.
- Validation is increasingly classified by purpose rather than treated as undifferentiated parity.

### 5. Context efficiency is now a product capability

Artifact slices, workflow/resource capsules, delegated APPLY packets, and contextual verbosity paring all support the same thesis: reduce repeated orientation cost without hiding required proof.

That is a differentiated product direction: inspectable context compression for agentic lifecycle work.

## Weaknesses

### 1. Process weight is high

PALS is safe, but small changes can still carry a heavy process tax:

- lifecycle artifacts
- module dispatch evidence
- validation marker checks
- GitHub Flow evidence
- Workguard/scope proof
- summaries/history updates

This is appropriate for risky lifecycle/runtime changes, but heavy for low-risk documentation or small polish changes.

The system needs clearer proportionality: tiny changes, normal changes, risky changes, and hotfixes should not all feel equally ceremonial.

### 2. Validation is broad but brittle

The validation suites are impressive but fragile:

- `tests/pi-end-to-end-validation.sh` is roughly 1,752 lines.
- `tests/cross-harness-validation.sh` is roughly 1,323 lines.
- Many checks are marker/prose based.
- Exact strings can become accidental APIs.
- Refactors can fail because wording changed, not behavior.

v2.54 exposed this directly: initial paring broke exact protected markers, then had to restore them.

The validation suites protect important contracts, but their shape now creates maintenance risk.

### 3. `drivers/pi/extensions/pals-hooks.ts` is a gravity well

The supported Pi runtime implementation has grown into a large multipurpose file of roughly 1,684 lines.

It owns too many concerns:

- command routing
- activation state
- lifecycle UI
- artifact slices
- workflow/resource capsules
- guided workflow detection
- CARL session boundaries
- module activity parsing

This is now a maintainability risk. It is the main supported runtime surface, so changes should become easier to isolate and test.

### 4. Modules are powerful but too prose-driven

The module system is conceptually strong, but much of the behavior lives in YAML prose and workflow instructions.

That makes modules easy to add, but harder to test as units. A stronger model would make hook inputs, outputs, severity, blocking status, and report shape more structured and machine-checkable.

### 5. Onboarding is intimidating

The README is accurate, but the product has many moving parts:

- PAUL/CARL/TODD/WALT/SKIP/etc.
- 18 modules
- Pi skills
- Pi extension
- artifact slices
- workflow/resource capsules
- guided workflow
- helper delegation
- GitHub Flow modes
- frozen legacy drivers

The first-run story needs to be simpler. A new user needs to feel the value before learning the architecture.

### 6. Artifact drift still happens

Example observed after v2.54: `.paul/MILESTONES.md` still described v2.54 as in progress / Phase 231 ready to plan, while `.paul/STATE.md` said v2.54 was complete.

That drift is small but important. PALS exists to preserve lifecycle truth, so index artifacts should be mechanically checked for consistency.

### 7. Usefulness evidence is weaker than structural evidence

PALS has strong validation around markers, install surfaces, and invariant preservation. It has less evidence around product outcomes:

- time saved
- context saved per phase
- fewer missed validations
- fewer agent mistakes
- usability for someone other than the project author
- quality difference versus ad hoc Pi usage

The product would be stronger with local, non-telemetry evidence of actual usefulness.

## Improvement Themes

### A. Make safety proportional

Introduce clearer intensity tiers for work:

| Tier | Use case | Expected ceremony |
|---|---|---|
| Tiny/doc-only | bounded docs or marker-only edits | minimal plan, focused verification, short summary |
| Normal | ordinary implementation | current lifecycle with scoped verification |
| Risky | runtime/lifecycle/validation/GitHub Flow changes | full module/validation/scope/review evidence |
| Hotfix | urgent repair | patch first inside strict bounds, reconcile after |

The goal is not to weaken safeguards. The goal is to avoid applying the same weight to every change.

### B. Decompose validation

Split giant shell suites into maintainable components:

- TAP helpers
- install checks
- skill wrapper contract checks
- extension/runtime contract checks
- workflow prose contract checks
- artifact/process consistency checks
- legacy parity checks
- validation classification checks

Longer term, move selected behavior checks into fixture-driven tests rather than string-only markers.

### C. Modularize the Pi extension

Extract concerns from `pals-hooks.ts` into focused modules, starting with low-risk pure helpers.

Candidate modules:

- `activation.ts`
- `state-parser.ts`
- `artifact-slices.ts`
- `resource-capsules.ts`
- `guided-workflow.ts`
- `lifecycle-ui.ts`
- `module-activity.ts`
- `carl-boundary.ts`
- `commands.ts`

The first extraction should preserve behavior exactly and prove the validation/build path before broader refactors.

### D. Structure module outputs

Move toward a standard module report envelope:

```yaml
module: WALT
hook: post-apply
status: pass | warn | block | skipped
severity: none | low | medium | high | critical
evidence:
  - command: ...
    result: ...
decision: continue | block | needs-user
```

Human-readable module reports should remain, but structured fields would reduce prose parsing and make validation/reporting safer.

### E. Add artifact drift reconciliation

Add a lightweight consistency check for hot lifecycle/index artifacts:

- STATE current milestone matches MILESTONES live pointer.
- ROADMAP current state matches STATE.
- latest SUMMARY exists for completed phase.
- Session continuity `Resume file` exists.
- completed milestone index is updated after milestone closure.
- copied validation counts are clearly historical or current.

This should catch stale lifecycle index drift without making `.paul/*` harder to edit.

### F. Build a first-run happy path

Create a short path that demonstrates the product in under 10 minutes:

1. Install PALS.
2. Initialize a toy project.
3. Create one plan.
4. Apply one small change.
5. Unify.
6. Show exactly what PALS protected or saved.

The goal is product clarity, not architecture completeness.

### G. Measure context efficiency locally

Add local, artifact-backed context-cost evidence without telemetry:

```md
Context Cost Evidence:
- Slice payload chars: 2.7k
- Estimated full-read chars avoided: 42k
- Required fallback reads: 1
- Full authoritative reads avoided: 3
```

This would make context-efficiency work measurable instead of only plausible.

## Proposed Next Milestone

### v2.55 Maintainability & Product Reality Hardening

**Purpose:** Reduce maintenance risk and product friction without adding new lifecycle authority or weakening existing safety contracts.

**Scope:** Audit and harden the current system's maintainability, validation shape, Pi runtime modularity, artifact consistency, and first-run product story.

**Non-goals:**

- no broad runtime behavior redesign
- no weakening PLAN/APPLY/UNIFY
- no hidden Pi state or telemetry
- no removal of validation checks without classification/replacement
- no broad module rewrite
- no GitHub Flow gate changes
- no helper-owned lifecycle authority

## Proposed Phase Map

This maps the next 8 phases after Phase 233. Phase numbers assume v2.55 starts at Phase 234.

| Phase | Name | Primary outcome |
|---:|---|---|
| 234 | Product Reality + Drift Audit | Critical inventory of stale artifacts, oversized files, brittle validation areas, onboarding friction, and measurement gaps. |
| 235 | Risk-Tiered Lifecycle Contract | Design proportional safety tiers for tiny, normal, risky, and hotfix work without weakening required gates. |
| 236 | Validation Suite Decomposition Baseline | Document and begin splitting validation concerns into maintainable sections/helpers while preserving current counts. |
| 237 | Artifact Consistency Guardrails | Add lightweight checks for STATE/ROADMAP/MILESTONES/SUMMARY/session-continuity drift. |
| 238 | Pi Extension Modularization Contract | Define extraction boundaries for `pals-hooks.ts` and select the first low-risk subsystem to extract. |
| 239 | Bounded Pi Extension Extraction Spike | Extract one pure subsystem, validate behavior preservation, and prove the modularization path. |
| 240 | Product Happy Path + Scenario Evidence | Create a simple first-run path and at least one scenario-style validation/story that shows user value. |
| 241 | Evidence Closure + Next Roadmap Decision | Reconcile validation, drift, maintainability evidence, and decide whether v2.56 should focus on validation architecture, Pi extension modularization, or module output schema. |

## Phase Details

### Phase 234 — Product Reality + Drift Audit

**Goal:** Create a grounded maintainability/product audit before changing implementation.

**Key questions:**

- Which files are maintenance gravity wells?
- Which validation checks are brittle exact-marker contracts?
- Which lifecycle/index artifacts are stale or prone to drift?
- Where does onboarding feel too complex?
- Where do we lack evidence of actual usefulness?

**Expected outputs:**

- `docs/PALS-MAINTAINABILITY-PRODUCT-REALITY-AUDIT.md`
- ranked weakness list
- file-size / hotspot inventory
- artifact drift inventory
- validation brittleness inventory
- first-run friction notes
- recommendations for Phases 235-241

**Verification:**

- focused marker checks for audit sections
- existing Pi validation
- existing cross-harness validation, unless explicitly scoped as not required for docs-only audit

### Phase 235 — Risk-Tiered Lifecycle Contract

**Goal:** Define a proportional safety model so small changes can be cheap while risky changes remain strict.

**Expected outputs:**

- risk-tier contract doc or workflow reference update
- criteria for tiny/doc-only, normal, risky, and hotfix work
- required evidence per tier
- explicit non-bypass rules for approval, validation truth, GitHub Flow, module blockers, and lifecycle writes

**Important boundary:**

This phase should design the model first. It should not silently relax APPLY/UNIFY behavior.

**Verification:**

- markers proving required gates remain intact
- validation remains green
- no runtime/lifecycle authority weakening

### Phase 236 — Validation Suite Decomposition Baseline

**Goal:** Reduce validation maintenance risk by mapping and beginning safe decomposition.

**Expected outputs:**

- validation component map
- shared TAP/helper extraction plan
- classification of marker-only vs behavioral checks
- first small extraction if safe, such as shared helper functions or section data comments

**Candidate decomposition areas:**

- installer deployment/parity
- skill wrapper contract
- extension runtime contract
- artifact-slice/capsule contract
- guided workflow safety
- helper delegation boundaries
- context-diet regression guards
- artifact/process consistency
- frozen legacy parity

**Verification:**

- Pi validation count remains reconciled
- cross-harness validation count remains reconciled
- no check removed unless explicitly rehomed or classified

### Phase 237 — Artifact Consistency Guardrails

**Goal:** Catch lifecycle/index drift such as stale MILESTONES live pointers after milestone closure.

**Expected outputs:**

- localized artifact consistency checks
- documented consistency contract for hot artifacts
- repair of any discovered stale pointers

**Candidate checks:**

- STATE milestone/phase/loop agrees with ROADMAP current status
- MILESTONES live pointer does not contradict STATE
- latest completed phase SUMMARY exists
- Session Continuity `Resume file` exists
- milestone completion updates the compact milestone index

**Verification:**

- one or more localized validation guardrails
- no broad validation refactor unless Phase 236 already authorized it
- repaired artifacts remain source-of-truth consistent

### Phase 238 — Pi Extension Modularization Contract

**Goal:** Plan modularization of `drivers/pi/extensions/pals-hooks.ts` before changing runtime behavior.

**Expected outputs:**

- `docs/PI-EXTENSION-MODULARIZATION-CONTRACT.md`
- subsystem inventory
- extraction order
- stable public/internal boundaries
- validation strategy
- first extraction candidate

**Recommended first candidates:**

- artifact-slice helpers
- workflow/resource capsule helpers
- state parsing helpers
- module activity parsing helpers

Avoid extracting guided workflow or CARL first unless the audit shows a safer seam.

**Verification:**

- docs-only validation
- no runtime behavior change
- clear Phase 239 handoff

### Phase 239 — Bounded Pi Extension Extraction Spike

**Goal:** Extract one low-risk subsystem from `pals-hooks.ts` and prove behavior preservation.

**Recommended scope:**

Extract a pure, low-risk subsystem such as artifact-slice rendering or state parsing into a separate TypeScript file.

**Expected outputs:**

- one new focused runtime helper module
- reduced `pals-hooks.ts` line count
- unchanged installed extension behavior
- validation updates only where needed to preserve contract markers

**Verification:**

- installer passes
- Pi validation passes
- cross-harness validation passes if shared surfaces touched
- focused grep/marker checks prove exported/imported behavior remains contract-shaped

### Phase 240 — Product Happy Path + Scenario Evidence

**Goal:** Make PALS easier to understand and prove product usefulness in a concrete scenario.

**Expected outputs:**

- first-run happy-path doc or README section
- scenario fixture or scripted walkthrough
- evidence of what PALS protects/saves in the scenario
- identification of remaining onboarding friction

**Possible scenario:**

A tiny project receives one planned change, runs APPLY, validates, and UNIFY records the result. The scenario should show:

- plan approval boundary
- scoped implementation
- verification command truth
- summary/lifecycle continuity
- optional context-slice benefit

**Verification:**

- docs markers
- scenario command or fixture validation if feasible
- no unsupported claim that PALS is universally faster without evidence

### Phase 241 — Evidence Closure + Next Roadmap Decision

**Goal:** Close v2.55 with clear evidence and choose the next maintenance/product direction.

**Expected outputs:**

- closure summary
- validation count reconciliation
- drift repair evidence
- maintainability improvements recorded
- next roadmap recommendation

**Likely next milestone candidates after v2.55:**

1. **Validation Architecture Hardening** — continue decomposing shell suites into componentized checks and fixtures.
2. **Pi Extension Modularization** — continue extracting subsystems from `pals-hooks.ts`.
3. **Structured Module Report Schema** — make module outputs more machine-checkable.
4. **Context Efficiency Measurement** — local artifact-backed context cost evidence.
5. **Onboarding / Product Adoption Pass** — improve first-run experience and docs around user value.

## Recommended Priority Order

If forced to choose only the highest-impact work:

1. **Artifact drift + maintainability audit** — establishes truth and prevents fixing the wrong thing.
2. **Validation decomposition** — reduces the biggest recurring maintenance pain.
3. **Pi extension modularization** — reduces supported-runtime risk.
4. **Artifact consistency guardrails** — prevents lifecycle truth drift.
5. **Happy path / scenario evidence** — makes the product easier to evaluate externally.

## Success Criteria for v2.55

v2.55 should be considered successful if:

- stale lifecycle/index artifacts are identified and repaired or explicitly documented
- validation brittleness is mapped and at least one decomposition step is complete
- `pals-hooks.ts` has a safe modularization path and ideally one subsystem extracted
- proportional safety tiers are defined without weakening required gates
- a simple product happy path exists
- validation remains green and count changes are reconciled
- future work is clearer, smaller, and less risky

## Open Questions

- Should risk-tiered lifecycle behavior become an actual workflow feature immediately, or remain guidance until validated manually?
- Should validation decomposition stay shell-based for now, or introduce a small test runner for fixture-based checks?
- Which `pals-hooks.ts` subsystem is safest to extract first?
- Should `.paul/MILESTONES.md` be automatically checked during every milestone closure?
- What is the minimum useful scenario validation that proves PALS value without creating another large brittle test surface?

## Suggested Handoff to `/paul:milestone`

Use this document as the milestone-context source for creating:

> **v2.55 Maintainability & Product Reality Hardening**

Suggested phase count: **8**  
Suggested phases: **234-241** as listed above.  
Planning mode: **exploratory**  
Collaboration level: **high**

The first phase should be:

> **Phase 234 — Product Reality + Drift Audit**

It should be docs/audit-first, not implementation-first.
