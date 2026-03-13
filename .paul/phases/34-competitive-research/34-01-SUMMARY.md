---
phase: 34-competitive-research
plan: 01
subsystem: kernel
tags: [competitive-analysis, research, frameworks, agentic-coding, landscape, v1.0-planning]

requires: []
provides:
  - "Competitive analysis of 15 agentic coding frameworks"
  - "Gap analysis with severity and effort ratings"
  - "Differentiator map with leverage strategies"
  - "V1.0 feature recommendations with phase mapping"
affects:
  - v1.0 milestone planning
  - v0.9.2 milestone completion

tech-stack:
  added: []
  patterns: []

key-files:
  created: [".paul/phases/34-competitive-research/competitive-analysis.md"]
  modified: []

key-decisions:
  - "Decision: Brownfield support is #1 adoption barrier — must address in v1.0"
  - "Decision: Lightweight fix loop is critical — full PLAN-APPLY-UNIFY for 1-file bugs is friction"
  - "Decision: Do NOT build full autonomous execution, IDE plugins, LSP/AST tools, or 46+ hooks"
  - "Decision: Superpowers is closest competitor — PALS's UNIFY phase and module depth are key differentiators"

patterns-established:
  - "Pattern: Parallel subagent research for multi-topic investigation"

duration: ~15min
started: 2026-03-13T00:00:00Z
completed: 2026-03-13T00:15:00Z
---

# Phase 34 Plan 01: Competitive Research Summary

**Benchmarked PALS against 15 agentic coding frameworks — identified 3 critical gaps, 6 strong differentiators, and recommended 3-phase v1.0 roadmap.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~15min |
| Tasks | 2 completed |
| Files modified | 1 created |
| Frameworks researched | 15 |
| Research subagents | 5 (parallel batches of 3) |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Framework Coverage | Pass | All 15 frameworks profiled with 7 fields each |
| AC-2: Gap Analysis | Pass | 14 gaps identified across 3 severity tiers with effort estimates |
| AC-3: Differentiator Map | Pass | 6 strong + 3 at-risk differentiators with leverage strategies |
| AC-4: V1.0 Recommendations | Pass | 3 must-have, 2 should-have, 4 could-have, 6 do-not-build items with phase mapping |

## Accomplishments

- Profiled 15 frameworks: BMAD, OhMyOpenCode, Superpowers, OpenSpec, SpecKit, Aider, Cline, Continue.dev, SWE-agent, OpenHands, MetaGPT, GPT Pilot, Cursor rules, Mentat, Devin
- Identified Superpowers as closest architectural cousin (Markdown skills, TDD, contextual activation) — PALS differentiates with UNIFY phase, 9 modules, and session continuity
- Found 3 critical gaps: brownfield support, lightweight fix loop, fast-forward escape hatch
- Mapped 6 strong differentiators: UNIFY phase (unique), modular architecture, TDD enforcement, quality gating with regression detection, session continuity, named module personalities
- Recommended v1.0 phases: 35 (fix/hotfix), 36 (brownfield), 37 (resilience/isolation)
- Identified 6 "do NOT build" items to prevent over-engineering

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `.paul/phases/34-competitive-research/competitive-analysis.md` | Created | Comprehensive analysis: 15 profiles, gap analysis, differentiator map, v1.0 recommendations |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Brownfield is #1 adoption barrier | OpenSpec, Aider prove existing codebases are where real development happens | Must address in v1.0 Phase 36 |
| Lightweight fix loop is critical | Every competitor handles ad-hoc fixes; full loop for 1-file bugs is friction | Must address in v1.0 Phase 35 |
| Do NOT build autonomous execution | Devin's 15% success rate on ambiguous tasks proves this doesn't work yet | PALS's supervised approach is correct |
| Do NOT build IDE-specific integration | Would fragment focus; CLI-first via Claude Code is the right abstraction | Stay platform-agnostic via drivers |
| Superpowers is closest competitor | Similar philosophy but narrower scope | PALS differentiates with UNIFY, modules, session continuity |
| Rules without enforcement decay | Cursor rules' biggest weakness is being ignored; PALS enforces | Quality gating is PALS's strongest moat |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- Competitive analysis complete and actionable
- V1.0 phase mapping recommended (35, 36, 37)
- Clear priorities for milestone planning

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 34-competitive-research, Plan: 01*
*Completed: 2026-03-13*
