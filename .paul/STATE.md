# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-03-12)

**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** Awaiting next milestone

## Current Position

Milestone: Awaiting next milestone
Phase: None active
Plan: None
Status: Milestone v0.4 Kernel & Modules complete — ready for next
Last activity: 2026-03-12 — Milestone completed

Progress:
- v0.4 Kernel & Modules: [██████████] 100% ✓

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ○        ○        ○     [Milestone complete - ready for next]
```

## Accumulated Context

### Decisions
| Decision | Phase | Impact |
|----------|-------|--------|
| Three-layer stack: Modules → Kernel → Drivers | Phase 10 | Each layer only talks to neighbors |
| 5 driver methods: workflow_invoke, hook_register, state_read/write, user_interact, command_register | Phase 10 | Platform abstraction contract |
| Agent SDK driver via query() API (not raw Anthropic API) | Phase 13 | Discovery confirmed GA SDK, same agent loop |
| Driver detection order: PALS_DRIVER env > ~/.claude/ > ANTHROPIC_AGENT_SDK > claude-code default | Phase 13 | Install-time driver resolution |
| Claude Code driver is install-time wiring, not runtime code | Phase 13 | The LLM IS the runtime driver |
| Workflow-as-system-prompt pattern for Agent SDK | Phase 13 | Same .md drives both drivers |

### Deferred Issues
- ci-generation.md and sonarqube-integration.md — future module candidates
- plan-phase-tdd.md does not exist as standalone file — needs creation as TODD module workflow
- Agent SDK hook dispatch not implemented (documented as future work)

### Blockers/Concerns
- None active

## Session Continuity

Last session: 2026-03-12
Stopped at: Milestone v0.4 Kernel & Modules complete
Next action: /paul:discuss-milestone or /paul:milestone
Resume file: .paul/MILESTONES.md

---
*STATE.md — Updated after every significant action*
