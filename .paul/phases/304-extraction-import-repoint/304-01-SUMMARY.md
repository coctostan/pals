---
phase: 304-extraction-import-repoint
plan: 01
subsystem: kernel
tags: [pi-extensions, dependency-leaf, refactor, import-repoint, shared-runtime-helpers, acyclic-graph, v2.72]

requires:
  - phase: 303-shared-runtime-helpers-contract
    provides: docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md (helper inventory, importer map, leaf/cycle rules)
provides:
  - drivers/pi/extensions/shared-runtime-helpers.ts (8-symbol dependency-leaf module)
  - Acyclic one-way Pi extension graph (orchestrator/siblings → leaf → Node only)
  - Bounded Pi-e2e leaf-extraction TAP block (#252)
affects:
  - 305-validation-closure
  - drivers/pi/extensions (any future sibling consuming the shared helpers)

tech-stack:
  added: []
  patterns:
    - "Pure/derived helpers live in a Node-only dependency leaf; orchestrator and siblings import from it, never the reverse"

key-files:
  created:
    - drivers/pi/extensions/shared-runtime-helpers.ts
  modified:
    - drivers/pi/extensions/pals-hooks.ts
    - tests/pi-end-to-end-validation.sh

key-decisions:
  - "Decision: Leaf is fully Node-only — PalsStateSnapshot moves WITH the helpers, so no type-only back-import to pals-hooks is needed (unlike S6/S7/S8)"
  - "Decision: command-routing.ts and pals-context-injection.ts split their imports — ActivationState stays on ./pals-hooks, PalsStateSnapshot moves to the leaf"

patterns-established:
  - "Pattern: A relocated helper's TAP import-pin assertions must be repointed in lockstep with the source move; grep all moved symbols against the old home to catch every pin"

duration: ~25min
started: 2026-06-06T12:30:00Z
completed: 2026-06-06T12:55:00Z
---

# Phase 304 Plan 01: Shared Runtime Helpers Extraction + Import Repoint Summary

**Extracted 7 pure/derived helpers + the `PalsStateSnapshot` type out of the `pals-hooks.ts` orchestrator into a new Node-only dependency-leaf sibling `shared-runtime-helpers.ts`, repointed all 9 importers, and removed the inverted "helper-hub" edge — yielding an acyclic one-way Pi extension graph with zero behavior change.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~25 min |
| Started | 2026-06-06T12:30:00Z |
| Completed | 2026-06-06T12:55:00Z |
| Tasks | 3 completed |
| Files modified | 11 (1 created, 10 modified) |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: New leaf module exists with all 8 symbols, single-defined, Node-only imports | Pass | `shared-runtime-helpers.ts` exports 7 functions + `PalsStateSnapshot`, bodies byte-for-byte identical, imports only `fs`/`path`, carries No-op Pi extension factory marker |
| AC-2: pals-hooks.ts and all 8 siblings repointed; no duplicate definitions; no cycles | Pass | 9 files import from `./shared-runtime-helpers`; no moving symbol imported from `./pals-hooks`; stay-put symbols (`ActivationState`, `MAX_*`, `collectRecentAssistantTexts`) preserved; leaf imports Node only |
| AC-3: Validation green with TAP assertions repointed; no behavior change; scope bounded | Pass | Pi-e2e 343/343, cross-harness 253/253, artifact consistency PASS, `git diff --check` clean; scope = new leaf + 9 extensions + 1 test suite |

## Module Execution Reports

No module subsystems fired during this plan. The PALS kernel-source repository has **no installed `modules.yaml` runtime registry** at the repo root (module source lives under `modules/*/module.yaml` but is not a dispatchable installed registry). All dispatch points honestly recorded `modules.yaml NOT FOUND — WARNING`:

- **pre-apply / post-task / post-apply** (APPLY): `modules.yaml NOT FOUND — WARNING`. DEAN dependency-audit not dispatched; risk nil — this plan relocated existing code between repo-local files and added **no** dependencies.
- **pre-unify / post-unify** (UNIFY): `modules.yaml NOT FOUND — WARNING`.
- **WALT** quality gate enforced inline by the parent via the full validation suite (Pi-e2e + cross-harness + artifact consistency + `git diff --check`), all green.
- **TODD** advisory only (pure source relocation; no RED/GREEN/REFACTOR units — behavior preserved by existing suites + the new bounded leaf-extraction TAP block, matching the Phase 262 S8 precedent).

## Accomplishments

- Created `drivers/pi/extensions/shared-runtime-helpers.ts` as a true dependency leaf: 8 symbols, Node `fs`/`path` only, loader-compat No-op factory.
- Removed the inverted helper-hub edge: siblings no longer depend on the orchestrator for pure helpers; post-extraction graph is acyclic and one-way.
- Repointed all 9 importers with surgical import splits that preserve every stay-put symbol on `./pals-hooks`.
- Repointed the two Pi-e2e `PalsStateSnapshot` import-pin assertions and added a bounded leaf-extraction TAP block (Pi-e2e 342 → 343).

## Task Commits

Each task committed atomically:

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Create leaf + remove moved symbols from pals-hooks.ts | `7f388406` | refactor | New 8-symbol Node-only leaf; duplicates removed from pals-hooks.ts; unused `fs` import dropped |
| Task 2: Repoint 8 sibling importers | `143fc0fc` | refactor | Moving symbols → `./shared-runtime-helpers`; stay-put symbols preserved; no cycle |
| Task 3: Repoint Pi-e2e TAP pins + add leaf block | `03edac83` | test | 2 import-pin assertions repointed (command-routing split for ActivationState); bounded leaf TAP block added |

Plan metadata: committed during UNIFY (docs: complete plan).

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `drivers/pi/extensions/shared-runtime-helpers.ts` | Created | New dependency-leaf module holding the 8 pure/derived helpers |
| `drivers/pi/extensions/pals-hooks.ts` | Modified | Removed 8 inline definitions; imports the 4 it still uses from the leaf; dropped unused `fs` import |
| `drivers/pi/extensions/guided-workflow-detection.ts` | Modified | Repoint `compactWhitespace`, `extractLoopSignature`, `PalsStateSnapshot` |
| `drivers/pi/extensions/command-routing.ts` | Modified | Split: `ActivationState` stays; `PalsStateSnapshot`, `compactWhitespace` → leaf |
| `drivers/pi/extensions/lifecycle-ui.ts` | Modified | Repoint `compactWhitespace`, `parsePalsState`, `PalsStateSnapshot`; keep `MAX_*`, `collectRecentAssistantTexts` on pals-hooks |
| `drivers/pi/extensions/workflow-resource-capsule-rendering.ts` | Modified | Repoint `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines` |
| `drivers/pi/extensions/module-activity-parsing.ts` | Modified | Split: `compactWhitespace` → leaf; `MAX_WIDGET_MODULE_DETAILS` stays |
| `drivers/pi/extensions/guided-workflow-delivery.ts` | Modified | Repoint `compactWhitespace`, `readFileOr` |
| `drivers/pi/extensions/artifact-slice-rendering.ts` | Modified | Repoint `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `PalsStateSnapshot` |
| `drivers/pi/extensions/pals-context-injection.ts` | Modified | Split: `PalsStateSnapshot` → leaf; `ActivationState` stays |
| `tests/pi-end-to-end-validation.sh` | Modified | Repointed 2 import-pin assertions; added `EXT_SHARED_RUNTIME_HELPERS` + bounded leaf-extraction TAP block |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Leaf is fully Node-only; no type-only back-import to pals-hooks | `PalsStateSnapshot` moves WITH the helpers; the moved bodies reference only each other + Node `fs`/`path` | Cleaner than S6/S7/S8 (which needed type-only back-imports); leaf is a genuine sink |
| Split imports in command-routing.ts & pals-context-injection.ts | `ActivationState` is out-of-scope (activation lifecycle, stays in orchestrator) while `PalsStateSnapshot` moves | Preserves the Phase 303 contract's stay-put membership exactly |
| Drop the unused `fs` import from pals-hooks.ts | After deletion, `readFileSync`/`existsSync`/`statSync` are only used inside moved functions; `join`/`path` still used by `loadCarlConfig` | No-unused-import discipline (Phase 246); `path` retained |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | — |
| Scope additions | 0 | — |
| Deferred | 0 | — |

**Total impact:** None — plan executed exactly as written. Pi-e2e count moved 342 → 343 exactly as predicted (1 net-new bounded leaf assertion); no other delta to reconcile.

### Deferred Items

None — plan executed exactly as written.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Stale `.git/index.lock` encountered while archiving the consumed handoff | Verified no live git process; the lock was stale (prior commands had completed); removed it safely and confirmed the handoff was archived |

## Next Phase Readiness

**Ready:**
- `shared-runtime-helpers.ts` leaf is in place, validated, and installed; the acyclic one-way graph the contract specified is achieved.
- Phase 305 (Validation Closure) can validate the result against `docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md` — build/typecheck, Pi-e2e, cross-harness, artifact consistency already green at APPLY.

**Concerns:**
- None. Bodies are byte-for-byte identical; behavior preservation is enforced by the existing suites plus the new bounded leaf TAP block.

**Blockers:**
- None. PR #224 open, CI green (both Socket checks SUCCESS), MERGEABLE.

---
*Phase: 304-extraction-import-repoint, Plan: 01*
*Completed: 2026-06-06*
