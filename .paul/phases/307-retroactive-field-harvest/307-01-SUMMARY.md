---
phase: 307-retroactive-field-harvest
plan: 01
subsystem: tooling
tags: [module-efficacy, field-harvest, normalization, tdd, validation, v2.73]

requires:
  - phase: 306-ledger-contract-unify-integration-config-surfacing
    provides: five-column row schema, six-value status enum, Actioned Trace Rule
provides:
  - docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md dialect/normalization authority
  - tools/harvest-module-ledger.sh deterministic read-only harvester
  - tests/fixtures/field-harvest/ hand-written golden corpus
  - tests/helpers/field_harvest.sh behavioral guardrails for both suites
  - .paul/field-harvest/pals-MODULE-LEDGER.md and UNPARSEABLE.md self-harvest artifacts
affects:
  - Plan 307-02 external-deployment harvest (quark, hybrid-energy-reasoner) + roll-up
  - Phase 308 proposal-batch evidence

tech-stack:
  added: []
  patterns:
    - "Hand-written goldens as specification: never regenerated from program output"
    - "Total status mapping with explicit no-silent-coercion: unmapped tokens manifest instead of coercing"
    - "Three-tier write boundary: source evidence read-only, output confined, external roots unwritable"

key-files:
  created:
    - docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md
    - tools/harvest-module-ledger.sh
    - tools/lib/parse-summary.awk
    - tests/helpers/field_harvest.sh
    - tests/fixtures/field-harvest/
    - .paul/field-harvest/pals-MODULE-LEDGER.md
    - .paul/field-harvest/UNPARSEABLE.md
  modified:
    - tests/pi-end-to-end-validation.sh
    - tests/cross-harness-validation.sh

key-decisions:
  - "Retroactive harvest never emits Actioned? = yes; harvested actioned counts are a floor, not a measurement."
  - "Unmapped status tokens are never coerced; they surface as manifest evidence rather than fabricated ledger rows."
  - "Dispatch tables must carry a real outcome column; no positional fallback, so grade/upgrade tables contribute no rows."

patterns-established:
  - "Namespace the Phase cell as {deployment}/{NN}-{PP} to preserve the five-column schema across deployments."
  - "Cross-check a retroactive parser against forward-path output on a shared phase before trusting it at scale."

completed: 2026-08-07
---

# Phase 307 Plan 01: Retroactive Field Harvest — Normalization Layer Summary

**Shipped the deterministic normalization layer for retroactive module-efficacy harvest: a source-backed dialect contract, a fixture-tested read-only harvester, and a proving-ground self-harvest of this repository into namespaced ledger + manifest artifacts — validated by an exact reproduction of the forward UNIFY ledger for phase 306-01.**

## Performance

| Metric | Value |
|---|---|
| Tasks | 3 completed |
| Source files changed | 25 (23 created, 2 modified), excluding lifecycle artifacts |
| Task commits | 3 (plus plan, APPLY-complete, and handoff commits) |
| Pull request | #227 |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|---|---|---|
| AC-1: Normalization contract authoritative and complete | Pass | All nine required sections present (`§1`–`§9`); dialects A–F plus exclusion class X each carry a cited real-world example; total status mapping; six `unparseable-phase` reason codes; `{deployment}/{NN}-{PP}` namespacing; retroactive `Actioned?` prohibition; subordination to the Phase 306 ledger contract stated in `§1`. |
| AC-2: Harvester deterministic, read-only, golden-exact | Pass | `bash -n` clean on both shell files; two independent runs over `tests/fixtures/field-harvest` produced byte-identical output (`diff -r` empty); 41-row and 5-row hand-written goldens matched exactly; all emitted statuses within the six-value enum; zero `Actioned? = yes` without an in-source token; `git status tests/fixtures` empty after runs. |
| AC-3: Namespaced self-harvest without touching lifecycle truth | Pass | 207 rows, every Phase cell `pals/`-namespaced; 270 manifest entries with reason codes; the six nested summaries under `129-adversarial-testing-setup` recorded as `excluded-foreign-evidence` with zero foreign rows in the ledger; `git diff origin/main...HEAD -- .paul/MODULE-LEDGER.md` empty. |
| AC-4: Guardrails pass with no baseline regression | Pass | Session baseline Pi 349/349 and cross-harness 254/254, both 0 failures; post-change Pi 355/355 and cross-harness 257/257, still 0 failures; `artifact_consistency_check: PASS`; `git diff --check` clean; Pi suite grew 30 lines against the 40-line budget. |

