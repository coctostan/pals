# PALS

PALS (Project Automation & Lifecycle System) is an end-to-end development framework for agentic coding. It manages the full plan-apply-unify lifecycle, enforces quality gates, loads context-aware modules, and tracks state across sessions.

**Support status:** Pi is the supported runtime for current PALS development. Claude Code and Agent SDK compatibility are unsupported/frozen historical surfaces: existing drivers and docs may remain as reference, but active product work no longer targets cross-harness parity. Eighteen modules. One kernel. Pi-first runtime assistance.

## Quick Start

```bash
git clone https://github.com/coctostan/pals.git
cd pals
./install.sh
```

Start a new Pi session, then in any project:

```
/paul:init        # Set up PALS in your project
/paul:plan        # Create a plan for your next phase
/paul:apply       # Execute the approved plan
/paul:unify       # Reconcile results and close the loop
```

Pi is the supported runtime: PALS installs canonical skills under `~/.pi/agent/skills/pals/`, the Pi extension at `~/.pi/agent/extensions/pals-hooks.ts`, and project-shipped helper agents under `~/.pi/agent/agents/`.

Claude Code and Agent SDK surfaces are unsupported/frozen historical compatibility references. They may remain in the repository, but new architecture work should use the Pi-native surfaces and preserve `.paul/*` artifact authority.
Driver inventory remains documented for maintenance context: Claude Code · Pi · Agent SDK. Pi driver installs canonical skills plus an extension-backed command/hook layer; the other surfaces are frozen legacy references.

That split keeps the operating model explicit. `/paul-*` remains the Pi-native command layer, `/skill:paul-*` remains the canonical workflow entry layer, and shared markdown workflows plus `.paul/*` remain the only lifecycle truth. Pi can expose bounded helper surfaces such as the repo-local `pals-implementer`, but it does not become the owner of PLAN/APPLY/UNIFY state.
Pi may also inject bounded artifact-slice context after explicit `/paul-*` or `/skill:paul-*` activation. The implemented slices — `current-lifecycle-state`, `active-roadmap-phase`, and `approved-plan-task-packet` — are orientation aids only; full authoritative reads of the cited artifacts remain required before edits, approved PLAN execution, lifecycle writes, stale or ambiguous facts, decisions, GitHub Flow gates, validation pass/fail, module completion, APPLY completion, or UNIFY completion. See `drivers/pi/extensions/README.md` and `drivers/pi/skill-map.md` for operational details.
That's the core loop. PALS tracks state, enforces quality, and manages context across sessions — you focus on the work.

## Architecture

PALS uses a three-layer stack inspired by operating system design:

```
┌─────────────────────────────────────────────────┐
│                   Modules (18)                   │
│  Core: CARL · TODD · WALT · DEAN · IRIS · SKIP │
│        DAVE · RUBY                               │
│  Expert: ARCH · SETH · PETE · GABE · LUKE      │
│          ARIA · DANA · OMAR · REED · VERA       │
├─────────────────────────────────────────────────┤
│                    Kernel                         │
│  PAUL — lifecycle, commands, workflows            │
├─────────────────────────────────────────────────┤
│                    Platforms                        │
│  Pi supported · Claude/SDK frozen               │
└─────────────────────────────────────────────────┘
```

**Kernel** — PAUL is the core. It owns the plan-apply-unify loop, commands, workflows, and lifecycle hooks. Platform-agnostic by design.

**Modules** — Each module registers for lifecycle events (pre-plan, post-apply, etc.) and participates automatically. Enable or disable any module without affecting the rest. 8 core pals handle lifecycle concerns; 10 expert modules cover architecture, security, accessibility, performance, data, API design, UX, observability, resilience, and privacy.

**Platforms** — Wiring layer that connects the kernel to a specific platform. Pi is the supported runtime and installs canonical skills plus an extension-backed command/hook layer. Claude Code and Agent SDK drivers are frozen historical surfaces, not active compatibility targets.

## Key Features

