---
phase: 180-re-trial-gating-decision
plan: 01
artifact: DECISION
created: 2026-04-20
binds: v2.41 CODI v0.1 — natural-scope re-trial
trial_evidence: ../179-organic-observation/179-01-SUMMARY.md
baseline_evidence: ../177-re-trial-gating-decision/177-01-DECISION.md
---

# Verdict: **ITERATE_V0_1** — CODI v0.1 Natural-Scope Re-Trial Gating Decision (v2.41)

This artifact is the binding verdict for the v2.41 CODI v0.1 natural-scope re-trial milestone: **ITERATE_V0_1**. It is derived mechanically from the evidence in `../179-organic-observation/179-01-SUMMARY.md` by applying the **unchanged Phase 173 decision rule** stated below, running the structured 3-question checklist with the required two-pass Q2 treatment, then the per-signal recap. The decision rule is stated before any score is read, and no rubric deviations are made in this phase.

---

## Decision rule

Restated verbatim from `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md` §1 — unchanged.

Variables:
- `S_pass_nonnull` = number of signals 1–4 scored ≥ partial restricted to non-CODI_NULL evidence per AC-2 of the PLAN. Counts `projected-pass` on counterfactual sub-comparisons as +1 toward signals 1, 2, 4 when the live row was not-applicable.
- `S_pass_signal3` = signal 3's score (live + counterfactual sub-comparison).

Rule:
1. **SHIP_V0_2** requires Q3=yes AND Q2=yes AND `S_pass_nonnull ≥ 3`.
2. **KILL** requires Q3=no AND Q2=no AND `S_pass_nonnull ≤ 1` AND `S_pass_signal3 = fail`.
3. **ITERATE_V0_1** in all other cases (explicit fallback, including all borderline scenarios).
4. **Tie-breaker**: if SHIP_V0_2 and ITERATE_V0_1 both qualify under literal reading of the gates, prefer ITERATE_V0_1 (lower-risk choice; SHIP requires unambiguous yes on Q2+Q3).

**No deviations.** The plan committed to reusing the Phase 173 rule unchanged and no evidence-driven deviation is required to compute the v2.41 verdict.

This rule is binding for this verdict. It is not edited below.

---

## Structured 3-question cross-cutting checklist

Thresholds remain unchanged from Phase 173 / Phase 177. Phase 180 records Q2 in two passes because the approved plan requires the instrumentation-blocked mechanical ledger to stay visibly separate from the qualitative natural-scope interpretation. The verdict letter follows the **mechanical** pass only.

### Q1: Does the trial sample include sufficient non-CODI-null evidence to score CODI's value?

**Phase 173 threshold (reused verbatim):** Yes if ≥ 1 non-CODI_NULL row exists; no if 0; uncertain only if resolution is ambiguous.

**Cited evidence:**
- quark `112-01` is a natural `pre-authored` row in the authoritative Phase 179 row set. The Phase 112 PLAN contains a CODI Blast Radius section for `makeProcessRun`, `createProcessSyscalls`, and `validateManifestPresence`; the Phase 112 SUMMARY records a post-unify `no-dispatch-found` row plus an explicit `### CODI Influence on APPLY` section stating **CODI materially shaped APPLY: yes** (`../179-organic-observation/179-01-SUMMARY.md:33-45`; quark `112-01` PLAN:73-100; quark `112-01` SUMMARY:55-58,83-90).
- quark `113-01` is a natural `concurrent-natural` row in the authoritative Phase 179 row set. The Phase 113 PLAN records `impact × 5 symbols → 2 resolved-with-call-sites, 3 resolved-but-empty, 0 unresolved, 5 total call-sites, injected blast_radius`; the Phase 113 SUMMARY shows no CODI post-unify entry, which is exactly the hook-not-firing finding (`../179-organic-observation/179-01-SUMMARY.md:37-45`; quark `113-01` PLAN:87-116; quark `113-01` SUMMARY:152-175).
- quark `CODI-HISTORY.md` mechanically contains only one row (`112-01 | no-dispatch-found`), so the ledger undercounts the two natural non-CODI_NULL phases by 2× for two different reasons: parser-miss on `112-01`, hook-not-firing on `113-01` (`../179-organic-observation/179-01-SUMMARY.md:16-20,39-45`; quark `.paul/CODI-HISTORY.md:6-8`).

**Answer: yes** — cleanly on the natural evidence itself. There are **2** natural non-CODI_NULL observations (`112-01`, `113-01`), even though the mechanical ledger records only **1** row. The undercount is real, but it does not erase the existence of the two natural CODI-active phases.

### Q2: When CODI does fire on indexed code (natural-scope evidence), does the blast-radius materially shape APPLY in the observed work?

