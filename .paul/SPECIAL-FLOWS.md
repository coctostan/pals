# Special Flows Configuration

## Project-Level Skills

| Skill | Work Type | Priority | Trigger |
|-------|-----------|----------|---------|
| /paul | Project planning & lifecycle management | Required | All planning, applying, and unifying work — the PLAN-APPLY-UNIFY loop |
| /carl | Session boundary manager — autonomous session transitions | Required | Automatic — monitors context at phase boundaries and mid-phase, creates fresh sessions when needed |
| TODD | Test-driven development enforcement | Required | Before and during code implementation — ensures tests are written first |
| WALT | Quality gating & validation | Required | After implementation — validates code quality before marking work complete |

## Skill Details

### /paul (Project Automation & Lifecycle)
- **Scope:** Full project lifecycle — planning phases, executing plans, unifying results
- **Commands:** /paul:plan, /paul:apply, /paul:unify, /paul:progress, /paul:verify
- **Integration:** Core workflow engine, always active

### /carl (Session Boundary Manager)
- **Scope:** Autonomous context-aware session transitions at phase boundaries and mid-phase safety valve
- **Mechanism:** Pi extension events (agent_end for phase detection, turn_end for safety monitoring)
- **Configuration:** pals.json carl section (session_strategy, continue_threshold, safety_ceiling)

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
