# Pi-Native Extension Modularization Contract

**Phase:** 238 Pi Extension Modularization Contract
**Plan:** 238-01
**Status:** Active — docs-only contract baseline. `drivers/pi/extensions/pals-hooks.ts` is unchanged by this plan; Phase 239 will execute the bounded extraction spike inside this contract.

## Purpose

`drivers/pi/extensions/pals-hooks.ts` is the supported Pi runtime entry point. Phase 234 ranked it as maintainability weakness #2 (1,684 lines, multiple supported-runtime concerns in one file). Phase 235 requires that any new safety mechanism preserve `.paul/*` authority and add no hidden state, telemetry, or alternate ledger. Phase 236 preserved validation command-output truth and the safe sourced-helper extraction pattern. Phase 237 added artifact consistency guardrails and proved the contract-then-implementation cadence end-to-end (the new guardrail caught real drift mid-loop).

This contract continues that cadence. It defines extraction boundaries, inventories candidate subsystems, classifies each candidate by risk/purity/extraction readiness, and selects exactly one Phase 239 first-spike candidate. It is **docs-only**: it does not modify the runtime, source, validation suites, install surface, dependencies, CI, lifecycle artifacts (beyond standard Phase 238 metadata), or tests.

## Evidence Base

- `docs/PALS-MAINTAINABILITY-PRODUCT-REALITY-AUDIT.md` — Phase 234 audit ranking the Pi extension as weakness #2 and naming candidate boundaries (command routing, activation/slices, capsules, guided workflow, CARL/session boundary, module activity parsing).
- `docs/PALS-RISK-TIERED-LIFECYCLE-CONTRACT.md` — Phase 235 contract: tier-aware evidence; non-bypass rules for `.paul/*` authority, no hidden state, no telemetry, command-output truth, full authoritative read fallback.
- `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md` — existing artifact-slice surface; informs the artifact-slice-rendering subsystem boundary and forbids hidden persistence/lifecycle authority for any extracted module.
- `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md` — existing workflow/resource capsule surface; informs the capsule subsystem boundary and the `Authority: Derived aid only` requirement.
- `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` — guided workflow detection / canonical reply surface; constrains how any extracted guided-workflow module must preserve transcript-visible canonical replies, no auto-approval, and no inferred merge intent.
- `docs/PI-NATIVE-DELEGATED-APPLY-PACKET-REPORT-CONTRACT.md` — delegated APPLY parent-authority contract; Phase 239 must not introduce helper-owned lifecycle writes through any extracted module.
- `.paul/STATE.md` — Phase 238 ready to plan; `.paul/*` artifacts remain authoritative lifecycle truth.
- `.paul/ROADMAP.md` — Phase 238 focus: define extraction boundaries and select the first low-risk subsystem to extract.
- `.paul/phases/237-artifact-consistency-guardrails/237-01-SUMMARY.md` — direct predecessor; preserved Pi 210/210 and cross-harness 124/124 and proved the contract-then-implementation cadence catches real drift in normal lifecycle transitions.
- `drivers/pi/extensions/pals-hooks.ts` — read-only context for this contract. Top-level identifiers cited below were observed by direct read; this plan does not modify the file.

## Authority and Non-Goals

- This contract is a **derived aid only**. It is not authoritative over `.paul/*` artifacts, runtime behavior, validation truth, GitHub Flow, or module evidence. `.paul/*` artifacts and command-output validation remain the only sources of lifecycle truth.
- `drivers/pi/extensions/pals-hooks.ts` is **unchanged** by Phase 238. No runtime behavior, type, function, constant, command, hook registration, lifecycle UI, artifact slice, capsule, guided workflow detection, canonical reply, CARL boundary, module activity parser, or context injection logic is modified, removed, or relocated by this plan.
- No telemetry. No hidden runtime state. No alternate lifecycle, module, validation, GitHub Flow, or merge-gate ledger.
- No auto-approval. No auto-continue. No skipped checkpoints. No UI-only lifecycle decisions. No inferred merge intent. No relaxation of parent-owned APPLY, helper-delegation boundaries, lifecycle authority, module evidence, or full authoritative read fallback.
- Validation count truth remains command-output: `bash tests/pi-end-to-end-validation.sh` and `bash tests/cross-harness-validation.sh` are the only count-of-record sources. Phase 238 introduces zero new TAP assertions and Pi `210/210` / cross-harness `124/124` are unchanged after this plan.
- This contract does **not** pre-decide Phase 239 implementation details (concrete API surface for any extracted module, exact internal naming, exact line ranges to move). It only fixes the boundary inventory, classification, first-spike selection, and bounded handoff.

## Tier-Aware Usage

Following `docs/PALS-RISK-TIERED-LIFECYCLE-CONTRACT.md`:

- **Phase 238 lands as tiny / doc-only tier.** Single new contract artifact, no runtime/source/test/install/dependency/CI/lifecycle-authority changes, validation counts unchanged. PASS evidence is the contract document itself plus stable command-output validation.
- **Phase 239 will land as risky tier.** It will touch the supported Pi runtime source. Risky-tier evidence (focused marker checks, `git diff --check`, bounded validation count change reconciliation, Workguard scope proof, parent-run official validation, full authoritative read fallback preservation) must be carried in the Phase 239 plan, not assumed from this contract.
- Hotfix tier remains out of scope: extension modularization is not a fix-loop concern.

## Subsystem Inventory

The following 8 candidate subsystems are derived from a read-only inspection of `drivers/pi/extensions/pals-hooks.ts`. Each candidate cites at least two top-level identifiers actually present in the file. Identifiers are referenced as observed at the time of writing; Phase 239 must reread the source before spike work because exact line numbers may shift.

### S1 — `artifact-slice-rendering`

Owns the artifact-slice contract surface: schema markers, spec list, line-bounded extraction, dedup, and fallback messaging.

Cited identifiers in `drivers/pi/extensions/pals-hooks.ts`:
- `buildArtifactSlice`
- `getArtifactSliceSpecs`
- `renderArtifactSlices`
- `selectBoundedLines`
- `deduplicateArtifactSliceLines`
- `normalizeArtifactSliceLine`
- `ARTIFACT_SLICE_SCHEMA_MARKERS` (constant)
- `MAX_ARTIFACT_SLICE_CHARS` / `MAX_ARTIFACT_SLICE_LINES` (constants)

Notes: this subsystem largely consumes general filesystem helpers (`readFileOr`, `getFileFreshness`) and a parsed `PalsStateSnapshot`; it does not own Pi lifecycle authority, register commands, send user messages, or write hidden state.

### S2 — `workflow-resource-capsule-rendering`

Owns the workflow/resource capsule contract surface: schema markers, spec list, source resolution, build, render, and fallback messaging.

Cited identifiers:
- `buildWorkflowResourceCapsule`
- `getWorkflowResourceCapsuleSpecs`
- `resolveWorkflowResourceCapsuleSource`
- `renderWorkflowResourceCapsules`
- `WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS` (constant)
- `MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS` / `MAX_WORKFLOW_RESOURCE_CAPSULE_LINES` (constants)

Notes: structurally near-identical to S1; consumes filesystem helpers and emits Derived-aid-only orientation text. Does not own Pi lifecycle authority or send user messages.

