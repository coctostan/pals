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

## Collaboration-Aware Planning

Shared planning workflows now support a bounded collaboration model:
- project default: `pals.json` → `planning.default_collaboration`
- per-run override: keep the default or switch to `low`, `medium`, or `high`
- planning mode: `exploratory` vs `direct-requirements`
- progressive review: `Quick recap`, `Detailed recap`, `Full plan`, `No review needed`

These behaviors belong to shared markdown workflows (`init-project`, `discuss-milestone`, `discuss-phase`, `create-milestone`, `plan-phase`). Pi surfaces them; it does not redefine them.

## Quick Actions & Shortcuts

The lifecycle widget exposes a bounded quick-action set for the highest-frequency PALS entry points:
- Next action — `Ctrl+Alt+N`
- Status — `Ctrl+Alt+S`
- Resume — `Ctrl+Alt+R`
- Help — `Ctrl+Alt+H`
- Milestone — `Ctrl+Alt+M`

The always-visible UI keeps only the first three actions in the primary summary and moves the rest into a secondary "More" line. These shortcuts stay adapter-only: they route into the existing `/paul-*` wrapper layer, which in turn routes to canonical `/skill:paul-*` entries. They do not create new workflow semantics or Pi-owned lifecycle truth.

## Guided Workflow UX

The extension adds a bounded guided workflow layer for canonical PALS lifecycle moments already emitted by shared workflows. It inspects recent assistant output plus `.paul/STATE.md` for stable markers such as `Would you like to see the plan?`, `Continue to APPLY`, `Continue to UNIFY`, `CHECKPOINT:`, and `▶ NEXT:`.

When one of those moments appears, Pi may use lightweight native surfaces such as `notify`, `confirm`, or `select` to help the user respond. If the user explicitly continues, the extension routes the exact canonical reply back through normal user-message flow via `pi.sendUserMessage(...)` (`1`, `approved`, `yes`, selected option id, etc.).

This layer is additive only: it never auto-continues a workflow, never skips human verification or human-action checkpoints, and never stores a Pi-owned workflow state. Shared `.paul/*` artifacts and shared markdown workflows remain authoritative.

## Live Module Visibility

The always-visible Pi status/widget now includes a bounded recent module activity summary when a trustworthy signal is present. That visibility is dispatch-derived from recent shared workflow/reporting output plus shared artifacts — especially canonical markers such as `[dispatch] pre-plan: ...`, `[dispatch] post-apply: ...`, and `Module Execution Reports`.

This surface is informative, adapter-only, and non-authoritative. It does not create Pi-owned module state, does not use `appendEntry`, and clears naturally when recent shared workflow output no longer provides a trustworthy module activity signal.

## CARL Session Boundary Manager

CARL in Pi manages autonomous session boundaries — it detects phase completion and creates fresh sessions when context pressure exceeds configurable thresholds. This is distinct from Claude Code CARL, which handles context rule injection via `UserPromptSubmit` hooks. The two serve different roles on different platforms (the "two-CARL model").

### How It Works

1. **Command stashing**: Every `/paul-*` command handler stashes the `ExtensionCommandContext` so CARL can later call `newSession()` to create a fresh session.
2. **Phase detection**: At `agent_end`, CARL extracts the loop signature (✓/○ marks) from `.paul/STATE.md` and compares it against the previous signature. A change to "✓✓✓" means the PLAN-APPLY-UNIFY loop just completed.
3. **Decision model**: On loop completion, CARL computes the context ratio (`tokens / contextWindow`) and compares it against `continue_threshold`. If the ratio exceeds the threshold (or strategy is `always-fresh`), it creates a new session.
4. **Safety valve**: At `turn_end`, CARL monitors context pressure. If the ratio reaches `safety_ceiling`, it sets a `pauseAtNextBoundary` flag that triggers a session break at the next `agent_end`.
5. **Bootstrap & auto-resume**: Fresh sessions receive a compact state summary and CARL automatically runs `/skill:paul-resume` to continue work.

