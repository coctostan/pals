# PAUL Handoff

**Date:** 2026-04-30T01:55:00Z
**Status:** paused at plan-created boundary; Phase 222 PLAN awaits review/approval

---

## READ THIS FIRST

You have no prior context. This document tells you everything needed to resume safely.

**Project:** pals — Project Automation & Lifecycle System. PAUL, CARL, TODD, and WALT provide an agentic lifecycle framework with portable markdown artifacts.
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers.

---

## Current State

**Version / Milestone:** v2.52 Legacy Retention / Install-Surface Cleanup
**Phase:** 222 of 225 — Legacy / Install-Surface Cleanup Contract Baseline
**Plan:** 222-01 created, awaiting approval

**Loop Position:**
```text
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ○        ○     [Plan created, awaiting approval]
```

## Git State

| Field | Value |
|-------|-------|
| Workflow | github-flow |
| Branch | `main` |
| Base | `main` |
| PR | none (N/A) |
| CI | N/A — no active PR |
| Behind base | 0 commits |
| Ahead base | 0 commits |
| Working tree | Dirty from v2.52 milestone setup, Phase 222 PLAN lifecycle artifacts, and this handoff |

---

## What Was Done

- Resumed after v2.51 closure; STATE.md was authoritative and confirmed Phase 221 / v2.51 complete.
- Created new milestone `v2.52 Legacy Retention / Install-Surface Cleanup` with four phases:
  - 222 — Legacy / Install-Surface Cleanup Contract Baseline
  - 223 — Safe Cleanup Implementation
  - 224 — Documentation + Validation Surfacing
  - 225 — Evidence Reconciliation + Milestone Closure
- Updated `.paul/PROJECT.md`, `.paul/ROADMAP.md`, and `.paul/STATE.md` for v2.52 milestone creation.
- Created phase directories for 222-225.
- Created PLAN `.paul/phases/222-legacy-install-surface-cleanup-contract-baseline/222-01-PLAN.md`.
- Updated `.paul/STATE.md` and `.paul/ROADMAP.md` to show Phase 222 PLAN ✓ / APPLY ○ / UNIFY ○.
- Workguard scope checks passed for milestone creation and Phase 222 plan creation:
  - `runs/workguards/20260430T014823Z-v2.52-create-milestone/workguard-report.json`: changed=3, outside_allowed=0, over_budget=false
  - `runs/workguards/20260430T015052Z-phase-222-plan/workguard-report.json`: changed=4, outside_allowed=0, over_budget=false

---

## What's In Progress

- APPLY has not started.
- PLAN 222-01 awaits user review/approval.
- Planned source output is exactly `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`.
- Phase 222 is baseline-only: it must create the cleanup contract before any frozen legacy or install-surface removal/relocation/archive/source-only conversion.
- Active uncommitted files are expected PLAN/session artifacts:
  - `.paul/PROJECT.md`
  - `.paul/ROADMAP.md`
  - `.paul/STATE.md`
  - `.paul/phases/222-legacy-install-surface-cleanup-contract-baseline/222-01-PLAN.md`
  - `.paul/HANDOFF-2026-04-30-phase-222-plan-awaiting-approval.md`

---

## Decisions / Boundaries To Preserve

- v2.52 focus: clean up frozen legacy/installation surfaces only where validation classification proves it is safe, while preserving shared invariants, command-output truth, and Pi-supported runtime behavior.
- Phase 222 is contract baseline only.
- Do not change runtime behavior, installers, validation scripts, dependency manifests, CI config, GitHub Flow automation, helper delegation, lifecycle authority, or actual legacy surfaces in Phase 222.
- Do not weaken/reclassify validation checks in Phase 222.
- Expected validation counts remain Pi `203/203` and cross-harness `119/119`; any count change must stop and be reconciled.
- Validation classification from v2.51 remains the safety gate for any future cleanup.
- Delegated APPLY may use repo-local `pals-implementer` only for eligible bounded tasks; parent APPLY remains authoritative for verification, module enforcement, fallback, checkpoints, GitHub Flow gates, and `.paul/*` lifecycle writes.

---

## What's Next

**Immediate:** Review and approve the plan, then run:

```text
/paul:apply .paul/phases/222-legacy-install-surface-cleanup-contract-baseline/222-01-PLAN.md
```

**Phase 222 APPLY should:**
- Create `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`.
- Include source inputs, cleanup target inventory, retention/removal decision matrix, preservation rules, non-goals, marker-check families, count-change reconciliation fields, failure conditions, and Phase 223 handoff.
- Run focused marker grep, `PALS_ROOT="$PWD" bash drivers/pi/install.sh`, `bash tests/pi-end-to-end-validation.sh`, and `bash tests/cross-harness-validation.sh`.
- Keep changed-file scope to the planned docs contract plus lifecycle artifacts.

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Authoritative lifecycle state and resume routing |
| `.paul/ROADMAP.md` | v2.52 milestone and phase routing |
| `.paul/PROJECT.md` | Hot project context and current focus |
| `.paul/phases/222-legacy-install-surface-cleanup-contract-baseline/222-01-PLAN.md` | Executable plan awaiting user approval |
| `.paul/phases/221-evidence-reconciliation-milestone-closure/221-01-SUMMARY.md` | v2.51 closure evidence and cleanup deferral |
| `docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md` | v2.51 classification safety gate for cleanup |
| `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md` | Planned Phase 222 output; does not exist yet |
| `tests/pi-end-to-end-validation.sh` | Existing Pi validation suite; expected 203/203 after APPLY |
| `tests/cross-harness-validation.sh` | Existing cross-harness validation suite; expected 119/119 after APPLY |

---

## Resume Instructions

1. Run `/paul:resume`.
2. Confirm STATE.md still shows Phase 222 PLAN ✓ / APPLY ○ / UNIFY ○.
3. Review `.paul/phases/222-legacy-install-surface-cleanup-contract-baseline/222-01-PLAN.md` if needed.
4. If approved, run `/paul:apply .paul/phases/222-legacy-install-surface-cleanup-contract-baseline/222-01-PLAN.md`.
5. Archive this active handoff after work proceeds.

---

*Handoff created: 2026-04-30T01:55:00Z*
