# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-03-25)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.33 Code Review Module (REV)
## Current Position
Milestone: v2.33 Code Review Module (REV)
Phase: 152 of 3 (Core Implementation) — Planning
Plan: 152-02 created, awaiting approval
Status: PLAN created, ready for APPLY
Last activity: 2026-03-27 — Created 152-02-PLAN.md
Progress:
- v2.33 Code Review Module (REV): [███░░░░░░░] 33%
- Phase 152: [█████░░░░░] 50%
## Loop Position
Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ○        ○     [Plan created, awaiting approval]
```

## Accumulated Context
### Decisions
| Decision | Phase | Impact |
|----------|-------|--------|
| Module dispatch quality is model-dependent — sonnet executes module instructions as commands, kimi documents them as expectations | 129 | Future module wording may need more imperative phrasing; module value proposition depends on model capability |
| Fix installer >- block scalar parser rather than rewriting descriptions | 109 | All modules with multi-line descriptions now install correctly; root cause of many v2.18 grades being lower than expected |
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
| 2026-03-18: Finalize summary evidence after post-unify instead of treating the first SUMMARY write as final | 69 | Gives post-unify-capable modules a durable report path in both UNIFY and standard fix loops |
| 2026-03-18: Use `module_reports` for persisted post-unify summary content and `side_effects` for non-blocking follow-on actions | 69 | Aligns workflows, specs, overlays, and validation around one durable reporting contract |
| 2026-03-18: Derive live module visibility from recent shared workflow/reporting signals rather than registry presence alone | 70 | Keeps Pi module visibility trustworthy without inventing a second execution ledger |
| 2026-03-18: Reuse existing Pi status/widget surfaces for recent module activity instead of adding new dashboards or telemetry | 70 | Delivers bounded visibility with additive adapter-only UX |
| 2026-03-18: Treat `Module Execution Reports` as a bounded fallback alongside recent `[dispatch]` output for live visibility | 70 | Keeps post-unify-visible module activity legible without Pi-owned persistence |
| 2026-03-18: Keep the module roster and improve legibility before considering merge/remove changes | 71 | Future work should refine recommendation/report clarity rather than destabilize module boundaries |
| 2026-03-18: Standardize a layered proof model across dispatch trace, durable reports, side effects, validation, and bounded Pi live visibility | 71 | Preserves artifact-first truth while making module participation legible without telemetry or Pi-owned execution state |
| All three CARL-critical Pi APIs work as documented; no design changes needed | 76 | Phase 77 can proceed with carl-pi-design.md architecture unchanged |
| 40% continue_threshold and 80% safety_ceiling are reasonable defaults | 76 | pals.json carl config uses these as defaults |
| Stashed command context lifetime across agent_end needs Phase 77 validation | 76 | Early Phase 77 task must test stashing across event handler boundaries |
| CARL logic inside palsHooks() closure, not a separate module | 77 | Self-contained; shares pi/activation/guided-workflow state |
| Loop signature change detection for phase-completion sensing | 77 | Prevents false positives from repeated agent_end calls |
| session_start seeds previousLoopSignature to avoid spurious session creation | 77 | Prevents CARL from misreading already-complete loop state on resume |
| CARL config fields inside modules.carl in pals.json | 78 | Consistent with existing module pattern; loadCarlConfig reads this path |
| CARL module version bumped to 2.0.0 | 78 | Clear signal of architectural shift from rule injection to session boundary |
| Add optional token-based CARL thresholds alongside ratio fallbacks | No phase | Keeps phase-boundary and safety rollover practical on 1M-context models without breaking existing configs |
| D1: Merge gate lives in unify-phase, not transition-phase | 84 | Phase 85 implementation targets unify-phase for the gate |
| D2: PR created after APPLY, merge state checked in UNIFY | 84 | Matches real GitHub Flow timing |
| D3: CI failure is blocking in github-flow mode (no escape) | 84 | Strict mode means strict; escape is ci_checks:false or workflow:legacy |
| D4: Branch naming stays feature/{phase-name} | 84 | No changes needed |
| D5: gh CLI required for github-flow mode | 84 | Init should validate gh availability |
| D6: Hotfix mode exempt from merge gate | 84 | fix-loop.md gets minimal changes |
| D7: Legacy mode = true superset of current behavior | 84 | Existing projects must not break |
| Use `git rev-parse --abbrev-ref HEAD` for all branch detection | 88 | Eliminates naming assumption coupling across workflows |
| Replace `git add .paul/ src/` with `git add -A` in all pause paths | 88 | Captures all repo changes without blind spots |
| Behind-base routing takes precedence over merge readiness | 89 | Prevents merging stale branches |
| Two-tier gh validation: CLI presence + auth status | 89 | Clear messaging for each failure mode |
| Status and resume share identical git-aware routing table | 90 | Consistent next-action guidance regardless of entry point |
| GitHub Flow init template omits `branching` field | 90 | Unambiguous config semantics |
### Fixes
| Fix | Phase | Impact |
|-----|-------|--------|
| Fix 02 (standard): Reworked installed module registries to include `hook_details`, aligned PLAN/APPLY/UNIFY dispatch wording to the installed registry, and added validation coverage | Phase 63 | Enabled modules can now be consulted from real installed `modules.yaml` registries instead of relying on conceptual source-manifest access |
| Fix 03 (standard): Aligned resume handoff discovery and docs so `/paul:resume` falls back to `.paul/handoffs/archive/` and only archives active consumed handoffs | No phase | Prevents the latest archived handoff from becoming undiscoverable during normal resume flows |
| Hotfix: Added token-based CARL session thresholds with 60k/120k project defaults | No phase | Retroactively documented in `83-02-HOTFIX-SUMMARY.md` |
| Fix 04 (standard): Removed `kernel/` path prefix from all module dispatch and reference paths in 11 files (36+ references). Reinstalled to deployed location. | Phase 99 | **Critical** — ALL module hooks (TODD, WALT, DEAN, IRIS, SKIP, DAVE, RUBY, DOCS) were silently skipped because `kernel/modules.yaml` didn't exist in the installed tree. Modules now dispatch correctly. |
| Fix 05 (manual — should have used /paul:fix): Added `modules.yaml` to `<required_reading>` in plan-phase.md, apply-phase.md, unify-phase.md. Model reads required_reading reliably but skips embedded dispatch substeps. | Phase 100 | Ensures model reads the module registry as a prerequisite for hook dispatch. **Needs reinstall.** |
| Fix 06 (standard /paul:fix): Split single-loop dispatch into two explicit steps — `advisory_module_dispatch` (IRIS, RUBY, DOCS, SKIP — never blocks) then `enforcement_module_dispatch` (TODD, WALT, DEAN — can block). Prose-based "DO NOT stop" failed because models follow structure not qualifiers. | Phase 104 | **Structural** — advisory output now guaranteed visible regardless of enforcement blocks. |
### Deviations
| Deviation | Phase | Impact |
|-----------|-------|--------|
| None material | 88-91 | All phases executed exactly as planned |
| **Orchestrator bypassed PALS for Phases 100-106** | Phases 100-106 | Committed directly, skipped PLAN/APPLY/UNIFY loop, no STATE.md updates, no merge gate workflow. Raw git + PR merges. Logged as deviation and corrected at Phase 107. |
| Fix 05 applied manually instead of /paul:fix | Phase 100 | Should have used standard fix workflow |
### Skill Audit (Phase 71)
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow drove PLAN → APPLY → UNIFY for this recommendation-only phase |
### Deferred Issues
- ci-generation.md and sonarqube-integration.md — future module candidates
- Agent SDK hook dispatch shelved — not an active milestone driver
- Tree-sitter repo map deferred
- AGENTS.md deferred to interoperability milestone
- Multi-model routing: implemented in Phase 43 — pals.json `agents` section, agent-dispatch.md reference, apply-phase dispatch logic
### Blockers/Concerns
- Future work should preserve artifact-first truth and resist telemetry, Pi-owned execution state, or reopening the settled Phase 69/70 contract without new evidence
### Git State
Branch: main
Last commit: ec240ef feat(152): REV module — module structure, IRIS fix, init wiring (#59)
PR: https://github.com/coctostan/pals/pull/59 (state: MERGED)
## Session Continuity
Last session: 2026-03-27
Stopped at: Plan 152-02 created
Next action: /paul:apply for Plan 152-02
Resume file: .paul/phases/152-core-implementation/152-02-PLAN.md
Resume context:
- Plan 152-02 creates /paul:review skill, adds merge gate review step, updates Pi extension
- Design reference at .paul/phases/151-research-and-design/rev-design.md