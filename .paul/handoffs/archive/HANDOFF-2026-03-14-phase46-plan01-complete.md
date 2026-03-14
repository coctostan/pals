# PAUL Handoff

**Date:** 2026-03-14
**Status:** Phase 46 plan 01 complete, ready for plan 02

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** PALS — Project Automation & Lifecycle System
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

---

## Current State

**Milestone:** v2.0 Portability & Cross-Harness
**Phase:** 46 of 48 — In Progress (plan 01 of ~3 complete)
**Progress:** 1 of 4 phases done (25%)

**Loop Position:**
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ✓     [Plan 46-01 complete, ready for 46-02]
```

---

## What Was Done (This Session)

### Plan 46-01: Convention & Core Loop
- Created `docs/REFERENCE-RESOLUTION.md` (115 lines) — portable reference convention:
  - Two categories: project artifacts (`.paul/`) and kernel resources (`kernel/` logical prefix)
  - Adapter responsibility table (Claude Code, Pi, Generic)
  - Migration examples (old `@~/.pals/` → new `kernel/`)
- Updated 3 core loop workflows to portable conventions:
  - `kernel/workflows/plan-phase.md` — removed `@~/.pals/`, `@.paul/`, `~/.pals/modules.yaml`
  - `kernel/workflows/apply-phase.md` — same changes
  - `kernel/workflows/unify-phase.md` — same changes
- Updated 2 templates:
  - `kernel/templates/PLAN.md` — removed `@` prefix from context references
  - `kernel/templates/SUMMARY.md` — removed `@` from description

### Key Convention Established
- `@~/.pals/X` → `kernel/X` (logical path, adapter resolves)
- `@.paul/X` → `.paul/X` (remove `@`, path unchanged)
- `~/.pals/modules.yaml` → `kernel/modules.yaml`
- Claude-specific tool names → generic verbs (Read, Run, Search)

---

## What's Next

**Immediate:** `/paul:plan` for Plan 46-02

Plan 46-02 scope: Apply the same portable convention to ALL remaining kernel files:
- `kernel/workflows/` — ~15 remaining workflows (init, pause, resume, transition, fix-loop, etc.)
- `kernel/commands/paul/` — all command files
- `kernel/references/` — all reference files
- `kernel/rules/` — all rule files
- `kernel/templates/` — remaining templates

**After that:** Plan 46-03 — module files (`modules/*/`)

**After Phase 46:** Phase 47 (Pi Adapter), Phase 48 (Cross-Harness Validation)

---

## Key Constraint

**v2.0 Primary Constraint:** Claude Code zero-regression is the #1 test gate.

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Live project state — Plan 46-01 complete |
| `.paul/ROADMAP.md` | v2.0 milestone, 1/4 phases done |
| `docs/REFERENCE-RESOLUTION.md` | Portable reference convention (NEW — Phase 46-01) |
| `docs/ARTIFACT-SPEC.md` | Normative artifact schemas (Phase 45) |
| `docs/LIFECYCLE-SPEC.md` | State machine spec (Phase 45) |
| `docs/HOOK-CONTRACT.md` | Hook dispatch contract (Phase 45) |

---

## Audit Data (for 46-02 planning)

From the codebase audit at session start:
- **318 total `@` references** across kernel files
- Plan 46-01 addressed ~30 references (core loop + templates)
- **~288 remaining** across workflows, commands, references, rules
- Top files by reference density:
  - `kernel/references/ci-generation.md` (18 refs)
  - `kernel/rules/commands.md` (16 refs)
  - `kernel/references/context-management.md` (14 refs)
  - `kernel/commands/paul/plan-fix.md` (8 refs)
  - `kernel/workflows/map-codebase.md` (8 refs)

---

## Resume Instructions

1. Run `/paul:resume`
2. STATE.md shows Plan 46-01 complete, ready for Plan 46-02
3. Run `/paul:plan` to begin Plan 46-02
4. Apply same mechanical changes as 46-01 across remaining kernel files
5. Mechanical pattern: `@~/.pals/X` → `kernel/X`, `@.paul/X` → `.paul/X`, tool names → generic verbs

---

## Git State

Branch: `v2.0/portability-and-cross-harness`
Last commit: `3e7cfa3` (wip from session start — changes not yet committed)

---
*Handoff created: 2026-03-14*
