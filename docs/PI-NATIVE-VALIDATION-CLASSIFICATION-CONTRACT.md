# Pi-Native Validation Classification Contract

## Status

| Field | Value |
|---|---|
| Milestone | v2.51 Pi-Native Validation Classification |
| Baseline phase | 218 — Validation Classification Baseline |
| Artifact status | Baseline contract for validation-suite classification and Phase 219 hardening |
| Implementation status | Phase 218 creates this contract only. Validation scripts, runtime files, install surfaces, reports, dependency manifests, CI config, GitHub Flow automation, legacy wrappers, and lifecycle authority semantics remain unchanged. |

## Purpose and boundary

PALS must classify validation checks by support purpose before any check is weakened, relocated, archived, deleted, or treated as legacy-only. This contract turns the Phase 200 validation/evidence strategy into a v2.51 baseline for the current Pi and cross-harness validation suites.

Command-output truth remains authoritative: reports, widgets, summaries, helper reports, lenses, and this classification contract may explain validation posture, but they do not mark validation green by themselves. Fresh command output from focused marker checks, `bash tests/pi-end-to-end-validation.sh`, and `bash tests/cross-harness-validation.sh` remains the validation truth for APPLY/UNIFY.

Phase 218 is baseline-only. It inventories current validation families and records preservation rules so Phase 219 can add explicit classification markers and guardrails without re-deciding taxonomy. Legacy Retention / Install-Surface Cleanup remains deferred until classification hardening is complete and product approval is explicit.

## Source inputs

| Source | Evidence used | Contract implication |
|---|---|---|
| `.paul/phases/218-validation-classification-baseline/218-01-PLAN.md` | Approved Phase 218 objective, acceptance criteria, suite-family minimums, scope boundaries, and verification commands. | This contract must cover taxonomy, current suite inventory, count-change reconciliation, no-cleanup preservation rules, and Phase 219 handoff while keeping validation scripts read-only. |
| `docs/PI-NATIVE-VALIDATION-EVIDENCE-STRATEGY.md` | Phase 200 validation principles, class taxonomy, current suite classification, preservation rules, and command-output evidence requirements. | Supplies the class names, blocking posture, command-output truth rule, and classify-before-weakening requirement. |
| `.paul/phases/217-evidence-reconciliation-milestone-closure/217-01-SUMMARY.md` | v2.50 closure baseline: Pi validation passed 200/200 and cross-harness validation passed 116/116. | Establishes the current command-output baseline that Phase 218 preserves and Phase 219 must reconcile against if counts change. |
| `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md` | Runtime Lens and Shared Invariant evidence for bounded artifact slices, source citations, fallback, and no hidden state. | Classification must preserve runtime-lens proof and shared-invariant coverage before any cleanup. |
| `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` | Guided UI Safety evidence for canonical replies, no auto-approval, no auto-continue, checkpoint blocking, and no UI-only lifecycle decisions. | Guided workflow checks remain safety evidence and cannot be treated as visual polish only. |
| `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md` | Runtime Lens evidence for capsules as derived aids with source/type/freshness/bounds/fallback and blocking-semantics exclusions. | Capsule checks remain runtime-lens and shared-invariant evidence until equivalent command proof exists. |
| `docs/PI-NATIVE-DELEGATED-APPLY-PACKET-REPORT-CONTRACT.md` | Helper Delegation evidence for parent-owned packets, structured reports, allowed/forbidden files, fallback triggers, parent verification, and no helper-owned lifecycle writes. | Helper delegation validation remains parent-verifiable command evidence, not helper-owned lifecycle authority. |
| `tests/pi-end-to-end-validation.sh` | Current Pi validation suite category families and TAP output. | Read-only Phase 218 input; Phase 219 may add explicit classification markers. |
| `tests/cross-harness-validation.sh` | Current cross-harness validation suite category families and TAP output. | Read-only Phase 218 input; Phase 219 may add explicit classification markers. |

## Validation class taxonomy

