# PALS Shared Runtime Helpers Contract

## Purpose

This contract defines the v2.72 implementation boundary for extracting the
**pure/derived filesystem and STATE helpers** out of
`drivers/pi/extensions/pals-hooks.ts` into a new leaf sibling module,
`drivers/pi/extensions/shared-runtime-helpers.ts`.

Today `pals-hooks.ts` is both the Pi extension orchestrator *and* the de-facto
helper hub: seven pure/derived helper functions and one derived snapshot type
live there and are imported back by eight sibling extensions. That makes
`pals-hooks.ts` an upstream dependency of modules it should not own, inverting
the intended dependency direction (orchestrator → helpers, never the reverse).
This contract fixes the exact symbols to move, the precise importer map, the
allowed responsibilities of the new leaf, the authority boundaries it must
never cross, and the acyclic/leaf rules — **before any code moves**.

No code is changed in this phase. Phase 303 produces only this document.

## Source Authority

This contract is the authoritative implementation boundary for v2.72
shared-runtime-helper-extraction work.

1. `docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md` (this file) is the
   authoritative spec for the extracted helper set, importer repointing,
   allowed responsibilities, authority boundaries, and leaf/cycle rules.
2. **Phase 304** extracts the named symbols into
   `drivers/pi/extensions/shared-runtime-helpers.ts` and repoints importers
   against this contract.
3. **Phase 305** validates the result (build/typecheck, Pi e2e, cross-harness,
   artifact consistency) against this written spec.

If a downstream phase and this contract conflict, the contract wins for v2.72
planning and APPLY work unless the user explicitly revises the contract.

Provenance:
- Decision basis: `.paul/assessments/2026-06-04-post-v2-71-next-milestone.md`
  (ranked shared runtime helper extraction #1 — the twice-deferred v2.69
  Phase 295 recommendation).
- Source of record for the symbols and importers: actual
  `drivers/pi/extensions/*.ts` source as of this contract's authoring.
- Document-shape precedent: `docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md`
  (v2.70) and the v2.69 S4 `guided-workflow-delivery.ts` sibling-extraction
  pattern.

## Doctrine

> **Pure leaf helpers, authoritative runtime.**

Move only pure/derived logic — string normalization, regex escaping, bounded
line selection, loop-signature derivation, safe file reads, file freshness, and
STATE parsing into a derived snapshot. Everything that touches lifecycle
authority, session/event context, activation, CARL, command routing, module
dispatch, git/validation, UI decisions, or canonical user-message delivery
**stays in `pals-hooks.ts`**. The new module is a dependency leaf; the
orchestrator depends on it, never the reverse.

## Helper Inventory

The following symbols are currently `export`ed from
`drivers/pi/extensions/pals-hooks.ts` and move to
`drivers/pi/extensions/shared-runtime-helpers.ts` in Phase 304. Line ranges are
the current locations in `pals-hooks.ts` at contract authoring (approximate;
Phase 304 re-locates by symbol, not line).

### Pure string / logic

| Symbol | Kind | Responsibility | Current location |
|--------|------|----------------|------------------|
| `compactWhitespace` | function | Collapse/normalize whitespace in an optional string; returns `string \| undefined`. | `pals-hooks.ts` ~155–157 |
| `escapeRegExp` | function | Escape regex metacharacters in a string for safe `RegExp` construction. | `pals-hooks.ts` ~200–202 |
| `selectBoundedLines` | function | Select up to `maxLines` lines matching given patterns from content (bounded slice). | `pals-hooks.ts` ~189–198 |

### Filesystem (Node `fs`/`path` only)

| Symbol | Kind | Responsibility | Current location |
|--------|------|----------------|------------------|
| `readFileOr` | function | Read a file, returning a fallback string when read fails (safe read). | `pals-hooks.ts` ~147–153 |
| `getFileFreshness` | function | Derive a human-readable freshness string from a file's mtime. | `pals-hooks.ts` ~181–187 |

### Derived STATE + type

| Symbol | Kind | Responsibility | Current location |
|--------|------|----------------|------------------|
| `parsePalsState` | function | Parse `.paul/STATE.md` (via safe read) into a derived `PalsStateSnapshot`. | `pals-hooks.ts` ~159–179 |
| `extractLoopSignature` | function | Derive the PLAN/APPLY/UNIFY loop signature from a `PalsStateSnapshot`. | `pals-hooks.ts` ~302–306 |
| `PalsStateSnapshot` | type | Derived snapshot shape returned by `parsePalsState` and consumed by importers. | `pals-hooks.ts` ~81–87 |

All eight symbols are confirmed `export`ed from `pals-hooks.ts` at contract
authoring time.

## Importer Map

Eight sibling extensions currently import from `./pals-hooks`. Phase 304
repoints **only the symbols in the Helper Inventory** to
`./shared-runtime-helpers`; co-imported symbols that are **not** moving (see
the "stays in `pals-hooks.ts`" column) keep their existing `./pals-hooks`
import. After extraction, `pals-hooks.ts` itself imports the moved helpers from
`./shared-runtime-helpers`.

