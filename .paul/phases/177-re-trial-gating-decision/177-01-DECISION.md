---
phase: 177-re-trial-gating-decision
plan: 01
artifact: DECISION
created: 2026-04-18
binds: v2.40 CODI v0.1 — ship/iterate/kill re-trial
trial_evidence: 177-01-TRIAL-DATA.md
baseline_evidence: ../173-real-world-trial-gating-decision/173-01-DECISION.md
---

# CODI v0.1 Re-Trial Gating Decision (v2.40)

This artifact is the binding verdict for the v2.40 CODI v0.1 re-trial milestone. It is derived mechanically from the evidence in `177-01-TRIAL-DATA.md` by applying the **unchanged Phase 173 decision rule** stated below, running the **unchanged Phase 173 structured 3-question checklist**, then the per-signal recap. The decision rule is stated before any score is read, and no rubric deviations are made in this phase.

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

**No deviations.** The plan committed to reusing the Phase 173 rule unchanged and no evidence-driven deviation is required to compute the v2.40 verdict.

This rule is binding for this verdict. It is not edited below.

---

## Structured 3-question cross-cutting checklist

Unchanged from Phase 173.

### Q1: Does the trial sample include sufficient non-CODI-null evidence to score CODI's value?

**Phase 173 threshold (reused verbatim):** Yes if ≥ 1 non-CODI_NULL row exists; no if 0; uncertain only if resolution is ambiguous.

**Cited evidence (`177-01-TRIAL-DATA.md`):**
- Session A (`175-01`, historically reconstructed live): CODI_NULL=false. `.paul/CODI-HISTORY.md` row `175-01 | injected | 4 | 0 | 10` plus Blast Radius sub-section verified against `175-01-PLAN` source (TRIAL-DATA Session A row).
- Session B (`176-01`, hook-written retrospective live): CODI_NULL=true. `skipped-no-symbols`; correct behavior for a YAML/markdown/shell-scoped phase.
- Session C (`177-01-self`, controlled live self-trial): CODI_NULL=false. `impact × 4 symbols → 4 resolved, 0 unresolved, 10 total call-sites`.
- Session D (Phase 168 counterfactual): CODI_NULL=false (projection only).
- Non-CODI_NULL live rows: **2** (Sessions A and C). Non-CODI_NULL counterfactual rows: 1 (Session D).

**Answer: yes** — cleanly, with two non-CODI_NULL live rows. This is a categorical improvement over Phase 173's 0 non-CODI_NULL live rows. Caveat carried forward: Session C is labeled `controlled live self-trial`, not a natural implementation-phase row, and counts toward the live non-null tally only under the honesty rules in TRIAL-DATA (capped at `partial` contribution on Signal 1 and Signal 4).

### Q2: When CODI does fire on indexed code (counterfactual + live-non-null evidence), does the blast-radius materially shape what a careful planner would write?

**Phase 173 threshold (reused verbatim):** Yes if ≥ 2 of 4 signals had projected-pass; no if 0; uncertain if 1.

