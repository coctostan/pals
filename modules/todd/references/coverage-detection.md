<overview>
Coverage tool detection and invocation for test coverage analysis. Maps project frameworks
to their coverage commands and provides output parsing guidance.

**Extends:** tdd-execution.md's detect_test_command step with coverage-specific flags.
**Used by:** /paul:coverage command for framework detection and coverage invocation.
</overview>

<detection_table>

## Framework → Coverage Command

Detection follows the same framework indicator files as tdd-execution.md's test command
detection, but maps to coverage-specific invocations.

| Indicator File | Framework | Coverage Command |
|---------------|-----------|-----------------|
| `package.json` (jest in deps/devDeps/scripts) | Jest | `npx jest --coverage --coverageReporters=text` |
| `package.json` (vitest in deps/devDeps) | Vitest | `npx vitest run --coverage` |
| `package.json` (c8 in deps/devDeps) | c8 | `npx c8 npm test` |
| `package.json` (nyc in deps/devDeps) | nyc/Istanbul | `npx nyc npm test` |
| `pyproject.toml` or `setup.py` | pytest | `pytest --cov --cov-report=term` |
| `go.mod` | Go | `go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out` |
| `Cargo.toml` | Rust (tarpaulin) | `cargo tarpaulin --out stdout` |
| `mix.exs` | Elixir | `mix test --cover` |
| `Makefile` (coverage target) | Make | `make coverage` |

### Detection Priority

When multiple indicators exist (e.g., package.json with both jest and vitest):

1. Check `package.json` scripts for explicit `test` or `coverage` script
2. Check `devDependencies` for test runner (jest, vitest, mocha, etc.)
3. Check `dependencies` as fallback
4. For Node.js projects: jest > vitest > c8 > nyc (by prevalence)

### Directory-Scoped Coverage

When user provides a target directory or file as argument:

| Framework | Scoped Command |
|-----------|---------------|
| Jest | `npx jest --coverage --coverageReporters=text -- {path}` |
| Vitest | `npx vitest run --coverage {path}` |
| pytest | `pytest --cov={path} --cov-report=term {path}` |
| Go | `go test -coverprofile=coverage.out ./{path}/... && go tool cover -func=coverage.out` |

</detection_table>

<output_parsing>

## Parsing Coverage Output

Each framework produces text output with per-file coverage. The key data to extract:

### Jest / Vitest / nyc / c8
Text reporter produces a table:
```
----------|---------|----------|---------|---------|
File      | % Stmts | % Branch | % Funcs | % Lines |
----------|---------|----------|---------|---------|
All files |   75.5  |    60.2  |   80.0  |   74.8  |
 src/     |         |          |         |         |
  foo.ts  |  100.0  |   100.0  |  100.0  |  100.0  |
  bar.ts  |   45.0  |    30.0  |   50.0  |   44.0  |
----------|---------|----------|---------|---------|
```

**Extract:** File path, % Stmts (primary metric), % Lines (secondary).
**Sort by:** % Stmts ascending (lowest coverage first).

### pytest (--cov-report=term)
```
Name                      Stmts   Miss  Cover
---------------------------------------------
src/module.py                50     10    80%
src/utils.py                 30     30     0%
---------------------------------------------
TOTAL                        80     40    50%
```

**Extract:** Name, Cover %.
**Sort by:** Cover % ascending.

### Go (go tool cover -func)
```
github.com/user/pkg/foo.go:10:  FuncA    100.0%
github.com/user/pkg/bar.go:25:  FuncB     0.0%
total:                          (statements) 65.0%
```

**Extract:** File path (strip module prefix), percentage.
**Aggregate:** Group by file, average function coverage per file.
**Sort by:** Average % ascending.

### Rust (cargo tarpaulin)
```
|| Tested/Total Lines:
|| src/lib.rs: 15/20 75.00%
|| src/utils.rs: 0/10 0.00%
||
|| 75.00% coverage, 15/30 lines covered
```

**Extract:** File path, percentage.
**Sort by:** Percentage ascending.

### Elixir (mix test --cover)
```
Generating cover results ...

Percentage | Module
-----------|--------------------------
   100.00% | MyApp.Foo
    50.00% | MyApp.Bar
-----------|--------------------------
    75.00% | Total
```

**Extract:** Module name, percentage.
**Sort by:** Percentage ascending.

</output_parsing>

<fallback>

## Fallback: No Framework Detected

If no recognized framework indicator file is found:

1. Check for a `Makefile` with a `coverage` or `test-coverage` target
2. Check for `.nycrc`, `.c8rc`, `jest.config.*`, `vitest.config.*` config files
3. If still nothing: ask user for their coverage command
   ```
   No coverage tool detected automatically.
   What command runs your test coverage? (e.g., "npm run coverage")
   ```

</fallback>

<coverage_thresholds>

## Coverage Interpretation

These thresholds are advisory for dashboard presentation, not enforcement:

| Range | Label | Dashboard Indicator |
|-------|-------|-------------------|
| 80%+  | Good  | File listed normally |
| 50-79% | Partial | File highlighted as improvement opportunity |
| 1-49% | Low   | File flagged for attention |
| 0%    | Untested | File listed in "Untested Files" section |

</coverage_thresholds>
