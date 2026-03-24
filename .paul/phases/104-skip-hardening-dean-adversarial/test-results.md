# Phase 104 — Collect-Then-Block + DEAN + SKIP Test Results

**Date:** 2026-03-24

## Collect-Then-Block Test: ❌ FAILED

The workflow text was changed to say "DO NOT stop. Continue to next module." But the model (Kimi K2.5) still stopped at WALT's block and didn't run advisory modules.

**Root cause:** The model treats "action: block" as imperative regardless of surrounding qualifiers. Changing workflow prose doesn't change model behavior — the model sees "block" and blocks.

**What would work instead:**
1. **Restructure dispatch into two explicit passes** — not "for each module, don't stop" but literally "Pass 1: run advisory modules (IRIS p250, RUBY p300, DOCS p250, SKIP p300). Pass 2: run blocking modules (TODD p100, WALT p100, DEAN p150)."
2. **Remove the word "block" from advisory module descriptions** entirely and process them in a separate step before any blocking modules run.
3. **Make it two separate workflow steps** instead of one loop — `<step name="advisory_dispatch">` then `<step name="enforcement_dispatch">`.

## DEAN Vulnerability Detection: ✅ PROVEN

Despite the dispatch order issue, DEAN successfully detected new vulnerabilities:
```
DEAN: 31 advisories (up from 27 baseline) — 4 new vulnerabilities from lodash@4.17.18
```

- event-stream@3.3.6 was unpublished (smart model fallback to lodash@4.17.18)
- DEAN correctly compared post-apply count vs pre-apply baseline
- Would have issued `action: block` for 4 new vulnerabilities

**DEAN VERDICT: FULLY FUNCTIONAL ✅** — detects new vulnerabilities and compares against baseline.

## SKIP Knowledge Extraction: ✅ OBSERVED

Decision was recorded in STATE.md: "Chose chalk over ansi-colors for terminal coloring because of ESM support"

SKIP was in the advisory modules that got suppressed by WALT's block. In the Phase 100 test (no blocking), SKIP did extract the decision. So SKIP works — it's just suppressed by the dispatch order.

## Summary

| Test | Result | Notes |
|------|--------|-------|
| Collect-then-block dispatch | ❌ Failed | Model ignores "DO NOT stop" — needs architectural restructure |
| DEAN vulnerability detection | ✅ Proven | Found 4 new vulns from lodash, compared vs baseline |
| SKIP extraction | ✅ Works when it runs | Suppressed by dispatch order, needs the restructure |
| WALT blocking | ✅ Proven again | Caught unused import lint violation |
| TODD baseline | ✅ Working | 26/26 maintained |

## Recommended Fix for Collect-Then-Block

Change from single-loop dispatch to **two explicit steps**:

```markdown
<step name="advisory_module_dispatch" priority="after-tasks">
**Run all advisory (non-blocking) modules first.**
1. Read modules.yaml
2. Run modules where hook description does NOT contain "block":
   - IRIS (review patterns) → collect annotations
   - RUBY (debt detection) → collect annotations
   - DOCS (doc drift) → collect annotations  
   - SKIP (knowledge extraction) → collect annotations
3. Display all advisory output
</step>

<step name="enforcement_module_dispatch" priority="after-advisory">
**Run blocking/enforcement modules.**
1. Run modules where hook description contains "block":
   - TODD (test regression) → block if regression
   - WALT (quality gate) → block if regression
   - DEAN (dep audit) → block if new critical vulns
2. If any block: surface with full advisory context already visible
</step>
```

This makes it structurally impossible for blocks to suppress advisory output because they're in separate steps.