## Accomplishments

- Established `docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md` as the retroactive-parsing authority, explicitly subordinate to the Phase 306 ledger contract, covering namespacing, dialect grammar with precedence, a total status mapping, `Finding?`/`Actioned?` derivation, reason codes, artifact posture, and non-goals.
- Implemented `tools/harvest-module-ledger.sh` (216 lines) with `tools/lib/parse-summary.awk` (329 lines) as a read-only, no-`eval`, deterministic POSIX harvester with a three-tier write boundary.
- Built an 11-unit fixture corpus (12 SUMMARY files, including the nested foreign tree) plus hand-written `expected-rows.tsv` / `expected-unparseable.tsv` goldens written from the contract, not from program output; mutation-tested to prove the checks are non-vacuous.
- Added `tests/helpers/field_harvest.sh` (182 lines) as a sourceable, caller-owns-TAP guardrail helper following `module_instruction_semantics.sh` conventions.
- Self-harvested this repository into `.paul/field-harvest/` — 207 ledger rows and 270 manifest entries — and independently verified the design by reproducing all 19 forward-path `306-01` rows byte-exactly.
- Wired bounded validation sections into both suites (+30 Pi, +31 cross-harness) with all check logic in the helper, honoring the standing ARCH/RUBY god-file constraint.

## Task and Verification Results

| Task | Status | Commit | Verification |
|---|---|---|---|
| Task 1: Author the field-harvest normalization contract | Pass | `814fb090` | Nine numbered sections confirmed; reason codes, namespacing pattern, and the retroactive `Actioned?` prohibition grep-confirmed; each dialect carries a cited source path. |
| Task 2: Fixtures and goldens first (RED), then the harvester (GREEN) | Pass | `25e662df` | `bash -n` clean; goldens matched byte-exactly; determinism confirmed across two runs into separate temp dirs; fixture tree unmodified; mutation test proved the checks fail when they should. |
| Task 3: Self-harvest and wire bounded guardrails | Pass with concerns | `61c88252` | Both suites pass with zero failures and no regression; `.paul/MODULE-LEDGER.md` byte-identical; Pi growth 30 ≤ 40 lines. Concern: the Task 1 contract required two amendments to close gaps the real corpus exposed. |

## Files Created/Modified

| File | Change | Purpose |
|---|---|---|
| `docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md` | Created | Dialect grammar, total status mapping, reason codes, namespacing, retroactive `Actioned?` rule. |
| `tools/harvest-module-ledger.sh` | Created | Read-only CLI harvester with the three-tier write boundary. |
| `tools/lib/parse-summary.awk` | Created | Dialect parser implementing the contract (**unplanned split** — see Deviations). |
| `tests/fixtures/field-harvest/**` (12 SUMMARYs) | Created | One unit per dialect A–F plus no-evidence, legacy-filename, unmapped-status, foreign-evidence, and non-dispatch-table edge cases. |
| `tests/fixtures/field-harvest/expected-rows.tsv` | Created | 41-row hand-written golden; the specification. |
| `tests/fixtures/field-harvest/expected-unparseable.tsv` | Created | 5-row hand-written manifest golden. |
| `tests/helpers/field_harvest.sh` | Created | Sourceable behavioral guardrails: golden diff, determinism, read-only, enum conformance. |
| `.paul/field-harvest/pals-MODULE-LEDGER.md` | Created | 207 namespaced harvested rows (9,036 B). |
| `.paul/field-harvest/UNPARSEABLE.md` | Created | 270 manifest entries with reason codes (45,337 B). |
| `tests/pi-end-to-end-validation.sh` | Modified | +30 lines: "FIELD HARVEST NORMALIZATION" section delegating to the helper. |
| `tests/cross-harness-validation.sh` | Modified | +31 lines: harness-neutral contract/artifact/enum checks and the no-namespaced-rows invariant on `.paul/MODULE-LEDGER.md`. |

