---
phase: 307-retroactive-field-harvest
plan: 02
subsystem: tooling
tags: [module-efficacy, field-harvest, rollup, tdd, validation, v2.73]

requires:
  - phase: 307-retroactive-field-harvest/307-01
    provides: normalization contract, deterministic harvester, self-harvest baseline, overlap-diff technique
provides:
  - quark and hybrid-energy-reasoner field-harvest ledgers
  - audited three-deployment UNPARSEABLE manifest
  - contract §10 cross-deployment roll-up specification
  - deterministic roll-up generator and HARVEST-ROLLUP.md evidence base
affects:
  - Phase 308 proposal batch and milestone closure

tech-stack:
  added: []
  patterns:
    - "Check write-boundary path sets as well as file checksums; boundary validation must precede mkdir."
    - "Distinguish absent dispatch evidence from present-but-unrecognized dispatch evidence."
    - "Generate aggregate evidence only from committed normalized artifacts, never by re-parsing source SUMMARYs."

key-files:
  created:
    - .paul/field-harvest/quark-MODULE-LEDGER.md
    - .paul/field-harvest/hybrid-energy-reasoner-MODULE-LEDGER.md
    - .paul/field-harvest/HARVEST-ROLLUP.md
    - tools/rollup-field-harvest.sh
    - tests/fixtures/rollup/
  modified:
    - docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md
    - tools/harvest-module-ledger.sh
    - tools/lib/parse-summary.awk
    - tests/helpers/field_harvest.sh
    - tests/pi-end-to-end-validation.sh
    - tests/cross-harness-validation.sh
    - README.md

key-decisions:
  - "Evidence absent and evidence present in an unrecognized shape are separate findings."
  - "Read-only guarantees are path-tested; boundary checks run before directory creation."
  - "The roll-up derives only from committed ledgers and manifest output."

patterns-established:
  - "Audit every foreign manifest reason class against the full source set before interpreting coverage."
  - "Write aggregate contracts and hand-authored goldens before implementing generators."
  - "Render absent deployment/module observations as an em dash, not a measured zero."

duration: 23m
started: 2026-08-07T02:49:05Z
completed: 2026-08-07T03:12:25Z
---

# Phase 307 Plan 02: External Field Harvest and Cross-Deployment Roll-Up Summary

**Harvested quark and hybrid-energy-reasoner without mutating either deployment, repaired three source-backed normalization gaps, and shipped a deterministic 375-row/408-unparseable cross-deployment roll-up for Phase 308.**

## Performance

| Metric | Value |
|---|---|
| Tasks | 3 completed |
| Pull request | #228, merged as `190012be` |
| Task commits | 4, including APPLY-complete lifecycle write |
| External source files hashed | quark 54,650; hybrid-energy-reasoner 4,143 |
| Final validation | Pi 362/362; cross-harness 259/259; zero failures |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|---|---|---|
| AC-1: External harvest complete, honest, and non-mutating | Pass | quark produced 73 rows / 121 manifest entries and hybrid-energy-reasoner 76 / 17; every Phase cell is deployment-namespaced and every status is in the six-value enum. Pre/post recursive checksums matched across 54,650 and 4,143 files. Consecutive runs were byte-identical. Real-root negative tests rejected writes and, after the Task 1 defect fix, created no path. No harvested row emitted `Actioned? = yes`. |
| AC-2: Foreign manifest verified, not assumed | Pass | Full-set audit separated genuine absence from unreadable evidence: 60 units were reclassified to `unrecognized-dispatch-shape`; every external unmapped token received a keep/map disposition; unknown/ambiguous module rejections were checked individually. Three contract amendments and fixtures 12–14 were written before parser fixes. |
| AC-3: Roll-up specified first and deterministic | Pass | Contract §10 defines inputs, aggregation, exact tables, coverage reporting, interpretation limits, and regeneration. Hand-written fixture goldens preceded `tools/rollup-field-harvest.sh`; two fixture runs matched byte-exactly. The committed roll-up reconciles to 76 + 226 + 73 = 375 rows and 17 + 270 + 121 = 408 unparseable units. |
| AC-4: Phase closes green without regression | Pass | APPLY-captured baseline Pi 355/355 and cross-harness 257/257 improved to 362/362 and 259/259 with zero failures before and after. `artifact_consistency_check: PASS`; `git diff --check` clean; Pi suite grew 15 lines against the 30-line limit; ROADMAP remained below 12,000 bytes at 11,873 bytes before closure writes. |

