---
phase: 66-collaborative-planning-model
plan: 01
completed: 2026-03-17T16:56:58Z
duration: ~40m
---

# Phase 66 Plan 01 Summary

## Objective
Implement the collaborative planning model established by Phase 65 so PALS planning workflows can support low / medium / high collaboration depth, a project default plus per-run override, exploratory vs direct-requirements mode selection, and a 4-option review flow before execution routing.

## What Was Built

| File | Purpose | Lines |
|------|---------|-------|
| `kernel/workflows/init-project.md` | Added onboarding planning posture, project-level collaboration default handling, and run-level mode/collaboration capture | `+38/-0` |
| `kernel/workflows/discuss-milestone.md` | Added collaboration-aware milestone discussion depth, exploratory/direct-requirements handling, and review-menu handoff flow | `+58/-0` |
| `kernel/workflows/discuss-phase.md` | Added collaboration-aware phase discussion depth, exploratory/direct-requirements handling, and review-menu handoff flow | `+56/-1` |
| `kernel/workflows/create-milestone.md` | Added collaboration metadata carry-forward, override logic, and milestone review routing before roadmap writes | `+39/-0` |
| `kernel/workflows/plan-phase.md` | Added collaboration posture resolution, context handoff reuse, and the 4-option plan review step before APPLY routing | `+52/-2` |
| `kernel/templates/CONTEXT.md`, `kernel/templates/milestone-context.md` | Extended handoff templates to preserve planning mode, collaboration level, and review-path metadata | `+24/-9` |
| `kernel/commands/paul/{init,discuss,discuss-milestone,milestone,plan}.md` | Synced shared command guidance with the new collaboration/default/override/review semantics | `+59/-19` |
| `drivers/pi/skills/paul-{init,discuss,milestone,plan}/SKILL.md` | Synced Pi skill instructions with collaboration defaults, planning mode, and review-menu behavior | `+31/-32` |
| `drivers/pi/extensions/pals-hooks.ts` | Extended guided workflow detection to surface the shared 4-option planning review menu without introducing Pi-owned lifecycle state | `+36/-1` |
| `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md` | Updated Pi discovery/docs to explain the collaboration model and review flow as shared-workflow behavior | `+24/-2` |
| `tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh` | Added validation coverage for collaboration defaults, mode selection, and the 4-option review menu across Pi + shared kernel surfaces | `+52/-0` |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|-----------|--------|----------|
| AC-1: Collaboration settings are introduced with safe defaults | Pass | Shared planning workflows now document `planning.default_collaboration`, low / medium / high behavior, and per-run override semantics with medium fallback. |
| AC-2: Shared planning workflows become collaboration-aware and reviewable | Pass | `init-project`, `discuss-milestone`, `discuss-phase`, `create-milestone`, and `plan-phase` now distinguish exploratory vs direct-requirements runs and expose the 4-option review menu before handoff/routing. |
| AC-3: Pi guidance and validation remain aligned with shared workflow truth | Pass | Pi skills/docs describe the shared behavior consistently, `pals-hooks.ts` surfaces the review menu additively, and both validation suites pass. |

## Verification Results

| Check | Result | Evidence |
|------|--------|----------|
| Collaboration defaults / levels / mode markers present | Pass | `grep -R "default_collaboration\|low / medium / high\|exploratory\|direct-requirements" kernel/workflows kernel/commands/paul | head -40` |
| Review-menu markers present across shared + Pi surfaces | Pass | `grep -R "Quick recap\|Detailed recap\|Full plan\|No review needed\|Would you like to see the plan" kernel drivers/pi | head -80` |
| Pi validation suite | Pass | `bash tests/pi-end-to-end-validation.sh` → 109/109 passing |
| Cross-harness validation suite | Pass | `bash tests/cross-harness-validation.sh` → 50/50 passing |

## Deviations

### Summary
No material deviation from the approved plan.

### Notes
- Existing unrelated tracked/untracked working tree changes remained outside Phase 66 scope and were intentionally left untouched.
- The repo root still does not contain `kernel/modules.yaml`, so validation for this phase relied on the shared markdown changes plus validation suites rather than repo-local module-dispatch evidence.

## Key Patterns / Decisions

| Decision | Impact |
|----------|--------|
| Keep planning collaboration shared-workflow driven via `pals.json` `planning.default_collaboration` plus per-run override | Preserves artifact-first portability while making init/discuss/milestone/plan behavior more collaborative |
| Extend Pi guided workflow UX to surface the 4-option review menu additively | Keeps Pi helpful without creating Pi-only lifecycle truth |
| Preserve exploratory vs direct-requirements as explicit planning-mode language | Makes the collaboration model legible across onboarding, milestone shaping, and phase planning |

## Skill Audit
- `/paul` lifecycle flow was used normally through PLAN → APPLY → UNIFY.
- TODD and WALT remain configured as module overlays per `.paul/SPECIAL-FLOWS.md`; this documentation-heavy phase did not produce separate repo-local dispatch artifacts because no repo-local `kernel/modules.yaml` is present.

## Next Phase
**Phase 67 — Onboarding & PRD Depth**
- Strengthen onboarding into a fuller PRD / requirements artifact
- Preserve explicit requirements / constraints / deferred items / open questions more durably
- Extend docs and validation around the richer planning artifacts without breaking cross-harness portability
