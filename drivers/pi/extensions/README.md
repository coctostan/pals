# PALS Hooks — Pi Extension

Bridges Pi lifecycle events to PALS workflows and registers `/paul-*` slash commands.

## Install

Copy the extension to Pi's global extensions directory:

```bash
cp pals-hooks.ts ~/.pi/agent/extensions/pals-hooks.ts
```

Pi discovers extensions automatically on next session start.

## Command Model

Pi installs three distinct PALS runtime surfaces:

- `~/.pi/agent/skills/pals/` — shared kernel files plus canonical `/skill:paul-*` entry points
- `~/.pi/agent/extensions/pals-hooks.ts` — the Pi-native `/paul-*` command layer, lifecycle hooks, and guided workflow UX
- `~/.pi/agent/agents/` — project-shipped helper agents such as `pals-implementer`

Only the first two are direct lifecycle entry surfaces. Project-shipped agents are helper definitions that parent-controlled workflows may invoke when an eligible bounded repo-local task needs isolated implementation work.

Each `/paul-*` command is a brief Pi-native convenience wrapper that routes to the corresponding canonical skill (`/skill:paul-*`). The extension provides the command/hook layer only; shared workflows and canonical skills remain the implementation truth, and command guidance stays local so workflow-context injection does not expand as part of discovery.
Pi also installs enabled PALS modules into the same skill tree and records them in `~/.pi/agent/skills/pals/modules.yaml`. Those modules are not separate Pi skills; workflows read that registry and dispatch module guidance from shared markdown at plan/apply/unify time. Because Pi resolves file access from the active workspace, the Pi installer renders the installed `SKILL.md` files with absolute install-root paths (for workflows, references, templates, rules, and `modules.yaml`) so module dispatch does not fall back to repo-local lookup.
Delegated APPLY stays bounded. If `/skill:paul-apply` uses `pals-implementer`, the parent workflow still owns verification, checkpoints, module gates, fallback judgment, and `.paul/*` artifacts. Pi surfaces the helper only for eligible bounded repo-local work; Pi does not become lifecycle truth.

## Collaboration-Aware Planning

Shared planning workflows now support a bounded collaboration model:
- project default: `pals.json` → `planning.default_collaboration`
- per-run override: keep the default or switch to `low`, `medium`, or `high`
- planning mode: `exploratory` vs `direct-requirements`
- progressive review: `Quick recap`, `Detailed recap`, `Full plan`, `No review needed`

These behaviors belong to shared markdown workflows (`init-project`, `discuss-milestone`, `discuss-phase`, `create-milestone`, `plan-phase`). Pi surfaces them; it does not redefine them.

## Quick Actions & Shortcuts

The always-visible lifecycle surface stays centered on milestone, phase, loop, and next action. Pi also exposes a bounded shortcut set for the highest-frequency PALS entry points:
- Next action — `Ctrl+Alt+N`
- Status — `Ctrl+Alt+S`
- Resume — `Ctrl+Alt+R`
- Help — `Ctrl+Alt+H`
- Milestone — `Ctrl+Alt+M`

These shortcuts are entry points, not persistent widget rows. They stay adapter-only: they route into the existing `/paul-*` wrapper layer, which in turn routes to canonical `/skill:paul-*` entries. They do not create new workflow semantics or Pi-owned lifecycle truth.
## Guided Workflow UX

The extension adds a bounded guided workflow layer for canonical PALS lifecycle moments already emitted by shared workflows. It inspects recent assistant output plus `.paul/STATE.md` for stable markers such as `Would you like to see the plan?`, `Continue to APPLY`, `Continue to UNIFY`, `CHECKPOINT:`, and `▶ NEXT:`.

When one of those moments appears, Pi may use lightweight native surfaces such as `notify`, `confirm`, or `select` to help the user respond. If the user explicitly continues, the extension routes the exact canonical reply back through normal user-message flow via `pi.sendUserMessage(...)` (`1`, `approved`, `yes`, selected option id, etc.).

This layer is additive only: it never auto-continues a workflow, never skips human verification or human-action checkpoints, and never stores a Pi-owned workflow state. Shared `.paul/*` artifacts and shared markdown workflows remain authoritative.

## Artifact-Slice Context Loading

The extension may add an `Artifact slices` block to the bounded PALS context payload, but only after an explicit `/paul-*` or `/skill:paul-*` activation signal. Slices are orientation aids for the active conversation; they do not approve work, execute tasks, mark validation, or update lifecycle state.

Implemented slice inventory:

| Slice | Source authority | Orientation use |
|-------|------------------|-----------------|
| `current-lifecycle-state` | `.paul/STATE.md` | Shows current milestone, phase, plan, loop marks, and next action after explicit activation. |
| `active-roadmap-phase` | `.paul/ROADMAP.md` | Shows current milestone/phase routing without expanding completed-history archives. |
| `approved-plan-task-packet` | `.paul/phases/**/{plan}-PLAN.md` from `.paul/STATE.md` routing | Shows approved task names, files, verification commands, acceptance criteria, and boundaries for APPLY orientation. |

Each emitted slice is activation-gated, source-cited, freshness-marked, bounded, read-only, disposable, and labeled `Derived aid only`. The visible schema exposes `Slice:`, `Source:`, `Freshness:`, `Bounds:`, `Content:`, `Fallback:`, and `Authority:` markers so the payload is easy to audit without making Pi lifecycle state.

