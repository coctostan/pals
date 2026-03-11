<overview>
Historical quality tracking across plans. Aggregates per-plan quality snapshots into `.paul/QUALITY-HISTORY.md`, showing cumulative trajectory over time.

**Philosophy:** Quality trajectory tells the project's health story. "Tests: 0→15→17→21" shows steady growth. "Lint: 12→10→15" reveals a regression. Developers and future sessions see the full picture.

**Core principle:** Append-only. Each unify adds one entry. Never edit or rewrite history.

**Location:** `.paul/QUALITY-HISTORY.md` — project-specific, lives in .paul/ alongside STATE.md and ROADMAP.md.
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
| 12-01 | 2026-03-10 | 17 pass | 82% | 5 | 0 | ▲ improved |
| 13-01 | 2026-03-10 | 21 pass | 82% | 0 | 0 | ▲ improved |

---
*Updated after every /paul:unify*
```

### Column Definitions

| Column | Source | Format |
|--------|--------|--------|
| Plan | Plan ID from PLAN.md frontmatter | `{phase}-{plan}` (e.g., `14-01`) |
| Date | Completion date | `YYYY-MM-DD` |
| Tests | Tests passing after apply | `N pass` or `—` if not tracked |
| Coverage | Coverage % after apply | `N%` or `—` if not tracked |
| Lint | Lint issues remaining after apply | Count or `—` if not tracked |
| Types | Type errors after apply | Count or `—` if not tracked |
| Verdict | Overall quality verdict from quality-delta.md | ▲/●/▼/◆/— |

</file_format>

<append_logic>

## Append Logic (During Unify)

### When to Append

Append a new row to QUALITY-HISTORY.md every time `/paul:unify` runs, after the `audit_quality_delta` step has captured the quality snapshot.

### Steps

1. **Check if `.paul/QUALITY-HISTORY.md` exists:**
   - If not: create the file with header, empty trajectory, and table header
   - If yes: read existing content

2. **Build entry from quality delta:**
   - Extract "after" values from the WALT reports captured during apply
   - Tests: `tests_passed_after` value → `N pass`
   - Coverage: `coverage_after` value → `N%`
   - Lint: `lint_remaining` value → count
   - Types: `type_errors` value → count
   - Verdict: overall verdict from quality-delta.md (▲/●/▼/◆/—)

3. **Append row to Plan History table:**
   ```
   | {plan-id} | {date} | {tests} pass | {coverage}% | {lint} | {types} | {verdict} |
   ```

4. **Update Cumulative Trajectory summary:**
   - Append new values to each trajectory line
   - If more than 8 values, truncate with `...→` prefix:
     ```
     Tests: ...→17→19→21→21→23
     ```

### Creating the File (First Entry)

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

<trajectory_format>

## Cumulative Trajectory Format

### Arrow Notation

Each metric gets a single line showing values across plans:

```
Tests: 0→15→17→21
Coverage: —→78%→82%→82%
Lint: 12→10→5→0
Types: 0→0→0→0
```

### Overflow Handling

When more than 8 values accumulate, show only the last 8 with `...→` prefix:

```
Tests: ...→17→19→21→21→23→25→27→29
```

### Not-Tracked Values

If a metric was not tracked for a plan (WALT SKIP), use `—`:

```
Coverage: —→—→78%→82%
```

This preserves positional alignment with the plan table.

</trajectory_format>

<edge_cases>

## Edge Cases

### First Plan in Project
- Create QUALITY-HISTORY.md with header and first entry
- Verdict: `◆ baseline` (establishing initial measurements)
- Trajectory lines each have a single value

### No WALT Reports (SKIP)
- Append entry with `—` for all metrics
- Verdict: `— skipped`
- Trajectory appends `—` for each metric line

### Coverage Not Tracked
- Show `—` in Coverage column
- Trajectory shows `—` for that entry
- Other metrics tracked normally

### Plan Has No Quality Changes (All Stable)
- Still append entry — history is complete, not selective
- Verdict: `● stable`

### Pre-WALT Plans
- If unifying a plan from before WALT existed, append with all `—`
- History file may not exist yet — create it

### Multiple Plans in Same Phase
- Each plan gets its own row (e.g., `05-01`, `05-02`)
- Trajectory grows by one entry per plan, not per phase

</edge_cases>
