# Module Manifest Format & Lifecycle Hook Contract

**Version:** 0.4-draft
**Date:** 2026-03-11
**Status:** Design specification

---

## Overview

PALS v0.4 kernelizes the framework. The kernel (PAUL core) runs the plan/apply/unify loop and manages project state. Modules are optional pals — CARL, TODD, WALT, and future ones like DEAN, IRIS, SKIP — that extend the kernel through lifecycle hooks.

Each module is self-contained. It declares a manifest (`module.yaml`) that tells the kernel what files it provides, which hooks it subscribes to, and what dependencies it requires. When a module is not installed, its hook points are no-ops. No errors, no warnings, no conditional logic in the kernel.

---

## 1. Module Manifest Schema (`module.yaml`)

Every module ships a `module.yaml` at its root. This is the single source of truth for what the module provides and how it integrates.

```yaml
# ── Identity ─────────────────────────────────────────────────────
name: todd                        # lowercase identifier, unique across all modules
display_name: TODD                # human-readable name
description: >
  Test-driven development enforcement. Ensures RED-GREEN-REFACTOR
  discipline when plans use TDD.
version: 1.0.0                   # semver

# ── Dependencies ─────────────────────────────────────────────────
dependencies:
  kernel: ">=0.4.0"              # minimum kernel version (semver range)
  modules: []                    # other modules this one requires (by name)
  # modules: ["walt"]            # example: module depends on walt

# ── Lifecycle Hooks ──────────────────────────────────────────────
hooks:
  pre-plan:
    priority: 100                # lower number = earlier execution
    description: Detect TDD candidates via heuristics
  post-plan:
    priority: 100
    description: Structure plan as RED-GREEN-REFACTOR if TDD type
  pre-apply:
    priority: 50
    description: Enforce RED phase — tests must be written first
  post-task:
    priority: 100
    description: Enforce GREEN phase — tests must pass after implementation
  post-apply:
    priority: 200
    description: Enforce REFACTOR phase — cleanup opportunity

# ── Files ────────────────────────────────────────────────────────
files:
  references:                    # reference docs the module provides
    - references/tdd.md
    - references/tdd-detection.md
    - references/tdd-plan-generation.md
    - references/tdd-execution.md
  workflows:                     # workflow files (overlays or standalone)
    - workflows/plan-phase-tdd.md
  templates: []                  # template files the module provides
  config: []                     # config files (installed to ~/.pals/carl/ etc.)
  rules: []                      # shared rule files the module contributes

# ── Commands ─────────────────────────────────────────────────────
commands: []                     # slash commands the module provides
  # Each entry is an object:
  # - name: carl:manager
  #   file: commands/carl/manager.md
  #   description: Manage CARL domains and rules

# ── Platform ─────────────────────────────────────────────────────
platform:                        # optional platform-specific configuration
  claude_code:
    hooks: []                    # native Claude Code hooks (UserPromptSubmit, etc.)
    settings_patch: {}           # entries to merge into settings.json
```

### Field Reference

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | Unique lowercase module identifier. Used as directory name and namespace. |
| `display_name` | string | yes | Human-readable name, typically uppercase (TODD, WALT, CARL). |
| `description` | string | yes | One-paragraph description of what the module does. |
| `version` | string | yes | Semver version of the module. |
| `dependencies.kernel` | string | yes | Semver range for minimum kernel version. |
| `dependencies.modules` | list[string] | no | Names of other modules this one requires. Installer checks these are present. |
| `hooks` | map | no | Keys are hook point names; values define priority and description. |
| `hooks.<point>.priority` | integer | yes (if hook declared) | Execution priority. Lower numbers run first. Range: 1-999. |
| `hooks.<point>.description` | string | yes (if hook declared) | Actionable instruction for what the module does at this hook point. |
| `hooks.<point>.refs` | list[string] | yes (if hook declared) | Reference files to load for this specific hook (not all module refs). |
| `files.references` | list[string] | no | Reference documents installed to `~/.pals/references/`. |
| `files.workflows` | list[string] | no | Workflow files installed to `~/.pals/workflows/`. |
| `files.templates` | list[string] | no | Template files installed to `~/.pals/templates/`. |
| `files.config` | list[string] | no | Config files installed to `~/.pals/<module-name>/`. |
| `files.rules` | list[string] | no | Rule files installed to `~/.pals/rules/`. |
| `commands` | list[object] | no | Slash commands installed to `~/.claude/commands/<module-name>/`. |
| `platform` | map | no | Platform-specific configuration (Claude Code hooks, settings patches). |

