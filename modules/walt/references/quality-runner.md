<overview>
WALT test runner for APPLY. It captures baseline and result evidence, then gates on new regressions by mode. No runner is a visible SKIP, not a zero baseline.
</overview>

<test_execution_protocol>

## Test Execution Protocol

**When:** Baseline capture (before first task) and result capture (after last task).

**Steps:**
1. Read quality profile for `tools.test`. No entry = emit `WALT: skipped — no test runner detected`, return `SKIP`.
2. Execute test command (e.g., `npx vitest run`, `python -m pytest`).
3. Capture: command, exit code, parsed counts when available, named failures when available, and output summary.
4. If `coverage_command` exists, run it and parse total coverage %.
5. **Timeout:** 120s. Kill the process, emit timeout evidence, return `WARN`, and do not invent counts.

### Parsing Test Output

| Tool | Pass | Fail | Skip |
|------|------|------|------|
| vitest | `X passed` | `X failed` | `X skipped` |
| jest | `X passed` | `X failed` | `X skipped` (JSON: `--json`) |
| pytest | `X passed` | `X failed` | `X skipped` from summary |
| cargo test | `X passed` from "test result" | `X failed` | `X ignored` |
| go test | Count `--- PASS` | Count `--- FAIL` | Count `--- SKIP` |

### Parsing Coverage Output

| Tool | Pattern | Example |
|------|---------|---------|
| vitest/jest | `All files \| XX.XX` | `All files \| 85.71` |
| pytest-cov | `TOTAL` line, last % | `TOTAL 450 85 81%` |
| cargo-tarpaulin | `XX.XX% coverage` | `82.35% coverage` |
| go test | `total:` line, last % | `total: (statements) 75.0%` |

If counts unparseable: fall back to exit code only. If no `coverage_command`: omit coverage.

</test_execution_protocol>

<regression_detection>

## Regression Detection

| Term | Definition |
|------|-----------|
| Regression | Passed in baseline, fails in result |
| New pass | Failed in baseline, passes in result (or new passing test) |
| Known failure | Failed in baseline — not a regression if still fails |

**Simplified (no test names):** `result.failed_count > baseline.failed_count` = regression.
**With test names (jest --json, etc.):** Compare name lists directly.
**Shortcut:** Both exit 0 and passed counts equal or increased = PASS, skip comparison.

</regression_detection>

<gating_rules>

## Gating Rules

| Mode | On New Regression | Default? |
|------|-------------------|----------|
| `strict` | BLOCK with expected-vs-observed evidence | Yes |
| `lenient` | WARN and continue | No |
| `advisory` | INFO only; never block | No |

Config: `.paul/walt.yml` → `test_gate: strict|lenient|advisory`. Default: `strict`.

No automatic small-change exemption. WALT must not infer lenient/advisory mode from file count.

| Gate Result | Meaning |
|-------------|---------|
| `PASS` | No new regressions |
| `BLOCK` | New regression in strict mode |
| `WARN` | Regression in lenient mode, runner timeout/failure, or unparseable counts with exit evidence |
| `INFO` | Regression in advisory mode |
| `SKIP` | No test runner or no tests found |

</gating_rules>

<report_format>

## Report Format

```
WALT Test Report
────────────────────────────────────
Before: {passed} passed, {failed} failed, {skipped} skipped
After:  {passed} passed, {failed} failed, {skipped} skipped
Regressions: {count} | New passes: {count} | Net delta: {+/-}
Coverage: {before}% → {after}% ({+/-delta}%)
Gate: {PASS|BLOCK|WARN|INFO|SKIP}
────────────────────────────────────
```

If test names are available, list regressions. No runner = `WALT: skipped — no test runner detected`. Runner timeout/failure = WARN with command/error evidence; do not invent counts.

### Failure Context (on BLOCK/WARN)

When gate is not PASS, include actionable context for the agent:
- **What failed:** List regressed test names (if available) or "N new failures"
- **Where to look:** Files modified in this plan that likely caused regression
- **Baseline note:** "N failures existed before this plan (not blocking)" — known failures are informational context, not regressions

</report_format>

<edge_cases>

## Edge Cases

- **No test runner:** Gate = SKIP. Emit visible skip; do not suggest installing.
- **Runner timeout/failure:** Gate = WARN. Record command/error; do not invent counts.
- **No tests (0 total):** Gate = SKIP, "No tests found"; do not suggest writing tests.
- **Baseline has failures:** Known failures are not regressions. Only new failures above baseline count.
- **No baseline available:** Report current result only; do not classify regressions without baseline evidence.
- **Tests deleted:** Passed count decrease without new failures is not a regression. Gate on new failures only.
- **TDD plan:** TDD execution manages phase gates. WALT still captures outer baseline/result evidence.

</edge_cases>
