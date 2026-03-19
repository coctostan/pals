# PAUL Handoff

**Date:** 2026-03-19T09:00:33-0400
**Status:** paused

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** PALS - Project Automation & Lifecycle System
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

---

## Current State

**Milestone:** v2.9 CARL Session Boundary Manager
**Phase:** 76 of 79 — API Validation & Prototype
**Plan:** Not started

**Loop Position:**
```
PLAN ──▶ APPLY ──▶ UNIFY
  ○        ○        ○     [Ready for first PLAN]
```

---

## What Was Done This Session

### v2.8 Module Report Clarity (complete milestone)
- Completed 4 phases (72-75) in ~30 minutes
- TODD: structured `module_report: todd` with Phase/Commit/Tests/Status table, uncommented SUMMARY.md subsection, unify reconciliation guidance
- WALT: `module_report: walt` with Before/After/Delta/Trajectory table, uncommented subsection, unify guidance with SKIP-gate omission
- SKIP: `module_report: skip` with capture vs suggestion split, uncommented subsection, unify guidance
- RUBY: `module_report: ruby` with File/Smell/Severity/Suggested Pattern table, uncommented subsection, unify guidance
- All four proof-bearing modules now have labeled module_report, uncommented template subsections, and per-module unify reconciliation guidance (8 guidance lines total)

### v2.9 CARL Session Boundary Manager (milestone created)
- Explored CARL's current state: dead weight on Pi (installed files, nothing reads them, zero lifecycle hooks)
- Investigated GSD2 (gsd-build/gsd-2): Pi SDK-based agent that implements fresh-session-per-unit using only standard Pi extension APIs
- Documented GSD2 mechanisms: `ctx.newSession()` via stashed `ExtensionCommandContext`, `pi.sendMessage({ triggerTurn: true })`, declarative dispatch table, disk-based state derivation
- Designed CARL Pi-native architecture: fresh session at phase boundaries by default, continue if context < 40%, mid-phase safety valve at 80%
- Created research artifacts and milestone with 4 phases

### Research Artifacts Created
- `.paul/phases/carl-research/gsd2-session-mechanisms.md` — complete GSD2 mechanism reference
- `.paul/phases/carl-research/carl-pi-design.md` — CARL Pi-native design document

---

## What's In Progress

- Nothing in progress — clean pause point between milestone creation and first PLAN

---

## What's Next

**Immediate:** Run `/paul:plan` for Phase 76 (API Validation & Prototype)
- Validate `ctx.getContextUsage()` return shape
- Validate `ctx.newSession()` via stashed command context (GSD2 pattern)
- Validate `pi.sendUserMessage()` for auto-resume
- Build minimal prototype of session creation + bootstrap from STATE.md

**After that:** Phase 77 (Core Implementation) — full CARL logic in pals-hooks.ts

---

## Key Decisions This Session

| Decision | Rationale |
|----------|-----------|
| No compaction — ever | CARL creates fresh sessions instead of degrading existing ones |
| Fresh session per phase by default | Eliminates context degradation; context monitoring is safeguard only |
| Hybrid continue model | Below threshold → continue in session; above → fresh session + handoff |
| Command context stashing (from GSD2) | `ctx.newSession()` requires ExtensionCommandContext; stash it from command handlers |
| CARL replaces old CARL entirely | Claude Code-era manifest/domains/commands are dead weight on Pi; new CARL is a session boundary manager |
| AGENTS.md template replaces global rules | Pi-native convention instead of CARL's parallel rule injection system |

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Live project state |
| `.paul/ROADMAP.md` | Phase overview with v2.9 milestone |
| `.paul/phases/carl-research/gsd2-session-mechanisms.md` | GSD2 fresh-session mechanism reference |
| `.paul/phases/carl-research/carl-pi-design.md` | CARL Pi-native design (decision model, config, lifecycle integration) |
| `/Users/maxwellnewman/.pi/agent/extensions/pals-hooks.ts` | Current Pi extension (CARL logic will be added here) |
| `/Users/maxwellnewman/.pi/agent/skills/pals/carl/` | Dead CARL files to be removed in Phase 78 |

---

## Git State

Branch: `feature/post-v27-complete`
Uncommitted: v2.8 milestone work (4 phases) + v2.9 milestone setup + CARL research artifacts
No WIP commit made yet — user may want to commit before resuming.

---

## Resume Instructions

1. Read `.paul/STATE.md` for latest position
2. Read `.paul/phases/carl-research/carl-pi-design.md` for CARL design context
3. Run `/paul:resume` or `/paul:plan` for Phase 76

---

*Handoff created: 2026-03-19T09:00:33-0400*
