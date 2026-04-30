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

**v2.53 Pi Integration Efficiency & Effectiveness Exploration**
Status: 🚧 In Progress
Phases: 2 of 4 complete

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 226 | Pi Integration Efficiency Discovery | 226-01 | ✅ Complete | 2026-04-30 |
| 227 | Effectiveness Improvement Candidate Design | 227-01 | ✅ Complete | 2026-04-30 |
| 228 | Bounded Pi Integration Spike | 228-01 | Planning | - |
| 229 | Validation + Evidence Closure | TBD | Not started | - |

### Phase 226: Pi Integration Efficiency Discovery
Focus: Identify current context-cost and workflow-friction hotspots in Pi integration, using recent v2.45-v2.52 evidence and current Pi surfaces without authorizing implementation changes.
Plans: 1/1 complete — Phase 226 created `docs/PI-INTEGRATION-EFFICIENCY-EFFECTIVENESS-DISCOVERY.md` with current Pi integration surface inventory, ranked efficiency/effectiveness hotspots, authority boundaries, and Phase 227 handoff; validation passed installer, Pi 205/205, and cross-harness 121/121.

### Phase 227: Effectiveness Improvement Candidate Design
Focus: Select and design the highest-value Pi-native improvements with explicit boundaries, evidence needs, fallback rules, and preservation of `.paul/*` artifact authority.
Plans: 1/1 complete — Phase 227 created `docs/PI-INTEGRATION-EFFECTIVENESS-CANDIDATE-DESIGN.md`, selecting artifact-slice targeting/deduplication as the Phase 228 candidate and defining expected future repo surfaces, output bounds, validation classes, marker checks, command-output verification requirements, Workguard scope, and stop/defer conditions. Validation stayed stable at Pi 205/205 and cross-harness 121/121; PR #142 merged.

### Phase 228: Bounded Pi Integration Spike
Focus: Prototype the selected improvement or improvements in bounded scope while preserving lifecycle gates, command-output truth, parent-owned APPLY, module evidence, and GitHub Flow safety.
Plans: 228-01 created — bounded artifact-slice targeting/deduplication runtime spike scoped to `drivers/pi/extensions/pals-hooks.ts`, Pi docs/skill-map surfacing, and localized Pi validation guardrails. Expected validation count change: Pi 205→207, cross-harness remains 121.

### Phase 229: Validation + Evidence Closure
Focus: Reconcile evidence, update docs and validation surfaces as needed, record validation count changes, and close the exploration milestone without expanding scope beyond approved Pi integration gains.
Plans: TBD (defined during /paul:plan)

### Previous milestone: v2.52 Legacy Retention / Install-Surface Cleanup
Result: Phases 222-225 complete. v2.52 established safe cleanup boundaries, made root install/uninstall Pi-first by default with explicit frozen legacy/source-only opt-ins, surfaced the posture in docs/reports/validation, reconciled final closure evidence, and closed with Pi 205/205 plus cross-harness 121/121 after PR #140 merged.

## Completed Milestones

| Milestone | Completed | Phases | Summary | Archive |
|-----------|-----------|--------|---------|---------|
| v2.44 PALS Context Optimization — Process & Artifacts | 2026-04-27 | 188-191 | Reduced recurring PALS context cost across wrappers, hot artifacts, workflow references, and validation guardrails. | [archive](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md) |
| v2.45 Pi-Native PALS Architecture | 2026-04-27 | 192-196 | Repositioned PALS around Pi as the supported runtime, mapped Pi capabilities, designed context-efficiency architecture, validated artifact-slice context loading, and produced the final Pi-native architecture proposal. | active artifacts |
| v2.46 Pi-Native Implementation Planning | 2026-04-27 | 197-201 | Converted v2.45 architecture into implementation findings, workstreams, sequencing, validation/evidence strategy, and a final executable Pi-native implementation-plan proposal. | active artifacts |
| v2.47 Artifact-Slice Contract Hardening | 2026-04-28 | 202-205 | Hardened activation-gated, bounded, source-cited, freshness-aware artifact slices and full-read fallback across contract baseline, runtime hardening, docs/skill-map surfacing, and validation/evidence reconciliation. | active artifacts |
| v2.48 Guided Workflow Evidence Hardening | 2026-04-28 | 206-209 | Proved guided workflow evidence across contract baseline, runtime canonical replies, docs/settings validation surfacing, and final evidence reconciliation while preserving explicit user intent and command-output truth. | active artifacts |
| v2.49 Workflow/Resource Capsule Contract | 2026-04-28 | 210-213 | Defined and hardened source-cited, bounded, derived-only workflow/resource capsules; surfaced docs/validation evidence; closed with Pi 197/197 and cross-harness 112/112. | active artifacts |
| v2.50 Delegated APPLY Packet/Report Contract | 2026-04-29 | 214-217 | Formalized parent-owned delegated APPLY task packets and structured helper reports; hardened runtime/helper boundaries; surfaced docs/validation markers; closed with Pi 200/200 and cross-harness 116/116. | active artifacts |
| v2.51 Pi-Native Validation Classification | 2026-04-30 | 218-221 | Defined validation classification taxonomy, hardened suite inventories, surfaced non-authoritative docs/report evidence, and closed with final evidence reconciliation; validation passes Pi 203/203 and cross-harness 119/119; cleanup remains deferred. | active artifacts |
| v2.52 Legacy Retention / Install-Surface Cleanup | 2026-04-30 | 222-225 | Established safe cleanup boundaries, made root install/uninstall Pi-first by default with explicit frozen legacy/source-only opt-ins, surfaced posture in docs/reports/validation, and closed with final evidence reconciliation; validation passes Pi 205/205 and cross-harness 121/121. | active artifacts |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-30 — Phase 228 Plan 228-01 created; awaiting approval.*