# Pi-Native Delegated APPLY Packet/Report Contract

## Status

| Field | Value |
|---|---|
| Milestone | v2.50 Delegated APPLY Packet/Report Contract |
| Phase | 214 — Delegated APPLY Packet/Report Contract Baseline |
| Artifact status | Contract baseline for later runtime, documentation, validation, and evidence reconciliation hardening |
| Implementation status | This document does not change runtime delegation behavior, helper-agent definitions, validation scripts, dependencies, CI, GitHub Flow automation, installed runtime copies, broad validation classification, legacy surfaces, or lifecycle authority |

## Purpose and boundary

This contract defines how parent APPLY may delegate a bounded autonomous task to repo-local `pals-implementer` while keeping lifecycle authority in the parent workflow. Delegation is a context-efficiency aid: it may reduce how much implementation detail the parent must hold while a bounded task is edited, but it cannot replace parent-owned task packets, full plan reads, official verification, module enforcement, file-scope checks, fallback judgment, checkpoints, GitHub Flow gates, command-output truth, or `.paul/*` lifecycle writes.

Phase 214 creates this baseline only. Phase 215 may harden runtime delegation behavior against the baseline; Phase 216 may surface docs and validation markers; Phase 217 may reconcile evidence and close the milestone.

## Source inputs

| Source | Evidence used | Contract implication |
|---|---|---|
| `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` | Delegated APPLY Packet/Report Contract is the fourth Pi-native build milestone and requires Helper Delegation checks, structured reports, parent official verification, file-scope diff checks, and no helper-owned `.paul/*` writes. | This baseline must define packet/report schemas and parent verification before runtime hardening. |
| `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md` | Runtime aids are derived, bounded, source-cited, freshness-aware where needed, and backed by full-read fallback and command-output truth. | Helper packets and reports are derived aids; they are not lifecycle state or validation truth. |
| `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` | Explicit user intent requires transcript/artifact-visible canonical replies and protects no auto-approval, no auto-continue, no skipped checkpoints, no UI-only decisions, and no inferred merge intent. | Delegation must not approve APPLY/UNIFY, satisfy checkpoints, continue lifecycle work, or infer human decisions. |
| `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md` | Orientation aids must expose source, freshness/bounds/fallback, `Derived aid only`, blocking-semantics exclusions, and full authoritative reads before action. | Helper packets and reports may orient execution/review, but full PLAN/workflow reads and command output remain authoritative. |
| `.paul/phases/214-delegated-apply-packet-report-contract-baseline/214-01-PLAN.md` | Phase 214 approved a docs-only contract baseline with packet fields, report fields, allowed/forbidden file scope, fallback triggers, validation classes, and handoffs. | APPLY for this phase must stay within this new contract artifact plus normal lifecycle writes. |

## Settled authority rules

| Rule | Consequence |
|---|---|
| Parent APPLY owns lifecycle execution. | The parent decides whether delegation is eligible, creates the task packet, inspects results, runs official verification, dispatches modules, classifies task status, handles checkpoints, and writes lifecycle artifacts. |
| `pals-implementer` is task-bounded. | A helper receives one bounded task packet at a time and returns a structured report; it does not own the plan, phase, module gates, GitHub Flow, or lifecycle loop. |
| Helper output is review input, not evidence truth. | Reports can summarize work and attempted checks, but current command output from the parent remains validation truth. |
| File scope is explicit. | The packet must list allowed files and forbidden files; parent must compare actual changed files against the packet before accepting a result. |
| Fallback is normal, not failure. | Parent APPLY falls back inline whenever delegation is unavailable, ambiguous, incomplete, outside scope, blocked, or not equivalent to inline execution. |

## Delegation eligibility

Delegation is allowed only when every condition is true:

1. The approved PLAN is autonomous and the selected task is `type="auto"`.
2. The task has clear `<files>`, `<action>`, `<verify>`, and `<done>` fields.
3. The task is a bounded unit the parent can describe, inspect, and verify as equivalent to inline APPLY.
4. No checkpoint, human decision, human action, external approval, merge intent, or ambiguous product choice is required inside the task.
5. All allowed files are repo-local and named in the packet.
6. The task can be reviewed with `git diff`, focused marker checks, and parent-run verification commands.
7. The helper is repo-local `pals-implementer`, enabled by config, and invoked from the parent workflow.
8. Parent APPLY keeps ownership of official verification, module gates, fallback, task status, GitHub Flow, and `.paul/*` writes.

Parent APPLY must stay inline when any condition below is true:

- The task is exploratory, ambiguous, checkpointed, cross-repo, or decision-heavy.
- The task involves `.paul/*` lifecycle writes, STATE/ROADMAP/SUMMARY reconciliation, module result persistence, GitHub Flow gates, CI/review/merge choices, or checkpoint handling.
- The task would require edits outside repo-local allowed files.
- The parent cannot judge the helper result as equivalent to inline APPLY.
- The helper report is missing, malformed, unverifiable, or recommends fallback.

## Parent-owned task packet schema

Every delegated task packet must be assembled and owned by the parent APPLY workflow. The packet should be visible enough for later review and should contain these fields or equivalent labels:

| Field | Required content |
|---|---|
| `packet_id` | Stable identifier such as `{phase}-{plan}-task-{n}`. |
| `plan_path` | Repo-relative approved PLAN path. |
| `task_name` | Exact task name from the PLAN. |
| `objective` | Task-local objective and linked acceptance criteria. |
| `action` | Exact task action content or a bounded excerpt sufficient to execute without guessing. |
| `allowed_files` | Repo-relative files the helper may create or modify. |
| `forbidden_files` | Files and patterns the helper must not touch, including `.paul/*`, installed runtime copies outside the repo, generated install outputs, dependency manifests, CI config, GitHub Flow automation, and any plan-protected files. |
| `context_sources` | Repo-relative files/docs the helper may read, plus required source-contract snippets when needed. |
| `verification_to_attempt` | Task-local checks the helper may run before reporting; these are advisory until parent reruns official verification. |
| `parent_official_verification` | Commands/checks the parent will run after helper returns. |
| `module_caveats` | Any module expectations from pre-apply context that affect the task. |
| `checkpoint_status` | Explicit statement that no checkpoint/human action is delegated, or that the task is ineligible if one is required. |
| `fallback_triggers` | Conditions that require the helper to stop and recommend parent inline fallback. |
| `report_schema` | Required structured helper report fields. |
| `authority_notice` | `Derived aid only`: parent APPLY owns verification, module gates, fallback, task status, checkpoints, GitHub Flow, and `.paul/*` lifecycle writes. |

Minimum marker language for later validation:

```text
Parent-owned task packet
Allowed files:
Forbidden files:
Fallback triggers:
Parent-run official verification:
Authority: Derived aid only; no helper-owned .paul/* lifecycle writes.
```

## Structured helper report schema

A delegated helper result is acceptable only when it returns a structured report with these fields or equivalent labels:

| Field | Required content |
|---|---|
| `status` | `complete`, `blocked`, or `fallback_recommended`. |
| `packet_id` | Echo of parent packet id. |
| `task_name` | Echo of delegated task name. |
| `files_changed` | Repo-relative list of files created/modified. |
| `summary` | Short description of actual work completed. |
| `commands_run` | Commands/checks the helper ran, with pass/fail summaries. |
| `verification_attempted` | Whether helper attempted the packet verification. |
| `verification_results` | Output summary or reason verification could not be completed. |
| `deviations` | Differences from packet action, files, or assumptions. |
| `concerns` | Known risks, uncertainty, untested edge cases, or warnings. |
| `fallback_recommended` | Boolean plus reason when parent inline fallback is safer. |
| `parent_review_required` | Explicit reminder that parent must inspect diff and rerun official verification. |

A report is incomplete when it omits changed files, verification state, fallback recommendation, or concerns. Incomplete reports require parent fallback or additional parent inspection before acceptance.

## Allowed and forbidden file scope

Allowed files must be repo-relative and task-specific. A packet may allow:

