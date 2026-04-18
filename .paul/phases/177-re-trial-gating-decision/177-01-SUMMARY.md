---
phase: 177-re-trial-gating-decision
plan: 01
completed: 2026-04-18T00:00:00Z
duration: ~45 min (APPLY + UNIFY in the same session)
---

## Objective

Re-run the Phase 173 CODI v0.1 trial gate against the v2.40 evidence set (live Phase 175/176 rows from `.paul/CODI-HISTORY.md`, this Phase 177 planning run as a controlled live self-trial, and the Phase 168 TS-touching counterfactual reused from Phase 173), using the same unchanged decision rule and 3-question checklist, and decide SHIP_V0_2 / ITERATE_V0_1 / KILL.

## What Was Built

| File | Purpose | Lines |
|------|---------|-------|
| `.paul/phases/177-re-trial-gating-decision/177-01-TRIAL-DATA.md` | v2.40 re-trial evidence corpus — 4 sessions (A: 175-01 historically reconstructed live, B: 176-01 hook-written retrospective live, C: 177-01-self controlled live self-trial, D: Phase 168 counterfactual) with CODI_NULL markers, trial-integrity status, per-signal scoring, and explicit Phase 173 comparison | 324 |
| `.paul/phases/177-re-trial-gating-decision/177-01-DECISION.md` | Binding verdict — unchanged Phase 173 decision rule, 3-question checklist (Q1=yes, Q2=uncertain, Q3=yes-qualified), per-signal recap, verdict-specific scope for v2.41 | 211 |
| `.paul/PROJECT.md` | +1 bullet marking v2.40 complete with verdict ITERATE_V0_1 and pointer to `177-01-DECISION.md`; footer updated | +2 |
| `.paul/ROADMAP.md` | Phase 177 row → ✅ Complete 2026-04-18; Current Milestone replaced with v2.41 Natural-Scope Evidence & Signal-1/2 Validation; Next Milestone block rewritten with concrete v2.41 phase shape; v2.40 moved into Completed Milestones as a new `<details>` block; footer updated | +15 / -7 |
| `.paul/STATE.md` | +2 decision rows (verdict + Session C honesty rule); Current Position → APPLY complete; Loop Position → APPLY ✓; Session Continuity → next action /paul:unify (will be reconciled with the actual UNIFY completion in this same artifact) | +11 / -9 |

Note: `.paul/CODI-HISTORY.md` was intentionally left unchanged during APPLY (boundary constraint). The 177-01 row is appended by the CODI post-unify hook during this UNIFY (see Module Execution Reports below).

## Acceptance Criteria Results

| AC | Description | Status |
|----|-------------|--------|
| AC-1 | The re-trial dataset captures the complete v2.40 evidence set with transparent trial-integrity and self-trial labeling | ✓ PASS — 4 sessions present (`175-01`, `176-01`, `177-01-self`, Phase 168 counterfactual); each row cites PLAN/SUMMARY paths, `.paul/CODI-HISTORY.md` row when present, dispatch outcome category, extracted symbols, R/U/K, blast_radius status, declared-vs-actual file counts, `<boundaries>` evidence, evidence class, and `CODI_NULL` marker; machine-readable line-start `CODI_NULL:` / `Trial integrity:` markers present for each session; Session C labeled `controlled live self-trial` throughout; `.paul/CODI-HISTORY.md` remained read-only during APPLY |
| AC-2 | The four signals are re-scored with the unchanged Phase 173 rubric and explicitly compared against the Phase 173 baseline | ✓ PASS — all four signals scored; `S_pass_nonnull` and `S_pass_signal3` computed explicitly; 4 evidence classes distinguished (historically reconstructed live, hook-written retrospective live, controlled live self-trial, counterfactual); Session C capped at `partial` contribution on Signal 1 / Signal 4 per the honesty rule; Comparison to Phase 173 section states explicit improvements (Signals 1, 2, 3) and unchanged Signal 4; remaining weaknesses enumerated |
| AC-3 | The binding verdict reuses the same Phase 173 decision rule and 3-question checklist | ✓ PASS — `## Decision rule` restated verbatim from Phase 173 §1; Q1/Q2/Q3 answered with cited evidence; mechanical gate computation present (`Q1=yes, Q2=uncertain, Q3=yes-qualified, S_pass_nonnull=3, S_pass_signal3=pass`); verdict **ITERATE_V0_1** declared; verdict-specific scope non-empty with concrete v2.41 phase shape |
| AC-4 | Lifecycle artifacts reflect the verdict and v2.40 closure without reopening module/runtime scope | ✓ PASS — `.paul/PROJECT.md`, `.paul/ROADMAP.md`, `.paul/STATE.md` all reflect the verdict; `.paul/ROADMAP.md` replaced the conditional `TBD after v2.40 completion` Next Milestone block with the concrete ITERATE_V0_1 scope; `.paul/STATE.md` gained 2026-04-18 decision rows; no repo-source CODI/module/runtime/validation files modified (verified via `git diff --name-only main..HEAD` showing only `.paul/*` paths) |

