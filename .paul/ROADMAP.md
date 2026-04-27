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
**v2.45 Pi-Native PALS Architecture**
Status: 🚧 In Progress
Phases: 4 of 5 complete

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 192 | Support-Tier Reset + Surface Inventory | 1/1 | ✅ Complete | 2026-04-27 |
| 193 | Pi Runtime Capability Mapping | 1/1 | ✅ Complete | 2026-04-27 |
| 194 | Context-Efficiency Architecture | 1/1 | ✅ Complete | 2026-04-27 |
| 195 | Exploratory Pi-Native Spikes | 1/1 | ✅ Complete | 2026-04-27 |
| 196 | Final Pi-Native Architecture Proposal | TBD | Ready to plan | - |

### Phase 192: Support-Tier Reset + Surface Inventory
Focus: Declare Claude Code unsupported/frozen; inventory cross-harness assumptions, wrappers, prompts, docs, and validation expectations.
Plans: 192-01 complete — support-tier reset documented and Pi-native support inventory created.

### Phase 193: Pi Runtime Capability Mapping
Focus: Map PLAN/APPLY/UNIFY, modules, GitHub Flow, context injection, and handoffs onto Pi extension primitives.
Plans: 193-01 complete — Pi runtime capability map created in `docs/PI-RUNTIME-CAPABILITY-MAP.md`; Phase 194 inputs and validation redesign notes documented.

### Phase 194: Context-Efficiency Architecture
Focus: Design how runtime assistance reduces repeated prompt, workflow, artifact, and context cost while preserving artifact-first truth.
Plans: 194-01 complete — created `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` with context-cost surfaces, Pi-native assistance architecture, read/citation contract, Phase 195 spike backlog, validation redesign requirements, and Phase 196 open decisions.

### Phase 195: Exploratory Pi-Native Spikes
Focus: Run optional small prototypes to validate extension commands, lifecycle status, artifact tools, compaction hooks, UI dialogs, or related runtime-assistance ideas.
Plans: 195-01 complete — bounded, read-only artifact-slice context loading implemented for explicit Pi/PALS activation payloads; docs, structural validation, and module history updated; final validation passed Pi 186/186 and cross-harness 100/100.

### Phase 196: Final Pi-Native Architecture Proposal
Focus: Produce the final design doc, migration plan, implementation roadmap, explicit non-goals, and recommendations for follow-on implementation milestones.
Plans: TBD (defined during /paul:plan); ready to plan after Phase 195 artifact-slice spike completion.

## Next Milestone
Defined after v2.45 completion.
## Completed Milestones

| Milestone | Completed | Phases | Summary | Archive |
|-----------|-----------|--------|---------|---------|
| v2.44 PALS Context Optimization — Process & Artifacts | 2026-04-27 | 188-191 | Reduced recurring PALS context cost across wrappers, hot artifacts, workflow references, and validation guardrails. | [archive](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md) |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-27 — Phase 195 complete; Phase 196 ready to plan.*