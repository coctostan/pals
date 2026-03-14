# PAUL Handoff

**Date:** 2026-03-14
**Status:** Phase 45 complete, ready for Phase 46

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** PALS — Project Automation & Lifecycle System
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

---

## Current State

**Milestone:** v2.0 Portability & Cross-Harness
**Phase:** 45 of 48 — Complete
**Progress:** 1 of 4 phases done (25%)

**Loop Position:**
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ✓     [Phase 45 complete]
```

---

## What Was Done (This Session)

- Created v2.0 milestone with 4 phases (45-48)
- Planned and executed Phase 45: Artifact & Lifecycle Spec
- Created 3 normative specification documents:
  - `docs/ARTIFACT-SPEC.md` (651 lines) — schemas for all 8 `.paul/` artifact types
  - `docs/LIFECYCLE-SPEC.md` (186 lines) — PLAN→APPLY→UNIFY state machine (7 states, 7 transitions)
  - `docs/HOOK-CONTRACT.md` (285 lines) — 6 hook points with input/output shapes, persistence rules, all 9 module registrations
- Committed: `9523b8e feat(45): Artifact & Lifecycle Spec — normative portable contracts`

---

## What's Next

**Immediate:** `/paul:plan` for Phase 46: Harness-Agnostic Skills

Phase 46 scope: Rewrite all workflows/commands to remove `@` references and Claude-specific assumptions. Implement portable reference resolution that works on both Claude Code (Read tool) and pi (read tool).

**After that:** Phase 47 (Pi Adapter), Phase 48 (Cross-Harness Validation)

---

## Key Constraint

**v2.0 Primary Constraint:** Claude Code zero-regression is the #1 test gate. Every phase must validate Claude Code functionality first, portability second.

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Live project state — Phase 45 complete |
| `.paul/ROADMAP.md` | v2.0 milestone, 1/4 phases done |
| `docs/ARTIFACT-SPEC.md` | Normative artifact schemas (Phase 46 depends on this) |
| `docs/LIFECYCLE-SPEC.md` | State machine spec (Phase 47 depends on this) |
| `docs/HOOK-CONTRACT.md` | Hook dispatch contract (Phase 47 depends on this) |
| `docs/HARNESS-PORTABILITY.md` | Design vision for portability |
| `docs/ADAPTER-CONTRACT.md` | Adapter compliance contract |

---

## Resume Instructions

1. Run `/paul:resume`
2. STATE.md shows Phase 45 complete, ready for Phase 46
3. Run `/paul:plan` to begin Phase 46: Harness-Agnostic Skills
4. Phase 46 will need to audit all `kernel/workflows/` and `kernel/commands/` for `@` references

---

## Git State

Branch: `v2.0/portability-and-cross-harness`
Last commit: `9523b8e`

---
*Handoff created: 2026-03-14*