### Strategies

| Strategy | Behavior |
|----------|----------|
| `phase-boundary` (default) | Creates fresh session at phase completion only when context ratio ≥ `continue_threshold` |
| `always-fresh` | Creates fresh session at every phase completion regardless of context pressure |
| `manual` | Disables CARL entirely; user manages session boundaries |

### Threshold Defaults

| Setting | Default | Purpose |
|---------|---------|----------|
| `continue_threshold` | 0.4 (40%) | Context ratio below which CARL continues in the same session |
| `safety_ceiling` | 0.8 (80%) | Context ratio that triggers a safety break at the next boundary |

These defaults were validated empirically in Phase 76 (API validation). They can be overridden per-project in `pals.json` → `modules.carl`.

### Configuration

```json
{
  "modules": {
    "carl": {
      "enabled": true,
      "session_strategy": "phase-boundary",
      "continue_threshold": 0.4,
      "safety_ceiling": 0.8
    }
  }
}
```

No separate `/carl-*` commands are needed in Pi — CARL runs automatically via extension event hooks.

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
- **turn_end**: Refreshes the always-visible lifecycle status/widget so shortcut hints and any recent dispatch-derived module activity stay aligned with shared artifacts and recent shared workflow output. Also runs CARL's safety ceiling monitor (`carlMonitorSafetyCeiling`).
- **agent_end**: Re-checks recent assistant output for canonical guided workflow moments and bounded live module activity, then offers additive Pi-native continuation UI only when the shared workflow prompt remains authoritative. Also runs CARL's phase completion evaluator (`carlEvaluatePhaseCompletion`) and checks the safety boundary flag.
- **context**: Supporting surface only. It keeps context lean by trimming legacy/duplicate PALS context messages; it is not the architectural center of injection.

## Requirements

- Pi coding agent with extension support
- PALS skills installed at `~/.pi/agent/skills/pals/` (see `skill-map.md`)
- Enabled module overlays installed into the same tree with `modules.yaml` describing which lifecycle hook semantics are available

## Installation Boundaries

`install.sh` deploys PALS artifacts to two distinct Pi locations:

| Artifact | Install Target | Purpose |
|----------|---------------|---------|
| Kernel files (`workflows/`, `references/`, `templates/`, `rules/`) | `~/.pi/agent/skills/pals/` | Shared markdown workflows referenced by skills and the extension |
| Skill entry points (11 `SKILL.md` files) | `~/.pi/agent/skills/pals/{skill-name}/SKILL.md` | Pi skill invocation layer for `/skill:paul-*` |
| Pi extension | `~/.pi/agent/extensions/pals-hooks.ts` | Command registration, lifecycle hooks, guided workflow UX |
| Module registry | `~/.pi/agent/skills/pals/modules.yaml` | Enabled PALS module overlays (TODD, WALT, etc.) |

These are distinct install targets. The extension goes to `~/.pi/agent/extensions/`, skills and kernel files go to `~/.pi/agent/skills/pals/`. Uninstalling the extension alone does not remove skills or kernel files; `uninstall.sh` handles the full cleanup of all targets.

## Development Workflow

When modifying `pals-hooks.ts`, always edit the **repo source** at `drivers/pi/extensions/pals-hooks.ts`. Never edit the installed runtime copy at `~/.pi/agent/extensions/pals-hooks.ts` directly — it will be overwritten by the next `install.sh` run.

After editing the repo source, re-deploy:
```bash
bash drivers/pi/install.sh
```

PALS plans that target this file MUST use the repo-relative path `drivers/pi/extensions/pals-hooks.ts` in their `<files>` tags, not the installed path.

## References

- [Pi Extensions docs](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/extensions.md)
- [Skill Map](../skill-map.md) — command/skill/workflow mapping for the Pi adapter
