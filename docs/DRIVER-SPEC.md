# PALS Driver Interface Specification

**Version:** 0.4-draft
**Status:** Design document

---

## Overview

A **driver** is a platform adapter that translates PALS kernel operations into platform-specific actions. The kernel is platform-agnostic markdown — plan/apply/unify workflows, state files, lifecycle hooks, and templates. Drivers make this kernel executable on a specific platform.

The driver interface defines five methods that every driver must implement. A driver MAY return no-op for methods that do not apply to its platform, but it MUST implement the interface.

### Current Drivers

| Driver | Platform | Status |
|--------|----------|--------|
| `claude-code` | Claude Code CLI (slash commands + hooks) | Production |
| `agent-sdk` | Anthropic Agent SDK (system prompts + file orchestration) | Planned |

### Future Drivers

Codex, OpenCode, OpenClaw, NanoClaw, or any system that can read markdown and maintain file state.

---

## Driver Methods

### 1. workflow_invoke

Load and execute a named kernel workflow.

```
workflow_invoke(workflow_name: string, context: WorkflowContext) -> WorkflowResult
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `workflow_name` | `string` | Yes | Workflow identifier (e.g., `plan-phase`, `apply-phase`, `unify-phase`) |
| `context` | `WorkflowContext` | Yes | Execution context (see below) |

**WorkflowContext:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `project_root` | `string` | Yes | Absolute path to the project directory |
| `state_path` | `string` | Yes | Path to STATE.md |
| `phase` | `string` | No | Current phase identifier (e.g., `01-architecture-design`) |
| `plan` | `string` | No | Current plan identifier (e.g., `01-01`) |
| `params` | `map<string, string>` | No | Additional workflow-specific parameters |

**WorkflowResult:**

| Field | Type | Description |
|-------|------|-------------|
| `status` | `string` | `completed`, `blocked`, `error` |
| `next_action` | `string` | Suggested next workflow or user action |
| `artifacts` | `list<string>` | Paths to files created or modified |

**Driver Mappings:**

| Driver | Implementation |
|--------|---------------|
| **Claude Code** | Slash command (e.g., `/paul:plan`) loads the workflow markdown file from `~/.pals/workflows/{name}.md`. The conversation context becomes the execution environment — the LLM reads the workflow instructions and follows them step by step. |
| **Agent SDK** | Orchestration code reads `~/.pals/workflows/{name}.md` and injects it as the agent's system prompt (or appends to an existing system prompt). The agent then follows the workflow instructions autonomously. The orchestrator monitors for completion signals. |

---

### 2. hook_register

Register a handler for a kernel lifecycle hook.

```
hook_register(hook_name: string, handler: HookHandler) -> void
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `hook_name` | `string` | Yes | Lifecycle event name (see hook names below) |
| `handler` | `HookHandler` | Yes | Handler to invoke when the hook fires |

**HookHandler:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `module` | `string` | Yes | Module that owns this handler (e.g., `todd`, `walt`, `carl`) |
| `priority` | `integer` | No | Execution order (lower = earlier, default 100) |
| `callback` | `function` | Yes | Platform-specific callable |

**Hook Names (kernel-defined):**

| Hook | Fires When |
|------|------------|
| `pre-plan` | Before plan creation begins |
| `post-plan` | After plan is drafted, before user approval |
| `pre-apply` | Before task execution begins |
| `post-task` | After each individual task completes |
| `post-apply` | After all tasks in a plan complete |
| `pre-unify` | Before reconciliation begins |
| `post-unify` | After reconciliation completes |
| `UserPromptSubmit` | Before each user prompt is processed (external to plan/apply/unify loop) |

**Hook Callback Signature:**

```
callback(hook_context: HookContext) -> HookResponse
```

**HookContext:**

| Field | Type | Description |
|-------|------|-------------|
| `hook_name` | `string` | Which hook is firing |
| `project_root` | `string` | Project directory |
| `state` | `object` | Current STATE.md parsed content |
| `payload` | `object` | Hook-specific data (e.g., plan content for post-plan, task result for post-task) |

**HookResponse:**

| Field | Type | Description |
|-------|------|-------------|
| `action` | `string` | `continue`, `block`, or `modify` |
| `reason` | `string` | Human-readable explanation (required if `block` or `modify`) |
| `modifications` | `object` | Changed data (only if action is `modify`) |

**Driver Mappings:**

| Driver | Implementation |
|--------|---------------|
| **Claude Code** | Wires into the Claude Code hooks system. For `UserPromptSubmit`, registers an entry in `~/.claude/settings.json` under `hooks.UserPromptSubmit` pointing to an executable (e.g., `hooks/carl-hook.py`). For kernel lifecycle hooks (`pre-plan`, `post-apply`, etc.), the workflow markdown files contain conditional `<references>` blocks that load module-specific files when relevant. |
| **Agent SDK** | The orchestration code maintains a hook registry in memory. At each lifecycle point, the orchestrator iterates registered handlers by priority, calls each one programmatically, and collects responses. Block responses halt execution; modify responses update the pipeline context. |

---

### 3. state_read / state_write

