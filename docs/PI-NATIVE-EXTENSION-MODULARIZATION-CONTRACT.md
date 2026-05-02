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
- **S3 promoted to bounded Phase 250 contract target:** S3 moves from the conditional-secondary classification in the table above to a v2.58 extraction target after S1/S2 stability was demonstrated. Phase 250 remains the first source-changing step.
- **S4/S6/S7/S8 deferrals preserved:** The contract explicitly forbids extracting or modifying S4 canonical-reply delivery, S6 lifecycle UI, S7 context injection, and S8 command routing as part of S3 work.
- **Validation baseline preserved:** Pi 223/223, cross-harness 131/131, artifact_consistency PASS, install 4 files, `git diff --check` clean.
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
