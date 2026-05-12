---
phase: 278-module-guardrails-closure
plan: 01
subsystem: testing
tags: [validation, codi, semantic-guardrails, module-instruction-audit, v2.64-closure, cross-harness, helpers]

requires:
  - phase: 273-module-instruction-audit-contract-cohort-map
    provides: contract requiring grouped semantic checks over marker-only validation
  - phase: 276-review-knowledge-and-codegraph-module-rewrite
    provides: tightened CODI module/ref content that produced 7 inherited marker-drift cross-harness failures
  - phase: 277-domain-optional-module-rewrite
    provides: confirmation Phase 277 did not modify CODI and carried the same 7 inherited failures forward

provides:
  - tests/helpers/module_instruction_semantics.sh — reusable grouped-signal helpers (TAP-free) for module-instruction validation
  - semantic replacements for cross-harness checks 12, 21, 126, 127, 128, 131, 132
  - Phase 278 closure note in docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md documenting the semantic-guardrail pattern

affects:
  - tests/pi-end-to-end-validation.sh (follow-up: same marker-drift family at checks 10, 185, 188, 190, 192)
  - future module-instruction audits in v2.65+

tech-stack:
  added: []
  patterns:
    - "Semantic module-instruction guardrail helpers: shell success/failure only, callers own TAP output"
    - "Grouped-signal cross-harness checks reject marker-only compliance by requiring multiple independent behaviour signals"

key-files:
  created:
    - tests/helpers/module_instruction_semantics.sh
  modified:
    - tests/cross-harness-validation.sh
    - docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md
    - .paul/STATE.md

key-decisions:
  - "Decision: keep canonical literal CODI dispatch log strings in references/codi.md (their documented home) and verify them there; require only behaviour signals (not legacy log strings) inside manifest descriptions"
  - "Decision: do NOT widen scope to tests/pi-end-to-end-validation.sh in this plan; record identical-family failures as Phase 278 follow-up so Plan 278-01 stays inside its approved files_modified"
  - "Decision: retire the deprecated `impact returned empty blast radius for all symbols` log string expectation (Phase 276 retired skipped-all-empty as a legacy-only token)"

patterns-established:
  - "Pattern: each module-instruction guardrail requires multiple independent contract signals (e.g. ≥3 of {.ts,.tsx,.js,.jsx} + ≥2 of bounded-extraction signals + impact + per-symbol contract + ≥2 of safe-skip signals + dispatch evidence + dispatch detail)"
  - "Pattern: validation helpers expose mis_* functions that set MIS_LAST_MISSING on failure and never call tap_* directly"

duration: ~20min
started: 2026-05-12T21:21:23Z
completed: 2026-05-12T21:41:23Z
---

# Phase 278 Plan 278-01: Module Guardrails + Closure Summary

**Replaced the 7 inherited Phase 276 CODI marker-drift failures in `tests/cross-harness-validation.sh` (195→202 PASS) with grouped semantic guardrails backed by reusable TAP-free helpers, and recorded the v2.64 closure pattern in the module-instruction audit contract.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~20min |
| Started | 2026-05-12T21:21:23Z |
| Completed | 2026-05-12T21:41:23Z |
| Tasks | 3 completed |
| Files modified | 3 source + 1 lifecycle |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Marker drift replaced by semantic CODI guardrails | PASS | Checks 12, 126, 127, 128, 131, 132 now use grouped behaviour signals; 195→202 cross-harness PASS. |
| AC-2: Durable module-report validation remains strict and source-grounded | PASS | Check 21 verifies WALT (`module_report`+`Module Execution Reports`+`quality`) and RUBY (`post-unify:`+`changed files`+≥2 of {debt, refactor, advisory, NOT_APPLICABLE, refactor-patterns ref}). |
| AC-3: Reusable validation helpers reduce marker-only checks without hiding evidence | PASS | `tests/helpers/module_instruction_semantics.sh` exposes 5 named CODI helpers + 4 generic helpers; helpers set `MIS_LAST_MISSING` on failure and never print TAP. Callers in `cross-harness-validation.sh` own `tap_ok`/`tap_not_ok` and reuse `$MIS_LAST_MISSING` as the diagnostic so failures explain which semantic group is missing. |
| AC-4: Runtime/install surfaces are verified through existing harnesses | PASS_WITH_CONCERNS | Cross-harness invokes Claude Code + Pi installers and verifies installed registry/refs. `tests/pi-end-to-end-validation.sh` 307/312 — diagnosed: 5 failures are baseline-inherited CODI marker-drift (checks 10, 185, 188, 190, 192) confirmed unchanged pre/post via `git stash` comparison; routed as Phase 278 follow-up. |
| AC-5: Scope stays validation/closure only | PASS | Changed files: `tests/cross-harness-validation.sh`, `tests/helpers/module_instruction_semantics.sh`, `docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md`, plus `.paul/STATE.md` lifecycle. No module sources, kernel workflows, dependency manifests, CI, installer behaviour, runtime binaries, or home-directory installed copies changed. |
| AC-6: Closure evidence is explicit and not marker-only | PASS | This SUMMARY records before/after validation (195→202), the semantic replacement map per check (below), the remaining Pi e2e diagnosis, scope review, and milestone readiness. |

