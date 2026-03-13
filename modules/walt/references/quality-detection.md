<overview>
Quality tool detection heuristics. Scans project files to identify test frameworks, linters, type checkers, and formatters. Use what the project already has — don't impose tools. Detection is file-based: config file or dependency exists = tool available.
</overview>

<detection_matrix>

## JavaScript / TypeScript

**Config files:** `package.json`, `tsconfig.json`, `.eslintrc.*`, `eslint.config.*`, `biome.json`, `.prettierrc*`, `jest.config.*`, `vitest.config.*`, `playwright.config.*`, `cypress.config.*`

| Category | Tool | Detection | Run Command | Auto-Fix |
|----------|------|-----------|-------------|----------|
| Test | vitest | `vitest` in devDeps or `vitest.config.*` | `npx vitest run` | — |
| Test | jest | `jest` in devDeps or `jest.config.*` | `npx jest --passWithNoTests` | — |
| Test | playwright | `@playwright/test` in devDeps | `npx playwright test` | — |
| Lint | biome | `@biomejs/biome` in devDeps or `biome.json` | `npx biome check .` | `npx biome check --fix .` |
| Lint | eslint | `eslint` in devDeps or `.eslintrc.*` | `npx eslint . --max-warnings=0` | `npx eslint . --fix` |
| Types | tsc | `tsconfig.json` exists | `npx tsc --noEmit` | — |
| Format | biome | (same as lint) | `npx biome format .` | `npx biome format --write .` |
| Format | prettier | `prettier` in devDeps or `.prettierrc*` | `npx prettier --check .` | `npx prettier --write .` |
| Coverage | vitest | `@vitest/coverage-v8` or `-istanbul` in devDeps | `npx vitest run --coverage` | — |
| Coverage | jest | `jest` in devDeps (built-in) | `npx jest --coverage` | — |

**Priority:** vitest > jest > mocha; biome > eslint; biome > prettier. Only include coverage if coverage tool detected in devDeps.

## Python

**Config files:** `pyproject.toml`, `setup.py`, `setup.cfg`, `requirements*.txt`, `tox.ini`, `mypy.ini`, `.flake8`, `ruff.toml`

| Category | Tool | Detection | Run Command | Auto-Fix |
|----------|------|-----------|-------------|----------|
| Test | pytest | `pytest` in deps/requirements or `conftest.py` | `python -m pytest` | — |
| Test | unittest | `test_*.py` files, no pytest | `python -m unittest discover` | — |
| Lint | ruff | `ruff` in deps or `ruff.toml` | `ruff check .` | `ruff check --fix .` |
| Lint | flake8 | `flake8` in requirements or `.flake8` | `flake8 .` | — |
| Types | mypy | `mypy` in deps or `mypy.ini` | `mypy .` | — |
| Types | pyright | `pyright` in deps or `pyrightconfig.json` | `pyright` | — |
| Format | ruff | (same as lint) | `ruff format --check .` | `ruff format .` |
| Format | black | `black` in deps | `black --check .` | `black .` |
| Coverage | pytest-cov | `pytest-cov` in deps | `python -m pytest --cov=. --cov-report=term` | — |

**Priority:** pytest > unittest; ruff > flake8 > pylint; mypy > pyright; ruff format > black.

## Rust

**Config files:** `Cargo.toml`, `clippy.toml`, `rustfmt.toml`

| Category | Tool | Detection | Run Command | Auto-Fix |
|----------|------|-----------|-------------|----------|
| Test | cargo test | `Cargo.toml` exists | `cargo test` | — |
| Lint | clippy | `Cargo.toml` exists | `cargo clippy -- -D warnings` | `cargo clippy --fix --allow-dirty` |
| Types | cargo check | `Cargo.toml` exists | `cargo check` | — |
| Format | rustfmt | `Cargo.toml` exists | `cargo fmt --check` | `cargo fmt` |
| Coverage | tarpaulin | `cargo tarpaulin --version` works | `cargo tarpaulin --out stdout` | — |

## Go

**Config files:** `go.mod`, `.golangci.yml`

| Category | Tool | Detection | Run Command | Auto-Fix |
|----------|------|-----------|-------------|----------|
| Test | go test | `go.mod` exists | `go test ./...` | — |
| Lint | golangci-lint | `.golangci.yml` exists | `golangci-lint run` | — |
| Lint | go vet | `go.mod` exists (built-in) | `go vet ./...` | — |
| Types | go vet | `go.mod` exists | `go vet ./...` | — |
| Format | goimports | `golang.org/x/tools` in go.sum | `goimports -l .` | `goimports -w .` |
| Format | gofmt | `go.mod` exists | `gofmt -l .` | `gofmt -w .` |
| Coverage | go test | `go.mod` exists (built-in) | `go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out` | — |

**Priority:** golangci-lint > go vet; goimports > gofmt.

</detection_matrix>

<quality_profile>

## Quality Profile Output

After scanning, produce a structured profile:

```yaml
ecosystem: [javascript|python|rust|go]
detected_via: [primary config file]
tools:
  test:
    name: [tool]
    command: [run command]
    coverage_command: [optional — only if detected]
    auto_fix: false
    detected_via: [config/dependency]
  lint:
    name: [tool]
    command: [run command]
    auto_fix: [fix command]
    detected_via: [config/dependency]
  typecheck: { ... }
  format: { ... }
```

**Missing tools:** Omit category from profile. Don't invent defaults.
**Multiple ecosystems:** Detect all, profile all separately.

</quality_profile>

<detection_priority>

## Priority Rules

1. Prefer modern/comprehensive: biome > eslint, ruff > flake8, vitest > jest, goimports > gofmt
2. Respect explicit config: if `"lint": "eslint ."` in package.json scripts, eslint is primary despite biome.json
3. Never run both tools in the same category

</detection_priority>

<fallback_behavior>

## Fallback

- **No tools for a category:** Skip silently. Do NOT suggest installing tools — use what the project has.
- **No ecosystem detected:** Report "No recognized project configuration found". WALT is a no-op — do NOT block workflow.
- **Partial detection:** Run what's detected, skip what's missing.
- **Detection errors:** Warn and skip: "WALT: {tool} detected but failed to run — skipping". Do NOT retry or fix tool configuration.

</fallback_behavior>

<ecosystem_detection>

## Ecosystem Detection Order

1. `package.json` → JS/TS  2. `Cargo.toml` → Rust  3. `go.mod` → Go  4. `pyproject.toml` → Python  5. `setup.py`/`setup.cfg` → Python  6. `requirements.txt` → Python

**Multi-ecosystem:** Detect and profile all. **Monorepos:** Scan from root, don't recurse unless root config references subdirs.

</ecosystem_detection>
