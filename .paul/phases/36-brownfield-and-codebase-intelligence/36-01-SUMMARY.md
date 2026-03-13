---
phase: 36-brownfield-and-codebase-intelligence
plan: 01
subsystem: kernel
tags: [brownfield, codebase-intelligence, reference-graph, onboarding, map-codebase, existing-project, adoption]

requires:
  - phase: 34-competitive-research
    provides: brownfield gap analysis identifying #1 adoption barrier + Aider/OpenSpec insights

provides:
  - Brownfield detection in init-project.md (detect_existing_code + populate_from_codebase steps)
  - map-codebase v2 with Agent 5 (reference graph) and GRAPH.md output
  - Brownfield context enrichment in Agent 2 (architecture) and Agent 3 (conventions)
  - Post-map routing (context-aware next action)
  - brownfield-onboarding.md reference guide (3-step adoption process)

affects:
  - future brownfield adoption workflows
  - init-project user experience for existing codebases
  - planning context quality (GRAPH.md hub files inform milestone scoping)

tech-stack:
  added: []
  patterns:
    - "Brownfield detection: check for project indicators (package.json, src/, etc.) before init"
    - "Reference graph via Explore agent: hub files, entry points, clusters — no tree-sitter needed"
    - "Post-map routing: context-aware next action based on .paul/ existence"
    - "Brownfield Quick Start subsections: patterns-to-preserve in ARCHITECTURE.md, style-rules in CONVENTIONS.md"

key-files:
  created:
    - kernel/references/brownfield-onboarding.md
  modified:
    - kernel/workflows/init-project.md
    - kernel/workflows/map-codebase.md
    - kernel/commands/paul/map-codebase.md

key-decisions:
  - "Decision: Brownfield = AI-directed analysis via Explore agents, not automated tooling"
  - "Decision: Reference graph built by Agent 5 at runtime, not a persistent tool or tree-sitter"
  - "Decision: GRAPH.md is a new 8th document alongside existing 7 (additive, not replacing)"
  - "Decision: Init brownfield detection is an additional branch, not a replacement for greenfield flow"

patterns-established:
  - "Pattern: Brownfield detection via project indicator files before init setup"
  - "Pattern: Agent-based reference graph analysis (hub files, clusters) for codebase intelligence"
  - "Pattern: Post-map routing based on project state (.paul/ existence)"

duration: ~20min
started: 2026-03-13T21:00:00Z
completed: 2026-03-13T21:20:00Z
---

# Phase 36 Plan 01: Brownfield & Codebase Intelligence Summary

**Brownfield adoption path for existing codebases — init detection, map-codebase v2 with reference graph (GRAPH.md), and 3-step onboarding guide closing the #1 adoption barrier.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~20min |
| Tasks | 3 completed |
| Files created | 1 |
| Files modified | 3 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Brownfield Detection in Init | Pass | detect_existing_code step checks for project indicators, routes to map-codebase |
| AC-2: Map-Codebase v2 Reference Graph | Pass | Agent 5 builds reference graph, GRAPH.md with hub files, entry points, edges, clusters |
| AC-3: Map-Codebase v2 Brownfield Context | Pass | Brownfield Quick Start in ARCHITECTURE.md + CONVENTIONS.md, post-map routing |
| AC-4: Brownfield Onboarding Reference | Pass | 120-line guide with 3-step process, boundaries, scoping, 4 scenarios |

## Accomplishments

- Added brownfield detection to init — detects existing code (package.json, src/, etc.) and offers codebase mapping before setup
- Upgraded map-codebase to v2 with Agent 5 (reference graph) producing GRAPH.md with hub files, entry points, reference edges, and clusters
- Enriched Agent 2 and Agent 3 with brownfield context extraction (patterns-to-preserve, style-rules)
- Created brownfield onboarding reference guide covering monorepo, legacy, mid-project, and team adoption scenarios

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `kernel/references/brownfield-onboarding.md` | Created | 3-step adoption guide (map → init → plan) with boundary-setting, scoping, and 4 common scenarios |
| `kernel/workflows/init-project.md` | Modified | Added detect_existing_code step (brownfield detection) and populate_from_codebase step (pre-populate PROJECT.md from codebase map) |
| `kernel/workflows/map-codebase.md` | Modified | Added Agent 5 (reference graph), GRAPH.md output, brownfield enrichment for Agents 2+3, post-map routing |
| `kernel/commands/paul/map-codebase.md` | Modified | Updated command docs: 5 agents, 8 documents, post-map routing |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| AI-directed analysis, not automated tooling | Follows OpenSpec pattern; PALS is markdown-based, not a Python tool | No new dependencies; Explore agents handle all analysis at runtime |
| Reference graph via Agent 5, not tree-sitter | Aider's core value is the weighted graph, not tree-sitter specifically; PALS can achieve similar insight via import scanning | Future upgrade path exists if tree-sitter integration ever makes sense |
| GRAPH.md as 8th document (additive) | Existing 7 documents and templates unchanged | Zero regression risk; GRAPH.md adds value without breaking existing workflows |
| Brownfield detection as branch, not replacement | Greenfield flow must remain untouched for new projects | Both paths work; brownfield is opt-in via detection |

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- Brownfield adoption path complete — existing codebases can now be onboarded
- map-codebase v2 provides actionable codebase intelligence (hub files, clusters)
- Phase 37 (Resilience & Isolation) can proceed independently

**Concerns:**
- None

**Blockers:**
- None

---
*Phase: 36-brownfield-and-codebase-intelligence, Plan: 01*
*Completed: 2026-03-13*