## Module Execution Reports

<!-- Finalized during UNIFY from carried APPLY annotations + post-unify dispatch. -->

### TODD (advisory)

- Pre-plan: PLAN is `execute`, not TDD restructure; validation suites are the verification mechanism.
- Post-plan / post-apply: validation suites named in the PLAN were run; failing output preserved with diagnosis where applicable.
- Result: PASS — `tests/cross-harness-validation.sh` 202/202, `tests/helpers/artifact_consistency.sh` PASS, `tests/pi-end-to-end-validation.sh` 307/312 diagnosed as inherited.

### WALT (quality)

| Metric | Before | After | Delta | Trajectory |
|--------|--------|-------|-------|------------|
| `tests/cross-harness-validation.sh` PASS | 195/202 | 202/202 | +7 | ▲ |
| `tests/helpers/artifact_consistency.sh` | PASS | PASS | 0 | ● |
| `git diff --check` | clean | clean | 0 | ● |
| `tests/pi-end-to-end-validation.sh` PASS | 307/312 | 307/312 | 0 | ● (inherited drift) |

**Overall:** ▲ improved — cross-harness now exercises behaviour groups rather than stale marker prose; Pi e2e marker drift unchanged but explicitly routed for follow-up.

### IRIS (advisory)

- Risk: weakening tests into marker-only or presence-only checks.
- Mitigation: each Phase 278 guardrail requires multiple independent contract signals; no check accepts a single magic phrase as sufficient.
- Diagnostics: helpers set `MIS_LAST_MISSING` to name the failing semantic group; callers surface this in `tap_not_ok` so future regressions are explainable from TAP output alone.
- Result: PASS — semantic groups exceed marker-only threshold.

### DEAN (enforcement)

- Pre-plan: PASS — no dependency/lockfile changes in `files_modified`.
- Post-apply: PASS — `git diff --stat` confirms no dependency manifest touched.

### DOCS (advisory)

- Pre-plan: closure note was optional; UNIFY added the Phase 278 closure section to `docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md`.
- Post-apply: NOT_APPLICABLE for code-doc drift (module-instruction audit document only).

### CODI (advisory, pre-plan)

- SKIPPED — no explicit TS/JS selectors in this shell/docs validation plan; no Blast Radius emission.
- Outcome (for post-unify history): `skipped-no-symbols`.

### CODI (post-unify)

- A `278-01` row will be appended to `.paul/CODI-HISTORY.md` as part of the post-unify dispatch evidence below.

### RUBY (advisory)

- Pre-plan / post-unify: NOT_APPLICABLE for code debt; module-instruction-style changes only.

### REV

- Deferred to PR review gate per `pals.json` (`pr_review: false`); no critical-finding block triggered.

### SKIP

- NOT_APPLICABLE; no durable knowledge surfaces touched.

## Accomplishments

