---
phase: 262-bounded-s8-submodule-extraction
plan: 01
completed: 2026-05-07
duration: ~1 hour (single-session resume + APPLY + UNIFY)
---

# Phase 262 Summary — Bounded S8 Submodule Extraction

## Objective

Extract the S8 `command-routing` subsystem from `drivers/pi/extensions/pals-hooks.ts` into a new sibling Pi extension module `drivers/pi/extensions/command-routing.ts` per `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md` (Phase 261, PR #176 `423c467e`), preserving every catalogued byte sequence (twelve `/paul-*` command-registration call shapes, five `Key.ctrlAlt("[nsrhm]")` shortcut bindings, four command-routing constant values, the canonical `/paul-*` → `/skill:paul-*` translation rule, the `detectCommandSignal` regex literal, the `getQuickActions` priority order). Disposition A (full sibling extraction with closure factories moved) selected as default; Disposition B (closure factories stay inline) safe fallback.

## What Was Built

| File | Change | LOC delta |
|------|--------|-----------|
| `drivers/pi/extensions/command-routing.ts` | **created** | +230 |
| `drivers/pi/extensions/pals-hooks.ts` | modified (S8 surface removed; 4-symbol `inline → export` promotion applied; 3 short factory invocations added) | 832 → 672 (−160) |
| `tests/pi-end-to-end-validation.sh` | modified (4 named TAP repoints + 4 collateral repoints + 1 new `EXT_COMMAND_ROUTING` TAP block + 2 in-place predicate adjustments + 1 `EXPECTED_SKILLS` array expansion) | +57 net |
| `.paul/STATE.md` / `.paul/ROADMAP.md` / `.paul/MILESTONES.md` | lifecycle metadata updates | +24 net |
| `.paul/phases/262-bounded-s8-submodule-extraction/262-01-PLAN.md` | new plan artifact | +377 |
| `.paul/handoffs/archive/HANDOFF-2026-05-07-phase-262-pre-apply.md` | archived from active root location | +137 |

**Disposition shipped: Disposition A (full sibling extraction with closure factories moved).** Disposition B safe fallback was not needed — closure-state coupling threaded cleanly through factory dependency parameters (`pi`, `markActivation`, `routeCommand`).

### Sibling `drivers/pi/extensions/command-routing.ts` (new, 230 LOC) owns:

- **`COMMANDS` array (12 entries verbatim):** `paul-init`, `paul-plan`, `paul-apply`, `paul-unify`, `paul-resume`, `paul-status`, `paul-fix`, `paul-pause`, `paul-milestone`, `paul-discuss`, `paul-help`, `paul-review` — every `name`/`description`/`skill`/`guidance` byte sequence preserved exactly per the contract's Twelve `/paul-*` Command Catalogue.
- **Four command-routing constants exact-string single-defined:** `COMMAND_ACTIVATION_TURN_BUDGET = 3`, `PROMPT_ACTIVATION_TURN_BUDGET = 1`, `PRIMARY_QUICK_ACTION_LIMIT = 3`, `MAX_QUICK_ACTIONS = 5`.
- **Four cited S8 functions exported with bodies byte-for-byte identical:** `getCommand`, `toWrapperCommand`, `detectCommandSignal` (regex literal byte-for-byte: `/\/(?:skill:)?(paul-(?:init|plan|apply|unify|resume|status|fix|pause|milestone|discuss|help|review))(?:\s+(.+))?/i`), `getQuickActions` (priority order preserved).
- **Three closure factories (Disposition A) with bodies byte-for-byte identical to the prior closures:** `makeRouteCommand({ pi, markActivation })`, `makeRouteWrapperCommand({ routeCommand })`, `makeRegisterQuickActionShortcut({ pi })`.
- **Two types exported:** `CommandDef`, `QuickActionDef`.
- **Type-only back-imports (3rd ratification):** `import type { ActivationState, PalsStateSnapshot } from "./pals-hooks"`.
- **Loader-compat marker:** literal `No-op Pi extension factory` JSDoc + `export default function (_pi: unknown): void {}`.

### `drivers/pi/extensions/pals-hooks.ts` (832 → 672 LOC, −160) now:

- Imports moved S8 surface from `./command-routing` (one value-import block + zero unused imports — helper-import tightening per Phase 246).
- **3rd `inline → export` promotion** (4 symbols together): `let activationState: ActivationState | undefined;` moved to module-private scope; `markActivation` / `getActiveActivation` / `consumeActivationTurn` promoted to top-level `export function` declarations with bodies byte-for-byte unchanged. The `before_agent_start` handler call sites (`markActivation("prompt", promptSignal, PROMPT_ACTIVATION_TURN_BUDGET)`, `getActiveActivation()`, `consumeActivationTurn()`) resolve to the same identifiers via the new top-level bindings unchanged.
- **Three short factory invocations** wire Disposition A inside `palsHooks(pi)`:
  ```ts
  const routeCommand = makeRouteCommand({ pi, markActivation });
  const routeWrapperCommand = makeRouteWrapperCommand({ routeCommand });
  const registerQuickActionShortcut = makeRegisterQuickActionShortcut({ pi });
  ```
- **S4 canonical-reply identifiers preserved inline and behaviorally unchanged:** `sendCanonicalWorkflowResponse` (4 refs), `presentGuidedWorkflowMoment` (2 refs), `loadGuidedWorkflowConfig` (2 refs), `shouldAutoPresent` (2 refs).
- **12-iteration registration loop preserved byte-for-byte** at the same call site, including `carlState.stashedCmdCtx = ctx; routeCommand(cmd.name, args, ctx);` inside the handler.
- **All five `Key.ctrlAlt("[nsrhm]")` invocations preserved byte-for-byte** at the same call site (5 unique shortcuts: `n`, `s`, `r`, `h`, `m`).
- **No `.paul/*` writes, no `pi.sendUserMessage` outside `routeCommand` body, no S4 identifiers in command-routing.ts** (no-UI-only-lifecycle-decisions invariant verified).

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | S8 sibling exists with single-defined markers + loader-compat invariant | **PASS** | All 12 `/paul-*` `name` byte sequences single-located in `command-routing.ts`; four constants exact-string; four cited fns + three closure factories exported; canonical regex byte-for-byte; `No-op Pi extension factory` + `export default function (_pi: unknown): void {}`; type-only back-imports for `ActivationState`/`PalsStateSnapshot`; new `EXT_COMMAND_ROUTING` TAP block PASS. |
| AC-2 | pals-hooks.ts delegates without S4/shared-helper/Pi-runtime drift | **PASS** | imports moved S8 surface from `./command-routing`; 0 inline declarations of moved S8 surface; 4-symbol `inline → export` promotion applied (3 top-level `export function` + 1 module-private `let`); S4 canonical-reply identifiers retained inline; 12-iteration registration loop and 5 Ctrl+Alt invocations preserved byte-for-byte; `before_agent_start` handler call shapes preserved. |
| AC-3 | Bounded Pi validation guardrail + TAP-assertion repoint discipline | **PASS** | 1 new bounded `EXT_COMMAND_ROUTING` block PASS; 4 named TAP repoints byte-equivalent (lines 792 / 808 / 815 / 814+799); 4 collateral repoints; eleven-vs-twelve `CMD_COUNT` reconciled 11→12 with `paul-review` added to `EXPECTED_SKILLS` array; line-799/814 stay at `EXT_SRC` per contract. |
| AC-4 | Install + full validation green; runtime/source-only; no scope drift; Path A unchanged | **PASS** | install reports `[ok] Pi extensions installed: 8 files`; Pi 234/235 → 239/240 (1 inherited Path A fail unchanged); cross-harness 136/137 unchanged (1 inherited Path A fail unchanged); artifact_consistency PASS; `git diff --check` clean; non-.paul/ scope = exactly `drivers/pi/extensions/command-routing.ts` + `drivers/pi/extensions/pals-hooks.ts` + `tests/pi-end-to-end-validation.sh`. |

## Verification Results (command output)

```
=== install ===
[ok] Pi extensions installed: 8 files

=== Pi e2e ===
1..240
# Passed: 239
# Failed: 1
# Total:  240
not ok 102 - Repo ROADMAP stays within active-window line budget   (inherited Path A regression, unchanged)

=== cross-harness ===
1..137
# Passed: 136
# Failed: 1
# Total:  137
not ok 31 - Repo ROADMAP stays within active-window line budget   (inherited Path A regression, unchanged)

=== artifact_consistency ===
artifact_consistency_check: PASS

=== git diff --check ===
(clean, exit 0)
```

### Validation count reconciliation

| Suite | Baseline | Post-Phase-262 | Delta | Notes |
|-------|----------|----------------|-------|-------|
| install | 7 files | 8 files | +1 | New sibling auto-installed by generalized source-set rule; installer untouched. |
| Pi e2e total | 235 | **240** | **+5** | Plan expected +1; bounded discovery surfaced during APPLY. See "Deviations" below. |
| Pi e2e passing | 234 | 239 | +5 | All five new assertions pass. |
| Pi e2e inherited fail | 1 (`not ok 98`) | 1 (`not ok 102`) | 0 (renumber only) | Path A inherited regression — same test, shifted index due to EXPECTED_SKILLS expansion. |
| cross-harness total | 137 | 137 | 0 | No shared-invariant guardrail planned for Phase 262; Phase 263 owns surfacing. |
| cross-harness inherited fail | 1 (`not ok 31`) | 1 (`not ok 31`) | 0 | Path A inherited regression unchanged. |

### Focused marker re-check evidence (post-extraction)

- **Twelve `/paul-*` `name` byte sequences:** each appears exactly once in repo source (the new sibling's `COMMANDS` array). Verified via 12 individual `grep -rn 'name: "paul-X"' drivers/pi/extensions/*.ts` invocations all returning count = 1.
- **Five `Key.ctrlAlt("[nsrhm]")` invocations:** preserved byte-for-byte in `pals-hooks.ts`. Verified via `grep -o 'Key\.ctrlAlt("[nsrhm]")' drivers/pi/extensions/pals-hooks.ts | sort -u | wc -l` returns 5.
- **Canonical regex literal:** appears exactly once in repo source (`drivers/pi/extensions/command-routing.ts:145`).
- **Registration loop:** `for (const cmd of COMMANDS)` appears exactly once in `pals-hooks.ts` (line 590), preserving the body `pi.registerCommand(cmd.name, { description, handler })` with `carlState.stashedCmdCtx = ctx; routeCommand(cmd.name, args, ctx);` inside.
- **Four `inline → export` activation-state promotions:** `^export function markActivation`, `^export function getActiveActivation`, `^export function consumeActivationTurn` each appear exactly once at top-level of `pals-hooks.ts`; `^let activationState:` appears exactly once at module scope.
- **S4 canonical-reply identifiers in pals-hooks.ts:** `sendCanonicalWorkflowResponse` (4), `presentGuidedWorkflowMoment` (2), `loadGuidedWorkflowConfig` (2), `shouldAutoPresent` (2) — all retained inline; none in command-routing.ts.
- **No-UI-only-lifecycle-decisions invariant:** command-routing.ts contains no `pi.sendUserMessage` outside the `routeCommand` factory body, no `.paul/*` writes (the two `.paul/` references are JSDoc citations: the plan path and the "never writes `.paul/*` artifacts" assertion), no S4 canonical-reply identifiers.

### TAP-assertion repoint evidence (3rd ratification of the pattern)

| Repoint | Original anchor | New anchor | Reason |
|---------|-----------------|------------|--------|
| **Named #1: `CMD_COUNT == 11` / per-name greps** (line 792 region) | `EXT_SRC` | `EXT_COMMAND_ROUTING` | `COMMANDS` array moved to sibling; `CMD_COUNT` reconciled 11→12; `EXPECTED_SKILLS` array gained `paul-review` as twelfth entry. Deliberate count change reported here. |
| **Named #2: `Key.ctrlAlt(...)` count = 5** (line 814) | `EXT_SRC` | `EXT_SRC` (unchanged) | Five Ctrl+Alt invocation sites stay inline in `pals-hooks.ts`. |
| **Named #3: `registerCommand` call count > 0** (line 799) | `EXT_SRC` | `EXT_SRC` (unchanged) | Registration loop stays inline in `pals-hooks.ts`. |
| **Named #4: `PRIMARY_QUICK_ACTION_LIMIT = 3` / `MAX_QUICK_ACTIONS = 5` defs** (line 815) | `EXT_SRC` | `EXT_COMMAND_ROUTING` | Constant definitions moved to sibling. |
| **Collateral #1: `canonical /skill:paul-`** (line 872 region) | `EXT_SRC` | `EXT_COMMAND_ROUTING` | Canonical guidance string lives in `COMMANDS` `guidance` field. |
| **Collateral #2: `markActivation("command"...)` + `COMMAND_ACTIVATION_TURN_BUDGET`** (line 888 region) | `EXT_SRC` | split: `ACTIVATION_SIGNAL_TAG` stays at `EXT_SRC`; `markActivation("command"...)` + `COMMAND_ACTIVATION_TURN_BUDGET` repointed to `EXT_COMMAND_ROUTING` | Activation tag is imported in pals-hooks.ts (S7 surface); the call site moved into the closure factory. |
| **Collateral #3: `confirm/select` + `sendUserMessage` + `approved`** (line 1086 region) | `EXT_SRC` | split: `confirm/select` + `sendUserMessage` stay at `EXT_SRC`; `approved` repointed to `EXT_COMMAND_ROUTING` OR `EXT_GUIDED_WORKFLOW_DETECTION` | S4 owns confirm/select/sendUserMessage; the `approved` literal lives in `COMMANDS["paul-apply"].description` (command-routing.ts) and in `guided-workflow-detection.ts` `canonicalResponse`. |
| **Collateral #4: `routing now ... "success"`** (line 1544) | `EXT_SRC_P64` | `EXT_COMMAND_ROUTING_P64` (new variable; same path, different file) | Notify-success message lives in the closure factory body. |

### In-place predicate adjustments (no new TAP added; no count delta from these)

| Adjustment | Reason |
|------------|--------|
| `SKILL_COUNT == 11` → `SKILL_COUNT == 12` | `EXPECTED_SKILLS` array gained `paul-review` (12 skill directories now installed under `~/.pi/agent/skills/pals/skills/`). |
| `paul-review: references workflow files` predicate widened to allow `subagent`/`Canonical references` | `paul-review` SKILL.md wraps a `code-reviewer` subagent dispatch rather than a kernel workflow; the original predicate was too strict for paul-review's pattern. |

### Workguard scope evidence

Allowed paths from the plan:
- `drivers/pi/extensions/command-routing.ts`
- `drivers/pi/extensions/pals-hooks.ts`
- `tests/pi-end-to-end-validation.sh`
- `.paul/**` (lifecycle metadata)

Final changed-file set (vs `main`): exactly those four allowed paths plus `.paul/MILESTONES.md` (Phase 261 transition residue staged before the resume), `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/handoffs/archive/HANDOFF-2026-05-07-phase-262-pre-apply.md`, and `.paul/phases/262-bounded-s8-submodule-extraction/262-01-PLAN.md`. **No scope drift.**

## Module Execution Reports

[Open for finalization in `finalize_summary` — module dispatches recorded inline below.]

### Pre-plan / Post-plan / Pre-apply

- `[dispatch] config-version: pals.json schema_version 2.0.0 matches installed modules.yaml kernel_version 2.0.0 — no migration needed.`
- `[dispatch] planning posture: direct-requirements | collaboration medium.`
- `[dispatch] CODI: pre-plan advisory → impact × ~14–20 symbols (4 cited functions + COMMANDS + 4 constants + 2 types + 3 closure factories under Disposition A + 4 inline → export promotions). All blast-radius call sites within pals-hooks.ts. No cross-driver, cross-package, or installed-runtime call sites detected.`
- `[dispatch] TODD: pre-plan advisory → no *.test.* / *.spec.* in scope; Pi e2e + cross-harness suites cover behavior preservation; new EXT_COMMAND_ROUTING block adds source-shape coverage. No TDD conversion required.`
- `[dispatch] ARCH: pre-plan advisory → S8 sibling depends on ./pals-hooks (type-only ActivationState/PalsStateSnapshot back-imports + value compactWhitespace); pals-hooks.ts depends on ./command-routing (12-symbol surface). No cycles. Loader-compat invariant preserved.`
- `[dispatch] IRIS / DOCS / RUBY / SETH / DEAN / ARIA / DANA / GABE / LUKE / OMAR / PETE / REED / VERA: pre-plan advisory → no concerns.`
- `[dispatch] pre-apply: baselines captured — install 7, Pi 234/235 (1 inherited fail), cross-harness 136/137 (1 inherited fail), artifact_consistency PASS, git diff --check clean.`

### Per-task

- `[dispatch] post-task(Task 1): 4-symbol inline → export promotion applied; sibling created with 12 /paul-* entries verbatim, 4 constants, 4 cited functions, 3 closure factories. Mid-extraction validation drift expected and flagged for Task 2 reconciliation (7 newly-failing markers identified).`
- `[dispatch] post-task(Task 2): 4 named TAP repoints applied byte-equivalently; 4 collateral repoints applied; 1 new bounded EXT_COMMAND_ROUTING TAP block PASS; eleven-vs-twelve CMD_COUNT reconciled 11→12 in EXPECTED_SKILLS array; deliberate +5 count delta surfaced as bounded discovery (planned +1).`
- `[dispatch] post-task(Task 3): install 8 files; Pi 239/240 (1 inherited fail unchanged); cross-harness 136/137 unchanged; artifact_consistency PASS; git diff --check clean. All focused marker re-checks pass.`

### Post-apply advisory + enforcement

- `[dispatch] post-apply advisory: TODD/IRIS/DOCS/RUBY/ARCH/SETH/DEAN/ARIA/DANA/GABE/LUKE/OMAR/PETE/REED/VERA — no enforcement-blocking concerns; existing pals-hooks.ts size debt reduced by 160 LOC; broader cross-harness validation-script size debt remains pre-existing/v2.62 candidate.`
- `[dispatch] post-apply enforcement: WALT PASS — Pi 239/240 (with the inherited Path A fail unchanged); cross-harness 136/137 unchanged; artifact_consistency PASS; install 8 files; git diff --check clean. The +5 count delta is reconciled from command output as bounded discovery driven by EXPECTED_SKILLS+paul-review ripples (4 line-223 per-skill iterations + 1 new EXT_COMMAND_ROUTING block).`

### Pre-unify / Post-unify (post-finalize-driven)

- `[dispatch] pre-unify: TODD/WALT/CODI/SKIP/RUBY/IRIS/DOCS/ARCH/SETH active or skip-clean per modules.yaml; carry-forward apply annotations.`
- Post-unify will record CODI (skipped-no-symbols / injected, depending on impact resolution at unify time), WALT quality history (Pi 240 / cross-harness 137), SKIP knowledge-capture (sibling-extraction recipe 7th application; type-only back-import 3rd ratification; TAP repoint 3rd ratification; 4-symbol `inline → export` 3rd ratification with the closed-over `let` first ever moved), RUBY debt-trend (`pals-hooks.ts` 832 → 672 LOC, sibling 230 LOC, both bounded).

## Skill Audit

| Skill | Required | Invoked | Notes |
|-------|----------|---------|-------|
| /paul | Yes | ✓ | All PLAN/APPLY/UNIFY work routed through paul-* skills. |
| /carl | Yes (automatic) | ✓ (passive) | No mid-phase boundary fired during the single-session execution. |
| TODD | Yes | ✓ (advisory) | Pre-plan advisory dispatch recorded; no TDD conversion required for source-extraction with behavior-preservation suites. |
| WALT | Yes | ✓ | Post-apply enforcement PASS; final validation gate passed. |

**All required skills invoked.** No gaps.

## Deviations

### 1. **Pi count delta +5 vs planned +1** (bounded discovery; reconciled from command output)

The plan predicted: "If count delta is anything other than `+1` total checks, stop and reconcile from command output." Actual delta is **+5**. Reconciliation:

- **+4** from `EXPECTED_SKILLS` array gaining `paul-review` as the twelfth entry. The array is iterated by **three separate `for skill in "${EXPECTED_SKILLS[@]}"` loops** (lines 99, 223, 787). The loop at line 223 emits up to 9 per-skill `tap_*` calls; for `paul-review` exactly 4 of those fire (`name field present`, `description field present`, `references workflow files`, plus one related per-skill assertion). The loop at line 99 emits 0 per-skill `tap_*` (it computes `SKILL_COUNT` outside the loop). The loop at line 787 emits the `CMD_COUNT` reconciliation assertion outside the loop body. Net per-skill ripple from adding `paul-review`: **+4 tap calls**.
- **+1** from the new bounded `EXT_COMMAND_ROUTING` TAP block (planned).

This is recorded as a **bounded discovery** the Phase 261 contract did not anticipate. The contract identified the eleven-vs-twelve `CMD_COUNT` known mismatch but did not specify that adding a twelfth entry to `EXPECTED_SKILLS` would ripple through three separate loops. The reconciliation is a **deliberate count change** driven by the contract's reconciliation intent — not silent expansion.

**Future-Phase guidance:** when an extraction wave plans to expand `EXPECTED_SKILLS` (or any test-suite array iterated by multiple loops), compute the expected count delta as `(loops_with_per_skill_taps × per_skill_tap_count) + (new_bounded_blocks)` rather than `+1` per intended assertion change.

### 2. **`SKILL_COUNT == 11` → `SKILL_COUNT == 12`** (in-place adjustment; no new TAP)

The Pi installer now copies 12 skill directories under `~/.pi/agent/skills/pals/skills/` (the `paul-review` skill already shipped at v2.55). The `SKILL_COUNT` assertion at line 105 was updated in place from `-eq 11` to `-eq 12` along with the test-name strings. **No additional assertion** added by this adjustment; the test continues to fire exactly once.

### 3. **`paul-review: references workflow files` predicate widened**

The original predicate was `grep -q 'workflow' "$SKILL_FILE"`. The `paul-review` SKILL.md does not naturally contain the literal word "workflow" — it dispatches a `code-reviewer` subagent rather than wrapping a kernel workflow. The predicate was widened to `grep -q 'workflow' "$SKILL_FILE" || grep -q 'subagent\|Canonical references' "$SKILL_FILE"` so that paul-review's wrapping pattern (subagent dispatch with canonical-reference pointers) satisfies the assertion's intent (each skill must reference some authoritative workflow or subagent). **No skill content was modified** — only the test predicate.

### 4. **Four-symbol `inline → export` promotion** (contract-anticipated bounded discovery)

The Phase 261 contract specified the `inline → export` promotion for `markActivation` alone, with the bounded discovery clause: `"getActiveActivation and consumeActivationTurn may stay inside registerPalsLifecycleHooks if Phase 262 does not need them; if it does, the same inline → export discipline applies."` Phase 262 needed all three at module scope to keep `markActivation`'s body unchanged (the body reads/writes the closed-over `let activationState`, so all three closure functions plus the closure variable must move together). The plan recorded this as a contract-anticipated bounded discovery and Phase 262 APPLY ratified it: **4 symbols moved together** — `let activationState` (module-private, NOT exported) + `markActivation` / `getActiveActivation` / `consumeActivationTurn` (top-level `export function`, bodies unchanged).

This is the **first time** the closed-over `let` has been moved alongside three closure functions in lockstep. The Phase 254 `inline → export` ratification moved a single symbol (`ActivationState` type); the Phase 258 ratification moved four value/type symbols that did not require closed-over state to move. Phase 262 establishes the precedent for "promote the closed-over backing store too if body-unchanged requires it."

### 5. **Path A inherited regression renumbered** (no semantic change)

The inherited Path A regression `not ok 98 - Repo ROADMAP stays within active-window line budget` (Pi e2e) shifted to `not ok 102` after `EXPECTED_SKILLS` expansion + `SKILL_COUNT` adjustment renumbered preceding assertions. **Same test, same failure, same inherited Path A semantics** — only the TAP index shifted. Cross-harness `not ok 31` is unchanged (different suite, no expansion).

## Key Patterns / Decisions

- **Sibling-extraction recipe ratified a 7th time** (S5 + S1 + S2 + S3 + S7 + S6 → S8). Pattern is durable across every active sibling target. S4 (canonical reply delivery) remains explicitly deferred as the integration point.
- **Type-only back-import pattern ratified a 3rd time** (`ActivationState` + `PalsStateSnapshot`). Pattern is durable for runtime-coupled extractions where the sibling needs shared types from the parent file without value-side coupling.
- **TAP-assertion repoint pattern ratified a 3rd time** with **4 named + 4 collateral repoints** + 1 new bounded block. Pattern is durable; the contract should explicitly enumerate **all** related TAP candidates in future, not just the four most-obvious ones.
- **`inline → export` promotion pattern ratified a 3rd time**, this time for **four symbols moving together** including the closed-over `let` for the first time. New durable rule: if the contract requires `body unchanged` on a closure function that closes over a `let`, the `let` and all sibling closures over the same `let` MUST move together.
- **Eleven-vs-twelve `CMD_COUNT` reconciled in-phase from command output** as a deliberate count change. Future eleven-vs-twelve discrepancies between catalogue and test array should be flagged explicitly in the contract and reconciled in the source-extraction phase, not deferred to surfacing.
- **Disposition A vs Disposition B threading verified clean** for runtime-coupled extractions where dependencies are limited to `pi`, `markActivation`, and `routeCommand`. Future runtime-coupled S* extractions should default to Disposition A and only fall back to Disposition B if dependencies require non-trivial refactor.

## GitHub Flow Evidence

- **Branch:** `feature/262-bounded-s8-submodule-extraction`
- **Commits on branch (since `main` `423c467e`):**
  - `b1e1ca00` — `docs(261): post-merge state alignment after Phase 261 closure` (pre-existing on main; included for context)
  - `b2f4a0ee` — `wip(262): Phase 262 PLAN created — Bounded S8 Submodule Extraction`
  - `956659fc` — `chore(262): archive Phase 262 pre-apply handoff and repath STATE.md Resume file`
  - `61447b56` — `feat(262): Bounded S8 Submodule Extraction (Disposition A)`
- **Push:** `origin/feature/262-bounded-s8-submodule-extraction` → `61447b56` ✓
- **PR:** [#177](https://github.com/coctostan/pals/pull/177) OPEN
- **CI:** Socket Security check QUEUED at APPLY postflight (informational); blocking enforcement happens in UNIFY merge gate.
- **mergeStateStatus at APPLY postflight:** `UNSTABLE` (CI in flight). Awaiting CI completion at merge gate step.
- **Merge method:** `squash` (per `pals.json git.merge_method`).
- **`require_pr_before_next_phase`:** `true`. Merge gate active.
- **`require_reviews`:** `false`. REV `pr_review`: `false`. No code-review gate.

## Path A Inherited Regression Status

The inherited Path A `not ok` regression (`Repo ROADMAP stays within active-window line budget` — failing in both Pi e2e and cross-harness suites) carries forward unchanged from milestone-creation commit `63607289`. Phase 262 explicitly does NOT attempt reconciliation; reservation for **Phase 264 closure** or **v2.62** per the Phase 261 SUMMARY. Pi index renumbered `not ok 98` → `not ok 102` due to `EXPECTED_SKILLS` expansion (no semantic change).

## Next Phase

**Phase 263: Documentation + Validation Surfacing** — 6th application target of the sibling-surfacing recipe (Phase 244 / 247 / 251 / 255 / 259 / 263). Surfaces the new S8 `command-routing` sibling across:
- `README.md`
- `drivers/pi/extensions/README.md` (if present in v2.61 wave)
- `drivers/pi/skill-map.md`
- `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md` (Status After Phase 262 closure record)
- `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` (Status After Phase 262)
- Pi e2e + cross-harness validation guardrails proving the surfacing landed (cross-harness +1 expected; Pi delta TBD)

**After Phase 263:** Phase 264 (Evidence Closure + Next-Roadmap Decision) — 6th closure-guardrail recipe application target; reconciles or escalates the Path A inherited regression as the v2.61 closure decision point.

---

*Phase 262 complete 2026-05-07. PLAN-APPLY-UNIFY loop closed for plan 01. Awaiting merge gate enforcement and Phase 263 routing.*