## Accomplishments

- Executed read-only harvests over both external deployments and retained a single sorted three-deployment manifest.
- Found and repaired a real write-boundary defect: rejected output paths could create a directory because `mkdir -p` preceded boundary checks. Path resolution is now non-creating, all gates precede `mkdir`, and a path-set regression check proves rejected runs create nothing.
- Audited the complete foreign manifest and amended the contract for `unrecognized-dispatch-shape`, colon-delimited outcome prefixes, and non-empty manifest detail.
- Re-harvested pals under the amended contract from 207 to 226 rows; the 19 added rows are new Plan 307-01 evidence and no prior row changed.
- Added contract §10 and a 240-line POSIX shell + awk roll-up generator with deterministic ordering, malformed-input rejection, confined writes, and hand-authored goldens.
- Closed the carried DOCS advisory with a concise README Tools section covering both scripts, read-only posture, and governing contracts.

## Task and Verification Results

| Task | Status | Commit | Verification |
|---|---|---|---|
| Task 1: Execute external harvest and audit the foreign manifest | Pass with repaired defect | `845faaf2` | Pre/post checksums identical; repeat harvests deterministic; external write-boundary tests reject writes and create nothing; full reason-class audit completed; fixtures 12–14 and three contract amendments precede parser changes. |
| Task 2: Specify §10, then build the roll-up goldens-first | Pass | `2ed58f5c` | Hand-written golden matched twice; malformed input rejected; fixture tree unchanged; real totals reconcile exactly to 375 rows / 408 unparseable. |
| Task 3: Wire guardrails, close DOCS advisory, validate closure | Pass | `e1ed33ae` | Pi 362/362, cross-harness 259/259, zero failures; artifact consistency PASS; Pi +15 lines; README documents both tools; ROADMAP 11,873 bytes. |
| APPLY completion and handoff archive | Pass | `80f889aa` | STATE recorded PLAN ✓ / APPLY ✓ / UNIFY ○ and PR #228 CI-green readiness. |

## Manifest Audit Dispositions

| Deployment | Reason | Count | Disposition |
|---|---|---:|---|
| quark | `no-dispatch-evidence` | 81 | Confirmed genuine absence across the full set; clustered in phases 01–80. |
| pals | `no-dispatch-evidence` | 119 | Carried from the 307-01 full-set audit as genuine absence. |
| hybrid-energy-reasoner | `no-dispatch-evidence` | 1 | Confirmed genuine absence. |
| quark | `unrecognized-dispatch-shape` | 26 | Reclassified from false absence; dispatch section exists in a deliberately unparsed shape. |
| pals | `unrecognized-dispatch-shape` | 32 | Reclassified from false absence after the amended contract was applied. |
| hybrid-energy-reasoner | `unrecognized-dispatch-shape` | 2 | Reclassified from false absence. |
| quark | `unmapped-status` | 12 | Kept unmapped: metric/free prose, not a status token. |
| pals | `unmapped-status` | 111 | Carried unchanged from 307-01; no coercion. |
| hybrid-energy-reasoner | `unmapped-status` | 13 | Kept unmapped: metric/free prose; four true colon-delimited status prefixes were mapped separately. |
| quark | `unknown-module` | 2 | Rejection correct; §7 now preserves the original non-empty cell text for auditability. |
| pals | `unknown-module` | 2 | Carried unchanged from 307-01 (`MEM`, `config-version`). |
| hybrid-energy-reasoner | `ambiguous-module-set` | 1 | Rejection correct; no fabricated module attribution. |
| pals | `excluded-foreign-evidence` | 6 | Carried unchanged from 307-01; nested foreign fixtures remain excluded. |

The table accounts for all 408 manifest rows: quark 121, pals 270, and hybrid-energy-reasoner 17. The 25 external unmapped tokens remain deliberately uncoerced.

## Files Created/Modified

