# PALS Maintainability and Product Reality Audit

**Status:** Phase 234 audit output  
**Created:** 2026-04-30  
**Milestone:** v2.55 Maintainability & Product Reality Hardening  
**Plan:** `.paul/phases/234-product-reality-drift-audit/234-01-PLAN.md`

## Executive Summary

PALS has strong lifecycle safety, artifact-first truth, and durable validation evidence, but the current product surface is expensive to maintain and hard for a new user to evaluate quickly.

The main risks are not missing features. They are maintenance gravity wells, brittle validation contracts, drift-prone lifecycle/index artifacts, a large Pi runtime surface, and weak evidence that shows user value beyond structural correctness.

Phase 234 should not fix those issues directly. This audit records the evidence base and recommends bounded follow-up work for Phases 235-241.

## Scope and Method

Audit inputs:

- `.paul/PROJECT.md`, `.paul/ROADMAP.md`, `.paul/STATE.md`, and `.paul/MILESTONES.md`
- `docs/PALS-CRITICAL-REVIEW-NEXT-ROADMAP.md`
- `README.md` and `docs/*.md`
- `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh`
- `drivers/pi/extensions/`, `drivers/*`, `kernel/`, and `modules/`

Repository scan summary from bounded text-file inspection:

| Area | Files scanned | Lines | Files >500 lines | Files >1000 lines |
|------|---:|---:|---:|---:|
| `.paul` | 709 | 116,536 | 11 | 0 |
| `docs` | 35 | 9,144 | 3 | 0 |
| `drivers` excluding Pi extension emphasis | 24 | 1,758 | 0 | 0 |
| `drivers/pi/extensions` | 2 | 1,903 | 1 | 1 |
| `kernel` | 105 | 21,693 | 6 | 1 |
| `modules` | 79 | 6,686 | 0 | 0 |
| `tests` | 2 | 3,075 | 2 | 2 |

## Ranked Weakness List

| Rank | Weakness | Severity | Evidence | Why it matters |
|---:|---|---|---|---|
| 1 | Validation suites are large and marker/prose-heavy | High | `tests/pi-end-to-end-validation.sh` is 1,752 lines with 314 marker/prose hits; `tests/cross-harness-validation.sh` is 1,323 lines with 353 marker/prose hits. | The suites protect important contracts, but wording changes can break tests even when behavior is intact. This slows refactors and makes exact prose an accidental API. |
| 2 | Supported Pi runtime is a gravity well | High | `drivers/pi/extensions/pals-hooks.ts` is 1,684 lines. The v2.55 source review identifies command routing, activation state, lifecycle UI, artifact slices, capsules, guided workflow detection, CARL boundaries, and module parsing in one file. | The supported runtime surface is where active product value lives. A large multipurpose file makes safe changes harder to isolate and test. |
| 3 | Lifecycle/index artifacts still drift under active use | High | Before v2.55 creation, the handoff recorded `.paul/MILESTONES.md` stale after v2.54 closure. During this phase, `.paul/STATE.md` already needed multiple hot-path updates as the project moved from milestone creation to plan creation. | PALS' core promise is durable lifecycle truth. Drift between STATE/ROADMAP/MILESTONES/HANDOFF/SUMMARY weakens trust and increases resume cost. |
| 4 | Process ceremony is not yet proportional to risk | Medium-high | The v2.55 source review lists lifecycle artifacts, module dispatch evidence, validation marker checks, GitHub Flow evidence, Workguard/scope proof, and summaries as routine overhead. This docs-only audit still required planning, module evidence, scope proof, and validation decisions. | Strong gates are useful, but tiny/doc-only work should not feel indistinguishable from risky runtime work. |
| 5 | First-run product story is dense | Medium-high | `README.md` Quick Start is short, but immediately introduces Pi support status, frozen legacy surfaces, 18 modules, artifact slices, guided workflow, workflow/resource capsules, validation classification, GitHub Flow, and artifact authority. | A new user may understand that PALS is safe before they feel what it does for them. Adoption needs a simpler happy path. |
| 6 | Usefulness evidence is weaker than structural evidence | Medium | Existing evidence strongly records validation counts, marker preservation, PR merges, and artifact updates. The critical review explicitly notes gaps around time saved, context saved per phase, missed-validation reduction, agent mistake reduction, and external usability. | PALS can prove its rules are preserved, but it needs more proof that the rules create user value. |
| 7 | Historical artifacts dominate local text volume | Medium | `.paul` scanned as 709 text files and 116,536 lines. Archive/history is legitimate authority, but hot-path readers must avoid pulling cold history. | History is valuable, but discoverability and bounded reads need guardrails so context cost does not regrow. |

