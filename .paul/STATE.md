# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-04-27 after Phase 189 transition)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.44 PALS Context Optimization — Process & Artifacts is active; Phases 188 and 189 are complete (50%) and Phase 190 Plan 190-01 is complete; Plan 190-02 is ready to plan.

## Current Position

Milestone: v2.44 PALS Context Optimization — Process & Artifacts
Phase: 190 of 4 in v2.44 — Artifact Structure Simplification — In progress
Plan: 190-01 complete
Status: Loop complete, ready for next PLAN in Phase 190
Last activity: 2026-04-27T01:37:00Z — Unified Plan 190-01 ROADMAP archive split; created SUMMARY and updated module histories.
Progress:
- v2.42 CODI v0.1 — Post-Unify Instrumentation Fix: [██████████] 100% (CODI v0.1 shipped as good enough; fresh quark validation intentionally skipped)
- v2.43 PALS Context Diet — Archive, Compact, Compress: [██████████] 100% (4 of 4 phases complete)
- v2.44 PALS Context Optimization — Process & Artifacts: [█████░░░░░] 50% (2 of 4 phases complete: 188 ✓, 189 ✓)

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ✓     [Loop complete — ready for Plan 190-02]
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

Branch: feature/190-artifact-structure-simplification
Phase transition commit: main transition commit after PR #101 squash merge 14251498; UNIFY artifacts pushed on feature branch
PR: https://github.com/coctostan/pals/pull/102 (OPEN)
CI: local validation passing — Pi 177/177 and cross-harness 90/90; PR #102 Socket Security checks passing
Prior PRs: #101 merged (Phase 189 Plan 189-01); #100 merged (Phase 188 Plan 188-01); #99 merged (Phase 187 Plan 187-01 / v2.43 closed); #98 merged (Phase 186 Plan 186-01); #97 merged (Phase 185 Plan 185-03); #96 merged (Phase 185 Plan 185-02); #95 merged (Phase 185 Plan 185-01); #94 merged (Phase 184); #93 merged (Phase 183 / v2.42 closed); #92 merged (Phase 182); #91 merged (Phase 181); #90 merged (Phase 180 / v2.41 closed)

## Session Continuity

Last session: 2026-04-27T01:37:00Z
Stopped at: Plan 190-01 UNIFY complete; PR #102 ready for merge gate
Next action: Complete GitHub Flow merge gate for PR #102, then run /paul:plan for Phase 190 Plan 190-02
Resume file: .paul/phases/190-artifact-structure-simplification/190-01-SUMMARY.md
Resume context:
- Phase 190 Plan 190-01 completed R1 (ROADMAP archive split): created `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md`, compacted `.paul/ROADMAP.md` to 68 lines, registered the archive in `.paul/archive/INDEX.md`, and documented results in `.paul/phases/190-artifact-structure-simplification/190-01-SUMMARY.md`.
- Validation passed: `bash tests/pi-end-to-end-validation.sh` (177/177), `bash tests/cross-harness-validation.sh` (90/90), and PR #102 Socket Security checks.
- UNIFY recorded the verification-count deviation: source ROADMAP had 57 `<details>` lines under 11 `## Completed Milestones` headings; the approved plan expected 11 conceptual blocks, so actual source history was preserved verbatim.
- Plan 190-02 next: R2 + R3 + R4 — workflow centralization wave (centralize GitHub Flow stanzas, hoist module-dispatch taxonomy, conditional refs in apply-phase.md).
- Plan 190-03 deferred: R5 — Pi adapter modular split. Decision: defer per user.
- Phase 191 follows after Phase 190 with anti-regrowth validation that locks the new hot-path budgets (R6–R7).