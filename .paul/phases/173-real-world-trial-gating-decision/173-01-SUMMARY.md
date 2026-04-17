---
phase: 173-real-world-trial-gating-decision
plan: 01
completed: 2026-04-17T03:30:00Z
duration: ~3 hours (PLAN with high-collab review + revision + APPLY + UNIFY, continuous session)
---

## Objective

Run CODI v0.1 against real PALS planning evidence already in the repo PLUS one TS-touching counterfactual scope, score it against the four v2.39 success signals with a CODI-null-aware rubric, and produce a binding ship-v0.2 / iterate-v0.1 / kill decision artifact gating all CODI follow-on work (`symbol_graph` v0.2, `trace` v0.3, PLAN.md template formalization v0.4, lifecycle expansion v0.5+).

## What Was Built

| File | Purpose | Lines |
|------|---------|-------|
| `.paul/phases/173-real-world-trial-gating-decision/173-01-TRIAL-DATA.md` | Read-only trial dataset: 4 live PALS planning sessions (170-01, 171-01, 172-01, 173-01-self) + 1 TS-touching counterfactual (Phase 168 scope dry-run), per-session CODI dispatch evidence with CODI_NULL marker, pre-CODI baseline `<boundaries>` corpus from phases 167+168, 4 signal scoring blocks with CODI-null down-weighting + counterfactual projections, 6 cross-cutting observations | 348 |
| `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md` | Binding gating verdict: decision rule stated upfront → structured 3-question checklist with cited evidence → per-signal score recap → mechanical verdict computation → ITERATE_V0_1 scope (5 numbered iteration tasks targeting v2.40) → lifecycle follow-up patches staged with provenance | 251 |

