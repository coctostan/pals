---
phase: 298-validation-closure
plan: 01
subsystem: tests
tags: [strategic-assessment, validation, marker-checks, pi-e2e, cross-harness, v2.70, closure]

requires:
  - phase: 297-discuss-workflow-integration
    provides: the wired optional strategic_assessment step + Bash/Glob/Grep on discuss command surfaces that this phase pins
  - phase: 296-strategic-assessment-contract-template
    provides: contract + STRATEGIC-ASSESSMENT template referenced by the new marker checks
provides:
  - installed-resource marker checks pinning the v2.70 strategic-assessment surface in both validation suites (Pi e2e + cross-harness)
affects:
  - future edits to discuss-milestone.md / discuss.md / STRATEGIC-ASSESSMENT.md (now regression-guarded)

tech-stack:
  added: []
  patterns:
    - "Validation-hygiene phase: pin a freshly-wired behavior with additive marker checks in both harness suites before milestone closure"
    - "Surface-aware assertions: installed workflow/template checked at install roots; command surfaces (which Pi does not install as files) checked at the kernel source path"

key-files:
  created:
    - .paul/phases/298-validation-closure/298-01-PLAN.md
    - .paul/phases/298-validation-closure/298-01-SUMMARY.md
  modified:
    - tests/pi-end-to-end-validation.sh
    - tests/cross-harness-validation.sh

key-decisions:
  - "Decision: assert the discuss command surfaces against $REPO_ROOT/kernel/commands/paul/ (source), not an install root, because Pi installs no command .md files — followed the existing review-command precedent in both suites"
  - "Decision: keep all edits additive (no changes to existing checks, helpers, or TAP-plan logic) so closure validation cleanly proves no regression"

patterns-established:
  - "Pattern: when pinning a wired surface, check the installed artifact at the harness-specific install root and the un-installed command surface at the kernel source path"

duration: ~25min
started: 2026-06-02T00:00:00Z
completed: 2026-06-02T00:25:00Z
---

# Phase 298 Plan 01: Validation + Closure Summary

**Pinned the v2.70 strategic-assessment surface with additive installed-resource marker checks in both validation suites — Pi e2e 331→336 and cross-harness 235→241 — clearing the Phase 297 SUMMARY "untested surface" concern. This is the final phase of v2.70.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~25 min |
| Tasks | 2 completed |
| Files modified | 2 (both test suites) |
| Pi e2e | 331 → 336 (+5) |
| Cross-harness | 235 → 241 (+6) |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Pi e2e pins the installed strategic-assessment surface | Pass | 5 new checks (118–122): installed `discuss-milestone` workflow wires the optional `strategic_assessment` step (OPTIONAL/NON-BLOCKING, non-authoritative, contract + template refs, `.paul/assessments/`, NO subagents) and keeps the four-part output; both source command surfaces grant `[Read, Write, Bash, Glob, Grep, AskUserQuestion]` + reference contract/template; installed template carries the four-part headings + Non-authoritative stance. Pi e2e 336/336, Failed 0. |
| AC-2: Cross-harness pins the surface with CC↔Pi parity | Pass | 6 new checks (236–241): both installed workflows (CC `$TEMP_CC/.pals`, Pi `$TEMP_PI/.pi/agent/skills/pals`) wire the step; both installed templates carry the four-part shape; both source command surfaces grant Bash/Glob/Grep. Cross-harness 241/241, Failed 0. |
| AC-3: Full closure validation green with no regression | Pass | Pi e2e 336/336, cross-harness 241/241, `artifact_consistency` PASS, `git diff --check` clean. No previously passing check regressed (baselines 331 / 235 both fully retained + increased). |

## Module Execution Reports

### Pre-apply (APPLY)
- `[dispatch] pre-apply: TODD(50)` → SKIPPED — non-TDD execute plan (shell-test marker checks); the added checks ARE the tests.
- `[dispatch] pre-apply: WALT(100)` → baseline captured: Pi e2e 331/331, cross-harness 235/235, artifact_consistency PASS, `git diff --check` clean.

