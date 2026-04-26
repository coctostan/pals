# Roadmap: pals

## Overview
PALS — the Linux of Harness Engineering. Minimal kernel, modular pals, universal drivers. PAUL (project lifecycle) is the kernel. CARL (context rules), TODD (TDD enforcement), and WALT (quality gating) are first-party modules. Drivers make it run on any agentic coding platform.

## Milestones

### v0.1 Fork & Unify (Complete)
Phases: 6 of 6 complete — 2026-03-11

### v0.2 Polish (Complete)
Status: Complete
Phases: 1 of 1 complete — 2026-03-11

### v0.3 Smart Context & Migration (Complete)
Status: Complete
Phases: 2 of 2 complete — 2026-03-11

### v0.4 Kernel & Modules (Complete)
Status: ✅ Complete
Completed: 2026-03-12
Phases: 4 of 4 complete

### v0.5 TODD & WALT Go Live (Complete)
Status: ✅ Complete
Completed: 2026-03-12
Phases: 3 of 3 complete

## Current Milestone
**v2.43 PALS Context Diet — Archive, Compact, Compress**
Status: 🚧 In Progress
Started: 2026-04-26
Theme: Keep PALS' disciplined PLAN/APPLY/UNIFY process, but make it cheaper to run by moving history out of hot context, compacting active artifacts, and trimming repetitive prose.
Source context: milestone discussion on 2026-04-26 (temporary `.paul/MILESTONE-CONTEXT.md` consumed and deleted)
Phases: 3 of 4 complete (75%)
| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 184 | Bloat Triage + Archive Design | 1/1 | ✅ Complete | 2026-04-26 |
| 185 | Artifact Archival + Hot-Path Compaction | 3/3 | ✅ Complete | 2026-04-26 |
| 186 | Workflow / Module Prose Compression | 1/1 | ✅ Complete | 2026-04-26 |
| 187 | Regression + Anti-Regrowth Guardrails | 1/1 | Planning | - |
### Phase 184: Bloat Triage + Archive Design
Focus: Identify highest-leverage context-heavy surfaces; separate hot-path, warm-path, and cold-history content; design `.paul/archive/INDEX.md` plus archive file conventions.
Plans: 184-01 complete — produced `.paul/phases/184-bloat-triage-archive-design/184-01-BLOAT-TRIAGE-ARCHIVE-DESIGN.md` and `.paul/phases/184-bloat-triage-archive-design/184-01-SUMMARY.md`
### Phase 185: Artifact Archival + Hot-Path Compaction
Focus: Restore `PROJECT.md` as a true compact brief; compact `STATE.md`, `MILESTONES.md`, and possibly `ROADMAP.md`; move historical decisions and milestone detail into indexed archives while preserving findability.
Plans: 185-01 complete (`.paul/phases/185-artifact-archival-hot-path-compaction/185-01-SUMMARY.md`) — archive index + lower-risk `MILESTONES.md`/`PROJECT.md` compaction wave complete. 185-02 complete (`.paul/phases/185-artifact-archival-hot-path-compaction/185-02-SUMMARY.md`) — `STATE.md` history archived and live state compacted. 185-03 complete (`.paul/phases/185-artifact-archival-hot-path-compaction/185-03-SUMMARY.md`) — PALS process-level `ROADMAP.md` active-window/archive handling implemented and merged via PR #97.
### Phase 186: Workflow / Module Prose Compression
Focus: Trim repeated PLAN/APPLY/UNIFY and module-dispatch prose; preserve checkpoints, dispatch evidence, merge gate behavior, exact routing, and artifact authority.
Plans: 186-01 complete (`.paul/phases/186-workflow-module-prose-compression/186-01-SUMMARY.md`) — shared dispatch mechanics moved into `module-dispatch.md`; PLAN/APPLY/UNIFY hook call sites compacted while preserving checkpoints, module evidence, post-unify persistence, and GitHub Flow merge-gate semantics.
### Phase 187: Regression + Anti-Regrowth Guardrails
Focus: Run existing validation; add lightweight semantic/shape checks so hot artifacts do not quietly become history sinks again; keep validation practical rather than over-engineered.
Plans: 187-01 created (`.paul/phases/187-regression-anti-regrowth-guardrails/187-01-PLAN.md`) — lightweight validation-script guardrails for hot-workflow line envelope and semantic marker retention; awaiting approval.
## Completed Milestones
<details>
<summary>v2.42 CODI v0.1 — Post-Unify Instrumentation Fix - 2026-04-26 (3 phases)</summary>

