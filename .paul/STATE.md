# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-04-20)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.43 PALS Context Diet — Archive, Compact, Compress is open; Phase 185 is executing archive-backed hot-path compaction waves.

## Current Position

Milestone: v2.43 PALS Context Diet — Archive, Compact, Compress
Phase: 185 of 4 in v2.43 — Artifact Archival + Hot-Path Compaction — Applying
Plan: 185-02 executed, ready for UNIFY
Status: APPLY complete; ready for UNIFY
Last activity: 2026-04-26T21:10:00Z — Completed Plan 185-02 STATE history archival and hot-path compaction
Progress:
- v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation: [██████████] 100% (Phase 180 complete; verdict ITERATE_V0_1)
- v2.42 CODI v0.1 — Post-Unify Instrumentation Fix: [██████████] 100% (CODI v0.1 shipped as good enough; fresh quark validation intentionally skipped)
- v2.43 PALS Context Diet — Archive, Compact, Compress: [███████░░░] 70% (185-02 APPLY compacted STATE history into indexed archive; UNIFY pending)

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ○     [APPLY complete, ready for UNIFY]
```

## Accumulated Context

### Current Summary

- PLAN/APPLY/UNIFY remains the authoritative PALS lifecycle loop.
- `.paul/*` artifacts remain lifecycle truth; archives under `.paul/archive/*` are authoritative historical artifacts, not disposable summaries.
- v2.43 is reducing hot-path context cost by moving cold history into indexed archives before compacting sensitive hot/warm artifacts.
- Plan 185-01 proved archive-link mechanics on `MILESTONES.md` and `PROJECT.md`.
- Plan 185-02 applies the same pattern to `STATE.md`; `ROADMAP.md` structural compaction remains deferred.

### Current Decisions

| Decision | Source | Impact |
|----------|--------|--------|
| Ship CODI v0.1 as good enough and skip fresh quark natural validation | Phase 183 | Future CODI work should be real-usage-driven, not prerequisite to context-diet work. |
| Start v2.43 archive split with indexed cold-history migration from live artifacts | Phase 184 | Phase 185 compacts hot artifacts while preserving lifecycle authority. |
| Archive files remain authoritative historical truth | Phase 185 Plan 185-01 | Hot artifacts may link to cold archives instead of duplicating long history. |
| Prove archive-link mechanics before compacting `STATE.md` | Phase 185 Plan 185-01 | `STATE.md` and `ROADMAP.md` compaction are separate risk-managed waves. |
| Compact `STATE.md` by moving historical accumulated context to `.paul/archive/state/STATE-HISTORY-v0-v2.43.md` | Phase 185 Plan 185-02 | Resume/status stay hot-path complete while old decisions/fixes/deviations/audits remain findable. |

Detailed historical decisions, fixes, deviations, skill audits, and deferred issues: [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md)

### Fixes / Deviations / Skill Audits

- Historical fix log, deviation log, and skill audit tables through Phase 185 Plan 185-01 are archived in [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md).
- Current active concern: preserve artifact-first truth and avoid telemetry, hidden runtime state, or Pi-owned persistence as shortcuts.

### Deferred Issues

- ci-generation.md and sonarqube-integration.md — future module candidates.
- Agent SDK hook dispatch shelved — not an active milestone driver.
- Tree-sitter repo map deferred.
- Multi-model routing exists via `pals.json` `agents`, `agent-dispatch.md`, and apply-phase dispatch logic.

### Blockers/Concerns

- Future work should preserve artifact-first truth and resist telemetry, Pi-owned execution state, or reopening the settled Phase 69/70 contract without new evidence.
- `ROADMAP.md` active-window/history compaction is still pending for a later Phase 185 plan.

### Git State

Branch: feature/185-artifact-archival-hot-path-compaction
Last commit: ca798d53 feat(185-artifact-archival-hot-path-compaction): archive and compact hot artifacts (#95)
PR: none yet for Plan 185-02 (postflight pending)
CI: local pre-apply baseline passed (`tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh`)
Prior PRs: #95 merged (Phase 185 Plan 185-01); #94 merged (Phase 184); #93 merged (Phase 183 / v2.42 closed); #92 merged (Phase 182); #91 merged (Phase 181); #90 merged (Phase 180 / v2.41 closed)

## Session Continuity

Last session: 2026-04-26T21:10:00Z
Stopped at: Plan 185-02 APPLY complete
Next action: Run /paul:unify .paul/phases/185-artifact-archival-hot-path-compaction/185-02-PLAN.md
Resume file: .paul/phases/185-artifact-archival-hot-path-compaction/185-02-PLAN.md
Resume context:
- `.paul/archive/state/STATE-HISTORY-v0-v2.43.md` now preserves historical STATE accumulated context.
- `.paul/STATE.md` is compact and remains the hot lifecycle routing artifact.
- `.paul/archive/INDEX.md` catalogs the state archive.
- `ROADMAP.md` structural compaction remains deferred to a later Phase 185 plan.
