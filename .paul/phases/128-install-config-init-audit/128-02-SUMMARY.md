---
phase: 128-install-config-init-audit
plan: 02
type: execute
completed: 2026-03-25
---

## Summary

**Phase:** 128 — Install, Config & Init Audit (Plan 02)
**Milestone:** v2.24 Module Dispatch Integrity
**Result:** pals.json migration for existing projects ✅

## What Was Built

| Change | File | Detail |
|--------|------|--------|
| Schema reference | kernel/references/pals-json-schema.md | Canonical field list: 18 modules, 14 git fields, planning, preferences, integrations — each with type, default, and version introduced |
| Migration step | kernel/workflows/init-project.md | `migrate_pals_json` step: detects stale pals.json, adds missing fields with defaults, preserves existing values, shows summary |
| Dynamic config | kernel/commands/paul/config.md | Reads modules from installed modules.yaml instead of hardcoded 8-module list |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|-----------|--------|----------|
| AC-1: Schema reference exists | ✅ Pass | pals-json-schema.md created with all fields |
| AC-2: Init migrates existing pals.json | ✅ Pass | migrate_pals_json step added, triggered on existing .paul/ |
| AC-3: Config shows all installed modules | ✅ Pass | config.md reads from modules.yaml registry |

## Module Execution Reports

No source code changes triggering module hooks. Workflow and command files are instruction documents, not application source. All modules correctly had no applicable work.

## Deviations

None.

## Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Migration only adds, never removes or overwrites | 128 | Safe for any existing project — worst case is extra fields with defaults |
| Legacy git.branching → git.workflow: "legacy" | 128 | Old projects with branching config get explicit legacy mode, not silent fallthrough |
| Config toggle is informational until runtime disable | 128 | Documented clearly — toggling in pals.json doesn't affect dispatch yet |

## Lessons Learned

1. **Every "add module" phase should update the init template and config command.** v2.20-v2.22 added 10 modules without touching either. A checklist item prevents this.
2. **Schema documentation prevents drift.** Without pals-json-schema.md, the expected shape was spread across init, config, and 14 jq reads in workflows. One reference file makes migration mechanical.

## Deferred Issues

- Per-project module enable/disable at runtime dispatch
- Install version staleness detection / warning

---
*Summary created: 2026-03-25*
