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

## Phase 200 Handoff

Phase 200 owns validation and evidence strategy. It should use this sequencing plan to decide what future implementation milestones must prove before runtime hardening, validation-script changes, or support-surface cleanup begins.

### Validation / Evidence Questions

| Question | Why it matters | Suggested evidence |
|---|---|---|
| Which current Pi validation checks prove supported runtime behavior? | New artifact-slice, guided UI, capsule, and helper work should add to Pi-supported evidence rather than legacy parity. | Annotated map of `tests/pi-end-to-end-validation.sh` assertions to Pi-supported runtime classes. |
| Which cross-harness checks protect shared invariants? | Shared invariants must remain blocking even when Claude Code / Agent SDK parity is frozen. | Annotated map of `tests/cross-harness-validation.sh` assertions to shared invariant vs frozen parity classes. |
| What command output must future APPLY/UNIFY preserve? | Validation truth must remain command-evidence-backed, not Pi-summary-backed. | SUMMARY verification table requirements for marker grep, Pi validation, cross-harness validation, git/gh checks, and module reports. |
| What new runtime-lens checks are needed? | Artifact slices and capsules need structural proof for citations, bounds, freshness, activation gating, and fallback. | Marker assertions for `Source:`, freshness language, full-read fallback text, no hidden persistence, and bounded output. |
| What new guided UI safety checks are needed? | Guided UX must reduce friction without auto-approval or UI-only decisions. | Tests or structural checks for canonical transcript replies, explicit user action, checkpoint blocking, and no auto-continue paths. |
| What new helper delegation checks are needed? | Packet/report compression is only safe if parent verification remains inspectable. | Required report-field checks, allowed-file diff checks, fallback trigger markers, and no `.paul/*` helper-owned lifecycle writes. |
| What must remain green during transition? | Existing green validation is the safety baseline for implementation planning. | Pi validation 186/186 and cross-harness validation 100/100 or updated expected counts with documented classification rationale. |

### Validation-Class Dependencies

- Artifact-slice hardening needs runtime-lens checks plus shared invariant checks for `.paul/*` authority and full-read fallback.
- Guided workflow evidence hardening needs guided UI safety checks before any UI affordance is treated as lower risk.
- Workflow/resource capsule design needs shared invariant checks that prove blocking workflow semantics remain intact and full reads remain required.
- Delegated APPLY packet/report compression needs helper delegation checks plus parent-owned APPLY invariant checks.
- Legacy cleanup must wait for classification proving each affected parity check is either frozen-only or has shared-invariant coverage elsewhere.

## Phase 201 Handoff

Phase 201 owns the final executable implementation-plan proposal. It should choose concrete build milestone scope only after Phase 200 defines validation classes and evidence requirements.

### Implementation Roadmap Inputs

| Input | Recommendation for Phase 201 |
|---|---|
| Default first build candidate | Propose Artifact-Slice Contract Hardening first unless Phase 200 finds validation classification must precede any runtime-context changes. |
| Likely second candidate | Propose Guided Workflow Evidence Hardening early because it is close to existing Pi behavior and proves explicit intent before broader UX/capsule work. |
| Capsule timing | Keep Workflow/Resource Capsule Design after slice citation/fallback proof and explicit blocking-semantics exclusions. |
| Helper compression timing | Keep Delegated APPLY Packet/Report Compression after packet/report schema clarity and parent file-scope verification rules. |
| Validation classification | Treat as either Phase 200 output feeding the roadmap or a dedicated early build milestone if script/report changes are required. |
| Legacy cleanup | Defer to a final/product-decision milestone after classification and shared-invariant protection are proven. |

### Candidate Milestone Splits

