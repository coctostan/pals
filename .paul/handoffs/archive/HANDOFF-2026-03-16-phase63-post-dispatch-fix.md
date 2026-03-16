# PAUL Handoff

**Date:** 2026-03-16T19:15:08Z
**Status:** paused

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** pals
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

---

## Current State

**Version:** v2.5 Pi Runtime Coherence & Guided Flow active
**Phase:** 63 of 64 — Guided Workflow UX
**Plan:** 63-01 — created, awaiting approval

**Loop Position:**
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ○        ○
```

---

## What Was Done

- Resumed from the earlier Phase 63 handoff and confirmed the project was paused before approval/APPLY
- Ran a standard PAUL fix side-loop to repair module dispatch semantics for PLAN/APPLY/UNIFY
- Updated both installers (`drivers/pi/install.sh`, `drivers/claude-code/install.sh`) so installed `modules.yaml` registries now include per-hook `hook_details` with `priority`, `description`, and `refs`
- Added `kernel/references/module-dispatch.md` and aligned shared workflow wording in `plan-phase.md`, `apply-phase.md`, `unify-phase.md`, and `fix-loop.md` so dispatch resolves from the installed registry rather than conceptual source manifest access
- Updated `docs/MODULE-SPEC.md` and `docs/HOOK-CONTRACT.md` to match the new runtime registry shape
- Added validation coverage proving the richer registry exists in Pi and Claude Code installs
- Verified Pi validation passes `94/94`
- Verified cross-harness validation passes `48/48`
- Confirmed this is compatibility-preserving for Claude Code because its installer was updated in parallel and still preserves flat `hooks` plus `platform_hooks`

---

## What's In Progress

- Phase 63 implementation has **not** started; APPLY has still not begun
- The module-dispatch framework fix is complete, but the main loop is still paused at plan approval
- The existing Phase 63 plan likely still stands, but it should be quickly reassessed now that dispatch semantics are corrected

---

## Key Decisions

- Treat `kernel/modules.yaml` as a **logical path** to the installed runtime registry, not a source-controlled repo file
- Put the hook metadata needed for dispatch directly into installed `modules.yaml` so workflows can resolve real runtime behavior from installed artifacts
- Preserve backward compatibility by keeping the flat `hooks` list and Claude Code `platform_hooks`
- If a user has a stale older install without `hook_details`, the right recovery is to reinstall/regenerate `modules.yaml`
- Keep `.paul/*` and shared markdown workflows authoritative; this fix improves real dispatch fidelity without introducing Pi-only or Claude-only lifecycle truth

---

## What's Next

**Immediate:** Reassess `.paul/phases/63-guided-workflow-ux/63-01-PLAN.md` now that module dispatch is fixed, then approve and run `/skill:paul-apply .paul/phases/63-guided-workflow-ux/63-01-PLAN.md`

**After that:** Complete APPLY for Phase 63, then reconcile with `/skill:paul-unify .paul/phases/63-guided-workflow-ux/63-01-PLAN.md`

---

## Git State

- **Branch:** `feature/63-guided-workflow-ux`
- **Modified files:** `.paul/STATE.md`, both installer scripts, 4 shared workflow files, 2 docs files, and 2 validation scripts
- **New files:** `kernel/references/module-dispatch.md`, `.paul/phases/63-guided-workflow-ux/63-02-FIX.md`, `.paul/phases/63-guided-workflow-ux/63-02-FIX-SUMMARY.md`, this handoff
- **Archive move note:** `.paul/HANDOFF-2026-03-16-phase63-module-dispatch-fix-next.md` was moved into `.paul/handoffs/archive/`; git currently shows that as a delete + untracked archive path until staged
- **Noise present:** unrelated untracked local/archive files and `.pi/` artifacts already exist in the worktree

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Live project state; now points resume to this handoff |
| `.paul/phases/63-guided-workflow-ux/63-01-PLAN.md` | Main Phase 63 plan still awaiting approval |
| `.paul/phases/63-guided-workflow-ux/63-02-FIX-SUMMARY.md` | Summary of the completed module-dispatch fix side-loop |
| `kernel/references/module-dispatch.md` | New portable dispatch reference for installed registry semantics |
| `drivers/pi/install.sh` | Pi installer now emits `hook_details` in installed `modules.yaml` |
| `drivers/claude-code/install.sh` | Claude Code installer now emits the same richer registry shape |
| `tests/pi-end-to-end-validation.sh` | Pi validation now checks runtime hook metadata and refs |
| `tests/cross-harness-validation.sh` | Cross-harness validation now checks hook metadata/refs parity |

---

## Resume Instructions

1. Read `.paul/STATE.md` for latest position
2. Read this handoff fully
3. Confirm the loop is still `PLAN ✓ / APPLY ○ / UNIFY ○` for Phase 63
4. Read `.paul/phases/63-guided-workflow-ux/63-01-PLAN.md`
5. If the plan still looks right after the dispatch fix, approve and run `/skill:paul-apply .paul/phases/63-guided-workflow-ux/63-01-PLAN.md`

---

*Handoff created: 2026-03-16T19:15:08Z*
