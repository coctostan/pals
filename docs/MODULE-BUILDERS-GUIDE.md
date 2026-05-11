# Module Builder's Guide

How to create a new PALS module from scratch. This guide walks through the practical steps — for the formal specification, see [MODULE-SPEC.md](MODULE-SPEC.md).

---

## What Is a Module?

A module is a named pal that extends PALS through lifecycle hooks. Each module is self-contained: it declares a source manifest (`modules/{name}/module.yaml`), provides reference files, and optionally registers for hooks in the PLAN/APPLY/UNIFY loop.

Runtime dispatch uses installed `modules.yaml`, not source manifests directly. When a module is absent from the installed registry, its hook points are no-ops: no errors, no warnings, no workflow-local checks.

---

## Prerequisites

Before building a module, you need:

- A PALS source checkout with `modules/`, `kernel/`, and installer/adapters available
- Understanding of the PLAN/APPLY/UNIFY loop (see [ARCHITECTURE.md](ARCHITECTURE.md))
- A clear purpose for your module — what capability does it add?

---

## Step-by-Step Walkthrough

### 1. Create the Module Directory

```
modules/
└── yourmod/
    ├── module.yaml          # manifest (required)
    └── references/          # reference files (if needed)
        └── yourmod-ref.md
```

Every module lives under `modules/{name}/` in the PALS repo. The directory name must match the `name` field in your manifest.

### 2. Write the Module Manifest

Create `modules/yourmod/module.yaml`:

```yaml
name: yourmod
display_name: YOURMOD
description: >
  One paragraph explaining what your module does and why it exists.
version: 1.0.0

dependencies:
  kernel: ">=0.4.0"
  modules: []              # list other modules if you depend on them

hooks: {}                  # see Step 4 for hook registration

files:
  references: []           # see Step 3
  workflows: []
  templates: []
  config: []
  rules: []

commands: []               # see Step 5

platform: {}
```

**Required fields:** `name`, `display_name`, `description`, `version`, `dependencies.kernel`.

### 3. Create Reference Files

Reference files contain the knowledge your module provides at hook dispatch time. Each file should be under 150 lines (hard cap from Phase 28 context optimization).

```
modules/yourmod/references/
├── yourmod-principles.md     # core concepts
└── yourmod-detection.md      # detection/analysis logic
```

List them in your manifest:

```yaml
files:
  references:
    - references/yourmod-principles.md
    - references/yourmod-detection.md
```

The installer makes these refs available through the runtime's logical `references/...` paths.

**Tip:** Keep references focused. One file per concern. Dispatch loads only the refs declared for the current hook, not all module refs.

### 4. Register Lifecycle Hooks

Hooks are the integration point between your module and PLAN/APPLY/UNIFY dispatch. Register only the hooks you need.

**Available hook points:**

| Hook | When It Fires | Can Block? |
|------|--------------|------------|
| `pre-plan` | Before plan creation | Yes |
| `post-plan` | After plan written, before approval | No |
| `pre-apply` | Before task execution starts | Yes |
| `post-task` | After each task completes | Yes |
| `post-apply` | After all tasks complete | Yes |
| `pre-unify` | Before reconciliation | No |
| `post-unify` | After loop closes | No |

**Register hooks in your manifest with per-hook refs:**

```yaml
hooks:
  pre-plan:
    priority: 150
    description: >
      Actionable instruction for what your module does at this hook point.
      This text guides lifecycle dispatch on what to do for this hook.
    refs:
      - references/yourmod-detection.md
  post-apply:
    priority: 150
    description: >
      Re-run analysis after apply; compare against pre-plan baseline.
    refs:
      - references/yourmod-detection.md
```

**Key details:**
- **priority:** Lower numbers run first. Use 50-99 for early enforcement, 100-199 for standard hooks, 200-299 for advisory hooks, 300+ for user-defined modules.
- **refs:** Only the files needed for *this specific hook*. Not all module refs.
- **description:** Must be actionable — dispatch reads this to know what to do.

**Logical return contract:** Hook instructions should produce one of:

```yaml
# Let the workflow proceed
action: continue
context_inject:
  your_key: value          # optional data for downstream hooks

# Request a block from an enforcement hook
action: block
reason: "Why execution should stop"
```

