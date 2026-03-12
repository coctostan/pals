---
phase: 18-todd-coverage-dashboard
plan: 01
subsystem: testing
tags: [todd, coverage, dashboard, test-coverage, detection]

requires:
  - phase: 17-carl-auto-detection
    provides: Established YAML catalog detection pattern
provides:
  - Coverage detection reference mapping 9 frameworks to coverage commands
  - /paul:coverage command for test coverage analysis and dashboard
  - Output parsing guidance for all major test frameworks
affects: [future todd enhancements, quality visibility]

tech-stack:
  added: []
  patterns: [framework-to-coverage-tool mapping, detect-run-parse-present command pattern]

key-files:
  created:
    - modules/todd/references/coverage-detection.md
    - kernel/commands/paul/coverage.md
  modified:
    - modules/todd/module.yaml

key-decisions:
  - "Command lives in kernel as /paul:coverage, not in TODD module namespace"
  - "Coverage detection extends tdd-execution.md pattern without duplicating it"

patterns-established:
  - "Detect-run-parse-present pattern for analysis commands"
  - "Advisory thresholds (Good/Partial/Low/Untested) for non-enforcement visibility"

duration: ~8min
completed: 2026-03-12
---

# Phase 18 Plan 01: TODD Coverage Dashboard Summary

**Coverage detection reference covering 9 frameworks and /paul:coverage command for test coverage visibility with actionable suggestions.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~8min |
| Completed | 2026-03-12 |
| Tasks | 3 completed |
| Files modified | 3 (2 created, 1 modified) |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Coverage Tool Detection | Pass | 9 frameworks: Jest, Vitest, c8, nyc, pytest, Go, Rust, Elixir, Make |
| AC-2: Coverage Dashboard Output | Pass | Dashboard format with overall %, file breakdown, untested files, summary |
| AC-3: Actionable Suggestions | Pass | Context-aware suggestions based on coverage level + TDD plan recommendations |

## Accomplishments

- Created coverage-detection.md with 9 framework mappings including detection priority rules and directory-scoped coverage commands
- Created /paul:coverage command following detect → run → parse → present → suggest pattern with full error handling
- Registered new reference in TODD module.yaml maintaining module's ownership of test-related knowledge

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `modules/todd/references/coverage-detection.md` | Created | Framework → coverage tool mapping with output parsing guidance |
| `kernel/commands/paul/coverage.md` | Created | /paul:coverage command — coverage analysis and dashboard |
| `modules/todd/module.yaml` | Modified | Added coverage-detection.md to files.references |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| /paul:coverage in kernel, not /todd:* namespace | Coverage is a project-level view; TODD owns detection logic via reference | Clean separation: kernel command + module reference |
| 9 frameworks (exceeded 6 minimum) | Added c8, nyc, Make for broader Node.js and polyglot coverage | More projects supported out-of-box |
| Advisory thresholds, not enforcement | Coverage dashboard is visibility, not gating | Complements WALT's enforcement model |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- TODD coverage dashboard complete and functional
- Pattern established for analysis commands (detect → run → parse → present)
- Phase 19 (WALT Quality Trends) can proceed independently

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 18-todd-coverage-dashboard, Plan: 01*
*Completed: 2026-03-12*
