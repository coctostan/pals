# Roadmap: pals

## Overview
PALS — the Linux of Harness Engineering. Minimal kernel, modular pals, universal drivers. PAUL (project lifecycle) is the kernel. CARL (context rules), TODD (TDD enforcement), and WALT (quality gating) are first-party modules. Drivers make it run on any agentic coding platform.

## Milestones
Closed-milestone detail archived (see `## Completed Milestones` table below; pre-v2.44 detail in [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md); v2.44 detail in [archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md)).

## Current Milestone

**v2.64 Module Instruction Audit + Context-Efficiency Rewrite**
Status: ✅ Complete (pending v2.64 milestone-closure routing) | Mode: exploratory / high collaboration | Phases: 6 of 6 complete
Theme: Audit and rewrite PALS module instruction sources through guardrail-first, section-by-section collaboration so base and optional modules become context-efficient, semantically enforced, lifecycle-compatible, and free of stale ceremony, marker-only compliance, redundancy, confusion, or incorrect guidance. Each phase must look at the module surface holistically for anything redundant, confusing, or simply wrong before proposing targeted rewrites.

| Phase | Name | Status | Plans |
|-------|------|--------|-------|
| 273 | Module Instruction Audit Contract + Cohort Map | ✅ Complete — PR #190 `f8861d44` | 273-01 |
| 274 | Base Module + Dispatch Instruction Rewrite | ✅ Complete — PR #191 `e18666ab` | 274-01 |
| 275 | Core Enforcement Module Rewrite | ✅ Complete — PR #192 `44b795d5` | 275-01 |
| 276 | Review, Knowledge, and Codegraph Module Rewrite | ✅ Complete — PR #194 `8c8dfb46` | 276-01 |
| 277 | Domain Optional Module Rewrite | ✅ Complete — PR #195 `aeff3f0a` | 277-01 |
| 278 | Module Guardrails + Closure | ✅ Complete — plan 278-01 PR #196 | 278-01 |

### Phase 273: Module Instruction Audit Contract + Cohort Map
Focus: Inventory base and optional module instruction sources, define v2.64 rewrite criteria, classify module cohorts, and standardize the v2.63-style collaborative protocol: semantic guardrails first, compact audit + proposed file/section order, blocking approval checkpoint, no edits ahead of approval, section re-read after each change, and final validation. The audit must look at each module holistically for redundancy, confusion, stale ceremony, marker-only compliance, and simply wrong guidance.
Plans: 273-01 (`.paul/phases/273-module-instruction-audit-contract-cohort-map/273-01-PLAN.md`; complete via PR #190 `f8861d44`)

### Phase 274: Base Module + Dispatch Instruction Rewrite
Focus: Collaboratively rewrite kernel/module-dispatch/base-module instructions, including lifecycle boundaries, hook semantics, skip/block evidence, compact dispatch output, and PAUL/CARL separation. Work file-by-file and section-by-section with user-approved wording before mutation.
Plans: 274-01 (`.paul/phases/274-base-module-dispatch-instruction-rewrite/274-01-PLAN.md`; complete via PR #191 `e18666ab`)

### Phase 275: Core Enforcement Module Rewrite
Focus: Collaboratively rewrite TODD, WALT, and other blocking/enforcement module instructions so they execute real checks, block with evidence, avoid stale ceremony, and cannot pass through marker prose or vague ritual. Work in small approved sections with holistic module review before edits.
Plans: 275-01 (`.paul/phases/275-core-enforcement-module-rewrite/275-01-PLAN.md`; complete, summary `.paul/phases/275-core-enforcement-module-rewrite/275-01-SUMMARY.md`)

### Phase 276: Review, Knowledge, and Codegraph Module Rewrite
Focus: Collaboratively rewrite IRIS, REV, SKIP, CODI, DOCS, and RUBY-style advisory module instructions for concise evidence, bounded source loading, non-blocking semantics, durable-but-compact persistence, and clear skip/no-scope behavior.
Plans: 276-01 (`.paul/phases/276-review-knowledge-and-codegraph-module-rewrite/276-01-PLAN.md`; complete, summary `.paul/phases/276-review-knowledge-and-codegraph-module-rewrite/276-01-SUMMARY.md`; PR #194 `8c8dfb46`)

### Phase 277: Domain Optional Module Rewrite
Focus: Collaboratively rewrite ARCH, SETH, GABE, ARIA, LUKE, DANA, DAVE, DEAN, OMAR, PETE, REED, VERA, and related domain module references/instructions by small file cohorts, preserving module-specific value while removing redundancy, confusion, stale assumptions, or incorrect guidance.
Plans: 277-01 (`.paul/phases/277-domain-optional-module-rewrite/277-01-PLAN.md`; complete, summary `.paul/phases/277-domain-optional-module-rewrite/277-01-SUMMARY.md`; PR #195 `aeff3f0a` — rewrote ARCH/SETH/OMAR/PETE/REED/VERA backend/runtime cross-cutting cohort; ARIA/LUKE/GABE/DANA/DAVE and DEAN deferred references reserved for follow-up)

### Phase 278: Module Guardrails + Closure
Focus: Add or update semantic validation so module instruction compliance cannot pass through marker prose alone, verify registry/module docs and installed/runtime surfaces where applicable, record evidence, and close the milestone.
Plans: 278-01 (`.paul/phases/278-module-guardrails-closure/278-01-PLAN.md`; complete, summary `.paul/phases/278-module-guardrails-closure/278-01-SUMMARY.md`; PR #196 — replaced inherited CODI marker-string validation drift with semantic module-instruction guardrails, added `tests/helpers/module_instruction_semantics.sh`, cross-harness 195→202 PASS; Pi e2e 5 baseline-inherited CODI marker-drift failures recorded for follow-up)

### Latest completed milestone: v2.63 Workflow Instruction Audit + Context-Efficiency Rewrite
Result: Phases 268–272 complete. Resume, plan, apply, unify, and pause workflow instructions now use bounded operational loading, concise lifecycle routing, parent-owned execution, SUMMARY-first reconciliation, compact agent-oriented handoffs, semantic guardrails, GitHub Flow safety, and required transition routing. v2.64 extends the same collaborative instruction-audit pattern from lifecycle workflows into base and optional module sources.

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

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).
---
*Last updated: 2026-05-12 — Phase 278 Plan 278-01 APPLY/UNIFY complete; v2.64 ready for milestone-closure routing.*