**Lifecycle artifacts updated as part of AC-4 patches applied in Task 4 (per the PLAN's UNIFY-semantics note):**

- `.paul/PROJECT.md` — v2.39 CODI Active Requirement: `[~]` → `[x]` with verdict marker.
- `.paul/ROADMAP.md` — Phase 173 row: `🟡 Planning | -` → `✅ Complete | 2026-04-17`; v2.39 milestone status: `🚧 In Progress` → `✅ Complete (4/4)`; Next Milestone: `TBD after v2.39 completion` → v2.40 scope with proposed phase shape (Phases 174–177).
- `.paul/STATE.md` — Decisions table gained 2026-04-17 ITERATE_V0_1 row.

**Plan revision during PLAN (not APPLY — pre-APPLY review-driven):**

- Original 3-task plan was reviewed pre-APPLY. Three concerns surfaced (rubric pre-determination, sample-set validity, CODI-null measuring planner-not-CODI).
- Empirical probing during plan revision (7 `impact` calls) reframed concern 2: codegraph DOES index PALS TypeScript (`palsHooks` resolved depth 3, fan-out 21).
- Plan was revised to 4 tasks (added Task 2: counterfactual probe), CODI_NULL marker added to AC-1, signal rubric made CODI-null-aware in AC-2, structured 3-question checklist added to AC-3, AC-4 patches moved from "deferred to UNIFY" to "applied in Task 4 with staged-diff provenance."
- This is the Phase 171 empirical-probing pattern operating as designed: ~7 tool calls during PLAN surfaced a structural finding (codegraph indexes PALS TS) that materially reshaped the trial design BEFORE APPLY started.

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | ≥4 PALS sessions + 1 TS-touching counterfactual session with per-session CODI dispatch evidence + CODI_NULL marker | ✅ PASS | TRIAL-DATA contains Sessions A–D (live, all CODI_NULL=true) + Session E (counterfactual, CODI_NULL=false). All 4 verbatim source-quote substrings present (`"hello-world"`, `"impact × N symbols →"`, `"no extractable symbols in phase scope"`, `"0 resolved, 4 unresolved"`). Pre-CODI baseline `<boundaries>` corpus from phases 167 + 168 included. Source PLAN.md and SUMMARY.md paths cited per row. |
| AC-2 | 4 success signals scored with CODI-null down-weighting + counterfactual projections | ✅ PASS | Signal Scoring section: 4 blocks (Signal 1–4) with rubric, Score line, Counterfactual addition/sub-comparison subsection per signal. Cross-cutting observations subsection (6 observations covering trial sample uniformity, structural reframing, seed-coupling effectiveness, trial setting calibration, empirical-probing pattern, format-ambiguity finding). |
| AC-3 | Binding verdict mechanically derived from structured 3-question checklist + decision rule | ✅ PASS | DECISION.md: Decision rule (line 16) precedes Verdict (line 98). Q1/Q2/Q3 each answered with cited evidence and threshold reasoning. Computation shown verbatim: "Q1=yes, Q2=uncertain, Q3=yes (qualified), `S_pass_nonnull`=1, `S_pass_signal3`=pass → SHIP gate fails on TWO conditions, KILL gate fails on THREE conditions, ITERATE_V0_1 = explicit fallback." Verdict line: `# Verdict: **ITERATE_V0_1**`. ITERATE_V0_1 scope subsection populated (43 lines: 5 numbered iteration tasks with file targets + rationale + estimated effort, plus recommended 4-phase shape for v2.40 and explicit deferred items). |
| AC-4 | Lifecycle patches APPLIED to PROJECT.md, ROADMAP.md, STATE.md with staged-diff provenance in DECISION.md | ✅ PASS | All three files modified per the staged diffs in DECISION.md section 6. PROJECT.md `[x] CODI module (v0.1)` line confirmed. ROADMAP.md Phase 173 row `✅ Complete | 2026-04-17` confirmed; v2.39 milestone status flipped to Complete; Next Milestone block replaced with v2.40 ITERATE_V0_1 scope. STATE.md Decisions table 2026-04-17 ITERATE_V0_1 row confirmed. |

## Verification Results

```text
=== Task 1 verify (build trial dataset) ===
(a) file non-empty: ✓
(b) sessions A-D: 4 (need 4)
(c) verbatim substrings present (4/4):
  "hello-world" ✓
  "impact × N symbols →" ✓
  "no extractable symbols in phase scope" ✓
  "0 resolved, 4 unresolved" ✓
(d) CODI_NULL markers in live session table cells: 4 (need ≥4)
(e) Pre-CODI baseline section present: ✓

=== Task 2 verify (counterfactual probe) ===
(a) Session E count: 1
(b) impact × dispatch line in synthesized log: ✓
(c) pals-hooks.ts in fenced code region (resolved evidence): ✓
(d) CODI_NULL: false in Session E: ✓
(e) literal "counterfactual — not a live PALS plan run" phrase: ✓

=== Task 3 verify (signal scoring) ===
(a) signals 1-4 count: 4
(b) Score: lines: 4 (one per signal)
(c+d) counterfactual subsections: 4 (one per signal)
(e) Cross-cutting observations section: ✓

=== Task 4 verify (decision artifact + AC-4 patches) ===
(a) Decision rule precedes Verdict: ✓ (line 16 < line 98)
(b) Q1-Q3 count: 3
(c) Verdict header: ✓
(d) Verdict locked to ITERATE_V0_1: ✓
(e) ITERATE_V0_1 scope subsection: 43 lines (need ≥5)
(f) PROJECT.md updated: ✓
(g) ROADMAP.md Phase 173 row: ✓
(h) STATE.md decisions row: ✓

=== WALT post-apply quality gate ===
tests/pi-end-to-end-validation.sh:   165/165 passing (no regressions)
tests/cross-harness-validation.sh:   69/69 passing (no regressions)
```

## Module Execution Reports

**PLAN phase:**
- `[dispatch] pre-plan advisory: ARCH(p75) → pass | TODD(p100) → skip (research/decision phase) | GABE(p175) → skip | DAVE(p200) → skip | DOCS(p200) → pass | OMAR(p205) → skip | REED(p210) → skip | VERA(p215) → skip | CODI(p220) → pre-plan advisory → impact × 4 symbols → 0 resolved, 4 unresolved, 0 total call-sites, injected blast_radius (extracted: impact, analyze_scope, pals-implementer, modules.codi — markdown-layer identifiers, all unresolved against codegraph) | PETE(p225) → skip | LUKE(p185) / ARIA(p190) / DANA(p195) → skip | RUBY(p250) → skip`
- `[dispatch] pre-plan enforcement: DEAN(p50) → pass (no deps) | SETH(p80) → pass (no source files in scope)`
- `[dispatch] post-plan: TODD(p100) → no modifications | 0 other modules registered`

**APPLY phase:**
- `[dispatch] pre-apply: TODD(p50) → skip (no source code in scope) | WALT(p100) → BASELINE (165/165 + 69/69 recorded as relevant validation surfaces)`
- `[dispatch] post-task (Task 1/2/3/4): TODD(p100) → skip (no test scope) ×4`
- `[dispatch] post-apply advisory: IRIS(p250) → PASS (no anti-patterns in research artifacts) | DOCS(p250) → 1 advisory annotation (PROJECT.md and ROADMAP.md updated as part of AC-4 patches; README.md not touched, but Phase 173 ships no code so no doc drift expected) | LUKE(p160) → skip | OMAR(p170) → skip | RUBY(p300) → skip (no source code for ESLint complexity) | SKIP(p300) → 1 decision candidate (verdict ITERATE_V0_1 with rationale)`
- `[dispatch] post-apply enforcement: WALT(p100) → PASS (165/165 + 69/69, exact parity with Phase 172 baseline; no regressions) | DEAN(p150) → skip (no deps) | TODD(p200) → skip (no test infra) | ARCH(p75) → PASS (no source layering changes; only research artifacts + lifecycle md edits) | SETH(p80) → PASS (no secrets) | ARIA/PETE/REED/VERA/GABE/DANA/DAVE → skip`

**UNIFY phase:**
- `[dispatch] pre-unify: 0 modules registered for this hook`
- `[dispatch] post-unify: WALT(p100) → 1 report / 1 side effect | SKIP(p200) → 1 report / 0 side effects | RUBY(p300) → 1 report / 0 side effects`

**Post-unify durable reports:**

- **WALT report:** Recorded Phase `173-01` in `.paul/quality-history.md` as `165 pass + 69 pass` for `pi-end-to-end-validation.sh + cross-harness-validation.sh`, coverage/lint/types `—` (no project test command), trend `→ stable` (exact parity with Phase 172 baseline; no new code shipped, no regression risk).
- **SKIP report:** Captured the Phase 173 verdict decision: "Phase 173 verdict ITERATE_V0_1 — CODI v0.1 has bounded value envelope (Signal 3 projected-pass on TS-touching counterfactual), live PALS sample uniformly CODI_NULL; iterate on extractor-vs-scope alignment in v2.40 before considering v0.2." Plus the structural reframing decision: "CODI's value envelope is bounded by extractor-vs-scope alignment, not repo type. The codegraph indexes PALS TypeScript with rich blast-radius; v0.1 extractor pulls markdown-layer identifiers from prose-heavy plan text. Fix is in extraction layer (source-file symbol extraction), not in seed-coupling layer (prose extraction)." Both already mirrored into STATE.md Decisions table.
- **RUBY report:** No code-complexity hotspot for refactoring in this phase (research artifacts only). Existing file-size debt remains visible in `kernel/workflows/init-project.md` (1039), `tests/pi-end-to-end-validation.sh` (1083), `tests/cross-harness-validation.sh` (664), `kernel/workflows/plan-phase.md` (365) — unchanged from Phase 172 RUBY report. Phase 173 added 599 lines of research artifacts (TRIAL-DATA + DECISION) under `.paul/phases/173-*/`; none are debt candidates (one-off retrospective documents, not maintained code).
- **Side effects:** WALT recorded quality-history entry for `173-01`.

## Deviations

- **None material.** All 4 tasks PASS on first attempt, 0 retries, 0 task-level deviations detected by the divergence check.
- **Plan revision occurred during PLAN, not APPLY.** Pre-APPLY review (user-requested) surfaced 3 concerns; planner responded with 7 empirical `impact` probes that reframed concern 2 and produced a 4-task plan (was 3). The revision is recorded in this SUMMARY's "What Was Built → Plan revision during PLAN" section. This is not an APPLY deviation; it is the Phase 171 empirical-probing pattern operating as designed.
- **AC-4 patches applied in Task 4 instead of UNIFY (intentional, per plan).** The PLAN explicitly moved AC-4 lifecycle patches into Task 4 with staged-diff provenance in DECISION.md, so UNIFY's role was reconciliation/verification rather than diff application. UNIFY confirmed the applied patches match the staged diffs (PROJECT/ROADMAP/STATE all show the expected changes). This is the documented departure from "lifecycle patches applied during UNIFY" semantics, with rationale in DECISION.md.
- **Plan listed `173-01-SUMMARY.md` in `files_modified` (this file).** Standard self-reference for UNIFY closure; no impact.

## Key Patterns / Decisions

- **CODI_NULL-aware signal scoring is what makes the trial verdict honest.** Without the CODI_NULL down-weighting in AC-2, Signal 3 would have scored a clean "pass" attributable to CODI when the underlying causation was almost entirely planner-discipline shift in v2.39. The CODI_NULL marker forces the rubric to acknowledge when a signal cannot be attributed to CODI's contribution. Worth carrying into any future module-trial phase: if your trial sample is mostly silent dispatches, score must explicitly down-weight or you're measuring something other than the module.

- **Counterfactual projection is the only way to score a value envelope when the live trial sample is uniformly CODI_NULL.** Phase 173 was at risk of being a defensible-but-meaningless ITERATE write-up if the rubric only used live evidence. The Session E counterfactual (Phase 168 scope dry-run) gave the trial concrete evidence that CODI does work as designed when it has the right inputs — that's what unblocked the Q3=yes (qualified) answer and prevented an unwarranted KILL drift. This pattern generalizes: when planning a trial, identify at least one counterfactual scope from existing repo history that exercises the module's best-case inputs.

- **Empirical probing during PLAN materially reshaped the trial.** The 7 `impact` probes during plan revision surfaced the structural finding that the codegraph indexes PALS TypeScript — which directly contradicted the original plan's framing ("markdown-heavy framework repo") and reshaped concern 2 from "non-representative repo" to "extractor-vs-scope alignment problem." That reframing is the difference between a verdict that says "CODI doesn't fit PALS-like repos" and a verdict that says "CODI fits PALS-like repos but the extractor needs to read the right inputs." The latter is actionable; the former would have been wrong.

- **The fix for Phase 173's findings is in the extraction layer, not the seed-coupling layer.** Phase 172's prose-heavy seed coupling worked at the extraction layer (it extracted 4 symbols from Phase 173's prose) but the symbols extracted were the wrong ones (markdown-layer identifiers, not codegraph-indexed code). Source-file symbol extraction (read PLAN's `<context>` source-file list, parse for top-level declarations, seed those into `impact`) would have converted Session D from CODI_NULL=true to CODI_NULL=false. **This is the highest-leverage v2.40 iteration.**

- **CODI's value envelope is narrower but more honest than originally hoped.** SHIP gates failed on TWO conditions; KILL gates failed on THREE; ITERATE was the explicit fallback. The carrying cost (~225 lines of bounded module surface, registry-driven, zero kernel/installer code per Phase 170's pattern) is small enough that ITERATE is justified, but the value envelope is concrete and bounded: TS-touching scope on indexed code, with potential 10–25% gain on `<boundaries>` specificity. Users on markdown-heavy or non-indexed repos see ~zero value from CODI today; install-time codegraph detection (v2.40 Task 2) would surface this honestly instead of leaving every dispatch as a silent skip.

