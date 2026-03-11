<overview>
Quality tool detection heuristics for WALT. Scans project files to identify test frameworks, linters, type checkers, and formatters — zero config required.

**Philosophy:** Use what the project already has. Don't impose tools. If nothing is detected, skip gracefully.

**Core principle:** Detection is file-based. If a config file or dependency exists, the tool is available. No guessing, no defaults.
</overview>

<detection_matrix>

## JavaScript / TypeScript

**Config files to scan:** `package.json`, `tsconfig.json`, `.eslintrc.*`, `eslint.config.*`, `biome.json`, `biome.jsonc`, `.prettierrc*`, `prettier.config.*`, `jest.config.*`, `vitest.config.*`, `playwright.config.*`, `cypress.config.*`

### Test Frameworks

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| vitest | `vitest` in package.json devDependencies, or `vitest.config.*` exists | `npx vitest run` | Exit 0 = pass, exit 1 = failures. Outputs test count summary. |
| jest | `jest` in package.json devDependencies, or `jest.config.*` exists | `npx jest --passWithNoTests` | Exit 0 = pass, exit 1 = failures. JSON output with `--json`. |
| mocha | `mocha` in package.json devDependencies | `npx mocha` | Exit 0 = pass, exit code = failure count. |
| playwright | `@playwright/test` in package.json devDependencies, or `playwright.config.*` exists | `npx playwright test` | Exit 0 = pass. Reports test/pass/fail counts. |
| cypress | `cypress` in package.json devDependencies, or `cypress.config.*` exists | `npx cypress run` | Exit 0 = pass. Video/screenshot artifacts. |

**Priority:** vitest > jest > mocha (if multiple found, prefer first match)

### Linters

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| eslint | `eslint` in devDependencies, or `.eslintrc.*`/`eslint.config.*` exists | `npx eslint . --max-warnings=0` | Exit 0 = clean, exit 1 = errors/warnings. JSON with `-f json`. |
| biome | `@biomejs/biome` in devDependencies, or `biome.json`/`biome.jsonc` exists | `npx biome check .` | Exit 0 = clean, exit 1 = issues found. |

**Priority:** biome > eslint (biome replaces eslint in projects that use it)

### Type Checkers

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| tsc | `tsconfig.json` exists | `npx tsc --noEmit` | Exit 0 = clean, exit 1 = type errors. Outputs file:line:col messages. |

### Formatters

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| prettier | `prettier` in devDependencies, or `.prettierrc*`/`prettier.config.*` exists | `npx prettier --check .` | Exit 0 = formatted, exit 1 = unformatted files. |
| biome | (same as linter detection) | `npx biome format .` | Exit 0 = formatted, exit 1 = unformatted. |

**Priority:** biome > prettier (if biome handles both linting and formatting)

**Auto-fix commands:**
- prettier: `npx prettier --write .`
- biome: `npx biome format --write .`
- eslint: `npx eslint . --fix`
- biome lint: `npx biome check --fix .`

### Coverage

| Tool | Detection | Coverage Command | Output |
|------|-----------|-----------------|--------|
| vitest | `@vitest/coverage-v8` or `@vitest/coverage-istanbul` in devDependencies | `npx vitest run --coverage` | Summary table with % per file. `All files \| XX.XX` line. |
| jest | `jest` in devDependencies (built-in support) | `npx jest --coverage` | Summary table with % per file. `All files \| XX.XX` line. |
| c8 | `c8` in devDependencies | `npx c8 [test command]` | Summary with %. Works with any test runner. |

**Zero-config:** Only include coverage if a coverage tool/plugin is detected in devDependencies. If none found, omit — do NOT suggest installing one.

---

## Python

**Config files to scan:** `pyproject.toml`, `setup.py`, `setup.cfg`, `requirements.txt`, `requirements-dev.txt`, `tox.ini`, `mypy.ini`, `.flake8`, `ruff.toml`, `.ruff.toml`

### Test Frameworks

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| pytest | `pytest` in pyproject.toml dependencies/dev-dependencies, or `pytest` in requirements*.txt, or `conftest.py` exists | `python -m pytest` | Exit 0 = pass, exit 1 = failures. Summary line: "X passed, Y failed". |
| unittest | `test_*.py` files exist with no pytest config | `python -m unittest discover` | Exit 0 = pass, exit 1 = failures. |

**Priority:** pytest > unittest

### Linters

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| ruff | `ruff` in pyproject.toml or requirements*.txt, or `ruff.toml`/`.ruff.toml` exists | `ruff check .` | Exit 0 = clean, exit 1 = violations. |
| flake8 | `flake8` in requirements*.txt, or `.flake8` exists | `flake8 .` | Exit 0 = clean, exit 1 = violations. |
| pylint | `pylint` in requirements*.txt | `pylint src/` | Exit code encodes message types. 0 = clean. |

