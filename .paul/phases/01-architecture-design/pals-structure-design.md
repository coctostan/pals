# PALS Unified Structure Design

**Generated:** 2026-03-11
**Purpose:** Blueprint for unifying PAUL, CARL, TODD, and WALT into a single distributable framework
**Input:** architecture-audit.md (111 files mapped)

---

## 1. Target Root

**Installation root:** `~/.pals/`

**Rationale:**
- Clean namespace — not `~/.claude/paul-framework/` buried inside Claude's config
- Mirrors the project name (PALS)
- Single location for all framework files
- Easy to `git clone` and symlink/install
- `.pals/` in project directories continues to hold project state (no change)

**Repository root:** `~/claude/pals/` (this repo)
- Contains the source of truth
- Install script copies/symlinks from repo to `~/.pals/`

---

## 2. Directory Tree

```
~/.pals/
├── workflows/                    # Core lifecycle workflows (PAUL + TODD + WALT merged)
│   ├── plan-phase.md             # Plan creation (includes TDD detection inline)
│   ├── apply-phase.md            # Plan execution (includes TDD + quality gates inline)
│   ├── unify-phase.md            # Reconciliation (includes quality delta inline)
│   ├── init-project.md
│   ├── resume-project.md
│   ├── pause-work.md
│   ├── complete-milestone.md
│   ├── create-milestone.md
│   ├── discuss-phase.md
│   ├── discuss-milestone.md
│   ├── phase-assumptions.md
│   ├── roadmap-management.md
│   ├── transition-phase.md
│   ├── verify-work.md
│   ├── consider-issues.md
│   ├── configure-special-flows.md
│   ├── discovery.md
│   ├── research.md
│   ├── map-codebase.md
│   ├── debug.md
│   └── quality-gate.md           # Standalone SonarQube (WALT)
│
├── references/                   # Conceptual docs and specifications
│   ├── plan-format.md
│   ├── loop-phases.md
│   ├── checkpoints.md
│   ├── context-management.md
│   ├── work-units.md
│   ├── git-strategy.md
│   ├── quality-principles.md
│   ├── subagent-criteria.md
│   ├── specialized-workflow-integration.md
│   ├── sonarqube-integration.md
│   ├── research-quality-control.md
│   ├── tdd.md                    # TDD principles (from TODD)
│   ├── tdd-detection.md          # TDD heuristics (from TODD)
│   ├── quality-detection.md      # Tool detection (from WALT)
│   ├── quality-runner.md         # Test runner (from WALT)
│   ├── quality-lint.md           # Lint/typecheck (from WALT)
│   ├── quality-delta.md          # Quality delta tracking (from WALT)
│   ├── quality-history.md        # Quality history (from WALT)
│   └── ci-generation.md          # CI workflow generation (from WALT)
│
├── templates/                    # File templates for generated artifacts
│   ├── PLAN.md
│   ├── SUMMARY.md
│   ├── PROJECT.md
│   ├── ROADMAP.md
│   ├── STATE.md
│   ├── HANDOFF.md
│   ├── CONTEXT.md
│   ├── DEBUG.md
│   ├── DISCOVERY.md
│   ├── ISSUES.md
│   ├── RESEARCH.md
│   ├── SPECIAL-FLOWS.md
│   ├── UAT-ISSUES.md
│   ├── config.md
│   ├── milestone-archive.md
│   ├── milestone-context.md
│   ├── MILESTONES.md
│   └── codebase/                 # Codebase mapping templates
│       ├── architecture.md
│       ├── concerns.md
│       ├── conventions.md
│       ├── integrations.md
│       ├── stack.md
│       ├── structure.md
│       └── testing.md
│
├── rules/                        # Framework authoring rules
│   ├── commands.md
│   ├── references.md
│   ├── style.md
│   ├── templates.md
│   └── workflows.md
│
├── carl/                         # Context & rules system (CARL)
│   ├── manifest                  # Domain registry
│   ├── global                    # Universal rules (always on)
│   ├── context                   # Context-aware rules (bracket detection)
│   ├── commands                  # Star-commands (*dev, *review, etc.)
│   └── example-custom-domain     # Template for custom domains
│
├── commands/                     # Skill command definitions
│   ├── pals/                     # Unified PALS commands (replacing paul/)
│   │   ├── add-phase.md
│   │   ├── apply.md
│   │   ├── assumptions.md
│   │   ├── complete-milestone.md
│   │   ├── config.md
│   │   ├── consider-issues.md
│   │   ├── discover.md
│   │   ├── discuss-milestone.md
│   │   ├── discuss.md
│   │   ├── flows.md
│   │   ├── handoff.md
│   │   ├── help.md
│   │   ├── init.md
│   │   ├── map-codebase.md
│   │   ├── milestone.md
│   │   ├── pause.md
│   │   ├── plan-fix.md
│   │   ├── plan.md
│   │   ├── progress.md
│   │   ├── remove-phase.md
│   │   ├── research-phase.md
│   │   ├── research.md
│   │   ├── resume.md
│   │   ├── unify.md
│   │   └── verify.md
│   └── carl/                     # CARL management commands
│       ├── manager.md
│       ├── tasks/
│       │   ├── add-rule.md
│       │   ├── create-domain.md
│       │   ├── create-command.md
│       │   ├── edit-rule.md
│       │   └── toggle-domain.md
│       └── templates/
│           ├── domain-template.md
│           └── manifest-entries.md
│
├── hooks/                        # Claude Code hook scripts
│   └── (populated during Phase 4 — CARL hook wiring)
│
└── install.sh                    # Setup script (populated during Phase 5)
```