| File | Change | Purpose |
|---|---|---|
| `.paul/field-harvest/{quark,hybrid-energy-reasoner}-MODULE-LEDGER.md` | Created | External normalized harvests with deployment-namespaced Phase cells. |
| `.paul/field-harvest/pals-MODULE-LEDGER.md` | Regenerated | Added 19 post-307-01 rows under the amended contract; prior rows unchanged. |
| `.paul/field-harvest/UNPARSEABLE.md` | Modified | Sorted three-deployment audit manifest with source-backed reason codes and details. |
| `.paul/field-harvest/HARVEST-ROLLUP.md` | Created | Derived four-table evidence base consumed by Phase 308. |
| `docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md` | Modified | Added three audit-driven amendments and §10 roll-up authority. |
| `tools/harvest-module-ledger.sh` | Modified | Fixed boundary-check ordering so rejected output paths create nothing. |
| `tools/lib/parse-summary.awk` | Modified | Added bounded detection/mapping required by the amended contract. |
| `tools/rollup-field-harvest.sh` | Created | Deterministic committed-artifact aggregator with malformed-input and write-boundary guards. |
| `tests/fixtures/field-harvest/**` | Modified/created | Added contract-first fixtures 12–14 and hand-extended goldens. |
| `tests/fixtures/rollup/**` | Created | Miniature committed-harvest tree and hand-written expected roll-up. |
| `tests/helpers/field_harvest.sh` | Modified | Added external boundary and roll-up behavioral guardrails. |
| `tests/pi-end-to-end-validation.sh` | Modified | Added 15 bounded TAP checks through the helper. |
| `tests/cross-harness-validation.sh` | Modified | Added harness-neutral contract, artifact, enum, and interpretation checks. |
| `README.md` | Modified | Added concise discoverability for both out-of-band tools. |

## Decisions Made

| Decision | Rationale | Impact |
|---|---|---|
| Separate evidence absence from unrecognized evidence shape | Sixty units had a Module Execution Reports section but no supported table shape. Treating them as absent would let parser coverage masquerade as low module use. | Phase 308 sees honest coverage limits; future parsers may extend support without rewriting the historical meaning of absence. |
| Test read-only guarantees with path sets, not file hashes alone | The original negative test missed a newly created empty directory because checksums covered files only. | Boundary checks must precede all creation; regression evidence compares complete path sets. |
| Derive roll-ups from committed normalized output only | Re-parsing SUMMARYs would create a second normalization path that could disagree with the ledgers. | `HARVEST-ROLLUP.md` is deterministic, traceable to committed inputs, and regenerable. |
| Preserve unmapped metric prose | Expanding lexical matching to trailing words would make statements such as `BLOCK overridden` indistinguishable from a block. | Twenty-five external tokens remain manifest evidence rather than fabricated statuses. |
| Render absence as `—`, not `0` | Zero asserts that a measurement exists; an absent deployment/module pair has no observation. | Aggregate tables avoid false precision and distinguish absence from observed zero status counts. |

## Deviations from Plan

| Type | Count | Impact |
|---|---:|---|
| Unplanned file | 1 | `tools/harvest-module-ledger.sh` was outside frontmatter `files_modified`, but Task 1's own negative-test verification exposed a defect in it. The essential fix stayed inside the harvester boundary and was regression-locked. |
| Task-order adjustment | 1 | `tests/helpers/field_harvest.sh` was first touched during Task 1, not Task 2, because the real-root write-boundary defect required an immediate path-set regression helper. No scope expansion. |
| Lifecycle budget trim | 1 | ROADMAP was trimmed by 112 bytes during Task 3 so closure writes could remain under the 12,000-byte ceiling. The removed Phase 308 seed detail remains in STATE. |
| Controlled boundary exception | 1 | `.paul/field-harvest/pals-MODULE-LEDGER.md` was regenerated because the authorized contract amendments changed output: 19 new 307-01 rows were added, with no existing row changed. This is the explicit exception allowed by the PLAN boundary. |
| Contract amendments | 3 | Expected adaptive work, not scope creep: every amendment was driven by a full-set audit, written before parser changes, and fixture-locked. |
| Boundary violations | 0 | Neither external deployment was modified; `.paul/MODULE-LEDGER.md` remained untouched during APPLY harvest/roll-up activity; Phase 306 authority, `kernel/`, and `pals.json` were unchanged. |
| Checkpoints | 0 | Autonomous plan; none required. |

