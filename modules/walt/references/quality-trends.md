<overview>
Trend analysis logic for WALT quality history. Detects patterns across multiple plans to surface whether project quality is improving, degrading, or stalled.

**Philosophy:** A single plan's quality delta shows one moment. Trends show the story. "Tests: ▲▲▲" means sustained investment. "Lint: ▲▲▼" means a regression after progress. Trends turn data into actionable insight.

**Core principle:** Read-only analysis of QUALITY-HISTORY.md. Never modify history — just interpret it.
</overview>

<trend_detection>

## Trend Detection Patterns

### Streak Detection

A streak is 3+ consecutive same-direction movements for a metric.

| Pattern | Name | Example |
|---------|------|---------|
| ▲▲▲ (3+ consecutive) | Improvement streak | Tests: 15→17→21→25 |
| ▼▼▼ (3+ consecutive) | Degradation streak | Lint: 0→3→5→8 |
| ●●● (3+ consecutive) | Stall | Coverage: 82%→82%→82% |

**Detection logic:**
1. Walk the trajectory values from most recent backward
2. Compare each consecutive pair using quality-delta.md's positive-direction rules
3. Count consecutive same-direction movements
4. Report streak length and direction if 3+

**Edge cases:**
- `—` (skipped) values break streaks — treat as boundary
- `◆ baseline` entries have no direction — don't count toward streaks
- A streak of length 2 is notable but not reported as a "streak"

### Regression Detection

A regression is a metric that was improving for 2+ plans then reversed.

| Pattern | Name | Severity |
|---------|------|----------|
| ▲▲▼ | Regression after improvement | Attention |
| ▲▲▲▼ | Regression after strong streak | High attention |
| ▼▲▼ | Unstable (not a regression) | Monitor |

**Detection logic:**
1. Check if the most recent movement is ▼ (degraded)
2. Check if the 2+ movements before that were ▲ (improved)
3. If both true: flag as regression
4. If recent is ▼ but prior was mixed: flag as "degraded" (not regression)

### Stall Detection

A stall is a metric unchanged for 3+ consecutive plans.

| Pattern | Name | Example |
|---------|------|---------|
| Same value ×3 | Stalled | Coverage: 82%→82%→82% |
| Same value ×5+ | Deeply stalled | Types: 0→0→0→0→0 |

**Detection logic:**
1. Compare the last 3+ trajectory values
2. If identical: report as stalled with the value and count
3. Exception: `0` stalls for Lint/Types are positive ("clean!") — not flagged as concerning

### Baseline Only

When QUALITY-HISTORY.md has a single entry:
- No trends possible
- Report: "Baseline established — trends visible after 2+ plans"

</trend_detection>

<health_verdict>

## Overall Project Health Verdict

Computed from all tracked metrics' recent trajectory:

| Condition | Verdict | Display |
|-----------|---------|---------|
| Majority ▲ or ●, no active regressions | Healthy | Overall: Healthy |
| Any active regression (▲▲▼ pattern) | Attention needed | Overall: Attention needed |
| Any ▼ without prior improvement (not regression) | Mixed | Overall: Mixed |
| Majority ▼, multiple regressions | Degrading | Overall: Degrading |
| Fewer than 3 entries in history | Insufficient data | Overall: Insufficient data |
| All metrics — (skipped) | Not tracked | Overall: Not tracked |

### Verdict Priority

When multiple conditions apply, use the most severe:
1. Degrading (highest severity)
2. Attention needed
3. Mixed
4. Healthy
5. Insufficient data
6. Not tracked (lowest — just means no tools)

### Zero-Value Stalls

Metrics stalled at `0` have special interpretation:

| Metric | Stalled at 0 | Meaning |
|--------|-------------|---------|
| Lint issues | ●●● at 0 | Clean — positive, not a concern |
| Type errors | ●●● at 0 | Clean — positive, not a concern |
| Tests passing | ●●● at 0 | No tests — flag as attention needed |
| Coverage | ●●● at — | Not tracked — neutral |

</health_verdict>

<presentation>

## Dashboard Presentation Format

### Trajectory Section

Show each metric's value progression with trend annotation:

```
── Trajectory ─────────────────────────
Tests:    0→15→17→21        ▲ improving (4-plan streak)
Coverage: —→78%→82%→82%     ● stalled at 82%
Lint:     12→10→5→0         ▲ improving (clean!)
Types:    0→0→0→0           ● stable (clean)
```

**Annotation rules:**
- Streak (3+): `▲ improving (N-plan streak)` or `▼ degrading (N-plan streak)`
- Regression: `▼ regression (was improving)`
- Stall: `● stalled at {value}`
- Zero stall for Lint/Types: `● stable (clean)`
- Zero stall for Tests: `● stalled at 0 (no tests)`
- Single entry: `◆ baseline`
- Two entries: show direction but no streak label

### History Table Section

Show the last 5-10 plan entries (most recent first):

```
── Recent History ─────────────────────
| Plan  | Tests | Coverage | Lint | Verdict |
|-------|-------|----------|------|---------|
| 13-01 | 21    | 82%      | 0    | ▲       |
| 12-01 | 17    | 82%      | 5    | ▲       |
| 11-01 | 15    | 78%      | 10   | ▲       |
| 10-01 | 0     | —        | 12   | ◆       |
```

### Health Section

Show overall verdict with supporting details:

```
── Health ─────────────────────────────
Overall: {verdict}
Streaks: {list any active streaks}
Attention: {list any regressions or concerning stalls}
```

If no streaks: omit the Streaks line.
If no concerns: omit the Attention line.

</presentation>
