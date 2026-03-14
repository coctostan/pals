---
name: pals:review
description: Generate structured code review guidance for recent changes
argument-hint: "[optional: commit range, file path, or 'staged']"
allowed-tools: [Read, Bash, Glob, Grep]
---

<objective>
Analyze recent code changes and generate structured review guidance with applicable patterns,
inspection checklists, and specific suggestions based on what actually changed.

**When to use:** Before committing, before opening a PR, or to review recent commits.

**IRIS integration:** Uses IRIS's review-patterns.md and inspection-checklists.md references.
</objective>

<execution_context>
kernel/modules/iris/references/review-patterns.md
kernel/modules/iris/references/inspection-checklists.md
</execution_context>

<context>
Scope: $ARGUMENTS (optional: "staged", commit range, or file path)

Project working directory.
</context>

<process>

<step name="determine_scope">
**Determine what to review.**

1. Parse $ARGUMENTS to determine scope:
   - `staged` → `git diff --cached`
   - Commit hash (e.g., `abc123`) → `git diff abc123~1..abc123`
   - Commit range (e.g., `HEAD~3..HEAD`) → `git diff HEAD~3..HEAD`
   - File path → `git diff -- {path}` (unstaged) + `git diff --cached -- {path}` (staged)
   - No arguments → `git diff` (unstaged) + `git diff --cached` (staged)

2. Verify git repository:
   ```bash
   git rev-parse --is-inside-work-tree 2>/dev/null
   ```
   - If not a git repo: display "IRIS requires git. Initialize with `git init`."

3. Run the appropriate diff command to check for changes:
   ```bash
   git diff --stat {scope}
   ```

4. If no changes found:
   Display no-changes message (see no_changes_output step)
</step>

<step name="analyze_changes">
**Gather and categorize changes.**

1. Get file-level summary:
   ```bash
   git diff --stat {scope}
   git diff --numstat {scope}
   ```

2. Get actual diff content:
   ```bash
   git diff {scope}
   ```
   - For large diffs (>500 lines): focus on file summaries and key patterns
   - Skip binary files with note