Theme: Shipped CODI v0.1 as good enough after bounded post-unify instrumentation repair; fresh quark natural validation was intentionally skipped by product decision rather than treated as passed.
Outcome: CODI v0.1 shipped as good enough. Phase 182 delivered hook-entry tracing and `injected-degraded` classification; Phase 183 closed the milestone honestly without collecting a fresh natural quark validation row.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 181 | Root-Cause Analysis | 1 | 2026-04-20 |
| 182 | Bounded Instrumentation Fix | 1 | 2026-04-20 |
| 183 | Natural Validation / Closeout | 1 | 2026-04-26 |

</details>
<details>
<summary>v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation - 2026-04-20 (3 phases)</summary>

Theme: Take CODI out of the markdown-heavy pals repo and observe it on real TS work in quark, then re-run the unchanged Phase 173/177 gate on that natural evidence.
Outcome: Phase 180 verdict **ITERATE_V0_1** (see `.paul/phases/180-re-trial-gating-decision/180-01-DECISION.md`). Natural-scope evidence showed CODI materially shaped APPLY qualitatively, but two distinct post-unify instrumentation gaps — parser-miss on quark `112-01` and hook-not-firing on quark `113-01` — kept the mechanical Q2 pass at `uncertain`. v2.42 therefore opens as a bounded instrumentation-fix milestone under a fresh SHA freeze rather than a v0.2 expansion.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 178 | CODI Cross-Repo Install (quark) | 1 | 2026-04-18 |
| 179 | Organic Observation Window | 1 | 2026-04-20 |
| 180 | Re-Trial + Gating Decision | 1 | 2026-04-20 |

</details>
<details>
<summary>v2.40 CODI v0.1 — Extractor & Coverage Iteration - 2026-04-18 (4 phases)</summary>

Theme: Close the extractor-vs-scope alignment gap surfaced by Phase 173's trial — extract symbols from PLAN-referenced source files, not just from prose — then re-trial against new live PALS phases before considering v0.2. Selected by Phase 173 verdict ITERATE_V0_1.
Outcome: Phase 177 verdict **ITERATE_V0_1** (see `.paul/phases/177-re-trial-gating-decision/177-01-DECISION.md`). `S_pass_nonnull` improved from 1 → 3 (first time mechanically clearing the SHIP threshold), Signal 3 still passes on live + counterfactual projected-pass, but SHIP gate fails on Q2=uncertain because only Signal 3 reaches projected-pass. Next milestone v2.41 focuses on natural-scope TS implementation evidence to resolve Q2 before considering v0.2.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 174 | Source-File Symbol Extraction | 1 | 2026-04-17 |
| 175 | Install-Time Detection + Value-Envelope Docs + Format Fix | 1 | 2026-04-17 |
| 176 | Dispatch-Outcome Instrumentation | 1 | 2026-04-18 |
| 177 | Re-Trial + Gating Decision | 1 | 2026-04-18 |

</details>
<details>
<summary>v2.39 CODI v0.1 — Pre-Plan Structural Injection - 2026-04-17 (4 phases)</summary>

