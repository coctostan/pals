# Pi Skill Map

Maps PALS kernel workflows to Pi-discoverable skills.

## Skill → Workflow Mapping

| Skill Name | Kernel Workflow(s) | Pi Command |
|------------|-------------------|------------|
| paul-init | init-project | /skill:paul-init |
| paul-plan | plan-phase | /skill:paul-plan |
| paul-apply | apply-phase | /skill:paul-apply |
| paul-unify | unify-phase | /skill:paul-unify |
| paul-resume | resume-project | /skill:paul-resume |
| paul-status | roadmap-management (progress) | /skill:paul-status |
| paul-fix | fix-loop | /skill:paul-fix |
| paul-pause | pause-work | /skill:paul-pause |
| paul-milestone | create-milestone, complete-milestone | /skill:paul-milestone |
| paul-discuss | discuss-phase, discuss-milestone | /skill:paul-discuss |
| paul-help | (self-contained) | /skill:paul-help |

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

## Design Decisions

- **11 skills, not 21**: Only user-facing commands become skills. Internal workflows are invoked by the skill's instructions.
- **Progressive disclosure**: Pi loads name+description at startup, full SKILL.md on demand. Keep descriptions concise (under 1024 chars).
- **No @ syntax**: Pi has no @ file references. Skills use "Read file X" instructions.
- **Plain text interaction**: No ctx.ui dependency. All user interaction via plain text output.

---
*Created: 2026-03-14 — Phase 49, v2.1 Pi Runtime Integration*