---

## 2. Lifecycle Hook Points

The kernel fires hooks at eight points in the plan/apply/unify loop. Modules subscribe to the hooks they need; unsubscribed hooks are skipped with zero cost.

```
  pre-plan ──► PLAN ──► post-plan ──► [user approval]
                                            │
  pre-apply ◄───────────────────────────────┘
       │
       ▼
  ┌─────────────────────────────────┐
  │  for each task:                 │
  │    pre-test ──► execute ──► post-task  │
  └─────────────────────────────────┘
       │
       ▼
  post-apply ──► pre-unify ──► UNIFY ──► post-unify ──► [loop closes]
```

### 2.1 `pre-plan`

**Trigger:** Fires when `/paul:plan` is invoked, before any plan content is written. The kernel has loaded the project state and identified the target phase but has not begun drafting.

**Payload:**
```yaml
hook: pre-plan
phase_name: "04-auth-system"       # target phase being planned
milestone: "v1.0"                  # current milestone
project_root: "/path/to/project"   # absolute path to project
state:                             # current STATE.md contents (parsed)
  status: planning
  current_phase: "04-auth-system"
roadmap_context:                   # relevant roadmap excerpt
  phase_objective: "Implement JWT auth"
  prior_phases_completed: 3
```

**Return contract:**
```yaml
action: continue                   # continue | block
# If continue:
context_inject:                    # additional context to feed into plan creation
  tdd_candidates:                  # example: TODD injects detection results
    - "src/auth/service.ts"
    - "src/auth/middleware.ts"
  tdd_type: true
# If block:
reason: "Cannot plan: dependency X not met"
```

**Priority ordering:** Lower priority numbers run first. A `pre-plan` hook at priority 50 runs before one at priority 100.

---

### 2.2 `post-plan`

**Trigger:** Fires after the plan document is fully written but before it is presented to the user for approval. The PLAN.md file exists on disk.

**Payload:**
```yaml
hook: post-plan
phase_name: "04-auth-system"
plan_path: ".paul/phases/04-auth-system/04-01-PLAN.md"
plan_content:                      # parsed plan structure
  objective: "Implement JWT auth"
  tasks:
    - id: 1
      description: "Create auth service"
      files: ["src/auth/service.ts"]
    - id: 2
      description: "Add middleware"
      files: ["src/auth/middleware.ts"]
  acceptance_criteria: [...]
context_from_pre_plan:             # accumulated context from pre-plan hooks
  tdd_candidates: [...]
```

**Return contract:**
```yaml
action: continue                   # continue | modify
# If modify:
plan_modifications:                # structured modifications to the plan
  task_overlays:                   # example: TODD restructures tasks as RED-GREEN-REFACTOR
    - task_id: 1
      subtasks:
        - phase: RED
          action: "Write failing tests for auth service"
        - phase: GREEN
          action: "Implement auth service to pass tests"
        - phase: REFACTOR
          action: "Clean up auth service implementation"
```

**Priority ordering:** Modifications are applied in priority order. If two modules both modify the same task, the lower-priority-number module's modification is applied first, and the higher-priority-number module sees the already-modified plan.

---

### 2.3 `pre-apply`

**Trigger:** Fires when `/paul:apply` is invoked and the user has approved the plan, before any task execution begins.

**Payload:**
```yaml
hook: pre-apply
phase_name: "04-auth-system"
plan_path: ".paul/phases/04-auth-system/04-01-PLAN.md"
plan_content:                      # parsed plan (including any post-plan modifications)
  tasks: [...]
project_root: "/path/to/project"
```

**Return contract:**
```yaml
action: continue                   # continue | block
# If continue:
context_inject:                    # context available to all tasks during execution
  test_baseline:                   # example: WALT captures test state before changes
    total: 142
    passing: 140
    failing: 2
    test_command: "npm test"
  tdd_enforced: true               # example: TODD flags enforcement is active
# If block:
reason: "Pre-apply check failed: ..."
```

---

### 2.4 `pre-test`

**Trigger:** Fires before test execution within a task. This hook fires only when a task includes a verification step that runs tests. It does not fire for tasks that have no test phase.

**Payload:**
```yaml
hook: pre-test
phase_name: "04-auth-system"
task_id: 1
task_description: "Create auth service"
test_command: "npm test"           # detected or configured test command
files_changed:                     # files modified so far in this task
  - "src/auth/service.ts"
  - "src/auth/service.test.ts"
```

