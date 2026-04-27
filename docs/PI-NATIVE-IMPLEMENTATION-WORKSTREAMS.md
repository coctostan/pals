# Pi-Native Implementation Workstreams

## Status

| Field | Value |
|---|---|
| Milestone | v2.46 Pi-Native Implementation Planning |
| Phase | 198 — Implementation Workstream Design |
| Artifact status | Planning input for Phases 199-201 |
| Implementation status | No runtime, workflow, validation-script, dependency, GitHub Flow, or legacy-surface changes are approved by this artifact |

## Purpose

This document converts the Phase 197 findings triage and v2.45 architecture work into candidate implementation workstreams. It is a planning artifact for later sequencing and executable-roadmap work, not a build plan.

The design keeps claims source-cited and intentionally shallow: it identifies workstream purpose, readiness, likely repo surfaces, validation expectations, boundaries, dependencies, and open questions without copying large source sections verbatim.

## Planning-Only Boundary

This artifact defines workstream planning inputs only. It does not approve changes to Pi runtime behavior, shared workflows, validation scripts, dependency manifests, GitHub Flow behavior, Claude Code wrappers, Agent SDK surfaces, portability docs, or installed runtime copies.

Future implementation still requires normal PLAN approval, parent-owned APPLY execution, module dispatch evidence, validation output, GitHub Flow gates, UNIFY reconciliation, and `.paul/*` lifecycle writes.

Non-negotiable authority boundaries from the source set:

- `.paul/*` artifacts remain lifecycle truth; Pi extension memory, widgets, hidden context, helper-agent transcripts, and UI selections are derived aids only.
- PLAN/APPLY/UNIFY remains authoritative: PLAN defines approved work, APPLY executes and verifies under parent control, and UNIFY reconciles durable artifacts.
- Installed `modules.yaml`, `[dispatch] ...` lines, and PLAN/SUMMARY/STATE reports remain module evidence; Pi must not create a separate module ledger.
- GitHub Flow gates remain workflow- and command-evidence-backed; Pi may surface state but must not bypass base sync, CI, review, merge, or cleanup gates.
- Parent APPLY owns eligibility, official verification, fallback judgment, checkpoints, module enforcement, task result classification, and `.paul/*` writes even when `pals-implementer` helps.
- Full authoritative reads remain required for edits, approved PLAN execution, lifecycle writes, GitHub Flow gates, ambiguity, stale facts, or contested decisions.

## Source Inputs

