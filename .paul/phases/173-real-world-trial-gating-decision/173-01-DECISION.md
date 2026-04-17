---
phase: 173-real-world-trial-gating-decision
plan: 01
artifact: DECISION
created: 2026-04-17
binds: v2.39 CODI v0.1 — ship/iterate/kill
trial_evidence: 173-01-TRIAL-DATA.md
---

# CODI v0.1 Gating Decision

This artifact is the binding verdict for the v2.39 CODI v0.1 milestone. It is derived mechanically from the evidence in `173-01-TRIAL-DATA.md` by applying the decision rule stated below, then to the structured 3-question checklist, then to the per-signal recap. **The decision rule is stated before any score is read.**

---

## Decision rule (stated upfront)

Variables:
- `S_pass_nonnull` = number of signals 1–4 scored ≥ partial restricted to non-CODI_NULL evidence per AC-2 of the PLAN. Counts `projected-pass` on counterfactual sub-comparisons as +1 toward signals 1, 2, 4 when the live row was not-applicable.
- `S_pass_signal3` = signal 3's score (live + counterfactual sub-comparison).

Rule:
1. **SHIP_V0_2** requires Q3=yes AND Q2=yes AND `S_pass_nonnull ≥ 3`.
2. **KILL** requires Q3=no AND Q2=no AND `S_pass_nonnull ≤ 1` AND `S_pass_signal3 = fail`.
3. **ITERATE_V0_1** in all other cases (explicit fallback, including all borderline scenarios).
4. **Tie-breaker**: if SHIP_V0_2 and ITERATE_V0_1 both qualify under literal reading of the gates, prefer ITERATE_V0_1 (lower-risk choice; SHIP requires unambiguous yes on Q2+Q3).

This rule is binding for this verdict. It is not edited below.

---

## Structured 3-question cross-cutting checklist

### Q1: Does the trial sample include sufficient non-CODI-null evidence to score CODI's value?

**Cited evidence:**
- Sessions A, B, C, D (live) are all CODI_NULL=true (TRIAL-DATA Sessions A–D rows; cross-cutting observation 1).
- Session E (counterfactual) is CODI_NULL=false (TRIAL-DATA Session E Step 5 marker).
- Total non-CODI_NULL rows: **1** (counterfactual only). The AC-1 threshold says "Yes if ≥ 1 non-CODI_NULL row exists; no if 0; uncertain only if Session E's extractor produced fewer symbols than expected and resolution is ambiguous."
- Session E extractor produced 6 symbol candidates; 4 resolved with call-sites, 1 resolved-but-empty, 1 unresolved. The resolution is **not ambiguous** (4/6 = 67% resolved).

**Answer: yes** — but with a strong caveat that the only non-CODI_NULL evidence is counterfactual. The trial set has 0 live CODI-active rows, which is an honesty constraint on Q2's confidence.

### Q2: When CODI does fire on indexed code (counterfactual evidence), does the blast-radius materially shape what a careful planner would write?

**Cited evidence (per AC-2 threshold "Yes if ≥ 2 of 4 signals had projected-pass; no if 0; uncertain if 1"):**
- Signal 1 counterfactual addition: "moderate value — the resolved blast_radius provides verification, not surprise prevention, in this specific case because Phase 168 was already correctly scoped to one file." → **not projected-pass.**
- Signal 2 counterfactual addition: "Limited yes... The blast_radius would have been visible context for the planner when writing `<boundaries>` — see Signal 3 — but APPLY did not need it. Different scope (e.g., a refactor across multiple call sites of `renderLifecycleStatus`) would benefit more." → **not projected-pass.**
- Signal 3 counterfactual sub-comparison: "**Projected score: projected-pass** for the counterfactual case. CODI-active TS scopes can plausibly add 10–25% to boundary specificity above the existing planner-discipline baseline. This is the strongest evidence for CODI's value envelope in the entire dataset." → **projected-pass.**
- Signal 4 counterfactual addition: "**Projected score: not-applicable** for the counterfactual case." → **not projected-pass.**

Projected-pass count: **1 of 4** (Signal 3 only).

