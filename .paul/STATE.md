# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-04-28 after Phase 204 Documentation + Skill Map Surfacing completion)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.47 Artifact-Slice Contract Hardening is in progress; Phase 204 Documentation + Skill Map Surfacing is complete and Phase 205 Validation + Evidence Reconciliation is ready to plan.

## Current Position

Milestone: v2.47 Artifact-Slice Contract Hardening
Phase: 205 of 205 (Validation + Evidence Reconciliation) — Ready to plan
Plan: Not started
Status: Ready to plan Phase 205
Last activity: 2026-04-28T00:40:35Z — Phase 204 complete; documentation/skill-map surfacing unified and transitioned to Phase 205
Progress:
- v2.42 CODI v0.1 — Post-Unify Instrumentation Fix: [██████████] 100% (CODI v0.1 shipped as good enough; fresh quark validation intentionally skipped)
- v2.43 PALS Context Diet — Archive, Compact, Compress: [██████████] 100% (4 of 4 phases complete)
- v2.44 PALS Context Optimization — Process & Artifacts: [██████████] 100% (4 of 4 phases complete: 188 ✓, 189 ✓, 190 ✓, 191 ✓)
- v2.45 Pi-Native PALS Architecture: [██████████] 100% (5 of 5 phases complete; final architecture proposal complete)
- v2.46 Pi-Native Implementation Planning: [██████████] 100% (5 of 5 phases complete; final implementation plan proposal complete)
- v2.47 Artifact-Slice Contract Hardening: [███████░░░] 75% (3 of 4 phases complete; Phase 205 ready to plan)
- Phase 202 Slice Inventory + Contract Baseline: [██████████] 100% complete — artifact-slice contract baseline created and unified
- Phase 203 Runtime Slice Hardening: [██████████] 100% complete — runtime hardening shipped and merged via PR #117
- Phase 204 Documentation + Skill Map Surfacing: [██████████] 100% complete — docs/skill-map surfacing unified and merged via PR #118
- Phase 197 v2.45 Findings Triage: [██████████] 100% complete — findings triage artifact created and unified
- Phase 198 Implementation Workstream Design: [██████████] 100% complete — workstream design artifact unified
- Phase 199 Sequencing + Dependency Plan: [██████████] 100% complete — sequencing/dependency artifact unified
- Phase 200 Validation + Evidence Strategy: [██████████] 100% complete — validation/evidence strategy artifact unified
- Phase 201 Final Implementation Plan Proposal: [██████████] 100% complete — final implementation plan proposal created and unified

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ○        ○        ○     [Phase 205 ready to plan]
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
- Phase 195 completed the first read-only artifact-slice spike: the Pi extension now emits bounded, source-cited, freshness-marked slices for `.paul/STATE.md`, `.paul/ROADMAP.md`, and discoverable current PLAN artifacts only behind explicit PALS activation; docs and validation preserve the fallback-to-full-read and no-hidden-state contract; final validation passed Pi 186/186 and cross-harness 100/100.
- Phase 196 created the final Pi-native architecture proposal in `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md`, promoting activation-gated artifact-slice loading as the first proven context-efficiency implementation pattern and defining migration, implementation, validation, legacy-surface, and follow-on milestone guidance.
- v2.46 has been created as an implementation-planning milestone: process v2.45 findings and architecture into concrete workstreams, sequencing, validation/evidence strategy, and a final executable implementation plan before build milestones begin.
- Phase 197 completed v2.45 findings triage in `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md`, giving Phases 198-201 source-cited planning input across settled decisions, authority boundaries, promoted/rejected options, workstream seeds, open questions, handoff recommendations, and readiness criteria.
- Phase 198 created `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md`, a source-cited planning-only workstream design artifact classifying six candidate workstreams, per-workstream outputs/surfaces/validation/boundaries/dependencies/open questions, and Phase 199 sequencing/dependency handoff inputs.
- Phase 199 created `docs/PI-NATIVE-SEQUENCING-DEPENDENCY-PLAN.md`, a source-cited planning-only sequencing/dependency artifact recommending default workstream order, viable alternatives, dependency matrix, risk gates, split/merge recommendations, Phase 200 validation/evidence handoff, Phase 201 roadmap inputs, and sequencing readiness criteria.
- Phase 200 created and unified `docs/PI-NATIVE-VALIDATION-EVIDENCE-STRATEGY.md`, defining command-output validation truth, validation-class taxonomy, current Pi/cross-harness suite classification, future workstream evidence requirements, durable artifact evidence rules, Phase 201 handoff, and readiness checklist while preserving docs-only scope and green validation.
- Phase 201 created and unified `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md`, the final v2.46 implementation-plan proposal recommending Artifact-Slice Contract Hardening first, Guided Workflow Evidence Hardening second, Workflow/Resource Capsule Contract third, Delegated APPLY Packet/Report Contract fourth, Pi-Native Validation Classification fifth, and Legacy Retention / Install-Surface Cleanup last while preserving docs-only scope and command-output validation truth.
- v2.47 has been created as the first Pi-native build milestone after v2.46: Artifact-Slice Contract Hardening will harden the activation-gated, bounded, source-cited, freshness-aware artifact-slice contract and full-read fallback before broader capsules, helper compression, validation classification, or legacy cleanup.
- Phase 202 created and unified `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md`, defining the named slice inventory, stable output schema, freshness/bounds/fallback rules, validation classes, marker-check families, failure conditions, durable evidence requirements, and Phase 203 runtime-hardening handoff while preserving docs-only scope and green validation.
- Phase 203 APPLY hardened the repo-source Pi artifact-slice runtime for `current-lifecycle-state`, `active-roadmap-phase`, and `approved-plan-task-packet`; updated Pi extension docs and skill map; extended runtime-lens validation markers; final validation passed Pi 187/187 and cross-harness 100/100.
- Phase 204 created and unified docs/skill-map surfacing for hardened artifact slices in `README.md`, `drivers/pi/extensions/README.md`, and `drivers/pi/skill-map.md`; marker grep passed and validation remained green (Pi 187/187, cross-harness 100/100); PR #118 merged.

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
| Promote artifact-slice loading as a candidate Pi-native context-efficiency pattern for Phase 196 | Phase 195 Plan 195-01 UNIFY | The spike proved activation-gated, bounded, source-cited, freshness-marked, read-only runtime context assistance can reduce repeated read burden without replacing `.paul/*` truth or GitHub Flow gates. |
| Promote activation-gated artifact-slice loading as the first implementation pattern for Pi-native context efficiency | Phase 196 Plan 196-01 UNIFY | Next implementation milestone should harden the artifact-slice contract before workflow capsules, guided UI hardening, helper-agent packet compression, validation classification, or legacy cleanup. |
| Create v2.46 as implementation-planning before implementation hardening | v2.46 milestone creation | The next milestone should process v2.45 findings and architecture into an executable implementation plan before starting artifact-slice contract hardening or later build work. |
| Complete Phase 197 findings triage before designing workstreams | Phase 197 Plan 197-01 UNIFY | `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` is the Phase 198-201 planning input: it classifies v2.45 decisions, boundaries, promoted/rejected patterns, workstream seeds, open questions, and readiness criteria without authorizing implementation hardening. |
| Treat artifact-slice contract hardening as the most implementation-ready candidate while leaving final sequencing to Phase 199 | Phase 198 Plan 198-01 UNIFY | Phase 199 should test whether artifact slices go first and whether the workstream should split; Phase 198 does not finalize build order. |
| Keep validation classification before legacy cleanup | Phase 198 Plan 198-01 UNIFY | Legacy retention/install-surface cleanup remains deferred until shared-invariant vs frozen-parity validation checks are classified and protected. |
| Recommend artifact-slice contract hardening first, guided workflow evidence second, workflow/resource capsules third, helper packet/report compression fourth, validation classification fifth, and legacy cleanup last as the default sequencing hypothesis | Phase 199 Plan 199-01 UNIFY | Phase 200 should pressure-test the order through validation/evidence strategy, and Phase 201 should decide final executable build milestones without treating Phase 199 as implementation authorization. |
| Require command-output validation truth and validation-class labeling before future Pi-native implementation plans weaken, relocate, archive, or delete checks | Phase 200 Plan 200-01 UNIFY | Phase 201 must carry explicit validation classes, command-output evidence, durable artifact evidence, fallback triggers, and non-authority boundaries into executable implementation milestone proposals. |
| Recommend Artifact-Slice Contract Hardening as the next Pi-native build milestone | Phase 201 Plan 201-01 UNIFY | The next milestone should harden activation-gated, bounded, source-cited, freshness-aware artifact slices and full-read fallback before broader capsules, helper compression, validation classification, or legacy cleanup. |
| Create v2.47 Artifact-Slice Contract Hardening as the first Pi-native build milestone | v2.47 milestone creation | Phase 202 should define the named slice inventory, schema, freshness/bounds/fallback rules, validation classes, protected files, and non-goals before runtime slice hardening begins. |
| Define artifact-slice contract baseline before runtime hardening | Phase 202 Plan 202-01 UNIFY | Phase 203 must cite `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md`, name implemented slices, declare validation classes, preserve full-read fallback, and avoid broader capsules/helper compression/validation classification/legacy cleanup unless separately approved. |
| Surface artifact slices as orientation aids without weakening full-read fallback or command-output truth | Phase 204 Plan 204-01 UNIFY | Future docs and Pi context surfaces must keep artifact slices discovery-oriented, source-cited, bounded, read-only, disposable, and non-authoritative; `.paul/*`, workflow artifacts, GitHub Flow evidence, module reports, and validation command output remain authoritative. |

