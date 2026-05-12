<overview>
Advisory performance pattern reference for in-scope query, imports/package metadata, rendering, I/O, memory/cache, and algorithmic signals. Findings are heuristic evidence, not benchmark or latency proof.
</overview>

<query_patterns>

## Database & Query Performance

| Anti-Pattern | Detection | Impact | Fix |
|-------------|-----------|--------|-----|
| N+1 Queries | Loop containing DB call, `forEach`/`map` with `await` query | O(N) round trips | Eager loading, `WHERE id IN (...)`, batch queries |
| SELECT * | `SELECT *` or ORM `.find()` without `.select()` | Fetches unused columns, bloats memory | Select specific columns |
| Missing Index Hints | Queries on non-indexed columns without comments | Slow queries at scale | Add index or document why full scan is acceptable |
| Unbounded Results | No `LIMIT`, no pagination | Memory exhaustion | Cursor pagination with default limits |
| Transaction Scope | Long-running transactions holding locks | Deadlocks, contention | Minimize transaction scope, optimistic locking |

### Evidence Checklist

Use query patterns only for in-scope source/text paths; omit checks without changed-code evidence.

| Check | Evidence |
|-------|----------|
| Query loop | changed loop/iteration contains awaited/repeated query call |
| Unbounded query | changed query call lacks visible limit/pagination/filter context |
| Broad select | changed SQL/query text selects broad records or `SELECT *` |
| Per-item fetch | changed map/forEach path performs per-item fetch or lookup |

Report `WARN` only with cited code evidence and recovery owner; do not infer missing pagination from unrelated files.

</query_patterns>

<bundle_size>

## Bundle & Package Size

Use bundle/package concerns only when the current diff changes imports, assets, or package metadata. Do not inspect `node_modules` or infer bundle size; DEAN owns dependency audit.

| Concern | Evidence | Advisory signal |
|---------|----------|-----------------|
| Heavy import | changed full-library import (for example lodash or moment) | possible bundle growth |
| Duplicate dependency | changed package metadata introduces duplicate package/version | dependency-size risk |
| Prod dependency drift | changed package metadata moves build/test-only package into runtime deps | deploy-size risk |
| Large asset | changed asset file has cited size evidence | possible load-time risk |
| Tree-shaking gap | changed import uses CommonJS in an ESM path | possible dead-code retention |

Report `WARN` only with cited in-scope evidence and recovery owner.

</bundle_size>

<render_performance>

## Rendering & UI Performance

| Anti-Pattern | Detection | Impact |
|-------------|-----------|--------|
| Unnecessary re-renders | Missing `useMemo`/`useCallback`, inline objects in JSX props | Wasted CPU cycles |
| Large component trees | Components >200 lines with no splitting | Slow reconciliation |
| Missing virtualization | Rendering 100+ items without virtual scrolling | DOM bloat, jank |
| Synchronous heavy work | CPU-intensive code on main thread | UI freezes |
| Layout thrashing | Reading then writing DOM in loops | Forced reflows |
| Missing lazy loading | All routes/components loaded upfront | Slow initial load |

</render_performance>

<algorithmic_concerns>

## Algorithmic & Memory Patterns

| Pattern | Evidence | Recovery hint |
|---------|----------|---------------|
| Nested loops | changed nested iteration over the same collection | index, batch, or single-pass |
| Async query loop | changed loop/map path performs awaited per-item query/fetch | batch, preload, or join |
| Memory/cache growth | changed listener/cache path lacks visible cleanup/eviction | cleanup, size limit, or TTL |
| String building loop | changed loop repeatedly appends to a string | collect parts and join |
| Synchronous I/O | changed sync I/O call appears in an async/request path | async variant or move out of request path |
| Large object clone | changed deep clone of large/unknown object | targeted copy or `structuredClone()` |

Report `WARN` only with current diff evidence and `{file}:{line}`; do not infer missing caching or request-path context from unrelated files.

</algorithmic_concerns>

<thresholds>

## Performance Thresholds

Use thresholds as advisory WARN triggers only with measured or cited in-scope evidence; do not estimate runtime metrics. Each WARN cites `{file}:{metric}={value}` or the measurement source.

| Metric | WARN trigger |
|--------|--------------|
| Function size | changed function exceeds 80 lines |
| Nested loop depth | changed loop nesting exceeds 2 levels |
| Asset/bundle artifact size | changed asset or provided bundle artifact exceeds 500KB |
| Query count | measured/provided request query count exceeds 10 |
| Memory use | measured/provided request memory exceeds 100MB |

</thresholds>
