# Pi-Native Context-Offload Measurement + Next Target Ranking

**Phase:** 295 Context-Offload Measurement + Next Target Ranking  
**Status:** recommendation-only artifact; not runtime authority  
**Scope:** documentation, measurement, candidate ranking, and validation guardrails only. No implementation in Phase 295.

## Authority Boundary

This report is a derived planning aid. It does not authorize another runtime extraction, move lifecycle authority, write `.paul/*` from Pi runtime code, add telemetry, create hidden state, auto-approve, auto-continue, skip checkpoints, make UI-only lifecycle decisions, infer merge intent, or change current S3/S4 behavior.

Shared `.paul/*` artifacts, PLAN/APPLY/UNIFY, installed module evidence, GitHub Flow command evidence, transcript-visible canonical replies, and validation command output remain authoritative.

## Evidence Base

- Phase 293 contract: `docs/PI-NATIVE-GUIDED-WORKFLOW-CANONICAL-REPLY-DELIVERY-EXTRACTION-CONTRACT.md`.
- Phase 294 result: `.paul/phases/294-s4-canonical-reply-delivery-extraction/294-01-SUMMARY.md`.
- Original S1-S8 inventory: `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md`.
- Current Pi extension source set: `drivers/pi/extensions/*.ts`.
- Current validation sources: `tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh`, and `tests/helpers/artifact_consistency.sh`.

## Measurement Method

Fresh APPLY measurements used the current working tree and source-backed git history:

```bash
# Current extension source metrics
# Equivalent calculation: for each drivers/pi/extensions/*.ts file, count text lines and bytes from the working tree.

# Pre/post S4 baseline from source-backed history
for rev in 17578fb0 8bbda2bd^ 8bbda2bd; do
  echo "REV $rev"
  git show "$rev:drivers/pi/extensions/pals-hooks.ts" | wc -l -c
  git show "$rev:drivers/pi/extensions/guided-workflow-delivery.ts" 2>/dev/null | wc -l -c || true
done
```

Baseline choice: `17578fb0` (Phase 293 merge) and `8bbda2bd^` both reconstruct the pre-S4 boundary with `pals-hooks.ts` at 671 lines / 24,147 bytes and no `guided-workflow-delivery.ts`. The Phase 294 implementation commit `8bbda2bd` records the post-S4 shape.

## Current Pi Extension Metrics

| File | Lines | Bytes |
| --- | ---: | ---: |
| `drivers/pi/extensions/artifact-slice-rendering.ts` | 183 | 8,233 |
| `drivers/pi/extensions/command-routing.ts` | 230 | 8,270 |
| `drivers/pi/extensions/guided-workflow-delivery.ts` | 148 | 5,855 |
| `drivers/pi/extensions/guided-workflow-detection.ts` | 356 | 13,236 |
| `drivers/pi/extensions/lifecycle-ui.ts` | 123 | 5,177 |
| `drivers/pi/extensions/module-activity-parsing.ts` | 172 | 5,974 |
| `drivers/pi/extensions/pals-context-injection.ts` | 88 | 4,054 |
| `drivers/pi/extensions/pals-hooks.ts` | 546 | 19,210 |
| `drivers/pi/extensions/workflow-resource-capsule-rendering.ts` | 192 | 9,097 |

## S4 Offload Result

| Source-backed point | `pals-hooks.ts` lines | `pals-hooks.ts` bytes | `guided-workflow-delivery.ts` lines | `guided-workflow-delivery.ts` bytes |
| --- | ---: | ---: | ---: | ---: |
| Pre-S4 baseline (`17578fb0` / `8bbda2bd^`) | 671 | 24,147 | 0 | 0 |
| Post-S4 implementation (`8bbda2bd`) | 546 | 19,210 | 148 | 5,855 |
| Current Phase 295 working tree | 546 | 19,210 | 148 | 5,855 |

Measured S4 impact:

- `pals-hooks.ts` shrank by 125 lines and 4,937 bytes from the pre-S4 baseline.
- The extracted S4 sibling is 148 lines and 5,855 bytes.
- The post-S4 total source-set size increased slightly because extraction adds imports, exports, comments, and loader-compatible sibling structure; the context-offload win is that APPLY/PLAN readers can inspect S4 delivery in a focused 148-line file instead of rereading the whole `pals-hooks.ts` runtime entry point.
- Current validation count sources before Phase 295 guardrails were Phase 294: Pi 329/329 and cross-harness 234/234. Phase 295 validation output must be copied from fresh command output in SUMMARY, not inferred from this report.

## Remaining Burden in `pals-hooks.ts`

`pals-hooks.ts` remains the supported runtime registration/orchestration entry point. Its 546 current lines still carry several responsibilities that intentionally should not all move at once:

- Runtime registration/orchestration: event hooks and command-layer wiring that make `pals-hooks.ts` the compatibility anchor.
- CARL/session-boundary helpers: context-pressure and phase-boundary orchestration that interact with session lifecycle decisions.
- Shared helpers: filesystem/state/string helpers used by sibling modules; extracting these could reduce coupling only if it avoids import cycles.
- Lifecycle event wiring: safe inline glue that coordinates sibling helpers without creating alternate lifecycle truth.

Some of this should stay inline because the entry point is the supported integration surface, and over-extraction could create indirection without reducing model context or risk.

## Ranked Candidates

### 1. Shared filesystem/state helper extraction — recommended winner

**Expected context-offload value:** High. Shared helpers are repeatedly relevant when reading or changing sibling modules, and a small helper sibling could let future runtime work avoid rereading orchestration code in `pals-hooks.ts`.

