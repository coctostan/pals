# Pi-Native Implementation Plan Proposal

## Status

| Field | Value |
|---|---|
| Milestone | v2.46 Pi-Native Implementation Planning |
| Phase | 201 — Final Implementation Plan Proposal |
| Artifact status | Final v2.46 proposal for future Pi-native build milestones |
| Implementation status | No runtime, workflow, validation-script, dependency, GitHub Flow, installed-runtime, report, or legacy-surface changes are approved by this artifact |

## Purpose

This document converts the v2.46 planning artifacts into an executable roadmap for the next Pi-native implementation milestones. It proposes the order, scope, acceptance-criteria families, validation classes, evidence requirements, and non-negotiable boundaries that future build milestones should use.

This is a proposal artifact, not build authorization. Each future build milestone still requires normal PALS lifecycle approval: milestone creation, PLAN approval, parent-owned APPLY, task verification, module dispatch evidence, GitHub Flow gates when enabled, UNIFY reconciliation, and `.paul/*` lifecycle writes.

## Planning-Only Boundary

This Phase 201 artifact may guide later implementation planning, but it does not authorize edits to:

- Pi runtime behavior or installed runtime copies.
- Kernel workflow semantics or module source behavior.
- Validation scripts, validation reports, dependency manifests, or CI configuration.
- GitHub Flow branch, PR, CI, merge, or cleanup behavior.
- Claude Code wrappers, Agent SDK surfaces, portability docs, or other frozen legacy surfaces.
- `.paul/*` lifecycle authority, PLAN/APPLY/UNIFY ownership, module evidence, GitHub Flow gates, parent-owned APPLY, explicit approval/checkpoint behavior, or archive authority.

## Source Inputs

| Source | Evidence used | Proposal implication |
|---|---|---|
| `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` | Settled v2.45 decisions, authority boundaries, promoted/rejected patterns, workstream seeds, open questions, and Phase 201 handoff outputs. | Keep artifact slices first, preserve derived-only Pi assistance, reject hidden state/telemetry/auto-approval/helper-owned APPLY, and name what is not ready. |
| `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md` | Six candidate workstreams, readiness levels, likely repo surfaces, validation expectations, boundaries, dependencies, and risk gates. | Promote artifact-slice contract hardening as the first implementation-ready workstream; keep other workstreams scoped by readiness and dependencies. |
| `docs/PI-NATIVE-SEQUENCING-DEPENDENCY-PLAN.md` | Default order, ordering alternatives, dependency matrix, split/merge cautions, Phase 201 roadmap inputs, and readiness criteria. | Use the default order unless a future plan explicitly chooses a validation-first override; preserve split points where proof types diverge. |
| `docs/PI-NATIVE-VALIDATION-EVIDENCE-STRATEGY.md` | Validation taxonomy, current suite classification, command-output evidence rules, durable artifact evidence rules, and Phase 201 handoff constraints. | Every proposed build milestone must include validation classes, command evidence, durable artifact evidence, fallback triggers, and shared-invariant preservation. |
| `.paul/phases/200-validation-evidence-strategy/200-01-SUMMARY.md` | Phase 200 acceptance criteria, validation output baseline, decisions, module reports, and readiness notes. | Phase 201 can proceed because Pi validation was 186/186 and cross-harness validation was 100/100; command output remains validation truth. |

## Settled Synthesis

| Decision | Proposal consequence |
|---|---|
| Pi is the active supported runtime. | New context-efficiency, guided workflow, helper-agent, and validation work should optimize for Pi unless a later product decision reopens active legacy parity. |
| `.paul/*` artifacts remain lifecycle truth. | Runtime slices, capsules, widgets, guided UI, helper reports, and Pi status surfaces stay derived, bounded, disposable, and source-backed. |
| Artifact-slice loading is the first proven Pi-native context-efficiency pattern. | The first build milestone should harden the artifact-slice contract before broader capsules, helper compression, or cleanup. |
| Validation must be classified before weakening checks. | Shared invariants remain blocking until equivalent command evidence exists; frozen legacy parity should be labeled before any retention/removal decision. |
| Command output is validation truth. | Pi summaries, validation reports, widgets, slices, capsules, and helper reports may explain results, but they cannot mark validation green without actual command output. |
| Parent APPLY remains authoritative. | `pals-implementer` can reduce bounded task context only when parent packets, verifies, checks files, enforces modules, owns fallback, and writes lifecycle artifacts. |