## Self-Harvest Results

| Measure | Value | Interpretation |
|---|---:|---|
| Ledger rows | 207 | NOTE 75, SKIP 79, PASS 48, PASS_WITH_CONCERNS 4, WARN 1; all within the enum. |
| Manifest entries | 270 | Honest record of what could not be normalized. |
| `no-dispatch-evidence` | 151 | Verified genuine — roughly half of this repo's SUMMARYs predate dispatch recording. |
| `unmapped-status` | 111 | Long tail of unique free prose, deliberately un-coerced; Phase 308 input. |
| `excluded-foreign-evidence` | 6 | Nested adversarial-test evidence under `129-adversarial-testing-setup`. |
| `unknown-module` | 2 | `MEM` and `config-version`, correctly rejected. |
| Forward-path cross-check | 19/19 exact | Harvested `pals/306-01` reproduces the rows UNIFY independently wrote in Phase 306, byte-for-byte. |

## Decisions Made

| Decision | Rationale | Impact |
|---|---|---|
| Split the parser into `tools/lib/parse-summary.awk` | A 329-line awk program embedded in shell would be unreviewable and untestable in isolation. | Two files instead of one; parser is independently inspectable. Not listed in PLAN `files_modified`. |
| No positional fallback for the status column | Module grade/upgrade tables share a `| Module | ... |` shape and would otherwise yield fabricated rows. | Dispatch tables must carry a real outcome column; ambiguous tables contribute nothing. |
| Leave 111 `unmapped-status` entries un-coerced | Coercion would silently overstate module efficacy and defeat the ledger's purpose. | Manifest growth is the intended signal, not a defect; Phase 308 decides on curated mappings. |
| Redesign the write boundary around source evidence | Task 2's whole-repo guard blocked legitimate self-harvest into `.paul/field-harvest/`. | Guard now protects `.paul/phases` and external roots while allowing the confined output dir; negative-tested in both directions. |
| Retroactive harvest never emits `Actioned? = yes` | D4 and the Phase 306 Actioned Trace Rule: only a traceable later fix proves action. | Harvested actioned counts are a floor; promotion is a Phase 308 human-confirmed activity. |

## Deviations from Plan

| Type | Count | Impact |
|---|---:|---|
| Contract scope expansion | 2 | The Task 1 contract was amended twice **after its own commit**, during Task 3, driven by self-harvest evidence: (a) dialect F for count-based outcomes plus count-outcome mapping; (b) em-dash outcome-suffix stripping, space-separated hook-suffix module normalization, and dispatch-table qualification. AC-1 planned dialects A–E; actual coverage is A–F. Task 3 explicitly authorized treating a dominant unexpected reason code as a contract gap, so this was in-mandate — but the roadmap's dialect estimate was wrong twice, which is itself a finding. Measured effect: `unknown-module` fell from 14 to 2. |
| Unplanned file | 1 | `tools/lib/parse-summary.awk` is not in PLAN `files_modified`; it is a decomposition of the planned `tools/harvest-module-ledger.sh`, not new scope. Recorded as a `reconciliation_mismatch` with no product-scope change. |
| Fixture count expansion | 2 | PLAN enumerated 9 fixture units; 11 were built, adding `10-dialect-f` and `11-non-dispatch-table` to cover the two contract amendments. Goldens grew accordingly and remained hand-written. |
| Implementation rework | 1 | Task 2's write-boundary guard was found wrong in Task 3 and replaced with the three-tier design. Caught by the plan's own self-harvest step rather than by review. |
| Plan-assumption correction | 1 | AC-4 assumed a baseline of "349 Pi checks with 2 known failures." The measured session baseline was 349/349 with **0** failures — the Phase 306 lifecycle failures were already repaired at transition. The no-regression claim is therefore against a stricter baseline than planned. |
| Boundary violations | 0 | None. `.paul/MODULE-LEDGER.md` byte-identical; Phase 306 contract untouched; no `kernel/` change; no external deployment read or written; no `pals.json` mutation; no new byte ceilings. |
| Checkpoints | 0 | Autonomous plan; none required. |

