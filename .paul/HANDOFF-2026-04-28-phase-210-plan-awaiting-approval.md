# PAUL Handoff

**Date:** 2026-04-28T16:34:21Z
**Status:** paused

---

## READ THIS FIRST

You have no prior context. This document tells you everything needed to resume.

**Project:** pals
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

---

## Current State

**Milestone:** v2.49 Workflow/Resource Capsule Contract
**Phase:** 210 of 213 — Workflow/Resource Capsule Contract Baseline
**Plan:** 210-01 created, awaiting approval
**Status:** PLAN created, ready for APPLY after user approval

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
| Working tree | Dirty with PAUL planning/session artifacts only; no source implementation has begun |

Current changed/untracked items at pause:
- Modified: `.paul/STATE.md`
- Modified: `.paul/ROADMAP.md`
- Deleted from active root / archived: `.paul/HANDOFF-2026-04-28-v2.49-ready-to-plan.md`
- Untracked archive copy: `.paul/handoffs/archive/HANDOFF-2026-04-28-v2.49-ready-to-plan.md`
- Untracked Phase 210 plan directory: `.paul/phases/210-workflow-resource-capsule-contract-baseline/`
- New active handoff: `.paul/HANDOFF-2026-04-28-phase-210-plan-awaiting-approval.md`

---

## What Was Done

- Resumed the project from `.paul/HANDOFF-2026-04-28-v2.49-ready-to-plan.md`.
- Confirmed v2.49 Workflow/Resource Capsule Contract is active and Phase 210 is the next phase.
- Created `.paul/phases/210-workflow-resource-capsule-contract-baseline/210-01-PLAN.md`.
- Updated `.paul/STATE.md` to show `PLAN ✓ / APPLY ○ / UNIFY ○` and route next action to plan review/approval.
- Updated `.paul/ROADMAP.md` to mark Phase 210 as Planning with plan `210-01` created.
- Archived the consumed resume handoff under `.paul/handoffs/archive/`.
- Workguard snapshot/report for planning scope was created earlier in this session; report showed 5 changed files, all within `.paul/**`, within budget.

---

## What's In Progress

- No APPLY work has started.
- The Phase 210 PLAN is awaiting user review/approval.
- The PLAN is documentation-contract scoped: it will create `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md` only outside normal `.paul/*` lifecycle artifacts.
- The PLAN is autonomous once approved: no checkpoints are required.

---

## What's Next

**Immediate:** Run `/paul:resume`, then review `.paul/phases/210-workflow-resource-capsule-contract-baseline/210-01-PLAN.md` and approve it.

**Canonical next command after approval:** `/paul:apply .paul/phases/210-workflow-resource-capsule-contract-baseline/210-01-PLAN.md`

**After that:** Execute the normal APPLY → UNIFY loop for Phase 210. APPLY should create `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md`, run focused marker greps plus Pi/cross-harness validation, and preserve command-output truth for UNIFY.

---

## Plan 210-01 Summary

Plan goal: create the v2.49 workflow/resource capsule contract baseline defining:
- capsule eligibility rules
- ineligible resource/content categories
- stable output schema (`Capsule`, `Source`, `Source type`, `Freshness`, `Bounds`, `Content`, `Fallback`, `Authority`)
- installed/logical resource citations
- STOP / DO NOT SKIP / checkpoint / lifecycle / merge-gate blocking-semantics exclusions
- full authoritative read fallback triggers
- validation classes and failure conditions
- Phase 211 runtime hardening, Phase 212 docs/validation, and Phase 213 evidence closure handoffs

Plan tasks:
1. Create capsule eligibility, citation, and schema contract.
2. Define blocking-semantics exclusions, fallback rules, and phase handoffs.
3. Run final contract evidence and scope checks.

Critical boundaries:
- Do not change `drivers/pi/extensions/pals-hooks.ts` in Phase 210.
- Do not change `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, `tests/pi-end-to-end-validation.sh`, or `tests/cross-harness-validation.sh` in Phase 210 unless a later approved plan scopes docs/validation surfacing.
- Do not implement runtime capsule loading, docs/skill-map surfacing, validation marker additions, helper packet/report compression, validation classification, legacy cleanup, telemetry, hidden state, helper-owned APPLY behavior, or merge-gate automation.
- Capsules must orient only; full workflow/resource reads remain authoritative for blocking semantics, ambiguity, lifecycle writes, and command-output evidence.

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Live lifecycle truth and resume routing |
| `.paul/ROADMAP.md` | v2.49 phase overview and Phase 210 planning status |
| `.paul/phases/210-workflow-resource-capsule-contract-baseline/210-01-PLAN.md` | Current executable plan awaiting approval |
| `.paul/handoffs/archive/HANDOFF-2026-04-28-v2.49-ready-to-plan.md` | Consumed prior handoff |
| `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md` | Planned output; does not exist yet unless APPLY has started |
| `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` | Source for v2.49 sequencing and scope |
| `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md` | Prior citation/fallback contract input |
| `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` | Prior guided-workflow safety contract input |

---

## Decisions / Constraints to Preserve

- Workflow/resource capsules are orientation aids only; full workflow/resource reads remain authoritative for blocking semantics.
- Capsules must not replace `.paul/*`, PLAN/APPLY/UNIFY, module reports, GitHub Flow command evidence, validation command output, or parent-owned APPLY.
- Do not merge workflow/resource capsules with blocking workflow semantic rewrites.
- Do not reopen guided workflow runtime hardening, helper packet/report compression, broad validation classification, legacy cleanup, or lifecycle authority without a new approved plan.
- Delegated APPLY may use repo-local `pals-implementer` only for eligible bounded tasks; parent APPLY remains authoritative for verification, module enforcement, fallback, and `.paul/*` lifecycle writes.

---

## Resume Instructions

1. Read `.paul/STATE.md` for the latest position.
2. Read this handoff if STATE still points here.
3. Check git status. Expect only PAUL planning/session artifacts unless someone has proceeded.
4. Review `.paul/phases/210-workflow-resource-capsule-contract-baseline/210-01-PLAN.md`.
5. Ask for or confirm approval.
6. After approval, run `/paul:apply .paul/phases/210-workflow-resource-capsule-contract-baseline/210-01-PLAN.md`.

---

*Handoff created: 2026-04-28T16:34:21Z*