**Return contract:**
```yaml
action: continue                   # continue | block
# If continue:
test_command_override: null        # optionally override the test command
# If block:
reason: "Tests must be written before implementation (RED phase)"
```

---

### 2.5 `post-task`

**Trigger:** Fires after each individual task within an apply phase completes (whether it succeeded or failed). This is the per-task hook, not the per-apply hook.

**Payload:**
```yaml
hook: post-task
phase_name: "04-auth-system"
task_id: 1
task_description: "Create auth service"
task_status: completed             # completed | failed | skipped
files_changed:
  - "src/auth/service.ts"
  - "src/auth/service.test.ts"
test_results:                      # if tests were run
  total: 145
  passing: 145
  failing: 0
context_from_pre_apply:            # accumulated context from pre-apply hooks
  test_baseline: { total: 142, passing: 140 }
```

**Return contract:**
```yaml
action: continue                   # continue | block
# If continue:
annotations:                      # metadata to attach to the task summary
  tdd_phase_completed: GREEN
  tests_added: 3
# If block:
reason: "Task failed quality gate: 2 test regressions detected"
```

---

### 2.6 `post-apply`

**Trigger:** Fires after all tasks in the apply phase have completed (or after the apply phase is halted due to a blocking hook). All task execution is finished.

**Payload:**
```yaml
hook: post-apply
phase_name: "04-auth-system"
plan_path: ".paul/phases/04-auth-system/04-01-PLAN.md"
tasks_completed: 5
tasks_failed: 0
tasks_skipped: 0
all_files_changed:
  - "src/auth/service.ts"
  - "src/auth/service.test.ts"
  - "src/auth/middleware.ts"
  - "src/auth/middleware.test.ts"
  - "src/auth/types.ts"
context_from_pre_apply:
  test_baseline: { total: 142, passing: 140 }
```

**Return contract:**
```yaml
action: continue                   # continue | block
# If continue:
annotations:                      # metadata for the phase summary
  quality_gate:
    tests: { before: 142, after: 150, regressions: 0 }
    lint: { errors: 0, warnings: 2 }
    typecheck: pass
# If block:
reason: "Quality gate failed: 3 test regressions, 1 lint error"
remediation:                       # optional guidance for fixing
  - "Fix test regression in auth.test.ts:42"
  - "Resolve lint error in middleware.ts:17"
```

---

### 2.7 `pre-unify`

**Trigger:** Fires when `/paul:unify` is invoked, before reconciliation begins. The kernel has loaded the plan and the apply results but has not yet compared them.

**Payload:**
```yaml
hook: pre-unify
phase_name: "04-auth-system"
plan_path: ".paul/phases/04-auth-system/04-01-PLAN.md"
summary_path: ".paul/phases/04-auth-system/04-01-SUMMARY.md"
plan_vs_actual:                    # kernel's initial diff
  tasks_planned: 5
  tasks_completed: 5
  deviations: []
annotations_from_apply:            # accumulated annotations from post-task and post-apply hooks
  quality_gate: { ... }
  tdd_phase_completed: REFACTOR
```

**Return contract:**
```yaml
action: continue                   # continue only (pre-unify cannot block)
context_inject:                    # additional data to include in unify reconciliation
  quality_trend:                   # example: WALT injects historical quality data
    last_3_phases: [...]
```

---

### 2.8 `post-unify`

**Trigger:** Fires after unify reconciliation is complete and the loop is about to close. STATE.md and ROADMAP.md have been updated. This is the final hook before the loop iteration ends.

**Payload:**
```yaml
hook: post-unify
phase_name: "04-auth-system"
plan_path: ".paul/phases/04-auth-system/04-01-PLAN.md"
summary_path: ".paul/phases/04-auth-system/04-01-SUMMARY.md"
state_update:                      # what changed in STATE.md
  previous_status: applying
  new_status: completed
  next_phase: "05-api-endpoints"
annotations_from_apply:            # all accumulated annotations
  quality_gate: { ... }
```

**Return contract:**
```yaml
action: continue                   # continue only (post-unify cannot block)
side_effects:                      # actions the module performed
  - "Recorded quality delta in quality-history.md"
  - "Updated TDD coverage metrics"
```

---

## 3. Hook Composition

When multiple modules subscribe to the same hook point, the kernel must resolve execution order, data flow, and failure handling.

### 3.1 Priority Ordering

