# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-04-27 after Phase 189 transition)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.44 PALS Context Optimization — Process & Artifacts is active; Phases 188 and 189 are complete (50%) and Phase 190 Plan 190-02 UNIFY is complete, pending merge gate and phase transition.

## Current Position

Milestone: v2.44 PALS Context Optimization — Process & Artifacts
Phase: 190 of 4 in v2.44 — Artifact Structure Simplification — UNIFY complete, transition pending
Plan: 190-02 complete
Status: UNIFY complete; merge gate and phase transition pending
Last activity: 2026-04-27T02:31:00Z — Unified .paul/phases/190-artifact-structure-simplification/190-02-PLAN.md; validation passed (Pi 177/177, cross-harness 90/90)
Progress:
- v2.42 CODI v0.1 — Post-Unify Instrumentation Fix: [██████████] 100% (CODI v0.1 shipped as good enough; fresh quark validation intentionally skipped)
- v2.43 PALS Context Diet — Archive, Compact, Compress: [██████████] 100% (4 of 4 phases complete)
- v2.44 PALS Context Optimization — Process & Artifacts: [█████░░░░░] 50% (2 of 4 phases complete: 188 ✓, 189 ✓)

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ✓     [Plan 190-02 loop complete — merge gate and phase transition pending]
```

## Accumulated Context

### Current Summary

- PLAN/APPLY/UNIFY remains the authoritative PALS lifecycle loop.
- `.paul/*` artifacts remain lifecycle truth; archives under `.paul/archive/*` are authoritative historical artifacts, not disposable summaries.
- v2.43 completed the first context-diet wave: indexed archives, compact hot artifacts, centralized workflow/module prose, and anti-regrowth validation.
- v2.44 continues context optimization across PALS process and artifacts; Phase 188 reduced recurring prompt/skill wrapper read cost.
- Phase 188 completed workflow prompt/skill slimming: selected wrapper total dropped from 406 to 296 lines while Pi 177/177 and cross-harness 90/90 validation stayed green.
- Phase 189 audit measured remaining hot-path reads and identified 8 findings (F1–F8) and 10 recommendations (R1–R10); ROADMAP archive split and GitHub Flow centralization are the largest reducible wins.
- Phase 190 Plan 190-01 moved completed ROADMAP history into `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md`, compacted live `.paul/ROADMAP.md` to 68 lines, and preserved archive authority through `.paul/archive/INDEX.md`.
- Phase 190 Plan 190-02 applied the workflow centralization wave for R2/R3/R4: GitHub Flow shared mechanics now live in `kernel/references/git-strategy.md`, module-dispatch taxonomy in `kernel/references/module-dispatch.md`, APPLY optional refs are conditional, and hot/warm workflow prose was reduced while validation stayed green.

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
| Guard context-diet gains with semantic validation and a practical line ceiling | Phase 187 Plan 187-01 | Future hot workflow edits must retain lifecycle/module/merge-gate markers and stay under the 1711 Phase 186 pre-compression ceiling. |
| Treat Claude Code command wrappers as legacy/reference thin pointers while keeping Pi skills as the active user-facing surface | Phase 188 Plan 188-01 | Future prompt-slimming should avoid expanding Claude-specific polish unless product strategy changes. |
| Hot-path read cost concentrates in `.paul/ROADMAP.md` history and duplicated GitHub Flow stanzas; Pi adapter modularization and Claude wrapper handling deferred to product decision | Phase 189 Plan 189-01 | Phase 190 should target ROADMAP archive split + GitHub Flow centralization first; Pi adapter and Claude wrappers wait for explicit product-level support-tier decision. |

Detailed historical decisions, fixes, deviations, skill audits, and deferred issues: [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md)

### Fixes / Deviations / Skill Audits

- Historical fix log, deviation log, and skill audit tables through Phase 185 Plan 185-01 are archived in [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md).
- Phase 188 auto-fixed initial Pi validation marker loss by restoring exact guardrail phrases in thinner Pi skill wrappers; final validation passed.
- Phase 190 Plan 190-01 recorded a verification-count deviation: approved plan expected 11 `<details>` blocks, actual ROADMAP source had 57 `<details>` lines under 11 completed-milestone headings; APPLY preserved actual history verbatim.

### Deferred Issues

- ci-generation.md and sonarqube-integration.md — future module candidates.
- Agent SDK hook dispatch shelved — not an active milestone driver.
- Tree-sitter repo map deferred.
- Multi-model routing exists via `pals.json` `agents`, `agent-dispatch.md`, and apply-phase dispatch logic.

### Blockers/Concerns

- Future work should preserve artifact-first truth and resist telemetry, Pi-owned execution state, or reopening the settled Phase 69/70 contract without new evidence.
- v2.44 slimming must not weaken PLAN/APPLY/UNIFY, GitHub Flow, module dispatch, archive authority, or parent-owned APPLY boundaries; future work should clarify Claude Code support tier before investing in Claude-specific polish.

### Git State

Branch: feature/190-02-workflow-centralization
Phase transition commit: PR #102 squash merge 42d72a8a; PR #103 squash merge 15dc8e57 for UNIFY artifacts
PR: #104 OPEN (Plan 190-02 APPLY artifacts); prior #102/#103 MERGED (Plan 190-01 APPLY/UNIFY artifacts)
CI: local validation passing — Pi 177/177 and cross-harness 90/90; PR #104 checks passing
Prior PRs: #104 open (Phase 190 Plan 190-02 APPLY artifacts); #103 merged (Phase 190 Plan 190-01 UNIFY artifacts); #102 merged (Phase 190 Plan 190-01 APPLY artifacts); #101 merged (Phase 189 Plan 189-01); #100 merged (Phase 188 Plan 188-01); #99 merged (Phase 187 Plan 187-01 / v2.43 closed); #98 merged (Phase 186 Plan 186-01); #97 merged (Phase 185 Plan 185-03); #96 merged (Phase 185 Plan 185-02); #95 merged (Phase 185 Plan 185-01); #94 merged (Phase 184); #93 merged (Phase 183 / v2.42 closed); #92 merged (Phase 182); #91 merged (Phase 181); #90 merged (Phase 180 / v2.41 closed)

## Session Continuity

Last session: 2026-04-27T02:31:00Z
Stopped at: Phase 190 Plan 190-02 UNIFY complete; merge gate and phase transition pending
Next action: Complete GitHub Flow merge gate for PR #104, then transition to Phase 191
Resume file: .paul/phases/190-artifact-structure-simplification/190-02-SUMMARY.md
Resume context:
- Phase 190 Plan 190-02 UNIFY completed R2 + R3 + R4 reconciliation: GitHub Flow recipes centralized, module-dispatch taxonomy hoisted, APPLY conditional refs encoded.
- Validation passed: semantic marker checks, `bash tests/pi-end-to-end-validation.sh` (177/177), and `bash tests/cross-harness-validation.sh` (90/90).
- Post-unify WALT/CODI/SKIP/RUBY reports persisted in `190-02-SUMMARY.md`, `.paul/QUALITY-HISTORY.md`, and `.paul/CODI-HISTORY.md`.
- Active pause handoff was consumed and archived under `.paul/handoffs/archive/`.
- PR #104 is open and checks are passing; merge gate should push UNIFY artifacts, merge PR #104, sync `main`, then run transition to Phase 191.