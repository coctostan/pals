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
**v2.46 Pi-Native Implementation Planning**
Status: 🚧 In Progress
Phases: 2 of 5 complete

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 197 | v2.45 Findings Triage | 1/1 | Complete | 2026-04-27 |
| 198 | Implementation Workstream Design | 1/1 | Complete | 2026-04-27 |
| 199 | Sequencing + Dependency Plan | TBD | Ready to plan | - |
| 200 | Validation + Evidence Strategy | TBD | Not started | - |
| 201 | Final Implementation Plan Proposal | TBD | Not started | - |

### Phase 197: v2.45 Findings Triage
Focus: Extract and classify v2.45 findings, decisions, promoted patterns, rejected options, constraints, and unresolved implementation questions before planning build work.
Plans: 197-01 complete — created and unified `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` with source-cited v2.45 findings, authority boundaries, workstream seeds, open questions, Phase 198-201 handoff recommendations, and readiness checklist.

### Phase 198: Implementation Workstream Design
Focus: Convert the v2.45 migration and implementation roadmap into concrete workstreams across artifact slices, workflow/resource capsules, guided UI evidence, helper-agent packets, validation classification, and legacy retention.
Plans: 198-01 complete — created and unified `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md` with source-cited candidate workstreams, readiness classifications, repo surfaces, validation/evidence expectations, authority boundaries, dependency edges, risk gates, unresolved decisions, and Phase 199 sequencing handoff inputs.

### Phase 199: Sequencing + Dependency Plan
Focus: Define ordering, dependencies, proof points, risk gates, and boundaries for implementation milestones so later build work proceeds safely.
Plans: TBD (defined during /paul:plan)

### Phase 200: Validation + Evidence Strategy
Focus: Define how implementation will preserve Pi-supported runtime checks, shared invariants, frozen legacy evidence, runtime lens checks, guided UI safety, and helper-agent delegation checks.
Plans: TBD (defined during /paul:plan)

### Phase 201: Final Implementation Plan Proposal
Focus: Produce the executable Pi-native implementation roadmap for the next build milestone(s), with acceptance criteria, phase recommendations, and non-negotiable authority boundaries.
Plans: TBD (defined during /paul:plan)
## Completed Milestones

| Milestone | Completed | Phases | Summary | Archive |
|-----------|-----------|--------|---------|---------|
| v2.44 PALS Context Optimization — Process & Artifacts | 2026-04-27 | 188-191 | Reduced recurring PALS context cost across wrappers, hot artifacts, workflow references, and validation guardrails. | [archive](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md) |
| v2.45 Pi-Native PALS Architecture | 2026-04-27 | 192-196 | Repositioned PALS around Pi as the supported runtime, mapped Pi capabilities, designed context-efficiency architecture, validated artifact-slice context loading, and produced the final Pi-native architecture proposal. | active artifacts |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-27 — Phase 198 complete; Phase 199 ready to plan sequencing and dependency constraints.*