## Skill Audit

| Skill | Required | Observed | Note |
|---|---|---|---|
| /paul | Yes | Yes | Parent-owned PLAN/APPLY/UNIFY throughout; no helper delegation. |
| TODD | Yes | Yes | `type: tdd` honored — goldens hand-written before harvester logic across three RED→GREEN cycles; mutation-tested. |
| WALT | Yes | Yes | Baseline captured before guardrails; both suites re-run after. |
| /carl | Yes | N/A | Pi-extension session-boundary manager; no session boundary was crossed inside APPLY. |

No gaps.

## Quality

| Metric | Before | After | Delta | Trajectory |
|---|---:|---:|---:|---|
| Pi checks passing | 349 | 355 | +6 | ▲ improved |
| Pi checks failing | 0 | 0 | 0 | ● stable |
| Cross-harness passing | 254 | 257 | +3 | ▲ improved |
| Cross-harness failing | 0 | 0 | 0 | ● stable |
| `artifact_consistency.sh` | PASS | PASS | — | ● stable |
| Coverage / lint / types | — | — | — | — not tracked |

**Overall:** ▲ improved. Zero failures on both sides, before and after — the cleanest validation baseline in the milestone so far.

## Module Execution Reports

[dispatch] pre-unify: 0 modules registered for this hook
[dispatch] post-unify: WALT(100), SKIP(200), CODI(220), RUBY(300) completed in installed-registry priority order; reports and side effects recorded below.

### ARCH

`Status: WARN | Finding?: yes | Actioned?: no` — Post-apply confirmed the new top-level `tools/` layer is intentional per D2. The standing validation-suite god-file finding persists: `tests/pi-end-to-end-validation.sh` is now 2,922 lines. This plan constrained its own contribution to +30 lines by pushing logic into `tests/helpers/field_harvest.sh`, but the underlying size finding from Phase 306 is not resolved and was not converted into a fix, PLAN task, or new debt entry here.

### ARIA

`Status: SKIP | Finding?: no | Actioned?: n/a` — No changed UI files.

### CODI

`Status: SKIP | Finding?: no | Actioned?: n/a` — No TS/JS symbols in scope (shell, awk, Markdown only); post-unify classified `skipped-no-symbols` and appended the `307-01` row to `.paul/CODI-HISTORY.md`.

### DANA

`Status: SKIP | Finding?: no | Actioned?: n/a` — No data model, schema, or migration files changed.

### DAVE

`Status: SKIP | Finding?: no | Actioned?: n/a` — No CI/CD configuration changed.

### DEAN

`Status: PASS | Finding?: no | Actioned?: n/a` — No dependency manifest in scope; no package added; no critical/high findings.

### DOCS

`Status: NOTE | Finding?: no | Actioned?: n/a` — The new `tools/` surface is not yet referenced from `README.md` or `docs/ARCHITECTURE.md` (grep-confirmed absent). Advisory only; discoverability is a candidate for Plan 307-02 or Phase 308, not a Plan 307-01 defect.

### GABE

`Status: SKIP | Finding?: no | Actioned?: n/a` — No route, controller, schema, or API surface changed.

### IRIS

`Status: PASS | Finding?: no | Actioned?: n/a` — No TODO/FIXME/HACK/XXX introduced; awk/grep parsing over unvalidated Markdown reviewed with every expansion quoted.

### LUKE

`Status: SKIP | Finding?: no | Actioned?: n/a` — No changed UI components.

### OMAR

`Status: SKIP | Finding?: no | Actioned?: n/a` — No runtime logging, health, readiness, or error-handler behavior changed.

### PETE

`Status: SKIP | Finding?: no | Actioned?: n/a` — No query, render, heavy-import, or performance-sensitive runtime path changed.

### REED

`Status: SKIP | Finding?: no | Actioned?: n/a` — No timeout, retry, error-boundary, shutdown, or degradation behavior changed.

### RUBY