- Replaced 7 inherited CODI marker-drift cross-harness failures with grouped semantic guardrails (195→202 PASS).
- Added `tests/helpers/module_instruction_semantics.sh` as a reusable, TAP-free assertion layer for future module-instruction audits.
- Documented the semantic-guardrail pattern as a durable v2.64 closure section inside `docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md`.
- Confirmed by `git stash`-based pre/post comparison that Pi e2e failures are baseline-inherited and not caused by this APPLY, so they can be safely routed as follow-up scope.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Audit CODI validation drift | (inline; no source mutation) | docs | Read-only audit mapping all 7 inherited failures to semantic replacement contracts before any edit. |
| Task 2: Implement helpers + update cross-harness checks | `f1e01cb9` | test | Added semantic helpers and replaced inherited marker-only failing checks with grouped behaviour signals. |
| Task 3: Closure validation + evidence | `4c61c18a` (STATE), UNIFY commits for SUMMARY + closure doc | docs | Ran final validation, recorded baseline diff for Pi e2e, added Phase 278 closure note. |

Plan metadata: `9cffe17b` (docs: complete plan).

## Semantic Replacement Map (Inherited Failure → Phase 278 Guardrail)

| Check | Stale literal expectation | Phase 278 semantic contract |
|-------|---------------------------|-----------------------------|
| 12 | `source selectors`, `top-level function declarations`, `exported const / arrow bindings`, `stable identifiers surfaced`, `resolved-with-call-sites only` in both installed `modules.yaml` | Both installed registry CODI blocks satisfy `mis_codi_source_selector_semantics_ok`: TS/JS breadth ≥3 of {.ts,.tsx,.js,.jsx}; bounded extraction ≥2 of {top-level, exported, explicit, bounded, STEP 1}; `impact` + per-symbol contract; safe-skip ≥2 signals; `[dispatch] CODI` + ≥1 dispatch-detail signal. |
| 21 | Strict marker pair on WALT `module_report` and RUBY `json {changed_files}` | WALT apply-phase quality has `module_report` + `Module Execution Reports` + `quality`; RUBY manifest has `post-unify:` + ≥1 of {`changed readable source files`, `changed files`} + ≥2 of {debt, refactor, advisory, NOT_APPLICABLE, refactor-patterns ref}. |
| 126 | Phase 174-era marketing/setup phrases in both installed `codi.md` | Both installed `codi.md` refs satisfy `mis_codi_ref_semantics_ok`: fit signal ≥2 of {TS/JS, .ts, indexed, boundary, structural}; extraction-rules header + content; `impact` + per-symbol contract; safe-skip/no-codegraph ≥2 signals; post-unify pointer `codi-instrumentation.md`. |
| 127 | Phase 174 source-selector markers across plan workflow, manifest, ref, init workflow, schema ref, README, and `pals.json` | Repo source satisfies a multi-file grouped contract: plan workflow has `codi_seed_candidates` + `explicit TS/JS selectors`; manifest and ref satisfy the semantic helpers; init workflow carries the canonical CODI registry seed line; schema ref carries `\`modules.codi.enabled\``; README has `### CODI setup (optional)` + ≥1 of {TS/JS, indexed, structural}; Pi installer carries `CODI is enabled but no codegraph index detected`; `pals.json` carries `"codi": {`. |
| 128 | `CODI-HISTORY.md`, `codi-instrumentation.md`, `no-dispatch-found`, `finalize_summary` literal in both installed `modules.yaml` | Both installed `modules.yaml` satisfy `mis_codi_post_unify_manifest_ok`: post-unify hook + `CODI-HISTORY.md` + `codi-instrumentation.md` + `no-dispatch-found` + ≥1 read-order signal of {`summary_path`, `Module Execution Reports`, `Blast Radius`} + ≥2 row-schema signals of {`Append`, `Plan`, `Date`, `Outcome`, `blast_radius`}. The workflow-owned `finalize_summary` token is intentionally not required inside module manifest descriptions. |
| 131 | All 5 verbatim pre-plan skip/success log strings in both installed `modules.yaml` | Both installed manifests satisfy `mis_codi_pre_plan_taxonomy_manifest_ok` (≥2 skip-taxonomy signals + ≥1 success/evidence-emission signal); installed `references/codi.md` (canonical home for literal log strings) satisfies `mis_codi_canonical_log_strings_ok` (4 canonical literal log strings). The deprecated `impact returned empty blast radius for all symbols` is intentionally not required (Phase 276 retired `skipped-all-empty` as legacy-only per `modules/codi/references/codi-instrumentation.md`). |
| 132 | `post-unify:` / `CODI-HISTORY.md` / `codi-instrumentation.md` / `no-dispatch-found` / `finalize_summary` in module.yaml + ref schema + pointer + seeded 175-01 row | Repo source satisfies: `mis_codi_post_unify_manifest_ok` on `modules/codi/module.yaml`; `codi-instrumentation.md` has `## Outcome taxonomy` + canonical header schema row + ≥1 read-order signal of {`Data-source read order`, `PLAN.md`, `SUMMARY.md`}; `modules/codi/references/codi.md` cross-references `codi-instrumentation.md`; `.paul/CODI-HISTORY.md` carries the seeded `175-01` row. Workflow-owned `finalize_summary` token intentionally not required in manifest descriptions. |

