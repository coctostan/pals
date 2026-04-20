---
phase: 179-organic-observation
plan: 01
type: execute
started: 2026-04-18
completed: 2026-04-20
status: closed — observation window produced a clean three-finding package for Phase 180
---

# Phase 179-01 Summary

## Headline Findings

Phase 179 observed two consecutive natural quark phases under CODI and closes with **three durable findings**, not a clean mechanical `S_pass_nonnull` tally:

1. **CODI pre-plan advisory is working on natural scope.** In both observed phases, CODI's injected blast-radius materially shaped APPLY placement (file awareness, signature-change propagation, caller-site choice). This is the qualitative answer to Q2 that Phase 177 structurally could not provide.
2. **Post-unify instrumentation has a parser-miss failure mode (112-01).** The hook fired but did not recognize the plan's qualitative dispatch wording as a valid success log, producing a `no-dispatch-found` row despite real CODI value in APPLY.
3. **Post-unify instrumentation has a hook-not-firing failure mode (113-01).** The hook did not dispatch at all during quark UNIFY; no `CODI-HISTORY.md` row and no CODI entry in the quark SUMMARY's `## Module Execution Reports`. Distinct from the 112-01 parser-miss.

The combined finding: **the mechanical SHIP gate (`S_pass_nonnull ≥ 3`) reads the ledger, but the ledger cannot be trusted to count when CODI is valuable** — two different instrumentation gaps produced the same ledger-level undercount from two real successful CODI pre-plan dispatches. That is the single most important observation of v2.41 so far.

## Scope Context

Phase 179 is the v2.41 natural observation window. The plan was amended mid-APPLY on 2026-04-18 to broaden trial fuel from `pre-authored only` to two labeled evidence classes:
- **pre-authored** — quark patches authored before CODI was enabled in quark (zero selection bias).
- **concurrent-natural** — real roadmap-driven quark work performed after CODI enablement, honoring the Phase 178 naturality discipline rule: `<context>` / `files_modified` drafted from engineering logic BEFORE CODI dispatch runs; scope chosen by engineering need, not CODI visibility.
Observation halted after 2 phases not because data was exhausted but because two distinct instrumentation gaps on two consecutive phases established that **the measurement surface is the bottleneck**, not observation volume. Continuing to collect more natural rows would not close that gap.

## Observed Row Set (rolling)

Source of truth: `/Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md`.

| Plan | Date | Class | CODI-HISTORY outcome | blast_radius | Class-labeled APPLY-consumption evidence |
|------|------|-------|----------------------|--------------|------------------------------------------|
| quark `112-01` | 2026-04-18 | pre-authored | `no-dispatch-found` | `n` | **Instrumentation mismatch.** Qualitative evidence: strong — quark `112-01` SUMMARY `### CODI Influence on APPLY` records **CODI materially shaped APPLY: yes**, with concrete attribution (boundary caution via `cli.ts` upstream callers; file awareness of `startDaemon` / `createProcessSyscalls` as real runtime surfaces; RED→GREEN sequencing from `validateManifestPresence` / `assembleContext` upstream analysis; avoided partial fix by including `src/daemon/lifecycle.ts` + daemon integration test + `src/kernel/loop.ts` caller). Mechanical evidence: imperfect — post-unify parser did not recognize the Phase 112 plan's qualitative dispatch wording as a valid success log, so the row classified as `no-dispatch-found`. Preserve this as natural live evidence with instrumentation mismatch; do not repair the row or patch CODI mid-trial. |

| quark `113-01` | 2026-04-20 | concurrent-natural | _(not recorded — post-unify hook did not fire)_ | pre-plan: `y` (injected, 2R/3E/5K) | **Pre-plan `injected` clean; post-unify silently skipped.** Pre-plan dispatch ran correctly: `impact × 5 symbols → 2 resolved-with-call-sites, 3 resolved-but-empty, 0 unresolved, 5 total call-sites, injected blast_radius`. Symbols: `makeProcessCreate`, `makeProcessRun`, `intersectManifests`, `checkCapabilitySubset`, `validateManifestPresence`. Naturality check — PASS: scope driven by PraesKern Security Fixes Spec (B1–B8), symbols traced from the spec bugs rather than CODI convenience; `.codegraph/graph.db` was freshly reindexed at planning time. APPLY-consumption evidence (reconstructed from SUMMARY, since 113-01 did not author an explicit `### CODI Influence on APPLY` section): (a) CODI's fan-out data identified `makeProcessCreate`→`createProcessSyscalls`→`startDaemon` (depth 3, entry-point); plan Task 1 explicitly notes the signature-change must propagate through the factory call site; APPLY landed that propagation in `process-syscalls.ts` without missing the daemon-runtime surface. (b) CODI's `resolved-but-empty` result on `validateManifestPresence` plus the plan's follow-up grep confirming the single call-site at `src/kernel/loop.ts:414` directly informed Deviation #1 — the hard-fail landed in `loop.ts` rather than `manifest-validator.ts` because the validator's return value was already consumed there. That is CODI materially shaping APPLY placement. **Instrumentation gap (different from 112-01):** no `CODI-HISTORY.md` row was appended. Quark SUMMARY's `## Module Execution Reports` section shows WALT(100), SKIP(200), RUBY(300) ran but CODI(220) post-unify did not appear. Root cause not yet isolated; most likely the post-unify hook was not dispatched during quark UNIFY rather than a parser-miss (unlike 112-01). Preserve this as a second, distinct instrumentation observation — do not hand-edit history, do not patch CODI mid-trial. |

