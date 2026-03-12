# PALS Architecture

**Version:** 0.4-draft
**Status:** Design document

---

## Vision

**PALS is the Linux of Harness Engineering.**

A minimal kernel handles lifecycle management. Modular pals (CARL, TODD, WALT, and future modules) extend functionality through hooks. Universal drivers make the whole system run on any AI coding platform.

Just as Linux separates the kernel from userspace programs and hardware drivers, PALS separates project lifecycle logic from domain modules and platform adapters. You can swap drivers without changing modules. You can add modules without touching the kernel. You can upgrade the kernel without breaking either.

---

## System Diagram

```
┌─────────────────────────────────────────────────┐
│               MODULES (Pals)                    │
│                                                 │
│   CARL          TODD          WALT              │
│   Context       TDD           Quality           │
│   Rules         Enforcement   Gating            │
│                                                 │
│              [future modules]                   │
├─────────────────────────────────────────────────┤
│               KERNEL (PAUL Core)                │
│                                                 │
│   Plan ──────▶ Apply ──────▶ Unify             │
│                                                 │
│   State Management    Lifecycle Hooks           │
│   Templates           Workflow Engine           │
│   References          Command Registry          │
├─────────────────────────────────────────────────┤
│               DRIVERS                           │
│                                                 │
│   Claude Code    │    Agent SDK    │   [future] │
│   Slash cmds     │    System       │            │
│   + Hooks        │    prompts      │            │
│   + Filesystem   │    + File ops   │            │
└─────────────────────────────────────────────────┘
```

Each layer only communicates with its immediate neighbors. Modules call kernel APIs. The kernel calls driver methods. No layer skips a level.

---

## How a Workflow Invocation Flows Through the Stack

A concrete example: the user runs `/paul:plan` to create a plan for a new phase.

```
User                Driver              Kernel              Modules
  │                   │                   │                   │
  │  /paul:plan       │                   │                   │
  │──────────────────▶│                   │                   │
  │                   │  workflow_invoke  │                   │
  │                   │  ("plan-phase",   │                   │
  │                   │   context)        │                   │
  │                   │──────────────────▶│                   │
  │                   │                   │  emit pre-plan    │
  │                   │                   │──────────────────▶│
  │                   │                   │                   │
  │                   │                   │  TODD: detect     │
  │                   │                   │  TDD candidates   │
  │                   │                   │◀──────────────────│
  │                   │                   │                   │
  │                   │                   │  [execute plan    │
  │                   │                   │   workflow]       │
  │                   │                   │                   │
  │                   │                   │  emit post-plan   │
  │                   │                   │──────────────────▶│
  │                   │                   │                   │
  │                   │                   │  TODD: structure  │
  │                   │                   │  as RED-GREEN-    │
  │                   │                   │  REFACTOR         │
  │                   │                   │◀──────────────────│
  │                   │                   │                   │
  │                   │  WorkflowResult   │                   │
  │                   │◀──────────────────│                   │
  │  Display plan     │                   │                   │
  │  for approval     │                   │                   │
  │◀──────────────────│                   │                   │
```

**Step by step:**

1. **User triggers action.** The user invokes a command (`/paul:plan`) or the system reaches a lifecycle transition.
2. **Driver translates.** The Claude Code driver loads `~/.pals/workflows/plan-phase.md` and presents it as instructions to the LLM. The Agent SDK driver injects the workflow as a system prompt.
3. **Kernel processes.** The workflow engine reads project state, determines context, and begins executing the workflow steps.
4. **Hooks fire.** At defined lifecycle points (`pre-plan`, `post-plan`), the kernel emits hook events through the driver's dispatch mechanism.
5. **Modules respond.** Registered module handlers execute in priority order and return `continue`, `block`, or `modify` responses.
6. **Driver presents output.** The driver takes the workflow result and presents it to the user in the platform's native format — conversation text in Claude Code, structured output in Agent SDK.

---

## How Hooks Fire and Modules Respond

