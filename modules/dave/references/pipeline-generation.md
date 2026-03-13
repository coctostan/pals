# Pipeline Generation

Templates and heuristics for CI/CD pipeline generation based on project structure.

## Project Detection

### Language Detection

| Indicator File | Language | Template |
|---------------|----------|----------|
| `package.json` | Node.js | node-ci |
| `package-lock.json`/`yarn.lock`/`pnpm-lock.yaml` | Node.js (npm/yarn/pnpm) | node-ci |
| `pyproject.toml`/`requirements.txt`/`Pipfile` | Python | python-ci |
| `go.mod` | Go | go-ci |
| `Cargo.toml` | Rust | rust-ci |
| `Gemfile` | Ruby | ruby-ci |
| `pom.xml`/`build.gradle` | Java | java-ci |

### Framework Detection

| Indicator | Framework | Additional Steps |
|-----------|-----------|-----------------|
| `next.config.*` | Next.js | Build + SSR deploy |
| `vite.config.*` | Vite | Build + static deploy |
| `Dockerfile` | Docker | Container build + push |
| `serverless.yml` | Serverless | Function deploy |
| `vercel.json`/`netlify.toml` | Vercel/Netlify | CLI deploy |

### CI Platform Detection

| Indicator | Platform |
|-----------|----------|
| `.github/workflows/` | GitHub Actions (existing) |
| `.gitlab-ci.yml` | GitLab CI |
| `.circleci/config.yml` | CircleCI |
| `Jenkinsfile` | Jenkins |
| Default | GitHub Actions |

## GitHub Actions Templates

### Node.js
```yaml
name: CI
on:
  push: { branches: [main] }
  pull_request: { branches: [main] }
jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: '{pkg-mgr}' }
      - run: {install}
      - run: {lint}
      - run: {test}
  build:
    needs: lint-and-test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: '{pkg-mgr}' }
      - run: {install}
      - run: {build}
```

### Python
```yaml
name: CI
on:
  push: { branches: [main] }
  pull_request: { branches: [main] }
jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: '3.12' }
      - run: {install}
      - run: {lint}
      - run: {test}
```

### Go
```yaml
name: CI
on:
  push: { branches: [main] }
  pull_request: { branches: [main] }
jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with: { go-version: '1.22' }
      - run: go vet ./...
      - run: go test ./...
  build:
    needs: lint-and-test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with: { go-version: '1.22' }
      - run: go build ./...
```

### Rust
```yaml
name: CI
on:
  push: { branches: [main] }
  pull_request: { branches: [main] }
jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
        with: { components: 'clippy, rustfmt' }
      - run: cargo fmt --check
      - run: cargo clippy -- -D warnings
      - run: cargo test
```

## GitLab CI Template (Node.js)

```yaml
stages: [lint, test, build]
lint:  { stage: lint,  image: 'node:20', script: ['{install}', '{lint}'] }
test:  { stage: test,  image: 'node:20', script: ['{install}', '{test}'] }
build: { stage: build, image: 'node:20', script: ['{install}', '{build}'], artifacts: { paths: ['dist/'] } }
```

## Generation Strategy

1. Detect language, framework, package manager from indicator files
2. Detect CI platform (existing config or default GitHub Actions)
3. Select + customize template (fill commands from package.json/pyproject.toml)
4. Add dependency caching (lock file hash as key, separate per branch)
5. Write config to correct path

## Best Practices

- **Caching:** Cache deps (node_modules, .venv, target/), lock file hash as key
- **Matrix builds:** Multiple runtime versions if supported; multi-OS if cross-platform
- **Reusable workflows:** Extract common steps; share via org-level configs
