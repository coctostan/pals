# PALS

**The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers.**

PALS (Project Automation & Lifecycle System) is an end-to-end development framework for agentic coding. It manages the full plan-apply-unify lifecycle, enforces test-driven development, gates quality, loads context-aware rules, tracks dependencies, reviews code, manages knowledge, automates deploys, and suggests refactors — all through a modular architecture that runs on any agentic coding platform.

Built for [Claude Code](https://docs.anthropic.com/en/docs/claude-code), Pi, and the Agent SDK. Eight pals. One kernel. Zero boilerplate.

## Quick Start

```bash
git clone https://github.com/maxwellnewman/pals.git
cd pals
./install.sh
```

Start a new Claude Code or Pi session, then in any project use the same core lifecycle:

```
/paul:init        # Set up PALS in your project
/paul:plan        # Create a plan for your next phase
/paul:apply       # Execute the approved plan
/paul:unify       # Reconcile results and close the loop
```

In Claude Code, those commands are installed directly as slash commands. In Pi, the extension exposes `/paul-*` convenience wrappers that route to canonical `/skill:paul-*` entries while keeping shared markdown workflows and `.paul/*` as the only lifecycle truth.
That's the core loop. PALS tracks state, enforces quality, and manages context across sessions — you focus on the work.

## Architecture

PALS uses a three-layer stack inspired by operating system design:

```
┌─────────────────────────────────────────────┐
│                  Modules                     │
│  CARL · TODD · WALT · DEAN · IRIS · SKIP   │
│              DAVE · RUBY                     │
├─────────────────────────────────────────────┤
│                  Kernel                      │
│  PAUL — lifecycle, commands, workflows       │
├─────────────────────────────────────────────┤
│                  Drivers                     │
│  Claude Code · Pi · Agent SDK                │
└─────────────────────────────────────────────┘
```

**Kernel** — PAUL is the core. It owns the plan-apply-unify loop, commands, workflows, and lifecycle hooks. Platform-agnostic by design.

**Modules** — Each pal is a loadable module with its own references, hooks, and capabilities. Modules register for lifecycle events (pre-plan, post-apply, etc.) and participate automatically. Enable or disable any module without affecting the rest.

**Drivers** — Wiring layer that connects the kernel to a specific platform. The Claude Code driver installs slash commands and hooks. The Pi driver installs canonical skills plus an extension-backed command/hook layer. The Agent SDK driver exposes the same workflows as a headless API.

## The Pals

| Pal | Full Name | What It Does | Key Command |
|-----|-----------|-------------|-------------|
| **PAUL** | Project Automation & Lifecycle | Kernel. Plans, executes, and tracks work through the plan-apply-unify loop. | `/paul:plan` |
| **CARL** | Session & Context Manager | Claude Code: context rule injection via hooks. Pi: autonomous session boundary management via extension events. | `/carl:manager` (CC) / automatic (Pi) |
| **TODD** | Test-Driven Development | Enforces RED-GREEN-REFACTOR discipline. Detects TDD candidates during planning and restructures tasks. | `/paul:coverage` |
| **WALT** | Watchful Automated Lint & Testing | Quality gating. Captures baselines before apply, runs checks after, detects regressions. | `/paul:quality` |
| **DEAN** | Dependency Evaluation & Audit Notifier | Scans dependencies for vulnerabilities, outdated packages, and license issues across 10 ecosystems. | `/paul:deps` |
| **IRIS** | Intelligent Review & Inspection System | Structured code review with 25 patterns and 5 checklists covering security, performance, and maintainability. | `/paul:review` |
| **SKIP** | Smart Knowledge & Information Persistence | Captures decisions, rationale, and context. Multi-source search across project knowledge. | `/paul:knowledge` |
| **DAVE** | Deploy Automation & Verification Engine | CI/CD pipeline auditing, generation, and verification. Detects 12+ languages and frameworks. | `/paul:deploy` |
| **RUBY** | Refactor Utility & Better-code Yielder | Scans for tech debt and suggests refactoring opportunities using 9 patterns across 3 analysis modes. | `/paul:refactor` |

## Commands

### Core Lifecycle

| Command | Description |
|---------|-------------|
| `/paul:init` | Initialize PALS in your project |
| `/paul:plan` | Create an executable plan for the current phase |
| `/paul:apply` | Execute an approved plan |
| `/paul:unify` | Reconcile plan vs actual and close the loop |
| `/paul:progress` | Show current status and suggest next action |
| `/paul:help` | Show all available commands |

### Session Management

| Command | Description |
|---------|-------------|
| `/paul:resume` | Restore context from handoff and continue work |
| `/paul:pause` | Create handoff file and prepare for session break |
| `/paul:handoff` | Generate comprehensive session handoff document |

### Planning & Discovery

| Command | Description |
|---------|-------------|
| `/paul:discuss` | Explore phase vision before planning |
| `/paul:discuss-milestone` | Explore next milestone vision |
| `/paul:assumptions` | Surface assumptions about a phase before planning |
| `/paul:discover` | Research technical options before planning |
| `/paul:research` | Research a topic using subagents |
| `/paul:research-phase` | Research unknowns for a specific phase |
| `/paul:consider-issues` | Review and triage deferred issues |

### Roadmap & Milestones

| Command | Description |
|---------|-------------|
| `/paul:milestone` | Create a new milestone |
| `/paul:complete-milestone` | Mark current milestone as complete |
| `/paul:add-phase` | Add a new phase to current milestone |
| `/paul:remove-phase` | Remove a future (not started) phase |

### Module Commands

| Command | Module | Description |
|---------|--------|-------------|
| `/paul:coverage` | TODD | Test coverage analysis dashboard |
| `/paul:quality` | WALT | Quality trend dashboard with streak/regression detection |
| `/paul:deps` | DEAN | Dependency health audit across 10 ecosystems |
| `/paul:review` | IRIS | Structured code review with pattern matching |
| `/paul:knowledge` | SKIP | Capture and search project knowledge |
| `/paul:deploy` | DAVE | CI/CD pipeline audit, generation, and verification |
| `/paul:refactor` | RUBY | Tech debt scanning and refactoring suggestions |
| `/paul:config` | — | View and manage module configuration |

### Verification & Quality

| Command | Description |
|---------|-------------|
| `/paul:verify` | Guide manual acceptance testing |
| `/paul:plan-fix` | Plan fixes for issues found during verification |

### CARL (Session & Context Manager)

CARL serves different roles depending on the platform:

**Claude Code — Context Rules:** `/carl:manager` manages domains, rules, and star-commands (`*list`, `*add`, `*create`, `*edit`, `*toggle`, `*view`, `*scan`, `*suggest`). Rules inject into prompts via `UserPromptSubmit` hooks.

**Pi — Session Boundary Manager:** CARL runs automatically via `pals-hooks.ts` extension events. It detects phase completion at `agent_end`, evaluates context pressure, and creates fresh sessions when thresholds are exceeded. No separate commands needed — configure via `pals.json` → `modules.carl` (strategy, thresholds). See `drivers/pi/extensions/README.md` for details.

### Utilities

| Command | Description |
|---------|-------------|
| `/paul:flows` | Configure specialized workflow integrations |
| `/paul:map-codebase` | Generate codebase map for context |

## Configuration

PALS uses `pals.json` at the project root for module configuration:

```json
{
  "modules": {
    "carl": { "enabled": true, "description": "Session boundary manager (Pi) / Context rules (Claude Code)" },
    "todd": { "enabled": true, "description": "Test-driven development enforcement" },
    "walt": { "enabled": true, "description": "Quality gating & validation" },
    "dean": { "enabled": true, "description": "Dependency evaluation & audit notifier" },
    "iris": { "enabled": true, "description": "Intelligent review & inspection system" },
    "skip": { "enabled": true, "description": "Smart knowledge & information persistence" },
    "dave": { "enabled": true, "description": "Deploy automation & verification engine" },
    "ruby": { "enabled": true, "description": "Refactor utility & better-code yielder" }
  },
  "integrations": {
    "sonarqube": { "enabled": false, "project_key": "" }
  },
  "preferences": {
    "auto_commit": false,
    "verbose_output": false
  }
}
```

All 8 modules are enabled by default. Use `/paul:config` to toggle modules, manage integrations, and set preferences interactively.

In Pi, enabled modules are installed beside the skills and recorded in `~/.pi/agent/skills/pals/modules.yaml`. PLAN/APPLY/UNIFY use that registry to dispatch module guidance such as TODD and WALT; those modules are not separate Pi skills.

### Git Workflow

PALS can enforce GitHub Flow through the `git` section of `pals.json`:

```json
{
  "git": {
    "workflow": "github-flow",
    "base_branch": "main",
    "merge_method": "squash",
    "auto_push": true,
    "auto_pr": true,
    "ci_checks": true,
    "require_pr_before_next_phase": true
  }
}
```

| Mode | Behavior |
|------|----------|
| `github-flow` | Strict enforcement — branch validation before work, auto-PR after apply, merge gate blocks next phase until PR is merged and CI passes. Requires `gh` CLI. |
| `legacy` | Advisory git ops — feature-per-phase branching with optional push/PR/CI. Default for existing projects. |
| `none` | No git operations (default for new projects without git config). |

GitHub Flow enforcement is configured during `/paul:init` or by editing `pals.json` directly. See `kernel/references/git-strategy.md` for full documentation.

## How It Works

### The Plan-Apply-Unify Loop

Every unit of work follows a three-phase loop:

```
PLAN ──▶ APPLY ──▶ UNIFY
```

1. **PLAN** — Analyze scope, define acceptance criteria, create tasks with specific files, actions, and verification steps. Modules participate via `pre-plan` and `post-plan` hooks (e.g., TODD detects TDD candidates and restructures tasks).

2. **APPLY** — Execute tasks sequentially. Each task is verified before proceeding. Modules gate quality via `pre-apply` and `post-apply` hooks (e.g., WALT captures baselines before and checks for regressions after).

3. **UNIFY** — Reconcile what was planned vs what was built. Record deviations, update state, close the loop. Modules contribute via `post-unify` hooks (e.g., SKIP captures decisions for future reference).

### Lifecycle Hooks

Modules register for lifecycle events and participate automatically:

| Hook Point | When It Fires | Example Modules |
|------------|--------------|-----------------|
| `pre-plan` | Before plan creation | TODD (TDD detection), DEAN (dependency check), IRIS (review prep) |
| `post-plan` | After plan creation | TODD (task restructuring for TDD) |
| `pre-apply` | Before execution | WALT (quality baseline capture) |
| `post-task` | After each task | TODD (test verification) |
| `post-apply` | After all tasks | WALT (regression check), DEAN (dependency audit), IRIS (review), SKIP (capture) |
| `post-unify` | After loop closes | WALT (history update), SKIP (knowledge persistence), RUBY (refactor suggestions) |

### Session Continuity

PALS tracks state in `.paul/STATE.md` and supports handoffs between sessions. Use `/paul:pause` to create a handoff document and `/paul:resume` to restore context in a new session. No work is lost between conversations.

## Install

```bash
git clone https://github.com/maxwellnewman/pals.git
cd pals
./install.sh
```

The installer:
- Creates `~/.pals/` with kernel, modules, and references
- Detects available harnesses and installs the matching driver surfaces
- Wires slash commands into `~/.claude/` for Claude Code
- Installs canonical skills plus the Pi extension into `~/.pi/agent/`
- Reads `pals.json` to determine which modules to install
- Detects and cleans up legacy installations if present
Start a new Claude Code or Pi session after installing.

## Uninstall

```bash
cd pals
./uninstall.sh
```

Removes all PALS files from `~/.pals/` plus any installed driver surfaces (for example `~/.claude/` and `~/.pi/agent/`) without affecting unrelated harness configuration.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and/or Pi
