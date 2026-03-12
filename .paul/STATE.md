# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-03-11)

**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v0.4 Kernel & Modules

## Current Position

Milestone: v0.4 Kernel & Modules
Phase: 11 of 13 (Kernel Extraction & Module Refactor) — Re-planning
Plan: 11-01 complete (migrate.sh + install.sh update)
Status: Loop closed, ready for next PLAN (11-02)
Last activity: 2026-03-11 — Unified Plan 11-01

Progress:
- v0.4 Kernel & Modules: [███░░░░░░░] 30%
- Phase 11: [█████░░░░░] 50%

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ✓     [Loop complete — ready for next PLAN]
```

## Accumulated Context

### Decisions
| Decision | Phase | Impact |
|----------|-------|--------|
| "Linux of Harness Engineering" — minimal kernel, modular pals, universal drivers | Phase 10 | Foundational architecture for v0.4+ |
| Naming: Kernel, Modules, Drivers (not plugins/adapters) | Phase 10 | Consistent terminology throughout |
| Delegated workflows stay in kernel (kernel-utils) | Phase 10 | Only named pals become modules; fork kernel for different tools |
| Three-layer stack: Modules → Kernel → Drivers | Phase 10 | Each layer only talks to neighbors |
| 8 lifecycle hooks with priority ordering | Phase 10 | pre/post for plan, apply, unify + pre-test, post-task |
| 5 driver methods: workflow_invoke, hook_register, state_read/write, user_interact, command_register | Phase 10 | Platform abstraction contract |

### Deferred Issues
- ci-generation.md and sonarqube-integration.md — future module candidates
- plan-phase-tdd.md does not exist as standalone file — needs creation as TODD module workflow

### Blockers/Concerns
- Plan 11-01 (big-bang file move) broke live infrastructure — reverted
- New approach: migration script that moves files AND updates all live references atomically

## Session Continuity

Last session: 2026-03-11
Stopped at: Plan 11-01 loop closed, session paused
Next action: Run /paul:plan for Plan 11-02 (decouple hardcoded TODD/WALT refs in kernel workflows)
Resume file: .paul/HANDOFF-2026-03-11.md
Resume context:
- Plan 11-01 complete: repo restructured into kernel/ + modules/ via migrate.sh
- install.sh updated and validated, symlink updated
- Next: Plan 11-02 — remove hardcoded TODD/WALT references from kernel workflows

---
*STATE.md — Updated after every significant action*