- **Plan-Apply-Unify Loop** — Every unit of work follows a structured three-phase cycle with acceptance criteria, verification, and reconciliation
- **18 Modules** — From TDD enforcement (TODD) to accessibility auditing (ARIA), each module hooks into lifecycle events and contributes automatically
- **GitHub Flow Enforcement** — Strict branch/PR/CI gating with merge gates, or advisory mode for lighter workflows
- **Collaborative Planning** — Low/medium/high collaboration levels with 4-option review menu before execution
- **Guided Workflow UX** (Pi) — Per-transition-type auto-approve config so users retain control at critical decision points
- **Artifact-Slice Context Loading** (Pi) — Activation-gated, source-cited, freshness-marked orientation aids for lifecycle state, active roadmap phase, and approved plan task packets; never a replacement for full authoritative reads
- **E2E Test Protocol** — Reusable methodology for validating PALS across 8 dimensions with structured reporting
- **Session Continuity** — State tracked in `.paul/STATE.md` with handoff/resume support across sessions
- **Three Init Flows** — Quick (~1 question), greenfield (~8), brownfield (~12+) with smart defaults

## The Pals

### Core Pals

| Pal | Full Name | What It Does |
|-----|-----------|-------------|
| **PAUL** | Project Automation & Lifecycle | Kernel. Plans, executes, and tracks work through the plan-apply-unify loop. |
| **CARL** | Session & Context Manager | Pi: autonomous session boundary management via extension events. Claude Code: context rule injection via hooks. |
| **TODD** | Test-Driven Development | Enforces RED-GREEN-REFACTOR. Detects TDD candidates during planning and restructures tasks. |
| **WALT** | Watchful Automated Lint & Testing | Quality gating. Captures baselines before apply, runs checks after, detects regressions. |
| **DEAN** | Dependency Evaluation & Audit Notifier | Scans dependencies for vulnerabilities with baseline-aware delta comparison across 10 ecosystems. |
| **IRIS** | Intelligent Review & Inspection System | Code review with 25 patterns and 5 checklists covering security, performance, and maintainability. |
| **SKIP** | Smart Knowledge & Information Persistence | Captures decisions, rationale, trade-offs, and lessons learned. Multi-source search across project knowledge. |
| **DAVE** | Deploy Automation & Verification Engine | CI/CD pipeline auditing, generation, and verification. Detects 12+ languages and frameworks. |
| **RUBY** | Refactor Utility & Better-code Yielder | Tech debt scanning and refactoring suggestions using 9 patterns across 3 analysis modes. |

### Expert Modules

| Module | Focus | What It Does |
|--------|-------|-------------|
| **ARCH** | Architecture | Detects project patterns (MVC, Clean, Feature-based), checks layer boundaries, flags god files |
| **SETH** | Security | OWASP-aligned scans for hardcoded secrets, injection risks, auth gaps, input validation |
| **PETE** | Performance | N+1 detection, heavy import flagging, sync I/O in async paths, unbounded query warnings |
| **GABE** | API Conventions | REST convention checks, breaking change detection, versioning, schema validation |
| **LUKE** | UX Patterns | Component size limits, design token enforcement, loading state checks, inline style detection |
| **ARIA** | Accessibility | Semantic HTML, alt text, input labels, focus management, keyboard handler checks |
| **DANA** | Data Patterns | Migration safety, schema health, N+1 query detection, unbounded query warnings |
| **OMAR** | Observability | Sensitive data in logs, empty catch blocks, health endpoint checks, structured logging |
| **REED** | Resilience | Timeout configuration, retry pattern validation, error boundaries, graceful shutdown |
| **VERA** | Privacy | PII detection in logs, consent checks, encryption verification, test data hygiene |

All modules are enabled by default and dispatch automatically via lifecycle hooks. No configuration needed — disable any module via `pals.json` or `/paul:config`.

## Commands

### Core Lifecycle

| Command | Description |
|---------|-------------|
| `/paul:init` | Initialize PALS in your project (quick, greenfield, or brownfield flow) |
| `/paul:plan` | Create an executable plan for the current phase |
| `/paul:apply` | Execute an approved plan |
| `/paul:unify` | Reconcile plan vs actual and close the loop |
| `/paul:status` | Show current status, git state, and suggest next action |
| `/paul:help` | Show all available commands and skill guidance |

### Session & Flow Management

| Command | Description |
|---------|-------------|
| `/paul:resume` | Restore context from handoff and continue work |
| `/paul:pause` | Create handoff file and prepare for session break |
| `/paul:fix` | Quick fix flow (standard, fast-forward, or hotfix mode) |
| `/paul:milestone` | Create or complete a milestone |
| `/paul:discuss` | Explore scope before planning (milestone or phase) |

### Module Commands

