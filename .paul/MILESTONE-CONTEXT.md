# Milestone Context

**Generated:** 2026-03-14
**Status:** Ready for /paul:milestone

## Features to Build

- **Multi-model routing for cost efficiency:** Use Sonnet for execution/testing phases (APPLY tasks, TODD enforcement) where Opus is overkill. Keep Opus for planning (PLAN) and reconciliation (UNIFY) where reasoning quality matters.
- **pals.json models config:** Add a `models` section to pals.json that maps workflow phases to model preferences (e.g., `plan: opus`, `apply: sonnet`, `unify: opus`)
- **Subagent model dispatch:** When spawning Agent tool subagents during APPLY, pass the configured model via the Agent tool's `model` parameter
- **Custom agent patterns:** May need specialized agent configurations for different task types (research vs code generation vs testing)

## Scope

**Suggested name:** v1.2 Multi-Model Routing
**Estimated phases:** 2-3
**Focus:** Make PALS account-efficient by routing cheaper models to execution tasks while preserving quality for planning and reconciliation

## Phase Mapping

| Phase | Focus | Features |
|-------|-------|----------|
| 43 | Config & routing design | pals.json `models` section schema, model selection logic in apply-phase.md, research which tasks benefit from Opus vs Sonnet |
| 44 | Implementation & validation | Wire model routing into apply-phase subagent dispatch, test with real tasks, document configuration |

## Constraints

- Must be backward-compatible — if no `models` config, behavior unchanged (uses whatever model the host tool provides)
- Cannot assume specific model APIs — routing is via Agent tool's `model` parameter, not direct API calls
- Should work with the existing Claude Code driver (Agent tool already supports `model` param with "sonnet", "opus", "haiku")
- Keep it simple — config-driven, not adaptive/dynamic model selection

## Future Milestone (noted, not in scope)

**v2.0 Portability & Cross-Harness Support** — formalize artifact/lifecycle/adapter contracts, decouple kernel from Claude assumptions, build pi-mono adapter. User's portability docs (PORTABILITY-ROADMAP.md, ADAPTER-CONTRACT.md, HARNESS-PORTABILITY.md) form the design basis. Needs pi-mono extension system research first.

## Additional Context

- Agent tool already supports `model` parameter with values "sonnet", "opus", "haiku"
- Deferred issue from v1.1: "Multi-model routing: Opus for plan/unify, Sonnet subagents for apply tasks — config-driven via pals.json `models` field, subagent dispatch in apply-phase"
- User's portability docs are in docs/ — well-structured but belong to v2.0, not this milestone

---

*This file is temporary. It will be deleted after /paul:milestone creates the milestone.*
