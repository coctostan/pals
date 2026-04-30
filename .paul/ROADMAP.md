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

**v2.54 Contextual Verbosity Paring**
Status: ✅ Complete
Phases: 4 of 4 complete — 2026-04-30

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 230 | Baseline Verbosity Audit | 230-01 | Complete | 2026-04-30 |
| 231 | Process / Workflow Verbosity Paring | 231-01 | Complete | 2026-04-30 |
| 232 | Skill Verbosity Pass | 232-01 | Complete | 2026-04-30 |
| 233 | Validation + Evidence Closure | 233-01 | Complete | 2026-04-30 |

### Phase 230: Baseline Verbosity Audit
Focus: Identify where PALS workflows, prompts, skills, module surfaces, and lifecycle artifacts create wasteful agent verbosity, distinguishing necessary evidence from redundant prose.
Plans: 230-01 — complete; created `docs/PALS-CONTEXTUAL-VERBOSITY-AUDIT.md` baseline audit artifact and Phase 231/232 inputs

### Phase 231: Process / Workflow Verbosity Paring
Focus: Update PALS process and workflow guidance to prefer concise, context-sensitive agent output while preserving lifecycle authority, approval gates, module evidence, validation truth, and GitHub Flow safety.
Plans: 231-01 — complete; added shared contextual verbosity guidance and compact high-frequency PLAN/milestone/resume/pause workflow reply templates; validation passed; PR #146 merged

### Phase 232: Skill Verbosity Pass
Focus: Review and update PALS skills so default replies are minimally verbose unless the task, evidence, or user request requires more detail.
Plans: 232-01 — complete; added concise-by-default output guidance across 13 Pi skill wrappers, pared config/help/review wrappers, preserved validation-protected markers, validation passed, PR #147 merged

### Phase 233: Validation + Evidence Closure
Focus: Reconcile evidence, update validation or documentation surfaces as needed, and close the milestone without expanding beyond approved verbosity-paring scope.
Plans: 233-01 — complete; closed v2.54 evidence in `docs/PALS-CONTEXTUAL-VERBOSITY-AUDIT.md`, added one localized closure guardrail per validation suite, passed Pi 209/209 and cross-harness 123/123, and opened PR #148.

### Previous milestone: v2.53 Pi Integration Efficiency & Effectiveness Exploration
Result: Phases 226-229 complete. v2.53 identified Pi integration context-cost/workflow-friction hotspots, selected artifact-slice targeting/deduplication, shipped a bounded runtime/docs/test spike, and closed with Pi 208/208 plus cross-harness 122/122 after PR #144 merged.

### Latest completed milestone: v2.54 Contextual Verbosity Paring
Result: Phases 230-233 complete. v2.54 established contextual verbosity guidance, compact dispatch skip/no-scope evidence, concise-by-default Pi skill wrappers, and final closure evidence protected by Pi 209/209 plus cross-harness 123/123 validation.
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
| v2.53 Pi Integration Efficiency & Effectiveness Exploration | 2026-04-30 | 226-229 | Identified Pi integration context-cost/workflow-friction hotspots, selected artifact-slice targeting/deduplication, shipped bounded runtime/docs/test spike, and closed with evidence reconciliation; validation passes Pi 208/208 and cross-harness 122/122. | active artifacts |
| v2.54 Contextual Verbosity Paring | 2026-04-30 | 230-233 | Audited PALS verbosity surfaces, added contextual verbosity and compact dispatch guidance, pared Pi skill wrappers, and closed with validation/evidence guardrails; validation passes Pi 209/209 and cross-harness 123/123. | active artifacts |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-30 — v2.54 complete after Phase 233 validation/evidence closure.*