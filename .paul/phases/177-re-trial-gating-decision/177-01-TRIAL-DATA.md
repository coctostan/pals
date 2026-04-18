---
phase: 177-re-trial-gating-decision
plan: 01
artifact: TRIAL-DATA
created: 2026-04-18
sessions: 2 live (reconstructed + retrospective) + 1 controlled self-trial + 1 counterfactual
---

# CODI v0.1 Re-Trial — v2.40 Evidence Set

This artifact is the read-only evidence corpus for the v2.40 CODI v0.1 re-trial (see `177-01-DECISION.md` for the binding verdict). All quotes are verbatim from the cited source artifacts; no prior source artifact (`.paul/CODI-HISTORY.md`, 175/176/168 PLAN/SUMMARY) has been modified by this phase.

## Trial structure

- **Session A (`175-01`)**: historically reconstructed live evidence — the `.paul/CODI-HISTORY.md` row was seeded during Phase 176 APPLY from Phase 175 PLAN/SUMMARY artifacts; it was not written contemporaneously by the post-unify hook (the hook did not exist during 175's UNIFY).
- **Session B (`176-01`)**: hook-written retrospective live evidence — the first row actually appended by the CODI post-unify hook end-to-end during Phase 176's own UNIFY.
- **Session C (`177-01-self`)**: controlled live self-trial — this Phase 177 PLAN's `<module_dispatch>` block injected a non-empty blast_radius by intentionally carrying `drivers/pi/extensions/pals-hooks.ts` as read-only evidence and naming four TS symbols in the objective so the v2.40 extractor (Phase 174) would resolve them against the live codegraph. The row MUST be labeled `controlled live self-trial` throughout the dataset and not treated as a natural product-scope implementation-phase outcome.
- **Session D (Phase 168 counterfactual)**: TS-touching counterfactual reused from Phase 173 `173-01-TRIAL-DATA.md` (Session E). Phase 168 predates CODI; evidence is interpreted against the v2.40 framing but Phase 168 source artifacts are read-only.

**CODI_NULL marker (v2.40 rules, unchanged from Phase 173 AC-1):** true if blast_radius injection was empty/skip/unresolved-only OR if dispatch was tool-unavailable/skipped; false if at least one resolved-with-call-sites symbol was injected.

## Trial integrity (Milestone Invariant 3)

Before admitting any row, installed `~/.pi/agent/skills/pals/modules.yaml` CODI pre-plan/post-unify priorities and refs were compared against repo `modules/codi/module.yaml`. At this Phase 177 PLAN time both surfaces carry `pre-plan priority: 220` + `post-unify priority: 220` with refs `references/codi.md` and `references/codi-instrumentation.md`, matching the repo source. Trial-integrity parity is therefore **pass** for the current-session rows (Sessions B and C). For historically reconstructed row Session A, parity is asserted on the best-available evidence — the Phase 175 PLAN `<module_dispatch>` block and Phase 176 seed provenance — rather than on a re-run against a vintage installed manifest, and is recorded explicitly below.

## Phase 173 baseline (fixed anchor)

- `S_pass_nonnull = 1` (only Signal 3 via counterfactual projected-pass; Signals 1, 2, 4 not-applicable due to 0 non-CODI_NULL live rows).
- Verdict: `ITERATE_V0_1`.
- Selected iteration theme for v2.40: close the extractor-vs-scope alignment gap surfaced by the counterfactual, then re-trial before considering v0.2.

v2.40 itself shipped three pieces of that iteration:
- Phase 174 — source-file selector extractor promoting repo-relative `.ts/.tsx/.js/.jsx` paths in `<context>` into bounded symbol seeds for `impact`.
- Phase 175 — installer codegraph-index heuristic + honest value-envelope docs + `R = resolved-with-call-sites only` convention.
- Phase 176 — CODI post-unify hook writing `.paul/CODI-HISTORY.md`, reference-doc split, 5-string drift guard.

Phase 177 is the honesty checkpoint for that iteration.

---

## Live Sessions (v2.40)

### Session A: Phase 175-01 (Install-Time Detection + Value-Envelope Docs + Format Fix)

**Evidence class:** `historically reconstructed live evidence` — the 175-01 `.paul/CODI-HISTORY.md` row was seeded in Phase 176 APPLY from Phase 175 PLAN/SUMMARY artifacts. It reflects a real live pre-plan CODI dispatch that actually occurred during 175-01 planning, but was not written contemporaneously by the post-unify hook (the hook did not exist in 175's UNIFY).

**Trial integrity:** pass (best-available) — Phase 175 PLAN `<module_dispatch>` reports the dispatch was produced by the then-installed CODI hook with the Phase 174 source-file selector extractor already live on the installed Pi surface (per 175-01-PLAN Prior Work). No evidence of installed-vs-repo manifest drift at that time.

| Field | Value |
|---|---|
| PLAN.md | `.paul/phases/175-install-time-detection-value-envelope-docs-format-fix/175-01-PLAN.md` |
| SUMMARY.md | `.paul/phases/175-install-time-detection-value-envelope-docs-format-fix/175-01-SUMMARY.md` |
| `.paul/CODI-HISTORY.md` row (verbatim) | `\| 175-01 \| 2026-04-17 \| injected \| 4 \| 0 \| 10 \| renderCompactLoopSummary, renderLifecycleStatus, syncLifecycleUi, renderLoopBadge \| y \|` |
| Dispatch outcome (verbatim, source: 175-01 PLAN `<module_dispatch>`) | `[dispatch] CODI: pre-plan advisory → impact × 4 symbols → 4 resolved, 0 unresolved, 10 total call-sites, injected blast_radius` |
| Manifest 6-outcome category | `injected` (success-log) |
| Extracted symbols | `renderCompactLoopSummary`, `renderLifecycleStatus`, `syncLifecycleUi`, `renderLoopBadge` |
| Per-symbol resolution (R/U/K) | R=4, U=0, K=10 |
| Blast-radius injected | yes — full block present in 175-01-PLAN `<module_dispatch>` Blast Radius sub-section |
| Declared `files_modified` | `drivers/pi/install.sh`, `modules/codi/module.yaml`, `modules/codi/references/codi.md`, `README.md`, `CHANGELOG.md`, `tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh` (7 files) |
| Actual files changed (per SUMMARY What Was Built) | All 7 declared files modified — exact match (7 files). SUMMARY: "Task 1…Task 3 — 3 tasks completed; Files modified 7". |
| Unexpected files | 0 (one auto-fixed README drift during Task 3 was to an already-declared file) |
| Surprise files (declared but not touched) | 0 |
| `<boundaries>` shape (from 175-01 PLAN) | DO NOT CHANGE: 5 bullets (plan-phase.md / schema / init / pals.json; unify-phase/QUALITY-HISTORY/new tally; `pals-hooks.ts` read-only; PLAN.md template + plan-format; validation suites beyond minimal assertions). SCOPE LIMITS: 6 bullets (no `.codegraph/` hard gate; no `symbol_graph`/`trace`; no schema/init rewrites; no CI generation / changelog sweep; no validation-suite broad rewrite; no Phase 176/177 work). |
| APPLY needed ad-hoc codegraph research? | No. SUMMARY records 3/3 tasks PASS; one bounded README marker fix surfaced by validation and fixed inline. |
| Planner used understand/verify brokers? | No sub-broker. Empirical installer smoke test during APPLY, not a broker. |
| Ad-hoc observations | 4 resolved-with-call-sites symbols on `drivers/pi/extensions/pals-hooks.ts`. This was the first live v2.40 planning run where the Phase 174 source-selector extractor actually produced a non-null injection — converting what would have been a Phase 173-era CODI_NULL (prose-heavy phase) into a substantive blast_radius. |
| **CODI_NULL** | **false** (4 resolved-with-call-sites → substantive injection) |
| Interpretation toward the gate | First live evidence that v2.40's extractor change moved at least one non-TS-product phase into CODI_NULL=false. But the phase's implementation scope (installer/docs) did not actually touch any of the 4 resolved symbols — the `<context>` carried the TS file as read-only evidence, exactly the posture Phase 177 formalizes as `controlled live self-trial`. Use for Q2 / value-envelope support, with caveat that carry-posture evidence is weaker than work-posture evidence. |

### Session B: Phase 176-01 (Dispatch-Outcome Instrumentation)

**Evidence class:** `hook-written retrospective live evidence` — the 176-01 `.paul/CODI-HISTORY.md` row is the first row actually appended by the CODI post-unify hook end-to-end; it records Phase 176's own pre-plan dispatch retrospectively as the hook intended.

**Trial integrity:** pass — Phase 176 APPLY reinstalled the Pi surface so the installed `modules.yaml` carried the new post-unify block before Phase 176 UNIFY triggered it; verification captured in 176-01-SUMMARY (`pi-end-to-end 172/172`, `cross-harness 75/75`, `installer exit 0`, 5-string drift guard active).

| Field | Value |
|---|---|
| PLAN.md | `.paul/phases/176-dispatch-outcome-instrumentation/176-01-PLAN.md` |
| SUMMARY.md | `.paul/phases/176-dispatch-outcome-instrumentation/176-01-SUMMARY.md` |
| `.paul/CODI-HISTORY.md` row (verbatim) | `\| 176-01 \| 2026-04-18 \| skipped-no-symbols \| — \| — \| — \| — \| n \|` |
| Dispatch outcome (verbatim, source: 176-01 PLAN `<module_dispatch>`) | `[dispatch] CODI (p220) → skipped — no extractable symbols in phase scope` |
| Manifest 6-outcome category | `skipped-no-symbols` (hook-level skip: "no extractable symbols in phase scope") |
| Extracted symbols | none — phase scope is YAML/markdown/shell (module manifest, new focused ref doc, validation suite assertions); no repo-relative `.ts/.tsx/.js/.jsx` paths in `<context>`, so the Phase 174 source-selector extractor had no bounded source files to read |
| Per-symbol resolution (R/U/K) | — / — / — |
| Blast-radius injected | no |
| Declared `files_modified` | `modules/codi/module.yaml`, `modules/codi/references/codi.md`, `modules/codi/references/codi-instrumentation.md`, `.paul/CODI-HISTORY.md`, `tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh` (6 files) |
| Actual files changed (per SUMMARY What Was Built) | All 6 declared files modified — exact match (6 files). SUMMARY shows per-file line counts for each. |
| Unexpected files | 0 |
| Surprise files | 0 |
| `<boundaries>` shape (from 176-01 PLAN) | DO NOT CHANGE and SCOPE LIMITS together enumerate installer/kernel-workflow/other-modules/pals.json/PLAN-template surfaces as out-of-scope; phase stays inside `modules/codi/*`, the new `.paul/CODI-HISTORY.md`, and bounded validation assertions. |
| APPLY needed ad-hoc codegraph research? | No. SUMMARY records 3/3 tasks PASS; one classifier-safety token-hygiene audit surfaced and fixed during APPLY, not codegraph research. |
| Planner used understand/verify brokers? | No sub-broker. |
| Ad-hoc observations | Phase 176 is the direct test case for Phase 175's honest value-envelope framing: a phase with no TS-touching scope and no TS paths in `<context>` should produce `skipped-no-symbols`, and did. This is correct CODI behavior, not a failure. |
| **CODI_NULL** | **true** (explicit skip — no extractable symbols, no injection) |
| Interpretation toward the gate | Confirms the honest-docs framing from Phase 175: when a phase has no indexed TS/JS in scope, CODI should be quiet. Signals this row contributes toward: Signal 1 denominator-eligible (declared vs actual file accuracy is strong — 6/6 exact match), but because it's CODI_NULL it is still excluded from the `S_pass_nonnull` numerator per the Phase 173 CODI-null-aware rules. |

### Session C: Phase 177-01-self (controlled live self-trial)

**Evidence class:** `controlled live self-trial` — this Phase 177 PLAN's `<module_dispatch>` block intentionally carries `drivers/pi/extensions/pals-hooks.ts` as read-only evidence and names the four TS symbols in the objective so the v2.40 extractor resolves them. This row is deliberately constructed to yield a non-null live row for the v2.40 dataset; it is NOT a natural product-scope implementation phase and MUST NOT be interpreted as one.

**Trial integrity:** pass — current-session installed `modules.yaml` parity with repo `modules/codi/module.yaml` was verified at plan time (both carry pre-plan p220, post-unify p220; both carry refs `references/codi.md` and `references/codi-instrumentation.md`). Evidence captured in this PLAN's `<module_dispatch>` trial-integrity precheck line.

| Field | Value |
|---|---|
| PLAN.md | `.paul/phases/177-re-trial-gating-decision/177-01-PLAN.md` |
| SUMMARY.md | **pending** — Phase 177 UNIFY has not run at dataset creation time. Provisional actual-files evidence is derived below from the current working-tree/git state and will be reconciled by UNIFY. |
| `.paul/CODI-HISTORY.md` row | **not yet written** — the 177-01 row is appended by the CODI post-unify hook during Phase 177 UNIFY. During APPLY `.paul/CODI-HISTORY.md` remains read-only (2 rows: 175-01 + 176-01). |
| Dispatch outcome (verbatim, source: 177-01 PLAN `<module_dispatch>` advisory block) | `[dispatch] CODI: pre-plan advisory → impact × 4 symbols → 4 resolved, 0 unresolved, 10 total call-sites, injected blast_radius` |
| Manifest 6-outcome category | `injected` (success-log) |
| Extracted symbols | `renderCompactLoopSummary`, `renderLifecycleStatus`, `syncLifecycleUi`, `renderLoopBadge` (same canonical ordering as Phase 175's Blast Radius) |
| Per-symbol resolution (R/U/K) | R=4, U=0, K=10 |
| Blast-radius injected | yes — full block present in this PLAN's `<module_dispatch>` Blast Radius sub-section |
| Declared `files_modified` (this plan) | `.paul/phases/177-re-trial-gating-decision/177-01-TRIAL-DATA.md`, `.paul/phases/177-re-trial-gating-decision/177-01-DECISION.md`, `.paul/PROJECT.md`, `.paul/ROADMAP.md`, `.paul/STATE.md` (5 files; SUMMARY is added by UNIFY per the plan's `<output>` block) |
| Actual files changed (provisional, pre-UNIFY) | `.paul/phases/177-re-trial-gating-decision/177-01-PLAN.md` (already present from planning), `.paul/ROADMAP.md` and `.paul/STATE.md` (already modified during planning), and after Task 1/2/3 the 5 declared files above. Reconcile at UNIFY. |
| Unexpected files | 0 expected; reconcile at UNIFY |
| Surprise files | 0 expected |
| `<boundaries>` shape (from 177-01 PLAN) | DO NOT CHANGE: 7 bullets (`modules/codi/*`; `kernel/workflows/plan-phase.md` + `drivers/pi/install.sh` + validation suites; `drivers/pi/extensions/pals-hooks.ts` read-only; `.paul/CODI-HISTORY.md` read-only during APPLY; prior phase artifacts 168/173/175/176 read-only; `pals.json` `modules.codi` block + deferred `symbol_graph`/`trace`/PLAN-template formalization surfaces). SCOPE LIMITS: 6 bullets (no repo-source CODI/module/runtime/validation edits; no installer rerun; no cross-repo expansion; no retroactive rewriting of prior rows/SUMMARYs; no silent rubric changes from Phase 173; counterfactual and self-trial evidence labeled explicitly). |
| APPLY needed ad-hoc codegraph research? | None planned — research/decision phase. |
| Planner used understand/verify brokers? | No sub-broker planned. |
| Ad-hoc observations | The injection is real and grounded in the live codegraph index, but the *work* this phase does is research/decision writing under `.paul/`, not runtime TS edits. Treat Session C as live evidence that the v2.40 extractor produces non-null output on TS-carrying phases — but understand that when the work is not itself TS-touching, the blast_radius is context that could shape `<boundaries>` rather than being directly consumed by APPLY. |
| **CODI_NULL** | **false** (4 resolved-with-call-sites → substantive injection) |
| Interpretation toward the gate | Strongest usable evidence for Q2 / value-envelope proof. As controlled evidence, it supports interpretation of Signals 2 and 3 and counts toward Q2, but on its own it MUST NOT lift Signal 1 or Signal 4 above `partial` — Session C does not measure a natural implementation-phase APPLY's declared-vs-actual accuracy or broker-substitution behavior. |

---

## Counterfactual Session

### Session D: Phase 168 scope (CODI dry-run, NOT a live PALS plan run)

> **Counterfactual — not a live PALS plan run.** Phase 168 touched `drivers/pi/extensions/pals-hooks.ts` (codegraph-indexed TS) but predates CODI. This row simulates what CODI v2.40 WOULD have produced if it had been live during 168-01 planning. It MUST NOT be conflated with Sessions A–C in any signal whose evidence is plan-vs-actual file accuracy or broker substitution; per AC-2 / Phase 173 rubric, it contributes only to projection sub-comparisons.

Reusing Phase 168 (not substituting a different counterfactual) preserves continuity with Phase 173's gate so this re-trial compares like with like.

**Source artifacts inspected (read-only):**
- `.paul/phases/168-core-lifecycle-ui-polish/168-01-PLAN.md`
- `.paul/phases/168-core-lifecycle-ui-polish/168-01-SUMMARY.md`

**Re-used synthesis from Phase 173 `173-01-TRIAL-DATA.md` Session E (verbatim, unchanged):**

- Extracted candidates: `palsHooks`, `renderCompactLoopSummary`, `renderLifecycleStatus`, `syncLifecycleUi`, `renderLoopBadge`, `renderLifecycleWidget` (5 identifiers + 1 path token `drivers/pi/extensions/pals-hooks.ts`).
- Per-symbol `impact` outcomes captured during Phase 173 PLAN construction:
  - `palsHooks` → resolved-with-call-sites (depth 3, fan-out 21, role:entry-point)
  - `renderCompactLoopSummary` → resolved-with-call-sites (depth 1, fan-out 2)
  - `renderLifecycleStatus` → resolved-with-call-sites (depth 1, fan-out 3)
  - `syncLifecycleUi` → resolved-with-call-sites (depth 2, fan-out 5)
  - `renderLoopBadge` → resolved-but-empty (entry point, no downstream call-sites)
  - `renderLifecycleWidget` → conservatively treated as unresolved (not probed live)
- Synthesized dispatch log: `[dispatch] CODI: pre-plan advisory → impact × 6 symbols → 4 resolved, 1 unresolved, 4 total call-sites, injected blast_radius` (under the Phase 175 `R = resolved-with-call-sites only` convention; K uses the conservative one-line-per-symbol count).

**v2.40 framing delta (what's new since Phase 173's Session E):**

- Phase 174 promoted `<context>` source-file paths like `drivers/pi/extensions/pals-hooks.ts` into bounded symbol seeds. Phase 168's PLAN listed that exact path, so a v2.40 live dispatch would have resolved the same 4+ symbols without needing prose-mentioned backtick identifiers.
- Phase 175 pinned `R = resolved-with-call-sites only`; the synthesized R stays at 4 (unchanged from the reinterpreted Phase 173 synthesis).
- Phase 176 would have caused a row to land: `| 168-01 | 2026-04-01 | injected | 4 | 1 | 4 | palsHooks, renderCompactLoopSummary, renderLifecycleStatus, syncLifecycleUi, renderLoopBadge, (renderLifecycleWidget unresolved) | y |` (projection only — Phase 168 actually predates the hook).

**Phase 168 plan-vs-actual (from 168-01-SUMMARY What Was Built):**

| Field | Value |
|---|---|
| 168-01 declared `files_modified` | `drivers/pi/extensions/pals-hooks.ts` (1 file) |
| 168-01 actual files changed | `drivers/pi/extensions/pals-hooks.ts` (1 file, 1331 lines) — exact match |
| Unexpected files | 0 |
| Surprise files | 0 |
| 168-01 ad-hoc codegraph-style research during APPLY? | No — SUMMARY records 1/1 task PASS, no retries, no sub-broker |
| 168-01 broker invocations? | None |

**Trial integrity:** n/a — counterfactual only; Phase 168 predates CODI and no installed-vs-repo parity can be asserted for a hook that did not exist.

**CODI_NULL: false** (4 resolved-with-call-sites symbols would have produced a substantive blast_radius injection)

**Interpretation toward the gate:** strongest evidence for Signal 3's counterfactual projection (unchanged from Phase 173). Does NOT lift Signals 1 or 4 because Phase 168 already executed cleanly with 0 unexpected files and 0 brokers — the counterfactual can't improve on zero.

---

## Signal Scoring

Per the unchanged Phase 173 rubric (AC-2, CODI-null-aware): signals 1, 2, 4 exclude CODI_NULL=true rows from numerator-and-denominator. Signal 3 scores `<boundaries>` specificity across all rows. Session C (controlled live self-trial) MAY count as live evidence overall, but on Session C alone Signals 1 and 4 MUST NOT exceed `partial` (Session C is not a natural implementation-phase APPLY). Session D (counterfactual) contributes only to projection sub-comparisons.

**Non-CODI_NULL eligibility matrix:**

| Session | Class | CODI_NULL | Eligible for Signal 1/2/4 numerator? | Signal 3 eligibility |
|---|---|---|---|---|
| A (175-01) | historically reconstructed live | false | yes (historically reconstructed live) | yes |
| B (176-01) | hook-written retrospective live | true | no | yes |
| C (177-01-self) | controlled live self-trial | false | capped at `partial` for Signal 1, Signal 4 | yes |
| D (Phase 168 counterfactual) | counterfactual | false | projection only (per Phase 173 rubric) | projection only |

### Signal 1 — Fewer unexpected files in APPLY

- **Rubric (CODI-null-aware, unchanged from Phase 173):** pass = ≥ 2/3 of NON-CODI_NULL eligible sessions had ≤ 1 unexpected file beyond declared `files_modified`; partial = 1/2 or 1/3; fail = 0; not-applicable = fewer than 2 eligible rows AND no counterfactual contribution.
- **Eligible live evidence (v2.40):**
  - Session A (175-01, historically reconstructed live): 0 unexpected files (7 declared / 7 actual, exact match per SUMMARY).
  - Session C (177-01-self, controlled live self-trial): pending UNIFY; expected 0 based on the plan's verification block. Capped at `partial` contribution per the self-trial honesty rule regardless of actual count.
  - Session B (176-01): excluded from numerator (CODI_NULL=true) but note: 6/6 declared/actual exact match would have contributed positively if eligible.
- **Counterfactual (Session D):** Phase 168 had 1 declared / 1 actual = 0 unexpected files; the synthetic blast_radius (fan-out 21 on `palsHooks`) would have verified rather than prevented surprise in this already-clean scope. Still rated "moderate value" as in Phase 173.
- **Score: partial** — Session A shows a clean live outcome (0 unexpected) with CODI_NULL=false, but (a) Session A's implementation scope did not itself touch any of the 4 resolved symbols, so the causal link from blast_radius to file-accuracy is weak, and (b) Session C is capped at `partial` contribution by construction. One strong live row plus one capped row plus a counterfactual projection does not clear the `≥ 2/3` threshold for a full pass, but it materially exceeds Phase 173's not-applicable.
- **Honesty caveat:** Before v2.40's extractor change Signal 1 was not-applicable; after v2.40 it is `partial` — the improvement is structural (non-null live row now exists) rather than a demonstrated causal effect of blast_radius on APPLY file accuracy.

### Signal 2 — Drop in mid-APPLY codegraph calls (plans carried structural facts forward)

- **Rubric:** same denominator-restriction as Signal 1.
- **Eligible live evidence (v2.40):**
  - Session A (175-01): APPLY ran clean (3/3 tasks PASS), no mid-APPLY codegraph research, one bounded auto-fixed README marker surfaced by the validation suite. The blast_radius was available in the PLAN but APPLY's scope was installer/docs — it did not need to traverse call-sites. Still, "did the plan carry structural facts forward" reads **yes**: the Blast Radius sub-section is in PLAN and survived into SUMMARY's module-execution reports.
  - Session C (177-01-self): controlled — Session C is the plan carrying structural facts forward by construction. Interpretation-only contribution.
- **Counterfactual (Session D):** Phase 168 would have carried a 4-symbol Blast Radius into its single-file plan; APPLY didn't need it (single-file scope), so the projection is "limited yes" — unchanged from Phase 173.
- **Score: partial** — Session A demonstrates structural facts being carried forward in a non-CODI_NULL live row (a step up from Phase 173's zero such rows), and Session C reinforces the pattern as controlled evidence. But neither session exhibits the inverse measurement Signal 2 was originally designed for — the drop in mid-APPLY probing — because APPLY in both cases didn't need any probing regardless of CODI.
- **Honesty caveat:** v2.40 does not provide a live session where the planner avoided empirical probing *because* CODI had already injected the facts. Phase 173's observation 5 (empirical probing is a planner pattern, not CODI's contribution) still holds. The improvement over Phase 173 is that structural facts are now visibly present in a non-CODI_NULL live plan (Session A) rather than zero.

### Signal 3 — More specific `<boundaries>`

- **Rubric:** compare CODI-era `<boundaries>` (v2.40 rows: 175/176/177-self) against pre-CODI `<boundaries>` (167/168 from the Phase 173 baseline corpus) on three sub-axes — DO NOT CHANGE bullets, named files in those bullets, SCOPE LIMITS bullets. Pass = CODI-era median is greater on ≥ 2 sub-axes; partial = greater on 1; fail = no improvement or regression. Counterfactual sub-comparison included separately.
- **Pre-CODI baseline (from Phase 173 `173-01-TRIAL-DATA.md`, unchanged):**
  - DO NOT CHANGE bullets: median 4 (167:4, 168:4)
  - Named files in DO NOT CHANGE: median 4.5
  - SCOPE LIMITS bullets: median 4.5 (167:4, 168:5)
- **v2.40 CODI-era counts (from the three v2.40 rows):**
  - 175-01 PLAN: DO NOT CHANGE 5 / named files ~8 / SCOPE LIMITS 6.
  - 176-01 PLAN: DO NOT CHANGE 6 / named files ~10 / SCOPE LIMITS 5 (both blocks enumerate installer/kernel-workflow/other-modules/pals.json/PLAN-template as out-of-scope).
  - 177-01 PLAN (self): DO NOT CHANGE 7 / named files ~11 / SCOPE LIMITS 6.
  - **v2.40 CODI-era median (n=3): DO NOT CHANGE 6 / named files ~10 / SCOPE LIMITS 6.**
- **Comparison:**

| Sub-axis | Pre-CODI median (n=2) | v2.40 CODI-era median (n=3) | CODI-era greater? |
|---|---|---|---|
| DO NOT CHANGE bullets | 4 | 6 | **yes** |
| Named files in DO NOT CHANGE | 4.5 | ~10 | **yes** |
| SCOPE LIMITS bullets | 4.5 | 6 | **yes** |

CODI-era is greater on **3 of 3 sub-axes**.

- **Score: pass.**
- **Honesty caveat (REQUIRED):** two of three v2.40 rows (Sessions B and the structural portion of 175) do not have a live non-null CODI injection at the moment they were authored, meaning their boundary richness is still partly attributable to general planner-discipline maturation (the same caveat Phase 173 raised). However, Session A had a non-null injection available during planning, and Session C was authored with a non-null injection in the module dispatch by construction. Causal attribution to CODI is therefore measurably stronger than in Phase 173 (0 non-null rows → some non-null rows), even if it still falls short of clean isolation.
- **Counterfactual sub-comparison (Session D):** unchanged from Phase 173 — projected-pass. CODI-active TS scopes plausibly add 10–25% to boundary specificity above the planner-discipline baseline.

### Signal 4 — No need for understand/verify brokers

- **Rubric:** same denominator-restriction as Signal 1.
- **Eligible live evidence (v2.40):**
  - Session A (175-01): no sub-broker invocations per SUMMARY Module Execution Reports.
  - Session C (177-01-self): no sub-broker planned; capped at `partial` per honesty rule regardless.
- **Counterfactual (Session D):** Phase 168 APPLY didn't invoke any broker (single-file scope). Projection is "not-applicable" — unchanged from Phase 173.
- **Score: not-applicable** — neither Session A nor Session C exhibits the specific behavior Signal 4 measures (a broker that would have been invoked but wasn't because CODI already injected the facts). Zero brokers observed is consistent with both "CODI substituted for brokers" and "the planner never needed brokers for this scope anyway." Without a session where a broker would plausibly have fired, this signal remains unscoreable.
- **Honesty caveat:** Phase 173's Signal 4 was also not-applicable; v2.40 has not produced a session shape that changes that. This is a measurement-design problem as much as a CODI-value problem.

---

## Comparison to Phase 173

| Dimension | Phase 173 (v2.39) | Phase 177 (v2.40) | Change |
|---|---|---|---|
| Non-CODI_NULL live rows | 0 (Sessions A–D all CODI_NULL=true) | 2 (Session A historically reconstructed + Session C controlled self-trial) | **improved** |
| Signal 1 score | not-applicable | **partial** | **improved** |
| Signal 2 score | not-applicable | **partial** | **improved** |
| Signal 3 score | pass (causation caveat) | pass (weakened causation caveat — some non-null rows now exist) | **matched / slightly strengthened** |
| Signal 4 score | not-applicable | not-applicable | unchanged |
| `S_pass_nonnull` | 1 (Signal 3 via counterfactual projected-pass) | Signal 1 partial (+1) + Signal 2 partial (+1) + Signal 3 pass (+1) + Signal 4 n/a = **3** under the "signals scored ≥ partial" count restricted to non-CODI_NULL evidence. Signal 3's counterfactual sub-contribution is already implicit in the Signal 3 pass. | **+2** |
| `S_pass_signal3` | pass | pass | unchanged |
| Strongest single piece of evidence | Session E (Phase 168 counterfactual) projected-pass on Signal 3 | Session A (175-01) = first live non-null hook-era injection on a non-test-controlled phase, plus Session C controlled proof that v2.40's extractor does resolve on TS-carrying `<context>` | substantively stronger |

**Overall:** v2.40 **improved** over Phase 173 on `S_pass_nonnull` (1 → 3) and on Signals 1, 2, and 3 evidence quality; Signal 4 remains unchanged (still not-applicable). The improvement is genuine but partially structural rather than purely causal — the v2.40 extractor change is what made non-null live rows possible, but the specific *work* of Sessions A and C did not itself depend on the injected blast_radius at APPLY time.

**Remaining weaknesses (required honest statement):**
- Signal 4 still has no usable live evidence; the trial set does not exhibit a scope where CODI would plausibly substitute for a broker.
- Signal 2's improvement is about structural facts being carried into the plan, not about a measurable drop in mid-APPLY probing.
- Signal 1's partial score rests on Session A's 0-unexpected outcome plus Session C's capped contribution; no single live session demonstrates CODI blast_radius preventing a surprise file in APPLY — the surprise rate was already zero.
- All three v2.40 live rows (A, B, C) are in the CODI-development / decision lineage itself; the trial set lacks non-CODI product-scope implementation phases with TS in play. Cross-repo or broader-domain trials remain a known future surface.

---

## Cross-cutting observations

### Observation 1: The v2.40 extractor change worked as designed

Phase 174's source-file selector extractor converted what would have been Phase 173-era CODI_NULL=true outcomes into Phase 175's non-null live row. The extractor did not merely reduce the "0 extractable symbols" skip-path frequency — it actually resolved TS symbols against the live codegraph and produced a substantive Blast Radius. Phase 173 cross-cutting observation 3 diagnosed the right layer for the fix.

### Observation 2: Non-null live rows exist, but the causal chain to APPLY quality is still indirect

In both Session A and the controlled Session C, the work APPLY actually did (installer/docs edits; research/decision writing) did not consume the blast_radius directly. The blast_radius shaped what the planner saw when writing `<boundaries>` and Task actions, but the APPLY didn't need to traverse call-sites. This is consistent with Phase 173's Signal 3 causation caveat but weaker than the dataset being used to definitively demonstrate causal improvement on Signals 1 or 2.

### Observation 3: Phase 176 retrospective hook works end-to-end

The first hook-written row (176-01) landed cleanly: `plan_path` resolution, PLAN.md primary read, outcome categorization, row append, all matched Phase 176 PLAN's self-test prediction. This is a structural win for measurement: Phase 178+ trials no longer need per-phase reconstruction. Phase 177's own post-unify hook run will append the 177-01 row during UNIFY.

### Observation 4: The re-trial still doesn't exercise a natural implementation phase with TS in work-scope

Session C is controlled-live precisely because v2.40's four implementation-lineage phases (174, 175, 176, 177-self) either touched no TS or touched TS only as read-only evidence. A truly unambiguous demonstration of CODI value would require a phase that (a) is not a CODI development phase, (b) touches indexed TS in its implementation, and (c) has the four target symbols actually in its changed-file set. The re-trial answers whether v2.40 moved the needle on the original gate — not whether the needle is at SHIP.

### Observation 5: `S_pass_nonnull = 3` under the literal Phase 173 rule

Counting signals scored ≥ `partial` restricted to non-CODI_NULL evidence: Signal 1 partial (+1), Signal 2 partial (+1), Signal 3 pass (+1), Signal 4 n/a (+0) → 3. This clears the Phase 173 SHIP_V0_2 threshold `S_pass_nonnull ≥ 3` mechanically. But SHIP_V0_2 also requires Q2=yes AND Q3=yes under the decision rule. Q2 is evaluated in DECISION.md against the projected-pass / live-non-null counterfactual+live mix; the honest answer is stronger than Phase 173's uncertain but not clearly unambiguous yes given the indirect causal chain observation above. The DECISION artifact resolves Q2 and the verdict; this TRIAL-DATA file only establishes the scores and the honest delta.

### Observation 6: The trial can honestly clear the gate without inflating Session C

Under the honesty rules written into the plan:
- Session C counts as live for overall non-CODI_NULL tallies but caps at `partial` for Signal 1 / Signal 4.
- Session A carries most of the Signal 1 / Signal 2 weight among live non-CODI_NULL rows; Session B contributes only to Signal 3 and to trial-integrity / measurement confidence.
- Signal 3 still uses the counterfactual as its strongest single data point.

Even with Session C capped and Session B excluded from Signal 1/2/4 numerators, `S_pass_nonnull = 3` is supportable with Session A alone providing Signal 1 + Signal 2 partials. This is the honest test the plan required.

---

## Machine-readable session summary

Per-session markers (line-start) so the AC-1 verify regex and downstream readers can enumerate sessions without parsing tables:

Session: 175-01
Trial integrity: pass (best-available)
CODI_NULL: false

Session: 176-01
Trial integrity: pass
CODI_NULL: true

Session: 177-01-self
Trial integrity: pass
CODI_NULL: false

Session: Phase 168 counterfactual
Trial integrity: n/a (counterfactual)
CODI_NULL: false

---
End of TRIAL-DATA.md. See `177-01-DECISION.md` for the binding verdict.
