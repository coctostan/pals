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

## Dependency Matrix

Legend: `none` = no prerequisite, `soft` = benefits from earlier proof, `blocks` = should not proceed before prerequisite, `defer` = intentionally later.

| Workstream | Artifact-Slice Contract Hardening | Workflow/Resource Capsule Design | Guided Workflow Evidence Hardening | Delegated APPLY Packet/Report Compression | Pi-Native Validation Classification | Legacy Retention and Install-Surface Cleanup |
|---|---|---|---|---|---|---|
| Artifact-Slice Contract Hardening | — | `blocks` capsule citation/fallback reuse | `soft` shared citation/freshness language | `soft` task-packet citation model | `soft` runtime-lens validation inputs | `none` |
| Workflow/Resource Capsule Design | `depends` on stable citation/fallback and bounds | — | `soft` guided prompt inventory | `soft` packet/capsule schema consistency | `soft` validation class mapping for capsule checks | `defer` cleanup remains separate |
| Guided Workflow Evidence Hardening | `soft` shared freshness/citation language | `soft` may inform prompt capsules | — | `soft` parent checkpoint/approval evidence | `soft` guided UI safety classification | `defer` cleanup remains separate |
| Delegated APPLY Packet/Report Compression | `soft` task-local source/fallback conventions | `soft` report/capsule language alignment | `soft` checkpoint/approval evidence | — | `soft` helper delegation validation class | `defer` cleanup remains separate |
| Pi-Native Validation Classification | `depends` on workstream proof needs, but can start as mapping | `blocks` weakening capsule-related parity checks | `blocks` weakening guided UI parity checks | `blocks` weakening helper delegation parity checks | — | `blocks` legacy cleanup |
| Legacy Retention and Install-Surface Cleanup | `none` | `defer` | `defer` | `defer` | `depends` on classification and shared-invariant relocation | — |

## Recommended Order

| Order | Workstream | Why here | Entry proof | Exit proof |
|---:|---|---|---|---|
| 1 | Artifact-Slice Contract Hardening | It is the only proven implementation-grade pattern and supplies source/freshness/fallback conventions used by later lenses. | Phase 195/196 evidence plus Phase 198 readiness classification. | Stable slice schema, named inventory, size/freshness rules, validation markers, and explicit full-read fallback. |
| 2 | Guided Workflow Evidence Hardening | It is close to current Pi guided UX and reduces risk around explicit approval before more summarization surfaces appear. | Inventory of plan review, APPLY approval, checkpoint, continue-to-UNIFY, and merge-gate prompts. | Canonical transcript replies, no-auto-continue proof, no UI-only decisions, and validation markers. |
| 3 | Workflow/Resource Capsule Design | Capsules are useful but riskier because they summarize authoritative workflow prose; they should follow citation/fallback hardening and prompt evidence. | Stable citation/fallback language and blocking-semantics exclusion list. | Capsule eligibility rules, installed path citations, exclusion list for STOP/DO NOT SKIP/checkpoints/merge gates/lifecycle writes, and validation markers. |
| 4 | Delegated APPLY Packet/Report Compression | Helper compression needs clear packet/report schemas and parent verification evidence before context can shrink safely. | Parent-owned packet fields, allowed-file scope rules, fallback triggers, and report schema draft. | Structured report contract, file-scope checks, parent official verification evidence, and no `.paul/*` helper-owned writes. |
| 5 | Pi-Native Validation Classification | Classification must happen before weakening parity or cleanup, but it benefits from knowing proof needs from the first implementation candidates. | Current validation assertion inventory and Phase 200 evidence taxonomy. | Mapping of Pi-supported runtime, shared invariant, frozen parity, runtime lens, guided UI safety, helper delegation, and GitHub Flow safety checks. |
| 6 | Legacy Retention and Install-Surface Cleanup | Cleanup is last because it can remove useful shared-invariant protection if done before validation classes and product decisions are settled. | Completed validation classification and explicit product decision. | Retention/removal matrix, archive/source-only plan, shared-invariant preservation evidence, and user-facing support posture updates. |

## Ordering Alternatives

