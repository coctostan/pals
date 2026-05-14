# Phase 287 Plan 01 Summary — Code Review Workflow Integration

## Implementation

- Added `optional_plannotator_apply_code_review` to `kernel/workflows/apply-phase.md` after post-apply gates and before GitHub Flow postflight/finalize routing.
- Added `CODE-REVIEW-NOTES.md` bounded required-reading guidance to `kernel/workflows/unify-phase.md` as advisory context only.
- Added `optional_plannotator_unify_code_review` to `kernel/workflows/unify-phase.md` before the GitHub Flow merge gate.
- Preserved PAUL authority: code review is project-available plus per-invocation opt-in, decline is zero-overhead, bridge use is limited to `requestCodeReview`, and Plannotator cannot approve/block/widen lifecycle work, replace REV, auto-route to `/paul:fix`, or override module/GitHub Flow gates.
- Documented advisory code-review sidecar output: `.paul/phases/{phase-slug}/CODE-REVIEW-NOTES.md` with surface (`apply` or `unify`), approval state, feedback, diff context, optional opaque annotation count/reference, and advisory-only statement.
- Added Phase 287 marker checks to Pi end-to-end and cross-harness validation scripts.

## Validation

- `git diff --check` — PASS
- `bash -n tests/pi-end-to-end-validation.sh` — PASS
- `bash -n tests/cross-harness-validation.sh` — PASS
- `bash tests/helpers/artifact_consistency.sh` — PASS
- `bash tests/cross-harness-validation.sh` — PASS (246/246)
- `bash tests/pi-end-to-end-validation.sh` — PASS for new Phase 287 markers; overall inherited failures remain (328/335):
  - installed CODI/module marker drift checks: 15, 205, 208, 210, 212
  - existing `.paul/PROJECT.md` and `.paul/ROADMAP.md` byte-budget checks: 125, 127

## Module Execution Reports

- `[dispatch] pre-apply: TODD skipped — no TDD enforcement for this docs/workflow-marker scope.`
- `[dispatch] pre-apply: WALT baseline recorded — shell validation commands available; syntax checks and artifact consistency used as baseline evidence.`
- `[dispatch] post-task(Task 1): TODD skipped — no test command-specific TDD task; marker grep evidence passed for APPLY workflow.`
- `[dispatch] post-task(Task 2): TODD skipped — no test command-specific TDD task; marker grep evidence passed for UNIFY workflow.`
- `[dispatch] post-task(Task 3): TODD skipped — no test command-specific TDD task; shell syntax checks and validation scripts passed or inherited-failed as noted.`
- `[dispatch] post-apply advisory: IRIS PASS — no TODO/FIXME/HACK/XXX markers in changed workflow/validation files.`
- `[dispatch] post-apply advisory: DOCS NOT_APPLICABLE — workflow-instruction documentation scope, no separate README/docs update needed.`
- `[dispatch] post-apply advisory: ARCH/ARIA/DANA/DAVE/GABE/LUKE/OMAR/PETE/REED/VERA skipped — no in-scope app UI/API/data/runtime/CI/dependency source changes.`
- `[dispatch] post-apply enforcement: WALT PASS_WITH_CONCERNS — required validation commands run; cross-harness passed; Pi end-to-end new Phase 287 checks passed with inherited unrelated failures classified separately.`
- `[dispatch] post-apply enforcement: TODD skipped — non-TDD scope; no new test regression evidence.`
- `[dispatch] post-apply enforcement: DEAN PASS — no dependency manifests or lockfiles changed.`
- `[dispatch] pre-unify: 0 modules registered for this hook.`
- `[dispatch] post-unify: WALT appended `.paul/QUALITY-HISTORY.md` row for `287-01` with cross-harness PASS and Pi inherited-failure baseline concerns.`
- `[dispatch] post-unify: SKIP no complete source-backed knowledge entries beyond PROJECT.md decision update; no separate knowledge artifact created.`
- `[dispatch] post-unify: CODI appended `.paul/CODI-HISTORY.md` row for `287-01` as `skipped-no-symbols` from PLAN evidence.`
- `[dispatch] post-unify: RUBY NOT_APPLICABLE — docs/workflow-marker scope, no code-debt candidate.

## Acceptance Criteria

- AC-1 PASS — APPLY workflow now offers opt-in Plannotator code review while keeping PAUL lifecycle authority.
- AC-2 PASS — UNIFY reads and records `CODE-REVIEW-NOTES.md` only as advisory evidence without overriding REV, GitHub Flow, CI/reviews, merge gates, or lifecycle truth.
- AC-3 PASS — Pi and cross-harness validation scripts protect the APPLY/UNIFY code-review workflow markers.

## UNIFY Result

- Plan vs actual reconciled: all planned files changed, code-review surfaces remain optional/advisory, no Plannotator runtime/browser requirement was added, and no out-of-scope bridge/default changes were introduced.
- Phase status: Phase 287 complete, 1/1 plan unified.
- Milestone status: v2.66 complete, 4/4 phases unified.
- GitHub Flow: PR #205 opened and Socket checks passed; merge gate continues through PR merge/base sync.

## Handoff Notes for UNIFY

- Phase 287 intentionally does not invoke Plannotator at runtime or require browser/UI execution for validation.
- v2.66 milestone closure should record that plan-review and code-review workflow surfaces are both integrated as optional/advisory review aids with no `.paul/*` authority transfer.
