---
phase: 188-workflow-prompt-skill-slimming
plan: 01
subsystem: prompts-skills
tags: [context-optimization, prompt-slimming, pi-skills, claude-commands, validation]
requires:
  - phase: 187-regression-anti-regrowth-guardrails
    provides: context-diet validation guardrails
provides:
  - Thin legacy/reference Claude command wrappers for PLAN/APPLY/UNIFY/resume/milestone
  - Thin but guardrail-complete Pi skill wrappers for matching lifecycle commands
  - Wrapper line-count reduction from 406 to 296 lines
  - Strategic note that Pi is likely the primary supported harness going forward
key-files:
  created:
    - .paul/phases/188-workflow-prompt-skill-slimming/188-01-PLAN.md
    - .paul/phases/188-workflow-prompt-skill-slimming/188-01-SUMMARY.md
  modified:
    - kernel/commands/paul/plan.md
    - kernel/commands/paul/apply.md
    - kernel/commands/paul/unify.md
    - kernel/commands/paul/resume.md
    - kernel/commands/paul/milestone.md
    - drivers/pi/skills/paul-plan/SKILL.md
    - drivers/pi/skills/paul-apply/SKILL.md
    - drivers/pi/skills/paul-unify/SKILL.md
    - drivers/pi/skills/paul-resume/SKILL.md
    - drivers/pi/skills/paul-milestone/SKILL.md
    - .paul/STATE.md
    - .paul/ROADMAP.md
key-decisions:
  - "Treat Claude Code command wrappers as legacy/reference thin pointers while preserving routing semantics."
  - "Keep Pi skill wrappers as the active user-facing surface and preserve exact validation markers there."
patterns-established:
  - "Driver wrappers should point at canonical workflows instead of duplicating workflow mechanics."
duration: one APPLY/UNIFY session
started: 2026-04-26T22:28:53Z
completed: 2026-04-27T00:13:53Z
---

# Phase 188 Plan 188-01: Workflow Prompt/Skill Slimming Summary

Core lifecycle command and Pi skill wrappers now delegate repeated mechanics to canonical workflows with less duplicated prose while preserving validation-visible lifecycle guardrails.

## Performance

| Metric | Value |
|--------|-------|
| Duration | one APPLY/UNIFY session |
| Started | 2026-04-26T22:28:53Z |
| Completed | 2026-04-27T00:13:53Z |
| Tasks | 3 completed |
| Files modified | 10 prompt/skill wrappers plus PALS lifecycle artifacts |

## Objective

Slim the highest-frequency PALS command prompts and matching Pi skill wrappers for PLAN/APPLY/UNIFY/resume/milestone so they delegate repeated mechanics to canonical workflows instead of restating them inline.

## What Was Built

| File | Purpose | Result |
|------|---------|--------|
| `kernel/commands/paul/plan.md` | Claude Code command wrapper | Converted to a thin canonical workflow pointer while preserving collaboration, planning mode, PRD selectivity, review, and state-update markers. |
| `kernel/commands/paul/apply.md` | Claude Code command wrapper | Reduced duplicated task/checkpoint mechanics to command-local obligations around explicit approval, verification, parent ownership, and UNIFY routing. |
| `kernel/commands/paul/unify.md` | Claude Code command wrapper | Reduced reconciliation prose to canonical workflow routing while preserving mandatory UNIFY, SUMMARY creation, state/roadmap updates, and next-action routing. |
| `kernel/commands/paul/resume.md` | Claude Code command wrapper | Reduced resume wrapper to authoritative STATE/handoff/single-next-action routing. |
| `kernel/commands/paul/milestone.md` | Claude Code command wrapper | Reduced milestone wrapper to create-vs-complete routing, handoff reuse, collaboration/review, and completion verification. |
| `drivers/pi/skills/paul-*.md` selected set | Pi active skill wrappers | Kept thin wrappers but restored validation-required phrases for active Pi operation. |
| `.paul/phases/188-workflow-prompt-skill-slimming/188-01-PLAN.md` | Plan artifact | Captured Phase 188 executable scope and strategic Pi-first/Claude-legacy framing. |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|-----------|--------|----------|
| AC-1: Wrapper Line-Cost Reduction | PASS | Selected wrapper total reduced from 406 lines to 296 lines, below the 325 target. |
| AC-2: Lifecycle Semantics Preserved | PASS | Validation confirmed collaboration/mode/review markers, explicit approval, parent-owned APPLY guardrails, mandatory UNIFY, resume routing, and milestone routing remain present. |
| AC-3: Pi Skill Wrappers Stay Thin and Complete | PASS | Pi skills retain frontmatter, canonical workflow references, and command-local guardrails required by validation. |
| AC-4: Existing Validation Remains Green | PASS | Final Pi validation passed 177/177; cross-harness validation passed 90/90. |

