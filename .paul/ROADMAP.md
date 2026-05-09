# Roadmap: pals

## Overview
PALS — the Linux of Harness Engineering. Minimal kernel, modular pals, universal drivers. PAUL (project lifecycle) is the kernel. CARL (context rules), TODD (TDD enforcement), and WALT (quality gating) are first-party modules. Drivers make it run on any agentic coding platform.

## Milestones
Closed-milestone detail archived (see `## Completed Milestones` table below; pre-v2.44 detail in [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md); v2.44 detail in [archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md)).

## Current Milestone

**v2.63 Workflow Instruction Audit + Context-Efficiency Rewrite**
Status: 🚧 In Progress | Mode: direct-requirements / interactive review | Phases: 1 of 5 complete | Current: Phase 269 planning | Created: 2026-05-08
Theme: Interactively audit and rewrite the core PALS lifecycle workflow instructions so their actual procedural steps are context-efficient, semantically correct, and free of contradictory legacy behavior. Focus is not marker-prose compliance; each phase must read the workflow closely, identify instructions that cause over-reading, stale context use, unnecessary ceremony, artifact bloat, helper-boundary confusion, or validation false positives, then edit the workflow text to make the intended behavior operational.

| Phase | Name | Status | Plans |
|-------|------|--------|-------|
| 268 | Resume Workflow Instruction Audit + Context-Efficiency Rewrite | ✅ Complete (2026-05-09) | 268-01 ✅ |
| 269 | Plan Workflow Instruction Audit + Context-Efficiency Rewrite | ✅ Complete (2026-05-09) | 269-01 ✅ |
| 270 | Apply Workflow Instruction Audit + Context-Efficiency Rewrite | Ready to plan | TBD |
| 271 | Unify Workflow Instruction Audit + Context-Efficiency Rewrite | Not started | TBD |
| 272 | Pause Workflow Instruction Audit + Context-Efficiency Rewrite | Not started | TBD |

### Phase 268: Resume Workflow Instruction Audit + Context-Efficiency Rewrite — Complete
Rewrote `kernel/workflows/resume-project.md` so routine resume starts from bounded STATE windows, resolves handoff/resume context only when needed, avoids decorative report reads, and uses narrow handoff lifecycle cleanup. Added Pi and cross-harness semantic guardrails that fail on broad STATE reads, eager handoff-file reads, stale archived-handoff preference, or handoff routing before STATE. Summary: `.paul/phases/268-resume-workflow-instruction-audit/268-01-SUMMARY.md`.

### Phase 269: Plan Workflow Instruction Audit + Context-Efficiency Rewrite — Complete
Rewrote `kernel/workflows/plan-phase.md` so routine planning starts from bounded STATE windows and current ROADMAP target-phase context, reads PROJECT/PRD/prior summaries only when needed, uses proportional collaboration prompts, keeps CODI seed preparation compact and bounded, and reports plan review/state updates concisely. Added Pi and cross-harness semantic guardrails that fail on broad/eager plan reads, mandatory prompt ceremony, missing bounded read order, or stale marker-only compliance. Summary: `.paul/phases/269-plan-workflow-instruction-audit/269-01-SUMMARY.md`.

### Phase 270: Apply Workflow Instruction Audit + Context-Efficiency Rewrite
Review `kernel/workflows/apply-phase.md` for execution-time context efficiency, parent-owned APPLY boundaries, helper delegation limits, checkpoint payload size, verification load, lifecycle artifact reads/writes, and instructions that encourage broad artifact scans or brittle validation.

### Phase 271: Unify Workflow Instruction Audit + Context-Efficiency Rewrite
Review `kernel/workflows/unify-phase.md` for reconciliation and summary behavior that duplicates narrative across artifacts, over-expands module evidence, weakens source-of-truth boundaries, or lets closure pass with prose markers instead of semantic evidence.

### Phase 272: Pause Workflow Instruction Audit + Context-Efficiency Rewrite
Review `kernel/workflows/pause-work.md` for handoff creation, compact resume payloads, stale-context prevention, archive/delete lifecycle, and instructions that cause future sessions to load irrelevant or obsolete artifacts.

### Latest completed milestone: v2.62 PALS Context Diet — STATE & Hot-Path Compression
Result: Phases 265–267 complete. Phase 265 created the authoritative context-diet contract (`docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md`); Phase 266 archive/compact reduced hot artifacts to 63,415 B aggregate (STATE 18,843 B / PROJECT 18,777 B / MILESTONES 14,610 B / ROADMAP 11,185 B) and resolved Path A to Pi 243/243 + cross-harness 138/138 PASS; Phase 267 delivered Selective Artifact Loading wording and anti-regrowth TAPs, but this session exposed that the actual workflow instructions still contain contradictory broad-read/stale-context behavior. v2.63 supersedes the prior narrative-dedup recommendation with a stricter interactive instruction audit.

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

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).
---
*Last updated: 2026-05-09 — Phase 269 complete; Phase 270 ready to plan.*
