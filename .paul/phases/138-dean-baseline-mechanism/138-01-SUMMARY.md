---
phase: 138-dean-baseline-mechanism
plan: 01
completed: 2026-03-26
duration: ~8 minutes
---

## Objective
Add DEAN baseline mechanism so pre-existing vulnerabilities are acknowledged after first override, and subsequent plans only BLOCK on NEW vulnerabilities.

## What Was Built

| File | Purpose | Change |
|------|---------|--------|
| modules/dean/references/vulnerability-audit.md | Audit reference | Added <baseline> section with schema, delta logic, staleness, clearing |
| modules/dean/module.yaml | DEAN module | Pre-plan hook now baseline-aware with delta comparison |
| kernel/workflows/plan-phase.md | Plan workflow | Override path records baseline to .paul/dean-baseline.json |

**Net change:** +51 lines in vulnerability-audit.md, +9 in module.yaml, +13 in plan-phase.md

### Baseline Lifecycle
1. **First run (no baseline):** DEAN BLOCKs on critical > 0 (unchanged behavior)
2. **User overrides:** plan-phase.md records severity counts + packages to `.paul/dean-baseline.json`
3. **Subsequent plans:** DEAN reads baseline, computes delta, only BLOCKs if NEW critical/high > 0
4. **Stale baseline (>30 days):** Re-triggers full BLOCK, user re-acknowledges
5. **Clearing:** Milestone completion or manual delete

## Acceptance Criteria Results

| AC | Description | Status |
|----|-------------|--------|
| AC-1 | Baseline file schema documented | ✅ PASS |
| AC-2 | Pre-plan hook uses baseline delta | ✅ PASS |
| AC-3 | First override records baseline + staleness guard | ✅ PASS |

## Verification Results
- vulnerability-audit.md: <baseline> section with schema, delta, staleness, clearing ✓
- DEAN pre-plan: checks baseline, computes delta, handles stale/missing ✓
- plan-phase.md: records baseline on override with JSON schema ✓
- Existing behavior unchanged when no baseline exists ✓
- Reinstalled to both ~/.pals/ and ~/.pi/agent/skills/pals/ ✓

## Module Execution Reports
No module dispatch needed for this change scope.

## Deviations
None.

## v2.25 Actionable Items — ALL COMPLETE

| Item | Description | Milestone | Status |
|------|-------------|-----------|--------|
| 1 | Module instruction wording audit | v2.27 | ✅ |
| 2 | Post-apply dispatch enforcement | v2.27 | ✅ |
| 3 | DEAN baseline mechanism | v2.28 | ✅ |
| 4 | Post-unify hook enforcement | v2.27 | ✅ |
| 5 | Merge gate simplification | v2.27 | ✅ |
| 6 | Smart question gating | v2.26 | ✅ |
| 7 | Brownfield detection fix | v2.26 | ✅ |
| 8 | Greenfield ~8 questions | v2.26 | ✅ |
| 9 | Explicit first milestone | v2.26 | ✅ |
| 10 | Module explanations | v2.26 | ✅ |
| 11 | Conditional git questions | v2.26 | ✅ |
| 12 | Remove specialized skills | v2.26 | ✅ |
| 13 | Quick init mode | v2.26 | ✅ |