**Answer: uncertain** — the counterfactual demonstrates a real but bounded value envelope. CODI's contribution to `<boundaries>` specificity is plausible and grounded in concrete blast-radius evidence, but it doesn't materially shape Signals 1, 2, or 4 in the specific Phase 168 case examined. A different counterfactual (e.g., a refactor touching multiple call sites of `renderLifecycleStatus`) would likely score higher on Signals 1–2, but that wasn't the trial scope.

### Q3: Is the cost of carrying CODI v0.1 (manifest + extractor rules + plan-phase seed coupling + default-on config + validation markers) justified by the value envelope identified in Q1+Q2?

**Cited evidence:**
- Carrying-cost surface (from PLAN's `<boundaries>` DO NOT CHANGE list):
  - `modules/codi/module.yaml` — 99 lines (after Phase 171)
  - `modules/codi/references/codi.md` — 124 lines
  - Plan-phase seed coupling in `kernel/workflows/plan-phase.md` — bounded prepare_codi_seed_candidates step (added Phase 172)
  - Default-on `pals.json` `modules.codi` block — 2-line registration
  - Validation markers in `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` — bounded semantic checks added in Phase 172
  - Total carrying-cost surface: **bounded, ~225 lines of module surface + a handful of validation/coupling markers**. The surface is small relative to the kernel and existing modules.
- Q1=yes (with caveat), Q2=uncertain.
- Value envelope identified: CODI demonstrably contributes to `<boundaries>` specificity on TS-touching scope (Signal 3 counterfactual projected-pass with 10–25% specificity gain). It does not yet demonstrate value on Signals 1, 2, 4 in the specific counterfactual examined, and live PALS planning (which is dominantly markdown-layer in v2.39) gets zero value from it.
- Cross-cutting observation 3: Phase 172's prose-heavy seed coupling did not improve hit-rate. The fix may be in the wrong layer — extracting from PLAN-referenced source files (Phase 168's `<context>`) would have given CODI direct TS symbol access. This is an iteration target, not a dealbreaker.
- Cross-cutting observation 5: empirical probing during PLAN partially substitutes for what CODI would inject. CODI's marginal value is highest precisely when the planner skips manual probing — making CODI value-additive even when the planner already does some probing.

**Answer: yes (qualified)** — the carrying cost is bounded, the surface is well-isolated (one module, registry-driven, zero kernel/installer code changes per Phase 170's pattern), and there is concrete projected-pass evidence on at least one signal (Signal 3) for the counterfactual case. The value envelope is narrower than originally hoped (Signals 1, 2, 4 do not demonstrate value in the trial), but the cost is also smaller than originally anticipated. Net: justified. (Borderline; would be "no" if the carrying cost were larger or if Signal 3's counterfactual projection were not at projected-pass.)

---

## Per-signal score recap

(Source: `173-01-TRIAL-DATA.md` Signal Scoring section.)

| Signal | Live score | Counterfactual projection | Combined evidence |
|---|---|---|---|
| 1 — Fewer unexpected files in APPLY | not-applicable (0 non-CODI_NULL live rows) | moderate value (verification, not surprise prevention) | weak — no live evidence; counterfactual sub-pass only |
| 2 — Drop in mid-APPLY codegraph calls | not-applicable | limited yes; would benefit different scope more | weak — no live evidence; counterfactual sub-pass only |
| 3 — More specific `<boundaries>` | pass (structural; CAUSATION CAVEAT — attributable to planner discipline, not CODI injection) | projected-pass (CODI-active TS scopes plausibly +10–25% specificity) | **strongest** — projected-pass on counterfactual is grounded in 4 resolved-with-call-sites symbols |
| 4 — No need for understand/verify brokers | not-applicable | not-applicable (no brokers in counterfactual) | weak — no broker substitution observed live or counterfactually |

**`S_pass_nonnull` calculation per the decision rule:**
- Signal 1: counterfactual = "moderate value", does NOT meet `projected-pass` threshold → 0
- Signal 2: counterfactual = "limited yes", does NOT meet `projected-pass` threshold → 0
- Signal 3: live = pass, but pass is on the live CODI_NULL=true sample with explicit causation caveat. Per AC-2, signal 3 includes all rows. Counterfactual sub-comparison = projected-pass → counts as 1.
- Signal 4: counterfactual = not-applicable → 0

