---
phase: 175-install-time-detection-value-envelope-docs-format-fix
plan: 01
subsystem: modules
tags: [codi, pi, installer, docs, validation]
requires:
  - phase: 173-real-world-trial-gating-decision
    provides: [value-envelope findings, resolved-count ambiguity evidence]
  - phase: 174-source-file-symbol-extraction
    provides: [live source-selector extraction on installed Pi surfaces]
provides:
  - bounded Pi install-time codegraph-index recommendation
  - CODI value-envelope docs aligned across manifest, reference, README, and changelog
  - semantic validation coverage for installer and CODI documentation markers
affects:
  - 176-dispatch-outcome-instrumentation
  - 177-re-trial-gating-decision
tech-stack:
  added: []
  patterns:
    - advisory install-time heuristics stay separate from runtime tool availability
    - CODI success-log R counts resolved-with-call-sites only
key-files:
  created:
    - .paul/phases/175-install-time-detection-value-envelope-docs-format-fix/175-01-SUMMARY.md
  modified:
    - drivers/pi/install.sh
    - modules/codi/module.yaml
    - modules/codi/references/codi.md
    - README.md
    - CHANGELOG.md
    - tests/pi-end-to-end-validation.sh
    - tests/cross-harness-validation.sh
key-decisions:
  - "Decision: Use .codegraph/graph.db only as a bounded install-time CODI heuristic"
  - "Decision: Document CODI as a TS/JS-touching indexed-code helper, not a broad planner win"
patterns-established:
  - "Pattern: installer recommendations remain non-blocking and never auto-disable modules"
  - "Pattern: validation-suite edits stay grep/assertion-only unless a dedicated cleanup phase is approved"
duration: 40min
started: 2026-04-17T15:41:13Z
completed: 2026-04-17T16:21:18Z
---

# Phase 175 Plan 01: Install-Time Detection + Value-Envelope Docs + Format Fix Summary

**Pi installs now warn once when CODI lacks a local codegraph index, and CODI docs plus validation surfaces consistently describe the bounded indexed-code value envelope and resolved-count convention.**

## Objective

Close the three Phase 173 loose ends selected for v2.40 follow-up: add an honest install-time recommendation, align CODI documentation around the real indexed-code value envelope, and make the success-log `R` convention explicit before the re-trial phase.

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~40 min |
| Started | 2026-04-17T15:41:13Z |
| Completed | 2026-04-17T16:21:18Z |
| Tasks | 3 completed |
| Files modified | 7 |

## What Was Built

| File | Purpose | Lines |
|------|---------|-------|
| `drivers/pi/install.sh` | Added a single non-blocking CODI recommendation when `.codegraph/graph.db` is absent | 409 |
| `modules/codi/module.yaml` | Clarified that success-log `R` means resolved-with-call-sites only | 104 |
| `modules/codi/references/codi.md` | Added a `When CODI helps` section and install-time recommendation note | 146 |
| `README.md` | Aligned repo-level CODI setup/value-envelope wording with installer behavior | 297 |
| `CHANGELOG.md` | Added a bounded `## [Unreleased]` / `### Changed` entry for Phase 175 | 324 |
| `tests/pi-end-to-end-validation.sh` | Added minimal semantic assertions for the installer hint and CODI wording | 1116 |
| `tests/cross-harness-validation.sh` | Added cross-harness semantic assertions for the same CODI markers | 723 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: The Pi installer gives a bounded codegraph recommendation when CODI is enabled but no local index marker is detected | Pass | Temp-root smoke test proved the absent-index path emits exactly one recommendation without gating install completion |
| AC-2: CODI's manifest, reference doc, README, and changelog describe the value envelope and success-log convention honestly and consistently | Pass | Manifest, reference doc, README, and changelog now all encode the indexed-code framing and `R = resolved-with-call-sites only` |
| AC-3: Repo and installed surfaces reflect the Phase 175 installer/docs changes with bounded verification | Pass | Two installer reruns plus both validation suites confirmed repo and installed Pi surfaces stay aligned |

## Verification Results

