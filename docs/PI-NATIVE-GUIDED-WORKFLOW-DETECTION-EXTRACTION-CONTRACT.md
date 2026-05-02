# Pi-Native Guided Workflow Detection Extraction Contract

**Phase:** 249 S3 Extraction Contract + Bounded Submodule Plan  
**Plan:** 249-01  
**Status:** Phase 250 extraction completed; Phase 251 docs/validation surfacing active. This document remains a derived aid only; no runtime/source/install/dependency/CI/lifecycle-authority changes are authorized by this surfacing update.

## Purpose

This contract defines the extraction boundary for S3 `guided-workflow-detection` from `drivers/pi/extensions/pals-hooks.ts` into the dedicated sibling Pi extension module `drivers/pi/extensions/guided-workflow-detection.ts`. Phase 249 created the docs-only contract and handoff; Phase 250 completed the source extraction while retaining S4 canonical reply delivery in `pals-hooks.ts`.

This document is a **derived aid only**. It does not modify runtime behavior, validation truth, module truth, GitHub Flow truth, or `.paul/*` lifecycle authority. Shared `.paul/*` artifacts, approved PLAN/APPLY/UNIFY artifacts, module reports, GitHub Flow command evidence, and validation command output remain authoritative.

## Evidence Base

- `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md` — current S1/S2/S5 extraction state, S3 conditional-secondary classification, and deferred S4/S6/S7/S8 posture.
- `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` — original S1–S8 inventory; S3 cited identifiers; sibling-module pattern ratified across S5+S1+S2.
- `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` — governing safety contract for canonical replies, no auto-approval, no auto-continue, checkpoint blocking, and merge-gate routing.
- `drivers/pi/extensions/pals-hooks.ts` — supported Pi runtime entry source; after Phase 250 it imports S3 detection from `guided-workflow-detection.ts` while retaining S4 canonical reply delivery.
- `drivers/pi/extensions/artifact-slice-rendering.ts` — S1 sibling-module precedent: module-level contract header, single-defined markers/constants, helper imports from `./pals-hooks`, no-op default extension factory.
- `drivers/pi/extensions/workflow-resource-capsule-rendering.ts` — S2 sibling-module precedent: same shape as S1, triple-confirmed pattern.
- `drivers/pi/extensions/guided-workflow-detection.ts` — Phase 250 S3 sibling module; owns detection/option parsing/merge-gate routing detection and preserves loader compatibility.

## S3 Subsystem Boundary

The following identifiers in `drivers/pi/extensions/pals-hooks.ts` define the S3 `guided-workflow-detection` subsystem. Phase 250 must preserve every named identifier through explicit import or single-defined re-export.

### Functions

- `detectGuidedWorkflowMoment`
- `parseGuidedWorkflowOptions`
- `detectExplicitCanonicalResponse`
- `isMergeGateRoutingPrompt`
- `extractMergeGateRoutingSummary`
- `makeGuidedWorkflowSignature`
- `summarizeWorkflowPrompt`
- `extractNextActionSummary`
- `isValidOptionId`

### Constants / Markers

- `GUIDED_WORKFLOW_LOOKBACK`
- `GUIDED_WORKFLOW_SIGNATURE_BYTES`

### Behavioral scope owned by S3

- Guided workflow moment detection (plan-review, apply-approval, checkpoint-decision, checkpoint-human-verify, checkpoint-human-action, resume-next, continue-to-unify, phase-transition, milestone-transition, merge-gate-routing).
- Option parsing semantics for parsed workflow prompts.
- Canonical-response detection (`detectExplicitCanonicalResponse`).
- Merge-gate routing detection (`isMergeGateRoutingPrompt`, `extractMergeGateRoutingSummary`).
- Duplicate-guidance signature generation (`makeGuidedWorkflowSignature`).
- Prompt summarization and next-action extraction (`summarizeWorkflowPrompt`, `extractNextActionSummary`).
- Option-id validation (`isValidOptionId`).

## Governing Safety Contract

S3 extraction **must** preserve every invariant in `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`:

- Transcript-visible canonical replies.
- No auto-approval.
- No auto-continue.
- No skipped checkpoints.
- No UI-only lifecycle decisions.
- No inferred merge intent.
- `.paul/*` authority remains workflow-owned.
- Module evidence, GitHub Flow evidence, and command-output validation truth remain authoritative.

The `guided_workflow.auto_present` config keys are display toggles only; extraction must not change that semantics.

## Allowed Phase 250 Extraction Shape

Phase 250 may extract S3 into a sibling module matching the ratified pattern:

- **New file:** `drivers/pi/extensions/guided-workflow-detection.ts` (or a sibling-equivalent name under `drivers/pi/extensions/`).
- **Module header:** JSDoc contract header citing this contract, the governing evidence contract, the Phase 250 plan, and `Authority: Derived aid only`.
- **Helper imports:** Explicit imports from `./pals-hooks` only where needed (e.g., `compactWhitespace`, shared types). No new hidden dependencies.
- **Single-defined markers:** `GUIDED_WORKFLOW_LOOKBACK` and `GUIDED_WORKFLOW_SIGNATURE_BYTES` must be single-defined in the new module or intentionally re-exported with a clear ownership comment.
- **Loader-compat invariant:** Trailing no-op default-exported factory preceded by the literal marker phrase `No-op Pi extension factory` (per Phase 246 ratification).
- **`pals-hooks.ts` edits:** Limited to importing the new module and calling into it; no behavior change, no rename of public identifiers, no semantic drift.

## Forbidden Scope

