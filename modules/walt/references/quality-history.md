<overview>
Historical quality tracking. Appends per-plan quality snapshots to `.paul/QUALITY-HISTORY.md` during unify. Append-only — never edit history.
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

| Plan | Date | Tests | Coverage | Lint | Types | Verdict |
|------|------|-------|----------|------|-------|---------|
| 10-01 | 2026-03-10 | 0 pass | — | 12 | 0 | ◆ baseline |
| 11-01 | 2026-03-10 | 15 pass | 78% | 10 | 0 | ▲ improved |

---
*Updated after every /paul:unify*
```

| Column | Format |
|--------|--------|
| Plan | `{phase}-{plan}` from PLAN.md |
| Tests | `N pass` or `—` |
| Coverage | `N%` or `—` |
| Lint/Types | Count or `—` |
| Verdict | ▲/●/▼/◆/— from quality-delta.md |

</file_format>

<append_logic>

## Append Logic (During Unify)

Append after `audit_quality_delta` step:

1. **File missing?** Create with header, empty trajectory, table header.
2. **Build entry** from WALT report "after" values (tests, coverage, lint, types, verdict).
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
- **No WALT reports (SKIP):** Append with `—` for all, verdict = `— skipped`.
- **Coverage not tracked:** `—` in Coverage, other metrics normal.
- **All stable:** Still append — history is complete. Verdict = `● stable`.
- **Pre-WALT plans:** Append all `—`. Create file if needed.
- **Multiple plans per phase:** Each gets its own row. Trajectory grows per plan.

</edge_cases>
