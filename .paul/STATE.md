# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-03-18)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** Phase 69 planning is next — execution proof first, visibility UX second
## Current Position
Milestone: v2.7 Module Reality Check & Visibility
Phase: 69 of 4 (Gap Fixes) — Ready to plan
Plan: Not started
Status: Ready to plan
Last activity: 2026-03-18T01:09:28Z — Phase 68 complete, transitioned to Phase 69 planning
Progress:
- v2.7 Module Reality Check & Visibility: [███░░░░░░░] 25%
- Phase 69: [░░░░░░░░░░] 0% (planning not started)
## Loop Position
Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ✓     [Loop complete - ready for next PLAN]
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
| Pi port is artifact-safe and directionally correct as a thin adapter shell | 53 | Confirms later Pi work should refine native fit without abandoning shared markdown artifacts |
| Future Pi work should focus on deeper native runtime/UI usage, not adapter replacement | 53 | Frames Phase 54 around gap analysis and Phase 55 around compatible recommendations |
| PALS needs a more mature Pi-native shell around the existing artifact-safe architecture, not a Pi-specific redesign | 54 | Keeps Phase 55 focused on recommendations that deepen native fit without changing core workflow truth |
| Prioritize context injection, command ergonomics, and lifecycle visibility as the highest-value Pi improvement areas | 54 | Gives the recommendation phase a clear ranking frame for roadmap shaping |
| v2.3 should focus first on interaction model refinement: context strategy, command discoverability, and adapter consistency | 55 | Establishes the concrete next milestone direction after v2.2 closeout |
| Rank Pi improvements by user value, risk, and compatibility posture instead of treating all ideas equally | 55 | Creates the roadmap structure for safe-now, careful-layering, and future-state work |
| Prefer a hybrid Pi event model over a single-hook redesign | 56 | Clarifies responsibility split across orientation, activation, and injection without creating Pi-only truth |
| Make `before_agent_start` the primary workflow-context decision point | 56 | Gives later implementation work a stronger timing boundary than the regex-driven `context` hook |
| Reduce `context` to a narrow supporting role while keeping `.paul/*` authoritative | 56 | Preserves artifact-first lifecycle truth while still allowing targeted prompt shaping |
| Reuse one shared lifecycle snapshot for Pi notifications, status, widget, and injected context | 59 | Keeps Pi lifecycle semantics aligned across all visible adapter surfaces |
| Keep Pi quick actions bounded and route shortcut entry points through the existing wrapper layer | 60 | Preserves low-clutter UX while avoiding Pi-only workflow semantics or duplicate routing logic |
| 2026-03-16: Treated TODD/WALT as installed Pi module overlays via modules.yaml and workflow dispatch rather than standalone skills during APPLY | 61 | Resolved first Pi end-to-end execution ambiguity without changing canonical workflow ownership |
| 2026-03-16: Implemented Phase 62 hybrid runtime refinement with explicit command activation budgeting, `before_agent_start` primary injection, and `context` normalization-only support | 62 | Preserves one bounded automatic injection path while keeping `.paul/*` as authoritative lifecycle truth |
| 2026-03-16: Keep Pi guided workflow UX marker-driven and route explicit continuations through `pi.sendUserMessage` without adding Pi-owned lifecycle state | 63 | Preserves shared workflow ownership while making approvals, checkpoints, resume routing, and transitions easier inside Pi |
| 2026-03-16: Use `matchAll(/[✓○]/g)` count for loop badge; "success" notify only for confirmed sends/routes | 64 | Keeps UX enrichment simple, robust, and bounded to additive cosmetic changes without regression risk |
| 2026-03-17: Keep artifact-first shared markdown workflows as lifecycle truth while improving collaborative definition behavior | 65 | Keeps v2.6 focused on workflow semantics and artifact population rather than architectural replacement |
| 2026-03-17: Add low/medium/high collaboration levels plus project default and per-run override for planning work | 65 | Establishes the bounded collaboration model for upcoming implementation phases |
| 2026-03-17: Add a 4-option pre-plan review choice (quick recap, detailed recap, full plan, no review needed) | 65 | Introduces progressive disclosure before APPLY without changing execution-loop semantics |
| 2026-03-17: Keep planning collaboration shared-workflow driven via `pals.json` `planning.default_collaboration` plus per-run overrides | 66 | Preserves artifact-first portability while making init/discuss/milestone/plan behavior more collaborative |
| 2026-03-17: Extend Pi guided workflow UX to surface the 4-option review menu without introducing Pi-owned workflow state | 66 | Keeps Pi additive-only while supporting the shared planning review flow |
| 2026-03-17: Split Phase 67 into a research-first plan before implementation | 67 | Settles the artifact/content/read model before workflow/template changes land |
| 2026-03-17: Greenfield and brownfield onboarding should converge to the same durable schema with different intake flows | 67 | Preserves one canonical product/project structure without forcing identical discovery behavior |
| 2026-03-17: Decide content model and read model before choosing whether PROJECT.md and PRD depth should be one or two documents | 67 | Keeps context cost explicit and avoids prematurely locking in the wrong durable artifact layout |
| 2026-03-17: Adopt a layered durable artifact model with compact `PROJECT.md` hot-path context plus selectively-read `PRD.md` depth | 67 | Settles the Phase 67 content/read/file model so the follow-on implementation plan can update onboarding, templates, docs, and validation without reopening the design question |
| 2026-03-17: Keep `PRD.md` additive and legacy-safe rather than mandatory for existing repos | 67 | Allows docs and validation to adopt the layered model without destructive migration |
| 2026-03-17: Complete the layered onboarding/artifact rollout across workflows, templates, docs, and validation | 67 | Finishes v2.6 with shared portable `PROJECT.md` + `PRD.md` behavior |
| 2026-03-18: Treat the module system as more wired than visible; source-vs-installed drift is not the main problem | 68 | Keeps follow-on work focused on proof/reporting and UX rather than phantom registry fixes |
| 2026-03-18: Prioritize execution-proof fixes before visibility UX | 68 | Sets Phase 69 on durable evidence/reporting and Phase 70 on presentation |
### Fixes
| Fix | Phase | Impact |
|-----|-------|--------|
| Fix 02 (standard): Reworked installed module registries to include `hook_details`, aligned PLAN/APPLY/UNIFY dispatch wording to the installed registry, and added validation coverage | Phase 63 | Enabled modules can now be consulted from real installed `modules.yaml` registries instead of relying on conceptual source-manifest access |
| Fix 03 (standard): Aligned resume handoff discovery and docs so `/paul:resume` falls back to `.paul/handoffs/archive/` and only archives active consumed handoffs | No phase | Prevents the latest archived handoff from becoming undiscoverable during normal resume flows |
### Deviations
| Deviation | Phase | Impact |
|-----------|-------|--------|
| None material | 66 | Phase executed as planned; unrelated working tree changes outside scope were left untouched |
| None material | 67 | Phase executed as planned; unrelated working tree changes outside scope were left untouched |
| None material | 68 | Phase executed as planned; audit stayed within `.paul/` artifacts and produced the requested evidence package |
### Deferred Issues
- ci-generation.md and sonarqube-integration.md — future module candidates
- Agent SDK hook dispatch shelved — not an active milestone driver
- Tree-sitter repo map deferred
- AGENTS.md deferred to interoperability milestone
- Multi-model routing: implemented in Phase 43 — pals.json `agents` section, agent-dispatch.md reference, apply-phase dispatch logic
### Blockers/Concerns
- Phase 68: Live Pi lifecycle surfaces remain module-opaque; address in Phase 70
- Phase 68: Post-unify module outputs lack a proven durable SUMMARY path; address in Phase 69
### Git State
Branch: feature/69-gap-fixes
Last commit: HEAD (WIP pause commit on feature/69-gap-fixes)
Feature branches merged: PR #15 and PR #16 merged to main; feature/69-gap-fixes recreated locally for Phase 69 planning pause
Remote status: origin configured; feature/69-gap-fixes not yet pushed
## Session Continuity
Last session: 2026-03-17T22:32:40-0400
Stopped at: Paused on synced main after PR #16 merge and feature-branch cleanup
Next action: /skill:paul-plan for Phase 69 (Gap Fixes)
Resume file: .paul/HANDOFF-2026-03-17-phase69-ready-main-synced.md
Git strategy: feature-per-phase (currently on feature/69-gap-fixes)
Resume context:
- Phase 68 is fully complete and summarized in `.paul/phases/68-execution-audit/68-01-SUMMARY.md`
- Local main is synced to merge commit `a0aa5df`; `feature/69-gap-fixes` is deleted locally and remotely
- Phase 69 should focus on durable module execution evidence, especially the post-unify reporting gap
- Phase 70 should make that proven evidence visible in live UX and end reporting
---
*STATE.md — Updated after every significant action*
