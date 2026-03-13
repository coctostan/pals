<overview>
Coverage tool detection and output parsing. Maps frameworks to coverage commands. Extends tdd-execution.md's test command detection.
</overview>

<detection_table>

## Framework → Coverage Command

| Indicator | Framework | Coverage Command |
|-----------|-----------|-----------------|
| package.json (jest) | Jest | `npx jest --coverage --coverageReporters=text` |
| package.json (vitest) | Vitest | `npx vitest run --coverage` |
| package.json (c8) | c8 | `npx c8 npm test` |
| package.json (nyc) | nyc | `npx nyc npm test` |
| pyproject.toml/setup.py | pytest | `pytest --cov --cov-report=term` |
| go.mod | Go | `go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out` |
| Cargo.toml | Rust | `cargo tarpaulin --out stdout` |
| mix.exs | Elixir | `mix test --cover` |
| Makefile (coverage target) | Make | `make coverage` |

**Priority (Node.js):** Check package.json scripts first, then devDeps. jest > vitest > c8 > nyc.

**Scoped:** Jest `-- {path}`, Vitest `{path}`, pytest `--cov={path} {path}`, Go `./{path}/...`

</detection_table>

<output_parsing>

## Parsing Coverage Output

**Jest/Vitest/nyc/c8:** Table with `% Stmts | % Branch | % Funcs | % Lines`. Extract % Stmts (primary). Sort ascending.

**pytest:** `Name | Stmts | Miss | Cover`. Extract Cover %. Sort ascending.

**Go:** `file:line: FuncName XX.X%`. Aggregate by file. `total: (statements) XX.X%`.

**Rust (tarpaulin):** `src/file.rs: 15/20 75.00%`. Final line: `XX.XX% coverage, N/M lines`.

**Elixir:** `Percentage | Module` table. `Total` line.

</output_parsing>

<fallback>

## Fallback

1. Check Makefile for `coverage`/`test-coverage` target
2. Check for `.nycrc`, `.c8rc`, `jest.config.*`, `vitest.config.*`
3. Ask user: "No coverage tool detected. What command runs coverage?"

</fallback>

<coverage_thresholds>

## Coverage Interpretation (advisory, not enforced)

| Range | Label |
|-------|-------|
| 80%+ | Good |
| 50-79% | Partial (improvement opportunity) |
| 1-49% | Low (flagged) |
| 0% | Untested |

</coverage_thresholds>