## Helper Functions Added

| Helper | Returns | Diagnostic on fail |
|--------|---------|--------------------|
| `mis_file_has_all FILE -- PATTERN ...` | 0 if all patterns present | `MIS_LAST_MISSING` lists missing patterns |
| `mis_files_all_have_all FILE1 FILE2 -- PATTERN ...` | 0 if both files satisfy all | first failing file/pattern set |
| `mis_file_has_min_of FILE MIN -- PATTERN ...` | 0 if at least MIN present | hits, min, and missing list |
| `mis_files_all_have_min_of FILE1 FILE2 MIN -- PATTERN ...` | 0 if both meet MIN | first failing file's diagnostic |
| `mis_codi_source_selector_semantics_ok FILE` | 0 if 5 CODI source-selector groups (A–E) pass | names failing group |
| `mis_codi_ref_semantics_ok FILE` | 0 if 5 `codi.md` semantic groups pass | names failing group |
| `mis_codi_post_unify_manifest_ok FILE` | 0 if post-unify manifest signals + read-order + row-schema pass | names failing signal set |
| `mis_codi_pre_plan_taxonomy_manifest_ok FILE` | 0 if ≥2 skip-taxonomy + ≥1 success-emission pass | names failing group |
| `mis_codi_canonical_log_strings_ok FILE` | 0 if 4 canonical literal log strings present | lists missing literal log strings |

All helpers return shell success/failure only; callers in `tests/cross-harness-validation.sh` own `tap_ok` and `tap_not_ok "$label" "$MIS_LAST_MISSING"`. The helper file is `source`d once near the existing `artifact_consistency.sh` import.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `tests/helpers/module_instruction_semantics.sh` | Created | Reusable TAP-free semantic helpers for module-instruction validation. |
| `tests/cross-harness-validation.sh` | Modified | Replaced 7 inherited marker-drift CODI checks with grouped semantic guardrails. |
| `docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md` | Modified | Appended Phase 278 Closure section documenting the semantic-guardrail pattern. |
| `.paul/STATE.md` | Modified | Lifecycle routing — APPLY/UNIFY status, resume context, and PR pointer. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Keep canonical literal CODI dispatch log strings in `references/codi.md` and verify them there; manifest descriptions verify behaviour signals only. | Phase 276 intentionally tightened manifest descriptions; the literal log strings already live in `codi.md` (their documented home). Asserting both verifies the actual contract without forcing manifest descriptions to duplicate log prose. | Cross-harness now checks each surface for its true contract role; reduces brittle duplication. |
| Do not widen Plan 278-01 scope to `tests/pi-end-to-end-validation.sh` despite identical-family failures. | The Pi e2e suite is not in PLAN `files_modified` and pre/post comparison proves the 5 failures are baseline-inherited, not caused by this APPLY. AC-4 explicitly allows diagnosis-with-evidence on remaining failures. | Plan 278-01 stays inside approved scope; a clean follow-up entry is queued without bundling unapproved changes. |
| Retire the `impact returned empty blast radius for all symbols` log-string expectation. | `modules/codi/references/codi-instrumentation.md` records `skipped-all-empty` as a legacy-only token not emitted for new dispatches. Requiring its literal log line in current dispatch surfaces would be exactly the marker drift Phase 278 must remove. | Semantic guardrail now matches the active Phase 276 contract; no legacy reintroduction risk. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 1 | Tightened RUBY check 21 from literal `changed_files` (underscore form not present in `modules/ruby/module.yaml`) to `changed readable source files`/`changed files` group; rediscovered during initial run and corrected in same task. |
| Scope additions | 0 | None. |
| Deferred | 1 | `tests/pi-end-to-end-validation.sh` 5 baseline-inherited CODI marker-drift failures (checks 10, 185, 188, 190, 192) deferred to follow-up plan. |

