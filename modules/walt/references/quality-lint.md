<overview>
WALT lint/typecheck integration for APPLY phase. Runs linters, type checkers, and format checks after tasks complete. Auto-fixes what's fixable, blocks on type errors, warns on lint. Uses quality profile from quality-detection.md.
</overview>

<execution_protocol>

## Execution Protocol

**When:** After tasks complete and after test runner (walt_post_apply). **Order:** format → lint → typecheck.

**Step 1: Format Check + Auto-Fix**
- Run format check (e.g., `npx prettier --check .`)
- Issues found + auto-fix available → run fix → record "{N} format issues auto-fixed"

**Step 2: Lint Check + Auto-Fix**
- Run lint (e.g., `npx eslint . --max-warnings=0`)
- Issues found + auto-fix available → run fix → re-run lint
- Record: "{N} found, {M} auto-fixed, {R} remaining"

**Step 3: Type Check**
- Run typecheck (e.g., `npx tsc --noEmit`)
- Record: "{N} type errors". Never auto-fix type errors.

**Timeout:** 60s per tool. Exceed = kill, warn, skip.

</execution_protocol>

<auto_fix_protocol>

## Auto-Fix Protocol

| Category | Auto-Fix? | Rationale |
|----------|-----------|-----------|
| Format violations | Always | Mechanical, deterministic |
| Lint: auto-fixable | Yes | Simple rule-based transforms |
| Lint: non-fixable | No | Requires judgment |
| Type errors | Never | Requires code logic changes |

**Safety:**
- If auto-fix introduces NEW issues (re-check count > pre-fix count minus fixable): revert, warn
- Never touch files outside project root
- Never modify test files unless linter explicitly targets them

</auto_fix_protocol>

<gating_rules>

## Gating Rules

| Category | Default Gate |
|----------|-------------|
| Format | No gate (always auto-fixed) |
| Lint | `lenient` (warn) |
| Type errors | `strict` (block) |

Config: `.paul/walt.yml` → `lint_gate: strict|lenient|advisory`, `type_gate: strict|lenient|advisory`.

**Small-change exemption:** If plan modifies ≤5 files and 0 test files, treat lint/type gates as `lenient` regardless of config.

**Scoped validation:** When possible, scope lint/format checks to `files_modified` from the plan frontmatter rather than the entire project. Reduces noise from pre-existing issues.

| Gate Result | Meaning |
|-------------|---------|
| `PASS` | No issues (or all auto-fixed) |
| `BLOCK` | Type errors (strict) or lint (if strict) |
| `WARN` | Lint issues in lenient mode |
| `INFO` | Issues in advisory mode (reported, not blocking) |
| `SKIP` | No tools or tool failed |

**Combined gate (test + lint):** Most restrictive wins. BLOCK + anything = BLOCK. SKIP = use other's result. INFO = treat as PASS for gating, include in report.

</gating_rules>

<report_format>

## Report Format

```
WALT Lint Report
────────────────────────────────────
Format: {N} issues → auto-fixed | clean                    [FYI]
Lint:   {N} found, {M} auto-fixed, {R} remaining | clean   [WARN|INFO]
Types:  {N} errors | clean                                  [BUG|INFO]
Gate: {PASS|BLOCK|WARN|INFO|SKIP}
────────────────────────────────────
```

### Severity Classification

| Severity | Meaning | Examples |
|----------|---------|---------|
| BUG | Probable correctness issue, blocks in strict | Type errors, undefined references |
| WARN | Quality concern, blocks only if strict | Lint violations, unused imports |
| FYI | Informational, never blocks | Format auto-fixed, minor style |

If blocking, list type errors with file:line and severity. No tools = "No linters or type checkers detected — skipped".

### Failure Context (on BLOCK/WARN)

When gate is not PASS, include actionable context:
- **What failed:** List errors with file:line and severity (BUG/WARN/FYI)
- **Where to look:** Files from plan's `files_modified` that have issues
- **Auto-fixed:** Note what was already resolved (FYI items)

</report_format>

<edge_cases>

## Edge Cases

- **No tools detected:** Skip silently. Don't suggest installing.
- **Tool fails:** Warn, Gate = SKIP. Don't retry/fix/block.
- **Auto-fix introduces issues:** Revert auto-fix, warn, report originals.
- **Pre-existing lint:** No baseline comparison (unlike tests). Auto-fix handles easy cases; set `lint_gate: lenient` for noisy projects.
- **Only format tools:** Run format + auto-fix. Gate = PASS.
- **Format vs lint conflict:** Format runs first. If lint fix conflicts, re-run format after.

</edge_cases>
