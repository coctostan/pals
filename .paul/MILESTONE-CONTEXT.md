# Milestone Context

**Generated:** 2026-03-14
**Status:** Ready for /paul:milestone

## Features to Build

- **Harness-agnostic skill format**: Rewrite all PALS workflows/commands to remove `@` reference syntax and Claude-specific assumptions. Use relative paths + explicit read instructions that work on any LLM platform.
- **Portable reference resolution**: Replace `@~/.pals/references/...` with a resolution pattern that works on both Claude Code (Read tool) and pi (read tool) without platform-specific syntax.
- **Adapter installer for pi**: Build a pi-specific installer that wires PALS skills into `~/.pi/agent/skills/` (or settings.json `skills` array), mapping the same source workflows to pi's discovery system.
- **Hook abstraction layer**: Define PALS lifecycle hook semantics (pre-plan, post-task, post-apply, etc.) in a harness-neutral way. Build a thin pi extension (TypeScript) that maps pi events → PALS hook dispatch, equivalent to what Claude Code hooks do via shell commands.
- **Artifact spec**: Formalize `.paul/` artifact schemas (STATE.md, PROJECT.md, ROADMAP.md, PLAN.md, SUMMARY.md, etc.) — required sections, allowed states, who writes/reads. This is the portable contract.
- **Lifecycle spec**: Formalize PLAN → APPLY → UNIFY state machine — valid transitions, preconditions, postconditions, artifact obligations per step.
- **Cross-harness validation**: Verify that the same `.paul/` project state works when driven by both Claude Code and pi adapters. Same artifacts, same lifecycle, same module participation.

## Scope

**Suggested name:** v2.0 Portability & Cross-Harness
**Estimated phases:** 4
**Focus:** Make PALS portable across harnesses while preserving the same `.paul/` artifacts as the authoritative runtime state.

## Phase Mapping

| Phase | Focus | Features |
|-------|-------|----------|
| 45 | Artifact & Lifecycle Spec | Formalize artifact schemas, lifecycle state machine, hook semantics — the portable contract docs |
| 46 | Harness-Agnostic Skills | Rewrite all workflows/commands to remove `@` references and Claude-specific assumptions; portable reference resolution |
| 47 | Pi Adapter | Pi installer, pi extension for hook dispatch, skill wiring, settings.json integration |
| 48 | Cross-Harness Validation | End-to-end testing — same `.paul/` project driven by both adapters, artifact parity verification |

## Constraints

- Existing Claude Code behavior must not regress — current users see no change
- `.paul/` artifacts remain the single source of truth across harnesses
- Pi adapter must work with pi's native skill/extension system (no forks or patches to pi)
- Module hooks on pi require a TypeScript extension (can't use shell hooks)
- User interaction stays plain text — no dependency on pi's `ctx.ui` primitives
- PALS workflows remain markdown — interpreted by the LLM, not compiled

## Key Research Findings

### Platform Comparison

| Concern | Claude Code | Pi | Gap |
|---------|------------|-----|-----|
| Commands | `/paul:plan` (skills) | `/skill:paul-plan` (skills) | Naming convention |
| Workflow content | Markdown read by LLM | Markdown read by LLM | **None** |
| Context injection | `@references` auto-inject | LLM reads files on demand | Must remove `@` syntax |
| User interaction | Plain text + AskUserQuestion | Plain text (skip ctx.ui) | **None if text-only** |
| Module hooks | Shell hooks on tool calls | TypeScript extension events | **Real gap — needs adapter** |
| Install paths | `~/.pals/` → `~/.claude/` | `~/.pi/agent/skills/` or settings | Installer concern |
| Skill format | Markdown + frontmatter | Markdown + frontmatter | **Nearly identical** |

### Pi References
- Extensions: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/extensions.md
- SDK: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/examples/sdk/README.md
- Skills: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/skills.md

### Key Insight
Pi supports the same skill format as Claude Code (markdown + frontmatter, `/skill:name` invocation, progressive disclosure). Pi can even load Claude Code skills directly via settings. The only real architectural gap is lifecycle hooks — Claude uses shell hooks, pi uses TypeScript extensions. Everything else is installer wiring.

## Additional Context

- Three design docs already exist: `docs/HARNESS-PORTABILITY.md`, `docs/ADAPTER-CONTRACT.md`, `docs/PORTABILITY-ROADMAP.md`
- The original PORTABILITY-ROADMAP.md scoped 5 phases; this is tightened to 4 based on the discovery that skills are nearly identical across platforms
- Guiding principle from prior discussion: "Artifacts are authoritative; prompts are interpretive"
- v2.0 was explicitly chosen as the version number because this is a major architectural shift

---

*This file is temporary. It will be deleted after /paul:milestone creates the milestone.*
