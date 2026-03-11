# Milestone Context

**Generated:** 2026-03-11
**Status:** Ready for /paul:milestone

## Features to Build

- Fork PAUL framework into standalone PALS (Project Automation & Lifecycle System)
- Integrate TODD (TDD enforcement) and WALT (quality gating) as named subsystems in core workflows
- Integrate CARL (context rules) as a native PALS component
- Unified directory structure under `~/.pals/` or similar
- Single install script (git clone + setup)
- Shareable with other developers
- End-to-end validation of the unified system

## Scope

**Suggested name:** PALS v0.1 — Fork & Unify
**Estimated phases:** 6
**Focus:** Create a single, distributable framework that unifies PAUL, CARL, TODD, and WALT under the PALS brand.

## Phase Mapping

| Phase | Focus | Features |
|-------|-------|----------|
| 1 | Architecture & Design | Map current structure, design unified layout, decide what stays/changes |
| 2 | Fork & Restructure | Create PALS repo structure, reorganize framework files |
| 3 | Merge TODD/WALT | Integrate TODD (TDD) and WALT (quality) as native workflow steps |
| 4 | CARL Integration | Context rules as native PALS component |
| 5 | Install & Distribution | Setup script, skill wiring, hook configuration |
| 6 | End-to-End Validation | Full PLAN-APPLY-UNIFY loop on test project using PALS |

## Constraints

- Must remain Claude Code native (skills, hooks, markdown workflows)
- Must work as a drop-in replacement for current PAUL setup
- No breaking changes to workflow semantics — PLAN-APPLY-UNIFY loop stays
- Individual PAL names (PAUL, CARL, TODD, WALT) preserved as module identifiers
- Public repo, shareable with friends

## Additional Context

- Current PAUL framework lives at ~/.claude/paul-framework/
- CARL lives in .carl/ directories per project
- TODD/WALT are integrated subsystems within PALS workflows and references
- The todd project (~/claude/todd/) has all TODD/WALT work and validation
- User wants this to be the foundation for future enhancements: self-healing state, auto-resume, intelligence layer, plugin architecture
- Future milestone roadmap: v0.2 (self-healing), v0.3 (intelligence), v0.4 (plugin arch), v1.0 (public release)

---

*This file is temporary. It will be deleted after /paul:milestone creates the milestone.*