The hook system is the sole integration point between the kernel and modules. Modules never patch kernel files. The kernel never imports module code. They communicate exclusively through hooks.

### Hook Dispatch Sequence

```
Kernel reaches lifecycle point
        │
        ▼
Driver.hook_dispatch(hook_name, context)
        │
        ▼
Sort registered handlers by priority (lower = first)
        │
        ▼
┌───────────────────────────────┐
│  Handler 1 (priority 10)     │──▶ returns {action: "continue"}
│  Handler 2 (priority 50)     │──▶ returns {action: "modify", ...}
│  Handler 3 (priority 100)    │──▶ returns {action: "continue"}
└───────────────────────────────┘
        │
        ▼
Merge responses:
  - Any "block"  → halt execution, report reason
  - Any "modify" → apply modifications to context
  - All "continue" → proceed unchanged
        │
        ▼
Kernel continues (or halts)
```

### Module Hook Registrations

| Module | Hook | Priority | Behavior |
|--------|------|----------|----------|
| **TODD** | `pre-plan` | 50 | Detect TDD candidates via heuristics |
| **TODD** | `post-plan` | 50 | Structure plan as RED-GREEN-REFACTOR if TDD type |
| **TODD** | `pre-apply` | 50 | Enforce RED phase (tests first) |
| **TODD** | `post-task` | 50 | Enforce GREEN phase (tests pass) |
| **TODD** | `post-apply` | 50 | Enforce REFACTOR phase |
| **WALT** | `pre-apply` | 40 | Capture test baseline before changes |
| **WALT** | `post-apply` | 60 | Run tests, lint, typecheck; gate on regressions |
| **WALT** | `post-unify` | 50 | Record quality delta in history |
| **CARL** | `UserPromptSubmit` | 10 | Inject context rules into every prompt |

Note that WALT's `pre-apply` runs before TODD's (priority 40 vs 50) to capture the baseline before TDD changes begin. WALT's `post-apply` runs after TODD's (priority 60 vs 50) to verify the final result after refactoring.

### Key Rule

If no modules are installed, no hooks fire. The kernel proceeds through every lifecycle point with the default `continue` action. Missing modules produce silence, never errors.

---

## How State Persists Across Sessions

All PALS state lives in the filesystem under `{project_root}/.paul/`. This directory is committed to the project repository (or excluded via `.gitignore` — the user decides). State files are plain markdown, readable by humans and LLMs alike.

### State Files

| File | Purpose | Lifecycle |
|------|---------|-----------|
| `.paul/STATE.md` | Current project state: active phase, loop position (PLAN/APPLY/UNIFY), status flags | Updated at every lifecycle transition |
| `.paul/PROJECT.md` | Project definition: name, description, goals, constraints | Created at init, rarely modified |
| `.paul/ROADMAP.md` | Phase roadmap with ordering and status | Updated when phases are added/removed/completed |
| `.paul/config.md` | Project configuration (driver, modules, special flows) | Set at init, modified via `/paul:config` |
| `.paul/MILESTONES.md` | Milestone archive | Appended when milestones complete |

### Phase-Scoped Files

Each phase gets a directory under `.paul/phases/{phase-name}/`:

| File | Purpose |
|------|---------|
| `{NN}-PLAN.md` | Executable plan (created during PLAN, consumed during APPLY) |
| `{NN}-SUMMARY.md` | Reconciliation summary (created during UNIFY) |

Plans and summaries are numbered sequentially within each phase (01-01, 01-02, etc.) to support multiple plan/apply/unify cycles per phase.

### Session Files

| File | Purpose |
|------|---------|
| `.paul/handoffs/HANDOFF-{date}-{label}.md` | Session handoff with context for the next session |
| `.paul/handoffs/archive/` | Completed handoffs |

### Persistence Model