**`S_pass_nonnull` = 1**.

**`S_pass_signal3` = pass** (with causation caveat).

---

## Verdict

Mechanical computation per the section-1 decision rule:

- Q1 = yes (with caveat: only counterfactual non-CODI_NULL evidence exists)
- Q2 = uncertain (1 of 4 projected-pass)
- Q3 = yes (qualified)
- `S_pass_nonnull` = 1
- `S_pass_signal3` = pass

Apply rules:
- **SHIP_V0_2 gate:** requires Q3=yes AND Q2=yes AND `S_pass_nonnull ≥ 3`. Q2=uncertain (not yes), `S_pass_nonnull` = 1 (not ≥ 3). **Gate fails on TWO conditions.** SHIP not selected.
- **KILL gate:** requires Q3=no AND Q2=no AND `S_pass_nonnull ≤ 1` AND `S_pass_signal3 = fail`. Q3=yes (not no), Q2=uncertain (not no), `S_pass_signal3` = pass (not fail). **Gate fails on THREE conditions.** KILL not selected.
- **ITERATE_V0_1**: explicit fallback for all other cases. **Selected.**
- Tie-breaker: not triggered (SHIP and ITERATE do not both qualify; only ITERATE qualifies).

# Verdict: **ITERATE_V0_1**

The trial demonstrates that CODI v0.1 has a real but bounded value envelope: it can plausibly improve `<boundaries>` specificity on TS-touching scope by 10–25% above the planner-discipline baseline. It does not yet demonstrate value on the other three success signals in the trial sample, and the live PALS planning sample (dominantly markdown-layer in v2.39) is uniformly CODI_NULL — meaning the seed coupling shipped in Phase 172 did not produce usable structural facts for any live planning run.

The carrying cost is bounded (~225 lines of module surface, registry-driven, zero kernel/installer code), making continued investment justified. But the value envelope is narrower than originally hoped, so the next milestone should iterate on extractor-vs-scope alignment before stacking v0.2's `symbol_graph` on top.

---

## Verdict-specific scope

### SHIP_V0_2 scope — **NOT SELECTED**

(Rationale: SHIP requires Q2=yes AND `S_pass_nonnull ≥ 3`. The trial achieved Q2=uncertain and `S_pass_nonnull` = 1. Stacking `symbol_graph` on top of an extractor that demonstrably misses the right symbols on prose-heavy scope would compound the wrong-layer problem identified in cross-cutting observation 3. Defer until ITERATE_V0_1 closes the extractor gap.)

### KILL scope — **NOT SELECTED**

