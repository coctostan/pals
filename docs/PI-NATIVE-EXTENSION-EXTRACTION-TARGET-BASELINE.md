# Pi-Native Extension Extraction Target Baseline

**Phase:** 242 Extension Extraction Target Baseline  
**Plan:** 242-01  
**Status:** Phase 250 extracted S3; Phase 251 documentation/validation surfacing baseline

## Purpose

This baseline chooses and bounds the next Pi extension submodule extraction wave from `drivers/pi/extensions/pals-hooks.ts`.

Phase 239 already extracted S5 `module-activity-parsing` into `drivers/pi/extensions/module-activity-parsing.ts`. Phase 241 then generalized the Pi extension install/uninstall surface so every repo-owned sibling `*.ts` file under `drivers/pi/extensions/` is installed by basename. Phase 243 can therefore extract one or more approved submodules without reopening installer or `driver.yaml` work unless contrary packaging evidence appears.

This document is a derived aid only. It is not lifecycle truth, validation truth, module truth, or GitHub Flow truth. Shared `.paul/*` artifacts, approved PLAN/APPLY/UNIFY artifacts, module reports, GitHub Flow command evidence, and validation command output remain authoritative.

## Evidence Base

- `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` — original S1-S8 inventory, risk/readiness classification, and preservation constraints.
- `.paul/phases/241-evidence-closure-next-roadmap-decision/241-01-SUMMARY.md` — confirms the generalized extension source-set install rule and records the `driver.yaml` audit decision.
- `drivers/pi/extensions/pals-hooks.ts` — current supported Pi runtime source and remaining subsystem host.
- `drivers/pi/extensions/module-activity-parsing.ts` — S5 extraction proof and sibling-module pattern.
- `drivers/pi/extensions/README.md` — Pi extension install boundary, command model, and derived-aid authority language.

## Current Extraction State

