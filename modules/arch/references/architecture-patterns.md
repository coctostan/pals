<overview>
Pattern catalog, boundary rules, and structural metrics applied to `files_modified` (pre-plan) and `files_changed` (post-apply), plus their parent directories.
</overview>

<layer_patterns>

## Layered Architecture

| Pattern | Indicators | Example |
|---------|-----------|---------|
| MVC | `models/`, `views/`, `controllers/` dirs | Rails, Django, Express |
| Clean/Hexagonal | `domain/`, `ports/`, `adapters/`, `usecases/` | DDD projects |
| 3-Tier | `presentation/`, `business/`, `data/` | Enterprise apps |
| Feature-based | `features/{name}/` with co-located files | Modern React, Angular |
| Flat | All files in `src/` root, no subdirectories | Small scripts, CLIs |

### Detection Heuristic

1. Take the unique parent directories of the in-scope paths.
2. Match them against the **Indicators** column above.
3. If a row matches, set `arch_context.detected_pattern = {name}`.
4. If no row matches, emit `ARCH: skipped — no recognized pattern in scope`.

</layer_patterns>

<boundary_rules>

## Architectural Boundaries

Rules that define valid and invalid cross-layer dependencies:

| From → To | Valid? | Why |
|-----------|--------|-----|
| Controller → Service | ✓ | Standard downward dependency |
| Service → Repository | ✓ | Business logic accesses data through abstraction |
| Repository → Service | ✗ | Data layer should not know about business logic |
| Controller → Repository | ✗ | Bypasses business logic; loses validation/authorization |
| Utility → Domain | ✗ | Utilities should be dependency-free |
| Domain → Infrastructure | ✗ | Domain should not depend on implementation details |
| Test → Any | ✓ | Tests can import anything they test |

### Boundary Detection

For each import resolved from `files_changed`, add one boundary-check row:

1. Resolve source layer (e.g., `src/controllers/auth.ts` → Controller).
2. Resolve imported layer (e.g., `src/repositories/user.ts` → Repository).
3. Set row Status from the **Architectural Boundaries** table: `✓` → `PASS`, `✗` → `VIOLATION`, unlisted pair → `WARN`.
4. Files with no resolved imports add no rows.

</boundary_rules>

<component_patterns>

## Component & Module Patterns

| Pattern | Good Sign | Smell |
|---------|-----------|-------|
| Single Responsibility | File has one export, clear name | File exports 5+ unrelated things |
| Dependency Injection | Constructor params, factory functions | `new` inside business logic |
| Interface Segregation | Small focused interfaces | "God interfaces" with 10+ methods |
| Event-Driven | Emitters, pub/sub, message queues | Direct cross-module function calls for async work |
| Repository Pattern | Data access behind interface | SQL/ORM calls scattered in business logic |
| Service Layer | Business logic isolated from transport | HTTP/DB concerns mixed in same function |

</component_patterns>

<side_effect_boundaries>

## Side-Effect Boundaries (Functional-First Advisory)

When `files_modified` or `files_changed` shows evidence of side-effect boundary drift, ARCH may surface it as advisory (Pure Core, Explicit Effects) under a functional-first, not functional-only posture, without forcing a functional architecture. Project conventions and local idioms remain authoritative.

| Smell | Example evidence |
|-------|------------------|
| Domain reads env/clock directly | Pure domain file imports `process.env`, `Date.now()`, `os`, or system clock APIs |
| Domain touches filesystem/network/process | Pure domain file imports `fs`, `http`/`fetch`, `child_process`, or DB clients directly |
| Controller mixes concerns | Route/controller file inlines orchestration, persistence, and business rules without delegation |
| Hidden dependencies | Function reaches globals, singletons, or module-level mutable state instead of accepting explicit inputs |

Report these only when in-scope evidence is available; cite `{file}:{evidence}`. Never extrapolate project-wide. Advisory only — PLAN/APPLY/UNIFY owns any blocking response, and ARCH does not require rewriting to a functional architecture.

</side_effect_boundaries>

<structural_metrics>

## Structural Health Metrics

Use these as advisory WARN triggers only when in-scope evidence is available; do not extrapolate project-wide counts. Each WARN cites `{file}:{metric}={value}` or the boundary-check row that triggered it.

| Metric | WARN trigger |
|--------|--------------|
| Max directory depth | In-scope path exceeds 6 levels |
| Files per directory | In-scope parent directory has >25 files |
| Circular dependencies | Resolved in-scope imports form a cycle |
| Cross-boundary imports | Boundary-check row has Status `VIOLATION` |
| God files | In-scope file exceeds 500 lines |

</structural_metrics>
