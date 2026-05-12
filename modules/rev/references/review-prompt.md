# REV Review Prompt Template

## Context Assembly

REV receives bounded review context.

| Context Layer | Source | Rule |
|---------------|--------|------|
| **Diff** | Requested-scope `git diff` | Always |
| **Changed files** | Changed-file excerpts | Only lines needed to review the diff |
| **Related tests** | Explicitly related tests | Optional; cite why included |
| **PAUL context** | Current plan/summary/STATE excerpt | Optional; smallest section needed |

Do not include unrelated files, broad `.paul/*` history, or guessed dependencies.
Name the source path for every context item.

## Scope-to-Diff Command Mapping

| Scope | Diff Command | When |
|-------|-------------|------|
| Current plan | `git diff {branch-base}...HEAD` | Default for `/paul:review` during active plan |
| Specific files | `git diff HEAD -- {files}` + bounded changed-file excerpts | User specifies files |
| Full branch | `git diff {base_branch}...HEAD` | PR-level review |
| Uncommitted | `git diff` + `git diff --cached` | Quick check before commit |

## Prompt Template

```
You are reviewing code changes in the project "{project_name}".

## Context
{AGENTS.md content if exists, otherwise project description}

## Changes to Review
{git diff output}

## Changed File Excerpts
{bounded excerpts from changed files}

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
- Advisory severity: Critical advisory / Warning advisory / Suggestion
- Location: file:line
- Description: source-backed concern
- Suggested fix, only when source evidence supports one

End with recommendation: APPROVE / CHANGES_SUGGESTED / NEEDS_DISCUSSION.
Flag source-backed issues, not style preferences.
```

## Output Format

The reviewer returns structured findings:

```markdown
## Code Review: {scope_description}

### Summary
{1-3 sentence overall assessment}

### Findings

Group findings by advisory severity:

#### Critical advisory
Potential correctness, data-loss, security, or rollback issue. Include
file:line evidence and why the changed code creates the risk.

#### Warning advisory
Maintainability, edge-case, test, performance, or clarity issue with file:line
evidence.

#### Suggestion
Optional improvement. Do not present as required.

### Recommendation

`APPROVE`, `CHANGES_SUGGESTED`, or `NEEDS_DISCUSSION`.

Recommendations are advisory unless the user or workflow explicitly makes review
findings blocking.
```

## Prompt Assembly Steps

1. Determine scope → get diff command
2. Run diff command → capture output
3. Read bounded changed-file excerpts needed to review the diff
4. Read AGENTS.md if exists
5. Find related test files (*.test.*, *.spec.* matching changed file names)
6. Read this template
7. Substitute placeholders: {project_name}, {diff}, {changed_files}, {test_files}, {agents_md}
8. Invoke Agent() with assembled prompt
9. Parse output → extract recommendation
10. Present findings to user

## Error Handling

| Error | Response |
|-------|----------|
| Agent tool not available | Offer bounded in-session review or skip |
| Subagent timeout | Display partial output if available + "Review timed out — try with fewer files" |
| Review agent crash / timeout | Report failure reason; do not invent findings |
| Empty/unhelpful output | "Review produced no actionable findings — may need more context. Try reviewing specific files." |
| Diff too large (>5000 lines) | "Diff is very large ({N} lines). Review specific files instead? [1] Proceed anyway [2] Pick files" |
