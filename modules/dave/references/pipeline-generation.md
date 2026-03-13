# Pipeline Generation

Templates and heuristics for generating CI/CD pipeline configurations based on project structure.

## Project Detection

### Language Detection Heuristics

| Indicator File | Language/Framework | Pipeline Template |
|---------------|-------------------|-------------------|
| `package.json` | Node.js | node-ci |
| `package-lock.json` | Node.js (npm) | node-ci (npm) |
| `yarn.lock` | Node.js (yarn) | node-ci (yarn) |
| `pnpm-lock.yaml` | Node.js (pnpm) | node-ci (pnpm) |
| `pyproject.toml` | Python | python-ci |
| `requirements.txt` | Python (pip) | python-ci (pip) |
| `Pipfile` | Python (pipenv) | python-ci (pipenv) |
| `go.mod` | Go | go-ci |
| `Cargo.toml` | Rust | rust-ci |
| `Gemfile` | Ruby | ruby-ci |
| `pom.xml` | Java (Maven) | java-ci (maven) |
| `build.gradle` | Java/Kotlin (Gradle) | java-ci (gradle) |

### Framework Detection

| Indicator | Framework | Additional Steps |
|-----------|-----------|-----------------|
| `next.config.*` | Next.js | Build + SSR deploy |
| `vite.config.*` | Vite | Build + static deploy |
| `Dockerfile` | Docker | Container build + push |
| `docker-compose.yml` | Docker Compose | Multi-service orchestration |
| `serverless.yml` | Serverless Framework | Function deploy |
| `vercel.json` | Vercel | Vercel CLI deploy |
| `netlify.toml` | Netlify | Netlify CLI deploy |

### CI Platform Detection

| Indicator | Platform |
|-----------|----------|
| `.github/workflows/` | GitHub Actions (existing) |
| `.gitlab-ci.yml` | GitLab CI (existing) |
| `.circleci/config.yml` | CircleCI (existing) |
| `Jenkinsfile` | Jenkins (existing) |
| `.github/` directory | GitHub (generate Actions) |
| Default | GitHub Actions (most common) |

## GitHub Actions Templates

### Node.js

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: '{package-manager}'
      - run: {install-command}
      - run: {lint-command}
      - run: {test-command}

  build:
    needs: lint-and-test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: '{package-manager}'
      - run: {install-command}
      - run: {build-command}
```

### Python

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      - run: {install-command}
      - run: {lint-command}
      - run: {test-command}
```

### Go

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with:
          go-version: '1.22'
      - run: go vet ./...
      - run: go test ./...

  build:
    needs: lint-and-test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with:
          go-version: '1.22'
      - run: go build ./...
```

### Rust

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
        with:
          components: clippy, rustfmt
      - run: cargo fmt --check
      - run: cargo clippy -- -D warnings
      - run: cargo test
```

## GitLab CI Templates

### Node.js

```yaml
stages:
  - lint
  - test
  - build

lint:
  stage: lint
  image: node:20
  script:
    - {install-command}
    - {lint-command}

test:
  stage: test
  image: node:20
  script:
    - {install-command}
    - {test-command}

build:
  stage: build
  image: node:20
  script:
    - {install-command}
    - {build-command}
  artifacts:
    paths:
      - dist/
```

## Generation Strategy

1. **Detect project** — scan for indicator files to determine language, framework, package manager
2. **Detect CI platform** — check for existing configs or default to GitHub Actions
3. **Select template** — match language + platform to template
4. **Customize stages** — fill in package manager commands, build scripts from package.json/pyproject.toml
5. **Add caching** — configure dependency caching for the detected package manager
6. **Write config** — generate the pipeline file at the correct path

## Best Practices

### Caching
- Cache dependency directories (node_modules, .venv, target/)
- Use lock file hash as cache key
- Separate cache per branch for isolation

### Matrix Builds
- Test against multiple runtime versions when supporting them
- Test on multiple OS if targeting cross-platform

### Reusable Workflows
- Extract common steps into reusable workflows/templates
- Share across repositories via organization-level configs
