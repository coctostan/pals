# Phase 155 Design — Prompt and Module Strategy

## Intent

Define how a future PALS-native implementer should be assembled for `@tintinweb/pi-subagents` using a repo-local `.pi/agents/*.md` file plus parent dispatch through `Agent()`.

This document answers five design questions:
- what belongs in the agent file
- what belongs in runtime `Agent()` parameters
- what context is safe to inherit vs must be assembled explicitly
- how module semantics reach the delegated task
- how tooling, model resolution, and extension loading should work without making generic runtime behavior authoritative

---

## Prompt Assembly

The future implementer should use a **hybrid prompt assembly model**:
- **small inherited context is acceptable**, but not relied on as the main carrier of execution semantics
- **explicit parent-assembled task context is required** for determinism
- **workflow and module authority stay outside the agent file** and are summarized into the dispatch prompt as needed

This follows the current Pi extension posture:
- `before_agent_start` is the primary bounded injection point
- the injected payload is intentionally small (`phase`, `loop`, `next action`, authority reminder)
- Pi does not currently inject a full APPLY contract or standalone TODD/WALT overlays

So the implementer must not depend on ambient magic. The parent must assemble the task packet deliberately.

---

## Context Sources

The parent should build the implementer prompt from explicit sources, in priority order.

### Required context sources
1. `STATE.md`
   - current phase and loop position
   - authority reminder
   - next action

2. current `PLAN.md`
   - objective
   - acceptance criteria relevant to the task
   - exact task instructions
   - boundaries / do-not-change scope
   - verify command for the delegated task

3. selected task-local project files
   - files named in the task's `<files>` list
   - immediate supporting files needed to complete the task
   - prior audit/design artifacts if the task is design-heavy

4. module context from the parent
   - pre-apply baseline signals
   - task-specific module rules the subagent must respect
   - parent-owned warnings or constraints

5. parent delegation contract
   - what the subagent may change
   - what it must report back
   - when it must stop and return control

### Optional context sources
- bounded inherited conversation context (`inherit_context`) when it shortens repetition and remains low-risk
- small parent-authored progress notes for a retried task
- selected prior task outputs if a later task depends on them

### Context that should stay out of the subagent by default
- full conversation history
- full workflow documents when a task packet summary is enough
- unrelated `.paul/*` artifacts
- broad project memory not needed for the current task
- parent-only merge-gate or UNIFY routing logic

---

## Agent File Contract

The recommended repo-owned custom agent is a dedicated file such as:
- `.pi/agents/pals-implementer.md`

It should represent the stable identity of the delegated execution role, not the full workflow state.

### Recommended agent identity
- name: `pals-implementer`
- purpose: bounded implementation worker for parent-controlled PALS APPLY
- scope: implementation and task-local verification only

### Frontmatter-owned defaults
The agent file frontmatter should own defaults that are stable across tasks:
- `name`
- a concise description of the role
- a conservative default model, if the project chooses to pin one
- default tool list
- default thinking level if needed
- no lifecycle-specific hardcoding tied to one phase or one plan

### Body/system-prompt responsibilities
The agent body should define stable behavior:
- treat the parent prompt as authoritative for task scope
- stay inside repo boundaries and declared file scope
- prefer explicit reporting over hidden assumptions
- stop on ambiguity rather than inventing lifecycle behavior
- report files changed, commands run, verification attempted, and unresolved concerns
- never treat itself as the owner of `.paul/*` lifecycle state

### What should **not** be hard-coded in the agent file
- current phase number
- current task text
- specific plan paths
- transient module states or baselines
- one-off model overrides for a single run
- whether the parent wants `inherit_context`
- exact list of files for the current task

Those belong in runtime dispatch parameters.

---

## Runtime `Agent()` Dispatch Contract

The parent should pass task-specific control at dispatch time.

Recommended runtime-owned parameters:
- `prompt`: the assembled task packet
- `description`: task-specific label such as `Apply task 2: module strategy`
- `subagent_type`: `pals-implementer`
- `model`: optional resolved override
- `thinking`: optional per-task override
- `run_in_background`: `false` for APPLY task delegation
- `inherit_context`: default `false`, enabled only when explicitly helpful
- `isolation`: optional, but should be decided by parent policy rather than embedded in the agent file

This mirrors the mature REV pattern:
- repo-controlled prompt assembly
- explicit `Agent()` dispatch
- optional model override from project config
- graceful degradation if the tool path is unavailable

---

## Module Participation Model

The implementer should use a **parent-orchestrated hybrid module model**.

### Parent-only modules or responsibilities
These remain parent-owned because they define lifecycle enforcement or durable reporting.