Theme: Ship CODI as a minimum-viable PALS pre-plan module that injects codegraph `impact` results into PLAN.md, then measure plan-quality improvements (manually) before stacking v0.2+.
Outcome: Phase 173 verdict **ITERATE_V0_1** (see `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md`). CODI value envelope confirmed on TS-touching counterfactual (Signal 3 projected-pass); live PALS sample uniformly CODI_NULL due to extractor-vs-scope misalignment. v2.40 iterates on source-file symbol extraction.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 170 | CODI Module Scaffolding & Hello-World Hook | 1 | 2026-04-16 |
| 171 | `impact` Integration & Symbol Extraction | 1 | 2026-04-16 |
| 172 | Plan-Phase Coupling & Distribution | 1 | 2026-04-17 |
| 173 | Real-World Trial & Gating Decision | 1 | 2026-04-17 |

</details>
<details>
<summary>v2.38 Pi Lifecycle UX Polish - 2026-04-01 (3 phases)</summary>

Theme: Make the existing Pi lifecycle display calm, legible, and visually meaningful for daily use without expanding into a broader new widget system.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 167 | UX Audit & Target Design | 1 | 2026-04-01 |
| 168 | Core Lifecycle UI Polish | 1 | 2026-04-01 |
| 169 | Supporting UX Alignment & Validation | 1 | 2026-04-01 |

</details>
<details>
<summary>v2.37 Implementer Config Alignment & Delegation Expansion - 2026-03-28 (3 phases)</summary>

Theme: Align `pals.json`, init, migration, schema, docs, and validation around explicit implementer config, then broaden delegated APPLY so `pals-implementer` is used more often without weakening parent authority.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 164 | Implementer Config Contract Alignment | 1 | 2026-03-28 |
| 165 | Delegated APPLY Expansion | 1 | 2026-03-28 |
| 166 | Validation & Docs Refresh | 1 | 2026-03-28 |

</details>
<details>
<summary>v2.36 Context Reduction Implementation — Workflow-First Pass - 2026-03-28 (3 phases)</summary>

Theme: Implement the highest-value workflow-side context reductions first — slimmer wrappers, tighter read discipline, and trimmed roadmap/workflow prose — without changing artifact-first lifecycle authority.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 161 | Wrapper & Entrypoint Slimming | 1 | 2026-03-28 |
| 162 | Workflow Read-Discipline Reduction | 1 | 2026-03-28 |
| 163 | ROADMAP/Workflow Prose Cleanup + Validation | 1 | 2026-03-28 |

</details>
<details>
<summary>v2.35 Context Bloat Audit & Reduction Strategy - 2026-03-28 (3 phases)</summary>

Theme: Audit how PALS context load grows under Pi usage, especially from repeatedly-read artifacts and workflow markdown, then produce ranked tactical and structural recommendations without changing artifact-first lifecycle authority.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 158 | Artifact Growth & Hot-Path Audit | 1 | 2026-03-27 |
| 159 | Workflow Bloat Audit | 1 | 2026-03-28 |
| 160 | Findings & Recommendation Package | 1 | 2026-03-28 |

</details>
<details>
<summary>v2.34 Pi Subagent Integration & PALS Implementer - 2026-03-27 (4 phases)</summary>

Theme: Make PALS use the `pi-subagents` extension deliberately and correctly by auditing current behavior and introducing a PALS-native implementer that preserves normal PALS execution semantics with fresh-context advantages.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 154 | Pi Subagent Audit | 1 | 2026-03-27 |
| 155 | PALS Implementer Design | 1 | 2026-03-27 |
| 156 | PALS Implementer Integration | 1 | 2026-03-27 |
| 157 | Validation & Polish | 1 | 2026-03-27 |

</details>
<details>
<summary>v2.33 Code Review Module (REV) - 2026-03-27 (3 phases)</summary>

Theme: Build a subagent-powered code review module that leverages fresh context and configurable models for thorough, unbiased code review.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 151 | Research & Design | 1 | 2026-03-27 |
| 152 | Core Implementation | 2 | 2026-03-27 |
| 153 | Validation & Polish | 1 | 2026-03-27 |

</details>
<details>
<summary>v2.29 E2E Test Protocol - 2026-03-26 (2 phases)</summary>

