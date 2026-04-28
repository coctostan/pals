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

**v2.48 Guided Workflow Evidence Hardening**
Status: ✅ Complete
Phases: 4 of 4 complete — started 2026-04-28; completed 2026-04-28

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 206 | Guided Workflow Evidence Contract Baseline | 1/1 | ✅ Complete | 2026-04-28 |
| 207 | Runtime Guided Reply Hardening | 1/1 | ✅ Complete | 2026-04-28 |
| 208 | Documentation + Validation Surfacing | 1/1 | ✅ Complete | 2026-04-28 |
| 209 | Evidence Reconciliation + Milestone Closure | 1/1 | ✅ Complete | 2026-04-28 |

### Phase 206: Guided Workflow Evidence Contract Baseline
Focus: Defined the guided workflow moment inventory, canonical transcript reply schema, explicit-intent/no-auto-continue boundaries, validation classes, failure conditions, and Phase 207+ handoff before runtime guided reply hardening begins.
Plans: 206-01 complete — created `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`; validation passed Pi 188/188 and cross-harness 104/104; PR #121 merge gate handled during UNIFY.

### Phase 207: Runtime Guided Reply Hardening
Focus: Harden repo-source Pi extension guided workflow behavior so plan review, APPLY approval, checkpoint choices, resume-next, continue-to-UNIFY, phase/milestone transition, and merge-gate routing remain explicit canonical user-message replies with no auto-approval, no auto-continue, no skipped checkpoints, and no UI-only lifecycle decisions.
Plans: 207-01 complete — `.paul/phases/207-runtime-guided-reply-hardening/207-01-PLAN.md`; runtime hardening merged via PR #122 as `688532cc`; Pi 188/188 and cross-harness 104/104 passing.

### Phase 208: Documentation + Validation Surfacing
Focus: Surface guided workflow evidence rules in Pi extension docs, skill map, and guided workflow settings documentation while adding focused validation markers for canonical replies, no-auto/no-UI-only boundaries, checkpoint blocking, and command-output truth.
Plans: 208-01 complete — `.paul/phases/208-documentation-validation-surfacing/208-01-PLAN.md`; docs/settings surfacing and validation markers implemented; Pi 192/192 and cross-harness 108/108 passing; PR #123 merged via squash as `60a9d113`.

### Phase 209: Evidence Reconciliation + Milestone Closure
Focus: Reconcile guided workflow validation/evidence markers, command-output proof, module/GitHub Flow evidence, and lifecycle metadata before handing off to the next Pi-native build milestone.
Plans: 209-01 complete — `.paul/phases/209-evidence-reconciliation-milestone-closure/209-01-PLAN.md`; evidence baselines reconciled; validation passed Pi 193/193 and cross-harness 109/109; SUMMARY `.paul/phases/209-evidence-reconciliation-milestone-closure/209-01-SUMMARY.md`; PR #124 merge gate handled during UNIFY.
## Completed Milestones

| Milestone | Completed | Phases | Summary | Archive |
|-----------|-----------|--------|---------|---------|
| v2.44 PALS Context Optimization — Process & Artifacts | 2026-04-27 | 188-191 | Reduced recurring PALS context cost across wrappers, hot artifacts, workflow references, and validation guardrails. | [archive](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md) |
| v2.45 Pi-Native PALS Architecture | 2026-04-27 | 192-196 | Repositioned PALS around Pi as the supported runtime, mapped Pi capabilities, designed context-efficiency architecture, validated artifact-slice context loading, and produced the final Pi-native architecture proposal. | active artifacts |
| v2.46 Pi-Native Implementation Planning | 2026-04-27 | 197-201 | Converted v2.45 architecture into implementation findings, workstreams, sequencing, validation/evidence strategy, and a final executable Pi-native implementation-plan proposal. | active artifacts |
| v2.47 Artifact-Slice Contract Hardening | 2026-04-28 | 202-205 | Hardened activation-gated, bounded, source-cited, freshness-aware artifact slices and full-read fallback across contract baseline, runtime hardening, docs/skill-map surfacing, and validation/evidence reconciliation. | active artifacts |
| v2.48 Guided Workflow Evidence Hardening | 2026-04-28 | 206-209 | Proved guided workflow evidence across contract baseline, runtime canonical replies, docs/settings validation surfacing, and final evidence reconciliation while preserving explicit user intent and command-output truth. | active artifacts |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-28 — v2.48 complete; ready for next milestone decision.*