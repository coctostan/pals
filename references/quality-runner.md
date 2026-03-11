<overview>
WALT test runner integration for the APPLY phase. Runs project test suites before and after task execution to detect regressions immediately.

**Philosophy:** Every apply should leave code quality equal or better. Catch regressions before they reach UNIFY.

**Core principle:** Use the quality profile from @references/quality-detection.md to determine what to run. If no test runner is detected, skip silently.
</overview>

<test_execution_protocol>

## Test Execution Protocol

### When to Run

Tests run at two points during apply:
1. **Baseline capture** — Before the first task executes
2. **Result capture** — After the last task completes

### How to Run

1. **Detect test runner:** Read quality profile (from quality-detection.md heuristics). Look for `tools.test` entry.
2. **If no test runner detected:** Log "WALT: No test runner detected — skipping test execution" and return early. Do not block.
3. **Execute test command:** Run the detected command (e.g., `npx vitest run`, `python -m pytest`, `cargo test`, `go test ./...`).
4. **Capture results:**
   - Exit code (0 = all pass, non-zero = failures)
   - Test counts: passed, failed, skipped (parse from output using tool-specific patterns)
   - Full output (for regression diagnosis)
5. **Capture coverage (if available):**
   - Check quality profile for `coverage_command`
   - If present: run coverage command, parse total coverage % (see Parsing Coverage Output)
   - If not present or command fails: set coverage = "not tracked"
   - Store coverage % for delta comparison

### Parsing Test Output

Use tool-specific patterns from quality-detection.md to extract counts:

| Tool | Pass Pattern | Fail Pattern | Skip Pattern |
|------|-------------|-------------|-------------|
| vitest | `X passed` | `X failed` | `X skipped` |
| jest | `X passed` | `X failed` | `X skipped` in JSON output (`--json`) |
| pytest | `X passed` | `X failed` | `X skipped` from summary line |
| cargo test | `X passed` from "test result" line | `X failed` | `X ignored` |
| go test | Count `--- PASS` lines | Count `--- FAIL` lines | Count `--- SKIP` lines |

**If counts cannot be parsed:** Fall back to exit code only (0 = pass, non-zero = fail). Report "counts unavailable" in report.

### Parsing Coverage Output

After test execution, if the quality profile includes `coverage_command`:

1. Run the coverage command
2. Parse total coverage % from output using tool-specific patterns:

| Tool | Coverage Pattern | Example |
|------|-----------------|---------|
| vitest | `All files \| XX.XX` from summary table | `All files \| 85.71` |
| jest | `All files \| XX.XX` from summary table | `All files \| 78.50` |
| pytest-cov | `TOTAL` line, last % column | `TOTAL    450    85    81%` |
| cargo-tarpaulin | `XX.XX% coverage` | `82.35% coverage` |
| go test | `total:` line, last % | `total: (statements) 75.0%` |

3. If coverage % cannot be parsed: set to "not available" and skip coverage delta
4. If no `coverage_command` in profile: omit coverage from report entirely

### Timeout

- Default timeout: 120 seconds
- If tests exceed timeout: kill process, warn, skip quality gate
- Do not let slow tests block the entire apply

</test_execution_protocol>

<regression_detection>

## Regression Detection

### Definitions

| Term | Definition |
|------|-----------|
| **Regression** | A test that passed in baseline but fails in result |
| **New pass** | A test that failed in baseline but passes in result, or a new test that passes |
| **Known failure** | A test that failed in baseline — not a regression if it still fails |
| **Net delta** | (new passes) - (regressions) |

### Comparison Logic

```
baseline_passed = baseline.passed_count
baseline_failed = baseline.failed_count
result_passed   = result.passed_count
result_failed   = result.failed_count

regressions = max(0, baseline_passed - result_passed + new_tests_passing)
new_passes  = max(0, result_passed - baseline_passed + regressions)
net_delta   = new_passes - regressions
```

**Simplified heuristic (when individual test names unavailable):**
- If `result.failed_count > baseline.failed_count` → regressions detected
- Regression count = `result.failed_count - baseline.failed_count`
- If `result.passed_count > baseline.passed_count` → new passes detected
- New pass count = `result.passed_count - baseline.passed_count`