Theme: Make E2E testing a repeatable PALS capability instead of ad-hoc sessions.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 139 | Protocol Design & Report Template | 1 | 2026-03-26 |
| 140 | Protocol Validation — Greenfield E2E Run | 1 | 2026-03-26 |

</details>
<details>
<summary>v2.28 DEAN Baseline Management - 2026-03-26 (1 phase)</summary>

Theme: Eliminate repeated override friction for pre-existing vulnerabilities.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 138 | DEAN Baseline Mechanism | 1 | 2026-03-26 |

</details>
<details>
<summary>v2.27 Module Dispatch Hardening - 2026-03-26 (3 phases)</summary>

Theme: Make modules actually fire across models — imperative instruction wording, structural post-apply/post-unify enforcement, and merge gate simplification.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 135 | Module Instruction Wording Audit | 1 | 2026-03-26 |
| 136 | Post-Apply/Post-Unify Enforcement | 1 | 2026-03-26 |
| 137 | GitHub Flow Merge Gate Simplification | 1 | 2026-03-26 |

</details>
<details>
<summary>v2.26 Init/Onboarding Overhaul - 2026-03-26 (3 phases)</summary>

Theme: Fix greenfield init friction — smart defaults, fewer questions, better detection, and conditional question gating.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 132 | Smart Question Gating + Brownfield Detection Fix | 1 | 2026-03-26 |
| 133 | Greenfield Fast Path + Explicit Milestone Creation | 1 | 2026-03-26 |
| 134 | Quick Mode + Validation | 1 | 2026-03-26 |

</details>
<details>
<summary>v2.25 E2E Adversarial Testing - 2026-03-25 (3 phases)</summary>

Theme: Prove modules produce real value under adversarial, real-dev, and greenfield conditions.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 129 | Adversarial Testing Setup | 1 | 2026-03-25 |
| 130 | Real-User Feature Dev | 1 | 2026-03-25 |
| 131 | Greenfield Project | 1 | 2026-03-25 |

</details>
<details>
<summary>v2.24 Module Dispatch Integrity - 2026-03-25 (2 phases)</summary>
<details>
<summary>v2.24 Module Dispatch Integrity - 2026-03-25 (2 phases)</summary>

Theme: Debug, reproduce, and durably fix the module dispatch system so modules can never silently skip.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 127 | Debug + Reproduce + Instrument | 2 | 2026-03-25 |
| 128 | Install, Config & Init Audit | 2 | 2026-03-25 |

</details>
<details>
<summary>v2.23 pi-verify v1.0 — Ship-Ready Product - 2026-03-25 (4 phases, executed in pi-verify via cmux)</summary>

Theme: Transform pi-verify from test scaffolding into a publishable, multi-language verification extension while stress-testing all 18 PALS modules under real development pressure.

**Result:** pi-verify v1.0 shipped (67 tests, 5 languages, config + parallel execution). Module dispatch failed silently — zero modules fired across all 4 phases. See .paul/references/v223-e2e-assessment.md.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 123/10 | Identity & Cleanup | 1 | 2026-03-25 |
| 124/11 | Multi-Language Detection | 1 | 2026-03-25 |
| 125/12 | Config & Parallel Execution | 1 | 2026-03-25 |
| 126/13 | Publish Prep | 1 | 2026-03-25 |

</details>
<details>
<summary>v2.22 Expertise Expansion III - 2026-03-24 (3 phases)</summary>

Theme: Build 3 new expert modules (OMAR, REED, VERA) for observability, resilience, and privacy/compliance coverage.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 120 | OMAR Module | 1 | 2026-03-24 |
| 121 | REED Module | 1 | 2026-03-24 |
| 122 | VERA Module | 1 | 2026-03-24 |

</details>
<details>
<summary>v2.21 Expertise Expansion II - 2026-03-24 (3 phases)</summary>

Theme: Build 3 new expert modules (LUKE, ARIA, DANA).

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 117 | LUKE Module | 1 | 2026-03-24 |
| 118 | ARIA Module | 1 | 2026-03-24 |
| 119 | DANA Module | 1 | 2026-03-24 |

