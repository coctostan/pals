<overview>
WALT quality delta tracking for the UNIFY phase. Collects before/after quality metrics from apply-phase WALT reports and documents them in SUMMARY.md.

**Philosophy:** Make quality trajectory visible. Every plan should show whether it improved, maintained, or degraded code quality. Developers see "Tests: 47→49, Lint: 12→10" and know the impact.

**Core principle:** Consume WALT reports from apply (quality-runner.md, quality-lint.md). Do not re-run quality checks — just record what apply already captured.
</overview>

<delta_collection>

## Delta Collection

### Source Data

Quality deltas come from WALT reports generated during the apply phase:

| Source | Metrics Available |
|--------|------------------|
| WALT Test Report (quality-runner.md) | Before/after: passed, failed, skipped counts; coverage % |
| WALT Lint Report (quality-lint.md) | Lint issues: found, auto-fixed, remaining. Type errors. Format issues auto-fixed. |

### Extraction Logic

**From WALT Test Report:**
- `tests_passed_before`, `tests_passed_after` → delta = after - before
- `tests_failed_before`, `tests_failed_after` → delta = after - before (negative is good)
- `tests_skipped` → note if changed, no gate impact
- `coverage_before`, `coverage_after` → delta = after - before (percentage points)

**From WALT Lint Report:**
- `lint_remaining` → issues remaining after auto-fix (0 = clean)
- `type_errors` → type error count (0 = clean)
- `format_fixed` → count of auto-fixed format issues (informational)

### When Reports Are Unavailable

| Scenario | Action |
|----------|--------|
| WALT test report = SKIP | Note "Tests: not tracked (no test runner)" |
| WALT lint report = SKIP | Note "Lint/Types: not tracked (no tools)" |
| Both SKIP | Quality section = "Not tracked (no quality tools detected)" |
| Apply phase had no WALT (old plan) | Quality section = "Not available (pre-WALT plan)" |

</delta_collection>

<metric_format>

## Metric Format

### SUMMARY.md Quality Section

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

### Compact Format (for inline summaries)

When a full table is too verbose (e.g., STATE.md session notes):

```
Quality: Tests 47→49 (+2▲), Cov 78%→82% (+4%▲), Lint 12→10 (-2▲), Types 0→0 (●)
```

### Minimal Format (no tools detected)

```markdown
## Quality

Not tracked (no quality tools detected)
```

### Partial Format (some tools only)

```markdown
## Quality

| Metric | Before | After | Delta | Trajectory |
|--------|--------|-------|-------|------------|
| Tests passing | 47 | 49 | +2 | ▲ improved |
| Tests failing | 3 | 1 | -2 | ▲ improved |

Lint/Types: not tracked (no linter detected)

**Overall:** ▲ improved
```

</metric_format>

<trajectory_indicators>

## Trajectory Indicators

### Per-Metric Trajectory

| Indicator | Meaning | When Applied |
|-----------|---------|-------------|
| ▲ improved | Metric moved in the positive direction | Tests passing ↑, failing ↓, lint ↓, types ↓ |
| ● stable | No change | Same value before and after |
| ▼ degraded | Metric moved in the negative direction | Tests passing ↓, failing ↑, lint ↑, types ↑ |
| — skipped | Tool not detected, no data | WALT report was SKIP |

### Positive Direction by Metric

| Metric | Positive Direction | Negative Direction |
|--------|-------------------|-------------------|
| Tests passing | ↑ increase | ↓ decrease |
| Tests failing | ↓ decrease | ↑ increase |
| Coverage | ↑ increase | ↓ decrease |
| Lint issues | ↓ decrease | ↑ increase |
| Type errors | ↓ decrease | ↑ increase |

### Overall Verdict

| Condition | Verdict |
|-----------|---------|
| Any ▲ and no ▼ | ▲ improved |
| All ● (no change) | ● stable |
| Any ▼ (regardless of ▲) | ▼ degraded |
| All — (no data) | — not tracked |
| Mix of ▲ and ▼ | ▼ degraded (conservative — any degradation flags) |
| First plan (no before) | ◆ baseline |

</trajectory_indicators>

<edge_cases>

## Edge Cases

### No quality tools detected (both reports SKIP)
- Quality section shows: "Not tracked (no quality tools detected)"
- Do NOT suggest installing tools
- This is normal for projects without quality tooling

### Partial tracking (tests but no lint, or vice versa)
- Show available metrics, note skipped categories
- Overall verdict based only on tracked metrics

### First plan in project (no history)
- WALT baseline capture from apply provides "before" values
- This IS the baseline — trajectory = "◆ baseline" for all metrics
- After values come from post-apply run

### All metrics stable
- Quality section shows the table with all ● indicators
- Overall: "● stable (no change)"
- This is fine — stable quality is acceptable

### Pre-WALT plans (no WALT reports available)
- Plans created before WALT integration won't have reports
- Quality section: "Not available (pre-WALT plan)"
- Do NOT retroactively run quality checks

### No coverage tool detected
- Omit coverage row from Quality table
- Does not affect overall verdict
- Note "Coverage: not tracked" only if other metrics are tracked

### Tests were deleted (passed count decreases)
- If total test count decreases: note "(tests removed)" alongside delta
- Not automatically ▼ degraded — tests may have been intentionally removed
- Mark as "● stable (tests restructured)" if failing count unchanged

</edge_cases>