- **The success-log format ambiguity (Cross-cutting observation 6) is a genuine v0.1 documentation gap.** The manifest's `R resolved, U unresolved, K total call-sites` doesn't pin down whether R counts resolved-but-empty rows. Phase 173-01's own dispatch is unambiguous (R=0), but Session E's mixed outcome (4 resolved-with-call-sites + 1 resolved-but-empty + 1 unresolved) requires a convention. v2.40 Task 4 fixes this with a 10-line manifest patch.

- **Pre-APPLY review pattern works.** The user's "Any questions, concerns or gaps?" → planner critique → revision cycle is a high-leverage practice when verdict-shaped artifacts are about to be locked in. Three concerns surfaced; two of them (1 and 3) were rubric design issues that would have produced a defensible-but-meaningless verdict; one (concern 2) was a structural framing error that would have led to the wrong v2.40 scope. All three were caught BEFORE APPLY started, with zero wasted execution cycles.

## Skill Audit (Phase 173)

| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the trial+gating phase, including pre-APPLY review-driven plan revision |
| /carl | ✓ | Session-boundary routing remained active across the long planning + revision + apply + unify continuous session |
| TODD | ✓ | Pre-apply, post-task ×4, and post-apply dispatches all consulted and recorded skip decisions for this no-source-code research scope |
| WALT | ✓ | Pre-apply baseline + post-apply enforcement ran `tests/pi-end-to-end-validation.sh` (165/165) and `tests/cross-harness-validation.sh` (69/69) PASS, exact parity with Phase 172 baseline; quality history entry recorded during post-unify |

