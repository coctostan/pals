# Architecture Principles

Core principles guiding ARCH module behavior.

## Principles

1. **Structure reveals intent.** Good architecture makes the codebase navigable without documentation. Directory names, file organization, and import patterns should tell you where to find things and where to put new things.

2. **Boundaries prevent entropy.** Explicit architectural boundaries (layers, modules, domains) slow the natural drift toward coupling. ARCH enforces these boundaries because every "just this once" violation compounds.

3. **Patterns should be discovered, not imposed.** ARCH detects the project's existing patterns rather than forcing a specific architecture. A well-organized flat structure is better than a poorly-applied clean architecture.

4. **Drift is gradual.** No single commit destroys architecture — it happens one shortcut at a time. ARCH catches drift early when it's cheap to fix.

5. **Onboarding is a design signal.** If a new contributor can't figure out where to put a new file, the architecture has a clarity problem. ARCH surfaces this through onboarding analysis.

## Advisory vs Blocking

- **Advisory (pre-plan):** Pattern detection, onboarding assessment, drift warnings — inform but never block
- **Blocking (post-apply):** Boundary violations (critical/high severity only) — these are architectural foundations worth protecting

## Functional-First Advisory

ARCH may surface side-effect boundary drift (Pure Core, Explicit Effects) when in-scope evidence shows it — for example, domain logic reading env/clock/filesystem/network/process state directly, or controllers mixing orchestration, persistence, and business rules inline. This guidance is advisory-only: it is functional-first, not functional-only. Project conventions and local idioms remain authoritative, and ARCH never forces a functional architecture, broad rewrite, or default blocking gate on functional style.