| Command | Result |
|--------|--------|
| `grep -n 'CODI is enabled but no codegraph index detected\|\.codegraph' drivers/pi/install.sh` | Pass |
| `grep -n 'When CODI helps\|boundary specificity\|TS/JS-touching indexed code\|resolved-with-call-sites only\|no codegraph index detected' modules/codi/module.yaml modules/codi/references/codi.md README.md && grep -n '^## \[Unreleased\]\|^### Changed\|no codegraph index detected\|resolved-with-call-sites' CHANGELOG.md` | Pass |
| `tmpdir="$(mktemp -d)" && mkdir -p "$tmpdir/repo" "$tmpdir/home" && tar --exclude='.git' --exclude='.codegraph' -cf - . | (cd "$tmpdir/repo" && tar -xf -) && HOME="$tmpdir/home" PALS_ROOT="$tmpdir/repo" bash "$tmpdir/repo/drivers/pi/install.sh" | tee "$tmpdir/install.log" && grep -F 'CODI is enabled but no codegraph index detected' "$tmpdir/install.log"` | Pass |
| `PALS_ROOT="$(pwd)" bash drivers/pi/install.sh` | Pass |
| `PALS_ROOT="$(pwd)" bash drivers/pi/install.sh` | Pass |
| `bash tests/pi-end-to-end-validation.sh` | Pass — 167/167 checks |
| `bash tests/cross-harness-validation.sh` | Pass — 70/70 checks |

## Module Execution Reports

### APPLY carry-forward

- **TODD:** No standard `.test` / `.spec` infrastructure exists in this repo, so Phase 175 remained `type: execute` and verification stayed command-driven.
- **WALT:** The phase passed its explicit quality surface: absent-index smoke test, two Pi installer reruns, Pi end-to-end validation, and cross-harness validation.
- **DOCS:** README and CHANGELOG were updated in the same phase, so doc drift stayed resolved.
- **DEAN:** No supported root dependency-audit manifest was present, so no baseline or delta audit applied to this phase.

### Pre-UNIFY dispatch

- `[dispatch] pre-unify: 0 modules registered for this hook`

### WALT (post-unify)

| Metric | Before | After | Delta | Trajectory |
|--------|--------|-------|-------|------------|
| Tests passing | 166 pass + 70 pass | 167 pass + 70 pass | +1 pass | ↑ improving |
| Coverage | — | — | — | — |
| Lint issues | — | — | — | — |
| Type errors | — | — | — | — |

**Overall:** ↑ improving

Side effect: appended `175-01 | 2026-04-17 | 167 pass + 70 pass | — | — | — | ↑ improving` to `.paul/QUALITY-HISTORY.md`.

### SKIP (post-unify)

## [2026-04-17] Keep CODI install-time detection as a bounded `.codegraph/graph.db` heuristic

**Type:** decision
**Phase:** 175 — Install-Time Detection + Value-Envelope Docs + Format Fix
**Related:** `drivers/pi/install.sh`, `modules/codi/references/codi.md`, `README.md`, PR #85

**Context:** Phase 175 needed an install-time signal that could help users understand why CODI may stay quiet without claiming that repo state can prove live codegraph tool availability in the runtime agent.

**Decision:** Emit one recommendation when CODI is enabled and `.codegraph/graph.db` is absent, but keep install success, module enablement, and runtime dispatch behavior unchanged.

**Alternatives considered:**
- Hard gate on missing `.codegraph/` — rejected because repo state does not prove runtime tool availability and would over-constrain a safe-skip advisory module.
- Auto-disable CODI in config during install — rejected because the installer should not mutate lifecycle truth or hide a default-on advisory capability.

**Rationale:** The chosen approach is honest, testable, and preserves Phase 170/171's bounded advisory posture.

**Impact:** Future CODI work should continue treating install-time repo markers and runtime tool namespace availability as separate concerns unless stronger evidence justifies a tighter contract.

### RUBY (post-unify)

- ESLint complexity analysis was not a meaningful fit for this shell/markdown/yaml-heavy change set, so debt review fell back to file-size screening.
- Existing large validation surfaces remain: `tests/pi-end-to-end-validation.sh` (1116 lines) and `tests/cross-harness-validation.sh` (723 lines).
- Supporting caution surfaces also remain large: `drivers/pi/install.sh` (409 lines) and `CHANGELOG.md` (324 lines).
- Recommendation: keep future edits to those validation scripts assertion-only unless a dedicated cleanup phase is explicitly planned.

## Skill Audit

All required skills and overlays were invoked for this loop: `/paul` lifecycle control, `/carl` session-boundary handling, TODD verification discipline, and WALT quality validation/reporting.

## Accomplishments

