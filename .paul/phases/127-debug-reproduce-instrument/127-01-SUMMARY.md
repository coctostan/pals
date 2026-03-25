---
phase: 127-debug-reproduce-instrument
plan: 01
type: execute
completed: 2026-03-25
---

## Summary

**Phase:** 127 — Debug + Reproduce + Instrument
**Milestone:** v2.24 Module Dispatch Integrity
**Result:** All 7 process failures fixed, reinstalled, and verified ✅

## What Was Built

Fixed all 7 process failures identified in the v2.23 E2E assessment that caused zero module dispatch across 4 complete PLAN→APPLY→UNIFY loops:

| # | Process Failure | Fix Applied | Files |
|---|----------------|-------------|-------|
| 1 | Duplicate step 5 in SKILL.md | Renumbered: modules.yaml read = step 5, follow workflow = step 6 (plan), 4/5 (apply/unify) | 3 SKILL.md files |
| 2 | "if it exists" qualifier on module reads | Changed to "MUST read" in SKILL.md; removed "if it exists" from all workflow dispatch steps; emit WARNING on missing registry | 3 SKILL.md + 4 workflows |
| 3 | No dispatch log when 0 modules fire | Replaced "no-op, no warning" with mandatory dispatch log: `[dispatch] {hook}: 0 modules registered` | 4 workflows |
| 4 | PLAN template has no module section | Added `<module_dispatch>` section with Pre-Plan Module Dispatch (REQUIRED) | kernel/templates/PLAN.md |
| 5 | SUMMARY template module section optional | Changed "omit this section entirely" to REQUIRED; must state WHY no modules fired | kernel/templates/SUMMARY.md |
| 6 | No downstream validation | Added module dispatch validation in plan-phase `validate_plan` and unify-phase `finalize_summary` | 2 workflows |
| 7 | Silent no-op in module-dispatch.md | Changed "treat hook dispatch as a no-op" to emit WARNING with actionable message | kernel/references/module-dispatch.md |

**Total:** 10 source files modified, 39 insertions, 27 deletions.

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|-----------|--------|----------|
| AC-1: No duplicate step numbers | ✅ Pass | `grep -n "^[0-9]\." paul-plan/SKILL.md` shows unique 1-6 numbering |
| AC-2: No "if it exists" on module reads | ✅ Pass | `grep -rn "if it exists" ... \| grep -i module` returns 0 hits |
| AC-3: Dispatch log always emitted | ✅ Pass | All "no-op, no warning" patterns replaced with mandatory dispatch log |
| AC-4: PLAN template has module section | ✅ Pass | `grep "Module Dispatch" kernel/templates/PLAN.md` confirms section |
| AC-5: SUMMARY module section required | ✅ Pass | "REQUIRED" language confirmed; "omit" instruction removed |
| AC-6: Fixes deployed and verified | ✅ Pass | `install.sh` clean; all 8 verification greps pass in installed tree |

## Module Execution Reports

This phase fixes the module dispatch system itself. No module hooks were dispatched during this APPLY because the phase modifies the dispatch infrastructure. This is expected — the fixes enable module dispatch for all future phases.

## Deviations

None. All 7 fixes applied exactly as planned. No unexpected files modified, no approach changes.

## Decisions

| Decision | Impact |
|----------|--------|
| Fix all 7 failures in one task rather than separate tasks per failure | Efficient — failures are interconnected; fixing them together ensures consistency |
| Keep "if it exists" on pals.json reads (only remove from modules.yaml reads) | pals.json is legitimately optional in some contexts; modules.yaml is always installed |

## Lessons Learned

1. **Duplicate step numbers are a silent killer.** Models scan numbered lists structurally — two step 5s means one gets skipped. Always validate step numbering.
2. **"if it exists" + "no-op, no warning" = invisible failure.** Ten separate "if it exists" qualifiers created ten chances to silently skip. Mandatory dispatch logging (even for 0 modules) is the fix.
3. **Templates drive behavior.** If the PLAN template has no module section, no plan will record module dispatch. If the SUMMARY template says "omit if empty," summaries will omit. Templates are implicit instructions.
4. **Two layers of weak instructions don't make one strong instruction.** SKILL.md and workflow both said "read modules.yaml if it exists" — two chances to skip, not two chances to succeed. The fix makes SKILL.md authoritative and workflow steps reference the already-loaded registry.

## Deferred Issues

- **Phase 128 (Durable Fix Across System):** Deeper systemic changes if needed after v2.25 adversarial testing
- **v2.25 adversarial test:** Will prove these fixes work under real multi-phase E2E pressure with a third-party model

---
*Summary created: 2026-03-25*
