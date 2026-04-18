# Project: pals

## Description
PALS - Project Automation & Lifecycle System. Based on PAUL and CARL along with their pals TODD and WALT. They team up to give users the agentic coding framework that makes development friendly.

## Core Value
The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

## Requirements

### Active
- [x] TODD coverage dashboard — visibility into untested code paths (Phase 18)
- [x] WALT quality trends — quality ledger tracking over time (Phase 19)
- [x] DEAN module — dependency evaluation & audit notifier (Phase 20)
- [x] IRIS module — intelligent review & inspection system (Phase 21)
- [x] SKIP module — smart knowledge & information persistence (Phase 22)
- [x] DAVE module — deploy automation & verification engine (Phase 23)
- [x] RUBY module — refactor utility & better-code yielder (Phase 24)
- [x] Lifecycle hooks — all 8 pals wired into plan/apply/unify (Phase 25)
- [x] Module configuration — JSON config (pals.json), /paul:config command, init integration (Phase 26)
- [x] Publication-quality README — architecture, module catalog, command reference, configuration guide (Phase 27)
- [x] Context audit & optimization — measure and trim module reference context weight (Phase 28)
- [x] Module observability — dispatch log, activity reports, user-visible hook output (Phase 29)
- [~] Context monitor (conditional) — skipped, Phase 28 optimization made this unnecessary (Phase 30)
- [x] Seamless Git & GH — config-driven git automation in kernel workflows (Phase 31)
- [x] PALS Documentation — module builder's guide, troubleshooting guide, changelog (Phase 32)
- [x] DOCS module — documentation lifecycle & oversight companion (Phase 33)
- [x] Competitive analysis — 15 frameworks benchmarked, gaps/differentiators mapped, v1.0 priorities set (Phase 34)
- [x] Lightweight fix loop — /paul:fix command with 3 modes (standard/fast-forward/hotfix), retroactive UNIFY (Phase 35)
- [x] Brownfield & codebase intelligence — brownfield init detection, map-codebase v2 with reference graph (GRAPH.md), onboarding guide (Phase 36)
- [x] Resilience & isolation — optional git worktree isolation (config-driven, default off) (Phase 37)
- [~] Planning deep dive — 12 frameworks researched, 4 improvements to plan-phase.md (Phase 38)
- [~] Execution deep dive — 12 frameworks researched, 6 improvements to apply-phase.md (Phase 39)
- [~] Testing & TDD deep dive — 12 frameworks researched, 6 improvements to TODD module (Phase 40)
- [~] Quality & Validation deep dive — 12 frameworks researched, 8 improvements to WALT module (Phase 41)
- [~] UNIFY, Continuity & Codebase Intel deep dive — 12 frameworks + 3 tools researched, 11 improvements to 5 workflow/reference files (Phase 42)
- [x] Config & routing design — agent-based task execution with 4 named roles, configurable models, dispatch logic (Phase 43)
- [x] Implementation & validation — agent config in init, agent tracking in unify, model routing in research/discover (Phase 44)
- [x] Artifact & Lifecycle Spec — normative schemas for 8 artifacts, lifecycle state machine, hook dispatch contract (Phase 45)
- [x] Harness-Agnostic Skills — all kernel + module files use portable kernel/ references, zero @~/.pals/ or @.paul/ patterns (Phase 46)
- [x] Pi Adapter — driver manifest, installer, uninstaller; multi-driver root installer installs for all detected harnesses (Phase 47)
- [x] REV code review module — on-demand subagent-powered review with configurable model selection, `/paul:review`, opt-in PR merge-gate review, and degraded in-session fallback (Phases 151-153)
- [x] PALS-native implementer path — parent-controlled delegated APPLY via `pals-implementer`, minimal Pi guidance/config, and installer-backed global agent availability (Phases 154-156)
- [x] Pi lifecycle UX polish — calm 4-line lifecycle panel, semantic color, and reduced persistent clutter across the existing Pi lifecycle surface (Phases 167-169)
- [x] CODI module (v0.1) — registry-discovered pre-plan advisory overlay at priority 220 across Phases 170–172 (hello-world scaffolding → live `impact` integration → plan-phase coupling/default-on distribution); Phase 173 trial verdict ITERATE_V0_1 selected v2.40, Phase 174 shipped bounded source-file selector extraction so upcoming-plan `<context>` TS/JS paths now seed stable `impact` candidates, Phase 175 aligned install-time detection, value-envelope docs, and the success-log `R` convention without widening CODI beyond its no-magic advisory scope, and Phase 176 added a bounded CODI post-unify hook that appends one row per UNIFY to `.paul/CODI-HISTORY.md` (PLAN.md `<module_dispatch>` primary / SUMMARY.md fallback / hotfix-aware `no-dispatch-found`) with a 5-string drift guard between pre-plan and post-unify hooks — first hook-triggered row (`176-01 skipped-no-symbols`) written successfully end-to-end.

### Must Have
All validated — see below.

### Should Have
All validated — see below.

### Nice to Have
All validated — see below.

