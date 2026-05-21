# PI-NATIVE-GUIDED-WORKFLOW-CANONICAL-REPLY-DELIVERY-EXTRACTION-CONTRACT

**Status:** v2.69 Phase 294 — S4 `guided-workflow-canonical-reply` Pi extension subsystem extracted to `drivers/pi/extensions/guided-workflow-delivery.ts` with bounded validation/docs repointed. Phase 293 produced the docs-only extraction contract; Phase 294 executed the source extraction without moving lifecycle authority, validation truth, GitHub Flow truth, module evidence, or `.paul/*` artifact authority.

**Authority:** Derived aid only. This artifact catalogues the existing S4 surface in `drivers/pi/extensions/pals-hooks.ts` so Phase 294 can preserve transcript-visible guided-workflow reply delivery exactly. It does not change runtime behavior, lifecycle authority, validation truth, GitHub Flow truth, module evidence, or `.paul/*` artifact authority. The `.paul/*` artifacts and parent APPLY remain authoritative for lifecycle decisions; Pi UI and canonical reply delivery remain derived aids that route explicit user choices into normal user-message flow.

## Purpose

PALS is continuing the Pi extension sibling-module extraction wave after S5 (`module-activity-parsing.ts`), S1 (`artifact-slice-rendering.ts`), S2 (`workflow-resource-capsule-rendering.ts`), S3 (`guided-workflow-detection.ts`), S7 (`pals-context-injection.ts`), S6 (`lifecycle-ui.ts`), and S8 (`command-routing.ts`) shipped. S4 is the last non-extracted S* surface and owns canonical guided-workflow reply delivery: explicit Pi confirm/select interaction, display-only auto-presentation config, notify-only behavior, and the single transcript-visible `pi.sendUserMessage` path for guided-workflow canonical responses.

S4 is runtime-coupled because it invokes `pi.sendUserMessage` and uses `ctx.ui.confirm`, `ctx.ui.select`, and `ctx.ui.notify`. Phase 294 must preserve the existing evidence contract: no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, no inferred merge intent, and no hidden lifecycle state. The extraction goal is context offload and source-boundary clarity, not behavioral redesign.

## Evidence Base

- `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` — original S1–S8 inventory. The S4 row names `sendCanonicalWorkflowResponse`, `loadGuidedWorkflowConfig`, and `shouldAutoPresent`, describes S4 as mutating Pi state via `pi.sendUserMessage`, and requires the surface to remain a thin call site under parent control.
- `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` — governing safety contract for guided-workflow evidence, canonical replies, no auto-approval, no auto-continue, checkpoint blocking, no UI-only lifecycle decisions, and no inferred merge intent.
- `docs/PI-NATIVE-GUIDED-WORKFLOW-DETECTION-EXTRACTION-CONTRACT.md` — S3 detection contract precedent. S3 detection moved to `guided-workflow-detection.ts`; S4 delivery intentionally stayed inline.
- `docs/PI-NATIVE-PALS-CONTEXT-INJECTION-EXTRACTION-CONTRACT.md` — S7 contract precedent for exact marker preservation, loader-compat no-op factory, and source-shape handoff.
- `docs/PI-NATIVE-LIFECYCLE-UI-EXTRACTION-CONTRACT.md` — S6 runtime-coupled extraction precedent for UI mutation while preserving no-UI-only-lifecycle-decisions.
- `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md` — S8 runtime-coupled extraction precedent for command-delivered `pi.sendUserMessage` while preserving S4 separation.
- `drivers/pi/extensions/pals-hooks.ts` — runtime registration/orchestration entry point. Phase 294 moved the S4 delivery/config surface out of this file and left existing call sites delegated to `guided-workflow-delivery.ts`.
- `drivers/pi/extensions/guided-workflow-detection.ts` — current S3 sibling that produces `GuidedWorkflowMoment`; Phase 294 must keep detection separate from delivery.
- `tests/pi-end-to-end-validation.sh` — existing guardrails already assert S4 identifiers, confirm/select delivery, no-auto markers, and S3/S4 separation.

