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
**v2.44 PALS Context Optimization — Process & Artifacts**
Status: 🚧 In Progress
Started: 2026-04-26
Theme: Continue reducing recurring context cost across PALS workflows and lifecycle artifacts while preserving artifact-first truth, module evidence, and GitHub Flow safety.
Source context: direct exploratory milestone creation on 2026-04-26 via `/skill:paul-milestone`
Phases: 2 of 4 complete (50%)
| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 188 | Workflow Prompt/Skill Slimming | 1/1 | ✅ Complete | 2026-04-27 |
| 189 | Hot-Path Read Audit | 1/1 | ✅ Complete | 2026-04-27 |
| 190 | Artifact Structure Simplification | 1/3 complete; 190-02 APPLY complete | In progress — ready for UNIFY | - |
| 191 | Validation + Anti-Regrowth Update | TBD | Not started | - |
### Phase 188: Workflow Prompt/Skill Slimming
Focus: Reduce recurring prompt, skill, and workflow read cost without weakening lifecycle semantics, module dispatch evidence, artifact authority, or GitHub Flow safety.
Plans: 188-01 complete (`.paul/phases/188-workflow-prompt-skill-slimming/188-01-SUMMARY.md`) — selected wrapper total reduced from 406 to 296 lines while Pi and cross-harness validation remained green.
### Phase 189: Hot-Path Read Audit
Focus: Measure what PALS reads repeatedly during normal PLAN/APPLY/UNIFY and identify remaining avoidable context load across workflows and lifecycle artifacts.
Plans: 189-01 complete (`.paul/phases/189-hot-path-read-audit/189-01-SUMMARY.md`) — audit report `.paul/phases/189-hot-path-read-audit/189-01-HOT-PATH-READ-AUDIT.md` produced 8 findings (F1–F8) and 10 recommendations (R1–R10); pi 177/177 + cross-harness 90/90 unchanged; PR #101 merged.
### Phase 190: Artifact Structure Simplification
Focus: Simplify active `.paul/*` artifacts and conventions where they still create avoidable context load while preserving archive authority and resume/status completeness.
Primary inputs from Phase 189 audit (R1–R5):
- R1 — Apply STATE archive pattern to ROADMAP (move completed milestones to `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md`).
- R2 — Centralize duplicated GitHub Flow stanzas (apply Phase 186 module-dispatch precedent to `kernel/references/git-strategy.md`).
- R3 — Hoist module-dispatch priority/taxonomy verbiage out of `apply-phase.md`/`unify-phase.md`.
- R4 — Conditional references in `apply-phase.md` (checkpoints / subagent-criteria).
- R5 (stretch) — Split `drivers/pi/extensions/pals-hooks.ts` into responsibility-scoped modules.
Plans:
- 190-01 complete (`.paul/phases/190-artifact-structure-simplification/190-01-SUMMARY.md`) — R1: ROADMAP archive split; compacted live roadmap to 68 lines and moved completed milestone detail to `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md`.
- 190-02 APPLY complete (`.paul/phases/190-artifact-structure-simplification/190-02-PLAN.md`) — R2 + R3 + R4: workflow centralization wave applied; GitHub Flow stanzas and module-dispatch taxonomy centralized, APPLY conditional refs encoded; awaiting UNIFY summary.
- R5 (Pi adapter modular split) deferred to a future driver-quality milestone.
### Phase 191: Validation + Anti-Regrowth Update
Focus: Extend validation guardrails so v2.44 slimming work stays protected across harnesses without brittle exact-prose checks.
Plans: TBD (defined during /paul:plan)
## Completed Milestones

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md) and the per-milestone phase narratives are preserved in the archive linked above.

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-27 — Phase 190 Plan 190-02 APPLY complete; awaiting UNIFY.*