<overview>
WALT quality delta tracking for UNIFY. Collects before/after metrics from apply-phase WALT reports and documents in SUMMARY.md. Does not re-run checks — just records what apply captured.
</overview>

<delta_collection>

## Delta Collection

**From WALT Test Report:** `tests_passed`, `tests_failed`, `tests_skipped` (before/after), `coverage` (before/after %).
**From WALT Lint Report:** `lint_remaining`, `type_errors`, `format_fixed` (informational).

| Scenario | Action |
|----------|--------|
| Test report = SKIP | "Tests: not tracked (no test runner)" |
| Lint report = SKIP | "Lint/Types: not tracked (no tools)" |
| Both SKIP | "Not tracked (no quality tools detected)" |
| Pre-WALT plan | "Not available (pre-WALT plan)" |

</delta_collection>

<metric_format>

## SUMMARY.md Quality Section

```markdown
## Quality

| Metric | Before | After | Delta | Trajectory |
|--------|--------|-------|-------|------------|
| Tests passing | 47 | 49 | +2 | ▲ improved |
| Tests failing | 3 | 1 | -2 | ▲ improved |
| Coverage | 78% | 82% | +4% | ▲ improved |
| Lint issues | 12 | 10 | -2 | ▲ improved |
| Type errors | 0 | 0 | 0 | ● stable |

**Overall:** ▲ improved
```

**Compact (for STATE.md):** `Quality: Tests 47→49 (+2▲), Cov 78%→82% (+4%▲), Lint 12→10 (-2▲), Types 0→0 (●)`

**No tools:** `Not tracked (no quality tools detected)`

**Partial:** Show available metrics, note skipped categories.

</metric_format>

<trajectory_indicators>

## Trajectory Indicators

| Indicator | Meaning |
|-----------|---------|
| ▲ improved | Positive direction (tests↑, failing↓, lint↓, types↓) |
| ● stable | No change |
| ▼ degraded | Negative direction |
| — skipped | No data |

**Positive direction:** Tests passing ↑, tests failing ↓, coverage ↑, lint ↓, types ↓.

### Overall Verdict

| Condition | Verdict |
|-----------|---------|
| Any ▲, no ▼ | ▲ improved |
| All ● | ● stable |
| Any ▼ (even with ▲) | ▼ degraded |
| All — | — not tracked |
| First plan | ◆ baseline |

</trajectory_indicators>

<edge_cases>

## Edge Cases

- **No tools:** "Not tracked". Don't suggest installing.
- **Partial tracking:** Verdict based on tracked metrics only.
- **First plan:** Trajectory = "◆ baseline". Before = baseline capture, after = post-apply.
- **All stable:** Show table with ● indicators. Fine — stable is acceptable.
- **Pre-WALT plans:** "Not available (pre-WALT plan)". Don't retroactively run checks.
- **No coverage tool:** Omit coverage row. Note "Coverage: not tracked" only if other metrics tracked.
- **Tests deleted:** Note "(tests removed)". Mark "● stable (tests restructured)" if failures unchanged.

</edge_cases>