`Status: NOTE | Finding?: no | Actioned?: n/a` — Measured changed files: `tools/lib/parse-summary.awk` 329 lines, `tools/harvest-module-ledger.sh` 216, `tests/helpers/field_harvest.sh` 182 — all within reasonable bounds and already decomposed along a parse/orchestrate boundary consistent with Extract Pure Core. No new debt introduced. The pre-existing validation-suite decomposition debt is unchanged and remains the standing candidate.

### SETH

`Status: PASS | Finding?: no | Actioned?: n/a` — Harvester consumes external repository roots by design. No `eval`; expansions quoted; `--root` treated strictly read-only; the redesigned three-tier write boundary was negative-tested in both directions (refuses writes outside the confined output dir, permits confined self-harvest). No secret-like literal, auth change, or dangerous execution path.

### SKIP

`Status: NOTE | Finding?: no | Actioned?: n/a` — Captured one source-backed knowledge entry for workflow-owned reporting:

- **Source:** `.paul/phases/307-retroactive-field-harvest/307-01-SUMMARY.md#Self-Harvest-Results`
- **Date:** 2026-08-07
- **Title:** Cross-check a retroactive parser against forward-path output before trusting it at scale
- **Type:** pattern
- **Phase/Plan:** 307 / 307-01
- **Context:** A retroactive normalizer over 319 heterogeneous historical SUMMARYs has no independent oracle; hand-written fixture goldens prove the parser matches the contract but not that the contract matches reality.
- **Content:** Phase 306 had already produced 19 forward-path ledger rows written independently by the UNIFY workflow. Harvesting that same phase and diffing against the forward rows yielded an exact 19/19 match, validating contract and parser together against evidence neither produced.
- **Impact:** Gives Plan 307-02 justified confidence to run the harvester over quark and hybrid-energy-reasoner; establishes overlap-diff as the acceptance technique for any future retroactive extraction.

### TODD

`Status: PASS | Finding?: no | Actioned?: n/a` — `type: tdd` honored across three RED→GREEN cycles. Goldens were hand-written from the contract and never regenerated from program output; a mutation test confirmed the guardrails fail when the harvester is broken.

### VERA

`Status: SKIP | Finding?: no | Actioned?: n/a` — No PII collection, storage, consent, deletion, encryption, or logging path changed.

### WALT

`Status: PASS | Finding?: no | Actioned?: n/a` — Reused APPLY-captured evidence and re-confirmed at UNIFY: Pi 349→355, cross-harness 254→257, zero failures on both sides before and after; `artifact_consistency_check: PASS`; `git diff --check` clean. Appended the `307-01` row to `.paul/QUALITY-HISTORY.md`.

## Issues Encountered

| Issue | Resolution |
|---|---|
| Reconnaissance underestimated dialect count twice | Amended the contract in place with cited evidence rather than coercing tokens to fit. `unknown-module` fell from 14 to 2; the residual 111 `unmapped-status` entries were left honest. |
| Task 2's write boundary blocked legitimate self-harvest | Redesigned as a three-tier guard in Task 3, protecting source evidence and external roots while permitting the confined output dir; negative-tested both directions. |
| Installed skill copy of the UNIFY workflow predates the Phase 306 `append_module_ledger` step | Used the repository's `kernel/workflows/unify-phase.md` as authoritative for this project's own dogfooding, matching the same mismatch recorded in the Phase 306 SUMMARY. |

## Next Phase Readiness

**Ready:** Plan 307-02 can execute external-deployment harvest over quark (154 SUMMARYs) and hybrid-energy-reasoner (62) using only the contract and the harvester, with no further specification work — the explicit success criterion of this plan.

**Concerns:** Three substantive Phase 308 inputs are now evidence-backed rather than assumed: 151 phases with no dispatch evidence at all, 111 un-coerced status tokens, and an unresolved validation-suite god-file. The DOCS advisory on `tools/` discoverability is open. Plan 307-02 should also expect dialect surprises in foreign corpora, given this plan amended its contract twice on a corpus it authored.

**Blockers:** None.

---
*Phase: 307-retroactive-field-harvest, Plan: 01*
*Completed: 2026-08-07*
