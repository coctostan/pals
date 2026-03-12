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

### v0.4 Kernel & Modules
Status: In Progress
Phases: 2 of 4 complete

## Phases (v0.4)

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 10 | Architecture & Module Interface | 1 | Complete | 2026-03-11 |
| 11 | Kernel Extraction & Module Refactor | 2 | Complete | 2026-03-12 |
| 12 | Module Manager & Installer | TBD | Not started | - |
| 13 | Driver Architecture & Agent SDK Stub | TBD | Not started | - |

## Phase Details (v0.4)

### Phase 10: Architecture & Module Interface

**Goal:** Design the kernel boundary, module manifest format, hook contract, and driver interface
**Depends on:** v0.3 complete
**Research:** Yes (need to define module interface, hook points, driver abstraction)

**Scope:**
- Define what's "kernel" vs what's "module" — classify every existing file
- Design module manifest format (module.yaml) — name, hooks, dependencies, interface
- Define lifecycle hook points (pre-plan, post-plan, pre-apply, pre-test, post-apply, pre-unify, post-unify)
- Design driver interface — what a platform adapter must implement
- Document the architecture (kernel, modules, drivers diagram)

**Plans:**
- [ ] 10-01: TBD (defined during /paul:plan)

### Phase 11: Kernel Extraction & Module Refactor

**Goal:** Extract PAUL core as the kernel, refactor CARL/TODD/WALT into self-contained modules
**Depends on:** Phase 10 (architecture designed)
**Research:** No

**Scope:**
- Extract kernel files — plan/apply/unify loop, state management, lifecycle hooks
- Remove hardcoded CARL/TODD/WALT references from kernel workflows
- Replace with hook-based invocation (no module = no-op)
- Create CARL module with module.yaml manifest
- Create TODD module with module.yaml manifest
- Create WALT module with module.yaml manifest
- Verify no regression — all existing functionality still works

**Plans:**
- [ ] 11-01: TBD (defined during /paul:plan)

### Phase 12: Module Manager & Installer

**Goal:** Module-aware installer with pals.yaml config and install/remove capabilities
**Depends on:** Phase 11 (modules exist)
**Research:** No

**Scope:**
- Design pals.yaml configuration format (active modules, settings)
- Refactor install.sh to be module-aware (install selected modules)
- Add module install/remove commands
- Module listing and status reporting
- Update uninstall.sh for modular cleanup

**Plans:**
- [ ] 12-01: TBD (defined during /paul:plan)

### Phase 13: Driver Architecture & Agent SDK Stub

**Goal:** Abstract platform interface, build Claude Code driver and Agent SDK proof-of-concept
**Depends on:** Phase 11 (kernel extracted)
**Research:** Yes (Agent SDK integration patterns)

**Scope:**
- Define driver interface contract (what a driver must implement)
- Extract Claude Code driver (rewire current slash commands + hooks as a driver)
- Build Agent SDK driver stub (load workflows as system prompts, file-based state)
- Prove kernel runs headless — same plan/apply/unify loop, no slash commands
- Document driver development guide for future platforms

**Plans:**
- [ ] 13-01: TBD (defined during /paul:plan)

---

## Phases (v0.3 — Complete)

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 8 | Smart Installer | 1 | Complete | 2026-03-11 |
| 9 | Auto Context Cycling | 1 | Complete (research only, impl deferred) | 2026-03-11 |

## Phases (v0.2 — Complete)

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 7 | Namespace & Cleanup | 1 | Complete | 2026-03-11 |

## Phases (v0.1 — Complete)

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 1 | Architecture & Design | 2 | Complete | 2026-03-11 |
| 2 | Fork & Restructure | 3 | Complete | 2026-03-11 |
| 3 | Merge TODD/WALT | 2 | Complete | 2026-03-11 |
| 4 | CARL Integration | 2 | Complete | 2026-03-11 |
| 5 | Install & Distribution | 2 | Complete | 2026-03-11 |
| 6 | End-to-End Validation | 1 | Complete | 2026-03-11 |

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-03-12 — Phase 11 complete*
