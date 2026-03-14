<overview>
WALT test runner for APPLY phase. Runs tests before and after task execution to detect regressions. Uses quality profile from quality-detection.md. No test runner detected = skip silently.
</overview>

<test_execution_protocol>

## Test Execution Protocol

**When:** Baseline capture (before first task) and result capture (after last task).

**Steps:**
1. Read quality profile for `tools.test`. No entry = log skip, return.
2. Execute test command (e.g., `npx vitest run`, `python -m pytest`).
3. Capture: exit code, test counts (passed/failed/skipped), full output.
4. If `coverage_command` in profile: run it, parse total coverage %.
5. **Timeout:** 120s. Exceed = kill, warn, skip gate.

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

| Mode | On Regression | Default? |
|------|--------------|----------|
| `strict` | Block. Present fix/override/stop options. | Yes |
| `lenient` | Warn, continue. | No |
| `advisory` | Surface in report, never block. For research/prototyping phases. | No |

Config: `.paul/walt.yml` → `test_gate: strict|lenient|advisory`. Default: `strict`.

**Small-change exemption:** If plan modifies ≤5 files and 0 test files, treat as `lenient` regardless of config.

| Gate Result | Meaning |
|-------------|---------|
| `PASS` | No regressions |
| `BLOCK` | Regressions in strict mode |
| `WARN` | Regressions in lenient mode |
| `INFO` | Regressions in advisory mode (reported, not blocking) |
| `SKIP` | No test runner or runner failed |

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

If test names available, list regressions. No runner = "No test runner detected — skipped". Runner error = SKIP with error message.

### Failure Context (on BLOCK/WARN)

When gate is not PASS, include actionable context for the agent:
- **What failed:** List regressed test names (if available) or "N new failures"
- **Where to look:** Files modified in this plan that likely caused regression
- **Baseline note:** "N failures existed before this plan (not blocking)" — known failures are informational context, not regressions

</report_format>

<edge_cases>

## Edge Cases

- **No test runner:** Skip silently. Gate = SKIP. Don't suggest installing.
- **Runner fails to execute:** Warn, Gate = SKIP. Don't retry/fix/block.
- **No tests (0 total):** Gate = SKIP, "No tests found". Don't suggest writing tests.
- **Baseline has failures:** Known failures aren't regressions. Only NEW failures above baseline count.
- **Tests deleted:** Passed count decrease without new failures = not regression. Gate on new failures only.
- **TDD plan:** TDD execution manages its own test runs. WALT still captures baseline before and result after for outer quality gate.

</edge_cases>
