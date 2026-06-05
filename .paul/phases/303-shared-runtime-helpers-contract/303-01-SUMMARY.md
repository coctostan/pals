---
phase: 303-shared-runtime-helpers-contract
plan: 01
subsystem: kernel
tags: [shared-runtime-helpers, contract-first, pals-hooks, pi-extensions, helper-extraction, dependency-leaf, cycle-avoidance, v2.72]

requires:
  - phase: 295-context-offload-measurement-next-target-ranking
    provides: ranked recommendation that shared runtime helper extraction is the #1 next target
provides:
  - authoritative v2.72 contract docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md fixing the exact helper set, importer map, allowed responsibilities, authority boundaries, and leaf/cycle rules
  - source-verified inventory (8 symbols) + importer map (12 import sites across 8 sibling extensions) for Phase 304 to extract + repoint against
affects:
  - 304-extraction-import-repoint
  - 305-validation-closure

tech-stack:
  added: []
  patterns:
    - contract-first boundary doc modeled on docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md (Purpose / Source Authority / Doctrine / ... / Status)
    - source-of-record verification (grep exports + import sites) reconciling contract claims against actual drivers/pi/extensions/*.ts

key-files:
  created:
    - docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md
    - .paul/phases/303-shared-runtime-helpers-contract/303-01-PLAN.md
    - .paul/phases/303-shared-runtime-helpers-contract/303-01-SUMMARY.md
  modified:
    - .paul/STATE.md
    - .paul/ROADMAP.md
    - .paul/MILESTONES.md

key-decisions:
  - "Decision: Documented the ACTUAL fuller co-import sets rather than the PLAN narrative's abbreviated list — lifecycle-ui.ts also imports MAX_VISIBLE_MODULES + RECENT_MODULE_ACTIVITY_LOOKBACK (not just MAX_WIDGET_MODULE_DETAILS); command-routing.ts and pals-context-injection.ts carry ActivationState as type-only. Task 2's 'correct the contract, not the source' rule governs."
  - "Decision: Named the new module drivers/pi/extensions/shared-runtime-helpers.ts and fixed the post-extraction dependency direction (orchestrator/siblings -> leaf, never reverse) as the core cycle-avoidance invariant."
  - "Decision: PalsStateSnapshot moves WITH the helpers, so the leaf needs no type-only back-import in practice; type-only back-reference rule is documented as a general escape hatch only."

patterns-established:
  - "Pattern: v2.72 contract docs name exact symbols + line ranges + a verified importer map, so Phase 304 extraction is deterministic and Phase 305 validates against a written spec."

duration: ~1 session
started: 2026-06-05T00:00:00Z
completed: 2026-06-05T00:00:00Z
---

# Phase 303 Plan 01: Shared Runtime Helpers Contract Summary

**Authored `docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md` as the authoritative v2.72 boundary for extracting 7 pure/derived helpers + the `PalsStateSnapshot` type out of `drivers/pi/extensions/pals-hooks.ts` into a new dependency-leaf `shared-runtime-helpers.ts` sibling — fixing the source-verified helper inventory, the 12-import-site importer map across 8 sibling extensions, allowed responsibilities, authority boundaries, and leaf/cycle-avoidance rules, with zero code changes.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~1 session |
| Started | 2026-06-05 |
| Completed | 2026-06-05 |
| Tasks | 2 completed |
| Files modified | 1 new doc + lifecycle artifacts (docs-only) |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Authoritative contract exists with required sections + exact helper set | Pass | `docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md` contains all 10 required headings (Purpose, Source Authority, Doctrine, Helper Inventory, Importer Map, Allowed Responsibilities, Authority Boundaries, Leaf/Cycle-Avoidance Rules, Out of Scope, Status) — confirmed by heading grep (10 matches). Names the exact symbols `compactWhitespace`, `selectBoundedLines`, `escapeRegExp`, `extractLoopSignature`, `readFileOr`, `getFileFreshness`, `parsePalsState`, and the `PalsStateSnapshot` type. Commit `a9c99eb7`. |
| AC-2: Helper inventory + importer map factually accurate against source | Pass | All 8 symbols confirmed `export`ed from `pals-hooks.ts` (grep `export (function\|type) {name}` → 8/8 match). Importer map verified against actual `from "./pals-hooks"` sites: 12 import statements across 8 sibling files (`guided-workflow-detection`, `command-routing`, `lifecycle-ui`, `workflow-resource-capsule-rendering`, `module-activity-parsing`, `guided-workflow-delivery`, `artifact-slice-rendering`, `pals-context-injection`). No fabricated symbol or importer. |
| AC-3: Authority boundaries + cycle rules explicit and bounded | Pass | Authority Boundaries section forbids `.paul/*` writes, lifecycle ownership, module dispatch, git/validation, approvals, command routing, UI decisions, and canonical user-message delivery. Leaf/Cycle-Avoidance requires the new module be a dependency leaf importing only Node `fs`/`path`, never from `pals-hooks` or siblings. Out of Scope explicitly excludes ctx/event helpers (`collectRecentAssistantTexts`, `extractTextContent`) and CARL/activation/routing logic — all confirmed present in `pals-hooks.ts` so the exclusions are accurate. |

## Module Execution Reports

This is the PALS kernel-source repository. There is **no installed `modules.yaml` runtime registry at the repo root** (module source lives under `modules/*/module.yaml` but is not a dispatchable installed registry). Every hook dispatch across this loop therefore recorded an honest NOT FOUND / not-registered result:

### Pre-Plan / Post-Plan Carry-Forward (from PLAN)
- `[dispatch] pre-plan advisory`: `modules.yaml NOT FOUND — WARNING` — TODD/IRIS/DAVE/DOCS/CODI/RUBY could not be dispatched (no installed registry). Docs-only phase, no TS/JS selectors → no CODI seeds.
- `[dispatch] pre-plan enforcement`: `modules.yaml NOT FOUND — WARNING` — DEAN dependency audit not dispatched; this phase adds one Markdown doc and no dependencies, so dependency-audit risk is nil.

### APPLY Verification / Quality Evidence
- `[dispatch] pre-apply`: `modules.yaml NOT FOUND — WARNING` — no installed registry. TODD/WALT are code/test gates and were not triggered (docs-only phase; no code or tests changed).
- Task 1 official verify: PASS — heading grep found all 10 sections + the 8 helper symbols.
- Task 2 official verify: PASS — 8/8 helper exports confirmed in `pals-hooks.ts`; 12 import sites confirmed across 8 sibling files; exclusion symbols confirmed present in source; `git diff --name-only` showed no `.ts` changes (docs-only).
- `[dispatch] post-task(Task 1)` / `post-task(Task 2)`: `modules.yaml NOT FOUND — WARNING`.
- `[dispatch] post-apply advisory` / `post-apply enforcement`: `modules.yaml NOT FOUND — WARNING`.

### Pre-Unify / Post-Unify Dispatch
- `[dispatch] pre-unify`: `modules.yaml NOT FOUND — WARNING`.
- `[dispatch] post-unify`: `modules.yaml NOT FOUND — WARNING`.

**Why no modules fired:** registry not installed in this kernel-source repo (expected, consistent with prior phases). No module evidence survives because none could be dispatched, not because dispatch was skipped.

## Accomplishments

- Produced the authoritative v2.72 implementation boundary: a single contract doc that fixes the helper set, importer map, and authority/leaf rules before any code moves, mirroring the v2.69 S4 and v2.70 strategic-assessment contract-first pattern.
- Verified every factual claim against actual source — 8 helper exports and 12 import sites — so Phase 304 can extract + repoint deterministically and Phase 305 can validate against a written spec.
- Pinned the core architectural invariant: `shared-runtime-helpers.ts` is a dependency leaf (Node `fs`/`path` only) and the post-extraction graph is one-way and acyclic, removing today's inverted "helper hub" edge where siblings depend on the orchestrator.
- Kept scope tight: exactly one new file, no `.ts`/`tests/*`/kernel changes.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Author the shared-runtime-helpers contract | `a9c99eb7` | docs | New `docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md` with all 10 sections, helper inventory, importer map, authority boundaries, leaf/cycle rules. |
| Task 2: Verify contract facts against actual source | `a9c99eb7` | docs | Cross-checked exports + import sites; map authored to match actual source (no separate commit — verification refined the same single Write before commit). |

UNIFY commit (STATE/ROADMAP/MILESTONES + SUMMARY): pending at SUMMARY creation time.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md` | Created | Authoritative v2.72 helper-extraction contract. |
| `.paul/phases/303-shared-runtime-helpers-contract/303-01-PLAN.md` | Created before APPLY | Approved executable plan. |
| `.paul/phases/303-shared-runtime-helpers-contract/303-01-SUMMARY.md` | Created | This reconciliation artifact. |
| `.paul/STATE.md` | Modified | Lifecycle routing progressed PLAN → APPLY → UNIFY. |
| `.paul/ROADMAP.md` | Modified | Phase 303 status Planning → Complete. |
| `.paul/MILESTONES.md` | Modified | Live-status pointer advanced to Phase 303. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Document the ACTUAL fuller co-import sets, not the PLAN narrative's abbreviated list. | `lifecycle-ui.ts` also imports `MAX_VISIBLE_MODULES` + `RECENT_MODULE_ACTIVITY_LOOKBACK`; `command-routing.ts`/`pals-context-injection.ts` carry `ActivationState` type-only. Task 2 mandates correcting the contract to match source. | Importer map is exactly accurate; Phase 304 repoints with no surprises. |
| Name the leaf `drivers/pi/extensions/shared-runtime-helpers.ts` and fix one-way dependency direction. | Removes the inverted helper-hub edge; orchestrator/siblings → leaf, never reverse. | Phase 304 has an unambiguous target module + acyclic invariant to satisfy. |
| `PalsStateSnapshot` moves WITH the helpers; type-only back-import documented only as a general escape hatch. | In practice the moved helpers need no back-reference to `pals-hooks`. | Cleaner leaf with no runtime cycle risk. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None. |
| Scope additions | 0 | None. |
| Clarifications | 1 | Low — importer map authored to actual source (fuller co-import sets) per Task 2. |

**Total impact:** Plan executed as written. The one refinement (fuller co-import sets) is exactly the source-reconciliation Task 2 requires, not scope creep.

### Clarifications
- The PLAN's Task 1 action text listed abbreviated co-imports for `lifecycle-ui` (only `MAX_WIDGET_MODULE_DETAILS`) and did not flag `command-routing`/`pals-context-injection`'s `ActivationState` as a stay-put symbol. Task 2 verification against source surfaced the fuller sets, and the contract was authored to match actual source. No source files touched.

### Deferred Items
None.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| None — docs-only phase executed cleanly. | N/A |

## Next Phase Readiness

**Ready:**
- Phase 304 (Extraction + Import Repoint) has a fixed, source-verified contract: exact symbols to move, the new leaf module name, the 12-site importer map with stay-put symbols flagged, and the acyclic/leaf invariant to satisfy.
- Baseline to preserve through Phases 304–305: Pi e2e 342/342, cross-harness 253/253, artifact consistency PASS.

**Concerns:**
- Phase 304 must repoint only the moving symbols and leave co-imported stay-put symbols (`collectRecentAssistantTexts`, `MAX_*` constants, `ActivationState`) importing from `./pals-hooks`, or imports will break. The contract's Importer Map is the checklist.

**Blockers:**
- None after PR #223 merges.

---
*Phase: 303-shared-runtime-helpers-contract, Plan: 01*
*Completed: 2026-06-05*
