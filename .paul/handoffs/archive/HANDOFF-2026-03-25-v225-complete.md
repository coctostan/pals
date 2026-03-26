# PAUL Handoff

**Date:** 2026-03-25
**Status:** milestone boundary — v2.25 complete, no active milestone

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** pals — PALS Project Automation & Lifecycle System
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

---

## Current State

| Field | Value |
|-------|-------|
| Milestone | None active (v2.25 just completed) |
| Phase | None |
| Plan | None |
| Loop | ○ ○ ○ (ready for next milestone) |
| Branch | main |
| Working tree | clean |

---

## What Was Done This Session

### v2.25 E2E Adversarial Testing (COMPLETE)

Tested PALS across 3 models, 2 projects (brownfield + greenfield), 3 scenarios:

**Phase 129 — Adversarial Testing (kimi K2.5 + sonnet 4.6):**
- Adversarial bait code on pi-verify to trigger all 18 modules
- Kimi: 71% workflow, 12% dispatch, 0% quality (documents modules, doesn't execute them)
- Sonnet: 100% workflow, 100% dispatch, 94% quality (runs actual shell commands)
- DEAN blocked plan creation with real CVE detection (sonnet)

**Phase 130 — Real-User Dev (GPT-5.4):**
- Cleanup loop: removed bait files from pi-verify
- Feature loop: built /verify diff command (67→70 tests)
- GPT-5.4: 86% workflow, 70% dispatch, 65% quality
- TODD shaped test coverage, RUBY shaped plan scope — genuine dev value

**Phase 131 — Greenfield (GPT-5.4):**
- Built pi-bench (LLM benchmarking Pi extension) from scratch
- 2 PAUL loops: v0.1 /bench command + v0.2 history/formatting (12 tests)
- GPT-5.4 greenfield: 92% workflow, 75% dispatch, 80% quality (better than brownfield)
- **Greenfield init audit:** 7 unnecessary questions, 8 recommendations
- CARL fired correctly at phase boundary

---

## Actionable Items (13 total)

**Detailed in:** `.paul/references/v225-actionable-items.md`

| # | Item | Priority | Milestone |
|---|------|----------|-----------|
| 1 | Module instruction wording audit (imperative phrasing) | High | v2.27 |
| 2 | Post-apply dispatch enforcement | High | v2.27 |
| 3 | DEAN "remember baseline" mechanism | Medium | v2.28 |
| 4 | Post-unify hook enforcement | Medium | v2.27 |
| 5 | GitHub Flow merge gate hardening | Medium | v2.27 |
| 6 | Smart question gating in init | High | v2.26 |
| 7 | Brownfield detection threshold fix | High | v2.26 |
| 8 | Reduce greenfield to ~8 questions | High | v2.26 |
| 9 | Explicit first milestone in init | Medium | v2.26 |
| 10 | Module explanations during init | Low | v2.26 |
| 11 | Conditional git automation questions | High | v2.26 |
| 12 | Remove "specialized skills" from init | Low | v2.26 |
| 13 | `/paul:init --quick` mode | Low | v2.26 |

---

## What's Next

**Immediate:** `/paul:discuss-milestone` or `/paul:milestone`

Likely next: **v2.26 Init/Onboarding Overhaul** (Items 6-13 from actionable items)

---

## Key Files

| File | Purpose |
|------|---------|
| .paul/STATE.md | Live project state |
| .paul/ROADMAP.md | Phase overview |
| .paul/MILESTONES.md | Completed milestone log |
| .paul/references/v225-actionable-items.md | 13 actionable items with evidence + milestone mapping |

---

## Resume Instructions

1. Read `.paul/STATE.md` for latest position
2. Read `.paul/references/v225-actionable-items.md` for next milestone context
3. Run `/paul:resume`

---

*Handoff created: 2026-03-25*
