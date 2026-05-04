---
phase: 254-bounded-s7-submodule-extraction
plan: 01
completed: 2026-05-04T12:35:00Z
duration: ~25 minutes (single APPLY session, parent-inline execution)
---

## Objective

Extract the S7 `pals-context-injection` subsystem from `drivers/pi/extensions/pals-hooks.ts` into a new sibling Pi extension module `drivers/pi/extensions/pals-context-injection.ts` without changing the PALS context payload bytes, the injection-gating logic, the message-stream housekeeping behavior (filter `isLegacyPalsContextMessage` → normalize via `keepOnlyLatestPalsContextMessage` → gate via `messagesChanged`), the `before_agent_start` / `context` Pi event surface, or the `/paul-resume` consumer-visible authority/activation tag behavior.

This is the fifth application of the sibling Pi extension extraction recipe (S5 Phase 239 → S1 Phase 243 → S2 Phase 246 → S3 Phase 250 → S7 Phase 254), executed under the bounded Phase 254 contract ratified by Phase 253 (`docs/PI-NATIVE-PALS-CONTEXT-INJECTION-EXTRACTION-CONTRACT.md`, PR #168 merged 2026-05-03).

## What Was Built

| File | Purpose | Lines |
|------|---------|-------|
| `drivers/pi/extensions/pals-context-injection.ts` (new) | New sibling Pi extension that owns the S7 PALS context injection: 6 single-defined exact-string constants, 6 exported functions, loader-compat no-op default factory carrying the literal `No-op Pi extension factory` marker. | +88 |
| `drivers/pi/extensions/pals-hooks.ts` (modified) | Imports the 6 S7 functions and 6 S7 constants from `./pals-context-injection`; exports the `ActivationState` type so the sibling can type-import it; retains all S4 canonical-reply identifiers inline; retains shared helpers (`extractTextContent`, `collectRecentAssistantTexts`, `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `PalsStateSnapshot`); preserves all 5 S7 call sites functionally identical. | 947 → 903 (−44) |
| `tests/pi-end-to-end-validation.sh` (modified) | Adds 1 new `EXT_PALS_CONTEXT_INJECTION` TAP block proving the new sibling shape and `pals-hooks.ts` delegation; declares `EXT_PALS_CONTEXT_INJECTION` near the existing `EXT_*` declarations; repoints pre-existing assertion 133 (Phase 250 era) so it references the imported identifier `PRIMARY_INJECTION_EVENT` in `pals-hooks.ts` rather than its inline definition (which moved to the sibling per the planned extraction). | +37 / −1 |

Net: 1 new file + 2 modified files + 1 new commit (`fabcb696`) on `feature/254-bounded-s7-submodule-extraction`. All within the plan's `files_modified` scope.

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | S7 sibling module exists with single-defined markers and loader-compat invariant | PASS | `drivers/pi/extensions/pals-context-injection.ts` exists. The six S7 constants are defined with their exact byte sequences (`PRIMARY_INJECTION_EVENT="before_agent_start"`, `SUPPORTING_CONTEXT_EVENT="context"`, `PALS_CONTEXT_CUSTOM_TYPE="pals-context"`, `LEGACY_PALS_CONTEXT_HEADER="## PALS Context (auto-injected)"`, `STATE_AUTHORITY_TAG="[PALS_STATE_AUTHORITY=.paul/STATE.md]"`, `ACTIVATION_SIGNAL_TAG="[PALS_ACTIVATION_SIGNAL]"`) and each is single-defined repo-wide. The six S7 functions are exported with their original signatures: `shouldInjectPalsContext`, `buildPalsContextPayload`, `isLegacyPalsContextMessage`, `isPalsContextMessage`, `keepOnlyLatestPalsContextMessage`, `messagesChanged`. The loader-compat invariant is satisfied: file ends with `// No-op Pi extension factory` immediately followed by `export default function (_pi: unknown): void {}` (Phase 246 `guided-workflow-detection.ts` style). |
| AC-2 | `pals-hooks.ts` delegates to the sibling without S4 / shared-helper drift | PASS | `pals-hooks.ts` imports the six S7 functions and six S7 constants from `./pals-context-injection` (single import block at lines 35–48). Inline declaration count: 0 S7 constants, 0 S7 functions (verified with `grep -cE`). `extractTextContent` and `collectRecentAssistantTexts` remain defined inline (still shared with S3 + S5). The existing exported helpers (`compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`) and the `PalsStateSnapshot` type are unchanged. `ActivationState` was promoted from a non-exported local type to an exported type at line 85 so the sibling can type-import it. All four S4 canonical-reply identifiers (`sendCanonicalWorkflowResponse` line 389, `presentGuidedWorkflowMoment` line 403, `loadGuidedWorkflowConfig` line 488, `shouldAutoPresent` line 512) remain inline and behaviorally unchanged. The five S7 call sites in the `palsHooks` factory are functionally identical: `shouldInjectPalsContext(state, activeActivation)` line 859, `buildPalsContextPayload(state, activeActivation as ActivationState, cwd)` line 861, `messages.filter((m) => !isLegacyPalsContextMessage(m))` line 896, `keepOnlyLatestPalsContextMessage(withoutLegacy)` line 897, `messagesChanged(messages, normalized)` line 899. Only the import source changed. |
| AC-3 | Bounded Pi validation guardrail proves the extraction boundary | PASS | One new TAP block named `EXT_PALS_CONTEXT_INJECTION` (modeled on the Phase 250 `EXT_GUIDED_WORKFLOW_DETECTION` block) was added to `tests/pi-end-to-end-validation.sh`. It asserts in a single `if/then/else/fi` block (one `tap_ok`/`tap_not_ok` pair): the new sibling exists; all six S7 constants with their exact `=` right-hand-side string literals are present in the new sibling; all six S7 functions are present in the new sibling; the literal `No-op Pi extension factory` marker is present; `pals-hooks.ts` imports `from "./pals-context-injection"`; `pals-hooks.ts` no longer declares the six S7 constants or functions inline; the S4 canonical-reply identifiers and the shared helpers `extractTextContent` / `collectRecentAssistantTexts` remain inline. Net Pi count delta: 227 → 228 (exactly +1, no silent count creep). |
| AC-4 | Install + full validation green; runtime/source-only changes; no scope drift | PASS | `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reported `[ok] Pi extensions installed: 6 files` (current 5 + new `pals-context-injection.ts`); the new sibling appears in the install log alongside the existing five extensions. `bash tests/pi-end-to-end-validation.sh` returned `1..228 / Passed 228 / Failed 0` (reconciled +1 from baseline 227). `bash tests/cross-harness-validation.sh` returned `1..135 / Passed 135 / Failed 0` (unchanged as planned — S7 contract markers are not shared across harnesses). `bash tests/helpers/artifact_consistency.sh` returned `artifact_consistency_check: PASS`. `git diff --check` returned clean. No `drivers/pi/install.sh` / `drivers/pi/uninstall.sh` / `drivers/pi/driver.yaml` / `tests/cross-harness-validation.sh` / `tests/helpers/artifact_consistency.sh` / `pals.json` / dependency / CI / kernel / module-registry / Claude Code driver / Agent SDK driver / installed-runtime-copy file is in the diff. |

## Verification Results

```
$ PALS_ROOT="$PWD" bash drivers/pi/install.sh
  [ok] Pi extension installed: ~/.pi/agent/extensions/artifact-slice-rendering.ts
  [ok] Pi extension installed: ~/.pi/agent/extensions/guided-workflow-detection.ts
  [ok] Pi extension installed: ~/.pi/agent/extensions/module-activity-parsing.ts
  [ok] Pi extension installed: ~/.pi/agent/extensions/pals-context-injection.ts
  [ok] Pi extension installed: ~/.pi/agent/extensions/pals-hooks.ts
  [ok] Pi extension installed: ~/.pi/agent/extensions/workflow-resource-capsule-rendering.ts
  [ok] Pi extensions installed: 6 files
  [ok] Pi agents installed: 1 agents
  [ok] modules.yaml generated (20 modules)
  Pi driver installation complete.

$ bash tests/pi-end-to-end-validation.sh
  ...
  1..228
  # Passed: 228
  # Failed: 0
  # Total:  228
  # ALL CHECKS PASSED

$ bash tests/cross-harness-validation.sh
  ...
  1..135
  # Passed: 135
  # Failed: 0
  # Total:  135
  # ALL CHECKS PASSED

$ bash tests/helpers/artifact_consistency.sh
  artifact_consistency_check: PASS

$ git diff --check
  (clean — no whitespace/conflict markers)
```

### Focused marker re-check

```
$ grep -rcE '^export const STATE_AUTHORITY_TAG = "\[PALS_STATE_AUTHORITY=\.paul/STATE\.md\]"' drivers/
  drivers/pi/extensions/pals-context-injection.ts: 1
  (all other files: 0)

$ grep -rcE '^export const ACTIVATION_SIGNAL_TAG = "\[PALS_ACTIVATION_SIGNAL\]"' drivers/
  drivers/pi/extensions/pals-context-injection.ts: 1
  (all other files: 0)

$ grep -n "customType: PALS_CONTEXT_CUSTOM_TYPE" drivers/pi/extensions/pals-hooks.ts
  866:        customType: PALS_CONTEXT_CUSTOM_TYPE,
```

The exact byte sequences `[PALS_STATE_AUTHORITY=.paul/STATE.md]` and `[PALS_ACTIVATION_SIGNAL]` appear exactly once each in repo source, both in the new sibling. The `customType: PALS_CONTEXT_CUSTOM_TYPE` call site is preserved in `pals-hooks.ts` (now using the imported constant).

### Constant / function single-definition audit

| Symbol | Definitions in repo | Location |
|--------|---------------------|----------|
| `PRIMARY_INJECTION_EVENT` | 1 | `pals-context-injection.ts` |
| `SUPPORTING_CONTEXT_EVENT` | 1 | `pals-context-injection.ts` |
| `PALS_CONTEXT_CUSTOM_TYPE` | 1 | `pals-context-injection.ts` |
| `LEGACY_PALS_CONTEXT_HEADER` | 1 | `pals-context-injection.ts` |
| `STATE_AUTHORITY_TAG` | 1 | `pals-context-injection.ts` |
| `ACTIVATION_SIGNAL_TAG` | 1 | `pals-context-injection.ts` |
| `shouldInjectPalsContext` | 1 | `pals-context-injection.ts` |
| `buildPalsContextPayload` | 1 | `pals-context-injection.ts` |
| `isLegacyPalsContextMessage` | 1 | `pals-context-injection.ts` |
| `isPalsContextMessage` | 1 | `pals-context-injection.ts` |
| `keepOnlyLatestPalsContextMessage` | 1 | `pals-context-injection.ts` |
| `messagesChanged` | 1 | `pals-context-injection.ts` |

All single-defined ✓. Constant byte sequences and function signatures preserved exactly.

## Module Execution Reports

### Pre-Plan (Phase 254 PLAN, recorded in 254-01-PLAN.md)
- `[dispatch] config-version`: pals.json `schema_version 2.0.0` matched `modules.yaml kernel_version 2.0.0` — no migration.
- `[dispatch] planning posture`: direct-requirements / collaboration high.
- TODD/IRIS/DAVE/DOCS/RUBY/ARCH advisories recorded; CODI blast radius for the 6 S7 symbols mapped to 7 internal call-sites within the single `palsHooks` factory; DEAN PASS (no dependency change).

### Pre-Apply (Phase 254 APPLY)
- TODD baseline: Pi 227/227 (per Phase 253 closure on main).
- WALT baseline: cross-harness 135/135, artifact_consistency PASS (per Phase 253).
- DAVE baseline: install reported 5 Pi extension files pre-extraction; expected 6 post.
- RUBY baseline: `pals-hooks.ts = 947 LOC` (above 500 threshold, under sibling-extraction wave reduction).
- ARCH/IRIS/SETH/DEAN: no blockers.

### Post-Task
- Task 1 (sibling extraction): TODD/RUBY/IRIS/ARCH PASS — `pals-hooks.ts` 947→903 LOC; new sibling 88 LOC; no TODO markers introduced; loader-compat invariant satisfied.
- Task 2 (TAP guardrail): TODD PASS — exactly +1 TAP assertion as planned; in-flight reconciliation of pre-existing assertion 133 keeps net delta +1.
- Task 3 (full validation): TODD/WALT/DAVE/DEAN PASS — all gates GREEN.

### Post-Apply Advisory
- TODD: source-extraction has command-verifiable behavior preservation via the existing Pi e2e suite + the new bounded TAP guardrail. PASS.
- IRIS: no `TODO`/`FIXME`/`HACK`/`XXX` markers introduced in the new sibling. PASS.
- DAVE: no CI / Dockerfile changes; install reports the expected 6 files. WARN-only baseline carried.
- DOCS: source-only phase by design — README / Pi extension docs / skill-map / extraction contract docs surfacing intentionally deferred to Phase 255. No drift.
- RUBY: `pals-hooks.ts` 947 → 903 LOC (−44, wave reduction continues). New sibling 88 LOC (well under threshold). Broader validation-script size-debt (`tests/cross-harness-validation.sh`) remains deferred per v2.58 closure. PASS-with-note.
- ARCH: import graph remains acyclic. The new sibling type-imports `PalsStateSnapshot` and `ActivationState` from `./pals-hooks` (type-only imports are erased at runtime, so no value cycle); it value-imports `renderArtifactSlices` from `./artifact-slice-rendering` and `renderWorkflowResourceCapsules` from `./workflow-resource-capsule-rendering`. `pals-hooks.ts` value-imports the six S7 functions and six S7 constants from `./pals-context-injection`. PASS.
- ARIA / DANA / GABE / LUKE / OMAR / PETE / REED / SETH / VERA: no UI / data-schema / API / UX / observability / performance / resilience / secret / privacy files touched. PASS.

### Post-Apply Enforcement
- TODD: Pi e2e 227 → 228 (+1, expected reconciliation). PASS.
- WALT: cross-harness 135/135 unchanged; artifact_consistency PASS; `git diff --check` clean. PASS.
- DEAN: no dependency manifests / lockfiles modified. PASS.
- All enforcement gates GREEN.

### Pre-Unify
- TODD / WALT / RUBY / ARCH / SKIP advisory annotations carried into this `Module Execution Reports` section as the durable home for module evidence; baselines and extraction deltas recorded above.

### Post-Unify
- SKIP: knowledge captured for the extraction wave's pattern library — (a) the S7 extraction ratifies the sibling Pi extension recipe a fifth time (S5/S1/S2/S3/S7); (b) the type-only back-import pattern (sibling type-imports `ActivationState` from `./pals-hooks` while value-importing only what its moved code actually calls) keeps the post-extraction dependency graph acyclic; (c) the TAP-assertion repoint pattern (move a constant *definition* into a sibling, then change pre-existing TAP definition-string assertions to imported-identifier assertions in the same plan-scope file) is a bounded, no-net-count-change reconciliation move that future S4/S6/S8 extractions can reuse.
- RUBY: debt history updated — `pals-hooks.ts` reduced 947 → 903 LOC (−44). The file remains 403 LOC over the 500 threshold and stays in the v2.5x sibling-extraction queue (S4 / S6 / S8 candidates pending modularization-contract promotion). Broader `tests/cross-harness-validation.sh` size-debt remains deferred per v2.58 closure.
- TODD: quality history — Pi e2e 227 → 228 (+1 source-shape coverage). One pre-existing TAP assertion (#133) required a single-conjunct repoint as a planned consequence of the constant-definition move; recorded as a recurring pattern future S* extractions should anticipate.
- WALT: quality history — Pi 228/228, cross-harness 135/135, artifact_consistency PASS, install 6 files, `git diff --check` clean. Baseline carried forward for Phase 255 (Documentation + Validation Surfacing).
- IRIS: no new code-smell debt; new sibling carries no `TODO`/`FIXME`/`HACK`/`XXX` markers.
- 5 modules dispatched, 0 blocked; persistence recorded above.

**Module evidence validation:** modules enabled in `pals.json` produced visible dispatch evidence at every required hook (pre-plan, pre-apply, post-task ×3, post-apply advisory, post-apply enforcement, pre-unify, post-unify). No SKIPPED-only cohort detected. No `modules.yaml NOT FOUND` warnings.

## Deviations

**One bounded in-flight reconciliation (anticipated by the plan).**

The plan's Task 2 explicitly allowed "If command output proves additional bounded repair is necessary, reconcile in-flight with explicit justification rather than expanding silently." When the new TAP block first ran, a pre-existing TAP assertion (#133, originally added in the Phase 250 era) failed because it had been checking for the inline definition string `PRIMARY_INJECTION_EVENT = "before_agent_start"` in `pals-hooks.ts` — exactly the definition string that the planned extraction moved into the sibling.

The reconciliation was a single-conjunct change in the same file already inside the plan's `files_modified` scope (`tests/pi-end-to-end-validation.sh`): the first conjunct of assertion 133 was repointed from `'PRIMARY_INJECTION_EVENT = "before_agent_start"'` (definition match) to `'PRIMARY_INJECTION_EVENT'` (imported-identifier match). A short comment was added in the test file documenting the Phase 254 repoint.

The same invariant assertion 133 originally checked is preserved post-repoint:
- Primary injection event identity = `before_agent_start` (now expressed via the imported constant whose definition lives in the sibling and whose value is unchanged).
- `pi.on("before_agent_start", ...)` handler still in `pals-hooks.ts` (line 847).
- `customType: PALS_CONTEXT_CUSTOM_TYPE` injection still in `pals-hooks.ts` (line 866).

Net Pi count delta is still exactly +1 (227 → 228) as planned — no silent count creep. No file outside the plan's `files_modified` scope was touched.

No other deviations.

## Key Patterns / Decisions

- **Loader-compat invariant ratified a fifth time.** The new sibling ends with `// No-op Pi extension factory` followed by `export default function (_pi: unknown): void {}`, matching the Phase 246 (`guided-workflow-detection.ts`) precedent comment-style. The bounded TAP guardrail asserts the literal phrase `No-op Pi extension factory` so future siblings keep the same loader-compat marker.
- **Helper-import tightening (Phase 246) applied.** The new sibling imports only what its moved code directly references: `renderArtifactSlices` (S1), `renderWorkflowResourceCapsules` (S2), and the type-only `PalsStateSnapshot` and `ActivationState` from `./pals-hooks`. It does not import `extractTextContent`, `collectRecentAssistantTexts`, or other shared helpers that the S7 functions do not call directly.
- **Type-only back-import keeps the dependency graph acyclic.** `ActivationState` was promoted from a non-exported local type in `pals-hooks.ts` to an exported type so the new sibling can type-import it. Because the back-import is `import type { … }`, it is erased at runtime and cannot form a value cycle with the forward `import { … } from "./pals-context-injection"` in `pals-hooks.ts`.
- **Single-defined exact-string contract markers continue to govern.** The six S7 constants are now defined in exactly one place each, with their byte sequences asserted by the bounded TAP block. The two transcript-visible markers `[PALS_STATE_AUTHORITY=.paul/STATE.md]` and `[PALS_ACTIVATION_SIGNAL]` appear exactly once each in repo source.
- **`docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` deferrals preserved.** S4 canonical-reply delivery, S6 lifecycle UI, and S8 command routing are not extracted. Full Claude Code / Agent SDK driver removal remains blocked on cross-harness validation decomposition per `PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`.
- **Test-script repoint pattern documented.** When sibling extractions move a constant *definition* out of `pals-hooks.ts`, pre-existing TAP assertions that pinned the constant's definition string must be repointed to the imported-identifier reference (and given an inline comment documenting the repoint). This is a bounded, in-scope, no-net-count-change reconciliation pattern that future S* extractions can reuse.

## GitHub Flow Evidence

| Field | Value |
|-------|-------|
| Branch | `feature/254-bounded-s7-submodule-extraction` (created from main during Phase 254 PLAN preflight) |
| Source commit | `fabcb696` — `feat(254): extract S7 pals-context-injection sibling Pi extension` |
| Push | `origin/feature/254-bounded-s7-submodule-extraction` (force-with-lease not required; clean fast-forward) |
| PR | [#169](https://github.com/coctostan/pals/pull/169) — OPEN against `main` |
| `mergeStateStatus` | CLEAN |
| CI | Socket Security: Project Report → SUCCESS; Socket Security: Pull Request Alerts → SUCCESS |
| Reviews | `require_reviews: false` per `pals.json`; review gate skipped |
| Merge gate | _resolved below in Merge Gate Status_ |

## Workguard Scope Evidence

- Snapshot: `runs/workguards/20260504T122135Z-phase-254-s7-extraction`
- Allowed paths: `drivers/pi/extensions/pals-context-injection.ts`, `drivers/pi/extensions/pals-hooks.ts`, `tests/pi-end-to-end-validation.sh`, `.paul/**`
- Final scope report: `changed=3, outside_allowed=0, over_budget=false`
- All changed files within allowed scope ✓

## Skill Audit

| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | resume → apply → unify lifecycle running |
| /carl | ✓ | automatic phase-boundary session strategy |
| TODD | ✓ | pre-plan, pre-apply, post-task ×3, post-apply, pre-unify dispatches recorded |
| WALT | ✓ | post-apply enforcement + pre-unify dispatches recorded; post-unify follows |

All required skills invoked ✓.

## Deferred Scope

- **S4 canonical-reply delivery, S6 lifecycle UI, S8 command routing**: still deferred per `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` (Phase 253 outcome). They remain inline in `pals-hooks.ts`.
- **Broader `tests/cross-harness-validation.sh` size-debt decomposition**: still deferred per v2.58 closure.
- **Full Claude Code / Agent SDK driver removal**: still blocked on cross-harness validation decomposition per `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`.
- **README / Pi extension docs / skill-map / extraction contract docs surfacing for S7**: deferred to Phase 255 (Documentation + Validation Surfacing) as planned.

## Next Phase

**Phase 255 — Documentation + Validation Surfacing** (v2.59 milestone, phase 3 of 4):
- Surface the S7 extraction across `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, and the contract / extraction docs so Phase 256 can close the v2.59 wave with a clean evidence pass.
- Inherit a clean baseline: install 6 Pi extension files, Pi 228/228, cross-harness 135/135, artifact_consistency PASS.
- v2.59 progress after Phase 254: 2 of 4 phases complete (50%).

After PR #169 is merged in the merge gate below, the next routing is `/paul:plan` for Phase 255.
