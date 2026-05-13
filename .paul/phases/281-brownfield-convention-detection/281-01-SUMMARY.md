---
phase: 281-brownfield-convention-detection
plan: 01
subsystem: kernel
tags: [functional-first, brownfield, map-codebase, conventions, validation]

requires:
  - phase: 279-functional-first-guidance-contract
    provides: authoritative v2.65 functional-first implementation boundary
  - phase: 280-agent-convention-surface
    provides: generated AGENTS/init Engineering Principles and installed-resource marker guardrails
provides:
  - source-backed brownfield functional/style signal detection in map-codebase
  - architecture and conventions template slots for local idioms and effect boundaries
  - Pi and cross-harness installed-resource marker checks for brownfield detection markers
affects:
  - Phase 282 TODD + RUBY Guidance
  - Phase 283 ARCH Advisory + Closure

tech-stack:
  added: []
  patterns:
    - descriptive brownfield functional-first signal capture
    - installed-resource marker preservation checks

key-files:
  created:
    - .paul/phases/281-brownfield-convention-detection/281-01-SUMMARY.md
  modified:
    - kernel/workflows/map-codebase.md
    - kernel/templates/codebase/architecture.md
    - kernel/templates/codebase/conventions.md
    - tests/pi-end-to-end-validation.sh
    - tests/cross-harness-validation.sh

key-decisions:
  - "Decision: keep functional-first guidance descriptive and source-backed in brownfield mapping."
  - "Decision: templates preserve local idioms instead of requiring conversion to a functional architecture."

patterns-established:
  - "Pattern: map-codebase captures mutation/immutability, pure helpers, side-effect boundaries, error/dependency/state-passing style, and preferred implementation shape with file-path evidence."
  - "Pattern: installed-resource validation checks workflow/template markers across Pi and cross-harness installs."

duration: ~20min
started: 2026-05-13T02:04:51Z
completed: 2026-05-13T02:35:00Z
---

# Phase 281 Plan 01: Brownfield Convention Detection Summary

Map-codebase now detects functional-first-relevant brownfield conventions and the generated codebase templates preserve local idioms without imposing a new architecture style.

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~20min |
| Started | 2026-05-13T02:04:51Z |
| Completed | 2026-05-13T02:35:00Z |
| Tasks | 3 completed |
| Files modified | 5 planned files + lifecycle/SUMMARY artifacts |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Map-Codebase Detects Functional-First-Relevant Brownfield Signals | Pass | `kernel/workflows/map-codebase.md` now asks Explore agents for source-backed mutation/immutability, pure helper, side-effect boundary, layering, error handling, dependency/state-passing, and class/function/module/framework preference observations. |
| AC-2: Codebase Templates Preserve Local Idioms | Pass | `kernel/templates/codebase/architecture.md` includes `## Brownfield Functional/Effect Boundaries`; `kernel/templates/codebase/conventions.md` includes `## Brownfield Functional Style Signals`; both explicitly preserve local idioms and avoid functional-architecture conversion requirements. |
| AC-3: Validation Guards Installed Brownfield Detection Markers | Pass | Pi and cross-harness validation scripts now assert installed map-codebase/template resources contain the brownfield functional/style markers. New marker checks passed in both validation suites. |

## Module Execution Reports

### Pre-UNIFY

[dispatch] pre-unify: 0 modules registered for this hook.

### APPLY Carried-Forward Reports

- TODD pre-apply: skipped — plan type is `execute`; no RED/test-first scope.
- WALT pre-apply/post-apply: local shell validation was the applicable quality gate for this docs/template/test-shell scope.
- Post-apply advisory modules: no runtime/API/data/UI/security/deploy/performance/privacy/resilience implementation paths changed; docs/template changes remained descriptive.
- DEAN: no dependency manifests or dependency changes; no audit-blocking evidence.

### Post-UNIFY

[dispatch] post-unify: CODI, RUBY, SKIP, WALT processed as durable-evidence hooks.

- CODI post-unify: skipped-no-symbols for `281-01`; markdown/shell/template scope had no stable TS/JS codegraph symbols. Appended `.paul/CODI-HISTORY.md` row with `blast_radius=n`.
- RUBY post-unify: not applicable for docs/template/test-shell instruction changes; no runtime code debt introduced.
- SKIP post-unify: captured reusable knowledge candidate that brownfield functional-first guidance must stay descriptive, source-backed, and local-idiom preserving.
- WALT post-unify: appended `.paul/QUALITY-HISTORY.md` row. Validation verdict is stable with baseline concerns: Phase 281 marker checks pass; remaining failures are inherited CODI/PROJECT/artifact-consistency guardrails outside this phase.

## Accomplishments