**Phase 173 threshold (reused verbatim):** Yes if ≥ 2 of 4 signals had projected-pass; no if 0; uncertain if 1.

**Mechanical pass (verdict-affecting):**
- quark `CODI-HISTORY.md` contains only one host row and that row is `no-dispatch-found`, not `injected`.
- quark `112-01` SUMMARY mechanically confirms the parser-miss: CODI appended a `no-dispatch-found` row because the plan used qualitative dispatch wording the post-unify parser did not classify as success.
- quark `113-01` SUMMARY mechanically confirms that CODI post-unify did not fire at all: WALT / SKIP / RUBY appear in `## Module Execution Reports`, CODI does not (`../179-organic-observation/179-01-SUMMARY.md:35-45,50-52`; quark `.paul/CODI-HISTORY.md:6-8`; quark `112-01` SUMMARY:55-58; quark `113-01` SUMMARY:152-175).

**Mechanical answer: uncertain.** The honest ledger-level picture is neither a clean `yes` nor a clean `no`: one natural row is misclassified as `no-dispatch-found`, the second is missing entirely, and the undercount is caused by two different instrumentation defects. That is exactly an ambiguity case, so the mechanical pass stays `uncertain`.

**Qualitative pass (recorded, but explicitly non-binding):**
- quark `112-01` SUMMARY states **CODI materially shaped APPLY: yes** and names the concrete mechanisms: boundary caution from upstream callers, file awareness of `startDaemon` / `createProcessSyscalls`, sequencing from `validateManifestPresence`, and avoidance of a partial fix (`../179-organic-observation/179-01-SUMMARY.md:35,41`; quark `112-01` SUMMARY:83-90).
- quark `113-01` natural evidence shows the same pattern in a different form: the Phase 113 PLAN carried forward the `makeProcessCreate` / `makeProcessRun` → `createProcessSyscalls` → `startDaemon` chain, and the SUMMARY's Deviation #1 shows the hard-fail landing in `loop.ts` rather than `manifest-validator.ts`, consistent with CODI's `resolved-but-empty` + single-call-site guidance for `validateManifestPresence` (`../179-organic-observation/179-01-SUMMARY.md:37,50-52`; quark `113-01` PLAN:92-114; quark `113-01` SUMMARY:41-43,181-183).

**Qualitative answer: yes.** On the natural trial record, CODI clearly shaped APPLY placement in both observed phases.

### Q3: Is v0.2 scope (for example `symbol_graph`, `trace`, and related expansion) justified now?

**Cited evidence:**
- Phase 179's headline finding is that the measurement surface, not observation volume, is the current bottleneck: the ledger undercounts two successful natural dispatches for two different reasons (`../179-organic-observation/179-01-SUMMARY.md:14-20,27,48-52`).
- The approved Phase 180 posture is Option C: issue the v2.41 verdict on the evidence as-is, then open v2.42 as the bounded instrumentation-fix milestone under a fresh source freeze.

**Answer: no** — stated openly with the Option C framing. The natural-scope trial produced real qualitative Q2 evidence, but it also established that parser-miss + hook-not-firing defects make the measurement surface untrustworthy. Under that openly stated framing, v2.42 should fix the instrumentation before expanding CODI to v0.2 scope. This is a milestone-framing answer, not a rule edit.

---

## Per-signal score recap

(Source: Signal labels copied verbatim from `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md`; mechanical scoring uses the Phase 179 authoritative row set plus host PLAN/SUMMARY artifacts without silently repairing the ledger.)