**When individual test names ARE available** (e.g., jest --json, vitest output):
- Compare test name lists directly
- Regression = name in baseline.passed but in result.failed
- New pass = name in result.passed but not in baseline.passed (or was in baseline.failed)

### No-Regression Shortcut

If both runs have exit code 0 and passed counts are equal or increased: **PASS** — skip detailed comparison.

</regression_detection>

<gating_rules>

## Gating Rules

### Modes

| Mode | Behavior on Regression | Default? |
|------|----------------------|----------|
| `strict` | **Block** apply execution. Present report. User must override, fix, or stop. | Yes |
| `lenient` | **Warn** with report. Continue apply execution. | No |

### Configuration

Gating mode is determined by (in priority order):
1. `.paul/walt.yml` → `test_gate: strict|lenient` (if file exists)
2. Default: `strict`

### Strict Mode (default)

When regressions detected:
```
════════════════════════════════════════
⚠️  WALT: TEST REGRESSION DETECTED
════════════════════════════════════════

[test report — see Report Format below]

Options:
[1] Fix regressions now (recommended)
[2] Override and continue (records deviation)
[3] Stop apply execution
════════════════════════════════════════
```

- **Fix:** Attempt to fix failing tests, re-run, verify fix
- **Override:** Record deviation in STATE.md Decisions table, continue
- **Stop:** Halt apply, user can debug manually

### Lenient Mode

When regressions detected:
```
⚠️  WALT: Test regressions detected (lenient mode — continuing)
[test report]
```
Continue execution. Report included in apply summary.

### Gate Results

| Result | Meaning | Action |
|--------|---------|--------|
| `PASS` | No regressions | Continue |
| `BLOCK` | Regressions in strict mode | Stop, prompt user |
| `WARN` | Regressions in lenient mode | Display warning, continue |
| `SKIP` | No test runner or runner failed | Continue silently |

</gating_rules>

<report_format>

## Report Format

After both runs complete, produce this structured report:

```
WALT Test Report
────────────────────────────────────
Before: {passed} passed, {failed} failed, {skipped} skipped
After:  {passed} passed, {failed} failed, {skipped} skipped

Regressions: {count}
New passes:  {count}
Net delta:   {+/-count}
Coverage:    {before}% → {after}% ({+/-delta}%)

Gate: {PASS|BLOCK|WARN|SKIP}
────────────────────────────────────
```

**If individual test names available, list regressions:**
```
Regressions (2):
  - test_user_login
  - test_api_auth_endpoint
```

**Minimal report (no test runner):**
```
WALT Test Report
────────────────────────────────────
No test runner detected — skipped
Gate: SKIP
────────────────────────────────────
```

**Error report (runner failed to execute):**
```
WALT Test Report
────────────────────────────────────
Test runner detected (vitest) but failed to execute
Error: [error message]
Gate: SKIP (runner error — not blocking)
────────────────────────────────────
```

</report_format>

<edge_cases>

## Edge Cases

### No test runner detected
- Skip silently. WALT is a no-op.
- Report: Gate = SKIP, "No test runner detected"
- Do NOT suggest installing a test framework

### Test runner fails to execute (broken config, not installed)
- Warn: "WALT: {tool} detected but failed to run — skipping"
- Report: Gate = SKIP with error message
- Do NOT retry or attempt to fix tool configuration
- Do NOT block apply execution

### No tests exist (0 total)
- Both runs return 0 passed, 0 failed, 0 skipped
- Report: Gate = SKIP, "No tests found"
- Do NOT suggest writing tests (that's the developer's choice)

### Baseline has failures (exit code != 0)
- Capture results normally — known failures are NOT regressions
- Only NEW failures (above baseline failure count) are regressions
- Report baseline failures as context

### Test count decreases (tests deleted)
- If passed count decreases but no new failures: not a regression
- If tests were removed: net delta may be negative but gate = PASS
- Only gate on new failures, not removed tests

### TDD plan type
- If plan `type: tdd`, the TDD execution spec (tdd-execution.md) manages its own test execution within RED-GREEN-REFACTOR phases
- WALT baseline capture still runs before TDD execution begins
- WALT result capture still runs after TDD execution completes
- This provides an outer quality gate around the TDD inner loop

</edge_cases>
