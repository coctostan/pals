<overview>
CI workflow generation from WALT's quality profile. Maps detected tools to GitHub Actions workflow steps — same commands, same checks, same standards.

**Philosophy:** CI mirrors local. If WALT runs it during apply, CI runs it on every push. No extra tools, no divergence.

**Core principle:** Opt-in generation. User asks Claude to generate CI config. Not automatic during apply.

**Output:** `.github/workflows/quality.yml` — single workflow file with steps for each detected tool category.
</overview>

<generation_process>

## How It Works

1. Read the project's quality profile (from quality-detection.md heuristics)
2. Map each detected tool category to a GitHub Actions step
3. Generate `.github/workflows/quality.yml` using the ecosystem template
4. Omit steps for tool categories not detected — no stubs, no placeholders

## Step Mapping

| Quality Profile Field | GitHub Actions Step | Command Source |
|----------------------|--------------------|--------------:|
| `tools.test.command` | "Run tests" | quality-detection.md test runner |
| `tools.test.coverage_command` | "Run coverage" | quality-detection.md coverage |
| `tools.lint.command` | "Lint" | quality-detection.md linter |
| `tools.typecheck.command` | "Type check" | quality-detection.md type checker |
| `tools.format.command` | "Check formatting" | quality-detection.md formatter |

**Omission rule:** If a tool category is not in the quality profile, omit the step entirely. Do not add `continue-on-error: true` or comment placeholders.

</generation_process>

<templates>

## JavaScript / TypeScript

```yaml
name: Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - run: npm ci

      # Include if tools.test detected:
      - name: Run tests
        run: {tools.test.command}

      # Include if tools.test.coverage_command detected:
      - name: Run coverage
        run: {tools.test.coverage_command}

      # Include if tools.lint detected:
      - name: Lint
        run: {tools.lint.command}

      # Include if tools.typecheck detected:
      - name: Type check
        run: {tools.typecheck.command}

      # Include if tools.format detected:
      - name: Check formatting
        run: {tools.format.command}
```

### Example: vitest + eslint + tsc + prettier

```yaml
name: Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - run: npm ci

      - name: Run tests
        run: npx vitest run

      - name: Lint
        run: npx eslint . --max-warnings=0

      - name: Type check
        run: npx tsc --noEmit

      - name: Check formatting
        run: npx prettier --check .
```

### Example: vitest + eslint + tsc + prettier + coverage

```yaml
name: Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - run: npm ci

      - name: Run tests
        run: npx vitest run

      - name: Run coverage
        run: npx vitest run --coverage

      - name: Lint
        run: npx eslint . --max-warnings=0

      - name: Type check
        run: npx tsc --noEmit

      - name: Check formatting
        run: npx prettier --check .
```

---

## Python

```yaml
name: Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
          cache: pip

      - run: pip install -e ".[dev]"

      # Include if tools.test detected:
      - name: Run tests
        run: {tools.test.command}

      # Include if tools.test.coverage_command detected:
      - name: Run coverage
        run: {tools.test.coverage_command}

      # Include if tools.lint detected:
      - name: Lint
        run: {tools.lint.command}

      # Include if tools.typecheck detected:
      - name: Type check
        run: {tools.typecheck.command}

      # Include if tools.format detected:
      - name: Check formatting
        run: {tools.format.command}
```

### Example: pytest + ruff + mypy

```yaml
name: Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
          cache: pip

      - run: pip install -e ".[dev]"

      - name: Run tests
        run: python -m pytest

      - name: Lint
        run: ruff check .

      - name: Type check
        run: mypy .

      - name: Check formatting
        run: ruff format --check .
```

---

## Rust

```yaml
name: Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: dtolnay/rust-toolchain@stable
        with:
          components: clippy, rustfmt

      # Include if tools.test detected:
      - name: Run tests
        run: {tools.test.command}

      # Include if tools.lint detected:
      - name: Lint
        run: {tools.lint.command}

      # Include if tools.typecheck detected:
      - name: Type check
        run: {tools.typecheck.command}

      # Include if tools.format detected:
      - name: Check formatting
        run: {tools.format.command}
```

### Example: cargo test + clippy + cargo check + rustfmt

```yaml
name: Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: dtolnay/rust-toolchain@stable
        with:
          components: clippy, rustfmt

      - name: Run tests
        run: cargo test

      - name: Lint
        run: cargo clippy -- -D warnings

      - name: Type check
        run: cargo check

      - name: Check formatting
        run: cargo fmt --check
```

---

## Go

```yaml
name: Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-go@v5
        with:
          go-version: stable

      # Include if tools.test detected:
      - name: Run tests
        run: {tools.test.command}

      # Include if tools.test.coverage_command detected:
      - name: Run coverage
        run: {tools.test.coverage_command}

      # Include if tools.lint detected:
      - name: Lint
        run: {tools.lint.command}

      # Include if tools.typecheck detected:
      - name: Type check
        run: {tools.typecheck.command}

      # Include if tools.format detected:
      - name: Check formatting
        run: |
          unformatted=$(gofmt -l .)
          if [ -n "$unformatted" ]; then
            echo "Unformatted files:"
            echo "$unformatted"
            exit 1
          fi
```

### Example: go test + golangci-lint + go vet + gofmt

```yaml
name: Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-go@v5
        with:
          go-version: stable

      - name: Run tests
        run: go test ./...

      - name: Lint
        run: golangci-lint run

      - name: Type check
        run: go vet ./...

      - name: Check formatting
        run: |
          unformatted=$(gofmt -l .)
          if [ -n "$unformatted" ]; then
            echo "Unformatted files:"
            echo "$unformatted"
            exit 1
          fi
```

</templates>

<generation_rules>

## Rules

1. **One workflow file:** Always generate `.github/workflows/quality.yml`. Do not split into multiple workflows.

2. **Single job:** Use one `quality` job with sequential steps. Simpler to understand and debug.

3. **Exact commands:** Use the exact commands from the quality profile. Do not modify, add flags, or "improve" them.

4. **Omit missing categories:** If the quality profile has no `lint` tool, do not include a lint step. No stubs.

5. **No caching beyond defaults:** Use built-in setup action caching (`cache: npm`, `cache: pip`). Do not add custom caching steps.

6. **No matrix builds:** Single runner, single version. Keep it simple. Users can add matrix strategies later if needed.

7. **Trigger on push + PR to main:** Standard default. User can customize after generation.

8. **Coverage as separate step:** If `coverage_command` exists, add it as a distinct step after the test step. Coverage does not replace the test step.

9. **Go format special case:** `gofmt -l .` outputs file list, not exit code. Wrap in shell script that checks for non-empty output.

10. **Python dependency install:** Use `pip install -e ".[dev]"` as default. If `requirements-dev.txt` exists, use `pip install -r requirements-dev.txt` instead. Check project structure.

</generation_rules>

<multi_ecosystem>

## Multi-Ecosystem Projects

If a project has multiple quality profiles (e.g., Python backend + JS frontend):

1. Generate one workflow file with multiple jobs — one per ecosystem
2. Name jobs descriptively: `quality-js`, `quality-python`
3. Each job uses its own setup action and commands
4. Jobs run in parallel (no dependencies between them)

```yaml
name: Quality

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality-js:
    runs-on: ubuntu-latest
    steps:
      # JS/TS setup and quality steps...

  quality-python:
    runs-on: ubuntu-latest
    steps:
      # Python setup and quality steps...
```

</multi_ecosystem>
