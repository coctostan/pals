# Roadmap: pals

## Overview
PALS — the Linux of Harness Engineering. Minimal kernel, modular pals, universal drivers. PAUL (project lifecycle) is the kernel. CARL (context rules), TODD (TDD enforcement), and WALT (quality gating) are first-party modules. Drivers make it run on any agentic coding platform.

## Milestones

### v0.1 Fork & Unify (Complete)
Phases: 6 of 6 complete — 2026-03-11

### v0.2 Polish (Complete)
Status: Complete
Phases: 1 of 1 complete — 2026-03-11

### v0.3 Smart Context & Migration (Complete)
Status: Complete
Phases: 2 of 2 complete — 2026-03-11

### v0.4 Kernel & Modules (Complete)
Status: ✅ Complete
Completed: 2026-03-12
Phases: 4 of 4 complete

### v0.5 TODD & WALT Go Live (Complete)
Status: ✅ Complete
Completed: 2026-03-12
Phases: 3 of 3 complete

## Phases (v0.5)

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 14 | TODD Integration | 1 | Complete | 2026-03-12 |
| 15 | WALT Integration | 1 | Complete | 2026-03-12 |
| 16 | Module System Validation | 1 | Complete | 2026-03-12 |

## Phase Details (v0.5)

### Phase 14: TODD Integration

**Goal:** Make TODD's TDD enforcement fully functional end-to-end
**Depends on:** v0.4 complete (module system in place)
**Research:** No

**Scope:**
- Create missing `plan-phase-tdd.md` workflow (declared in module.yaml but file doesn't exist)
- Test TDD detection heuristics on real code (pre-plan hook)
- Test plan restructuring into RED/GREEN/REFACTOR (post-plan hook)
- Test execution enforcement: RED phase first, GREEN verification (pre-apply, post-task hooks)
- Fix any gaps in reference files discovered during testing

### Phase 15: WALT Integration

**Goal:** Make WALT's quality gating fully functional end-to-end
**Depends on:** Phase 14 (TODD working, shared module patterns proven)
**Research:** No

**Scope:**
- Test quality tool auto-detection (zero-config heuristics)
- Test baseline capture before apply (pre-apply hook)
- Test regression detection after apply (post-apply hook)
- Test quality history recording (post-unify hook)
- Fix any gaps in reference files discovered during testing

### Phase 16: Module System Validation

**Goal:** Prove both modules work together through a full PAUL lifecycle loop
**Depends on:** Phases 14-15 (both modules individually working)
**Research:** No

**Scope:**
- Fresh install → run full PLAN/APPLY/UNIFY loop with TODD + WALT active
- Verify hook priorities respected (TODD pre-apply at 50 fires before WALT pre-apply at 100)
- Verify module enable/disable via pals.yaml works
- Document any fixes or patterns discovered

---

## Completed Milestones

<details>
<summary>v0.4 Kernel & Modules - 2026-03-12 (4 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 10 | Architecture & Module Interface | 1 | 2026-03-11 |
| 11 | Kernel Extraction & Module Refactor | 2 | 2026-03-12 |
| 12 | Module Manager & Installer | 2 | 2026-03-12 |
| 13 | Driver Architecture & Agent SDK Stub | 2 | 2026-03-12 |

</details>

<details>
<summary>v0.3 Smart Context & Migration - 2026-03-11 (2 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 8 | Smart Installer | 1 | 2026-03-11 |
| 9 | Auto Context Cycling | 1 | 2026-03-11 |

</details>

<details>
<summary>v0.2 Polish - 2026-03-11 (1 phase)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 7 | Namespace & Cleanup | 1 | 2026-03-11 |

</details>

<details>
<summary>v0.1 Fork & Unify - 2026-03-11 (6 phases)</summary>

| Phase | Name | Plans | Completed |
|-------|------|-------|-----------|
| 1 | Architecture & Design | 2 | 2026-03-11 |
| 2 | Fork & Restructure | 3 | 2026-03-11 |
| 3 | Merge TODD/WALT | 2 | 2026-03-11 |
| 4 | CARL Integration | 2 | 2026-03-11 |
| 5 | Install & Distribution | 2 | 2026-03-11 |
| 6 | End-to-End Validation | 1 | 2026-03-11 |

</details>

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-03-12 — v0.5 TODD & WALT Go Live milestone complete*
