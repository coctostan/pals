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
**v2.39 CODI v0.1 — Pre-Plan Structural Injection**
Status: ✅ Complete
Started: 2026-04-16
Theme: Ship CODI as a minimum-viable PALS pre-plan module that injects codegraph `impact` results into PLAN.md, then measure plan-quality improvements (manually) before stacking v0.2+.
Phases: 4 of 4 complete — verdict: ITERATE_V0_1 (closes v2.39)
| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 170 | CODI Module Scaffolding & Hello-World Hook | 1 (`170-01`) | ✅ Complete | 2026-04-16 |
| 171 | `impact` Integration & Symbol Extraction | 1 (`171-01`) | ✅ Complete | 2026-04-16 |
| 172 | Plan-Phase Coupling & Distribution | 1 (`172-01`) | ✅ Complete | 2026-04-17 |
| 173 | Real-World Trial & Gating Decision | 1 (`173-01`) | ✅ Complete | 2026-04-17 |

### Phase 170: CODI Module Scaffolding & Hello-World Hook
Focus: Create `modules/codi/` with manifest and reference doc as a registry-discovered pre-plan advisory overlay. v0.1 ships with a hello-world dispatch, no codegraph tool calls, and no prerequisite checks — tool-availability handling is deferred to Phase 171 call-time failure handling. First concrete step from the integration plan.
Plans: 1 (`170-01`) — complete

### Phase 171: `impact` Integration & Symbol Extraction
Focus: Add an explicit-symbol extractor (backtick-quoted names, file paths, explicit mentions — no magic inference), call `impact({ symbols, changeType: "behavior_change" })` per target, and inject a formatted Blast Radius block via `context_inject`. Advisory hook priority (~p200, after TODD/IRIS, before DEAN). Records dispatch in `<module_dispatch>`. Never blocks.
Plans: 1 (`171-01`) — complete

### Phase 172: Plan-Phase Coupling & Distribution
Focus: Add a lightweight optional symbol-enumeration tweak to `analyze_scope` so prose-heavy objectives still produce CODI targets, register CODI default-on in the `pals.json` schema with graceful skip when `pi-codegraph` or the codegraph index is absent, and document setup UX. No PLAN.md template changes (deferred to v0.4).
Plans: 1 (`172-01`) — complete

### Phase 173: Real-World Trial & Gating Decision
Focus: Run CODI on 2–3 real PALS planning sessions and manually observe the 4 success signals (fewer unexpected files, drop in mid-APPLY codegraph calls, more specific `<boundaries>`, no need for understand/verify brokers). Produce a decision artifact: ship v0.2, iterate v0.1, or kill the thesis. Honors the plan's explicit gating discipline.
Plans: 1 (`173-01`) — complete. Verdict: **ITERATE_V0_1** (see `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md`).
## Next Milestone
**v2.40 CODI v0.1 — Extractor & Coverage Iteration** (selected by Phase 173 verdict ITERATE_V0_1; see `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md`).
Theme: Close the extractor-vs-scope alignment gap surfaced by Phase 173's trial — extract symbols from PLAN-referenced source files, not just from prose — then re-trial against new live PALS phases before considering v0.2.

Proposed phase shape (subject to /paul-plan refinement):
- Phase 174 — Source-file symbol extraction (high-leverage iteration)
- Phase 175 — Install-time codegraph detection + value-envelope docs + success-log format ambiguity fix
- Phase 176 — Dispatch-outcome instrumentation across phases
- Phase 177 — Re-trial + gating decision (the v2.40 version of Phase 173)

Deferred (gated on v2.40 re-trial outcome):
- v0.2 — add `symbol_graph` for upstream dependency context
- v0.3 — conditional `trace` for runtime-behavior plans
- v0.4 — formalize `<impact>` / `<dependencies>` / `<runtime_paths>` PLAN.md template sections
- v0.5+ — CODI at other PALS hooks (pre-apply / post-task / pre-unify)
- Cross-repo trials if v2.40 re-trial still leaves doubt about CODI's value envelope.

## Completed Milestones
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
*Last updated: 2026-04-17 — Phase 172 complete (`172-01`); v2.39 is now 3 of 4 phases complete*