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

**v2.47 Artifact-Slice Contract Hardening**
Status: 🚧 In Progress
Phases: 1 of 4 complete

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 202 | Slice Inventory + Contract Baseline | 1/1 | ✅ Complete | 2026-04-27 |
| 203 | Runtime Slice Hardening | TBD | Ready to plan | - |
| 204 | Documentation + Skill Map Surfacing | TBD | Not started | - |
| 205 | Validation + Evidence Reconciliation | TBD | Not started | - |

### Phase 202: Slice Inventory + Contract Baseline
Focus: Define the named artifact-slice inventory, stable schema fields, freshness/bounds/fallback rules, protected files, validation classes, and non-goals before runtime hardening begins.
Plans: 202-01 complete — created and unified `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md` with named slice inventory, schema fields, freshness/bounds/fallback rules, validation classes, marker-check families, protected files, failure conditions, durable evidence requirements, and Phase 203 handoff.

### Phase 203: Runtime Slice Hardening
Focus: Harden Pi extension artifact-slice output so slices remain activation-gated, bounded, source-cited, freshness-aware, read-only, and backed by full authoritative reads.
Plans: TBD (defined during /paul:plan). Ready to plan next.

### Phase 204: Documentation + Skill Map Surfacing
Focus: Update Pi extension documentation and skill-map surfacing so artifact slices are documented as orientation aids and full reads remain required for edits, lifecycle writes, stale facts, ambiguity, and decisions.
Plans: TBD (defined during /paul:plan)

### Phase 205: Validation + Evidence Reconciliation
Focus: Add or adjust runtime-lens validation markers, preserve Pi and cross-harness command-output evidence, reconcile module/GitHub Flow proof, and hand off safely to the next Pi-native build milestone.
Plans: TBD (defined during /paul:plan)
## Completed Milestones

| Milestone | Completed | Phases | Summary | Archive |
|-----------|-----------|--------|---------|---------|
| v2.44 PALS Context Optimization — Process & Artifacts | 2026-04-27 | 188-191 | Reduced recurring PALS context cost across wrappers, hot artifacts, workflow references, and validation guardrails. | [archive](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md) |
| v2.45 Pi-Native PALS Architecture | 2026-04-27 | 192-196 | Repositioned PALS around Pi as the supported runtime, mapped Pi capabilities, designed context-efficiency architecture, validated artifact-slice context loading, and produced the final Pi-native architecture proposal. | active artifacts |
| v2.46 Pi-Native Implementation Planning | 2026-04-27 | 197-201 | Converted v2.45 architecture into implementation findings, workstreams, sequencing, validation/evidence strategy, and a final executable Pi-native implementation-plan proposal. | active artifacts |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-27 — Phase 202 complete; ready to plan Phase 203 Runtime Slice Hardening.*