Hooks run in ascending priority order (lower number first). Example for `pre-apply`:

| Module | Priority | Runs |
|--------|----------|------|
| TODD | 50 | 1st — enforces RED phase readiness |
| WALT | 100 | 2nd — captures test baseline |

If two modules declare the same priority on the same hook, execution order is alphabetical by module name. This is deterministic but should be avoided — modules should use distinct priorities.

### 3.2 Short-Circuit Behavior

When a hook returns `action: block`:

- **Blocking hooks** (`pre-plan`, `pre-apply`, `pre-test`, `post-task`, `post-apply`): Execution stops. Remaining modules on the same hook point **do not run**. The kernel surfaces the blocking module's `reason` to the user.
- **Non-blocking hooks** (`post-plan`, `pre-unify`, `post-unify`): These hooks cannot return `block`. If a module attempts to, the kernel ignores the block and treats it as `continue`.

Short-circuit order follows priority. If TODD (priority 50) blocks on `pre-apply`, WALT (priority 100) never runs on that invocation.

### 3.3 Data Passing Between Hooks

Hooks at the same hook point receive the same base payload from the kernel. They cannot directly pass data to each other within a single hook point. However:

- `context_inject` values from one hook point carry forward to subsequent hook points. If TODD injects `tdd_type: true` at `pre-plan`, that value appears in `context_from_pre_plan` at `post-plan`.
- `annotations` from `post-task` hooks accumulate and appear in `annotations_from_apply` at `post-apply`, `pre-unify`, and `post-unify`.
- Within a single hook point, if multiple modules return `context_inject`, their values are merged. On key collision, the higher-priority-number (later-running) module's value wins.

### 3.4 `context_inject` Schema

Every hook that returns `context_inject` must follow this schema:

```yaml
context_inject:
  <key>:                              # string key, unique per module per hook point
    value: <any>                      # the injected data (scalar, list, or object)
    format: key-value | structured | flag  # how the consumer should interpret it
```

**Format types:**
| Format | Description | Example |
|--------|-------------|---------|
| `flag` | Boolean signal — presence means active | `tdd_enforced: true` |
| `key-value` | Simple key with scalar/list value | `tdd_candidates: ["src/auth.ts"]` |
| `structured` | Object with nested fields | `test_baseline: { total: 142, passing: 140, test_command: "npm test" }` |

**Per-hook-point injection table:**

| Hook Point | Who Injects | Keys | Format | Consumed By |
|-----------|-------------|------|--------|-------------|
| pre-plan | DEAN | `dep_warnings` | key-value | plan scope analysis |
| pre-plan | TODD | `tdd_candidates`, `tdd_type` | key-value, flag | post-plan |
| pre-plan | IRIS | `review_flags` | key-value | plan scope analysis |
| pre-plan | DAVE | `deploy_warning` | flag | plan scope analysis |
| pre-plan | RUBY | `debt_flags` | key-value | plan scope analysis |
| pre-apply | TODD | `tdd_enforced` | flag | post-task, post-apply |
| pre-apply | WALT | `test_baseline` | structured | post-apply |
| post-task | TODD | `tdd_phase_completed` | key-value | accumulates → post-apply |
| post-apply | WALT | `quality_gate` | structured | pre-unify, SUMMARY |
| pre-unify | WALT | `quality_trend` | structured | reconciliation |

**Merge rules:** When multiple modules inject at the same hook point, values are merged by key. On key collision, the later-running module (higher priority number) wins.

### 3.5 Data Flow Summary

```
pre-plan
  └─ context_inject ──────────────► post-plan (as context_from_pre_plan)

post-plan
  └─ plan_modifications ──────────► kernel applies to plan

pre-apply
  └─ context_inject ──────────────► pre-test, post-task, post-apply
                                      (as context_from_pre_apply)

pre-test (per task)
  └─ test_command_override ────────► kernel uses for test execution

post-task (per task)
  └─ annotations ──────────────────► accumulate across tasks

post-apply
  └─ annotations ──────────────────► pre-unify, post-unify
                                      (as annotations_from_apply)

pre-unify
  └─ context_inject ──────────────► kernel includes in reconciliation

post-unify
  └─ side_effects ─────────────────► logged, no further processing
```

---

## 4. No-Op Behavior

When a module is not installed, the kernel skips its hook points with zero overhead. There are no conditional checks, no fallback logic, no warnings, and no errors.

The kernel iterates over registered hooks at each hook point. If no modules are registered for a hook point, the kernel proceeds immediately. This means:

- A kernel-only installation (no TODD, no WALT, no CARL) runs the plan/apply/unify loop with no hook overhead.
- Installing a module is additive. Removing a module returns the kernel to its prior behavior.
- The kernel never checks `if todd_installed` or `if walt_installed`. It checks `if hooks_registered_for("post-apply")`.

---

## 5. Module Filesystem Layout

### 5.1 Source Layout (in the PALS repo)

Each module lives in a subdirectory of `modules/` in the PALS repository:

```
pals/
├── kernel/                        # PAUL core (workflows, references, templates, rules)
│   ├── workflows/
│   ├── references/
│   ├── templates/
│   └── rules/
├── modules/
│   ├── todd/
│   │   ├── module.yaml
│   │   ├── references/
│   │   │   ├── tdd.md
│   │   │   ├── tdd-detection.md
│   │   │   ├── tdd-plan-generation.md
│   │   │   └── tdd-execution.md
│   │   └── workflows/
│   │       └── plan-phase-tdd.md
│   ├── walt/
│   │   ├── module.yaml
│   │   ├── references/
│   │   │   ├── quality-principles.md
│   │   │   ├── quality-runner.md
│   │   │   ├── quality-detection.md
│   │   │   ├── quality-lint.md
│   │   │   ├── quality-delta.md
│   │   │   └── quality-history.md
│   │   └── workflows/
│   │       └── quality-gate.md
│   └── carl/
│       ├── module.yaml
│       ├── config/
│       │   ├── manifest
│       │   ├── global
│       │   ├── context
│       │   ├── commands
│       │   └── example-custom-domain
│       ├── hooks/
│       │   └── carl-hook.py
│       └── commands/
│           ├── carl/
│           │   ├── manager.md
│           │   ├── tasks/
│           │   └── templates/
├── install.sh
├── uninstall.sh
└── README.md
```

### 5.2 Installed Layout (on the user's machine)

After installation, files land in standard locations:

```
~/.pals/
├── kernel.yaml                    # kernel version metadata
├── modules.yaml                   # registry of installed modules + versions
├── workflows/                     # kernel + module workflows (merged)
├── references/                    # kernel + module references (merged)
├── templates/                     # kernel + module templates (merged)
├── rules/                         # kernel + module rules (merged)
├── carl/                          # CARL-specific config (user-editable)
│   ├── manifest
│   ├── global
│   ├── context
│   └── commands

~/.claude/
├── commands/
│   ├── paul/                      # kernel commands
│   └── carl/                      # CARL module commands
├── hooks/
│   └── carl-hook.py               # CARL's platform-level hook
└── settings.json                  # hook registration
```

### 5.3 `modules.yaml` (Installed Module Registry)

The installer writes `~/.pals/modules.yaml` to track what is installed:

```yaml
kernel_version: "0.4.0"
installed_modules:
  todd:
    version: "1.0.0"
    installed_at: "2026-03-11T14:30:00Z"
    hooks: [pre-plan, post-plan, pre-apply, post-task, post-apply]
  walt:
    version: "1.0.0"
    installed_at: "2026-03-11T14:30:00Z"
    hooks: [pre-apply, post-apply, post-unify]
  carl:
    version: "1.0.0"
    installed_at: "2026-03-11T14:30:00Z"
    hooks: []                      # CARL uses platform hooks, not lifecycle hooks
    platform_hooks: [UserPromptSubmit]
```

---

## 6. Example Manifests

### 6.1 CARL (`modules/carl/module.yaml`)

```yaml
name: carl
display_name: CARL
description: >
  Context Augmentation & Reinforcement Layer. Manages domain-driven context
  rules that inject into every Claude prompt via keyword matching. Operates
  independently of the plan/apply/unify loop through Claude Code's native
  hook system.
version: 1.0.0

dependencies:
  kernel: ">=0.4.0"
  modules: []

hooks: {}
  # CARL does not use PAUL lifecycle hooks.
  # It operates through the platform.claude_code.hooks mechanism below.

files:
  references: []
  workflows: []
  templates: []
  config:
    - config/manifest
    - config/global
    - config/context
    - config/commands
    - config/example-custom-domain
  rules: []

commands:
  - name: carl:manager
    file: commands/carl/manager.md
    description: Manage CARL domains and rules
  - name: carl:manager/add-rule
    file: commands/carl/tasks/add-rule.md
    description: Add a rule to a domain
  - name: carl:manager/create-domain
    file: commands/carl/tasks/create-domain.md
    description: Create a new domain
  - name: carl:manager/create-command
    file: commands/carl/tasks/create-command.md
    description: Create a new command
  - name: carl:manager/edit-rule
    file: commands/carl/tasks/edit-rule.md
    description: Edit an existing rule
  - name: carl:manager/toggle-domain
    file: commands/carl/tasks/toggle-domain.md
    description: Toggle domain active state

platform:
  claude_code:
    hooks:
      - event: UserPromptSubmit
        type: command
        command: "python3 ~/.claude/hooks/carl-hook.py"
        source: hooks/carl-hook.py
    settings_patch: {}
```

