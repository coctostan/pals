# Pi-Native Implementation Findings

## Status

| Field | Value |
|---|---|
| Milestone | v2.46 Pi-Native Implementation Planning |
| Phase | 197 — v2.45 Findings Triage |
| Artifact status | Planning input for Phases 198-201 |
| Implementation status | No implementation approved by this artifact |

## Purpose

This document triages the completed v2.45 Pi-native architecture work into implementation-planning inputs. It is not a build plan and does not authorize runtime, workflow, validation-script, dependency, or legacy-surface changes.

The goal is to preserve v2.45 evidence in a compact, source-cited form so v2.46 can design workstreams, sequencing, validation evidence, and the final executable implementation roadmap before implementation hardening begins.

## Source Inputs

| Source | Evidence used | Planning implication |
|---|---|---|
| `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Final v2.45 proposal, target architecture, authority boundaries, promoted/rejected patterns, migration roadmap, implementation roadmap, validation classes, readiness checklist. | Primary source for implementation-planning scope. |
| `docs/PI-NATIVE-SUPPORT-INVENTORY.md` | Phase 192 support-tier reset: Pi active supported runtime; Claude Code and Agent SDK frozen legacy/historical; `.paul/*` remains authoritative. | Workstreams should optimize for Pi without reopening active cross-harness parity. |
| `docs/PI-RUNTIME-CAPABILITY-MAP.md` | Phase 193 Pi primitive inventory: command routing, installed resources, lifecycle UI, context injection, guided UX, module visibility, CARL, helper-agent delegation, GitHub Flow surfacing. | Workstreams should map implementation ideas to existing Pi primitives before adding new surfaces. |
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Phase 194 context-cost model, read/citation contract, assistance components, rejected designs, spike backlog, and recommended sequence. | Workstreams need source citations, freshness, bounded output, and full-read fallback as first-class requirements. |
| `.paul/phases/195-exploratory-pi-native-spikes/195-01-SUMMARY.md` | Phase 195 artifact-slice spike implementation and validation evidence: source-cited, freshness-marked, activation-gated, read-only slices passed Pi 186/186 and cross-harness 100/100. | Artifact-slice loading is the only proven implementation-grade pattern so far. |
| `.paul/phases/196-final-pi-native-architecture-proposal/196-01-SUMMARY.md` | Phase 196 closure decisions: promote artifact slices first, classify validation by support purpose, keep architecture closure separate from implementation. | v2.46 should plan implementation before starting build hardening. |
| `.paul/PROJECT.md`, `.paul/STATE.md`, `.paul/ROADMAP.md` | Current lifecycle truth, active requirements, v2.46 phase route, and PLAN/APPLY/UNIFY state. | Later plans must preserve artifact-first lifecycle authority and current milestone routing. |

## Planning-Only Boundary

This triage artifact may guide later plans, but it does not approve implementation. Future implementation still requires normal PLAN approval, APPLY execution, module dispatch, validation evidence, GitHub Flow gates, UNIFY reconciliation, and `.paul/*` lifecycle writes.

## Settled Decisions

| Decision | Source | Implementation-planning effect |
|---|---|---|
| Pi is the active supported runtime. | `docs/PI-NATIVE-SUPPORT-INVENTORY.md`; `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | New UX, context-efficiency, guided workflow, and helper-agent work should be Pi-native unless a later product decision reopens legacy support. |
| Claude Code and Agent SDK surfaces are frozen legacy or historical references. | `docs/PI-NATIVE-SUPPORT-INVENTORY.md`; `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Do not optimize current architecture around active parity; preserve shared invariants and decide retention later. |
| Pi assistance must be derived, bounded, disposable, source-cited, freshness-aware, and backed by full reads. | `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md`; `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Every runtime lens or capsule workstream needs citation, freshness, size, and fallback requirements. |
| Artifact-slice loading is the first proven implementation-grade pattern. | `.paul/phases/195-exploratory-pi-native-spikes/195-01-SUMMARY.md`; `.paul/phases/196-final-pi-native-architecture-proposal/196-01-SUMMARY.md` | Later implementation should harden this pattern before riskier workflow capsules, guided UI expansion, helper packet compression, validation classification, or legacy cleanup. |
| Validation should be classified by support purpose. | `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md`; `.paul/phases/196-final-pi-native-architecture-proposal/196-01-SUMMARY.md` | Validation planning must separate Pi-supported runtime checks, shared invariants, frozen legacy parity, runtime lens checks, guided UI safety, and helper-agent delegation checks. |

## Authority Boundaries

Future implementation plans must preserve these non-negotiable boundaries from `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` and `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md`:

- `.paul/*` artifacts remain lifecycle truth; Pi extension memory, widgets, hidden context, helper-agent transcripts, and UI selections are derived aids only.
- PLAN/APPLY/UNIFY remains authoritative: PLAN defines approved work, APPLY executes and verifies under parent control, and UNIFY reconciles durable artifacts.
- Installed `modules.yaml`, `[dispatch] ...` lines, and PLAN/SUMMARY/STATE reports remain module evidence; Pi must not create an independent module ledger.
- GitHub Flow gates remain command-evidence-backed; Pi may surface branch/PR/CI/readiness state but must not bypass base sync, CI, review, merge, or cleanup gates.
- Parent APPLY owns eligibility, official verification, fallback judgment, checkpoints, module enforcement, task result classification, and `.paul/*` writes even when `pals-implementer` helps.
- Full authoritative reads remain required for edits, approved PLAN execution, lifecycle writes, GitHub Flow gates, ambiguity, stale facts, or contested decisions.

## Promoted Patterns

| Pattern | Promotion status | Planning notes |
|---|---|---|
| Activation-gated artifact-slice loading | Promote first | Proven by Phase 195; needs stable contract, slice labels, source/freshness schema, bounds, and validation. |
| Workflow/resource capsules | Promote later | Useful for orientation, but riskier because capsules summarize workflow prose; must cite installed workflow/reference paths and never replace blocking semantics. |
| Guided workflow evidence hardening | Promote later | Should make Pi UI approvals/checkpoints auditable as canonical transcript replies; cannot auto-continue or infer approval. |
| Helper-agent packet/report compression | Promote later | Can reduce parent review context if task packets, structured reports, allowed-file checks, fallback triggers, and parent verification are explicit. |
| Validation classification | Required planning layer | Needed before weakening frozen parity checks or expanding Pi-supported runtime checks. |
| Legacy retention/removal | Last | Should follow validation classification so shared invariants are preserved before any frozen surface is archived or removed. |

## Rejected Options

| Option | Rejection source | Why it stays rejected |
|---|---|---|
| Hidden Pi lifecycle state | `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md`; `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Breaks portable markdown truth and makes future sessions unauditable. |
| Telemetry-owned context engine | `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Creates opaque runtime authority and privacy/scope risk. |
| Auto-approval or auto-continue | `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md`; `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Violates explicit approval and checkpoint invariants. |
| Merge-gate bypass from Pi status/widget | `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Risks merging behind-base or failing-CI work. |
| Helper-agent-owned APPLY | `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md`; `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Undermines parent verification, fallback, module gates, checkpoints, and `.paul/*` writes. |
| Broad replacement of workflow reads with summaries | `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Summaries can omit STOP, DO NOT SKIP, override, checkpoint, or merge-gate semantics. |
| Active Claude Code / Agent SDK parity as current constraint | `docs/PI-NATIVE-SUPPORT-INVENTORY.md`; `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Conflicts with the support-tier reset; preserve historical references and shared invariants instead. |

## Workstream Seeds

| Seed | Source evidence | Needs before implementation |
|---|---|---|
| Artifact-slice contract hardening | Phase 195 summary; final proposal recommended Milestone A | Named slice inventory, output schema, size bounds, freshness rules, fallback text, validation markers. |
| Workflow/resource capsule design | Phase 194 architecture; final proposal recommended Milestone B | Capsule eligibility rules, path citations, full-read fallback criteria, blocking-semantics exclusion list. |
| Guided UI evidence hardening | Phase 193 capability map; Phase 194 architecture; final proposal recommended Milestone B | Canonical transcript reply proof, no-auto-continue tests, checkpoint-blocking evidence. |
| Delegated APPLY packet compression | Phase 193 helper-agent mapping; final proposal recommended Milestone C | Packet fields, structured report schema, allowed-file diff checks, fallback triggers, parent verification obligations. |
| Pi-native validation classification | Phase 193 redesign notes; final proposal recommended Milestone D | Classification scheme for Pi-supported runtime, shared invariant, frozen legacy parity, runtime lens, guided UI safety, helper delegation. |
| Legacy retention and install-surface cleanup | Support inventory; final proposal recommended Milestone E | Explicit product decision after validation classification; shared-invariant relocation before any deletion. |

## Open Planning Questions

1. Which artifact slices are necessary for implementation-grade hardening, and which should stay ordinary markdown reads?
2. What exact schema should every runtime context aid use for `Source`, slice label, freshness, bounds, and fallback language?
3. Which workflow/resource content is safe as an orientation capsule, and which blocking workflow prose must always require full reads?
4. How should Pi guided UI prove explicit canonical user intent in the transcript and artifacts?
5. What helper-agent report fields are sufficient for parent APPLY to inspect equivalent output without weakening parent authority?
6. Which validation assertions protect shared invariants, and which are frozen legacy parity only?
7. What legacy-surface retention/removal decisions are safe only after validation classification is complete?

## Handoff Recommendations

### Phase 198 — Implementation Workstream Design

Use the `Workstream Seeds` table as the starting inventory, but do not assume each seed becomes one build milestone. Phase 198 should define workstream outputs, required source files, validation expectations, and scope boundaries for each candidate. The artifact-slice workstream should be treated as foundational because it is the only implementation pattern already proven by Phase 195.

Key Phase 198 questions:

- Which workstreams are implementation-ready after source review?
- Which workstreams are still architecture-only and need more design?
- Which repo surfaces are likely to change for each workstream?
- Which `.paul/*`, workflow, module, GitHub Flow, and parent-APPLY guarantees must each workstream explicitly preserve?

### Phase 199 — Sequencing + Dependency Plan

Use the promoted-pattern ordering from `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` as the default sequence: artifact slices first, then workflow/resource capsules and guided UI evidence, then helper-agent packet compression, then validation classification, then legacy retention/cleanup. Phase 199 should test that sequence against dependencies, risk, validation burden, and implementation size.

Key Phase 199 questions:

- What proof must artifact-slice hardening produce before capsules or guided UI work begins?
- Should guided UI evidence hardening happen before workflow capsules because it is closer to existing Pi behavior?
- Which workstreams should be split into separate milestones to keep APPLY bounded?
- Which changes must wait until validation classification protects shared invariants elsewhere?

### Phase 200 — Validation + Evidence Strategy

Use the validation classes from `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` as the baseline taxonomy. Phase 200 should define how future implementation proves Pi-supported runtime behavior while preserving shared invariants and labeling frozen legacy parity without prematurely deleting checks.

Key Phase 200 questions:

- Which existing `tests/pi-end-to-end-validation.sh` checks are Pi-supported runtime checks?
- Which `tests/cross-harness-validation.sh` checks protect shared invariants and must remain blocking during transition?
- Which parity checks are frozen legacy evidence only?
- What new runtime-lens, guided UI safety, and helper-agent delegation checks are required before implementation hardening ships?

### Phase 201 — Final Implementation Plan Proposal

Use the outputs of Phases 197-200 to produce an executable roadmap for build milestones. Phase 201 should choose the next implementation milestone(s), define acceptance criteria and boundaries, and explicitly state what is not yet ready to implement.

Key Phase 201 outputs:

- recommended next implementation milestone,
- candidate phase breakdown,
- acceptance criteria families,
- protected authority boundaries,
- validation command requirements,
- legacy-surface retention/removal timing,
- explicit non-goals for the first build milestone.

## Readiness Checklist

Before PALS leaves v2.46 planning and starts implementation hardening:

- [ ] Each proposed workstream has source files, scope limits, and authority boundaries.
- [ ] Artifact-slice hardening has a stable contract proposal for labels, citations, freshness, size bounds, and fallback language.
- [ ] Workflow/resource capsule work has an exclusion rule for blocking workflow semantics that require full reads.
- [ ] Guided UI work has explicit canonical transcript-reply proof and no-auto-continue checks.
- [ ] Helper-agent packet work preserves parent APPLY ownership of eligibility, verification, fallback, module gates, checkpoints, and `.paul/*` writes.
- [ ] Validation changes are classified as Pi-supported runtime, shared invariant, frozen legacy parity, runtime lens, guided UI safety, or helper delegation.
- [ ] Legacy retention/removal is deferred until shared-invariant protection is preserved or intentionally retired by plan.
- [ ] GitHub Flow gates remain workflow-owned and command-evidence-backed.