## File-Size / Hotspot Inventory

Largest observed files in the audited surface:

| File | Lines | Notes |
|------|---:|------|
| `tests/pi-end-to-end-validation.sh` | 1,752 | Largest validation suite; high marker/prose contract density. |
| `drivers/pi/extensions/pals-hooks.ts` | 1,684 | Supported Pi runtime gravity well; main modularization candidate. |
| `tests/cross-harness-validation.sh` | 1,323 | Cross-surface validation; high marker/prose contract density. |
| `kernel/workflows/init-project.md` | 1,039 | Largest kernel workflow; likely onboarding/process complexity hotspot. |
| `docs/MODULE-SPEC.md` | 875 | Large module-system reference; useful but intimidating for new readers. |
| `.paul/archive/milestones/MILESTONES-v0-v2.42.md` | 853 | Cold history; should remain archived and rarely hot-read. |
| `docs/ARTIFACT-SPEC.md` | 695 | Large artifact reference; important but not first-run friendly. |
| `kernel/workflows/map-codebase.md` | 592 | Workflow size hotspot. |
| `kernel/workflows/apply-phase.md` | 564 | Core lifecycle workflow; high importance and safety-sensitive. |
| `docs/PALS-CRITICAL-REVIEW-NEXT-ROADMAP.md` | 545 | Useful planning source, but should not become a recurring hot-path artifact after v2.55 planning. |

Hotspot conclusions:

- The riskiest implementation hotspot is `drivers/pi/extensions/pals-hooks.ts` because it is both large and supported-runtime active.
- The riskiest validation hotspots are the two shell suites in `tests/` because both are >1,000 lines and rely heavily on exact marker checks.
- The largest process hotspot is `kernel/workflows/init-project.md`; it likely contributes to first-run complexity and should be reviewed before onboarding polish.
- `.paul/archive/*` volume is expected, but hot-path workflows must keep treating archive detail as cold context.

## Artifact Drift Inventory

Current status after v2.55 milestone/plan setup:

| Artifact | Current signal | Drift status |
|----------|----------------|--------------|
| `.paul/STATE.md` | v2.55 active, Phase 234 planning, Plan 234-01 awaiting approval | Mostly current, but hot-path fields are easy to stale during rapid transitions. |
| `.paul/ROADMAP.md` | v2.55 active, Phase 234 has Plan 234-01 in Planning | Current after milestone/plan update. |
| `.paul/MILESTONES.md` | v2.54 completed entry and v2.55 current/future pointer | Current after v2.55 setup; previously identified as stale after v2.54 closure. |
| `.paul/PROJECT.md` | v2.55 current focus and milestone posture | Current after v2.55 setup. |
| `.paul/handoffs/archive/HANDOFF-2026-04-30-v255-roadmap-ready.md` | Consumed active handoff archived | Current lifecycle cleanup. |

Drift patterns to guard later:

- Milestone completion can update `STATE.md` but leave compact indexes stale.
- Plan creation changes the active phase from ready-to-plan to awaiting-approval; every hot artifact that repeats the phase status becomes a possible drift source.
- Handoff state is useful but must be archived after consumption so active handoffs do not compete with STATE.
- Repeated current-state prose across `PROJECT.md`, `STATE.md`, `ROADMAP.md`, and `MILESTONES.md` is helpful for humans but creates duplicate truth.

## Validation Brittleness Inventory

Observed brittle patterns:

