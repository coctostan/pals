# PALS Hooks — Pi Extension

Bridges Pi lifecycle events to PALS workflows and registers `/paul-*` slash commands.

## Install

Copy the extension to Pi's global extensions directory:

```bash
cp pals-hooks.ts ~/.pi/agent/extensions/pals-hooks.ts
```

Pi discovers extensions automatically on next session start.

## Command Model

Pi exposes two aligned PALS entry surfaces:

- `/paul-*` — the ergonomic Pi command layer for everyday discovery and routing
- `/skill:paul-*` — the canonical Pi skill layer that owns the underlying workflow entry point

Each `/paul-*` command is a brief Pi-native convenience wrapper that routes to the corresponding canonical skill (`/skill:paul-*`). The extension provides the command/hook layer only; shared workflows and canonical skills remain the implementation truth, and command guidance stays local so workflow-context injection does not expand as part of discovery.

Pi also installs enabled PALS modules into the same skill tree and records them in `~/.pi/agent/skills/pals/modules.yaml`. Those modules are not separate Pi skills; workflows read that registry and dispatch module guidance from shared markdown at plan/apply/unify time.

## Quick Actions & Shortcuts

The lifecycle widget exposes a bounded quick-action set for the highest-frequency PALS entry points:
- Next action — `Ctrl+Alt+N`
- Status — `Ctrl+Alt+S`
- Resume — `Ctrl+Alt+R`
- Help — `Ctrl+Alt+H`
- Milestone — `Ctrl+Alt+M`
The always-visible UI keeps only the first three actions in the primary summary and moves the rest into a secondary "More" line. These shortcuts stay adapter-only: they route into the existing `/paul-*` wrapper layer, which in turn routes to canonical `/skill:paul-*` entries. They do not create new workflow semantics or Pi-owned lifecycle truth.

## Guided Workflow UX

The extension adds a bounded guided workflow layer for canonical PALS lifecycle moments already emitted by shared workflows. It inspects recent assistant output plus `.paul/STATE.md` for stable markers such as `Continue to APPLY`, `Continue to UNIFY`, `CHECKPOINT:`, and `▶ NEXT:`.

When one of those moments appears, Pi may use lightweight native surfaces such as `notify`, `confirm`, or `select` to help the user respond. If the user explicitly continues, the extension routes the exact canonical reply back through normal user-message flow via `pi.sendUserMessage(...)` (`approved`, `yes`, `1`, selected option id, etc.).

This layer is additive only: it never auto-continues a workflow, never skips human verification or human-action checkpoints, and never stores a Pi-owned workflow state. Shared `.paul/*` artifacts and shared markdown workflows remain authoritative.

## Commands

The extension registers these slash commands:

| Command | Description |
|---------|-------------|
| /paul-init | Set up PALS lifecycle files for this project |
| /paul-plan | Plan the next PALS phase |
| /paul-apply | Execute the approved PALS plan |
| /paul-unify | Reconcile completed work and close the loop |
| /paul-resume | Resume PALS work from current project state |
| /paul-status | Show current PALS status and next action |
| /paul-fix | Run a quick PALS fix flow |
| /paul-pause | Create a PALS handoff before stopping |
| /paul-milestone | Create or complete a PALS milestone |
| /paul-discuss | Discuss scope before planning in PALS |
| /paul-help | Show Pi command and skill guidance for PALS |

## Event Hooks
- **session_start**: Orientation only — detects `.paul/`, reads `STATE.md`, refreshes lifecycle UI, and explains the runtime model without injecting workflow context.
- **before_agent_start**: Primary PALS injection point. Explicit `/paul-*` (or `/skill:paul-*`) activation signals are treated as highest confidence, then one bounded `PALS Context` payload is injected from `.paul/STATE.md` as the authoritative source.
- **turn_end**: Refreshes the always-visible lifecycle status/widget so shortcut hints stay aligned with shared artifacts.
- **agent_end**: Re-checks recent assistant output for canonical guided workflow moments and, when appropriate, offers additive Pi-native continuation UI while keeping the shared workflow prompt authoritative.
- **context**: Supporting surface only. It keeps context lean by trimming legacy/duplicate PALS context messages; it is not the architectural center of injection.
## Requirements

- Pi coding agent with extension support
- PALS skills installed at `~/.pi/agent/skills/pals/` (see `skill-map.md`)
- Enabled module overlays installed into the same tree with `modules.yaml` describing which lifecycle hook semantics are available

## References

- [Pi Extensions docs](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/extensions.md)
- [Skill Map](../skill-map.md) — command/skill/workflow mapping for the Pi adapter
