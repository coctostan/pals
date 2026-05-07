# Pi-Native Lifecycle UI Extraction Contract

**Phase:** 257 S6 Extraction Contract + Bounded Submodule Plan
**Plan:** 257-01
**Status:** Phase 257 docs-only; Phase 258 source extraction not yet started. This document is a derived aid only; it does not modify runtime behavior, validation truth, module truth, GitHub Flow truth, or `.paul/*` lifecycle authority.

## Purpose

This contract defines the extraction boundary for S6 `lifecycle-ui` from `drivers/pi/extensions/pals-hooks.ts` into a dedicated sibling Pi extension module `drivers/pi/extensions/lifecycle-ui.ts`. Phase 257 produces the docs-only contract and Phase 258 handoff; Phase 258 will perform the source extraction following the sibling-module recipe ratified by S5 (Phase 239), S1 (Phase 243), S2 (Phase 246), S3 (Phase 250), and S7 (Phase 254).

S6 owns the visible Pi lifecycle status / widget / loop badge surface and the `syncLifecycleUi` call that mutates Pi UI through `ctx`. It is the **first runtime-coupled sibling extraction**: unlike S1/S2/S3/S5/S7, S6 mutates Pi state (`ctx?.ui?.setStatus` and `ctx?.ui?.setWidget`) rather than purely producing strings or transforming pure inputs. The `should not be extracted before S1/S5 prove the pattern; must keep all visible lifecycle status semantics` precondition recorded in `PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` is now satisfied by the v2.55–v2.59 wave (S5/S1/S2/S3/S7 shipped; PRs #149/#157/#161/#165/#169 squash-merged; v2.59 closure validation Pi 231/231, cross-harness 136/136, install 6 Pi extension files).

This document is a **derived aid only**. It does not modify runtime behavior, validation truth, module truth, GitHub Flow truth, or `.paul/*` lifecycle authority. Shared `.paul/*` artifacts, approved PLAN/APPLY/UNIFY artifacts, module reports, GitHub Flow command evidence, and validation command output remain authoritative.

## Evidence Base

- `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` — original S1–S8 inventory; S6 row + risk note; cited identifiers; "should not be extracted before S1/S5 prove the pattern; must keep all visible lifecycle status semantics" precondition (now satisfied by S5/S1/S2/S3/S7 shipping).
- `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md` — current S1/S2/S3/S5/S7 extraction state; S6 risk classification (runtime-coupled, depends on outputs of S5 and S7, mutates Pi UI through `ctx`); multi-module extraction rule; forbidden scope; validation expectations.
- `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` — governing safety contract for canonical replies, no auto-approval, no auto-continue, checkpoint blocking, **no UI-only lifecycle decisions**, no inferred merge intent. The no-UI-only-lifecycle-decisions invariant is the single most important S6 boundary because S6 is the UI rendering surface itself.
- `docs/PI-NATIVE-PALS-CONTEXT-INJECTION-EXTRACTION-CONTRACT.md` — most-recent S* extraction contract precedent (Phase 253/254 S7 wave); shape applied here, including the type-only back-import pattern Phase 254 ratified.
- `docs/PI-NATIVE-GUIDED-WORKFLOW-DETECTION-EXTRACTION-CONTRACT.md` — second-most-recent S* extraction contract precedent (Phase 249/250 S3 wave); same docs-only shape.
- `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md` — preserved deferral of full Claude Code / Agent SDK driver removal until cross-harness validation decomposition lands; this contract is out of scope for v2.60 and must not be modified.
- `drivers/pi/extensions/pals-hooks.ts` — supported Pi runtime entry source; currently owns S6 inline. Phase 258 will import S6 from the new sibling while keeping the S4 canonical reply delivery, the S5/S1/S2/S3/S7 sibling imports, and the shared helpers.
- `drivers/pi/extensions/module-activity-parsing.ts` — S5 sibling precedent (pure; smallest authority surface); also owns the `RecentModuleActivity` type that S6 consumes.
- `drivers/pi/extensions/artifact-slice-rendering.ts` — S1 sibling precedent (single-defined contract markers).
- `drivers/pi/extensions/workflow-resource-capsule-rendering.ts` — S2 sibling precedent (helper-import tightening; loader-compat invariant; triple-confirmed pattern).
- `drivers/pi/extensions/guided-workflow-detection.ts` — S3 sibling precedent (detection extracted while delivery (S4) remained inline; same shape applies to S6: rendering helpers extracted while UI-mutation invocation sites remain explicit).
- `drivers/pi/extensions/pals-context-injection.ts` — S7 sibling precedent (88 LOC); ratified the type-only back-import pattern (Phase 254) that Phase 258 will apply for `PalsStateSnapshot` and `RecentModuleActivity` import direction.
- `.paul/phases/253-s7-extraction-contract-bounded-submodule-plan/253-01-SUMMARY.md` — closes the S7 contract phase; sets the precedent docs-only shape Phase 257 mirrors.
- `.paul/phases/254-bounded-s7-submodule-extraction/254-01-SUMMARY.md` — closes the S7 source-extraction phase; sets the precedent shape Phase 258 will mirror for S6.
- `.paul/phases/256-evidence-closure-next-roadmap-decision-v2-59/256-01-SUMMARY.md` — v2.59 closure that recorded S6 `lifecycle-ui` extraction as the v2.60 default recommendation only; explicit approval routes through `/paul:milestone` and the resulting plan, not through this contract.

## S6 Subsystem Boundary

The following identifiers in `drivers/pi/extensions/pals-hooks.ts` define the S6 `lifecycle-ui` subsystem. Phase 258 must preserve every named identifier through explicit import or single-defined re-export, and must preserve the listed constants as exact-string single-defined runtime UI-element identifiers.

### Functions

- `renderLifecycleStatus`
- `renderLifecycleWidget`
- `renderLoopBadge`
- `renderCompactLoopSummary`
- `renderLifecycleActionLabel`
- `renderModuleActivity`
- `renderModuleActivityDetails`
- `syncLifecycleUi`

### Constants (exact-string single-defined runtime UI-element identifiers)

- `PALS_STATUS_ID` — `"pals-lifecycle"`
- `PALS_WIDGET_ID` — `"pals-lifecycle"`

These two constants are the runtime UI correlation surface: Pi correlates `ctx?.ui?.setStatus` and `ctx?.ui?.setWidget` calls across renders by these element IDs. Phase 258 MUST keep each constant single-defined (no duplication, no template re-derivation, no concatenation drift). Either Pi treating both IDs as the same string ("pals-lifecycle") is the existing runtime behavior and MUST be preserved; the contract does NOT require introducing distinct strings.

## Shared-Input Disposition

`PalsStateSnapshot` and `RecentModuleActivity` are NOT S6-private types.

- `PalsStateSnapshot` is the parsed lifecycle state owned by `drivers/pi/extensions/pals-hooks.ts` (parsed from `.paul/STATE.md`). It is referenced by S5 (`module-activity-parsing.ts`) and S7 (`pals-context-injection.ts`) and is exported from `pals-hooks.ts` as part of the canonical sibling-import discipline ratified in Phase 246.
- `RecentModuleActivity` is the parsed module-activity record owned by the S5 sibling `drivers/pi/extensions/module-activity-parsing.ts`.

Phase 258 MUST import both as **type-only back-imports** (TypeScript `import type { … } from "./…"`), following the Phase 254 type-only back-import precedent established for S7's `PalsStateSnapshot` reference. Type-only imports erase at runtime, so the dependency graph stays acyclic and the loader-compat invariant is preserved.

`PalsStateSnapshot` type-only import direction: from `./pals-hooks`.
`RecentModuleActivity` type-only import direction: from `./module-activity-parsing`.

S6 MUST NOT re-implement either parser; it MUST consume both as inputs.

## Shared-Helper Disposition

Among the helpers exported from `drivers/pi/extensions/pals-hooks.ts` (`compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`), the S6 code references only `compactWhitespace` (used by `renderCompactLoopSummary`).

Phase 258 MUST value-import only `compactWhitespace` from `./pals-hooks` and deliberately omit `readFileOr`, `getFileFreshness`, `selectBoundedLines`, and `escapeRegExp` because the moved S6 code does not reference them. This mirrors the Phase 246 S2, Phase 250 S3, and Phase 254 S7 helper-import tightening discipline: the new sibling imports only the shared helpers it actually references.

If Phase 258 implementation discovers an additional referenced helper (for example, if a renderer indirectly calls another shared utility through a helper not yet observed), Phase 258 MAY add that single helper to the value-imports list, but MUST NOT move shared helpers out of `pals-hooks.ts`.

## Pi-UI-Mutation Invocation Rule

`syncLifecycleUi(ctx)` is the only S6 function that mutates Pi state. It calls `ctx?.ui?.setStatus(PALS_STATUS_ID, …)` and `ctx?.ui?.setWidget(PALS_WIDGET_ID, …)` to drive the visible Pi lifecycle UI.

The Phase 258 extraction MUST preserve every existing `syncLifecycleUi(ctx)` call site inside `drivers/pi/extensions/pals-hooks.ts`. The observed call sites at the time of Phase 257 are approximately five sites (lines 841, 848, 874, 879, 891), one for each lifecycle event that triggers a UI refresh (e.g., turn_end, prompt_submit, after canonical replies). The contract describes the rule, not the line numbers — Phase 258 verification MUST confirm every existing `syncLifecycleUi(ctx)` invocation in `pals-hooks.ts` is preserved by call shape, not by line number.

The current call shape in `pals-hooks.ts` MUST remain functionally identical:

```
syncLifecycleUi(ctx);
```

The named identifier (`syncLifecycleUi`) and the single positional argument (`ctx`) MUST stay observable at every existing call site; only the import source changes (from inline definition to `import { syncLifecycleUi } from "./lifecycle-ui"`).

S6 MUST NOT introduce any new path where the UI rather than `.paul/*` and parent APPLY drives lifecycle state. The UI is a render of authoritative state read from `.paul/STATE.md` and module activity; it is NEVER an authority for lifecycle decisions. This is the **no-UI-only-lifecycle-decisions** invariant.

## Allowed Phase 258 Extraction Shape

Phase 258 MUST follow the sibling-module recipe ratified by S5 (Phase 239), S1 (Phase 243), S2 (Phase 246), S3 (Phase 250), and S7 (Phase 254):

1. **Allowed source target:** create `drivers/pi/extensions/lifecycle-ui.ts` as a new sibling Pi extension module.
2. **Loader-compat invariant:** the new sibling MUST end with a no-op default-exported factory `export default function (_pi: unknown): void {}` preceded by a JSDoc comment carrying the literal phrase `No-op Pi extension factory`.
3. **Type-only back-imports:** `import type { PalsStateSnapshot } from "./pals-hooks";` and `import type { RecentModuleActivity } from "./module-activity-parsing";` per the Phase 254 type-only back-import precedent. Type-only imports erase at runtime; the dependency graph stays acyclic.
4. **Value imports:** value-import only `compactWhitespace` from `./pals-hooks`. Do not duplicate, do not re-export, and do not move shared helpers.
5. **Single-defined markers:** the two S6 constants (`PALS_STATUS_ID = "pals-lifecycle"`, `PALS_WIDGET_ID = "pals-lifecycle"`) MUST be defined exactly once in the new sibling and either consumed locally or explicitly re-exported. `pals-hooks.ts` MUST replace its local definitions with imports from the new sibling (or rely on the exported re-export) — no constant is duplicated and none is dropped.
6. **Function moves:** the eight S6 functions listed above MUST move to the new sibling with no signature change. `pals-hooks.ts` MUST import them from `./lifecycle-ui` at the call sites that already exist (every `syncLifecycleUi(ctx)` site is preserved; rendering helpers are imported transitively through `syncLifecycleUi` or directly if `pals-hooks.ts` calls them outside `syncLifecycleUi`).
7. **UI-mutation invocation-site rule:** every existing `syncLifecycleUi(ctx)` call site in `pals-hooks.ts` MUST remain functionally identical (same call shape, same identifier, same single `ctx` argument). The only change at the call site is the import source.
8. **No-UI-only-lifecycle-decisions preservation:** the new sibling MUST NOT introduce any path where the UI drives lifecycle state. UI rendering reads `PalsStateSnapshot` and `RecentModuleActivity` and emits status / widget content; lifecycle decisions remain in `.paul/*` and parent APPLY.
9. **Install surface:** `drivers/pi/install.sh` MUST report 7 Pi extension files after Phase 258 (current 6 + new sibling). Any other installer change is forbidden.
10. **Pi runtime entry:** `palsHooks` (the Pi extension factory in `pals-hooks.ts`) MUST continue to fire on every existing lifecycle event that currently triggers `syncLifecycleUi(ctx)`. The visible Pi lifecycle status and widget content MUST remain functionally equivalent to v2.59 closure behavior.
11. **TAP-assertion repoint discipline:** any Pi or cross-harness assertion that names the source file/path of an S6 function or constant MUST be repointed to the new sibling. This applies the Phase 254 TAP-assertion repoint pattern.
12. **Default-arg cycle-avoidance:** if Phase 258 implementation introduces any new shared cap or default-arg referencing a sibling-owned constant, it MUST follow the canonical default-arg cycle-avoidance pattern (Phase 243) — the cap moves from a default-arg referencing a sibling-owned constant to a required parameter at the helper signature, with each call site passing its local cap explicitly.

## Forbidden Scope (Phase 258)

Phase 258 MUST NOT:

- Modify or extract S4 canonical reply delivery: `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`, or any other S4 identifier. S4 stays inline in `pals-hooks.ts` (S4 is the integration point for every other sibling and is explicitly deferred).
- Modify or extract S8 command routing (`/paul-*` command surface, command lookup, wrapper translation, command-signal detection, quick-action selection, command registration).
- Re-extract or modify previously extracted siblings: `module-activity-parsing.ts` (S5), `artifact-slice-rendering.ts` (S1), `workflow-resource-capsule-rendering.ts` (S2), `guided-workflow-detection.ts` (S3), `pals-context-injection.ts` (S7).
- Touch `drivers/pi/uninstall.sh`, `drivers/pi/driver.yaml`, kernel workflow sources, or installed runtime copies under `~/.pi/agent/extensions/`. Only `drivers/pi/install.sh` may be changed, and only by the minimal source-set entry needed to install the new sibling.
- Modify dependency manifests, lockfiles, CI configuration (`.github/workflows/*`), Dockerfiles, module registry files (`modules.yaml`, `kernel/modules.yaml`), or `.paul/SPECIAL-FLOWS.md`.
- Touch the Claude Code driver or the Agent SDK driver (frozen since v2.52; full removal still blocked on cross-harness validation decomposition per `PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`).
- Decompose `tests/cross-harness-validation.sh`. Broader validation-script size-debt work remains a separate v2.5x candidate (RUBY-flagged in v2.58/v2.59 closures).
- Add telemetry, hidden state, runtime ledgers, cache-as-truth, auto-approval, auto-continue, skipped checkpoints, **UI-only lifecycle decisions** (the canonical S6 boundary), or inferred merge intent.
- Move shared helpers (`compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `extractTextContent`, `collectRecentAssistantTexts`, `PalsStateSnapshot`) or shared types out of `pals-hooks.ts`. They remain shared.
- Move `RecentModuleActivity` out of `module-activity-parsing.ts`. It remains the S5 sibling's owned type.
- Change `.paul/*` lifecycle authority. The PLAN/APPLY/UNIFY loop and STATE.md/ROADMAP.md/PROJECT.md/MILESTONES.md remain authoritative.

## Phase 258 Handoff

Phase 258 (Bounded S6 Submodule Extraction) MUST satisfy the following before declaring APPLY complete:

### Marker / function preservation checks

- `grep` proves each of the two S6 constants (`PALS_STATUS_ID`, `PALS_WIDGET_ID`) is defined exactly once across the repo (no duplication after extraction).
- `grep` proves each of the eight S6 functions is defined exactly once across the repo and that `pals-hooks.ts` imports them from `./lifecycle-ui` (or that `pals-hooks.ts` references only `syncLifecycleUi` from the import and the rendering helpers are internal to the sibling — Phase 258 may choose either shape, but each function must remain single-defined).
- `grep` proves the S4 canonical-reply identifiers (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`) remain defined in `pals-hooks.ts` (S4 stays inline).
- `grep` proves `PalsStateSnapshot` remains defined in `pals-hooks.ts` and `RecentModuleActivity` remains defined in `module-activity-parsing.ts` (shared-type retention).
- `grep` proves the literal UI-element ID byte sequence `pals-lifecycle` appears in exactly one source location (the new sibling, where both `PALS_STATUS_ID` and `PALS_WIDGET_ID` are defined to that value).
- `grep` proves every `syncLifecycleUi(ctx)` call site in `pals-hooks.ts` is preserved by call shape (the named identifier and the single `ctx` argument are both observable at each call site).

### Install verification

- `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports 7 Pi extension files (current 6 + new `lifecycle-ui.ts`). The TAP / `[ok]` line is preserved verbatim in the SUMMARY.

### Validation

- `bash tests/pi-end-to-end-validation.sh` passes. Expected baseline at start of Phase 258: Pi 231/231. Any count change MUST be reconciled from command output in the SUMMARY.
- `bash tests/cross-harness-validation.sh` passes. Expected baseline at start of Phase 258: cross-harness 136/136. Any count change MUST be reconciled from command output in the SUMMARY.
- `bash tests/helpers/artifact_consistency.sh` returns `artifact_consistency_check: PASS`.
- `git diff --check` returns clean.

### GitHub Flow evidence

- Phase 258 work happens on a non-base feature branch.
- After successful APPLY, the branch is pushed and a PR is opened (per `pals.json` `auto_push: true`, `auto_pr: true`).
- CI status is recorded in the SUMMARY (passing required before merge per `pals.json` `ci_checks: true`).
- Merge follows squash strategy with branch deletion (`merge_method: "squash"`, `delete_branch_on_merge: true`).

### Summary count reconciliation discipline

- All TAP counts in the Phase 258 SUMMARY MUST be copied from fresh command output, not from this contract or any other prior document. If validation counts differ from the expected baseline, the SUMMARY MUST explain the delta from command output before UNIFY proceeds.

## Acceptance Checklist

- [ ] New sibling `drivers/pi/extensions/lifecycle-ui.ts` exists, exports the eight S6 functions (or makes the rendering helpers internal and exports only `syncLifecycleUi` plus the two constants), defines the two S6 constants single-defined, ends with the loader-compat no-op default factory carrying the literal `No-op Pi extension factory` JSDoc phrase.
- [ ] `drivers/pi/extensions/pals-hooks.ts` no longer defines the two S6 constants or the eight S6 functions; it imports them from `./lifecycle-ui`.
- [ ] `drivers/pi/extensions/pals-hooks.ts` still defines and exports `PalsStateSnapshot`, `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `extractTextContent`, `collectRecentAssistantTexts`, and the existing shared helpers/types; the new S6 sibling type-only back-imports `PalsStateSnapshot` from `./pals-hooks` and value-imports `compactWhitespace` from `./pals-hooks`.
- [ ] `drivers/pi/extensions/module-activity-parsing.ts` still defines and exports `RecentModuleActivity`; the new S6 sibling type-only back-imports it from `./module-activity-parsing`.
- [ ] The S4 canonical-reply identifiers remain inline in `drivers/pi/extensions/pals-hooks.ts`.
- [ ] Every existing `syncLifecycleUi(ctx)` call site in `drivers/pi/extensions/pals-hooks.ts` is functionally identical (same call shape, same identifier, same single argument) and rebinds only the import source.
- [ ] No new path is introduced where UI rather than `.paul/*` and parent APPLY drives lifecycle state (no-UI-only-lifecycle-decisions invariant preserved).
- [ ] `drivers/pi/install.sh` reports 7 Pi extension files after Phase 258.
- [ ] Pi e2e, cross-harness, and artifact-consistency validation pass at the Phase 258 reconciled count; deltas explained from command output.
- [ ] `git diff --check` clean.
- [ ] Any Pi or cross-harness assertion that names the source file/path of an S6 function or constant is repointed to the new sibling (TAP-assertion repoint discipline).
- [ ] No forbidden-scope file is touched.
- [ ] PR opened, CI green, squash-merge with branch deletion.

## Status After Phase 257

This contract is final for Phase 257. It does not authorize source changes; it defines the boundary Phase 258 will execute against. Approval of Phase 258 routes through `/paul:plan` for Phase 258 (after Phase 257 UNIFY closes), not through this contract.

## Status After Phase 258

Contract closed for Phase 258. The Phase 257 boundary has been executed end-to-end without scope drift; the placeholder above is replaced with the recorded closure facts.

- **S6 function move evidence:** all eight S6 functions extracted to `drivers/pi/extensions/lifecycle-ui.ts` with no signature change — `renderLoopBadge`, `renderCompactLoopSummary`, `renderLifecycleActionLabel`, `renderModuleActivity`, `renderModuleActivityDetails`, `renderLifecycleStatus`, `renderLifecycleWidget`, `syncLifecycleUi` — each exported and single-defined in the new sibling.
- **S6 constant move evidence:** `PALS_STATUS_ID` and `PALS_WIDGET_ID` are single-defined in the new sibling as exact-string runtime UI-element identifiers (`PALS_STATUS_ID = "pals-lifecycle"`, `PALS_WIDGET_ID = "pals-lifecycle"`); the literal byte sequence `pals-lifecycle` appears exactly once in repo source as the right-hand side of those two constants.
- **Loader-compat invariant satisfied:** the new sibling carries the literal `No-op Pi extension factory` JSDoc marker plus `export default function (_pi: unknown): void {}`.
- **Helper-import tightening applied:** the new sibling value-imports only what the moved S6 code calls (omits `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `extractLoopSignature`, `extractTextContent`).
- **Type-only back-imports for `PalsStateSnapshot` and `RecentModuleActivity`** (Phase 254 precedent ratified ×2): `PalsStateSnapshot` type-imported from `./pals-hooks`; `RecentModuleActivity` type-imported from `./module-activity-parsing`; back-imports erased at runtime so the dependency graph stays acyclic.
- **`inline → export` promotion ratified ×2** at four-symbol scale (`MAX_VISIBLE_MODULES`, `RECENT_MODULE_ACTIVITY_LOOKBACK`, `parsePalsState`, `collectRecentAssistantTexts`); only the `export` keyword was added — bodies unchanged.
- **TAP-assertion repoint pattern ratified ×2:** five pre-existing assertions naming moved S6 source paths against `$EXT_SRC` / `$EXT_SRC_P64` repointed in-place to `$EXT_LIFECYCLE_UI` as a no-net-count-change reshape (TAP blocks #128, #130, #160 plus the two `renderLoopBadge` blocks); one new bounded `EXT_LIFECYCLE_UI` source-shape guardrail added (`+1` net: 231 → 232).
- **Render-string shapes preserved exactly:** loop-badge `PLAN✓ APPLY✓ UNIFY✓` derived from `[✓○]` marks; action-label heuristics (`Complete` / `Blocked` / `Waiting` / `Ready` / `Next`); module-activity `Modules: <stage> • <list>` shape; widget multi-line shape; `•`-separated status shape.
- **UI-mutation invocation-site preservation:** all five existing `syncLifecycleUi(ctx)` call sites in `pals-hooks.ts` (lines 770, 777, 803, 808, 820) preserved by call shape — same identifier, same single argument, only the import source rebound.
- **No-UI-only-lifecycle-decisions invariant verified shipped:** `lifecycle-ui.ts` performs no `.paul/*` writes, no `pi.sendUserMessage` calls, and no S4 canonical-reply identifier invocations.
- **Install-surface delta:** `[ok] Pi extensions installed: 7 files` (6 → 7).
- **TAP delta (Pi):** Pi e2e 232/232 (231 → 232 with the bounded `EXT_LIFECYCLE_UI` TAP block + the in-flight repoint of 5 pre-existing assertions).
- **TAP delta (cross-harness):** cross-harness 136/136 unchanged (no shared-invariant surfacing guardrail planned for S6 — the +1 closure guardrail is reserved for Phase 260 evidence closure per the recipe established by Phases 244 / 247 / 251 / 255).
- **`git diff --check` evidence:** clean.
- **PR/CI/merge evidence:** PR #173 opened, Socket Security CI ×2 PASS, squash-merged 2026-05-06 as `1531e47a`; feature branch deleted on remote and locally; `main` synced.
- **Phase 259 owns user-facing-doc surfacing:** root README, Pi extensions README, Pi skill-map; modularization contract docs (modularization contract + extraction-target baseline); this S6 contract; `tests/pi-end-to-end-validation.sh` (+3 surfacing TAP assertions). Phase 260 will own evidence closure + next-roadmap decision.
- **S4 / S8 deferrals preserved;** full Claude Code / Agent SDK driver removal still blocked per `PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`.
