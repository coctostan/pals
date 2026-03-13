# Module Builder's Guide

How to create a new PALS module from scratch. This guide walks through the practical steps — for the formal specification, see [MODULE-SPEC.md](MODULE-SPEC.md).

---

## What Is a Module?

A module is a named pal that extends the PALS kernel through lifecycle hooks. Each module is self-contained: it declares a manifest (`module.yaml`), provides reference files, and optionally registers for hooks at specific points in the plan-apply-unify loop.

When a module is not installed, the kernel skips its hook points with zero overhead. No errors, no warnings.

---

## Prerequisites

Before building a module, you need:

- A working PALS installation (`~/.pals/` exists)
- Understanding of the plan-apply-unify loop (see [ARCHITECTURE.md](ARCHITECTURE.md))
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

These get installed to `~/.pals/references/` by the installer.

**Tip:** Keep references focused. One file per concern. The kernel loads only the refs declared per hook, not all module refs.

### 4. Register Lifecycle Hooks

Hooks are the integration point between your module and the kernel. Register only the hooks you need.

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
      This text guides the kernel on what to do when dispatching.
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
- **priority:** Lower numbers run first. Use 50-99 for enforcement, 100-199 for standard, 200-299 for advisory, 300+ for user-defined.
- **refs:** Only the files needed for *this specific hook*. Not all module refs.
- **description:** Must be actionable — the kernel reads this to know what to do.

**Return contract:** Your hook should return one of:

```yaml
# Let the kernel proceed
action: continue
context_inject:
  your_key: value          # optional data for downstream hooks

# Stop execution (blocking hooks only)
action: block
reason: "Why execution should stop"
```

### 5. Add a Kernel Command (Optional)

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

The installer copies command files to `~/.claude/commands/paul/`.

**Note:** Most modules don't need their own command. Hooks handle integration automatically.

### 6. Wire Into the Installer

The installer (`install.sh` → `drivers/claude-code/install.sh`) handles module installation automatically based on your manifest:

- **References** → copied to `~/.pals/references/`
- **Workflows** → copied to `~/.pals/workflows/`
- **Config files** → copied to `~/.pals/{module-name}/` (preserves existing user config)
- **Commands** → copied to `~/.claude/commands/`
- **Platform hooks** → symlinked to `~/.claude/hooks/` and registered in `settings.json`

**No changes to `install.sh` are needed** unless your module requires non-standard installation logic. The Python module installer reads `module.yaml` and handles everything.

### 7. Add to pals.json Schema

Add your module to the default `pals.json` so users can enable/disable it:

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

The installer checks `pals.json` and skips modules with `"enabled": false`.

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
1. User runs `/paul:plan` → kernel dispatches `pre-plan` hooks
2. DEAN's `pre-plan` fires at priority 50 → loads `vulnerability-audit.md` → injects `dep_warnings` into plan context
3. User runs `/paul:apply` → tasks execute → kernel dispatches `post-apply`
4. DEAN's `post-apply` fires at priority 150 → re-audits → blocks if new critical vulnerabilities introduced

---

## Pre-Ship Checklist

Before considering your module complete:

- [ ] `module.yaml` parses correctly (all required fields present)
- [ ] `name` field matches directory name
- [ ] Every hook has `priority`, `description`, and `refs`
- [ ] Reference files are each under 150 lines
- [ ] Module is listed in `pals.json` with `enabled: true`
- [ ] `./install.sh` completes without errors
- [ ] Module appears in `~/.pals/modules.yaml` after install
- [ ] Hook refs are installed to `~/.pals/references/`
- [ ] If commands exist: they appear in `~/.claude/commands/`
- [ ] Test: disable module in `pals.json`, reinstall — kernel runs without it
