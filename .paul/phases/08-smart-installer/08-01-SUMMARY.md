---
phase: 08-smart-installer
plan: 01
subsystem: infra
tags: [bash, installer, migration, legacy-cleanup]

requires:
  - phase: 07-namespace-cleanup
    provides: standardized /paul:* namespace, clean install/uninstall scripts
provides:
  - upgrade-aware install.sh with legacy detection
  - uninstall.sh with legacy cleanup
affects: []

tech-stack:
  added: []
  patterns: [interactive-prompt-with-tty-fallback]

key-files:
  created: []
  modified: [install.sh, uninstall.sh]

key-decisions:
  - "Interactive prompt (y/N) for legacy cleanup during install — safe default"
  - "No prompt during uninstall — already a destructive user-initiated action"

patterns-established:
  - "Legacy detection pattern: check dir, prompt, clean"

duration: ~5min
started: 2026-03-11
completed: 2026-03-11
---

# Phase 8 Plan 01: Upgrade-Aware Installer Summary

**install.sh now detects legacy ~/.claude/paul-framework/ and offers cleanup; uninstall.sh auto-removes it.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~5min |
| Started | 2026-03-11 |
| Completed | 2026-03-11 |
| Tasks | 2 completed |
| Files modified | 2 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Legacy Detection | Pass | install.sh checks for ~/.claude/paul-framework/ |
| AC-2: Legacy Cleanup on Install | Pass | Interactive y/N prompt, removes on confirmation |
| AC-3: Clean Install Unaffected | Pass | No legacy output when dir absent |
| AC-4: Uninstaller Handles Legacy | Pass | Auto-removes without prompt |

## Quality

Quality: not tracked (no test runner detected — shell scripts)

## Accomplishments

- install.sh detects legacy ~/.claude/paul-framework/ and prompts for removal with safe default (N)
- uninstall.sh auto-removes legacy directory alongside existing stale namespace cleanup
- Both scripts pass bash -n syntax validation

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `install.sh` | Modified | Added step 0: legacy detection with interactive prompt |
| `uninstall.sh` | Modified | Added step 2b: legacy paul-framework cleanup |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Interactive y/N prompt (default No) | Safe default prevents accidental deletion | Users must explicitly confirm legacy removal |
| Read from /dev/tty | Supports piped install scenarios | Works with curl-pipe-bash pattern |
| No prompt in uninstall | Uninstall is already user-initiated destructive action | Simpler UX, consistent with existing cleanup |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- Phase 8 complete — installer is now upgrade-aware
- Clean foundation for Phase 9 (Auto Context Cycling)

**Concerns:**
- Phase 9 requires research on programmatic /clear mechanism

**Blockers:**
- None

---
*Phase: 08-smart-installer, Plan: 01*
*Completed: 2026-03-11*
