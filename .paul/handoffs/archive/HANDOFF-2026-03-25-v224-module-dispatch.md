# PAUL Handoff

**Date:** 2026-03-25
**Status:** paused at milestone boundary

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** pals — PALS Project Automation & Lifecycle System
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

---

## Current State

| Field | Value |
|-------|-------|
| Milestone | v2.24 Module Dispatch Integrity |
| Phase | 127 of 128 (Debug + Reproduce + Instrument) |
| Plan | Not started |
| Loop | ○ ○ ○ (ready for first PLAN) |
| Branch | feature/123-identity-and-cleanup (needs cleanup — was from v2.23) |
| Working tree | .paul/ changes only |

---

## What Was Done This Session

### v2.23 pi-verify v1.0 — Ship-Ready Product (COMPLETE but flawed)
- Ran full E2E test: 4 PLAN→APPLY→UNIFY cycles via cmux pane (Kimi for Coding K2.5)
- pi-verify shipped: v1.0.0, 67 tests, 5 languages, .verifyrc.json config, parallel execution
- **CRITICAL FINDING:** Zero module dispatch across all 4 phases. The 18-module roster was never consulted.

### Module System E2E Debug
Traced the entire module system from source to deployment to runtime:

1. **Deployment chain works:** install.sh correctly generates modules.yaml at ~/.pi/agent/skills/pals/modules.yaml with all 18 modules. All reference files copied.

2. **Runtime chain breaks (suspected):** Workflows say `Read modules.yaml` with a bare path. Model resolves from CWD (project dir), not skill dir. The file doesn't exist in project dir → "if it exists" → silent no-op.

3. **Additional concerns identified:**
   - pi-verify pals.json only lists 8 of 18 modules — installer may skip unlisted modules
   - SKILL.md has duplicate step 5 numbering
   - "if it exists" + "no-op, no warning" = zero signal when modules don't fire
   - SUMMARY template Module Execution Reports section is optional

4. **Root cause is UNVERIFIED** — these are hypotheses. Phase 127 must reproduce before fixing.

### v2.24 Milestone Created
- 2 phases: Debug + Reproduce + Instrument (127), Durable Fix Across System (128)
- Follow-on v2.25 planned: adversarial test, real dev, greenfield (3 phases)

---

## Decisions Made

| Decision | Impact |
|----------|--------|
| v2.23 E2E test proved nothing about modules — entire module validation was wasted | Led to v2.24 milestone focused on module dispatch integrity |
| Must reproduce before fixing — no assumptions about root cause | Phase 127 structured as debug-first, not fix-first |
| Split verification into separate v2.25 milestone (adversarial + real dev + greenfield) | Keeps v2.24 focused on the fix, v2.25 on proof |
| Need to examine install.sh + pals.json chain, not just workflow paths | Broadened scope beyond just path resolution |

---

## What's Next

**Immediate:** `/paul:plan` for Phase 127 — Debug + Reproduce + Instrument

Phase 127 must:
1. Add instrumentation/logging to module dispatch path
2. Reproduce the failure in pi-verify via cmux pane
3. Examine install.sh behavior with missing/stale pals.json
4. Document what's actually broken with evidence
5. Apply minimum isolated fix
6. Iterate in cmux until modules visibly fire

---

## Key Files

| File | Purpose |
|------|---------|
| .paul/STATE.md | Live project state |
| .paul/ROADMAP.md | Phase overview |
| .paul/references/v223-e2e-assessment.md | Full E2E assessment with debug findings |
| /Users/maxwellnewman/.pi/agent/skills/pals/modules.yaml | Installed module registry (18 modules) |
| install.sh | PALS installer — module deployment chain |
| drivers/pi/install.sh | Pi-specific installer |
| docs/REFERENCE-RESOLUTION.md | Documents kernel/ path convention |

---

## Resume Instructions

1. Read `.paul/STATE.md` for latest position
2. Read `.paul/references/v223-e2e-assessment.md` for full debug context
3. Run `/paul:resume`

---

*Handoff created: 2026-03-25T22:00:00-0400*
