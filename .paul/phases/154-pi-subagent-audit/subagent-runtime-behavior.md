# Phase 154 Audit: Subagent Runtime Behavior

## Runtime Paths

### 1. REV review path (`code-reviewer`)

The current repo-controlled REV behavior is explicit and narrow:

1. `drivers/pi/skills/paul-review/SKILL.md` assembles review context from diff + changed files + optional tests + `AGENTS.md`.
2. It then dispatches `Agent()` with `subagent_type: "code-reviewer"` and `run_in_background: false`.
3. If `pals.json modules.rev.model` is set, that value becomes the model override.
4. `kernel/workflows/unify-phase.md` reuses the same subagent type for optional PR merge-gate review when `modules.rev.pr_review = true`.
5. If `pi-subagents` / the `Agent` tool is unavailable, both paths are designed to skip or degrade rather than block ordinary non-REV lifecycle execution.

**Evidence:** `drivers/pi/skills/paul-review/SKILL.md`, `modules/rev/references/review-prompt.md`, `kernel/workflows/unify-phase.md`, `pals.json`, `modules/rev/module.yaml`

### 2. `research` path (`Explore` / `general-purpose`)

`kernel/workflows/research.md` defines two agent-routing modes:

- **Codebase research** → `subagent_type: Explore`
- **Web research** → `subagent_type: general-purpose`

These are workflow-level instructions, not Pi-driver-specific code. They show that PALS already uses subagent orchestration for research/discovery work, but this is not the same as a PALS-native implementer.

**Evidence:** `kernel/workflows/research.md`

### 3. `map-codebase` path (`Explore` × 5)

`kernel/workflows/map-codebase.md` instructs the workflow to spawn 5 parallel `Explore` agents with `run_in_background: true` to analyze stack, architecture, conventions, concerns, and reference graph.

This confirms that PALS already relies on background read-only subagents for bounded analysis work.

**Evidence:** `kernel/workflows/map-codebase.md`

### 4. `implementer`, `worker`, and `spec-reviewer`

Current repo-controlled PALS runtime files do **not** show a dispatch path for `implementer`, `worker`, or `spec-reviewer`:

- Grep across `drivers/` and `kernel/` found no current call sites for `implementer`, `worker`, or `spec-reviewer`.
- `pals.json` has no generic `agents` routing block in the current project state.
- The active global runtime filesystem only exposes `~/.pi/agent/agents/implementer.md`; the expected active files for `code-reviewer`, `worker`, and `spec-reviewer` are missing.
- Historical copies for `code-reviewer`, `worker`, and `spec-reviewer` exist only under `~/.pi/agent/agents/oldAgents/`.

**Classification:** if `worker` / `implementer` behavior was observed in another session, it is currently **out-of-band runtime evidence**, not a repo-controlled PALS workflow path proven by the audited files.

**Evidence:** repo search over `drivers/` and `kernel/`, `pals.json`, `~/.pi/agent/agents/implementer.md`, `~/.pi/agent/agents/oldAgents/*`

## Runtime Behavior by Path

| Path | Trigger | Agent type | Foreground/background | Project config influence | Notes |
|---|---|---|---|---|---|
| `/paul-review` | Explicit user command | `code-reviewer` | Foreground | `modules.rev.model`, `modules.rev.enabled` | Repo-controlled and deliberate |
| UNIFY merge gate | `modules.rev.pr_review = true` | `code-reviewer` | Foreground | `modules.rev.pr_review`, `modules.rev.pr_review_block_on_critical`, `modules.rev.model` | Currently disabled in this project (`pr_review: false`) |
| `research` codebase mode | Workflow branch | `Explore` | Not explicitly shown in the current snippet, but described as a spawned research agent | No project-local agent config found | Read-only exploration |
| `research` web mode | Workflow branch | `general-purpose` | Not explicitly shown in the current snippet | No project-local agent config found | External/web research |
| `map-codebase` | Explicit workflow | `Explore` | Background (`run_in_background: true`) | No project-local agent config found | 5 parallel read-only agents |
| APPLY implementation | Current canonical behavior | Inline parent agent | N/A | Full PALS lifecycle + modules | Still the reference model today |

