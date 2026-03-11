# Special Flows Configuration

## Project-Level Skills

| Skill | Work Type | Priority | Trigger |
|-------|-----------|----------|---------|
| /paul | Project planning & lifecycle management | Required | All planning, applying, and unifying work — the PLAN-APPLY-UNIFY loop |
| /carl | Context rules & domain configuration | Required | When establishing coding standards, domain rules, or behavioral constraints |
| TODD | Test-driven development enforcement | Required | Before and during code implementation — ensures tests are written first |
| WALT | Quality gating & validation | Required | After implementation — validates code quality before marking work complete |

## Skill Details

### /paul (Project Automation & Lifecycle)
- **Scope:** Full project lifecycle — planning phases, executing plans, unifying results
- **Commands:** /paul:plan, /paul:apply, /paul:unify, /paul:progress, /paul:verify
- **Integration:** Core workflow engine, always active

### /carl (Context & Rules Layer)
- **Scope:** Domain-specific rules, global conventions, context-aware behavior
- **Commands:** /carl:manager, domain/rule CRUD
- **Integration:** Rules injected via system hooks, enforced during all phases

### TODD (Test-Driven Development)
- **Scope:** TDD enforcement during APPLY phase — tests before implementation
- **Integration:** TODD steps run inline during APPLY phase (TDD detection, red-green-refactor cycle)
- **References:** tdd.md, tdd-detection.md, tdd-plan-generation.md, tdd-execution.md

### WALT (Quality Assurance & Gating)
- **Scope:** Quality validation during APPLY and UNIFY phases — testing, linting, quality delta tracking
- **Integration:** WALT steps run inline during APPLY (quality gates) and UNIFY (quality delta tracking)
- **References:** quality-runner.md, quality-lint.md, quality-delta.md, quality-history.md, quality-detection.md

## Phase Overrides
None configured.

## Templates/Assets
None configured.

---
*Configuration created: 2026-03-11*