| Command | Module | Description |
|---------|--------|-------------|
| `/paul:coverage` | TODD | Test coverage analysis dashboard |
| `/paul:quality` | WALT | Quality trend dashboard with streak/regression detection |
| `/paul:deps` | DEAN | Dependency health audit across 10 ecosystems |
| `/paul:review` | IRIS | On-demand review path that dispatches a separate `code-reviewer`; not part of delegated APPLY or lifecycle state ownership |
| `/paul:knowledge` | SKIP | Capture and search project knowledge |
| `/paul:deploy` | DAVE | CI/CD pipeline audit, generation, and verification |
| `/paul:refactor` | RUBY | Tech debt scanning and refactoring suggestions |
| `/paul:config` | — | View and manage module configuration |

## Configuration

PALS uses `pals.json` at the project root:

```json
{
  "schema_version": "2.0.0",
  "modules": {
    "carl": { "enabled": true, "description": "Session boundary manager" },
    "codi": { "enabled": true, "description": "Codegraph-driven structural injection (safe skip when codegraph is unavailable)" },
    "todd": { "enabled": true, "description": "Test-driven development enforcement" },
    "walt": { "enabled": true, "description": "Quality gating & validation" },
    "dean": { "enabled": true, "description": "Dependency evaluation & audit notifier" },
    "iris": { "enabled": true, "description": "Intelligent review & inspection system" },
    "skip": { "enabled": true, "description": "Smart knowledge & information persistence" },
    "dave": { "enabled": true, "description": "Deploy automation & verification engine" },
    "ruby": { "enabled": true, "description": "Refactor utility & better-code yielder" }
  },
  "agents": {
    "implementer": { "enabled": true, "model": null }
  },
  "git": {
    "workflow": "github-flow",
    "base_branch": "main",
    "merge_method": "squash",
    "auto_push": true,
    "auto_pr": true,
    "ci_checks": true,
    "require_pr_before_next_phase": true,
    "require_reviews": false
  },
  "planning": {
    "default_collaboration": "medium"
  },
  "preferences": {
    "auto_commit": false,
    "verbose_output": false
  },
  "guided_workflow": {
    "auto_present": {
      "plan_review": false,
      "apply_approval": false,
      "continue_to_unify": true,
      "phase_transition": false,
      "milestone_transition": false
    }
  }
}
```

Fresh generated configs keep core and expert modules enabled by default, including `modules.codi`. Runtime dispatch still follows `modules.yaml`; if `pi-codegraph` or a usable repo index is absent, CODI stays enabled and planning safely skips blast-radius injection rather than blocking.
Current top-level sections for a fresh generated config are `modules`, `agents`, `git`, `planning`, `preferences`, and `guided_workflow` (plus `schema_version`).


### CODI setup (optional)

`modules.codi.enabled` defaults to `true` in generated and migrated configs. CODI helps most on TS/JS-touching indexed code and is often quiet on markdown, config, or workflow-only phases. When structural call-sites exist, it can improve boundary specificity, but it should not be pitched as a broad planner win. Pi installs emit a single `CODI is enabled but no codegraph index detected` recommendation when `.codegraph/graph.db` is absent, pointing to `modules/codi/references/codi.md` for setup. Phase 175 still does not create a hard `.codegraph/` gate: if `pi-codegraph` or a usable repo index is unavailable, planning continues cleanly and CODI logs a safe skip instead of blocking.

### Git Workflow

| Mode | Behavior |
|------|----------|
| `github-flow` | Strict enforcement — branch validation, auto-PR, merge gate blocks next phase until PR merged and CI passes. Requires `gh` CLI. |
| `legacy` | Advisory git ops — feature-per-phase branching with optional push/PR/CI. Default for existing projects. |
| `none` | No git operations (default for new projects without git config). |

Both `/paul:status` and `/paul:resume` surface live git state (branch, PR, CI, sync status) and route the next action based on git state — e.g., "fix CI" if checks failing, "update branch" if behind base, "merge PR" when ready.

### Guided Workflow (Pi)

The `guided_workflow.auto_present` section controls whether the Pi extension auto-presents interactive dialogs at each transition type:

- **`false`** (notify-only): User responds in the chat prompt — no auto-cascade
- **`true`** (auto-present): Interactive confirm/select dialog presented automatically

Default: critical transitions (plan approval, phase/milestone transitions) are notify-only. Routine transitions (continue to UNIFY, checkpoints) auto-present.

