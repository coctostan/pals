# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-04-27 after v2.45 milestone creation)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.45 Pi-Native PALS Architecture is active; Phase 194 Context-Efficiency Architecture is complete and Phase 195 Exploratory Pi-Native Spikes is ready for planning.

## Current Position

Milestone: v2.45 Pi-Native PALS Architecture
Phase: 195 of 196 (Exploratory Pi-Native Spikes) — Planning
Plan: Not started
Status: Ready to plan Phase 195
Last activity: 2026-04-27T16:06:00Z — Phase 194 complete, PR #108 merged, transitioned to Phase 195 planning
Progress:
- v2.42 CODI v0.1 — Post-Unify Instrumentation Fix: [██████████] 100% (CODI v0.1 shipped as good enough; fresh quark validation intentionally skipped)
- v2.43 PALS Context Diet — Archive, Compact, Compress: [██████████] 100% (4 of 4 phases complete)
- v2.44 PALS Context Optimization — Process & Artifacts: [██████████] 100% (4 of 4 phases complete: 188 ✓, 189 ✓, 190 ✓, 191 ✓)
- v2.45 Pi-Native PALS Architecture: [██████░░░░] 60% (3 of 5 phases complete; Phase 195 planning next)
- Phase 192 Support-Tier Reset + Surface Inventory: [██████████] 100% complete
- Phase 193 Pi Runtime Capability Mapping: [██████████] 100% complete
- Phase 194 Context-Efficiency Architecture: [██████████] 100% complete
- Phase 195 Exploratory Pi-Native Spikes: [░░░░░░░░░░] 0% (ready for PLAN)

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ○        ○        ○     [Ready for next PLAN]
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
- v2.45 has been created as an architecture/design milestone: reset Claude Code support tier to unsupported/frozen, map Pi runtime capabilities, design context-efficiency architecture, allow bounded Pi-native code spikes, and produce a final migration/implementation roadmap.
- Phase 192 completed the support-tier reset: Pi is documented as the supported runtime, Claude Code / Agent SDK are unsupported/frozen historical surfaces, portability docs are historical/frozen references, and `docs/PI-NATIVE-SUPPORT-INVENTORY.md` is the source artifact for Phase 193+ capability mapping.
- Phase 193 completed the Pi runtime capability map in `docs/PI-RUNTIME-CAPABILITY-MAP.md`, classifying current Pi primitives and documenting Phase 194 design inputs while preserving `.paul/*` authority, module evidence, GitHub Flow gates, and parent-owned APPLY boundaries.
- Phase 194 created `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md`, defining context-cost surfaces, Pi-native assistance components, read/citation contracts, rejected designs, Phase 195 spike backlog, validation redesign requirements, and Phase 196 open decisions while preserving design-only scope.

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
| Declare Claude Code compatibility unsupported/frozen and allow PALS architecture to become Pi-native | v2.45 milestone creation | Future work may stop maintaining Claude-specific wrappers/prompts and leverage Pi extensions without preserving cross-harness parity. |
| Record Pi as the supported runtime and classify Claude Code / Agent SDK as unsupported/frozen historical surfaces | Phase 192 Plan 192-01 APPLY | README, portability docs, and new inventory now route future v2.45 work through Pi-native support-tier assumptions while preserving `.paul/*` artifact authority. |
| Classify Pi runtime assistance as derived, bounded, and artifact-backed rather than authoritative lifecycle state | Phase 193 Plan 193-01 APPLY | Phase 194 may design Pi-native context-efficiency helpers, but they must cite `.paul/*`/workflow artifacts and preserve module evidence, GitHub Flow gates, and parent-owned APPLY. |
| Keep Pi-native context assistance derived, bounded, disposable, and source-cited | Phase 194 Plan 194-01 UNIFY | Phase 195 spikes may reduce context cost through artifact slices, capsules, lenses, and guided UI, but `.paul/*`, installed resources, git/PR evidence, and validation output remain authoritative. |
| Start Phase 195 with read-only artifact-slice context loading | Phase 194 Plan 194-01 UNIFY | The first spike should prove the citation/freshness/fallback contract without lifecycle writes or hidden Pi state. |
| Evolve validation toward Pi-supported runtime checks plus shared invariant protection | Phase 194 Plan 194-01 UNIFY | Frozen Claude Code / Agent SDK parity should be classified as historical parity and not silently block Pi-native architecture decisions. |

