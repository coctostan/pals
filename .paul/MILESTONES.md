# Milestones

Completed milestone log for this project.

| Milestone | Completed | Duration | Stats |
|-----------|-----------|----------|-------|
| v0.1 Fork & Unify | 2026-03-11 | 1 day | 6 phases, 10 plans |
| v0.2 Polish | 2026-03-11 | 1 day | 1 phase, 1 plan |
| v0.3 Smart Context & Migration | 2026-03-11 | 1 day | 2 phases, 2 plans |
| v0.4 Kernel & Modules | 2026-03-12 | 2 days | 4 phases, 7 plans |
| v0.5 TODD & WALT Go Live | 2026-03-12 | 1 day | 3 phases, 3 plans |
| v0.6 Enhance & Expand | 2026-03-12 | 1 day | 5 phases, 5 plans |
| v0.7 Full Roster & Lifecycle Integration | 2026-03-12 | 1 day | 4 phases, 4 plans |
| v0.8 Configuration & Polish | 2026-03-12 | 1 day | 2 phases, 2 plans |
| v0.9 Observability & Context Health | 2026-03-13 | 1 day | 2 phases, 3 plans |
| v0.9.1 Release Readiness | 2026-03-13 | 1 day | 3 phases, 4 plans |
| v0.9.2 Competitive Intelligence | 2026-03-13 | 1 day | 1 phase, 1 plan |

---

## ✅ v0.9.2 Competitive Intelligence

**Completed:** 2026-03-13
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 1 |
| Plans | 1 |
| Frameworks researched | 15 |
| Research subagents | 5 (parallel) |

### Key Accomplishments

- Benchmarked PALS against 15 agentic coding frameworks (BMAD, OhMyOpenCode, Superpowers, OpenSpec, SpecKit, Aider, Cline, Continue.dev, SWE-agent, OpenHands, MetaGPT, GPT Pilot, Cursor rules, Mentat, Devin)
- Identified 3 critical gaps: brownfield support, lightweight fix loop, fast-forward escape hatch
- Mapped 6 strong differentiators: UNIFY phase (unique), modular architecture, TDD enforcement, quality gating, session continuity, named module personalities
- Recommended v1.0 phases: 35 (fix/hotfix), 36 (brownfield), 37 (resilience/isolation)
- Identified Superpowers as closest competitor; PALS differentiates with UNIFY, modules, session continuity

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Brownfield is #1 adoption barrier | 34 | Must address in v1.0 |
| Lightweight fix loop critical | 34 | Full loop for 1-file bugs drives users away |
| Do NOT build autonomous execution | 34 | Supervised approach is correct |
| Do NOT build IDE plugins | 34 | CLI-first via drivers is right abstraction |

---

## ✅ v0.9.1 Release Readiness

**Completed:** 2026-03-13
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 3 |
| Plans | 4 |
| Files changed | ~20 (created modules, docs, configs) |

### Key Accomplishments

- Config-driven git automation: pals.json git config (5 fields), auto branching/PR/push/CI support with conservative defaults
- Module builder's guide (7-step walkthrough + DEAN worked example), troubleshooting guide (5 categories, 19 entries), changelog (v0.1 through v0.9.1)
- DOCS module — 9th pal providing documentation drift detection and currency checking via lifecycle hooks (advisory priority 200-250)

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| All git automation defaults to off | 31 | Users must opt in during init |
| Git config in pals.json (not separate file) | 31 | Single config file |
| DEAN as worked example in module builder's guide | 32 | Simplest real module for tutorial |
| Keep Changelog format | 32 | Industry standard |
| DOCS uses advisory priority (200-250) | 33 | Non-blocking doc awareness |
| No kernel command for DOCS in v1 | 33 | Visibility via hooks first |

---

## ✅ v0.9 Observability & Context Health

**Completed:** 2026-03-13
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 2 (Phase 30 skipped — conditional, deemed unnecessary) |
| Plans | 3 |
| Files changed | 32 (2 created, 30 modified) |

### Key Accomplishments

- Measured all 27 module reference files, identified WALT/TODD as 55% of context weight, trimmed 15 files achieving 43% total reduction (4,507 to 2,550 lines)
- Established context budgets: 150 lines/file, 750 lines/core module, 350 lines/standard module
- Per-hook reference mapping in 7 modules — each hook loads only what it needs
- Formal context_inject schema with format types and per-hook injection table in MODULE-SPEC.md
- Dispatch log instructions at every hook point in plan/apply/unify workflows
- Failure cascading documentation across hook points (MODULE-SPEC.md 3.6-3.8)
- State recovery playbook for non-destructive STATE.md repair

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| 150-line hard cap per reference file | 28 | Bounded context load per hook dispatch |
| Separate budgets: 750 lines core, 350 standard | 28 | Core modules get 2x budget due to deeper integration |
| Per-hook refs in module.yaml (not all module refs) | 29 | Each hook loads only what it needs |
| post-task block skips tasks but post-apply still fires | 29 | Cleanup/reporting always runs |
| Three detection outcomes: found-standard, found-non-standard, not-found | 29 | Non-standard warns, never silently skips |
| Phase 30 skipped — context sustainable after Phase 28 optimization | 30 | No ongoing monitoring tool needed |

