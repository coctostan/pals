# Pi-Native Guided Workflow Evidence Contract

## Status

| Field | Value |
|---|---|
| Milestone | v2.48 Guided Workflow Evidence Hardening |
| Phase | 206 — Guided Workflow Evidence Contract Baseline |
| Artifact status | Contract baseline for later runtime, docs, and validation hardening |
| Implementation status | This document does not change runtime behavior, validation scripts, dependencies, CI, workflow/resource capsules, delegated APPLY packet/report compression, validation classification, legacy cleanup, or lifecycle authority |

## Purpose and boundary

This contract defines how Pi guided workflow assistance must prove explicit user intent. Pi may reduce friction around already-emitted PALS workflow prompts, but every lifecycle decision must remain visible as a canonical reply in the normal transcript and/or as durable workflow artifact evidence.

Phase 206 is planning-only. It creates the evidence baseline that later v2.48 phases should implement and validate. It is not proof that runtime guided workflow behavior is newly hardened.

## Source inputs

| Source | Evidence used | Contract implication |
|---|---|---|
| `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` | Candidate build order names Guided Workflow Evidence Hardening second, requires explicit canonical transcript replies, names Guided UI Safety / GitHub Flow Safety / Shared Invariant / Artifact / Process classes, and preserves command-output validation truth. | Guided workflow hardening must be separate from broader capsules, helper compression, validation classification, and legacy cleanup. |
| `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md` | Guided Workflow Evidence Hardening is a guardrail-only workstream focused on transcript-visible canonical replies, no-auto-continue proof, and evidence mapping from UI actions to transcript/artifact outcomes. | The contract must inventory moments, replies, expected evidence, and open runtime-validation handoffs. |
| `docs/PI-NATIVE-VALIDATION-EVIDENCE-STRATEGY.md` | Guided Workflow Evidence Hardening requires structural checks for canonical replies/no-auto-continue, Pi validation, green cross-harness validation, transcript-visible evidence, and no UI-only decision proof. | Later phases must add command-backed marker checks and preserve fresh TAP output as validation truth. |
| `docs/PI-RUNTIME-CAPABILITY-MAP.md` | Guided workflow UX is `guardrail-only`; Pi detects plan review, APPLY approval, checkpoints, resume-next, and continue-to-UNIFY, then may send canonical user replies. | UI assistance can route explicit replies but cannot own lifecycle decisions or state. |
| `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Pi is the supported runtime, but `.paul/*`, PLAN/APPLY/UNIFY, module evidence, git/PR evidence, and validation command output remain authoritative. Auto-approval, auto-continue, merge-gate bypass, helper-owned APPLY, and hidden Pi lifecycle state are rejected. | Guided UI evidence must strengthen auditability without creating a Pi-owned control plane. |
| `.paul/phases/205-validation-evidence-reconciliation/205-01-SUMMARY.md` | v2.47 closed with Pi validation 188/188 and cross-harness validation 104/104; guided workflow evidence hardening is the next recommended Pi-native build milestone. | Phase 206 starts from current green validation and should not regress or rewrite it. |
| `drivers/pi/extensions/pals-hooks.ts` | Current runtime types include `plan-review`, `apply-approval`, `checkpoint-decision`, `checkpoint-human-verify`, `checkpoint-human-action`, `resume-next`, `phase-transition`, `milestone-transition`, and `continue-to-unify`; `presentGuidedWorkflowMoment` routes selected/confirmed canonical replies through `sendCanonicalWorkflowResponse`. | Later runtime hardening should preserve explicit send paths and add proof around no-auto/no-UI-only behavior. |
| `drivers/pi/extensions/README.md` and `drivers/pi/skill-map.md` | User-facing docs already state guided workflow UX is additive, sends exact canonical replies through normal user-message flow, and never auto-continues, skips checkpoints, or stores Pi-owned workflow state. | Docs and skill-map surfacing must keep this contract discoverable and aligned with runtime behavior. |
| `pals.json` | `guided_workflow.auto_present` controls whether each moment uses auto-present UI or notify-only mode. | Config toggles display behavior only; it cannot change lifecycle authority or skip canonical replies. |

## Guided workflow moment inventory

| Moment | Shared prompt marker / trigger | Allowed Pi UI mode | Canonical reply values | Required evidence |
|---|---|---|---|---|
| plan review | `Would you like to see the plan?` or review prompt containing `Quick recap`, `Detailed recap`, `Full plan`, `No review needed` | `select` when options are present; otherwise notify-only | `1`, `2`, `3`, `4` matching the visible review menu | Transcript-visible numeric reply; PLAN artifact remains the authoritative plan; no review choice is treated as APPLY approval. |
| APPLY approval | `Continue to APPLY?` | `select` | `approved` for approval, `2` for questions first, `3` for pause here | Transcript-visible `approved` before APPLY starts; STATE/PLAN must still show PLAN complete and APPLY pending until workflow execution proceeds. |
| checkpoint decision | `CHECKPOINT: Decision Required` | `select` if workflow options are parsed; otherwise notify-only | Exact option ids emitted by the checkpoint prompt | Transcript-visible selected option; if the choice changes lifecycle semantics, the workflow records the decision in `.paul/STATE.md` and later SUMMARY. |
| checkpoint human verification | `CHECKPOINT: Human Verification` | `confirm` | `approved` only after the human has verified | Transcript-visible `approved`; APPLY notes/SUMMARY record verification result. Pi confirm state alone is not evidence. |
| checkpoint human action | `CHECKPOINT: Human Action Required` | `confirm` only when the prompt exposes an explicit canonical resume response; otherwise notify-only | Prompt-detected canonical response after the required human action is complete | Transcript-visible resume response plus parent workflow verification; Pi must not claim the action was done. |
| resume-next | Resume/status prompt containing `▶ NEXT:` and `Type "yes" to proceed` | `confirm` | `yes` | Transcript-visible `yes`; `.paul/STATE.md` remains the routing authority; consumed handoffs are archived by workflow lifecycle rules, not by hidden Pi state. |
| continue-to-UNIFY | `Continue to UNIFY?` while loop is not already complete | `select` | `1` for yes/run UNIFY, `2` for pause here | Transcript-visible numeric reply; APPLY must already be complete in workflow artifacts before UNIFY starts. |
| phase transition | `PHASE N COMPLETE` with explicit options | `select` when options exist; otherwise notify-only | Exact option ids emitted by the transition prompt | Transcript-visible option; ROADMAP/STATE transition remains workflow-owned. |
| milestone transition | `MILESTONE COMPLETE` plus `What's next?` | `select` when options exist; otherwise notify-only | Exact option ids emitted by the milestone prompt | Transcript-visible option; milestone creation/completion artifacts remain workflow-owned. |
| merge-gate routing handoff | Resume/status/UNIFY output that surfaces branch, base, PR, CI, review, or merge-gate route | notify-only or `select` only when the shared workflow emits explicit options | `yes` or exact option id only when the prompt names a concrete next command; never implicit merge intent | Transcript-visible route choice plus GitHub Flow command evidence (`git`, `gh pr view/checks/merge`, PR URL/state, CI state). Pi UI must not merge, bypass CI, or infer approval. |

## Canonical reply schema

Every guided workflow reply must be explainable with this schema:

| Field | Requirement |
|---|---|
| `moment` | One of the named guided workflow moments above. |
| `source_marker` | The stable prompt text or workflow marker that made the moment eligible. |
| `ui_mode` | `notify`, `confirm`, or `select`; notify-only mode never sends a reply. |
| `canonical_reply` | The exact string the shared workflow already accepts, such as `yes`, `approved`, `1`, another numbered option, an option id, or an explicit checkpoint resume token. |
| `delivery` | Normal transcript-visible user-message flow via the Pi runtime, including follow-up delivery only when the parent context is already busy. |
| `artifact_evidence` | PLAN, APPLY notes, SUMMARY, STATE, ROADMAP, module dispatch reports, validation command output, or GitHub Flow command output as appropriate. |
| `non_authority_note` | UI state, notifications, widgets, and runtime memory are not lifecycle truth. |

Canonical reply rules:

- `yes` means proceed only when the shared prompt explicitly says `Type "yes" to proceed` or equivalent.
- `approved` means approval only for an APPLY approval or human-verification prompt that explicitly accepts `approved`.
- `1`, `2`, `3`, `4`, or other option ids mean only the visible option text from the current prompt.
- Pause, stop, questions-first, or non-continuation choices are still canonical replies, but they are not approvals and must not continue the lifecycle unless the shared workflow says so.
- UI success notifications are useful feedback, not evidence. The evidence is the canonical user message plus workflow artifacts/command output.

## Explicit intent boundaries

These are non-negotiable for v2.48 and later guided workflow work:

- no auto-approval: Pi must not approve PLAN, APPLY, checkpoints, reviews, merges, or validation on its own.
- no auto-continue: Pi must not continue to APPLY, continue-to-UNIFY, phase transition, milestone transition, or next-route execution without a transcript-visible canonical user reply.
- no skipped checkpoints: checkpoint decision, checkpoint human verification, and checkpoint human action prompts remain blocking until the shared workflow receives a valid reply.
- no UI-only lifecycle decisions: a clicked confirm/select result is not sufficient unless Pi sends the canonical reply through normal user-message flow and the workflow processes it.
- no inferred merge intent: branch/PR/CI status surfaces may route the user, but merge intent must be explicit and GitHub Flow command evidence remains required.
- no hidden Pi state: runtime memory, widgets, notifications, context payloads, or helper transcripts cannot replace `.paul/*` artifacts.
- no Pi-owned lifecycle/module/validation ledger: installed `modules.yaml`, `[dispatch] ...` lines, Module Execution Reports, SUMMARY/STATE, GitHub Flow evidence, and validation command output remain authoritative.
- no replacement of `.paul/*`, PLAN/APPLY/UNIFY, parent-owned APPLY, module dispatch, GitHub Flow gates, or command-output validation truth.

## Validation classes for later phases

| Validation class | When required for guided workflow evidence | Example command-backed evidence |
|---|---|---|
| Guided UI Safety | Any guided workflow, approval, checkpoint, continue-to-UNIFY, pause/stop, phase/milestone transition, or merge-route UI path. | Marker checks for canonical replies, explicit user action, no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, no merge-gate bypass. |
| Pi-Supported Runtime | Changes to `drivers/pi/extensions/pals-hooks.ts`, Pi docs, install surfaces, command routing, or guided workflow config. | Pi validation output showing current TAP pass counts and matched runtime markers. |
| Shared Invariant | Any change that could affect PLAN/APPLY/UNIFY, `.paul/*` authority, module evidence, checkpoints, parent APPLY, or GitHub Flow safety. | Cross-harness validation remains green for shared approval/checkpoint/module/git invariants. |
| GitHub Flow Safety | Any guided route that references branch, base, PR, CI, review, merge, or cleanup state. | `git branch`, ahead/behind counts, `gh pr view`, `gh pr checks`, merge-gate output, PR URL/state, and CI state. |
| Runtime Lens | Any context injection/status/widget surfacing adjacent to guided moments. | Source citations, freshness/bounds markers, full-read fallback, and no hidden persistence checks. |
| Artifact / Process | PLAN/SUMMARY/STATE/ROADMAP/report/history evidence for guided decisions. | PLAN names moments/reply schema; SUMMARY records transcript-visible evidence, checkpoint/approval behavior, changed files, validation output, module reports, and deviations. |

## Marker-check families for Phase 207+

Later phases should add or preserve marker checks in these families:

- `drivers/pi/extensions/pals-hooks.ts`
  - guided moment kinds: `plan-review`, `apply-approval`, `checkpoint-decision`, `checkpoint-human-verify`, `checkpoint-human-action`, `resume-next`, `continue-to-unify`, `phase-transition`, `milestone-transition`.
  - canonical send path: `sendCanonicalWorkflowResponse`, `pi.sendUserMessage`, `deliverAs: "followUp"`.
  - no-auto behavior: UI prompts must require explicit confirm/select results; notify-only mode must not send a reply.
  - merge-gate safety: no direct merge command, no PR merge shortcut, no CI bypass from guided UI.
- `drivers/pi/extensions/README.md`
  - guided workflow UX is additive only.
  - exact canonical replies are sent through normal user-message flow.
  - never auto-continues, never skips checkpoints, never stores Pi-owned workflow state.
- `drivers/pi/skill-map.md`
  - Pi guided workflow UX may surface review menus but sends canonical replies through normal message flow.
  - full authoritative reads remain required before approved PLAN execution, lifecycle writes, decisions, GitHub Flow gates, validation pass/fail, APPLY completion, and UNIFY completion.
- `pals.json`
  - `guided_workflow.auto_present` keys are display toggles only: `plan_review`, `apply_approval`, `continue_to_unify`, `checkpoint_decision`, `checkpoint_human_verify`, `checkpoint_human_action`, `resume_next`, `phase_transition`, `milestone_transition`.
- `tests/pi-end-to-end-validation.sh`
  - Pi-supported runtime markers for guided workflow detection and canonical replies.
  - Guided UI Safety markers for no auto-approval, no auto-continue, checkpoint blocking, and no UI-only decisions.
- `tests/cross-harness-validation.sh`
  - Shared Invariant markers for explicit approval/checkpoint semantics, parent-owned APPLY, module evidence, GitHub Flow safety, and command-output validation truth.

## Command-output evidence requirements

A future APPLY/UNIFY that changes guided workflow behavior must preserve command output a reviewer can audit:

- Focused marker greps must print matched lines or enough context to identify the file and marker family.
- `bash tests/pi-end-to-end-validation.sh` must show TAP summary counts and final pass/fail status. The Phase 205/Phase 206 starting baseline is Pi 188/188.
- `bash tests/cross-harness-validation.sh` must show TAP summary counts and final pass/fail status. The Phase 205/Phase 206 starting baseline is cross-harness 104/104.
- If validation counts change, SUMMARY must state old count, new count, reason, validation class affected, and shared-invariant preservation rationale.
- GitHub Flow evidence must include current branch, base branch, ahead/behind status, PR URL/state when applicable, CI/check state, and merge-gate result during UNIFY.
- Reports, widgets, notifications, slices, or helper summaries may explain evidence, but they cannot replace fresh command output.

## Failure Conditions

Block or fail later guided workflow hardening if any of the following occurs:

- UI state alone records approval, checkpoint decision, pause/stop, phase transition, milestone transition, APPLY completion, UNIFY completion, or merge intent.
- A guided prompt can auto-approve, auto-continue, skip a checkpoint, infer merge intent, or bypass GitHub Flow evidence.
- A canonical reply is not transcript-visible in normal user-message flow.
- A checkpoint human-action or human-verification prompt can continue before the human action/verification is complete.
- Pi writes hidden lifecycle state, a module ledger, validation pass/fail state, or a local memory/cache that acts as truth.
- Runtime assistance replaces `.paul/*`, PLAN/APPLY/UNIFY, installed `modules.yaml`, GitHub Flow command evidence, or validation command output.
- Validation scripts, dependencies, CI, workflow/resource capsules, delegated APPLY packet/report compression, broad validation classification, legacy cleanup, or lifecycle authority are changed in a phase that did not explicitly approve them.
- Fresh Pi and cross-harness validation are missing, failing, or summarized without command output.

## Explicit deferrals

The following work remains out of Phase 206 and must stay separately planned:

- Runtime guided workflow behavior changes — Phase 207 owns this.
- User-facing docs/skill-map surfacing and validation marker additions — Phase 208 owns this unless Phase 207 explicitly includes a bounded subset.
- Evidence reconciliation, count updates, and milestone closure — Phase 209 owns this.
- workflow/resource capsules.
- delegated APPLY packet/report compression.
- broad Pi-native validation classification.
- legacy retention, install-surface cleanup, Claude Code or Agent SDK support changes.
- dependency additions, CI configuration, telemetry, hidden state, helper-owned APPLY, or merge-gate automation.

## Handoff requirements

### Phase 207 — Runtime Guided Reply Hardening

Phase 207 should use this contract to harden `drivers/pi/extensions/pals-hooks.ts` without broad redesign:

- Preserve the named moment inventory and add any missing route only through an explicit prompt marker and canonical reply schema.
- Prove confirm/select UI cannot send replies without explicit user action.
- Prove notify-only mode never sends a canonical reply.
- Prove checkpoint human verification and human action remain blocking.
- Prove merge-gate routing cannot infer merge intent or execute GitHub Flow commands from UI state.
- Keep runtime assistance derived-only; no `.paul/*` writes, hidden persistence, telemetry, or Pi-owned ledgers.

### Phase 208 — Documentation + Validation Surfacing

Phase 208 should make the contract user- and reviewer-visible:

- Update Pi docs and skill-map surfaces to describe the canonical reply contract.
- Add marker checks for Guided UI Safety, Pi-Supported Runtime, Shared Invariant, GitHub Flow Safety, Runtime Lens, and Artifact / Process where applicable.
- Keep validation output command-backed and reconcile any count changes.
- Avoid turning this docs/validation surfacing phase into workflow/resource capsules, delegated APPLY compression, broad validation classification, or legacy cleanup.

### Phase 209 — Evidence Reconciliation + Milestone Closure

Phase 209 should reconcile actual v2.48 behavior against this baseline:

- SUMMARY records acceptance-criteria results, actual changed files, validation command output, module reports, GitHub Flow state, decisions, deviations, and remaining deferrals.
- STATE/ROADMAP/PROJECT update only through normal lifecycle writes.
- The milestone closes only if explicit user intent remains protected: no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent.

## Acceptance checklist for this contract

- [x] Guided workflow moments are inventoried.
- [x] canonical reply values and transcript evidence expectations are defined.
- [x] no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent are contractually protected.
- [x] Guided UI Safety, Pi-Supported Runtime, Shared Invariant, GitHub Flow Safety, Runtime Lens, and Artifact / Process validation classes are named.
- [x] Phase 207, Phase 208, and Phase 209 handoff requirements are executable.
- [x] workflow/resource capsules, delegated APPLY packet/report compression, broad validation classification, legacy cleanup, dependencies, CI, runtime behavior changes, and lifecycle-authority changes remain deferred outside approved scope.