(Rationale: Signal 3's counterfactual projected-pass and Q3=yes (qualified) both block the kill path. The carrying cost is small and well-isolated; abandoning the module on a counterfactual-confirmed value envelope would be premature. The thesis "pre-plan structural injection improves PLAN quality" is partially confirmed for TS-touching scope on indexed code — that's not a thesis failure, it's a scope-coverage problem.)

### ITERATE_V0_1 scope — **SELECTED**

Numbered iteration tasks for the next milestone (proposed v2.40 — "CODI v0.1 — Extractor & Coverage Iteration"):

1. **Extract from PLAN-referenced source files, not just from prose.**
   - **Files:** `modules/codi/module.yaml` (manifest description Step 1), `modules/codi/references/codi.md` (Symbol Extraction Rules section), `kernel/workflows/plan-phase.md` (`prepare_codi_seed_candidates` step from Phase 172).
   - **Rationale:** Cross-cutting observation 3 establishes that the v0.1 extractor pulls markdown-layer identifiers from prose-heavy plan text but cannot reach the codegraph-indexed TS symbols inside the source files the plan references in `<context>`. Phase 168's PLAN listed `drivers/pi/extensions/pals-hooks.ts` as a source-file path; an extractor that scanned that file for top-level symbol declarations (functions, classes, exports) and seeded those into `impact` would have produced exactly the Session E counterfactual hit rate (4 resolved-with-call-sites). Adding source-file symbol extraction would convert at least Session D (and likely future TS-touching live sessions) from CODI_NULL=true to CODI_NULL=false. **This is the highest-leverage iteration.**
   - **Estimated effort:** 1 phase (extractor rule update + reference doc + manifest description + validation markers).

2. **Install-time codegraph-availability detection so default-on becomes "default-on when applicable."**
   - **Files:** `drivers/pi/install.sh` (or a new probe step), `pals.json` schema in `kernel/references/pals-json-schema.md`, `modules/codi/references/codi.md` (Codegraph Tool Dependency section).
   - **Rationale:** v0.1's default-on stance is honest only because the safe-skip path is first-class. But on repos without a codegraph index at all, every plan dispatch hits the tool-unavailable skip path with no diagnostic value. Detecting codegraph availability at install time and surfacing a one-line config recommendation ("CODI is enabled but no codegraph index detected — see modules/codi/references/codi.md for setup") would reduce the noise floor for users on non-indexed repos.
   - **Estimated effort:** 1 phase (probe + schema doc + install message).

3. **Reference-doc clarification of CODI's value envelope.**
   - **Files:** `modules/codi/references/codi.md` (new "When CODI helps" section), `README.md` (CODI overview).
   - **Rationale:** The trial established that CODI's value envelope is bounded by extractor-vs-scope alignment. Users should understand up-front that CODI is most valuable for plans touching typed code in indexed repos, and is mostly silent on plans touching markdown/config/workflow surfaces. Setting expectations honestly will reduce disappointment with skip dispatches and direct usage toward where CODI pays off.
   - **Estimated effort:** 1 phase (or co-shipped with Task 1 above).

4. **Resolve the success-log resolved-count format ambiguity.**
   - **Files:** `modules/codi/module.yaml` (manifest description Step 6), `modules/codi/references/codi.md` (matching format spec).
   - **Rationale:** Cross-cutting observation 6 documents that the manifest's `R resolved, U unresolved, K total call-sites` format does not specify whether R counts resolved-but-empty rows. Pin the convention explicitly (recommend: R = resolved-with-call-sites only; resolved-but-empty rows are reported separately in K-style total-callsite count) so future Session-E-shaped synthesis is unambiguous.
   - **Estimated effort:** trivial (10-line manifest patch + matching reference-doc note); could be grouped with Task 1 or 3.

5. **Instrumentation for dispatch-outcome distribution visibility across phases.**
   - **Files:** `kernel/workflows/unify-phase.md` or a new bounded summary surface; possibly `.paul/quality-history.md` or a new CODI-specific tally.
   - **Rationale:** Phase 173 had to manually reconstruct the CODI dispatch outcomes for 4 sessions by reading PLAN/SUMMARY artifacts one at a time. A small post-unify tally (per-phase: dispatch outcome category, resolved/unresolved counts, blast_radius injected y/n) would let future trials measure CODI's contribution at scale without reconstruction work. Lightweight; one row per phase appended to a tally file.
   - **Estimated effort:** 1 phase, or could be partially shipped alongside Task 1.

**Recommended phase shape for v2.40:**
- Phase 174: Source-file symbol extraction (Task 1) — the high-leverage iteration.
- Phase 175: Install-time detection + value-envelope docs + format ambiguity (Tasks 2 + 3 + 4) — bundled docs/install pass.
- Phase 176: Dispatch-outcome instrumentation (Task 5).
- Phase 177: Re-trial against new live PALS phases (the v2.40 version of Phase 173) to validate the iteration before considering v0.2.

Out of scope for ITERATE_V0_1:
- `symbol_graph` integration (v0.2 — gated by re-trial outcome).
- `trace` integration (v0.3).
- PLAN.md template `<impact>` / `<dependencies>` / `<runtime_paths>` formalization (v0.4 — gated by v0.2 outcomes).
- Lifecycle expansion to other hooks (v0.5+).
- Cross-repo trials (would belong to a downstream phase if v2.40's re-trial still leaves doubt).

---

## Lifecycle follow-up patches (staged for application in Task 4)

These patches are applied IN this same task (per AC-4 and the UNIFY-semantics note in the PLAN). UNIFY verifies they match these staged diffs but does not re-apply.

### Patch 1: `.paul/PROJECT.md` Active Requirements

Update the v2.39 CODI line from `[~]` (in progress) to `[x]` and append the verdict marker.

**Find (line ≈45 of PROJECT.md, the `- [~] CODI module (v0.1 live integration)` line):**
```
- [~] CODI module (v0.1 live integration) — registry-discovered pre-plan advisory overlay at priority 220; Phase 170 shipped hello-world scaffolding; Phase 171 upgraded to live `impact` integration with per-symbol call pattern, 5-outcome categorization, partial-success invariant, and call-time failure handling; Phase 172 shipped plan-phase coupling/default-on distribution; real-world trial and gating decision remain in Phase 173 (v2.39 in progress)
```

**Replace with:**
```
- [x] CODI module (v0.1) — registry-discovered pre-plan advisory overlay at priority 220 across Phases 170–172 (hello-world scaffolding → live `impact` integration → plan-phase coupling/default-on distribution); Phase 173 trial verdict: **ITERATE_V0_1** — Signal 3 projected-pass on TS-touching counterfactual; live PALS sample uniformly CODI_NULL; v2.40 iterates on source-file symbol extraction before considering v0.2 (verdict and full evidence in `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md`)
```

### Patch 2: `.paul/ROADMAP.md` Phase 173 row + Next Milestone

Update the Phase 173 row in the v2.39 milestone table from `Not started` to `✅ Complete | 2026-04-17`, and replace the conditional Next Milestone wording.

**Find:**
```
| 173 | Real-World Trial & Gating Decision | TBD | Not started | - |
```

**Replace with:**
```
| 173 | Real-World Trial & Gating Decision | 1 (`173-01`) | ✅ Complete | 2026-04-17 |
```

(Note: this row was already updated by /paul-plan to `🟡 Planning | -` — the patch should target whichever wording is currently present.)

**Find (Next Milestone block):**
```
## Next Milestone
TBD after v2.39 completion. Candidate directions (gated on v0.1 results):
- **v0.2** — add `symbol_graph` for upstream dependency context
- **v0.3** — conditional `trace` for runtime-behavior plans
- **v0.4** — formalize `<impact>` / `<dependencies>` / `<runtime_paths>` PLAN.md template sections
- **v0.5+** — CODI at other PALS hooks (pre-apply / post-task / pre-unify)
- Gate CODI module registration on `pi-codegraph` install detection (not just runtime skip).
```

**Replace with:**
```
## Next Milestone
**v2.40 CODI v0.1 — Extractor & Coverage Iteration** (selected by Phase 173 verdict ITERATE_V0_1; see `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md`).
Theme: Close the extractor-vs-scope alignment gap surfaced by Phase 173's trial — extract symbols from PLAN-referenced source files, not just from prose — then re-trial against new live PALS phases before considering v0.2.

Proposed phase shape (subject to /paul-plan refinement):
- Phase 174 — Source-file symbol extraction (high-leverage iteration)
- Phase 175 — Install-time codegraph detection + value-envelope docs + success-log format ambiguity fix
- Phase 176 — Dispatch-outcome instrumentation across phases
- Phase 177 — Re-trial + gating decision (the v2.40 version of Phase 173)

Deferred (gated on v2.40 re-trial outcome):
- v0.2 — add `symbol_graph` for upstream dependency context
- v0.3 — conditional `trace` for runtime-behavior plans
- v0.4 — formalize `<impact>` / `<dependencies>` / `<runtime_paths>` PLAN.md template sections
- v0.5+ — CODI at other PALS hooks (pre-apply / post-task / pre-unify)
- Cross-repo trials if v2.40 re-trial still leaves doubt about CODI's value envelope.
```

### Patch 3: `.paul/STATE.md` Decisions table

Append a 2026-04-17 entry recording the verdict and decision rule.

**Insert into the Decisions table (under `### Decisions`, alongside the existing 2026-04-17 entry from Phase 172):**

```
| 2026-04-17: Phase 173 verdict ITERATE_V0_1 — CODI v0.1 has bounded value envelope (Signal 3 projected-pass on TS-touching counterfactual), live PALS sample uniformly CODI_NULL; iterate on extractor-vs-scope alignment in v2.40 before considering v0.2 | 173 | Sets v2.40 milestone direction (source-file symbol extraction); defers symbol_graph/trace/template formalization until re-trial validates iteration |
```

Patches end. These are applied in Task 4 commits below.