</details>
## Completed Milestones
<details>
<summary>v2.20 Expertise Expansion I - 2026-03-24 (4 phases)</summary>

Theme: Build 4 new expert modules (ARCH, SETH, PETE, GABE).

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 113 | ARCH Module | 1 | 2026-03-24 |
| 114 | SETH Module | 1 | 2026-03-24 |
| 115 | PETE Module | 1 | 2026-03-24 |
| 116 | GABE Module | 1 | 2026-03-24 |

</details>
## Completed Milestones
<details>
<summary>v2.19 Module Excellence - 2026-03-24 (4 phases)</summary>

Theme: Get every module to A or A+ using adversarial testing methodology.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 109 | DOCS & SKIP Upgrade | 1 | 2026-03-24 |
| 110 | DEAN Adversarial Hardening | 1 | 2026-03-24 |
| 111 | DAVE Adversarial Hardening | 1 | 2026-03-24 |
| 112 | Full Roster Retest & Certification | 1 | 2026-03-24 |

</details>
## Completed Milestones
<details>
<summary>v2.18 Module Hardening - 2026-03-24 (3 phases)</summary>

Theme: Upgrade all 8 modules from "dispatches correctly" to "produces genuinely useful, tool-backed output."

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 106 | Quick Wins | 1 | 2026-03-24 |
| 107 | Tool Integration | 1 | 2026-03-24 |
| 108 | Quality Tracking + Retest | 1 | 2026-03-24 |

</details>
## Completed Milestones
<details>
<summary>v2.17 Module Dispatch Refinement - 2026-03-24 (3 phases)</summary>

Theme: Fix blocking-suppresses-advisory, harden weak modules, compare module behavior across models.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 103 | Fix Blocking-Suppresses-Advisory | 1 | 2026-03-24 |
| 104 | SKIP Hardening + DEAN Adversarial | 2 | 2026-03-24 |
| 105 | Module Action Items | 1 | 2026-03-24 |

</details>

Theme: Fix blocking-suppresses-advisory, harden weak modules, compare module behavior across models.

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|----------|
| 103 | Fix Blocking-Suppresses-Advisory | 1/1 | ✅ Complete | 2026-03-24 |
| 104 | SKIP Hardening + DEAN Adversarial | 2 | ✅ Complete | 2026-03-24 |
| 105 | Module Action Items | 1 | ✅ Complete | 2026-03-24 |

## Completed Milestones
<details>
<summary>v2.16 Module Dispatch Validation - 2026-03-24 (3 phases)</summary>

Theme: Prove that PALS modules actually dispatch and contribute value.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 100 | Module E2E Test | 2 | 2026-03-24 |
| 101 | Blocking Module Audit | 1 | 2026-03-24 |
| 102 | Advisory Module Audit | 1 | 2026-03-24 |

</details>

Theme: Prove that PALS modules actually dispatch and contribute value when driving a real project through Pi, now that the kernel/ path fix is deployed.

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|----------|
| 100 | Module E2E Test | 1/1 | ✅ Complete | 2026-03-24 |
| 101 | Blocking Module Audit | 1/1 | ✅ Complete | 2026-03-24 |
| 102 | Advisory Module Audit | 1/1 | ✅ Complete | 2026-03-24 |

## Completed Milestones
<details>
<summary>v2.15 PALS E2E Validation via Pi - 2026-03-24 (5 phases)</summary>

Theme: Build a real Pi extension (pi-verify) by driving PALS through Pi in a cmux-controlled pane — exercising every major workflow and recording gaps.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 95 | Test Infrastructure | 1/1 | 2026-03-24 |
| 96 | Init & First Loop | 1/1 | 2026-03-24 |
| 97 | Second Loop & Lifecycle | 1/1 | 2026-03-24 |
| 98 | Fix Loop & GH Flow | 1/1 | 2026-03-24 |
| 99 | Gap Report & Finalization | 1/1 | 2026-03-24 |