Detailed historical decisions, fixes, deviations, skill audits, and deferred issues: [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md)

### Fixes / Deviations / Skill Audits

- Historical fix log, deviation log, and skill audit tables through Phase 185 Plan 185-01 are archived in [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md).
- Phase 188 auto-fixed initial Pi validation marker loss by restoring exact guardrail phrases in thinner Pi skill wrappers; final validation passed.
- Phase 190 Plan 190-01 recorded a verification-count deviation: approved plan expected 11 `<details>` blocks, actual ROADMAP source had 57 `<details>` lines under 11 completed-milestone headings; APPLY preserved actual history verbatim.
- Phase 190 Plan 190-02 restored exact validation guardrail markers (`gh pr checks`, `gh pr merge`, `Durable Evidence Requirements`) after workflow/reference prose compaction; final Pi 177/177 and cross-harness 90/90 validation passed.
- Phase 191 noted existing validation harness size debt (`tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` remain >500 lines) but kept additions helper/loop based; no implementation deviation.
- Skill audit Phase 191: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch as required.
- Skill audit Phase 194: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify CODI/WALT/SKIP/RUBY persistence recorded in SUMMARY.
- Skill audit Phase 195: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify CODI/WALT/SKIP/RUBY persistence recorded in SUMMARY.
- Phase 195 validation adaptation: installer verification used `PALS_ROOT="$PWD" bash drivers/pi/install.sh`; no implementation deviation.
- Skill audit Phase 196: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify WALT/SKIP/CODI/RUBY persistence recorded in SUMMARY.
- Skill audit Phase 197: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify WALT/SKIP/CODI/RUBY persistence recorded in SUMMARY.
- Skill audit Phase 198: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify WALT/SKIP/CODI/RUBY persistence recorded in SUMMARY.
- Skill audit Phase 199: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify WALT/SKIP/CODI/RUBY persistence recorded in SUMMARY.
- Skill audit Phase 200: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify WALT/SKIP/CODI/RUBY persistence recorded in SUMMARY.
- Skill audit Phase 201: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify WALT/SKIP/CODI/RUBY persistence recorded in SUMMARY.
- Skill audit Phase 202: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify WALT/SKIP/CODI/RUBY persistence recorded in SUMMARY.
- Skill audit Phase 203 APPLY: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-task and post-apply validation passed with no regression. Minor adaptation: Task 3 tightened `drivers/pi/extensions/pals-hooks.ts` authority wording to add the enforced no-hidden-persistence marker.
- Skill audit Phase 204: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify WALT/SKIP/CODI/RUBY persistence recorded in SUMMARY. Active handoff archived after resume proceeded.

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

