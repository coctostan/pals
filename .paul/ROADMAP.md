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

**v2.52 Legacy Retention / Install-Surface Cleanup**
Status: 🚧 In Progress
Phases: 1 of 4 complete — starts 2026-04-30

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 222 | Legacy / Install-Surface Cleanup Contract Baseline | 1/1 | ✅ Complete | 2026-04-30 |
| 223 | Safe Cleanup Implementation | TBD | Ready to plan | - |
| 224 | Documentation + Validation Surfacing | TBD | Not started | - |
| 225 | Evidence Reconciliation + Milestone Closure | TBD | Not started | - |

### Phase 222: Legacy / Install-Surface Cleanup Contract Baseline
Focus: Define exact safe cleanup targets and preservation boundaries using v2.51 validation classification before any frozen legacy or install-surface removal/relocation.
Plans: 222-01 — ✅ Complete. Created the baseline cleanup contract for frozen legacy/install surfaces, retention/removal decision rules, protected shared invariants, verification requirements, failure conditions, and Phase 223 handoff before any cleanup implementation.

### Phase 223: Safe Cleanup Implementation
Focus: Apply bounded legacy retention and install-surface cleanup only where the baseline proves Shared Invariant, Artifact / Process, and Pi-supported runtime guarantees remain protected.
Plans: TBD (ready for /paul:plan)

### Phase 224: Documentation + Validation Surfacing
Focus: Update user-facing docs and validation/report surfaces to describe the cleaned install/legacy posture without making stale reports replace command-output truth.
Plans: TBD (defined during /paul:plan)

### Phase 225: Evidence Reconciliation + Milestone Closure
Focus: Reconcile cleanup evidence, validation counts, module/GitHub Flow evidence, lifecycle metadata, and remaining deferred boundaries before closing v2.52.
Plans: TBD (defined during /paul:plan)

### Previous milestone: v2.51 Pi-Native Validation Classification
Result: Phases 218-221 complete. Phase 221 reconciled v2.51 evidence, final classification markers, validation counts, module/GitHub Flow evidence, and lifecycle metadata; validation passes Pi 203/203 and cross-harness 119/119; PR #136 merged. v2.51 hands off to Legacy Retention / Install-Surface Cleanup.

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

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-30 — Phase 222 complete and PR #137 merged; Phase 223 is ready to plan.*