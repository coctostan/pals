# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-04-27)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.44 PALS Context Optimization — Process & Artifacts is active; Phase 188 is complete and Phase 189 Hot-Path Read Audit is ready to plan.

## Current Position

Milestone: v2.44 PALS Context Optimization — Process & Artifacts
Phase: 189 of 4 in v2.44 — Hot-Path Read Audit — APPLY complete, awaiting UNIFY
Plan: 189-01 applied; audit report created
Status: PLAN ✓ / APPLY ✓ / UNIFY ○
Last activity: 2026-04-27T00:55:00Z — Applied Plan 189-01; audit report at .paul/phases/189-hot-path-read-audit/189-01-HOT-PATH-READ-AUDIT.md; pi 177/177 + cross-harness 90/90 unchanged.
Progress:
- v2.42 CODI v0.1 — Post-Unify Instrumentation Fix: [██████████] 100% (CODI v0.1 shipped as good enough; fresh quark validation intentionally skipped)
- v2.43 PALS Context Diet — Archive, Compact, Compress: [██████████] 100% (4 of 4 phases complete)
- v2.44 PALS Context Optimization — Process & Artifacts: [███░░░░░░░] 30% (Phase 189 APPLY complete, UNIFY pending)

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ○     [Audit report applied; awaiting UNIFY]
```

## Accumulated Context

### Current Summary

- PLAN/APPLY/UNIFY remains the authoritative PALS lifecycle loop.
- `.paul/*` artifacts remain lifecycle truth; archives under `.paul/archive/*` are authoritative historical artifacts, not disposable summaries.
- v2.43 completed the first context-diet wave: indexed archives, compact hot artifacts, centralized workflow/module prose, and anti-regrowth validation.
- v2.44 continues context optimization across PALS process and artifacts; Phase 188 reduced recurring prompt/skill wrapper read cost.
- Phase 188 completed workflow prompt/skill slimming: selected wrapper total dropped from 406 to 296 lines while Pi 177/177 and cross-harness 90/90 validation stayed green.
- Phase 189 will audit remaining hot-path reads during normal PLAN/APPLY/UNIFY to identify the next avoidable context costs.

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

Detailed historical decisions, fixes, deviations, skill audits, and deferred issues: [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md)

### Fixes / Deviations / Skill Audits

- Historical fix log, deviation log, and skill audit tables through Phase 185 Plan 185-01 are archived in [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md).
- Phase 188 auto-fixed initial Pi validation marker loss by restoring exact guardrail phrases in thinner Pi skill wrappers; final validation passed.

### Deferred Issues

- ci-generation.md and sonarqube-integration.md — future module candidates.
- Agent SDK hook dispatch shelved — not an active milestone driver.
- Tree-sitter repo map deferred.
- Multi-model routing exists via `pals.json` `agents`, `agent-dispatch.md`, and apply-phase dispatch logic.

### Blockers/Concerns

- Future work should preserve artifact-first truth and resist telemetry, Pi-owned execution state, or reopening the settled Phase 69/70 contract without new evidence.
- v2.44 slimming must not weaken PLAN/APPLY/UNIFY, GitHub Flow, module dispatch, archive authority, or parent-owned APPLY boundaries; future work should clarify Claude Code support tier before investing in Claude-specific polish.

### Git State

Branch: main
Phase transition commit: main transition commit after PR #100 squash merge 5d03e3b7
PR: https://github.com/coctostan/pals/pull/100 (MERGED)
CI: passing — local Pi 177/177, cross-harness 90/90, and Socket Security checks passed before merge
Prior PRs: #100 merged (Phase 188 Plan 188-01); #99 merged (Phase 187 Plan 187-01 / v2.43 closed); #98 merged (Phase 186 Plan 186-01); #97 merged (Phase 185 Plan 185-03); #96 merged (Phase 185 Plan 185-02); #95 merged (Phase 185 Plan 185-01); #94 merged (Phase 184); #93 merged (Phase 183 / v2.42 closed); #92 merged (Phase 182); #91 merged (Phase 181); #90 merged (Phase 180 / v2.41 closed)

## Session Continuity

Last session: 2026-04-27T00:55:00Z
Stopped at: APPLY complete; UNIFY pending
Next action: Run /paul:unify .paul/phases/189-hot-path-read-audit/189-01-PLAN.md
Resume file: .paul/handoffs/archive/HANDOFF-2026-04-27-phase-189-plan-awaiting-approval.md (consumed)
Resume context:
- Plan 189-01 APPLY produced `.paul/phases/189-hot-path-read-audit/189-01-HOT-PATH-READ-AUDIT.md` (330 lines).
- Validation: pi-end-to-end 177/177; cross-harness 90/90 — unchanged from baseline.
- Findings F1–F8 ranked; recommendations R1–R10 mapped to Phase 190 / Phase 191 / future product decisions; Do Not Do section preserved.
- Branch: feature/189-hot-path-read-audit; postflight will push + open PR per pals.json (auto_push, auto_pr, ci_checks all true).