## Prompt Assembly Observations

### REV

REV has explicit prompt assembly:

- Diff
- Full changed files
- `AGENTS.md` if present
- Related test files if present
- `modules/rev/references/review-prompt.md` template

This is the most mature current subagent path in the repo.

### Research / map-codebase

Research and map-codebase prompts are workflow-authored natural-language task briefs. They describe what to inspect and how to report, but they do not define a PALS module/lifecycle wrapper around the subagent.

### `implementer`

The current active global `implementer` prompt is generic:

- strict TDD
- small/scoped changes
- narrow tests first
- commit when tests pass
- report changes/tests/files/concerns

It does **not** mention:

- `.paul/*` artifacts as authority
- PLAN/APPLY/UNIFY loop semantics
- module dispatch from installed `modules.yaml`
- TODD/WALT/DEAN behavior
- checkpoints, deviation handling, or STATE/SUMMARY updates

**Evidence:** `~/.pi/agent/agents/implementer.md`

## Module Reach

| Reach category | Current state | Evidence |
|---|---|---|
| Parent workflow module dispatch | **Present and authoritative.** Pi skill-map says enabled modules are materialized into installed `modules.yaml`, and shared PLAN/APPLY/UNIFY workflows use that registry for dispatch. | `drivers/pi/skill-map.md`, `~/.pi/agent/skills/pals/modules.yaml`, apply/unify workflow docs |
| Subagent prompt inheritance | **Bounded / minimal.** `drivers/pi/extensions/pals-hooks.ts` injects a compact PALS context payload with phase, loop, next action, and an authority reminder. It is not a full APPLY/module overlay. | `drivers/pi/extensions/pals-hooks.ts` |
| Subagent extension loading | **Mostly unknown or absent in active evidence.** Current `implementer.md` has an empty `extensions:` block. Historical `oldAgents/worker.md` had a `tdd-guard.ts` extension, but that is not active-file evidence. | `~/.pi/agent/agents/implementer.md`, `~/.pi/agent/agents/oldAgents/worker.md` |
| TODD/WALT/DEAN reach inside subagents | **Not proven today.** Repo docs say modules load from installed `modules.yaml` and lifecycle workflows; the extension explicitly says Pi does not expose standalone TODD/WALT skills. No audited subagent prompt or active agent file shows module overlays being injected into `code-reviewer` or `implementer`. | `drivers/pi/skill-map.md`, `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/skills/paul-review/SKILL.md`, `~/.pi/agent/agents/implementer.md` |
| Absent / unknown behavior | **Important gap.** There is no current repo-controlled evidence that `implementer`, `worker`, or `spec-reviewer` inherit the same enforcement/reporting semantics as inline APPLY. | repo search over `drivers/` and `kernel/`, `pals.json`, runtime agent files |

## What the Pi extension actually contributes

The Pi extension contributes orchestration support around the parent agent session:

- `/paul-*` wrapper command registration
- bounded workflow context injection via `before_agent_start`
- lifecycle status/widget updates
- guided-workflow prompt detection and canonical follow-up replies
- CARL session-boundary behavior

It does **not** itself define a PALS-native implementer or inject full module overlays into a custom implementer path.

**Evidence:** `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/skill-map.md`

## Out-of-band Runtime Evidence

The user reported seeing `worker` / `implementer` in another session. Based on the audited files, the correct interpretation today is:

- treat the observation as real runtime evidence that Pi can run those agent types,
- but do **not** treat it as proof of a repo-controlled PALS implementation path,
- and do **not** assume module reach or APPLY-equivalent semantics from that observation alone.

## Conclusion

1. The current mature subagent path is REV via `code-reviewer`.
2. Research/discovery also uses subagents (`Explore`, `general-purpose`), but in read-only analysis roles.
3. There is no current repo-controlled PALS dispatch path for `implementer`, `worker`, or `spec-reviewer`.
4. Module enforcement/reporting still lives primarily in the parent lifecycle workflows.
5. Any future PALS-native implementer must be designed explicitly; it is not already present in current audited runtime behavior.
