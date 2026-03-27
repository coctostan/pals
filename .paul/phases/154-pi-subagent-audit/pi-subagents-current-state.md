# Phase 154 Audit: `pi-subagents` Current State

## Scope

This document inventories the current PALS ↔ `pi-subagents` integration points, the agent definitions that are inspectable from the current Pi runtime, and the project config that influences subagent behavior today.

## Integration Points

| Area | Current behavior | Evidence |
|---|---|---|
| Pi command/hook layer | Pi installs `drivers/pi/extensions/pals-hooks.ts` into `~/.pi/agent/extensions/pals-hooks.ts`. That extension registers `/paul-*` wrapper commands, lifecycle hooks, guided workflow UX, and bounded PALS context injection. It does **not** define an `Agent()` call itself. | `drivers/pi/install.sh`, `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/skill-map.md`, `drivers/pi/extensions/README.md` |
| Canonical skill routing | The Pi extension routes wrapper commands like `/paul-review` to canonical `/skill:paul-review`, keeping shared skills/workflows authoritative. | `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/skill-map.md` |
| REV on-demand review | `drivers/pi/skills/paul-review/SKILL.md` is the main repo-controlled path that explicitly dispatches a `code-reviewer` subagent through the `Agent()` tool. | `drivers/pi/skills/paul-review/SKILL.md`, `modules/rev/references/review-prompt.md` |
| REV merge-gate review | `kernel/workflows/unify-phase.md` can also dispatch `code-reviewer` during merge gating when `modules.rev.pr_review = true`. | `kernel/workflows/unify-phase.md`, `pals.json` |
| Research agent routing | `kernel/workflows/research.md` instructs codebase research to use `subagent_type: Explore` and web research to use `subagent_type: general-purpose`. | `kernel/workflows/research.md` |
| Map-codebase fan-out | `kernel/workflows/map-codebase.md` instructs the workflow to spawn 5 parallel `Explore` agents with `run_in_background: true`. | `kernel/workflows/map-codebase.md` |
| Module registry / lifecycle overlays | Pi materializes enabled modules into `~/.pi/agent/skills/pals/modules.yaml`; shared PLAN/APPLY/UNIFY workflows use that registry for module dispatch. This is separate from subagent definitions. | `drivers/pi/skill-map.md`, `~/.pi/agent/skills/pals/modules.yaml` |

## Agent Definitions

### Built-in / workflow-selected agent types

| Agent type | Where it is selected | What is directly inspectable from repo/runtime evidence | Notes |
|---|---|---|---|
| `code-reviewer` | `drivers/pi/skills/paul-review/SKILL.md`, `kernel/workflows/unify-phase.md` | Call sites, prompt template, config hooks | Explicitly used by current repo-controlled REV flows |
| `Explore` | `kernel/workflows/research.md`, `kernel/workflows/map-codebase.md` | Call-site intent only | Built-in/read-only exploration role; no repo-local `.md` definition found |
| `general-purpose` | `kernel/workflows/research.md` | Call-site intent only | Used for web research path |
| `implementer` | No current repo-controlled dispatch path found | Current global agent file is inspectable | Present in runtime as a global agent file, but not wired from current repo-controlled PALS flows |
| `worker` | No current repo-controlled dispatch path found | No active global file at expected path; only historical file under `oldAgents/` | Treat current usage claims as runtime/out-of-band unless proven by a repo-controlled call site |
| `spec-reviewer` | No current repo-controlled dispatch path found | No active global file at expected path; only historical file under `oldAgents/` | Same status as `worker` |

### Current global Pi agent files

| Agent | Current file status | Tools | Model | Extensions | Notes |
|---|---|---|---|---|---|
| `implementer` | Present at `~/.pi/agent/agents/implementer.md` | `read`, `write`, `edit`, `bash` | `openai-codex/gpt-5.3-codex:high` | Empty `extensions:` block | Prompt is generic strict-TDD guidance; no explicit PALS lifecycle/module instructions |
| `code-reviewer` | Missing at expected active path `~/.pi/agent/agents/code-reviewer.md` | Unknown from active path | Unknown from active path | Unknown from active path | Historical file exists at `~/.pi/agent/agents/oldAgents/code-reviewer.md` |
| `worker` | Missing at expected active path `~/.pi/agent/agents/worker.md` | Unknown from active path | Unknown from active path | Unknown from active path | Historical file exists at `~/.pi/agent/agents/oldAgents/worker.md` |
| `spec-reviewer` | Missing at expected active path `~/.pi/agent/agents/spec-reviewer.md` | Unknown from active path | Unknown from active path | Unknown from active path | Historical file exists at `~/.pi/agent/agents/oldAgents/spec-reviewer.md` |

### Historical / out-of-band agent definitions found under `oldAgents/`

These files are useful as context, but they are **not** active-file evidence in `~/.pi/agent/agents/`.