## Per-Class Tally (final)

- `pre-authored`: 1 row — quark `112-01`. Mechanical: `no-dispatch-found` (parser-miss). Qualitative: strong; quark SUMMARY explicitly records **CODI materially shaped APPLY: yes**.
- `concurrent-natural`: 1 observation — quark `113-01`. Mechanical pre-plan: clean `injected` (2R/3E/0U/5K, blast_radius injected). Mechanical post-unify: no row written (hook-not-firing). Qualitative: strong; reconstructed from SUMMARY.

**Total natural phases with injected blast_radius: 2. Total mechanical rows in `CODI-HISTORY.md`: 1.** The ledger undercount is 2× for a different reason each time.

## Handoff to Phase 180

Phase 180 was always scoped as the formal re-trial against the unchanged Phase 173/177 gating rubric. Phase 179's findings reshape what Phase 180 must decide:

1. **Mechanical SHIP gating cannot be trusted on the current post-unify surface.** Two consecutive natural phases with injected blast_radius produced 1 mechanical row. Until the parser-miss and hook-not-firing gaps are characterized, `S_pass_nonnull ≥ 3` is reading a censored ledger.
2. **Qualitative value envelope trends `yes` for Q2.** Both observed phases produced concrete evidence that CODI's structural blast-radius shaped real APPLY placement in ways the trial cannot reasonably dismiss as post-hoc narrative — particularly 113-01 Deviation #1, where CODI's `resolved-but-empty` + single-call-site data directly informed a different-file placement decision.
3. **Phase 180 scoping decision.** Open question for Phase 180: is the v2.41 verdict evaluated on (a) the qualitative evidence alone with an honest caveat that mechanical gating is instrumentation-blocked, or (b) a bounded post-unify instrumentation fix (parser hardening + hook-firing guard) that is still compatible with the v2.41 CODI-source freeze? Decision deferred to Phase 180's PLAN step with this SUMMARY as input.

Phase 180 opens cleanly from this SUMMARY without reconstructing the observation window from raw quark artifacts. AC-4 satisfied.

## Integrity Invariants Preserved

- pals `modules/codi/*` source frozen at SHA `0d667560b65944801faaee270ab920786afa471a` for the entire duration of v2.41.
- No controlled self-trials, no synthetic rows, no retroactive CODI runs, no `CODI-HISTORY.md` hand edits.
- quark scope selection stays engineering-logic-first; no file included because it happens to be indexed TypeScript.
- pals Phase 179 performed observation and reconciliation only; no pals-side feature work.

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Phase 179 opens as observation-only with correct integrity constraints | PASS | CODI source frozen at SHA `0d667560b65944801faaee270ab920786afa471a` throughout; no synthetic rows, no controlled self-trials, no retroactive runs, no hand-edited ledger rows |
| AC-2 | User's existing quark patches decomposed by engineering logic first | PASS | quark `112-01` was the natural single-slice decomposition; quark `113-01` was real roadmap work (v2.17 Security Correctness II, PraesKern Security Fixes Spec bugs B1–B8) with symbols traced from the bug set, not CODI convenience |
| AC-3 | Natural quark UNIFY runs generate the authoritative Phase 179 row set | PASS with findings | 2 natural phases observed; each row traceable to a real quark phase artifact pair; per-phase qualitative APPLY-consumption notes recorded. Mechanical ledger undercount is itself the authoritative finding, not a scope gap |
| AC-4 | pals closes Phase 179 with a SUMMARY ready as Phase 180 input | PASS | Three headline findings recorded; handoff frames Phase 180's scoping decision; `.paul/STATE.md` and `.paul/ROADMAP.md` advance to Phase 180 |

## Module Execution Reports

### Pre-apply dispatch

- `[dispatch] pre-apply: TODD(p50) → baseline recorded` — no test-first surface in pals-side observation scope; quark-local TODD is the active surface and ran during each quark phase.
- `[dispatch] pre-apply: WALT(p100) → baseline recorded` — pals has no application test suite for documentation-only lifecycle work; installer-backed validation unchanged.

