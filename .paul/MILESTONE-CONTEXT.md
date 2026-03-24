# Milestone Context

**Generated:** 2026-03-24
**Status:** Ready for /paul:milestone
**Planning Mode:** direct-requirements
**Collaboration Level:** medium
**Suggested Review Path:** quick recap

## Features to Build

All 10 module improvement action items (AI-1 through AI-10):
- AI-1: SKIP structured knowledge entries using its own templates
- AI-2: DAVE CI config validation + syntax checking
- AI-3: IRIS real linting tools (eslint complexity/security) instead of grep
- AI-4: RUBY real complexity tools instead of wc -l estimates
- AI-5: DOCS expanded doc catalog beyond README
- AI-6: DEAN severity-based blocking (critical/high = block)
- AI-7: WALT persistent quality-history.md with trends
- AI-8: TODD more aggressive TDD plan suggestion
- AI-9: IRIS/RUBY shared ESLint invocation
- AI-10: DAVE CI generation for projects without it

## Scope

**Suggested name:** v2.18 Module Hardening
**Estimated phases:** 3
**Focus:** Upgrade all 8 modules from "dispatches correctly" to "produces genuinely useful, tool-backed output."

## Phase Mapping

| Phase | Focus | Items |
|-------|-------|-------|
| 106 | Quick Wins (small effort, high impact) | AI-1 (SKIP templates), AI-6 (DEAN severity blocking), AI-5 (DOCS expanded catalog), AI-8 (TODD TDD suggestion) |
| 107 | Tool Integration (medium effort, high impact) | AI-2 (DAVE validation), AI-3 (IRIS ESLint), AI-4 (RUBY complexity), AI-9 (IRIS/RUBY shared) |
| 108 | Quality Tracking + CI Gen + Retest | AI-7 (WALT history), AI-10 (DAVE generation), then retest ALL modules via pi-verify cmux pane |

## Constraints

- Changes are to module reference files and hook descriptions in modules.yaml source (modules/*/references/*.md)
- Need ./install.sh after each phase to deploy
- Retest in pi-verify pane to validate improvements
- All changes must be backward-compatible (no new required config)

---

*This file is temporary. It will be deleted after /paul:milestone creates the milestone.*