All 4 ACs satisfied.

## Verification Results

| Command | Result |
|---------|--------|
| `test -s 177-01-TRIAL-DATA.md && grep -c "^### Session " = 4 && grep -Fq '175-01' && grep -Fq '176-01' && grep -Fq '177-01-self' && grep -Fq 'controlled live self-trial' && grep -Fq 'Phase 168' && grep -c '^CODI_NULL:' ≥ 4 && grep -c '^Trial integrity:' ≥ 4` | Pass (Task 1) |
| `grep -c '^### Signal [1-4]' = 4 && grep -Fq 'S_pass_nonnull' && grep -Fq 'S_pass_signal3' && grep -Fq 'Comparison to Phase 173' && grep -Fq 'controlled live self-trial'` | Pass (Task 2) |
| `grep -E '^## Decision rule' 177-01-DECISION.md && grep -cE '^### Q[1-3]' = 3 && grep -E '^# Verdict: \*\*(SHIP_V0_2\|ITERATE_V0_1\|KILL)\*\*$' && grep -Fq 'Phase 177' .paul/ROADMAP.md && grep -Fq '2026-04-18' .paul/STATE.md` | Pass (Task 3) |
| `bash tests/pi-end-to-end-validation.sh` | Pass — 172/172 checks (unchanged from pre-apply baseline) |
| `bash tests/cross-harness-validation.sh` | Pass — 75/75 checks (unchanged from pre-apply baseline) |
| `git diff --name-only main..HEAD` | Only `.paul/*` paths present (`PROJECT.md`, `ROADMAP.md`, `STATE.md`, `phases/177-re-trial-gating-decision/*`); no repo-source CODI/module/runtime/validation files touched |

## Module Execution Reports

### Pre-apply baseline (APPLY phase)
- `[dispatch] pre-apply: TODD(50) → skip (research/decision phase; no RED/GREEN task surface; explicit `<verify>` commands replace test gates per plan) | WALT(100) → baseline recorded (pi-end-to-end 172/172, cross-harness 75/75)`

### Post-task enforcement (APPLY phase)
- `[dispatch] post-task(Task 1): TODD(100) → skip (no test infra)`
- `[dispatch] post-task(Task 2): TODD(100) → skip (no test infra)`
- `[dispatch] post-task(Task 3): TODD(100) → skip (no test infra; shell validation suites serve as gates and both pass)`