---

## ✅ v0.5 TODD & WALT Go Live

**Completed:** 2026-03-12
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 3 |
| Plans | 3 |
| Files changed | 5 (2 created, 3 modified) |

### Key Accomplishments

- Created TODD hook-mapping workflow (plan-phase-tdd.md) with 5 hook definitions covering full TDD lifecycle: detection → plan restructuring → RED/GREEN/REFACTOR enforcement
- Created WALT hook-mapping workflow (apply-phase-quality.md) with 3 hook definitions: baseline capture → quality gate → history recording
- Added missing post-task hook dispatch to kernel apply-phase.md (discovered during TODD integration)
- Fixed broken @src/ references in WALT's quality-gate.md
- Validated full module system: all 8 hooks dispatch correctly, all 10 reference files resolve, priority ordering verified, module enable/disable works
- Documented complete hook dispatch trace for PLAN → APPLY → UNIFY lifecycle

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Dual-purpose workflow files (hook handler + standalone) | 14 | One file serves both kernel dispatch and direct invocation |
| Each hook maps to exactly 2 reference files (not all) | 15 | Minimize context per dispatch; efficient kernel hook resolution |
| quality-principles.md excluded from per-hook loading | 15 | Foundational context only, not execution-specific |
| Module system validated via audit (no code changes needed) | 16 | All dimensions passed clean — system is production-ready |

---

## ✅ v0.4 Kernel & Modules

**Completed:** 2026-03-12
**Duration:** 2 days (2026-03-11 to 2026-03-12)

### Stats

| Metric | Value |
|--------|-------|
| Phases | 4 |
| Plans | 7 |
| Files changed | 23 (17 created, 6 modified) |

### Key Accomplishments

- Designed the kernel/module/driver three-layer architecture with 4 specification documents (ARCHITECTURE.md, MODULE-SPEC.md, DRIVER-SPEC.md, KERNEL-MANIFEST.md)
- Restructured repo into kernel/ (85 files) and modules/ (28 files) directories via atomic migration script
- Decoupled kernel workflows from hardcoded TODD/WALT references — replaced with generic lifecycle hook dispatch via modules.yaml
- Built manifest-driven installer that reads module.yaml dynamically — drop a new module in modules/ and it auto-installs
- Created pals CLI for module management (list/install/remove) and module-aware uninstall
- Extracted Claude Code driver into drivers/claude-code/ — root installer delegates platform-specific setup
- Built Agent SDK driver stub proving kernel runs headless via query() API with workflow-as-system-prompt
- Created pals.yaml config and generated modules.yaml registry for runtime hook dispatch

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Three-layer stack: Modules → Kernel → Drivers | 10 | Each layer only talks to neighbors |
| 8 lifecycle hook points with composition rules | 10 | Module integration contract |
| 5 driver methods: workflow_invoke, hook_register, state_read/write, user_interact, command_register | 10 | Platform abstraction |
| Delegated workflows stay in kernel | 10 | Fork kernel for different tools, modules for optional pals |
| Migration script over raw file moves | 11 | Prevents breaking live infrastructure |
| Inline Python YAML parser (no PyYAML dependency) | 12 | Zero-dependency installer |
| Claude Code driver is install-time wiring, not runtime code | 13 | The LLM IS the runtime driver |
| Driver detection: PALS_DRIVER env > ~/.claude/ > ANTHROPIC_AGENT_SDK > default | 13 | Install-time driver resolution |

---

## ✅ v0.3 Smart Context & Migration

**Completed:** 2026-03-11
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 2 |
| Plans | 2 |

### Key Accomplishments

- Upgrade-aware installer with legacy ~/.claude/paul-framework/ cleanup
- Auto context cycling researched — deferred (no programmatic /clear available)

---

## ✅ v0.2 Polish

**Completed:** 2026-03-11
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 1 |
| Plans | 1 |

### Key Accomplishments

- /paul:* namespace standardized (removed /pals:* duplication)
- Install/uninstall scripts updated for /paul:* namespace
- Cleanup artifacts removed

---

## ✅ v0.1 Fork & Unify

**Completed:** 2026-03-11
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 6 |
| Plans | 10 |

### Key Accomplishments

- Architecture mapped (111 files across 4 components)
- Unified structure designed (105 destinations, 6 consolidations)
- PALS repo created with 96 PAUL files migrated
- TODD/WALT integrated as named subsystems
- CARL integrated as independent component
- Single install script from git clone
- End-to-end validation passed

---
*Milestones log created: 2026-03-12*
