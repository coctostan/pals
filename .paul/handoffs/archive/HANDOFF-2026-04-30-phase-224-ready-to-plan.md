# PAUL Handoff

**Date:** 2026-04-30T03:12:00Z
**Status:** paused at clean phase boundary; Phase 224 ready to plan

---

## READ THIS FIRST

You have no prior context. This document tells you everything needed to resume safely.

**Project:** pals — Project Automation & Lifecycle System. PAUL, CARL, TODD, and WALT provide an agentic lifecycle framework with portable markdown artifacts.
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers.

---

## Current State

**Version / Milestone:** v2.52 Legacy Retention / Install-Surface Cleanup
**Phase:** 224 of 225 — Documentation + Validation Surfacing
**Plan:** not started

**Loop Position:**
```text
PLAN ──▶ APPLY ──▶ UNIFY
  ○        ○        ○     [Ready to plan Phase 224]
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
| Working tree | Dirty only from this pause handoff + STATE.md session-continuity update |

---

## What Was Done

- Completed Phase 223 Safe Cleanup Implementation.
- Implemented Pi-first root install/uninstall behavior:
  - default no-`PALS_DRIVER` install targets Pi only when `~/.pi` exists;
  - default no-`PALS_DRIVER` uninstall prefers Pi cleanup when `~/.pi` exists;
  - frozen legacy/source-only driver actions require explicit `PALS_DRIVER=claude-code`, `PALS_DRIVER=agent-sdk`, or `PALS_DRIVER=all`.
- Updated README install/uninstall guidance for Pi-first default behavior, frozen legacy/source-only opt-ins, all-driver maintenance mode, and command-output truth.
- Created and unified `.paul/phases/223-safe-cleanup-implementation/223-01-SUMMARY.md`.
- Persisted post-unify history in `.paul/QUALITY-HISTORY.md` and `.paul/CODI-HISTORY.md`.
- Merged PR #138: https://github.com/coctostan/pals/pull/138.
- Transitioned lifecycle state to Phase 224 and pushed transition metadata commit `e596346c` to `main`.

---

## Validation Evidence To Preserve

Phase 223 final evidence:

- `bash -n install.sh uninstall.sh` passed.
- Focused temporary-HOME installer smoke checks passed:
  - default Pi routing when `~/.pi` exists;
  - no implicit Claude Code install when both `~/.pi` and `~/.claude` exist.
- Focused temporary-HOME uninstaller smoke checks passed:
  - default Pi cleanup when `~/.pi` exists;
  - no implicit Claude Code cleanup;
  - shared `~/.pals` removal preserved.
- README marker greps passed for Pi default, explicit `PALS_DRIVER`, frozen legacy/source-only wording, and command-output truth.
- `PALS_ROOT="$PWD" bash drivers/pi/install.sh` passed.
- `bash tests/pi-end-to-end-validation.sh` passed 203/203.
- `bash tests/cross-harness-validation.sh` passed 119/119.
- Workguard report was clean: `runs/workguards/20260430T023759Z-phase-223-apply/workguard-report.json`, `outside_allowed=0`, `over_budget=false`.

---

## What's In Progress

- No implementation is in progress.
- Phase 224 has not been planned yet.
- Current dirty files are expected pause artifacts only:
  - `.paul/HANDOFF-2026-04-30-phase-224-ready-to-plan.md`
  - `.paul/STATE.md`

---

## Decisions / Boundaries To Preserve

- Pi is the supported runtime; Claude Code and Agent SDK remain unsupported/frozen historical/source-only compatibility surfaces.
- Root install/uninstall surfaces are now Pi-first by default, with frozen legacy/source-only driver actions requiring explicit `PALS_DRIVER=...` opt-in.
- Command-output truth remains authoritative. Docs, reports, summaries, widgets, helper reports, and Pi surfaces can explain validation posture but cannot prove pass/fail status.
- `.paul/*` remains lifecycle truth; no hidden Pi state, telemetry, UI-only lifecycle state, or helper output replaces PLAN/APPLY/UNIFY artifacts.
- Delegated APPLY may use repo-local `pals-implementer` only for eligible bounded tasks; parent APPLY owns task packets, report acceptance, actual changed-file diff checks, official verification, module gates, fallback, checkpoints, GitHub Flow gates, and `.paul/*` writes.
- Phase 224 should surface documentation/validation posture for the Phase 223 cleanup. It should not change runtime behavior, installers, validation scripts, dependency manifests, CI, GitHub Flow automation, helper delegation semantics, or lifecycle authority unless a new approved plan explicitly scopes that work.

---

## What's Next

**Immediate:** Run:

```text
/paul:plan
```

Plan Phase 224 — Documentation + Validation Surfacing.

**Phase 224 should likely:**
- use Phase 222 cleanup contract and Phase 223 summary as source inputs;
- update user-facing docs and validation/report surfaces to describe the cleaned Pi-first install posture;
- preserve command-output truth and avoid treating stale docs/reports as validation proof;
- keep expected validation baselines at Pi 203/203 and cross-harness 119/119 unless an approved count-change reconciliation is planned.

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Authoritative lifecycle state and resume routing |
| `.paul/ROADMAP.md` | Current milestone and Phase 224 routing |
| `.paul/PROJECT.md` | Current project focus, support posture, and decisions |
| `.paul/phases/223-safe-cleanup-implementation/223-01-SUMMARY.md` | Phase 223 completion evidence and Phase 224 handoff |
| `.paul/phases/223-safe-cleanup-implementation/223-01-PLAN.md` | Approved Phase 223 plan |
| `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md` | Phase 222 cleanup decision framework |
| `README.md` | Updated public install/uninstall posture |
| `install.sh` | Pi-first root installer |
| `uninstall.sh` | Pi-first root uninstaller |
| `tests/pi-end-to-end-validation.sh` | Pi validation suite; expected 203/203 |
| `tests/cross-harness-validation.sh` | Cross-harness suite; expected 119/119 |

---

## Resume Instructions

1. Run `/paul:resume`.
2. Confirm `.paul/STATE.md` still shows Phase 224 ready to plan.
3. Confirm git is on `main` and clean or only contains this handoff/STATE pause update.
4. Start Phase 224 planning with `/paul:plan`.
5. Archive this active handoff after work proceeds.

---

*Handoff created: 2026-04-30T03:12:00Z*