Read and write kernel state files.

```
state_read(file: string) -> string | null
state_write(file: string, content: string) -> void
```

**Parameters (state_read):**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `file` | `string` | Yes | Relative path within the state directory (e.g., `STATE.md`, `phases/01-design/01-01-PLAN.md`) |

**Returns:** File content as a string, or null if the file does not exist.

**Parameters (state_write):**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `file` | `string` | Yes | Relative path within the state directory |
| `content` | `string` | Yes | Full file content to write |

**State Directory Convention:**

The kernel stores all project state under `{project_root}/.paul/`. This path is fixed across all drivers. The state directory contains:

| Path | Purpose |
|------|---------|
| `.paul/STATE.md` | Current project state (phase, loop position, status) |
| `.paul/PROJECT.md` | Project definition |
| `.paul/ROADMAP.md` | Phase roadmap |
| `.paul/phases/{phase}/` | Phase-specific plans, summaries, artifacts |
| `.paul/handoffs/` | Session handoff documents |
| `.paul/config.md` | Project configuration |

**Driver Mappings:**

| Driver | Implementation |
|--------|---------------|
| **Claude Code** | Direct filesystem read/write. The LLM uses file tools (`Read`, `Write`, `Edit`) to interact with `.paul/` files. No abstraction layer needed — the filesystem IS the state store. |
| **Agent SDK** | Default implementation uses filesystem (same as Claude Code). Alternative implementations could back state to a database, object store, or API. The driver translates `state_read`/`state_write` calls to the appropriate backend. When using non-filesystem backends, the driver must maintain path semantics (directory structure, relative paths). |

---

### 4. user_interact

Present information to the user and optionally collect input.

```
user_interact(prompt: string, options: InteractionOptions) -> UserResponse
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | `string` | Yes | Text to present to the user |
| `options` | `InteractionOptions` | No | Interaction configuration |

**InteractionOptions:**

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `type` | `string` | `open` | `open` (free text), `confirm` (yes/no), `select` (pick from list) |
| `choices` | `list<string>` | `[]` | Available choices (for `select` type) |
| `default` | `string` | `null` | Default response if user provides none |
| `required` | `boolean` | `true` | Whether a response is required to proceed |
| `timeout_seconds` | `integer` | `null` | Auto-proceed with default after timeout (null = wait forever) |

**UserResponse:**

| Field | Type | Description |
|-------|------|-------------|
| `value` | `string` | The user's response |
| `source` | `string` | `user`, `default`, or `timeout` |

**Driver Mappings:**

| Driver | Implementation |
|--------|---------------|
| **Claude Code** | Conversation-based. The LLM displays the prompt text in the conversation and waits for the user to type a response. For `confirm` type, the LLM asks a yes/no question. For `select`, the LLM presents numbered options. This is the natural Claude Code interaction pattern — no special plumbing needed. |
| **Agent SDK** | Multiple options depending on deployment: (a) CLI prompt via stdin/stdout, (b) API callback to an external service that collects the response, (c) webhook notification with a response endpoint, (d) automated policy that returns pre-configured responses for known interaction types. For fully autonomous operation, the driver can be configured to auto-approve with `timeout_seconds: 0`. |

---

### 5. command_register

Register a user-facing command that can be invoked by name.

```
command_register(name: string, handler: CommandHandler) -> void
```

**Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | `string` | Yes | Command name using namespace:action format (e.g., `paul:plan`, `carl:manager`) |
| `handler` | `CommandHandler` | Yes | Command definition |

**CommandHandler:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `description` | `string` | Yes | One-line description of what the command does |
| `workflow` | `string` | No | Workflow to invoke (if the command maps directly to a workflow) |
| `markdown` | `string` | No | Path to command markdown file (for Claude Code) |
| `params` | `list<ParamDef>` | No | Expected parameters |

**ParamDef:**

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Parameter name |
| `type` | `string` | `string`, `boolean`, `integer` |
| `required` | `boolean` | Whether the parameter is required |
| `description` | `string` | Help text |

**Driver Mappings:**

| Driver | Implementation |
|--------|---------------|
| **Claude Code** | Copies command markdown files to `~/.claude/commands/{namespace}/{action}.md`. Claude Code natively discovers these as slash commands (e.g., `/paul:plan`). The command markdown contains instructions the LLM follows when the user invokes the command. |
| **Agent SDK** | Returns no-op for most commands — the Agent SDK does not have a slash command system. Commands that map to workflows can be registered as named entry points in the orchestrator's API. Commands that are purely conversational (e.g., `paul:help`, `paul:progress`) can be mapped to utility functions that format and return information. |

---

## Driver Manifest

Every driver declares its capabilities in a `driver.yaml` file at the driver's root.

```yaml
# driver.yaml
name: claude-code
version: 0.4.0
platform: claude-code
description: PALS driver for Claude Code CLI

# Which kernel version this driver targets
kernel_version: ">=0.4.0"

# Capabilities this driver supports
capabilities:
  workflow_invoke: true
  hook_register: true
  state_read: true
  state_write: true
  user_interact: true
  command_register: true

