# PALS Agent SDK Driver

**Status:** Proof-of-concept stub

Runs PALS kernel workflows headless using the [Anthropic Agent SDK](https://github.com/anthropics/claude-agent-sdk-python). This driver proves the PALS kernel is platform-agnostic — the same workflow markdown that powers Claude Code slash commands can drive an autonomous agent via the SDK.

## Prerequisites

- Python 3.10+
- Anthropic API key
- PALS kernel installed (`~/.pals/workflows/` must exist)

## Setup

```bash
cd drivers/agent-sdk
pip install -r requirements.txt
export ANTHROPIC_API_KEY=sk-ant-...
```

## Usage

Run a workflow against a project:

```bash
python pals-agent.py ~/.pals/workflows/plan-phase.md --project-dir /path/to/project
```

With a specific prompt:

```bash
python pals-agent.py ~/.pals/workflows/plan-phase.md \
  --project-dir /path/to/project \
  --prompt "Plan phase 3: API implementation"
```

Piped input:

```bash
echo "Create the initial project roadmap" | \
  python pals-agent.py ~/.pals/workflows/init-project.md --project-dir /path/to/project
```

### Options

| Flag | Default | Description |
|------|---------|-------------|
| `workflow` | (required) | Path to workflow .md file |
| `--project-dir` | Current directory | Project with `.paul/` state |
| `--prompt` | Auto-generated | Task prompt for the agent |
| `--permission-mode` | `acceptEdits` | `acceptEdits`, `dontAsk`, or `default` |

## How It Works

1. Reads the workflow markdown file (e.g., `plan-phase.md`)
2. Injects it as the `system_prompt` for the Agent SDK's `query()` function
3. The agent receives the same built-in tools as Claude Code: Read, Write, Edit, Bash, Glob, Grep
4. The agent follows the workflow instructions autonomously, reading/writing `.paul/` state files
5. Output streams to stdout

The key insight: PALS workflows are plain markdown instructions. Claude Code loads them as slash commands. The Agent SDK loads them as system prompts. The kernel doesn't care which — it just needs an LLM that can read markdown and use file tools.

## Known Limitations

- **No hook dispatch**: Kernel lifecycle hooks (pre-plan, post-apply, etc.) are not dispatched to modules. Module references must be manually included in the workflow or system prompt.
- **No interactive checkpoints**: Checkpoint tasks (human-verify, decision) are not handled interactively. The agent will attempt to proceed autonomously.
- **No command registration**: The Agent SDK has no slash command system. `command_register` is a no-op.
- **No multi-session state**: Each invocation is a fresh session. Session resume via `session_id` is not implemented.
- **Requires API key**: Unlike Claude Code CLI, the Agent SDK requires an `ANTHROPIC_API_KEY`.

## Future Work

- **Hook dispatch**: Parse `modules.yaml`, load module references at lifecycle points
- **Interactive mode**: Pause at checkpoints, collect user input via stdin
- **Multi-plan sessions**: Resume sessions across plan/apply/unify cycles
- **Install script**: Auto-detect Agent SDK and configure the driver
- **State backend abstraction**: Support database or API-backed state (beyond filesystem)

## Driver Capabilities

| Method | Status | Notes |
|--------|--------|-------|
| `workflow_invoke` | Implemented | Workflow markdown as system_prompt |
| `hook_register` | Stub (TODO) | No module hook dispatch yet |
| `state_read/write` | Implemented | Via built-in Read/Write/Edit tools |
| `user_interact` | Partial | Stdout only, no interactive input |
| `command_register` | No-op | No slash command system |