### S3 — `guided-workflow-detection`

Owns guided workflow moment detection, option parsing, canonical-reply detection, merge-gate routing detection, and signatures used to avoid duplicate guidance.

Cited identifiers:
- `detectGuidedWorkflowMoment`
- `parseGuidedWorkflowOptions`
- `detectExplicitCanonicalResponse`
- `isMergeGateRoutingPrompt`
- `extractMergeGateRoutingSummary`
- `makeGuidedWorkflowSignature`
- `summarizeWorkflowPrompt`
- `extractNextActionSummary`
- `isValidOptionId`
- `GUIDED_WORKFLOW_LOOKBACK` / `GUIDED_WORKFLOW_SIGNATURE_BYTES` (constants)

Notes: this subsystem is bound by `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`. Any extraction must preserve transcript-visible canonical replies, no auto-approval, no inferred merge intent, and the display-only treatment of `guided_workflow.auto_present`.

### S4 — `guided-workflow-canonical-reply`

Owns the actual delivery of selected canonical replies into the Pi message stream and the configuration surface that gates auto-presentation.

Cited identifiers:
- `sendCanonicalWorkflowResponse`
- `loadGuidedWorkflowConfig`
- `shouldAutoPresent`

Notes: this subsystem mutates Pi state via `pi.sendUserMessage`. It is the most lifecycle-coupled of the guided-workflow concerns and must remain a thin call site under parent control.

### S5 — `module-activity-parsing`

Owns parsing of recent assistant transcripts to surface module dispatch evidence and module reports for the lifecycle UI.

Cited identifiers:
- `parseModuleActivityEntries`
- `extractDispatchModuleActivity`
- `extractModuleReportActivity`
- `extractRecentModuleActivity`
- `formatModuleEntryList`
- `compactModuleDetail`
- `normalizeModuleEntryName`
- `formatModuleStageLabel`
- `DISPATCH_MARKER` / `MODULE_REPORTS_HEADER` (constants)

Notes: pure transcript parsing — string in, structured `RecentModuleActivity` out. No Pi mutation, no filesystem writes, no lifecycle authority. This is the strongest pure-extraction candidate alongside artifact-slice rendering.

### S6 — `lifecycle-ui`

Owns the visible lifecycle status / widget / loop badge and the Pi UI sync call.

Cited identifiers:
- `renderLifecycleStatus`
- `renderLifecycleWidget`
- `syncLifecycleUi`
- `renderLoopBadge`
- `renderCompactLoopSummary`
- `renderLifecycleActionLabel`
- `renderModuleActivity`
- `renderModuleActivityDetails`
- `PALS_STATUS_ID` / `PALS_WIDGET_ID` (constants)

Notes: depends on parsed `PalsStateSnapshot` and `RecentModuleActivity`. Mutates Pi UI through `ctx`; not a pure subsystem. Useful as a later spike once a pure extraction proves the pattern.

### S7 — `pals-context-injection`

Owns the PALS context payload that is injected before agent start and the message-stream housekeeping that keeps only the latest PALS context message.

Cited identifiers:
- `buildPalsContextPayload`
- `shouldInjectPalsContext`
- `isPalsContextMessage`
- `isLegacyPalsContextMessage`
- `keepOnlyLatestPalsContextMessage`
- `messagesChanged`
- `extractTextContent`
- `collectRecentAssistantTexts`
- `LEGACY_PALS_CONTEXT_HEADER` / `STATE_AUTHORITY_TAG` / `ACTIVATION_SIGNAL_TAG` / `PALS_CONTEXT_CUSTOM_TYPE` (constants)
- `PRIMARY_INJECTION_EVENT` / `SUPPORTING_CONTEXT_EVENT` (constants)

Notes: this subsystem owns the explicit `[PALS_STATE_AUTHORITY=.paul/STATE.md]` and `[PALS_ACTIVATION_SIGNAL]` tags that consumers (including `/paul-resume`) rely on. Extraction must preserve those exact tags.

### S8 — `command-routing`

Owns the `/paul-*` command surface registered on Pi: command lookup, wrapper-command translation, command-signal detection, quick-action selection, and command registration.

Cited identifiers:
- `getCommand`
- `toWrapperCommand`
- `detectCommandSignal`
- `getQuickActions`
- `COMMANDS` (top-level `const COMMANDS: CommandDef[]` declared in the command-definitions section)

Notes: any extraction must preserve current command names, registration via `pi.registerCommand` and `pi.registerShortcut`, and must not change canonical reply behavior.

(The CARL session boundary surface — `loadCarlConfig`, `extractLoopSignature`, `buildCarlBootstrapPrompt`, `formatCarlContextPressure` — is intentionally not promoted to its own candidate in this 8-candidate list because Phase 234 grouped session-boundary work under the existing CARL module rather than the Pi extension monolith hotspot. It can be promoted in a later approved plan if Phase 239 evidence shows the existing CARL surface is the correct extraction target.)

## Classification

| Candidate | Purity | Risk tier hint | Extraction-readiness rationale | Ordering constraints |
|-----------|--------|----------------|--------------------------------|----------------------|
| S1 `artifact-slice-rendering` | pure | risky (first runtime spike) → low practical risk | Self-contained build/render functions, contract-protected by `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md`; consumes only `PalsStateSnapshot` plus filesystem helpers. Strongest pure-extraction candidate, equal to S5. | Must preserve `ARTIFACT_SLICE_SCHEMA_MARKERS` exactly; any extracted module must not own lifecycle authority or write hidden state. |
| S2 `workflow-resource-capsule-rendering` | pure | risky → low practical risk | Structurally near-identical to S1 and contract-protected by `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md`. Slightly more coupled because of `resolveWorkflowResourceCapsuleSource` paths. | Must preserve `WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS` exactly; should not be extracted before the artifact-slice pattern proves on a smaller surface. |
| S3 `guided-workflow-detection` | mixed | risky → moderate practical risk | Detection functions are pure, but the surface is bound by `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` and any change must preserve canonical reply semantics. Larger function set. | Must not be split from S4 in a way that allows divergence between detection and canonical reply delivery. |
| S4 `guided-workflow-canonical-reply` | runtime-coupled | risky → higher practical risk | Mutates Pi message stream via `pi.sendUserMessage`; must not introduce auto-approval, auto-continue, or inferred merge intent. | Stays inline until at least one pure subsystem extraction is proven; must preserve all guided-workflow evidence markers. |
| S5 `module-activity-parsing` | pure | risky → low practical risk | Pure string parsing producing structured `RecentModuleActivity`; no Pi mutation; no filesystem writes; no lifecycle authority. Strongest pure-extraction candidate, equal to S1. | Must preserve `DISPATCH_MARKER` and `MODULE_REPORTS_HEADER` exactly; module reports remain authoritative — any extracted parser stays advisory. |
| S6 `lifecycle-ui` | runtime-coupled | risky → higher practical risk | Mutates Pi UI via `ctx`; consumes outputs of S5 and S7; depends on Pi widget/status surface. Useful as a later spike once a pure extraction proves the pattern. | Should not be extracted before S1/S5 prove the pattern; must keep all visible lifecycle status semantics. |
| S7 `pals-context-injection` | mixed | risky → moderate practical risk | Build is pure but housekeeping (`keepOnlyLatestPalsContextMessage`) mutates the message stream; explicit authority/activation tags must be preserved exactly. | Must preserve `STATE_AUTHORITY_TAG`, `ACTIVATION_SIGNAL_TAG`, `LEGACY_PALS_CONTEXT_HEADER`, and `PALS_CONTEXT_CUSTOM_TYPE` exactly; do not extract before guided-workflow evidence semantics are stable. |
| S8 `command-routing` | runtime-coupled | risky → higher practical risk | Registers commands and shortcuts on Pi; sends user messages; defines `/paul-*` user-facing surface. Highest user-visible blast radius. | Should not be the first spike; any extraction must preserve current `/paul-*` names, shortcuts, canonical replies, and quick-action ordering. |