**Reconciliation mismatch:** actual changed files exceeded frontmatter through the essential harvester fix, authorized pals regeneration, and normal lifecycle/handoff writes. All are explained above; no unrelated product scope was added.

## Skill Audit

| Skill | Required | Observed | Note |
|---|---|---|---|
| /paul | Yes | Yes | Parent-owned PLAN/APPLY/UNIFY lifecycle and verification throughout. |
| TODD | Yes | Yes | `type: tdd` honored: contract and hand-written goldens preceded both parser amendments and roll-up implementation. |
| WALT | Yes | Yes | Baselines captured and both full suites plus artifact consistency re-run after implementation. |
| /carl | Yes | N/A | CARL is an independent phase-boundary Pi extension, not an APPLY hook; no manual invocation was required inside APPLY. |

No blocking skill gaps.

## Quality

| Metric | Before | After | Delta | Trajectory |
|---|---:|---:|---:|---|
| Pi checks passing | 355 | 362 | +7 | ▲ improved |
| Pi checks failing | 0 | 0 | 0 | ● stable |
| Cross-harness passing | 257 | 259 | +2 | ▲ improved |
| Cross-harness failing | 0 | 0 | 0 | ● stable |
| `artifact_consistency.sh` | PASS | PASS | — | ● stable |
| Coverage / lint / types | — | — | — | — not tracked |

**Overall:** ▲ improved. Both validation surfaces added guardrails while retaining zero failures.

## Module Execution Reports

[dispatch] pre-unify: 0 modules registered for this hook

[dispatch] post-unify: WALT(100), SKIP(200), CODI(220), RUBY(300) completed in installed-registry priority order; reports and side effects recorded below.

### ARCH

`Status: WARN | Finding?: yes | Actioned?: no` — The planned decomposition held: parser, orchestrator, roll-up, and test-helper responsibilities remain separate. The standing god-file concern persists at `tests/pi-end-to-end-validation.sh` 2,937 lines; this plan added only 15 lines and did not own the deferred decomposition.

### ARIA

`Status: SKIP | Finding?: no | Actioned?: n/a` — No changed UI files.

### CODI

`Status: SKIP | Finding?: no | Actioned?: n/a` — PLAN evidence is `skipped-no-symbols`: no TS/JS selectors were in scope. Post-unify appended the `307-02` row to `.paul/CODI-HISTORY.md`.

### DANA

`Status: SKIP | Finding?: no | Actioned?: n/a` — No data model, schema, or migration files changed.

### DAVE

`Status: SKIP | Finding?: no | Actioned?: n/a` — No CI/CD configuration changed.

### DEAN

`Status: PASS | Finding?: no | Actioned?: n/a` — No dependency manifest or lockfile changed and no package was added.

### DOCS

`Status: PASS | Finding?: yes | Actioned?: yes` — The 307-01 discoverability finding was explicitly carried into Plan 307-02 Task 3 and resolved by README's `## Tools` section, which names both scripts, their read-only/derived posture, and governing contracts.

### GABE

`Status: SKIP | Finding?: no | Actioned?: n/a` — No route, controller, schema, or API surface changed.

### IRIS

`Status: PASS | Finding?: yes | Actioned?: yes` — The pre-plan malformed-ledger risk was actioned in Task 2: the roll-up generator exits non-zero on malformed input instead of emitting an empty success artifact, with a regression test in the field-harvest helper.

### LUKE

`Status: SKIP | Finding?: no | Actioned?: n/a` — No changed UI components.

### OMAR

`Status: SKIP | Finding?: no | Actioned?: n/a` — No runtime logging, health, readiness, or application error-handler path changed.

### PETE

`Status: SKIP | Finding?: no | Actioned?: n/a` — No query, rendering, heavy-import, or request-path performance surface changed.

### REED

`Status: SKIP | Finding?: no | Actioned?: n/a` — No timeout, retry, shutdown, degradation, or application resilience path changed.

### RUBY