| Candidate split | Contents | Rationale |
|---|---|---|
| Split 1: Artifact-slice contract only | Slice schema, source/freshness/fallback language, size bounds, validation markers. | Keeps first build milestone small and validates the foundational contract. |
| Split 2: Artifact-slice inventory expansion | Additional lifecycle, roadmap, plan, summary, and module-evidence slices. | Avoids mixing schema design with many new runtime outputs. |
| Split 3: Guided workflow evidence | Canonical replies, no-auto-continue proof, checkpoint/approval transcript evidence. | Proves explicit intent before broader Pi UX or capsule work. |
| Split 4: Capsule contract | Eligibility rules, installed path citations, exclusion list, validation markers. | Keeps risky workflow summarization separate from runtime behavior expansion. |
| Split 5: Helper packet/report contract | Packet template, report schema, fallback triggers, allowed-file checks. | Reduces parent context only after equivalence to inline APPLY can be verified. |
| Split 6: Validation classification | Assertion mapping, report classifications, migration rules. | Required before weakening parity or cleanup. |
| Split 7: Legacy retention cleanup | Retention/removal matrix, archive/source-only decisions, install-surface adjustments. | Product/support-surface decision that should remain last. |

### Readiness Criteria for Phase 201 Proposals

- The proposed milestone names exact repo surfaces, protected files, validation commands, and expected evidence.
- Acceptance criteria preserve `.paul/*` authority, PLAN/APPLY/UNIFY ownership, module evidence, GitHub Flow gates, parent-owned APPLY, explicit approval/checkpoint behavior, and full-read fallback.
- The proposal states which validation class each changed check belongs to: Pi-supported runtime, shared invariant, frozen legacy parity, runtime lens, guided UI safety, helper delegation, or GitHub Flow safety.
- The proposal defers or excludes hidden Pi state, telemetry, auto-approval, helper-owned APPLY, merge-gate bypass, lifecycle ledger, dependency additions, and unclassified legacy cleanup.
- The proposal includes command-output evidence requirements for APPLY and durable reconciliation requirements for SUMMARY/STATE/ROADMAP during UNIFY.

### Non-Goals to Carry Forward

- Do not treat Phase 199 sequencing as final build authorization.
- Do not rewrite validation scripts in a build milestone until Phase 200 defines the evidence strategy or the plan is explicitly scoped to validation classification.
- Do not delete, archive, or remove installed legacy surfaces before classification and product decision.
- Do not let runtime slices, capsules, UI status, or helper reports replace full authoritative reads for lifecycle-changing decisions.

## Sequencing Readiness Checklist

A workstream is ready to be promoted into a future build milestone proposal only when all applicable items are true:

- [ ] Source inputs and repo surfaces are named precisely enough for a bounded PLAN.
- [ ] Dependencies on earlier proof points are satisfied or explicitly deferred.
- [ ] Scope limits and protected files are explicit.
- [ ] Acceptance criteria preserve `.paul/*` authority, PLAN/APPLY/UNIFY ownership, module evidence, GitHub Flow gates, and parent-owned APPLY.
- [ ] Runtime assistance remains derived, bounded, disposable, source-cited, freshness-aware where needed, and backed by full authoritative reads.
- [ ] Explicit approval, checkpoint, and guided UI behavior remain visible as canonical transcript/artifact evidence.
- [ ] Helper-agent work, if any, remains parent-packeted, parent-verified, file-scoped, and fallback-safe.
- [ ] Validation commands and expected evidence are named before implementation begins.
- [ ] Shared invariants remain protected before any parity-only check or frozen legacy surface is weakened.
- [ ] No hidden Pi state, telemetry, auto-approval, UI-only decisions, helper-owned APPLY, merge-gate bypass, or lifecycle ledger is introduced.

## Phase 199 Conclusion

The recommended default sequence is Artifact-Slice Contract Hardening, Guided Workflow Evidence Hardening, Workflow/Resource Capsule Design, Delegated APPLY Packet/Report Compression, Pi-Native Validation Classification, then Legacy Retention and Install-Surface Cleanup. Phase 200 should pressure-test this order through validation/evidence classification, and Phase 201 should convert the surviving order into an executable implementation-plan proposal without treating this planning artifact as build approval.