### Validated
- ✓ Architecture fully mapped (111 files across 4 components) — Phase 1
- ✓ Unified structure designed (105 destinations, 6 consolidations) — Phase 1
- ✓ PALS repo structure created with 96 PAUL files migrated — Phase 2
- ✓ /paul:* command namespace replacing /paul:* — Phase 2
- ✓ All @-references rewritten to ~/.pals/ paths — Phase 2
- ✓ TODD/WALT integrated as named subsystems (no indirection) — Phase 3
- ✓ CARL as native component with /carl:* namespace retained — Phase 4
- ✓ Single install script from git clone — Phase 5
- ✓ Uninstall/cleanup script — Phase 5
- ✓ Getting-started documentation (README.md) — Phase 5
- ✓ /paul:* namespace standardized (removed /pals:* duplication) — Phase 7
- ✓ Cleanup artifacts removed (test-lifecycle.sh) — Phase 7
- ✓ Install/uninstall scripts updated for /paul:* namespace — Phase 7
- ✓ Upgrade-aware installer with legacy ~/.claude/paul-framework/ cleanup — Phase 8
- ✓ Auto context cycling researched — not feasible (no programmatic /clear) — Phase 9
- ✓ Kernel/module/driver architecture designed (4 spec documents) — Phase 10
- ✓ Kernel/module/driver architecture implemented — v0.4
- ✓ CARL, TODD, WALT refactored as loadable modules with module.yaml manifests — v0.4
- ✓ Module-aware installer with pals.yaml config and pals CLI — v0.4
- ✓ Agent SDK driver proof-of-concept (headless kernel via query() API) — v0.4
- ✓ TODD hook-mapping workflow (plan-phase-tdd.md) with 5 kernel hook dispatch instructions — Phase 14
- ✓ WALT hook-mapping workflow (apply-phase-quality.md) with 3 kernel hook dispatch instructions — Phase 15
- ✓ TODD TDD enforcement functional end-to-end (detection → plan restructuring → RED/GREEN/REFACTOR) — v0.5
- ✓ WALT quality gating functional end-to-end (baseline → regression detection → history) — v0.5
- ✓ Module system validated with both modules active simultaneously — Phase 16
- ✓ CARL auto-detection with rule catalog (11 technologies) and *scan command — Phase 17
- ✓ TODD coverage dashboard with /paul:coverage command (9 frameworks) — Phase 18
- ✓ WALT quality trends with /paul:quality command (streak/regression/stall detection) — Phase 19
- ✓ DEAN module — dependency evaluation & audit notifier with /paul:deps command (10 ecosystems) — Phase 20
- ✓ IRIS module — intelligent review & inspection system with /paul:review command (25 patterns, 5 checklists) — Phase 21
- ✓ SKIP module — smart knowledge & information persistence with /paul:knowledge command (5 knowledge types, multi-source search) — Phase 22
- ✓ DAVE module — deploy automation & verification engine with /paul:deploy command (4 modes, 12+ language detectors) — Phase 23
- ✓ RUBY module — refactor utility & better-code yielder with /paul:refactor command (3 modes, 9 refactoring patterns) — Phase 24
- ✓ Lifecycle hooks — all 8 pals integrated into plan/apply/unify with priority-based dispatch (16 hook registrations across 6 hook points) — Phase 25
- ✓ Module configuration — pals.json with all 8 modules, /paul:config dashboard with toggle, module selection in /paul:init — Phase 26
- ✓ Publication-quality README — 3-layer architecture, 9-pal catalog, 40 commands, configuration guide — Phase 27
- ✓ Context audit & optimization — 27 reference files measured, 15 trimmed, 43% reduction (4,507 → 2,550 lines), per-module budgets established — Phase 28
- ✓ Module observability — per-hook refs in 7 modules, context_inject schema, dispatch log in 3 workflows, failure cascading + state recovery documentation — Phase 29
- ✓ Seamless Git & GH — pals.json git config (5 fields), init configure_git step, config-driven auto PR/push/CI in transition-phase, auto push in complete-milestone, branching defaults in pause-work — Phase 31
- ✓ PALS Documentation — module builder's guide (7-step walkthrough + DEAN example), troubleshooting guide (5 categories, 19 entries), changelog (v0.1 through v0.9.1) — Phase 32
- ✓ DOCS module — documentation lifecycle & oversight (2 hooks, 3 references, advisory priority 200-250) — Phase 33
- ✓ Competitive analysis — 15 frameworks benchmarked, 3 critical gaps, 6 strong differentiators, v1.0 phase mapping — Phase 34
- ✓ Lightweight fix loop — /paul:fix with 3 modes (standard/fast-forward/hotfix), retroactive UNIFY, fix-types reference — Phase 35
- ✓ Brownfield & codebase intelligence — brownfield init detection, map-codebase v2 with Agent 5 reference graph (GRAPH.md), brownfield onboarding guide — Phase 36
- ✓ Resilience & isolation — optional git worktree isolation (config-driven, default off) — Phase 37
- ✓ Planning deep dive — 12 frameworks researched, 4 improvements (clarity test, dual-goal, complexity gating, read-only) — Phase 38
- ✓ Execution deep dive — 12 frameworks researched, 6 improvements (structured status, divergence check, bounded retry, revert-and-refine, stuck detection, re-plan protocol) — Phase 39
- ✓ Testing & TDD deep dive — 12 frameworks researched, 6 improvements (anti-pattern injection, failure classification, contract guard, reflection loop, structural coverage, quality heuristics) — Phase 40
- ✓ Quality & Validation deep dive — 12 frameworks researched, 8 improvements (3-tier severity, failure-to-context, advisory mode, zero-regression rate, small-change exemption, diff-based guidance, event-tagged history, scoped validation) — Phase 41
- ✓ UNIFY, Continuity & Codebase Intel deep dive — 12 frameworks + 3 tools researched, 11 improvements (retrospective artifacts, offline changes detection, knowledge quality feedback, context assembly pipeline, interrupted-action recovery, file staleness tracking, per-module map, convention capture, structured onboarding) — Phase 42
- ✓ Config & routing design — pals.json agents schema (4 roles), agent-dispatch.md reference, apply/plan-phase agent dispatch logic, PLAN.md template agent attribute — Phase 43
- ✓ Implementation & validation — init creates agents config, unify tracks agent execution, research/discover use configured model — Phase 44
- ✓ Artifact & Lifecycle Spec — ARTIFACT-SPEC.md (8 schemas), LIFECYCLE-SPEC.md (7 states, 7 transitions), HOOK-CONTRACT.md (6 hooks, 9 modules) — Phase 45
- ✓ Harness-Agnostic Skills — 3 plans: convention doc + core loop (46-01), all kernel files (46-02), all module files (46-03). 53+ files converted, zero non-portable references — Phase 46
- ✓ Pi Adapter — driver manifest (4/6 capabilities), installer targeting ~/.pi/agent/skills/pals/, multi-driver root installer — Phase 47
- ✓ Cross-Harness Validation — 45-check validation suite (TAP format), installer parity, portability compliance, artifact spec conformance, driver manifests. All pass. — Phase 48
- ✓ SKILL.md Generation — 11 Pi skill entry points + skill-map.md mapping 21 workflows to 11 skills + 10 internal — Phase 49
- ✓ Pi Extension — Thin TypeScript extension (143 lines) with 11 /paul-* commands via registerCommand, session_start + context event hooks — Phase 50
- ✓ Installer & Driver Update — install.sh deploys skills + extension, uninstall.sh cleans up, driver.yaml reflects command/hook capabilities — Phase 51
- ✓ Pi End-to-End Validation — 75-check TAP validation suite, installer deployment, skill structure, extension structure, driver manifest accuracy. All pass. — Phase 52
- ✓ Pi lifecycle visibility surface — persistent status/widget UI derived from `.paul/STATE.md` with validation coverage and no Pi-only lifecycle truth — Phase 59
- ✓ Pi shortcut-enabled lifecycle entry layer — bounded quick actions and keyboard shortcuts route through `/paul-*` wrappers while preserving `/skill:paul-*` as canonical and `.paul/*` as the only lifecycle truth — Phase 60
- ✓ Pi UX polish, module-overlay clarity, and interoperability guardrails — bounded lifecycle wording, explicit TODD/WALT overlay guidance, 90-check Pi validation, and 47-check cross-harness validation all pass — Phase 61
- ✓ Pi runtime context/event refinement — explicit command activation + `before_agent_start` primary bounded injection + support-only `context`, with updated Pi validation contract (93 checks passing) — Phase 62
- ✓ Pi guided workflow UX — bounded canonical prompt detection plus explicit Pi-native continuation helpers for approvals, checkpoints, resume routing, and transitions, with validation contract coverage (98 checks passing) — Phase 63
- ✓ Pi UX polish & readability — semantic notify levels ("success" for routing/sends), compact loop badge in status bar, installation boundary docs, 106-check validation contract — Phase 64
- [x] Collaborative planning & PRD depth — Phase 65 research, Phase 66 collaboration model, and Phase 67 layered onboarding / `PROJECT.md` + `PRD.md` rollout completed (v2.6)
- [x] Module execution proof & visibility — execution evidence/reporting was hardened in Phase 69, live module visibility UX shipped in Phase 70, and recommendation-grade module guidance closed the loop in Phase 71 (v2.7)
- [x] CARL API validation — all 3 Pi extension APIs (getContextUsage, newSession, sendUserMessage) validated empirically with working prototype (Phase 76, v2.9 hollow — research artifacts valid)
- [x] CARL core implementation — production session boundary manager with phase detection, configurable decision model, session creation + auto-resume, and safety valve (Phase 81, v2.11)
- [x] CARL integration & configuration — pals.json carl config fields added, init workflow updated for new projects, dead Claude Code-era modules/carl/ removed (Phase 82, v2.11)
- [x] CARL validation & docs — end-to-end deployment verified, threshold calibration documented, Pi extension README and PALS docs updated for two-CARL model (Phase 83, v2.11)
- [x] GitHub Flow lifecycle awareness — init offers GitHub Flow as first-class option, resume surfaces git/PR/CI state with git-aware routing, pause captures git continuity in handoffs (Phase 86, v2.12)
- [x] GitHub Flow enforcement — strict branch/PR/merge/CI gating with preflight, postflight, 6-gate merge gate, lifecycle awareness, and full documentation (Phases 84-87, v2.12)

