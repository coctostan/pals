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
