# Milestone Context

**Generated:** 2026-03-15
**Status:** Draft for post-v2.2 handoff

## Features to Build

- **Hook and context strategy refinement**: Determine the best Pi-native trigger model for PALS state injection, comparing `input`, `before_agent_start`, and `context` while preserving `.paul/*` artifact authority.
- **Command routing and discoverability improvements**: Refine `/paul-*` command ergonomics, descriptions, and discoverability while keeping skills as canonical execution entry points.
- **Adapter consistency cleanup**: Align installer comments, extension docs, help text, and skill-facing language with the actual extension-enabled Pi architecture.

## Scope

**Suggested name:** v2.3 Pi Interaction Model Refinement
**Estimated phases:** 3
**Focus:** Make the Pi adapter more deterministic, discoverable, and idiomatic without moving workflow truth out of shared artifacts.

## Phase Mapping

| Phase | Focus | Features |
|-------|-------|----------|
| 56 | Hook & Context Strategy | Evaluate and choose the best model for PALS state injection and workflow activation inside Pi |
| 57 | Command Routing & Discoverability | Improve `/paul-*` command UX, discoverability, and routing while preserving `/skill:paul-*` as canonical |
| 58 | Adapter Consistency Cleanup | Remove drift across extension docs, installer comments, and skill/help text so the adapter clearly matches reality |

## Constraints

- Shared markdown workflows, references, and templates remain authoritative.
- `.paul/*` artifacts remain the source of truth for project state.
- Pi-specific logic should stay in the adapter layer, not replace workflow behavior.
- Improvements should favor additive Pi-native UX over platform-specific semantic divergence.

## Additional Context

- v2.2 audit conclusion: the Pi port is directionally correct and artifact-safe, but still basic in its use of Pi-native capabilities.
- The highest-priority gap is interaction model quality: triggers, routing, context injection, and adapter clarity.
- This milestone is intentionally adapter-focused, not a rewrite of shared kernel or module artifacts.

---

*This is a draft context artifact for the next milestone discussion/creation step.*
*Do NOT commit this file to version control unless intentionally promoted into PALS workflow artifacts.*
