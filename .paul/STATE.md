# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-04-29 after Phase 216 Documentation + Validation Surfacing completion)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.50 Delegated APPLY Packet/Report Contract is active; Phase 216 Documentation + Validation Surfacing is complete and Phase 217 Evidence Reconciliation + Milestone Closure is ready to plan.

## Current Position

Milestone: v2.50 Delegated APPLY Packet/Report Contract
Phase: 217 of 217 (Evidence Reconciliation + Milestone Closure) — Ready to plan
Plan: Not started
Status: Ready to plan Phase 217
Last activity: 2026-04-29T02:07:54Z — Completed UNIFY and transition for Phase 216; validation passed Pi 199/199 and cross-harness 115/115
Progress:
- v2.42 CODI v0.1 — Post-Unify Instrumentation Fix: [██████████] 100% (CODI v0.1 shipped as good enough; fresh quark validation intentionally skipped)
- v2.43 PALS Context Diet — Archive, Compact, Compress: [██████████] 100% (4 of 4 phases complete)
- v2.44 PALS Context Optimization — Process & Artifacts: [██████████] 100% (4 of 4 phases complete: 188 ✓, 189 ✓, 190 ✓, 191 ✓)
- v2.45 Pi-Native PALS Architecture: [██████████] 100% (5 of 5 phases complete; final architecture proposal complete)
- v2.46 Pi-Native Implementation Planning: [██████████] 100% (5 of 5 phases complete; final implementation plan proposal complete)
- v2.47 Artifact-Slice Contract Hardening: [██████████] 100% (4 of 4 phases complete; milestone closed)
- v2.48 Guided Workflow Evidence Hardening: [██████████] 100% (4 of 4 phases complete; milestone closed)
- v2.49 Workflow/Resource Capsule Contract: [██████████] 100% (4 of 4 phases complete; milestone closed)
- v2.50 Delegated APPLY Packet/Report Contract: [████████░░] 75% (3 of 4 phases complete; Phase 217 ready to plan)
- Phase 206 Guided Workflow Evidence Contract Baseline: [██████████] 100% complete
- Phase 207 Runtime Guided Reply Hardening: [██████████] 100% complete
- Phase 208 Documentation + Validation Surfacing: [██████████] 100% complete
- Phase 209 Evidence Reconciliation + Milestone Closure: [██████████] 100% complete
- Phase 210 Workflow/Resource Capsule Contract Baseline: [██████████] 100% complete
- Phase 211 Runtime Capsule Loading Hardening: [██████████] 100% complete
- Phase 212 Documentation + Validation Surfacing: [██████████] 100% complete
- Phase 213 Evidence Reconciliation + Milestone Closure: [██████████] 100% complete
- Phase 214 Delegated APPLY Packet/Report Contract Baseline: [██████████] 100% complete
- Phase 215 Runtime Delegation Packet/Report Hardening: [██████████] 100% complete
- Phase 216 Documentation + Validation Surfacing: [██████████] 100% complete
- Phase 217 Evidence Reconciliation + Milestone Closure: [░░░░░░░░░░] 0% ready to plan

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ✓     [Loop complete - ready for next PLAN]
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
- Phase 205 reconciled validation/evidence markers for the hardened artifact-slice surfaces: Pi validation now passes 188/188, cross-harness validation passes 104/104, the artifact-slice contract records current baselines, and PR #119 merged with Socket checks passing.
- v2.48 has been created as the second Pi-native build milestone after v2.46: Guided Workflow Evidence Hardening will prove explicit canonical transcript replies, no-auto-continue behavior, no UI-only lifecycle decisions, checkpoint/approval blocking, and merge-gate routing evidence before broader workflow/resource capsules or helper packet/report compression.
- Phase 206 created and unified `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`, defining guided workflow moment inventory, canonical transcript replies, explicit no-auto/no-UI-only boundaries, validation classes, failure conditions, and Phase 207/208/209 handoffs; marker greps passed, Pi validation passed 188/188, cross-harness validation passed 104/104, and PR #121 merge gate was handled during UNIFY.
- Phase 207 completed runtime hardening in `drivers/pi/extensions/pals-hooks.ts` with contract-backed `merge-gate-routing`, display-only guided workflow config handling, explicit confirm/select-only canonical reply delivery, notify-only no-reply behavior, and durable no-auto/no-UI-only/no-inferred-merge markers; `PALS_ROOT="$PWD" bash drivers/pi/install.sh`, Pi validation 188/188, and cross-harness validation 104/104 passed; PR #122 merged via squash as `688532cc`.
- Phase 208 completed docs/settings and validation surfacing for guided workflow evidence: README/Pi docs/skill-map/schema docs now describe canonical transcript replies, explicit confirm/select behavior, notify-only no-reply behavior, display-only `guided_workflow.auto_present`, checkpoint blocking, no-auto/no-UI-only/no-inferred-merge boundaries, and command-output truth; Pi validation now passes 192/192 and cross-harness validation passes 108/108; PR #123 merged via squash as `60a9d113`.
- Phase 209 completed evidence reconciliation and milestone closure for v2.48: `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` now distinguishes historical Phase 205/206 baselines (Pi 188/188, cross-harness 104/104) from the post-Phase-207/208 closure baseline (Pi 192/192, cross-harness 108/108); validation suites now protect the closure markers and pass Pi 193/193 and cross-harness 109/109; SUMMARY `.paul/phases/209-evidence-reconciliation-milestone-closure/209-01-SUMMARY.md` hands off to the Workflow/Resource Capsule Contract milestone.
- v2.49 Workflow/Resource Capsule Contract has been created as the third Pi-native build milestone after v2.46: it will define and harden safe orientation capsules for installed resources without replacing authoritative workflow reads, blocking semantics, `.paul/*`, PLAN/APPLY/UNIFY, module evidence, GitHub Flow evidence, or command-output validation truth.
- Phase 210 completed the workflow/resource capsule contract baseline in `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md`: capsules are installed-resource orientation aids only, must expose source/type/freshness/bounds/fallback/`Derived aid only` markers, exclude STOP/DO NOT SKIP/checkpoint/lifecycle/module/GitHub Flow/validation authority, and require full authoritative reads before consequential workflow action; validation remained Pi 193/193 and cross-harness 109/109.
- Phase 211 completed runtime capsule loading hardening in `drivers/pi/extensions/pals-hooks.ts`: the Pi runtime now emits bounded workflow/resource capsules after artifact slices only through explicit PALS activation; capsules include `Capsule:`, `Source:`, `Source type:`, `Freshness:`, `Bounds:`, `Fallback:`, and `Authority: Derived aid only` markers, cite repo/logical installed resources, degrade safely to full-read fallback, and preserve no hidden persistence/no lifecycle authority/no auto-approval/no skipped-checkpoint boundaries; validation remained Pi 193/193 and cross-harness 109/109.
- Phase 212 completed docs and validation surfacing for workflow/resource capsules without runtime edits: README/Pi docs/skill-map now name `plan-task-anatomy`, `checkpoint-type-orientation`, `module-dispatch-evidence-orientation`, and `github-flow-phase-orientation`; validation protects runtime/doc/schema/fallback/non-authority markers with `Workflow/Resource Capsule Context — Pi-Supported Runtime` and `Workflow/Resource Capsule Context — Shared Invariant`; focused greps passed; Pi validation increased 193→196 and passed 196/196; cross-harness validation increased 109→111 and passed 111/111; SUMMARY `.paul/phases/212-documentation-validation-surfacing/212-01-SUMMARY.md` hands off to Phase 213 evidence reconciliation.
- Phase 213 completed evidence reconciliation and milestone closure for v2.49: `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md` now records Phase 210/211 historical baselines (Pi 193/193, cross-harness 109/109), Phase 212 PR #127 closure-entry evidence (Pi 196/196, cross-harness 111/111), and final Phase 213 counts (Pi 197/197, cross-harness 112/112); validation suites protect closure markers and count-change reconciliation requirements; PR #128 merged.
- v2.50 Delegated APPLY Packet/Report Contract has been created as the fourth Pi-native build milestone after v2.46: it will reduce parent context cost for bounded `pals-implementer` tasks through formal task packets and structured reports while preserving parent APPLY authority, official verification, file-scope checks, fallback judgment, module gates, checkpoints, `.paul/*` lifecycle writes, and command-output truth.
- Phase 214 completed the delegated APPLY packet/report contract baseline in `docs/PI-NATIVE-DELEGATED-APPLY-PACKET-REPORT-CONTRACT.md`: the contract defines parent-owned task packets, structured helper reports, allowed/forbidden file scope, full-read fallback triggers, validation classes including Helper Delegation and Shared Invariant, marker-check families, command-output evidence requirements, failure conditions, and Phase 215/216/217 handoffs while preserving parent APPLY authority; validation remained Pi 197/197 and cross-harness 112/112.
- Phase 215 completed runtime delegation packet/report hardening in `kernel/workflows/apply-phase.md` and `.pi/agents/pals-implementer.md`: parent-owned packets now name required fields and authority boundaries, structured helper reports feed parent review, actual changed-file diffs are checked against allowed files, out-of-scope helper edits block until repaired or guidance is requested, and helper output cannot claim lifecycle/validation/module/checkpoint/GitHub Flow authority; validation remained Pi 197/197 and cross-harness 112/112.
- Phase 216 completed documentation and validation surfacing for delegated APPLY packet/report guarantees in README, Pi extension docs, Pi skill map, the repo-local `pals-implementer` contract, and validation suites; validation passes Pi 199/199 and cross-harness 115/115, with Phase 217 still owning final milestone evidence reconciliation and closure.

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
| Close v2.47 with validation/evidence reconciliation only | Phase 205 Plan 205-01 UNIFY | Artifact-slice contract hardening is complete; broader guided workflow evidence, capsules, helper compression, validation classification, and legacy cleanup remain future milestones. |
| Create v2.48 Guided Workflow Evidence Hardening as the second Pi-native build milestone | Phase 206 Plan 206-01 creation | Phase 206 starts with a contract baseline for guided moments, canonical replies, transcript evidence, validation classes, no-auto/no-UI-only boundaries, and Phase 207+ runtime/docs/validation handoffs before changing guided workflow behavior. |
| Define guided workflow evidence contract baseline before runtime guided reply hardening | Phase 206 Plan 206-01 UNIFY | Phase 207 should harden `drivers/pi/extensions/pals-hooks.ts` against `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`, preserving transcript-visible canonical replies, no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent. |
| Treat merge-gate routing as a guided runtime moment without merge authority | Phase 207 Plan 207-01 UNIFY | Pi may surface GitHub Flow route prompts and send exact selected canonical replies, but it must never run git/gh commands, bypass CI/reviews, or infer merge approval from displayed state. |
| Keep guided_workflow.auto_present display-only | Phase 207 Plan 207-01 UNIFY | Future docs/validation should describe guided workflow config as UI display behavior only; it cannot approve, continue, complete checkpoints, or create lifecycle state. |
| Surface guided_workflow.auto_present as display-only and protect guided workflow evidence with structural marker checks | Phase 208 Plan 208-01 UNIFY | Future docs/validation must keep Pi guided workflow UX as adapter-side canonical reply routing only; marker checks should protect semantics without brittle exact-prose assertions. |
| Close v2.48 with evidence reconciliation only and hand off to Workflow/Resource Capsule Contract | Phase 209 Plan 209-01 UNIFY | Guided Workflow Evidence Hardening is complete; future work should build workflow/resource capsule contracts without reopening runtime guided reply behavior, broad validation classification, helper compression, legacy cleanup, or lifecycle authority. |
| Define workflow/resource capsule contract before runtime loading | Phase 210 Plan 210-01 UNIFY | Phase 211 must harden runtime capsule loading against `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md`, preserving installed-resource citations, schema markers, blocking-semantics exclusions, full-read fallback, command-output truth, and derived-only non-authority boundaries. |
| Keep workflow/resource capsules as activation-gated derived aids with mandatory full-read fallback | Phase 211 Plan 211-01 UNIFY | Future capsule surfacing must cite repo/logical installed resources, stay bounded and fallback-safe, and never replace `.paul/*`, installed workflow/reference reads, module/GitHub Flow/validation evidence, checkpoints, approvals, parent-owned APPLY, or lifecycle writes. |
| Use explicit workflow/resource capsule validation class names across docs and validation | Phase 212 Plan 212-01 UNIFY | Future capsule evidence should cite `Workflow/Resource Capsule Context — Pi-Supported Runtime` and `Workflow/Resource Capsule Context — Shared Invariant` when reconciling runtime/docs/shared-invariant marker coverage. |
| Close v2.49 with evidence reconciliation only and hand off to Delegated APPLY Packet/Report Contract | Phase 213 Plan 213-01 UNIFY | Workflow/resource capsules are complete; future work should focus on bounded delegated APPLY packet/report compression while preserving parent-owned APPLY and command-output truth. |
| Create v2.50 Delegated APPLY Packet/Report Contract as the next Pi-native build milestone | v2.50 milestone creation | Phase 214 should define the packet/report contract before runtime helper compression, preserving parent-owned APPLY, allowed-file boundaries, fallback triggers, and helper delegation validation evidence. |
| Define the delegated APPLY packet/report contract before runtime hardening | Phase 214 Plan 214-01 UNIFY | Phase 215 should harden repo-source APPLY/helper-agent delegation against `docs/PI-NATIVE-DELEGATED-APPLY-PACKET-REPORT-CONTRACT.md`, preserving parent-owned official verification, module gates, fallback judgment, changed-file scope checks, checkpoints, GitHub Flow gates, command-output truth, and `.paul/*` lifecycle writes. |
| Enforce parent-owned task packets and actual changed-file diff checks before accepting delegated helper work | Phase 215 Plan 215-01 UNIFY | Future bounded `pals-implementer` tasks can reduce parent context cost through packet/report structure, but parent APPLY must inspect report completeness, actual `git diff --name-only` output, content diffs, and parent-run verification before PASS; actual out-of-scope helper edits block until reverted/repaired or halted for guidance. |
| Surface delegated APPLY as parent-owned Helper Delegation, not an independent lifecycle authority | Phase 216 Plan 216-01 UNIFY | Future docs, helper-agent wording, and validation should preserve parent-owned task packets, structured reports as review input, parent-run official verification, changed-file diff review, and no helper-owned `.paul/*` lifecycle writes. |

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
- Skill audit Phase 205: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify WALT/SKIP/CODI/RUBY persistence recorded in SUMMARY. Process adaptation: PR #119 was manually merged before UNIFY metadata finalization; final evidence was reconciled afterward.
- Skill audit Phase 206: `/paul`, `/carl`, TODD, and WALT invoked or active via module dispatch; post-unify WALT/SKIP/CODI/RUBY persistence recorded in SUMMARY. Active handoff archived after resume proceeded.
- Skill audit Phase 207: `/paul`, `/carl`, TODD, WALT, CODI, SKIP, and RUBY invoked or active via module dispatch; post-task, post-apply, and post-unify validation/persistence passed with no regression. Active handoff archived after resume proceeded. Advisory DOCS drift noted as expected Phase 208 scope; ARCH/RUBY large-file debt remains pre-existing.
- Skill audit Phase 208: `/paul`, `/carl`, TODD, WALT, DOCS, CODI, SKIP, and RUBY invoked or active via module dispatch; post-apply and post-unify validation/persistence passed. `.gitignore` Workguard artifact ignore was added at user request and reconciled into plan scope.
- Skill audit Phase 209: `/paul`, `/carl`, TODD, WALT, CODI, SKIP, and RUBY invoked or active via module dispatch; post-task, post-apply, and post-unify validation/persistence passed. Validation count increase was expected and reconciled (Pi 192→193, cross-harness 108→109).
- Skill audit Phase 210: `/paul`, `/carl`, TODD, WALT, CODI, SKIP, and RUBY invoked or active via module dispatch; post-task, post-apply, and post-unify validation/persistence passed. Validation counts stayed stable (Pi 193/193, cross-harness 109/109). Active stale handoff archived after resume proceeded.
- Skill audit Phase 211: `/paul`, `/carl`, TODD, WALT, CODI, SKIP, and RUBY invoked or active via module dispatch; post-task, post-apply, and post-unify validation/persistence passed. DOCS drift was expected and deferred to Phase 212 by approved scope. ARCH/RUBY large-file debt remains pre-existing/future driver-quality scope.
- Skill audit Phase 212: `/paul`, `/carl`, TODD, WALT, CODI, SKIP, and RUBY invoked or active via module dispatch; post-task, post-apply, and post-unify validation/persistence passed. Validation count increase was expected and reconciled (Pi 193→196, cross-harness 109→111). Runtime source remained unchanged by approved adaptation.
- Skill audit Phase 213 APPLY: `/paul`, `/carl`, TODD, WALT, DOCS, SKIP, and enforcement modules invoked or active via module dispatch; pre-apply, post-task, and post-apply validation passed with no regression. Validation count increase was expected and reconciled for UNIFY (Pi 196→197, cross-harness 111→112). Minor process adaptation: source edits for Tasks 1 and 2 were applied in one localized pass before the combined validation run; final changed-file scope matched the approved contract/tests only.
- Skill audit Phase 214: `/paul`, `/carl`, TODD, WALT, CODI, SKIP, RUBY, and enforcement/advisory modules invoked or active via module dispatch; pre-plan, post-plan, APPLY, validation, post-unify persistence, and GitHub Flow evidence recorded. Validation stayed stable (Pi 197/197, cross-harness 112/112). Active handoff archived after resume proceeded.
- Skill audit Phase 215: `/paul`, `/carl`, TODD, WALT, CODI, SKIP, RUBY, and enforcement/advisory modules invoked or active via module dispatch; pre-plan, post-plan, APPLY, review-fix validation, and post-unify persistence passed with no regression. Validation stayed stable (Pi 197/197, cross-harness 112/112). Active handoff archived after resume proceeded. No helper delegation was used because the phase edited the delegation contract itself.
- Skill audit Phase 216: `/paul`, `/carl`, TODD, WALT, CODI, SKIP, RUBY, and advisory/enforcement modules invoked or active via module dispatch; validation passed Pi 199/199 and cross-harness 115/115. CODI recorded skipped-no-symbols; WALT quality history improved to 199 pass + 115 pass; RUBY noted existing validation-script size debt remains pre-existing/future driver-quality scope.

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
Last commit: 6ac2eaa6 (Phase 216 complete; PR #131 merged)
PR: #131 MERGED — https://github.com/coctostan/pals/pull/131
CI: PR #131 Socket Security checks passed; local validation passed Pi 199/199 and cross-harness 115/115 during UNIFY
Working tree: clean after Phase 216 merge gate
Prior PRs: #130 merged (Phase 215 runtime delegation packet/report hardening); #129 merged (Phase 214 delegated APPLY packet/report contract baseline); #128 merged (Phase 213 evidence reconciliation + milestone closure); #127 merged (Phase 212 documentation + validation surfacing); #126 merged (Phase 211 runtime capsule loading hardening); #125 merged (Phase 210 workflow/resource capsule contract baseline); #124 merged (Phase 209 evidence reconciliation + milestone closure); earlier PR history archived in STATE history.

## Session Continuity

Last session: 2026-04-29T02:07:54Z
Stopped at: Phase 216 complete, ready to plan Phase 217
Next action: Run /paul:plan for Phase 217 Evidence Reconciliation + Milestone Closure
Resume file: .paul/ROADMAP.md
Resume context:
- Phase 216 PLAN 216-01 is complete and summarized at `.paul/phases/216-documentation-validation-surfacing/216-01-SUMMARY.md`.
- Docs/helper-agent surfaces expose parent-owned task packets, structured helper reports, allowed/forbidden file scope, fallback triggers, parent-run official verification, changed-file diff review, and no helper-owned lifecycle authority.
- Validation count increased as expected and remains green: Pi 199/199 and cross-harness 115/115.
- Phase 217 owns final v2.50 evidence reconciliation and milestone closure.