# PALS Functional-First Agent Guidance Contract

## Purpose

This contract defines the v2.65 implementation boundary for adding practical functional-programming-inspired guidance to PALS.

The goal is to improve agent-written code by making logic easier to reason about, test, review, and maintain. The goal is not to make PALS a functional-programming framework or to impose a programming paradigm on every project.

## Source Authority

This contract is derived from `docs/FUNCTIONAL-FIRST-AGENT-GUIDANCE-RESEARCH.md`.

After Phase 279 UNIFY:

1. `docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md` is the authoritative implementation boundary for v2.65.
2. `docs/FUNCTIONAL-FIRST-AGENT-GUIDANCE-RESEARCH.md` remains background, rationale, and provenance.
3. If the contract and research note conflict, the contract wins for v2.65 planning and APPLY work.

## Doctrine

Use this framing across v2.65:

> Functional-first, not functional-only.

Alternative short form:

> Pure Core, Explicit Effects.

Default rule:

> Prefer pure, explicit, testable logic; isolate side effects at boundaries; follow the project’s existing idioms unless they conflict with correctness or maintainability.

## Practical Principles

### Pure Logic for Core Decisions

Prefer pure functions for business logic, validation, data transformation, state transitions, algorithms, and decision-making.

A pure function:

- returns the same output for the same input;
- does not mutate hidden or external state;
- does not perform I/O;
- does not read ambient process, environment, clock, random, network, database, filesystem, or UI state unless those values are explicitly passed in.

### Immutable-by-Default Data

Prefer producing a new value over mutating shared state when this fits the language, framework, and project style.

This is guidance, not a prohibition. In-place mutation remains acceptable when it is the established project idiom, required by a framework, clearer for the local code, or materially better for performance.

### Explicit Inputs and Outputs

Make dependencies, current state, config, time, randomness, and external data explicit where practical.

Avoid hidden globals, ambient context, and implicit state when they make behavior harder to test or review.

### Functional Core, Imperative Shell

Separate thinking from effects:

- the functional core performs business rules, validation, transformation, and decisions;
- the imperative shell handles I/O, persistence, network calls, filesystem access, logging, framework callbacks, timers, random values, process/env access, and orchestration.

This pattern should be suggested when it reduces coupling and improves testability. It should not be forced where the local architecture already has clear, testable boundaries.

### Readability Over Clever Functional Style

Do not replace readable imperative code with dense functional chains, point-free style, or abstraction-heavy helper layers just to appear functional.

Prefer small named helpers, direct data flow, and clear tests. Boring readable code wins over clever FP style.

### Explicit State Modeling

Where the language and project style support it, prefer types, enums, discriminated unions, schemas, result objects, or other explicit models that make invalid states harder to represent.

Avoid magic strings, sentinel values, and loosely shaped objects when a clearer representation is already natural for the project.

## Integration Rules

### Use Existing PALS Surfaces First

v2.65 should extend existing PALS surfaces before considering a new module or pal.

Allowed surfaces:

- generated agent/project convention surfaces, especially `AGENTS.md` templates and init workflow text;
- brownfield codebase mapping and convention extraction;
- TODD guidance for TDD-friendly pure logic;
- RUBY guidance for safe refactoring toward pure cores;
- optional ARCH advisory language for side-effect boundary drift.

A new module is out of scope for v2.65 unless a later milestone explicitly proves existing surfaces are insufficient.

### Project Conventions Remain Authoritative

Default functional-first guidance must not override project-specific conventions.

Brownfield projects may prefer class-based services, framework-specific mutation, object-oriented patterns, or other local idioms. PALS should preserve those idioms and suggest pure helpers or explicit boundaries only where they fit naturally.

### Guidance Is Advisory Unless a Later Phase Explicitly Makes It Structural

The default posture is non-blocking guidance.

Do not create new blocking gates for functional style by default. Existing quality gates still apply: tests, lint, typecheck, security/dependency gates, and other module-specific enforcement remain authoritative where already configured.

### Keep the Guidance Agent-Usable

Guidance should help an agent make a narrow, correct, reviewable change. Prefer concise rules that reduce ambiguity:

- read before writing;
- make the smallest correct change;
- isolate side effects when practical;
- keep changes local and testable;
- avoid speculative abstractions;
- state assumptions and conflicts.

## Non-Goals

v2.65 must not:

