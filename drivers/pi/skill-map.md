# Pi Skill Map

Maps the Pi adapter's command, skill, and workflow surfaces for PALS.

## Command → Skill → Workflow Mapping

In Pi:
- `~/.pi/agent/skills/pals/` holds the shared kernel files and canonical `/skill:paul-*` entry points
- `~/.pi/agent/extensions/pals-hooks.ts` provides the user-facing `/paul-*` command layer, lifecycle hooks, and bounded shortcut UX
- `~/.pi/agent/agents/` holds project-shipped helper agents such as `pals-implementer`
- shared workflow markdown remains the implementation truth behind all three surfaces
- the extension also exposes a bounded shortcut layer for high-frequency flow entry points while still routing back through `/paul-*` wrappers
- enabled modules are installed alongside the skills and recorded in `~/.pi/agent/skills/pals/modules.yaml`; TODD/WALT remain module overlays, not standalone Pi skills
- live module visibility in the Pi status/widget is dispatch-derived from recent shared workflow/reporting output plus shared artifacts; it remains adapter-only and never becomes an authoritative Pi-owned execution ledger
- the visible lifecycle surface stays centered on milestone, phase, loop, and next action; shortcuts remain separate routing affordances rather than extra persistent panel rows
- planning-oriented wrappers surface the shared collaboration model: `planning.default_collaboration`, per-run override, `exploratory` vs `direct-requirements`, and the 4-option review menu
- delegated APPLY stays task-bounded: Pi may surface `pals-implementer`, but parent APPLY keeps verification, fallback, checkpoints, module gates, and `.paul/*` authority; the helper is only for eligible bounded repo-local work
- artifact-slice loading is an adapter-side context aid behind explicit `/paul-*` activation: slices are source-cited, freshness-marked, bounded, read-only, and never a new skill, workflow authority, hidden Pi state, or replacement for a full authoritative read

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
The extension is installed to Pi's extension directory — separate from the skill tree:
- `~/.pi/agent/extensions/pals-hooks.ts` — Pi extension (command registration, lifecycle hooks, guided workflow UX)
Project-shipped helper agents are installed to Pi's agent directory:
- `~/.pi/agent/agents/pals-implementer.md` — bounded implementation worker used only when parent `/skill:paul-apply` delegates an eligible repo-local task
This means PALS uses three Pi install surfaces: skill/kernel files under `~/.pi/agent/skills/pals/`, the extension under `~/.pi/agent/extensions/`, and helper agents under `~/.pi/agent/agents/`. Removing one surface does not move lifecycle truth into Pi; shared workflows plus `.paul/*` remain authoritative, and `uninstall.sh` handles the coordinated cleanup.
Pi currently executes file reads from the project workspace, so the Pi installer materializes canonical skill references as absolute install-root paths inside the installed `SKILL.md` files. Source-controlled Pi skills still use portable `../...` references, but the installed copies resolve to paths like:
- Workflows: `~/.pi/agent/skills/pals/workflows/{name}.md`
- References: `~/.pi/agent/skills/pals/references/{name}.md`
- Templates: `~/.pi/agent/skills/pals/templates/{name}.md`
- Rules: `~/.pi/agent/skills/pals/rules/{name}.md`
- Module registry: `~/.pi/agent/skills/pals/modules.yaml`

`pals-implementer` is not a second APPLY authority. It exists so parent APPLY can offload an eligible bounded repo-local task or sequential task step and then resume parent-owned verification and lifecycle handling.

Enabled module manifests are materialized into `~/.pi/agent/skills/pals/modules.yaml` during install. PLAN/APPLY/UNIFY then use that registry to decide which module hook semantics to dispatch from shared markdown references. This is how Pi loads TODD/WALT today: as installed module overlays, not separate `/skill:*` entries, and the installed Pi skills point at that registry via absolute install-root paths rather than repo-local lookup.
That same shared workflow/reporting contract now powers bounded live module visibility in the Pi status/widget. The extension only derives a recent module activity snapshot from canonical signals such as `[dispatch] ...` and `Module Execution Reports`; it does not persist its own module history or claim authoritative proof independently of shared artifacts.

## Shortcut-Enabled Entry Points

The Pi extension exposes a small shortcut layer for the visible lifecycle surface. The persistent lifecycle surface itself stays centered on milestone, phase, loop, and next action:
- `Ctrl+Alt+N` → current next action
- `Ctrl+Alt+S` → `/paul-status`
- `Ctrl+Alt+R` → `/paul-resume`
- `Ctrl+Alt+H` → `/paul-help`
- `Ctrl+Alt+M` → `/paul-milestone`

These shortcuts are discovery and routing affordances only, not extra persistent panel rows. They remain adapter-only and preserve `/skill:paul-*` as the canonical entry layer.
## Collaboration Flow Notes

Planning-oriented Pi entry points stay aligned with shared workflow truth:
- `init`, `discuss`, `milestone`, and `plan` all respect `planning.default_collaboration`
- each run may keep the default or override it to `low`, `medium`, or `high`
- planning runs explicitly distinguish `exploratory` vs `direct-requirements`
- Pi guided workflow UX may surface the review menu (`Quick recap`, `Detailed recap`, `Full plan`, `No review needed`) but still sends canonical numeric replies through normal message flow

## Design Decisions

- **11 skills, not 21**: Only user-facing commands become skills. Internal workflows are invoked by the skill's instructions.
- **Progressive disclosure**: Pi loads name+description at startup, full SKILL.md on demand. Keep descriptions concise (under 1024 chars).
- **No @ syntax**: Pi has no @ file references. Skills use "Read file X" instructions.
- **Plain text interaction**: Skill behavior stays plain-text-first even though the extension may use lightweight Pi notifications for command guidance.

---
*Created: 2026-03-14 — Phase 49, v2.1 Pi Runtime Integration*