**Priority:** ruff > flake8 > pylint

### Type Checkers

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| mypy | `mypy` in pyproject.toml or requirements*.txt, or `mypy.ini` exists | `mypy .` | Exit 0 = clean, exit 1 = type errors. |
| pyright | `pyright` in requirements*.txt or package.json devDependencies, or `pyrightconfig.json` exists | `pyright` | Exit 0 = clean, exit 1 = errors. |

**Priority:** mypy > pyright (use whichever is configured)

### Formatters

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| black | `black` in pyproject.toml or requirements*.txt | `black --check .` | Exit 0 = formatted, exit 1 = unformatted. |
| ruff format | (same as ruff linter detection) | `ruff format --check .` | Exit 0 = formatted, exit 1 = unformatted. |

**Priority:** ruff format > black (ruff replaces black in projects that use it)

**Auto-fix commands:**
- ruff: `ruff check --fix .`
- ruff format: `ruff format .`
- black: `black .`

### Coverage

| Tool | Detection | Coverage Command | Output |
|------|-----------|-----------------|--------|
| pytest-cov | `pytest-cov` in pyproject.toml or requirements*.txt | `python -m pytest --cov=. --cov-report=term` | Summary with % per file. `TOTAL` line with overall %. |
| coverage.py | `coverage` in pyproject.toml or requirements*.txt | `coverage run -m pytest && coverage report` | Summary with %. `TOTAL` line. |

**Zero-config:** Only include coverage if pytest-cov or coverage.py is detected. If none found, omit.

---

## Rust

**Config files to scan:** `Cargo.toml`, `clippy.toml`, `.clippy.toml`, `rustfmt.toml`, `.rustfmt.toml`

### Test Frameworks

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| cargo test | `Cargo.toml` exists | `cargo test` | Exit 0 = pass, exit 101 = failures. Outputs "test result: ok/FAILED". |

### Linters

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| clippy | `Cargo.toml` exists (clippy ships with rustup) | `cargo clippy -- -D warnings` | Exit 0 = clean, exit 101 = warnings/errors. |

### Type Checkers

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| cargo check | `Cargo.toml` exists | `cargo check` | Exit 0 = compiles, exit 101 = errors. |

### Formatters

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| rustfmt | `Cargo.toml` exists (rustfmt ships with rustup) | `cargo fmt --check` | Exit 0 = formatted, exit 1 = unformatted. |

**Auto-fix commands:**
- rustfmt: `cargo fmt`
- clippy: `cargo clippy --fix --allow-dirty`

### Coverage

| Tool | Detection | Coverage Command | Output |
|------|-----------|-----------------|--------|
| cargo-tarpaulin | `cargo-tarpaulin` installed (check `cargo tarpaulin --version`) | `cargo tarpaulin --out stdout` | Summary with `XX.XX% coverage`. |
| cargo-llvm-cov | `cargo-llvm-cov` installed (check `cargo llvm-cov --version`) | `cargo llvm-cov` | Summary with % per file. |

**Zero-config:** Only include coverage if tarpaulin or llvm-cov is installed. If neither found, omit.

---

## Go

**Config files to scan:** `go.mod`, `.golangci.yml`, `.golangci.yaml`, `.golangci.toml`

### Test Frameworks

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| go test | `go.mod` exists | `go test ./...` | Exit 0 = pass, exit 1 = failures. Outputs "ok" or "FAIL" per package. |

### Linters

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| golangci-lint | `.golangci.yml`/`.golangci.yaml`/`.golangci.toml` exists | `golangci-lint run` | Exit 0 = clean, exit 1 = issues. |
| go vet | `go.mod` exists (built-in) | `go vet ./...` | Exit 0 = clean, exit 1 = issues. |

**Priority:** golangci-lint > go vet (golangci-lint includes vet)

### Type Checkers

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| go vet | `go.mod` exists | `go vet ./...` | Exit 0 = clean. Catches type-adjacent issues. |

### Formatters

| Tool | Detection | Run Command | Result |
|------|-----------|-------------|--------|
| gofmt | `go.mod` exists (built-in) | `gofmt -l .` | Empty output = formatted, file list = unformatted. |
| goimports | `golang.org/x/tools` in go.sum | `goimports -l .` | Empty output = formatted, file list = unformatted. |

**Priority:** goimports > gofmt (goimports is a superset)

**Auto-fix commands:**
- gofmt: `gofmt -w .`
- goimports: `goimports -w .`

### Coverage

| Tool | Detection | Coverage Command | Output |
|------|-----------|-----------------|--------|
| go test | `go.mod` exists (built-in) | `go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out` | Per-function %. `total:` line with overall %. |