## Phase 239 First-Spike Selection

**Selected candidate:** **S5 `module-activity-parsing`**.

Selection rationale (3 reasons):

1. **Highest purity for a first spike.** S5 is pure transcript parsing — string in, structured `RecentModuleActivity` out. It does not call any `pi.*` API, does not touch the filesystem, does not read or write `.paul/*`, and does not own lifecycle authority. This minimizes Pi-API coupling and makes a behavior-preserving extraction observable through focused marker checks alone.
2. **Smallest authority surface.** S5 has no contract document of its own that pins exact emitted strings (unlike S1's `ARTIFACT_SLICE_SCHEMA_MARKERS` and S2's `WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS`); only `DISPATCH_MARKER` and `MODULE_REPORTS_HEADER` need preservation. This makes a behavior-preserving extraction provable with the smallest validation guardrail addition.
3. **Highest reuse potential for the Phase 240/241 evidence work.** A clean `parseModuleActivityEntries` / `extractRecentModuleActivity` boundary lets later phases test transcript parsing without spinning up Pi runtime context, which directly supports v2.55's product-evidence and reconciliation phases.

Rejection reasons for non-selected candidates:

- **S1 `artifact-slice-rendering`** — equally pure, but contract-protected schema markers raise the prose-preservation surface area, increasing the chance a behavior-preserving extraction needs more than one validation guardrail addition.
- **S2 `workflow-resource-capsule-rendering`** — structurally near-identical to S1 and slightly more coupled via source resolution; should follow S1 once the artifact-slice pattern is proven.
- **S3 `guided-workflow-detection`** — large function set bound by guided-workflow evidence contract; not a "smallest safe spike" target.
- **S4 `guided-workflow-canonical-reply`** — mutates Pi message stream and bears merge-gate routing constraints; far too high a blast radius for the first extraction.
- **S6 `lifecycle-ui`** — mutates Pi UI and depends on outputs of S5 and S7; should follow at least one pure extraction.
- **S7 `pals-context-injection`** — must preserve explicit authority/activation tags exactly; mutates the message stream during housekeeping; not the smallest safe spike.
- **S8 `command-routing`** — highest user-visible blast radius (commands and shortcuts); never a first spike.

## Phase 243 Outcome

Phase 243 Plan 01 extracted the S1 candidate identified above as equally pure to S5; the rejection-reasons analysis and risk-readiness table preceding this section remain authoritative verbatim and were not re-litigated.