## S4 Subsystem Boundary

### Owned functions

The following top-level functions currently live in `drivers/pi/extensions/pals-hooks.ts` and define the S4 delivery surface:

- `sendCanonicalWorkflowResponse(pi: any, ctx: any, canonicalResponse?: string): void` — normalizes the canonical response with `compactWhitespace`; returns early for empty responses; sends through `pi.sendUserMessage(response, { deliverAs: "followUp" })` when `ctx.isIdle() === false`; otherwise sends through `pi.sendUserMessage(response)`. This is the only guided-workflow canonical reply send path.
- `presentGuidedWorkflowMoment(moment: GuidedWorkflowMoment, ctx: any, pi: any, config?: GuidedWorkflowConfig): Promise<void>` — displays guided workflow moments through Pi UI; respects display-only auto-presentation config; never treats UI display as lifecycle truth; invokes `sendCanonicalWorkflowResponse` only after explicit confirm/select mapping to a known canonical response.
- `loadGuidedWorkflowConfig(cwd: string): GuidedWorkflowConfig` — reads `pals.json` / `.paul/pals.json` guided-workflow display configuration and maps booleans into defaults. The config controls only display behavior.
- `shouldAutoPresent(config: GuidedWorkflowConfig, momentKind: GuidedWorkflowMoment["kind"]): boolean` — maps hyphenated moment kinds to underscored display-config keys and returns display eligibility. This is not lifecycle state.

### Owned types and constants

- `type GuidedWorkflowAutoPresent` — display-only boolean map for plan review, apply approval, continue-to-unify, checkpoint, resume, and merge-gate moment kinds.
- `type GuidedWorkflowConfig` — wrapper for `auto_present` display configuration.
- `GUIDED_WORKFLOW_DEFAULTS` — default display behavior for guided workflow moments.

Phase 294 may move these S4-owned types/constants into the new sibling if doing so keeps imports minimal and preserves byte-equivalent behavior. If a type remains needed by `pals-hooks.ts`, use a type-only import/export pattern.

### Runtime mutation and UI rule

S4 uses Pi runtime surfaces only for derived assistance:

- `ctx.ui.notify` may display information, success, or warning messages.
- `ctx.ui.confirm` may ask whether to send a known canonical response.
- `ctx.ui.select` may ask the user to choose one displayed canonical option.
- `pi.sendUserMessage` may send only the known canonical response selected from `GuidedWorkflowMoment.confirmResponse` or `GuidedWorkflowMoment.options[].canonicalResponse`.

Arbitrary UI text is ignored. Notify-only mode never sends a canonical reply. `guided_workflow.auto_present` changes only whether Pi displays an affordance; disabling it never approves, continues, completes checkpoints, records validation, creates lifecycle state, or infers merge intent.

## Shared-Helper and Sibling Disposition

Phase 294 SHOULD create a new sibling Pi extension module named:

- `drivers/pi/extensions/guided-workflow-delivery.ts`

The sibling SHOULD import only what it uses:

- value import `compactWhitespace` and `readFileOr` from `./pals-hooks` if the moved code continues to call them;
- type import `GuidedWorkflowMoment` from `./guided-workflow-detection` if needed;
- avoid importing S3 parsing helpers or any unrelated S1/S2/S5/S6/S7/S8 symbols.

`pals-hooks.ts` remains the runtime registration/orchestration entry point. It must import the moved S4 surface from `./guided-workflow-delivery` and call it from the same existing hook locations. Phase 294 must not move CARL session-boundary helpers, command registration, context injection, lifecycle UI, module activity parsing, artifact slices, workflow capsules, or guided-workflow detection into the S4 sibling.

## Allowed Phase 294 Extraction Shape

Phase 294 may perform only the following source changes:

1. Create `drivers/pi/extensions/guided-workflow-delivery.ts` as a sibling Pi extension module.
2. Move `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`, `GuidedWorkflowAutoPresent`, `GuidedWorkflowConfig`, and `GUIDED_WORKFLOW_DEFAULTS` into that sibling when needed.
3. Export the moved S4 functions and any moved types/constants required by `pals-hooks.ts`.
4. Replace inline definitions in `pals-hooks.ts` with imports from `./guided-workflow-delivery`.
5. Preserve every existing S4 call site in `pals-hooks.ts` functionally identical, including the hook path that calls `loadGuidedWorkflowConfig`, `detectGuidedWorkflowMoment`, and `presentGuidedWorkflowMoment`.
6. Preserve the `sendCanonicalWorkflowResponse` delivery semantics exactly, including `deliverAs: "followUp"` when `ctx.isIdle() === false`.
7. Preserve confirm/select behavior exactly: only explicit confirm/select choices mapped to known canonical responses may send a reply.
8. End the new sibling with a default-exported no-op Pi extension factory preceded by a JSDoc comment carrying the literal phrase `No-op Pi extension factory`.
9. Update `drivers/pi/install.sh` only if needed to install the new sibling; expected install surface after Phase 294 is one additional Pi extension file.
10. Repoint existing validation guardrails from `pals-hooks.ts` to the new sibling only where ownership moved; keep S3/S4 separation checks visible.

## Forbidden Scope

Phase 294 MUST NOT:

- Change canonical response strings, option ids, checkpoint behavior, merge-gate routing, or guided-workflow detection semantics.
- Modify or extract S3 detection (`guided-workflow-detection.ts`) beyond type imports required by the S4 sibling.
- Modify or re-extract S5/S1/S2/S7/S6/S8 siblings.
- Modify command routing, `/paul-*` commands, shortcut bindings, or command-delivered `pi.sendUserMessage` behavior.
- Modify lifecycle UI state, CARL session-boundary behavior, context injection payloads, artifact slices, workflow resource capsules, or module activity parsing.
- Add telemetry, analytics, hidden runtime state, caches, generated ledgers, or alternate lifecycle/module/validation/GitHub Flow truth.
- Add auto-approval, auto-continue, skipped checkpoints, UI-only lifecycle decisions, inferred merge intent, or a merge-anyway path.
- Write `.paul/*` lifecycle artifacts from the Pi runtime or the new sibling.
- Edit installed runtime copies under `~/.pi/agent/extensions/` or `~/.pi/agent/skills/`.
- Touch dependency manifests, lockfiles, CI configuration, Dockerfiles, Claude Code driver, Agent SDK driver, kernel workflow sources, module registry files, or unrelated tests.

## Phase 294 Handoff

Phase 294 must satisfy the following before declaring APPLY complete.

### Marker and function preservation checks

- `grep` proves `guided-workflow-delivery.ts` exists and exports `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, and `shouldAutoPresent`.
- `grep` proves `pals-hooks.ts` imports those S4 functions from `./guided-workflow-delivery` and no longer defines them inline.
- `grep` proves `pi.sendUserMessage`, `deliverAs: "followUp"`, `ctx.ui.confirm`, `ctx.ui.select`, `notify-only mode never sends a canonical reply`, `no auto-approval`, `no auto-continue`, `no skipped checkpoints`, `no UI-only lifecycle decisions`, and `no inferred merge intent` remain visible in the appropriate source or validation surfaces.
- `grep` proves S3 detection (`detectGuidedWorkflowMoment`, `GuidedWorkflowMoment`, and S3 parsing helpers) remains in `guided-workflow-detection.ts` and is not redefined in the S4 sibling.
- `grep` proves S8 command routing still owns command activation and `/paul-*` → `/skill:paul-*` routing separately from S4 guided-workflow replies.

### Install verification

- `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports one additional Pi extension file compared with the Phase 293 baseline. The exact `[ok] Pi extensions installed: N files` line must be copied into the SUMMARY from fresh output.

