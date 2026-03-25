# PAUL Handoff

**Date:** 2026-03-25
**Status:** milestone boundary — v2.24 complete, no active milestone

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** pals — PALS Project Automation & Lifecycle System
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

---

## Current State

| Field | Value |
|-------|-------|
| Milestone | None active (v2.24 just completed) |
| Phase | None |
| Plan | None |
| Loop | ○ ○ ○ (ready for next milestone) |
| Branch | main |
| Working tree | clean |
| Tag | v2.24 |

---

## What Was Done This Session

### v2.24 Module Dispatch Integrity (COMPLETE)

**Phase 127 — Debug + Reproduce + Instrument (2 plans):**
- Identified and fixed 7 process failures causing zero module dispatch across v2.23 E2E test:
  1. Duplicate step numbers in SKILL.md (model skips one)
  2. "if it exists" qualifiers on module reads (10+ silent skip points)
  3. No dispatch log when 0 modules fire (invisible failure)
  4. PLAN template missing module section
  5. SUMMARY template module section optional (could be omitted)
  6. No downstream validation of dispatch
  7. Silent no-op in module-dispatch.md reference
- 127-01 applied all fixes across 10 source files
- 127-02 confirmed dispatch works at runtime — 18 modules parsed, 16 hooks dispatched, log lines emitted
- **Root cause confirmed:** compounding process failures in workflow instructions, not architecture

**Phase 128 — Install, Config & Init Audit (2 plans):**
- 128-01: Updated init template from 8 to 18 modules, documented config vs registry relationship
- 128-02: Created pals-json-schema.md (canonical field reference), added migrate_pals_json step to init-project.md, added check_config_version step to plan-phase.md and resume-project.md for auto-migration, updated config.md to read from modules.yaml instead of hardcoded list, added paul-config Pi skill

**Deep audit findings:**
- install.sh reads PALS repo's pals.json, not project's — absent modules default to enabled (not a bug)
- Runtime dispatch reads modules.yaml only, not project pals.json (documented, per-project disable deferred)
- All jq reads have safe `// default` fallbacks — old pals.json never crashes workflows
- Auto-migration now triggers on plan/resume when schema_version mismatches kernel_version

---

## Decisions Made

| Decision | Impact |
|----------|--------|
| Fix instruction patterns, not architecture | Root cause was process failures, not module system design |
| schema_version field enables auto-migration | plan/resume detect mismatch, run migration automatically |
| Migration only adds, never overwrites | Safe for any existing project |
| Per-project module disable deferred | pals.json modules section is informational until runtime disable |
| Install staleness detection deferred | No version check telling users to reinstall |

---

## Deferred Issues

- Per-project module enable/disable at runtime dispatch
- Install version staleness detection / warning
- v2.25 adversarial E2E testing (multi-model, real project, greenfield)
- Module addition checklist (update init template when adding modules)

---

## What's Next

**Immediate:** `/paul:discuss-milestone` or `/paul:milestone`

Likely next milestone candidates:
- **v2.25 E2E Adversarial Testing** — multi-model, real dev project, greenfield. Prove modules produce value, not just dispatch.
- Per-project module runtime disable
- Install upgrade / staleness detection

---

## Key Files

| File | Purpose |
|------|---------|
| .paul/STATE.md | Live project state |
| .paul/ROADMAP.md | Phase overview |
| .paul/MILESTONES.md | Completed milestone log |
| .paul/references/v223-e2e-assessment.md | Original 7-failure analysis |
| kernel/references/pals-json-schema.md | Canonical pals.json field reference |

---

## Resume Instructions

1. Read `.paul/STATE.md` for latest position
2. Run `/paul:resume`

---

*Handoff created: 2026-03-25*
