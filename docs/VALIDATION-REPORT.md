# PALS Cross-Harness Validation Report

> **Historical validation report.** This 2026-03-14 report is archival evidence only; its 45/45 count must not be used as current pass/fail proof. The current Phase 219 command baseline is Pi validation 201/201 and cross-harness validation 117/117. For current validation truth, run `bash tests/pi-end-to-end-validation.sh` and `bash tests/cross-harness-validation.sh`; use `docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md` for taxonomy and preservation rules.

**Date:** 2026-03-14
**Branch:** v2.0/portability-and-cross-harness
**Commit:** 98dce92
**Result:** ALL 45 CHECKS PASSED

---

## Summary

| Metric | Value |
|--------|-------|
| Total checks | 45 |
| Passed | 45 |
| Failed | 0 |
| Categories | 4 |

---

## Category 1: Installer Parity

Both Claude Code and Pi installers produce equivalent installations from the same repo.

| # | Check | Status | Detail |
|---|-------|--------|--------|
| 1 | Claude Code installer exits successfully | Pass | |
| 2 | Pi installer exits successfully | Pass | |
| 3 | Kernel file counts match | Pass | Both: 98 files |
| 4 | Kernel workflows count | Pass | Both: 24 files |
| 5 | Kernel references count | Pass | Both: 45 files |
| 6 | Kernel templates count | Pass | Both: 24 files |
| 7 | Kernel rules count | Pass | Both: 5 files |
| 8 | Both generate modules.yaml | Pass | |
| 9 | Module sets match | Pass | 9 modules each |

**Install paths:**
- Claude Code: `~/.pals/` (kernel) + `~/.claude/commands/` (commands) + `~/.claude/hooks/` (hooks)
- Pi: `~/.pi/agent/skills/pals/` (kernel + modules)

---

## Category 2: Portability Compliance

All kernel and module files use portable reference conventions — zero harness-specific patterns.

| # | Check | Status | Detail |
|---|-------|--------|--------|
| 10 | No `@~/` references in kernel | Pass | 0 occurrences |
| 11 | No `@.paul/` references in kernel | Pass | 0 occurrences |
| 12 | No `~/.pals/` hardcoded paths in kernel | Pass | 0 occurrences |
| 13 | No harness-specific tool language in kernel | Pass | 0 occurrences |
| 14 | No `@~/` references in modules | Pass | 0 occurrences |
| 15 | No `@.paul/` references in modules | Pass | 0 occurrences |
| 16 | No `~/.pals/` hardcoded paths in modules | Pass | 0 occurrences |

**Patterns checked:** `@~/`, `@.paul/`, `~/.pals/`, "Use the Read tool", "Use Bash to", "Use Grep to", "Use Edit to", "Use Write to", "Use the Glob"

---

## Category 3: Artifact Spec Compliance

Project artifacts in `.paul/` conform to ARTIFACT-SPEC.md required sections.

| # | Check | Status | Detail |
|---|-------|--------|--------|
| 17 | STATE.md exists | Pass | |
| 18 | STATE.md: Project Reference section | Pass | |
| 19 | STATE.md: Current Position section | Pass | |
| 20 | STATE.md: Loop Position section | Pass | |
| 21 | STATE.md: Accumulated Context section | Pass | |
| 22 | STATE.md: Session Continuity section | Pass | |
| 23 | PROJECT.md exists | Pass | |
| 24 | PROJECT.md: Description section | Pass | |
| 25 | PROJECT.md: Core Value section | Pass | |
| 26 | PROJECT.md: Requirements section | Pass | |
| 27 | ROADMAP.md exists | Pass | |
| 28 | ROADMAP.md: Overview section | Pass | |
| 29 | ROADMAP.md: Milestone sections | Pass | |
| 30 | ROADMAP.md: Phase table | Pass | |

---

## Category 4: Driver Manifests

Both drivers declare required capabilities per ADAPTER-CONTRACT.md.

| # | Check | Status | Detail |
|---|-------|--------|--------|
| 31 | claude-code: driver.yaml exists | Pass | |
| 32 | claude-code: workflow_invoke | Pass | true |
| 33 | claude-code: state_read | Pass | true |
| 34 | claude-code: state_write | Pass | true |
| 35 | claude-code: user_interact | Pass | true |
| 36 | claude-code: install.sh exists | Pass | |
| 37 | claude-code: uninstall.sh exists | Pass | |
| 38 | pi: driver.yaml exists | Pass | |
| 39 | pi: workflow_invoke | Pass | true |
| 40 | pi: state_read | Pass | true |
| 41 | pi: state_write | Pass | true |
| 42 | pi: user_interact | Pass | true |
| 43 | pi: install.sh exists | Pass | |
| 44 | pi: uninstall.sh exists | Pass | |
| 45 | Pi capability limitations documented | Pass | hook_register=false, command_register=false |

### Capability Matrix

| Capability | Claude Code | Pi |
|------------|:-----------:|:--:|
| workflow_invoke | true | true |
| hook_register | true | false |
| state_read | true | true |
| state_write | true | true |
| user_interact | true | true |
| command_register | true | false |

---

## Conclusion

**v2.0 Portability & Cross-Harness: VALIDATED**

The PALS framework produces identical kernel installations across both Claude Code and Pi adapters. All workflow and module files use portable reference conventions with zero harness-specific patterns. Project artifacts conform to the normative specifications. Both driver manifests correctly declare their capabilities with documented differences.

The same `.paul/` project can be driven by either harness adapter with full artifact parity, lifecycle fidelity, and module participation.

---

*Generated by: tests/cross-harness-validation.sh*
*Report created: 2026-03-14*