| Source | Evidence used | Workstream implication |
|---|---|---|
| `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` | Phase 197 source map, settled decisions, authority boundaries, promoted patterns, rejected options, workstream seeds, open questions, and Phase 198-201 handoff. | Primary inventory for candidate workstreams and planning-only scope. |
| `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Final v2.45 target architecture, promoted patterns, migration roadmap, implementation roadmap, legacy guidance, validation strategy, and non-goals. | Supplies default ordering pressure and guardrails for later implementation milestones. |
| `docs/PI-RUNTIME-CAPABILITY-MAP.md` | Current Pi primitives: command routing, installed resource resolution, lifecycle UI, bounded context injection, guided workflow UX, module visibility, CARL, helper-agent delegation, GitHub Flow surfacing, and validation classification. | Grounds each workstream in existing repo surfaces and current capability classifications. |
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Context-cost surfaces, non-negotiable guardrails, assistance components, read/citation contract, rejected designs, spike backlog, recommended sequence, and validation redesign notes. | Defines citation, freshness, fallback, boundedness, and full-read requirements for runtime assistance. |
| `.paul/phases/197-v245-findings-triage/197-01-SUMMARY.md` | Immediate prior phase result: findings triage completed, artifact-slice pattern identified as implementation-grade, parent APPLY and `.paul/*` authority reaffirmed, validation green. | Confirms Phase 198 should design workstreams before implementation hardening and should treat artifact slices as foundational input. |

## Planning Status Summary

| Planning area | Current classification | Source basis | Phase 198 implication |
|---|---|---|---|
| Artifact-slice loading | Proven candidate | Phase 195/196 evidence summarized in `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` and `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Treat as the most implementation-ready workstream, but leave sequencing to Phase 199. |
| Workflow/resource capsules | Promoted later | `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md`; `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Design carefully because capsules summarize process prose and must not replace blocking workflow reads. |
| Guided workflow evidence | Promoted later / guardrail-only | `docs/PI-RUNTIME-CAPABILITY-MAP.md`; `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Focus on transcript-visible canonical replies and no-auto-continue proof. |
| Delegated APPLY packet compression | Promoted later / guardrail-only | `docs/PI-RUNTIME-CAPABILITY-MAP.md`; `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Preserve parent APPLY authority while reducing review context for bounded helper work. |
| Validation classification | Required planning layer | `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md`; `docs/PI-RUNTIME-CAPABILITY-MAP.md` | Needed before weakening frozen parity checks or expanding Pi-native checks. |
| Legacy retention / cleanup | Last / defer | `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md`; `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` | Defer until shared-invariant validation is classified and protected. |

## Candidate Workstream Inventory

| Workstream | Purpose | Readiness | Implementation target | Planning status |
|---|---|---|---|---|
| Artifact-Slice Contract Hardening | Turn the Phase 195 spike into a stable activation-gated, source-cited, freshness-marked slice contract. | `implementation-ready` | Pi extension context loading, skill-map docs, install/validation evidence. | Candidate foundation; sequencing remains Phase 199-owned. |
| Workflow/Resource Capsule Design | Define safe installed-resource orientation capsules for repeated workflow and reference reminders. | `needs design` | Installed workflow/reference summaries, Pi docs, validation markers. | Needs exclusion rules for blocking semantics before implementation. |
| Guided Workflow Evidence Hardening | Make Pi guided UI decisions auditable as explicit canonical transcript replies. | `needs design` | Pi extension guided workflow handlers, README, validation checks. | Close to existing behavior but requires no-auto-continue proof. |
| Delegated APPLY Packet/Report Compression | Reduce parent review context for helper-agent work through bounded packets and structured reports. | `needs design` | `.pi/agents/pals-implementer.md`, APPLY workflow text, skill map, validation. | Must preserve parent APPLY authority and file-scope verification. |
| Pi-Native Validation Classification | Classify validation checks by Pi-supported runtime, shared invariant, frozen legacy parity, runtime lens, guided UI safety, and helper delegation. | `depends on validation classification` | Validation scripts and validation reports. | Required before weakening parity checks or expanding Pi-native assertions. |
| Legacy Retention and Install-Surface Cleanup | Decide what frozen Claude Code, Agent SDK, portability, and install-surface artifacts stay, move, or retire. | `defer` | Legacy drivers, docs, install surfaces, validation references. | Last; depends on validation classification and explicit product decision. |

## Workstream Details

### Artifact-Slice Contract Hardening

**Purpose:** Generalize the proven Phase 195 artifact-slice pattern into a stable Pi-native context-efficiency contract while keeping slices read-only, activation-gated, bounded, source-cited, freshness-aware, and backed by full authoritative reads.

**Readiness:** `implementation-ready`. Phase 195 already validated source-cited, freshness-marked, activation-gated, read-only slices; Phase 196 and Phase 197 promote this as the first implementation-grade pattern.

**Expected Outputs:**

- Named slice inventory for current lifecycle state, active roadmap phase, current PLAN task packet, recent SUMMARY decisions, and module evidence.
- Stable output schema for `Source`, slice label, freshness marker, bounds, and fallback language.
- Documentation updates that explain when slices orient vs when full reads are required.
- Validation markers for activation gating, source citations, freshness, bounds, no `.paul/*` writes, and fallback text.

**Likely Repo Surfaces:**

- `drivers/pi/extensions/pals-hooks.ts`
- `drivers/pi/extensions/README.md`
- `drivers/pi/skill-map.md`
- `tests/pi-end-to-end-validation.sh`
- Possibly `docs/PI-VALIDATION-REPORT.md`

**Validation / Evidence:**

- Structural checks for explicit PALS activation before slice output.
- Assertions that each slice cites source paths and includes freshness/fallback language.
- Existing Pi validation remains green; cross-harness validation stays green for shared invariants.
- Evidence that no slice writes `.paul/*` or creates hidden persistence.

**Authority Boundaries:** Preserve `.paul/*` truth, PLAN/APPLY/UNIFY ownership, module evidence, GitHub Flow gates, parent-owned APPLY, full-read fallback, no hidden Pi state, no telemetry, and no auto-approval.

**Dependencies:** Source schema agreement; slice inventory; validation-marker design.

**Open Questions:** Which slices are high-value enough to harden first, what size bound applies per slice, and how should freshness be represented for git/PR/CI-sensitive facts?

### Workflow/Resource Capsule Design

**Purpose:** Define short installed-resource capsules for stable orientation content without replacing authoritative workflow or reference reads.

**Readiness:** `needs design`. The architecture promotes capsules later because they summarize process prose and can hide blocking behavior if scoped poorly.

**Expected Outputs:**

- Capsule eligibility rules for stable, low-risk orientation topics.
- Exclusion list for STOP/DO NOT SKIP, override paths, checkpoint handling, lifecycle writes, module gate enforcement, and merge-gate semantics.
- Citation format pointing to installed workflow/reference paths and source sections.
- Documentation that says capsules orient only; full workflow files remain authority.

**Likely Repo Surfaces:**

- `drivers/pi/skill-map.md`
- `drivers/pi/extensions/README.md`
- Installed skill/resource references generated by `drivers/pi/install.sh`
- Shared workflow/reference docs only through future approved plans
- `tests/pi-end-to-end-validation.sh`

**Validation / Evidence:**

- Capsule output includes installed logical path citations.
- Validation confirms blocking markers are not removed or replaced by capsules.
- Full workflow reads remain required for APPLY, UNIFY, checkpoints, lifecycle writes, and ambiguity.

**Authority Boundaries:** Capsules must not rewrite workflow semantics, shorten mandatory blocking rules, replace module dispatch evidence, or become source of truth.

**Dependencies:** Artifact-slice citation/fallback contract should be stable first; blocking-semantics exclusion list must be reviewed before implementation.

**Open Questions:** Which installed resources are safe to capsule, what capsule length budget is acceptable, and how should capsule staleness be detected after install regeneration?

### Guided Workflow Evidence Hardening

**Purpose:** Make Pi guided workflow interactions auditable by ensuring every approval, checkpoint choice, continue-to-UNIFY response, and merge-gate route appears as an explicit canonical transcript reply.

**Readiness:** `needs design`. Current guided workflow UX is a guardrail-only primitive; hardening should stay near current behavior and prove it never auto-continues.

**Expected Outputs:**

- Canonical transcript reply contract for `yes`, `approved`, `1`, selected option ids, checkpoint responses, and stop/pause choices.
- No-auto-continue and no-UI-only-decision tests.
- README/user-facing guidance for guided workflow affordances.
- Evidence mapping from guided UI actions to transcript/artifact outcomes.

**Likely Repo Surfaces:**

- `drivers/pi/extensions/pals-hooks.ts`
- `drivers/pi/extensions/README.md`
- `pals.json` guided workflow settings documentation
- `tests/pi-end-to-end-validation.sh`

**Validation / Evidence:**

- Tests prove plan review, APPLY approval, checkpoints, and continue-to-UNIFY require explicit user action.
- Tests prove canonical replies are visible in transcript flow.
- Existing validation remains green and no lifecycle state is stored only in Pi UI.

**Authority Boundaries:** User intent remains explicit; Pi UI must not silently approve, continue, merge, skip checkpoints, or record UI-only decisions.

**Dependencies:** Guided workflow prompt inventory; transcript reply schema; validation harness ability to assert no-auto-continue behavior.

**Open Questions:** Which guided moments should be hardened first, and what evidence should SUMMARY/STATE record when a checkpoint decision changes lifecycle semantics?

### Delegated APPLY Packet/Report Compression

**Purpose:** Reduce parent context cost for bounded `pals-implementer` work while keeping parent APPLY authoritative for task packets, verification, fallback, module gates, checkpoints, and lifecycle writes.

**Readiness:** `needs design`. The helper-agent surface exists and is guardrail-only, but packet/report schemas need formalization before implementation hardening.

**Expected Outputs:**

- Parent-owned task packet template with task identity, allowed files, forbidden files, action excerpt, supporting context, verification, stop conditions, and lifecycle reminders.
- Required structured report schema with status, files changed, commands run, verification attempted/results, concerns, fallback recommendation, and summary.
- Allowed-file diff checks and fallback triggers documented and validated.
- Clear rule that helper reports reduce review cost but do not replace parent official verification.

**Likely Repo Surfaces:**

- `.pi/agents/pals-implementer.md`
- `kernel/workflows/apply-phase.md`
- `drivers/pi/skill-map.md`
- `drivers/pi/extensions/README.md`
- Validation scripts as needed

**Validation / Evidence:**

- Static checks for required packet/report fields and fallback language.
- APPLY validation that parent still runs official verify and checks changed files.
- Tests or markers that helper cannot write `.paul/*` lifecycle artifacts or own checkpoints.

**Authority Boundaries:** Parent APPLY owns eligibility, official verification, fallback judgment, module enforcement, checkpoints, task results, and `.paul/*` writes.

**Dependencies:** Report schema clarity; allowed-file diff review pattern; fallback/blocked result handling.

**Open Questions:** Which fields make helper output machine-checkable enough to reduce review context, and when should parent force inline fallback despite a successful helper report?

### Pi-Native Validation Classification

**Purpose:** Classify current and future validation into support-purpose groups so Pi-native behavior can grow while shared invariants stay protected and frozen parity checks are labeled before any weakening.

**Readiness:** `depends on validation classification`. The workstream is itself the classification layer required before safe validation redesign or legacy cleanup.

**Expected Outputs:**

- Classification taxonomy: Pi-supported runtime, shared invariant, frozen legacy parity, runtime lens, guided UI safety, helper delegation, and GitHub Flow safety.
- Mapping of current `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` assertions to those classes.
- Validation report updates that show what each suite protects.
- Migration rules for adding Pi-native checks without deleting shared invariants prematurely.

**Likely Repo Surfaces:**

- `tests/pi-end-to-end-validation.sh`
- `tests/cross-harness-validation.sh`
- `docs/PI-VALIDATION-REPORT.md`
- `docs/VALIDATION-REPORT.md`
- Possibly validation documentation under `docs/`

**Validation / Evidence:**

- Both validation suites remain green during classification.
- Reports identify frozen legacy parity without letting parity-only checks silently block Pi-native design.
- Shared-invariant assertions remain blocking until intentionally relocated or retired by plan.

**Authority Boundaries:** Validation output remains command evidence; Pi summaries cannot mark validation passed; GitHub Flow CI and local validation gates remain workflow-owned.

**Dependencies:** Inventory of current validation assertions; decision rules for shared invariants vs parity-only checks; Phase 200 evidence strategy.

**Open Questions:** Which cross-harness checks are shared invariant protection, which are frozen parity, and what new checks are needed for runtime lenses, guided UI safety, and helper delegation?

### Legacy Retention and Install-Surface Cleanup

**Purpose:** Decide what frozen Claude Code, Agent SDK, portability, and install-surface artifacts should remain installed, become source-only references, move to archives, or be retired.

**Readiness:** `defer`. Source guidance places this last because cleanup before validation classification could accidentally remove shared-invariant protection.

**Expected Outputs:**

- Explicit retention/removal matrix for Claude Code wrappers, Agent SDK driver, portability docs, cross-harness validation, and install surfaces.
- Migration notes for historical references and archive links.
- Validation proof that shared invariants are preserved or intentionally retired.
- User-facing documentation of Pi-supported runtime posture without reopening active parity.

**Likely Repo Surfaces:**

- `drivers/claude-code/**`
- `drivers/agent-sdk/**`
- Portability docs under `docs/`
- `drivers/pi/install.sh` and install docs if install surface changes are approved
- Cross-harness validation references

**Validation / Evidence:**

- Shared invariants stay covered after any retention/removal action.
- Frozen legacy references are clearly labeled rather than silently deleted.
- GitHub Flow and module evidence semantics remain unchanged.

**Authority Boundaries:** Cleanup must not remove `.paul/*` authority, shared workflow semantics, module evidence, GitHub Flow safety, or historical archive truth.

**Dependencies:** Validation classification; explicit product decision; archive/retention plan.

**Open Questions:** Which legacy files remain useful as historical proof, which install surfaces impose active context cost, and which parity checks protect real shared invariants?


## Phase 199 Handoff

Phase 199 owns sequencing and dependency planning. The notes below are sequencing inputs, not final ordering decisions.

### Sequencing Inputs

| Input | Source pressure | Phase 199 planning use |
|---|---|---|
| Artifact slices before capsules | Phase 195 proved slices; architecture recommends stabilizing citation/fallback schema first. | Test whether artifact-slice contract hardening should be first build milestone or split into schema + implementation phases. |
| Guided UI evidence near current Pi behavior | Current guided UX already exists as a guardrail-only primitive. | Consider whether no-auto-continue and canonical transcript proof can ship before or alongside capsules. |
| Helper packet compression after report schema clarity | Delegation safety depends on parent-readable packets, structured reports, allowed-file checks, and fallback triggers. | Sequence after packet/report schema is explicit enough for parent verification. |
| Validation classification before weakening parity | Existing scripts protect both Pi-supported behavior and shared invariants. | Classify assertions before deleting, weakening, or relabeling frozen legacy parity checks. |
| Legacy cleanup last | Source guidance defers retention/removal until validation classification protects shared invariants. | Keep legacy install and documentation cleanup out of early build milestones unless it is purely labeling. |

### Dependency Edges

- Artifact-slice contract hardening should define reusable source/freshness/fallback language before workflow/resource capsules use similar citation conventions.
- Workflow/resource capsules depend on a blocking-semantics exclusion list so they do not replace full workflow reads for APPLY, UNIFY, checkpoints, lifecycle writes, or merge gates.
- Guided workflow evidence hardening depends on an inventory of canonical workflow prompts and transcript reply values.
- Delegated APPLY packet/report compression depends on clear parent-owned packet/report schemas and allowed-file diff checks.
- Pi-native validation classification should precede any validation-script weakening, frozen parity retirement, or legacy install-surface cleanup.
- Legacy retention and install-surface cleanup depends on explicit product approval plus evidence that shared invariants remain covered.

### Split / Merge Cautions

- Do not merge artifact-slice hardening with workflow capsules unless the plan can keep APPLY bounded and separately verify slice schema vs capsule semantics.
- Consider splitting artifact-slice hardening into contract/schema and additional slice inventory if validation cost grows.
- Consider pairing guided workflow evidence with small validation additions because the behavior is close to existing Pi UX.
- Keep helper-agent compression separate from lifecycle workflow rewrites unless packet/report schema and parent verification are stable.
- Keep validation classification separate from legacy cleanup; classification is evidence strategy, cleanup is product/support-surface decision.

### Risk Gates

Before any workstream moves into implementation planning, Phase 199 or later plans should verify:

- `.paul/*` remains authoritative and no hidden runtime state, telemetry, local memory, or lifecycle ledger is introduced.
- PLAN/APPLY/UNIFY ownership, module evidence, GitHub Flow gates, and parent-owned APPLY remain explicit in acceptance criteria.
- Every runtime context aid has source path citations, freshness handling where relevant, bounds, and full-read fallback language.
- Pi UI decisions appear as explicit canonical transcript replies and cannot auto-continue, auto-approve, skip checkpoints, or merge.
- Validation changes preserve shared invariants and keep command-output evidence as the source of validation truth.

### Unresolved Decisions for Phase 199

1. Should artifact-slice hardening be one milestone or split into schema, lifecycle slices, and module-evidence slices?
2. Should guided workflow evidence hardening happen before workflow/resource capsules because it is closer to current Pi behavior?
3. Which workflow/resource capsule topics are safe enough for first implementation: task anatomy, checkpoint prompt shape, module-dispatch evidence convention, or GitHub Flow preflight/postflight reminders?
4. What helper-agent report fields are required before parent review context can safely shrink?
5. Which validation assertions are shared invariants vs frozen legacy parity, and which new Pi-native checks are required before build milestones ship?
6. What explicit product decision is needed before any frozen legacy install surface is removed, archived, or made source-only?

## Readiness Checklist

A workstream can move from design to an implementation-plan proposal only when all applicable items are true:

- [ ] Source inputs and repo surfaces are named precisely enough for a bounded PLAN.
- [ ] Scope limits and protected files are explicit.
- [ ] Acceptance criteria preserve `.paul/*` authority, PLAN/APPLY/UNIFY ownership, module evidence, GitHub Flow gates, and parent-owned APPLY.
- [ ] Runtime assistance remains derived, bounded, disposable, source-cited, freshness-aware where needed, and backed by full authoritative reads.
- [ ] Validation commands and expected evidence are named before implementation begins.
- [ ] No hidden Pi state, telemetry, auto-approval, UI-only decisions, helper-owned APPLY, or merge-gate bypass is introduced.
- [ ] Dependencies on validation classification or legacy retention decisions are resolved or deferred explicitly.

## Phase 198 Non-Implementation Statement

This artifact does not choose the final implementation sequence and does not authorize edits to runtime, workflow, validation, dependency, GitHub Flow, or legacy-support surfaces. Its output is the workstream map that Phase 199 should use to design sequencing and dependency constraints.