A full authoritative read remains required before edits, approved PLAN execution, lifecycle writes, stale facts, ambiguous facts, contested facts, decisions, GitHub Flow gates, validation pass/fail, module completion, APPLY completion, or UNIFY completion. If slice content conflicts with a full read or command output, the full read or command output wins.

This layer introduces no hidden Pi state, telemetry, persistence, cache, report, or Pi-owned lifecycle/module/validation ledger. Shared `.paul/*` artifacts, shared markdown workflows, installed `modules.yaml`, explicit user replies, GitHub Flow command evidence, and validation command output remain authoritative.

## Live Module Visibility

The always-visible Pi status/widget now includes a bounded recent module activity summary when a trustworthy signal is present. That visibility is dispatch-derived from recent shared workflow/reporting output plus shared artifacts — especially canonical markers such as `[dispatch] pre-plan: ...`, `[dispatch] post-apply: ...`, and `Module Execution Reports`.

This surface is informative, adapter-only, and non-authoritative. It does not create Pi-owned module state, does not use `appendEntry`, and clears naturally when recent shared workflow output no longer provides a trustworthy module activity signal.

## CARL Session Boundary Manager

CARL in Pi manages autonomous session boundaries — it detects phase completion and creates fresh sessions when context pressure exceeds configurable thresholds. This is distinct from Claude Code CARL, which handles context rule injection via `UserPromptSubmit` hooks. The two serve different roles on different platforms (the "two-CARL model").

### How It Works

1. **Command stashing**: Every `/paul-*` command handler stashes the `ExtensionCommandContext` so CARL can later call `newSession()` to create a fresh session.
2. **Phase detection**: At `agent_end`, CARL extracts the loop signature (✓/○ marks) from `.paul/STATE.md` and compares it against the previous signature. A change to "✓✓✓" means the PLAN-APPLY-UNIFY loop just completed.
3. **Decision model**: On loop completion, CARL computes both token usage and context ratio (`tokens / contextWindow`). It compares usage against `continue_threshold_tokens` when configured, otherwise against `continue_threshold`. If the threshold is reached (or strategy is `always-fresh`), it creates a new session.
4. **Safety valve**: At `turn_end`, CARL monitors context pressure. It compares usage against `safety_ceiling_tokens` when configured, otherwise against `safety_ceiling`. If the threshold is reached, it sets a `pauseAtNextBoundary` flag that triggers a session break at the next `agent_end`.
5. **Bootstrap & auto-resume**: Fresh sessions receive a compact state summary and CARL automatically runs `/skill:paul-resume` to continue work.

### Strategies

| Strategy | Behavior |
|----------|----------|
| `phase-boundary` (default) | Creates fresh session at phase completion only when usage reaches `continue_threshold_tokens` or, if unset, context ratio ≥ `continue_threshold` |
| `always-fresh` | Creates fresh session at every phase completion regardless of context pressure |
| `manual` | Disables CARL entirely; user manages session boundaries |

### Threshold Defaults

| Setting | Default | Purpose |
|---------|---------|----------|
| `continue_threshold` | 0.4 (40%) | Ratio-based phase boundary fallback when `continue_threshold_tokens` is unset |
| `continue_threshold_tokens` | unset | Optional absolute token threshold for phase-boundary session rollover |
| `safety_ceiling` | 0.8 (80%) | Ratio-based safety fallback when `safety_ceiling_tokens` is unset |
| `safety_ceiling_tokens` | unset | Optional absolute token threshold for next-boundary safety rollover |

These defaults were validated empirically in Phase 76 (API validation). They can be overridden per-project in `pals.json` → `modules.carl`.

### Configuration

```json
{
  "modules": {
    "carl": {
      "enabled": true,
      "session_strategy": "phase-boundary",
      "continue_threshold": 0.4,
      "continue_threshold_tokens": 60000,
      "safety_ceiling": 0.8,
      "safety_ceiling_tokens": 120000
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
- Project-shipped Pi agents installed at `~/.pi/agent/agents/` when bounded delegated APPLY is enabled
- Enabled module overlays installed into the same tree with `modules.yaml` describing which lifecycle hook semantics are available

## Installation Boundaries

`install.sh` deploys PALS artifacts to three distinct Pi locations:
| Artifact | Install Target | Purpose |
|----------|---------------|---------|
| Kernel files (`workflows/`, `references/`, `templates/`, `rules/`) | `~/.pi/agent/skills/pals/` | Shared markdown workflows referenced by skills and the extension |
| Skill entry points (11 `SKILL.md` files) | `~/.pi/agent/skills/pals/{skill-name}/SKILL.md` | Pi skill invocation layer for `/skill:paul-*`; installer rewrites portable `../...` references to absolute install-root paths |
| Pi extension | `~/.pi/agent/extensions/pals-hooks.ts` | Command registration, lifecycle hooks, guided workflow UX |
| Project-shipped agents | `~/.pi/agent/agents/{agent-name}.md` | Helper agents such as `pals-implementer` for parent-authoritative, task-bounded delegation |
| Module registry | `~/.pi/agent/skills/pals/modules.yaml` | Enabled PALS module overlays (TODD, WALT, etc.) |
These are distinct install targets. Skills and kernel files live under `~/.pi/agent/skills/pals/`, the extension lives under `~/.pi/agent/extensions/`, and project-shipped agents live under `~/.pi/agent/agents/`. Removing one surface does not transfer lifecycle ownership to Pi or remove the others; `uninstall.sh` handles the full cleanup of all targets.

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
