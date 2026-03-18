---
phase: 71-recommendations
plan: 01
subsystem: modules
tags: [recommendations, module-proof, visibility, reporting, milestone-close]
requires:
  - phase: 68-execution-audit
    provides: wiring-vs-visibility findings and the recommendation questions left open for Phase 71
  - phase: 69-gap-fixes
    provides: durable post-unify evidence path via module_reports and side_effects
  - phase: 70-visibility-ux
    provides: bounded live Pi module visibility derived from canonical shared workflow/reporting signals
provides:
  - per-module keep/improve/merge/remove recommendation matrix
  - bounded proof-and-visibility guidance
  - v2.7 milestone-close report and next-step handoff
affects:
  - next milestone definition
  - module reporting guidance
  - future Pi/module recommendation work
tech-stack:
  added: []
  patterns:
    - preserve the module roster and improve legibility before considering consolidation
    - separate dispatch trace, durable reports, side effects, validation, and Pi live visibility into distinct evidence roles
    - keep Pi live visibility adapter-only and non-authoritative while shared artifacts remain the durable truth
key-files:
  created:
    - .paul/phases/71-recommendations/module-recommendations-matrix.md
    - .paul/phases/71-recommendations/proof-visibility-guidance.md
    - .paul/phases/71-recommendations/71-recommendations-report.md
    - .paul/phases/71-recommendations/71-01-SUMMARY.md
  modified:
    - .paul/STATE.md
    - .paul/ROADMAP.md
    - .paul/PROJECT.md
key-decisions:
  - "Decision: Keep the module roster; opacity did not justify merge/remove recommendations"
  - "Decision: Standardize a layered proof model: dispatch trace, durable reports, side effects, validation, and bounded Pi live visibility"
patterns-established:
  - "Pattern: Recommendation phases should prefer explicit keep/improve calls over forced structural change when audit evidence shows bounded but real value"
  - "Pattern: End reports should omit module sections when no durable evidence survives rather than implying universal module participation"
duration: ~21min
started: 2026-03-18T09:55:47-0400
completed: 2026-03-18T10:16:51-0400
---

# Phase 71 Plan 01: Recommendations Summary

**Closed v2.7 by turning the audit, evidence-path repair, and live Pi visibility work into a stable recommendation set: keep the module architecture, improve proof/report legibility where needed, and explicitly reject telemetry or Pi-owned execution truth.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~21min |
| Started | 2026-03-18T09:55:47-0400 |
| Completed | 2026-03-18T10:16:51-0400 |
| Tasks | 3 completed |
| Files modified | 3 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Every module gets an explicit decision-usable recommendation | Pass | `module-recommendations-matrix.md` covers CARL, TODD, WALT, DEAN, DAVE, DOCS, IRIS, RUBY, and SKIP with keep/improve/merge/remove guidance, rationale, and timing |
| AC-2: The proof/visibility model stays bounded and artifact-safe | Pass | `proof-visibility-guidance.md` separates dispatch trace, durable `Module Execution Reports`, side effects, validation, and Pi live visibility while rejecting telemetry and Pi-owned lifecycle truth |
| AC-3: End-report guidance makes module participation legible without false certainty | Pass | `proof-visibility-guidance.md` defines when module sections should persist, when silence is correct, and how `module_reports` differ from `side_effects` |
| AC-4: The v2.7 milestone can close with clear next-step guidance | Pass | `71-recommendations-report.md` closes the milestone with preserved guardrails, strong calls, and a recommended next-step sequence |

## Accomplishments

- Produced a per-module recommendation matrix that concluded the current roster should be preserved and selectively improved rather than consolidated out of visibility anxiety.
- Defined one layered proof/visibility model that cleanly separates live traceability, durable summary evidence, side effects, validation, and Pi's additive live UX.
- Closed v2.7 with a direct handoff that future work can use without reopening the Phase 68-70 debates.

## Task Commits

Each task was completed in the working session and will be captured in the phase transition commit.

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Produce a per-module recommendation matrix | `HEAD` | docs | Created `module-recommendations-matrix.md` with explicit per-module keep/improve/merge/remove guidance |
| Task 2: Define bounded proof, visibility, and end-report guidance | `HEAD` | docs | Created `proof-visibility-guidance.md` defining the layered proof model and summary guidance |
| Task 3: Write the final recommendations and milestone-close report | `HEAD` | docs | Created `71-recommendations-report.md` to close v2.7 and route future work |

Plan metadata: `HEAD` (phase transition commit created after UNIFY closes the loop)

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `.paul/phases/71-recommendations/module-recommendations-matrix.md` | Created | Gives every shipped module a concrete disposition and timing recommendation |
| `.paul/phases/71-recommendations/proof-visibility-guidance.md` | Created | Defines the bounded long-term proof, visibility, validation, and end-report model |
| `.paul/phases/71-recommendations/71-recommendations-report.md` | Created | Summarizes the strongest calls, guardrails, and follow-on sequence for milestone closeout |
| `.paul/phases/71-recommendations/71-01-SUMMARY.md` | Created | Reconciles the Phase 71 plan against delivered recommendation artifacts |
| `.paul/STATE.md` | Modified | Closes the loop, records the final phase outcome, and routes the project to milestone completion |
| `.paul/ROADMAP.md` | Modified | Marks Phase 71 and v2.7 complete |
| `.paul/PROJECT.md` | Modified | Records v2.7 completion and the key Phase 71 recommendation decisions |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Keep the module roster; do not force merge/remove decisions | Phase 68 showed opacity more than dead weight, and Phases 69-70 solved the core trust gaps without proving structural redundancy | Future work can focus on legibility and recommendation clarity instead of destabilizing module boundaries |
| Use a layered proof model across dispatch logs, durable reports, side effects, validation, and bounded Pi live visibility | Each surface is good at a different kind of truth; collapsing them would either overclaim or require telemetry | Preserves artifact-first portability while making module participation easier to interpret |
| Treat silence from conditional/advisory modules as acceptable when no durable evidence survives | Not every enabled module should appear in every run, and forced boilerplate would imply false certainty | End reports can stay honest and compact instead of pretending universal module participation |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None |
| Scope additions | 0 | None |
| Deferred | 0 | None |

**Total impact:** No material deviation — the phase stayed within recommendation-only scope and did not reopen implementation work from Phases 69 or 70.

### Deferred Items

None - plan executed exactly as written.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| The repo checkout still has no repo-local `kernel/modules.yaml`, so live recommendation evidence could not rely on in-repo runtime dispatch metadata | Used the completed Phase 68 audit, shared specs/contracts, Pi visibility docs, and module manifests as the authoritative evidence package for recommendation synthesis |

## Skill Audit

- `/paul` lifecycle flow was used through PLAN → APPLY → UNIFY for this phase.
- Required skill audit result: All required skills invoked ✓

## Next Phase Readiness

**Ready:**
- v2.7 can close cleanly with a recommendation-backed explanation of what the module system should keep, improve, and defer.
- The next milestone can start directly from the recommendation matrix, proof/visibility guidance, and final report.
- The project now has a stable answer to the original trust question without needing telemetry or Pi-owned module state.

**Concerns:**
- The next milestone is not yet defined; future work should choose a narrow follow-on scope rather than reopening the full proof/visibility debate.
- Future improvements should preserve the artifact-first model and resist slipping into module dashboards or execution ledgers.

**Blockers:**
- None

---
*Phase: 71-recommendations, Plan: 01*
*Completed: 2026-03-18*
