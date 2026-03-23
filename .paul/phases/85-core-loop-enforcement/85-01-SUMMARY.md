---
phase: 85-core-loop-enforcement
plan: 01
subsystem: kernel
tags: [github-flow, git, merge-gate, preflight, postflight, enforcement, apply-phase, unify-phase, transition-phase]

requires:
  - "84-01: git-audit-report.md (gap inventory) + github-flow-config-design.md (behavioral contracts + config schema)"
provides:
  - "github_flow_preflight step in apply-phase.md — branch validation before work begins"
  - "github_flow_postflight step in apply-phase.md — push + PR creation after execution"
  - "github_flow_merge_gate step in unify-phase.md — 6-gate merge enforcement before next PLAN"
  - "GIT_WORKFLOW 3-tier resolution in transition-phase.md — workflow > branching fallback > none"
  - "GitHub-flow conditional mechanics in transition-phase.md — skip local merge, CI blocking, configurable base_branch"
affects:
  - "86-lifecycle-awareness (init defaults, resume/pause/status git surfacing)"
  - "87-validation-docs (validation + docs for the new enforcement behavior)"

tech-stack:
  added: []
  patterns:
    - "3-tier workflow mode resolution: workflow field > branching fallback > none"
    - "Conditional step pattern: If GIT_WORKFLOW != github-flow: skip entire step (no-op)"
    - "6-gate strict-order merge gate: PR exists → CI → reviews → merged → base sync → branch cleanup"
    - "GIT_BASE_BRANCH replaces all hardcoded main references in transition-phase"

key-files:
  created:
    - ".paul/phases/85-core-loop-enforcement/85-01-PLAN.md"
  modified:
    - "kernel/workflows/apply-phase.md"
    - "kernel/workflows/unify-phase.md"
    - "kernel/workflows/transition-phase.md"

key-decisions: []

patterns-established:
  - "GitHub Flow enforcement is always conditional — gated behind workflow: github-flow checks"
  - "Legacy/none modes must have zero behavior change from any enforcement addition"
  - "Merge gate is a lifecycle routing decision (unify-phase), not mechanical git ops (transition-phase)"
  - "CI failure in github-flow mode has no escape hatch — user must fix or change config"

duration: ~15min
started: 2026-03-23T14:15:00-0400
completed: 2026-03-23T14:35:00-0400
---

# Phase 85 Plan 01: Core Loop Enforcement Summary

**Added GitHub Flow enforcement to the three core loop workflows: apply-phase preflight/postflight (2 new steps), unify-phase merge gate (1 new step with 6 sequential gates), and transition-phase config resolution with backward-compatible github-flow mechanics.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~15min |
| Started | 2026-03-23T14:15:00-0400 |
| Completed | 2026-03-23T14:35:00-0400 |
| Tasks | 3/3 PASS |
| Files modified | 3 workflow files |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Apply-Phase Preflight | PASS | `github_flow_preflight` step added between `validate_approval` and `load_plan` — 4 checks (branch, base sync, behind, clean tree) with skip guard |
| AC-2: Apply-Phase Postflight | PASS | `github_flow_postflight` step added between `track_progress` and `finalize` — push, PR create, CI surface with skip guard |
| AC-3: Unify-Phase Merge Gate | PASS | `github_flow_merge_gate` step added between `finalize_summary` and `check_phase_completion` — 6 strict-order gates, CI blocking with no escape, hotfix exempt |
| AC-4: Transition-Phase Config + Mechanics | PASS | `read_git_config` resolves GIT_WORKFLOW with 3-tier fallback, `commit_phase` skips local merge in github-flow, `post_commit_automation` CI is blocking, all hardcoded `main` → GIT_BASE_BRANCH |

## Accomplishments

- **apply-phase.md** (450→625 lines): Added `github_flow_preflight` (95 lines) and `github_flow_postflight` (80 lines) as new steps, both with workflow mode skip guard
- **unify-phase.md** (397→547 lines): Added `github_flow_merge_gate` (150 lines) as new step with 6 sequential gates and merge-via-PR offering
- **transition-phase.md** (520→548 lines): Updated `read_git_config` with 7 new field reads + 3-tier resolution, added github-flow conditionals to `commit_phase` (skip local merge) and `post_commit_automation` (CI blocking, PR duplicate check), replaced all hardcoded `main` with `${GIT_BASE_BRANCH}`

## Enforcement Points Added

| Workflow | Step | Enforcement | Mode Guard |
|----------|------|-------------|------------|
| apply-phase | `github_flow_preflight` | Branch validation, base sync, behind check, clean tree | github-flow only |
| apply-phase | `github_flow_postflight` | Auto-push, auto-PR, CI surfacing | github-flow only |
| unify-phase | `github_flow_merge_gate` | PR exists, CI passing, reviews, merged, base sync, branch cleanup | github-flow + require_pr |
| transition-phase | `commit_phase` | Skip local merge (PR merge handles it) | github-flow only |
| transition-phase | `post_commit_automation` | CI blocking (no escape), PR duplicate check | github-flow only |

## Phase 84 Design Decisions Implemented

| Decision | Implementation |
|----------|---------------|
| D1: Merge gate in unify-phase | ✓ `github_flow_merge_gate` step in unify-phase.md |
| D2: PR after APPLY, check in UNIFY | ✓ Postflight creates PR; merge gate checks state |
| D3: CI blocking in github-flow | ✓ No "merge anyway" in merge gate or transition-phase |
| D4: Keep feature/{phase-name} | ✓ All branch references use this convention |
| D5: gh CLI required | ✓ All PR/CI ops use `gh` commands |
| D6: Hotfix exempt | ✓ Retroactive UNIFY short-circuits before merge gate |
| D7: Legacy = current behavior | ✓ All new steps skip entirely for legacy/none |

## Files Created/Modified

| File | Change | Lines |
|------|--------|-------|
| `kernel/workflows/apply-phase.md` | +175 lines (2 new steps) | 450→625 |
| `kernel/workflows/unify-phase.md` | +150 lines (1 new step) | 397→547 |
| `kernel/workflows/transition-phase.md` | +28 lines (config + conditionals) | 520→548 |

## Deviations from Plan

None — plan executed exactly as written. All 3 tasks PASS, no existing steps modified, all changes conditional on github-flow mode.

## Next Phase Readiness

**Ready:**
- Phase 86 (Lifecycle Awareness) can proceed — init defaults, resume/pause/status git surfacing
- The enforcement infrastructure is complete; Phase 86 adds visibility and onboarding

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 85-core-loop-enforcement, Plan: 01*
*Completed: 2026-03-23*
