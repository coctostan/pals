# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-04-26)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.43 PALS Context Diet — Archive, Compact, Compress is open; Phase 187 Plan 187-01 UNIFY summary is created and merge gate is in progress.

## Current Position

Milestone: v2.43 PALS Context Diet — Archive, Compact, Compress
Phase: 187 of 4 in v2.43 — Regression + Anti-Regrowth Guardrails — UNIFY in progress
Plan: 187-01 SUMMARY created, merge gate in progress
Status: UNIFY in progress — GitHub Flow merge gate pending
Last activity: 2026-04-26T21:55:36Z — Created .paul/phases/187-regression-anti-regrowth-guardrails/187-01-SUMMARY.md and post-unify history rows
Progress:
- v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation: [██████████] 100% (Phase 180 complete; verdict ITERATE_V0_1)
- v2.42 CODI v0.1 — Post-Unify Instrumentation Fix: [██████████] 100% (CODI v0.1 shipped as good enough; fresh quark validation intentionally skipped)
- v2.43 PALS Context Diet — Archive, Compact, Compress: [████████░░] 75% (3 of 4 phases complete; Phase 187 UNIFY in progress)

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ○     [UNIFY summary created; merge gate in progress]
```

## Accumulated Context

### Current Summary

- PLAN/APPLY/UNIFY remains the authoritative PALS lifecycle loop.
- `.paul/*` artifacts remain lifecycle truth; archives under `.paul/archive/*` are authoritative historical artifacts, not disposable summaries.
- v2.43 is reducing hot-path context cost by moving cold history into indexed archives, compacting hot/warm artifacts, and compressing repeated workflow/module prose.
- Phase 185 completed archive-link mechanics, `STATE.md` compaction, and PALS process-level `ROADMAP.md` active-window/archive behavior.
- Phase 186 completed shared module-dispatch prose compression across PLAN/APPLY/UNIFY workflows while preserving checkpoints, dispatch evidence, post-unify persistence, and GitHub Flow merge-gate semantics.

### Current Decisions

| Decision | Source | Impact |
|----------|--------|--------|
| Ship CODI v0.1 as good enough and skip fresh quark natural validation | Phase 183 | Future CODI work should be real-usage-driven, not prerequisite to context-diet work. |
| Start v2.43 archive split with indexed cold-history migration from live artifacts | Phase 184 | Phase 185 compacts hot artifacts while preserving lifecycle authority. |
| Archive files remain authoritative historical truth | Phase 185 Plan 185-01 | Hot artifacts may link to cold archives instead of duplicating long history. |
| Prove archive-link mechanics before compacting `STATE.md` | Phase 185 Plan 185-01 | `STATE.md` and `ROADMAP.md` compaction are separate risk-managed waves. |
| Compact `STATE.md` by moving historical accumulated context to `.paul/archive/state/STATE-HISTORY-v0-v2.43.md` | Phase 185 Plan 185-02 | Resume/status stay hot-path complete while old decisions/fixes/deviations/audits remain findable. |
| Define PALS process-level ROADMAP active-window/archive convention | Phase 185 Plan 185-03 | Future roadmap writes keep current routing inline, archive completed detail, and repair bloat without hidden state. |
| Centralize shared dispatch mechanics in `kernel/references/module-dispatch.md` while workflows keep hook-local call-site obligations | Phase 186 Plan 186-01 | Hot PLAN/APPLY/UNIFY workflow prose is shorter without weakening module evidence, post-unify persistence, or merge-gate safety. |

Detailed historical decisions, fixes, deviations, skill audits, and deferred issues: [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md)

### Fixes / Deviations / Skill Audits

- Historical fix log, deviation log, and skill audit tables through Phase 185 Plan 185-01 are archived in [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md).
- Current active concern: Phase 187 guardrails should stay lightweight and semantic, avoiding brittle exact-prose checks or another compression wave.

### Deferred Issues

- ci-generation.md and sonarqube-integration.md — future module candidates.
- Agent SDK hook dispatch shelved — not an active milestone driver.
- Tree-sitter repo map deferred.
- Multi-model routing exists via `pals.json` `agents`, `agent-dispatch.md`, and apply-phase dispatch logic.

### Blockers/Concerns

- Future work should preserve artifact-first truth and resist telemetry, Pi-owned execution state, or reopening the settled Phase 69/70 contract without new evidence.
- Phase 186 must trim workflow/module prose without weakening PLAN/APPLY/UNIFY, GitHub Flow, module dispatch, or archive authority.

### Git State

Branch: feature/187-regression-anti-regrowth-guardrails
APPLY commits: 47234075, 0d5fad13 pushed to origin/feature/187-regression-anti-regrowth-guardrails
PR: https://github.com/coctostan/pals/pull/99 (OPEN)
CI: passing — Socket Security checks passing before UNIFY artifact push
Prior PRs: #98 merged (Phase 186 Plan 186-01); #97 merged (Phase 185 Plan 185-03); #96 merged (Phase 185 Plan 185-02); #95 merged (Phase 185 Plan 185-01); #94 merged (Phase 184); #93 merged (Phase 183 / v2.42 closed); #92 merged (Phase 182); #91 merged (Phase 181); #90 merged (Phase 180 / v2.41 closed)

## Session Continuity

Last session: 2026-04-26T21:55:36Z
Stopped at: UNIFY summary created; merge gate in progress
Next action: Complete GitHub Flow merge gate for PR #99, then transition Phase 187
Resume file: .paul/phases/187-regression-anti-regrowth-guardrails/187-01-SUMMARY.md
Resume context:
- Plan 187-01 modified `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` only.
- New guardrails enforce the Phase 186 hot-workflow ceiling (`1711`) and semantic markers for plan/apply/unify/module-dispatch contracts.
- Validation passed: `bash tests/pi-end-to-end-validation.sh` → 177 passed, 0 failed; `bash tests/cross-harness-validation.sh` → 90 passed, 0 failed.
- Post-unify history rows were appended to `.paul/QUALITY-HISTORY.md` and `.paul/CODI-HISTORY.md`.
- Merge gate must push UNIFY artifacts, verify PR #99 CI, merge, sync `main`, then transition the phase.