- Added brownfield functional-first signal detection to map-codebase Architecture + Structure and Conventions + Testing Explore prompts.
- Added explicit ARCHITECTURE/CONVENTIONS template sections for local idioms, mutation/immutability, pure helper/data transformation patterns, side-effect placement, error/dependency/state-passing style, and preferred implementation shape.
- Added installed-resource marker assertions for Pi and cross-harness installs so future installer drift catches missing brownfield detection markers.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Add functional-style signal detection to map-codebase prompts | `1637c652` | feat | Added source-backed brownfield functional/style signal prompts and write-through instructions. |
| Task 2: Add brownfield signal sections to codebase templates | `1637c652` | feat | Added architecture and conventions template sections plus good-example guidance. |
| Task 3: Add installed-resource validation markers and run verification | `1637c652` | feat/test | Added Pi and cross-harness marker assertions and ran syntax/focused validation suites. |

Plan metadata: pending UNIFY commit.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `kernel/workflows/map-codebase.md` | Modified | Added brownfield functional-first/local idiom detection prompts and output mapping for ARCHITECTURE/CONVENTIONS. |
| `kernel/templates/codebase/architecture.md` | Modified | Added `## Brownfield Functional/Effect Boundaries` template and example sections. |
| `kernel/templates/codebase/conventions.md` | Modified | Added `## Brownfield Functional Style Signals` template and example sections. |
| `tests/pi-end-to-end-validation.sh` | Modified | Added Pi installed-resource marker checks for workflow and template markers. |
| `tests/cross-harness-validation.sh` | Modified | Added Claude Code and Pi installed-resource marker checks for workflow and template markers. |
| `.paul/phases/281-brownfield-convention-detection/281-01-SUMMARY.md` | Created | Records PLAN/APPLY/UNIFY reconciliation and durable module evidence. |
| `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/PROJECT.md` | Modified | Lifecycle transition to Phase 282 planning. |
| `.paul/CODI-HISTORY.md`, `.paul/QUALITY-HISTORY.md` | Modified | Durable post-unify evidence rows. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Brownfield findings must be descriptive and source-backed. | Phase 279 contract requires functional-first guidance without overriding project conventions. | Future codebase mapping reports local style rather than imposing a functional architecture. |
| Functional/effect-boundary findings belong in existing ARCHITECTURE and CONVENTIONS outputs. | The phase target was map-codebase and codebase templates, not new generated documents. | Keeps generated documentation compact and preserves existing artifact model. |
| Validation should assert installed resource markers, not external behavior. | This phase changes workflow/template text and shell validation guardrails. | Pi and cross-harness installs now catch missing marker propagation. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 1 | Marker assertion initially required lowercase `mutation-heavy`/`pure helper`; source text was adjusted without scope expansion. |
| Scope additions | 0 | None. |
| Deferred | 0 | None. |

**Total impact:** Plan executed within scope; inherited validation failures remain outside Phase 281.

### Auto-fixed Issues

**1. Marker case mismatch in installed map-codebase check**
- **Found during:** Task 3 validation.
- **Issue:** `tests/pi-end-to-end-validation.sh` looked for lowercase `mutation-heavy vs immutable style` and `pure helper`, while map-codebase initially used sentence-case bullets.
- **Fix:** Changed the two marker bullets in `kernel/workflows/map-codebase.md` to lowercase literal markers.
- **Files:** `kernel/workflows/map-codebase.md`.
- **Verification:** Pi installed-resource marker check changed from fail to pass.
- **Commit:** `1637c652`.

### Deferred Items

None.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Full Pi validation retained inherited failures unrelated to Phase 281. | Documented as baseline concerns: CODI marker guardrails, PROJECT byte budget, and artifact consistency drift; Phase 281 marker checks all passed. |
| Cross-harness validation retained inherited artifact-consistency failure. | Documented as baseline concern; all new Phase 281 cross-harness checks passed. |
| GitHub Flow CI has no checks reported on PR #199. | Recorded for merge-gate visibility; no repository CI checks are currently reported for the feature branch. |

## Verification Evidence

| Check | Result | Notes |
|-------|--------|-------|
| Focused native marker checks | Pass | Required brownfield markers found in workflow/templates and validation scripts. |
| `bash -n tests/pi-end-to-end-validation.sh tests/cross-harness-validation.sh` | Pass | Shell syntax valid. |
| `bash tests/pi-end-to-end-validation.sh` | Pass for Phase 281 markers; suite 310/317 | Remaining 7 failures are inherited CODI/PROJECT/artifact-consistency baseline failures. |
| `bash tests/cross-harness-validation.sh` | Pass for Phase 281 markers; suite 211/212 | Remaining 1 failure is inherited artifact-consistency baseline drift. |
| Workguard scope report | Pass | `changed=6`, `outside_allowed=0`, `over_budget=false` for the APPLY scope report. |

## Next Phase Readiness

**Ready:**
- Phase 282 can add TODD/RUBY functional-first guidance using the Phase 279 contract and Phase 281 brownfield convention-detection slots.
- Codebase mapping now has explicit places to record local idioms that TODD/RUBY guidance should respect.

**Concerns:**
- Inherited validation baseline failures remain: Pi CODI marker/PROJECT/artifact-consistency checks and cross-harness artifact-consistency check.
- PR #199 reports no CI checks; merge readiness depends on current repository GitHub settings.

**Blockers:**
- None for Phase 282 planning after merge-gate completion.

---
*Phase: 281-brownfield-convention-detection, Plan: 01*
*Completed: 2026-05-13*
