# Pi Skill Map

Maps the Pi adapter's command, skill, and workflow surfaces for PALS.

## Command → Skill → Workflow Mapping

In Pi:
- `/paul-*` is the user-facing command layer for discovery and routing
- `/skill:paul-*` is the canonical skill invocation layer
- shared workflow markdown remains the implementation truth behind both surfaces
- the extension also exposes a bounded shortcut layer for high-frequency flow entry points while still routing back through `/paul-*` wrappers
- enabled modules are installed alongside the skills and recorded in `~/.pi/agent/skills/pals/modules.yaml`; TODD/WALT remain module overlays, not standalone Pi skills

| Pi Command | Skill Name | Kernel Workflow(s) | Canonical Entry |
|------------|------------|--------------------|-----------------|
| /paul-init | paul-init | init-project | /skill:paul-init |
| /paul-plan | paul-plan | plan-phase | /skill:paul-plan |
| /paul-apply | paul-apply | apply-phase | /skill:paul-apply |
| /paul-unify | paul-unify | unify-phase | /skill:paul-unify |
| /paul-resume | paul-resume | resume-project | /skill:paul-resume |
| /paul-status | paul-status | roadmap-management (progress) | /skill:paul-status |
| /paul-fix | paul-fix | fix-loop | /skill:paul-fix |
| /paul-pause | paul-pause | pause-work | /skill:paul-pause |
| /paul-milestone | paul-milestone | create-milestone, complete-milestone | /skill:paul-milestone |
| /paul-discuss | paul-discuss | discuss-phase, discuss-milestone | /skill:paul-discuss |
| /paul-help | paul-help | (self-contained) | /skill:paul-help |

## Internal Workflows (not standalone skills)

These are invoked by other workflows and do not need their own skill entry point:

| Workflow | Invoked By |
|----------|-----------|
| transition-phase | unify-phase, complete-milestone |
| verify-work | apply-phase |
| phase-assumptions | plan-phase |
| consider-issues | unify-phase |
| configure-special-flows | init-project |
| map-codebase | init-project |
| research | plan-phase, apply-phase |
| discovery | plan-phase, apply-phase |
| debug | internal diagnostic |
| discuss-milestone | paul-discuss (context detection) |
| discuss-phase | paul-discuss (context detection) |

## Path Strategy

Skills are installed to `~/.pi/agent/skills/pals/{skill-name}/SKILL.md`.

Kernel files are installed to `~/.pi/agent/skills/pals/` with the same directory structure as the source repo kernel:
- `~/.pi/agent/skills/pals/workflows/`
- `~/.pi/agent/skills/pals/references/`
- `~/.pi/agent/skills/pals/templates/`
- `~/.pi/agent/skills/pals/rules/`

From a skill directory, kernel resources are referenced via relative paths:
- Workflows: `../workflows/{name}.md`
- References: `../references/{name}.md`
- Templates: `../templates/{name}.md`
- Rules: `../rules/{name}.md`

Pi command registration lives in the extension layer (`drivers/pi/extensions/pals-hooks.ts`). Those `/paul-*` commands provide the command/hook layer only; they do not replace canonical skill files or shared workflows.

Enabled module manifests are materialized into `~/.pi/agent/skills/pals/modules.yaml` during install. PLAN/APPLY/UNIFY then use that registry to decide which module hook semantics to dispatch from shared markdown references. This is how Pi loads TODD/WALT today: as installed module overlays, not separate `/skill:*` entries.

## Shortcut-Enabled Entry Points

The Pi extension exposes a small shortcut layer for the visible lifecycle surface:
- `Ctrl+Alt+N` → current next action
- `Ctrl+Alt+S` → `/paul-status`
- `Ctrl+Alt+R` → `/paul-resume`
- `Ctrl+Alt+H` → `/paul-help`
- `Ctrl+Alt+M` → `/paul-milestone`

These shortcuts are discovery and routing affordances only. They remain adapter-only and preserve `/skill:paul-*` as the canonical entry layer.

## Design Decisions

- **11 skills, not 21**: Only user-facing commands become skills. Internal workflows are invoked by the skill's instructions.
- **Progressive disclosure**: Pi loads name+description at startup, full SKILL.md on demand. Keep descriptions concise (under 1024 chars).
- **No @ syntax**: Pi has no @ file references. Skills use "Read file X" instructions.
- **Plain text interaction**: Skill behavior stays plain-text-first even though the extension may use lightweight Pi notifications for command guidance.

---
*Created: 2026-03-14 — Phase 49, v2.1 Pi Runtime Integration*