**Total impact:** Essential fixes, no scope creep. Follow-up scope explicit and bounded.

### Auto-fixed Issues

**1. [Validation guardrail] RUBY post-unify durable-reporting signal**
- **Found during:** Task 2 (helper smoke + cross-harness run).
- **Issue:** Initial check 21 helper call required literal `changed_files`, but `modules/ruby/module.yaml` carries `changed readable source files` / `changed files` (no underscore).
- **Fix:** Replaced exact-match with grouped signal: ≥1 of {`changed readable source files`, `changed files`} + ≥2 of {debt, refactor, advisory, NOT_APPLICABLE, refactor-patterns ref}; both signals reflect the actual RUBY post-unify contract.
- **Files:** `tests/cross-harness-validation.sh`.
- **Verification:** Final `tests/cross-harness-validation.sh` → 202/202 PASS.
- **Commit:** `f1e01cb9` (part of Task 2 commit).

### Deferred Items

- Phase 278 follow-up: apply the same semantic-guardrail pattern to `tests/pi-end-to-end-validation.sh` failing checks 10, 185, 188, 190, 192 (identical inherited CODI marker drift; pre/post `git stash` comparison shows zero delta caused by this APPLY).

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Pi end-to-end validation reports 5 failing checks after APPLY. | Diagnosed as baseline-inherited via `git stash`-based pre/post comparison (identical pass/fail count and identical failing check IDs). Routed for follow-up plan rather than silent in-flight scope expansion; recorded in STATE Session Continuity and in this SUMMARY. |
| Optional contract-doc closure note. | Added a concise Phase 278 closure section in `docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md` (within the PLAN-approved file set); a stray duplicate trailing line introduced by the insert was removed and validation re-run green. |

## Skill Audit

| Required Skill | Observed Activity | Status |
|----------------|-------------------|--------|
| /paul | PLAN/APPLY/UNIFY lifecycle executed end-to-end. | ✓ |
| /carl | Session boundary signal triggered the resume that began this loop. | ✓ |
| TODD | Pre-plan/post-plan and post-apply advisory dispatch logged; validation suites named in PLAN executed. | ✓ |
| WALT | Pre-apply baseline (195/202) and post-apply quality table captured (202/202; ▲). | ✓ |

No skill gaps.

## Next Phase Readiness

**Ready:**

- Phase 278 (of 278) Plan 278-01 satisfies AC-1, AC-2, AC-3, AC-5, AC-6 fully and AC-4 with diagnosed inherited failures.
- Cross-harness validation is now backed by executable semantic guardrails (`tests/helpers/module_instruction_semantics.sh`).
- `docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md` carries the closure note formalizing the v2.64 semantic-guardrail pattern for future module-instruction audits.

**Concerns:**

- `tests/pi-end-to-end-validation.sh` still has 5 inherited CODI marker-drift failures (checks 10, 185, 188, 190, 192). These are stable (zero pre/post delta this APPLY) but should be cleared by a follow-up plan before the next major milestone.

**Blockers:**

- None blocking v2.64 milestone closure routing. PR #196 mergeability + CI gates owned by the post-unify merge gate.

---
*Phase: 278-module-guardrails-closure, Plan: 01*
*Completed: 2026-05-12*