### Post-task (APPLY)
- `[dispatch] post-task(Task 1/2): TODD(100)` → SKIPPED — shell-test marker checks, no test-first cycle applies.
- `[dispatch] post-task(Task 2/2): TODD(100)` → SKIPPED — shell-test marker checks, no test-first cycle applies.

### Post-apply advisory (APPLY)
- ARCH(125)/SETH(130)/GABE(140)/DANA(155)/LUKE(160)/ARIA(165)/OMAR(170)/DAVE(175)/PETE(175)/REED(180)/VERA(185) → skipped — no in-scope source/API/UI/CI/data/observability/perf/resilience/privacy files (shell-test only).
- DOCS(250) → NOT_APPLICABLE — test-harness change.
- IRIS(250) → no review markers introduced in changed files.
- SKIP(300) → knowledge candidate: when pinning a wired surface, assert the installed artifact at the harness install root and the un-installed command surface at the kernel source path (Pi installs no command `.md`).

### Post-apply enforcement (APPLY)
- `[dispatch] post-apply enforcement: WALT(100)` → PASS — Pi e2e 336/336 (+5), cross-harness 241/241 (+6), artifact_consistency PASS (== baseline), `git diff --check` clean; no quality regression.
- `[dispatch] post-apply enforcement: DEAN(150)` → PASS — no dependency manifest/lockfile changes; carry counts forward.
- `[dispatch] post-apply enforcement: TODD(200)` → SKIPPED — non-TDD shell-test scope, no full suite applies.

### Pre-unify (UNIFY)
- `[dispatch] pre-unify: 0 modules registered for this hook`.

### Post-unify (UNIFY)
- `[dispatch] post-unify: CODI(220)` → no CODI evidence in PLAN module_dispatch (shell/markdown scope, pre-plan CODI skipped — no TS/JS seeds) → no-dispatch-found row appended to `.paul/CODI-HISTORY.md`.
- `[dispatch] post-unify: RUBY(300)` → NOT_APPLICABLE — adding validation marker checks is not code debt.
- `[dispatch] post-unify: SKIP(200)` → knowledge entry recorded (surface-aware assertion pattern; see post-apply advisory candidate above).
- `[dispatch] post-unify: WALT(100)` → quality delta appended to `.paul/QUALITY-HISTORY.md`; bash harness PASS — Pi 331→336, cross-harness 235→241 (test-count growth, no numeric code-quality delta).

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Pi e2e marker checks | `67229f93` | test | Pin installed Pi workflow step + source command surfaces + installed template (331→336) |
| Task 2: Cross-harness parity checks | `e512c0ba` | test | Pin CC↔Pi installed workflow/template parity + source command surfaces (235→241) |

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `tests/pi-end-to-end-validation.sh` | Modified | +5 marker checks for the strategic-assessment surface; added `PI_DISCUSS_MILESTONE` / `PI_ASSESSMENT_TEMPLATE` install-root vars |
| `tests/cross-harness-validation.sh` | Modified | +6 CC↔Pi parity checks under a new "v2.70 STRATEGIC-ASSESSMENT SURFACE PARITY" section |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Assert command surfaces at `$REPO_ROOT/kernel/commands/paul/` (source), not an install root | Pi installs no command `.md` files; the existing review-command checks in both suites already use the source path | Checks are correct and harness-faithful; no false negative from a non-existent installed command file |
| Keep all edits strictly additive | A clean no-regression proof is the whole point of a validation-hygiene phase | Baselines 331/235 fully retained; closure validation unambiguous |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None |
| Scope additions | 0 | None |
| Deferred | 0 | None |

**Total impact:** Plan executed exactly as written; no deviations.

### Deferred Items

None.

## Issues Encountered

None — both tasks passed on first verification.

## Next Phase Readiness

**Ready:**
- v2.70's strategic-assessment surface is now regression-pinned in both harnesses; the Phase 297 "untested surface" concern is fully closed.
- Phase 298 is the **final phase of v2.70** — after the GitHub Flow merge gate (PR #217) and phase transition, route to **milestone completion** for v2.70 Strategic Milestone Assessment.

**Concerns:**
- None.

**Blockers:**
- None.

---
*Phase: 298-validation-closure, Plan: 01*
*Completed: 2026-06-02*
