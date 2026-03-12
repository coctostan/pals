<overview>
WALT lint and typecheck integration for the APPLY phase. Runs project linters, type checkers, and format checks after task execution, auto-fixes what's fixable, and surfaces what's not.

**Philosophy:** Auto-fix the trivial (formatting, simple lint), block on the serious (type errors), warn on the debatable (lint style). Complement quality-runner.md (tests) with code quality checks.

**Core principle:** Use the quality profile from @references/quality-detection.md to determine what to run. If no tools detected, skip silently.
</overview>

<execution_protocol>

## Execution Protocol

### When to Run

Lint/typecheck runs once during apply:
- **After tasks complete** and **after test runner** (walt_post_apply step)
- Order: format check → auto-fix → lint → auto-fix → typecheck
- This order matters: format fixes may resolve lint issues; lint fixes should not break types

### How to Run

1. **Detect tools:** Read quality profile (from quality-detection.md heuristics). Look for `tools.format`, `tools.lint`, `tools.typecheck` entries.
2. **If no tools detected for a category:** Skip that category silently.
3. **Execute in order:**

**Step 1: Format Check + Auto-Fix**
- Run format check command (e.g., `npx prettier --check .`)
- If issues found AND auto-fix available: run auto-fix command (e.g., `npx prettier --write .`)
- Record: "{N} format issues → auto-fixed"
- If no auto-fix available: record issues as warnings

**Step 2: Lint Check + Auto-Fix**
- Run lint command (e.g., `npx eslint . --max-warnings=0`)
- Capture issue count from output
- If issues found AND auto-fix available: run fix command (e.g., `npx eslint . --fix`)
- Re-run lint check to count remaining issues
- Record: "{N} issues found, {M} auto-fixed, {R} remaining"

**Step 3: Type Check**
- Run typecheck command (e.g., `npx tsc --noEmit`)
- Capture error count from output
- Record: "{N} type errors"
- Never auto-fix type errors (they require intentional code changes)

### Timeout

- Default timeout per tool: 60 seconds
- If a tool exceeds timeout: kill process, warn, skip that tool
- Do not let slow checks block the entire apply

</execution_protocol>

<auto_fix_protocol>

## Auto-Fix Protocol

### What Gets Auto-Fixed

| Category | Auto-Fix? | Rationale |
|----------|-----------|-----------|
| Format violations | Always | Formatting is mechanical, deterministic |
| Lint: auto-fixable rules | Yes | Simple rule-based transforms (unused imports, semicolons) |
| Lint: non-auto-fixable | No | Require developer judgment |
| Type errors | Never | Require code logic changes |

### Auto-Fix Sequence

```
1. Run format check → issues found?
   YES → run format auto-fix → record "N format issues auto-fixed"
   NO  → record "Format: clean"

2. Run lint check → issues found?
   YES → auto-fix available?
     YES → run lint auto-fix → re-run lint check → record "N found, M fixed, R remaining"
     NO  → record "N lint issues (no auto-fix available)"
   NO  → record "Lint: clean"

3. Run typecheck → errors found?
   YES → record "N type errors" (no auto-fix)
   NO  → record "Types: clean"
```

### Safety Rules

- Auto-fix runs on the working directory (files already modified by apply tasks)
- If auto-fix introduces NEW issues (re-check count > pre-fix count minus fixable): revert auto-fix, warn
- Auto-fix never touches files outside the project root
- Auto-fix never modifies test files (only source files) — unless the linter explicitly targets test files

</auto_fix_protocol>

<gating_rules>

## Gating Rules

### Default Gating by Category

| Category | Default Gate | Rationale |
|----------|-------------|-----------|
| Format | No gate | Always auto-fixed silently |
| Lint warnings | `lenient` (warn) | Style preferences vary; don't block on opinions |
| Lint errors | `lenient` (warn) | May have pre-existing issues |
| Type errors | `strict` (block) | Type errors indicate broken code |

### Configuration