| Class | Purpose | Evidence | Blocking posture |
|---|---|---|---|
| Pi-Supported Runtime | Proves the supported Pi runtime, installer, skills, extension, manifests, lifecycle UI, and Pi discovery surfaces work as designed. | Pi installer output, installed skill/resource structure, extension command/hook behavior, driver manifest checks, Pi docs and discovery markers. | Blocking for Pi-native milestones that touch Pi runtime, installer, skill/resource deployment, extension behavior, driver manifests, or Pi-facing discovery. |
| Shared Invariant | Protects PALS lifecycle semantics independent of runtime. | `.paul/*` authority markers, PLAN/APPLY/UNIFY loop markers, module evidence, GitHub Flow safety, parent-owned APPLY, explicit approval/checkpoint rules, context-diet guardrails, archive/handoff traceability. | Blocking until a future approved plan intentionally relocates or retires the invariant with equivalent command evidence. |
| Frozen Legacy Parity | Preserves historical compatibility evidence for Claude Code, Agent SDK, and cross-harness install surfaces after the support-tier reset. | Claude Code wrapper parity, legacy installer parity, cross-harness file-count parity, historical portability docs, driver parity checks. | Non-authorizing by itself for new Pi behavior; do not weaken or delete until shared-invariant coverage is identified and product approval is explicit. |
| Runtime Lens | Proves Pi-derived context assistance remains bounded, cited, freshness-aware where facts can change, disposable, and backed by full authoritative reads. | Artifact-slice markers, workflow/resource capsule markers, source citations, freshness/bounds/fallback text, activation gating, no hidden persistence, full-read fallback. | Blocking for artifact-slice, capsule, module lens, GitHub Flow lens, CARL bootstrap, or context-injection changes. |
| Guided UI Safety | Proves Pi UI assistance cannot silently continue lifecycle work, approve work, satisfy checkpoints, or hide user intent. | Canonical transcript replies, explicit user action, checkpoint blocking, no auto-approval, no auto-continue, no UI-only lifecycle decisions, no inferred merge intent. | Blocking for guided workflow, checkpoint, approval, continue-to-UNIFY, or merge-gate UI changes. |
| Helper Delegation | Proves `pals-implementer` remains bounded, parent-packeted, file-scoped, fallback-safe, and parent-verifiable. | Parent-owned task packet fields, structured helper report fields, allowed/forbidden file scope, changed-file diff checks, fallback triggers, parent official verification, no helper-owned `.paul/*` lifecycle writes. | Blocking for helper-agent packet/report compression, delegated APPLY ergonomics, or helper-agent installation/contract changes. |
| GitHub Flow Safety | Proves branch, PR, CI, review, merge, base-sync, and branch-cleanup behavior remain workflow-owned and command-evidence-backed. | `git branch`, ahead/behind counts, `gh pr view`, `gh pr checks`, PR URL/state, CI status, merge-gate summaries, base sync and branch cleanup output. | Blocking for git status, route, PR, CI, merge-gate, or next-action automation changes. |
| Artifact / Process | Proves lifecycle artifacts, plans, summaries, validation reports, and process evidence remain reviewable, fresh, and subordinate to command output. | PLAN source inputs/boundaries, SUMMARY AC results, STATE/ROADMAP updates, Module Execution Reports, validation report freshness labels, historical-report disclaimers. | Blocking for lifecycle writes, validation reports, documentation artifacts that shape implementation planning, and evidence reconciliation phases. |

## Current command-output baseline

The current v2.51 baseline is inherited from Phase 217 closure evidence:

| Suite | Current baseline | Source |
|---|---:|---|
| `bash tests/pi-end-to-end-validation.sh` | 200/200 passing | `.paul/phases/217-evidence-reconciliation-milestone-closure/217-01-SUMMARY.md` |
| `bash tests/cross-harness-validation.sh` | 116/116 passing | `.paul/phases/217-evidence-reconciliation-milestone-closure/217-01-SUMMARY.md` |

These counts are not self-validating when copied into artifacts. Each APPLY/UNIFY must preserve fresh command output and reconcile count changes with class-aware rationale.

## Current suite classification inventory

Phase 218 records this section as the baseline location for current Pi and cross-harness validation families. Phase 219 owns validation-suite marker hardening against this inventory.

## Preservation rules

Phase 218 records this section as the baseline location for class-aware preservation and count-change reconciliation rules. Phase 219 owns validation-suite marker hardening against these rules.

## Phase 219 handoff

Phase 219 should use this contract as the source taxonomy and inventory for validation-suite classification hardening.

## Readiness checklist

A future validation-changing plan is ready only when it names affected validation classes, expected command-output evidence, changed checks, protected shared invariants, and count-change reconciliation requirements.