- require functional programming across all PALS projects;
- force rewrites from OOP/class-based styles to FP styles;
- add a new pal/module by default;
- create a default blocking gate for functional style;
- override project-specific conventions;
- add dependencies, runtime tooling, CI requirements, or package changes solely for this guidance;
- encourage broad refactors outside a plan’s approved scope;
- use “functional” as a reason to make code less readable.

## Hard Boundaries

- Phase 279 creates this contract only; downstream implementation surfaces are out of scope until later phases.
- Phase 280 may edit agent convention/init surfaces only within its approved plan.
- Phase 281 may edit brownfield mapping/convention extraction only within its approved plan.
- Phase 282 may edit TODD and RUBY guidance only within its approved plan.
- Phase 283 decides whether ARCH advisory language is needed; ARCH work remains optional until then.
- Validation scripts may only change in later phases if an approved plan names them explicitly.

## Phase Scope Map

### Phase 280: Agent Convention Surface

Allowed scope:

- Add compact Engineering Principles to generated `AGENTS.md` or equivalent agent convention templates.
- Update init workflow text so new projects receive editable guidance.
- Preserve the authority of project-specific conventions.

Expected guidance shape:

- prefer boring, readable, testable code;
- follow existing project conventions;
- prefer pure functions for business logic and transformations;
- keep side effects near boundaries;
- prefer immutable data where natural;
- pass state/dependencies explicitly where practical;
- keep changes minimal and local;
- avoid unapproved dependencies or architecture changes.

Out of scope:

- map-codebase extraction changes;
- TODD/RUBY/ARCH changes;
- new modules or blocking gates.

### Phase 281: Brownfield Convention Detection

Allowed scope:

- Teach codebase mapping to detect and record style signals relevant to functional-first guidance.
- Preserve local idioms rather than imposing functional style.

Signals to consider:

- mutation-heavy vs immutable style;
- pure helper/data transformation patterns;
- service/repository/controller boundary style;
- error handling style;
- dependency injection style;
- whether the repo prefers classes, functions, modules, hooks, or framework-specific patterns.

Out of scope:

- changing generated AGENTS/init text unless explicitly needed by the approved plan;
- changing TODD/RUBY/ARCH guidance;
- requiring brownfield repos to adopt a new architecture.

### Phase 282: TODD + RUBY Guidance

Allowed TODD scope:

- Clarify that pure input-to-output logic is high-value TDD scope.
- Reinforce testing the pure core directly when behavior can be expressed without side effects.

Allowed RUBY scope:

- Add or refine an “Extract Pure Core” refactoring pattern.
- Keep refactoring behavior-preserving, incremental, and test-backed.

Out of scope:

- changing TDD enforcement semantics beyond wording/guidance unless separately planned;
- making pure-core extraction mandatory;
- broad refactoring of source code.

### Phase 283: ARCH Advisory + Closure

Allowed scope:

- Decide whether ARCH should receive lightweight side-effect-boundary advisory language.
- If approved, add non-blocking advisory guidance for boundary drift such as:
  - domain logic reading env, clock, filesystem, network, or process state directly;
  - route/controller code mixing orchestration, persistence, and business rules inline;
  - shared utilities mutating global state;
  - hidden dependencies that make tests brittle.
- Close the milestone with validation and reconciliation.

Out of scope:

- default blocking ARCH gates for side-effect boundaries;
- broad architectural rewrites;
- adding a separate functional-programming module.

## Validation Expectations

Every downstream phase should run validation appropriate to its modified surfaces.

Minimum expected checks for docs/workflow guidance changes:

- `git diff --check`
- `bash tests/helpers/artifact_consistency.sh`

When a phase changes installed workflow, command, module, or driver-discovered surfaces, consider the relevant broader checks named by that phase’s plan, such as:

- `bash tests/pi-end-to-end-validation.sh`
- `bash tests/cross-harness-validation.sh`
- targeted semantic guard scripts when applicable

Validation should prove that guidance is present, discoverable, and not contradictory. Validation does not need to prove that all future agent code is functional.

## Handoff Guidance for Later Plans

Later v2.65 PLANs should cite this contract as the source of truth for scope and terminology.

Use the research note only when additional rationale is needed. Do not reopen settled doctrine unless the user explicitly asks to revise the contract.

When planning downstream phases, preserve these assumptions:

- the doctrine is “functional-first, not functional-only”;
- project conventions remain authoritative;
- default guidance is advisory;
- no new module is expected;
- no blocking functional-style gate is expected;
- ARCH advisory work is optional until Phase 283 decides it.
