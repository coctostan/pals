# Performance Principles

Core principles guiding PETE module behavior.

## Principles

1. **Measure, don't guess.** Performance intuition is unreliable. PETE uses tool-backed detection (grep patterns, size checks, complexity heuristics) rather than subjective assessment.

2. **Prevent at the pattern level.** Individual slow lines matter less than systemic anti-patterns (N+1 queries, full library imports, nested loops on collections). PETE catches patterns, not micro-optimizations.

3. **Scale matters.** Code that works fine with 10 items may fail with 10,000. PETE flags unbounded operations, missing pagination, and O(n²) patterns because they're time bombs.

4. **Bundle size is user experience.** Every unnecessary kilobyte increases load time. PETE catches full library imports, dev deps in production, and missing tree-shaking.

5. **Performance is not premature optimization.** Catching N+1 queries, missing pagination, and synchronous I/O in async paths is not premature — it's structural correctness.

## Advisory vs Blocking

- **Advisory (pre-plan):** Pattern detection, bundle analysis, complexity heuristics — inform but never block
- **Blocking (post-apply):** New N+1 patterns in hot paths, synchronous I/O in request handlers — these are bugs, not style choices