- The exact files listed in the PLAN task `<files>` field.
- Newly created repo-local files explicitly named in the packet.
- Narrow supporting files only when the parent adds them to `allowed_files` before dispatch.

Forbidden files and scopes by default:

- `.paul/*` lifecycle artifacts, including STATE, ROADMAP, PROJECT, PLAN, SUMMARY, handoffs, histories, and archives.
- Installed/runtime absolute paths such as `~/.pi/*`, `~/.claude/*`, `~/.carl/*`, or generated install outputs outside the repo.
- Dependency manifests and lockfiles unless explicitly approved for the task.
- CI configuration unless explicitly approved for the task.
- GitHub Flow automation, branch/PR/CI/merge scripts, or git metadata.
- Kernel workflows, module manifests, validation scripts, docs/skill-map surfaces, or runtime source files when a docs-only contract plan does not approve them.
- Any file protected by the PLAN `<boundaries>` section.

Parent APPLY must run a changed-file diff check after helper return:

```bash
git diff --name-only -- {allowed_files}
git diff --name-only
```

If any changed file is outside `allowed_files`, the parent must treat the result as a boundary concern and either revert/repair inline or stop for user guidance. If any task claims completion but no allowed file changed, the parent must not mark the task PASS.

## Full-read fallback triggers

Parent and helper must fall back to full authoritative reads and/or inline parent execution when any of these occur:

- The packet, PLAN, source artifact, or helper report is stale, ambiguous, contested, or missing.
- The helper needs a decision not present in the packet.
- The helper encounters a checkpoint, human verification, human action, approval, or merge-gate question.
- The helper cannot complete verification or cannot explain verification output.
- The helper touches or proposes touching files outside `allowed_files`.
- The helper needs `.paul/*` lifecycle writes, module report persistence, GitHub Flow commands, CI/review/merge decisions, or validation pass/fail classification.
- The helper output conflicts with PLAN boundaries or acceptance criteria.
- The parent cannot judge the result as equivalent to inline APPLY.

Fallback language must be explicit, for example:

```text
Fallback: Full authoritative read of the approved PLAN, current task files, and relevant workflow/reference files is mandatory before parent APPLY accepts this helper result or records task status.
```

## Parent acceptance procedure

After a helper returns, parent APPLY must:

1. Read the structured helper report.
2. Inspect `git diff --name-only` and compare with packet `allowed_files` and PLAN boundaries.
3. Inspect relevant content diffs for the changed files.
4. Rerun the official `<verify>` command from the PLAN in the parent session.
5. Run required post-task and post-apply module hooks from installed `modules.yaml`.
6. Classify the task as `PASS`, `PASS_WITH_CONCERNS`, or `BLOCKED` using parent judgment.
7. Record deviations, fallback decisions, warnings, and verification output for UNIFY.
8. Write `.paul/*` lifecycle artifacts only through the parent workflow.

Helper-attempted commands can inform parent review, but parent-run official verification is required before PASS.

## Validation classes

Phase 215+ plans that implement, surface, or validate this contract must declare applicable validation classes:

| Class | Required when | Blocking posture |
|---|---|---|
| Helper Delegation | `pals-implementer` packet/report creation, delegated APPLY ergonomics, helper summaries, allowed-file checks, fallback decisions, or parent verification review changes. | Blocking: helper work must be parent-packeted, parent-verified, file-scoped, fallback-safe, and forbidden from lifecycle ownership. |
| Shared Invariant | Work could affect `.paul/*` authority, PLAN/APPLY/UNIFY, module evidence, parent-owned APPLY, checkpoints, explicit approvals, GitHub Flow safety, archives, or command-output truth. | Blocking until equivalent command evidence proves invariant preservation. |
| Artifact / Process | PLAN/SUMMARY/STATE/ROADMAP/docs/report/history evidence changes shape lifecycle truth or planning evidence. | Blocking for durable artifacts and lifecycle writes. |
| Pi-Supported Runtime | Pi extension, Pi docs, install surfaces, command routing, context payloads, or runtime hooks change. | Blocking for supported Pi behavior touched by implementation. |
| Runtime Lens | Runtime context injection, bounded helper summaries, status widgets, or generated context surfaces include delegation facts. | Blocking when generated context could be mistaken for authoritative lifecycle or validation state. |
| Guided UI Safety | Delegation appears adjacent to APPLY approvals, checkpoints, continue-to-UNIFY, phase/milestone transitions, or merge-gate prompts. | Blocking for no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent. |
| GitHub Flow Safety | Delegation mentions branch, base, PR, CI, review, merge, cleanup, or status routing. | Blocking for any GitHub Flow automation or surfacing change. |
| Frozen Legacy Parity | Delegation changes touch Claude Code, Agent SDK, portability, cross-driver parity, or legacy install surfaces. | Label before weakening; no legacy cleanup is approved by this contract. |