3. Categorize changed files:
   | Category | File patterns |
   |----------|--------------|
   | Source | .ts, .js, .py, .go, .rs, .rb, .ex, .java, .kt, .php, .c, .cpp, .swift |
   | Test | *.test.*, *.spec.*, *_test.*, test_*.*, tests/*, __tests__/* |
   | Config | .env*, *.yaml, *.yml, *.toml, *.json (non-package), Dockerfile, .github/* |
   | Docs | *.md, *.txt, *.rst, docs/* |
   | Style | *.css, *.scss, *.less, *.styled.* |
   | Build | package.json, Cargo.toml, go.mod, requirements.txt, Gemfile |

4. Count changes:
   - Files added (new files)
   - Files modified (existing files changed)
   - Files deleted
   - Lines added / removed per file
</step>

<step name="detect_change_type">
**Determine the primary change type.**

Apply heuristics from inspection-checklists.md:

| Signal | Detected Type |
|--------|--------------|
| New files created (non-test) | Feature |
| Only test files added/modified | Test improvement |
| Config files only | Config/Infrastructure |
| Small, focused change (<50 lines) in existing code | Bugfix |
| Large restructuring, renames, no new behavior | Refactor |
| Mix of new files + existing modifications | Feature (default) |
| Deleted files only | Cleanup/Refactor |

If multiple types apply: use primary type + note secondary.
</step>

<step name="select_patterns">
**Select applicable review patterns from review-patterns.md.**

Match patterns based on changes detected:

| Change Characteristic | Applicable Patterns |
|----------------------|-------------------|
| SQL files or database queries in diff | SQL Injection, N+1 Queries, Unbounded Queries |
| API endpoints / route handlers | Missing Input Validation, Missing Error Handling, Missing Pagination |
| HTML templates / JSX with user data | XSS, Unsafe Deserialization |
| New dependencies added | Check for Hardcoded Secrets in config |
| Functions >40 lines in diff | Long Functions, Deep Nesting |
| File >300 lines created | God Objects |
| Loop constructs with I/O | Blocking I/O, Unnecessary Allocations, N+1 Queries |
| String concatenation with variables | SQL/Command Injection, Path Traversal |
| `any` types, untyped params | Missing Types |
| Commented-out code blocks | Commented-Out Code |
| `TODO`/`FIXME` without issue ref | TODO Without Tracking |
| `console.log`, `print()`, `debugger` | Debug artifacts (general checklist) |
| `Math.random()` / `random.random()` for tokens | Insecure Randomness |
| `eval()`, `pickle.loads()` | Unsafe Deserialization |
| `.env` or credentials in diff | Hardcoded Secrets |

Present only patterns that are relevant to the actual changes. Do not dump the entire pattern list.
</step>

<step name="generate_checklist">
**Build the inspection checklist.**

1. Select primary checklist based on detected change type
2. Always include General Checklist items
3. Mark items as particularly relevant based on the actual diff content
4. Present as actionable checkboxes
</step>

<step name="generate_suggestions">
**Create specific suggestions tied to actual changes.**

For each file in the diff:
1. Scan for pattern matches (from select_patterns step)
2. Note the specific location (file and approximate area)
3. Frame as constructive suggestion:
   - "New endpoint in `routes.ts` — verify input validation is in place"
   - "Database query in `users.py:34` — check for N+1 pattern"
   - "`config.yaml` modified — confirm no secrets committed"

Keep suggestions specific and actionable. Avoid generic advice.
</step>

<step name="present_dashboard">
**Display the review dashboard.**

```
════════════════════════════════════════
IRIS CODE REVIEW
════════════════════════════════════════

Scope: {description — e.g., "Unstaged changes", "Last 3 commits", "Staged changes"}
Files: {N} changed ({added} added, {modified} modified, {deleted} deleted)
Lines: +{added} / -{removed}
Change Type: {Feature|Bugfix|Refactor|Config|Test|Mixed} (detected)

── Files Changed ──────────────────────
{categorized file list with +/- counts}

Source:
  {file.ts}  +{N} -{N}
  {file.py}  +{N} -{N}
Test:
  {file.test.ts}  +{N} -{N}
Config:
  {config.yaml}  +{N} -{N}

── Review Patterns to Check ───────────
{only patterns relevant to this diff}

• {Pattern Name}: {brief description of what to check}
  → {specific location or context from the diff}

• {Pattern Name}: {brief description}
  → {specific location}

── Inspection Checklist ────────────────
{primary checklist for detected change type}

- [ ] {checklist item — highlighted if particularly relevant}
- [ ] {checklist item}
- [ ] {checklist item}

General:
- [ ] {general checklist item}
- [ ] {general checklist item}

── Specific Suggestions ────────────────
{targeted suggestions based on actual diff content}

1. {Specific, actionable suggestion with file reference}
2. {Another suggestion}
3. {Another suggestion}

════════════════════════════════════════
```
</step>

<step name="no_changes_output">
**Display when no changes are detected.**

```
════════════════════════════════════════
IRIS CODE REVIEW
════════════════════════════════════════

No changes detected in working tree.

Usage:
  /paul:review              — Review all uncommitted changes
  /paul:review staged       — Review staged changes only
  /paul:review HEAD~3..HEAD — Review last 3 commits
  /paul:review src/auth/    — Review changes in specific path

IRIS supports: code smells, security concerns,
performance anti-patterns, and change-type checklists.
════════════════════════════════════════
```
</step>

</process>

<error_handling>

**Not a git repository:**
Display: "IRIS requires git. Initialize with `git init`."

**Invalid commit range:**
Display: "Invalid range: {input}. Use format: commit1..commit2 or HEAD~N..HEAD"

**Binary files in diff:**
Skip with note: "Binary files excluded from review: {list}"

**Very large diff (>2000 lines):**
Focus on file-level summary and highest-priority patterns. Note: "Large diff — showing high-priority patterns only. Scope with a file path for detailed review."

</error_handling>