| Signal | Mechanical live score (v2.41) | Mechanical evidence |
|---|---|---|
| 1 — Fewer unexpected files in APPLY | partial | `112-01` planned 9 files and SUMMARY reports those same 9 files in `## What Was Built`, with no source-scope deviation. `113-01` planned 18 files, but SUMMARY reports several additional changed files outside `files_modified` (`src/cli.ts`, `src/kernel/descriptor-audit.test.ts`, `src/kernel/state.test.ts`, `src/kernel/security-stress.test.ts`, `src/cli.test.ts`, `src/driver/echo.test.ts`, `src/kernel/coprocessor-interface.test.ts`) plus one planned file pair not touched. Under the unchanged Signal 1 rubric, 1 of 2 natural non-CODI_NULL rows meets the `≤ 1 unexpected file` condition → **partial** (quark `112-01` PLAN:7-16; quark `112-01` SUMMARY:17-25,72-75; quark `113-01` PLAN:7-24; quark `113-01` SUMMARY:18-39,41-43). |
| 2 — Drop in mid-APPLY codegraph calls | partial | Both natural rows carried structural facts forward at PLAN time: `112-01` has a CODI Blast Radius section; `113-01` has an explicit injected pre-plan CODI dispatch plus Blast Radius section. That is stronger than Phase 173's zero non-null live rows. But the post-unify parser-miss / hook-not-firing defects mean the mechanical record does not cleanly prove a drop in APPLY-time probing attributable to CODI alone. Structural facts were carried forward; causal isolation remains incomplete → **partial** (`../179-organic-observation/179-01-SUMMARY.md:35-45`; quark `112-01` PLAN:73-100; quark `113-01` PLAN:87-116; quark `113-01` SUMMARY:152-175). |
| 3 — More specific `<boundaries>` | pass | The unchanged Signal 3 rubric asks whether CODI-era boundary blocks are greater on ≥ 2 of 3 sub-axes. Phase 173's baseline medians are DO NOT CHANGE = 4 and SCOPE LIMITS = 4.5. The two natural v2.41 plans score: `112-01` DO NOT CHANGE = 4 / SCOPE LIMITS = 4; `113-01` DO NOT CHANGE = 6 / SCOPE LIMITS = 8. The v2.41 natural median is therefore 5 / 6, greater than baseline on 2 sub-axes, which is sufficient for **pass**. Named-file specificity is mixed, but pass already clears on the required two axes (`173-01-TRIAL-DATA.md:279-292`; quark `112-01` PLAN:209-219; quark `113-01` PLAN:499-515). |
| 4 — No need for understand/verify brokers | not-applicable | No broker-substitution event is mechanically recorded in the Phase 179 row set, quark `CODI-HISTORY.md`, or either quark SUMMARY `## Module Execution Reports` block. As in Phase 177, zero brokers observed is consistent with both "CODI substituted for brokers" and "the work never needed brokers." The signal remains unscoreable → **not-applicable** (`../179-organic-observation/179-01-SUMMARY.md:33-45`; quark `.paul/CODI-HISTORY.md:6-8`; quark `112-01` SUMMARY:47-69; quark `113-01` SUMMARY:146-175). |

**`S_pass_nonnull` calculation per the decision rule:**
- Signal 1: live partial (≥ partial, non-CODI_NULL) → **+1**
- Signal 2: live partial (≥ partial, non-CODI_NULL) → **+1**
- Signal 3: live pass → **+1**
- Signal 4: not-applicable → **+0**

**`S_pass_nonnull` = 3.**

**`S_pass_signal3` = pass.**

---

## Verdict

Mechanical computation per the section-1 decision rule.

- Q1 = yes
- Q2 = uncertain (mechanical pass; qualitative pass recorded separately below)
- Q3 = no
- `S_pass_nonnull` = 3
- `S_pass_signal3` = pass

Apply rules:

- **SHIP_V0_2 gate:** requires Q3=yes AND Q2=yes AND `S_pass_nonnull ≥ 3`. `S_pass_nonnull ≥ 3` ✓, but Q2=uncertain ✗ and Q3=no ✗. **Gate fails on two conditions.** SHIP not selected.
- **KILL gate:** requires Q3=no AND Q2=no AND `S_pass_nonnull ≤ 1` AND `S_pass_signal3 = fail`. Q3=no ✓, but Q2=uncertain ✗, `S_pass_nonnull` = 3 ✗, and `S_pass_signal3` = pass ✗. **Gate fails on three conditions.** KILL not selected.
- **ITERATE_V0_1:** explicit fallback for all other cases. **Selected.**
- Tie-breaker: not triggered (SHIP and ITERATE do not both qualify; only ITERATE qualifies under the literal reading).

# Verdict: **ITERATE_V0_1**

v2.41 produced the first genuinely natural-scope evidence that CODI's pre-plan advisory can shape APPLY, but the same trial also established that the post-unify measurement surface is not trustworthy enough to support a clean mechanical SHIP. The natural evidence package is therefore strong enough to block KILL, strong enough to keep `S_pass_nonnull` at 3, and still not strong enough to satisfy the unchanged SHIP gate because the verdict-affecting Q2 mechanical pass remains `uncertain` and Option C openly routes Q3 to `no` until the measurement surface is repaired.

**Interpretation note (does NOT influence the verdict letter):** Qualitatively, the natural trial trends Q2 to **yes**. Both quark phases show CODI materially shaping APPLY placement, and the Phase 179 SUMMARY's core finding is that the ledger undercount is caused by two distinct instrumentation defects, not by CODI being valueless on natural scope. That qualitative read is preserved as trial record and is the reason v2.42 opens as the bounded instrumentation-fix milestone. It does **not** change the mechanical verdict letter above.

---

## Binding statement

This artifact binds the v2.41 milestone verdict as **ITERATE_V0_1**. v2.41 closes on this basis; any attempt to change the letter would require a new milestone/phase, not a reinterpretation of this evidence package.