Advisory hooks cannot block. Enforcement hooks may produce block evidence, but the workflow call site owns fix/override/stop handling.

### 5. Add a PAUL Command (Optional)

If your module needs a user-facing slash command (like `/paul:deps` or `/paul:review`):

1. Create the command file in your module:
   ```
   modules/yourmod/commands/paul/yourmod.md
   ```

2. The command file is a standard PALS command markdown file with `<objective>`, `<process>`, etc.

3. Register it in your manifest:
   ```yaml
   commands:
     - name: paul:yourmod
       file: commands/paul/yourmod.md
       description: What this command does
   ```

Adapters install command files in the appropriate harness-specific command location.

**Note:** Most modules don't need their own command. Hooks handle integration automatically.

### 6. Wire Into the Installer

The installer reads source `module.yaml` files and makes declared assets available to the installed runtime:

- **References** → logical `references/...` paths
- **Workflows** → logical `workflows/...` paths
- **Config files** → adapter-managed runtime config locations
- **Commands** → harness-specific command locations
- **Platform hooks** → harness-specific hook/settings integrations
- **Hook metadata** → installed `modules.yaml`, including hook priority, description, and refs

**No changes to `install.sh` are needed** unless your module requires non-standard installation logic. The module installer should derive runtime registry metadata from `module.yaml`.

### 7. Add to pals.json Defaults

Add your module to the default `pals.json` so project configuration records the user's module preference:

```json
{
  "modules": {
    "yourmod": {
      "enabled": true,
      "description": "What your module does"
    }
  }
}
```

`pals.json` is project configuration metadata. Runtime dispatch reads installed `modules.yaml`; do not rely on `pals.json` as runtime dispatch authority.

---

## Worked Example: DEAN

DEAN (Dependency Evaluation & Audit Notifier) is the simplest real module — 2 hooks, 3 reference files, no commands of its own.

**Directory structure:**
```
modules/dean/
├── module.yaml
└── references/
    ├── dependency-principles.md
    ├── dependency-detection.md
    └── vulnerability-audit.md
```

**Manifest (`module.yaml`):**
```yaml
name: dean
display_name: DEAN
description: >
  Dependency Evaluation & Audit Notifier. Detects package managers, audits
  for vulnerabilities and outdated packages, and provides dependency health
  visibility via /paul:deps.
version: 1.0.0

dependencies:
  kernel: ">=0.4.0"
  modules: []

hooks:
  pre-plan:
    priority: 50
    description: >
      Run dependency audit for detected package managers;
      inject dep_warnings with severity counts into plan context
    refs:
      - references/vulnerability-audit.md
  post-apply:
    priority: 150
    description: >
      Re-run dependency audit; compare against pre-plan baseline;
      block if new critical/high vulnerabilities introduced
    refs:
      - references/vulnerability-audit.md

files:
  references:
    - references/dependency-principles.md
    - references/dependency-detection.md
    - references/vulnerability-audit.md
  workflows: []
  templates: []
  config: []
  rules: []

commands: []
platform: {}
```

**What happens at runtime:**
1. User runs `/paul:plan` → lifecycle dispatch runs `pre-plan` hooks from installed `modules.yaml`.
2. DEAN's `pre-plan` fires at priority 50 → loads `vulnerability-audit.md` → injects `dep_warnings` into plan context.
3. User runs `/paul:apply` → tasks execute → lifecycle dispatch runs the approved post-apply cohort.
4. DEAN's `post-apply` fires at priority 150 → re-audits → may return block evidence if new critical vulnerabilities were introduced; the workflow call site handles fix/override/stop.

---

## Pre-Ship Checklist

Before considering your module complete:

- [ ] `module.yaml` parses correctly and includes all required fields
- [ ] `name` field matches directory name
- [ ] Every hook has `priority`, `description`, and hook-local `refs`
- [ ] Reference files are focused and bounded
- [ ] Module is listed in default `pals.json` metadata when appropriate
- [ ] `./install.sh` completes without errors
- [ ] Installed `modules.yaml` includes the module and expected hook metadata
- [ ] Hook refs are available through logical `references/...` paths
- [ ] If commands exist: they appear in the adapter's command location
- [ ] Runtime check: remove the module from installed `modules.yaml` generation and confirm workflows no-op cleanly