### Validation

- `bash tests/pi-end-to-end-validation.sh` passes. Any TAP count change must be reconciled from command output in the SUMMARY.
- `bash tests/cross-harness-validation.sh` passes. Any TAP count change must be reconciled from command output in the SUMMARY.
- `bash tests/helpers/artifact_consistency.sh` returns `artifact_consistency_check: PASS`.
- `git diff --check` returns clean.

### GitHub Flow evidence

- Phase 294 work happens on a non-base feature branch.
- After successful APPLY, the branch is pushed and a PR is opened or reused according to `pals.json` GitHub Flow settings.
- CI status is recorded in the SUMMARY; UNIFY owns merge readiness.

### Summary count reconciliation discipline

All TAP counts and install file counts in the Phase 294 SUMMARY must be copied from fresh command output, not from this contract or prior documents. If validation counts differ from the expected baseline, the SUMMARY must explain the delta from command output before UNIFY proceeds.

## Acceptance Checklist

- [ ] `drivers/pi/extensions/guided-workflow-delivery.ts` exists, exports the S4 delivery/config functions, and ends with the loader-compatible `No-op Pi extension factory` marker.
- [ ] `drivers/pi/extensions/pals-hooks.ts` imports the moved S4 surface and preserves existing S4 invocation flow.
- [ ] `sendCanonicalWorkflowResponse` behavior is byte-equivalent, including follow-up delivery for non-idle contexts.
- [ ] `presentGuidedWorkflowMoment` behavior preserves display-only config, notify-only no-send behavior, confirm/select explicit user choice, and known-option canonical response mapping.
- [ ] No S3/S5/S1/S2/S7/S6/S8 sibling is re-extracted or behaviorally modified.
- [ ] No auto-approval, auto-continue, skipped checkpoint, UI-only lifecycle decision, inferred merge intent, hidden state, telemetry, or `.paul/*` runtime write is introduced.
- [ ] Install, Pi e2e, cross-harness, artifact-consistency, and `git diff --check` evidence is copied from fresh command output.
- [ ] PR/CI status is recorded under GitHub Flow after APPLY.

## Status After Phase 294

Phase 294 implemented the contract: `drivers/pi/extensions/guided-workflow-delivery.ts` now owns `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`, `GuidedWorkflowAutoPresent`, `GuidedWorkflowConfig`, and `GUIDED_WORKFLOW_DEFAULTS`. The sibling imports only `compactWhitespace` / `readFileOr` from `./pals-hooks`, `join` from `path`, and `GuidedWorkflowMoment` as a type from `./guided-workflow-detection`, then ends with the loader-compatible `No-op Pi extension factory` marker.

`drivers/pi/extensions/pals-hooks.ts` remains the runtime orchestration entry point and imports S4 delivery/config from `./guided-workflow-delivery`. S3 detection remains in `guided-workflow-detection.ts`; S5/S1/S2/S7/S6/S8 siblings remain separate; no command routing, lifecycle UI, context injection, CARL, artifact slicing, workflow capsules, module parsing, `.paul/*` lifecycle authority, telemetry, hidden state, auto-approval, auto-continue, skipped checkpoints, UI-only lifecycle decisions, or inferred merge intent moved into S4.

Validation and docs were repointed to the new S4 owner: Pi e2e guardrails assert `guided-workflow-delivery.ts` exports the moved S4 surface, contains the canonical reply/no-auto markers, keeps follow-up delivery and confirm/select explicit-choice behavior visible, and verifies `pals-hooks.ts` imports from the sibling without inline S4 definitions. `drivers/pi/extensions/README.md` and `drivers/pi/skill-map.md` now list `guided-workflow-delivery.ts` as the Phase 294 S4 owner and part of the Pi extension source set.
## Status After Phase 293

This contract was final for Phase 293. It authorized no source changes by itself; it defined the boundary Phase 294 executed after Phase 293 UNIFY closed and Phase 294 received its own approved PLAN.