### 6.2 TODD (`modules/todd/module.yaml`)

```yaml
name: todd
display_name: TODD
description: >
  Test-Driven Development enforcement. Detects TDD candidates during planning,
  structures plans as RED-GREEN-REFACTOR, and enforces phase discipline during
  apply execution.
version: 1.0.0

dependencies:
  kernel: ">=0.4.0"
  modules: []

hooks:
  pre-plan:
    priority: 100
    description: Detect TDD candidates via file heuristics and phase metadata
  post-plan:
    priority: 100
    description: Restructure plan tasks as RED-GREEN-REFACTOR when TDD type detected
  pre-apply:
    priority: 50
    description: Enforce RED phase — verify test files exist or will be created first
  post-task:
    priority: 100
    description: Enforce GREEN phase — verify tests pass after each implementation task
  post-apply:
    priority: 200
    description: Signal REFACTOR opportunity — suggest cleanup if all tests green

files:
  references:
    - references/tdd.md
    - references/tdd-detection.md
    - references/tdd-plan-generation.md
    - references/tdd-execution.md
  workflows:
    - workflows/plan-phase-tdd.md
  templates: []
  config: []
  rules: []

commands: []

platform: {}
```

### 6.3 WALT (`modules/walt/module.yaml`)

```yaml
name: walt
display_name: WALT
description: >
  Quality gating. Captures test baselines before apply, runs tests and lint
  after apply, detects regressions, and tracks quality trends across phases.
version: 1.0.0

dependencies:
  kernel: ">=0.4.0"
  modules: []

hooks:
  pre-apply:
    priority: 100
    description: Capture test baseline — run tests and record counts before changes
  post-apply:
    priority: 100
    description: Run tests, lint, typecheck; compare against baseline; gate on regressions
  post-unify:
    priority: 100
    description: Record quality delta in quality-history.md for trend tracking

files:
  references:
    - references/quality-principles.md
    - references/quality-runner.md
    - references/quality-detection.md
    - references/quality-lint.md
    - references/quality-delta.md
    - references/quality-history.md
  workflows:
    - workflows/quality-gate.md
  templates: []
  config: []
  rules: []

commands: []

platform: {}
```

---

## 7. Hook Implementation Notes

### 7.1 How the Kernel Dispatches Hooks

The kernel does not import module code. Hooks are dispatched by the kernel reading the installed `modules.yaml`, identifying which modules subscribe to the current hook point, sorting by priority, and then loading the module's relevant reference/workflow files as context for the current operation.

In PALS v0.4, modules are prompt-based, not code-based. A module's hook "firing" means: the kernel loads the module's declared files into context and follows the module's instructions at that point in the lifecycle. The payload schema and return contract above describe the logical data flow — not a programmatic API.

CARL is the exception: it has a real code hook (`carl-hook.py`) that runs through Claude Code's native `UserPromptSubmit` event. This is declared in `platform.claude_code.hooks` rather than in `hooks`.

### 7.2 Priority Ranges (Convention)

| Range | Intended Use |
|-------|-------------|
| 1-49 | Reserved for future kernel-internal hooks |
| 50-99 | Enforcement modules (must run early to block if needed) |
| 100-199 | Standard modules (default range) |
| 200-299 | Advisory modules (run after enforcement, can observe but rarely block) |
| 300-999 | User-defined modules |

### 7.3 Future: Code-Based Hooks

v0.4 hooks are prompt-context-based. A future version may support code-based hooks (Python/shell scripts) that run programmatically and return structured YAML. The manifest format is designed to accommodate this by adding an `implementation` field to each hook entry:

```yaml
hooks:
  pre-apply:
    priority: 100
    description: Capture test baseline
    implementation: hooks/pre-apply.py    # future: code-based hook
```

This field is reserved but not yet supported.
