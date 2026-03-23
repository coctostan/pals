---
phase: 84-research-config-schema
plan: 01
subsystem: kernel
tags: [github-flow, git, config, pals-json, workflow-mode, merge-gate, branch-enforcement]

requires: []
provides:
  - "git-audit-report.md — complete inventory of current git handling across 8 workflows"
  - "github-flow-config-design.md — pals.json schema with 11 fields, behavioral contracts, backward compatibility"
affects:
  - "85-core-loop-enforcement (apply-phase preflight, unify-phase merge gate)"
  - "86-lifecycle-awareness (resume, pause, status, init git state surfacing)"

tech-stack:
  added: []
  patterns:
    - "workflow mode resolution: workflow field > branching field fallback > none"
    - "enforcement via preflight (apply) + merge gate (unify) pattern"

key-files:
  created:
    - ".paul/phases/84-research-config-schema/git-audit-report.md"
    - ".paul/phases/84-research-config-schema/github-flow-config-design.md"
  modified: []

key-decisions:
  - "D1: Merge gate lives in unify-phase (lifecycle routing), not transition-phase (mechanical git ops)"
  - "D2: PR created after APPLY, merge state checked in UNIFY"
  - "D3: CI failure is blocking in github-flow mode — no escape hatch"
  - "D4: Branch naming stays feature/{phase-name}"
  - "D5: gh CLI required for github-flow mode"
  - "D6: Hotfix mode exempt from merge gate"
  - "D7: Legacy mode is true superset of current behavior"

patterns-established:
  - "Three workflow modes: github-flow (strict), legacy (advisory), none (no git ops)"
  - "Config migration: absent workflow + present branching = legacy mode"

duration: ~25min
started: 2026-03-23T13:00:00-0400
completed: 2026-03-23T13:28:00-0400
---

# Phase 84 Plan 01: Research & Config Schema Summary

**Audited all 8 PALS workflow files for git handling, identified 7 GitHub Flow gaps (1 critical, 3 high), and designed the complete pals.json config schema with 11 fields, behavioral contracts per workflow, and backward compatibility plan.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~25min |
| Started | 2026-03-23T13:00:00-0400 |
| Completed | 2026-03-23T13:28:00-0400 |
| Tasks | 2 completed |
| Files modified | 0 source files (research-only) |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Complete Git Touchpoint Inventory | Pass | All 8 workflows audited with operations, config reads, enforcement level, and gaps |
| AC-2: Gap Analysis Against Strict GitHub Flow | Pass | All 7 requirements mapped; 1 CRITICAL, 3 HIGH, 2 MEDIUM, 1 LOW gap severity |
| AC-3: Config Schema Design | Pass | 11 fields defined with types, defaults, behavioral contracts; backward compat documented; 7 design decisions explicit |

## Accomplishments

- Complete audit of git handling across all 8 PALS workflows, identifying that the central gap is the missing merge gate — UNIFY routes to next PLAN without checking if the previous work is merged
- Designed a 3-mode workflow system (github-flow/legacy/none) with backward-compatible config migration from existing `branching` field
- Produced behavioral contracts for all 8 workflows documenting exactly what changes under each mode, with explicit design decisions for the 7 key ambiguities

## Key Audit Findings

| # | Gap | Severity | Current State |
|---|-----|----------|---------------|
| 1 | No merge gate — UNIFY routes to next PLAN without checking merge state | CRITICAL | unify-phase.md has zero PR/merge awareness |
| 2 | No apply-phase preflight — work can start on wrong branch or stale base | HIGH | apply-phase.md only has worktree setup |
| 3 | PR ordering inverted — PR created after local merge, not before | HIGH | transition-phase.md creates PR post-merge |
| 4 | CI is advisory — "merge anyway" offered on failure | HIGH | transition-phase.md offers escape hatch |
| 5 | No base_branch sync before branching | HIGH | No check that main is up-to-date |
| 6 | resume-project.md has zero git awareness | MEDIUM | No branch, PR, CI, or behind-main surfacing |
| 7 | No remote branch deletion config | LOW | Local branch deleted, remote not addressed |

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `git-audit-report.md` | Created | Complete inventory of current git handling per workflow + gap analysis |
| `github-flow-config-design.md` | Created | New pals.json schema, field definitions, behavioral contracts, backward compat, design decisions |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| D1: Merge gate in unify-phase | Lifecycle routing belongs in UNIFY, not mechanical git ops in transition-phase | Phase 85 implementation targets unify-phase for the gate |
| D2: PR after APPLY, check in UNIFY | Matches real GitHub Flow timing: work → push → PR → CI → review → merge | Phase 85 adds post-apply PR creation and UNIFY merge check |
| D3: CI blocking in github-flow | Strict mode means strict — escape is ci_checks:false or workflow:legacy | No "merge anyway" option in github-flow mode |
| D4: Keep feature/{phase-name} | Already established, descriptive, consistent with lifecycle | No branch naming changes needed |
| D5: gh CLI required | Standard GitHub CLI, already referenced in transition-phase | Init should validate gh availability |
| D6: Hotfix exempt from merge gate | Hotfix is explicit escape hatch; requiring PR defeats purpose | fix-loop.md gets minimal changes |
| D7: Legacy = current behavior | Existing projects must not break; migration is opt-in | branching field becomes fallback for absent workflow field |

## Deviations from Plan

None — plan executed exactly as written. Both research artifacts produced, no source files modified.

## Next Phase Readiness

**Ready:**
- Config schema is concrete enough for direct implementation in Phase 85
- Behavioral contracts document exactly which steps to add/modify per workflow
- Design decisions resolve all implementation ambiguities identified

**Concerns:**
- Phase 85 (Core Loop Enforcement) is the heaviest lift — apply-phase preflight + unify-phase merge gate + transition-phase PR reordering
- gh CLI availability should be validated early in Phase 85

**Blockers:**
- None

---
*Phase: 84-research-config-schema, Plan: 01*
*Completed: 2026-03-23*
