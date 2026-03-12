---
name: pals:quality
description: Display quality trend dashboard from WALT history
argument-hint: ""
allowed-tools: [Read, Bash, Glob, Grep]
---

<objective>
Display a quality trend dashboard by reading QUALITY-HISTORY.md and presenting
trajectory analysis showing whether project quality is improving, stable, or degrading.

**When to use:** To see quality trajectory across plans before planning new work.

**WALT integration:** Uses WALT's quality-trends.md reference for trend detection logic.
</objective>

<execution_context>
@~/.pals/modules/walt/references/quality-trends.md
</execution_context>

<context>
Project working directory with .paul/ directory.
</context>

<process>

<step name="check_project">
**Verify PAUL project exists.**

1. Check for `.paul/` directory
2. If not found:
   ```
   No PAUL project found. Run /paul:init first.
   ```
   Stop.
</step>

<step name="check_history">
**Check for quality history file.**

1. Check for `.paul/QUALITY-HISTORY.md`
2. If not found:
   ```
   ════════════════════════════════════════
   WALT QUALITY TRENDS
   ════════════════════════════════════════

   No quality data yet.

   Quality tracking starts automatically when you run plans
   with WALT enabled. Each /paul:unify records a quality
   snapshot to QUALITY-HISTORY.md.

   To get started:
   - Run a plan: /paul:plan → /paul:apply → /paul:unify
   - WALT captures test counts, coverage, lint, and type errors
   - After 2+ plans, trends become visible here
   ════════════════════════════════════════
   ```
   Stop.
</step>

<step name="parse_history">
**Read and parse QUALITY-HISTORY.md.**

1. Read `.paul/QUALITY-HISTORY.md`

2. Parse **Cumulative Trajectory** lines:
   - Extract each metric line: `Tests: val→val→val`
   - Split on `→` to get ordered values
   - Track per-metric value arrays

3. Parse **Plan History** table:
   - Extract rows (skip header and separator)
   - Parse columns: Plan, Date, Tests, Coverage, Lint, Types, Verdict
   - Count total entries

4. Handle parse edge cases:
   - `—` values = not tracked for that entry
   - `...→` prefix = truncated history (only recent values available)
</step>

<step name="analyze_trends">
**Detect trend patterns per quality-trends.md.**

For each tracked metric (Tests, Coverage, Lint, Types):

1. **Streak detection:**
   - Walk values from most recent backward
   - Compare consecutive pairs (direction depends on metric — see quality-delta.md)
   - Count consecutive same-direction movements
   - Flag if 3+ consecutive

2. **Regression detection:**
   - Check if most recent movement is negative
   - Check if 2+ prior movements were positive
   - If both: flag as regression

3. **Stall detection:**
   - Check if last 3+ values are identical
   - If Lint/Types stalled at 0: mark as "clean" (positive)
   - If Tests stalled at 0: mark as concerning

4. **Overall health verdict:**
   - Apply verdict priority from quality-trends.md
   - Factor in: streaks, regressions, stalls
   - Single entry: "Insufficient data"
   - Two entries: show direction, note "limited data"
</step>

<step name="present_dashboard">
**Display the quality trend dashboard.**

```
════════════════════════════════════════
WALT QUALITY TRENDS
════════════════════════════════════════

── Trajectory ─────────────────────────
Tests:    {trajectory}        {annotation}
Coverage: {trajectory}        {annotation}
Lint:     {trajectory}        {annotation}
Types:    {trajectory}        {annotation}

── Recent History ─────────────────────
| Plan  | Tests | Coverage | Lint | Verdict |
|-------|-------|----------|------|---------|
{last 5-10 entries, most recent first}

── Health ─────────────────────────────
Overall: {verdict}
{Streaks line if any active streaks}
{Attention line if any regressions or concerning stalls}
════════════════════════════════════════
```

**Display rules:**
- Trajectory: align metric names with padding for readability
- History table: show last 10 entries max, most recent first
- Types column: omit from table if never tracked (all `—`)
- If only 1 entry: show trajectory with `◆ baseline` annotation, no history table
</step>

<step name="suggest_actions">
**Suggest actionable next steps based on health verdict.**

If regressions detected:
```
────────────────────────────────────────
Suggestions:
- Recent regression in {metric} — review last plan's changes
- Run /paul:verify to check current state
────────────────────────────────────────
```

If stalls detected (non-zero, concerning):
```
────────────────────────────────────────
Suggestions:
- {Metric} stalled at {value} for {N} plans
- Run /paul:coverage to find improvement opportunities
────────────────────────────────────────
```

If healthy:
```
────────────────────────────────────────
Quality trajectory looks good!
{If any streaks: "{metric} on a {N}-plan improvement streak"}
────────────────────────────────────────
```

If insufficient data:
```
────────────────────────────────────────
Only {N} entry — trends visible after 2+ plans.
Keep running plans with WALT enabled to build history.
────────────────────────────────────────
```
</step>

</process>

<success_criteria>
- [ ] QUALITY-HISTORY.md read and parsed correctly
- [ ] Trend patterns detected (streaks, regressions, stalls)
- [ ] Dashboard displayed with trajectory, history, and health verdict
- [ ] Actionable suggestions provided based on health
- [ ] Graceful handling when no history exists
</success_criteria>

<anti_patterns>
- Don't modify QUALITY-HISTORY.md — this is read-only analysis
- Don't re-run tests or quality checks — just read existing history
- Don't show raw file content — parse and present as dashboard
- Don't show all history entries when there are many — limit to 10 most recent
- Don't report Lint/Types at 0 as "stalled" in a negative sense — that's clean code
</anti_patterns>