## Next Phase

**v2.39 milestone closes with this phase.** The verdict ITERATE_V0_1 selects v2.40 — *"CODI v0.1 — Extractor & Coverage Iteration"* — as the next milestone. Proposed phase shape (subject to /paul-plan refinement during v2.40 init):

- **Phase 174:** Source-file symbol extraction (the high-leverage iteration; converts Session-D-shaped scopes from CODI_NULL=true to CODI_NULL=false)
- **Phase 175:** Install-time codegraph detection + value-envelope docs + success-log format ambiguity fix (bundled docs/install pass)
- **Phase 176:** Dispatch-outcome instrumentation across phases (one-row-per-phase tally so future trials can measure CODI's contribution at scale without manual reconstruction)
- **Phase 177:** Re-trial + gating decision (the v2.40 version of Phase 173, validating whether the iteration converted the trial signals from "weak" to "strong" before considering v0.2)

Deferred until v2.40 re-trial:
- v0.2 — `symbol_graph` integration
- v0.3 — `trace` integration
- v0.4 — PLAN.md template `<impact>` / `<dependencies>` / `<runtime_paths>` formalization
- v0.5+ — CODI at other PALS hooks
- Cross-repo trials (only if v2.40 re-trial still leaves doubt)

Full evidence and rationale: `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md`.
