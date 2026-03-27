# PAUL Handoff

**Date:** 2026-03-27T19:20:00Z
**Status:** paused

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** pals
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

---

## Current State

**Version:** v2.34 Pi Subagent Integration & PALS Implementer
**Phase:** 156 of 157 — PALS Implementer Integration
**Plan:** 156-01 — created, awaiting approval

**Loop Position:**
```text
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ○        ○
```

## Git State

| Field | Value |
|-------|-------|
| Branch | feature/155-pals-implementer-design |
| Base | main |
| PR | https://github.com/coctostan/pals/pull/63 (MERGED) |
| CI | passing |
| Behind base | 1 commit |

---

## What Was Done

- Resumed from the CARL session boundary and restored authoritative context from `.paul/STATE.md` plus the Phase 155 summary.
- Resolved the merge gate by merging PR #63, which closed Phase 155 (`PALS Implementer Design`).
- Planned Phase 156 and created `.paul/phases/156-pals-implementer-integration/156-01-PLAN.md`.
- Updated `.paul/STATE.md` and `.paul/ROADMAP.md` to move the project into Phase 156 planning status.

---

## What's In Progress

- Phase 156 is ready for APPLY but execution has not started.
- The working tree contains only planning/lifecycle changes for Phase 156:
  - modified: `.paul/STATE.md`
  - modified: `.paul/ROADMAP.md`
  - untracked: `.paul/phases/156-pals-implementer-integration/156-01-PLAN.md`

---

## What's Next

**Immediate:** Review/approve the plan and run:
```bash
/skill:paul-apply .paul/phases/156-pals-implementer-integration/156-01-PLAN.md
```

**After that:** Implement the repo-local `pals-implementer` path, then proceed to Phase 156 UNIFY and later Phase 157 validation/polish.

---

## Key Decisions / Mental Context

- Phase 155 settled the architecture: do **not** trust the generic runtime `implementer` / `worker` as PALS authority.
- The new path must be **parent-controlled**: APPLY remains the orchestrator for verification, module enforcement, checkpoints, fallback, and `.paul/*` writes.
- The delegated path is **task-bounded**, not whole-loop delegation.
- The repo-local custom agent should live at `.pi/agents/pals-implementer.md` and be invoked explicitly through `Agent()`.
- Any config or Pi extension changes in Phase 156 must stay minimal and must not create Pi-owned lifecycle truth.
- REV must remain untouched; its `code-reviewer` path is already deliberate and should not be repurposed.

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Live project state and session continuity |
| `.paul/ROADMAP.md` | Milestone/phase overview |
| `.paul/phases/156-pals-implementer-integration/156-01-PLAN.md` | Executable Phase 156 implementation plan |
| `.paul/phases/155-pals-implementer-design/pals-implementer-contract.md` | Authority/fallback/equivalence contract from Phase 155 |
| `.paul/phases/155-pals-implementer-design/prompt-and-module-strategy.md` | Prompt assembly, module boundary, tooling/model strategy |
| `.paul/phases/155-pals-implementer-design/integration-handoff.md` | File-level implementation targets and validation matrix |
| `kernel/workflows/apply-phase.md` | Main shared workflow Phase 156 will modify |
| `drivers/pi/skills/paul-apply/SKILL.md` | Pi apply skill guidance to align with delegated APPLY |
| `drivers/pi/extensions/pals-hooks.ts` | Pi extension surface; only narrow support changes allowed |
| `pals.json` | Repo config surface; may get a minimal implementer config block |

---

## Resume Instructions

1. Read `.paul/STATE.md` for the authoritative latest position.
2. Read `.paul/phases/156-pals-implementer-integration/156-01-PLAN.md`.
3. If needed, re-read the three Phase 155 design artifacts listed above.
4. Run `/skill:paul-resume` or directly approve and run `/skill:paul-apply .paul/phases/156-pals-implementer-integration/156-01-PLAN.md`.

---

*Handoff created: 2026-03-27T19:20:00Z*