- **Within a session:** State is read and written via the driver's `state_read`/`state_write` methods. For Claude Code, this is direct filesystem access. For other drivers, the backend may differ.
- **Across sessions:** The handoff mechanism captures session context (what was done, what is next, key decisions) so a new session can resume without re-reading the entire project history.
- **Across platforms:** Because state is plain markdown files in a fixed directory structure, a project can be started on Claude Code and resumed on Agent SDK (or vice versa). The state is portable.

---

## How Modules Are Loaded at Install Time

When PALS is installed (via `install.sh` or a future module manager), the installer processes each module's manifest and wires it into the system.

### Install Sequence

```
1. Parse module manifest
   └── Read the module's file list, hook registrations, and commands

2. Copy module files to framework directory
   └── References  → ~/.pals/references/
   └── Workflows   → ~/.pals/workflows/
   └── Config      → ~/.pals/{module}/   (e.g., ~/.pals/carl/)

3. Register hooks
   └── Claude Code: Add entries to ~/.claude/settings.json
   └── Agent SDK:   Register in orchestrator config

4. Wire commands
   └── Claude Code: Copy command .md files to ~/.claude/commands/{namespace}/
   └── Agent SDK:   Register API entry points (or no-op)

5. Validate installation
   └── Check all expected paths exist
   └── Verify hook registration
   └── Report success/failure
```

### Module Manifest (future)

Each module will declare its contents in a manifest file:

```yaml
# modules/todd/module.yaml
name: todd
description: TDD enforcement via RED-GREEN-REFACTOR
version: 0.4.0
kernel_version: ">=0.4.0"

files:
  references:
    - tdd.md
    - tdd-detection.md
    - tdd-plan-generation.md
    - tdd-execution.md

hooks:
  - hook: pre-plan
    priority: 50
    reference: tdd-detection.md
  - hook: post-plan
    priority: 50
    reference: tdd-plan-generation.md
  - hook: pre-apply
    priority: 50
    reference: tdd-execution.md

commands: []  # TODD has no user-facing commands
```

### Selective Installation

Not every project needs every module. The installer supports selective module loading:

```bash
./install.sh                    # Install kernel + all modules (default)
./install.sh --modules paul     # Kernel only, no modules
./install.sh --modules paul,carl  # Kernel + CARL only
```

---

## Filesystem Layout After Kernelization

A fully installed PALS with all modules, on the Claude Code driver:

```
~/.pals/                              # Framework directory
├── workflows/                        # Kernel workflows
│   ├── plan-phase.md
│   ├── apply-phase.md
│   ├── unify-phase.md
│   ├── init-project.md
│   ├── transition-phase.md
│   ├── complete-milestone.md
│   ├── create-milestone.md
│   ├── discuss-milestone.md
│   ├── discuss-phase.md
│   ├── roadmap-management.md
│   ├── pause-work.md
│   ├── resume-project.md
│   ├── verify-work.md
│   ├── phase-assumptions.md
│   ├── research.md
│   ├── discovery.md
│   ├── map-codebase.md
│   ├── consider-issues.md
│   ├── configure-special-flows.md
│   ├── debug.md
│   └── quality-gate.md              # WALT module workflow
├── references/                       # Kernel + module references
│   ├── loop-phases.md                #   Kernel
│   ├── checkpoints.md                #   Kernel
│   ├── plan-format.md                #   Kernel
│   ├── work-units.md                 #   Kernel
│   ├── git-strategy.md               #   Kernel
│   ├── context-management.md         #   Kernel
│   ├── subagent-criteria.md          #   Kernel
│   ├── research-quality-control.md   #   Kernel
│   ├── tdd.md                        #   TODD module
│   ├── tdd-detection.md              #   TODD module
│   ├── tdd-plan-generation.md        #   TODD module
│   ├── tdd-execution.md              #   TODD module
│   ├── quality-principles.md         #   WALT module
│   ├── quality-runner.md             #   WALT module
│   ├── quality-detection.md          #   WALT module
│   ├── quality-lint.md               #   WALT module
│   ├── quality-delta.md              #   WALT module
│   └── quality-history.md            #   WALT module
├── templates/                        # Kernel templates
│   ├── PROJECT.md
│   ├── STATE.md
│   ├── ROADMAP.md
│   ├── PLAN.md
│   ├── SUMMARY.md
│   ├── HANDOFF.md
│   ├── CONTEXT.md
│   ├── ISSUES.md
│   ├── config.md
│   └── codebase/
│       ├── architecture.md
│       ├── conventions.md
│       └── ...
├── rules/                            # Shared rules
│   ├── style.md
│   ├── workflows.md
│   ├── commands.md
│   ├── references.md
│   └── templates.md
└── carl/                             # CARL module config
    ├── manifest
    ├── global
    ├── context
    ├── commands
    └── example-custom-domain

~/.claude/                            # Claude Code driver files
├── commands/
│   ├── paul/                         # Kernel commands
│   │   ├── plan.md
│   │   ├── apply.md
│   │   ├── unify.md
│   │   ├── init.md
│   │   ├── progress.md
│   │   ├── help.md
│   │   └── ...                       # (23 commands total)
│   └── carl/                         # CARL module commands
│       ├── manager.md
│       ├── tasks/
│       │   ├── add-rule.md
│       │   ├── create-domain.md
│       │   └── ...
│       └── templates/
│           ├── domain-template.md
│           └── manifest-entries.md
├── hooks/
│   └── carl-hook.py                  # CARL module hook (symlink)
└── settings.json                     # Hook registrations

{project}/                            # Per-project state
└── .paul/
    ├── STATE.md
    ├── PROJECT.md
    ├── ROADMAP.md
    ├── config.md
    ├── MILESTONES.md
    ├── phases/
    │   ├── 01-architecture-design/
    │   │   ├── 01-01-PLAN.md
    │   │   ├── 01-01-SUMMARY.md
    │   │   └── ...
    │   └── 02-implementation/
    │       └── ...
    └── handoffs/
        ├── HANDOFF-2026-03-11-session.md
        └── archive/
```

---

## Key Design Principles

### 1. Kernel never references modules by name

The kernel does not contain the strings "TODD", "WALT", or "CARL" (except in documentation). It emits hooks at lifecycle points. It loads workflows from the filesystem. If a module's files are present, they participate. If absent, the kernel proceeds without them.

This means new modules can be added without modifying any kernel file.

### 2. Modules never reference the driver layer

A module does not know whether it is running on Claude Code, Agent SDK, or something else. TODD's TDD detection reference does not contain Claude Code slash command syntax. CARL's hook script receives a standardized input format, not a Claude Code-specific payload.

This means modules work on any driver without modification.

### 3. Drivers never reference specific modules

The Claude Code driver installs files and registers hooks. It does not contain logic specific to TODD, WALT, or CARL. It copies whatever command files exist under `commands/`. It registers whatever hooks are declared in the manifest.

This means new modules can be installed without modifying the driver.

### 4. Each layer only talks to its neighbors

```
Modules  ←→  Kernel  ←→  Drivers
```

Modules call kernel APIs (state read/write, hook responses). The kernel calls driver methods (workflow invoke, user interact). A module never calls a driver method directly. A driver never calls a module directly.

### 5. Missing modules = no-op, never error

If TODD is not installed:
- The `pre-plan` hook fires with zero handlers registered. Result: `continue`.
- The plan workflow runs without TDD detection. Plans are structured normally.
- No error messages. No degraded-mode warnings. The system simply does less.

If WALT is not installed:
- The `post-apply` hook fires with zero handlers. Result: `continue`.
- No quality gate runs. The apply phase completes without test verification.
- The user can still run tests manually. PALS does not block them.

If CARL is not installed:
- No `UserPromptSubmit` hook is registered.
- No context rules are injected into prompts.
- The user gets standard Claude Code behavior without domain-aware context.

This principle ensures that PALS degrades gracefully. A minimal install (kernel only) is a fully functional project management system. Each module adds capability without adding fragility.
