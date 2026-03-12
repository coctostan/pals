---
name: pals:deps
description: Run dependency health audit and display vulnerability/outdated dashboard
argument-hint: "[optional: directory path to scope analysis]"
allowed-tools: [Read, Bash, Glob, Grep]
---

<objective>
Run dependency health audit for the current project, detect package managers, check for
vulnerabilities and outdated packages, and display a dashboard with actionable suggestions.

**When to use:** To understand dependency health before planning new work or after adding packages.

**DEAN integration:** Uses DEAN's dependency-detection.md and vulnerability-audit.md references.
</objective>

<execution_context>
@~/.pals/modules/dean/references/dependency-detection.md
@~/.pals/modules/dean/references/vulnerability-audit.md
</execution_context>

<context>
Scope: $ARGUMENTS (optional directory path)

Project working directory.
</context>

<process>

<step name="detect_ecosystem">
**Detect package managers and ecosystems.**

1. Determine scan directory:
   - If $ARGUMENTS provided: use that path
   - Otherwise: use project root

2. Check for indicator files in scan directory:
   - Node.js: `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `package.json`
   - Python: `poetry.lock`, `Pipfile.lock`, `requirements.txt`, `pyproject.toml`, `Pipfile`
   - Go: `go.sum`, `go.mod`
   - Rust: `Cargo.lock`, `Cargo.toml`
   - Ruby: `Gemfile.lock`, `Gemfile`
   - Elixir: `mix.lock`, `mix.exs`
   - PHP: `composer.lock`, `composer.json`
   - Java: `build.gradle`, `build.gradle.kts`, `pom.xml`

3. Resolve ambiguities per dependency-detection.md:
   - Lock file determines package manager for Node.js
   - Check `[tool.poetry]` in pyproject.toml for Python
   - Deduplicate per ecosystem

4. If no ecosystems detected:
   ```
   ════════════════════════════════════════
   DEAN DEPENDENCY HEALTH
   ════════════════════════════════════════

   No dependency files detected.

   DEAN looks for these files:
   - Node.js: package.json, package-lock.json, yarn.lock
   - Python:  requirements.txt, pyproject.toml, Pipfile
   - Go:      go.mod
   - Rust:    Cargo.toml
   - Ruby:    Gemfile
   - Elixir:  mix.exs
   - PHP:     composer.json
   - Java:    build.gradle, pom.xml

   Try: /paul:deps path/to/subdirectory
   ════════════════════════════════════════
   ```
   Stop.

5. Display detected ecosystems:
   ```
   Detected: {ecosystem} ({package_manager})
   ```
</step>

<step name="run_audit">
**Run audit and outdated commands for each detected ecosystem.**

For each detected ecosystem:

1. Display command being run:
   ```
   Running: {audit_command}
   ```

2. Run vulnerability audit command via Bash:
   - Use JSON output format where available
   - Capture both stdout and stderr
   - Non-zero exit codes are normal when vulnerabilities exist — parse output anyway

3. Run outdated packages command via Bash:
   - Use JSON output format where available
   - Non-zero exit codes are normal when outdated packages exist

**Error handling:**
- Command not found (tool not installed):
  ```
  Audit tool not installed: {tool}
  Install with: {install_command}
  ```
  Install commands per vulnerability-audit.md.

- No lock file:
  ```
  No lock file found. Run {install_command} first for accurate results.
  ```
  Still attempt audit if possible.

- Network error:
  ```
  Audit requires network access. Check connectivity.
  ```

- If audit tool unavailable but outdated check works: show outdated only, note audit skipped.
</step>

<step name="parse_results">
**Parse audit and outdated output per ecosystem.**

Follow parsing guidance from vulnerability-audit.md.

**Vulnerability parsing:**
- Extract count by severity: critical, high, medium, low
- Normalize "moderate" (npm) to "medium"
- If severity unavailable (some tools), count total only

**Outdated parsing:**
- Classify by update type: major, minor, patch
- Compare current version vs latest version
- Count total outdated packages

**Dependency count:**
- From lock file: count total entries (direct + transitive)
- From manifest only: count direct dependencies
- Note if count is approximate (no lock file)

**Categorize for dashboard:**
- Total dependencies
- Vulnerability counts by severity
- Outdated counts by type
- Top 5 most outdated packages (by severity: major first)
</step>

<step name="present_dashboard">
**Display the dependency health dashboard.**

For each detected ecosystem:

```
════════════════════════════════════════
DEAN DEPENDENCY HEALTH
════════════════════════════════════════

Ecosystem: {name} ({package_manager})
Dependencies: {total_count}
{scope indicator if $ARGUMENTS provided: "Scope: {path}"}

── Vulnerabilities ────────────────────
Critical: {N}  High: {N}  Medium: {N}  Low: {N}
{or "No known vulnerabilities ✓"}

{if vulnerabilities found, list top 5:}
  {package}@{version} — {severity}: {advisory_title}
  {package}@{version} — {severity}: {advisory_title}

── Outdated Packages ──────────────────
Major: {N}  Minor: {N}  Patch: {N}
{or "All packages up to date ✓"}

{if outdated found, list top 5 major updates:}
  {package}: {current} → {latest} (major)
  {package}: {current} → {latest} (major)

── Health ─────────────────────────────
Overall: {verdict}
════════════════════════════════════════
```

**Display rules:**
- Show vulnerability details sorted by severity (critical first), limit to 5
- Show outdated packages sorted by update type (major first), limit to 5
- If more exist: "+N more" note
- Multiple ecosystems: show separate sections with divider
- If audit was skipped (tool not installed): note "Vulnerability audit skipped"
</step>

<step name="health_verdict">
**Determine overall health verdict.**

| Condition | Verdict |
|-----------|---------|
| Any critical vulnerabilities | Action required |
| Any high vulnerabilities OR >10 outdated | Attention needed |
| No critical/high, ≤5 outdated | Healthy |
| Audit skipped, outdated only | Partial (audit unavailable) |

Multiple ecosystems: use most severe verdict across all.
</step>

<step name="suggest_actions">
**Suggest actionable next steps based on findings.**

If critical vulnerabilities:
```
────────────────────────────────────────
Suggestions:
- Run {fix_command} to address critical vulnerabilities
- Review advisories for breaking changes before updating
────────────────────────────────────────
```

If outdated packages (no critical vulns):
```
────────────────────────────────────────
Suggestions:
- {N} major updates available — review changelogs before upgrading
- Run {update_command} for safe minor/patch updates
────────────────────────────────────────
```

If healthy:
```
────────────────────────────────────────
Dependencies look healthy!
{If any minor outdated: "{N} minor/patch updates available when ready"}
────────────────────────────────────────
```

If audit skipped:
```
────────────────────────────────────────
Suggestions:
- Install {audit_tool} for vulnerability scanning: {install_command}
────────────────────────────────────────
```
</step>

</process>

<success_criteria>
- [ ] Package manager detected or helpful message shown
- [ ] Audit command executed (or graceful skip if tool missing)
- [ ] Dashboard displayed with vulnerability and outdated summary
- [ ] Health verdict determined
- [ ] Actionable suggestions provided
</success_criteria>

<anti_patterns>
- Don't install audit tools without asking — only suggest install commands
- Don't run fix/update commands — only suggest them
- Don't modify any project files — this is read-only analysis
- Don't scan recursively into node_modules, venv, or vendor directories
- Don't block on audit tool errors — show what's available
- Don't dump raw JSON output — parse and present as dashboard
</anti_patterns>