## Marker-check families for later phases

Future runtime/docs/validation phases should add or preserve marker checks for these families:

| Surface | Marker family |
|---|---|
| `kernel/workflows/apply-phase.md` | Parent-owned task packet; structured helper report; allowed/forbidden files; fallback triggers; parent-run official verification; changed-file diff check; no helper-owned `.paul/*` writes; parent owns module gates and task status. |
| `.pi/agents/pals-implementer.md` / installed agent source | Helper receives bounded packet, edits only allowed repo files, reports structured results, stops on fallback triggers, and cannot write lifecycle artifacts or claim validation/module/GitHub Flow authority. |
| `drivers/pi/extensions/README.md` and `drivers/pi/skill-map.md` | User-facing explanation that delegated APPLY is bounded and parent-authoritative. |
| `tests/pi-end-to-end-validation.sh` | Pi-Supported Runtime and Helper Delegation markers for packet/report schema, fallback, file-scope checks, and parent authority. |
| `tests/cross-harness-validation.sh` | Shared Invariant markers for parent-owned APPLY, module evidence, checkpoint blocking, GitHub Flow safety, `.paul/*` authority, and command-output truth. |
| SUMMARY/STATE/ROADMAP lifecycle artifacts | Durable evidence that helper use, fallback decisions, validation output, changed-file scope, and module reports were reconciled by the parent workflow. |

## Command-output evidence requirements

Future APPLY/UNIFY phases that implement or validate this contract must preserve reviewer-auditable command output:

- Focused marker greps showing parent-owned task packet, structured helper report, allowed/forbidden files, changed-file diff check, fallback triggers, parent-run official verification, and no helper-owned `.paul/*` writes.
- Parent `git diff --name-only` output proving actual changed files stayed inside approved scope.
- Parent-run task verification output; helper-attempted verification is not enough.
- `bash tests/pi-end-to-end-validation.sh` output with TAP summary counts and final pass/fail status when Pi-supported runtime/docs/validation surfaces change.
- `bash tests/cross-harness-validation.sh` output with TAP summary counts and final pass/fail status when shared invariants are affected.
- Module dispatch evidence in PLAN/SUMMARY, including `[dispatch] ...` lines and TODD/WALT outcomes.
- GitHub Flow evidence during UNIFY when enabled: current branch, base branch, PR URL/state, CI/check state, merge-gate result, and cleanup status.
- Count reconciliation when validation totals change: old count, new count, reason, validation class affected, and shared-invariant preservation rationale.

Reports, widgets, context payloads, capsules, slices, helper summaries, and historical reports may explain command evidence, but they cannot replace current command output.

## Failure Conditions

Block, fall back, or re-plan if any of these occur:

- A helper writes, edits, or proposes editing `.paul/*` lifecycle artifacts.
- A helper claims official verification, module gate satisfaction, checkpoint completion, APPLY completion, UNIFY completion, GitHub Flow readiness, PR merge readiness, or validation pass/fail authority.
- A helper touches files outside packet `allowed_files` or outside repo-local scope.
- A helper report omits changed files, verification state, deviations/concerns, or fallback recommendation.
- Parent APPLY does not rerun official verification before marking task PASS.
- Parent APPLY cannot inspect the diff or cannot judge the result equivalent to inline execution.
- Runtime or docs imply helper reports can replace full PLAN reads, workflow reads, module evidence, GitHub Flow command evidence, or validation command output.
- Delegation can auto-approve, auto-continue, skip checkpoints, infer merge intent, or bypass GitHub Flow evidence.
- Hidden helper state, telemetry, local memory, widget state, or a helper transcript becomes lifecycle truth.
- Work broadens into runtime implementation, docs/validation surfacing, broad validation classification, legacy cleanup, dependency additions, CI configuration, GitHub Flow automation, or lifecycle-authority changes without a separately approved plan.

## Explicit Deferrals

Phase 214 and this contract defer:

- Runtime delegation hardening — Phase 215 owns this.
- User-facing docs, Pi docs, helper-agent docs, skill-map surfacing, and validation marker additions — Phase 216 owns this unless Phase 215 explicitly scopes a bounded subset.
- Evidence reconciliation, validation count updates, PR/CI/merge evidence, and milestone closure — Phase 217 owns this.
- Broad Pi-native validation classification.
- Legacy retention/removal, install-surface cleanup, Claude Code or Agent SDK support changes.
- Dependency additions, CI configuration, telemetry, hidden state, helper-owned APPLY, helper-owned `.paul/*` writes, merge-gate automation, workflow semantic rewrites, or lifecycle-authority changes.

## Handoff requirements

### Phase 215 — Runtime Delegation Packet/Report Hardening

Phase 215 should harden repo-source APPLY/helper-agent delegation behavior against this contract without broad redesign:

- Emit or preserve parent-owned task packet markers.
- Require structured helper report markers.
- Enforce allowed/forbidden file scope and changed-file diff checks.
- Fall back inline when reports are incomplete, unverifiable, blocked, outside scope, or not equivalent to inline APPLY.
- Preserve parent-run official verification and module enforcement.
- Preserve no helper-owned `.paul/*` lifecycle writes, no helper-owned validation/module/GitHub Flow authority, and no hidden helper state.

### Phase 216 — Documentation + Validation Surfacing

Phase 216 should make the contract user- and reviewer-visible:

- Update relevant user-facing docs, Pi docs/skill map, helper-agent docs, and validation suites.
- Add marker checks for Helper Delegation, Shared Invariant, Artifact / Process, and any touched Pi-Supported Runtime or GitHub Flow Safety surfaces.
- Keep validation output command-backed and reconcile count changes.
- Avoid broad validation classification, legacy cleanup, dependency/CI changes, GitHub Flow automation, or lifecycle-authority changes.

### Phase 217 — Evidence Reconciliation + Milestone Closure

Phase 217 should reconcile actual v2.50 behavior against this baseline:

- SUMMARY records acceptance-criteria results, actual changed files, validation command output, module reports, GitHub Flow state, helper delegation evidence if used, deviations, decisions, validation count changes, and remaining deferrals.
- STATE/ROADMAP/PROJECT update only through normal lifecycle writes.
- Milestone closure occurs only if delegated APPLY remains parent-packeted, parent-verified, file-scoped, fallback-safe, command-output-backed, and forbidden from lifecycle ownership.

## Acceptance checklist for this contract

- [x] Delegation eligibility and inline fallback conditions are defined.
- [x] Parent-owned task packet schema is defined.
- [x] Structured helper report schema is defined.
- [x] Allowed and forbidden file scope is explicit.
- [x] Full-read fallback triggers and parent acceptance procedure are defined.
- [x] Helper Delegation, Shared Invariant, Artifact / Process, Pi-Supported Runtime, Runtime Lens, Guided UI Safety, GitHub Flow Safety, and Frozen Legacy Parity validation classes are named.
- [x] Marker-check families and command-output evidence requirements are executable for Phase 215+.
- [x] Failure conditions block helper-owned `.paul/*` writes, helper-owned verification/module/GitHub Flow authority, hidden helper state, and command-output replacement.
- [x] Phase 215, Phase 216, and Phase 217 handoff requirements are executable.
