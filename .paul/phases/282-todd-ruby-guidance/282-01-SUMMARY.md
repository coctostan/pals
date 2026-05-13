---
phase: 282-todd-ruby-guidance
plan: 01
subsystem: modules
tags: [functional-first, todd, ruby, tdd, refactoring, validation]
requires:
  - phase: 279-functional-first-guidance-contract
    provides: docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md authority hierarchy and Phase 282 scope
  - phase: 281-brownfield-convention-detection
    provides: local-idiom and effect-boundary guidance context
provides:
  - TODD pure input-to-output / Pure Core TDD guidance
  - RUBY Extract Pure Core advisory refactoring guidance
  - Pi and cross-harness installed-resource marker checks for Phase 282 TODD/RUBY guidance
affects:
  - v2.65 Functional-First Agent Guidance
  - modules/todd
  - modules/ruby
tech-stack:
  added: []
  patterns:
    - functional-first, not functional-only guidance
    - Pure Core, Explicit Effects as optional/advisory agent guidance
key-files:
  created: []
  modified:
    - modules/todd/module.yaml
    - modules/todd/references/tdd.md
    - modules/todd/references/tdd-plan-generation.md
    - modules/todd/references/tdd-execution.md
    - modules/ruby/module.yaml
    - modules/ruby/references/refactor-principles.md
    - modules/ruby/references/refactor-patterns.md
    - tests/pi-end-to-end-validation.sh
    - tests/cross-harness-validation.sh
key-decisions:
  - "Decision: Keep functional-first guidance advisory and project-convention-aware; no new blocking FP gate."
patterns-established:
  - "Pattern: Module guidance marker checks should assert grouped behavior markers in installed resources across Pi and cross-harness installers."
duration: same-session UNIFY after APPLY handoff
started: 2026-05-13T14:35:00Z
completed: 2026-05-13T14:50:00Z
---

# Phase 282 Plan 01: TODD + RUBY Guidance Summary

Phase 282 shipped TODD pure-logic TDD guidance, RUBY Extract Pure Core refactoring guidance, and installed-resource validation guards without changing enforcement semantics or requiring functional architecture.

## Performance

| Metric | Value |
|--------|-------|
| Duration | same-session UNIFY after APPLY handoff |
| Started | 2026-05-13T14:35:00Z |
| Completed | 2026-05-13T14:50:00Z |
| Tasks | 3 completed |
| Files modified | 9 implementation/validation files + lifecycle artifacts |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: TODD Pure-Logic TDD Guidance | PASS | TODD module metadata and references now identify pure input-to-output behavior as high-value TDD scope, include Pure Core, Explicit Effects language, and encourage direct pure-core tests while preserving project conventions. |
| AC-2: RUBY Extract Pure Core Refactoring Guidance | PASS | RUBY module metadata and references now include Extract Pure Core as advisory, behavior-preserving, test-backed guidance for decisions/data transformation mixed with side effects. |
| AC-3: Installed Resources Preserve TODD/RUBY Functional-First Markers | PASS | Pi and cross-harness validation scripts assert installed TODD/RUBY Phase 282 markers; cross-harness passed 224/224 and Pi Phase 282 checks passed with 5 inherited CODI failures remaining. |

## Module Execution Reports

### Pre-Unify Dispatch

[dispatch] pre-unify: 0 modules registered for this hook.

### WALT Quality History

[dispatch] post-unify: WALT appended `.paul/QUALITY-HISTORY.md` row for `282-01`.

| Check | Result |
|-------|--------|
| `git diff --check` | PASS (`0`) |
| `bash -n tests/pi-end-to-end-validation.sh tests/cross-harness-validation.sh` | PASS (`0`) |
| `bash tests/helpers/artifact_consistency.sh` | PASS (`artifact_consistency_check: PASS`) |
| `bash tests/cross-harness-validation.sh` | PASS 224/224 |
| `bash tests/pi-end-to-end-validation.sh` | Phase 282 marker checks PASS; overall 318/323 with 5 inherited CODI marker failures unrelated to Phase 282 |

### CODI History

[dispatch] CODI post-unify: appended `.paul/CODI-HISTORY.md` row for `282-01` with outcome `skipped-no-symbols` from PLAN pre-plan evidence (`markdown/YAML/shell-only phase; no explicit TS/JS selectors or stable codegraph seeds`).

### SKIP Knowledge Capture

