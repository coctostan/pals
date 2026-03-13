---
name: pals:refactor
description: Scan for tech debt and suggest refactoring opportunities
argument-hint: "[scan|suggest]"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

<objective>
Scan for tech debt indicators, analyze code complexity, and suggest prioritized refactoring
opportunities for the current project.

**When to use:** After milestones, before new features, or when code health is a concern.

**RUBY integration:** Uses RUBY's debt-detection.md and refactor-patterns.md references.
</objective>

<execution_context>
@~/.pals/modules/ruby/references/debt-detection.md
@~/.pals/modules/ruby/references/refactor-patterns.md
</execution_context>

<context>
Mode: $ARGUMENTS (optional — "scan", "suggest")

Project working directory.
</context>

<process>

<step name="determine_mode">
**Determine operating mode from arguments.**

1. If $ARGUMENTS is empty or not provided:
   - Mode: **dashboard**
2. If $ARGUMENTS is "scan":
   - Mode: **scan**
3. If $ARGUMENTS is "suggest":
   - Mode: **suggest**
4. Otherwise:
   - Treat as search/query within refactoring context
</step>

<step name="detect_project">
**Detect project structure and language.**

1. Scan for language indicators:
   - `package.json` → JavaScript/TypeScript
   - `tsconfig.json` → TypeScript
   - `pyproject.toml` or `requirements.txt` → Python
   - `go.mod` → Go
   - `Cargo.toml` → Rust
   - `Gemfile` → Ruby
   - `pom.xml` or `build.gradle` → Java

2. Identify source directories:
   - `src/`, `lib/`, `app/`, `pkg/`, `internal/`

3. Record detection results for use in subsequent steps.
</step>

<step name="mode_dashboard">
**Mode: Dashboard (no arguments)**

1. Perform a quick scan:
   - Count source files by language
   - Identify largest files (by line count)
   - Check for obvious structural indicators (very large files, deep directory nesting)

2. Display overview:
   ```
   ════════════════════════════════════════
   RUBY — Refactoring Dashboard
   ════════════════════════════════════════

   Project: [detected language/framework]
   Source Files: [count by language]

   Code Health Overview:
     Largest files:
       [file] — [lines] lines
       [file] — [lines] lines
       [file] — [lines] lines

     Potential concerns:
       [count] files over 300 lines
       [count] functions over 50 lines (if detectable)

   ────────────────────────────────────────
   Usage:
     /paul:refactor scan      — Full tech debt scan
     /paul:refactor suggest   — Prioritized suggestions
   ────────────────────────────────────────
   ```

3. If project is small/clean:
   ```
   Code Health: Good
   No major concerns detected. Codebase is well-structured.
   ```
</step>

<step name="mode_scan">
**Mode: Scan (argument is "scan")**

1. Analyze source files using heuristics from @~/.pals/modules/ruby/references/debt-detection.md:

   **File-level analysis:**
   - Line count per file (flag >300 lines)
   - Identify files with mixed responsibilities

   **Function-level analysis (where detectable):**
   - Long functions (>50 lines)
   - Deep nesting (>3 levels)
   - Long parameter lists (>4 params)

   **Pattern detection:**
   - Duplicated code blocks (similar patterns across files)
   - Magic numbers and strings
   - Dead code indicators (unused exports, commented-out blocks)
   - Circular dependency indicators

2. Classify findings by severity:
   - Critical: circular deps, actively broken patterns
   - High: large files, duplicated logic, shotgun surgery
   - Medium: long functions, deep nesting, magic values
   - Low: naming issues, dead code, style inconsistencies

3. Display results:
   ```
   ════════════════════════════════════════
   RUBY — Tech Debt Scan
   ════════════════════════════════════════

   Scanned: [N] files across [M] directories

   Critical ([count]):
     [file]:[line] — [description]

   High ([count]):
     [file]:[line] — [description]

   Medium ([count]):
     [file]:[line] — [description]

   Low ([count]):
     [file]:[line] — [description]

   Summary:
     Total findings: [N]
     Top concern: [most impactful finding]

   ────────────────────────────────────────
   Run /paul:refactor suggest for prioritized fix suggestions.
   ────────────────────────────────────────
   ```

4. If codebase is clean:
   ```
   Scan complete. No significant tech debt detected.
   Codebase health: Good
   ```
</step>

<step name="mode_suggest">
**Mode: Suggest (argument is "suggest")**

1. Run scan (if not already done) to identify findings.

2. For each finding, match to refactoring patterns from
   @~/.pals/modules/ruby/references/refactor-patterns.md:
   - Long function → Extract function
   - Deep nesting → Guard clauses
   - Magic values → Replace with constants
   - Duplicated code → Consolidate duplicates
   - Complex conditional → Decompose conditional

3. Prioritize using Impact × Frequency ÷ Effort framework:
   - Check git log for file churn (frequently changed = higher priority)
   - Estimate effort based on scope of change
   - Rank by priority score

4. Display prioritized suggestions:
   ```
   ════════════════════════════════════════
   RUBY — Refactoring Suggestions
   ════════════════════════════════════════

   Priority 1: [file]
     Smell: [description]
     Pattern: [recommended refactoring pattern]
     Effort: [low/medium/high]
     Impact: [description of improvement]

   Priority 2: [file]
     Smell: [description]
     Pattern: [recommended refactoring pattern]
     Effort: [low/medium/high]
     Impact: [description of improvement]

   Priority 3: [file]
     Smell: [description]
     Pattern: [recommended refactoring pattern]
     Effort: [low/medium/high]
     Impact: [description of improvement]

   ────────────────────────────────────────
   To address these, create a refactoring plan:
     /paul:plan (include specific items as phase goals)
   ────────────────────────────────────────
   ```

5. If no actionable suggestions:
   ```
   No high-priority refactoring opportunities found.
   Codebase is in good shape — keep it up!
   ```
</step>

</process>

<output>
- Dashboard: code health overview with file statistics and top concerns
- Scan: detailed tech debt findings grouped by severity
- Suggest: prioritized refactoring suggestions with specific patterns and effort estimates
</output>
