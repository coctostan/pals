# Roadmap: pals

## Overview
PALS — the Linux of Harness Engineering. Minimal kernel, modular pals, universal drivers. PAUL (project lifecycle) is the kernel. CARL (context rules), TODD (TDD enforcement), and WALT (quality gating) are first-party modules. Drivers make it run on any agentic coding platform.

## Milestones
Closed-milestone detail archived (see `## Completed Milestones` table below; pre-v2.44 detail in [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md); v2.44 detail in [archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md)).

## Current Milestone

**v2.69 Pi Runtime Context Offload — S4 First**
Status: ✅ Complete
Phases: 3 of 3 complete; v2.69 closed by PR #214 squash `08b0e891`
Theme: Use S4 canonical reply delivery as the next safe Pi runtime offload, proving the extraction pattern still holds while preserving lifecycle authority and ending with an evidence-backed ranking of next context-bloat reduction targets.

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 293 | S4 Offload Contract | 1 | Complete | 2026-05-20 |
| 294 | S4 Canonical Reply Delivery Extraction | 1/1 | ✅ Complete | 2026-05-20 |
| 295 | Context-Offload Measurement + Next Target Ranking | 1/1 | ✅ Complete | 2026-05-21 |

### Phase 293: S4 Offload Contract
Focus: Define the S4 boundary, allowed/forbidden file scope, context-bloat success framing, validation expectations, and authority guardrails.
Plans: 1 (`.paul/phases/293-s4-offload-contract/293-01-PLAN.md`)

