<overview>
WALT lint/typecheck integration for APPLY phase. Runs linters, type checkers, and format checks after tasks complete. Auto-fixes what's fixable, blocks on type errors, warns on lint. Uses quality profile from quality-detection.md.
</overview>

<execution_protocol>

## Execution Protocol

**When:** After tasks complete and after test runner (walt_post_apply). **Order:** format → lint → typecheck.

**Step 1: Format Check + Auto-Fix**
- Run format check when a configured formatter exists.
- Auto-fix changed files only. If scope is uncertain, do not auto-fix.
- Re-run format check and record: "{N} issues, {M} auto-fixed, {R} remaining".

**Step 2: Lint Check + Auto-Fix**
- Run configured lint command, scoped to changed files when possible.
- If auto-fix is available, fix changed files only, re-run lint, and record: "{N} found, {M} auto-fixed, {R} remaining".
- If auto-fix increases remaining issues or touches files outside approved scope, undo only the auto-fix changes and report evidence.

**Step 3: Type Check**
- Run configured typecheck command.
- Record type error count and representative file:line evidence. Never auto-fix type errors.

**Timeout:** 60s per tool. Kill the process, emit timeout evidence, return WARN for that tool, and do not invent counts.

</execution_protocol>

<auto_fix_protocol>

## Auto-Fix Protocol

| Category | Auto-Fix? | Rationale |
|----------|-----------|-----------|
| Format violations | Changed files in approved scope only | Mechanical, but scope must stay bounded |
| Lint: auto-fixable | Changed files in approved scope only | Rule-based transforms within approved scope |
| Lint: non-fixable | No | Requires judgment |
| Type errors | Never | Requires code logic changes |

**Safety:**
- If auto-fix scope is uncertain, do not auto-fix.
- If auto-fix increases remaining issues or touches files outside approved scope, undo only the auto-fix changes and report evidence.
- Do not auto-fix unrelated files, even if the tool suggests them.

</auto_fix_protocol>

<gating_rules>

## Gating Rules

| Check | Default Gate |
|-------|--------------|
| Format | PASS if clean or auto-fixed; WARN if issues remain |
| Lint | `lenient` (warn) |
| Type errors | `strict` (block) |

Config: `.paul/walt.yml` → `lint_gate: strict|lenient|advisory`, `type_gate: strict|lenient|advisory`.

No automatic small-change exemption. WALT must not infer lenient/advisory mode from file count.

**Scoped validation:** Scope lint/format checks to changed files when possible.

| Gate Result | Meaning |
|-------------|---------|
| `PASS` | No issues or all allowed auto-fixes applied |
| `BLOCK` | Strict-mode lint/type issue with evidence |
| `WARN` | Lenient-mode issue, tool timeout/failure, or unparseable output with command evidence |
| `INFO` | Advisory-mode issue |
| `SKIP` | No applicable tool or no applicable files |

**Combined gate (test + lint):** Most restrictive wins. WARN/INFO remain visible. SKIP = use other available result.

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

- **No tools detected:** Gate = SKIP. Emit visible skip; do not suggest installing.
- **Tool timeout/failure:** Gate = WARN. Record command/error; do not invent counts.
- **Auto-fix introduces issues or touches files outside approved scope:** Undo only the auto-fix changes, re-run checks, and report evidence.
- **Pre-existing lint:** No baseline comparison by default. Report current findings under configured gate.
- **Only format tools:** Run format + scoped auto-fix. Gate = PASS if clean/auto-fixed, WARN if issues remain.
- **Format vs lint conflict:** Format runs first. If lint fix conflicts, re-run format and report remaining issues.
- **Typecheck unavailable:** Gate = SKIP for typecheck only; preserve lint/test results.

</edge_cases>
