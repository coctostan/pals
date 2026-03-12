---
phase: 13-driver-architecture
plan: 01
subsystem: infra
tags: [driver, claude-code, installer, architecture]

requires:
  - phase: 12-module-manager
    provides: module-aware install.sh, modules.yaml, pals.yaml, module manifests
provides:
  - drivers/claude-code/ directory with driver.yaml, install.sh, uninstall.sh
  - Root install.sh refactored to kernel + driver delegation pattern
  - Root uninstall.sh refactored to driver teardown + kernel cleanup
affects: [13-driver-architecture (plan 02 — agent-sdk stub)]

tech-stack:
  added: []
  patterns: [driver-delegation-at-install-time, driver-detection-order]

key-files:
  created: [drivers/claude-code/driver.yaml, drivers/claude-code/install.sh, drivers/claude-code/uninstall.sh]
  modified: [install.sh, uninstall.sh]

key-decisions:
  - "Claude Code driver is install-time wiring, not runtime code — the LLM IS the runtime driver"
  - "Driver detection order: PALS_DRIVER env > ~/.claude/ presence > ANTHROPIC_AGENT_SDK env > claude-code default"
  - "YAML parser stays with driver installer (not extracted to shared lib)"

patterns-established:
  - "Driver directory structure: drivers/{name}/driver.yaml + install.sh + uninstall.sh"
  - "Root installer delegates platform-specific setup to detected driver"
  - "Driver-specific validation in root installer (conditional check_path)"

duration: ~10min
completed: 2026-03-12
---

# Phase 13 Plan 01: Extract Claude Code Driver Summary

**Extracted Claude Code platform logic from monolithic install.sh into `drivers/claude-code/` directory, refactored root installer to kernel install + driver delegation.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~10min |
| Completed | 2026-03-12 |
| Tasks | 2 completed |
| Files modified | 5 (3 created, 2 rewritten) |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Claude Code Driver Directory | Pass | driver.yaml with all 5 capabilities true, install.sh and uninstall.sh present |
| AC-2: Root Install Delegates to Driver | Pass | Kernel files to ~/.pals/, then driver installer runs; identical end result |
| AC-3: Root Uninstall Delegates to Driver | Pass | Driver uninstaller removes ~/.claude/ artifacts, root removes ~/.pals/ |

## Module Execution Reports

No modules contributed annotations — infrastructure-only changes.

## Accomplishments

- Created `drivers/claude-code/` with driver.yaml manifest declaring all 5 capabilities
- Extracted all Claude Code-specific logic (commands, hooks, settings.json, modules.yaml) into driver installer
- Root install.sh now: validates repo → installs kernel → detects driver → delegates
- Root uninstall.sh now: detects driver → delegates teardown → removes kernel
- Verified end-to-end: `./install.sh` produces identical installed artifacts as before

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| drivers/claude-code/driver.yaml | Created | Driver capabilities manifest (5 methods, all true) |
| drivers/claude-code/install.sh | Created | Claude Code platform setup (commands, hooks, settings.json, modules.yaml) |
| drivers/claude-code/uninstall.sh | Created | Claude Code platform teardown (remove ~/.claude/ artifacts) |
| install.sh | Rewritten | Kernel install + driver detection + delegation |
| uninstall.sh | Rewritten | Driver teardown delegation + kernel cleanup |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| /dev/tty not available in sandbox for legacy cleanup prompt | Non-blocking — defaults to "n" (skip), same as before |

## Next Phase Readiness

**Ready:**
- `drivers/` directory structure established — Agent SDK stub adds `drivers/agent-sdk/`
- Driver detection logic in root install.sh already handles `ANTHROPIC_AGENT_SDK` env var
- DRIVER-SPEC.md + DISCOVERY.md provide complete Agent SDK integration blueprint

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 13-driver-architecture, Plan: 01*
*Completed: 2026-03-12*