### Post-apply advisory dispatch

- `[dispatch] post-apply advisory: IRIS(p250) → 0 annotations` — no TODO/FIXME/HACK anti-patterns introduced in markdown artifacts.
- `[dispatch] post-apply advisory: DOCS(p250) → 0 annotations` — ROADMAP.md and STATE.md updated in-step with SUMMARY; no doc drift.
- `[dispatch] post-apply advisory: RUBY(p300) → 0 annotations` — no in-repo code surface touched.
- `[dispatch] post-apply advisory: SKIP(p300) → knowledge captured in SUMMARY's Headline Findings + Handoff to Phase 180 sections`.

### Post-apply enforcement dispatch

- `[dispatch] post-apply enforcement: WALT(p100) → PASS` — no pals source/test changes; baseline preserved.
- `[dispatch] post-apply enforcement: DEAN(p150) → PASS` — no dependency manifest changes.
- `[dispatch] post-apply enforcement: TODD(p200) → PASS` — documentation-only phase; no TDD sequencing required.

### Pre-unify dispatch

- `[dispatch] pre-unify: 0 modules registered for this hook` — no pre-unify hooks declared in installed registry.

### Post-unify dispatch

- `[dispatch] post-unify: WALT(p100) → appended stable row for 179-01` — quality history entry recorded in both `.paul/QUALITY-HISTORY.md` and `.paul/quality-history.md` (documentation-only phase; test counts unchanged at 172+75 pass).
- `[dispatch] post-unify: SKIP(p200) → knowledge captured inline` — three headline findings deposited in SUMMARY and STATE.md Decisions; no separate artifact needed.
- `[dispatch] post-unify: CODI(p220) → appended skipped-no-symbols row for 179-01` — matched PLAN.md `<module_dispatch>` line `CODI (p220) → skipped — no extractable symbols in phase scope`; `.paul/CODI-HISTORY.md` row appended with R/U/K/Symbols as `—` and blast_radius `n`. Honest record of this pals-side observation plan being documentation-shaped.
- `[dispatch] post-unify: RUBY(p300) → skipped — no source-code changes in phase scope`.

### Skill audit

| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY (with mid-APPLY plan amendment checkpoint) → UNIFY for the Phase 179 observation window |
| /carl | ✓ | Session-boundary routing remained active across the multi-session pause/resume boundary |
| TODD | N/A | Documentation-only phase in pals; no implementation path or RED/GREEN/REFACTOR work applied. Quark-local TODD was active during each observed quark phase |
| WALT | ✓ | Pre-apply baseline + post-apply enforcement PASS; post-unify quality history recorded |

**Skill audit: all required skills either invoked or documented N/A ✓**

## Deviations

1. **Plan amended mid-APPLY (2026-04-18).** Scope broadened from `pre-authored only` to two labeled evidence classes (`pre-authored` + `concurrent-natural`). Logged as explicit decision in `.paul/STATE.md`. The amendment was necessary because the single pre-authored quark slice (112-01) was structurally too thin for Phase 180's SHIP gate. Integrity invariants (CODI-source freeze, no-self-trial, no-synthetic, naturality discipline, engineering-logic-first) preserved unchanged by the amendment. **Impact: broadens observation scope without weakening trial integrity.**

2. **Plan's original Task 1 language assumed prospective quark-phase creation; actual quark `112-01` had already completed organically before this APPLY began.** Retrospective-in-timing but substantively PASS — the natural engineering decomposition had already happened at the right granularity (one coherent security-correctness slice). **Impact: none — AC-2 satisfied on the merits.**

## Key Patterns / Decisions

- **Two distinct post-unify instrumentation gaps** on two consecutive natural quark phases is strong evidence the measurement surface, not observation volume, is the v2.41 bottleneck. This reshapes Phase 180's scoping question.
- **Concurrent-natural class** is a real category distinct from Session C-style controlled self-trials: the naturality discipline rule (scope chosen by engineering need, not CODI visibility; `<context>` drafted before CODI dispatch runs) provides a defensible boundary.
- **Mechanical ledger alone is insufficient for Q2 resolution** when the post-unify instrumentation surface can silently undercount successful dispatches. Qualitative APPLY-consumption evidence in quark SUMMARIES carries real signal that the ledger cannot.

## Next Phase

Phase 180: Re-Trial + Gating Decision. Scoping question now framed by Phase 179's three findings: decide between (a) qualitative-alone v2.41 verdict with instrumentation-blocked caveat, or (b) bounded post-unify instrumentation fix (parser hardening + hook-firing guard) compatible with the v2.41 CODI-source freeze. Input: this SUMMARY.
