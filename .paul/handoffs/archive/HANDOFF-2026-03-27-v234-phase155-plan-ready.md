# PAUL Handoff

**Date:** 2026-03-27T18:10:00Z
**Status:** paused

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** pals
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

---

## Current State

**Milestone:** v2.34 Pi Subagent Integration & PALS Implementer
**Phase:** 155 of 157 — PALS Implementer Design
**Plan:** 155-01 — created, awaiting approval

**Loop Position:**
```text
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ○        ○     [Plan created, awaiting approval]
```

## Git State

| Field | Value |
|-------|-------|
| Workflow | github-flow |
| Branch | main |
| Base | main |
| PR | none (N/A) |
| CI | N/A |
| Sync | 0 behind / 0 ahead |
| Working tree | modified (`.paul/ROADMAP.md`, `.paul/STATE.md`) + untracked phase directory (`.paul/phases/155-pals-implementer-design/`) |

---

## What Was Done

- Resumed the project at the Phase 155 planning boundary after Phase 154 completed.
- Read the resume, planning, loop, and project workflow/state artifacts needed to plan correctly.
- Created `.paul/phases/155-pals-implementer-design/155-01-PLAN.md` for Phase 155.
- Corrected the Phase 155 plan after user review so it explicitly targets `@tintinweb/pi-subagents`, its `.pi/agents/*.md` custom-agent format, and parent dispatch via the `Agent()` tool.
- Updated `.paul/STATE.md` and `.paul/ROADMAP.md` so the project is now in PLAN complete / awaiting APPLY for Phase 155.

---

## What's In Progress

- No APPLY implementation work has started.
- Phase 155 is paused at plan approval.
- The approved direction is now narrowed to a `pi-subagents`-specific design, not a generic runtime-agent design.

---

## Decisions / Mental Context

- Phase 155 must design a **parent-controlled PALS-native implementer** rather than trusting the current generic runtime `implementer` / `worker` behavior.
- Inline APPLY remains the behavioral reference model; any subagent-backed execution path must be judged against it.
- The design is now explicitly for **`@tintinweb/pi-subagents`**:
  - use repo-local `.pi/agents/*.md` agent definitions
  - use `Agent()` for dispatch
  - decide what belongs in agent frontmatter/body vs runtime dispatch parameters
- `.paul/*` remains authoritative lifecycle truth.
- REV behavior must remain unchanged.
- Scope remains additive and Pi-only where needed; no Pi-owned lifecycle state should be introduced.

---

## Blockers / Open Questions

- The plan is created but not yet approved for APPLY.
- Phase 155 still needs to answer the design questions inside the plan artifacts, including:
  - exact parent vs subagent responsibility split
  - prompt/context assembly strategy
  - module participation model for TODD/WALT/DEAN
  - tool/model resolution and fallback behavior
  - exact implementation targets for Phase 156 and validation targets for Phase 157

---

## What's Next

**Immediate:** Review and approve the Phase 155 plan, then run:
```bash
/paul:apply .paul/phases/155-pals-implementer-design/155-01-PLAN.md
```

**After that:** Execute the design plan to produce the three Phase 155 artifacts:
- `pals-implementer-contract.md`
- `prompt-and-module-strategy.md`
- `integration-handoff.md`

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Live project state; now shows PLAN complete for Phase 155 |
| `.paul/ROADMAP.md` | Milestone overview; now shows Phase 155 planning underway |
| `.paul/phases/155-pals-implementer-design/155-01-PLAN.md` | Executable Phase 155 design plan |
| `.paul/phases/154-pi-subagent-audit/pals-implementer-audit-summary.md` | Audit-derived design inputs and open questions |
| `.paul/phases/154-pi-subagent-audit/subagent-runtime-behavior.md` | Current subagent behavior and module-reach analysis |
| `drivers/pi/extensions/pals-hooks.ts` | Current Pi extension behavior and bounded context injection reference |
| `drivers/pi/skills/paul-review/SKILL.md` | Current deliberate REV subagent path |
| `kernel/workflows/apply-phase.md` | Inline APPLY reference model that the future implementer must preserve semantically |

---

## Resume Instructions

1. Read `.paul/STATE.md` for the authoritative current position.
2. Read `.paul/phases/155-pals-implementer-design/155-01-PLAN.md` to reload the exact design scope.
3. Read this handoff file for the session-specific correction: the design must target `@tintinweb/pi-subagents`, `.pi/agents/*.md`, and `Agent()` dispatch.
4. Approve the plan and run `/paul:apply .paul/phases/155-pals-implementer-design/155-01-PLAN.md`.
5. Keep Phase 155 design-only; do not start Phase 156 implementation during this APPLY run.

---

*Handoff created: 2026-03-27T18:10:00Z*
