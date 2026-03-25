<overview>
Performance pattern detection and anti-pattern classification for PETE. Covers query complexity, bundle/package size, rendering performance, memory patterns, and algorithmic concerns.
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

### Detection

```bash
# Find potential N+1 patterns (await in loop)
grep -n "for.*await\|forEach.*await\|map.*await" --include="*.ts" --include="*.js" src/

# Find SELECT * patterns
grep -rn "SELECT \*\|\.find()\|\.findAll()" --include="*.ts" --include="*.js" --include="*.py" src/
```

</query_patterns>

<bundle_size>

## Bundle & Package Size

| Concern | Detection | Impact |
|---------|-----------|--------|
| Heavy imports | `import _ from 'lodash'` (full lib) vs `import map from 'lodash/map'` | Bundle bloat |
| Duplicate dependencies | Multiple versions of same package | Unnecessary size |
| Dev deps in prod | `dependencies` vs `devDependencies` misplacement | Deploy bloat |
| Large assets | Images >500KB, unminified CSS/JS | Slow load times |
| Missing tree-shaking | CommonJS `require()` in ESM project | Dead code not eliminated |

### Detection

```bash
# Check for full library imports (lodash, moment, etc.)
grep -rn "import.*from 'lodash'\|require('lodash')\|import.*from 'moment'" --include="*.ts" --include="*.js" src/

# Check package sizes
du -sh node_modules/*/ 2>/dev/null | sort -rh | head -20
```

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

| Pattern | Symptom | Detection |
|---------|---------|-----------|
| O(n²) nested loops | Nested `for`/`forEach`/`filter` on same collection | `grep -n 'for.*for\|forEach.*forEach\|filter.*filter'` |
| Memory leaks | Event listeners not cleaned up, growing caches without eviction | Check for `addEventListener` without `removeEventListener` |
| String concatenation in loops | Building strings with `+=` in loops | Use `Array.join()` or template literals |
| Synchronous file I/O | `readFileSync`, `writeFileSync` in request handlers | Use async variants |
| Missing caching | Same expensive computation repeated | Check for memoization, cache patterns |
| Large object cloning | `JSON.parse(JSON.stringify(obj))` for deep clone | Use `structuredClone()` or targeted copy |

</algorithmic_concerns>

<thresholds>

## Performance Thresholds

| Metric | Good | Warning | Critical |
|--------|------|---------|----------|
| Function complexity (lines) | <40 | 40-80 | >80 |
| Nested loop depth | 1 | 2 | >2 |
| Bundle size (JS) | <250KB | 250-500KB | >500KB |
| Image size | <200KB | 200-500KB | >500KB |
| DB queries per request | <5 | 5-10 | >10 |
| Memory per request | <50MB | 50-100MB | >100MB |

</thresholds>