# Driver-specific configuration
config:
  # Where commands are installed
  command_dir: "~/.claude/commands"
  # Where hooks are registered
  hook_config: "~/.claude/settings.json"
  # Where framework files live
  framework_dir: "~/.pals"

# Files this driver provides (beyond the kernel)
files:
  - install.sh
  - uninstall.sh
  - hooks/carl-hook.py
```

**Agent SDK driver.yaml example:**

```yaml
name: agent-sdk
version: 0.4.0
platform: anthropic-agent-sdk
description: PALS driver for Anthropic Agent SDK

kernel_version: ">=0.4.0"

capabilities:
  workflow_invoke: true
  hook_register: true
  state_read: true
  state_write: true
  user_interact: true
  command_register: false  # no-op on this platform

config:
  state_backend: filesystem  # or "database", "api"
  auto_approve: false
  system_prompt_injection: prepend  # or "append"
```

---

## Driver Discovery and Loading

The kernel discovers the active driver through a fixed resolution order:

1. **Explicit configuration** — If `.paul/config.md` contains a `driver:` field, use that driver name.
2. **Environment detection** — If no explicit config:
   - Check for `~/.claude/` directory presence -> `claude-code` driver
   - Check for `ANTHROPIC_AGENT_SDK` environment variable -> `agent-sdk` driver
3. **Fallback** — If no driver is detected, the kernel operates in "bare" mode: all driver methods are no-ops, and the kernel only manages state files. This is useful for testing and for platforms not yet supported.

**Resolution at install time:**

The installer (`install.sh` or equivalent) is driver-specific. It copies kernel files to the framework directory and then runs driver-specific setup (registering hooks, symlinking commands, etc.). The installer sets the active driver in the project or global config.

**Resolution at runtime:**

When a workflow is invoked, the kernel reads the active driver name, loads the driver's method implementations, and delegates all platform operations through the driver interface. The kernel never calls platform APIs directly.

---

## Developing a New Driver

Step-by-step guide for adding a driver to PALS (e.g., a hypothetical `opencode` driver).

### Step 1: Create the driver directory

```
pals/
  drivers/
    opencode/
      driver.yaml
      install.sh        # platform-specific installer
      uninstall.sh      # platform-specific uninstaller
      README.md         # driver-specific docs
```

### Step 2: Write the driver manifest

Create `driver.yaml` declaring the driver name, platform, kernel version compatibility, and capabilities. Set any unsupported capabilities to `false`.

### Step 3: Implement the five methods

For each method, write the platform-specific translation:

| Method | What to implement |
|--------|-------------------|
| `workflow_invoke` | How does your platform load and execute a markdown workflow file? Inject as system prompt? Parse and execute steps? |
| `hook_register` | How does your platform handle lifecycle callbacks? Native hook system? Event emitter? Manual dispatch? |
| `state_read` / `state_write` | How does your platform read/write files? If filesystem, this may be trivial. If not, implement the backend adapter. |
| `user_interact` | How does your platform collect user input? Conversation? API? CLI? Auto-approve policy? |
| `command_register` | Does your platform have a command system? If not, return no-op. If yes, wire commands into it. |

### Step 4: Write the installer

The installer must:

1. Copy kernel files (workflows, references, templates, rules) to the framework directory.
2. Run driver-specific setup (register hooks, install commands, configure the platform).
3. Set the active driver in config.
4. Validate the installation.

Use the existing `install.sh` (Claude Code driver) as a reference.

### Step 5: Test against the kernel contract

Verify that:

- `workflow_invoke("plan-phase", context)` loads and executes the plan workflow.
- `hook_register("post-apply", handler)` fires the handler after apply completes.
- `state_read("STATE.md")` returns current state content.
- `state_write("STATE.md", content)` persists updated state.
- `user_interact("Approve?", {type: "confirm"})` collects a yes/no response.
- `command_register("paul:plan", handler)` registers (or no-ops) the command.

### Step 6: Document platform-specific behavior

Every driver will have quirks. Document:

- What is different from the reference (Claude Code) implementation.
- What capabilities are no-op and why.
- Any additional setup the user must perform.
- Known limitations.

### Step 7: Submit the driver

Add the driver directory to the PALS repository under `drivers/`. Update the kernel's driver discovery logic to recognize the new platform. Add the driver to this spec's "Current Drivers" table.

---

## Design Constraints

1. **Drivers never reference specific modules.** A driver does not know about TODD, WALT, or CARL. It dispatches hooks and loads workflows — it does not know what those hooks or workflows do.

2. **The kernel never references drivers by name.** The kernel calls driver methods through the interface. It does not contain `if driver == "claude-code"` branches.

3. **Missing methods = no-op.** If a driver sets a capability to `false`, the kernel skips that operation silently. No errors.

4. **State format is fixed.** All drivers must use the same markdown state file format. The `.paul/` directory structure and file formats are kernel concerns, not driver concerns.

5. **Workflow markdown is platform-agnostic.** Workflow files do not contain platform-specific instructions. If a workflow needs platform-specific behavior, it calls a driver method — it does not embed Claude Code syntax or Agent SDK API calls.
