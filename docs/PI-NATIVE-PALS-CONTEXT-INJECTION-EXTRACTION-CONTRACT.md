# Pi-Native PALS Context Injection Extraction Contract

**Phase:** 253 S7 Extraction Contract + Bounded Submodule Plan
**Plan:** 253-01
**Status:** Phase 253 docs-only; Phase 254 source extraction not yet started. This document is a derived aid only; it does not modify runtime behavior, validation truth, module truth, GitHub Flow truth, or `.paul/*` lifecycle authority.

## Purpose

This contract defines the extraction boundary for S7 `pals-context-injection` from `drivers/pi/extensions/pals-hooks.ts` into a dedicated sibling Pi extension module `drivers/pi/extensions/pals-context-injection.ts`. Phase 253 produces the docs-only contract and Phase 254 handoff; Phase 254 will perform the source extraction following the sibling-module recipe ratified by S5 (Phase 239), S1 (Phase 243), S2 (Phase 246), and S3 (Phase 250).

S7 owns the PALS context payload that is injected before agent start (`PRIMARY_INJECTION_EVENT`) and the supporting `context` event (`SUPPORTING_CONTEXT_EVENT`), plus the message-stream housekeeping that keeps only the latest PALS context message. This subsystem owns the explicit `[PALS_STATE_AUTHORITY=.paul/STATE.md]` and `[PALS_ACTIVATION_SIGNAL]` tags that downstream consumers — including `/paul-resume` itself and the v2.55+ guided-workflow surfaces — rely on. The `do not extract before guided-workflow evidence semantics are stable` precondition recorded in `PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` is now satisfied by v2.58 closure (Phases 249–252; PRs #164/#165/#166/#167; Pi 227/227, cross-harness 135/135, install 5 Pi extension files).

This document is a **derived aid only**. It does not modify runtime behavior, validation truth, module truth, GitHub Flow truth, or `.paul/*` lifecycle authority. Shared `.paul/*` artifacts, approved PLAN/APPLY/UNIFY artifacts, module reports, GitHub Flow command evidence, and validation command output remain authoritative.

## Evidence Base

- `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` — original S1–S8 inventory; S7 row + risk note; cited identifiers; "must preserve `STATE_AUTHORITY_TAG`, `ACTIVATION_SIGNAL_TAG`, `LEGACY_PALS_CONTEXT_HEADER`, `PALS_CONTEXT_CUSTOM_TYPE` exactly; do not extract before guided-workflow evidence semantics are stable" precondition (now satisfied by v2.58 closure).
- `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md` — current S1/S2/S3/S5 extraction state; S7 risk classification; multi-module extraction rule; forbidden scope; validation expectations.
- `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` — governing safety contract for canonical replies, no auto-approval, no auto-continue, checkpoint blocking, no UI-only lifecycle decisions, no inferred merge intent.
- `docs/PI-NATIVE-GUIDED-WORKFLOW-DETECTION-EXTRACTION-CONTRACT.md` — most-recent S* extraction contract precedent (Phase 249/250 S3 wave); same shape applied here.
- `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md` — preserved deferral of full Claude Code / Agent SDK driver removal until cross-harness validation decomposition lands; this contract is out of scope for v2.59 and must not be modified.
- `drivers/pi/extensions/pals-hooks.ts` — supported Pi runtime entry source; currently owns S7 inline. Phase 254 will import S7 from the new sibling while keeping the S4 canonical reply delivery, the S5/S1/S2/S3 sibling imports, and the shared helpers.
- `drivers/pi/extensions/module-activity-parsing.ts` — S5 sibling precedent (pure; smallest authority surface).
- `drivers/pi/extensions/artifact-slice-rendering.ts` — S1 sibling precedent (single-defined contract markers).
- `drivers/pi/extensions/workflow-resource-capsule-rendering.ts` — S2 sibling precedent (helper-import tightening; loader-compat invariant; triple-confirmed pattern).
- `drivers/pi/extensions/guided-workflow-detection.ts` — S3 sibling precedent: detection extracted while delivery (S4) remained inline; same shape applies to S7 (injection extracted while housekeeping invocation site and shared helpers remain explicit).
- `.paul/phases/249-s3-extraction-contract-bounded-submodule-plan/249-01-SUMMARY.md` — closes the S3 contract phase; sets the precedent docs-only shape Phase 253 mirrors.
- `.paul/phases/250-bounded-s3-submodule-extraction/250-01-SUMMARY.md` — closes the S3 source-extraction phase; sets the precedent shape Phase 254 will mirror for S7.
- `.paul/phases/252-evidence-closure-next-roadmap-decision/252-01-SUMMARY.md` — v2.58 closure that recorded S7 `pals-context-injection` as the v2.59 default recommendation only; explicit approval routes through `/paul:milestone` and the resulting plan, not through this contract.

## S7 Subsystem Boundary

The following identifiers in `drivers/pi/extensions/pals-hooks.ts` define the S7 `pals-context-injection` subsystem. Phase 254 must preserve every named identifier through explicit import or single-defined re-export, and must preserve the listed constants as exact-string single-defined markers.

### Functions

- `buildPalsContextPayload`
- `shouldInjectPalsContext`
- `isPalsContextMessage`
- `isLegacyPalsContextMessage`
- `keepOnlyLatestPalsContextMessage`
- `messagesChanged`

### Constants (exact-string single-defined markers)

- `PRIMARY_INJECTION_EVENT` — `"before_agent_start"`
- `SUPPORTING_CONTEXT_EVENT` — `"context"`
- `PALS_CONTEXT_CUSTOM_TYPE` — `"pals-context"`
- `LEGACY_PALS_CONTEXT_HEADER` — `"## PALS Context (auto-injected)"`
- `STATE_AUTHORITY_TAG` — `"[PALS_STATE_AUTHORITY=.paul/STATE.md]"`
- `ACTIVATION_SIGNAL_TAG` — `"[PALS_ACTIVATION_SIGNAL]"`

These six constants are the consumer contract surface. `/paul-resume` and other consumers that parse the injected payload depend on the exact byte sequences. Phase 254 MUST keep each constant single-defined (no duplication, no template re-derivation, no concatenation drift).

## Shared-Helper Disposition

`extractTextContent` and `collectRecentAssistantTexts` are NOT S7-private. They are referenced by S5 module-activity-parsing helpers and by S3 guided-workflow detection inputs in addition to S7 injection. They must remain shared helpers exported from `drivers/pi/extensions/pals-hooks.ts` — the same boundary used for `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp` — and the new S7 sibling MUST import them from `./pals-hooks` rather than duplicating them or moving them with S7.

This mirrors the Phase 246 S2 + Phase 250 S3 helper-import tightening discipline: the new sibling imports only the shared helpers it actually references.

## Message-Stream Housekeeping Rule

`keepOnlyLatestPalsContextMessage` is the only S7 function that mutates the message stream. The Phase 254 extraction MUST preserve the existing housekeeping invocation site in `drivers/pi/extensions/pals-hooks.ts` (the pass that filters `isLegacyPalsContextMessage` out, then normalizes via `keepOnlyLatestPalsContextMessage`, then gates the rewrite via `messagesChanged`) by calling into the new sibling rather than re-implementing message mutation in `pals-hooks.ts`.

The current call shape in `pals-hooks.ts`:

```
const withoutLegacy = messages.filter((message) => !isLegacyPalsContextMessage(message));
const normalized = keepOnlyLatestPalsContextMessage(withoutLegacy);
if (messagesChanged(messages, normalized)) {
    /* existing rewrite path */
}
```

MUST remain functionally identical. The four named identifiers (`isLegacyPalsContextMessage`, `keepOnlyLatestPalsContextMessage`, `messagesChanged`, plus the `messages` array) MUST stay observable at the same call site; only the import source for the three S7 functions changes.

## Allowed Phase 254 Extraction Shape

Phase 254 MUST follow the sibling-module recipe ratified by S5 (Phase 239), S1 (Phase 243), S2 (Phase 246), and S3 (Phase 250):

1. **Allowed source target:** create `drivers/pi/extensions/pals-context-injection.ts` as a new sibling Pi extension module.
2. **Loader-compat invariant:** the new sibling MUST end with a no-op default-exported factory `export default function (_pi: unknown): void {}` preceded by a JSDoc comment carrying the literal phrase `No-op Pi extension factory`.
3. **Helper imports:** import `extractTextContent`, `collectRecentAssistantTexts`, and any other shared helpers actually referenced from `./pals-hooks` only. Do not duplicate, do not re-export, and do not move shared helpers.
4. **Single-defined markers:** the six S7 constants listed above MUST be defined exactly once in the new sibling and either consumed locally or explicitly re-exported. `pals-hooks.ts` MUST replace its local definitions with imports from the new sibling. No constant is duplicated and none is dropped.
5. **Function moves:** the six S7 functions listed above MUST move to the new sibling with no signature change. `pals-hooks.ts` MUST import them from `./pals-context-injection` at the call sites that already exist (injection at `PRIMARY_INJECTION_EVENT`, supporting context at `SUPPORTING_CONTEXT_EVENT`, and the message-housekeeping site).
6. **Authority/activation tag preservation:** the exact byte sequences of `STATE_AUTHORITY_TAG` (`[PALS_STATE_AUTHORITY=.paul/STATE.md]`) and `ACTIVATION_SIGNAL_TAG` (`[PALS_ACTIVATION_SIGNAL]`) MUST appear unchanged in the emitted payload.
7. **Custom-message-type preservation:** `customType: PALS_CONTEXT_CUSTOM_TYPE` MUST be set to `"pals-context"` on injected messages so `isPalsContextMessage` continues to identify them.
8. **Legacy-header migration preservation:** `isLegacyPalsContextMessage` MUST continue to recognize the literal `"## PALS Context (auto-injected)"` header so legacy injected messages remain filterable for housekeeping.
9. **Install surface:** `drivers/pi/install.sh` MUST report 6 Pi extension files after Phase 254 (current 5 + new sibling). Any other installer change is forbidden.
10. **Pi runtime entry:** `palsHooks` (the Pi extension factory in `pals-hooks.ts`) and the events `before_agent_start` and `context` MUST continue to fire. The injection gate (`shouldInjectPalsContext`) MUST continue to gate exactly the same payloads it currently gates.

## Forbidden Scope (Phase 254)

Phase 254 MUST NOT:

- Modify or extract S4 canonical reply delivery: `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`, or any other S4 identifier. S4 stays inline in `pals-hooks.ts`.
- Modify or extract S6 lifecycle UI (Pi widget/status/UI mutation paths).
- Modify or extract S8 command routing (`/paul-*` command surface, command lookup, wrapper translation, command-signal detection, quick-action selection, command registration).
- Re-extract or modify previously extracted siblings: `module-activity-parsing.ts` (S5), `artifact-slice-rendering.ts` (S1), `workflow-resource-capsule-rendering.ts` (S2), `guided-workflow-detection.ts` (S3).
- Touch `drivers/pi/uninstall.sh`, `drivers/pi/driver.yaml`, kernel workflow sources, or installed runtime copies under `~/.pi/agent/extensions/`. Only `drivers/pi/install.sh` may be changed, and only by the minimal source-set entry needed to install the new sibling.
- Modify dependency manifests, lockfiles, CI configuration (`.github/workflows/*`), Dockerfiles, module registry files (`modules.yaml`, `kernel/modules.yaml`), or `.paul/SPECIAL-FLOWS.md`.
- Touch the Claude Code driver or the Agent SDK driver (frozen since v2.52; full removal still blocked on cross-harness validation decomposition per `PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`).
- Decompose `tests/cross-harness-validation.sh`. Broader validation-script size-debt work remains a separate v2.5x candidate (RUBY-flagged in v2.58 closure).
- Add telemetry, hidden state, runtime ledgers, cache-as-truth, auto-approval, auto-continue, skipped checkpoints, UI-only lifecycle decisions, or inferred merge intent.
- Move shared helpers (`extractTextContent`, `collectRecentAssistantTexts`, `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `PalsStateSnapshot`) out of `pals-hooks.ts`. They remain shared.
- Change `.paul/*` lifecycle authority. The PLAN/APPLY/UNIFY loop and STATE.md/ROADMAP.md/PROJECT.md/MILESTONES.md remain authoritative.

## Phase 254 Handoff

Phase 254 (Bounded S7 Submodule Extraction) MUST satisfy the following before declaring APPLY complete:

### Marker / function preservation checks

- `grep` proves each of the six S7 constants is defined exactly once across the repo (no duplication after extraction).
- `grep` proves each of the six S7 functions is defined exactly once across the repo and that `pals-hooks.ts` imports them from `./pals-context-injection`.
- `grep` proves `extractTextContent` and `collectRecentAssistantTexts` remain defined in `pals-hooks.ts` (shared-helper retention).
- `grep` proves the S4 canonical-reply identifiers (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`) remain defined in `pals-hooks.ts` (S4 stays inline).
- `grep` proves the literal authority/activation byte sequences `[PALS_STATE_AUTHORITY=.paul/STATE.md]` and `[PALS_ACTIVATION_SIGNAL]` appear in exactly one source location each (the new sibling).

### Install verification

- `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports 6 Pi extension files (current 5 + new `pals-context-injection.ts`). The TAP / `[ok]` line is preserved verbatim in the SUMMARY.

### Validation

- `bash tests/pi-end-to-end-validation.sh` passes. Expected baseline at start of Phase 254: Pi 227/227. Any count change MUST be reconciled from command output in the SUMMARY.
- `bash tests/cross-harness-validation.sh` passes. Expected baseline at start of Phase 254: cross-harness 135/135. Any count change MUST be reconciled from command output in the SUMMARY.
- `bash tests/helpers/artifact_consistency.sh` returns `artifact_consistency_check: PASS`.
- `git diff --check` returns clean.

### GitHub Flow evidence

- Phase 254 work happens on a non-base feature branch.
- After successful APPLY, the branch is pushed and a PR is opened (per `pals.json` `auto_push: true`, `auto_pr: true`).
- CI status is recorded in the SUMMARY (passing required before merge per `pals.json` `ci_checks: true`).
- Merge follows squash strategy with branch deletion (`merge_method: "squash"`, `delete_branch_on_merge: true`).

### Summary count reconciliation discipline

- All TAP counts in the Phase 254 SUMMARY MUST be copied from fresh command output, not from this contract or any other prior document. If validation counts differ from the expected baseline, the SUMMARY MUST explain the delta from command output before UNIFY proceeds.

## Acceptance Checklist

- [ ] New sibling `drivers/pi/extensions/pals-context-injection.ts` exists, exports the six S7 functions, defines the six S7 constants single-defined, ends with the loader-compat no-op default factory carrying the literal `No-op Pi extension factory` JSDoc phrase.
- [ ] `drivers/pi/extensions/pals-hooks.ts` no longer defines the six S7 constants or the six S7 functions; it imports them from `./pals-context-injection`.
- [ ] `drivers/pi/extensions/pals-hooks.ts` still defines and exports `extractTextContent`, `collectRecentAssistantTexts`, and the existing shared helpers; the new S7 sibling imports them from `./pals-hooks`.
- [ ] The S4 canonical-reply identifiers remain inline in `drivers/pi/extensions/pals-hooks.ts`.
- [ ] The message-housekeeping invocation site in `drivers/pi/extensions/pals-hooks.ts` is functionally identical (same call shape, same identifiers) and rebinds only the import source.
- [ ] `drivers/pi/install.sh` reports 6 Pi extension files after Phase 254.
- [ ] Pi e2e, cross-harness, and artifact-consistency validation pass at the Phase 254 reconciled count; deltas explained from command output.
- [ ] `git diff --check` clean.
- [ ] No forbidden-scope file is touched.
- [ ] PR opened, CI green, squash-merge with branch deletion.

## Status After Phase 253

This contract is final for Phase 253. It does not authorize source changes; it defines the boundary Phase 254 will execute against. Approval of Phase 254 routes through `/paul:plan` for Phase 254 (after Phase 253 UNIFY closes), not through this contract.
