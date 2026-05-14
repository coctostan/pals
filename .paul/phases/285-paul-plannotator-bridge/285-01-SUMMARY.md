# Phase 285 Plan 285-01 Summary — PAUL ↔ Plannotator Bridge

## Objective

Create the repo-source Pi extension bridge for optional Plannotator review requests, with helper exports for plan/code review, async result recovery, graceful unavailable/timeout handling, and marker validation for the new installed-resource surface.

## Result

PASS. Phase 285 added the bounded Plannotator bridge sibling under `drivers/pi/extensions/`, surfaced it in Pi-facing docs and adapter maps, and added marker validation proving the helper names, event channels, optional/advisory posture, and no-lifecycle-authority boundary.

The bridge is not wired into PAUL workflows yet. Phases 286–287 own plan-review/code-review workflow prompts, sidecars, and result incorporation.

## Files Changed

| File | Purpose |
|------|---------|
| `drivers/pi/extensions/plannotator-bridge.ts` | New optional/advisory Pi extension bridge exposing `requestPlanReview`, `requestCodeReview`, and `awaitReviewResult` through the Plannotator event surface. |
| `drivers/pi/extensions/README.md` | Documents `plannotator-bridge.ts` as part of the repo-owned Pi extension source set and preserves advisory/non-authority language. |
| `drivers/pi/skill-map.md` | Adds Plannotator bridge to the Pi adapter map as an optional helper, not a skill/module/workflow authority. |
| `tests/pi-end-to-end-validation.sh` | Adds marker checks for bridge helper names, event channels, fallback statuses, advisory `savedPath`, ignored fields, and docs/skill-map surfacing. |
| `.paul/phases/285-paul-plannotator-bridge/285-01-PLAN.md` | Approved plan artifact for Phase 285. |
| `.paul/STATE.md` | Lifecycle state updated from PLAN to APPLY completion and UNIFY routing. |
| `.paul/ROADMAP.md` | Phase 285 status updated through APPLY and UNIFY routing. |
| `.paul/MILESTONES.md` | Current milestone pointer refreshed to v2.66 / Phase 285. |
| `.paul/handoffs/archive/HANDOFF-2026-05-14-phase-285-ready-to-plan.md` | Consumed active handoff archived after APPLY proceeded. |

No workflow instruction files, installed runtime copies, `pals.json`, module registry, dependency manifests, Plannotator internal modes, or `.paul/*` lifecycle authority semantics were changed.

## Acceptance Criteria Results

