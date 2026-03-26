---
phase: 147-adoption-decisions
plan: 01
completed: 2026-03-26T00:00:00Z
---

# Phase 147 Plan 01: Adoption Decisions — Summary

## Objective
Implement the 3 adaptations from the upstream audit: qualify substep, evidence discipline reference, and quick-track UNIFY.

## What Was Built

| File | Change | Lines |
|------|--------|-------|
| `kernel/workflows/apply-phase.md` | Added step 3a (qualify) between verify and record-status. Added `references/evidence-discipline.md` to references section. Fixed duplicate step 6 numbering to 7. | +15 net |
| `kernel/references/evidence-discipline.md` | New file. Evidence chain, anti-rationalization table (8 patterns), 7 PALS principles. | 75 lines |
| `kernel/workflows/unify-phase.md` | Added quick-track detection (step 3 in gather_results). Added compressed SUMMARY path before full SUMMARY in create_summary. | +25 net |

## Acceptance Criteria Results

| AC | Result | Evidence |
|----|--------|----------|
| AC-1: Qualify substep added | ✅ PASS | Step 3a exists between verify and record-status with re-read mandate + spec/AC comparison |
| AC-2: Evidence discipline reference | ✅ PASS | 75-line file with evidence chain, anti-rationalization table, and 7 PALS principles |
| AC-3: Quick-track UNIFY | ✅ PASS | Detection logic in gather_results; compressed format in create_summary; full path unchanged |

## Verification Results

```
Qualify substep: grep confirms "Qualify.*verify your own output" in apply-phase.md ✓
Evidence discipline: file exists, 3 sections present, 75 lines (under 150 budget) ✓
Quick-track: 4 references to is_quick_track, 3 references to compressed SUMMARY ✓
No unauthorized files modified ✓
```

## Deviations
- **Minor (pre-existing fix):** Renumbered duplicate step 6 → 7 in apply-phase.md (both divergence check and post-task hooks were numbered 6). Not in plan but corrects an existing defect.

## Key Decisions
All adoption decisions were made in Phase 146. This phase was pure implementation.

## What Was Adopted from Upstream (Milestone Summary)

| Source | What | How We Adapted |
|--------|------|---------------|
| PAUL v1.2 E/Q Loop | Qualify substep — re-read your own output before claiming done | Added as step 3a in apply-phase.md; kept our PASS/PASS_WITH_CONCERNS/BLOCKED statuses |
| PAUL v1.2 quality-principles.md | Anti-rationalization table + philosophy doc | Created evidence-discipline.md with PALS-specific principles (7 vs upstream's 9) |
| PAUL v1.2 unify quick-track | Compressed SUMMARY for simple plans | Added is_quick_track detection + compressed format; module dispatch unaffected |

## What Was Rejected/Deferred

| Item | Decision | Rationale |
|------|----------|-----------|
| Plan audit (`/paul:audit`) | Deferred | Enterprise-oriented; IRIS/ARCH modules cover similar ground |
| Upstream CARL capabilities | Rejected | Fundamentally different product (rule injection vs session boundary) |
| Formal JSON Schema | Deferred | Low incident rate; consider for external users |
| NPM distribution | Deferred | Multi-driver architecture complicates; premature |
| SonarQube workflow | Rejected | Niche; existing reference sufficient |
| BASE satellite system | Rejected | Not relevant to PALS |

## Next
Milestone v2.31 complete — all 3 phases done. Ready for `/paul:milestone` (complete mode).