## Non-Negotiable Authority Boundaries

Future build milestones must preserve these boundaries as acceptance criteria, not as informal notes:

- `.paul/*` artifacts remain lifecycle truth; no hidden Pi state, telemetry-owned context, local memory, widget state, helper transcript, or UI selection becomes authoritative.
- PLAN/APPLY/UNIFY remains the lifecycle loop: PLAN defines approved work, APPLY executes and verifies under parent control, and UNIFY reconciles durable artifacts.
- Installed `modules.yaml`, `[dispatch] ...` lines, PLAN/SUMMARY/STATE reports, and validation command output remain module and quality evidence; Pi must not create a separate module ledger.
- GitHub Flow gates remain workflow- and command-evidence-backed; Pi may surface branch/PR/CI status but must not bypass branch creation, base sync, CI, review, merge, or cleanup gates.
- Parent APPLY owns helper eligibility, official verification, fallback judgment, checkpoints, module enforcement, task result classification, and `.paul/*` lifecycle writes.
- Full authoritative reads remain required for edits, approved PLAN execution, lifecycle writes, GitHub Flow gates, stale or contested facts, ambiguity, and decisions that change lifecycle state.
- Explicit approval and checkpoint behavior must stay transcript- or artifact-visible; UI-only decisions, auto-approval, auto-continue, skipped checkpoints, or inferred merge intent are not allowed.

## Recommended First Build Milestone

### Milestone A: Artifact-Slice Contract Hardening

**Recommendation:** Start the next build cycle with Artifact-Slice Contract Hardening.

**Why first:** Phase 195 proved activation-gated, source-cited, freshness-marked, read-only artifact slices can reduce repeated read burden without replacing `.paul/*` truth. Phases 196-200 repeatedly promote this as the most implementation-ready pattern, and Phase 200 defines the validation/evidence rules needed to harden it safely.

**Likely repo surfaces:**

- `drivers/pi/extensions/pals-hooks.ts`
- `drivers/pi/extensions/README.md`
- `drivers/pi/skill-map.md`
- `tests/pi-end-to-end-validation.sh`
- Possibly `docs/PI-VALIDATION-REPORT.md` only if a future plan explicitly scopes report freshness/classification updates

**Entry conditions:**

- Named slice inventory is defined before implementation starts.
- Slice schema is explicit: source path, slice label, freshness marker, size/bounds, and full-read fallback language.
- Protected files and non-goals are listed in the approved PLAN.
- Validation classes are declared: primarily Runtime Lens, Pi-Supported Runtime, Shared Invariant, and Artifact / Process.

**Exit evidence:**

- Slice output is activation-gated and bounded.
- Every slice cites source paths and includes freshness/fallback language where facts can change.
- Validation proves no slice writes `.paul/*`, creates hidden persistence, replaces full reads, or changes lifecycle authority.
- `bash tests/pi-end-to-end-validation.sh` passes with expected count evidence.
- `bash tests/cross-harness-validation.sh` remains green for shared invariants.
- SUMMARY records exact marker checks, TAP counts, changed files, module reports, and GitHub Flow state.

**First-build non-goals:**

- Do not implement workflow/resource capsules in the same milestone unless slice proof remains separately reviewable and bounded.
- Do not alter guided workflow approval semantics.
- Do not compress helper-agent packets or reports.
- Do not weaken validation parity or perform legacy cleanup.
- Do not add dependencies, telemetry, hidden state, or Pi-owned lifecycle/validation pass signals.