Phase 250 and any later plan **must not** extract or modify the following as part of S3 work:

- S4 canonical reply delivery: `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`.
- Pi message mutation outside the existing `sendCanonicalWorkflowResponse` call site.
- S6 lifecycle UI (`renderLifecycleStatus`, `syncLifecycleUi`, etc.).
- S7 context injection (`buildPalsContextPayload`, `shouldInjectPalsContext`, etc.).
- S8 command routing (`getCommand`, `toWrapperCommand`, `COMMANDS`, etc.).
- `drivers/pi/install.sh`, `drivers/pi/uninstall.sh`, `drivers/pi/driver.yaml` edits solely for a new sibling `.ts` module (the Phase 241 generalized install source-set rule already covers this).
- Dependency manifest edits, CI configuration changes, module registry changes, kernel workflow source changes, Claude Code driver changes, Agent SDK driver changes.
- Telemetry, hidden runtime state, generated ledgers, cache-as-truth, or alternate validation/module/lifecycle/GitHub Flow ledger.
- Auto-approval, auto-continue, skipped checkpoints, UI-only lifecycle decisions, or inferred merge intent.
- Broad validation-suite decomposition or reclassification beyond the bounded guardrails expected for S3 surfacing in Phase 251.

## Phase 250 Handoff

Phase 250 must plan and execute inside the following bounds.

### Required marker/source checks before extraction

- Grep/read confirmation that all 10 S3 identifiers are present in `drivers/pi/extensions/pals-hooks.ts` before any move.
- Confirm `GUIDED_WORKFLOW_LOOKBACK` and `GUIDED_WORKFLOW_SIGNATURE_BYTES` are referenced only within the S3 function set or by call sites that will remain in `pals-hooks.ts`.
- Confirm no S3 function calls into S4 delivery functions are severed or re-routed.

### Expected sibling-module shape validation

- The new `*.ts` file is covered by the generalized install source set (Phase 241 rule: all `drivers/pi/extensions/*.ts` siblings are installed by basename).
- `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports the new sibling in its installed file count.
- `git diff --check` is clean.

### Validation commands and count reconciliation

- `bash tests/pi-end-to-end-validation.sh` — expected baseline at Phase 249 closure: Pi 223/223. Phase 250 may introduce bounded guardrails; any count change must be reconciled from command output in the Phase 250 SUMMARY.
- `bash tests/cross-harness-validation.sh` — expected baseline at Phase 249 closure: cross-harness 131/131. Same reconciliation rule.
- `bash tests/helpers/artifact_consistency.sh` — must PASS.
- If counts differ from baseline, the delta must be stated with reason, validation class, and shared-invariant preservation rationale.

### GitHub Flow evidence

- If github-flow mode is active, Phase 250 APPLY must create or reuse a feature branch, push when configured, and surface PR/CI state for UNIFY merge-gate handling.
- No merge intent is inferred from branch/PR/CI display state.

### Prohibited files/surfaces

- Do not edit installed runtime copies under `~/.pi/agent/extensions/` directly.
- Do not modify `drivers/pi/extensions/pals-hooks.ts` beyond the minimal import-plus-call-site delegation needed for the extracted module.
- Do not create the sibling module before Phase 250 (Phase 249 is contract-only).

## Phase 250 Outcome

Phase 250 completed the bounded S3 extraction without changing S4 canonical reply delivery, S6 lifecycle UI, S7 context injection, S8 command routing, installer/uninstaller/driver manifest behavior, dependencies, CI, telemetry, hidden state, or lifecycle authority.

- **S3 sibling created:** `drivers/pi/extensions/guided-workflow-detection.ts` now owns the S3 detection functions and constants named in this contract, with helper imports from `./pals-hooks` and the no-op default factory required by Pi's extension loader.
- **S4 boundary preserved:** `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`, `pi.sendUserMessage`, and notify-only canonical-reply behavior remain in `drivers/pi/extensions/pals-hooks.ts`.
- **Install evidence:** `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reported `[ok] Pi extensions installed: 5 files`, proving the Phase 241 generalized source-set rule covered `guided-workflow-detection.ts` without installer or manifest edits.
- **Validation evidence:** Phase 250 APPLY passed Pi validation `224/224`, cross-harness validation `131/131`, `bash tests/helpers/artifact_consistency.sh` PASS, and `git diff --check` clean. Pi count changed `223→224` because Phase 250 added one localized S3 extraction guardrail; cross-harness count stayed `131`.
- **GitHub Flow evidence:** PR #165 carried the Phase 250 implementation and was merged on 2026-05-02; no merge intent was inferred from displayed branch/PR/CI state.

## Acceptance Checklist

- [x] S3 subsystem boundary is defined with all 10 named identifiers.
- [x] Governing safety contract (`docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`) is cited and its invariants are protected.
- [x] Allowed Phase 250 extraction shape names the sibling file, helper-import discipline, single-defined constants, and loader-compat invariant.
- [x] Forbidden scope explicitly excludes S4 delivery, S6/S7/S8, installer/manifest edits, dependencies, CI, telemetry, hidden state, and lifecycle authority changes.
- [x] Phase 250 handoff includes required marker checks, install verification, validation commands, count reconciliation rules, GitHub Flow evidence requirements, and prohibited surfaces.
- [x] This contract is docs-only: no runtime/source/test/install/dependency/CI/lifecycle-authority changes were made in Phase 249.

---

*Created: Phase 249 / Plan 249-01.*  
*Authority: Derived aid only; `.paul/*` artifacts and command-output truth remain authoritative lifecycle truth.*