| File | Evidence | Risk |
|------|----------|------|
| `tests/pi-end-to-end-validation.sh` | 1,752 lines; marker helper uses `grep -Fq`; 314 marker/prose hits in scan. | Exact strings become protected contracts. Safe prose cleanup can fail tests unless all protected markers are known. |
| `tests/cross-harness-validation.sh` | 1,323 lines; marker helper uses `grep -Fq`; 353 marker/prose hits in scan. | Cross-surface parity can preserve frozen legacy wording longer than the supported product needs. |
| `modules/*/module.yaml` | Hook behavior is mostly YAML prose. | Modules are easy to inspect but harder to unit-test as structured inputs/outputs. |
| `kernel/workflows/*.md` | Workflow behavior is implemented as human/agent-readable prose with required markers. | Workflow edits can accidentally change behavior or break marker-based validation. |

Validation conclusions:

- Current validation is valuable and should not be weakened casually.
- Future decomposition should separate behavior assertions from wording assertions where possible.
- Marker checks should be intentionally classified: protected contract markers, documentation presence markers, frozen legacy parity markers, and brittle wording markers.
- Phase 236 should preserve current pass counts while extracting helper structure or inventories that make validation responsibilities easier to understand.

## First-Run Friction Notes

README strengths:

- Quick Start is short and gives concrete install plus `/paul:init`, `/paul:plan`, `/paul:apply`, `/paul:unify` commands.
- It states Pi is the supported runtime and `.paul/*` artifacts remain lifecycle truth.

Friction points:

- A new user sees many advanced concepts immediately: Pi-only support posture, frozen legacy surfaces, 18 modules, artifact slices, guided workflow UX, workflow/resource capsules, validation classification, GitHub Flow, module dispatch, and helper agents.
- The architecture is accurate but vocabulary-heavy: PAUL, CARL, TODD, WALT, SKIP, CODI, PALS, capsules, slices, modules, drivers, kernel, lifecycle artifacts.
- The README proves system sophistication before it demonstrates a tiny useful scenario.
- There is no obvious “five-minute happy path” that shows what PALS prevents or saves in one concrete change.

Recommended first-run framing:

- Start with one small scenario: create a tiny project phase, plan one safe docs/code change, apply it, and unify evidence.
- Delay module taxonomy until after the user sees the loop.
- Present the first user value as: “PALS gives the agent a durable plan, prevents unapproved scope creep, runs verification, and records what happened.”

## Usefulness-Evidence Gaps

Strong existing evidence:

- Validation counts are repeatedly recorded, e.g. Pi 209/209 and cross-harness 123/123 at v2.54 closure.
- PR/merge evidence and phase summaries show lifecycle discipline.
- Context-efficiency work records reduced wrapper size and bounded artifact/capsule behavior.
- Workguard and lifecycle summaries provide scope and artifact drift evidence.

Weak or missing evidence:

| Gap | Current state | Better local evidence |
|-----|---------------|-----------------------|
| Time saved | No recurring local measure of setup/planning/apply time saved versus ad hoc usage. | Scenario walkthrough with approximate step count or elapsed manual actions. |
| Context saved per phase | Some context-efficiency artifacts exist, but not a simple per-phase product metric. | Record hot-path files read before/after a guidance improvement. |
| Missed validation reduction | Validation counts exist; fewer missed validations are not demonstrated. | Scenario showing a required gate caught a missing verification or scope drift. |
| Agent mistake reduction | Parent-owned APPLY and module gates are documented; mistake-prevention examples are sparse. | Before/after narrative from a small intentionally risky change. |
| External usability | Evidence is mostly dogfooded by this repo. | Fresh-project fixture or scripted walkthrough that a new user can run/read. |

Usefulness evidence should remain local and non-telemetry based. PALS does not need hidden runtime state to prove value.

## Recommendations for Phases 235-241

### Phase 235 — Risk-Tiered Lifecycle Contract

Recommended focus:

- Define tier criteria for tiny/doc-only, normal, risky, and hotfix work.
- Preserve non-bypass rules: explicit APPLY approval, validation truth, GitHub Flow gates, module blockers, parent-owned APPLY, lifecycle writes, and full authoritative reads.
- Make the output a contract first, not a behavior relaxation.

Audit basis:

