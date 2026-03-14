<overview>
Trend analysis for WALT quality history. Detects patterns across multiple plans. Read-only analysis of QUALITY-HISTORY.md — never modifies history.
</overview>

<trend_detection>

## Trend Detection

### Streaks (3+ consecutive same-direction)

| Pattern | Name | Example |
|---------|------|---------|
| ▲▲▲+ | Improvement streak | Tests: 15→17→21→25 |
| ▼▼▼+ | Degradation streak | Lint: 0→3→5→8 |
| ●●●+ | Stall | Coverage: 82%→82%→82% |

Walk trajectory from most recent backward, compare pairs using positive-direction rules, count consecutive same-direction. `—` breaks streaks. `◆ baseline` has no direction.

### Regressions

| Pattern | Name |
|---------|------|
| ▲▲▼ | Regression after improvement |
| ▲▲▲▼ | Regression after strong streak |
| ▼▲▼ | Unstable (not regression) |

Most recent = ▼ AND 2+ prior = ▲ → regression. Prior mixed → "degraded" (not regression).

### Stalls

Same value 3+ plans = stalled. Exception: `0` for Lint/Types = positive ("clean!"), not concerning.

**Single entry:** "Baseline established — trends visible after 2+ plans"

### Zero-Regression Rate

Track percentage of plans completing without introducing test regressions:
- **Formula:** Plans with Gate=PASS or SKIP / Total plans (excluding SKIP-only)
- **Display:** `Zero-regression rate: N/M plans (X%)`
- **Healthy:** ≥80%. **Attention:** 50-79%. **Degrading:** <50%.

</trend_detection>

<health_verdict>

## Project Health Verdict

| Condition | Verdict |
|-----------|---------|
| Majority ▲/●, no regressions | Healthy |
| Any ▲▲▼ regression | Attention needed |
| Any ▼ without prior improvement | Mixed |
| Majority ▼, multiple regressions | Degrading |
| <3 entries | Insufficient data |
| All — | Not tracked |

**Priority (most severe wins):** Degrading > Attention > Mixed > Healthy > Insufficient > Not tracked.

**Zero stalls:** Lint/Types at 0 = clean (positive). Tests at 0 = attention needed.

</health_verdict>

<presentation>

## Dashboard Format

```
── Trajectory ─────────────────────────
Tests:    0→15→17→21        ▲ improving (4-plan streak)
Coverage: —→78%→82%→82%     ● stalled at 82%
Lint:     12→10→5→0         ▲ improving (clean!)
Types:    0→0→0→0           ● stable (clean)

── Zero-Regression Rate ───────────────
Rate: 8/10 plans (80%)     ✓ healthy

── Recent History ─────────────────────
| Plan  | Tests | Coverage | Lint | Event | Verdict |
|-------|-------|----------|------|-------|---------|
| 13-01 | 21    | 82%      | 0    |       | ▲       |
| 12-01 | 17    | 82%      | 5    | refactor | ▲    |

── Health ─────────────────────────────
Overall: {verdict}
Streaks: {any active streaks}
Attention: {regressions or concerning stalls}
```

**Annotations:** Streak 3+ → `▲ improving (N-plan streak)`. Regression → `▼ regression (was improving)`. Stall → `● stalled at {value}`. Zero Lint/Types → `● stable (clean)`. Zero Tests → `● stalled at 0 (no tests)`.

Omit Streaks/Attention lines if none. Show last 5-10 entries (most recent first).

</presentation>