- Added the bounded CODI install-time no-index recommendation without creating a hard `.codegraph/` gate.
- Made CODI's value envelope and `R` convention explicit across manifest, module docs, README, and changelog.
- Extended installed-surface and cross-harness validation so the new installer/doc markers stay durable.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Add a non-blocking install-time codegraph-index recommendation to the Pi installer | `c451db4` | feat | Added the `.codegraph/graph.db` heuristic and recommendation line |
| Task 2: Align the CODI manifest, reference doc, README, and changelog around honest value-envelope wording and the resolved-count convention | `c451db4` | docs | Updated CODI-facing contract text across manifest and docs |
| Task 3: Reinstall the live surfaces and add only minimal semantic validation coverage for the new installer/docs markers | `c451db4` | test | Added bounded semantic assertions and verified repo plus installed surfaces |

Note: APPLY used the GitHub Flow postflight path, so all task work shipped together in a single feature-branch commit rather than per-task commits.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `drivers/pi/install.sh` | Modified | Added the bounded CODI no-index recommendation path |
| `modules/codi/module.yaml` | Modified | Clarified the `R` success-log convention |
| `modules/codi/references/codi.md` | Modified | Documented when CODI helps and preserved safe-skip framing |
| `README.md` | Modified | Aligned user-facing CODI setup/value-envelope wording |
| `CHANGELOG.md` | Modified | Recorded the Phase 175 contract updates under `Unreleased` |
| `tests/pi-end-to-end-validation.sh` | Modified | Verified installer/source/reference/README markers on installed Pi surfaces |
| `tests/cross-harness-validation.sh` | Modified | Verified the same markers across Claude Code and Pi installed surfaces |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Use `.codegraph/graph.db` only as an install-time heuristic | It is bounded and testable, but does not over-claim runtime tool availability | Preserves CODI's advisory posture while still helping users diagnose quiet behavior |
| Define success-log `R` as resolved-with-call-sites only | Removes ambiguity before Phase 177 re-trial and keeps resolved-but-empty behavior explicit | Future CODI trial analysis can compare outcomes consistently |
| Keep validation-suite edits grep/assertion-only | Large legacy scripts were already in debt territory; Phase 175 was not a cleanup pass | Prevents scope creep while still adding durable proof for the new markers |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 1 | Essential verification-driven README fix, no scope creep |
| Scope additions | 0 | None |
| Deferred | 0 | None |

**Total impact:** One bounded follow-up fix was needed after validation surfaced a missing README marker; otherwise the plan executed as intended.

### Auto-fixed Issues

**1. Validation contract drift in `README.md`**
- **Found during:** Task 3 (semantic validation coverage + reinstall)
- **Issue:** `bash tests/pi-end-to-end-validation.sh` initially failed one README assertion because the fresh-config top-level sections sentence was no longer present.
- **Fix:** Restored the explicit top-level sections sentence directly above the CODI setup subsection.
- **Files:** `README.md`
- **Verification:** Re-ran `bash tests/pi-end-to-end-validation.sh` and `bash tests/cross-harness-validation.sh` successfully.
- **Commit:** `c451db4` (same APPLY commit)

### Deferred Items

None - plan executed exactly as written.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Pi end-to-end validation reported one missing README marker after the first verification pass | Restored the missing sentence and re-ran both validation suites to green |

## Key Patterns/Decisions

- Installer messaging can help users diagnose missing local codegraph setup without mutating config or creating a false runtime guarantee.
- CODI's strongest current value remains indexed TS/JS structural call-sites; markdown/config/workflow-only phases should still be expected to produce quiet or skip outcomes.
- Semantic validation markers are the right fit for this documentation-heavy surface; brittle prose or line-count assertions are unnecessary.

## Next Phase Readiness

**Ready:**
- Phase 176 can add dispatch-outcome instrumentation on top of a now-stable installer/docs contract.
- Repo and installed Pi surfaces agree on the new CODI markers after explicit reinstall.

**Concerns:**
- Large validation scripts remain debt-heavy and should continue receiving only surgical assertion changes until a dedicated cleanup phase exists.
- Install-time detection is intentionally heuristic-only; future work should not mistake it for runtime tool availability proof.

**Blockers:**
- None technically. Operationally, Phase 176 should begin from the merged result of PR #85.

---
*Phase: 175-install-time-detection-value-envelope-docs-format-fix, Plan: 01*
*Completed: 2026-04-17*
