---
phase: 128-install-config-init-audit
plan: 01
type: execute
completed: 2026-03-25
---

## Summary

**Phase:** 128 — Install, Config & Init Audit
**Milestone:** v2.24 Module Dispatch Integrity
**Result:** Init template updated, config relationship documented ✅

## What Was Built

| Change | File | Detail |
|--------|------|--------|
| Init module list: 8 → 18 | kernel/workflows/init-project.md | configure_modules display and pals.json template now include all 18 modules |
| Config vs registry docs | kernel/references/module-dispatch.md | New section documenting that dispatch reads modules.yaml, not project pals.json |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|-----------|--------|----------|
| AC-1: Init lists all 18 modules | ✅ Pass | `grep -c '"enabled": true'` = 18 in both display and template |
| AC-2: Config relationship documented | ✅ Pass | "Project Config vs Installed Registry" section added |
| AC-3: Fixes deployed | ✅ Pass | install.sh clean, installed files verified |

## Module Execution Reports

No source code changes that would trigger module hooks. Init-project.md is a workflow instruction file, not application source. All modules correctly had no applicable work.

## Deviations

None.

## Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Per-project module disable deferred | 128 | Project pals.json modules section remains informational; runtime dispatch reads modules.yaml only |
| Install staleness detection deferred | 128 | No version check at runtime; users must manually run install.sh after updates |

## Lessons Learned

1. **The init template was never updated when new modules were added in v2.20-v2.22.** Each "add module" phase should have included an init template update as a checklist item.
2. **Project pals.json and installed modules.yaml serve different purposes but this was never documented.** Making implicit behavior explicit prevents confusion.

## Deferred Issues

- Per-project module enable/disable at runtime dispatch
- Install version staleness detection
- Module addition checklist (update init template when adding modules)

---
*Summary created: 2026-03-25*
