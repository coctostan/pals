# PALS Hooks — Pi Extension

Bridges Pi lifecycle events to PALS workflows and registers `/paul-*` slash commands.

## Install

Copy the extension to Pi's global extensions directory:

```bash
cp pals-hooks.ts ~/.pi/agent/extensions/pals-hooks.ts
```

Pi discovers extensions automatically on next session start.

## Commands

The extension registers these slash commands:

| Command | Description |
|---------|-------------|
| /paul-init | Initialize PALS in this project |
| /paul-plan | Create execution plan for current phase |
| /paul-apply | Execute an approved plan |
| /paul-unify | Reconcile plan vs actual and close the loop |
| /paul-resume | Restore context and continue work |
| /paul-status | Show project progress and next action |
| /paul-fix | Quick fix with compressed loop |
| /paul-pause | Create handoff and prepare for session break |
| /paul-milestone | Create or complete a milestone |
| /paul-discuss | Explore phase or milestone vision |
| /paul-help | Show available PAUL commands |

Each command delegates to the corresponding Pi skill (`/skill:paul-*`).

## Event Hooks

- **session_start**: Detects `.paul/` directory, reads STATE.md, and logs current phase/loop position.
- **context**: When a PALS workflow is active, injects project state (phase, loop position, active modules) so the LLM can follow PALS workflows correctly.

## Requirements

- Pi coding agent with extension support
- PALS skills installed at `~/.pi/agent/skills/pals/` (see skill-map.md)

## References

- [Pi Extensions docs](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/extensions.md)
- [Skill Map](../skill-map.md) — full workflow-to-skill mapping
