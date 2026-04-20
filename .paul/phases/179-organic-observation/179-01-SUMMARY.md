---
phase: 179-organic-observation
plan: 01
type: execute
started: 2026-04-18
status: in-progress (observation window open — awaiting concurrent-natural quark phases)
---

# Phase 179-01 Summary (provisional — observation window open)

## Status

Phase 179 is **open, not closed**. The plan was amended mid-APPLY on 2026-04-18 to broaden trial fuel from `pre-authored only` to two labeled evidence classes:

- **pre-authored** — quark patches authored before CODI was enabled in quark (zero selection bias).
- **concurrent-natural** — real roadmap-driven quark work performed after CODI enablement, honoring the Phase 178 naturality discipline rule: `<context>` / `files_modified` drafted from engineering logic BEFORE CODI dispatch runs; scope chosen by engineering need, not CODI visibility.

This SUMMARY is written provisionally: the pre-authored slice is logged now, and concurrent-natural rows will be appended as each quark phase completes its normal PLAN → APPLY → UNIFY loop. Final reconciliation (AC-4, Phase 180 handoff) happens when the user judges the observation window sufficient.

## Observed Row Set (rolling)

Source of truth: `/Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md`.

| Plan | Date | Class | CODI-HISTORY outcome | blast_radius | Class-labeled APPLY-consumption evidence |
|------|------|-------|----------------------|--------------|------------------------------------------|
| quark `112-01` | 2026-04-18 | pre-authored | `no-dispatch-found` | `n` | **Instrumentation mismatch.** Qualitative evidence: strong — quark `112-01` SUMMARY `### CODI Influence on APPLY` records **CODI materially shaped APPLY: yes**, with concrete attribution (boundary caution via `cli.ts` upstream callers; file awareness of `startDaemon` / `createProcessSyscalls` as real runtime surfaces; RED→GREEN sequencing from `validateManifestPresence` / `assembleContext` upstream analysis; avoided partial fix by including `src/daemon/lifecycle.ts` + daemon integration test + `src/kernel/loop.ts` caller). Mechanical evidence: imperfect — post-unify parser did not recognize the Phase 112 plan's qualitative dispatch wording as a valid success log, so the row classified as `no-dispatch-found`. Preserve this as natural live evidence with instrumentation mismatch; do not repair the row or patch CODI mid-trial. |

| quark `113-01` | 2026-04-20 | concurrent-natural | _(not recorded — post-unify hook did not fire)_ | pre-plan: `y` (injected, 2R/3E/5K) | **Pre-plan `injected` clean; post-unify silently skipped.** Pre-plan dispatch ran correctly: `impact × 5 symbols → 2 resolved-with-call-sites, 3 resolved-but-empty, 0 unresolved, 5 total call-sites, injected blast_radius`. Symbols: `makeProcessCreate`, `makeProcessRun`, `intersectManifests`, `checkCapabilitySubset`, `validateManifestPresence`. Naturality check — PASS: scope driven by PraesKern Security Fixes Spec (B1–B8), symbols traced from the spec bugs rather than CODI convenience; `.codegraph/graph.db` was freshly reindexed at planning time. APPLY-consumption evidence (reconstructed from SUMMARY, since 113-01 did not author an explicit `### CODI Influence on APPLY` section): (a) CODI's fan-out data identified `makeProcessCreate`→`createProcessSyscalls`→`startDaemon` (depth 3, entry-point); plan Task 1 explicitly notes the signature-change must propagate through the factory call site; APPLY landed that propagation in `process-syscalls.ts` without missing the daemon-runtime surface. (b) CODI's `resolved-but-empty` result on `validateManifestPresence` plus the plan's follow-up grep confirming the single call-site at `src/kernel/loop.ts:414` directly informed Deviation #1 — the hard-fail landed in `loop.ts` rather than `manifest-validator.ts` because the validator's return value was already consumed there. That is CODI materially shaping APPLY placement. **Instrumentation gap (different from 112-01):** no `CODI-HISTORY.md` row was appended. Quark SUMMARY's `## Module Execution Reports` section shows WALT(100), SKIP(200), RUBY(300) ran but CODI(220) post-unify did not appear. Root cause not yet isolated; most likely the post-unify hook was not dispatched during quark UNIFY rather than a parser-miss (unlike 112-01). Preserve this as a second, distinct instrumentation observation — do not hand-edit history, do not patch CODI mid-trial. |
_(concurrent-natural rows appended here as quark phases complete)_

## Per-Class Tally (rolling)

- `pre-authored`: 1 row (quark `112-01`) - 0 mechanically-clean `injected`, 1 `no-dispatch-found` with strong qualitative APPLY-consumption evidence.
- `concurrent-natural`: 1 observation (quark `113-01`) — 1 mechanically-clean pre-plan `injected` (2R/3E/5K with blast_radius injected), but **0 post-unify rows written** due to post-unify hook not firing during quark UNIFY. Strong qualitative APPLY-consumption evidence (reconstructed).

## Integrity Invariants Preserved

- pals `modules/codi/*` source frozen at SHA `0d667560b65944801faaee270ab920786afa471a` for the entire duration of v2.41.
- No controlled self-trials, no synthetic rows, no retroactive CODI runs, no `CODI-HISTORY.md` hand edits.
- quark scope selection stays engineering-logic-first; no file included because it happens to be indexed TypeScript.
- pals Phase 179 performs observation and reconciliation only; no pals-side feature work.

## Open Questions for Phase 180

- **Instrumentation surface gaps are distinct and compounding.** quark `112-01` exposed a post-unify **parser-miss** (hook fired but could not classify qualitative dispatch wording as success). quark `113-01` exposed a **hook-not-firing** gap (pre-plan dispatched cleanly, blast_radius injected, but no post-unify row appended and no CODI entry in the SUMMARY's Module Execution Reports). Two different failure modes on two consecutive natural quark phases. The mechanical `CODI-HISTORY.md` ledger has captured 1 row total from 2 real quark phases with injected blast_radius. Phase 180 must disentangle these or SHIP threshold cannot be read honestly from `CODI-HISTORY.md` alone.
- **Qualitative value envelope is increasingly visible even without clean mechanical rows.** Both 112-01 and 113-01 provide concrete evidence that CODI's injected call-site data shaped real APPLY placement (file awareness, signature-change propagation, caller-site choice). This is exactly what Q2 asked about — but mechanical SHIP-gating (`S_pass_nonnull ≥ 3`) reads the ledger, not the SUMMARY prose.
- Whether `S_pass_nonnull` over the combined pre-authored + concurrent-natural row set crosses the SHIP threshold organically, or whether Q2 requires a Phase 180 tooling fix on the instrumentation surface (post-unify parser hardening + hook-firing guard) before the mechanical signal can be trusted.

## Pause State

APPLY is paused after Task 1 completion and plan amendment, pending concurrent-natural quark phases. Resume on pals when:
- the user judges the observation window sufficient, OR
- the next quark milestone closes and natural row volume is ready to reconcile.

On resume, the final pass will: append any new rows to the Observed Row Set table, update the per-class tally, write the per-phase APPLY-consumption notes, advance `.paul/ROADMAP.md` and `.paul/STATE.md` to Phase 180, and close Phase 179.