- **S1 `artifact-slice-rendering` extracted** to `drivers/pi/extensions/artifact-slice-rendering.ts` following the Phase 239 S5 sibling-module pattern. The contract-protected `ARTIFACT_SLICE_SCHEMA_MARKERS` strings and the `MAX_ARTIFACT_SLICE_*` caps are preserved single-defined in the new sibling; no marker is duplicated and none was dropped.
- **Helpers exported from `pals-hooks.ts`:** `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, and the type `PalsStateSnapshot`. Future siblings import these helpers from `./pals-hooks` rather than duplicating them.
- **Canonical `default-arg cycle-avoidance` pattern:** any shared cap (e.g., `selectBoundedLines`'s `maxLines`) moves from a default-arg referencing a sibling-owned constant to a required parameter at the helper signature, with each call site passing its local cap explicitly. This eliminates the latent circular-import risk between `pals-hooks.ts` and any sibling module that owns the cap constant, and is the recommended cycle-avoidance recipe for future S* extractions.
- **Validation guardrail addition was bounded** as the rejection-reasons section anticipated: Pi e2e `1..212 → 1..214` (+2; the +1 anticipated for the S1 single-defined guardrail plus +1 for splitting `shouldInjectPalsContext` into its own block, documented in `.paul/phases/243-bounded-submodule-extraction-wave/243-01-SUMMARY.md`); cross-harness unchanged at `1..127` because no contract-doc string moved.
- **Outcome does not change the S1-S8 risk/readiness analysis above.** The selection prose (S5 first as smallest authority surface; S1 as the equally-pure runner-up) was correct: S5's smaller marker surface let it be the safest first spike, and S1's contract-protected markers were preserved by mirroring the same sibling-module pattern after S5 proved it.

## Phase 246 Outcome

Phase 246 extracted S2 to `drivers/pi/extensions/workflow-resource-capsule-rendering.ts` following the Phase 239 S5 + Phase 243 S1 sibling-module pattern. The contract-protected `WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS` strings and the `MAX_WORKFLOW_RESOURCE_CAPSULE_*` caps are preserved single-defined in the new sibling; no marker is duplicated and none was dropped.

- **Loader-compat invariant** — every helper-only Pi extension sibling MUST end with a no-op default-exported factory `export default function (_pi: unknown): void {}` preceded by a JSDoc comment carrying the literal marker phrase `No-op Pi extension factory`. This is a per-extraction acceptance criterion (Phase 246 promotion from Phase 245’s closure-phase hotfix). Pi auto-loads every `~/.pi/agent/extensions/*.ts` and rejects modules without a default-exported factory; without the loader-compat invariant the sibling fails at session start with `Failed to load extension "...": Extension does not export a valid factory function`.
- **Triple-confirmed sibling-module pattern** — S5 (Phase 239 `module-activity-parsing.ts`) + S1 (Phase 243 `artifact-slice-rendering.ts`) + S2 (Phase 246 `workflow-resource-capsule-rendering.ts`) all match the same shape. The pattern is now ratified rather than provisional. Future S3/S4/S6/S7/S8 extractions can apply this recipe verbatim.
- **Helper-import tightening (canonical sibling-import discipline)** — extracted siblings import only the helpers they actually reference. The new S2 sibling imports `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines` and deliberately omits `escapeRegExp` and `PalsStateSnapshot` because the moved S2 code does not reference them; this keeps the sibling-import surface honest and the boundary minimal.
- **`pals-hooks.ts` post-extraction state** — 1273 LOC (was 1415; −142). The shared helpers `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, and the type `PalsStateSnapshot` remain defined and exported, so future S3–S8 extractions can import them without re-litigating the helper boundary.
- **Validation evidence:** Pi `1..221/0`, cross-harness `1..129/0`, artifact_consistency PASS, install reports `[ok] Pi extensions installed: 4 files`, `git diff --check` clean. PR #161 merged 2026-05-02.

## Phase 249 Outcome

Phase 249 created the S3 `guided-workflow-detection` extraction contract and bounded submodule plan without modifying runtime, source, tests, install, dependencies, CI, or lifecycle authority. The S1–S8 inventory, classification table, and Phase 239/243/246 outcomes above remain authoritative verbatim; this section surfaces the Phase 249 addition only.

- **S3 contract created:** `docs/PI-NATIVE-GUIDED-WORKFLOW-DETECTION-EXTRACTION-CONTRACT.md` defines the 10 S3 identifiers, cites the governing `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`, names the allowed Phase 250 sibling-module shape (`drivers/pi/extensions/guided-workflow-detection.ts`), and preserves the loader-compat invariant, single-defined markers, and helper-import tightening from Phase 246.
- **S3 promoted to bounded Phase 250 contract target:** S3 moved from the conditional-secondary classification in the table above to a v2.58 extraction target after S1/S2 stability was demonstrated. Phase 250 was the first source-changing step and is now complete.
- **S4/S6/S7/S8 deferrals preserved:** The contract explicitly forbids extracting or modifying S4 canonical-reply delivery, S6 lifecycle UI, S7 context injection, and S8 command routing as part of S3 work.
- **Validation baseline preserved:** Pi 223/223, cross-harness 131/131, artifact_consistency PASS, install 4 files, `git diff --check` clean.

## Phase 250 Outcome

Phase 250 extracted S3 `guided-workflow-detection` to `drivers/pi/extensions/guided-workflow-detection.ts`, applying the S5/S1/S2 sibling-module recipe to a guided-workflow detection surface while keeping S4 delivery inline.

- **S3 extracted / S4 retained:** `guided-workflow-detection.ts` now owns detection, option parsing, canonical-response detection, merge-gate routing detection, prompt summarization, next-action extraction, signatures, and S3 constants. `pals-hooks.ts` still owns S4 canonical reply delivery (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`, and `pi.sendUserMessage`).
- **S3/S4 split preserved:** Phase 250 did not extract S4, S6, S7, or S8; it did not change installer/uninstaller/driver manifest, dependencies, CI, telemetry, hidden state, or lifecycle authority.
- **Sibling-module pattern extended:** S5 (`module-activity-parsing.ts`) + S1 (`artifact-slice-rendering.ts`) + S2 (`workflow-resource-capsule-rendering.ts`) + S3 (`guided-workflow-detection.ts`) now share the extracted sibling shape, including helper imports from `./pals-hooks`, single-defined owned markers, and the no-op default factory loader-compat invariant.
- **Validation evidence:** install reports `[ok] Pi extensions installed: 5 files`; Pi validation passed `224/224`; cross-harness validation passed `131/131`; artifact_consistency PASS; `git diff --check` clean. PR #165 merged 2026-05-02.

## Phase 253 Outcome

Phase 253 created the v2.59 S7 `pals-context-injection` extraction contract and bounded Phase 254 handoff without modifying runtime, source, tests, install, dependencies, CI, or lifecycle authority. The S1–S8 inventory, classification table, and Phase 239/243/246/249/250 outcomes above remain authoritative verbatim; this section surfaces the Phase 253 addition only.

- **S7 contract created:** `docs/PI-NATIVE-PALS-CONTEXT-INJECTION-EXTRACTION-CONTRACT.md` defines the six S7 functions (`buildPalsContextPayload`, `shouldInjectPalsContext`, `isPalsContextMessage`, `isLegacyPalsContextMessage`, `keepOnlyLatestPalsContextMessage`, `messagesChanged`), the six S7 constants as exact-string single-defined markers (`PRIMARY_INJECTION_EVENT`, `SUPPORTING_CONTEXT_EVENT`, `PALS_CONTEXT_CUSTOM_TYPE`, `LEGACY_PALS_CONTEXT_HEADER`, `STATE_AUTHORITY_TAG`, `ACTIVATION_SIGNAL_TAG`), the shared-helper disposition (`extractTextContent` and `collectRecentAssistantTexts` stay in `pals-hooks.ts` and are imported by the new S7 sibling rather than moved with S7), the message-stream housekeeping rule (`keepOnlyLatestPalsContextMessage` mutates the array; the existing call site in `pals-hooks.ts` stays explicit), the allowed Phase 254 sibling shape (`drivers/pi/extensions/pals-context-injection.ts` following the S5/S1/S2/S3 sibling-module recipe with the loader-compat no-op default factory carrying the literal `No-op Pi extension factory` JSDoc phrase), the forbidden scope, the Phase 254 handoff, and the acceptance checklist.
- **S7 promoted to bounded Phase 254 contract target:** the `do not extract before guided-workflow evidence semantics are stable` precondition recorded in the S7 row above is satisfied by v2.58 closure (Phases 249–252; PRs #164/#165/#166/#167; Pi 227/227, cross-harness 135/135, install 5 Pi extension files). Phase 254 will be the first source-changing step.
- **S4/S6/S8 deferrals preserved:** the contract explicitly forbids extracting or modifying S4 canonical-reply delivery, S6 lifecycle UI, and S8 command routing as part of S7 work. Previously extracted siblings (S5, S1, S2, S3) are also forbidden from re-extraction or modification.
- **Validation baseline preserved:** Pi 227/227, cross-harness 135/135, artifact_consistency PASS, install 5 files, `git diff --check` clean. Phase 253 is docs-only.

## Phase 254 Outcome

Phase 254 extracted S7 `pals-context-injection` to `drivers/pi/extensions/pals-context-injection.ts`, applying the S5/S1/S2/S3 sibling-module recipe a fifth time while keeping S4 canonical reply delivery inline.

- **S7 extracted / S4 retained:** `pals-context-injection.ts` (88 LOC) now owns the six S7 functions (`buildPalsContextPayload`, `shouldInjectPalsContext`, `isPalsContextMessage`, `isLegacyPalsContextMessage`, `keepOnlyLatestPalsContextMessage`, `messagesChanged`) and the six S7 constants as exact-string single-defined markers (`PRIMARY_INJECTION_EVENT`, `SUPPORTING_CONTEXT_EVENT`, `PALS_CONTEXT_CUSTOM_TYPE`, `LEGACY_PALS_CONTEXT_HEADER`, `STATE_AUTHORITY_TAG`, `ACTIVATION_SIGNAL_TAG`); the loader-compat no-op default factory carries the literal `No-op Pi extension factory` JSDoc phrase. `pals-hooks.ts` reduced 947 → 903 LOC by importing the six S7 functions and six S7 constants from `./pals-context-injection` and exporting `ActivationState` for the sibling's type-import; S4 canonical reply delivery (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`) and shared helpers (`extractTextContent`, `collectRecentAssistantTexts`) remain in `pals-hooks.ts`.
- **Type-only back-import pattern:** the new sibling type-imports `ActivationState` and `PalsStateSnapshot` from `./pals-hooks` while value-importing only `renderArtifactSlices` from `./artifact-slice-rendering` and `renderWorkflowResourceCapsules` from `./workflow-resource-capsule-rendering`; the back-import is erased at runtime so the dependency graph stays acyclic.
- **TAP-assertion repoint pattern:** when a constant *definition* moves into a sibling, pre-existing TAP definition-string assertions are repointed to imported-identifier assertions in the same plan-scope file as a bounded, no-net-count-change reconciliation (Phase 254 repointed pre-existing assertion 133 from the conjunct `'PRIMARY_INJECTION_EVENT = "before_agent_start"'` definition string to the `'PRIMARY_INJECTION_EVENT'` imported-identifier reference in `tests/pi-end-to-end-validation.sh`).
- **S7/S4 split preserved:** Phase 254 did not extract S4, S6, or S8; it did not change installer/uninstaller/driver manifest, dependencies, CI, telemetry, hidden state, or lifecycle authority.
- **Sibling-module pattern extended:** S5 (`module-activity-parsing.ts`) + S1 (`artifact-slice-rendering.ts`) + S2 (`workflow-resource-capsule-rendering.ts`) + S3 (`guided-workflow-detection.ts`) + S7 (`pals-context-injection.ts`) now share the extracted sibling shape, including helper imports from `./pals-hooks`, single-defined owned markers, and the no-op default factory loader-compat invariant.
- **Validation evidence:** install reports `[ok] Pi extensions installed: 6 files` (5 → 6); Pi validation passed `228/228` (227 → 228 with the bounded `EXT_PALS_CONTEXT_INJECTION` TAP block plus the in-flight repoint of pre-existing assertion 133); cross-harness validation passed `135/135` unchanged; artifact_consistency PASS; `git diff --check` clean. PR #169 squash-merged 2026-05-04 as `af1c1793`.

## Phase 257 Outcome

Phase 257 promoted S6 `lifecycle-ui` from "should not be extracted before S1/S5 prove the pattern" to a bounded Phase 258 contract target without modifying runtime, source, tests, install, dependencies, CI, or lifecycle authority. The S5/S1/S2/S3/S7 extraction history above remains authoritative verbatim; this section records the Phase 257 promotion only.

- **S6 promoted to bounded Phase 258 contract target:** S6 moved from the deferred classification in the table above to a v2.60 extraction target after S5/S1/S2/S3/S7 stability was demonstrated. Phase 258 will be the first source-changing step.
- **Phase 258 boundary defined** via `docs/PI-NATIVE-LIFECYCLE-UI-EXTRACTION-CONTRACT.md`: eight S6 functions (`renderLifecycleStatus`, `renderLifecycleWidget`, `renderLoopBadge`, `renderCompactLoopSummary`, `renderLifecycleActionLabel`, `renderModuleActivity`, `renderModuleActivityDetails`, `syncLifecycleUi`); two S6 constants (`PALS_STATUS_ID`, `PALS_WIDGET_ID`) as exact-string single-defined runtime UI-element identifiers (both equal to `"pals-lifecycle"`); type-only back-imports for `PalsStateSnapshot` (from `./pals-hooks`) and `RecentModuleActivity` (from `./module-activity-parsing`) per the Phase 254 type-only back-import precedent; value-import only `compactWhitespace` from `./pals-hooks`; loader-compat no-op default factory carrying the literal `No-op Pi extension factory` JSDoc phrase; every existing `syncLifecycleUi(ctx)` call site preserved by call shape; install surface 6 → 7 Pi extension files; TAP-assertion repoint discipline applied.
- **First runtime-coupled extraction:** S6 is the first sibling that mutates Pi state (through `ctx?.ui?.setStatus(PALS_STATUS_ID, …)` and `ctx?.ui?.setWidget(PALS_WIDGET_ID, …)`) rather than purely producing strings. The contract reinforces preservation of every existing `syncLifecycleUi(ctx)` invocation in `pals-hooks.ts` and the no-UI-only-lifecycle-decisions invariant.
- **No-UI-only-lifecycle-decisions invariant reinforced:** the contract requires the new S6 sibling to render UI from authoritative `.paul/*` and module-activity inputs only — it MUST NOT introduce any path where the UI drives lifecycle state. UI is a render of `PalsStateSnapshot` and `RecentModuleActivity`, never an authority for lifecycle decisions.
- **S4/S8 deferrals preserved:** the Phase 257 contract explicitly forbids extracting or modifying S4 canonical-reply delivery and S8 command routing as part of S6 work. Previously extracted siblings (S5, S1, S2, S3, S7) are also forbidden from re-extraction or modification.
- **Phase 257 is docs-only:** no `drivers/pi/extensions/*.ts`, `tests/*.sh`, installer, dependency, CI, module registry, kernel workflow source, Claude Code driver, Agent SDK driver, or installed runtime copy is modified. The validation baseline at the close of Phase 257 remains Pi 231/231, cross-harness 136/136, artifact_consistency PASS, install 6 Pi extension files (the v2.59 closure baseline).
## Phase 258 Outcome

Phase 258 extracted S6 `lifecycle-ui` to `drivers/pi/extensions/lifecycle-ui.ts`, applying the S5/S1/S2/S3/S7 sibling-module recipe a sixth time and ratifying the Phase 254 type-only back-import, TAP-assertion repoint, and `inline → export` promotion patterns each a second time, while keeping S4 canonical reply delivery inline.

- **S6 extracted / S4 retained:** `lifecycle-ui.ts` (123 LOC) now owns the eight S6 functions (`renderLoopBadge`, `renderCompactLoopSummary`, `renderLifecycleActionLabel`, `renderModuleActivity`, `renderModuleActivityDetails`, `renderLifecycleStatus`, `renderLifecycleWidget`, `syncLifecycleUi`) and the two S6 constants as exact-string single-defined runtime UI-element identifiers (`PALS_STATUS_ID = "pals-lifecycle"` and `PALS_WIDGET_ID = "pals-lifecycle"`); the loader-compat no-op default factory carries the literal `No-op Pi extension factory` JSDoc phrase. `pals-hooks.ts` reduced 903 → 832 LOC by importing the eight S6 functions and two S6 constants from `./lifecycle-ui` and promoting four currently-inline S6-supporting symbols to exports (`MAX_VISIBLE_MODULES`, `RECENT_MODULE_ACTIVITY_LOOKBACK`, `parsePalsState`, `collectRecentAssistantTexts` — only the `export` keyword added; bodies unchanged); S4 canonical reply delivery (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`) and shared helpers (`extractTextContent`, `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `extractLoopSignature`, `PalsStateSnapshot`, `ActivationState`, `MAX_WIDGET_MODULE_DETAILS`) remain in `pals-hooks.ts`.
- **Type-only back-import pattern ratified a second time:** the new sibling type-imports `PalsStateSnapshot` from `./pals-hooks` and `RecentModuleActivity` from `./module-activity-parsing` while value-importing only what the moved S6 code calls; the back-import is erased at runtime so the dependency graph stays acyclic.
- **TAP-assertion repoint pattern ratified a second time:** five pre-existing TAP assertions naming moved S6 source paths against `$EXT_SRC` / `$EXT_SRC_P64` were repointed in-place to `$EXT_LIFECYCLE_UI` as a no-net-count-change reshape (TAP blocks #128, #130, #160 plus the two `renderLoopBadge` blocks) alongside one new `EXT_LIFECYCLE_UI` source-shape guardrail (`+1` net: 231 → 232).
- **`inline → export` promotion pattern ratified a second time:** four-symbol scaling versus Phase 254's single-symbol `ActivationState` promotion (`MAX_VISIBLE_MODULES`, `RECENT_MODULE_ACTIVITY_LOOKBACK`, `parsePalsState`, `collectRecentAssistantTexts` — each gained only the `export` keyword; bodies unchanged).
- **Helper-import tightening (Phase 246) applied:** the new sibling omits `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `extractLoopSignature`, `extractTextContent` because the moved S6 code does not reference them.
- **All five existing `syncLifecycleUi(ctx)` call sites preserved by call shape** (lines 770, 777, 803, 808, 820 in `pals-hooks.ts`); no signature change; no runtime semantics drift.
- **No-UI-only-lifecycle-decisions invariant verified shipped:** `lifecycle-ui.ts` performs no `.paul/*` writes, no `pi.sendUserMessage` calls, and no S4 canonical-reply identifier invocations. UI rendering is a strict derivation of authoritative `.paul/*` and module-activity inputs.
- **S6/S4 split preserved:** Phase 258 did not extract S4 or S8; it did not change installer/uninstaller/driver manifest, dependencies, CI, telemetry, hidden state, lifecycle authority, or any previously extracted sibling.
- **Sibling-module pattern extended:** S5 (`module-activity-parsing.ts`) + S1 (`artifact-slice-rendering.ts`) + S2 (`workflow-resource-capsule-rendering.ts`) + S3 (`guided-workflow-detection.ts`) + S7 (`pals-context-injection.ts`) + S6 (`lifecycle-ui.ts`) now share the extracted sibling shape, including helper imports from `./pals-hooks`, single-defined owned markers, and the no-op default factory loader-compat invariant.
- **Validation evidence:** install reports `[ok] Pi extensions installed: 7 files` (6 → 7); Pi validation passed `232/232` (231 → 232 with the bounded `EXT_LIFECYCLE_UI` TAP block plus the in-flight repoint of 5 pre-existing assertions); cross-harness validation passed `136/136` unchanged; artifact_consistency PASS; `git diff --check` clean. PR #173 squash-merged 2026-05-06 as `1531e47a`.
- **Still-deferred surfaces:** S4 canonical reply delivery (never extraction candidate while siblings are being shipped) and S8 command routing remain inline in `pals-hooks.ts`.

## Phase 261 Outcome

Phase 261 promoted S8 `command-routing` from "Deferred; highest user-visible command/shortcut surface" to a bounded Phase 262 contract target without modifying runtime, source, tests, install, dependencies, CI, or lifecycle authority. The S1–S8 inventory, classification table, and Phase 239/243/246/249/250/253/254/257/258 outcomes above remain authoritative verbatim; this section surfaces the Phase 261 addition only.

- **S8 contract created:** `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md` defines the four cited S8 functions (`getCommand`, `toWrapperCommand`, `detectCommandSignal`, `getQuickActions`); the cited `COMMANDS` top-level constant catalogued with all twelve entries verbatim (`paul-init`, `paul-plan`, `paul-apply`, `paul-unify`, `paul-resume`, `paul-status`, `paul-fix`, `paul-pause`, `paul-milestone`, `paul-discuss`, `paul-help`, `paul-review`, each with exact `name` / `description` / `skill` / `guidance` byte sequences); the closure-routing surface (`routeCommand`, `routeWrapperCommand`, `registerQuickActionShortcut`); the four command-routing constants as exact-string single-defined values (`COMMAND_ACTIVATION_TURN_BUDGET = 3`, `PROMPT_ACTIVATION_TURN_BUDGET = 1`, `PRIMARY_QUICK_ACTION_LIMIT = 3`, `MAX_QUICK_ACTIONS = 5`); the two top-level inline types (`CommandDef`, `QuickActionDef`); the shared-input disposition (`compactWhitespace` and `parsePalsState` value-imported from `./pals-hooks`; `markActivation` value-imported from `./pals-hooks` after the third application of the Phase 258 `inline → export` promotion pattern; `ActivationState` and `PalsStateSnapshot` type-only back-imported from `./pals-hooks` per the Phase 254 type-only back-import precedent now ratified twice); the Pi-runtime mutation invocation rule (the `for (const cmd of COMMANDS) { pi.registerCommand(cmd.name, { description, handler: async (args, ctx) => { carlState.stashedCmdCtx = ctx; routeCommand(cmd.name, args, ctx); } }) }` loop and the five `registerQuickActionShortcut(Key.ctrlAlt("n" | "s" | "r" | "h" | "m"), ...)` invocations stay byte-for-byte inside `registerPalsLifecycleHooks` in `pals-hooks.ts`); the canonical `/paul-*` → `/skill:paul-*` routing rule with the exact `routeCommand` body; the allowed Phase 262 sibling shape (`drivers/pi/extensions/command-routing.ts` following the S5/S1/S2/S3/S7/S6 sibling-module recipe with the loader-compat no-op default factory carrying the literal `No-op Pi extension factory` JSDoc phrase); the forbidden scope (S4 canonical reply delivery and previously extracted siblings); the Phase 262 handoff; and the acceptance checklist.
- **S8 promoted to bounded Phase 262 contract target:** the `should not be the first spike` precondition recorded in the S8 row above is satisfied by the S5/S1/S2/S3/S7/S6 extraction wave shipping with byte-sequence preservation discipline (Phase 258 preserved the literal `pals-lifecycle` UI-element identifier exactly through the S6 move). Phase 262 will be the first source-changing step.
- **Disposition A (preferred) vs Disposition B (safe fallback) recorded:** Disposition A is the default — the closure factories `routeCommand` / `routeWrapperCommand` / `registerQuickActionShortcut` move to the new sibling as exported factory functions, while the registration loop and the five Ctrl+Alt invocation sites stay in `pals-hooks.ts`. Disposition B keeps the closure factories inline if Disposition A surfaces unexpected closure-state coupling. Phase 262 SUMMARY MUST record which disposition was used and why.
- **Eleven-vs-twelve `CMD_COUNT` known mismatch flagged:** `tests/pi-end-to-end-validation.sh` line 792 currently asserts `CMD_COUNT == 11` over `EXPECTED_SKILLS` lines 48–58 (eleven entries) while the live `COMMANDS` array has twelve entries (the `detectCommandSignal` regex literal at line 226 of `pals-hooks.ts` already enumerates all twelve). The contract requires Phase 262 to surface this discrepancy from command output as a deliberate count reconciliation (either repointing the assertion or extending `EXPECTED_SKILLS` to twelve), not an incidental edit; the choice MUST be reported in the Phase 262 SUMMARY.
- **TAP-assertion repoint discipline applied:** four known repoint candidates identified (line-815 `PRIMARY_QUICK_ACTION_LIMIT`/`MAX_QUICK_ACTIONS` guardrail, line-814 shortcut-count guardrail, line-799 registration-count guardrail, line-792 `CMD_COUNT == 11` assertion); the discipline is byte-equivalent, not paraphrased.
- **S4 deferral preserved:** the Phase 261 contract explicitly forbids extracting or modifying S4 canonical-reply delivery as part of S8 work. Previously extracted siblings (S5, S1, S2, S3, S7, S6) are also forbidden from re-extraction or modification. The S4/S8 separation is structurally clean: S4 sends canonical workflow replies in response to displayed guided-workflow moments; S8 sends canonical skill routing in response to `/paul-*` command activations. Both flow through `pi.sendUserMessage` but at different invocation sites for different purposes.
- **No-UI-only-lifecycle-decisions invariant reinforced:** every `/paul-*` activation MUST continue to result in exactly one `pi.sendUserMessage(skillCmd)` invocation flowing through normal user-message delivery — no auto-approval, no auto-continue, no skipped checkpoints, no inferred merge intent, no merge-anyway path.
- **Phase 261 is docs-only:** no `drivers/pi/extensions/*.ts`, `tests/*.sh`, installer, dependency, CI, module registry, kernel workflow source, Claude Code driver, Agent SDK driver, or installed runtime copy is modified. The validation baseline at the close of Phase 261 is reconciled from command output: Pi 234/235 (the inherited `not ok 98` ROADMAP active-window line-budget regression from the v2.61 milestone-creation commit `63607289` is unchanged by Phase 261), cross-harness 136/137 (the inherited `not ok 31` same root cause is unchanged by Phase 261), artifact_consistency PASS, install 7 Pi extension files. The inherited regression is flagged for Phase 264 / v2.62 reconciliation.

## Phase 262 Outcome

Phase 262 extracted S8 `command-routing` to `drivers/pi/extensions/command-routing.ts`, applying the S5/S1/S2/S3/S7/S6 sibling-module recipe a seventh time and ratifying the Phase 254 type-only back-import, TAP-assertion repoint, and `inline → export` promotion patterns each a third time, while keeping S4 canonical reply delivery inline.

- **S8 extracted / S4 retained:** `command-routing.ts` (230 LOC) now owns the twelve-entry `COMMANDS` array verbatim with all `paul-*` `name` / `description` / `skill` / `guidance` byte sequences preserved, the four exported S8 functions (`getCommand`, `toWrapperCommand`, `detectCommandSignal`, `getQuickActions`), the three closure factories under Disposition A (`makeRouteCommand`, `makeRouteWrapperCommand`, `makeRegisterQuickActionShortcut` — moved as exported factory functions), the four command-routing constants exact-string single-defined (`COMMAND_ACTIVATION_TURN_BUDGET = 3`, `PROMPT_ACTIVATION_TURN_BUDGET = 1`, `PRIMARY_QUICK_ACTION_LIMIT = 3`, `MAX_QUICK_ACTIONS = 5`), the two exported types (`CommandDef`, `QuickActionDef`), and the loader-compat no-op default factory carrying the literal `No-op Pi extension factory` JSDoc phrase. `pals-hooks.ts` reduced 832 → 672 LOC by importing the moved S8 surface from `./command-routing` and promoting four currently-inline activation-state symbols (`let activationState` to module-private and `markActivation` / `getActiveActivation` / `consumeActivationTurn` to top-level `export function` — bodies unchanged); S4 canonical reply delivery (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`) and shared helpers (`extractTextContent`, `compactWhitespace`, `parsePalsState`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `extractLoopSignature`, `extractRecentModuleActivity`, `formatModuleEntryList`, `collectRecentAssistantTexts`, `formatCarlContextPressure`, `MAX_VISIBLE_MODULES`, `RECENT_MODULE_ACTIVITY_LOOKBACK`, `MAX_WIDGET_MODULE_DETAILS`, `ACTIVATION_WINDOW_MS`, `PalsStateSnapshot`, `ActivationState`, `RecentModuleActivity`) remain in their existing source locations.
- **Type-only back-import pattern ratified a third time:** the new sibling type-imports `ActivationState` and `PalsStateSnapshot` both from `./pals-hooks`; the back-import is erased at runtime so the dependency graph stays acyclic.
- **TAP-assertion repoint pattern ratified a third time** (4 named + 4 collateral byte-equivalent repoints + 1 new bounded `EXT_COMMAND_ROUTING` source-shape block + 2 in-place predicate adjustments): line-792 `CMD_COUNT == 11 → 12` with `paul-review` added to `EXPECTED_SKILLS` repointed to `EXT_COMMAND_ROUTING`; line-808 split with shortcut count staying at `EXT_SRC` and `Ctrl+Alt+N` hint repointed to `EXT_COMMAND_ROUTING`; line-815 quick-action constants repointed to `EXT_COMMAND_ROUTING`; line-814+799 ctrl+alt count and `registerCommand` count staying at `EXT_SRC`; plus 4 collateral repoints — `canonical /skill:paul-` guidance repointed to `EXT_COMMAND_ROUTING`, `markActivation("command"...)` + `COMMAND_ACTIVATION_TURN_BUDGET` repointed to `EXT_COMMAND_ROUTING` (with `ACTIVATION_SIGNAL_TAG` staying at `EXT_SRC`), `confirm/select` + `sendUserMessage` staying at `EXT_SRC` with `approved` repointed to `EXT_COMMAND_ROUTING` / `EXT_GUIDED_WORKFLOW_DETECTION`, `routing now ... "success"` repointed to `EXT_COMMAND_ROUTING`. Two in-place predicate adjustments (`SKILL_COUNT 11 → 12`; `paul-review references workflow files` widened to allow `subagent` / `Canonical references` because paul-review wraps a `code-reviewer` subagent rather than a kernel workflow).
- **`inline → export` promotion pattern ratified a third time** (4 symbols moving together — first time the closed-over `let` is moved alongside three closure functions in lockstep): `let activationState` (module-private) plus `markActivation` / `getActiveActivation` / `consumeActivationTurn` (top-level `export function`) with bodies unchanged. This establishes the durable rule: if `body unchanged` is required on a closure that closes over a `let`, the `let` and all sibling closures over the same `let` MUST move together.
- **Helper-import tightening (Phase 246) applied:** the new sibling imports only `compactWhitespace` value-side from `./pals-hooks`; `parsePalsState`, `markActivation`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `extractTextContent`, `collectRecentAssistantTexts`, `extractLoopSignature` are deliberately omitted because Disposition A's factory parameter pattern threads `markActivation` through the factory dependency, and the moved S8 code does not reference the others.
- **Disposition A shipped (full sibling extraction with closure factories moved as factory functions):** `makeRouteCommand` / `makeRouteWrapperCommand` / `makeRegisterQuickActionShortcut` moved to the new sibling as exported factory functions; the registration loop and the five `Key.ctrlAlt("[nsrhm]")` invocation sites stay byte-for-byte inside `registerPalsLifecycleHooks` in `pals-hooks.ts`. Disposition B safe fallback was not needed because the closure-state coupling threaded cleanly through factory dependency parameters (`pi`, `markActivation`, `routeCommand`).
- **Eleven-vs-twelve `CMD_COUNT` reconciliation 11 → 12** with `paul-review` added to `EXPECTED_SKILLS` as a deliberate count change reported in the Phase 262 SUMMARY (driven by the contract's reconciliation intent rather than silent expansion).
- **+5 vs planned +1 Pi count delta reconciled as bounded discovery:** `EXPECTED_SKILLS` + `paul-review` ripples through the line-223 per-skill loop +4 `paul-review` iterations, plus +1 from the new `EXT_COMMAND_ROUTING` source-shape block.
- **No-UI-only-lifecycle-decisions invariant verified shipped:** `command-routing.ts` performs no `.paul/*` writes, no `pi.sendUserMessage` calls outside the `routeCommand` factory body, and no S4 canonical-reply identifier invocations.
- **Byte-for-byte preserved Pi-runtime mutation invocation sites:** the 12-iteration registration loop (`for (const cmd of COMMANDS) { pi.registerCommand(cmd.name, ...) }`) and the five `Key.ctrlAlt("[nsrhm]")` invocations remain at the same call site in `pals-hooks.ts` (unchanged byte sequences).
- **S8/S4 split preserved:** Phase 262 did not extract S4; it did not change installer/uninstaller/driver manifest, dependencies, CI, telemetry, hidden state, lifecycle authority, or any previously extracted sibling.
- **Sibling-module pattern extended:** S5 + S1 + S2 + S3 + S7 + S6 + S8 (`module-activity-parsing.ts`, `artifact-slice-rendering.ts`, `workflow-resource-capsule-rendering.ts`, `guided-workflow-detection.ts`, `pals-context-injection.ts`, `lifecycle-ui.ts`, `command-routing.ts`) now share the extracted sibling shape, including helper imports from `./pals-hooks`, single-defined owned markers, and the no-op default factory loader-compat invariant. The per-sibling S1–S8 modularization wave is now closed except S4 (the integration point).
- **Validation evidence:** install reports `[ok] Pi extensions installed: 8 files` (7 → 8); Pi validation passed `239/240` (234/235 → 239/240; +5 with the bounded `EXT_COMMAND_ROUTING` TAP block + 4 paul-review per-skill iterations + 2 in-place predicate adjustments + 8 in-flight repointed pre-existing assertions; 1 inherited Path A `not ok 102` unchanged — was `not ok 98`, renumbered by `EXPECTED_SKILLS` expansion); cross-harness `136/137` unchanged with the inherited `not ok 31`; artifact_consistency PASS; `git diff --check` clean. PR #177 squash-merged 2026-05-07 as `19555747`.
- **Still-deferred surface:** S4 canonical reply delivery (the integration point; never an extraction candidate while siblings are being shipped through the per-sibling wave).

## Phase 239 Handoff

Phase 239 must plan inside the following bounds. Anything outside these bounds requires a separately approved later plan.

### Allowed file scope

- **Read + minimal edit (delegate to extracted module):** `drivers/pi/extensions/pals-hooks.ts`. Allowed edits are limited to importing the new module and calling into it; no behavior change.
- **New module file:** exactly one new file under `drivers/pi/extensions/`, named after the selected subsystem. Suggested location pattern: `drivers/pi/extensions/<selected-subsystem-name>.ts` (for the selected `module-activity-parsing` candidate, the suggested name is `drivers/pi/extensions/module-activity-parsing.ts`; Phase 239 may choose a sibling-equivalent name, but the file must live under `drivers/pi/extensions/`).
- **Validation guardrail (optional, bounded):** at most one localized Pi validation guardrail addition and at most one localized cross-harness guardrail addition, only if needed to protect the extracted module's external behavior. The contract permits up to **Pi `210→211`** and **cross-harness `124→125`**; any larger drift is out of scope.
- **Pi extension docs (optional, bounded):** updates limited to `drivers/pi/extensions/README.md` and/or `drivers/pi/skill-map.md` if the extracted module needs surface naming.
- **Lifecycle artifacts:** standard Phase 239 plan/SUMMARY/handoff/state metadata writes only.

### Forbidden in Phase 239 (out of scope)

- Refactoring any non-selected subsystem (S1, S2, S3, S4, S6, S7, S8).
- Changing `drivers/pi/install.sh`, `drivers/pi/uninstall.sh`, `drivers/pi/driver.yaml`, `drivers/claude-code/**`, `drivers/agent-sdk/**`, `kernel/**`, `modules/**`, `tests/helpers/tap.sh`, `tests/helpers/artifact_consistency.sh`, package manifests, lockfiles, CI configuration, or any non-`.paul/*` source of lifecycle truth.
- Adding telemetry, hidden runtime state, caches, generated ledgers, alternate validation/module/lifecycle/GitHub Flow ledger, or any analytics surface.
- Relaxing parent-owned APPLY, helper-delegation boundaries, lifecycle authority, module evidence, GitHub Flow gates, full authoritative read fallback, command-output truth, guided-workflow canonical reply semantics, no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, no inferred merge intent, or `.paul/*` artifact authority.
- Changing the `/paul-*` user-facing command surface, shortcut surface, or canonical reply set.

### Bounded validation count handoff

| Suite | Phase 238 baseline | Phase 239 cap |
|-------|--------------------|----------------|
| `tests/pi-end-to-end-validation.sh` | `1..210` / `# Passed: 210` | at most `1..211` / `# Passed: 211` |
| `tests/cross-harness-validation.sh` | `1..124` / `# Passed: 124` | at most `1..125` / `# Passed: 125` |

If Phase 239 evidence shows zero new guardrails are needed (pure refactor preserves all existing markers), the count remains exactly Pi `210/210` and cross-harness `124/124`. Either outcome is acceptable; larger drift is out of scope.

### Required Phase 239 evidence (risky tier)

- Focused marker check that the extracted module preserves `DISPATCH_MARKER` and `MODULE_REPORTS_HEADER` semantics.
- `bash -n` and behavior-preserving validation suites pass.
- Workguard report with allowed paths limited to the scope above; `outside_allowed=0`, `over_budget=false`.
- `git diff --check` clean.
- Parent-run official validation matches the Phase 239 reconciled count exactly; full authoritative read fallback preserved.
- Standard `.paul/*` lifecycle metadata writes; no helper-owned lifecycle writes.

## Validation Count Reconciliation

Phase 238 introduces zero new TAP assertions. Expected baselines after Phase 238 APPLY:

- Pi end-to-end validation: `1..210` / `# Passed: 210` (unchanged from Phase 237 baseline).
- Cross-harness validation: `1..124` / `# Passed: 124` (unchanged from Phase 237 baseline).
- Artifact consistency helper: `artifact_consistency_check: PASS` against current repo.

Phase 239 reconciliation is bounded above by Pi `210→211` and cross-harness `124→125`; see `## Phase 239 Handoff` for details.

## Out of Scope (Future Approved Plans Only)

- Extracting more than one subsystem in the Phase 239 spike.
- Cross-driver runtime modularization (`drivers/claude-code/**`, `drivers/agent-sdk/**`).
- New Pi UI affordances, banners, or guided-workflow surfaces beyond what currently exists.
- Schema redesign for any contract-protected surface (artifact slices, capsules, guided-workflow evidence, delegated APPLY packets/reports, validation classification).
- New telemetry or analytics surface in the Pi extension or any extracted module.
- Conversion of brittle prose checks elsewhere in the validation suites (ongoing future work, not Phase 238/239 scope).

---

*Created: Phase 238 / Plan 238-01.*
*Authority: Derived aid only; `.paul/*` artifacts and command-output truth remain authoritative lifecycle truth. `drivers/pi/extensions/pals-hooks.ts` is unchanged by this plan.*