## Candidate Build Sequence

| Order | Candidate milestone | Purpose | Key dependencies | Exit evidence |
|---:|---|---|---|---|
| 1 | Artifact-Slice Contract Hardening | Stabilize activation-gated, bounded, source-cited, freshness-aware context slices and fallback language. | Phase 195 proof, Phase 200 validation strategy, named slice inventory. | Runtime Lens + Pi-Supported Runtime checks, slice citation/freshness/bounds markers, no hidden state, full-read fallback, green Pi/cross-harness validation. |
| 2 | Guided Workflow Evidence Hardening | Prove guided UI approvals, checkpoint choices, continue-to-UNIFY, pause/stop, and merge-gate routes emit explicit canonical transcript replies. | Inventory of guided prompts and reply values; no-auto-continue test design. | Guided UI Safety checks, explicit user action evidence, checkpoint blocking proof, no UI-only lifecycle decisions, green validation. |
| 3 | Workflow/Resource Capsule Contract | Define safe orientation capsules for installed resources without replacing authoritative workflow reads. | Stable citation/fallback language from Milestone A; blocking-semantics exclusion list. | Capsule eligibility rules, installed path citations, STOP/DO NOT SKIP/checkpoint/lifecycle/merge-gate exclusions, required full-read fallback. |
| 4 | Delegated APPLY Packet/Report Contract | Reduce parent context cost for bounded helper-agent tasks while preserving parent APPLY authority. | Packet template, report schema, allowed/forbidden file rules, fallback triggers. | Helper Delegation checks, structured reports, parent official verification, file-scope diff checks, no helper-owned `.paul/*` writes. |
| 5 | Pi-Native Validation Classification | Label current and future validation checks by support purpose before weakening, relocating, archiving, or deleting any check. | Assertion inventory for Pi and cross-harness suites; Phase 200 taxonomy. | Classification map for Pi-Supported Runtime, Shared Invariant, Frozen Legacy Parity, Runtime Lens, Guided UI Safety, Helper Delegation, GitHub Flow Safety, and Artifact / Process. |
| 6 | Legacy Retention and Install-Surface Cleanup | Decide what frozen Claude Code, Agent SDK, portability, and install-surface artifacts stay, move, become source-only, or retire. | Completed validation classification plus explicit product/support decision. | Retention/removal matrix, archive/source-only plan, preserved shared-invariant evidence, green validation, user-facing support posture updates. |

## Split / Merge Guidance

- Split artifact-slice work into schema/contract and additional slice inventory if validation burden or source/freshness rules grow beyond one bounded APPLY.
- Keep guided workflow evidence separate from broad guided UI redesign; the first pass should prove explicit intent and no-auto-continue behavior.
- Do not merge workflow/resource capsules with blocking workflow semantic rewrites. Capsules orient; full workflow reads remain authoritative for blocking semantics.
- Keep delegated APPLY packet/report compression separate from lifecycle workflow rewrites until parent review equivalence is proven.
- Keep validation classification separate from legacy cleanup. Classification labels evidence; cleanup is a support-surface/product decision.
- Legacy retention/removal is last by default and requires product approval plus preserved shared-invariant coverage.

## Acceptance-Criteria Families for Future Build Plans

Every future build PLAN derived from this proposal should include acceptance criteria for the applicable families below:

| Family | Required proof |
|---|---|
| Source grounding | PLAN cites the source artifacts, repo surfaces, protected files, and exact boundaries that authorize the work. |
| Authority preservation | `.paul/*`, PLAN/APPLY/UNIFY, module evidence, GitHub Flow gates, parent-owned APPLY, approval/checkpoint behavior, and archive truth remain authoritative. |
| Runtime aid boundedness | Pi context aids are derived, bounded, disposable, source-cited, freshness-aware where needed, and backed by full authoritative reads. |
| Explicit user intent | Guided UI or checkpoint behavior emits canonical transcript/artifact evidence and cannot auto-approve, auto-continue, skip checkpoints, or infer merge intent. |
| Helper delegation safety | Helper work is parent-packeted, parent-verified, file-scoped, fallback-safe, and forbidden from lifecycle ownership. |
| Validation command truth | Marker checks and validation scripts produce current command output; reports and UI summaries cannot replace that output. |
| Durable reconciliation | SUMMARY, STATE, ROADMAP, module histories, git/PR evidence, and any validation count changes are reconciled during UNIFY. |
| Deferral discipline | Runtime, workflow, validation-script, dependency, GitHub Flow, legacy, and cleanup work outside the approved scope remains deferred. |

## Validation Classes

Future plans must name every affected validation class before implementation begins:

| Class | When required | Blocking posture |
|---|---|---|
| Pi-Supported Runtime | Pi install/runtime/extension/skill/discovery behavior changes. | Blocking for Pi-native milestones that touch supported runtime behavior. |
| Shared Invariant | `.paul/*` authority, PLAN/APPLY/UNIFY, module evidence, GitHub Flow safety, parent-owned APPLY, explicit approvals/checkpoints, archives, or context-diet guardrails. | Blocking until equivalent command evidence exists or an approved plan explicitly retires the invariant. |
| Frozen Legacy Parity | Claude Code, Agent SDK, cross-driver parity, portability, or legacy install surfaces. | Label before weakening; do not let parity-only failures silently veto Pi-native direction after classification. |
| Runtime Lens | Artifact slices, capsules, module lenses, GitHub Flow lenses, CARL bootstrap, context injection, or bounded context outputs. | Blocking for runtime context-assistance changes. |
| Guided UI Safety | Plan review, APPLY approval, checkpoints, continue-to-UNIFY, pause/stop, merge-gate UI, or guided workflow changes. | Blocking for any UI-assisted lifecycle decision path. |
| Helper Delegation | `pals-implementer` packet/report, delegated APPLY ergonomics, helper summaries, or allowed-file verification changes. | Blocking for helper-agent context-compression work. |
| GitHub Flow Safety | Branch, base sync, PR, CI, review, merge, cleanup, or status-routing changes. | Blocking for GitHub Flow automation or surfacing changes. |
| Artifact / Process | PLAN/SUMMARY/STATE/ROADMAP/report/history changes that shape lifecycle truth or planning evidence. | Blocking for lifecycle writes and planning artifacts. |

## Command-Output Evidence

Future APPLY/UNIFY phases should preserve command output in a reviewer-auditable form:

- Marker greps should show matched lines or enough output to identify the checked file and marker family.
- `bash tests/pi-end-to-end-validation.sh` output should include TAP summary counts and final pass/fail status; Phase 200/201 baseline is 186/186.
- `bash tests/cross-harness-validation.sh` output should include TAP summary counts and final pass/fail status; Phase 200/201 baseline is 100/100.
- GitHub Flow evidence should include current branch, base branch, ahead/behind state, PR URL/state, CI/check state, and merge-gate result during UNIFY.
- Dependency/security audit evidence, when applicable, should include command name, severity counts, baseline comparison, and any override decision.
- Helper delegation evidence, when used, should include the parent-owned task packet, structured helper report, changed-file diff check, fallback decision, and parent-run official verification.
- When validation counts change, SUMMARY should state old count, new count, reason, validation class affected, and shared-invariant preservation rationale.

## Durable Artifact Evidence

| Artifact | Required evidence for future implementation milestones |
|---|---|
| PLAN | Source inputs, validation classes, repo surfaces, protected files, acceptance criteria, module-dispatch evidence, verification commands, fallback triggers, and explicit non-goals. |
| APPLY notes / task results | Per-task status, official verify output, changed-file checks, deviations, retries, fallback decisions, checkpoints, and post-task/post-apply module results. |
| SUMMARY | Acceptance-criteria results, actual changed files, validation output, module reports, git/PR state, helper review results if used, deviations, decisions, and follow-on recommendations. |
| STATE | Current lifecycle position, loop state, decisions, blockers/concerns, git state, and session continuity only after workflow-owned writes. |
| ROADMAP | Phase status, completion notes, next-phase routing, and milestone progress without replacing SUMMARY detail. |
| Historical reports | Freshness label and explicit note that current validation truth comes from command output unless a future approved plan updates reports as part of validation classification. |

