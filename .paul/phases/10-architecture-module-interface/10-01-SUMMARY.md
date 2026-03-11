---
phase: 10-architecture-module-interface
plan: 01
subsystem: architecture
tags: [kernel, modules, drivers, lifecycle-hooks, module-manifest]

requires:
  - phase: v0.3
    provides: Complete PALS framework (monolithic) to kernelize
provides:
  - Kernel/module/driver architecture specification
  - File classification (kernel vs module vs shared)
  - Module manifest format (module.yaml)
  - Lifecycle hook contract (8 hook points)
  - Driver interface contract (5 methods)
affects: [phase-11-kernel-extraction, phase-12-module-manager, phase-13-driver-architecture]

tech-stack:
  added: []
  patterns: [kernel-module-driver layering, lifecycle hooks, module manifests]

key-files:
  created: [docs/ARCHITECTURE.md, docs/MODULE-SPEC.md, docs/DRIVER-SPEC.md, docs/KERNEL-MANIFEST.md]
  modified: []

key-decisions:
  - "Delegated workflows stay in kernel (kernel-utils) — only named pals become modules"
  - "8 lifecycle hook points: pre-plan, post-plan, pre-apply, pre-test, post-task, post-apply, pre-unify, post-unify"
  - "5 driver methods: workflow_invoke, hook_register, state_read/write, user_interact, command_register"
  - "CARL hooks via platform-level hook (UserPromptSubmit), not PAUL lifecycle hooks"

patterns-established:
  - "Three-layer stack: Modules → Kernel → Drivers"
  - "Kernel never references modules by name; modules never reference drivers"
  - "Missing module = no-op, never error"
  - "Hook priority ordering: lower number = earlier execution"

duration: ~30min
started: 2026-03-11
completed: 2026-03-11
---

# Phase 10 Plan 01: Architecture & Module Interface Summary

**Designed the PALS kernel/module/driver architecture — 4 specification documents defining boundaries, contracts, and the three-layer stack.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~30min |
| Tasks | 4 completed (including 1 decision checkpoint) |
| Files created | 4 |
| Files modified | 0 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Kernel Boundary Defined | Pass | 78 files classified across kernel (48), TODD (5), WALT (7), CARL (13), shared (5) |
| AC-2: Module Manifest Format Specified | Pass | module.yaml format with identity, hooks, deps, files, commands; example manifests for all 3 modules |
| AC-3: Lifecycle Hook Points Defined | Pass | 8 hooks with trigger timing, payload schema, return contract, priority ordering |
| AC-4: Driver Interface Specified | Pass | 5 methods with Claude Code and Agent SDK mappings; driver.yaml manifest format |

## Quality

Not tracked — no test runner (research/design plan, no code changes).

## Accomplishments

- Classified every framework file into kernel/module/shared categories with clean boundaries
- Designed module.yaml manifest format that can describe CARL, TODD, WALT, and future modules
- Defined 8 lifecycle hook points with composition rules (priority, short-circuit, data passing)
- Specified platform-agnostic driver interface with concrete mappings for Claude Code and Agent SDK
- Resolved architectural decision: delegated workflows stay in kernel (fork kernel for different tools, modules for optional pals)

## Files Created

| File | Purpose |
|------|---------|
| `docs/KERNEL-MANIFEST.md` | Classification of all 78 framework files as kernel/module/shared |
| `docs/MODULE-SPEC.md` | Module manifest format, lifecycle hooks, composition rules, example manifests |
| `docs/DRIVER-SPEC.md` | Driver interface contract (5 methods), driver.yaml format, development guide |
| `docs/ARCHITECTURE.md` | System overview, three-layer diagram, invocation flows, filesystem layout |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Delegated workflows in kernel | Only named pals become modules; fork kernel for different tools | Kernel is ~48 files, not minimal but practical |
| CARL uses platform hook, not lifecycle hook | CARL runs on every prompt (UserPromptSubmit), not tied to plan/apply/unify loop | CARL module has `platform.claude_code.hooks` section in manifest |
| Hook priority ranges: 50-99 enforcement, 100-199 standard, 200+ advisory | Convention prevents priority collisions between modules | TODD=50-range, WALT=100-range by default |

## Deviations from Plan

None — plan executed exactly as written.

## Next Phase Readiness

**Ready:**
- Architecture specs provide clear implementation targets for Phase 11
- Module manifests can be written directly from MODULE-SPEC.md
- Kernel extraction can follow KERNEL-MANIFEST.md classifications

**Concerns:**
- ci-generation.md and sonarqube-integration.md are unclassified (flagged as future module candidates)
- plan-phase-tdd.md referenced but may need extraction as standalone file during Phase 11

**Blockers:**
- None

---
*Phase: 10-architecture-module-interface, Plan: 01*
*Completed: 2026-03-11*