| AC | Result | Evidence |
|----|--------|----------|
| AC-1: Bridge sibling exposes contracted helpers and event surface | PASS | `drivers/pi/extensions/plannotator-bridge.ts` exports `requestPlanReview`, `requestCodeReview`, and `awaitReviewResult`; defines `plannotator:request` and `plannotator:review-result`; includes `review-status`; ends with the `No-op Pi extension factory` loader-compat marker. |
| AC-2: Optional integration fails gracefully without lifecycle authority | PASS | Bridge returns normalized unavailable/error/timeout/abandoned/missing results for optional absence or incomplete review; bounds review-status retry; comments and types preserve advisory `savedPath`, ignore `agentSwitch`/`permissionMode`, and state no `.paul/*` lifecycle writes. |
| AC-3: Installed-resource docs and validation surface the new bridge | PASS | `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, and `tests/pi-end-to-end-validation.sh` all mention `plannotator-bridge.ts` and the advisory/non-authoritative boundary. New Pi marker checks 225–227 passed in the final Pi validation run. |

## Task Results

| Task | Result | Evidence |
|------|--------|----------|
| Task 1: Implement bounded Plannotator bridge sibling | PASS | Created `drivers/pi/extensions/plannotator-bridge.ts` with dependency-injected Pi event surface, plan/code review request helpers, matched `reviewId` handling, bounded timeout/status recovery, and non-authority comments. |
| Task 2: Surface bridge in Pi docs and adapter map | PASS | Updated Pi extension README and skill map source-set lists; added compact bridge note preserving optional/advisory, no `.paul/*` lifecycle truth, no workflow-instruction-change, and ignored-field boundaries. |
| Task 3: Add Pi marker validation for bridge contract | PASS | Added `EXT_PLANNOTATOR_BRIDGE` and marker checks to `tests/pi-end-to-end-validation.sh`; final Pi run shows bridge checks PASS. |

## Verification Results

Executed during APPLY/UNIFY:

```text
git diff --check                         PASS
bash -n tests/pi-end-to-end-validation.sh PASS
bash -n tests/cross-harness-validation.sh PASS
bash tests/helpers/artifact_consistency.sh PASS
bash tests/cross-harness-validation.sh    PASS — 234/234
bash tests/pi-end-to-end-validation.sh    324/331; Phase 285 marker checks PASS; 7 inherited CODI/PROJECT/ROADMAP budget failures remain
```

Final Pi validation inherited failures:

```text
not ok 15  - Installed modules.yaml preserves CODI source-selector and success-log markers
not ok 121 - Repo PROJECT stays within v2.62 byte budget
not ok 123 - Repo ROADMAP stays within v2.62 byte budget
not ok 201 - Installed CODI reference keeps source-selector, value-envelope, and safe-setup markers
not ok 204 - Installed modules.yaml carries CODI post-unify dispatch-outcome instrumentation hook
not ok 206 - Installed CODI instrumentation reference documents schema, taxonomy, and read order
not ok 208 - Installed CODI manifest preserves all pre-plan skip-log strings (drift guard)
```

These failures are unrelated to Phase 285's new bridge markers; all new bridge checks passed.

Workguard:

```text
runs/workguards/20260514T155028Z-phase-285-apply/workguard-report.json
changed=0 at final report after commit
outside_allowed=0
over_budget=false
```

## Deviations / Concerns

- The bridge prepares the helper surface only; it does not yet prompt users or write Plannotator sidecars. This is intentional Phase 285 scope. Phase 286 owns plan-review workflow integration and Phase 287 owns code-review workflow integration.
- Exact runtime `savedPath` serialization remains opaque/advisory. The bridge exposes it as a string only and does not parse, copy, or adopt it.
- The implementation uses a generic Pi event surface contract because Plannotator runtime invocation was not required in this phase. The marker validation guards the expected public helper/event shape without requiring Plannotator installation or browser automation.
- Pi validation still carries inherited CODI marker drift and hot-artifact byte-budget failures. Cross-harness and artifact consistency are green.

## Module Execution Reports

Pre-unify:

```text
[dispatch] pre-unify: 0 modules registered for this hook
```

Post-unify:

```text
[dispatch] WALT post-unify: appended quality row for 285-01; final evidence is cross-harness 234/234 PASS, artifact_consistency PASS, git diff --check PASS, and Pi 324/331 with inherited CODI/PROJECT/ROADMAP-budget failures unrelated to Phase 285 bridge checks.
[dispatch] SKIP post-unify: knowledge candidate recorded in SUMMARY only — Plannotator bridge is a bounded optional/advisory adapter helper; workflow authority and sidecar incorporation remain deferred to Phases 286–287.
[dispatch] CODI post-unify: skipped-no-symbols; PLAN pre-plan CODI evidence was skipped-no-symbols for new bridge surface and no pre-plan blast-radius evidence was injected.
[dispatch] RUBY post-unify: no technical debt concerns recorded beyond keeping the new bridge bounded and non-authoritative.
```

## Durable Decisions / Lessons

- A separate `plannotator-bridge.ts` sibling keeps Plannotator event mechanics isolated from `pals-hooks.ts` and from PAUL workflow authority.
- `savedPath`, `agentSwitch`, and `permissionMode` remain contract-governed advisory/ignored fields; the bridge must not silently expand PALS authority if upstream adds fields.
- Marker validation is the right proof shape for Phase 285: it validates the installed-resource surface without requiring Plannotator to be installed or a browser UI to run.
- Workflow integration should consume this bridge through explicit per-invocation prompts and sidecar policies, not by direct lifecycle mutation.

## GitHub Flow

- Branch: `feature/285-paul-plannotator-bridge`
- APPLY commit: `b06553b1 feat(285-01): add Plannotator bridge surface`
- APPLY postflight commit: `785c7579 docs(285-01): record apply postflight PR`
- PR: https://github.com/coctostan/pals/pull/203
- UNIFY commit: pending at summary creation time
- Merge gate: pending GitHub Flow CI/PR checks after UNIFY commit

## Next Phase Note

Phase 286 — Plan Review UI Hook — should integrate this bridge into `/paul:plan` as an opt-in plan-review surface. It should preserve the Phase 284 contract: project-level config only makes the surface available, per-invocation prompt remains required, denial feedback writes `PLAN-FEEDBACK-{iteration}.md`, approval-with-notes writes `PLAN-REVIEW-NOTES.md`, and `.paul/*` lifecycle truth remains PAUL-owned.
