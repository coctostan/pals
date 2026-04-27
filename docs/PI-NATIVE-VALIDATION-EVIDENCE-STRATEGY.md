# Pi-Native Validation and Evidence Strategy

## Status

| Field | Value |
|---|---|
| Milestone | v2.46 Pi-Native Implementation Planning |
| Phase | 200 — Validation + Evidence Strategy |
| Artifact status | Planning input for Phase 201 final implementation-plan proposal |
| Implementation status | No runtime, workflow, validation-script, dependency, GitHub Flow, report, or legacy-surface changes are approved by this artifact |

## Purpose

This document defines how future Pi-native implementation milestones should prove behavior while preserving the artifact-first PALS contract. It turns the Phase 199 sequencing/dependency plan into validation classes, command-output evidence rules, and Phase 201 readiness constraints.

Phase 200 is implementation planning, not implementation hardening. This strategy can guide later plans, but it does not authorize edits to Pi runtime behavior, shared workflow semantics, validation scripts, dependency manifests, GitHub Flow behavior, Claude Code wrappers, Agent SDK surfaces, portability docs, installed runtime copies, or validation reports.

## Planning-Only Boundary

This artifact provides validation and evidence strategy only. Future implementation still requires an approved PLAN, parent-owned APPLY, module dispatch evidence, official verification output, GitHub Flow gates when enabled, UNIFY reconciliation, and `.paul/*` lifecycle writes.

Non-negotiable boundaries for all later validation decisions:

- `.paul/*` artifacts remain lifecycle truth; Pi context, widgets, helper-agent reports, guided UI choices, and context slices are derived aids only.
- PLAN/APPLY/UNIFY remains authoritative: PLAN approves work, APPLY executes and verifies under parent control, and UNIFY reconciles durable artifacts.
- Installed `modules.yaml`, `[dispatch] ...` lines, PLAN/SUMMARY/STATE reports, git/PR evidence, and validation command output remain evidence sources; Pi must not create hidden ledgers.
- GitHub Flow gates remain command-evidence-backed; Pi may surface branch/PR/CI state but must not bypass branch creation, base sync, CI, review, merge, or cleanup gates.
- Parent APPLY owns eligibility, official verification, fallback judgment, checkpoints, module enforcement, task result classification, and `.paul/*` writes even when `pals-implementer` helps.
- Runtime context aids must be source-cited, freshness-aware where facts can change, bounded, disposable, and backed by full authoritative reads for edits, lifecycle decisions, stale/contested facts, GitHub Flow gates, or ambiguity.
- No hidden Pi state, telemetry-owned context, auto-approval, auto-continue, UI-only lifecycle decision, helper-owned APPLY, merge-gate bypass, lifecycle ledger, or Pi-owned validation pass signal is allowed.

## Source Inputs

| Source | Evidence used | Strategy implication |
|---|---|---|
| `docs/PI-NATIVE-SEQUENCING-DEPENDENCY-PLAN.md` | Phase 199 validation/evidence questions, validation-class dependencies, Phase 201 handoff, readiness criteria, and sequencing conclusion. | Primary source for the validation/evidence questions this Phase 200 artifact must answer. |
| `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md` | Six candidate workstreams, likely repo surfaces, validation/evidence expectations, dependencies, risk gates, and open questions. | Defines which future workstreams need evidence requirements before Phase 201 proposes build milestones. |
| `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` | Settled decisions, authority boundaries, promoted/rejected patterns, workstream seeds, and Phase 200 questions. | Supplies the baseline requirement to classify Pi-supported runtime, shared invariant, frozen legacy parity, runtime lens, guided UI safety, and helper delegation checks. |
| `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Final v2.45 authority model, promoted patterns, migration roadmap, implementation roadmap, validation classes, evidence requirements, and non-goals. | Establishes the validation class taxonomy and the command-evidence-backed authority model. |
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Context-cost surfaces, non-negotiable guardrails, read/citation contract, assistance components, validation redesign requirements, and rejected designs. | Defines citation, freshness, boundedness, full-read fallback, and command-output truth requirements. |
| `docs/PI-RUNTIME-CAPABILITY-MAP.md` | Pi runtime primitive classifications, lifecycle mapping, guardrails, and validation/CI surfacing notes. | Grounds evidence in current Pi capabilities and separates usable runtime surfaces from guardrail-only or validation-redesign surfaces. |
| `tests/pi-end-to-end-validation.sh` | Current Pi validation categories and assertions for installer deployment, module evidence, skill structure, extension behavior, driver manifests, context-diet guardrails, CODI, guided workflow, helper delegation, and discovery surfaces. | Source for Pi-supported runtime and runtime-lens classification. The script remains command truth, not a report to rewrite in this phase. |
| `tests/cross-harness-validation.sh` | Current cross-harness categories for installer parity, shared apply/REV boundaries, durable module evidence, portability, artifact spec, context-diet guardrails, CODI distribution, and driver manifests. | Source for shared invariant vs frozen legacy parity classification. The script remains command truth, not a report to rewrite in this phase. |
| `docs/PI-VALIDATION-REPORT.md` | Historical Pi report from 2026-03-14 with 75 checks. | Historical example only; current validation truth comes from fresh command output. |
| `docs/VALIDATION-REPORT.md` | Historical cross-harness report from 2026-03-14 with 45 checks. | Historical example only; current validation truth comes from fresh command output. |

## Validation Strategy Principles

1. **Command output is validation truth.** Reports, widgets, summaries, and Pi lenses can explain results, but they cannot mark validation green without the actual command output.
2. **Classify before weakening.** A check must be labeled by support purpose before any future plan weakens, relocates, archives, or deletes it.
3. **Protect shared invariants first.** `.paul/*` authority, PLAN/APPLY/UNIFY, module evidence, GitHub Flow gates, parent-owned APPLY, explicit approval/checkpoints, and archive/handoff traceability remain blocking product invariants.
4. **Treat frozen legacy parity as evidence, not current product direction.** Claude Code and Agent SDK parity can remain useful historical proof, but parity-only checks should not silently veto Pi-native design after classification.
5. **Add runtime-lens proof with every new lens.** Artifact slices, capsules, module lenses, GitHub Flow lenses, CARL bootstrap, and helper reports need source citations, freshness where facts can change, bounds, activation/intent proof, and full-read fallback.
6. **Keep guided UI auditable.** Any UI confirmation, selection, checkpoint, approval, continue-to-UNIFY, or merge-gate route must emit explicit canonical transcript or artifact evidence.
7. **Keep helper delegation parent-verifiable.** Helper-agent context compression is safe only when packet fields, report fields, changed files, attempted commands, fallback triggers, and parent official verification remain inspectable.
8. **Do not combine validation classification with cleanup.** Legacy retention or install-surface cleanup waits until shared-invariant coverage is identified and product approval is explicit.
