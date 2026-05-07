---
phase: 261-s8-extraction-contract-bounded-submodule-plan
plan: 01
completed: 2026-05-07T14:05Z
duration: ~30 minutes (PLAN + APPLY + UNIFY across two sessions)
---

## Objective

Create the v2.61 Phase 261 S8 `command-routing` extraction contract and bounded Phase 262 handoff before any runtime/source extraction work begins. Continue the Pi-extension sibling-module extraction wave by promoting S8 from "Deferred; highest user-visible command/shortcut surface" to a bounded Phase 262 contract target after S5/S1/S2/S3/S7/S6 stability was demonstrated in v2.55–v2.60.

## What Was Built

| File | Purpose | Lines |
|------|---------|-------|
| `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md` (new) | S8 extraction contract: four cited S8 functions (`getCommand`, `toWrapperCommand`, `detectCommandSignal`, `getQuickActions`), the cited `COMMANDS` constant with all twelve `/paul-*` entries enumerated verbatim (`paul-init`, `paul-plan`, `paul-apply`, `paul-unify`, `paul-resume`, `paul-status`, `paul-fix`, `paul-pause`, `paul-milestone`, `paul-discuss`, `paul-help`, `paul-review`), the closure-routing surface trio (`routeCommand` / `routeWrapperCommand` / `registerQuickActionShortcut`), the four command-routing constants (`COMMAND_ACTIVATION_TURN_BUDGET = 3`, `PROMPT_ACTIVATION_TURN_BUDGET = 1`, `PRIMARY_QUICK_ACTION_LIMIT = 3`, `MAX_QUICK_ACTIONS = 5`), the two inline types (`CommandDef`, `QuickActionDef`), shared-input disposition (`compactWhitespace`/`parsePalsState` value-imports; `markActivation` value-import via the third application of the Phase 258 `inline → export` promotion pattern; `ActivationState` type-only back-import), Pi-runtime mutation invocation rule, canonical `/paul-*` → `/skill:paul-*` routing rule, explicit Disposition A vs Disposition B with Disposition A as the default, no-UI-only-lifecycle-decisions invariant, the eleven-vs-twelve `CMD_COUNT` known mismatch flag, Phase 262 handoff, and acceptance checklist | 283 |
| `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md` (update) | Added `Phase 261 Outcome`, `Phase 261 Validation Expectations`, and `Phase 262 Validation Expectations` sections; S8 row promoted from "Deferred" to bounded Phase 262 contract target; preserved S1/S2/S3/S5/S6/S7 outcome history verbatim; preserved S4 deferral verbatim | +51 |
| `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` (update) | Added concise `Status After Phase 261` section linking to the new S8 contract, noting the Disposition A default, and flagging the eleven-vs-twelve `CMD_COUNT` known mismatch in `tests/pi-end-to-end-validation.sh` line 792 / EXPECTED_SKILLS lines 48–58; preserved the S4 deferral and the prior S1/S2/S3/S5/S6/S7 outcome sections verbatim | +13 |
| `.paul/phases/261-s8-extraction-contract-bounded-submodule-plan/261-01-PLAN.md` (created at PLAN time) | Approved plan: objective, context, module dispatch, skills, AC-1..AC-4, 3 tasks, boundaries, verification, success criteria | 261 |
| `.paul/STATE.md` (lifecycle update) | Current Position, Last activity, Progress, Loop Position, Git State, Session Continuity updated for v2.61 milestone creation, Phase 261 PLAN/APPLY/UNIFY transitions | (lifecycle artifact) |
| `.paul/ROADMAP.md` (lifecycle update) | v2.61 Current Milestone block + 4 phase sections + v2.60 closure note + Phase 261 plan reference | (lifecycle artifact) |
| `.paul/MILESTONES.md` (lifecycle update) | Live Status row + Current pointer + recommendation forward to v2.62 + footer | (lifecycle artifact) |
| `.paul/handoffs/archive/HANDOFF-2026-05-07-v2-61-created-ready-phase-261.md` (archived) | Archived from active root location during `/paul:resume` | (lifecycle artifact) |

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| **AC-1** | S8 extraction contract exists and is bounded | ✓ PASS | `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md` exists (283 LOC); contains the four cited S8 functions (`getCommand` ×8, `toWrapperCommand` ×11, `detectCommandSignal` ×7, `getQuickActions` ×10), the cited `COMMANDS` constant with all twelve entries enumerated verbatim (`paul-init` ×1, `paul-review` ×4 — both proving full enumeration ran), the closure-routing surface trio, the four command-routing constants with exact-string values (`COMMAND_ACTIVATION_TURN_BUDGET = 3` ×3, `PROMPT_ACTIVATION_TURN_BUDGET = 1` ×3, `PRIMARY_QUICK_ACTION_LIMIT = 3` ×4, `MAX_QUICK_ACTIONS = 5` ×5), the two inline types, shared-input disposition (`markActivation` ×10), Pi-runtime mutation invocation rule (`pi.sendUserMessage` ×7, `pi.registerCommand` ×2, `pi.registerShortcut` ×2), no-UI-only-lifecycle-decisions invariant ×2, no-inferred-merge-intent invariant ×4, S4 canonical reply delivery boundary ×3, Phase 262 handoff with explicit Disposition A (×7) and Disposition B (×5), and the eleven-vs-twelve `CMD_COUNT` known mismatch flag (×5). |
| **AC-2** | Command-surface byte-sequence and authority invariants are preserved | ✓ PASS | Every `/paul-*` command name catalogued exactly (twelve entries verbatim including `paul-review`); all five `Key.ctrlAlt("[nsrhm]")` shortcut bindings cited (`Key.ctrlAlt` ×7) with exact `Ctrl+Alt+[NSRHM]` shortcut-hint strings; the four command-routing constants documented as exact-string single-defined; the canonical `/paul-*` → `/skill:paul-*` routing rule explicit (every command handler funnels through `routeCommand` → `pi.sendUserMessage(skillCmd)` exactly once per activation after `markActivation("command", wrapperCmd, COMMAND_ACTIVATION_TURN_BUDGET)`); S4 canonical reply delivery boundary preserved; no-UI-only-lifecycle-decisions, transcript-visible canonical replies, no auto-approval, no auto-continue, no skipped checkpoints, no inferred merge intent, `.paul/*` authority, module evidence, GitHub Flow evidence, and command-output validation truth all explicitly named in the contract. |
| **AC-3** | Phase 262 source-change boundary is executable | ✓ PASS | Contract names exact Phase 262 sibling target (`drivers/pi/extensions/command-routing.ts`); shape rules (loader-compat no-op default factory with literal `No-op Pi extension factory` JSDoc, single-defined `COMMANDS` with twelve entries, single-defined four constants, single-defined `CommandDef`/`QuickActionDef` types with `export`, helper-import tightening); `ActivationState` type-only back-import disposition; value-imports for `compactWhitespace`/`parsePalsState`/`markActivation` from `./pals-hooks`; explicit registration-site rule (the `for (const cmd of COMMANDS)` loop and the five Ctrl+Alt invocation sites stay byte-for-byte inside `registerPalsLifecycleHooks` in `pals-hooks.ts`); explicit Disposition A vs Disposition B with Disposition A as the default and Disposition B as the safe fallback; install surface 7 → 8 (+1 sibling); TAP-assertion repoint discipline (Phase 254/258 precedent — line-815 `EXT_SRC` guardrail repointed if Disposition A applied); the `CMD_COUNT == 11` assertion at line 792 over EXPECTED_SKILLS flagged as a known eleven-vs-twelve mismatch for Phase 262 to surface from command output. |
| **AC-4** | Phase 261 remains docs-only and validation-backed | ✓ PASS | `git diff --name-only 3201c00f..HEAD` shows only docs files (`docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md`, `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md`, `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md`) plus `.paul/*` lifecycle artifacts; no `drivers/`, `tests/`, installer, dependency, CI, kernel, module-registry, Claude Code driver, Agent SDK driver, or installed-runtime-copy file modified. `git diff --check` clean. Pi 234/235 with one inherited `not ok 98 - Repo ROADMAP stays within active-window line budget`; cross-harness 136/137 with one inherited `not ok 31` (same root cause). Both regressions inherited from the v2.61 milestone-creation commit `63607289` (unchanged by Phase 261); flagged for Phase 264 / v2.62 reconciliation per Path A baseline. install 7 Pi extension files (unchanged). artifact_consistency PASS. |