- Process ceremony is currently useful but heavy even for docs-only audit work.
- This phase should decide proportional evidence expectations before changing workflows.

### Phase 236 — Validation Suite Decomposition Baseline

Recommended focus:

- Inventory each validation check by purpose: behavior contract, protected marker, docs presence, frozen legacy parity, runtime lens, guided UI safety, helper delegation, GitHub Flow safety, artifact/process.
- Extract or document helper groupings without reducing pass counts.
- Identify wording-sensitive checks that could become structured assertions later.

Audit basis:

- `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` are both >1,000 lines with high marker/prose density.

### Phase 237 — Artifact Consistency Guardrails

Recommended focus:

- Add lightweight checks that compare STATE/ROADMAP/MILESTONES/SUMMARY/session continuity for active milestone, phase, plan, and loop position.
- Prefer checks that report drift over checks that introduce another source of truth.
- Include handoff lifecycle checks for consumed active handoffs.

Audit basis:

- `.paul/MILESTONES.md` drift was observed after v2.54 closure.
- Current-state prose is duplicated across several hot artifacts.

### Phase 238 — Pi Extension Modularization Contract

Recommended focus:

- Define subsystem boundaries inside `drivers/pi/extensions/pals-hooks.ts` before extraction.
- Candidate boundaries: command routing, activation/slices, capsules, guided workflow, CARL/session boundary, module activity parsing.
- Pick one low-risk pure subsystem for Phase 239.

Audit basis:

- `drivers/pi/extensions/pals-hooks.ts` is 1,684 lines and owns multiple supported-runtime concerns.

### Phase 239 — Bounded Pi Extension Extraction Spike

Recommended focus:

- Extract one pure subsystem from `pals-hooks.ts` with behavior-preserving tests or focused validation.
- Avoid broad runtime churn and do not mix modularization with feature work.
- Record before/after file size and validation result.

Audit basis:

- Pi extension size is a top maintainability risk, but extraction should be incremental and evidence-backed.

### Phase 240 — Product Happy Path + Scenario Evidence

Recommended focus:

- Create a first-run happy path or scenario doc that demonstrates one small plan/apply/unify loop.
- Show what PALS protects or saves: approval boundary, scope control, verification, durable summary, resume state.
- Keep the scenario small enough not to become another brittle validation suite.

Audit basis:

- README is accurate but concept-dense.
- Usefulness evidence is weaker than structural validation evidence.

### Phase 241 — Evidence Closure + Next Roadmap Decision

Recommended focus:

- Reconcile whether v2.55 reduced maintainability risk without weakening safety.
- Compare evidence from Phases 235-240 against this audit’s ranked weaknesses.
- Decide whether v2.56 should prioritize validation architecture, Pi extension modularization, or module output schema.

Audit basis:

- v2.55 spans several risk areas; closure needs explicit evidence that future work is sequenced by actual product/maintenance value.

## Deferred / Non-Goals for Phase 234

Phase 234 intentionally does not:

- Refactor `drivers/pi/extensions/pals-hooks.ts`.
- Change validation suite logic or protected markers.
- Relax lifecycle gates, approval requirements, GitHub Flow requirements, module blockers, or parent-owned APPLY authority.
- Add dependencies, CI configuration, telemetry, hidden runtime state, or product analytics.
- Rewrite onboarding docs beyond recording friction and recommendations.
- Repair drift beyond normal PAUL lifecycle artifact updates required by PLAN/APPLY/UNIFY.

## Verification Notes

Focused marker checks should verify this document contains:

- `## Ranked Weakness List`
- `## File-Size / Hotspot Inventory`
- `## Artifact Drift Inventory`
- `## Validation Brittleness Inventory`
- `## First-Run Friction Notes`
- `## Usefulness-Evidence Gaps`
- `## Recommendations for Phases 235-241`
- recommendation entries for Phases 235, 236, 237, 238, 239, 240, and 241

Full Pi and cross-harness validation can be run for additional confidence. If scoped out, the rationale should be that this phase created a docs-only audit and did not alter runtime, validation-suite, module, driver, dependency, or CI behavior.
