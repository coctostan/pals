# Changelog

All notable changes to PALS are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased] — v0.9.1 Release Readiness

### Added
- Config-driven git automation in kernel workflows — auto-commit, auto-push, auto-PR, CI checks, branching strategy (Phase 31)
- `pals.json` git config section with 5 fields, defaults all off for safety (Phase 31)
- Init workflow `configure_git` step for interactive git setup (Phase 31)
- PALS documentation — module builder's guide, troubleshooting guide, changelog (Phase 32)

### Changed
- `transition-phase.md` now reads git config and runs post-commit automation (Phase 31)
- `complete-milestone.md` now conditionally auto-pushes tags and branches from config (Phase 31)
- `pause-work.md` now defaults branch naming from `pals.json` branching config (Phase 31)
- All remote operations guard on `remote != null` for graceful local-only degradation (Phase 31)

### Decisions
- Git automation is kernel-level, not a separate module (Phase 31)
- All git automation defaults to off — users opt in during init (Phase 31)

## [0.9.0] — 2026-03-13

### Added
- Context audit tooling — measured 27 reference files, established per-module budgets (Phase 28)
- Per-hook `refs` in `module.yaml` — each hook loads only what it needs (Phase 29)
- `context_inject` schema for structured data passing between hooks (Phase 29)
- Dispatch log output in 3 kernel workflows (Phase 29)
- Failure cascading and state recovery documentation (Phase 29)

### Changed
- Trimmed 15 reference files, reducing total from 4,507 to 2,550 lines (43% reduction) (Phase 28)
- Established 150-line hard cap per reference file (Phase 28)
- Separate budgets: 750 lines core modules, 350 lines standard modules (Phase 28)

### Removed
- Phase 30 (Context Monitor) — skipped, Phase 28 optimization made it unnecessary

### Decisions
- `post-task` block skips remaining tasks but `post-apply` still fires for reporting (Phase 29)
- Three detection outcomes: found-standard, found-non-standard, not-found (Phase 29)

## [0.8.0] — 2026-03-12

### Added
- `pals.json` configuration file replacing `pals.yaml` (Phase 26)
- `/paul:config` command — dashboard with module toggle, integration management (Phase 26)
- Module selection during `/paul:init` interactive setup (Phase 26)
- Publication-quality README with 3-layer architecture, 9-pal catalog, 40 commands (Phase 27)

### Decisions
- JSON over YAML for config — standard tooling, no custom parser needed (Phase 26)
- All 8 modules enabled by default in config (Phase 26)
- README groups commands into 7 functional categories (Phase 27)

## [0.7.0] — 2026-03-12

### Added
- SKIP module — smart knowledge & information persistence with 5 knowledge types (Phase 22)
- DAVE module — deploy automation & verification engine with 4 modes, 12+ language detectors (Phase 23)
- RUBY module — refactor utility & better-code yielder with 3 modes, 9 refactoring patterns (Phase 24)
- Lifecycle hooks for all 8 pals — 16 hook registrations across 6 hook points (Phase 25)
- Priority-based hook dispatch ordering (Phase 25)

### Decisions
- CARL excluded from lifecycle hooks — uses platform hooks only, per Phase 4 design (Phase 25)
- Each module follows established pattern: no hooks initially, hooks added in Phase 25 (Phases 22-24)

## [0.6.0] — 2026-03-12

### Added
- CARL auto-detection with YAML rule catalog for 11 technologies (Phase 17)
- `*scan` command for automatic technology detection and rule suggestion (Phase 17)
- TODD `/paul:coverage` command — test coverage dashboard for 9 frameworks (Phase 18)
- WALT `/paul:quality` command — quality trend dashboard with streak/regression/stall detection (Phase 19)
- DEAN module — dependency evaluation & audit notifier for 10 ecosystems (Phase 20)
- IRIS module — intelligent review & inspection system with 25 patterns, 5 checklists (Phase 21)

### Decisions
- YAML catalog pattern for extensible detection — add technologies by editing YAML (Phase 17)
- Advisory thresholds for coverage, not enforcement (Phase 18)
- Zero-value stalls treated as positive — lint/types at 0 means clean code (Phase 19)
- DEAN and IRIS start read-only (no hooks), enforcement added later (Phases 20-21)

## [0.5.0] — 2026-03-12

### Added
- TODD hook mapping — `plan-phase-tdd.md` workflow with 5 kernel hook dispatch instructions (Phase 14)
- WALT hook mapping — `apply-phase-quality.md` workflow with 3 kernel hook dispatch instructions (Phase 15)
- TODD TDD enforcement end-to-end: detection → plan restructuring → RED/GREEN/REFACTOR (Phase 14)
- WALT quality gating end-to-end: baseline → regression detection → history (Phase 15)
- Module system validation — both modules active simultaneously, verified clean (Phase 16)

### Decisions
- Each module hook maps to exactly 2 reference files to minimize context per dispatch (Phase 15)

## [0.4.0] — 2026-03-12

### Added
- Three-layer architecture: Modules → Kernel → Drivers (Phase 10)
- Kernel extraction — PAUL core separated from modules (Phase 11)
- CARL, TODD, WALT refactored as loadable modules with `module.yaml` manifests (Phase 11)
- Module manager and `modules.yaml` registry (Phase 12)
- Module-aware installer with `pals.yaml` config and `pals` CLI (Phase 12)
- Agent SDK driver proof-of-concept — headless kernel via `query()` API (Phase 13)
- Claude Code driver — install-time wiring, not runtime code (Phase 13)

### Decisions
- "Linux of Harness Engineering" vision established (Phase 10)
- Delegated workflows stay in kernel — only named pals become modules (Phase 10)
- Claude Code driver is install-time wiring; the LLM IS the runtime driver (Phase 13)
- Driver detection order: PALS_DRIVER > ~/.claude/ > ANTHROPIC_AGENT_SDK > default (Phase 13)

## [0.3.0] — 2026-03-11

### Added
- Upgrade-aware installer with legacy `~/.claude/paul-framework/` cleanup (Phase 8)
- Interactive y/N prompt for legacy cleanup with safe default (Phase 8)

### Changed
- Auto context cycling researched and deferred — no programmatic `/clear` exists (Phase 9)

## [0.2.0] — 2026-03-11

### Changed
- `/pals:*` namespace reverted to `/paul:*` — PAUL is the subsystem name (Phase 7)
- Install/uninstall scripts updated for `/paul:*` namespace (Phase 7)
- Test lifecycle artifacts cleaned up (Phase 7)

## [0.1.0] — 2026-03-11

### Added
- Architecture fully mapped — 111 files across 4 components (Phase 1)
- Unified structure designed — 105 destinations, 6 consolidations (Phase 1)
- PALS repo created with 96 PAUL files migrated (Phase 2)
- All `@`-references rewritten to `~/.pals/` paths (Phase 2)
- TODD/WALT integrated as named subsystems with identity preserved (Phase 3)
- CARL integrated with own subdirectory and `/carl:*` namespace retained (Phase 4)
- Single `install.sh` from git clone (Phase 5)
- Uninstall/cleanup script (Phase 5)
- Getting-started documentation (Phase 5)
- End-to-end validation of full plan-apply-unify loop (Phase 6)

### Decisions
- CARL is fully independent — hook-level integration only, no file-level refs (Phase 1)
- TODD/WALT are named integrated subsystems, retain identity (Phase 1)
- Flat `workflows/` directory — TODD/WALT steps inline in parent workflows (Phase 1)
- `/paul:*` namespace with `/carl:*` retained for CARL independence (Phase 1)
