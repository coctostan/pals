---
phase: 280-agent-convention-surface
plan: 01
subsystem: kernel
tags: [agents, init-workflow, conventions, functional-first, validation]
requires:
  - phase: 279-functional-first-guidance-contract
    provides: docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md authority for v2.65 implementation boundaries
provides:
  - Generated AGENTS Engineering Principles section
  - Init workflow Engineering Principles generation guidance
  - Pi and cross-harness marker checks for installed convention surfaces
affects:
  - Phase 281 Brownfield Convention Detection
  - Phase 282 TODD + RUBY Guidance
  - Phase 283 ARCH Advisory + Closure
tech-stack:
  added: []
  patterns:
    - Advisory functional-first guidance remains subordinate to project-specific conventions
    - Installed-resource validation protects convention-surface markers without adding a new gate
key-files:
  created: []
  modified:
    - kernel/templates/AGENTS.md
    - kernel/workflows/init-project.md
    - tests/pi-end-to-end-validation.sh
    - tests/cross-harness-validation.sh
key-decisions:
  - "Decision: Functional-first guidance belongs in generated AGENTS Engineering Principles before Project Conventions, while Project Conventions remain authoritative."
patterns-established:
  - "Pattern: Agent convention defaults should be compact, editable, and guarded by installed-resource marker checks."
duration: 5min
started: 2026-05-12T23:59:59Z
completed: 2026-05-13T00:04:00Z
---

# Phase 280 Plan 01: Agent Convention Surface Summary

**Generated agent convention surfaces now carry compact functional-first Engineering Principles, and validation scripts guard those installed markers without creating a new module or blocking FP gate.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~5 minutes |
| Started | 2026-05-12T23:59:59Z |
| Completed | 2026-05-13T00:04:00Z |
| Tasks | 3 completed |
| Files modified | 4 planned source files |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Generated AGENTS Template Carries Advisory Engineering Principles | Pass | `kernel/templates/AGENTS.md` now includes `## Engineering Principles`, “Functional-first, not functional-only”, “Project Conventions remain authoritative”, and side-effect-boundary guidance before `## Project Conventions`. |
| AC-2: Init Workflow Generates the Same Editable Guidance | Pass | `kernel/workflows/init-project.md` now describes adding default Engineering Principles and includes the same generated markdown markers before Project Conventions. |
| AC-3: Validation Guards the Installed Convention Surface | Pass | `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` assert the installed AGENTS template and init workflow keep the required markers. |

## Module Execution Reports

### Pre-UNIFY

[dispatch] pre-unify: 0 modules registered for this hook.

### WALT Quality

[dispatch] WALT post-unify: appended quality history for `280-01` with carried APPLY evidence. New Phase 280 marker checks passed in both validation suites. Overall suite status remains `PASS_WITH_BASELINE_CONCERNS`: Pi validation reported 308/314 with six pre-existing CODI/artifact-consistency failures; cross-harness reported 205/206 with one pre-existing artifact-consistency failure.

### CODI Dispatch History

[dispatch] CODI post-unify: `280-01` classified as `skipped-no-symbols`; PLAN pre-plan evidence recorded CODI skipped because this markdown/shell phase had no explicit TS/JS selectors or stable code seeds. Appended `.paul/CODI-HISTORY.md` row with `blast_radius=n`.

### SKIP Knowledge Capture

[dispatch] SKIP post-unify: captured one source-backed knowledge candidate in this SUMMARY: generated agent convention defaults should remain compact, editable, subordinate to project-specific conventions, and covered by installed-resource marker checks.

### RUBY Debt Review

[dispatch] RUBY post-unify: NOT_APPLICABLE for code debt; changed files are markdown/workflow/test-shell convention-surface validation and do not introduce runtime code complexity.

## Accomplishments

- Added compact Engineering Principles to the generated `AGENTS.md` template, including functional-first/non-functional-only doctrine and side-effect-boundary guidance.
- Updated init workflow generation so new projects receive the same editable Engineering Principles while preserving Project Conventions as authoritative.
- Added Pi and cross-harness installed-resource marker checks for the AGENTS template and init workflow markers.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Add Engineering Principles to generated AGENTS surfaces | `0ccc722f` | docs | Added guidance to `kernel/templates/AGENTS.md` and `kernel/workflows/init-project.md`. |
| Task 2: Add validation markers for installed resources | `0ccc722f` | test | Added installed AGENTS/init marker checks to Pi and cross-harness validation scripts. |
| Task 3: Run focused and full phase verification | `0ccc722f` | docs/test | Captured marker-pass evidence and baseline validation failures. |

Plan metadata: included in the Phase 280 UNIFY metadata commit.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `kernel/templates/AGENTS.md` | Modified | Adds default Engineering Principles before Project Conventions. |
| `kernel/workflows/init-project.md` | Modified | Generates the same Engineering Principles during `/paul:init`. |
| `tests/pi-end-to-end-validation.sh` | Modified | Asserts installed Pi AGENTS template/init workflow contain functional-first markers. |
| `tests/cross-harness-validation.sh` | Modified | Asserts both Claude Code and Pi installed AGENTS/init surfaces contain the markers. |
| `.paul/phases/280-agent-convention-surface/280-01-SUMMARY.md` | Created | Records UNIFY reconciliation and module reports. |
| `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/PROJECT.md`, `.paul/CODI-HISTORY.md`, `.paul/QUALITY-HISTORY.md` | Modified | Lifecycle, transition, and module-history updates. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Put default Engineering Principles before Project Conventions. | The guidance should be visible in generated convention surfaces while the project-owned section remains authoritative. | New projects receive practical defaults without losing local override authority. |
| Keep guidance advisory and marker-validated only. | Phase 280 explicitly excluded new modules, blocking gates, dependencies, and architecture changes. | Validation guards text presence but does not turn functional style into enforcement. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None |
| Scope additions | 0 | None |
| Deferred | 0 | No new deferred Phase 280 work |

**Total impact:** Plan executed as written. Existing validation baseline failures remain outside Phase 280 scope and were not introduced by this plan.

### Auto-fixed Issues

None.

### Deferred Items

None from Phase 280. Existing deferred CODI marker/artifact-consistency validation debt remains recorded in STATE.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| `bash tests/pi-end-to-end-validation.sh` still reports six failures. | New Phase 280 marker checks passed; failures are existing CODI/artifact-consistency baseline issues and were recorded as non-blocking baseline concerns for this phase. |
| `bash tests/cross-harness-validation.sh` still reports one artifact-consistency failure. | New Phase 280 marker checks passed; failure is an existing artifact-consistency baseline concern outside Phase 280 scope. |

## Next Phase Readiness

**Ready:**
- Phase 281 can teach brownfield mapping to detect convention signals using the contract and generated-surface guidance now in place.
- Phase 282 can update TODD/RUBY guidance knowing project convention authority is explicit.

**Concerns:**
- Baseline CODI/artifact-consistency validation failures remain unrelated to Phase 280.

**Blockers:**
- None for Phase 281 planning after merge gate completion.

---
*Phase: 280-agent-convention-surface, Plan: 01*
*Completed: 2026-05-13*