---

## 3. Naming Conventions

### File Naming
| Category | Pattern | Example |
|----------|---------|---------|
| Workflows | `kebab-case.md` | `apply-phase.md` |
| References | `kebab-case.md` | `quality-runner.md` |
| Templates | `UPPER-CASE.md` or `kebab-case.md` | `PLAN.md`, `config.md` |
| Rules | `kebab-case.md` | `workflows.md` |
| Commands | `kebab-case.md` | `plan-fix.md` |
| CARL domains | `no-extension` (plain text) | `manifest`, `global` |

### Command Namespace

**Before (scattered):**
- `/paul:plan`, `/paul:apply`, `/paul:unify`, ...
- `/carl:manager`, `/carl:tasks:add-rule`, ...

**After (unified):**
- `/pals:plan`, `/pals:apply`, `/pals:unify`, ... (replacing `/paul:*`)
- `/carl:manager`, `/carl:tasks:add-rule`, ... (CARL keeps its namespace)

**Rationale:** CARL maintains its own identity because:
1. It's fully independent (hook-level integration only, per 01-01 findings)
2. Users may use CARL without PALS lifecycle features
3. `/carl:*` is already intuitive for rule management

**Deprecated:** `/paul:status` → removed entirely (replaced by `/pals:progress`)

### Component Identity

TODD, WALT, PAUL, and CARL **retain their names** as subsystems within PALS. They are tightly integrated — no separate directories or delegation indirection — but their identity is preserved:
- TODD steps are labeled "TODD:" in workflows (e.g., "TODD: detect TDD project")
- WALT steps are labeled "WALT:" in workflows (e.g., "WALT: Capture baseline")
- TDD files keep `tdd` prefix in names (e.g., `tdd.md`, `tdd-detection.md`)
- Quality files keep `quality-` prefix (e.g., `quality-runner.md`, `quality-delta.md`)
- No separate `todd/` or `walt/` directories — they live inline in the core workflows
- CARL keeps its own namespace (`/carl:*`) and subdirectory (`carl/`)
- Future PALS subsystems ("friends") follow the same pattern: named identity, integrated execution

---

## 4. Source-to-Destination File Map

### 4.1 PAUL Workflows (23 files)