## Task Results

| Task | Status | Evidence |
|------|--------|----------|
| Task 1: Slim core Claude command wrappers to canonical pointers | PASS | Five `kernel/commands/paul/*.md` wrappers now use concise canonical workflow routing and command-local obligations. |
| Task 2: Normalize matching Pi skill wrappers without adding prose | PASS | Five `drivers/pi/skills/paul-*/SKILL.md` wrappers remain short and preserve exact active Pi guardrail phrases. |
| Task 3: Verify context-diet markers and full validation | PASS | Wrapper total is 296 lines; Pi and cross-harness validation both passed. |

## Verification Results

| Command | Result |
|---------|--------|
| `wc -l kernel/commands/paul/plan.md kernel/commands/paul/apply.md kernel/commands/paul/unify.md kernel/commands/paul/resume.md kernel/commands/paul/milestone.md drivers/pi/skills/paul-plan/SKILL.md drivers/pi/skills/paul-apply/SKILL.md drivers/pi/skills/paul-unify/SKILL.md drivers/pi/skills/paul-resume/SKILL.md drivers/pi/skills/paul-milestone/SKILL.md` | PASS — 296 total lines, below 325 target and down from 406 baseline. |
| `grep -R 'default_collaboration' kernel/workflows kernel/commands/paul drivers/pi/skills` | PASS |
| `grep -R 'exploratory' kernel/workflows kernel/commands/paul drivers/pi/skills` | PASS |
| `grep -R 'direct-requirements' kernel/workflows kernel/commands/paul drivers/pi/skills` | PASS |
| `bash tests/pi-end-to-end-validation.sh` | PASS — 177 passed, 0 failed |
| `bash tests/cross-harness-validation.sh` | PASS — 90 passed, 0 failed |

## Module Execution Reports

### PLAN/APPLY carry-forward

- `[dispatch] pre-plan advisory`: ARCH found markdown prompt/skill wrapper files in expected kernel/driver locations; SETH found no hardcoded secrets; TODD found no root test framework and identified shell validation as the relevant verification path; IRIS found no TODO/FIXME/HACK/XXX markers; DAVE found no CI config and CI generation remained out of scope; DOCS found markdown docs but no separate doc update need; RUBY flagged wrapper line-count debt in `apply.md` and `unify.md`.
- `[dispatch] CODI: skipped — no extractable symbols in phase scope`.
- `[dispatch] pre-plan enforcement`: DEAN passed/skipped because no dependency manifest or lock file changed.
- `[dispatch] post-apply advisory`: ARCH-style import/boundary checks found no runtime import boundary surface in markdown wrappers; DOCS/RUBY concerns were satisfied by wrapper slimming and this summary.
- `[dispatch] post-apply enforcement`: WALT/TODD validation passed with Pi 177/177 and cross-harness 90/90; DEAN remained skipped because no dependency files changed.

### Post-unify reports

- `[dispatch] pre-unify: 0 modules registered for this hook`.
- `[dispatch] WALT post-unify: appended stable row for 188-01 to .paul/QUALITY-HISTORY.md`.
- `[dispatch] SKIP post-unify: captured prompt-wrapper slimming pattern and Pi-primary/Claude-legacy strategic note in this SUMMARY`.
- `[dispatch] CODI post-unify: hook body entered for 188-01`.
- `[dispatch] CODI post-unify: appended skipped-no-symbols row for 188-01`.
- `[dispatch] RUBY post-unify: wrapper line count reduced by 110 lines; no additional refactor candidate required for this slice`.

## Quality

| Metric | Before | After | Delta | Trajectory |
|--------|--------|-------|-------|------------|
| Selected wrapper total | 406 lines | 296 lines | -110 lines (-27%) | ↑ improving |
| Pi validation | 177 passed, 0 failed | 177 passed, 0 failed | 0 | → stable |
| Cross-harness validation | 90 passed, 0 failed | 90 passed, 0 failed | 0 | → stable |
| Dependencies | unchanged | unchanged | 0 | stable |

**Overall:** improving. The recurring wrapper read surface is smaller while validation remains green.

## Accomplishments