</details>

Theme: Build a real Pi extension (pi-verify) by driving PALS through Pi in a cmux-controlled pane — exercising every major workflow and recording gaps.
| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|----------|
| 95 | Test Infrastructure | 1/1 | ✅ Complete | 2026-03-24 |
| 96 | Init & First Loop | 1/1 | ✅ Complete | 2026-03-24 |
| 97 | Second Loop & Lifecycle | 1/1 | ✅ Complete | 2026-03-24 |
| 98 | Fix Loop & GH Flow | 1/1 | ✅ Complete | 2026-03-24 |
| 99 | Gap Report & Finalization | 1/1 | ✅ Complete | 2026-03-24 |

## Completed Milestones
<details>
<summary>v2.14 GitHub Flow Validation - 2026-03-24 (3 phases)</summary>

Theme: Prove the v2.12/v2.13 GitHub Flow implementation works in real use on both a lean test project and the full pals repo.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 92 | Isolated Validation (gh-flow-test) | 1/1 | 2026-03-24 |
| 93 | Live Validation (pals) | 1/1 | 2026-03-24 |
| 94 | Fixes & Hardening | 1/1 | 2026-03-24 |

</details>
## Completed Milestones
<details>
<summary>v2.13 GitHub Flow Hardening - 2026-03-23 (4 phases)</summary>

Theme: Close remaining correctness gaps so GitHub Flow in PALS is reliable in real use — hardening pass, not redesign.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 88 | Branch & Staging Correctness | 1/1 | 2026-03-23 |
| 89 | Routing & Validation | 1/1 | 2026-03-23 |
| 90 | Status Parity & Config Clarity | 1/1 | 2026-03-23 |
| 91 | Verification & Docs | 1/1 | 2026-03-23 |

</details>
<details>
<summary>v2.12 GitHub Flow Enforcement - 2026-03-23 (4 phases)</summary>
<details>
<summary>v2.12 GitHub Flow Enforcement - 2026-03-23 (4 phases)</summary>

Theme: Make PALS loop progression aware of branch/PR/merge/CI state so GitHub Flow is actively enforced, not just descriptive config.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 84 | Research & Config Schema | 1/1 | 2026-03-23 |
| 85 | Core Loop Enforcement | 1/1 | 2026-03-23 |
| 86 | Lifecycle Awareness | 1/1 | 2026-03-23 |
| 87 | Validation & Docs | 1/1 | 2026-03-23 |