- [x] Branch & Staging Correctness — all GitHub Flow workflow steps use detected branch name, pause staging captures all repo changes (Phase 88, v2.13)
- [x] Routing & Validation — behind-base routing priority in resume, gh auth validation in init (Phase 89, v2.13)
- [x] Status Parity & Config Clarity — progress.md mirrors resume's git-aware routing/display, GitHub Flow init template no longer emits redundant `branching` (Phase 90, v2.13)
- [x] Verification & Docs — cross-cutting verification artifact proving all 6 hardening issues resolved, git-strategy.md and README.md updated (Phase 91, v2.13)
- [x] Init/Onboarding Overhaul — three init flows (quick ~1Q, greenfield ~8Q, brownfield ~12+Q), brownfield detection fix, conditional question gating, explicit default milestone, grouped module descriptions, --quick mode (Phases 132-134, v2.26)
- [x] Module Dispatch Hardening — 40 hook descriptions rewritten to imperative, MANDATORY post-apply/post-unify dispatch markers, dispatch evidence audits, merge gate split 1→4 sub-steps (Phases 135-137, v2.27)
- [x] DEAN Baseline Management — baseline-aware override (delta comparison, staleness guard, .paul/dean-baseline.json), closes all 13 v2.25 actionable items (Phase 138, v2.28)
- ✓ REV code review module — on-demand module manifest, review prompt/checklist refs, nullable model override, and graceful degraded fallback shipped across Phases 151-153 (v2.33)
- ✓ Review workflow integration — `/paul:review` skill, Pi command registration, opt-in merge-gate review step, live review validation, and polish fixes shipped in v2.33
- ✓ PALS-native implementer validation & operating-model docs — automated proof, temp-HOME install validation, and explicit Pi three-surface documentation shipped in Phase 157 (v2.34)
- ✓ Workflow-first context reduction implementation — thin wrappers, slice-based roadmap reads, slimmer warm-path workflow prose, and semantic installed-surface validation shipped across Phases 161-163 (v2.36)
- ✓ Implementer config contract alignment — explicit `agents.implementer` defaults now flow through init, migration, schema docs, README guidance, and installed-surface validation across Phases 164-166 (v2.37)
- ✓ Delegated APPLY expansion — `pals-implementer` now covers broader bounded parent-verifiable task packets while keeping verification, module enforcement, fallback, and `.paul/*` lifecycle authority in the parent (Phases 165-166, v2.37)
- ✓ Pi lifecycle UX polish — calm 4-line lifecycle panel, semantic color, and reduced persistent clutter across the existing Pi lifecycle surface shipped across Phases 167-169 (v2.38)
- ✓ CODI module scaffolding — registry-discovered pre-plan advisory overlay at priority 220, hello-world dispatch, no tool calls in v0.1; installer is already registry-driven so zero installer/kernel/workflow edits were required (Phase 170, v2.39 in progress)
- ✓ CODI live `impact` integration — per-symbol call pattern (not batched, because `impact` is all-or-nothing on unresolved input), 5 per-symbol outcome categories, partial-success invariant, Blast Radius markdown sub-section returned as `context_inject.blast_radius`, 4 hook-level skip paths, classifier-safety invariant extended to full module surface (Phase 171, v2.39 in progress)
- ✓ CODI plan-phase coupling & distribution — prose-heavy planning scopes now seed explicit repo-confirmed CODI targets, `modules.codi` ships default-on across config/schema/docs, and semantic validation guards the contract across repo + installed surfaces (Phase 172, v2.39 in progress)
- ✓ CODI install-time detection + value-envelope docs + format fix — bounded `.codegraph/graph.db` install hint (advisory only, never auto-disables CODI), honest `When CODI helps` framing across manifest/reference/README/changelog, and explicit success-log `R = resolved-with-call-sites only` convention; installed-surface + cross-harness validation extended with minimal semantic markers (Phase 175, v2.40 in progress)
- ✓ CODI v2.40 complete — Phase 177 re-trial verdict **ITERATE_V0_1** (`S_pass_nonnull` improved from 1 → 3, Signal 3 still clears live + counterfactual projected-pass, SHIP gate fails on Q2=uncertain). v2.40 shipped source-file selector extraction (174), install-time detection + value-envelope docs + `R` convention (175), and CODI post-unify hook writing `.paul/CODI-HISTORY.md` (176). Next milestone (v2.41) focuses on natural-scope TS implementation evidence to resolve Q2 before considering v0.2. Verdict and full evidence in `.paul/phases/177-re-trial-gating-decision/177-01-DECISION.md` (Phases 174–177, v2.40 complete)
- [~] v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation — in progress. Proposal approved at `.paul/proposals/v2.41-cross-repo-trial-quark.md`. Phase 178 is now UNIFY-complete at `.paul/phases/178-codi-cross-repo-install/178-01-{PLAN,SUMMARY}.md`: `quark/pals.json` enables `modules.codi`, `quark/.codegraph/graph.db` was refreshed, `quark/.paul/CODI-HISTORY.md` was seeded with the canonical zero-row header, and a direct smoke test resolved `deriveTools` to `src/kernel/context.ts:40` (`assembleContext`) with behavioral depth 1. Phase 179 remains the natural observation window for the user's in-flight quark patches, authored before CODI was enabled in quark — causally independent, zero selection bias. Phase 180 re-trial applies the unchanged Phase 173/177 rubric to resolve Q2.
## Constraints
- CARL remains architecturally independent (Pi extension event integration, not PALS workflow hooks)
- TODD/WALT have no standalone operation — always PALS-native
- /carl:* namespace preserved (not merged into /paul:*)
- Kernel must remain platform-agnostic (no Claude Code assumptions in core)
- Module interface must be simple enough to build a new pal in one session
- Existing functionality must not regress during kernelization