## Verification Results

```text
=== Pi end-to-end validation ===
1..235
# Passed: 234
# Failed: 1
# Total:  235
not ok 98 - Repo ROADMAP stays within active-window line budget
  (inherited from v2.61 milestone-creation commit 63607289; unchanged by Phase 261)

=== Cross-harness validation ===
1..137
# Passed: 136
# Failed: 1
# Total:  137
not ok 31 - Repo ROADMAP stays within active-window line budget
  (same inherited root cause; unchanged by Phase 261)

=== artifact_consistency ===
artifact_consistency_check: PASS

=== git diff --check ===
✓ clean

=== install (PALS_ROOT=$PWD bash drivers/pi/install.sh) ===
[ok] Pi extension installed: ~/.pi/agent/extensions/artifact-slice-rendering.ts
[ok] Pi extension installed: ~/.pi/agent/extensions/guided-workflow-detection.ts
[ok] Pi extension installed: ~/.pi/agent/extensions/lifecycle-ui.ts
[ok] Pi extension installed: ~/.pi/agent/extensions/module-activity-parsing.ts
[ok] Pi extension installed: ~/.pi/agent/extensions/pals-context-injection.ts
[ok] Pi extension installed: ~/.pi/agent/extensions/pals-hooks.ts
[ok] Pi extension installed: ~/.pi/agent/extensions/workflow-resource-capsule-rendering.ts
[ok] Pi extensions installed: 7 files

=== changed-file scope (git diff --stat 3201c00f..HEAD; non-.paul/) ===
docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md  | 283 +++
docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md |  51 +-
docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md    |  13 +
3 files changed, 346 insertions(+), 1 deletion(-)
(plus .paul/ lifecycle artifacts)

=== focused marker checks (S8 contract) ===
  paul-init: 1, paul-review: 4, Key.ctrlAlt: 7
  PRIMARY_QUICK_ACTION_LIMIT = 3: 4, MAX_QUICK_ACTIONS = 5: 5
  COMMAND_ACTIVATION_TURN_BUDGET = 3: 3, PROMPT_ACTIVATION_TURN_BUDGET = 1: 3
  pi.sendUserMessage: 7, pi.registerCommand: 2, pi.registerShortcut: 2
  markActivation: 10, getCommand: 8, toWrapperCommand: 11
  detectCommandSignal: 7, getQuickActions: 10
  S4 canonical: 3, no UI-only lifecycle decisions: 2, no inferred merge intent: 4
  Disposition A: 7, Disposition B: 5, CMD_COUNT: 5
```

