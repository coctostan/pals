# REV Review Prompt Template

## Context Assembly

The reviewer subagent receives a structured prompt built from multiple context layers:

| Context Layer | Source | Always/Optional |
|---------------|--------|-----------------|
| **Diff** | `git diff {base}...HEAD` or `git diff --cached` | Always |
| **Changed files (full)** | Read each file in the diff | Always |
| **AGENTS.md** | Project root `AGENTS.md` (if exists) | Always |
| **Relevant test files** | Test files for changed source files | Optional (include if they exist) |
| **PLAN.md** | Current plan (if reviewing plan's output) | Optional (on-demand only) |

## Scope-to-Diff Command Mapping

| Scope | Diff Command | When |
|-------|-------------|------|
| Current plan | `git diff {branch-base}...HEAD` | Default for `/paul:review` during active plan |
| Specific files | `git diff HEAD -- {files}` + full file read | User specifies files |
| Full branch | `git diff {base_branch}...HEAD` | PR-level review |
| Uncommitted | `git diff` + `git diff --cached` | Quick check before commit |

## Prompt Template

```
You are reviewing code changes in the project "{project_name}".

## Context
{AGENTS.md content if exists, otherwise project description}

## Changes to Review
{git diff output}

## Full Changed Files
{full content of each changed file}

## Test Files (if any)
{test files related to changed files}

## Review Instructions
Review these changes across 8 dimensions:
1. Correctness — logic errors, wrong behavior
2. Edge cases — null, empty, boundary, concurrent
3. Naming & clarity — readability in 6 months
4. Architecture fit — does this belong here?
5. Performance — hidden cost, hot path issues
6. Security surface — new attack vectors
7. Test coverage — are the right things tested?
8. Rollback safety — reversibility if broken

For each finding, provide:
- Severity: Critical / Important / Minor
- Location: file:line
- Description: what's wrong
- Suggestion: how to fix (for Critical/Important)

End with a verdict: READY / NOT READY / READY WITH CONCERNS.
Be thorough but not pedantic. Flag real issues, not style preferences.
```

## Output Format

The reviewer returns structured findings:

```markdown
## Code Review: {scope_description}

### Summary
{1-3 sentence overall assessment}

### Findings

#### Critical
- **[{file}:{line}] {title}** — {description}. Fix: {suggestion}.

#### Important
- **[{file}:{line}] {title}** — {description}. Consider: {suggestion}.

#### Minor
- **[{file}:{line}] {title}** — {description}.

### Strengths
- {what's done well — positive reinforcement}

### Verdict
{READY / NOT READY (Critical issues) / READY WITH CONCERNS (Important issues only)}
```

## Prompt Assembly Steps

1. Determine scope → get diff command
2. Run diff command → capture output
3. Read changed files in full
4. Read AGENTS.md if exists
5. Find related test files (*.test.*, *.spec.* matching changed file names)
6. Read this template
7. Substitute placeholders: {project_name}, {diff}, {changed_files}, {test_files}, {agents_md}
8. Invoke Agent() with assembled prompt
9. Parse output → extract verdict
10. Present findings to user

## Error Handling

| Error | Response |
|-------|----------|
| Agent tool not available | Offer degraded in-session mode or skip |
| Subagent timeout | Display partial output if available + "Review timed out — try with fewer files" |
| Subagent crash (exit code ≠ 0) | Display stderr + "Review failed — check pi-subagents installation" |
| Empty/unhelpful output | "Review produced no actionable findings — may need more context. Try reviewing specific files." |
| Diff too large (>5000 lines) | "Diff is very large ({N} lines). Review specific files instead? [1] Proceed anyway [2] Pick files" |
