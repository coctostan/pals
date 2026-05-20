# Phase 291 Plan 01 — Plannotator Live-Surface Removal — SUMMARY

**Phase:** 291-plannotator-live-surface-removal
**Plan:** 01
**Milestone:** v2.68 Plannotator Retraction (1 of 2 phases)
**Date:** 2026-05-19
**Result:** ✅ PASS — all acceptance criteria satisfied; both validation harnesses green at new totals.

---

## Objective vs Result

**Planned:** Remove all live Plannotator integration surfaces (bridge code, workflow opt-in language, validation assertions) and reconcile harness totals in-phase, while preserving v2.66 archive authority. Defer hot-artifact decision-row reconciliation and contract doc deletion to Phase 292.

**Actual:** Done. Bridge deleted, README + skill-map cleaned, three kernel workflow files stripped of Plannotator language, both validation suites purged and reconciled to new totals (Pi 335→328; cross-harness 246→234). One in-scope deviation: `.paul/MILESTONES.md` updated during APPLY to satisfy the PALS artifact consistency guardrail when its "Current milestone" pointer pinned to v2.67 became stale relative to STATE/ROADMAP showing v2.68 Phase 291 active. The change is one line and falls inside the same lifecycle-reconciliation goal as the harness reconciliation; recorded here for transparency.

---

## Files Changed

Planned `files_modified` (8):

1. `drivers/pi/extensions/plannotator-bridge.ts` — **deleted**
2. `drivers/pi/extensions/README.md` — Plannotator removed from source-set bullet + install enumeration; Phase 285 paragraph deleted
3. `drivers/pi/skill-map.md` — Plannotator bridge bullet deleted; two source-set enumerations cleaned
4. `kernel/workflows/plan-phase.md` — `optional_plannotator_plan_review` step removed; `update_state` `priority="required"` preserved
5. `kernel/workflows/apply-phase.md` — `optional_plannotator_apply_code_review` step removed; PLAN-REVIEW-NOTES advisory `<required_reading>` bullet removed
6. `kernel/workflows/unify-phase.md` — `optional_plannotator_unify_code_review` step removed; CODE-REVIEW-NOTES advisory `<required_reading>` bullet removed
7. `tests/pi-end-to-end-validation.sh` — 7 Plannotator assertions deleted (in 5 blocks) + `EXT_PLANNOTATOR_BRIDGE` constant deleted
8. `tests/cross-harness-validation.sh` — 12 Plannotator assertions deleted (in 4 blocks)

Unplanned (1, in-scope deviation):

9. `.paul/MILESTONES.md` — "Current milestone" pointer updated from "v2.67 complete; next milestone pending" to "v2.68 Plannotator Retraction — Phase 291 of 292 in flight" to clear the artifact consistency guardrail Pi-suite check (`not ok 306`). Required because STATE/ROADMAP had already been updated by `/paul:plan` to reflect v2.68 active.

Lifecycle artifacts also touched during PLAN/APPLY (expected, not part of `files_modified`):

- `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/MILESTONE-CONTEXT.md` (consumed and deleted by `/paul:milestone`), `.paul/phases/291-plannotator-live-surface-removal/291-01-PLAN.md` (created by `/paul:plan`).

---

## Acceptance Criteria Results

| AC | Result | Evidence |
|----|--------|----------|
| **AC-1** Plannotator bridge code removed | ✅ PASS | `! test -e drivers/pi/extensions/plannotator-bridge.ts` (deleted in commit); `grep -rci 'plannotator-bridge\|requestPlanReview\|requestCodeReview\|awaitReviewResult' drivers/ kernel/ --include='*.ts' --include='*.js'` → 0; `grep -ci plannotator drivers/pi/extensions/README.md drivers/pi/skill-map.md` → 0/0 |
| **AC-2** Kernel workflow Plannotator opt-in retracted | ✅ PASS | `grep -ci plannotator kernel/workflows/{plan,apply,unify}-phase.md` → 0/0/0; `grep -c optional_plannotator kernel/workflows/*.md` → 0; no PLAN-REVIEW-NOTES / PLAN-FEEDBACK / CODE-REVIEW-NOTES references remain; 4-option PAUL review menu preserved |
| **AC-3** Validation harnesses purged & reconciled in-phase | ✅ PASS | `bash tests/pi-end-to-end-validation.sh` → 328/328 PASS (was 335; 7 removed); `bash tests/cross-harness-validation.sh` → 234/234 PASS (was 246; 12 removed); zero Plannotator/PLAN-REVIEW-NOTES/etc. matches in either harness |

---

## Task Results

| Task | Status | Notes |
|------|--------|-------|
| 1. Delete bridge + update Pi extension docs | PASS | One delete + two clean edits (README, skill-map). Pi installer source-set rule handles uninstall automatically. |
| 2. Strip Plannotator opt-in from kernel workflows | PASS | One step block deleted per workflow file; one advisory `<required_reading>` bullet removed from apply-phase.md and unify-phase.md. `<process>` framing and existing review menu preserved. |
| 3. Purge harness assertions + reconcile totals | PASS | 7 Pi e2e assertions across 5 blocks deleted + dead `EXT_PLANNOTATOR_BRIDGE` constant; 12 cross-harness assertions across 4 blocks deleted. Both harnesses count dynamically (no static TOTAL constant); new totals = Pi 328, cross 234. |

---

## Deviations