Gating is determined by (in priority order):
1. `.paul/walt.yml` → `lint_gate: strict|lenient` and `type_gate: strict|lenient` (if file exists)
2. Defaults: `lint_gate: lenient`, `type_gate: strict`

### Strict Mode (type errors default)

When blocking issues detected:
```
════════════════════════════════════════
⚠️  WALT: TYPE ERRORS DETECTED
════════════════════════════════════════

[lint report — see Report Format below]

Options:
[1] Fix type errors now (recommended)
[2] Override and continue (records deviation)
[3] Stop apply execution
════════════════════════════════════════
```

### Lenient Mode (lint default)

When issues detected:
```
⚠️  WALT: Lint issues detected (lenient mode — continuing)
[lint report]
```
Continue execution. Report included in apply summary.

### Gate Results

Reuses quality-runner.md gate enum:

| Result | Meaning | Action |
|--------|---------|--------|
| `PASS` | No issues (or all auto-fixed) | Continue |
| `BLOCK` | Type errors (strict) or lint errors (if strict configured) | Stop, prompt user |
| `WARN` | Lint issues in lenient mode | Display warning, continue |
| `SKIP` | No tools detected or tool failed | Continue silently |

### Combined Gate with Test Runner

The overall WALT gate is the most restrictive:
- Test BLOCK + Lint anything → BLOCK (test regressions)
- Test PASS + Lint BLOCK → BLOCK (type errors)
- Test WARN + Lint WARN → WARN
- Test PASS + Lint PASS → PASS
- Either SKIP → use the other's result

</gating_rules>

<report_format>

## Report Format

After all checks complete, produce this structured report:

```
WALT Lint Report
────────────────────────────────────
Format: {N} issues → auto-fixed | clean
Lint:   {N} found, {M} auto-fixed, {R} remaining | clean
Types:  {N} errors | clean

Gate: {PASS|BLOCK|WARN|SKIP}
────────────────────────────────────
```

**If blocking (type errors):**
```
Types (3 errors):
  src/api/auth.ts:42 — Type 'string' not assignable to 'number'
  src/lib/utils.ts:15 — Property 'foo' does not exist on type 'Bar'
  src/app/page.tsx:8 — Missing return type annotation
```

**Minimal report (no tools):**
```
WALT Lint Report
────────────────────────────────────
No linters or type checkers detected — skipped
Gate: SKIP
────────────────────────────────────
```

**Error report (tool failed):**
```
WALT Lint Report
────────────────────────────────────
Lint: eslint detected but failed to execute
Types: clean
Gate: SKIP (tool error — not blocking)
────────────────────────────────────
```

</report_format>

<edge_cases>

## Edge Cases

### No linters or type checkers detected
- Skip silently. WALT lint is a no-op.
- Report: Gate = SKIP, "No linters or type checkers detected"
- Do NOT suggest installing tools

### Tool fails to execute (broken config, not installed)
- Warn: "WALT: {tool} detected but failed to run — skipping"
- Report: Gate = SKIP for that category
- Do NOT retry or attempt to fix tool configuration
- Do NOT block apply execution

### Auto-fix introduces new issues
- After auto-fix, re-run check
- If remaining count > (original count - expected fixes): revert auto-fix
- Warn: "WALT: Auto-fix for {tool} reverted — introduced new issues"
- Report original issues as-is

### Pre-existing lint errors (baseline)
- Unlike tests, lint does NOT use before/after baseline comparison
- Reason: lint auto-fix handles the easy cases; remaining issues are surfaced
- If a project has many pre-existing lint issues, the user should set `lint_gate: lenient`
- Future enhancement (Phase 8): track lint count delta over time

### Project with only format tools (no lint or typecheck)
- Run format check + auto-fix
- Gate = PASS (formatting always auto-fixed)
- Report shows format line only

### Conflicting auto-fixes (format vs lint)
- Format runs first, then lint
- If lint auto-fix conflicts with format: format wins (re-run format after lint fix)
- In practice this is rare — modern tools (biome, ruff) handle both

</edge_cases>
