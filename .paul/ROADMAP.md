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

**v2.56 Pi Extension Submodule Extraction Wave** (v2.56)
Status: 🚧 In Progress
Phases: 1 of 4 complete

Theme: Continue extracting bounded Pi extension submodules from `pals-hooks.ts`, using the generalized install surface from v2.55 so future extraction waves reduce maintenance risk without installer churn.

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 242 | Extension Extraction Target Baseline | 1/1 | ✅ Complete | 2026-05-01 |
| 243 | Bounded Submodule Extraction Wave | 1 | ✅ Complete | 2026-05-02 |
| 244 | Documentation + Validation Surfacing | TBD | Not started | - |
| 245 | Evidence Closure + Next Roadmap Decision | TBD | Not started | - |

### Phase 242: Extension Extraction Target Baseline
Focus: Choose and bound multiple candidate submodules from `pals-hooks.ts` using the v2.55 modularization and install-surface evidence.
Plans: `.paul/phases/242-extension-extraction-target-baseline/242-01-PLAN.md` (✅ complete; SUMMARY `.paul/phases/242-extension-extraction-target-baseline/242-01-SUMMARY.md`)

### Phase 243: Bounded Submodule Extraction Wave
Focus: Extract one or more approved Pi extension submodules behind safe contracts while preserving runtime behavior, lifecycle authority, and install compatibility.
Plans: `.paul/phases/243-bounded-submodule-extraction-wave/243-01-PLAN.md` + `243-01-SUMMARY.md` — Complete: S1 `artifact-slice-rendering` extracted to `drivers/pi/extensions/artifact-slice-rendering.ts` (sibling Pi extension module). AC-1–AC-4 PASS (Pi 1..214/0, cross-harness 1..127/0, artifact_consistency PASS, install 3 files; +2 Pi count vs planned +1 reconciled in SUMMARY). PR #158 merged 2026-05-02 (squash + delete-branch). S2 reserved for a future approved plan if scheduled.

### Phase 244: Documentation + Validation Surfacing
Focus: Document extracted modules and protect install/runtime behavior with validation and artifact consistency evidence.
Plans: `.paul/phases/244-documentation-validation-surfacing/244-01-PLAN.md` + `244-01-SUMMARY.md` — Complete: surfaced S1 sibling extraction (`artifact-slice-rendering.ts`) across `README.md` + `drivers/pi/extensions/README.md` + `drivers/pi/skill-map.md`; surfaced Phase 243 outcome (S1 extracted, helpers exported, canonical `default-arg cycle-avoidance` pattern) in `PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md` and `PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md`; added closure guardrails (Pi `Phase 244 sibling extraction surfacing (Pi-supported runtime)` ×2; cross-harness `Phase 244 sibling extraction surfacing (Shared Invariant)` ×1). AC-1–AC-5 PASS (Pi 1..216/0, cross-harness 1..128/0, artifact_consistency PASS, install unchanged at 3 files; +2 Pi count vs planned +1 reconciled in SUMMARY). PR #159 merged 2026-05-02 (squash + delete-branch).

### Phase 245: Evidence Closure + Next Roadmap Decision
Focus: Reconcile v2.56 evidence, close the milestone, and decide the next roadmap focus.
Plans: TBD (defined during /paul:plan)

### Latest completed milestone: v2.55 Maintainability & Product Reality Hardening
Result: Phases 234-241 complete. v2.55 closed after PR #156 merged 2026-05-01. Shipped product-reality audit, risk-tiered lifecycle contract, validation-suite decomposition baseline, artifact consistency guardrails, Pi extension modularization contract, bounded S5 extraction spike, first-run happy-path scenario doc, and generalized Pi extension install surface with driver.yaml audit decision. Final validation: Pi 212/212 and cross-harness 127/127.

Phase status (closed):

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 234 | Product Reality + Drift Audit | 1/1 | ✅ Complete | 2026-05-01 |
| 235 | Risk-Tiered Lifecycle Contract | 1/1 | ✅ Complete | 2026-05-01 |
| 236 | Validation Suite Decomposition Baseline | 1/1 | ✅ Complete | 2026-05-01 |
| 237 | Artifact Consistency Guardrails | 1/1 | ✅ Complete | 2026-05-01 |
| 238 | Pi Extension Modularization Contract | 1/1 | ✅ Complete | 2026-05-01 |
| 239 | Bounded Pi Extension Extraction Spike | 1/1 | ✅ Complete | 2026-05-01 |
| 240 | Product Happy Path + Scenario Evidence | 1/1 | ✅ Complete | 2026-05-01 |
| 241 | Evidence Closure + Next Roadmap Decision | 1/1 | ✅ Complete | 2026-05-01 |

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
| v2.55 Maintainability & Product Reality Hardening | 2026-05-01 | 234-241 | Made PALS cheaper to maintain, easier to validate, easier to explain, and harder to drift; shipped product-reality audit, risk-tiered lifecycle contract, validation-suite decomposition baseline, artifact consistency guardrails, Pi extension modularization contract, bounded S5 extraction spike, first-run happy-path scenario doc, and generalized Pi extension install surface with driver.yaml audit decision; validation passes Pi 212/212 and cross-harness 127/127. | active artifacts |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-05-02 — Phase 244 complete (S1 outcome surfaced in 5 docs + 1 closure guardrail per validation suite; PR #159 merged); transitioned to Phase 245 Evidence Closure + Next Roadmap Decision.*