| Alternative | Sequence | Trade-off | When to choose |
|---|---|---|---|
| A — Evidence-first guided path | Artifact slices → Guided workflow evidence → Validation classification → Capsules → Helper compression → Legacy cleanup | Earlier validation classification reduces later risk, but may classify before capsule/helper proof details are fully known. | Choose if Phase 200 finds existing validation scripts are too mixed to support even small runtime/guided changes safely. |
| B — Foundation-plus-capsules path | Artifact slices → Capsules → Guided workflow evidence → Helper compression → Validation classification → Legacy cleanup | Reduces recurring workflow context sooner, but risks capsule work before explicit transcript-proof hardening. | Choose only if capsule scope is restricted to low-risk orientation topics and blocking-semantics exclusions are already precise. |
| C — Helper-late conservative path | Artifact slices → Guided workflow evidence → Capsules → Validation classification → Helper compression → Legacy cleanup | Keeps helper delegation changes after validation taxonomy, reducing parent-APPLY risk, but delays context savings for implementation-heavy plans. | Choose if future APPLY work is mostly docs/design and `pals-implementer` is not yet a major context-cost driver. |

## Per-Workstream Risk Gates

| Workstream | Prerequisites | Proof points | Risk Gates | Split / Merge Recommendation |
|---|---|---|---|---|
| Artifact-Slice Contract Hardening | Named slice inventory, source/freshness schema, size bounds, fallback wording, validation marker plan. | Activation-gated output; cited sources; bounded slices; no `.paul/*` writes; stale/contested/full-read fallback. | Block if slices become hidden state, omit citations, lack freshness for changing facts, or replace full reads for edits/lifecycle decisions. | Split schema/contract from additional slice inventory if line count or validation burden grows. Do not merge with capsules unless slice proof remains separately reviewable. |
| Workflow/Resource Capsule Design | Stable citation/fallback conventions; installed resource citation format; blocking-semantics exclusion list. | Capsules cite installed logical paths and orient only; full workflow reads remain required for APPLY, UNIFY, checkpoints, lifecycle writes, merge gates, ambiguity, and override handling. | Block if capsules summarize or hide STOP/DO NOT SKIP, override paths, checkpoint handling, lifecycle writes, module enforcement, or merge-gate semantics. | Keep separate from artifact slices unless implementation scope is tiny; prefer a design/contract milestone before runtime behavior changes. |
| Guided Workflow Evidence Hardening | Canonical prompt inventory; reply schema; no-auto-continue test design. | Pi UI actions produce explicit transcript replies for approvals, selections, checkpoint decisions, continue-to-UNIFY, pause/stop, and merge-gate routing. | Block if UI state alone records a decision, if prompts auto-continue, if checkpoint/human gates can be skipped, or if SUMMARY/STATE loses decision evidence. | Can run early or near artifact slices because behavior is close to current Pi UX; keep separate from broad guided UI redesign. |
| Delegated APPLY Packet/Report Compression | Parent-owned packet template; report schema; allowed/forbidden file list; fallback and blocked result rules. | Helper report includes status, files changed, commands, verification, concerns, fallback recommendation, and summary; parent runs official verify and file-scope checks. | Block if helper owns `.paul/*` writes, checkpoints, module gates, official verification, fallback judgment, or APPLY completion status. | Keep separate from workflow rewrites; split schema-only work from runtime/delegation behavior if parent review cannot be equivalent to inline APPLY. |
| Pi-Native Validation Classification | Assertion inventory for Pi and cross-harness scripts; taxonomy from Phase 196; Phase 200 evidence strategy. | Current checks are labeled as Pi-supported runtime, shared invariant, frozen legacy parity, runtime lens, guided UI safety, helper delegation, or GitHub Flow safety. | Block if shared invariants are weakened before relocation, if parity-only failures silently block Pi-native design, or if validation summaries replace command output. | Keep separate from legacy cleanup. It may precede or follow small guided/capsule work only if no parity weakening occurs first. |
| Legacy Retention and Install-Surface Cleanup | Validation classification complete; product decision; archive/retention plan; shared-invariant protection evidence. | Frozen surfaces are labeled, archived, retained, or made source-only with explicit support posture and validation preservation. | Block if cleanup removes `.paul/*` authority, workflow semantics, module evidence, GitHub Flow protection, historical archive truth, or shared invariants. | Last/deferred. Do not merge with validation classification except for labeling/report-only work; removal belongs in a separate product-approved milestone. |

## Split / Merge Recommendations

- **Split artifact-slice work** into contract/schema and additional slice inventory if validation additions or source/freshness rules exceed one bounded APPLY.
- **Merge guided evidence with small validation additions** only when no workflow semantics, validation-script redesign, or hidden UI state is introduced.
- **Do not merge capsules with blocking workflow edits.** Capsule work can cite and orient, but full workflow semantics should remain separately reviewable.
- **Keep helper packet/report compression separate** from lifecycle workflow rewrites until the report schema and parent file-scope verification are stable.
- **Keep validation classification before legacy cleanup.** Classification is evidence strategy; cleanup is a support-surface/product decision.