- **One unplanned file:** `.paul/MILESTONES.md` (see "Files Changed" above). Cleared the artifact consistency guardrail `not ok 306`; without it the Pi suite would have failed despite all Plannotator work being correct. Recorded in v2.68 milestone constraint compliance: still bounded to subtractive intent + lifecycle hygiene needed for the harness to pass.
- **No relaxed/skipped assertions:** All non-Plannotator assertions remain enforced; no Plannotator assertion left behind as "skipped" or commented.

---

## Boundaries

All "DO NOT CHANGE" boundaries respected:

- `.paul/phases/284-*` through `287-*` archives untouched.
- `.paul/MILESTONES.md` v2.66 row untouched (only the "Current milestone" pointer line was updated).
- `.paul/archive/project/PROJECT-HISTORY-v2.61-v2.66.md` untouched.
- `.paul/STATE.md` / `.paul/PROJECT.md` Plannotator decision rows untouched (deferred to Phase 292 as planned).
- `docs/PALS-PLANNOTATOR-UI-INTEGRATION-CONTRACT.md` untouched (deferred to Phase 292).
- `drivers/pi/driver.yaml` untouched (directory entry still valid).
- Installer code untouched (source-set rule handled deletion automatically).
- All non-Plannotator harness assertions untouched.

---

## Module Execution Reports

[dispatch] pre-plan advisory: TODD `tdd_candidates`: none (subtractive). IRIS `review_flags`: low. DAVE `deploy_warning`: none. DOCS `doc_warnings`: hot-artifact decision-row reconciliation deferred to Phase 292. CODI `blast_radius`: bounded (bridge referenced only by tests + README + skill-map). RUBY `debt_flags`: none.

[dispatch] pre-plan enforcement: DEAN — no dependency surface changes; PASS.

[dispatch] pre-apply: TODD — no TDD scope. WALT — baseline Pi 335/335, cross-harness 246/246 captured. CODI — bridge symbols confirmed bounded. DEAN — PASS.

[dispatch] post-task(Task 1): IRIS — clean removal; no orphan imports.
[dispatch] post-task(Task 2): DOCS — workflow `<process>` framing intact; 4-option PAUL review menu preserved.
[dispatch] post-task(Task 3): WALT — both harnesses green at new totals.

[dispatch] post-apply advisory: IRIS / DOCS / CODI — clean subtractive change, no orphan refs.
[dispatch] post-apply enforcement: WALT — PASS at Pi 328/328, cross-harness 234/234. DEAN — PASS.

[dispatch] pre-unify: TODD, WALT, IRIS, CODI, DEAN, RUBY, DOCS — reconciliation inputs clean; no blocking findings.

[dispatch] post-unify: WALT — Pi e2e 328/328 and cross-harness 234/234 hold. DOCS — SUMMARY records deviations and AC evidence. SKIP — no persistent knowledge writes. DEAN — no dep changes. IRIS — subtractive change verified.

---

## Decisions / Lessons

- **Artifact consistency guardrail catches lifecycle pointer drift.** When STATE/ROADMAP advance to a new milestone, MILESTONES "Current milestone" pointer must move in the same atomic phase or the Pi-suite blocks it. Worth surfacing in `/paul:milestone` flow so future milestones update MILESTONES inline rather than relying on the next phase's APPLY to discover the drift. Recorded as a phase-292 / future-improvement candidate, not in scope to fix here.
- **Installer source-set rule paid off.** Phase 285 added `plannotator-bridge.ts` next to other extension siblings; deleting it required no `install.sh` / `uninstall.sh` edit thanks to the generalized source-set rule established in Phases 239/243/246/250/254/258/262. This is durable evidence that the sibling-extraction pattern handles retraction symmetrically.
- **Harness totals reconciled in-phase (no inherited drift).** Pi e2e 335→328 and cross-harness 246→234. v2.67 closed the era of inherited marker drift; v2.68 Phase 291 stays consistent with that posture.
- **Hot-artifact retraction-row write deferred to Phase 292.** Recorded as the closure work; Phase 292 will replace the four Plannotator decision rows in PROJECT.md + STATE.md with a single retraction row and delete the contract doc.

---

## GitHub Flow

- Branch: `phase-291-plannotator-live-surface-removal`
- Base: `main`
- Commit: `1beb4b42` (12 files, +287/-577)
- PR: [#209](https://github.com/coctostan/pals/pull/209) — "Phase 291: Plannotator live-surface removal (v2.68 part 1/2)"
- CI: pending at PR open; UNIFY merge gate will block on failing/missing required checks per `pals.json` (`ci_checks: true`).

---

## Next Phase

Phase 291 is the only plan in this phase directory — Phase 291 completes after merge gate; transition routes to **Phase 292: Plannotator Contract Removal + v2.68 Closure**, which will:

1. Delete `docs/PALS-PLANNOTATOR-UI-INTEGRATION-CONTRACT.md`.
2. Replace the four Plannotator-related "current decisions" rows in `.paul/PROJECT.md` and the related current-decisions/posture references in `.paul/STATE.md` with a single retraction decision row pointing at this SUMMARY and Phase 292's SUMMARY.
3. Update MILESTONES live status to mark v2.68 complete and add an archived v2.68 row.
4. Perform final v2.68 validation closure (Pi + cross-harness green at the new totals).
5. Close the milestone via GitHub Flow merge gate.