| Candidate | Current state | Phase 243 posture |
|-----------|---------------|-------------------|
| S1 `artifact-slice-rendering` | Extracted to `drivers/pi/extensions/artifact-slice-rendering.ts` (Phase 243 / PR #158) | Shipped — sibling-module pattern repeated |
| S2 `workflow-resource-capsule-rendering` | Extracted to `drivers/pi/extensions/workflow-resource-capsule-rendering.ts` (Phase 246 / PR #161) | Shipped — sibling-module pattern triple-confirmed |
| S3 `guided-workflow-detection` | Extracted to `drivers/pi/extensions/guided-workflow-detection.ts` (Phase 250 / PR #165) | Shipped — S3 detection sibling extracted; S4 canonical reply delivery retained in `pals-hooks.ts` |
| S4 `guided-workflow-canonical-reply` | Still inline in `pals-hooks.ts` | Deferred; runtime-coupled Pi message mutation |
| S5 `module-activity-parsing` | Already extracted to `module-activity-parsing.ts` | Not a Phase 243 extraction target |
| S6 `lifecycle-ui` | Still inline in `pals-hooks.ts`; promoted by Phase 257 to a bounded Phase 258 contract target via `docs/PI-NATIVE-LIFECYCLE-UI-EXTRACTION-CONTRACT.md` (no source change yet) | Bounded Phase 258 target after S5/S1/S2/S3/S7 prove the pattern; Pi UI mutation through `ctx`; consumes `PalsStateSnapshot` and `RecentModuleActivity` as type-only back-imports |
| S7 `pals-context-injection` | Extracted to `drivers/pi/extensions/pals-context-injection.ts` (Phase 254 / PR #169) | Shipped — type-only back-import + TAP-assertion repoint patterns ratified |
| S8 `command-routing` | Still inline in `pals-hooks.ts`; promoted by Phase 261 to a bounded Phase 262 contract target via `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md` (no source change yet) | Bounded Phase 262 target after S5/S1/S2/S3/S7/S6 prove the pattern; second runtime-coupled extraction after S6; Pi command/shortcut registration and user-message delivery; preserves twelve `/paul-*` command names, five Ctrl+Alt shortcut bindings, four command-routing constants, and the canonical `/paul-*` → `/skill:paul-*` routing rule byte-for-byte |

S5 is already extracted and remains the proof that a sibling extension module can preserve behavior when marker ownership and import boundaries are explicit.

## Approved Phase 243 Extraction Wave

Phase 243 may extract **one or more approved** candidates from this wave:

1. **S1 `artifact-slice-rendering` — approved primary.**
   - Strong pure candidate: build/render helpers consume state and filesystem reads, then return derived orientation text.
   - Key call chain from CODI: `buildArtifactSlice` → `renderArtifactSlices` → `buildPalsContextPayload` → `palsHooks`.
   - Required preservation markers:
     - `ARTIFACT_SLICE_SCHEMA_MARKERS`
     - `MAX_ARTIFACT_SLICE_CHARS`
     - `MAX_ARTIFACT_SLICE_LINES`
     - `ARTIFACT_SLICE_FALLBACK`
     - `ARTIFACT_SLICE_AUTHORITY`
     - visible schema strings: `Slice:`, `Source:`, `Freshness:`, `Bounds:`, `Content:`, `Fallback: full authoritative read`, `Authority: Derived aid only`

2. **S2 `workflow-resource-capsule-rendering` — approved primary, pairable with S1.**
   - Strong pure candidate: structurally similar to S1 and already contract-protected by the workflow/resource capsule contract.
   - Key call chain from CODI: `buildWorkflowResourceCapsule` → `renderWorkflowResourceCapsules` → `buildPalsContextPayload` → `palsHooks`.
   - Required preservation markers:
     - `WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS`
     - `MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS`
     - `MAX_WORKFLOW_RESOURCE_CAPSULE_LINES`
     - `WORKFLOW_RESOURCE_CAPSULE_FALLBACK`
     - `WORKFLOW_RESOURCE_CAPSULE_AUTHORITY`
     - visible schema strings: `Capsule:`, `Source:`, `Source type:`, `Freshness:`, `Bounds:`, `Content:`, `Fallback: full authoritative read`, `Authority: Derived aid only`

3. **S3 `guided-workflow-detection` — Phase 250 extracted outcome.**
   - Phase 250 moved S3 detection into `drivers/pi/extensions/guided-workflow-detection.ts` after S1/S2 stability made the contract-sensitive extraction reviewable.
   - It remains separate from S4 canonical-reply delivery: `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, and `shouldAutoPresent` stay in `pals-hooks.ts`.
   - Required preservation markers include `GUIDED_WORKFLOW_LOOKBACK`, `GUIDED_WORKFLOW_SIGNATURE_BYTES`, option parsing semantics, merge-gate routing detection, and no inferred merge intent.

S4, S6, S7, and S8 are not approved for Phase 243 extraction by default. They require a later plan or an explicit Phase 243 re-plan because they touch Pi message mutation, Pi UI mutation, authority/activation tags, or the user-facing command surface.

## Multi-Module Extraction Rule

Phase 243 may extract **one or more approved** candidates when all of the following are true:

- Each extracted module has a clear sibling file under `drivers/pi/extensions/`.
- Each module owns one coherent subsystem and preserves existing function names or call-site semantics through explicit imports.
- Exact marker strings remain single-defined or intentionally re-exported from the extracted module.
- The `pals-hooks.ts` diff is primarily imports plus calls into extracted helpers, not a behavior rewrite.
- The combined diff remains reviewable in one APPLY plan and can be verified with focused grep/marker checks plus full validation.
- The generalized install surface from Phase 241 covers the new sibling `*.ts` files without extra installer edits.

If S1 and S2 are extracted together, keep them either as two sibling modules (`artifact-slice-rendering.ts` and `workflow-resource-capsule-rendering.ts`) or as a clearly justified shared orientation-rendering boundary. Prefer two sibling modules unless shared helper extraction is necessary to avoid duplicated marker/fallback logic.

## Phase 243 Handoff

Recommended default Phase 243 scope:

- Extract S1 `artifact-slice-rendering` first.
- Extract S2 `workflow-resource-capsule-rendering` in the same plan only if S1's import/type boundary is straightforward and no extra installer, manifest, dependency, CI, or lifecycle-authority work is needed.
- Preserve S3 as an optional secondary candidate only if the S1/S2 pair is deliberately deferred.

Phase 243 should target repo source files only. It must not edit installed runtime copies under `~/.pi/agent/extensions/`. If APPLY needs runtime verification, it should run the repo installer after source changes rather than editing installed files directly.

Because Phase 241 generalized the install surface, Phase 243 does **not** need installer or `driver.yaml` edits solely because it adds a new sibling `*.ts` extension module under `drivers/pi/extensions/`. Reopen installer or manifest work only if fresh command-output or packaging evidence contradicts the Phase 241 audit decision.

## Preservation Boundaries

Any Phase 243 extraction must preserve:

- `.paul/*` artifact authority and full authoritative read fallback.
- PLAN/APPLY/UNIFY lifecycle ownership.
- Parent-owned APPLY verification, module gates, fallback judgment, checkpoints, GitHub Flow gates, and lifecycle writes.
- Module evidence and validation command-output truth.
- No hidden state, telemetry, generated lifecycle ledger, Pi-owned validation ledger, or cache-as-truth.
- No auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent.
- `Authority: Derived aid only` language on derived runtime orientation surfaces.
- Existing command names, shortcuts, canonical replies, and activation behavior unless a future approved plan explicitly targets those surfaces.

## Phase 243 Outcome

Phase 243 Plan 01 executed the approved primary candidate and closed the wave's first extraction:

- **S1 `artifact-slice-rendering` extracted** to `drivers/pi/extensions/artifact-slice-rendering.ts` per the Phase 239 S5 sibling-module precedent. Markers (`ARTIFACT_SLICE_SCHEMA_MARKERS`, `MAX_ARTIFACT_SLICE_CHARS=3000`, `MAX_ARTIFACT_SLICE_LINES=8`, the slice banner, the `Fallback: full authoritative read…` line, and the `Authority: Derived aid only…` line) are preserved single-defined in the new sibling.
- **S2 `workflow-resource-capsule-rendering` reserved** for a future approved plan (e.g., Plan 243-02 if scheduled); it remains inline in `pals-hooks.ts` and is not extracted by Phase 243.
- **Helpers exported from `drivers/pi/extensions/pals-hooks.ts`:** `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, and the type `PalsStateSnapshot`. Future S2-S8 sibling extractions import these helpers from `./pals-hooks` rather than duplicating them.
- **Canonical `default-arg cycle-avoidance` pattern:** any shared cap (e.g., `selectBoundedLines`'s `maxLines`) moves from a default-arg referencing a sibling-owned constant to a required parameter at the helper signature, with each call site passing its local cap explicitly. This eliminates the latent circular-import risk between `pals-hooks.ts` and any sibling module that owns the cap constant.
- **Install / validation evidence:** `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports `[ok] Pi extensions installed: 3 files`. Pi e2e: `1..214 / # Failed: 0`. Cross-harness: `1..127 / # Failed: 0`. `bash tests/helpers/artifact_consistency.sh` PASS. `git diff --check` clean. PR #158 merged 2026-05-02 (squash + delete-branch).

The approved-wave selection prose, preservation constraints, forbidden-scope rules, and validation expectations above remain in force verbatim — this section surfaces outcome only and does not re-litigate selection.

## Phase 246 Outcome

Phase 246 extracted the S2 `workflow-resource-capsule-rendering` subsystem from `drivers/pi/extensions/pals-hooks.ts` to a new sibling Pi extension module `drivers/pi/extensions/workflow-resource-capsule-rendering.ts` (192 LOC) following the Phase 239 S5 + Phase 243 S1 sibling-module pattern.

- **S2 `workflow-resource-capsule-rendering` extracted** — markers (`WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS`, `MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS=6_000`, `MAX_WORKFLOW_RESOURCE_CAPSULE_LINES=5`, the capsules banner, the `Fallback: full authoritative read…` line, and the `Authority: Derived aid only…` line) preserved single-defined in the new sibling.
- **Loader-compat invariant promoted to per-extraction acceptance criterion** — the loader-compat invariant (no-op default-exported factory + `No-op Pi extension factory` marker comment) was a Phase 245 closure-phase hotfix; it is now asserted inline in the Phase 246 extraction TAP guardrail, catching Pi extension-loader breakage at extraction time rather than at the next session start.
- **Sibling-module pattern triple-confirmed** — S5 (Phase 239) + S1 (Phase 243) + S2 (Phase 246) all follow the same shape: dedicated `drivers/pi/extensions/<name>.ts`, helpers imported from `./pals-hooks`, single-defined exact-marker exports, trailing no-op default-exported factory + marker comment.
- **Helper-import tightening** — extracted siblings import only the helpers they actually reference (e.g., the new S2 sibling imports `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines` and omits `escapeRegExp`/`PalsStateSnapshot` because they are unreferenced).
- **`pals-hooks.ts` shrank by 142 LOC** (1415 → 1273); shared helpers (`compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, type `PalsStateSnapshot`) remain defined and exported for future S3–S8 sibling extractions.
- **S3 `guided-workflow-detection` is deferred to v2.58 at the earliest** per the line-29 conditional-secondary classification (“larger and contract-sensitive, conditional secondary candidate only after S1/S2 bounds are stable”). Phase 246 stabilizes S2 but does not validate S3 readiness; the baseline says wait, and v2.57 honors that.
- **Validation evidence:** Pi `1..221/0`, cross-harness `1..129/0`, artifact_consistency PASS, install reports `[ok] Pi extensions installed: 4 files`, `git diff --check` clean. PR #161 merged 2026-05-02 (squash + delete-branch).

The approved-wave selection prose, preservation constraints, forbidden-scope rules, and validation expectations above remain in force verbatim — this section surfaces outcome only and does not re-litigate selection.

## Phase 249 Outcome

Phase 249 created the S3 `guided-workflow-detection` extraction contract and bounded submodule plan without modifying runtime, source, tests, install, dependencies, CI, or lifecycle authority.

- **S3 contract created:** `docs/PI-NATIVE-GUIDED-WORKFLOW-DETECTION-EXTRACTION-CONTRACT.md` defines the 10 S3 identifiers (`detectGuidedWorkflowMoment`, `parseGuidedWorkflowOptions`, `detectExplicitCanonicalResponse`, `isMergeGateRoutingPrompt`, `extractMergeGateRoutingSummary`, `makeGuidedWorkflowSignature`, `summarizeWorkflowPrompt`, `extractNextActionSummary`, `isValidOptionId`, `GUIDED_WORKFLOW_LOOKBACK`, `GUIDED_WORKFLOW_SIGNATURE_BYTES`), the governing safety contract (`docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`), allowed Phase 250 sibling-module shape, forbidden scope, and Phase 250 handoff with marker checks, install verification, validation commands, count reconciliation, and GitHub Flow evidence requirements.
- **S3 promoted from conditional secondary to bounded contract target:** v2.58 Phase 249 promotes S3 after S1/S2 stability was demonstrated by Phase 246. Phase 250 remains the first source-changing step.
- **S4/S6/S7/S8 deferrals preserved:** The contract explicitly forbids S4 canonical-reply delivery, S6 lifecycle UI, S7 context injection, and S8 command routing as part of S3 extraction work.
- **Validation baseline preserved:** Pi 223/223, cross-harness 131/131, artifact_consistency PASS, install 4 files, `git diff --check` clean.

The approved-wave selection prose, preservation constraints, forbidden-scope rules, and validation expectations above remain in force verbatim — this section surfaces outcome only and does not re-litigate selection.

## Phase 250 Outcome

Phase 250 completed the S3 extraction and updated the active baseline from “contract target” to shipped sibling:

- **S3 `guided-workflow-detection` extracted** to `drivers/pi/extensions/guided-workflow-detection.ts`; the sibling owns the detection/option parsing/merge-gate routing functions and constants named in the Phase 249 contract.
- **S3/S4 split preserved:** S4 canonical reply delivery remains in `drivers/pi/extensions/pals-hooks.ts`, including `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`, `pi.sendUserMessage`, and notify-only no-reply behavior.
- **S4/S6/S7/S8 deferrals preserved:** Phase 250 did not extract or modify canonical reply delivery, lifecycle UI, context injection, command routing, installer/uninstaller/driver manifest, dependency, CI, telemetry, hidden state, or lifecycle-authority surfaces.
- **Install / validation evidence:** `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reported `[ok] Pi extensions installed: 5 files`; Pi validation passed `224/224`; cross-harness validation passed `131/131`; artifact_consistency PASS; `git diff --check` clean. Pi count changed `223→224` due to one localized S3 extraction guardrail, and cross-harness stayed `131`.
- **GitHub Flow evidence:** PR #165 merged the Phase 250 implementation on 2026-05-02.

The approved-wave selection prose, preservation constraints, forbidden-scope rules, and validation expectations above remain historical context; this section records the Phase 250 outcome only and does not authorize reopening runtime behavior.

## Phase 253 Outcome

Phase 253 promoted S7 `pals-context-injection` from "do not extract before guided-workflow evidence semantics are stable" to a bounded contract target without modifying runtime, source, tests, install, dependencies, CI, or lifecycle authority. The S1/S2/S3/S5 extraction history above remains authoritative verbatim; this section records the Phase 253 promotion only.

- **S7 contract created:** `docs/PI-NATIVE-PALS-CONTEXT-INJECTION-EXTRACTION-CONTRACT.md` defines the S7 subsystem boundary (six functions: `buildPalsContextPayload`, `shouldInjectPalsContext`, `isPalsContextMessage`, `isLegacyPalsContextMessage`, `keepOnlyLatestPalsContextMessage`, `messagesChanged`; six constants as exact-string single-defined markers: `PRIMARY_INJECTION_EVENT`, `SUPPORTING_CONTEXT_EVENT`, `PALS_CONTEXT_CUSTOM_TYPE`, `LEGACY_PALS_CONTEXT_HEADER`, `STATE_AUTHORITY_TAG`, `ACTIVATION_SIGNAL_TAG`), the shared-helper retention rule for `extractTextContent` and `collectRecentAssistantTexts`, the message-stream housekeeping rule for `keepOnlyLatestPalsContextMessage`, the allowed Phase 254 sibling-module shape (`drivers/pi/extensions/pals-context-injection.ts`), the forbidden scope, and the Phase 254 handoff.
- **Precondition satisfied:** the v2.58 closure (Phases 249–252; PRs #164/#165/#166/#167; Pi 227/227, cross-harness 135/135, install 5 Pi extension files) stabilizes guided-workflow evidence semantics, satisfying the `do not extract before guided-workflow evidence semantics are stable` precondition recorded for S7.
- **S4/S6/S8 deferrals preserved:** the Phase 253 contract explicitly forbids extracting or modifying S4 canonical-reply delivery, S6 lifecycle UI, and S8 command routing as part of S7 work. Previously extracted siblings (S5, S1, S2, S3) are also forbidden from re-extraction or modification.
- **Phase 253 is docs-only:** no `drivers/pi/extensions/*.ts`, `tests/*.sh`, installer, dependency, CI, module registry, kernel workflow source, Claude Code driver, Agent SDK driver, or installed runtime copy is modified. The validation baseline at the close of Phase 253 remains Pi 227/227, cross-harness 135/135, artifact_consistency PASS, install 5 Pi extension files.

The approved-wave selection prose above remains historical context; Phase 254 is the first source-changing step authorized for S7.

## Phase 254 Outcome

Phase 254 executed the S7 extraction authorized by Phase 253, promoting `pals-context-injection` from contract target to shipped sibling and updating the active baseline accordingly:

- **S7 `pals-context-injection` extracted** to `drivers/pi/extensions/pals-context-injection.ts` (88 LOC); the sibling owns the six S7 functions and the six S7 constants single-located as exact-string markers (`PRIMARY_INJECTION_EVENT`, `SUPPORTING_CONTEXT_EVENT`, `PALS_CONTEXT_CUSTOM_TYPE`, `LEGACY_PALS_CONTEXT_HEADER`, `STATE_AUTHORITY_TAG`, `ACTIVATION_SIGNAL_TAG`), and carries the loader-compat no-op default factory with the literal `No-op Pi extension factory` JSDoc phrase.
- **`pals-hooks.ts` reduced 947 → 903 LOC** by importing the six S7 functions and six S7 constants from `./pals-context-injection` and exporting `ActivationState` for the sibling's type-import; S4 canonical reply delivery (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`) and shared helpers (`extractTextContent`, `collectRecentAssistantTexts`) remain in `pals-hooks.ts`.
- **Type-only back-import + TAP repoint patterns recorded:** the new sibling type-imports `ActivationState` and `PalsStateSnapshot` from `./pals-hooks` (erased at runtime, dependency graph stays acyclic); pre-existing TAP assertion 133 was repointed in `tests/pi-end-to-end-validation.sh` from the conjunct `'PRIMARY_INJECTION_EVENT = "before_agent_start"'` definition string to the imported-identifier reference `'PRIMARY_INJECTION_EVENT'` as a bounded, no-net-count-change reconciliation.
- **S4/S6/S8 deferrals preserved:** Phase 254 did not extract or modify canonical reply delivery, lifecycle UI, command routing, installer/uninstaller/driver manifest, dependency, CI, telemetry, hidden state, or lifecycle-authority surfaces. The new sibling enters the source set governed by `drivers/pi/install.sh` lines 88–112; broader `tests/cross-harness-validation.sh` size-debt remains deferred per v2.58 closure.
- **Install / validation evidence:** `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reported `[ok] Pi extensions installed: 6 files` (5 → 6); Pi validation passed `228/228` (227 → 228 with the bounded `EXT_PALS_CONTEXT_INJECTION` TAP block plus the in-flight repoint of pre-existing assertion 133); cross-harness validation passed `135/135` unchanged; artifact_consistency PASS; `git diff --check` clean.
- **GitHub Flow evidence:** PR #169 squash-merged the Phase 254 implementation on 2026-05-04 as `af1c1793`.

The approved-wave selection prose, preservation constraints, forbidden-scope rules, and validation expectations above remain historical context; this section records the Phase 254 outcome only and does not authorize reopening runtime behavior.

## Phase 254 Validation Expectations

Phase 254 must include focused source checks and full validation before the S7 sibling module is considered extracted:

- Grep/read checks that the six S7 constants (`PRIMARY_INJECTION_EVENT`, `SUPPORTING_CONTEXT_EVENT`, `PALS_CONTEXT_CUSTOM_TYPE`, `LEGACY_PALS_CONTEXT_HEADER`, `STATE_AUTHORITY_TAG`, `ACTIVATION_SIGNAL_TAG`) are defined exactly once in repo source after extraction (single-defined markers).
- Grep/read checks that the six S7 functions (`buildPalsContextPayload`, `shouldInjectPalsContext`, `isPalsContextMessage`, `isLegacyPalsContextMessage`, `keepOnlyLatestPalsContextMessage`, `messagesChanged`) are defined exactly once in repo source after extraction and that `drivers/pi/extensions/pals-hooks.ts` imports them from `./pals-context-injection`.
- Shared-helper retention check: `extractTextContent` and `collectRecentAssistantTexts` remain defined in `drivers/pi/extensions/pals-hooks.ts` (shared with S3 and S5).
- Explicit separation check: no S7 function is moved into or merged with S4 canonical-reply delivery (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`); S4 stays inline.
- `no inferred merge intent` marker remains present in contract and validation context.
- Repo-source-only changes: no direct edits to installed runtime copies under `~/.pi/agent/extensions/`.
- Install source-set proof: `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports 6 Pi extension files (current 5 + new sibling) in its installed file count.
- `bash tests/pi-end-to-end-validation.sh` — expected Phase 253 baseline: Pi 227/227.
- `bash tests/cross-harness-validation.sh` — expected Phase 253 baseline: cross-harness 135/135.
- `bash tests/helpers/artifact_consistency.sh` — must PASS.
- `git diff --check` — must be clean.

If validation counts differ from the Phase 253 baseline, the delta must be reconciled from command output in the Phase 254 SUMMARY with reason, validation class, and shared-invariant preservation rationale.

## Phase 257 Outcome

Phase 257 promoted S6 `lifecycle-ui` from "should not be extracted before S1/S5 prove the pattern" to a bounded Phase 258 contract target without modifying runtime, source, tests, install, dependencies, CI, or lifecycle authority. The S1/S2/S3/S5/S7 extraction history above remains authoritative verbatim; this section records the Phase 257 promotion only.

- **Precondition satisfied:** the S5/S1/S2/S3/S7 extraction wave (PRs #149/#157/#161/#165/#169) ratified the sibling-module recipe, including the type-only back-import pattern (Phase 254) and TAP-assertion repoint pattern (Phase 254). S6 is the first runtime-coupled extraction (mutates Pi UI through `ctx`), so the contract reinforces preservation of every existing `syncLifecycleUi(ctx)` call site and the no-UI-only-lifecycle-decisions invariant.
- **Phase 258 boundary defined** via `docs/PI-NATIVE-LIFECYCLE-UI-EXTRACTION-CONTRACT.md`: eight S6 functions (`renderLifecycleStatus`, `renderLifecycleWidget`, `renderLoopBadge`, `renderCompactLoopSummary`, `renderLifecycleActionLabel`, `renderModuleActivity`, `renderModuleActivityDetails`, `syncLifecycleUi`); two S6 constants (`PALS_STATUS_ID`, `PALS_WIDGET_ID`) as exact-string single-defined runtime UI-element identifiers; type-only back-imports for `PalsStateSnapshot` (from `./pals-hooks`) and `RecentModuleActivity` (from `./module-activity-parsing`); value-import only `compactWhitespace` from `./pals-hooks`; loader-compat no-op default factory carrying the literal `No-op Pi extension factory` JSDoc phrase; every existing `syncLifecycleUi(ctx)` call site preserved by call shape; install surface 6 → 7 Pi extension files; TAP-assertion repoint discipline applied.
- **S4/S8 deferrals preserved:** the Phase 257 contract explicitly forbids extracting or modifying S4 canonical-reply delivery and S8 command routing as part of S6 work. Previously extracted siblings (S5, S1, S2, S3, S7) are also forbidden from re-extraction or modification.
- **No-UI-only-lifecycle-decisions invariant reinforced:** the contract requires the new S6 sibling to render UI from authoritative `.paul/*` and module-activity inputs only — it MUST NOT introduce any path where the UI drives lifecycle state.
- **Phase 257 is docs-only:** no `drivers/pi/extensions/*.ts`, `tests/*.sh`, installer, dependency, CI, module registry, kernel workflow source, Claude Code driver, Agent SDK driver, or installed runtime copy is modified. The validation baseline at the close of Phase 257 remains Pi 231/231, cross-harness 136/136, artifact_consistency PASS, install 6 Pi extension files (the current v2.59 closure baseline).
## Phase 258 Outcome

Phase 258 executed the Phase 257 contract by extracting S6 `lifecycle-ui` to `drivers/pi/extensions/lifecycle-ui.ts`, ratifying the Phase 254 patterns each a second time, and promoting S6 from "contract target" to "shipped sibling" without disturbing any prior extracted sibling.

- **New sibling extracted:** `drivers/pi/extensions/lifecycle-ui.ts` (123 LOC) holds the eight S6 functions and two S6 constants in their single source of truth; the runtime UI-element identifier byte sequence `pals-lifecycle` is single-located in the new sibling as the right-hand side of both `PALS_STATUS_ID` and `PALS_WIDGET_ID`. `pals-hooks.ts` reduced 903 → 832 LOC.
- **Source-set rule auto-installed it:** `drivers/pi/install.sh` is unchanged; the Phase 241 generalized source-set rule over repo-owned `drivers/pi/extensions/*.ts` discovered the new sibling automatically. `drivers/pi/uninstall.sh` and `drivers/pi/driver.yaml` are unchanged. `~/.pi/agent/extensions/lifecycle-ui.ts` is now present.
- **S6 row promoted to "Shipped"** alongside S5 (Phase 239), S1 (Phase 243), S2 (Phase 246), S3 (Phase 250), and S7 (Phase 254) in the active extracted-sibling set.
- **Type-only back-import pattern ratified a second time** (`PalsStateSnapshot` from `./pals-hooks`, `RecentModuleActivity` from `./module-activity-parsing`); **TAP-assertion repoint pattern ratified a second time** (5 pre-existing assertions repointed to `$EXT_LIFECYCLE_UI` as a no-net-count-change reshape); **`inline → export` promotion pattern ratified a second time** (4 symbols: `MAX_VISIBLE_MODULES`, `RECENT_MODULE_ACTIVITY_LOOKBACK`, `parsePalsState`, `collectRecentAssistantTexts`); **helper-import tightening pattern (Phase 246) applied** (omits unused shared helpers); **no-UI-only-lifecycle-decisions invariant verified shipped**.
- **Validation baseline at the close of Phase 258:** Pi 232/232 (231 → 232 with the bounded `EXT_LIFECYCLE_UI` TAP block plus the in-flight repoint of 5 pre-existing assertions), cross-harness 136/136 unchanged, artifact_consistency PASS, install 7 Pi extension files (6 → 7), `git diff --check` clean. PR #173 squash-merged 2026-05-06 as `1531e47a`.
- **Still-deferred surfaces:** S4 canonical reply delivery and S8 command routing remain inline in `pals-hooks.ts`; broader cross-harness validation-script size-debt remains deferred per the v2.59 closure decision.
- **Phase 258 is source + test-only on the validation side:** the surfacing of the new sibling across user-facing Pi docs (root README, Pi extensions README, Pi skill-map), the modularization contract docs (this baseline + the modularization contract + the S6 contract), and the surfacing TAP guardrails belongs to Phase 259; the `+1` closure guardrail is reserved for Phase 260 evidence closure per the established sibling-surfacing recipe (Phases 244 / 247 / 251 / 255 / 259).

## Phase 261 Outcome

Phase 261 promoted S8 `command-routing` from "Deferred; highest user-visible command/shortcut surface" to a bounded Phase 262 contract target without modifying runtime, source, tests, install, dependencies, CI, or lifecycle authority. The S1/S2/S3/S5/S6/S7 extraction history above remains authoritative verbatim; this section records the Phase 261 promotion only.

- **Precondition satisfied:** the S5/S1/S2/S3/S7/S6 extraction wave (PRs #149/#157/#161/#165/#169/#173) ratified the sibling-module recipe with byte-sequence preservation discipline (Phase 258 preserved the literal `pals-lifecycle` UI-element identifier exactly through the S6 move). S8 is the second runtime-coupled extraction (registers commands and shortcuts on Pi, sends user messages, defines the user-facing `/paul-*` surface), so the contract reinforces preservation of every existing `/paul-*` command-registration call shape byte-for-byte and the no-UI-only-lifecycle-decisions invariant.
- **Phase 262 boundary defined** via `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md`: four cited S8 functions (`getCommand`, `toWrapperCommand`, `detectCommandSignal`, `getQuickActions`); `COMMANDS` top-level constant catalogued with all twelve entries verbatim (`paul-init`, `paul-plan`, `paul-apply`, `paul-unify`, `paul-resume`, `paul-status`, `paul-fix`, `paul-pause`, `paul-milestone`, `paul-discuss`, `paul-help`, `paul-review`); five `Key.ctrlAlt("[nsrhm]")` shortcut bindings preserved byte-for-byte; four command-routing constants as exact-string single-defined values (`COMMAND_ACTIVATION_TURN_BUDGET = 3`, `PROMPT_ACTIVATION_TURN_BUDGET = 1`, `PRIMARY_QUICK_ACTION_LIMIT = 3`, `MAX_QUICK_ACTIONS = 5`); two top-level types (`CommandDef`, `QuickActionDef`) with `export` after extraction; type-only back-imports for `ActivationState` (from `./pals-hooks`) and `PalsStateSnapshot` (from `./pals-hooks`); value imports for `compactWhitespace` and `parsePalsState` from `./pals-hooks`; the third application of the Phase 258 `inline → export` promotion pattern (for `markActivation`); loader-compat no-op default factory carrying the literal `No-op Pi extension factory` JSDoc phrase; the registration loop and the five Ctrl+Alt invocation sites stay byte-for-byte inside `registerPalsLifecycleHooks` in `pals-hooks.ts`; install surface 7 → 8 Pi extension files; TAP-assertion repoint discipline applied (four known repoint candidates: line-815 `PRIMARY_QUICK_ACTION_LIMIT`/`MAX_QUICK_ACTIONS` guardrail, line-814 shortcut-count guardrail, line-799 registration-count guardrail, line-792 `CMD_COUNT == 11` assertion).
- **Disposition A (preferred) vs Disposition B (safe fallback):** the contract specifies Disposition A as the default — the closure factories `routeCommand` / `routeWrapperCommand` / `registerQuickActionShortcut` move to the new sibling as exported factory functions, while the registration loop and the five Ctrl+Alt invocation sites stay in `pals-hooks.ts`. Disposition B keeps the closure factories inline if Disposition A surfaces unexpected closure-state coupling.
- **Eleven-vs-twelve `CMD_COUNT` known mismatch flagged:** `tests/pi-end-to-end-validation.sh` line 792 asserts `CMD_COUNT == 11` over `EXPECTED_SKILLS` lines 48–58 (eleven entries) while the live `COMMANDS` array has twelve entries; the contract requires Phase 262 to surface this discrepancy from command output as a deliberate count reconciliation, not an incidental edit.
- **S4 deferral preserved:** the Phase 261 contract explicitly forbids extracting or modifying S4 canonical-reply delivery (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`) as part of S8 work. Previously extracted siblings (S5, S1, S2, S3, S7, S6) are also forbidden from re-extraction or modification.
- **No-UI-only-lifecycle-decisions invariant reinforced:** the contract requires every `/paul-*` activation to continue resulting in exactly one `pi.sendUserMessage(skillCmd)` invocation flowing through normal user-message delivery — no auto-approval, no auto-continue, no skipped checkpoints, no inferred merge intent, no merge-anyway path.
- **Phase 261 is docs-only:** no `drivers/pi/extensions/*.ts`, `tests/*.sh`, installer, dependency, CI, module registry, kernel workflow source, Claude Code driver, Agent SDK driver, or installed runtime copy is modified. The validation baseline at the close of Phase 261 is reconciled from command output: Pi 234/235 (the inherited `not ok 98` ROADMAP active-window line-budget regression from the v2.61 milestone-creation commit `63607289` is unchanged by Phase 261), cross-harness 136/137 (the inherited `not ok 31` same root cause is unchanged by Phase 261), artifact_consistency PASS, install 7 Pi extension files. The inherited regression is flagged for Phase 264 / v2.62 reconciliation.

## Phase 257 Validation Expectations

Phase 257 must include focused doc-shape checks and full validation before the S6 contract is considered final:

- Grep/read checks that the new contract `docs/PI-NATIVE-LIFECYCLE-UI-EXTRACTION-CONTRACT.md` lists each of the eight S6 functions and each of the two S6 constants as a single explicit list, plus the shared-input disposition for `PalsStateSnapshot` and `RecentModuleActivity`, the Pi-UI-mutation invocation rule for `syncLifecycleUi`, the no-UI-only-lifecycle-decisions invariant, and the Phase 258 handoff acceptance checklist.
- Grep/read checks that the eight S6 functions and two S6 constants remain defined exactly as before in `drivers/pi/extensions/pals-hooks.ts` (no source change in Phase 257).
- Explicit separation check in the contract: no S6 function is moved into or merged with S4 canonical-reply delivery (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`); S4 stays inline.
- `no UI-only lifecycle decisions` and `no inferred merge intent` markers remain present in contract and validation context.
- Repo-source-only changes: no direct edits to installed runtime copies under `~/.pi/agent/extensions/`.
- Phase 257 is docs-only: install source-set count remains 6 Pi extension files; `bash tests/pi-end-to-end-validation.sh` — expected v2.59 closure baseline: Pi 231/231; `bash tests/cross-harness-validation.sh` — expected v2.59 closure baseline: cross-harness 136/136; `bash tests/helpers/artifact_consistency.sh` — must PASS; `git diff --check` — must be clean.

If validation counts differ from the v2.59 closure baseline, the delta must be reconciled from command output in the Phase 257 SUMMARY with reason, validation class, and shared-invariant preservation rationale.

## Phase 258 Validation Expectations

Phase 258 must include focused source checks and full validation before the S6 sibling module is considered extracted:

- Grep/read checks that the two S6 constants (`PALS_STATUS_ID`, `PALS_WIDGET_ID`) are defined exactly once in repo source after extraction (single-defined markers; both equal to `"pals-lifecycle"`).
- Grep/read checks that the eight S6 functions (`renderLifecycleStatus`, `renderLifecycleWidget`, `renderLoopBadge`, `renderCompactLoopSummary`, `renderLifecycleActionLabel`, `renderModuleActivity`, `renderModuleActivityDetails`, `syncLifecycleUi`) are defined exactly once in repo source after extraction and that `drivers/pi/extensions/pals-hooks.ts` imports them from `./lifecycle-ui`.
- Type-only back-import shape check: `import type { PalsStateSnapshot } from "./pals-hooks";` and `import type { RecentModuleActivity } from "./module-activity-parsing";` appear in the new sibling; runtime dependency graph stays acyclic.
- Shared-helper retention check: `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `extractTextContent`, `collectRecentAssistantTexts`, and `PalsStateSnapshot` remain defined in `drivers/pi/extensions/pals-hooks.ts`; `RecentModuleActivity` remains defined in `drivers/pi/extensions/module-activity-parsing.ts`.
- Explicit separation check: no S6 function is moved into or merged with S4 canonical-reply delivery; S4 stays inline.
- UI-mutation invocation-site preservation check: every existing `syncLifecycleUi(ctx)` call site in `pals-hooks.ts` is functionally identical (same call shape, same identifier, same single `ctx` argument); only the import source changes.
- No-UI-only-lifecycle-decisions invariant check: the new sibling MUST NOT introduce any path where the UI drives lifecycle state.
- `no inferred merge intent` marker remains present in contract and validation context.
- Repo-source-only changes: no direct edits to installed runtime copies under `~/.pi/agent/extensions/`.
- Install source-set proof: `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports 7 Pi extension files (current 6 + new sibling) in its installed file count.
- `bash tests/pi-end-to-end-validation.sh` — expected Phase 257 baseline: Pi 231/231.
- `bash tests/cross-harness-validation.sh` — expected Phase 257 baseline: cross-harness 136/136.
- `bash tests/helpers/artifact_consistency.sh` — must PASS.
- `git diff --check` — must be clean.
- TAP-assertion repoint discipline: any Pi or cross-harness assertion that names the source file/path of an S6 function or constant must be repointed to the new sibling.

If validation counts differ from the Phase 257 baseline, the delta must be reconciled from command output in the Phase 258 SUMMARY with reason, validation class, and shared-invariant preservation rationale.

## Phase 261 Validation Expectations

Phase 261 must include focused doc-shape checks and full validation before the S8 contract is considered final:

- Grep/read checks that the new contract `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md` lists each of the four cited S8 functions (`getCommand`, `toWrapperCommand`, `detectCommandSignal`, `getQuickActions`), enumerates all twelve `COMMANDS` entries with exact `name`/`description`/`skill`/`guidance` byte sequences, captures the registration loop / five Ctrl+Alt invocations / `routeCommand` body / `toWrapperCommand` translation rule / `detectCommandSignal` regex literal / `getQuickActions` priority order as literal code-fence blocks or fully-enumerated tables, names the four command-routing constants with exact-string values, names `CommandDef` and `QuickActionDef` as the two inline types, states the shared-input disposition for `compactWhitespace` / `parsePalsState` / `markActivation` / `ActivationState` / `PalsStateSnapshot`, states the Pi-runtime mutation invocation rule, states the canonical `/paul-*` → `/skill:paul-*` routing rule, states the explicit Disposition A vs Disposition B choice with Disposition A as the default, flags the eleven-vs-twelve `CMD_COUNT` known mismatch, and contains the Phase 262 handoff acceptance checklist.
- Grep/read checks that the four cited S8 functions, the `COMMANDS` array (twelve entries), the four command-routing constants, the five `Key.ctrlAlt("[nsrhm]")` shortcut bindings, the canonical regex in `detectCommandSignal`, and the `routeCommand` body remain defined exactly as before in `drivers/pi/extensions/pals-hooks.ts` (no source change in Phase 261).
- Explicit separation check in the contract: no S8 function is moved into or merged with S4 canonical-reply delivery; S4 stays inline; previously extracted siblings (S5, S1, S2, S3, S7, S6) are not re-extracted or modified.
- `no UI-only lifecycle decisions`, `no inferred merge intent`, and `transcript-visible canonical replies` markers remain present in contract and validation context.
- Repo-source-only changes: no direct edits to installed runtime copies under `~/.pi/agent/extensions/`.
- Phase 261 is docs-only: install source-set count remains 7 Pi extension files; `bash tests/pi-end-to-end-validation.sh` — expected reconciled-from-command-output baseline: Pi 234/235 (the inherited `not ok 98` ROADMAP active-window line-budget regression from commit `63607289` is unchanged by Phase 261, flagged for Phase 264 / v2.62 reconciliation); `bash tests/cross-harness-validation.sh` — expected reconciled-from-command-output baseline: cross-harness 136/137 (the inherited `not ok 31` same root cause is unchanged by Phase 261); `bash tests/helpers/artifact_consistency.sh` — must PASS; `git diff --check` — must be clean.

If validation counts differ from the Phase 261 reconciled baseline (i.e., a NEW failure is introduced beyond the two inherited ROADMAP-line-budget failures, or the install count changes from 7), the delta must be reconciled from command output in the Phase 261 SUMMARY with reason, validation class, and shared-invariant preservation rationale.

## Phase 262 Validation Expectations

Phase 262 must include focused source checks and full validation before the S8 sibling module is considered extracted:

- Grep/read checks that the four cited S8 functions (`getCommand`, `toWrapperCommand`, `detectCommandSignal`, `getQuickActions`) and the `COMMANDS` array (twelve entries) are defined exactly once in repo source after extraction and that `drivers/pi/extensions/pals-hooks.ts` imports them from `./command-routing` (Disposition A or B).
- Byte-sequence preservation checks: every `/paul-*` `name` / `description` / `skill` / `guidance` byte sequence in the moved `COMMANDS` array is unchanged from current `pals-hooks.ts` source; every `Key.ctrlAlt("[nsrhm]")` shortcut binding is unchanged; every command-routing constant value (`COMMAND_ACTIVATION_TURN_BUDGET = 3`, `PROMPT_ACTIVATION_TURN_BUDGET = 1`, `PRIMARY_QUICK_ACTION_LIMIT = 3`, `MAX_QUICK_ACTIONS = 5`) is unchanged; the `detectCommandSignal` regex literal is unchanged; the `routeCommand` body is unchanged; the `toWrapperCommand` translation rule is unchanged; the `getQuickActions` priority order (id/label/shortcutHint byte sequences and dedupe-then-cap order) is unchanged.
- Type-only back-import shape check: `import type { ActivationState } from "./pals-hooks";` and `import type { PalsStateSnapshot } from "./pals-hooks";` appear in the new sibling; runtime dependency graph stays acyclic.
- Value-import shape check: `compactWhitespace`, `parsePalsState`, and `markActivation` are imported value-side from `./pals-hooks` in the new sibling.
- `inline → export` promotion check (third application): `markActivation` is now a top-level exported function in `pals-hooks.ts` (was an inline closure inside `registerPalsLifecycleHooks`); body unchanged.
- Registration-site rule check: the `for (const cmd of COMMANDS) { pi.registerCommand(cmd.name, { description, handler: async (args, ctx) => { carlState.stashedCmdCtx = ctx; routeCommand(cmd.name, args, ctx); } }) }` loop and the five `registerQuickActionShortcut(Key.ctrlAlt(...), ...)` invocations stay byte-for-byte inside `registerPalsLifecycleHooks` in `pals-hooks.ts`.
- Disposition record: Phase 262 SUMMARY records whether Disposition A or Disposition B was used and why.
- Explicit separation check: no S8 function is moved into or merged with S4 canonical-reply delivery; S4 stays inline; previously extracted siblings (S5, S1, S2, S3, S7, S6) are not re-extracted or modified.
- Loader-compat invariant check: the new sibling exports `export default function (_pi: unknown): void {}` preceded by JSDoc carrying the literal `No-op Pi extension factory` phrase.
- `no UI-only lifecycle decisions` and `no inferred merge intent` markers remain present in contract and validation context.
- Repo-source-only changes: no direct edits to installed runtime copies under `~/.pi/agent/extensions/`.
- Install source-set proof: `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports 8 Pi extension files (current 7 + new sibling) in its installed file count.
- `bash tests/pi-end-to-end-validation.sh` — expected Phase 261 reconciled baseline (delta TBD from Phase 262 changes plus the `CMD_COUNT` reconciliation): Pi count moves from 234/235 by the net of any new EXT_COMMAND_ROUTING TAP additions, repointed assertions, and the 11→12 `CMD_COUNT` reconciliation.
- `bash tests/cross-harness-validation.sh` — expected Phase 261 reconciled baseline: cross-harness 136/137 unchanged by Phase 262.
- `bash tests/helpers/artifact_consistency.sh` — must PASS.
- `git diff --check` — must be clean.
- TAP-assertion repoint discipline: the line-815 `PRIMARY_QUICK_ACTION_LIMIT`/`MAX_QUICK_ACTIONS` guardrail, the line-814 shortcut-count guardrail, the line-799 registration-count guardrail, and the line-792 `CMD_COUNT == 11` assertion are repointed (or kept pointed at `pals-hooks.ts` per the contract's discipline) byte-equivalently, not paraphrased.

If validation counts differ from the Phase 261 baseline plus the deliberate Phase 262 reconciliations, the delta must be reconciled from command output in the Phase 262 SUMMARY with reason, validation class, and shared-invariant preservation rationale.

## Forbidden Scope for Phase 243 by Default

- S4 canonical reply delivery, unless a new approved plan specifically covers Pi message mutation.
- S6 lifecycle UI extraction, unless S1/S2/S5 boundaries prove the supporting parse/render dependencies first.
- S7 context-injection extraction, unless the plan protects `STATE_AUTHORITY_TAG`, `ACTIVATION_SIGNAL_TAG`, `LEGACY_PALS_CONTEXT_HEADER`, and `PALS_CONTEXT_CUSTOM_TYPE` exactly.
- S8 command routing extraction, unless a later plan focuses on command/shortcut compatibility.
- Installer, uninstall, or `driver.yaml` edits solely for new extension siblings.
- Dependency, CI, kernel, module registry, Claude Code driver, Agent SDK driver, or lifecycle artifact authority changes.

## Validation Expectations

A Phase 243 APPLY plan should include focused source checks and full validation:

- Grep/read checks that exact S1/S2 markers remain present in the expected source files.
- Checks that `drivers/pi/extensions/pals-hooks.ts` imports the extracted module(s) from repo sibling paths.
- Checks that new sibling `*.ts` modules are covered by the generalized install source set.
- `bash tests/pi-end-to-end-validation.sh`
- `bash tests/cross-harness-validation.sh`
- `bash tests/helpers/artifact_consistency.sh`
- `git diff --check`

If a future plan changes validation counts, it must reconcile the count change in its SUMMARY using command-output evidence.

## Phase 250 Validation Expectations

Phase 250 must include focused source checks and full validation before the S3 sibling module is considered extracted:

- Grep/read checks that all 10 S3 identifiers (`detectGuidedWorkflowMoment`, `parseGuidedWorkflowOptions`, `detectExplicitCanonicalResponse`, `isMergeGateRoutingPrompt`, `extractMergeGateRoutingSummary`, `makeGuidedWorkflowSignature`, `summarizeWorkflowPrompt`, `extractNextActionSummary`, `isValidOptionId`, `GUIDED_WORKFLOW_LOOKBACK`, `GUIDED_WORKFLOW_SIGNATURE_BYTES`) remain present in repo source after extraction.
- Explicit separation check: no S3 function is moved into or merged with S4 canonical-reply delivery (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`).
- `no inferred merge intent` marker remains present in contract and validation context.
- Repo-source-only changes: no direct edits to installed runtime copies under `~/.pi/agent/extensions/`.
- Install source-set proof: `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports the new sibling in its installed file count.
- `bash tests/pi-end-to-end-validation.sh` — expected Phase 249 baseline: Pi 223/223.
- `bash tests/cross-harness-validation.sh` — expected Phase 249 baseline: cross-harness 131/131.
- `bash tests/helpers/artifact_consistency.sh` — must PASS.
- `git diff --check` — must be clean.

If validation counts differ from the Phase 249 baseline, the delta must be reconciled from command output in the Phase 250 SUMMARY with reason, validation class, and shared-invariant preservation rationale.

## Deferred Candidates

- S3 is extracted and remains bounded to detection/option parsing/merge-gate routing in `guided-workflow-detection.ts`.
- S4 is still deferred because it sends canonical replies through Pi message flow.
- S6 is promoted to a bounded Phase 258 contract target via `docs/PI-NATIVE-LIFECYCLE-UI-EXTRACTION-CONTRACT.md`; it is the first runtime-coupled extraction (mutates Pi UI through `ctx`), the no-UI-only-lifecycle-decisions invariant remains the binding preservation rule, and `PalsStateSnapshot` + `RecentModuleActivity` consumption is constrained to type-only back-imports per the Phase 254 precedent.
- S7 is extracted to `drivers/pi/extensions/pals-context-injection.ts` (Phase 254 / PR #169) per `docs/PI-NATIVE-PALS-CONTEXT-INJECTION-EXTRACTION-CONTRACT.md`; the exact authority/activation tags (`STATE_AUTHORITY_TAG`, `ACTIVATION_SIGNAL_TAG`), the legacy-header migration path (`LEGACY_PALS_CONTEXT_HEADER`), and the custom-message-type identity (`PALS_CONTEXT_CUSTOM_TYPE`) remain the binding preservation rules and were not relaxed by this extraction.
- S8 is still deferred because command routing is the highest user-visible compatibility surface.

## Summary Decision

Phase 243's approved extraction wave was S1 + S2, with permission to extract **one or more approved** candidates if bounded reviewability and validation were preserved. S5 was already extracted. S3 was promoted by Phase 249 and extracted by Phase 250 into `guided-workflow-detection.ts` with S4 canonical reply delivery retained in `pals-hooks.ts`. S7 was promoted by Phase 253 and extracted by Phase 254 into `pals-context-injection.ts`. S6 was promoted by Phase 257 to a bounded Phase 258 contract target via `docs/PI-NATIVE-LIFECYCLE-UI-EXTRACTION-CONTRACT.md` (no source change yet). S4/S8 remain deferred by default; S4 is the integration point for every other sibling and is explicitly never an extraction candidate while siblings are still being shipped.
