---
name: pals:coverage
description: Run test coverage analysis and display dashboard of tested vs untested code
argument-hint: "[optional: directory or file path to scope analysis]"
allowed-tools: [Read, Bash, Glob, Grep]
---

<objective>
Run test coverage analysis for the current project, parse results, and display a dashboard
showing tested vs untested code paths with actionable suggestions.

**When to use:** To understand where test coverage is thin before planning new work.

**TODD integration:** Uses TODD's coverage-detection.md reference for framework detection.
</objective>

<execution_context>
@~/.pals/modules/todd/references/coverage-detection.md
</execution_context>

<context>
Scope: $ARGUMENTS (optional directory/file path)

Project working directory.
</context>

<process>

<step name="detect_framework">
**Detect test framework and coverage command.**

1. Check for framework indicator files in project root:
   - `package.json` → Node.js ecosystem (Jest, Vitest, c8, nyc)
   - `pyproject.toml` or `setup.py` → Python (pytest)
   - `go.mod` → Go
   - `Cargo.toml` → Rust
   - `mix.exs` → Elixir
   - `Makefile` with coverage target → Make

2. For Node.js projects (package.json found):
   a. Read `package.json`
   b. Check `scripts` for explicit `coverage` script → use `npm run coverage`
   c. If no coverage script, check `devDependencies` then `dependencies`:
      - `jest` → `npx jest --coverage --coverageReporters=text`
      - `vitest` → `npx vitest run --coverage`
      - `c8` → `npx c8 npm test`
      - `nyc` → `npx nyc npm test`
   d. If none found, check for config files: `jest.config.*`, `vitest.config.*`

3. For other frameworks: use the detection table from coverage-detection.md

4. If $ARGUMENTS provided (directory/file scope):
   - Append scope to coverage command per framework conventions
   - Jest: `-- {path}`
   - Vitest: `{path}`
   - pytest: `--cov={path} {path}`
   - Go: `./{path}/...`

5. If no framework detected:
   - Check for config files: `.nycrc`, `.c8rc`, `jest.config.*`, `vitest.config.*`
   - Check Makefile for coverage/test-coverage target
   - If still nothing, ask user:
     ```
     No coverage tool detected automatically.
     What command runs your test coverage? (e.g., "npm run coverage")
     ```
</step>

<step name="run_coverage">
**Display detected command and run it.**

```
Detected: {framework}
Running: {coverage_command}
```

Run the coverage command via Bash.

**Error handling:**
- Command not found (tool not installed):
  ```
  Coverage tool not installed: {tool}
  Install with: {install_command}
  ```
  Install commands:
  - Jest: `npm install --save-dev jest`
  - Vitest: `npm install --save-dev vitest @vitest/coverage-v8`
  - pytest-cov: `pip install pytest-cov`
  - cargo-tarpaulin: `cargo install cargo-tarpaulin`

- No test files found:
  ```
  No tests found in this project.
  Start with `/paul:plan` using type: tdd to create your first tests.
  ```

- Tests fail (coverage still produced):
  - Parse whatever coverage output was produced
  - Note: "Some tests failed — coverage may be incomplete"
</step>

<step name="parse_output">
**Parse coverage output per framework.**

Follow the output parsing guidance from coverage-detection.md.

Extract for each file:
- File path (relative to project root)
- Coverage percentage (use statement coverage as primary metric)

Categorize files:
- **Good** (80%+): adequately covered
- **Partial** (50-79%): improvement opportunity
- **Low** (1-49%): needs attention
- **Untested** (0%): no coverage at all

Calculate:
- Overall coverage percentage
- Count of files in each category
</step>

<step name="present_dashboard">
**Display the coverage dashboard.**

```
════════════════════════════════════════
TODD COVERAGE DASHBOARD
════════════════════════════════════════

Overall: {XX}% coverage
{scope indicator if $ARGUMENTS provided: "Scope: {path}"}

── Low Coverage (attention needed) ────
{file path}                        {XX}%
{file path}                        {XX}%
{file path}                        {XX}%

── Untested Files (0%) ────────────────
{file path}
{file path}
{file path}

── Summary ────────────────────────────
Good (80%+): {N} files
Partial (50-79%): {N} files
Low (1-49%): {N} files
Untested (0%): {N} files
════════════════════════════════════════
```

**Display rules:**
- Show Low Coverage files sorted ascending (worst first), limit to 10
- Show Untested files, limit to 10 (note if more: "+N more untested files")
- Do NOT list all Good/Partial files (too noisy) — just show counts in Summary
- If overall coverage is 80%+, lead with a positive note
</step>

<step name="suggest_actions">
**Suggest actionable next steps based on results.**

If untested files exist:
```
────────────────────────────────────────
Suggestions:
- Consider `/paul:plan` with type: tdd for:
  {top 3 untested files by size/importance}
- Run `/paul:coverage {specific_dir}` to focus analysis
────────────────────────────────────────
```

If overall coverage is low (<50%):
```
────────────────────────────────────────
Suggestions:
- Start with the largest untested files for maximum impact
- Use `/paul:plan` with type: tdd to add tests systematically
- Run `/paul:coverage {specific_dir}` to focus on one area
────────────────────────────────────────
```

If coverage is good (80%+):
```
────────────────────────────────────────
Coverage looks healthy! {N} files at 80%+ coverage.
{If any partials exist: "Consider improving partial coverage in {top 2 files}"}
────────────────────────────────────────
```
</step>

</process>

<success_criteria>
- [ ] Framework detected or user prompted
- [ ] Coverage command executed
- [ ] Dashboard displayed with file-level breakdown
- [ ] Actionable suggestions provided
</success_criteria>

<anti_patterns>
- Don't install coverage tools without asking — only suggest install commands
- Don't modify any project files — this is read-only analysis
- Don't run tests in watch mode — use single-run coverage commands
- Don't display all files when there are many — focus on low/untested
- Don't block on test failures — parse whatever coverage output is produced
</anti_patterns>
