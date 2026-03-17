---
phase: 67-onboarding-prd-depth
plan: 02
completed: 2026-03-17T21:04:55Z
duration: ~50m
---

# Phase 67 Plan 02 Summary

## Objective
Implement the approved layered artifact model so onboarding writes a compact hot-path `PROJECT.md` plus deeper `PRD.md`, planning/discovery surfaces read `PRD.md` selectively, and shared docs/validation codify the contract without portability regressions.

## What Was Built

| File | Purpose | Change |
|------|---------|--------|
| `kernel/workflows/init-project.md` | Reworked onboarding questions and artifact-writing flow around the layered model | Modified |
| `kernel/references/brownfield-onboarding.md` | Updated brownfield guidance to bridge current-system evidence into the shared durable schema | Modified |
| `kernel/templates/PROJECT.md` | Recast `PROJECT.md` as the compact hot-path landing brief | Modified |
| `kernel/templates/PRD.md` | Added the new deeper product-definition template | Created |
| `kernel/commands/paul/init.md` | Documented layered onboarding outputs | Modified |
| `drivers/pi/skills/paul-init/SKILL.md` | Synced Pi init skill guidance to `PROJECT.md` + `PRD.md` | Modified |
| `kernel/workflows/plan-phase.md` | Added selective `.paul/PRD.md` reading guidance for planning | Modified |
| `kernel/workflows/discuss-phase.md` | Added selective `PRD.md` reads for phase discussion | Modified |
| `kernel/workflows/discuss-milestone.md` | Added selective `PRD.md` reads for milestone shaping | Modified |
| `kernel/workflows/phase-assumptions.md` | Added selective `PRD.md` reads for assumption review | Modified |
| `kernel/commands/paul/{plan,discuss,discuss-milestone,assumptions,research,research-phase}.md` | Named `PRD.md` explicitly where deeper context helps | Modified |
| `drivers/pi/skills/paul-plan/SKILL.md` | Synced Pi planning skill guidance to hot-path vs selective-depth behavior | Modified |
| `drivers/pi/skills/paul-discuss/SKILL.md` | Synced Pi discussion skill guidance to hot-path vs selective-depth behavior | Modified |
| `docs/ARTIFACT-SPEC.md` | Added the normative layered `PROJECT.md` + `PRD.md` contract | Modified |
| `docs/ADAPTER-CONTRACT.md` | Added adapter responsibilities for layered project-definition semantics | Modified |
| `docs/KERNEL-MANIFEST.md` | Added `templates/PRD.md` to the kernel inventory and updated counts | Modified |
| `tests/cross-harness-validation.sh` | Added layered-artifact validation while keeping legacy migration additive | Modified |
| `.paul/STATE.md` | Marked APPLY complete, then prepared loop closure context | Modified |
| `.paul/ROADMAP.md` | Reflected `67-02` execution progress during APPLY | Modified |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|-----------|--------|----------|
| AC-1: Onboarding creates layered durable artifacts from distinct product-definition inputs | Pass | `init-project.md`, `PROJECT.md`, `PRD.md`, `init.md`, and the Pi init skill now describe and write the layered onboarding model. |
| AC-2: Planning and discovery surfaces treat `PRD.md` as selective depth, not hot-path default context | Pass | Planning, discussion, milestone discussion, assumptions, and research surfaces now name `.paul/PRD.md` selectively while leaving orientation flows such as resume untouched. |
| AC-3: Shared docs and validation codify the new artifact contract without portability regression | Pass | `ARTIFACT-SPEC.md`, `ADAPTER-CONTRACT.md`, `KERNEL-MANIFEST.md`, and cross-harness validation now encode the layered contract and legacy-safe posture. |

## Verification Results

| Check | Result | Evidence |
|------|--------|----------|
| Task 1 verification command | Pass | `grep -q 'PRD.md' kernel/workflows/init-project.md && grep -q '## Scope Snapshot' kernel/templates/PROJECT.md && grep -q '## Problem / Opportunity' kernel/templates/PRD.md && grep -q 'PRD.md' kernel/commands/paul/init.md && grep -q 'PRD.md' drivers/pi/skills/paul-init/SKILL.md` |
| Task 2 verification command | Pass | `grep -q '.paul/PRD.md' kernel/workflows/plan-phase.md && grep -q '.paul/PRD.md' kernel/workflows/discuss-phase.md && grep -q '.paul/PRD.md' kernel/workflows/phase-assumptions.md && grep -q '.paul/PRD.md' kernel/commands/paul/research-phase.md && ! grep -q 'PRD.md' kernel/workflows/resume-project.md` |
| Task 3 verification command | Pass | `grep -q 'PRD.md' docs/ARTIFACT-SPEC.md && grep -q 'PRD.md' docs/ADAPTER-CONTRACT.md && grep -q 'templates/PRD.md' docs/KERNEL-MANIFEST.md && grep -q 'PRD.md' tests/cross-harness-validation.sh` |
| Cross-harness validation | Pass | `bash tests/cross-harness-validation.sh` → 53/53 passing |
| Pi validation | Pass | `bash tests/pi-end-to-end-validation.sh` → 109/109 passing |

## Deviations

### Summary
No material deviation from the approved implementation plan.

### Notes
- Existing unrelated tracked and untracked working tree changes remained outside Phase 67 scope and were intentionally left untouched.
- `kernel/modules.yaml` is not present in this repo checkout, so repo-local pre-unify/post-unify module dispatch remained a no-op.
- The plan was executed as a shared markdown/template/doc/test change set only; no Pi runtime code or install manifests were changed.

## Key Patterns / Decisions

| Decision | Impact |
|----------|--------|
| `PROJECT.md` is now the compact hot-path brief while `PRD.md` is the deeper selective-read artifact | Preserves context efficiency without losing durable product-definition depth |
| Greenfield and brownfield onboarding converge on one durable schema with different intake emphasis | Keeps artifact semantics portable while preserving brownfield evidence-first guidance |
| Validation treats `PRD.md` as additive and legacy-safe rather than mandatory for all existing repos | Avoids destructive migration while still codifying the new portable contract |

## Skill Audit
- `/paul` lifecycle flow was used normally through PLAN → APPLY → UNIFY.
- No repo-local module overlays were dispatched because `kernel/modules.yaml` is absent in this checkout.

## Next Phase
**Milestone complete after transition**
- v2.6 now has all three phases complete once Phase 67 is reconciled and transitioned
- the next lifecycle action should be milestone completion / next-milestone routing
- the layered onboarding/artifact model is now ready for future milestone work to build on