### Phase 294: S4 Canonical Reply Delivery Extraction
Focus: Create a dedicated sibling such as `drivers/pi/extensions/guided-workflow-delivery.ts`; move `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, and `shouldAutoPresent` out of `pals-hooks.ts`; update docs/validation while preserving behavior exactly.
Plans: 1 (`.paul/phases/294-s4-canonical-reply-delivery-extraction/294-01-PLAN.md`)

### Phase 295: Context-Offload Measurement + Next Target Ranking
Focus: Review remaining agent-context burden after S4 and rank next safe TypeScript offload candidates such as workflow/resource capsule runtime loading, context injection targeting/dedupe, module activity summarization, and guided workflow routing ergonomics. Recommendation only; no second target implementation.
Plans: 1 (`.paul/phases/295-context-offload-measurement-next-target-ranking/295-01-PLAN.md`)

### Latest completed milestone: v2.68 Plannotator Retraction
Result: Phases 291–292 complete. Removed the live Plannotator integration surface, deleted the contract document, retracted current decision rows, preserved v2.66 archive evidence, and kept validation green at Pi 328/328 + cross-harness 234/234. PR #210 merged at squash `7c38f42e`.
### Latest completed milestone: v2.66 Plannotator Integration — Rich UI Review Surfaces
Result: Phases 284–287 complete. Added optional/advisory Plannotator plan/code review surfaces while preserving `.paul/*` lifecycle authority. PRs #202–#205.

### Latest completed milestone: v2.65 Functional-First Agent Guidance
Result: Phases 279–283 complete. Added “functional-first, not functional-only” guidance without overriding project conventions. Archive: [v2.65](archive/roadmap/v2.65-functional-first-agent-guidance.md).

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 279 | Functional-First Guidance Contract | 1/1 | ✅ Complete | 2026-05-12 |
| 280 | AGENTS/Init Engineering Principles + Marker Checks | 1/1 | ✅ Complete | 2026-05-13 |
| 281 | Brownfield Convention Detection | 1/1 | ✅ Complete | 2026-05-13 |
| 282 | TODD + RUBY Functional-First Guidance | 1/1 | ✅ Complete | 2026-05-13 |
| 283 | ARCH Advisory + Closure | 1/1 | ✅ Complete | 2026-05-13 |

## Completed Milestones

| Milestone | Completed | Phases | Summary |
|-----------|-----------|--------|---------|
| v2.44 PALS Context Optimization — Process & Artifacts | 2026-04-27 | 188-191 | Reduced recurring PALS context cost across wrappers, hot artifacts, workflow references, and validation guardrails. [archive](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md) |
| v2.45 Pi-Native PALS Architecture | 2026-04-27 | 192-196 | Repositioned PALS around Pi as the supported runtime; produced `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md`. |
| v2.46 Pi-Native Implementation Planning | 2026-04-27 | 197-201 | Produced `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md`. |
| v2.47 Artifact-Slice Contract Hardening | 2026-04-28 | 202-205 | `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md`; activation-gated, bounded, source-cited slices. |
| v2.48 Guided Workflow Evidence Hardening | 2026-04-28 | 206-209 | `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`; transcript-visible canonical replies; Pi 193/193, cross-harness 109/109. |
| v2.49 Workflow/Resource Capsule Contract | 2026-04-28 | 210-213 | `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md`; Pi 197/197, cross-harness 112/112. |
| v2.50 Delegated APPLY Packet/Report Contract | 2026-04-29 | 214-217 | `docs/PI-NATIVE-DELEGATED-APPLY-PACKET-REPORT-CONTRACT.md`; parent-owned packets/reports; Pi 200/200, cross-harness 116/116. |
| v2.51 Pi-Native Validation Classification | 2026-04-30 | 218-221 | `docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md`; Pi 203/203, cross-harness 119/119. |
| v2.52 Legacy Retention / Install-Surface Cleanup | 2026-04-30 | 222-225 | Pi-first install/uninstall by default with explicit frozen legacy/source-only opt-ins; Pi 205/205, cross-harness 121/121. |
| v2.53 Pi Integration Efficiency & Effectiveness Exploration | 2026-04-30 | 226-229 | Artifact-slice targeting/deduplication runtime spike; Pi 208/208, cross-harness 122/122. |
| v2.54 Contextual Verbosity Paring | 2026-04-30 | 230-233 | `docs/PALS-CONTEXTUAL-VERBOSITY-AUDIT.md`; Pi 209/209, cross-harness 123/123. |
| v2.55 Maintainability & Product Reality Hardening | 2026-05-01 | 234-241 | Product-reality audit, risk-tiered lifecycle contract, validation-suite decomposition baseline, artifact consistency guardrails, Pi extension modularization contract, bounded S5 extraction spike, first-run happy-path scenario doc, generalized Pi extension install surface; Pi 212/212, cross-harness 127/127. |
| v2.56 Pi Extension Submodule Extraction Wave | 2026-05-02 | 242-245 | S1 `artifact-slice-rendering` sibling extraction; sibling Pi extension loader-compat hotfix; Pi 218/218, cross-harness 129/129; install 3. |
| v2.57 Pi Extension Submodule Extraction Wave — S2 Workflow/Resource Capsule Rendering | 2026-05-02 | 246-248 | `workflow-resource-capsule-rendering.ts` (4th sibling); Pi 223/223, cross-harness 131/131; install 4. |
| v2.58 Pi Extension Submodule Extraction Wave — S3 Guided Workflow Detection | 2026-05-03 | 249-252 | `guided-workflow-detection.ts` (5th sibling); Pi 227/227, cross-harness 135/135; install 5. |
| v2.59 Pi Extension Submodule Extraction Wave — S7 PALS Context Injection | 2026-05-05 | 253-256 | `pals-context-injection.ts` (6th sibling, 88 LOC); type-only back-import + TAP-assertion repoint patterns first formally named; Pi 231/231, cross-harness 136/136; install 6. |
| v2.60 Pi Extension Submodule Extraction Wave — S6 Lifecycle UI Extraction | 2026-05-07 | 257-260 | `lifecycle-ui.ts` (7th sibling, 123 LOC); no-UI-only-lifecycle-decisions invariant verified shipped; Pi 235/235, cross-harness 137/137; install 7. |
| v2.61 Pi Extension Submodule Extraction Wave — S8 Command Routing Extraction | 2026-05-07 | 261-264 | `command-routing.ts` (8th and final unclaimed sibling, 230 LOC); per-sibling S1–S8 wave closed except S4; first-ever closure-record-convention establishment via `## Status After Phase 262` on the S8 contract; closure-guardrail recipe ratified 6× (Phase 245/248/252/256/260/264); 4-symbol `inline → export` lockstep promotion durable rule; Pi 242/243 with inherited Path A `not ok 102`; cross-harness 137/138 with inherited `not ok 31`; install 8. PRs #176/#177/#178/#179. |
| v2.62 PALS Context Diet — STATE & Hot-Path Compression | 2026-05-08 | 265-267 | Hot lifecycle artifacts archived/compacted to 63,415 B aggregate; Path A PASS; Selective Artifact Loading added across hot workflows; anti-regrowth TAPs and the 7th closure-guardrail recipe application ratified; v2.63 narrative deduplication / single-source summary architecture recommended-not-approved. PRs #180/#181/#182 (`068d7cb3`). |
| v2.63 Workflow Instruction Audit + Context-Efficiency Rewrite | 2026-05-10 | 268-272 | Rewrote resume, plan, apply, unify, and pause workflow instructions for bounded operational loading, concise lifecycle routing, parent-owned execution, SUMMARY-first reconciliation, compact agent-oriented handoffs, semantic guardrails, GitHub Flow safety, and required transition routing. Final validation: Pi 312/312, cross-harness 202/202. PR #188 (`df56ece1`). |
| v2.64 Module Instruction Audit + Context-Efficiency Rewrite | 2026-05-12 | 273-278 | Rewrote base/dispatch, core enforcement, advisory, and domain optional module instructions section-by-section; added semantic module-instruction validation guardrails (`tests/helpers/module_instruction_semantics.sh`); cleared inherited Phase 276 CODI marker drift in `tests/cross-harness-validation.sh` (195→202 PASS). Pi e2e 307/312 (5 baseline-inherited CODI marker drift recorded as future follow-up). PRs #190/#191/#192/#194/#195/#196 (`340eee03`). [archive](archive/roadmap/v2.64-module-instruction-audit-context-efficiency-rewrite.md) |
| v2.65 Functional-First Agent Guidance | 2026-05-13 | 279-283 | Added “functional-first, not functional-only” agent coding guidance across PALS without overriding project conventions: agent conventions, brownfield mapping, TDD, refactoring, and advisory ARCH side-effect-boundary surfaces. Final validation: cross-harness 234/234 PASS; Pi 322/328 (6 baseline-inherited CODI/PROJECT-budget failures unchanged pre/post). PRs #197/#198/#199/#200/#201. [archive](archive/roadmap/v2.65-functional-first-agent-guidance.md) |
| v2.66 Plannotator Integration — Rich UI Review Surfaces | 2026-05-14 | 284-287 | Added optional/advisory Plannotator plan-review and code-review surfaces while preserving `.paul/*` lifecycle authority. Final validation: cross-harness 246/246 PASS; Pi 328/335 with inherited CODI/PROJECT/ROADMAP-budget failures carried into v2.67. PRs #202/#203/#204/#205. |
| v2.67 Validation Hygiene | 2026-05-19 | 288-290 | Cleared inherited Pi e2e CODI marker drift and hot-artifact budget drift; final validation Pi 335/335 and cross-harness 246/246. [archive](archive/roadmap/v2.67-validation-hygiene.md) |
| v2.68 Plannotator Retraction | 2026-05-20 | 291-292 | Removed live Plannotator surfaces and contract document while preserving v2.66 archive evidence. Final validation: Pi 328/328, cross-harness 234/234. PR #210 merged at squash `7c38f42e`. |
| v2.69 Pi Runtime Context Offload — S4 First | 2026-05-22 | 293-295 | Created S4 canonical reply delivery contract (PR #212), extracted S4 delivery to `drivers/pi/extensions/guided-workflow-delivery.ts` (PR #213), then measured the context offload and ranked shared filesystem/state helper extraction as the next contract-first recommendation (PR #214 squash `08b0e891`). Final validation: Pi 331/331, cross-harness 235/235. |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).
---
*Last updated: 2026-05-22 — Phase 295 UNIFY and v2.69 milestone closure completed via PR #214 squash `08b0e891`.*
