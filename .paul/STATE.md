# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-03-14)

**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** Awaiting next milestone

## Current Position

Milestone: Awaiting next milestone
Phase: None active
Plan: None
Status: Milestone v2.0 complete — ready for next
Last activity: 2026-03-14 — v2.0 Portability & Cross-Harness milestone completed

Progress:
- v2.0 Portability & Cross-Harness: [██████████] 100% ✓

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ○        ○        ○     [Milestone complete - ready for next]
```

## Accumulated Context

### Decisions
| Decision | Phase | Impact |
|----------|-------|--------|
| Adopt clarity test from Superpowers | 38 | validate_plan checks "could someone with no context execute this?" |
| Adopt dual-goal emphasis from GPT Pilot | 38 | verify=programmatic, done=human-reviewable made explicit |
| Adopt complexity gating from GPT Pilot | 38 | analyze_scope scales plan depth to change size |
| Adapt read-only planning from OpenHands | 38 | plan phase cannot modify source files |
| Reject schema-as-workflow, PageRank, multi-model, tool restriction | 38 | Contradict PALS simplicity or not applicable |
| Defer re-plan protocol to Phase 39 | 38 | Belongs in execution scope |
| Adopt stuck detection, deviation notification, revert-and-refine | 39 | Best execution techniques from 12 frameworks |
| Adapt bounded retries, structured status, re-plan protocol | 39 | Lighter versions of Aider/Superpowers patterns |
| Reject 6 execution techniques | 39 | Handled by host tool or existing PALS mechanisms |
| Adopt anti-pattern injection, failure classification, contract guard | 40 | Best testing techniques from 12 frameworks into TODD |
| Adapt test output reflection, structural coverage, quality heuristics | 40 | Lighter versions of Aider/Continue.dev/BMAD patterns |
| Reject 10 testing techniques | 40 | Multi-agent, IDE-specific, or already adopted |
| Adopt 3-tier severity, failure-to-context, advisory mode, zero-regression rate | 41 | Best quality techniques from 12 frameworks into WALT |
| Adapt small-change exemption, diff-based guidance, event-tagged history, scoped validation | 41 | Lighter versions of SonarQube/reviewdog/lint-staged patterns |
| Reject 10 quality techniques | 41 | Agent domain, over-engineering, or existing mechanisms |
| Adopt retrospective artifacts, offline changes detection, knowledge quality feedback | 42 | Best techniques from Devin/GPT Pilot into UNIFY and resume workflows |
| Adapt context assembly pipeline, interrupted-action recovery, file staleness tracking, convention capture, structured onboarding | 42 | Lighter versions of Windsurf/MetaGPT/Cline/Devin/Cursor patterns |
| Reject 11 techniques (condenser, dual-state, shadow git, autonomous memory, etc.) | 42 | Requires programmatic infrastructure or redundant with existing PALS/Claude Code mechanisms |
| Defer tree-sitter+PageRank repo-map and LSP-powered analysis | 42 | High value but requires programmatic implementation beyond PALS scope |
| Install for ALL detected harnesses (not pick one) | 47 | Both ~/.claude/ and ~/.pi/ get drivers; no prompt needed, no conflict |

### Deferred Issues
- ci-generation.md and sonarqube-integration.md — future module candidates
- Agent SDK hook dispatch not implemented
- Tree-sitter repo map deferred
- AGENTS.md deferred to interoperability milestone
- Multi-model routing: implemented in Phase 43 — pals.json `agents` section, agent-dispatch.md reference, apply-phase dispatch logic

### Blockers/Concerns
- None active

### Git State
Branch: main
PR: #7 merged (v1.1+v1.2 milestones)

## Session Continuity

Last session: 2026-03-14
Stopped at: v2.0 Portability & Cross-Harness milestone complete
Next action: /paul:discuss-milestone or /paul:milestone
Resume file: .paul/MILESTONES.md
Resume context:
- v2.0 complete: portable specs, harness-agnostic kernel, Pi adapter, cross-harness validation
- 14 milestones completed total (v0.1 through v2.0)
- 48 phases, 60+ plans completed

---
*STATE.md — Updated after every significant action*
