# Phase 71 Final Report: Recommendations

## Executive Summary
Phase 71 closes v2.7 by converting the last three phases into a stable recommendation set:
- **Phase 68** established that the module system was more wired than visible.
- **Phase 69** fixed the durable proof path.
- **Phase 70** made recent module activity visible in Pi without creating adapter-owned truth.
- **Phase 71** concludes that the module roster should largely be preserved, while proof-bearing and late-surface modules should become easier to interpret through better recommendation/reporting guidance rather than heavier infrastructure.

## Strongest Calls

### 1. Keep the roster; do not treat opacity as dead weight
The audit did not support dramatic consolidation or removal. The central problem was weak user legibility, not fictional module participation.

### 2. Improve proof-bearing modules first
The highest-value follow-on improvements are in how module value is explained and summarized, especially for:
- **TODD** — stronger explanation of TDD participation across plan/apply reporting
- **WALT** — keep using it as the gold-standard example of durable module evidence
- **SKIP** — clarify what was durably captured versus merely suggested
- **RUBY** — make late post-unify refactor guidance easier to interpret

### 3. Preserve the layered proof model
The recommended proof/visibility stack is now clear:
- dispatch logs for immediate trace
- `Module Execution Reports` for durable proof
- `side_effects` for non-blocking follow-on actions
- validation suites for contract assurance
- Pi live visibility for bounded real-time awareness

### 4. Keep Pi additive and non-authoritative
Pi should continue surfacing the newest trustworthy signal, but it should not become a second execution ledger or a persistence layer for module activity.

## What Should Stay Unchanged
- `.paul/*` artifacts remain the authoritative lifecycle source.
- The Phase 69 `module_reports` / `side_effects` split remains the right durable contract.
- The Phase 70 derived-only Pi visibility model remains the right adapter posture.
- Conditional/advisory modules are allowed to be quiet when their trigger conditions are absent.
- CARL remains outside PAUL lifecycle hooks.

## What Should Improve Next
1. **Recommendation/report wording for proof-bearing modules**
   - Make it easier to tell what TODD, WALT, SKIP, and RUBY materially contributed.
2. **Summary readability**
   - Keep module summaries concise, module-specific, and explicit about what persisted versus what remained advisory.
3. **Validation explainability**
   - Keep proving contract integrity, but make it easier for maintainers to understand what those tests do and do not prove.

## What Should Not Happen Next
- Do **not** add telemetry pipelines.
- Do **not** create Pi-owned lifecycle state or hidden module history.
- Do **not** reopen source-vs-installed drift work unless new evidence appears.
- Do **not** force merge/remove decisions just because multiple advisory modules are not always visible.
- Do **not** reopen the Phase 69 or Phase 70 contract as design churn without a demonstrated contradiction.

## Recommended Follow-On Sequence

### Near-term
- Keep the current architecture intact.
- Apply small, high-confidence improvements to recommendation/report clarity for proof-bearing and post-unify modules.
- Preserve the current validation posture while making its purpose easier to read.

### Later
- Reassess whether any module boundaries need tightening only if future usage evidence shows real overlap or low value.
- Consider targeted UX/report refinements where late-surface modules remain misunderstood even after report clarity improvements.

### Defer
- dashboards
- telemetry
- execution ledgers
- Pi-owned persistence
- broad module consolidation

## v2.7 Milestone Closeout
v2.7 answered the user's original trust question in a staged way:
1. **Audit reality** — the module system is real, but opaque.
2. **Fix proof** — durable summary evidence now exists.
3. **Fix visibility** — Pi now shows recent module activity in a bounded way.
4. **Decide direction** — keep the module architecture, refine clarity, and avoid overbuilding.

That is a clean milestone arc: diagnose, fix truth, improve legibility, then rationalize.

## Direct Handoff
The next milestone should start from this recommendation set rather than reopening the Phase 68-70 debates.

Recommended next move:
- choose a small implementation milestone focused on **report/recommendation clarity and selective module-legibility improvements**, while explicitly preserving the current artifact-first proof model.

In short: **keep the modules, improve how their value is explained, and resist turning proof/visibility into telemetry.**