### Validation count reconciliation

- Pi: baseline 235/235 (post-v2.60 closure on `main`) → Phase 261 235 total checks; 234 pass, 1 fail; **no count delta** (235 → 235) and **no new pass delta** introduced by Phase 261 itself. The single failing check (`not ok 98`) was introduced by the v2.61 milestone-creation commit `63607289` and is unchanged by Phase 261's docs-only scope. Path A baseline (proceed-with-documented-inherited-regression) per `/paul:apply` reconciliation; Phase 264 / v2.62 owns reconciliation.
- Cross-harness: baseline 137/137 (post-v2.60 closure on `main`) → Phase 261 137 total; 136 pass, 1 fail; **no count delta** (137 → 137) and **no new pass delta** introduced by Phase 261 itself. Same inherited root cause (`not ok 31`).
- Install: 7 Pi extension files (unchanged). The new sibling lands in Phase 262 (7 → 8).

## Module Execution Reports

### Pre-Plan (recorded in PLAN module_dispatch block)

- **Config-version:** `pals.json` schema_version 2.0.0 matches installed `modules.yaml` kernel_version 2.0.0; no migration needed.
- **Planning posture:** direct-requirements | collaboration medium.
- **Advisory:** TODD (no test conversion required) · IRIS (avoid TODO/FIXME/HACK/XXX in new contract) · DAVE (no CI config; warn only) · DOCS (no doc drift concern for docs-only contract) · RUBY (compact contract recommended; broader validation-script size-debt remains queued v2.62 candidate) · ARCH (docs-only; no architecture boundary concerns) · ARIA/DANA/GABE/LUKE/OMAR/PETE/REED/SETH/VERA (no UI/data/API/UX/observability/performance/resilience/secret/privacy concerns; SETH secret scan PASS).
- **CODI:** docs-only Phase 261; no source files modified; CODI seed candidates (4 cited S8 functions, `COMMANDS`, closure-routing surface trio, 4 command-routing constants, 2 inline types) recorded for downstream Phase 262 reference.
- **Enforcement (DEAN):** PASS — no dependency manifest changes.

### Pre-Apply

