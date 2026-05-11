<overview>
Historical quality tracking. Appends one per-plan quality snapshot to `.paul/QUALITY-HISTORY.md` during UNIFY. Append-only module evidence; it does not update STATE, ROADMAP, or SUMMARY.
</overview>

<file_format>

## QUALITY-HISTORY.md Format

```markdown
# Quality History

## Cumulative Trajectory

Tests: 0→15→17→21
Coverage: —→78%→82%→82%
Lint: 12→10→5→0
Types: 0→0→0→0

## Plan History

| Plan | Date | Tests | Coverage | Lint | Types | Event | Verdict |
|------|------|-------|----------|------|-------|-------|---------|
| 10-01 | 2026-03-10 | 0 pass | — | 12 | 0 | | ◆ baseline |
| 11-01 | 2026-03-10 | 15 pass | 78% | 10 | 0 | | ▲ improved |

---
*Updated after every /paul:unify*
```

| Column | Format |
|--------|--------|
| Plan | `{phase}-{plan}` from PLAN.md |
| Tests | `N pass` or `—` |
| Coverage | `N%` or `—` |
| Lint/Types | Count or `—` |
| Event | Optional: `refactor`, `new module`, `dep upgrade`, or blank. Explains metric shifts in context |
| Verdict | ▲/●/▼/◆/— from quality-delta.md |

</file_format>

<append_logic>

## Append Logic (During Unify)

Append after `audit_quality_delta` step:

1. **File missing?** Create with header, empty trajectory, table header.
2. **Build entry** from WALT report "after" values (tests, coverage, lint, types, verdict). If a metric is missing or untracked, use `—`; do not invent metrics.
3. **Append row** to Plan History table.
4. **Update trajectory** — append new values. If >8 values, truncate with `...→` prefix.

### First Entry Template

```markdown
# Quality History

## Cumulative Trajectory

Tests: {tests}
Coverage: {coverage}
Lint: {lint}
Types: {types}

## Plan History

| Plan | Date | Tests | Coverage | Lint | Types | Verdict |
|------|------|-------|----------|------|-------|---------|
| {plan-id} | {date} | {tests} pass | {coverage} | {lint} | {types} | ◆ baseline |

---
*Updated after every /paul:unify*
```

</append_logic>

<edge_cases>

## Edge Cases

- **First plan:** Create file, verdict = `◆ baseline`, single trajectory value.
- **No WALT APPLY evidence:** Append all `—`, verdict = `— skipped`; do not invent metrics.
- **No quality tools detected:** Append all `—`, verdict = `— skipped`; do not suggest installing.
- **Partial data:** Append available metrics and `—` for missing categories.
- **All stable:** Still append — history is complete. Verdict = `● stable`.
- **Pre-WALT plans:** Append all `—`. Create file if needed.
- **Multiple plans per phase:** Each gets its own row. Trajectory grows per plan.

</edge_cases>
