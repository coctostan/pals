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

## Constraints
- CARL remains architecturally independent (hook-level integration only)
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

## Success Criteria
- The ultimate user friendly end-to-end Claude Code software development framework is achieved
- Single `git clone` + install script gets PALS working
- Full PLAN-APPLY-UNIFY loop works on test project

## Specialized Flows

See: .paul/SPECIAL-FLOWS.md

Quick Reference:
- /paul → Project planning & lifecycle management
- /carl → Context rules & domain configuration
- TODD → Test-driven development enforcement
- WALT → Quality gating & validation

---
*Created: 2026-03-11*
*Last updated: 2026-03-12 after Phase 26 Module Configuration & Init complete (v0.8 in progress)*