| # | Source (~/.) | Destination (~/.pals/) | Action | Notes |
|---|-------------|----------------------|--------|-------|
| 1 | claude/paul-framework/workflows/apply-phase.md | workflows/apply-phase.md | copy + merge | Inline TODD/WALT delegation (Phase 3) |
| 2 | claude/paul-framework/workflows/apply-phase-tdd.md | — | merge into apply-phase.md | TODD overlay becomes inline section |
| 3 | claude/paul-framework/workflows/complete-milestone.md | workflows/complete-milestone.md | copy | No changes needed |
| 4 | claude/paul-framework/workflows/configure-special-flows.md | workflows/configure-special-flows.md | copy | No changes needed |
| 5 | claude/paul-framework/workflows/consider-issues.md | workflows/consider-issues.md | copy | No changes needed |
| 6 | claude/paul-framework/workflows/create-milestone.md | workflows/create-milestone.md | copy | No changes needed |
| 7 | claude/paul-framework/workflows/debug.md | workflows/debug.md | copy | No changes needed |
| 8 | claude/paul-framework/workflows/discovery.md | workflows/discovery.md | copy | No changes needed |
| 9 | claude/paul-framework/workflows/discuss-milestone.md | workflows/discuss-milestone.md | copy | No changes needed |
| 10 | claude/paul-framework/workflows/discuss-phase.md | workflows/discuss-phase.md | copy | No changes needed |
| 11 | claude/paul-framework/workflows/init-project.md | workflows/init-project.md | copy | No changes needed |
| 12 | claude/paul-framework/workflows/map-codebase.md | workflows/map-codebase.md | copy | No changes needed |
| 13 | claude/paul-framework/workflows/pause-work.md | workflows/pause-work.md | copy | No changes needed |
| 14 | claude/paul-framework/workflows/phase-assumptions.md | workflows/phase-assumptions.md | copy | No changes needed |
| 15 | claude/paul-framework/workflows/plan-phase.md | workflows/plan-phase.md | copy + merge | Inline TDD detection delegation (Phase 3) |
| 16 | claude/paul-framework/workflows/plan-phase-tdd.md | — | merge into plan-phase.md | TODD overlay becomes inline section |
| 17 | claude/paul-framework/workflows/quality-gate.md | workflows/quality-gate.md | copy | Standalone SonarQube workflow |
| 18 | claude/paul-framework/workflows/research.md | workflows/research.md | copy | No changes needed |
| 19 | claude/paul-framework/workflows/resume-project.md | workflows/resume-project.md | copy | No changes needed |
| 20 | claude/paul-framework/workflows/roadmap-management.md | workflows/roadmap-management.md | copy | No changes needed |
| 21 | claude/paul-framework/workflows/transition-phase.md | workflows/transition-phase.md | copy | No changes needed |
| 22 | claude/paul-framework/workflows/unify-phase.md | workflows/unify-phase.md | copy + merge | Inline WALT delta/audit (Phase 3) |
| 23 | claude/paul-framework/workflows/verify-work.md | workflows/verify-work.md | copy | No changes needed |

### 4.2 PAUL References (19 files)