- **WALT enforcement**
  - quality gate comparison belongs in the parent
  - parent owns the final pass/block decision

- **DEAN enforcement**
  - dependency audit baseline and comparison belong in the parent
  - parent decides whether new dependency risk blocks progress

- **SUMMARY / STATE / module reports**
  - durable artifact updates remain parent-owned

- **checkpoint handling**
  - checkpoints are workflow events, not implementation details

### Subagent-visible but parent-orchestrated
These may be summarized into the task packet so the implementer can act with better discipline.

- **TODD guidance**
  - if tests must be written first, the parent should say so explicitly in the delegated task
  - the subagent may run task-local tests, but parent still owns post-task and post-apply gate enforcement

- **WALT expectations**
  - the parent may tell the subagent which checks it should try before returning
  - this is advisory or preparatory, not the final gate

- **DEAN risk awareness**
  - the parent may tell the subagent to avoid dependency changes unless required
  - actual audit comparison still belongs in the parent

- **IRIS / DOCS / SKIP / RUBY**
  - these remain primarily parent lifecycle modules
  - the parent may pass selected concerns into the task packet when materially useful

### Explicit anti-pattern to avoid
Do not assume that loading the custom agent file means TODD/WALT/DEAN are now automatically active inside the subagent. The audit evidence does not support that assumption.

---

## Tooling Contract

The delegated implementer should have a bounded but real coding toolset.

### Tooling Contract
Recommended tools:
- `read`
- `grep`
- `edit`
- `write`
- `bash`
- optionally `lsp` when the task materially benefits from symbol-aware navigation

### Tool rules
- tools are used only for repo work allowed by the parent task packet
- no editing of installed runtime files under `~/.pi/` or other out-of-repo paths
- no self-directed lifecycle writes to `.paul/STATE.md` unless the parent explicitly delegates a non-authoritative draft artifact task
- no assumption that unrestricted tool access implies workflow authority

### Verification boundary
The subagent may run:
- task-local tests
- lint/typecheck commands relevant to the task
- document validation commands

But the parent remains responsible for:
- running or validating the task's official `<verify>` step
- module enforcement dispatch
- final task completion status

---

## Model Resolution

Model resolution should be layered and parent-controlled.

### Recommended order
1. explicit per-dispatch override from the parent APPLY logic
2. project config for the implementer path (future `pals.json` field if introduced)
3. agent frontmatter default in `.pi/agents/pals-implementer.md`
4. runtime default if nothing else is set

This matches the REV precedent better than embedding policy only in the runtime-global agent layer.

### Why this order
- preserves repo control
- keeps one-off experiments cheap
- avoids making the agent file the only control plane
- avoids overloading unrelated `modules.rev.*` configuration for implementation routing

---

## Extension Loading

### Extension Loading
The default design should treat extension loading for the implementer as **optional and intentionally minimal**.

Reasoning:
- the Phase 154 audit did not prove that active extension loading reproduces APPLY semantics inside subagents
- current Pi bounded injection is parent-session oriented, not a full implementer overlay
- lifecycle semantics are already more defensible in parent orchestration than in hidden subagent extension behavior

Recommended posture:
- do **not** require a special implementer extension as the first implementation step
- prefer parent-authored prompt assembly and parent-owned enforcement
- allow future extension loading only if Phase 157 validation shows a concrete benefit without shifting authority away from `.paul/*`

In short: prompt/workflow first, extension magic later if justified.

---

## Prompt Packet Shape

A delegated task packet should be short, structured, and explicit.

Recommended sections:
1. task identity
2. lifecycle reminder (`.paul/*` authoritative; parent owns state and verification)
3. objective for this task only
4. allowed files / forbidden files
5. relevant context excerpts
6. task-local module expectations
7. task-local verification to attempt before returning
8. required result-report format
9. stop conditions / when to hand back control

This is enough for deterministic execution without copying entire workflow files into the subagent.

---

## Failure and Return Strategy

The subagent should be instructed to return early when:
- a checkpoint would be required
- scope is unclear
- required files are missing
- the task would cross protected boundaries
- verification fails and the correct next step depends on workflow policy
- the best next action is fallback to inline APPLY

This keeps the parent in charge of lifecycle decisions and avoids hidden divergence.

---

## Concrete Recommendation

The future implementer should use:
- a dedicated repo-local `.pi/agents/pals-implementer.md`
- parent-assembled task packets passed through `Agent()`
- default `inherit_context: false`
- parent-owned module enforcement and state/reporting
- optional task-local verification inside the subagent
- layered model resolution controlled by the parent
- no required implementer-specific extension loading in the first implementation

That is the narrowest prompt/module strategy that fits the current Pi extension model and preserves PALS authority.