`Status: NOTE | Finding?: no | Actioned?: n/a` — Changed implementation sizes are measured at harvester 243 lines, parser 356, roll-up 240, and helper 319. Responsibilities remain decomposed across parse/orchestrate/aggregate/test boundaries; no new behavior-preserving extraction is warranted. The pre-existing 2,937-line validation-suite debt remains unchanged in ownership.

### SETH

`Status: PASS | Finding?: yes | Actioned?: yes` — The pre-plan writable-external-root risk was actioned. Real-root negative tests exposed creation-before-validation; boundary gates now run before `mkdir`, path-set checks prove rejected runs create nothing, expansions remain quoted, and no `eval`, auth, secret, or dangerous input sink was introduced.

### SKIP

`Status: NOTE | Finding?: no | Actioned?: n/a` — Two complete source-backed knowledge entries survive reconciliation:

1. **Source:** `.paul/phases/307-retroactive-field-harvest/307-02-SUMMARY.md#Decisions-Made`; **Date:** 2026-08-07; **Type:** lesson; **Phase/Plan:** 307 / 307-02; **Title:** Read-only guarantees need path-set evidence; **Context:** a rejected output path created an empty directory that file checksums could not observe; **Content:** resolve and validate every write boundary before directory creation, then compare complete path sets as well as file hashes; **Impact:** governs future tools that promise non-mutation of user-writable external roots.
2. **Source:** `.paul/phases/307-retroactive-field-harvest/307-02-SUMMARY.md#Manifest-Audit-Dispositions`; **Date:** 2026-08-07; **Type:** decision; **Phase/Plan:** 307 / 307-02; **Title:** Separate absent evidence from unreadable evidence; **Context:** 60 units contained dispatch-report sections in unsupported shapes; **Content:** classify these as `unrecognized-dispatch-shape`, never `no-dispatch-evidence`; **Impact:** Phase 308 and future harvests cannot mistake parser coverage gaps for low module usage.

### TODD

`Status: PASS | Finding?: no | Actioned?: n/a` — TDD/spec-first order was preserved: three contract amendments and fixtures 12–14 preceded parser changes; §10 and a hand-authored roll-up golden preceded the generator; all guardrails passed.

### VERA

`Status: SKIP | Finding?: no | Actioned?: n/a` — No PII collection, storage, consent, deletion, encryption, or logging path changed.

### WALT

`Status: PASS | Finding?: no | Actioned?: n/a` — Reused APPLY-captured evidence without re-running checks in UNIFY: Pi 355→362 and cross-harness 257→259, with zero failures before and after; artifact consistency PASS and `git diff --check` clean. Appended the `307-02` row to `.paul/QUALITY-HISTORY.md`.

## Issues Encountered

| Issue | Resolution |
|---|---|
| Negative write-boundary checks still created an empty directory | Moved all boundary gates before `mkdir`, made path resolution non-creating, and added path-set comparison to catch directories that file hashes miss. |
| Sixty report-bearing units were mislabeled as evidence-free | Added `unrecognized-dispatch-shape` to the contract and manifest, then fixture-locked section-heading detection without widening row parsing. |
| Colon-prefixed status outcomes were rejected | Added the same strict lexical prefix rule already used for dash suffixes; deliberately left free prose unmapped. |
| Unknown-module manifest details could be empty | Amended §7 and preserved original cell text so every rejection remains traceable. |
| Installed UNIFY skill copy predates Phase 306's ledger append | Used this repository's `kernel/workflows/unify-phase.md` append contract for dogfooding, matching Plan 307-01's recorded handling. |

## Next Phase Readiness

**Ready:** Phase 308 has the three committed deployment ledgers, the 408-row reason-coded manifest, and `HARVEST-ROLLUP.md` with 375 normalized rows across four deterministic tables. Every aggregate proposal must still cite source SUMMARYs.

**Concerns:** Corpus-level unparseable share is 52% (hybrid 18%, pals 54%, quark 62%). This is a coverage caveat, not a module-value judgment. The validation-suite god-file remains the standing next-milestone candidate.

**Blockers:** None.

---
*Phase: 307-retroactive-field-harvest, Plan: 02*
*Completed: 2026-08-07*
