# Project State

## Project Reference

See: .paul/PROJECT.md (updated 2026-04-01)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** Unify 169-01 completed — Phase 169 is reconciled and waiting on merge/transition closure
## Current Position
Milestone: v2.38 Pi Lifecycle UX Polish
Phase: 169 of 3 (Supporting UX Alignment & Validation) — Complete
Plan: 169-01 complete
Status: UNIFY complete; merge gate and phase transition pending
Last activity: 2026-04-01T19:53:03Z — Created 169-01 SUMMARY and finalized UNIFY reconciliation for PR #79
Progress:
- v2.38 Pi Lifecycle UX Polish: [██████████] 100%
- Phase 168: [██████████] 100% ✓
- Phase 169: [██████████] 100%
## Loop Position
Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ✓     [Loop complete - awaiting merge gate and transition]
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
| 2026-03-27: Design Phase 155 around a parent-controlled PALS-native implementer contract, not the generic runtime `implementer` | 154 | Keeps inline APPLY as the reference model and prevents runtime-global agent behavior from becoming lifecycle truth |
| 2026-03-27: Use a dedicated repo-local `pals-implementer` agent with parent-controlled task delegation, not the generic runtime `implementer` | 155 | Gives Phase 156 a concrete repo-owned dispatch target while preserving `.paul/*` authority |
| 2026-03-27: Keep module enforcement, verification authority, and inline APPLY fallback in the parent workflow | 155 | Prevents subagent execution from becoming hidden lifecycle truth and defines the Phase 157 validation target |
| 2026-03-27: Install project-shipped Pi agents via `drivers/pi/install.sh` instead of relying on repo-local discovery alone | 156 | Makes `pals-implementer` available after install across repos, not just inside the PALS repo |
| 2026-03-27: Validate the implementer path with explicit Pi install-surface docs and text-based boundary assertions | 157 | Turns the delegated APPLY contract into durable automated proof without moving lifecycle truth into Pi |
| GitHub Flow init template omits `branching` field | 90 | Unambiguous config semantics |
| 2026-03-27: Separate total artifact growth from repeat-read hot-path cost before designing fixes | 158 | Prevents Phase 159 from conflating archive mass with active Pi context pressure |
| 2026-03-27: Treat `STATE.md` as the confirmed hot artifact and `ROADMAP.md` as the main warm-path artifact | 158 | Future reduction work should optimize repeated-read pressure first, not just largest files |
| 2026-03-27: Preserve `PROJECT.md` as the compact brief instead of using it to absorb roadmap or milestone history | 158 | Protects the layered artifact model that Phase 158 found was already working comparatively well |
| 2026-03-28: Keep workflow-side amplification separate from artifact-side cost until Phase 160 combines both evidence streams | 159 | Preserves a clean recommendation baseline and avoids blurring root causes across the two audit phases |
| 2026-03-28: Preserve guided workflow markers and target surrounding prose/read bundles first for workflow-bloat reduction | 159 | Lets Phase 160 pursue safer wording and read-discipline reductions without destabilizing guided UX semantics |
| 2026-03-28: Reduce workflow amplification before attempting hotter artifact redesign | 160 | Sets the next milestone toward wrapper/read-discipline/prose cleanup before any `STATE.md` redesign |
| 2026-03-28: Treat `ROADMAP.md` as the clearest combined reduction target while preserving `PROJECT.md` and guided markers | 160 | Gives future reduction work explicit trim-vs-preserve boundaries |
| 2026-03-28: Keep Pi wrapper shells as command-local deltas while retaining route-specific guardrails in each wrapper | 161 | Reduces repeated read scaffolding without moving lifecycle truth out of shared workflows |
| 2026-03-28: Prefer semantic thin-wrapper validation over brittle line-count assertions | 161 | Keeps wrapper slimming durable without freezing command-local wording |
| 2026-03-28: Prefer semantic shared-workflow contract checks over brittle line-count assertions | 163 | Keeps workflow prose cleanup durable without freezing exact wording |
| 2026-03-28: Finish v2.36 with bounded prose cleanup before structural artifact redesign | 163 | Closes the workflow-first reduction pass without reopening higher-risk roadmap/state redesign |
| 2026-03-28: Align the canonical `pals.json` contract around an explicit `agents.implementer` block before expanding delegated APPLY coverage | 164 | Keeps future delegation work grounded in init/migration/schema defaults rather than repo-local runtime assumptions |
| 2026-03-28: Broaden delegated APPLY eligibility around bounded parent-verifiable tasks rather than a parallel-only subagent heuristic | 165 | Keeps delegated APPLY practical for more auto tasks without weakening parent authority, fallback, or lifecycle ownership |
| 2026-03-28: Keep fresh-project docs and installed-surface validation aligned with the implementer/delegation contract | 166 | Prevents README/Pi/runtime drift from silently reintroducing configuration or authority ambiguity |
|| 2026-04-01: Collapse the persistent Pi lifecycle widget to a strict 4-line panel centered on milestone, phase, loop, and next action | 167 | Gives Phase 168 a clear implementation target and removes shortcut/module clutter from the main daily-use surface |
|| 2026-04-01: Use semantic lifecycle color for meaning, not decoration, and keep v2.38 bounded to polish of the existing surface | 167 | Preserves the additive Pi model without expanding into a new widget system or shifting lifecycle truth into Pi |
| 2026-04-01: Keep a direct `renderLoopBadge(state.loop)` call in the compact status path while simplifying the surrounding hierarchy | 168 | Preserves the calmer status line while keeping the existing Pi validation contract green during APPLY |
| 2026-04-01: Keep Phase 169 lifecycle alignment documentation-first when `pals-hooks.ts` already matches the calmer contract | 169 | Preserved the stable Phase 168 runtime hierarchy and focused changes on docs plus semantic validation guardrails |
### Fixes
| Fix | Phase | Impact |
|-----|-------|--------|
| Fix 02 (standard): Reworked installed module registries to include `hook_details`, aligned PLAN/APPLY/UNIFY dispatch wording to the installed registry, and added validation coverage | Phase 63 | Enabled modules can now be consulted from real installed `modules.yaml` registries instead of relying on conceptual source-manifest access |
| Fix 03 (standard): Aligned resume handoff discovery and docs so `/paul:resume` falls back to `.paul/handoffs/archive/` and only archives active consumed handoffs | No phase | Prevents the latest archived handoff from becoming undiscoverable during normal resume flows |
| Hotfix: Added token-based CARL session thresholds with 60k/120k project defaults | No phase | Retroactively documented in `83-02-HOTFIX-SUMMARY.md` |
| Fix 04 (standard): Removed `kernel/` path prefix from all module dispatch and reference paths in 11 files (36+ references). Reinstalled to deployed location. | Phase 99 | **Critical** — ALL module hooks (TODD, WALT, DEAN, IRIS, SKIP, DAVE, RUBY, DOCS) were silently skipped because `kernel/modules.yaml` didn't exist in the installed tree. Modules now dispatch correctly. |
| Fix 05 (manual — should have used /paul:fix): Added `modules.yaml` to `<required_reading>` in plan-phase.md, apply-phase.md, unify-phase.md. Model reads required_reading reliably but skips embedded dispatch substeps. | Phase 100 | Ensures model reads the module registry as a prerequisite for hook dispatch. **Needs reinstall.** |
| Fix 06 (standard /paul:fix): Split single-loop dispatch into two explicit steps — `advisory_module_dispatch` (IRIS, RUBY, DOCS, SKIP — never blocks) then `enforcement_module_dispatch` (TODD, WALT, DEAN — can block). Prose-based "DO NOT stop" failed because models follow structure not qualifiers. | Phase 104 | **Structural** — advisory output now guaranteed visible regardless of enforcement blocks. |
| Fix 07 (ff): Install project-shipped Pi agents from `.pi/agents` into `~/.pi/agent/agents` via `drivers/pi/install.sh` | Phase 156 | Makes `pals-implementer` available as a user-level Pi agent after install instead of only inside the PALS repo |
### Deviations
| Deviation | Phase | Impact |
|-----------|-------|--------|
| None material | 88-91 | All phases executed exactly as planned |
| **Orchestrator bypassed PALS for Phases 100-106** | Phases 100-106 | Committed directly, skipped PLAN/APPLY/UNIFY loop, no STATE.md updates, no merge gate workflow. Raw git + PR merges. Logged as deviation and corrected at Phase 107. |
| Fix 05 applied manually instead of /paul:fix | Phase 100 | Should have used standard fix workflow |
| Phase 156 implementation expanded to include installer-backed global agent installation after initial APPLY scope | Phase 156 | Small scope expansion via `drivers/pi/install.sh` so `pals-implementer` works outside the PALS repo |
| Phase 161 Task 3 used `install.sh` and `tests/cross-harness-validation.sh` as verification surfaces, but only `tests/pi-end-to-end-validation.sh` required repo changes | Phase 161 | Minor plan metadata over-scoping; APPLY completed successfully and the variance should be documented in UNIFY |
### Skill Audit (Phase 156)
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the Phase 156 implementer integration and follow-up installer fix |
### Skill Audit (Phase 159)
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the workflow-bloat audit |
| /carl | ✓ | Session-boundary routing remained active at pause/resume level; no separate manual action was needed during the audit |
| TODD | N/A | Research-only documentation phase; no implementation path or RED/GREEN/REFACTOR work applied |
| WALT | N/A | Documentation-only audit; no project test/lint/typecheck execution path was available for meaningful gating |
### Skill Audit (Phase 163)
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the workflow prose cleanup and validation phase |
| /carl | ✓ | Session-boundary routing remained active while the phase moved across planning, apply, and unify |
| TODD | ✓ | APPLY/UNIFY preserved regression-check sequencing for the workflow and validation edits |
| WALT | ✓ | Validation suites ran during APPLY and quality history was recorded during UNIFY |
### Skill Audit (Phase 167)
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the Phase 167 audit/design work |
### Skill Audit (Phase 168)
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the runtime lifecycle UI polish phase |
| /carl | ✓ | Session-boundary routing remained active while Phase 168 moved across planning, apply, and unify |
| TODD | ✓ | APPLY preserved disciplined verification expectations for the bounded runtime edit |
| WALT | ✓ | Validation passed during APPLY and quality evidence was persisted during UNIFY |
### Skill Audit (Phase 169)
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the docs/validation alignment phase |
| /carl | ✓ | Session-boundary routing remained active while the phase moved across APPLY and UNIFY |
| TODD | ✓ | APPLY preserved disciplined validation sequencing on the shell-based Pi validation surface |
| WALT | ✓ | Validation ran during APPLY and quality history was recorded during UNIFY |
### Deferred Issues
- ci-generation.md and sonarqube-integration.md — future module candidates
- Agent SDK hook dispatch shelved — not an active milestone driver
- Tree-sitter repo map deferred
Last commit: a9b47a3 feat(167-ux-audit-target-design): complete phase transition
- Multi-model routing: implemented in Phase 43 — pals.json `agents` section, agent-dispatch.md reference, apply-phase dispatch logic
### Blockers/Concerns
- Future work should preserve artifact-first truth and resist telemetry, Pi-owned execution state, or reopening the settled Phase 69/70 contract without new evidence
### Git State
Branch: feature/169-supporting-ux-alignment-validation
Last commit: 2e531d7 chore(169-supporting-ux-alignment-validation): record apply state
PR: https://github.com/coctostan/pals/pull/79 (state: open)
CI: passing
## Session Continuity
Last session: 2026-04-01T19:53:03Z
Stopped at: UNIFY complete for Plan 169-01
Next action: Merge PR #79, complete transition for Phase 169, and close milestone v2.38
Resume file: .paul/phases/169-supporting-ux-alignment-validation/169-01-SUMMARY.md
Resume context:
- Phase 169 docs now describe the persistent Pi lifecycle surface as milestone / phase / loop / next action, with shortcuts framed as entry points rather than persistent rows.
- `tests/pi-end-to-end-validation.sh` now guards the calm 4-line hierarchy semantically and rejects the older `Actions:` / `More:` copy.
- `drivers/pi/extensions/pals-hooks.ts` was inspected for adjacent wording drift; no runtime hierarchy changes were needed, and bundling plus the Pi end-to-end validation suite passed.