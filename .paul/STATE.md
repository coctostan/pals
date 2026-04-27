# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-04-27 after Phase 191 transition)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.44 PALS Context Optimization — Process & Artifacts is complete; all four phases (188-191) are unified and validation now protects the context-diet gains.

## Current Position

Milestone: v2.44 PALS Context Optimization — Process & Artifacts — Complete
Phase: 191 of 4 in v2.44 — Validation + Anti-Regrowth Update — Complete
Plan: 191-01 complete (`.paul/phases/191-validation-anti-regrowth-update/191-01-SUMMARY.md`)
Status: Milestone complete, ready for next milestone or release decision
Last activity: 2026-04-27T12:20:44Z — Completed UNIFY for Phase 191 Plan 191-01 and transitioned v2.44 to complete
Progress:
- v2.42 CODI v0.1 — Post-Unify Instrumentation Fix: [██████████] 100% (CODI v0.1 shipped as good enough; fresh quark validation intentionally skipped)
- v2.43 PALS Context Diet — Archive, Compact, Compress: [██████████] 100% (4 of 4 phases complete)
- v2.44 PALS Context Optimization — Process & Artifacts: [██████████] 100% (4 of 4 phases complete: 188 ✓, 189 ✓, 190 ✓, 191 ✓)

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ✓     [Loop complete - v2.44 milestone complete]
```

## Accumulated Context

### Current Summary

- PLAN/APPLY/UNIFY remains the authoritative PALS lifecycle loop.
- `.paul/*` artifacts remain lifecycle truth; archives under `.paul/archive/*` are authoritative historical artifacts, not disposable summaries.
- v2.43 completed the first context-diet wave: indexed archives, compact hot artifacts, centralized workflow/module prose, and anti-regrowth validation.
- v2.44 completed process/artifact context optimization across four phases:
  - Phase 188 reduced recurring prompt/skill wrapper read cost; selected wrapper total dropped from 406 to 296 lines while validation stayed green.
  - Phase 189 measured remaining hot-path reads and identified 8 findings (F1–F8) and 10 recommendations (R1–R10).
  - Phase 190 moved completed ROADMAP history into `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md`, compacted live `.paul/ROADMAP.md`, centralized GitHub Flow mechanics in `kernel/references/git-strategy.md`, hoisted module-dispatch taxonomy into `kernel/references/module-dispatch.md`, made APPLY optional refs conditional, and reduced target workflow/reference files by a net 335 lines.
  - Phase 191 updated Pi and cross-harness validation with structural anti-regrowth guardrails for active ROADMAP budgets, hot workflow/reference budgets, archive-link presence, bounded GitHub Flow duplication, and critical semantic markers; final validation passed Pi 183/183 and cross-harness 100/100.

### Current Decisions

| Decision | Source | Impact |
|----------|--------|--------|
| Ship CODI v0.1 as good enough and skip fresh quark natural validation | Phase 183 | Future CODI work should be real-usage-driven, not prerequisite to context-diet work. |
| Archive files remain authoritative historical truth | Phase 185 Plan 185-01 | Hot artifacts may link to cold archives instead of duplicating long history. |
| Define PALS process-level ROADMAP active-window/archive convention | Phase 185 Plan 185-03 | Future roadmap writes keep current routing inline, archive completed detail, and repair bloat without hidden state. |
| Centralize shared dispatch mechanics in `kernel/references/module-dispatch.md` while workflows keep hook-local obligations | Phase 186 Plan 186-01 | Hot PLAN/APPLY/UNIFY workflow prose is shorter without weakening module evidence, post-unify persistence, or merge-gate safety. |
| Guard context-diet gains with semantic validation and practical line ceilings | Phase 187 + Phase 191 | Future hot workflow edits must retain lifecycle/module/merge-gate markers and stay under anti-regrowth budgets. |
| Treat Claude Code command wrappers as legacy/reference thin pointers while keeping Pi skills as the active user-facing surface | Phase 188 Plan 188-01 | Future prompt-slimming should avoid expanding Claude-specific polish unless product strategy changes. |
| Hot-path read cost concentrates in `.paul/ROADMAP.md` history and duplicated GitHub Flow stanzas; Pi adapter modularization and Claude wrapper handling deferred to product decision | Phase 189 Plan 189-01 | Phase 190 targeted ROADMAP archive split + GitHub Flow centralization first; Pi adapter and Claude wrappers wait for explicit product-level support-tier decision. |
| Centralize GitHub Flow mechanics in `kernel/references/git-strategy.md` while keeping workflow-local merge/CI/review gates explicit | Phase 190 Plan 190-02 | Reduces duplicated workflow prose without weakening github-flow enforcement or status routing. |
| Make R5 Pi adapter modularization a future driver-quality milestone rather than Phase 190 scope | Phase 190 Plan 190-02 | v2.44 preserved current Pi adapter behavior while focusing on artifact/workflow read-cost reductions. |
| Prefer structural anti-regrowth checks over long exact-prose assertions | Phase 191 Plan 191-01 | Validation now protects context-diet gains with line budgets, archive pointers, occurrence ceilings, and short semantic anchors. |

Detailed historical decisions, fixes, deviations, skill audits, and deferred issues: [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md)

### Fixes / Deviations / Skill Audits

- Historical fix log, deviation log, and skill audit tables through Phase 185 Plan 185-01 are archived in [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md).
- Phase 188 auto-fixed initial Pi validation marker loss by restoring exact guardrail phrases in thinner Pi skill wrappers; final validation passed.
- Phase 190 Plan 190-01 recorded a verification-count deviation: approved plan expected 11 `<details>` blocks, actual ROADMAP source had 57 `<details>` lines under 11 completed-milestone headings; APPLY preserved actual history verbatim.
- Phase 190 Plan 190-02 restored exact validation guardrail markers (`gh pr checks`, `gh pr merge`, `Durable Evidence Requirements`) after workflow/reference prose compaction; final Pi 177/177 and cross-harness 90/90 validation passed.
- Phase 191 noted existing validation harness size debt (`tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` remain >500 lines) but kept additions helper/loop based; no implementation deviation.
- Skill audit Phase 191: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch as required.

### Deferred Issues

- ci-generation.md and sonarqube-integration.md — future module candidates.
- Agent SDK hook dispatch shelved — not an active milestone driver.
- Tree-sitter repo map deferred.
- Multi-model routing exists via `pals.json` `agents`, `agent-dispatch.md`, and apply-phase dispatch logic.
- R5 Pi adapter modularization remains deferred to a future driver-quality milestone.

### Blockers/Concerns

- Future work should preserve artifact-first truth and resist telemetry, Pi-owned execution state, or reopening the settled Phase 69/70 contract without new evidence.
- Future context optimization must not weaken PLAN/APPLY/UNIFY, GitHub Flow, module dispatch, archive authority, parent-owned APPLY boundaries, or Phase 191 anti-regrowth validation; future work should clarify Claude Code support tier before investing in Claude-specific polish.

### Git State

Branch: main
Last commit: 144ee543 — feat(191-validation-anti-regrowth): update guardrails (#105)
PR: #105 MERGED — https://github.com/coctostan/pals/pull/105 (Phase 191 Plan 191-01 APPLY + UNIFY/transition artifacts)
CI: local validation passing — Pi 183/183 and cross-harness 100/100; GitHub status checks reported none after final push and PR #105 was mergeable/clean
Prior PRs: #105 merged (Phase 191 / v2.44 closed); #104 merged (Phase 190 Plan 190-02 APPLY/UNIFY artifacts); #103 merged (Phase 190 Plan 190-01 UNIFY artifacts); #102 merged (Phase 190 Plan 190-01 APPLY artifacts); #101 merged (Phase 189 Plan 189-01); #100 merged (Phase 188 Plan 188-01); #99 merged (Phase 187 Plan 187-01 / v2.43 closed); #98 merged (Phase 186 Plan 186-01); #97 merged (Phase 185 Plan 185-03); #96 merged (Phase 185 Plan 185-02); #95 merged (Phase 185 Plan 185-01); #94 merged (Phase 184); #93 merged (Phase 183 / v2.42 closed); #92 merged (Phase 182); #91 merged (Phase 181); #90 merged (Phase 180 / v2.41 closed)

## Session Continuity

Last session: 2026-04-27T12:28:00Z
Stopped at: Phase 191 and v2.44 milestone complete; PR #105 merged to main
Next action: Choose next milestone/release action
Resume file: .paul/phases/191-validation-anti-regrowth-update/191-01-SUMMARY.md
Resume context:
- Phase 191 added structural anti-regrowth helpers/checks to `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh`.
- Validation passes: Pi 183/183 and cross-harness 100/100.
- Post-unify persistence updated `.paul/quality-history.md` and `.paul/CODI-HISTORY.md`.
- v2.44 is complete and PR #105 is merged to main.