## How It Works

### The Plan-Apply-Unify Loop

```
PLAN ──▶ APPLY ──▶ UNIFY
```

1. **PLAN** — Analyze scope, define acceptance criteria, create tasks with specific files, actions, and verification steps. Modules participate via `pre-plan` and `post-plan` hooks.

2. **APPLY** — Execute tasks sequentially. Each task is verified before proceeding. Modules gate quality via `pre-apply` and `post-apply` hooks.

3. **UNIFY** — Reconcile what was planned vs what was built. Record deviations, update state, close the loop. Modules contribute via `post-unify` hooks.

### Delegated APPLY Operating Model

Parent APPLY remains authoritative even when an eligible auto task is delegated. The parent workflow still owns approval, official verify steps, module dispatch and gates, checkpoints, fallback judgment, and all `.paul/*` lifecycle writes.

For eligible bounded repo-local work only, the parent may delegate a single task or sequential task step to the repo-shipped `pals-implementer`. In Pi, `install.sh` makes that agent visible at `~/.pi/agent/agents/pals-implementer.md` so parent-controlled APPLY can invoke a helper without moving lifecycle ownership into the adapter.
This is distinct from review. `/paul:review` remains a separate on-demand path that dispatches `code-reviewer` for isolated review work; it does not replace APPLY verification and it does not become lifecycle truth.

### Lifecycle Hooks

| Hook Point | When It Fires | Example Modules |
|------------|--------------|-----------------|
| `pre-plan` | Before plan creation | TODD, DEAN, IRIS, ARCH, SETH, LUKE, ARIA, DANA, GABE, OMAR, PETE, REED, VERA |
| `post-plan` | After plan creation | TODD (task restructuring for TDD) |
| `pre-apply` | Before execution | WALT (quality baseline), TODD (test verification) |
| `post-task` | After each task | TODD (test verification) |
| `post-apply` | After all tasks | Advisory: IRIS, DOCS, RUBY, SKIP. Enforcement: WALT, DEAN, TODD. Plus expert modules. |
| `post-unify` | After loop closes | WALT (history), SKIP (knowledge), RUBY (debt analysis) |

### Session Continuity

PALS tracks state in `.paul/STATE.md` and supports handoffs between sessions. Use `/paul:pause` to create a handoff document and `/paul:resume` to restore context. CARL (Pi extension) automatically manages session boundaries based on context pressure — creating fresh sessions when thresholds are reached.

## Install

```bash
git clone https://github.com/coctostan/pals.git
cd pals
./install.sh
```

The installer currently prioritizes Pi-first use:
- **Pi skill/kernel surface:** Installs shared workflows, references, templates, rules, and canonical skills to `~/.pi/agent/skills/pals/`
- **Pi extension surface:** Installs `pals-hooks.ts` to `~/.pi/agent/extensions/`
- **Pi project-agent surface:** Installs project-shipped agent definitions, including `pals-implementer`, to `~/.pi/agent/agents/`
- **Frozen legacy surfaces:** Existing Claude Code and Agent SDK files may remain for historical/reference compatibility, but they are unsupported/frozen and not active support targets
- Generates `modules.yaml` registry for all 18 modules
- Reads `pals.json` to determine which modules to install
- Detects and cleans up legacy installations if present

Start a new session after installing.

## Uninstall

```bash
cd pals
./uninstall.sh
```

Removes all PALS files from installed driver locations without affecting unrelated harness configuration.

## Requirements

- [Pi](https://github.com/nicholasgasior/pi-coding-agent) — supported runtime. Claude Code and Agent SDK surfaces are unsupported/frozen historical references.
- `gh` CLI (optional — required only for GitHub Flow enforcement)

## Documentation

See `docs/` for detailed specifications:
- `docs/ARCHITECTURE.md` — System architecture
- `docs/LIFECYCLE-SPEC.md` — State machine and transitions
- `docs/HOOK-CONTRACT.md` — Module lifecycle hooks
- `docs/MODULE-BUILDERS-GUIDE.md` — How to build a new module
- `docs/TROUBLESHOOTING.md` — Common issues and solutions
- `kernel/references/e2e-test-protocol.md` — E2E testing methodology

## Credits

Built on top earlier versoins of [PAUL](https://github.com/ChristopherKahler/paul) and [CARL](https://github.com/ChristopherKahler/carl)
Thank you to https://github.com/ChristopherKahler