### Post-apply advisory (APPLY phase)
- `[dispatch] post-apply advisory: IRIS(250) → 0 annotations (no TODO/FIXME/HACK/XXX markers in changed `.paul/*` research artifacts) | DOCS(250) → pass (DECISION.md cross-links TRIAL-DATA; PROJECT.md / ROADMAP.md / STATE.md all received lifecycle patches) | RUBY(300) → 0 annotations (new artifacts 324 + 211 lines; well under module-ref cap; ESLint complexity n/a for research prose) | SKIP(300) → 2 decisions captured (v2.40 re-trial verdict ITERATE_V0_1; Session C honesty rule)`

### Post-apply enforcement (APPLY phase)
- `[dispatch] post-apply enforcement: WALT(100) → PASS (pi-end-to-end 172/172; cross-harness 75/75; zero regressions vs pre-apply baseline; additive delta 0 since no source-code changes in research/decision phase) | DEAN(150) → skip (no dependency manifest changes) | TODD(200) → skip (no standard test command)`

### Pre-unify (UNIFY phase)
- `[dispatch] pre-unify: 0 modules registered for this hook`

### Post-unify (UNIFY phase)
- `[dispatch] post-unify: WALT(100) → 1 quality-history row appended (177-01 → stable, 172 pass + 75 pass, zero regressions; trend: stable from Phase 176's 172 pass + 75 pass baseline — research/decision phase changed no validation surfaces) | SKIP(200) → 2 decision records captured in SUMMARY Module Execution Reports (see below) | CODI(220) → appended injected row for 177-01 (second hook-triggered CODI-HISTORY.md write; STEP 2 matched success-log `impact × 4 symbols → 4 resolved, 0 unresolved, 10 total call-sites, injected blast_radius` in PLAN.md `<module_dispatch>`; STEP 4 categorized outcome as `injected`; STEP 5 extracted R=4, U=0, K=10, Symbols=renderCompactLoopSummary, renderLifecycleStatus, syncLifecycleUi, renderLoopBadge, blast_radius=y; STEP 6 appended `| 177-01 | 2026-04-18 | injected | 4 | 0 | 10 | renderCompactLoopSummary, renderLifecycleStatus, syncLifecycleUi, renderLoopBadge | y |`; STEP 7 emitted `[dispatch] CODI post-unify: appended injected row for 177-01`) | RUBY(300) → 0 refactor candidates (research/decision artifacts, no code surface)`

### SKIP knowledge records (captured during post-apply advisory and post-unify)

#### Decision Record 1

## [2026-04-18] v2.40 CODI v0.1 re-trial verdict — ITERATE_V0_1

**Type:** decision
**Phase:** 177 — Re-Trial + Gating Decision
**Related:** `.paul/phases/177-re-trial-gating-decision/177-01-DECISION.md`, `177-01-TRIAL-DATA.md`, `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md`

**Context:** Phase 173 verdict ITERATE_V0_1 selected v2.40's iteration theme (extractor-vs-scope alignment). Phases 174–176 shipped the iteration (source-file selector extractor, install-time heuristic + honest envelope docs, post-unify `CODI-HISTORY.md`). Phase 177 is the honesty checkpoint for that iteration.

**Decision:** ITERATE_V0_1 again. `S_pass_nonnull` improved from 1 → 3 (first time mechanically crossing the SHIP threshold), Signal 3 continues to clear on live + counterfactual projected-pass, but SHIP gate fails on Q2=uncertain because only Signal 3 reaches projected-pass. Signals 1/2 are live-partial but not projected-pass.

**Alternatives considered:**
- SHIP_V0_2 — rejected: Q2=uncertain under the unchanged Phase 173 threshold. Stacking `symbol_graph` on top before causal isolation of Signal 1/2 would compound the indirect-causal-chain problem TRIAL-DATA Observation 2 flags.
- KILL — rejected: Signal 3 still clears and `S_pass_nonnull` actually improved. Three of four KILL conditions clearly false; the fourth (`S_pass_signal3 = fail`) is explicitly refuted.

**Rationale:** v2.40 delivered on Phase 173's iteration theme; live non-null CODI rows now exist and dispatch-outcome measurement is automated. The remaining gap is a natural-scope TS implementation phase whose `files_modified` actually consumes the injected blast_radius during APPLY — which the re-trial could not provide because v2.40's four phases were all CODI-development-lineage.

**Impact:** Sets v2.41 direction (natural-scope TS implementation evidence for Q2 validation); defers `symbol_graph`, `trace`, PLAN-template formalization, cross-repo trials until the next re-trial closes Q2. Preserves the unchanged Phase 173 rubric as the stable gate across v2.39 → v2.40 → v2.41.

#### Decision Record 2

## [2026-04-18] Session C honesty rule — controlled live self-trial caps

**Type:** decision
**Phase:** 177 — Re-Trial + Gating Decision
**Related:** `177-01-TRIAL-DATA.md` Session C, Signal Scoring

**Context:** Phase 177 PLAN intentionally carried `drivers/pi/extensions/pals-hooks.ts` as read-only evidence and named four TS symbols in its objective so the v2.40 extractor would resolve them, yielding a controlled non-null live row. Without explicit handling, this would have let the re-trial self-fulfill its SHIP threshold.

**Decision:** Session C counts as live for overall non-CODI_NULL tallies but caps at `partial` contribution on Signal 1 and Signal 4, and is interpretation-only for Signal 2. Strongest allowed use is Q2 / value-envelope support. The final verdict is supportable from Session A (natural historically-reconstructed live) alone; Session C provides interpretive reinforcement without being the load-bearing evidence.

**Alternatives considered:**
- Let Session C count fully — rejected: would inflate `S_pass_nonnull` with a test-controlled row.
- Exclude Session C entirely — rejected: hides that v2.40's extractor does produce non-null injections when TS paths are in `<context>`, which is genuinely valuable evidence.

**Rationale:** Honest labeling beats suppression.

**Impact:** Future re-trial frameworks should preserve the same labeling discipline — controlled evidence counts transparently with explicit caps rather than being laundered into broad live proof.

### WALT (post-unify)

| Metric | Before (175/176 baseline) | After (177) | Delta | Trajectory |
|--------|---------------------------|-------------|-------|------------|
| Tests passing | 172 pass + 75 pass | 172 pass + 75 pass | 0 | → stable |
| Coverage | — | — | — | — |
| Lint issues | — | — | — | — |
| Type errors | — | — | — | — |

**Overall:** → stable (research/decision phase; no code surface touched)

Side effect: append `177-01 | 2026-04-18 | 172 pass + 75 pass | — | — | — | → stable` to `.paul/QUALITY-HISTORY.md` (expected by WALT post-unify hook).

### CODI (post-unify)

Side effect: appended `| 177-01 | 2026-04-18 | injected | 4 | 0 | 10 | renderCompactLoopSummary, renderLifecycleStatus, syncLifecycleUi, renderLoopBadge | y |` to `.paul/CODI-HISTORY.md` (third row; first hook-written `injected` row; matches the success-log present in this phase's PLAN `<module_dispatch>`).

## Skill Audit

| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the v2.40 re-trial/gating decision phase |
| /carl | ✓ | Session-boundary routing remained active via installed Pi runtime |
| TODD | N/A | Declared n/a in PLAN `<skills>` — research/decision phase with no implementation/test-first surface; explicit `<verify>` commands per task and both validation suites replaced test gates (same pattern as Phases 172, 173, 175, 176) |
| WALT | ✓ | Pre-apply baseline recorded (172/172 pi-e2e + 75/75 cross-harness); post-apply enforcement passed with zero regressions; post-unify quality-history row appended |

All required skills invoked (TODD declared n/a in PLAN by design).

## Deviations

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None |
| Scope additions | 0 | None |
| Deferred | 0 | None |

**Total impact:** Plan executed exactly as written. One small inline reconciliation: Task 1's plan text prescribed a per-session summary block, and the actual file adds an explicit "Machine-readable session summary" section at the end so the AC-1 verify regex (`^CODI_NULL:`, `^Trial integrity:`) could match line-starts cleanly alongside the table-embedded markers. This is a bounded presentation choice, not a content deviation, and the 4-session coverage, labeling, and trial-integrity requirements all landed as specified.

## Key Patterns / Decisions

- **Unchanged rubric across iterations.** The Phase 173 decision rule and 3-question checklist were reused verbatim for Phase 177. This is intentional: the rubric is the stable gate; the trial evidence is what moves. `S_pass_nonnull` moved from 1 (Phase 173) to 3 (Phase 177) under the same rule, which is the correct way to measure iteration progress.
- **Controlled live self-trial is a legitimate evidence class when labeled honestly.** Phase 177 intentionally constructed Session C to produce a non-null live CODI injection so the v2.40 dataset could be evaluated against the same rubric that produced `S_pass_nonnull = 1` in Phase 173. The honesty rule (capped at `partial` on Signal 1 / Signal 4) prevents the controlled row from self-fulfilling the SHIP threshold — the final verdict is supportable from Session A alone.
- **Indirect causal chain on live evidence is a real limitation, not a paper one.** Sessions A and C produce non-null CODI dispatch, but in neither case did APPLY's work consume the injected blast_radius directly. The `S_pass_nonnull ≥ 3` threshold is now mechanically cleared, yet Q2 remains uncertain under the unchanged rubric because only Signal 3 reaches projected-pass. This is why ITERATE_V0_1, not SHIP_V0_2, is the correct verdict even with the improved signal count.
- **The CODI post-unify hook works end-to-end on a non-null outcome.** Phase 176 demonstrated the hook on a `skipped-no-symbols` outcome (176-01); Phase 177's own UNIFY dispatches the hook on an `injected` outcome (177-01), completing the end-to-end proof across both primary outcome categories.

## Accomplishments

- Produced a source-cited, honestly-labeled v2.40 re-trial dataset and a mechanically-derived verdict under the unchanged Phase 173 rubric.
- Closed v2.40 CODI v0.1 — Extractor & Coverage Iteration cleanly with PROJECT/ROADMAP/STATE reflecting the verdict.
- Established the v2.41 milestone scope (Natural-Scope Evidence & Signal-1/2 Validation) so the next planning decision has a concrete starting point without re-planning from scratch.
- Preserved all boundary constraints: no repo-source CODI/module/runtime/validation edits; `.paul/CODI-HISTORY.md` remained read-only during APPLY and is updated only by the post-unify hook during UNIFY.

## Next Phase Readiness

**Ready:**
- v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation has concrete shape (Phase 178 natural-scope TS observation / Phase 179 optional pre-plan guidance / Phase 180 re-trial).
- Phase 177's UNIFY populated the third row in `.paul/CODI-HISTORY.md` (first hook-triggered `injected` row) and the first quality-history row under the v2.41 baseline.
- Validation surfaces remain green (172/172 pi-e2e + 75/75 cross-harness).

**Concerns:**
- The natural-scope TS implementation phase that would resolve Q2 may depend on organic project work; if none arises in a reasonable window, the cross-repo backup path becomes more relevant.
- `S_pass_nonnull` mechanically cleared the SHIP threshold for the first time. Future readers might misread this as a SHIP-ready state; the DECISION artifact is explicit that Q2 is the binding constraint under the unchanged rubric.

**Blockers:**
- None technically. v2.41 planning can begin after this UNIFY and the GitHub Flow merge gate close.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Tasks 1–3 | `ed77f78` | feat | Built TRIAL-DATA (4 sessions + signal scoring + Phase 173 comparison), DECISION (unchanged rubric + mechanical verdict ITERATE_V0_1), and lifecycle patches |
| State update | `eba2fe6` | chore | Updated STATE.md loop position to APPLY complete |

---

*Phase: 177-re-trial-gating-decision, Plan: 01*
*Completed: 2026-04-18*
