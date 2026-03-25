<overview>
Architecture pattern detection and classification. ARCH identifies the project's structural patterns from directory layout, import graphs, and naming conventions.
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

1. List top-level directories under `src/` (or project root)
2. Match directory names against known patterns above
3. If no match: check for feature-based (dirs with mixed file types) vs flat (all files at root)
4. Report: "Detected pattern: {name} — {confidence}"

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

For each import/require in changed files:
1. Resolve source file's layer (e.g., `src/controllers/auth.ts` → controller layer)
2. Resolve imported file's layer (e.g., `src/repositories/user.ts` → repository layer)
3. Check against boundary rules table
4. Flag violations: "Boundary violation: {source_layer} → {target_layer} in {file}:{line}"

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

<structural_metrics>

## Structural Health Metrics

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| Max directory depth | ≤4 levels | 5-6 levels | >6 levels |
| Files per directory | ≤15 | 16-25 | >25 |
| Circular dependencies | 0 | 1-2 | >2 |
| Cross-boundary imports | 0 violations | 1-3 warnings | >3 violations |
| Orphan files (no imports in/out) | <5% | 5-15% | >15% |
| God files (>500 lines) | 0 | 1-2 | >2 |

</structural_metrics>