**Source-backed rationale:** The Phase 243 and Phase 246 outcomes in `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` record that siblings import helpers such as `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, and `PalsStateSnapshot` from `pals-hooks.ts`. The Phase 294 S4 contract also permits `guided-workflow-delivery.ts` to import `compactWhitespace` and `readFileOr` from `./pals-hooks`.

**Risk:** Moderate. Helper movement can create circular imports or accidentally centralize lifecycle authority if it is too broad.

**Authority constraints:** A helper sibling must remain pure/derived. It must not write `.paul/*`, own lifecycle state, run git, dispatch modules, validate, approve, continue, or send user messages.

**Validation Impact:** Focused Pi e2e guardrails should assert helper exports, import repoints, no duplicate definitions, and no runtime authority markers in the helper sibling. Cross-harness can protect recommendation-only/authority wording if a contract precedes implementation.

**Dependencies:** Requires a contract that inventories exact helper users and applies the Phase 246 cycle-avoidance recipe.

**Recommended next action:** Plan a docs-first contract for a minimal `shared-runtime-helpers` sibling, then implement only if the contract proves no import cycle or authority widening.

### 2. CARL/session-boundary helper extraction — runner-up

**Expected context-offload value:** Medium-high. CARL logic is conceptually distinct from command routing and guided workflow delivery, and isolating it could make session-boundary review cheaper.

**Source-backed rationale:** `drivers/pi/extensions/README.md` documents the Pi CARL session-boundary manager, including command stashing, phase detection, context-pressure decisions, safety ceiling, bootstrap, and auto-resume. `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` notes that CARL session-boundary identifiers were intentionally not promoted into the original S1-S8 list but could be promoted later.

**Risk:** Moderate-high. CARL creates sessions and can trigger resume behavior, so it is closer to lifecycle flow than pure rendering/parsing helpers.

**Authority constraints:** Extraction must preserve that CARL is derived session-boundary assistance only. It must not make APPLY/UNIFY decisions, mark lifecycle progress, bypass checkpoints, auto-approve, or replace STATE routing.

**Validation Impact:** Guardrails would need to assert exact threshold/config markers, no `.paul/*` writes, no canonical reply sending, no checkpoint skipping, and unchanged event-hook call sites.

**Dependencies:** Best after helper extraction clarifies shared read/string helper imports.

**Recommended next action:** Keep as runner-up; write a narrow contract only if helper extraction is either completed or deemed unnecessary.

### 3. Validation helper/script decomposition

**Expected context-offload value:** Medium. `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` are large TAP truth sources; decomposing repeated checks could reduce future validation-maintenance context.

**Source-backed rationale:** Phase 295 itself adds guardrails to both scripts, and prior validation hygiene phases established helper-based decomposition patterns under `tests/helpers/`.

**Risk:** Moderate. Validation command output is authoritative, so decomposition must not weaken TAP count truth or hide failing checks behind helper abstractions.

**Authority constraints:** Helpers may report TAP checks only; they must not become a validation ledger, skip existing checks, or replace fresh command output.

**Validation Impact:** Potentially high because the scripts validate themselves. Any decomposition needs count reconciliation and artifact consistency proof.

**Dependencies:** A baseline report should identify repeated marker-check clusters before implementation.

**Recommended next action:** Defer until a dedicated validation-maintenance milestone; do not mix with runtime extraction.

### 4. Runtime registration/orchestration cleanup

**Expected context-offload value:** Low-medium. Some inline wiring may be compressible, but it is also the supported entry point.

**Source-backed rationale:** `drivers/pi/extensions/README.md` states `pals-hooks.ts` is the compatibility anchor and runtime registration/orchestration entry point after S3/S4/S6/S7/S8 sibling extractions.

**Risk:** High. Registration and event hooks are user-visible and can affect every Pi lifecycle surface.

**Authority constraints:** Must preserve all command names, shortcuts, hook events, GitHub Flow safety, module evidence, and guided workflow no-auto boundaries.

**Validation Impact:** Broad. Would require install, Pi e2e, cross-harness, and focused source checks across many surfaces.

**Dependencies:** Should follow smaller helper/CARL extractions, if ever.

**Recommended next action:** Do not extract yet; treat only as cleanup after lower-risk targets reduce the helper/session burden.

### 5. Documentation/contract consolidation before future runtime work

**Expected context-offload value:** Medium for planning, low for runtime file size. A concise index could reduce broad doc rereads before extraction phases.

**Source-backed rationale:** Current extraction context spans the S1-S8 modularization contract, S3/S4 contracts, Pi README, skill-map, and phase summaries.

**Risk:** Low if docs-only; moderate if it tries to rewrite authoritative lifecycle artifacts.

**Authority constraints:** Must remain derived documentation; no runtime behavior, validation semantics, or lifecycle authority changes.

**Validation Impact:** Small bounded docs checks.

**Dependencies:** None.

**Recommended next action:** Use as a preparatory docs-only phase if the next milestone needs a contract index before implementation.

## Winner Recommendation

Next milestone should start with **shared filesystem/state helper extraction**, but only through a contract-first plan. It offers the best balance of context-offload value and authority safety because it targets repeated utility imports instead of Pi UI, canonical replies, command routing, or lifecycle decisions.

Runner-up: **CARL/session-boundary helper extraction**, after helper import boundaries are clearer.

Do not extract yet: **runtime registration/orchestration cleanup**. It is the supported entry point and carries the broadest blast radius.

## Non-Goals

- No implementation in Phase 295.
- No TypeScript runtime behavior change.
- No new sibling extraction in Phase 295.
- No `.paul/*` runtime writes.
- No telemetry, hidden state, generated ledger, or Pi-owned lifecycle/module/validation truth.
- No auto-approval, auto-continue, skipped checkpoints, UI-only lifecycle decisions, or inferred merge intent.
- No changes to current S3/S4 guided workflow behavior.