| # | Source (~/.) | Destination (~/.pals/) | Action | Notes |
|---|-------------|----------------------|--------|-------|
| 24 | claude/paul-framework/references/checkpoints.md | references/checkpoints.md | copy | No changes needed |
| 25 | claude/paul-framework/references/ci-generation.md | references/ci-generation.md | copy | WALT origin |
| 26 | claude/paul-framework/references/context-management.md | references/context-management.md | copy | No changes needed |
| 27 | claude/paul-framework/references/git-strategy.md | references/git-strategy.md | copy | No changes needed |
| 28 | claude/paul-framework/references/loop-phases.md | references/loop-phases.md | copy | No changes needed |
| 29 | claude/paul-framework/references/plan-format.md | references/plan-format.md | copy | No changes needed |
| 30 | claude/paul-framework/references/quality-delta.md | references/quality-delta.md | copy | WALT origin |
| 31 | claude/paul-framework/references/quality-detection.md | references/quality-detection.md | copy | WALT origin |
| 32 | claude/paul-framework/references/quality-history.md | references/quality-history.md | copy | WALT origin |
| 33 | claude/paul-framework/references/quality-lint.md | references/quality-lint.md | copy | WALT origin |
| 34 | claude/paul-framework/references/quality-principles.md | references/quality-principles.md | copy | WALT origin |
| 35 | claude/paul-framework/references/quality-runner.md | references/quality-runner.md | copy | WALT origin |
| 36 | claude/paul-framework/references/research-quality-control.md | references/research-quality-control.md | copy | WALT origin |
| 37 | claude/paul-framework/references/sonarqube-integration.md | references/sonarqube-integration.md | copy | No changes needed |
| 38 | claude/paul-framework/references/specialized-workflow-integration.md | references/specialized-workflow-integration.md | copy | No changes needed |
| 39 | claude/paul-framework/references/subagent-criteria.md | references/subagent-criteria.md | copy | No changes needed |
| 40 | claude/paul-framework/references/tdd-detection.md | references/tdd-detection.md | copy | TODD origin |
| 41 | claude/paul-framework/references/tdd.md | references/tdd.md | copy | TODD origin |
| 42 | claude/paul-framework/references/work-units.md | references/work-units.md | copy | No changes needed |

### 4.3 PAUL Templates (24 files)

| # | Source (~/.) | Destination (~/.pals/) | Action | Notes |
|---|-------------|----------------------|--------|-------|
| 43 | claude/paul-framework/templates/PLAN.md | templates/PLAN.md | copy | No changes needed |
| 44 | claude/paul-framework/templates/SUMMARY.md | templates/SUMMARY.md | copy | No changes needed |
| 45 | claude/paul-framework/templates/PROJECT.md | templates/PROJECT.md | copy | No changes needed |
| 46 | claude/paul-framework/templates/ROADMAP.md | templates/ROADMAP.md | copy | No changes needed |
| 47 | claude/paul-framework/templates/STATE.md | templates/STATE.md | copy | No changes needed |
| 48 | claude/paul-framework/templates/HANDOFF.md | templates/HANDOFF.md | copy | No changes needed |
| 49 | claude/paul-framework/templates/CONTEXT.md | templates/CONTEXT.md | copy | No changes needed |
| 50 | claude/paul-framework/templates/DEBUG.md | templates/DEBUG.md | copy | No changes needed |
| 51 | claude/paul-framework/templates/DISCOVERY.md | templates/DISCOVERY.md | copy | No changes needed |
| 52 | claude/paul-framework/templates/ISSUES.md | templates/ISSUES.md | copy | No changes needed |
| 53 | claude/paul-framework/templates/RESEARCH.md | templates/RESEARCH.md | copy | No changes needed |
| 54 | claude/paul-framework/templates/SPECIAL-FLOWS.md | templates/SPECIAL-FLOWS.md | copy | No changes needed |
| 55 | claude/paul-framework/templates/UAT-ISSUES.md | templates/UAT-ISSUES.md | copy | No changes needed |
| 56 | claude/paul-framework/templates/config.md | templates/config.md | copy | No changes needed |
| 57 | claude/paul-framework/templates/milestone-archive.md | templates/milestone-archive.md | copy | No changes needed |
| 58 | claude/paul-framework/templates/milestone-context.md | templates/milestone-context.md | copy | No changes needed |
| 59 | claude/paul-framework/templates/MILESTONES.md | templates/MILESTONES.md | copy | No changes needed |
| 60 | claude/paul-framework/templates/codebase/architecture.md | templates/codebase/architecture.md | copy | No changes needed |
| 61 | claude/paul-framework/templates/codebase/concerns.md | templates/codebase/concerns.md | copy | No changes needed |
| 62 | claude/paul-framework/templates/codebase/conventions.md | templates/codebase/conventions.md | copy | No changes needed |
| 63 | claude/paul-framework/templates/codebase/integrations.md | templates/codebase/integrations.md | copy | No changes needed |
| 64 | claude/paul-framework/templates/codebase/stack.md | templates/codebase/stack.md | copy | No changes needed |
| 65 | claude/paul-framework/templates/codebase/structure.md | templates/codebase/structure.md | copy | No changes needed |
| 66 | claude/paul-framework/templates/codebase/testing.md | templates/codebase/testing.md | copy | No changes needed |

