# PAUL Handoff

**Date:** 2026-04-18
**Status:** APPLY paused — Phase 179 observation window open, awaiting concurrent-natural quark phases

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** pals — Project Automation & Lifecycle System
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

This pause happened mid-APPLY of Phase 179 after the plan was amended to broaden trial fuel and the first pre-authored row was logged. Phase 179 is deliberately held open to collect more natural observation data before reconciling into Phase 180.

---

## Current State

**Milestone:** v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation
**Phase:** 179 of ~3 — Organic Observation Window
**Plan:** `179-01` amended mid-APPLY; provisional SUMMARY exists

**Loop Position:**
```text
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ◐        ○     [APPLY paused — observation window open]
```

## Git State

| Field | Value |
|-------|-------|
| Branch | feature/179-organic-observation |
| Base | main |
| PR | none (N/A) |
| CI | N/A |
| Behind base | Up to date |
| Local ahead | 1 wip commit (`wip(179-organic-observation): paused at 179-01`) |

---

## What Was Done This Session

- Resumed from prior handoff; archived consumed handoff to `.paul/handoffs/archive/`.
- Executed APPLY Task 1: inspected the user's pre-authored quark patch set. Determined it had already completed organically as a single coherent quark phase (`112-01-security-correctness-runtime-wiring`, PR #95 merged 2026-04-18). No additional unapplied patches remain (confirmed via `git stash` review — only unrelated content stashes).
- At the Task-2 checkpoint, the user signaled they have significant real quark work still to do and asked for more data.
- Amended Phase 179 plan mid-APPLY to add a second labeled evidence class: `concurrent-natural` (roadmap-driven quark work performed after CODI enablement, honoring the Phase 178 naturality discipline rule). See `.paul/STATE.md` Decisions for the logged amendment.
- Wrote provisional `.paul/phases/179-organic-observation/179-01-SUMMARY.md` with quark `112-01` logged as the first pre-authored row (outcome: `no-dispatch-found` mechanically, **CODI materially shaped APPLY: yes** qualitatively — preserved as instrumentation mismatch).
- Updated `.paul/STATE.md` Current Position, Loop Position, and Session Continuity.

---

## What's In Progress

Phase 179 observation window is **open**, not closed. APPLY is paused on purpose. Quark-side roadmap work continues as normal quark PALS phases under CODI; each completed quark UNIFY appends one row to `quark/.paul/CODI-HISTORY.md`.

---

## What's Next

**Do real quark roadmap work.** For each quark phase:

1. Plan the work in quark as normal (`/paul:plan` inside quark).
2. **Naturality discipline (non-negotiable):** draft `<context>` / `files_modified` from engineering logic BEFORE CODI dispatch runs. Do NOT pick files because they are indexed TypeScript. Do NOT reshape scope to feed CODI nicer symbols.
3. Run APPLY and UNIFY normally. Let the installed CODI hooks fire organically — one row will append to `quark/.paul/CODI-HISTORY.md` per completed UNIFY.
4. If the quark phase's `### CODI Influence on APPLY` section has something real to say (yes/no/partial, plus concrete attribution), capture it in the quark SUMMARY as usual.

**No manual `CODI-HISTORY.md` edits. No retroactive CODI runs. No CODI-source edits in pals (frozen at SHA `0d667560b65944801faaee270ab920786afa471a` for the duration of v2.41).**

**When observation volume feels sufficient:**
- The user (not the model) decides when enough is enough. There is no fixed target row count.
- Good heuristic: Phase 177 set `S_pass_nonnull ≥ 3` as the mechanical SHIP threshold; the current pre-authored row is instrumentation-mismatched, so a small handful of additional concurrent-natural rows is the next natural stopping point. But the stop condition is qualitative judgment, not a quota.

**Resume on pals:**
```
/paul:resume
```

That will route to: reconcile new concurrent-natural rows into `.paul/phases/179-organic-observation/179-01-SUMMARY.md`, write per-phase APPLY-consumption notes, run UNIFY, advance `.paul/ROADMAP.md` and `.paul/STATE.md` to Phase 180.

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Authoritative pals lifecycle state |
| `.paul/phases/179-organic-observation/179-01-PLAN.md` | Amended plan (added `concurrent-natural` evidence class) |
| `.paul/phases/179-organic-observation/179-01-SUMMARY.md` | Provisional SUMMARY; rolling row set table, per-class tally |
| `/Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md` | Authoritative row ledger (1 row: `112-01` `no-dispatch-found`) |
| `/Users/maxwellnewman/claude/quark/.paul/phases/112-security-correctness-runtime-wiring/112-01-SUMMARY.md` | Source of quark `112-01` qualitative evidence |

---

## Integrity Invariants (Active)

- **CODI-source freeze:** pals `modules/codi/*` pinned at SHA `0d667560b65944801faaee270ab920786afa471a` for v2.41.
- **Shared registry parity:** pals and quark both dispatch from `~/.pi/agent/skills/pals/modules.yaml`.
- **Naturality discipline:** `<context>` / `files_modified` drafted from engineering logic first, before CODI dispatch runs.
- **No synthetic evidence:** no controlled self-trials, no retroactive CODI runs, no manual `CODI-HISTORY.md` edits, no re-runs-until-pretty.
- **Observation-only:** no pals-side feature work during Phase 179.
- **Row labeling:** every row in SUMMARY is labeled `pre-authored` or `concurrent-natural` so Phase 180's rubric can weight them.

---

## Resume Instructions

1. Run `/paul:resume` to restore context via STATE.md + this handoff.
2. If new quark rows exist in `/Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md`, resume will route toward reconciliation.
3. If no new rows yet, the observation window is still open; continue quark work.
4. Final APPLY pass on resume appends new rows to the SUMMARY row-set table, updates the per-class tally, writes per-phase APPLY-consumption notes, then hands off to `/paul:unify`.

---

## Mental Context

- The plan amendment was a real scope change, recorded as an explicit decision. It is not silent scope creep.
- Concurrent-natural ≠ controlled self-trial. The difference is the naturality discipline: scope chosen by engineering need, not by CODI visibility. Session C (177-01-self) violated that; concurrent-natural observation respects it.
- Phase 180 will perform the formal re-trial; Phase 179 just collects clean evidence. Keep the two separate.

---

*Handoff created: 2026-04-18*