**Cited evidence (`177-01-TRIAL-DATA.md` Signal Scoring + Cross-cutting Observations 2 and 4):**
- Signal 1: live-partial (Session A's 0 unexpected files) + counterfactual "moderate value" (verification, not surprise prevention in this specific case). **Not projected-pass.** The causal chain from blast_radius to file accuracy is weak because Session A's implementation scope did not itself touch any of the 4 resolved symbols.
- Signal 2: live-partial (Session A carried structural facts forward into the plan) + counterfactual "limited yes". **Not projected-pass.** v2.40 does not provide a live session where the planner avoided empirical probing *because* CODI had already injected the facts; Phase 173 cross-cutting observation 5 (empirical probing is a planner pattern) still holds.
- Signal 3: live pass + counterfactual **projected-pass** (CODI-active TS scopes plausibly +10–25% to boundary specificity). Causation caveat is measurably weaker in v2.40 because some non-null rows now exist, but it is not fully isolated. **Projected-pass counted.**
- Signal 4: live not-applicable + counterfactual not-applicable. **Not projected-pass.** Zero brokers observed is consistent with both "CODI substituted for brokers" and "the planner never needed brokers for this scope anyway."

Projected-pass count: **1 of 4** (Signal 3 only) — unchanged from Phase 173 under the strict threshold.

**Answer: uncertain** — v2.40 moved live evidence from "nothing" to "something" on Signals 1 and 2, but neither reaches projected-pass under the unchanged Phase 173 Q2 threshold. The counterfactual continues to support Signal 3 only. Honesty constraint from TRIAL-DATA Observation 4 applies: the re-trial still does not exercise a natural implementation phase with TS in work-scope, so a clean projected-pass on Signals 1, 2, or 4 remains absent.

### Q3: Is the cost of carrying CODI v0.1 (manifest + extractor rules + source-file selector extraction + install-time heuristic + post-unify hook + `.paul/CODI-HISTORY.md` + validation markers) justified by the value envelope identified in Q1+Q2?

**Cited evidence:**
- Carrying-cost surface (from 175-01/176-01 SUMMARY line counts and the plan's `<boundaries>` DO NOT CHANGE list):
  - `modules/codi/module.yaml` — 170 lines (after Phase 176 post-unify addition).
  - `modules/codi/references/codi.md` — 147 lines (≤ 150-line module-ref cap; pointer to instrumentation ref added in Phase 176).
  - `modules/codi/references/codi-instrumentation.md` — 85 lines (new in Phase 176, ≤ 150-line cap).
  - Plan-phase seed coupling in `kernel/workflows/plan-phase.md` — bounded `prepare_codi_seed_candidates` step (Phase 172) plus the Phase 174 source-file selector extension.
  - Default-on `pals.json` `modules.codi` block — 2-line registration.
  - Install-time heuristic in `drivers/pi/install.sh` — single non-blocking recommendation line (Phase 175), no config mutation and no CODI auto-disable.
  - `.paul/CODI-HISTORY.md` — 9 lines (header + 2 rows; grows by one row per UNIFY, same shape as `.paul/QUALITY-HISTORY.md`).
  - Validation markers in `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` — bounded semantic checks; drift guard on 5 pre-plan skip-log strings (Phase 176).
  - Total carrying-cost surface: still bounded (roughly ~400 lines of module surface + the two tally/history files + bounded validation markers). Grew from Phase 173's ~225 lines by ~1.8× as iteration shipped, but remains well-isolated and registry-driven.
- Q1=yes (cleanly), Q2=uncertain (1 projected-pass under the Phase 173 threshold).
- Value envelope identified in v2.40: CODI now produces non-null live injections on TS-carrying phases (Session A demonstrated end-to-end), and the post-unify hook turns dispatch-outcome measurement from manual reconstruction into an automated append (Session B demonstrated end-to-end). Signal 3 continues to clear on both live and counterfactual evidence.
- Cross-cutting observation 1 (TRIAL-DATA): Phase 174's source-file selector extractor worked as designed — it converted Phase 173-era CODI_NULL outcomes into non-null rows when TS paths are present in `<context>`.
- Cross-cutting observation 2 (TRIAL-DATA): the causal chain from blast_radius to APPLY quality is still indirect — neither Session A nor Session C actually traversed the injected call-sites during APPLY.
- Cross-cutting observation 4 (TRIAL-DATA): the re-trial does not yet include a non-CODI-development product-scope implementation phase with TS in work-scope. The known future surface is either a product phase that naturally touches TS (organic) or a cross-repo trial (explicit).
- Cross-cutting observation 6 (TRIAL-DATA): even with Session C capped at `partial` contribution and Session B excluded from Signal 1/2/4 numerators, `S_pass_nonnull = 3` is supportable from Session A alone on Signals 1 + 2 partials plus Signal 3 pass. The verdict is not inflated by the controlled self-trial.

**Answer: yes (qualified)** — carrying cost grew modestly but remains small and well-isolated. Value envelope widened from Phase 173's "only counterfactual projection on Signal 3" to v2.40's "live non-null injection demonstrated plus structural measurement in place plus Signal 3 still clearing." The qualification is that Signals 1, 2, and 4 still lack the kind of live evidence that would isolate CODI's causal contribution from planner discipline. Borderline; would be "no" if the carrying cost were larger or if Signal 3's value were weakening instead of holding.

---

## Per-signal score recap

(Source: `177-01-TRIAL-DATA.md` Signal Scoring section and Comparison to Phase 173 table.)

| Signal | Live score (v2.40) | Counterfactual projection (Session D) | Combined evidence | Phase 173 comparison |
|---|---|---|---|---|
| 1 — Fewer unexpected files in APPLY | partial (Session A 0-unexpected; Session C capped at partial) | moderate value (verification, not surprise prevention) | live-partial — one non-CODI_NULL live row now exists where Phase 173 had zero | **improved** |
| 2 — Drop in mid-APPLY codegraph calls | partial (Session A carried structural facts forward) | limited yes (different scope would benefit more) | live-partial — structural facts are now visibly carried into a non-CODI_NULL live plan | **improved** |
| 3 — More specific `<boundaries>` | pass (weakened causation caveat — some non-null live rows now exist) | projected-pass (CODI-active TS scopes plausibly +10–25% specificity) | **strongest** — live pass + counterfactual projected-pass + non-null live rows now exist | matched / slightly strengthened |
| 4 — No need for understand/verify brokers | not-applicable (no broker substitution observed live or counterfactually) | not-applicable | weak — no session shape exercises Signal 4 | unchanged |

**Honesty cap preserved:** Session C alone does not lift Signal 1 or Signal 4 above `partial`, per TRIAL-DATA's explicit self-trial rule. Session A's contribution is what actually carries Signal 1 + Signal 2 across the partial threshold.

**`S_pass_nonnull` calculation per the decision rule:**
- Signal 1: live partial (≥ partial, non-CODI_NULL) → **+1**
- Signal 2: live partial (≥ partial, non-CODI_NULL) → **+1**
- Signal 3: live pass + counterfactual projected-pass → **+1**
- Signal 4: not-applicable → **+0**

**`S_pass_nonnull` = 3.** (Phase 173 baseline: 1. Delta: +2.)

**`S_pass_signal3` = pass** (with weakened causation caveat versus Phase 173).

---

## Verdict

Mechanical computation per the section-1 decision rule.

- Q1 = yes
- Q2 = uncertain (1 of 4 projected-pass under the unchanged Phase 173 threshold)
- Q3 = yes (qualified)
- `S_pass_nonnull` = 3
- `S_pass_signal3` = pass

Apply rules:

- **SHIP_V0_2 gate:** requires Q3=yes AND Q2=yes AND `S_pass_nonnull ≥ 3`. Q3=yes ✓, `S_pass_nonnull ≥ 3` ✓ (**=3, cleared for the first time**), Q2=uncertain ✗. **Gate fails on Q2.** SHIP not selected.
- **KILL gate:** requires Q3=no AND Q2=no AND `S_pass_nonnull ≤ 1` AND `S_pass_signal3 = fail`. Q3=yes ✗, Q2=uncertain ✗, `S_pass_nonnull` = 3 ✗, `S_pass_signal3` = pass ✗. **Gate fails on all four conditions.** KILL not selected.
- **ITERATE_V0_1:** explicit fallback for all other cases. **Selected.**
- Tie-breaker: not triggered (SHIP and ITERATE do not both qualify; only ITERATE qualifies under the literal reading).

# Verdict: **ITERATE_V0_1**

v2.40 delivered on the Phase 173 iteration theme. The extractor-vs-scope alignment gap closed: Phase 174's source-file selector extractor converted live PALS phases with TS in `<context>` from uniformly CODI_NULL (Phase 173) into non-null live rows (Session A), and Phase 176's post-unify hook turned dispatch-outcome measurement from manual reconstruction into an automated append. Signal 3 continues to clear on both live and counterfactual evidence. `S_pass_nonnull` moved from 1 to 3 — mechanically crossing the SHIP threshold for the first time.

But the SHIP gate's Q2 requirement is not yet met under the unchanged Phase 173 threshold: only Signal 3 reaches projected-pass; Signals 1 and 2's live partials do not. The honest interpretation (TRIAL-DATA Observation 4) is that v2.40's live evidence is partially structural (non-null rows exist) rather than causally demonstrated (the *work* in Sessions A and C did not itself consume the injected blast_radius during APPLY). A SHIP decision on Q2=uncertain would overclaim.

The carrying cost remains bounded (~400 lines of module surface, registry-driven, zero kernel/installer code changes beyond the bounded Phase 175 recommendation). The Signal 3 value envelope continues to justify continued investment. One more iteration cycle that exercises CODI on a natural non-CODI-development implementation-phase TS scope — either organically or via a targeted bounded phase — would either convert Q2 to yes (SHIP) or demonstrate conclusively that the envelope remains Signal-3-only (KILL path candidate).

---

## Verdict-specific scope

### SHIP_V0_2 scope — **NOT SELECTED**

(Rationale: SHIP requires Q2=yes. v2.40 has `S_pass_nonnull ≥ 3` for the first time, but only Signal 3 reaches projected-pass. Stacking `symbol_graph` on top before Signal 1/2 demonstrate causal value on a natural implementation-phase TS scope would compound an indirect-causal-chain problem. Defer until the next iteration cycle closes that gap or confirms the envelope is bounded to Signal 3.)

### KILL scope — **NOT SELECTED**

(Rationale: Signal 3 continues to clear, `S_pass_nonnull` has actually improved from 1 to 3, and the carrying cost has grown modestly but remains bounded. Three of the four KILL gate conditions are clearly false and the fourth — `S_pass_signal3 = fail` — is explicitly refuted by live pass + counterfactual projected-pass. Closing the thesis while the envelope is expanding would discard real iteration gains.)

### ITERATE_V0_1 scope — **SELECTED**

Numbered iteration tasks for the next milestone (proposed v2.41 — "CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation"). Priority-ordered by expected decision weight on the next gate:

1. **Organic TS-touching implementation phase trial.**
   - **Goal:** Observe CODI dispatch on a natural PALS implementation phase whose `files_modified` list actually includes a codegraph-indexed TS file (not just `<context>` carry-posture). This is the test Phase 177 Observation 4 explicitly flagged as missing from the v2.40 dataset. Candidate phases: any future runtime-surface polish, Pi extension UX work, or `pals-hooks.ts` maintenance — exactly the shape Phase 168 originally had.
   - **Why this first:** A single natural non-CODI-development phase with TS in work-scope that shows (a) 0 unexpected files AND (b) blast_radius visibly consulted during APPLY — or that shows one of those is wrong — would resolve Q2 and either unlock SHIP or tighten the KILL case. Current evidence is bottlenecked on this signal shape, not on extractor coverage.
   - **Estimated effort:** 1 observation phase (piggybacks on whatever natural work is next); no CODI-source changes required.

2. **Optional pre-plan guidance that blast_radius should be consulted when present.**
   - **Goal:** Update `modules/codi/references/codi.md` (When CODI helps section) and optionally `kernel/workflows/plan-phase.md` prose so planners notice the injected Blast Radius during `<boundaries>` and `<tasks>` drafting rather than passing over it. This is a light wording change, not a new mechanic.
   - **Rationale:** TRIAL-DATA Observation 2 flags that the causal chain from blast_radius to APPLY quality is still indirect. Wording guidance that nudges planner attention toward the injected facts might produce a Signal 1 or Signal 2 live effect on the next TS-touching phase without changing any module or runtime code.
   - **Estimated effort:** co-shipped with Task 1 or packaged as a bounded docs-only phase.

3. **Cross-repo trial preparation (only if Task 1 does not surface a natural TS implementation phase within a reasonable window).**
   - **Goal:** Document the minimal setup for running CODI on a second repo (codegraph index presence, install-time recommendation behavior, `<context>` source selector use). Capture as a reference doc only — not a v2.41 APPLY target unless Task 1 cannot run organically.
   - **Rationale:** Phase 173 already flagged cross-repo trials as out-of-scope unless v2.40's re-trial still leaves doubt. The doubt is now specifically Q2-shaped; cross-repo is the backup path if PALS itself does not produce the needed natural phase.
   - **Estimated effort:** 1 bounded docs-only phase if invoked.

**Recommended phase shape for v2.41 (subject to `/paul:plan` refinement during milestone transition):**
- Phase 178 — Natural-scope TS implementation observation (piggybacks on the next real TS-touching PALS phase; no CODI-source churn).
- Phase 179 — Optional pre-plan guidance wording (Task 2).
- Phase 180 — Re-trial + gating decision (the v2.41 version of Phase 177, reusing the same unchanged rubric).

Out of scope for ITERATE_V0_1 (carried forward from Phase 173's deferred list):
- `symbol_graph` integration (v0.2 — gated by next re-trial's verdict).
- `trace` integration (v0.3).
- PLAN.md template `<impact>` / `<dependencies>` / `<runtime_paths>` formalization (v0.4).
- Lifecycle expansion to other CODI hooks (v0.5+).
- Cross-repo trials (deferred behind the natural-scope test above).

---

## Lifecycle follow-up patches (applied in Task 3)

These patches are applied IN this same task per AC-4. UNIFY verifies they match these staged diffs but does not re-apply.

### Patch 1: `.paul/PROJECT.md` Active Requirements

Update the v2.40 CODI lineage line to mark the milestone complete with the Phase 177 verdict.

- Target: the `- ✓ CODI install-time detection + value-envelope docs + format fix …` line (currently the most recent CODI-lineage bullet under `## Requirements / ### Active` / `### Validated`).
- Action: append a new bullet marking v2.40 complete with verdict ITERATE_V0_1 and pointing to `177-01-DECISION.md`.

### Patch 2: `.paul/ROADMAP.md` Phase 177 row + Current Milestone + Next Milestone

- Update the Phase 177 row from `Planning` / `-` to `✅ Complete` / `2026-04-18`.
- Update the `## Current Milestone` block: `Phases: 3 of 4 complete` → `Phases: 4 of 4 complete`, and mark the milestone complete with its verdict.
- Replace the conditional `## Next Milestone` block with the concrete ITERATE_V0_1 next-milestone scope (v2.41 — natural-scope evidence & Signal-1/2 validation).
- Move the v2.40 milestone entry into `## Completed Milestones` as the new top entry, in the same collapsible `<details>` shape as v2.39.

### Patch 3: `.paul/STATE.md` Decisions table + Current Position + Git State

- Append a 2026-04-18 decision row recording the verdict and gate computation.
- Update `## Current Position` to mark Phase 177 post-APPLY with the verdict.
- Lifecycle bookkeeping surfaces only — no CODI/module/runtime/validation source edits.

Patches applied inline in the Task 3 `<action>` execution below.