| Importer (`drivers/pi/extensions/*.ts`) | Moving symbols it consumes (→ `./shared-runtime-helpers`) | Co-imported symbols that STAY in `./pals-hooks` |
|-----------------------------------------|------------------------------------------------------------|--------------------------------------------------|
| `guided-workflow-detection.ts` | `compactWhitespace`, `extractLoopSignature`, type `PalsStateSnapshot` | — |
| `command-routing.ts` | `compactWhitespace`, type `PalsStateSnapshot` | type `ActivationState` |
| `lifecycle-ui.ts` | `compactWhitespace`, `parsePalsState`, type `PalsStateSnapshot` | `MAX_WIDGET_MODULE_DETAILS`, `MAX_VISIBLE_MODULES`, `RECENT_MODULE_ACTIVITY_LOOKBACK`, `collectRecentAssistantTexts` |
| `workflow-resource-capsule-rendering.ts` | `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines` | — |
| `module-activity-parsing.ts` | `compactWhitespace` | `MAX_WIDGET_MODULE_DETAILS` |
| `guided-workflow-delivery.ts` | `compactWhitespace`, `readFileOr` | — |
| `artifact-slice-rendering.ts` | `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, type `PalsStateSnapshot` | — |
| `pals-context-injection.ts` | type `PalsStateSnapshot` | type `ActivationState` |
| `pals-hooks.ts` *(after extraction, as consumer)* | all moved symbols it still references internally | (defines orchestration; imports moved helpers) |

**Symbols that do NOT move** and must keep their current home in
`pals-hooks.ts`:

- `collectRecentAssistantTexts` — ctx/event-touching helper (consumed by
  `lifecycle-ui.ts`); out of scope.
- `extractTextContent` — ctx/event-touching helper; out of scope.
- `MAX_WIDGET_MODULE_DETAILS`, `MAX_VISIBLE_MODULES`,
  `RECENT_MODULE_ACTIVITY_LOOKBACK` — widget/module-activity tuning constants
  owned by the orchestrator surface; out of scope.
- `ActivationState` (type) — activation-state shape tied to
  markActivation/getActiveActivation/consumeActivationTurn lifecycle; out of
  scope.

This importer map is verified against the actual `from "./pals-hooks"` import
sites in `drivers/pi/extensions/*.ts` at contract authoring (12 import
statements across the 8 sibling files; some files use a named-import block plus
a separate `import type` line).

## Allowed Responsibilities

The new `shared-runtime-helpers.ts` leaf may contain ONLY:

- pure string normalization (`compactWhitespace`);
- regex metacharacter escaping (`escapeRegExp`);
- bounded line selection (`selectBoundedLines`);
- loop-signature derivation from a snapshot (`extractLoopSignature`);
- safe file reads with fallback (`readFileOr`);
- file freshness from mtime (`getFileFreshness`);
- `.paul/STATE.md` parsing into a derived `PalsStateSnapshot`
  (`parsePalsState` + the `PalsStateSnapshot` type).

Runtime imports are limited to Node `fs`/`path`. No other runtime imports.

## Authority Boundaries

`shared-runtime-helpers.ts` MUST NOT:

- perform `.paul/*` writes or own any lifecycle state;
- own or mutate lifecycle authority (PLAN/APPLY/UNIFY position, STATE
  truth) — it only *reads and derives*, never writes;
- dispatch modules or run module enforcement/advisory hooks;
- perform git operations, validation, or quality gating;
- implement approval / continue / checkpoint behavior;
- perform command routing or activation decisions;
- make UI/widget rendering decisions;
- perform canonical user-message delivery;
- introduce any new authority markers.

It is **derived/aid-only** code: pure functions and safe reads that produce
values for the orchestrator and siblings to use. Authority stays in
`pals-hooks.ts` and the lifecycle workflows.

## Leaf / Cycle-Avoidance Rules

- `shared-runtime-helpers.ts` is a **dependency leaf**: it MUST NOT import from
  `pals-hooks.ts` or from any other `drivers/pi/extensions/*` sibling.
- Its only allowed imports are Node built-ins (`fs`, `path`).
- The post-extraction dependency direction is one-way:
  `pals-hooks.ts` and siblings → `shared-runtime-helpers.ts`. Never the
  reverse. This removes the current inverted "helper hub" edge where siblings
  depend on the orchestrator for pure helpers.
- Where a back-reference to an orchestrator-owned type is genuinely
  unavoidable, use a **type-only import** (`import type`) so it is erased at
  runtime and creates no runtime cycle. (In practice the moved helpers need
  none — `PalsStateSnapshot` moves *with* them.)
- The resulting module graph among these extensions MUST remain acyclic.

## Out of Scope for v2.72

Deliberately excluded from this extraction (broadening the helper set requires
revising this contract):

- **ctx/event-touching helpers** — `collectRecentAssistantTexts`,
  `extractTextContent` (they read Pi session/event context, not pure inputs).
- **CARL session-boundary logic** — e.g. `loadCarlConfig`, CARL state,
  `buildCarlBootstrapPrompt`, `formatCarlContextPressure`.
- **Activation state** — `markActivation`, `getActiveActivation`,
  `consumeActivationTurn`, and the `ActivationState` type.
- **Command routing** and activation/CARL/routing decision logic.
- **Validation-suite decomposition** (`tests/pi-end-to-end-validation.sh`,
  `tests/cross-harness-validation.sh`) — a separately ranked future milestone,
  not part of v2.72.
- Any change to lifecycle authority, module dispatch, or GitHub Flow behavior.

## Status

Phase 303: contract authored. Extraction + importer repointing pending
**Phase 304**; build/typecheck + Pi e2e + cross-harness + artifact-consistency
validation pending **Phase 305**.
