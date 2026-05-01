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

**v2.55 Maintainability & Product Reality Hardening**
Status: 🚧 In Progress
Phases: 7 of 8 complete; Phase 241 (the v2.55 closure phase) has Plan 241-01 created and awaiting approval.

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 234 | Product Reality + Drift Audit | 1/1 | ✅ Complete | 2026-05-01 |
| 235 | Risk-Tiered Lifecycle Contract | 1/1 | ✅ Complete | 2026-05-01 |
| 236 | Validation Suite Decomposition Baseline | 1/1 | ✅ Complete | 2026-05-01 |
| 237 | Artifact Consistency Guardrails | 1/1 | ✅ Complete | 2026-05-01 |
| 238 | Pi Extension Modularization Contract | 1/1 | ✅ Complete | 2026-05-01 |
| 239 | Bounded Pi Extension Extraction Spike | 1/1 | ✅ Complete | 2026-05-01 |
| 240 | Product Happy Path + Scenario Evidence | 1/1 | ✅ Complete | 2026-05-01 |
| 241 | Evidence Closure + Next Roadmap Decision | 0/1 | Planning | - |

### Phase 234: Product Reality + Drift Audit
Focus: Create a grounded maintainability/product audit before changing implementation, including stale artifacts, oversized files, brittle validation areas, onboarding friction, and measurement gaps.
Plans: 234-01 complete — summary at `.paul/phases/234-product-reality-drift-audit/234-01-SUMMARY.md`

### Phase 235: Risk-Tiered Lifecycle Contract
Focus: Design proportional safety tiers for tiny, normal, risky, and hotfix work without weakening required approval, validation truth, GitHub Flow, module blocker, or lifecycle-write gates.
Plans: 235-01 complete — summary at `.paul/phases/235-risk-tiered-lifecycle-contract/235-01-SUMMARY.md`; contract at `docs/PALS-RISK-TIERED-LIFECYCLE-CONTRACT.md`.

### Phase 236: Validation Suite Decomposition Baseline
Focus: Document and begin splitting validation concerns into maintainable sections/helpers while preserving current validation counts and command-output truth.
Plans: 236-01 complete — summary at `.paul/phases/236-validation-suite-decomposition-baseline/236-01-SUMMARY.md`; baseline doc at `docs/PALS-VALIDATION-SUITE-DECOMPOSITION-BASELINE.md`.

### Phase 237: Artifact Consistency Guardrails
Focus: Add lightweight checks for STATE, ROADMAP, MILESTONES, SUMMARY, and session-continuity drift.
Plans: 237-01 complete — summary at `.paul/phases/237-artifact-consistency-guardrails/237-01-SUMMARY.md`; contract at `docs/PALS-ARTIFACT-CONSISTENCY-GUARDRAILS.md`.

### Phase 238: Pi Extension Modularization Contract
Focus: Define extraction boundaries for `drivers/pi/extensions/pals-hooks.ts` and select the first low-risk subsystem to extract.
Plans: 238-01 complete — summary at `.paul/phases/238-pi-extension-modularization-contract/238-01-SUMMARY.md`; contract at `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` (selected first-spike candidate: `module-activity-parsing` / S5).

### Phase 239: Bounded Pi Extension Extraction Spike
Focus: Extract one pure subsystem, validate behavior preservation, and prove the modularization path without broad runtime churn.
Plans: 239-01 complete — summary at `.paul/phases/239-bounded-pi-extension-extraction-spike/239-01-SUMMARY.md`; new module at `drivers/pi/extensions/module-activity-parsing.ts`; PR #154 merged; Pi 211/211 and cross-harness 125/125.

### Phase 240: Product Happy Path + Scenario Evidence
Focus: Create a simple first-run path and at least one scenario-style validation/story that shows user value.
Plans: 240-01 complete — summary at `.paul/phases/240-product-happy-path-scenario-evidence/240-01-SUMMARY.md`; new doc at `docs/PALS-FIRST-RUN-HAPPY-PATH.md` (201 lines, five named protections, literal `Authority: Derived aid only`, What This Scenario Does NOT Prove section, 5 onboarding-friction bullets); one bounded README pointer line; one bounded cross-harness TAP marker assertion (suite `1..125 → 1..126`); Pi suite unchanged at `1..211`; PR #155 merged.

### Phase 241: Evidence Closure + Next Roadmap Decision
Focus: Reconcile validation, drift, and maintainability evidence, then decide whether v2.56 should focus on validation architecture, Pi extension modularization, or module output schema.
Plans: 241-01 created — `.paul/phases/241-evidence-closure-next-roadmap-decision/241-01-PLAN.md`; awaiting approval for APPLY.

### Previous milestone: v2.54 Contextual Verbosity Paring
Result: Phases 230-233 complete. v2.54 established contextual verbosity guidance, compact dispatch skip/no-scope evidence, concise-by-default Pi skill wrappers, and final closure evidence protected by Pi 209/209 plus cross-harness 123/123 validation.

### Latest completed milestone: v2.54 Contextual Verbosity Paring
Result: Phases 230-233 complete. v2.54 closed after PR #148 merged; final validation passed Pi 209/209 and cross-harness 123/123.

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
*Last updated: 2026-05-01 — Phase 241 Plan 241-01 created for Evidence Closure + Install-Surface Generalization; awaiting approval for APPLY.*