# PAUL Handoff

**Date:** 2026-04-18
**Status:** paused — Phase 178 plan drafted, awaiting APPLY approval

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** pals — Project Automation & Lifecycle System ("The Linux of Harness Engineering")
**Core value:** LLM systems gain OS primitives — minimal kernel, modular pals, universal drivers

**Why we paused:** Phase 178 PLAN is complete and written to disk; STATE/PROJECT/ROADMAP all reflect v2.41 in progress. The next step is `/paul:apply` of the drafted plan, which executes against a second repo (quark). User stepped away before authorizing that APPLY.

---

## Current State

**Milestone:** v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation — 🚧 In Progress
**Prior milestone:** v2.40 ✅ Complete (verdict ITERATE_V0_1, all 4 phases merged to main)
**Phase:** 178 of ~3 in v2.41 — CODI Cross-Repo Install (quark)
**Plan:** `178-01` drafted, awaiting APPLY approval

**Loop Position:**
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ○        ○     [Phase 178 PLAN drafted — awaiting APPLY approval]
```

## Git State

| Field | Value |
|-------|-------|
| Branch | main |
| Base | main |
| PR | none (N/A) |
| CI | N/A |
| Behind base | Up to date |
| Uncommitted work | `.paul/PROJECT.md`, `.paul/ROADMAP.md`, `.paul/STATE.md` modified + `.paul/phases/178-codi-cross-repo-install/` and `.paul/proposals/` untracked |

---

## What Was Done This Session

1. **Completed `/paul:apply` + `/paul:unify` for Phase 177** — v2.40's re-trial gating decision. Wrote TRIAL-DATA, DECISION (verdict `ITERATE_V0_1`), SUMMARY; applied lifecycle patches; merged PR #87 as `dbf2d7a` on main; closed v2.40 milestone.
2. **Post-v2.40 analysis session** — explicit review of the open Q2 question from Phase 177's verdict. Concluded pals is a structurally bad CODI trial environment (1 TS file, 1,331 lines). Surveyed 20+ candidate projects for cross-repo trial.
3. **Selected quark as v2.41 trial bed** — 36k TS lines, `.codegraph/graph.db` already indexed (Mar 28, 1.7MB), 111 PALS phases of history, shared installed registry with pals at `~/.pi/agent/skills/pals/modules.yaml`.
4. **Drafted v2.41 proposal** at `.paul/proposals/v2.41-cross-repo-trial-quark.md` — 3-phase shape (178 install → 179 observe → 180 re-trial), unchanged Phase 173/177 rubric, explicit honesty constraints.
5. **User approved proposal** and clarified that their **in-flight quark patches should serve as Phase 179 trial fuel** (not be applied before Phase 178). This is actually a BETTER trial design — patches authored before CODI was enabled in quark = causally independent scope = zero selection bias.
6. **Drafted Phase 178 PLAN** at `.paul/phases/178-codi-cross-repo-install/178-01-PLAN.md` — 4 tasks, minimal touch, ~30 min APPLY expected.
7. **Updated STATE.md, PROJECT.md, ROADMAP.md, and the proposal itself** to reflect the patch-driven Phase 179 framing. Time-based observation window dropped; row count now scales with patches' natural engineering decomposition.

---

## What's In Progress

- **Phase 178 APPLY not yet started.** The plan is drafted and ready. No uncommitted code, no branch created, no CODI-enabled dispatch in quark yet.
- **User's in-flight quark patches exist but are not yet applied.** They're held back deliberately — they'll be applied AFTER Phase 178 completes, as the Phase 179 trial fuel.

---

## What's Next

**Immediate:** Run `/paul:apply .paul/phases/178-codi-cross-repo-install/178-01-PLAN.md`.

This executes 4 tasks:
1. Add `modules.codi` entry to `/Users/maxwellnewman/claude/quark/pals.json` (quark's pals.json has 20 modules, codi is absent — we add it alphabetically between `carl` and `dana`).
2. Refresh `/Users/maxwellnewman/claude/quark/.codegraph/graph.db` (stale since 2026-03-28, before quark's v2.14 and v2.15 work). Three-tier fallback: pi incremental → direct `impact()` call → rebuild from scratch. Task 2 must verify `impact()` resolves at least one current quark kernel symbol (candidates: `deriveTools`, `intersectArrays`, `intersectManifests`, `validateManifestPresence`).
3. Create `/Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md` with canonical 7-line header from Phase 176 contract, zero data rows.
4. Verify quark test suite stays green (baseline: 950 tests from 2026-04-01); verify pals validation suites stay green (172/172 pi-e2e + 75/75 cross-harness); apply pals lifecycle patches closing Phase 178 (PROJECT/ROADMAP/STATE updates).

**After that:** User applies their quark patches as one or more natural quark PALS phases. Each phase's PLAN runs CODI pre-plan hook organically; each UNIFY appends a row to `quark/.paul/CODI-HISTORY.md`. When all patch work has landed, advance to Phase 180 re-trial.

**Critical honesty discipline (enforced during patch application):** when planning each quark phase that applies a portion of the patches, draft `<context>` source files and `files_modified` list from engineering logic FIRST — do not tune scope to feed CODI nicer symbols. Patches predate CODI in quark, so causal independence is by construction; the discipline prevents unconscious tuning.

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Live project state — authoritative for current position |
| `.paul/PROJECT.md` | Requirements + key decisions |
| `.paul/ROADMAP.md` | Milestone overview; v2.41 is Current Milestone |
| `.paul/proposals/v2.41-cross-repo-trial-quark.md` | v2.41 milestone proposal (approved) |
| `.paul/phases/178-codi-cross-repo-install/178-01-PLAN.md` | The plan awaiting APPLY approval |
| `.paul/phases/177-re-trial-gating-decision/177-01-DECISION.md` | The verdict that set v2.41's direction |
| `.paul/CODI-HISTORY.md` | pals-side CODI dispatch tally (3 rows: 175/176/177) |
| `.paul/QUALITY-HISTORY.md` | Test baseline — entering v2.41 at 172 pass + 75 pass stable |
| `/Users/maxwellnewman/claude/quark/pals.json` | Phase 178 Task 1 target (add modules.codi) |
| `/Users/maxwellnewman/claude/quark/.codegraph/graph.db` | Phase 178 Task 2 target (refresh) |
| `/Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md` | Phase 178 Task 3 target (create with header) |

---

## Key Decisions Made This Session

1. **Pals is a bad CODI trial environment; quark is a good one.** Phase 177's Q2=uncertain verdict is structurally dependent on pals's shape (markdown-dominated, 1 TS file). Cross-repo trial is the honest way to resolve Q2.
2. **quark is the best choice** among 20+ candidates (already PALS-installed with 111 phases of history, already has `.codegraph/graph.db`, 36k TS lines, natural fan-out in `src/kernel/`).
3. **User's in-flight quark patches = Phase 179 trial fuel** (authored before CODI was enabled in quark, zero selection bias). Better than observing arbitrary future natural work.
4. **Pals CODI source frozen** at SHA `0d667560b65944801faaee270ab920786afa471a` for v2.41 duration. Trial-integrity parity is by construction (shared installed registry).
5. **Time-based observation window dropped.** Row count scales with patches' natural engineering decomposition, not trial convenience.
6. **Naturality discipline rule added** to prevent unconscious scope tuning when planning quark phases.
7. **Phase 178 does NOT require a pals installer re-run** — quark's install path (`drivers/pi/install.sh`) and pals's share the same target (`~/.pi/agent/skills/pals/`), and CODI is already installed there. Phase 178 only edits `quark/pals.json` + refreshes quark's codegraph.

---

## Blockers / Concerns

- **None blocking.** The only remaining gate is explicit user approval of Phase 178 APPLY.
- **Minor concern:** Phase 177 review raised ~25% probability of KILL verdict on v2.41 completion. Phase 178/179 design is neutral — it will honestly answer the question either way.
- **Quark patches are unshown to me.** I don't know their scope, size, or decomposition. Phase 179's row count will be discovered as they land.

---

## Validation Baseline Entering v2.41

- `bash tests/pi-end-to-end-validation.sh`: **172/172** (all pass)
- `bash tests/cross-harness-validation.sh`: **75/75** (all pass)
- `.paul/QUALITY-HISTORY.md` trend: **→ stable** (research/decision phases don't move it)
- pals `main` branch: clean, synced with `origin/main`, last commit `9038ed2` (Phase 177 post-transition state updates)

---

## Resume Instructions

1. Read `.paul/STATE.md` for latest position (should still show Phase 178 plan drafted awaiting APPLY).
2. Optionally re-read `.paul/phases/178-codi-cross-repo-install/178-01-PLAN.md` to refresh on what will execute.
3. Run `/paul:resume` — it will re-present this handoff and suggest `/paul:apply`.
4. To proceed directly: `/paul:apply .paul/phases/178-codi-cross-repo-install/178-01-PLAN.md`.

---

## Mental Context (in case the reader is me, later, confused)

- We did **not** commit the pending changes (`PROJECT.md`, `ROADMAP.md`, `STATE.md`, untracked `phases/178-*` and `proposals/`). They'll ride along with Phase 178's feature branch when APPLY creates it. Don't commit them separately on main — that would pollute main with v2.41 lifecycle writes before the milestone actually ships anything.
- The patches-as-trial-fuel framing is not in the Phase 178 PLAN itself (which correctly deals only with installation). It IS in the v2.41 proposal and STATE.md's Accumulated Context. Phase 179 will have its own PLAN when the patches start landing.
- Phase 180 is the same shape as Phase 177 (TRIAL-DATA + DECISION + lifecycle patches). The rubric and 3-question checklist are unchanged from Phase 173. Do not modify them in v2.41 — that's explicitly out of scope.
- My Phase 177 review stance (lean KILL, SHIP is the upside case) is unchanged. v2.41 is the honest test of that stance. If Phase 180 comes back SHIP, the review was wrong. If it comes back KILL, we close the thesis cleanly.

---

*Handoff created: 2026-04-18*