### 4.4 PAUL Rules (5 files)

| # | Source (~/.) | Destination (~/.pals/) | Action | Notes |
|---|-------------|----------------------|--------|-------|
| 67 | claude/paul-framework/rules/commands.md | rules/commands.md | copy | No changes needed |
| 68 | claude/paul-framework/rules/references.md | rules/references.md | copy | No changes needed |
| 69 | claude/paul-framework/rules/style.md | rules/style.md | copy | No changes needed |
| 70 | claude/paul-framework/rules/templates.md | rules/templates.md | copy | No changes needed |
| 71 | claude/paul-framework/rules/workflows.md | rules/workflows.md | copy | No changes needed |

### 4.5 PAUL Skill Commands (26 files)

| # | Source (~/.) | Destination (~/.pals/) | Action | Notes |
|---|-------------|----------------------|--------|-------|
| 72 | claude/commands/paul/add-phase.md | commands/pals/add-phase.md | copy + rename refs | Update /paul: → /pals: |
| 73 | claude/commands/paul/apply.md | commands/pals/apply.md | copy + rename refs | Update /paul: → /pals: |
| 74 | claude/commands/paul/assumptions.md | commands/pals/assumptions.md | copy + rename refs | Update /paul: → /pals: |
| 75 | claude/commands/paul/complete-milestone.md | commands/pals/complete-milestone.md | copy + rename refs | Update /paul: → /pals: |
| 76 | claude/commands/paul/config.md | commands/pals/config.md | copy + rename refs | Update /paul: → /pals: |
| 77 | claude/commands/paul/consider-issues.md | commands/pals/consider-issues.md | copy + rename refs | Update /paul: → /pals: |
| 78 | claude/commands/paul/discover.md | commands/pals/discover.md | copy + rename refs | Update /paul: → /pals: |
| 79 | claude/commands/paul/discuss-milestone.md | commands/pals/discuss-milestone.md | copy + rename refs | Update /paul: → /pals: |
| 80 | claude/commands/paul/discuss.md | commands/pals/discuss.md | copy + rename refs | Update /paul: → /pals: |
| 81 | claude/commands/paul/flows.md | commands/pals/flows.md | copy + rename refs | Update /paul: → /pals: |
| 82 | claude/commands/paul/handoff.md | commands/pals/handoff.md | copy + rename refs | Update /paul: → /pals: |
| 83 | claude/commands/paul/help.md | commands/pals/help.md | copy + rename refs | Update /paul: → /pals: |
| 84 | claude/commands/paul/init.md | commands/pals/init.md | copy + rename refs | Update /paul: → /pals: |
| 85 | claude/commands/paul/map-codebase.md | commands/pals/map-codebase.md | copy + rename refs | Update /paul: → /pals: |
| 86 | claude/commands/paul/milestone.md | commands/pals/milestone.md | copy + rename refs | Update /paul: → /pals: |
| 87 | claude/commands/paul/pause.md | commands/pals/pause.md | copy + rename refs | Update /paul: → /pals: |
| 88 | claude/commands/paul/plan-fix.md | commands/pals/plan-fix.md | copy + rename refs | Update /paul: → /pals: |
| 89 | claude/commands/paul/plan.md | commands/pals/plan.md | copy + rename refs | Update /paul: → /pals: |
| 90 | claude/commands/paul/progress.md | commands/pals/progress.md | copy + rename refs | Update /paul: → /pals: |
| 91 | claude/commands/paul/remove-phase.md | commands/pals/remove-phase.md | copy + rename refs | Update /paul: → /pals: |
| 92 | claude/commands/paul/research-phase.md | commands/pals/research-phase.md | copy + rename refs | Update /paul: → /pals: |
| 93 | claude/commands/paul/research.md | commands/pals/research.md | copy + rename refs | Update /paul: → /pals: |
| 94 | claude/commands/paul/resume.md | commands/pals/resume.md | copy + rename refs | Update /paul: → /pals: |
| 95 | claude/commands/paul/status.md | — | remove | Deprecated — replaced by progress.md |
| 96 | claude/commands/paul/unify.md | commands/pals/unify.md | copy + rename refs | Update /paul: → /pals: |
| 97 | claude/commands/paul/verify.md | commands/pals/verify.md | copy + rename refs | Update /paul: → /pals: |

