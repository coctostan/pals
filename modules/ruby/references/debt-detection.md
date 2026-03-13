# Debt Detection

RUBY's catalog of tech debt indicators, detection heuristics, and prioritization framework.

## Code Smells Catalog

### Structural Smells

| Smell | Indicator | Severity |
|-------|-----------|----------|
| Long function | Function body exceeds ~50 lines | Medium |
| God object/file | Single file with too many responsibilities (>300 lines or >10 public methods) | High |
| Deep nesting | More than 3 levels of indentation (if/for/try) | Medium |
| Long parameter list | Function takes more than 4 parameters | Medium |
| Feature envy | Function uses more data from another module than its own | Medium |

### Duplication Smells

| Smell | Indicator | Severity |
|-------|-----------|----------|
| Copy-paste code | Near-identical blocks in 2+ locations | High |
| Parallel class hierarchies | Adding a subclass in one hierarchy requires adding one in another | Medium |
| Repeated conditionals | Same if/switch chain appears in multiple places | High |

### Naming & Clarity Smells

| Smell | Indicator | Severity |
|-------|-----------|----------|
| Unclear naming | Single-letter variables, abbreviations, generic names (data, info, temp) | Low |
| Magic numbers/strings | Hardcoded values without named constants | Medium |
| Misleading names | Name suggests different behavior than implementation | High |
| Dead code | Unreachable code, unused functions, commented-out blocks | Low |

### Coupling Smells

| Smell | Indicator | Severity |
|-------|-----------|----------|
| Circular dependencies | Module A imports B, B imports A (directly or transitively) | Critical |
| Shotgun surgery | One change requires edits across many unrelated files | High |
| Inappropriate intimacy | Class/module accesses internals of another | Medium |

## Complexity Heuristics

### Thresholds

| Metric | Acceptable | Warning | Critical |
|--------|-----------|---------|----------|
| Cyclomatic complexity (per function) | 1-10 | 11-20 | >20 |
| Cognitive complexity (per function) | 1-15 | 16-30 | >30 |
| Lines per function | 1-50 | 51-100 | >100 |
| Lines per file | 1-300 | 301-500 | >500 |
| Parameters per function | 1-4 | 5-6 | >6 |
| Nesting depth | 1-3 | 4 | >4 |

### Language-Specific Detection

**JavaScript/TypeScript:**
- ESLint `complexity` rule for cyclomatic complexity
- `no-unused-vars`, `no-unused-imports` for dead code
- Bundle analysis for unused exports
- `any` type count as type-safety debt

**Python:**
- `radon` for cyclomatic and Halstead complexity
- `pylint` for code smells (R-category: refactor suggestions)
- `vulture` for dead code detection
- `import` cycle detection via `pydeps` or `importlab`

**Go:**
- `gocyclo` for cyclomatic complexity
- `deadcode` for unused code
- `golangci-lint` aggregates multiple linters
- Package dependency analysis via `go mod graph`

**Rust:**
- `clippy` complexity and style lints
- `cargo-udeps` for unused dependencies
- `cargo-bloat` for binary size analysis
- Module coupling via dependency graph

## Severity Classification

| Level | Definition | Action |
|-------|-----------|--------|
| Critical | Actively causing bugs or blocking development | Fix immediately |
| High | Slowing development, increasing bug risk | Fix in current milestone |
| Medium | Reducing code clarity and maintainability | Fix when touching affected files |
| Low | Style/convention issues, minor clarity improvements | Fix opportunistically |

## Prioritization Framework

### Impact × Frequency ÷ Effort

Score each debt item on three axes:

1. **Impact** (1-5): How much does this slow down or risk the project?
2. **Frequency** (1-5): How often is this code touched? (git log --stat)
3. **Effort** (1-5): How much work to fix? (1 = trivial, 5 = multi-day)

**Priority = (Impact × Frequency) ÷ Effort**

Focus on high-priority items first: high-impact, frequently-changed, easy-to-fix.

### Structural Indicators

Beyond individual smells, look for systemic patterns:

- **File size distribution:** Are a few files dramatically larger than the rest?
- **Import fan-in/fan-out:** Files with many importers are high blast-radius targets
- **Change coupling:** Files that always change together may need consolidation
- **Circular dependencies:** Indicate architectural issues requiring module boundary redesign