- **Baseline collection:** validation commands detected (Pi e2e, cross-harness, artifact_consistency); planned task order T1 → T2 → T3.
- **DEAN enforcement:** PASS — no dependency manifest changes.
- **WALT baseline:** Pi 234/235 (1 inherited `not ok 98` from `63607289`), cross-harness 136/137 (1 inherited `not ok 31` same root cause), artifact_consistency PASS, install 7 — established for post-task and post-apply comparison; Path A baseline approved (proceed-with-documented-inherited-regression).

### Post-Task

- **Task 1 (Create S8 contract):** IRIS PASS (no unresolved markers) · DEAN PASS · WALT PASS-with-documented-inherited-regression (no new regression introduced; inherited regression unchanged).
- **Task 2 (Update extraction baseline + modularization contract):** IRIS PASS · DEAN PASS · WALT PASS-with-documented-inherited-regression.
- **Task 3 (Verify docs-only scope + validation):** IRIS PASS · DEAN PASS · WALT PASS-with-documented-inherited-regression · DAVE PASS.

### Post-Apply

- **Advisory:**
  - IRIS: 0 unresolved markers (TODO/FIXME/HACK/XXX) in any modified file ✓
  - DOCS: docs catalog updated; new contract + 2 doc updates surfaced; new contract cross-linked from baseline + modularization contract ✓
  - RUBY: new contract 283 lines, baseline 354 lines, modularization contract 363 lines — all under 500-line god-file threshold ✓; broader validation-script size-debt remains queued v2.62 candidate ✓
  - ARCH: docs-only changes; no architecture boundary impact ✓
  - SETH: secret scan over modified docs found no secrets ✓
- **Enforcement:**
  - WALT: tests/lint/typecheck baseline preserved per Path A (Pi 234/235, cross-harness 136/137, artifact_consistency PASS) — no new regression vs pre-apply baseline; PASS-with-documented-inherited-regression ✓
  - DAVE: no CI config changes; no Dockerfile changes; no deploy concerns; PASS ✓
  - DEAN: no dependency manifest changes; no audit deltas; PASS ✓
  - TODD: docs-only contract phase; advisory; no test conversion required; PASS ✓

### Pre-Unify

- **WALT:** annotations_from_apply: Pi 234/235, cross-harness 136/137, artifact_consistency PASS, install 7 (unchanged); ready for SUMMARY/QUALITY-HISTORY persistence; inherited regression flagged for Phase 264 / v2.62 reconciliation.
- **DOCS:** Phase 261 is the docs-only contract scope; the 6th sibling-surfacing-recipe ratification target is Phase 263 (per Phase 244/247/251/255/259 precedent).
- **IRIS:** no unresolved markers in modified files.
- **RUBY:** all docs under god-file threshold; broader validation-script size-debt remains deferred (queued v2.62).
- **CODI:** Phase 261 docs-only; no source impact graph change to record; CODI seed candidates recorded in PLAN module_dispatch for downstream Phase 262.

### Post-Unify

- **QUALITY-HISTORY persistence:** Phase 261 entry to be appended to `.paul/QUALITY-HISTORY.md` recording docs-only contract phase, Path A baseline preservation (Pi 234/235, cross-harness 136/137), and module dispatch evidence.
- **CODI-HISTORY persistence:** Phase 261 entry to be appended to `.paul/CODI-HISTORY.md` recording the recorded CODI seed candidates (4 cited S8 functions, `COMMANDS`, closure-routing surface trio, 4 command-routing constants, 2 inline types) for downstream Phase 262 reference; no source impact graph delta (`skipped-no-symbols`).
- **PROJECT.md evolution:** to be updated by transition step (route to next-phase routing — Phase 262 ready to plan).

### GitHub Flow Evidence