[dispatch] SKIP post-unify: no separate knowledge artifact written; durable source-backed decisions are already recorded in this SUMMARY and compact lifecycle/project updates. Candidate decision: functional-first remains advisory and project-convention-aware.

### RUBY Debt Review

[dispatch] RUBY post-unify: docs/module-instruction and validation-shell scope is `NOT_APPLICABLE` for source-code debt; no runtime refactor debt introduced.

## Accomplishments

- Added TODD pure input-to-output and Pure Core, Explicit Effects guidance to module metadata and references.
- Added RUBY Extract Pure Core guidance as incremental, behavior-preserving, test-backed, advisory refactoring advice.
- Added Pi and cross-harness installed-resource assertions for the new TODD/RUBY markers.
- Preserved Phase 282 boundaries: no dependency changes, no runtime source refactor, no ARCH scope, and no new functional-style blocking gate.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Add pure-logic guidance to TODD references and hook metadata | `938618d0` | feat | Updated TODD metadata and references with pure input-to-output / Pure Core TDD guidance. |
| Task 2: Add Extract Pure Core guidance to RUBY references and hook metadata | `938618d0` | feat | Updated RUBY metadata and references with advisory Extract Pure Core guidance. |
| Task 3: Add installed-resource validation markers and run verification | `938618d0` | feat | Added Pi and cross-harness marker assertions and captured verification evidence. |

Plan metadata and UNIFY lifecycle artifacts: this SUMMARY plus `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/PROJECT.md`, `.paul/MILESTONES.md`, `.paul/QUALITY-HISTORY.md`, and `.paul/CODI-HISTORY.md`.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `modules/todd/module.yaml` | Modified | Installed TODD metadata carries pure input-to-output / Pure Core markers. |
| `modules/todd/references/tdd.md` | Modified | TODD candidate guidance includes pure behavior and direct pure-core tests. |
| `modules/todd/references/tdd-plan-generation.md` | Modified | Planning guidance names explicit inputs/outputs/state/dependencies for pure behavior. |
| `modules/todd/references/tdd-execution.md` | Modified | RED/GREEN/REFACTOR execution guidance prefers direct pure-core assertions when available. |
| `modules/ruby/module.yaml` | Modified | Installed RUBY metadata surfaces Extract Pure Core guidance. |
| `modules/ruby/references/refactor-principles.md` | Modified | Adds optional Pure Core, Explicit Effects as a safe refactoring target. |
| `modules/ruby/references/refactor-patterns.md` | Modified | Adds Extract Pure Core pattern and safety guidance. |
| `tests/pi-end-to-end-validation.sh` | Modified | Adds Pi installed-resource marker assertions for TODD/RUBY Phase 282 markers. |
| `tests/cross-harness-validation.sh` | Modified | Adds Claude Code + Pi installed-resource marker assertions for TODD/RUBY Phase 282 markers. |
| `.paul/QUALITY-HISTORY.md` | Modified | WALT post-unify history row for `282-01`. |
| `.paul/CODI-HISTORY.md` | Modified | CODI post-unify history row for `282-01`. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Keep functional-first guidance advisory and project-convention-aware. | Phase 279 contract says functional-first, not functional-only; project conventions remain authoritative. | TODD/RUBY guidance improves testing/refactoring heuristics without imposing architecture or functional programming style. |
| Add validation at installed-resource boundaries. | Phase 282 changes must survive installer copies in Pi and Claude Code/Pi parity paths. | Future edits that drop TODD/RUBY markers fail validation before release. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None |
| Scope additions | 0 | None |
| Deferred | 0 | None |

**Total impact:** Plan executed as scoped; inherited Pi CODI failures remain unrelated baseline concerns and were not treated as Phase 282 regressions.

### Auto-fixed Issues

None.

### Deferred Items

None from Phase 282.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| `bash tests/pi-end-to-end-validation.sh` still reports 5 inherited CODI marker failures. | Documented as inherited/unrelated; Phase 282 marker checks pass and cross-harness validation passes 224/224. |

## Next Phase Readiness

**Ready:**
- Phase 282 TODD/RUBY guidance is complete and validated.
- Phase 283 can plan ARCH Advisory + Closure from the v2.65 contract boundary.

**Concerns:**
- Inherited CODI Pi marker failures remain visible in Pi validation but are outside Phase 282 scope.

**Blockers:**
- None for Phase 283 planning after GitHub Flow merge gate completes.

---
*Phase: 282-todd-ruby-guidance, Plan: 01*
*Completed: 2026-05-13*