</details>
## Completed Milestones
<details>
<summary>v2.11 Pi CARL Session Boundary Manager - 2026-03-19 (3 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 81 | Core Implementation | 1/1 | 2026-03-19 |
| 82 | Config & Integration | 1/1 | 2026-03-19 |
| 83 | Validation & Docs | 1/1 | 2026-03-19 |

</details>
---

## Completed Milestones
<details>
<summary>v2.10 Workflow Integrity - 2026-03-19 (1 phase)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 80 | Workflow Integrity Fixes | 1/1 | 2026-03-19 |

</details>
<details>
<summary>v2.9 CARL Session Boundary Manager - 2026-03-18 (4 phases) ⚠️ HOLLOW</summary>

**Note:** Phases 76-79 committed only `.paul/` documentation artifacts. The actual CARL extension code was never implemented — all acceptance criteria were falsely reported as passing. This milestone's completion status is retained for historical accuracy but its deliverables are void.

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 76 | API Validation & Prototype | 1/1 | 2026-03-18 |
| 77 | Core Implementation | 1/1 | 2026-03-18 |
| 78 | Integration & Configuration | 1/1 | 2026-03-18 |
| 79 | Validation & Documentation | 1/1 | 2026-03-18 |

</details>
<details>
<summary>v2.8 Module Report Clarity - 2026-03-18 (4 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 72 | TODD Report Clarity | 1/1 | 2026-03-18 |
| 73 | WALT Report Clarity | 1/1 | 2026-03-18 |
| 74 | SKIP Report Clarity | 1/1 | 2026-03-18 |
| 75 | RUBY Report Clarity | 1/1 | 2026-03-18 |

</details>
<details>
<summary>v2.7 Module Reality Check & Visibility - 2026-03-18 (4 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 68 | Execution Audit | 1/1 | 2026-03-18 |
| 69 | Gap Fixes | 1/1 | 2026-03-18 |
| 70 | Visibility UX | 1/1 | 2026-03-18 |
| 71 | Recommendations | 1/1 | 2026-03-18 |

</details>
<details>
<summary>v2.6 Collaborative Planning & PRD Depth - 2026-03-17 (3 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 65 | Research & Current-State Audit | 1 | 2026-03-17 |
| 66 | Collaborative Planning Model | 1 | 2026-03-17 |
| 67 | Onboarding & PRD Depth | 2 | 2026-03-17 |

</details>
<details>
<summary>v2.5 Pi Runtime Coherence & Guided Flow - 2026-03-16 (3 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 62 | Runtime Context & Event Refinement | 1 | 2026-03-16 |
| 63 | Guided Workflow UX | 1 | 2026-03-16 |
| 64 | Polish, Validation & UX Readability | 1 | 2026-03-16 |

</details>
<details>
<summary>v2.4 Pi Native UX Layer - 2026-03-16 (3 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 59 | Always-Visible Lifecycle Surface | 1 | 2026-03-16 |
| 60 | Interactive Shortcuts & Flow Entry Points | 1 | 2026-03-16 |
| 61 | UX Polish, Validation & Interoperability Guardrails | 1 | 2026-03-16 |

</details>

<details>
<summary>v2.3 Pi Interaction Model Refinement - 2026-03-16 (3 phases)</summary>
| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 56 | Hook & Context Strategy | 1 | 2026-03-15 |
| 57 | Command Routing & Discoverability | 1 | 2026-03-16 |
| 58 | Adapter Consistency Cleanup | 1 | 2026-03-16 |
</details>
<details>
<summary>v2.2 Pi Port Audit & Native Fit - 2026-03-15 (3 phases)</summary>
| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 53 | Current-State Audit | 1 | 2026-03-15 |
| 54 | Gap Analysis vs Ideal Pi Usage | 1 | 2026-03-15 |
| 55 | Recommendations & Roadmap | 1 | 2026-03-15 |
</details>

<details>
<summary>v2.1 Pi Runtime Integration - 2026-03-14 (4 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 49 | SKILL.md Generation | 1 | 2026-03-14 |
| 50 | Pi Extension | 1 | 2026-03-14 |
| 51 | Installer & Driver Update | 1 | 2026-03-14 |
| 52 | End-to-End Validation | 1 | 2026-03-14 |

</details>

<details>
<summary>v2.0 Portability & Cross-Harness - 2026-03-14 (4 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 45 | Artifact & Lifecycle Spec | 1 | 2026-03-14 |
| 46 | Harness-Agnostic Skills | 3 | 2026-03-14 |
| 47 | Pi Adapter | 1 | 2026-03-14 |
| 48 | Cross-Harness Validation | 1 | 2026-03-14 |

</details>

<details>
<summary>v1.2 Multi-Model Routing - 2026-03-14 (2 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 43 | Config & Routing Design | 1 | 2026-03-14 |
| 44 | Implementation & Validation | 1 | 2026-03-14 |

</details>

<details>
<summary>v1.1 Deep Competitive Audit & Quality Improvements - 2026-03-14 (5 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 38 | Planning Deep Dive | 1 | 2026-03-13 |
| 39 | Execution Deep Dive | 1 | 2026-03-14 |
| 40 | Testing & TDD | 1 | 2026-03-14 |
| 41 | Quality & Validation | 1 | 2026-03-14 |
| 42 | UNIFY, Continuity & Codebase Intel | 1 | 2026-03-14 |

</details>

<details>
<summary>v1.0 Production Ready - 2026-03-13 (3 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 35 | Lightweight Fix & Hotfix | 1 | 2026-03-13 |
| 36 | Brownfield & Codebase Intelligence | 1 | 2026-03-13 |
| 37 | Resilience & Isolation | 1 | 2026-03-13 |

</details>

<details>
<summary>v0.9.2 Competitive Intelligence - 2026-03-13 (1 phase)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 34 | Competitive Research | 1 | 2026-03-13 |

</details>

<details>
<summary>v0.9.1 Release Readiness - 2026-03-13 (3 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 31 | Seamless Git & GH | 2 | 2026-03-13 |
| 32 | PALS Documentation | 1 | 2026-03-13 |
| 33 | Doc Lifecycle Module | 1 | 2026-03-13 |

</details>

<details>
<summary>v0.9 Observability & Context Health - 2026-03-13 (2 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 28 | Context Audit & Optimization | 1 | 2026-03-13 |
| 29 | Module Observability | 2 | 2026-03-13 |
| 30 | Context Monitor (conditional) | - | Skipped |

</details>

<details>
<summary>v0.8 Configuration & Polish - 2026-03-12 (2 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 26 | Module Configuration & Init | 1 | 2026-03-12 |
| 27 | README | 1 | 2026-03-12 |

</details>

<details>
<summary>v0.7 Full Roster & Lifecycle Integration - 2026-03-12 (4 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 22 | SKIP Module | 1 | 2026-03-12 |
| 23 | DAVE Module | 1 | 2026-03-12 |
| 24 | RUBY Module | 1 | 2026-03-12 |
| 25 | Lifecycle Hooks | 1 | 2026-03-12 |

</details>

<details>
<summary>v0.6 Enhance & Expand - 2026-03-12 (5 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 17 | CARL Auto-Detection | 1 | 2026-03-12 |
| 18 | TODD Coverage Dashboard | 1 | 2026-03-12 |
| 19 | WALT Quality Trends | 1 | 2026-03-12 |
| 20 | DEAN Module | 1 | 2026-03-12 |
| 21 | IRIS Module | 1 | 2026-03-12 |

</details>


<details>
<summary>v0.5 TODD & WALT Go Live - 2026-03-12 (3 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 14 | TODD Integration | 1 | 2026-03-12 |
| 15 | WALT Integration | 1 | 2026-03-12 |
| 16 | Module System Validation | 1 | 2026-03-12 |

</details>

<details>
<summary>v0.4 Kernel & Modules - 2026-03-12 (4 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 10 | Architecture & Module Interface | 1 | 2026-03-11 |
| 11 | Kernel Extraction & Module Refactor | 2 | 2026-03-12 |
| 12 | Module Manager & Installer | 2 | 2026-03-12 |
| 13 | Driver Architecture & Agent SDK Stub | 2 | 2026-03-12 |

</details>

<details>
<summary>v0.3 Smart Context & Migration - 2026-03-11 (2 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 8 | Smart Installer | 1 | 2026-03-11 |
| 9 | Auto Context Cycling | 1 | 2026-03-11 |

</details>

<details>
<summary>v0.2 Polish - 2026-03-11 (1 phase)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 7 | Namespace & Cleanup | 1 | 2026-03-11 |

</details>

<details>
<summary>v0.1 Fork & Unify - 2026-03-11 (6 phases)</summary>

| Phase | Name | Plans | Completed |
*Last updated: 2026-03-17 - Phase 65 complete; transitioned to Phase 66 planning*
| 1 | Architecture & Design | 2 | 2026-03-11 |
| 2 | Fork & Restructure | 3 | 2026-03-11 |
| 3 | Merge TODD/WALT | 2 | 2026-03-11 |
| 4 | CARL Integration | 2 | 2026-03-11 |
| 5 | Install & Distribution | 2 | 2026-03-11 |
| 6 | End-to-End Validation | 1 | 2026-03-11 |

</details>

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-26 — Phase 187 Plan 187-01 created and awaiting approval.*