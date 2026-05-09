# PAUL Handoff

**Date:** 2026-05-08T21:36:01Z
**Status:** paused — Phase 268 plan created and refined; APPLY awaiting approval

---

## READ THIS FIRST

You have no prior context. This document tells you everything needed to resume.

**Project:** pals — PALS - Project Automation & Lifecycle System. PAUL + CARL + TODD + WALT and modular pals provide a markdown-first lifecycle framework with Pi as the supported runtime.
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers.

---

## Current State

**Milestone:** v2.63 Workflow Instruction Audit + Context-Efficiency Rewrite
**Phase:** 268 of 272 — Resume Workflow Instruction Audit + Context-Efficiency Rewrite
**Plan:** 268-01 created, awaiting approval
**Status:** PLAN complete; APPLY not started

**Loop Position:**
```text
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ○        ○     [Plan 268-01 created, awaiting approval]
```

## Git State

| Field | Value |
|-------|-------|
| Branch | main |
| Base | main |
| Sync | 0 behind / 0 ahead origin/main at pause check |
| PR | none active for current branch |
| CI | N/A |
| Working tree | dirty with milestone/plan lifecycle artifacts and this handoff |

---

## What Was Done

- Created milestone **v2.63 Workflow Instruction Audit + Context-Efficiency Rewrite**.
- Created phase structure for 268–272:
  - 268 resume workflow instruction audit
  - 269 plan workflow instruction audit
  - 270 apply workflow instruction audit
  - 271 unify workflow instruction audit
  - 272 pause workflow instruction audit
- Updated `.paul/ROADMAP.md`, `.paul/STATE.md`, `.paul/MILESTONES.md`, and `.paul/PROJECT.md` for v2.63.
- Created `.paul/phases/268-resume-workflow-instruction-audit/268-01-PLAN.md`.
- Refined the plan after user direction so APPLY must rewrite `resume-project.md` collaboratively section by section.
- Verified after plan creation/refinement:
  - `git diff --check`: PASS
  - `bash tests/pi-end-to-end-validation.sh`: PASS before the later section-loop refinement; not rerun afterward because only lifecycle plan/STATE text changed
  - `bash tests/cross-harness-validation.sh`: PASS before the later section-loop refinement; not rerun afterward because only lifecycle plan/STATE text changed

---

## What's In Progress

Phase 268 is planned but not approved for APPLY.

The key user requirement is now explicit in the plan: **do not bulk rewrite `kernel/workflows/resume-project.md`.** APPLY must work section by section with the user:

1. Show the section name and smallest useful current excerpt.
2. State the concrete problem in that section.
3. Propose replacement wording or a focused diff.
4. Wait for user approval or wording changes.
5. Edit only that approved section.
6. Re-read that section before moving on.

Planned section order:

1. Purpose / loop context / required reading.
2. PAUL existence and bounded STATE loading.
3. Optional handoff and resume-file context resolution.
4. Config, git state, and single-action routing.
5. Report format and verbosity.
6. Handoff lifecycle cleanup.
7. Error handling and output contract.

---

## What's Next

**Immediate:** Run:

```text
/paul:apply .paul/phases/268-resume-workflow-instruction-audit/268-01-PLAN.md
```

During APPLY, stop at the checkpoint and confirm the section-by-section collaboration protocol before editing `kernel/workflows/resume-project.md`.

**After that:** Start with Section 1 — purpose / loop context / required reading — and collaborate on wording before applying any edit.

---

## Key Decisions / Constraints

- The Phase 267 selective-loading change was considered a false-positive implementation: it added marker/policy wording but left contradictory old procedural instructions in place.
- v2.63 exists to audit and rewrite the actual major lifecycle instruction files one by one.
- Phase 268 is limited to `resume-project.md` and resume-specific semantic validation.
- Do not edit installed runtime copies directly (`~/.pi`, `~/.claude`, etc.). Edit repo source files.
- Do not touch `plan-phase.md`, `apply-phase.md`, `unify-phase.md`, or `pause-work.md` in Phase 268; those are later phases.
- Parent APPLY remains authoritative. Do not delegate the instruction-sensitive workflow rewrite by default.
- The user explicitly wants wording control while editing.

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Authoritative live project state and resume routing |
| `.paul/ROADMAP.md` | v2.63 milestone and Phase 268 scope |
| `.paul/phases/268-resume-workflow-instruction-audit/268-01-PLAN.md` | Approved/awaiting-approval Phase 268 executable plan |
| `kernel/workflows/resume-project.md` | Target workflow to rewrite during APPLY |
| `tests/pi-end-to-end-validation.sh` | Pi/install validation to receive resume semantic guardrails |
| `tests/cross-harness-validation.sh` | Shared validation to receive resume semantic guardrails |

---

## Current Working Tree at Pause

```text
 M .paul/MILESTONES.md
 M .paul/PROJECT.md
 M .paul/ROADMAP.md
 M .paul/STATE.md
?? .paul/phases/268-resume-workflow-instruction-audit/
?? .paul/HANDOFF-2026-05-08-phase-268-plan-ready.md
```

No WIP commit was created during pause.

---

## Resume Instructions

1. Read `.paul/STATE.md` bounded sections for current position and session continuity.
2. Read this handoff if `STATE.md` points here.
3. Read `.paul/phases/268-resume-workflow-instruction-audit/268-01-PLAN.md`, especially the checkpoint and Task 2.
4. Run `/paul:apply .paul/phases/268-resume-workflow-instruction-audit/268-01-PLAN.md` when ready.
5. Do not bulk edit `resume-project.md`; collaborate section by section.

---

*Handoff created: 2026-05-08T21:36:01Z*