### 4.6 CARL Core (5 files)

| # | Source (~/.) | Destination (~/.pals/) | Action | Notes |
|---|-------------|----------------------|--------|-------|
| 98 | carl/manifest | carl/manifest | copy | May need path updates (Phase 4) |
| 99 | carl/global | carl/global | copy | No changes needed |
| 100 | carl/context | carl/context | copy | No changes needed |
| 101 | carl/commands | carl/commands | copy | No changes needed |
| 102 | carl/example-custom-domain | carl/example-custom-domain | copy | No changes needed |

### 4.7 CARL Skill Commands (9 files)

| # | Source (~/.) | Destination (~/.pals/) | Action | Notes |
|---|-------------|----------------------|--------|-------|
| 103 | claude/commands/carl/manager.md | commands/carl/manager.md | copy | Update paths to ~/.pals/carl/ |
| 104 | claude/commands/carl/tasks/add-rule.md | commands/carl/tasks/add-rule.md | copy | Update paths |
| 105 | claude/commands/carl/tasks/create-domain.md | commands/carl/tasks/create-domain.md | copy | Update paths |
| 106 | claude/commands/carl/tasks/create-command.md | commands/carl/tasks/create-command.md | copy | Update paths |
| 107 | claude/commands/carl/tasks/edit-rule.md | commands/carl/tasks/edit-rule.md | copy | Update paths |
| 108 | claude/commands/carl/tasks/toggle-domain.md | commands/carl/tasks/toggle-domain.md | copy | Update paths |
| 109 | claude/commands/carl/utils/manifest-parser.md | — | merge into manager.md | Small utility, inline it |
| 110 | claude/commands/carl/templates/domain-template.md | commands/carl/templates/domain-template.md | copy | No changes needed |
| 111 | claude/commands/carl/templates/manifest-entries.md | commands/carl/templates/manifest-entries.md | copy | No changes needed |

### 4.8 Summary by Action

| Action | Count | Description |
|--------|-------|-------------|
| copy | 73 | Direct copy, no content changes needed |
| copy + rename refs | 25 | Copy with `/paul:` → `/pals:` and path updates |
| copy + merge | 3 | Copy with TODD/WALT content merged inline (Phase 3) |
| merge into | 3 | Content absorbed into another file, source removed |
| remove | 1 | Deprecated file, not migrated |
| **Total** | **105 destinations from 111 sources** | 6 files consolidated (3 merges + 2 merge targets already counted + 1 removal) |

---

## 5. Key Design Decisions

### Decision 1: Flat workflows directory (no TODD/WALT subdirectories)

**Choice:** All workflows in a single `workflows/` directory
**Rationale:**
- TODD only has 2 workflow files, WALT has 1 — subdirectories would be overkill
- TODD workflows merge INTO existing plan/apply/unify workflows (Phase 3)
- After Phase 3, there are no standalone TODD/WALT workflow files
- Component origin preserved through `quality-` and `tdd` prefixes in reference filenames

### Decision 2: CARL gets its own subdirectory (`carl/`)

**Choice:** `~/.pals/carl/` for domain files, separate from workflow/reference structure
**Rationale:**
- CARL is architecturally independent (01-01 finding)
- Domain files are not workflows or references — they're runtime configuration
- Users interact with CARL domains directly (creating, editing)
- Clean separation supports using CARL standalone

### Decision 3: Commands use `/pals:*` namespace, CARL keeps `/carl:*`

