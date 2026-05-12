# Functional-First Agent Guidance Research

## Purpose

Capture research and design thinking for a future PALS milestone that adds practical functional-programming-inspired guidance for coding agents.

This note is intentionally pre-milestone. It preserves the idea before roadmap/phase planning.

## Research summary

Functional programming is useful for agent-written code because it makes behavior easier to reason about, test, and review. The goal is not to make PALS a functional-programming framework. The goal is to add a functional-first engineering bias where it improves correctness and maintainability.

Relevant principles from Python, F#, Scala, Clojure, and functional-core/imperative-shell guidance:

1. **Pure functions**
   - Same input produces same output.
   - No hidden reads or writes.
   - No mutation of external state.
   - No I/O, logging, network, database, filesystem, clock, randomness, or environment access inside core logic.

2. **Immutable data by default**
   - Prefer producing a new value over mutating an existing value.
   - Avoid shared mutable state unless required by framework or performance constraints.

3. **Explicit inputs and outputs**
   - Pass dependencies, config, time, randomness, current state, and external data explicitly where practical.
   - Avoid ambient globals and implicit context when they make behavior hard to test.

4. **Functional core, imperative shell**
   - Put business logic, validation, transformations, state transitions, and decisions in pure functions.
   - Keep I/O and orchestration in a thin outer shell.
   - The core does the thinking; the shell does the effects.

5. **Composition over cleverness**
   - Prefer small, named transformations with clear inputs and outputs.
   - Do not use dense point-free/chained style if it harms readability.
   - Readability remains more important than functional purity.

6. **Represent states explicitly**
   - Use types, enums, discriminated unions, schemas, or explicit result objects when supported by the language.
   - Avoid loosely shaped objects, magic strings, sentinel values, and invalid intermediate states where clearer modeling is available.

## General coding-agent guidance

Functional-first guidance should sit inside broader agent coding discipline:

- Read before writing.
- Make the smallest correct change.
- Follow existing project conventions before introducing new style.
- Keep changes local and reviewable.
- Avoid speculative abstractions.
- Avoid unrelated refactors.
- Run focused tests first, then broader validation when needed.
- Prefer deterministic, hermetic tests.
- Keep side effects visible and bounded.
- Do not add dependencies, architecture patterns, or broad abstractions without approval.
- State assumptions and conflicts instead of silently guessing.

## Recommended doctrine

Use this framing:

> Functional-first, not functional-only.

Alternative PALS-oriented phrasing:

> Pure Core, Explicit Effects.

The intended default rule:

> Prefer pure, explicit, testable logic; isolate side effects at boundaries; follow the project’s existing idioms unless they conflict with correctness or maintainability.

## Fit with existing PALS surfaces

PALS already has compatible machinery:

- **PAUL** provides the PLAN → APPLY → UNIFY lifecycle.
- **TODD** promotes TDD and RED-GREEN-REFACTOR.
- **WALT** gates tests, lint, typecheck, and quality regressions.
- **RUBY** promotes safe, behavior-preserving, test-backed refactoring.
- **ARCH** surfaces boundary and architecture drift.
- **Project Conventions / AGENTS.md** already provide a place for repo-specific coding guidance.

Therefore, PALS should not add a mandatory functional-programming module by default. The better path is to add lightweight, non-dogmatic guidance across existing surfaces.

## Proposed incorporation plan

### 1. Add default Engineering Principles to generated AGENTS.md

Add a compact section near project conventions:

```md
## Engineering Principles

- Prefer boring, readable, testable code over clever abstractions.
- Follow existing project conventions before introducing new style.
- Prefer pure functions for business logic, data transformation, validation, and decision-making.
- Keep side effects explicit and near boundaries: I/O, DB, network, filesystem, logging, time, randomness, process/env access.
- Prefer immutable data and return new values instead of mutating shared state, unless the project/framework idiom clearly favors mutation.
- Pass dependencies and state explicitly where practical; avoid hidden globals and ambient context.
- Keep changes minimal, local, and reviewable. Do not refactor unrelated code.
- Add or update tests for behavior changes. Use existing test style.
- Do not add new dependencies, architecture patterns, or broad abstractions without approval.
```

Likely files:

- `kernel/templates/AGENTS.md`
- `kernel/workflows/init-project.md`

### 2. Teach brownfield mapping to detect style instead of imposing style

Update codebase mapping so convention extraction notices:

- mutation-heavy vs immutable style
- pure helper/data-transform patterns
- service/repository/controller boundary style
- error handling style
- dependency injection style
- whether the repo prefers classes, functions, modules, hooks, or another architecture style

The output should preserve local idioms. Example:

> This repo prefers class-based services; use pure helpers for data transformation where natural, but do not rewrite class services into a functional architecture.

Likely file:

- `kernel/workflows/map-codebase.md`

### 3. Add RUBY refactoring guidance: Extract Pure Core

Add a refactoring pattern:

```md
### Extract Pure Core

When code mixes decision logic with I/O, logging, time, env, DB, or network access:

1. Preserve behavior.
2. Extract the decision/data transformation into a pure helper.
3. Pass all needed inputs explicitly.
4. Keep the original shell responsible for effects.
5. Add focused tests for the pure helper.
```

Likely files:

- `modules/ruby/references/refactor-principles.md`
- `modules/ruby/references/refactor-patterns.md`

### 4. Strengthen TODD guidance for pure logic

TODD already identifies business logic, data transformations, validation rules, algorithms, state machines, and utilities as TDD candidates.

Add wording such as:

> If behavior can be expressed as input → output without side effects, prefer TDD and test the pure core directly.

Likely files:

- `modules/todd/references/tdd.md`
- `modules/todd/references/tdd-detection.md`

### 5. Optionally add ARCH advisory boundary language

ARCH can non-blockingly surface side-effect boundary drift, such as:

- route/controller doing business logic and persistence inline
- domain logic reading env, clock, filesystem, network, or process state directly
- shared utility mutating global state
- test-hostile hidden dependencies

This should remain advisory unless a project explicitly opts into stricter enforcement.

Likely files:

- `modules/arch/references/*`
- `modules/arch/module.yaml`

## Proposed milestone shape

A future milestone could be scoped as documentation/workflow guidance first, with no new module:

1. Update generated `AGENTS.md` and init workflow with Engineering Principles.
2. Update `map-codebase` to extract functional/side-effect convention signals from brownfield repos.
3. Add RUBY Extract Pure Core guidance.
4. Add TODD pure-logic/TDD guidance.
5. Consider lightweight ARCH advisory language for side-effect boundary drift.
6. Validate with existing artifact consistency, Pi e2e, and cross-harness checks.

## Non-goals

- Do not require functional programming across all PALS projects.
- Do not force rewrites from OOP to FP.
- Do not add a new pal/module unless existing surfaces prove insufficient.
- Do not make advisory design guidance a blocking quality gate by default.
- Do not override project-specific conventions.

## Open questions for milestone planning

- Should the user-facing phrase be “Functional-first” or “Pure Core, Explicit Effects”?
- Should this guidance appear in default `AGENTS.md`, `PROJECT.md`, or both?
- Should ARCH receive side-effect-boundary checks in this milestone or be deferred?
- Should init ask whether to include stricter engineering principles, or should the section be default and editable?
- How should brownfield projects record “follow existing OOP/class style while extracting pure helpers where natural” without sounding contradictory?
