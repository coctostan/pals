# PALS Adapter Contract

## Purpose

This document defines what a harness adapter must do to run PALS without changing the meaning of the system.

A PALS adapter is a translation layer between:
- the **portable PALS kernel** (artifacts, workflows, modules, lifecycle rules)
- and a **specific harness** (Claude Code, pi, Codex, future systems)

Adapters may vary in UX, but they must preserve artifact semantics and lifecycle behavior.

---

## Adapter responsibilities

An adapter must provide the following capabilities.

### 1. Artifact access
The adapter must be able to:
- read project artifacts from `.paul/`
- create new artifacts
- update existing artifacts
- preserve canonical file locations and meanings

At minimum, this includes:
- `STATE.md`
- `PROJECT.md`
- `PRD.md`
- `ROADMAP.md`
- `MILESTONES.md`
- `SPECIAL-FLOWS.md`
- phase plan/summary files
- handoff files

### 2. Workflow invocation
The adapter must be able to invoke named workflows such as:
- `init-project`
- `plan-phase`
- `apply-phase`
- `unify-phase`
- `transition-phase`

How workflows are surfaced is adapter-specific.
Examples:
- slash commands
- extension commands
- skills
- menu items
- API calls

The workflow identity is portable; the command surface is not.

### 3. Module hook dispatch
The adapter must:
- load active module configuration
- discover hooks from module manifests
- dispatch hooks in priority order
- apply blocking and merge rules consistently

### 4. User interaction
The adapter must provide a way to:
- ask for freeform input
- ask for confirmation
- ask the user to choose among options
- surface blocking states and next actions

The exact UI may differ by harness.

### 5. Shell/code execution
The adapter must be able to:
- run shell commands when workflows require it
- read code and project files
- write or edit code and project files
- respect harness safety/approval mechanisms

---

## Adapter must preserve

An adapter must preserve the following invariant behaviors.

### A. Artifact semantics
Generated files do not need to be word-for-word identical across runs or harnesses, but they must preserve:
- required sections
- required frontmatter keys
- section meaning
- state meaning
- lifecycle implications
- the layered `PROJECT.md` (hot path) / `PRD.md` (deeper selective context) distinction when `PRD.md` is present

### B. Lifecycle semantics
The adapter must respect:
- valid PLAN/APPLY/UNIFY transitions
- required preconditions
- required postconditions
- phase completion behavior
- transition workflow requirements

### C. Module semantics
The adapter must preserve:
- module activation rules
- hook ordering
- hook blocking rules
- hook merge rules
- persistence expectations for important module outputs

### D. Project portability
The adapter must not require a project to be migrated into a harness-specific state format.

The same `.paul/` state should remain usable across adapters.

---

## Adapter may vary

The following are intentionally adapter-specific:
- command naming and invocation UX
- menus, dialogs, widgets, and UI layout
- model choice
- prompt phrasing
- install paths and package layout
- approval flows and permissions UI
- how continuation is offered to the user

These differences are acceptable so long as artifact and lifecycle semantics remain intact.

---

## Portable primitives

A compliant adapter should implement equivalents of these logical primitives.

### File primitives
- read file
- write file
- edit file
- list/find/search files

### Execution primitives
- execute shell command
- inspect command output

### Interaction primitives
- ask user for text
- ask user to confirm
- ask user to choose from options

### Workflow primitives
- invoke workflow by identity
- load required references/templates
- resolve current state from artifacts

### Module primitives
- load active module manifests
- dispatch hook with context
- merge hook outputs
- stop on blocking hook

These are logical capabilities; they do not prescribe a particular implementation API.

---

## Resource model

Adapters should treat the following as distinct categories:

### Portable kernel resources
- workflows
- references
- templates
- rules

### Portable module resources
- `module.yaml`
- module references
- module workflows
- module config/resources

### Project artifacts
- `.paul/*`

### Adapter-installed resources
- local package files
- adapter extension code
- harness-specific config

Portable resource identities should not depend on a specific installed location like `~/.pals` or `~/.claude`.

---

## Adapter input sources

To run PALS correctly, an adapter should consult:
- `.paul/STATE.md`
- `.paul/PROJECT.md`
- `.paul/PRD.md` (when present; selective deeper context)
- `.paul/ROADMAP.md`
- current plan/summary files
- active module configuration
- kernel workflow definitions
- module manifests and relevant resources

Adapters should avoid relying on hidden conversational context when the same information should exist in artifacts.

Adapters should treat `PROJECT.md` as the default landing brief and `PRD.md` as additive deeper context. Legacy projects may not have `PRD.md`; when present, it must remain a shared portable artifact rather than a harness-specific extension.

---

## Persistence rule

Important workflow facts must either:
- be written into artifacts, or
- be derivable from artifacts and canonical workflow/module definitions

Adapters should not rely on ephemeral in-memory state for facts that matter across sessions or across harnesses.

Examples of facts that should persist or be derivable:
- current loop position
- active phase/plan
- decisions made at checkpoints
- deviations from plan
- summary status
- important module annotations

---

## Validation expectations

A robust adapter should be testable against artifact-level validation.

At minimum, it should be possible to verify that the adapter:
- writes valid artifact structures
- preserves lifecycle consistency
- creates matching plan/summary pairs
- updates state coherently
- preserves layered project-definition semantics when `PRD.md` is present
- does not introduce harness-specific state into `.paul/`

---

## Non-goals

This contract does not require:
- identical prose across adapters
- identical command names across harnesses
- identical interaction patterns
- identical installation layout
- identical model behavior

The contract is about **artifact and process compatibility**, not identical surface behavior.

---

## Compliance summary

A harness adapter is compliant when:
- it can drive PALS workflows using the canonical kernel/module definitions
- it reads and writes the canonical `.paul/` artifacts
- it preserves lifecycle and module semantics
- it allows a project to move between harnesses without migration

That is the standard future adapters should meet.