## Explicit Deferrals

The first build milestone should not include:

- Workflow/resource capsule implementation.
- Guided workflow behavior changes beyond what is explicitly planned and tested.
- Helper-agent packet/report compression.
- Validation-script weakening, relocation, archiving, or deletion.
- Legacy retention/removal, install-surface cleanup, or support-surface deletion.
- Dependency additions, CI configuration, generated install outputs, or historical report rewrites.
- Hidden Pi lifecycle state, telemetry, Pi-owned validation pass signals, auto-approval, auto-continue, helper-owned APPLY, merge-gate bypass, or lifecycle ledgers.

## Readiness Checklist

Before PALS leaves v2.46 planning and starts a build milestone:

- [ ] The next milestone names exact repo surfaces and protected files.
- [ ] Validation classes are explicit for every changed check or behavior.
- [ ] Acceptance criteria preserve `.paul/*` authority, PLAN/APPLY/UNIFY, module evidence, GitHub Flow gates, parent-owned APPLY, explicit approvals/checkpoints, archive truth, and full-read fallback.
- [ ] Runtime assistance remains derived, bounded, disposable, source-cited, freshness-aware where needed, and backed by full authoritative reads.
- [ ] Guided UI behavior, if touched, creates explicit canonical transcript/artifact evidence and cannot auto-approve, auto-continue, skip checkpoints, or merge.
- [ ] Helper-agent work, if touched, remains parent-packeted, parent-verified, file-scoped, fallback-safe, and forbidden from lifecycle ownership.
- [ ] Validation commands and expected output evidence are named before APPLY begins.
- [ ] Shared invariants remain protected before any parity-only check or frozen legacy surface is weakened.
- [ ] Legacy retention/removal is deferred until validation classification is complete and product approval is explicit.
- [ ] No hidden Pi state, telemetry, UI-only decision, helper-owned APPLY, merge-gate bypass, lifecycle ledger, or Pi-owned validation pass signal is introduced.

## Next Build Handoff

Recommended next action after v2.46 closes: create a new implementation milestone for Artifact-Slice Contract Hardening.

Suggested first build milestone framing:

- **Goal:** Harden the activation-gated artifact-slice contract into a stable Pi-native context-efficiency feature.
- **Primary validation classes:** Runtime Lens, Pi-Supported Runtime, Shared Invariant, Artifact / Process.
- **Likely files:** `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, `tests/pi-end-to-end-validation.sh`.
- **Required verification:** marker checks for slice schema/fallback/no-hidden-state, `bash tests/pi-end-to-end-validation.sh`, `bash tests/cross-harness-validation.sh`, changed-file diff review, and GitHub Flow PR/CI evidence.
- **Protected boundaries:** no `.paul/*` writes from Pi context aids, no hidden persistence, no lifecycle decisions from slices, no full-read replacement for edits or lifecycle writes, no helper-owned APPLY, no auto-approval, and no legacy cleanup.

The second build milestone should likely harden Guided Workflow Evidence unless new evidence during Milestone A shows validation classification must move earlier. Legacy retention/removal should remain last.

## Conclusion

The recommended implementation path is deliberately conservative: harden the proven artifact-slice contract first, then prove guided workflow intent, then introduce workflow/resource capsules, then compress delegated APPLY packets/reports, then classify validation before any legacy retention or cleanup. This order maximizes context-efficiency gains while preserving PALS' artifact-first lifecycle authority, command-backed validation, module evidence, GitHub Flow safety, and parent-owned APPLY.