Detailed historical decisions, fixes, deviations, skill audits, and deferred issues: [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md)

### Fixes / Deviations / Skill Audits

- Historical fix log, deviation log, and skill audit tables through Phase 185 Plan 185-01 are archived in [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md).
- Phase 188 auto-fixed initial Pi validation marker loss by restoring exact guardrail phrases in thinner Pi skill wrappers; final validation passed.
- Phase 190 Plan 190-01 recorded a verification-count deviation: approved plan expected 11 `<details>` blocks, actual ROADMAP source had 57 `<details>` lines under 11 completed-milestone headings; APPLY preserved actual history verbatim.
- Phase 190 Plan 190-02 restored exact validation guardrail markers (`gh pr checks`, `gh pr merge`, `Durable Evidence Requirements`) after workflow/reference prose compaction; final Pi 177/177 and cross-harness 90/90 validation passed.
- Phase 191 noted existing validation harness size debt (`tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` remain >500 lines) but kept additions helper/loop based; no implementation deviation.
- Skill audit Phase 191: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch as required.
- Skill audit Phase 194: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify CODI/WALT/SKIP/RUBY persistence recorded in SUMMARY.

### Deferred Issues

- ci-generation.md and sonarqube-integration.md — future module candidates.
- Agent SDK hook dispatch shelved — not an active milestone driver.
- Tree-sitter repo map deferred.
- Multi-model routing exists via `pals.json` `agents`, `agent-dispatch.md`, and apply-phase dispatch logic.
- R5 Pi adapter modularization remains deferred to a future driver-quality milestone.

### Blockers/Concerns

- Future work should preserve artifact-first truth and resist telemetry, Pi-owned authoritative execution state, or reopening the settled Phase 69/70 contract without new evidence.
- The v2.45 architecture may use Pi runtime assistance aggressively, but it must reduce model context burden without creating an opaque control plane or weakening PLAN/APPLY/UNIFY, module evidence, GitHub Flow safety, or parent-owned APPLY boundaries.

### Git State

Branch: main
Last commit: e8aa93b6 — feat(194): complete context-efficiency architecture
PR: #108 MERGED — https://github.com/coctostan/pals/pull/108 (Phase 194 context-efficiency architecture)
CI: No blocking checks after final push; PR #108 merged; local validation passed Pi 183/183 and cross-harness 100/100
Prior PRs: #108 merged (Phase 194 context-efficiency architecture); #107 merged (Phase 193 runtime capability map and UNIFY artifacts); #106 merged (Phase 192 support-tier reset + UNIFY/transition artifacts); #105 merged (Phase 191 / v2.44 closed); #104 merged (Phase 190 Plan 190-02 APPLY/UNIFY artifacts); #103 merged (Phase 190 Plan 190-01 UNIFY artifacts); #102 merged (Phase 190 Plan 190-01 APPLY artifacts); #101 merged (Phase 189 Plan 189-01); #100 merged (Phase 188 Plan 188-01); #99 merged (Phase 187 Plan 187-01 / v2.43 closed); #98 merged (Phase 186 Plan 186-01); #97 merged (Phase 185 Plan 185-03); #96 merged (Phase 185 Plan 185-02); #95 merged (Phase 185 Plan 185-01); #94 merged (Phase 184); #93 merged (Phase 183 / v2.42 closed); #92 merged (Phase 182); #91 merged (Phase 181); #90 merged (Phase 180 / v2.41 closed)

## Session Continuity

Last session: 2026-04-27T16:06:00Z
Stopped at: Phase 194 complete; ready to plan Phase 195
Next action: Run /paul:plan for Phase 195 Exploratory Pi-Native Spikes
Resume file: .paul/ROADMAP.md
Resume context:
- Phase 194 created and merged `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` via PR #108.
- Phase 195 should start from the Phase 194 recommendation: a bounded, read-only artifact-slice context loading spike that proves citation, freshness, bounded output, and fallback-to-full-read behavior.
- Validation baseline remains green: Pi 183/183 and cross-harness 100/100.
- Preserve artifact-first truth, visible module evidence, GitHub Flow gates, and parent-owned APPLY while exploring Pi-native context assistance.