## Key Decisions

| Decision | Phase | Rationale |
|----------|-------|-----------|
| CARL is fully independent (hook-level integration) | 1 | No file-level refs between CARL and PAUL |
| TODD/WALT are named integrated subsystems, retain identity | 1 (revised) | Steps labeled TODD:/WALT: in workflows, no separate directories |
| Flat workflows/ directory (no TODD/WALT subdirs) | 1 | TODD/WALT steps inline in parent workflows |
| CARL gets own subdirectory (~/.pals/carl/) | 1 | Independent runtime config, not docs |
| /paul:* namespace, /carl:* retained | 1 | Unified brand + CARL independence |
| TODD workflows reclassified as references | 1 (revised) | TDD specs stay self-contained, referenced natively from plan/apply |
| Preserve all subsystem names (TODD, WALT, PAUL, CARL) | 3 | User directive — integration not erasure |
| Revert /pals:* → /paul:* namespace | 7 | PAUL is the subsystem name; /pals:* adds confusion |
| Interactive y/N prompt for legacy cleanup (default No) | 8 | Safe default prevents accidental deletion during install |
| Auto context cycling deferred | 9 | No programmatic /clear exists; 3→2 step improvement not worth building |
| "Linux of Harness Engineering" vision | 10 | Minimal kernel, modular pals, universal drivers — platform-agnostic |
| Three-layer stack: Modules → Kernel → Drivers | 10 | Each layer only talks to neighbors; missing modules = no-op |
| Delegated workflows stay in kernel | 10 | Only named pals become modules; fork kernel for different tools |
| Claude Code driver is install-time wiring, not runtime code | 13 | The LLM IS the runtime driver |
| Workflow-as-system-prompt for Agent SDK | 13 | Same .md drives both drivers |
| Driver detection: PALS_DRIVER > ~/.claude/ > ANTHROPIC_AGENT_SDK > default | 13 | Install-time resolution |
| Each module hook maps to exactly 2 reference files | 15 | Minimize context per dispatch; specific refs per hook |
| Module system validated via audit (no code changes needed) | 16 | All hooks, refs, priorities, and enable/disable verified clean |
| YAML catalog pattern for extensible detection | 17 | rule-catalog.yaml drives *scan; add technologies by editing YAML |
| Scan delegates to existing CARL CRUD tasks | 17 | No duplicated domain/rule creation logic |
| /paul:coverage in kernel, detection ref in TODD module | 18 | Clean separation: project-level command + module-owned knowledge |
| Advisory thresholds for coverage (not enforcement) | 18 | Visibility complements WALT's enforcement model |
| /paul:quality in kernel, trends ref in WALT module | 19 | Same pattern as Phase 18: command + module reference |
| Zero-value stalls treated as positive (clean code) | 19 | Lint/Types at 0 = clean, not concerning |
| DEAN has no hooks in v0.6 (read-only visibility) | 20 | Visibility first, enforcement later (mirrors WALT's evolution) |
| Never auto-fix dependencies — only suggest commands | 20 | Updates can break things; user controls all changes |
| /paul:deps in kernel, detection refs in DEAN module | 20 | Same pattern as Phases 18-19: command + module reference |
| IRIS has no hooks in v0.6 (read-only guidance) | 21 | Advisory first, enforcement later (same as DEAN) |
| /paul:review in kernel, pattern/checklist refs in IRIS module | 21 | Same pattern as Phases 18-20: command + module reference |
| SKIP follows DEAN/IRIS pattern (no hooks initially) | 22 | Read-only first, hooks in Phase 25 |
| /paul:knowledge in kernel, knowledge refs in SKIP module | 22 | Same pattern as Phases 18-21: command + module reference |
| DAVE follows established module pattern (no hooks initially) | 23 | Read-only first, hooks in Phase 25 |
| /paul:deploy in kernel, deploy refs in DAVE module | 23 | Same pattern as Phases 18-22 |
| 4 modes for deploy command (dashboard, audit, generate, verify) | 23 | Deploy has distinct concerns requiring separate modes |
| RUBY follows established module pattern (no hooks initially) | 24 | Read-only first, hooks in Phase 25 |
| /paul:refactor in kernel, detection/pattern refs in RUBY module | 24 | Same pattern as Phases 18-23 |
| 3 modes for refactor command (dashboard, scan, suggest) | 24 | Distinct concerns: overview vs analysis vs guidance |
| Priority-based hook ordering (no conflicts per hook point) | 25 | Clean dispatch: lower priority runs first |
| CARL excluded from lifecycle hooks (platform hooks only) | 25 | Per Phase 4 design: CARL is architecturally independent |
| pals.json replaces pals.yaml (JSON over YAML) | 26 | Standard tooling (json.load, jq), no custom parser needed |
| All 8 modules enabled by default in config | 26 | New users get full experience, can disable via /paul:config |
| README grouped commands into 7 functional categories | 27 | Scannable reference aids command discovery |
| 150-line hard cap per reference file | 28 | Bounded context load per hook dispatch |
| Separate budgets: 750 lines core, 350 standard | 28 | TODD/WALT get more room due to deeper integration |
| Per-hook refs in module.yaml (not all module refs) | 29 | Each hook loads only what it needs, reducing context waste |
| post-task block skips tasks but post-apply still fires | 29 | Allows quality gates to report even when task-level block halted execution |
| Three detection outcomes: found-standard, found-non-standard, not-found | 29 | Non-standard should warn, not silently skip |
| All git automation defaults to off (conservative) | 31 | Users must opt in during init |
| Git config in pals.json (not separate file) | 31 | Single config file, consistent with modules/integrations |
| Git automation is kernel-level, not a module | 31 | Kernel already does git; config toggle is the disable mechanism |
| All remote ops guard on remote != null | 31 | Graceful degradation for local-only projects |
| DOCS uses advisory priority (200-250) | 33 | Non-blocking doc awareness, runs after enforcement modules |
| No kernel command for DOCS in v1 | 33 | Visibility via hooks first, /paul:docs command later |
| Proximity-based drift detection (not content parsing) | 33 | Content parsing too fragile, git blame too slow for hook context |
| Brownfield support is #1 adoption barrier | 34 | OpenSpec, Aider prove existing codebases need support |
| Lightweight fix loop critical for v1.0 | 34 | Full PLAN-APPLY-UNIFY for 1-file bugs drives users away |
| Do NOT build full autonomous execution | 34 | Devin's 15% success rate proves supervised approach is correct |
| Superpowers is closest competitor | 34 | PALS differentiates with UNIFY, modules, session continuity |
| 3 fix modes: standard/fast-forward/hotfix | 35 | Covers all ad-hoc fix scenarios with appropriate overhead |
| Fast-forward skips ALL hooks by design | 35 | Zero overhead for trivial fixes — users accept no quality gates |
| Fixes are side-loops, not phase progression | 35 | Main loop integrity preserved — fixes tracked in STATE.md only |
| Retroactive UNIFY via early branch | 35 | One workflow (unify-phase.md) handles both normal and retroactive |
| Brownfield = AI-directed analysis, not automated tooling | 36 | Follows OpenSpec pattern: framework provides structure, AI does introspection |
| Reference graph via Explore agent, not tree-sitter | 36 | PALS is markdown-based; Aider's graph insight adopted without Python dependencies |
| GRAPH.md as 8th additive document | 36 | Existing 7 templates unchanged; zero regression risk |
| Brownfield init is branch, not replacement | 36 | Greenfield flow untouched; brownfield detection is opt-in |
| Worktree isolation must be optional (default off) | 37 | Config-driven, zero behavior change for existing users |
| worktree/ branch prefix distinct from feature/ | 37 | Clear namespace separation |
| No worktree in fix loop | 37 | Fix loop lightweight by design; worktree overhead contradicts fast-forward |
| AGENTS.md deferred to interoperability milestone | 37 | Duplicates CLAUDE.md; convention not standardized |
| Adopt clarity test, dual-goal, complexity gating, read-only planning | 38 | Best techniques from 12 frameworks' planning approaches |
| Adopt stuck detection, deviation notification, revert-and-refine | 39 | Best techniques from 12 frameworks' execution mechanics |
| Adapt bounded retries (max 2), structured status (3-state), re-plan protocol | 39 | Lighter versions of Aider/Superpowers/Devin techniques |
| Reject 6 execution techniques (lint-gate, per-hunk, context fetch, checkpoints, isolation, slicing) | 39 | Handled by host tool or existing PALS mechanisms |
| Adopt anti-pattern injection, failure classification, contract guard for TODD | 40 | Best techniques from 12 frameworks' testing approaches |
| Adapt reflection loop, structural coverage, quality heuristics for TODD | 40 | Lighter versions of Aider/Continue.dev/BMAD techniques |
| Reject 10 testing techniques (cross-agent, recursive debug, CI auto-fix, delete-before-test, etc.) | 40 | Multi-agent, IDE-specific, or already adopted |
| Adopt retrospective artifacts (Devin), offline changes detection (GPT Pilot), knowledge quality feedback (Devin) | 42 | Best techniques for UNIFY, resume, and codebase intelligence workflows |
| Adapt 8 techniques (context assembly, interrupted-action, staleness tracking, convention capture, structured onboarding, etc.) | 42 | Lighter versions of Windsurf/MetaGPT/Cline/Cursor patterns |
| Reject 11 techniques (condenser, dual-state, shadow git, autonomous memory, etc.) | 42 | Require programmatic infrastructure beyond PALS scope |
| Defer tree-sitter+PageRank and LSP-powered analysis | 42 | High value but needs programmatic implementation |
| 4 agent roles: coder/researcher/tester/reviewer with config-driven models | 43 | Named roles dispatch via Agent tool; reviewer=opus, rest=sonnet |
| Missing agents config = inline execution (backward-compatible) | 43 | No behavior change for projects without agents section |
| Writing agents sequential, research/review parallel | 43 | Prevents file conflicts while allowing read-only parallelism |
| No interactive agent config during init | 44 | Defaults correct; advanced users edit pals.json directly |
| 11 skills (not 21) — only user-facing commands | 49 | Internal workflows invoked by skill instructions, not standalone |
| ../workflows/ relative paths in skills | 49 | Skills installed as siblings of kernel dirs in ~/.pi/agent/skills/pals/ |
| Commands delegate to /skill:paul-* via notify | 50 | Keeps extension thin; skills have full workflow instructions |
| Inline Pi API types (no SDK import) | 50 | Extension runs in Pi's runtime which provides types; no build step |
| Context hook checks last 5 messages for PALS detection | 50 | Balance between detection accuracy and performance |
| Pi adapter remains a thin, artifact-safe shell over shared markdown workflows | 53 | Audit confirmed current Pi implementation is directionally correct and should be refined rather than replaced |
| Pi-native depth should increase via adapter-only improvements, not shared artifact divergence | 53 | Future Pi roadmap work should preserve cross-harness compatibility while improving command, hook, and UX fit |
| PALS needs a more mature Pi-native shell around the existing artifact-safe architecture, not a Pi-specific redesign | 54 | Directs future Pi work toward adapter refinement rather than replacing the shared artifact model |
| Prioritize context injection, command ergonomics, and lifecycle visibility in Phase 55 recommendations | 54 | Establishes the main ranking frame for Pi roadmap guidance |
| v2.3 should begin with Pi interaction model refinement before broader UX or runtime experiments | 55 | Converts the v2.2 recommendation work into the next milestone direction |
| Preserve shared markdown artifacts as the authoritative lifecycle layer while refining Pi-native interaction quality | 55 | Ensures future Pi implementation work deepens native fit without semantic divergence |
| Prefer a hybrid Pi event model over a single-hook redesign | 56 | Separating orientation, activation, and injection responsibilities produces a clearer adapter architecture than centering everything on one hook | Gives later implementation work a stable event model to build on |
| Make `before_agent_start` the primary workflow-context decision point | 56 | It offers a stronger timing boundary than the current regex-driven `context` hook while staying adapter-only | Focuses future runtime refinement on a specific Pi-native surface |
| Reduce `context` to a narrow supporting role while keeping `.paul/*` authoritative | 56 | Preserves the useful parts of the current adapter without letting prompt shaping become hidden lifecycle truth | Protects artifact-first semantics as later Pi UX work deepens native fit |
| Keep `/paul-*` as Pi-native convenience wrappers and `/skill:paul-*` as canonical entry points | 57 | Improves discoverability without forking workflow semantics into TypeScript |
| Keep added routing guidance brief and command-local | 57 | Preserves command discoverability gains without materially increasing Pi runtime context load |
| Keep Phase 58 focused on wording, metadata, and validation only | 58 | Closes the milestone with low-risk consistency work instead of reopening behavior changes |
| Extend validation to cover Pi consistency claims | 58 | Makes future Pi adapter drift easier to detect and correct |
| Reuse one shared lifecycle snapshot for Pi notifications, status, widget, and injected context | 59 | Keeps adapter-only lifecycle semantics in one parsing path and reduces drift across Pi UI surfaces |
| Keep Pi quick actions bounded and route shortcut entry points through the existing wrapper layer | 60 | Preserves low-clutter UX while avoiding Pi-only workflow semantics or duplicate routing logic | Extends the lifecycle surface into interaction without breaking canonical skill ownership |
| Pi should explain TODD/WALT as installed module overlays from `modules.yaml`, not standalone Pi skills | 61 | First end-to-end Pi APPLY exposed a skill-vs-module ambiguity; documenting the real model preserves workflow truth while improving usability |
| Explicit command entry is the strongest Pi activation signal; `before_agent_start` owns primary bounded injection while `context` remains support-only | 62 | Implements the Phase 56 hybrid event model directly in runtime code while preserving `.paul/*` as the authoritative lifecycle truth |
| Guided workflow assistance in Pi must stay marker-driven, explicit, and routed through canonical user-message flow | 63 | Keeps the adapter helpful at approval/checkpoint/resume/transition moments without inventing Pi-owned lifecycle truth |
| Use `matchAll(/[✓○]/g)` count for loop badge extraction; "success" level only for confirmed sends/routes | 64 | Keeps UX enrichment simple, robust, and bounded to additive cosmetic changes only |
| Keep artifact-first shared markdown workflows as lifecycle truth while improving collaborative definition behavior | 65 | Audit showed collaboration weaknesses come from workflow behavior and artifact population, not from the authority model itself |
| Add low/medium/high collaboration levels plus project default and per-run override for planning work | 65 | Matches user need for adjustable collaboration depth across project, milestone, and phase planning |
| Add a 4-option pre-plan review choice: quick recap, detailed recap, full plan, no review needed | 65 | Introduces progressive disclosure before APPLY without changing execution-loop semantics |
| Keep planning collaboration shared-workflow driven via `pals.json` `planning.default_collaboration` plus per-run overrides | 66 | Preserves artifact-first portability while making init/discuss/milestone/plan behavior more collaborative |
| Extend Pi guided workflow UX to surface the 4-option review menu without introducing Pi-owned workflow state | 66 | Keeps Pi additive-only while supporting the shared planning review flow |
| Adopt a layered durable artifact model with compact `PROJECT.md` hot-path context plus selectively-read `PRD.md` depth | 67 | Settles the content/read/file model for richer onboarding without bloating the hot path |
| Keep `PRD.md` additive and legacy-safe for existing repos rather than forcing destructive migration | 67 | Preserves portability while allowing validation and docs to codify the new layered contract |
| Treat the module system as more wired than visible | 68 | Audit found source manifests and the installed Pi registry aligned; the main trust problem is weak proof and visibility, not declared hook drift |
| Prioritize execution-proof fixes before visibility UX | 68 | Post-unify reporting and lifecycle evidence need to be made durable before richer UI surfaces are added |
| Finalize summary evidence after post-unify instead of treating the first SUMMARY write as final | 69 | Keeps post-unify-capable module contributions durably visible in SUMMARY/FIX-SUMMARY artifacts |
| Use `module_reports` for persisted post-unify content and `side_effects` for non-blocking follow-on actions | 69 | Gives workflows, specs, overlays, and validation one durable reporting contract before Phase 70 UX work |
| 2026-03-18: Derive live module visibility from recent shared workflow/reporting signals rather than registry presence alone | 70 | Keeps Pi module visibility trustworthy without inventing a second execution ledger |
| 2026-03-18: Reuse existing Pi status/widget surfaces for recent module activity instead of adding new dashboards or telemetry | 70 | Delivers bounded visibility with additive adapter-only UX |
| 2026-03-18: Treat `Module Execution Reports` as a bounded fallback alongside recent `[dispatch]` output for live visibility | 70 | Keeps post-unify-visible module activity legible without Pi-owned persistence |
| 2026-03-18: Keep the module roster and improve legibility before considering merge/remove changes | 71 | Audit evidence showed opacity more than dead weight, so future work should refine recommendation/report clarity rather than destabilize module boundaries |
| 2026-03-18: Standardize a layered proof model across dispatch trace, durable reports, side effects, validation, and bounded Pi live visibility | 71 | Preserves artifact-first truth while making module participation legible without telemetry or Pi-owned execution state |
| 2026-03-18: All three CARL-critical Pi APIs work as documented; no design changes needed | 76 | Phase 77 can proceed with carl-pi-design.md architecture unchanged |
| 2026-03-18: 40% continue_threshold and 80% safety_ceiling are reasonable defaults for CARL | 76 | pals.json carl config uses these as defaults |
| 2026-03-18: Stashed command context lifetime across agent_end needs Phase 77 validation | 76 | Early Phase 77 task must test stashing across event handler boundaries |
| 2026-03-18: CARL logic inside palsHooks() closure sharing pi/activation/guided-workflow state | 77 | Self-contained without module-level exports |
| 2026-03-18: Loop signature change detection prevents false positives from repeated agent_end calls | 77 | CARL triggers once per actual phase completion |
| 2026-03-18: session_start seeds previousLoopSignature to avoid spurious session creation on resume | 77 | Prevents CARL from misreading already-complete loop state |
| 2026-03-18: CARL config fields live inside modules.carl in pals.json alongside enabled/description | 78 | Consistent with existing module pattern; loadCarlConfig reads this path |
| 2026-03-18: CARL module version bumped to 2.0.0 for architectural shift from rule injection to session boundary | 78 | Clear signal of role change in module registry |
| REV has no lifecycle hooks; it is on-demand and PR-level only | 151 | Keeps review deliberate and avoids expensive automatic dispatch when IRIS already covers lightweight post-apply review |
| REV runs in foreground and blocks until review completes | 151 | On-demand review and merge-gate review both need the result before the workflow can proceed |
| `modules.rev.model` is nullable and falls back to agent/session defaults | 151 | Preserves flexible model control without forcing a PALS-only override |
| `modules.rev.pr_review` defaults to false | 151 | Merge-gate review remains opt-in and adds zero default overhead |
| Design a parent-controlled PALS-native implementer contract instead of adopting the generic runtime `implementer` | 154 | Audit showed current runtime agents are useful primitives but not authoritative APPLY semantics |
| Install project-shipped Pi agents globally during Pi driver install instead of relying on repo-local discovery alone | 156 | Ensures `pals-implementer` works in repos that use installed PALS without requiring extra agent-scope setup |
| Separate total artifact growth from repeat-read hot-path cost before designing fixes | 158 | Prevents blanket cleanup instincts from blurring historical accumulation with active Pi context pressure |
| Treat `STATE.md` as the confirmed hot artifact and `ROADMAP.md` as the main warm-path artifact | 158 | Future reduction work should optimize repeated-read pressure first, not just largest files |
| Preserve `PROJECT.md` as the compact brief instead of using it to absorb roadmap or milestone history | 158 | The layered artifact model is working here; expanding PROJECT would recreate the same bloat problem elsewhere |
| Keep workflow-side amplification separate from artifact-side cost until Phase 160 combines both evidence streams | 159 | Preserves a clean recommendation baseline and avoids blurring root causes across the two audit phases |
| Preserve guided workflow markers and target surrounding prose/read bundles first for workflow-bloat reduction | 159 | Enables safer wording/read-discipline cleanup without destabilizing guided UX semantics |
| Reduce workflow amplification before attempting hotter artifact redesign | 160 | The combined audit shows the safest high-value wins are in wrapper/read-discipline/prose cleanup before touching `STATE.md` structure |
| Treat `ROADMAP.md` as the clearest combined reduction target while preserving `PROJECT.md` and guided markers | 160 | `ROADMAP.md` is the main warm-path artifact amplified by workflow bundling, while `PROJECT.md` and canonical markers are stabilizing behaviors worth keeping |
| Align the canonical `pals.json` contract around an explicit `agents.implementer` block before expanding delegated APPLY coverage | 164 | Keeps future delegation work grounded in init/migration/schema defaults rather than repo-local runtime assumptions |
|| Broaden delegated APPLY eligibility around bounded parent-verifiable tasks rather than a parallel-only subagent heuristic | 165 | Makes delegated APPLY practical for more auto tasks without weakening parent authority, fallback, or lifecycle ownership |
|| Keep fresh-project docs and installed-surface validation aligned with the implementer/delegation contract | 166 | Prevents README/Pi/runtime drift from silently reintroducing configuration or authority ambiguity |
|| 2026-04-01: Collapse the persistent Pi lifecycle widget to a strict 4-line panel centered on milestone, phase, loop, and next action | 167 | Gives Phase 168 a clear implementation target and removes shortcut/module clutter from the main daily-use surface |
|| 2026-04-01: Use semantic lifecycle color for meaning, not decoration, and keep v2.38 bounded to polish of the existing surface | 167 | Preserves the additive Pi model without expanding into a new widget system or shifting lifecycle truth into Pi |
| 2026-04-01: Keep the compact Pi lifecycle status text-first and preserve direct `renderLoopBadge(state.loop)` wiring while Phase 169 owns docs/validation alignment | 168 | Delivers the calmer Phase 168 runtime polish without broadening scope into validation-contract churn or fragile styling experiments |
| 2026-04-01: Keep Phase 169 lifecycle alignment semantic and documentation-first when runtime wording already matches | 169 | The shipped runtime already fit the calmer contract, so the safest closeout was docs + validation alignment rather than unnecessary render-path churn |
| 2026-04-16: CODI v0.1 ships with no prerequisite checks and no tool calls; tool-availability handling is deferred to Phase 171 call-time failure handling rather than a pre-dispatch proxy check | 170 | Honest about what a markdown hook description can reliably introspect; keeps v0.1 minimal and honors the source-plan's "skip cleanly rather than erroring" intent at the correct layer |
| 2026-04-16: Installer is already fully registry-driven; adding a new PALS module requires zero installer/kernel/workflow code changes | 170 | Establishes the canonical pattern for future module additions and is the reason Phase 170's scope shrank from "4 phases of scaffolding" to "2 files" |
| 2026-04-16: CODI uses "halt" and "skip" instead of "block" in its manifest description | 170 | The shared dispatch classifier in `plan-phase.md` uses strict substring matching on "block" to distinguish advisory from enforcement hooks; documented in the reference doc so future maintainers don't reintroduce the token |
| 2026-04-16: CODI call pattern is per-symbol, NOT batched — `impact` is all-or-nothing on unresolved input and batching would destroy partial results | 171 | Generalizes to future codegraph tool integrations (`symbol_graph` v0.2, `trace` v0.3); documented alongside the input-self-filter quirk discovered during Phase 171 planning |
| 2026-04-16: Classifier-safety invariant tightens at the module surface — the halt-keyword token is now avoided across manifest description AND reference doc natural prose | 171 | Prevents future module edits from reintroducing the time bomb via innocent prose; "sub-section" and "code region" replace the common alternative across all CODI surfaces |
| 2026-04-16: Empirical probing during PLAN is a high-value practice when a tool's contract materially shapes the plan | 171 | Phase 171 spent ~5 tool calls during PLAN to surface 3 assumption errors that would have caused silent data loss in APPLY; pattern worth codifying for future CODI-family phases |
| 2026-04-16: Partial-success invariant decouples per-symbol outcomes (5 categories) from hook-level skip paths (4 paths) | 171 | Two-layer separation is what makes the partial-success guarantee coherent; R/U/K success log carries diagnostic granularity for Phase 173's real-world trial |
| 2026-04-17: Add deterministic CODI seed ordering, repo-root `modules.codi` dogfood, and semantic validation markers | 172 | Keeps prose-heavy plan coupling bounded and default-on config/docs aligned without brittle prose assertions or new runtime enforcement |
| 2026-04-17: Treat upcoming-plan `<context>` repo-relative `.ts/.tsx/.js/.jsx` files as bounded source selectors and promote only extracted stable identifiers to `impact` candidates | 174 | Fixes extractor-vs-scope alignment without turning CODI into semantic guessing or raw-path `impact` dispatch |
| 2026-04-17: Use `.codegraph/graph.db` only as a bounded install-time CODI heuristic; never auto-disable CODI or gate install on its absence | 175 | Keeps CODI's advisory posture honest — installer surfaces a single recommendation without mutating config or conflating repo state with runtime tool availability |
| 2026-04-17: Document CODI as a TS/JS-touching indexed-code helper and pin success-log `R` to resolved-with-call-sites only | 175 | Aligns manifest, reference doc, README, and changelog around one honest value envelope and removes the resolved-but-empty ambiguity before Phase 177's re-trial |

## Success Criteria
- The ultimate user friendly end-to-end Claude Code software development framework is achieved
- Single `git clone` + install script gets PALS working
- Full PLAN-APPLY-UNIFY loop works on test project

## Specialized Flows

See: .paul/SPECIAL-FLOWS.md

Quick Reference:
- /paul → Project planning & lifecycle management
- /carl → Session boundary manager — autonomous session transitions
- TODD → Test-driven development enforcement
- WALT → Quality gating & validation

---
*Created: 2026-03-11*
*Last updated: 2026-04-18 after Phase 178 UNIFY (v2.41 CODI cross-repo install completed in quark; Phase 179 observation window is the next planned work after merge/transition).*
