# Strategic Assessment Template

Template for `.paul/assessments/{date}-{slug}.md` — output of the optional strategic-assessment checkpoint in `/paul:discuss` (see `docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md`).

**Purpose:** Captures a take-stock-before-you-build assessment across five evidence lenses, ending in a single non-authoritative ranked recommendation that informs the next milestone discussion. Created by the milestone-mode strategic-assessment branch of `discuss-milestone.md` (wired in Phase 297).

---

## File Template

```markdown
# Strategic Assessment — {milestone_boundary}

**Generated:** {{DATE}}
**Milestone boundary:** after {{PREV_MILESTONE}}, before {{NEXT_MILESTONE}}
**Capability detection:** {{LENSES_RUN_VS_SKIPPED}}
**Status:** Non-authoritative — informs the next milestone discussion

> See `docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md` for lens definitions, capability-detection rules, and authority stance.

## Findings

Evidence-backed observations, organized by the five lenses in contract order. Mark absent capabilities with `{skipped: not applicable — <reason>}` and partial availability with `{partial: <what was available>}`.

### Vision alignment

{{VISION_FINDINGS}}
<!-- Core Value + Success Criteria vs. last N milestone themes; note drift. -->
<!-- {skipped: not applicable — <reason>} -->

### Trajectory

{{TRAJECTORY_FINDINGS}}
<!-- Convergence vs. sprawl: milestone-theme drift, deferred-debt accumulation, decision-log churn / re-litigation. -->
<!-- {skipped: not applicable — <reason>} -->

### Codebase reality

{{CODEBASE_FINDINGS}}
<!-- Size/growth, complexity hotspots / largest files, TODO-FIXME density, test presence, duplication/dead code. Lightweight by default. -->
<!-- {skipped: not applicable — <reason>} -->

### Buildable/runnable reality

{{BUILD_FINDINGS}}
<!-- Build status, test pass/fail, validation state, executable/output health. Never invent counts. -->
<!-- {skipped: not applicable — <reason>} -->

### Data & outputs

{{DATA_FINDINGS}}
<!-- Generated data, logs, benchmark/validation results, and their trend. -->
<!-- {skipped: not applicable — <reason>} -->

## Strategic Options

Candidate next directions, each with tradeoffs (cost, risk, value, dependencies).

- **{{OPTION_1}}** — {{TRADEOFFS_1}}
- **{{OPTION_2}}** — {{TRADEOFFS_2}}
- **{{OPTION_3}}** — {{TRADEOFFS_3}}

## Ranked Recommendation

**Recommended next target (non-authoritative):** {{RECOMMENDATION}}

**Why this ranks first:** {{RANKING_RATIONALE}}

> Non-authoritative: this recommendation informs the milestone discussion but does not decide it. Only a future approved PLAN authorizes implementation.

## Actionable Points

Concrete handoff items that feed into the milestone feature discussion (`explore_features` / `synthesize_scope`).

- [ ] {{ACTION_1}}
- [ ] {{ACTION_2}}
- [ ] {{ACTION_3}}

---

*This artifact is durable posterity under `.paul/assessments/`; it is not a hot-path lifecycle artifact and is not subject to STATE/PROJECT/ROADMAP/MILESTONES byte budgets.*
```

---

## Field Descriptions

| Field | Purpose |
|-------|---------|
| `milestone_boundary` | Which milestone gap this assessment sits in |
| `Capability detection` | Which lenses ran vs. were skipped not-applicable |
| `Status` | Always non-authoritative — informs, does not decide |
| `Findings` | Evidence per lens, in contract order |
| `Strategic Options` | Candidate directions with tradeoffs |
| `Ranked Recommendation` | Single non-authoritative next target + rationale |
| `Actionable Points` | Handoff items into feature discussion |

---

## Usage Pattern

1. User reaches the milestone-discussion strategic-assessment checkpoint in `/paul:discuss` (optional, skippable).
2. The checkpoint detects available capabilities and gathers evidence across the five lenses.
3. This template is instantiated at `.paul/assessments/{date}-{slug}.md`.
4. Findings → Strategic options → Ranked recommendation → Actionable points are filled in contract order.
5. Actionable points hand off into `explore_features` / `synthesize_scope`.

---

## Relationship to Other Files

| File | Relationship |
|------|--------------|
| `docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md` | Authoritative spec for lenses, capability detection, output format, and authority stance |
| `kernel/templates/RESEARCH.md` | Sibling output-artifact template (convention source for this template) |
| `.paul/assessments/{date}-{slug}.md` | The durable instances created from this template |
| `kernel/workflows/discuss-milestone.md` | Call site that instantiates this template (wired in Phase 297) |