| Agent | Historical file | Tools | Model | Extensions | Notes |
|---|---|---|---|---|---|
| `code-reviewer` | `~/.pi/agent/agents/oldAgents/code-reviewer.md` | `read`, `bash`, `find`, `grep`, `ls` | `openai-codex/gpt-5.3-codex:medium` | none declared | Read-only review agent aligned with REV intent |
| `worker` | `~/.pi/agent/agents/oldAgents/worker.md` | `read`, `write`, `edit`, `bash` | `openai-codex/gpt-5.3-codex:low` | `/Users/maxwellnewman/pi/workspace/pi-superpowers-plus/extensions/tdd-guard.ts` | Generic worker with TDD guard extension |
| `spec-reviewer` | `~/.pi/agent/agents/oldAgents/spec-reviewer.md` | `read`, `bash`, `find`, `grep`, `ls` | `openai-codex/gpt-5.2:low` | none declared | Read-only spec compliance reviewer |

## `pals.json` Config / Routing Notes

| Config surface | Current value | Effect on subagents |
|---|---|---|
| `modules.rev.enabled` | `true` | REV skill is enabled project-side |
| `modules.rev.model` | `null` | No project-level model override; REV falls back to the agent file / runtime default |
| `modules.rev.pr_review` | `false` | Merge-gate `code-reviewer` path is currently disabled by project config |
| `modules.rev.pr_review_block_on_critical` | `true` | If PR review is enabled later, Critical review findings can block merge |
| Generic `agents` block | Not present in current `pals.json` | There is no current project-level routing/config surface for `implementer`, `worker`, or `spec-reviewer` |
| `guided_workflow.auto_present.*` | Present | Affects Pi guided workflow UX, not subagent selection |

Additional note: `kernel/references/pals-json-schema.md` explicitly says runtime lifecycle dispatch reads installed `modules.yaml`, not the `pals.json` module section alone. In practice, `pals.json` currently influences REV gating/model override and Pi guided-workflow behavior, but not a generic implementer-routing layer.

## Repo-defined vs Runtime-global

| Concern | Repo-defined today | Runtime-global today |
|---|---|---|
| `/paul-*` command registration | Yes — `drivers/pi/extensions/pals-hooks.ts` | Installed copy lives in `~/.pi/agent/extensions/pals-hooks.ts` |
| Canonical PALS lifecycle skills/workflows | Yes — `drivers/pi/skills/*`, `kernel/workflows/*` | Installed under `~/.pi/agent/skills/pals/` |
| REV prompt assembly and call site | Yes | Depends on runtime availability of the `Agent` tool and the `code-reviewer` agent definition |
| `implementer` prompt/tools/model | No repo-controlled file found | Yes — current global file at `~/.pi/agent/agents/implementer.md` |
| `worker` / `spec-reviewer` active definitions | No | Not present at expected active global paths; only `oldAgents/` historical copies were found |

## Evidence

### Repo file evidence

- `drivers/pi/install.sh` copies `drivers/pi/extensions/pals-hooks.ts` into `~/.pi/agent/extensions/pals-hooks.ts`.
- `drivers/pi/extensions/pals-hooks.ts` registers `/paul-*` commands, routes them to `/skill:paul-*`, and injects only bounded PALS context.
- `drivers/pi/skill-map.md` states that the extension is separate from skills/kernel files and that modules are loaded from installed `modules.yaml`.
- `drivers/pi/skills/paul-review/SKILL.md` is the clearest current repo-controlled `code-reviewer` dispatch path.
- `kernel/workflows/unify-phase.md` contains the optional merge-gate `code-reviewer` dispatch path.
- `kernel/workflows/research.md` and `kernel/workflows/map-codebase.md` describe `Explore` / `general-purpose` subagent usage for research/discovery work.
- `modules/rev/references/review-prompt.md` defines the exact prompt assembly contract for the `code-reviewer` path.
- `pals.json` contains `modules.rev` config, but no generic `agents` block.

### Runtime filesystem evidence

- `~/.pi/agent/agents/implementer.md` exists and is inspectable.
- `~/.pi/agent/agents/code-reviewer.md` is missing.
- `~/.pi/agent/agents/worker.md` is missing.
- `~/.pi/agent/agents/spec-reviewer.md` is missing.
- Historical files exist under `~/.pi/agent/agents/oldAgents/` for `code-reviewer`, `worker`, and `spec-reviewer`.
- Installed lifecycle module registry exists at `~/.pi/agent/skills/pals/modules.yaml`.

### Working conclusion

The current deliberate PALS ↔ `pi-subagents` integration is narrow and specific:

1. Pi wrapper commands and bounded context injection come from the extension layer.
2. The only explicit repo-controlled custom subagent dispatch in current live PALS flows is `code-reviewer` for REV.
3. `implementer`, `worker`, and `spec-reviewer` are not currently wired by repo-controlled PALS workflow files.
4. The current `implementer` definition is global runtime state, not a PALS-specific implementation path.
