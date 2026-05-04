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

**v2.59 Pi Extension Submodule Extraction Wave — S7 PALS Context Injection** (v2.59)
Status: 🚧 In Progress | Mode: direct-requirements | Collaboration: high | Phases: 1 of 4 complete (Phase 253 closed; PR #168 merged)
Theme: Continue the sibling extraction wave by extracting S7 `pals-context-injection` from `drivers/pi/extensions/pals-hooks.ts` while preserving the explicit `STATE_AUTHORITY_TAG` / `ACTIVATION_SIGNAL_TAG` / `LEGACY_PALS_CONTEXT_HEADER` / `PALS_CONTEXT_CUSTOM_TYPE` / `PRIMARY_INJECTION_EVENT` / `SUPPORTING_CONTEXT_EVENT` constants, the message-stream housekeeping that keeps only the latest PALS context message, and the loader-compat / sibling-import / single-defined-marker invariants ratified by Phases 239 / 243 / 246 / 250. S4 canonical reply delivery, S6 lifecycle UI, and S8 command routing remain explicitly out of scope.

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 253 | S7 Extraction Contract + Bounded Submodule Plan | 1/1 | ✅ Complete | 2026-05-03 |
| 254 | Bounded S7 Submodule Extraction | TBD | Not started | - |
| 255 | Documentation + Validation Surfacing | TBD | Not started | - |
| 256 | Evidence Closure + Next Roadmap Decision | TBD | Not started | - |

### Phase 253: S7 Extraction Contract + Bounded Submodule Plan
Focus: Define the S7 `pals-context-injection` extraction contract, readiness evidence, preservation markers (authority/activation tags, legacy header, custom message type, injection-event constants), allowed files, validation expectations, and bounded APPLY shape before any source change.
Plans: TBD (defined during /paul:plan)

### Phase 254: Bounded S7 Submodule Extraction
Focus: Extract S7 `pals-context-injection` into a sibling Pi extension module following the S5/S1/S2/S3 sibling-module recipe (loader-compat no-op default factory, single-defined markers, sibling-import discipline) while preserving payload build purity, message-stream housekeeping behavior, and exact authority/activation tags.
Plans: TBD (defined during /paul:plan)

### Phase 255: Documentation + Validation Surfacing
Focus: Surface the S7 extraction outcome across README, Pi extension docs, and skill-map; reconcile the S7 extraction contract and modularization contract; add localized Pi/cross-harness validation guardrails without broad validation-suite refactors.
Plans: TBD (defined during /paul:plan)

### Phase 256: Evidence Closure + Next Roadmap Decision
Focus: Reconcile v2.59 evidence, validation counts, install-surface behavior, module reports, GitHub Flow evidence, and the next roadmap recommendation; record v2.60 candidate selection without approving it.
Plans: TBD (defined during /paul:plan)

### Latest completed milestone: v2.58 Pi Extension Submodule Extraction Wave — S3 Guided Workflow Detection
Result: Phases 249–252 complete. v2.58 closed after PR #167 merged 2026-05-03. Shipped S3 `guided-workflow-detection` sibling extraction (`drivers/pi/extensions/guided-workflow-detection.ts`) while preserving S4 canonical reply delivery in `pals-hooks.ts`, README/Pi docs/skill-map plus extraction contract surfacing, validation guardrails for S3 extraction/surfacing/closure, and v2.59 default-focus recommendation (S7 `pals-context-injection`). Final validation: Pi 227/227, cross-harness 135/135, artifact_consistency PASS, install surface 5 Pi extension files.
Per-phase detail (Phases 249–252 with PR numbers and durations) lives in `.paul/MILESTONES.md` and in the completed-milestone table further below.

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
Plans: `.paul/phases/245-evidence-closure-next-roadmap-decision/245-01-PLAN.md` + `245-01-SUMMARY.md` — ✅ Complete: sibling Pi extension loader-compat hotfix (no-op default factory appended to `module-activity-parsing.ts` and `artifact-slice-rendering.ts`); v2.56 evidence aggregated into `.paul/MILESTONES.md` and `.paul/PROJECT.md`; v2.57 recommendation recorded (Plan 243-02 S2 `workflow-resource-capsule-rendering`); Pi 216→218 (+2 loader-compat), cross-harness 128→129 (+1 v2.56 closure), install unchanged at 3 files. AC-0–AC-5 PASS. PR #160 merged 2026-05-02 (squash + delete-branch).

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
| v2.56 Pi Extension Submodule Extraction Wave | 2026-05-02 | 242-245 | Continued extracting bounded Pi extension submodules from `pals-hooks.ts` using the v2.55 generalized install surface: extension-extraction target baseline, S1 `artifact-slice-rendering` sibling extraction with named default-arg cycle-avoidance pattern, 5-doc surfacing with closure guardrails, and evidence closure with sibling Pi extension loader-compat hotfix (no-op default factories appended to `module-activity-parsing.ts` and `artifact-slice-rendering.ts`). Validation passes Pi 218/218 and cross-harness 129/129; install surface unchanged at 3 files. | active artifacts |
| v2.57 Pi Extension Submodule Extraction Wave — S2 Workflow/Resource Capsule Rendering | 2026-05-02 | 246-248 | Completed the compact S2 extraction wave: Phase 246 extracted `workflow-resource-capsule-rendering.ts` as the fourth sibling Pi extension module (PR #161), Phase 247 surfaced S2 across README/Pi docs/skill-map and extraction contract docs with validation guardrails (PR #162), and Phase 248 reconciled milestone evidence, added the shared-invariant closure guardrail, and recorded the v2.58 recommendation (PR #163 merged). Validation passes Pi 223/223 and cross-harness 131/131; install surface 4 files. | active artifacts |
| v2.58 Pi Extension Submodule Extraction Wave — S3 Guided Workflow Detection | 2026-05-03 | 249-252 | Completed the S3 extraction wave: Phase 249 created the S3 extraction contract + bounded submodule plan (PR #164), Phase 250 extracted `guided-workflow-detection.ts` as the fifth sibling Pi extension module while preserving S4 canonical reply delivery in `pals-hooks.ts` (PR #165), Phase 251 surfaced S3 across README/Pi docs/skill-map and contract docs with validation guardrails (PR #166), and Phase 252 reconciled milestone evidence, added the shared-invariant closure guardrail, and recorded the v2.59 recommendation S7 `pals-context-injection` (PR #167 merged). Validation passes Pi 227/227 and cross-harness 135/135; install surface 5 files. | active artifacts |
Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).
---
*Roadmap created: 2026-03-11*
*Last updated: 2026-05-03 — v2.59 Phase 253 closed and merged via PR #168 (squash-merge into main as `f326db54`); SUMMARY at `.paul/phases/253-s7-extraction-contract-bounded-submodule-plan/253-01-SUMMARY.md` (AC-1…AC-4 PASS; Pi 227/227, cross-harness 135/135, artifact_consistency PASS). v2.59 progress 1 of 4. Ready for /paul:plan Phase 254. v2.58 remains closed via PR #167.*