# PALS Reference Resolution Convention

How workflows reference files portably across harnesses.

**Related:** [HARNESS-PORTABILITY.md](HARNESS-PORTABILITY.md), [ADAPTER-CONTRACT.md](ADAPTER-CONTRACT.md)

---

## Problem

PALS workflows previously used Claude Code's `@path` syntax (e.g., `@~/.pals/references/plan-format.md`) and hardcoded install paths. Neither is portable to other harnesses.

---

## Convention

### Two reference categories

**Project artifacts** — paths relative to project root:
```
.paul/STATE.md
.paul/ROADMAP.md
.paul/phases/10-auth/10-01-PLAN.md
```
Already portable. Every harness reads from the same project directory.

**Kernel resources** — logical paths using `kernel/` prefix:
```
kernel/references/plan-format.md
kernel/workflows/apply-phase.md
kernel/templates/PLAN.md
kernel/modules.yaml
```
Adapters resolve `kernel/` to their install location (e.g., `~/.pals/` for Claude Code, `~/.pi/agent/skills/pals/` for pi).

**Module resources** — logical paths using `modules/` prefix:
```
modules/todd/references/tdd-detection.md
modules/walt/references/quality-baseline.md
```
Adapters resolve `modules/` to their module install location.

### In workflow files

References appear in `<required_reading>` and `<references>` sections as plain paths — no `@` prefix:
```xml
<required_reading>
.paul/STATE.md
.paul/ROADMAP.md
.paul/phases/{phase}/{plan}-PLAN.md
</required_reading>

<references>
kernel/references/plan-format.md
kernel/templates/PLAN.md
</references>
```

The adapter's workflow loader reads these files into context before execution begins.

### In prose instructions

Workflows use generic verbs instead of harness-specific tool names:

| Action | Write as | Not |
|--------|----------|-----|
| Read a file | "Read STATE.md" | "Use the Read tool on STATE.md" |
| Search files | "Search for pattern" | "Use Grep to find..." |
| Execute command | "Run: `command`" | "Use Bash to run..." |
| Create file | "Create file at path" | "Use Write tool to..." |
| Edit file | "Edit file at path" | "Use Edit tool to..." |

---

## Adapter Responsibilities

| Concern | Claude Code | Pi | Generic |
|---------|------------|-----|---------|
| Resolve `kernel/` | `~/.pals/` | `~/.pi/agent/skills/pals/` | `$PALS_DIR/` |
| Resolve `modules/` | `~/.pals/modules/` | `~/.pi/agent/skills/pals/modules/` | `$PALS_DIR/modules/` |
| Resolve `.paul/` | Project root | Project root | Project root |
| Load references | Reads files into context | Reads files into context | Reads files into context |
| Invoke workflow | Slash command | Skill trigger | API call |

---

## Migration Reference

| Old (Claude Code specific) | New (portable) |
|---------------------------|----------------|
| `@~/.pals/references/plan-format.md` | `kernel/references/plan-format.md` |
| `@~/.pals/workflows/apply-phase.md` | `kernel/workflows/apply-phase.md` |
| `@~/.pals/templates/PLAN.md` | `kernel/templates/PLAN.md` |
| `@~/.pals/modules.yaml` | `kernel/modules.yaml` |
| `@.paul/STATE.md` | `.paul/STATE.md` |
| `@.paul/ROADMAP.md` | `.paul/ROADMAP.md` |
| `@path/to/source.ts` | `path/to/source.ts` |

The `@` prefix and `~/.pals/` install path are adapter-specific details that do not appear in portable workflow definitions.

---

## Backward Compatibility

Claude Code users experience zero change. The Claude Code adapter:
1. Reads `<required_reading>` and `<references>` sections
2. Resolves `kernel/` → `~/.pals/`
3. Resolves `modules/` → `~/.pals/modules/`
4. Loads files into context using its native file reading

The installed symlinks at `~/.pals/` continue to work. Only the workflow file contents change — the adapter handles resolution transparently.

---

*Created: Phase 46 — Harness-Agnostic Skills*