**Zero-config:** Go coverage is built-in — always available when `go.mod` exists.

</detection_matrix>

<quality_profile>

## Quality Profile Output Format

After scanning a project, produce a structured quality profile:

```yaml
ecosystem: [javascript|python|rust|go]
detected_via: [primary config file that identified the ecosystem]
tools:
  test:
    name: [tool name]
    command: [run command]
    coverage_command: [coverage command]  # optional — only if coverage tool detected
    auto_fix: false
    detected_via: [config file or dependency]
  lint:
    name: [tool name]
    command: [run command]
    auto_fix: [fix command]
    detected_via: [config file or dependency]
  typecheck:
    name: [tool name]
    command: [run command]
    auto_fix: false
    detected_via: [config file or dependency]
  format:
    name: [tool name]
    command: [check command]
    auto_fix: [fix command]
    detected_via: [config file or dependency]
```

**Missing tools:** If a category has no detected tool, omit it from the profile. Do not invent defaults.

**Multiple ecosystems:** Some projects (e.g., a Python backend with a JS frontend) may have multiple profiles. Detect all, report all.

### Example: Node.js project with vitest + eslint + TypeScript + prettier

```yaml
ecosystem: javascript
detected_via: package.json
tools:
  test:
    name: vitest
    command: "npx vitest run"
    coverage_command: "npx vitest run --coverage"  # only if @vitest/coverage-v8 detected
    auto_fix: false
    detected_via: "vitest in package.json devDependencies"
  lint:
    name: eslint
    command: "npx eslint . --max-warnings=0"
    auto_fix: "npx eslint . --fix"
    detected_via: "eslint.config.js"
  typecheck:
    name: tsc
    command: "npx tsc --noEmit"
    auto_fix: false
    detected_via: "tsconfig.json"
  format:
    name: prettier
    command: "npx prettier --check ."
    auto_fix: "npx prettier --write ."
    detected_via: ".prettierrc"
```

### Example: Rust project

```yaml
ecosystem: rust
detected_via: Cargo.toml
tools:
  test:
    name: cargo test
    command: "cargo test"
    auto_fix: false
    detected_via: "Cargo.toml"
  lint:
    name: clippy
    command: "cargo clippy -- -D warnings"
    auto_fix: "cargo clippy --fix --allow-dirty"
    detected_via: "Cargo.toml"
  typecheck:
    name: cargo check
    command: "cargo check"
    auto_fix: false
    detected_via: "Cargo.toml"
  format:
    name: rustfmt
    command: "cargo fmt --check"
    auto_fix: "cargo fmt"
    detected_via: "Cargo.toml"
```

</quality_profile>

<detection_priority>

## Detection Priority Rules

When multiple tools in the same category are detected:

1. **Use the more modern/comprehensive tool:**
   - biome > eslint (biome replaces eslint)
   - ruff > flake8 > pylint (ruff replaces both)
   - vitest > jest > mocha (vitest is newer, faster)
   - goimports > gofmt (goimports is a superset)
   - ruff format > black (ruff replaces black)

2. **Respect explicit configuration:**
   - If a project has both eslint and biome configs, check package.json scripts for which is actively used
   - If `"lint": "eslint ."` in scripts → eslint is primary despite biome.json existing

3. **Never run both tools in the same category.** Pick one per priority rules.

</detection_priority>

<fallback_behavior>

## Fallback Behavior

**No tools detected for a category:**
- Skip that category silently
- Do not suggest installing tools
- Do not block workflow execution

**No ecosystem detected:**
- Report: "No recognized project configuration found"
- Skip all quality checks
- WALT is a no-op — does not interfere with PAUL's normal operation

**Partial detection:**
- Run whatever is detected, skip what's missing
- Example: project has tests but no linter → run tests only

**Detection errors:**
- If a detected tool fails to run (not installed, broken config): warn and skip
- Do not retry or attempt to fix tool configuration
- Log: "WALT: {tool} detected but failed to run — skipping"

</fallback_behavior>

<ecosystem_detection>

## Ecosystem Detection Order

Scan for ecosystem markers in this order:

1. `package.json` → JavaScript/TypeScript
2. `Cargo.toml` → Rust
3. `go.mod` → Go
4. `pyproject.toml` → Python
5. `setup.py` or `setup.cfg` → Python (legacy)
6. `requirements.txt` → Python (minimal)

**Multi-ecosystem projects:** If multiple markers exist (e.g., `package.json` + `pyproject.toml`), detect and profile all. Each ecosystem gets its own quality profile.

**Monorepos:** Scan from project root. If tools are configured at root level, use those. Do not recurse into subdirectories looking for nested configs unless the root config explicitly references them.

</ecosystem_detection>