**Choice:** Rename paul commands to pals, keep carl commands as-is
**Rationale:**
- PALS is the unified brand — `/pals:plan` is clearer than `/paul:plan` for new users
- CARL's independence means its namespace should remain distinct
- Two namespaces: `/pals:*` (lifecycle) and `/carl:*` (rules)

### Decision 4: TODD workflows merge inline, not kept as separate files

**Choice:** `apply-phase-tdd.md` and `plan-phase-tdd.md` merge into their parent workflows
**Rationale:**
- Removes indirection — no more "detect type, then delegate to overlay"
- TDD is a mode of plan/apply, not a separate system
- Reduces file count and simplifies execution flow
- TDD references (`tdd.md`, `tdd-detection.md`) stay as separate reference files

### Decision 5: manifest-parser.md merges into manager.md

**Choice:** Inline the manifest parser utility into the manager command
**Rationale:**
- It's a small utility referenced only by manager.md
- Reduces indirection for a single-use reference
- Other CARL templates stay separate (they're used by multiple commands)

### Decision 6: Deprecated status.md is removed, not migrated

**Choice:** Drop `paul/status.md` entirely
**Rationale:**
- Already deprecated in favor of `progress.md`
- No value in carrying dead code into a new system

---

## 6. Migration Notes

### 6.1 Reference Rewiring (@-paths that change)

All internal `@` references must update from:
- `@~/.claude/paul-framework/workflows/` → `@~/.pals/workflows/`
- `@~/.claude/paul-framework/references/` → `@~/.pals/references/`
- `@~/.claude/paul-framework/templates/` → `@~/.pals/templates/`
- `@~/.claude/paul-framework/rules/` → `@~/.pals/rules/`
- `@~/.carl/` → `@~/.pals/carl/`

**Scope:** This affects nearly every workflow and command file. Recommend batch find-and-replace during Phase 2.

### 6.2 Files Requiring Content Updates (not just moves)

| File | Update Type | Phase |
|------|-------------|-------|
| All 25 pals commands | `/paul:` → `/pals:` in text and references | Phase 2 |
| All 25 pals commands | `paul-framework` → `pals` in @-paths | Phase 2 |
| All CARL commands (8) | `~/.carl/` → `~/.pals/carl/` in paths | Phase 4 |
| apply-phase.md | Inline TDD overlay + WALT quality gates | Phase 3 |
| plan-phase.md | Inline TDD detection delegation | Phase 3 |
| unify-phase.md | Inline WALT delta/audit steps | Phase 3 |
| carl/manifest | Update domain file paths | Phase 4 |
| manager.md | Inline manifest-parser.md content | Phase 4 |

### 6.3 Order-Dependent Migrations

```
Phase 2: Fork & Restructure
  ├── 02-01: Create directory structure + copy core workflows (73 direct copies)
  ├── 02-02: Copy templates, references, rules (batch copy)
  └── 02-03: Copy + rewrite commands (/paul: → /pals:, update @-paths)

Phase 3: Merge TODD/WALT (depends on Phase 2 — files must exist first)
  ├── 03-01: Merge TODD into plan-phase.md + apply-phase.md
  └── 03-02: Merge WALT into apply-phase.md + unify-phase.md

Phase 4: CARL Integration (depends on Phase 2 — directory must exist)
  ├── 04-01: Copy CARL core files + update paths
  └── 04-02: Wire hooks + update commands + inline manifest-parser
```

### 6.4 Install Script Considerations (Phase 5)

The install script will need to:
1. Symlink or copy `~/.pals/commands/pals/` → `~/.claude/commands/pals/`
2. Symlink or copy `~/.pals/commands/carl/` → `~/.claude/commands/carl/`
3. Configure Claude Code hooks to point to `~/.pals/hooks/`
4. Initialize `~/.pals/carl/` from templates if no existing CARL config

---

*Structure design complete: 111 source files mapped to 105 destinations*
*Ready for Phase 2: Fork & Restructure*
