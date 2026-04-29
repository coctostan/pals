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

**v2.50 Delegated APPLY Packet/Report Contract**
Status: 🚧 In progress
Phases: 2 of 4 complete — started 2026-04-28; Phase 215 complete, Phase 216 ready to plan

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 214 | Delegated APPLY Packet/Report Contract Baseline | 1/1 | ✅ Complete | 2026-04-28 |
| 215 | Runtime Delegation Packet/Report Hardening | 1/1 | ✅ Complete | 2026-04-29 |
| 216 | Documentation + Validation Surfacing | TBD | 🔵 Not started | — |
| 217 | Evidence Reconciliation + Milestone Closure | TBD | 🔵 Not started | — |

### Phase 214: Delegated APPLY Packet/Report Contract Baseline
Focus: Define the bounded delegated APPLY packet/report contract before implementation: parent-owned packet fields, allowed/forbidden file scope, fallback triggers, structured report schema, validation classes, and no helper-owned `.paul/*` writes.
Plans: 214-01 complete. Created `docs/PI-NATIVE-DELEGATED-APPLY-PACKET-REPORT-CONTRACT.md` with parent-owned task packet schema, structured helper report schema, allowed/forbidden file scope, fallback triggers, validation classes, command-output evidence requirements, failure conditions, and Phase 215-217 handoffs.

### Phase 215: Runtime Delegation Packet/Report Hardening
Focus: Harden repo-source APPLY/helper-agent delegation behavior against the contract so task packets and reports are cheaper to inspect while parent APPLY still owns official verification, module gates, fallback judgment, file-scope checks, checkpoints, and lifecycle writes.
Plans: 215-01 complete. Hardened `kernel/workflows/apply-phase.md` and `.pi/agents/pals-implementer.md` for parent-owned task packets, structured helper reports, allowed/forbidden file scope, fallback triggers, changed-file diff checks, parent-run official verification, actual out-of-scope helper edit blocking, and no helper-owned lifecycle/validation/module/GitHub Flow authority. Validation passed Pi 197/197 and cross-harness 112/112.

### Phase 216: Documentation + Validation Surfacing
Focus: Surface the delegated APPLY packet/report guarantees in user-facing docs, Pi docs/skill map, helper-agent docs, and validation suites with command-output proof for Helper Delegation and Shared Invariant coverage.
Plans: TBD (defined during `/paul:plan`).

### Phase 217: Evidence Reconciliation + Milestone Closure
Focus: Reconcile helper delegation validation/evidence markers, command-output proof, module/GitHub Flow evidence, and lifecycle metadata before handing off to Pi-Native Validation Classification.
Plans: TBD (defined during `/paul:plan`).
## Completed Milestones

| Milestone | Completed | Phases | Summary | Archive |
|-----------|-----------|--------|---------|---------|
| v2.44 PALS Context Optimization — Process & Artifacts | 2026-04-27 | 188-191 | Reduced recurring PALS context cost across wrappers, hot artifacts, workflow references, and validation guardrails. | [archive](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md) |
| v2.45 Pi-Native PALS Architecture | 2026-04-27 | 192-196 | Repositioned PALS around Pi as the supported runtime, mapped Pi capabilities, designed context-efficiency architecture, validated artifact-slice context loading, and produced the final Pi-native architecture proposal. | active artifacts |
| v2.46 Pi-Native Implementation Planning | 2026-04-27 | 197-201 | Converted v2.45 architecture into implementation findings, workstreams, sequencing, validation/evidence strategy, and a final executable Pi-native implementation-plan proposal. | active artifacts |
| v2.47 Artifact-Slice Contract Hardening | 2026-04-28 | 202-205 | Hardened activation-gated, bounded, source-cited, freshness-aware artifact slices and full-read fallback across contract baseline, runtime hardening, docs/skill-map surfacing, and validation/evidence reconciliation. | active artifacts |
| v2.48 Guided Workflow Evidence Hardening | 2026-04-28 | 206-209 | Proved guided workflow evidence across contract baseline, runtime canonical replies, docs/settings validation surfacing, and final evidence reconciliation while preserving explicit user intent and command-output truth. | active artifacts |
| v2.49 Workflow/Resource Capsule Contract | 2026-04-28 | 210-213 | Defined and hardened source-cited, bounded, derived-only workflow/resource capsules; surfaced docs/validation evidence; closed with Pi 197/197 and cross-harness 112/112. | active artifacts |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-29 — Phase 215 complete; Phase 216 Documentation + Validation Surfacing ready to plan.*