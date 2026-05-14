# Roadmap: pals

## Overview
PALS — the Linux of Harness Engineering. Minimal kernel, modular pals, universal drivers. PAUL (project lifecycle) is the kernel. CARL (context rules), TODD (TDD enforcement), and WALT (quality gating) are first-party modules. Drivers make it run on any agentic coding platform.

## Milestones
Closed-milestone detail archived (see `## Completed Milestones` table below; pre-v2.44 detail in [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md); v2.44 detail in [archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md)).

## Current Milestone

**v2.66 Plannotator Integration — Rich UI Review Surfaces**
Status: 🚧 In Progress
Phases: 2 of 4 complete
Theme: Enhance human plan/code review with rich browser UI annotations via the existing `@plannotator/pi-extension`, while keeping PAUL's `.paul/*` lifecycle authority intact and Plannotator integration optional per-invocation.

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 284 | Plannotator Integration Contract | 1/1 | ✅ Complete | 2026-05-14 |
| 285 | PAUL ↔ Plannotator Bridge | 1/1 | ✅ Complete | 2026-05-14 |
| 286 | Plan Review Workflow Integration | 1/1 | ✅ Complete | 2026-05-14 |
| 287 | Code Review Workflow Integration | TBD | 🔵 Ready to plan | - |

### Phase 284: Plannotator Integration Contract
Focus: Produce authoritative `docs/PALS-PLANNOTATOR-UI-INTEGRATION-CONTRACT.md`. Investigate Plannotator source for event delivery mechanism, async result race recovery (`review-status` query pattern), extension-presence probe, result schema, `savedPath` semantics, multi-iteration behavior, and UI-abandoned timeout handling. Define advisory sidecar artifact contracts (`PLAN-REVIEW-NOTES.md`, `PLAN-FEEDBACK-{iteration}.md`, `CODE-REVIEW-NOTES.md`). Document non-adoption surface (`--plan` mode, `plannotator_submit_plan`, phase machine, `plannotator.json`, `agentSwitch`/`permissionMode`). Opt-in via `pals.json` `integrations.plannotator.enabled`. Validation classification: helper delegation + Pi-supported runtime; Pi-only. No code.
Plans: 284-01 (`.paul/phases/284-plannotator-integration-contract/284-01-PLAN.md`) — COMPLETE ✓ (`284-01-SUMMARY.md`)

### Phase 285: PAUL ↔ Plannotator Bridge
Focus: New sibling Pi extension `drivers/pi/extensions/plannotator-bridge.ts` following the S1–S8 extraction recipe (9th application of the loader-compat invariant). Helper functions `requestPlanReview(planPath)`, `requestCodeReview(diffType)`, `awaitReviewResult(reviewId, timeoutMs)`. Extension-presence detection with graceful fallback. Pi installed-resource marker checks per v2.65 pattern. No workflow instruction changes yet.
Plans: 285-01 (`.paul/phases/285-paul-plannotator-bridge/285-01-PLAN.md`) — COMPLETE ✓ (`285-01-SUMMARY.md`)

### Phase 286: Plan Review Workflow Integration
Focus: Edit `/paul:plan` workflow instructions for an end-of-PLAN per-invocation prompt. On approve: optional `PLAN-REVIEW-NOTES.md` sidecar; continue. On deny: write `PLAN-FEEDBACK-{iteration}.md`, re-enter PLAN with feedback as required reading; PAUL regenerates PLAN.md (never adopts Plannotator `savedPath` directly). Add one-line required-reading note to `/paul:apply` for `PLAN-REVIEW-NOTES.md`. Section-by-section workflow rewrite pattern (v2.63 lineage).
Plans: 286-01 (`.paul/phases/286-plan-review-workflow-integration/286-01-PLAN.md`) — COMPLETE ✓ (`286-01-SUMMARY.md`)

### Phase 287: Code Review Workflow Integration
Focus: Edit `/paul:apply` end-of-APPLY and `/paul:unify` for the same per-invocation prompt with `diffType` appropriate to the phase (uncommitted / staged / phase-range). Annotation feedback written to `.paul/phases/N/CODE-REVIEW-NOTES.md`. Advisory only — no automatic route to `/paul:fix`. Add one-line required-reading note to `/paul:unify` for `CODE-REVIEW-NOTES.md`. Both APPLY and UNIFY code-review hooks share the bridge — one phase, not two. Ready to plan after Phase 286 closure.
Plans: TBD (defined during /paul:plan)

## Next Milestone

v2.67 candidate: Validation Hygiene — clear the 6 baseline-inherited Pi e2e failures (5 CODI marker-drift checks + 1 PROJECT byte-budget) via the existing `tests/helpers/module_instruction_semantics.sh` helpers. Deferred from v2.66 per the v2.66 discussion (visual review UX prioritized over hygiene bookkeeping).

### Latest completed milestone: v2.65 Functional-First Agent Guidance
Result: Phases 279–283 complete. Added “functional-first, not functional-only” agent coding guidance across PALS without overriding project conventions: Phase 279 authoritative contract; Phase 280 AGENTS/init Engineering Principles + installed-resource marker checks; Phase 281 brownfield map-codebase signal detection for local idioms and effect boundaries; Phase 282 TODD pure-logic TDD + RUBY Extract Pure Core advisory guidance + marker checks; Phase 283 advisory ARCH side-effect-boundary guidance (Pure Core, Explicit Effects), `The Leaking Effect` drift label, and Pi+cross-harness installed-resource marker validation (5 + 10 assertions). Archive: [archive/roadmap/v2.65-functional-first-agent-guidance.md](archive/roadmap/v2.65-functional-first-agent-guidance.md).

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

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).
---
*Last updated: 2026-05-13 — v2.65 milestone complete; awaiting next milestone.*