Branch: main after PR #118 squash merge
Last commit: Phase 204 UNIFY metadata committed on feature branch before PR #118 merge
PR: #118 MERGED — https://github.com/coctostan/pals/pull/118
CI: passing — Socket Security Project Report PASS; Pull Request Alerts PASS; local validation passed marker grep, Pi 187/187 and cross-harness 100/100
Prior PRs: #117 merged (Phase 203 runtime slice hardening); #116 merged (Phase 202 artifact-slice contract baseline); #115 merged (Phase 201 final implementation plan proposal); #114 merged (Phase 200 validation evidence strategy); #113 merged (Phase 199 sequencing dependency plan); #109 merged (Phase 195 exploratory Pi-native spikes); #108 merged (Phase 194 context-efficiency architecture); #107 merged (Phase 193 runtime capability map and UNIFY artifacts); #106 merged (Phase 192 support-tier reset + UNIFY/transition artifacts); #105 merged (Phase 191 / v2.44 closed); #104 merged (Phase 190 Plan 190-02 APPLY/UNIFY artifacts); #103 merged (Phase 190 Plan 190-01 UNIFY artifacts); #102 merged (Phase 190 Plan 190-01 APPLY artifacts); #101 merged (Phase 189 Plan 189-01); #100 merged (Phase 188 Plan 188-01); #99 merged (Phase 187 Plan 187-01 / v2.43 closed); #98 merged (Phase 186 Plan 186-01); #97 merged (Phase 185 Plan 185-03); #96 merged (Phase 185 Plan 185-02); #95 merged (Phase 185 Plan 185-01); #94 merged (Phase 184); #93 merged (Phase 183 / v2.42 closed); #92 merged (Phase 182); #91 merged (Phase 181); #90 merged (Phase 180 / v2.41 closed)

## Session Continuity

Last session: 2026-04-28T00:40:35Z
Stopped at: Phase 204 complete; ready to plan Phase 205
Next action: Run /paul:plan for Phase 205 Validation + Evidence Reconciliation
Resume file: .paul/phases/204-documentation-skill-map-surfacing/204-01-SUMMARY.md
Resume context:
- Phase 204 Plan 204-01 completed documentation-only surfacing for `README.md`, `drivers/pi/extensions/README.md`, and `drivers/pi/skill-map.md`.
- Validation passed marker grep, Pi 187/187, and cross-harness 100/100.
- Phase 205 should reconcile validation/evidence markers while preserving documentation-only boundaries unless a new plan approves implementation changes.