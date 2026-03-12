<overview>
Package manager and ecosystem detection for DEAN. Identifies which dependency ecosystems are present in a project by scanning for indicator files.

**Core principle:** Prefer lock files over manifest files for detection accuracy. Lock files confirm the package manager in use; manifest files may be ambiguous (e.g., pyproject.toml could be pip, poetry, or hatch).

**Multi-ecosystem:** Projects often have multiple ecosystems. Detect and report all — don't assume a single package manager.
</overview>

<detection_table>

## Indicator Files

Scan project root (or specified directory) for these files:

| Indicator File | Package Manager | Ecosystem | Priority |
|---------------|----------------|-----------|----------|
| package-lock.json | npm | Node.js | 1 (lock) |
| yarn.lock | yarn | Node.js | 1 (lock) |
| pnpm-lock.yaml | pnpm | Node.js | 1 (lock) |
| package.json | npm* | Node.js | 2 (manifest) |
| requirements.txt | pip | Python | 2 (manifest) |
| poetry.lock | poetry | Python | 1 (lock) |
| Pipfile.lock | pipenv | Python | 1 (lock) |
| pyproject.toml | pip/poetry** | Python | 3 (ambiguous) |
| Pipfile | pipenv | Python | 2 (manifest) |
| go.sum | go | Go | 1 (lock) |
| go.mod | go | Go | 2 (manifest) |
| Cargo.lock | cargo | Rust | 1 (lock) |
| Cargo.toml | cargo | Rust | 2 (manifest) |
| Gemfile.lock | bundler | Ruby | 1 (lock) |
| Gemfile | bundler | Ruby | 2 (manifest) |
| mix.lock | mix | Elixir | 1 (lock) |
| mix.exs | mix | Elixir | 2 (manifest) |
| composer.lock | composer | PHP | 1 (lock) |
| composer.json | composer | PHP | 2 (manifest) |
| build.gradle | gradle | Java/Kotlin | 2 (manifest) |
| build.gradle.kts | gradle | Java/Kotlin | 2 (manifest) |
| pom.xml | maven | Java | 2 (manifest) |

*npm is default when only package.json exists without a lock file.
**pyproject.toml: check for `[tool.poetry]` section → poetry; otherwise assume pip.

</detection_table>

<detection_logic>

## Detection Logic

### Step 1: Scan for indicator files
```
Glob for all indicator files in project root (or $ARGUMENTS directory).
```

### Step 2: Resolve ambiguities
- **Node.js:** Lock file determines manager. If only package.json, default to npm.
- **Python:** Poetry lock → poetry. Pipfile → pipenv. pyproject.toml with `[tool.poetry]` → poetry. Otherwise → pip.
- **Java:** build.gradle → gradle. pom.xml → maven. Both present → gradle (build.gradle takes precedence).

### Step 3: Deduplicate ecosystems
- One detection per ecosystem (don't report npm AND yarn for same Node.js project)
- Lock file wins over manifest file for same ecosystem
- Report multiple ecosystems if genuinely different (e.g., Node.js + Python)

### Step 4: Return detected ecosystems
For each detected ecosystem, return:
- Ecosystem name (e.g., "Node.js")
- Package manager (e.g., "npm")
- Lock file path (if found)
- Manifest file path

</detection_logic>

<lock_file_preference>

## Lock File Preference

Lock files provide more accurate dependency information:

| Advantage | Lock File | Manifest Only |
|-----------|-----------|---------------|
| Exact versions | ✓ | ✗ (ranges) |
| Transitive deps | ✓ | ✗ |
| Reproducible | ✓ | ✗ |
| Dep count accuracy | High | Low (direct only) |

**When no lock file exists:**
- Still detect and audit using manifest
- Note in output: "No lock file — dependency count may be approximate"
- Suggest: "Run {install_command} to generate a lock file for accurate auditing"

</lock_file_preference>

<monorepo_handling>

## Monorepo Handling

For monorepo projects with multiple package managers:

1. **Root-level detection:** Always scan project root first
2. **Subdirectory scanning:** If $ARGUMENTS specifies a subdirectory, scan only that path
3. **Multiple ecosystems:** Report each ecosystem separately in the dashboard
4. **No recursive scanning:** Don't walk the entire tree — scan root and specified path only

**Common monorepo patterns:**
- `package.json` (root) + `requirements.txt` (backend/) → Node.js + Python
- `go.mod` (root) + `package.json` (web/) → Go + Node.js
- Workspace roots (npm workspaces, cargo workspaces) → single ecosystem, one audit

</monorepo_handling>

<edge_cases>

## Edge Cases

### No indicator files found
- Report: "No dependency files detected"
- List supported ecosystems
- Suggest checking subdirectories

### Multiple Node.js lock files (npm + yarn)
- This usually indicates a migration
- Use the most recently modified lock file
- Note: "Multiple Node.js lock files found — using {most_recent}"

### Empty manifest (package.json with no dependencies)
- Still detect the ecosystem
- Report: "0 dependencies" in dashboard
- No audit needed

### Virtual environments (Python)
- Don't scan inside venv/, .venv/, env/ directories
- These contain installed packages, not project manifests

</edge_cases>