- **PR:** [#176](https://github.com/coctostan/pals/pull/176) — branch `feature/261-s8-extraction-contract-bounded-submodule-plan` from commit `88690c40`.
- **CI:** Socket Security: Project Report SUCCESS (2026-05-07T13:55:59Z), Socket Security: Pull Request Alerts SUCCESS (2026-05-07T13:55:58Z).
- **mergeStateStatus:** CLEAN; **mergeable:** MERGEABLE.
- **Reviews:** `require_reviews=false` per `pals.json`; skipped.
- **REV pr_review:** `pr_review=false` per `pals.json`; skipped.
- **Merge method:** squash with `--delete-branch` per `pals.json`.

## Skill audit

All required skills invoked ✓
- `/paul` (lifecycle): active throughout PLAN/APPLY/UNIFY
- `/carl` (session boundary): automatic monitoring (no boundary fired this session)
- TODD (TDD enforcement): advisory dispatch recorded; docs-only contract — no test conversion required
- WALT (quality gating): validation gating across pre-apply, post-task, post-apply, pre-unify; PASS-with-documented-inherited-regression (Path A)

## Deviations

Plan and execution aligned; one documented validation deviation:

- **Files modified:** matched plan's `files_modified` frontmatter (3 docs targets) plus the lifecycle artifacts the plan explicitly designates (`.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/MILESTONES.md`, `.paul/MILESTONES.md`, `.paul/phases/261-…/261-01-PLAN.md`, archived handoff). No drift.
- **Task structure:** 3 tasks executed inline (parent-owned APPLY); no delegation to `pals-implementer` (docs-only contract did not warrant delegation overhead).
- **Acceptance criteria:** AC-1, AC-2, AC-3, AC-4 all PASS.
- **Validation counts (Path A documented inherited regression):** plan expected Pi 235/235 and cross-harness 137/137 unless command output proved a reconciled count change. Actual Pi 234/235 (1 fail) and cross-harness 136/137 (1 fail), both inherited from the v2.61 milestone-creation commit `63607289` (`not ok 98` and `not ok 31`, same `Repo ROADMAP stays within active-window line budget` root cause). The regression existed before Phase 261 began and is unchanged by Phase 261's docs-only scope. Phase 261 explicitly chose Path A (proceed-with-documented-inherited-regression) and routes reconciliation to Phase 264 / v2.62 — Phase 264 (Evidence Closure + Next-Roadmap Decision) is the natural reconciliation point inside v2.61, and any residual ROADMAP active-window structural concerns can be lifted into v2.62 if they survive the closure pass.

## Key Patterns / Decisions

### Patterns ratified (existing — applied here)

- **Sibling-extraction-contract recipe** (S6 Phase 257 → S8 Phase 261): docs-only contract phase that catalogues every byte-sequence-preservation invariant, names exact source targets for the source-changing phase, and explicitly forbids extraction of S4 canonical reply delivery and previously-extracted siblings. **6th application** of the contract recipe (S5/S1/S2/S3/S7/S6 → S8).
- **Type-only back-import pattern** (Phase 254 → Phase 258 → Phase 261 contract): the S8 contract requires `import type { ActivationState } from "./pals-hooks"` to keep the runtime dependency graph acyclic. **3rd ratification** target (Phase 262 will apply).
- **TAP-assertion repoint pattern** (Phase 254 → Phase 258 → Phase 261 contract): the S8 contract's Phase 262 handoff requires repointing any Pi or cross-harness assertion that names the source file/path of an S8 function or constant to the new sibling, byte-equivalent rather than merely semantically equivalent. **3rd ratification** target (Phase 262 will apply).
- **`inline → export` promotion pattern** (Phase 254 promoted helpers; Phase 258 promoted four S6-supporting symbols → Phase 261 contract requires `markActivation` promotion in Phase 262). **3rd ratification** target (Phase 262 will apply).
- **Closure-guardrail recipe** (Phase 245/248/252/256/260): the S8 contract names the line-815 `EXT_SRC` guardrail repoint requirement and Phase 264 will add the v2.61 closure marker (5× ratified durable; Phase 264 = 6th application target).
- **Recommendation-not-approval boundary** (5× ratified): v2.60 closure recommendation was an input to `/paul:milestone`, not an approval; Q1=a confirmed v2.61 selection.
- **Sibling-surfacing recipe** (Phase 244/247/251/255/259): Phase 263 = 6th application target; out of Phase 261 scope.

### New decisions recorded

- **Second runtime-coupled extraction:** S8 is the second sibling that mutates Pi runtime state (registers commands and shortcuts on Pi via `pi.registerCommand` / `pi.registerShortcut` and sends user messages via `pi.sendUserMessage`) rather than purely producing strings (after S6's `setStatus`/`setWidget` mutation in Phase 258). The contract reinforces preservation of every existing `pi.registerCommand(cmd.name, …)` invocation, every existing `registerQuickActionShortcut(Key.ctrlAlt(…), …)` invocation, and the canonical `/paul-*` → `/skill:paul-*` routing rule (every command handler funnels through `routeCommand` → `pi.sendUserMessage(skillCmd)` exactly once per activation).
- **Disposition A vs Disposition B made explicit:** Disposition A (preferred — full sibling extraction) moves the three closure factories `routeCommand` / `routeWrapperCommand` / `registerQuickActionShortcut` to the new sibling and re-imports them as factory functions; Disposition B (safe-fallback) keeps the closure factories inline in `pals-hooks.ts` and only moves the four pure functions, `COMMANDS`, the four constants, and the two types. The contract specifies Disposition A as the default and Disposition B as the safe fallback only if Disposition A surfaces unexpected closure-state coupling during Phase 262 implementation.
- **Eleven-vs-twelve `CMD_COUNT` known mismatch flagged:** `tests/pi-end-to-end-validation.sh` line 792 asserts `CMD_COUNT == 11` over an EXPECTED_SKILLS list of eleven `paul-*` skill names (lines 48–58), but the `COMMANDS` array contains twelve entries (`paul-review` is the twelfth). The contract MUST require Phase 262 to surface this discrepancy from command output rather than guess; Phase 264 closure will reconcile if needed.
- **No-UI-only-lifecycle-decisions invariant reinforced for the user-facing command surface:** the S8 surface IS the user-facing UI surface; extracting it MUST NOT introduce any code path where command activation drives lifecycle state without a transcript-visible canonical reply.
- **Path A documented-inherited-regression baseline:** Phase 261 explicitly chose to proceed with the inherited `not ok 98` / `not ok 31` ROADMAP active-window line-budget regression (introduced by the v2.61 milestone-creation commit `63607289`) rather than reconciling in-flight, because Phase 261 is docs-only contract scope and the regression is a docs/lifecycle-budget concern best handled by Phase 264 closure or v2.62. This is the first formal `Path A baseline` invocation in v2.61.

## Next Phase

**Phase 262: Bounded S8 Submodule Extraction** (next).

Phase 262 will perform the source extraction authorized by this contract. The Phase 262 handoff in `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md` lists the exact acceptance checklist:

- New sibling `drivers/pi/extensions/command-routing.ts` exists with the four cited S8 functions, the `COMMANDS` array (twelve entries verbatim), the four command-routing constants (`COMMAND_ACTIVATION_TURN_BUDGET = 3`, `PROMPT_ACTIVATION_TURN_BUDGET = 1`, `PRIMARY_QUICK_ACTION_LIMIT = 3`, `MAX_QUICK_ACTIONS = 5`), and the two types (`CommandDef`, `QuickActionDef` — exported); loader-compat default factory present with literal `No-op Pi extension factory` JSDoc.
- `pals-hooks.ts` no longer defines the moved S8 functions or constants; imports them from `./command-routing`.
- `markActivation` promoted to top-level `export` in `pals-hooks.ts` (third application of the `inline → export` promotion pattern); type-only back-import for `ActivationState`; value-imports for `compactWhitespace`, `parsePalsState`, `markActivation`.
- Disposition A applied (closure factories `routeCommand` / `routeWrapperCommand` / `registerQuickActionShortcut` moved as factory functions), or Disposition B (closure factories stay inline) if Disposition A surfaces closure-state coupling — the SUMMARY MUST record which disposition shipped.
- The `for (const cmd of COMMANDS) { pi.registerCommand(cmd.name, …) }` loop and the five `registerQuickActionShortcut(Key.ctrlAlt("[nsrhm]"), …)` invocations remain byte-for-byte inside `registerPalsLifecycleHooks` in `pals-hooks.ts`.
- Every `/paul-*` name byte sequence preserved (twelve entries); every Ctrl+Alt shortcut binding preserved (five entries); every command-routing constant value preserved exact-string single-defined; the canonical `/paul-*` → `/skill:paul-*` routing rule preserved.
- S4 canonical reply delivery, S5/S1/S2/S3/S7/S6 siblings, shared helpers, and `RecentModuleActivity` ownership all unchanged.
- Install reports 8 Pi extension files (7 → 8).
- Pi/cross-harness/artifact_consistency validation pass; counts reconciled from command output; the eleven-vs-twelve `CMD_COUNT` mismatch surfaced and reconciled.
- TAP-assertion repoint discipline applied where any assertion names a moved source path.
- PR opened, CI green, squash-merge with branch deletion.

After Phase 262 ships, Phase 263 (Documentation + Validation Surfacing) and Phase 264 (Evidence Closure + Next-Roadmap Decision) close v2.61. Phase 264 also reconciles the inherited Path A `not ok 98` / `not ok 31` regression or escalates to v2.62.
