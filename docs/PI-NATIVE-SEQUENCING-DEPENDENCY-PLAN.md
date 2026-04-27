# Pi-Native Sequencing and Dependency Plan

## Status

| Field | Value |
|---|---|
| Milestone | v2.46 Pi-Native Implementation Planning |
| Phase | 199 — Sequencing + Dependency Plan |
| Artifact status | Planning input for Phase 200 validation/evidence strategy and Phase 201 final implementation-plan proposal |
| Implementation status | No runtime, workflow, validation-script, dependency, GitHub Flow, or legacy-surface changes are approved by this artifact |

## Purpose

This document turns the Phase 198 workstream map into sequencing and dependency guidance for future build milestones. It tests the default v2.45/v2.46 implementation order against dependency edges, risk, validation burden, proof points, and authority boundaries before implementation hardening begins.

The artifact is intentionally planning-only. It does not choose the final executable implementation roadmap; Phase 201 owns that proposal after Phase 200 defines validation and evidence strategy.

## Planning-Only Boundary

This artifact provides sequencing/dependency planning only. It does not approve changes to Pi runtime behavior, shared workflow semantics, validation scripts, dependency manifests, GitHub Flow behavior, Claude Code wrappers, Agent SDK surfaces, portability docs, installed runtime copies, or lifecycle authority.

Future implementation still requires an approved PLAN, parent-owned APPLY, task verification, module dispatch evidence, GitHub Flow gates when enabled, UNIFY reconciliation, and `.paul/*` lifecycle writes.

Non-negotiable boundaries for all later sequencing decisions:

- `.paul/*` artifacts remain lifecycle truth; Pi context, widgets, helper-agent reports, and UI choices are derived aids only.
- PLAN/APPLY/UNIFY remains authoritative: PLAN approves work, APPLY executes and verifies under parent control, and UNIFY reconciles durable artifacts.
- Installed `modules.yaml`, `[dispatch] ...` lines, PLAN/SUMMARY/STATE reports, and validation command output remain evidence sources; Pi must not create hidden ledgers.
- GitHub Flow gates remain command-evidence-backed; Pi may surface branch/PR/CI state but must not bypass base sync, CI, review, merge, or cleanup gates.
- Parent APPLY owns eligibility, official verification, fallback judgment, checkpoints, module enforcement, task result classification, and `.paul/*` writes even when `pals-implementer` helps.
- Runtime context aids must be source-cited, freshness-aware where facts can change, bounded, disposable, and backed by full authoritative reads for edits, lifecycle decisions, stale/contested facts, GitHub Flow gates, or ambiguity.
- No hidden Pi state, telemetry-owned context, auto-approval, auto-continue, UI-only lifecycle decision, helper-owned APPLY, merge-gate bypass, or lifecycle ledger is allowed.

## Source Inputs

| Source | Evidence used | Sequencing implication |
|---|---|---|
| `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md` | Phase 198 candidate workstreams, readiness, outputs, repo surfaces, validation expectations, dependencies, risk gates, and Phase 199 handoff. | Primary workstream inventory and dependency-edge source for this artifact. |
| `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` | Phase 197 settled decisions, promoted patterns, rejected options, workstream seeds, and Phase 199/200/201 handoff questions. | Supplies default order pressure: artifact slices first, capsules/guided UI later, helper packet compression later, validation classification before legacy cleanup. |
| `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Final v2.45 architecture, target authority model, promoted patterns, migration roadmap, implementation roadmap A-E, validation classes, non-goals, and readiness checklist. | Provides the default milestone-order hypothesis and the authority/proof constraints for every future build milestone. |
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Context-cost surfaces, non-negotiable guardrails, read/citation contract, assistance components, recommended sequence, validation redesign requirements, and rejected designs. | Defines why artifact slices are foundational and why workflow capsules require stronger exclusion rules. |
| `docs/PI-RUNTIME-CAPABILITY-MAP.md` | Current Pi runtime primitives, capability classifications, lifecycle mapping, guided workflow constraints, helper-agent boundaries, and validation redesign notes. | Grounds sequencing in what Pi can already do safely vs what is guardrail-only or validation-redesign work. |
| `.paul/phases/198-implementation-workstream-design/198-01-SUMMARY.md` | Phase 198 results, decisions, validation evidence, and warnings that sequencing must not be finalized too early. | Confirms six candidate workstreams are ready for dependency/risk analysis and that validation classification must precede legacy cleanup. |

## Sequencing Principles

1. **Build from proven to risky.** Start with the only implementation-grade pattern already validated: activation-gated artifact slices.
2. **Stabilize citation/fallback before summarization.** Runtime slices should settle source, freshness, bounds, and fallback language before workflow/resource capsules summarize authoritative process prose.
3. **Prefer explicit user-intent proof early.** Guided workflow evidence is close to current Pi behavior and can reduce approval/checkpoint risk before broader UX expansion.
4. **Keep parent verification ahead of helper compression.** Delegated APPLY packet/report compression should not proceed until packet fields, allowed-file checks, fallback triggers, and parent official verification remain obvious.
5. **Classify validation before weakening parity.** Pi-native validation classification must precede parity-check removal, legacy install-surface cleanup, or broad validation rewrites.
6. **Defer product-support cleanup last.** Legacy retention/removal is a product/support-surface decision, not a context-efficiency prerequisite for early build milestones.
7. **Split when proof types diverge.** A workstream should split if one plan would mix runtime behavior, workflow semantics, validation-script redesign, and support-tier cleanup in a way that obscures evidence.