- Removed duplicated workflow mechanics from the highest-frequency Claude command wrappers.
- Preserved Claude command routing as thin legacy/reference pointers rather than expanding Claude-specific polish.
- Kept Pi skill wrappers short while retaining exact active-harness guardrails checked by validation.
- Reduced selected wrapper total from 406 to 296 lines.
- Preserved all existing context-diet and cross-harness validation checks.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `.paul/phases/188-workflow-prompt-skill-slimming/188-01-PLAN.md` | Created | Executable plan for Phase 188. |
| `.paul/phases/188-workflow-prompt-skill-slimming/188-01-SUMMARY.md` | Created | This reconciliation summary. |
| `kernel/commands/paul/plan.md` | Modified | Thin planning command wrapper. |
| `kernel/commands/paul/apply.md` | Modified | Thin apply command wrapper. |
| `kernel/commands/paul/unify.md` | Modified | Thin unify command wrapper. |
| `kernel/commands/paul/resume.md` | Modified | Thin resume command wrapper. |
| `kernel/commands/paul/milestone.md` | Modified | Thin milestone command wrapper. |
| `drivers/pi/skills/paul-plan/SKILL.md` | Modified | Thin active Pi planning skill wrapper. |
| `drivers/pi/skills/paul-apply/SKILL.md` | Modified | Thin active Pi apply skill wrapper with delegation guardrails. |
| `drivers/pi/skills/paul-unify/SKILL.md` | Modified | Thin active Pi unify skill wrapper. |
| `drivers/pi/skills/paul-resume/SKILL.md` | Modified | Thin active Pi resume skill wrapper with handoff lifecycle markers. |
| `drivers/pi/skills/paul-milestone/SKILL.md` | Modified | Thin active Pi milestone skill wrapper. |
| `.paul/STATE.md` | Modified | Lifecycle state and routing. |
| `.paul/ROADMAP.md` | Modified | Phase 188 plan/apply/unify routing. |
| `.paul/PROJECT.md` | Modified | v2.44 milestone posture. |
| `.paul/MILESTONES.md` | Modified | v2.44 milestone pointer and v2.43 completed row. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Treat Claude Code command wrappers as legacy/reference thin pointers | User signaled the next strategic direction may move away from supporting Claude as a primary surface. | Avoids expanding Claude-specific support while preserving cross-harness routing and install parity. |
| Keep Pi skill wrappers as the stronger active user-facing surface | Pi is the likely primary supported harness going forward and validation already encodes Pi wrapper guardrails. | Pi skills retain exact guardrail phrases even when command wrappers become more pointer-like. |
| Do not modify validation scripts | First validation failure showed useful exact marker drift, not a false-positive test. | Guardrails remain strong; wrappers were adjusted instead. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 1 | Initial Pi validation failed because slimmed Pi wrappers removed exact guardrail phrases; the phrases were restored in thinner form. |
| Scope additions | 0 | None. |
| Deferred | 0 | None from this plan. |

**Total impact:** No scope deviation. The auto-fix strengthened compliance with the plan's semantic-preservation requirement.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Initial Pi validation failed 4 checks for missing exact thin-wrapper markers in `paul-apply`, `paul-plan`, and `paul-resume`. | Restored required phrases: `explicit user approval`, `pals-implementer`, `single-task work the parent can still verify`, `official verify steps`, `module enforcement`, `4-option review menu`, `.paul/handoffs/archive/`, and `Archive an active consumed handoff`. Re-ran validation successfully. |

## Knowledge Captured

### 2026-04-27 Driver command wrappers should be thin pointers; active harness skills keep guardrail phrases

**Type:** pattern / strategic note  
**Phase:** 188 — Workflow Prompt/Skill Slimming  
**Related:** `kernel/commands/paul/*.md`, `drivers/pi/skills/paul-*/SKILL.md`

Prompt/skill context optimization should distinguish canonical workflow truth from driver-facing convenience wrappers. Claude Code command wrappers can be minimal legacy/reference pointers as long as they preserve routing semantics and cross-harness installation parity. Pi skill wrappers are the likely primary active user-facing surface and should retain concise guardrail phrases that validation and users rely on.

**Key factors:**
- Canonical workflows own lifecycle semantics.
- Repeated command-wrapper prose adds recurring context cost.
- Pi is likely the primary supported harness going forward.
- Validation marker failures are useful signals when slimming user-facing wrappers.

**Impact:** Future prompt-slimming should reduce duplicated wrapper mechanics first, keep exact active-harness guardrails where validation requires them, and avoid new Claude-specific polish unless product strategy changes.

## Next Phase Readiness

**Ready:**
- Phase 188 implementation and local validation are complete.
- Selected wrapper total is below target.
- Phase 189 can audit remaining hot-path reads with a smaller wrapper baseline.

**Concerns:**
- Future milestones may need an explicit product decision about Claude Code's support tier.

**Blockers:**
- None for Phase 189 after GitHub Flow merge gate completes.

---
*Phase: 188-workflow-prompt-skill-slimming, Plan: 01*
*Completed: 2026-04-27*
