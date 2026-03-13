<overview>
Review patterns by category. /paul:review selects applicable patterns based on file types and change characteristics.
</overview>

<code_smells>

## Code Smells

- **Duplication:** Identical/near-identical blocks → extract shared function/module. *Why:* Duplicated logic diverges over time, creating inconsistent behavior and doubling maintenance cost.
- **Long Functions:** >~40 lines or multiple responsibilities → split into named functions. *Why:* Harder to test, name, and reuse.
- **Deep Nesting:** >3 indentation levels → early returns, guard clauses, extract blocks. *Why:* Control flow becomes difficult to follow; increases cyclomatic complexity.
- **Feature Envy:** Function uses another module's data more than its own → move logic there. *Why:* Indicates misplaced logic.
- **God Objects:** >~300 line files, >10 methods on different concerns → split by responsibility. *Why:* Concentrates risk; makes changes dangerous and testing difficult.
- **Primitive Obsession:** Strings/numbers where domain types fit → enums, value objects. *Why:* Loses type safety; allows invalid states.
- **Shotgun Surgery:** One change = edits across many files → consolidate or add facade. *Why:* High coupling; forgetting one file causes bugs.

</code_smells>

<security_concerns>

## Security Concerns

- **SQL/Command Injection:** String concat with user input in SQL/shell → parameterized queries, array-based execution. *Why:* Allows arbitrary SQL or system command execution.
- **XSS:** User input rendered unescaped (`dangerouslySetInnerHTML`, `innerHTML`) → framework auto-escaping, sanitize library. *Why:* Attacker scripts run in other users' browsers.
- **Hardcoded Secrets:** API keys/tokens/passwords in source → env vars, secret managers, gitignored .env. *Why:* Visible to anyone with repo access.
- **Unsafe Deserialization:** `eval()`, `pickle.loads()`, `yaml.load()` on untrusted input → validate first, use safe loaders. *Why:* Arbitrary code execution through crafted input.
- **Missing Input Validation:** API endpoints without validation → schema validation (Zod, Pydantic). *Why:* Invalid input causes crashes, data corruption, or security holes.
- **Insecure Randomness:** `Math.random()`/`random.random()` for security values → `crypto.randomUUID()`, `secrets` module. *Why:* Predictable values can be guessed by attackers.
- **Path Traversal:** File paths from user input without sanitization → allowlist, `path.resolve()` + boundary check. *Why:* Allows reading/writing arbitrary files on the server.

</security_concerns>

<performance_antipatterns>

## Performance Anti-Patterns

- **N+1 Queries:** DB queries inside loops → eager loading, joins, batch `WHERE id IN (...)`. *Why:* O(N) round-trips instead of O(1); latency scales with data size.
- **Allocations in Loops:** Creating objects/arrays in tight loops → hoist outside, buffer pools. *Why:* GC pressure and memory churn.
- **Blocking I/O in Async:** Sync file/network in async functions → async equivalents (`fs.promises`, `aiohttp`). *Why:* Blocks event loop/thread pool; stalls all concurrent operations.
- **Missing Pagination:** Unbounded result sets → cursor-based pagination with default limits. *Why:* Memory exhaustion and slow responses as data grows.
- **Unbounded Queries:** `SELECT *` without WHERE on large tables → filters, select needed columns. *Why:* Full table scans get progressively slower.
- **Excessive Logging:** Logging in loops, large objects, debug in prod paths → appropriate levels, structured logging. *Why:* I/O overhead can dominate hot-path performance.

</performance_antipatterns>

<maintainability_issues>

## Maintainability Issues

- **Missing Error Handling:** Uncaught rejections, empty catch, swallowed errors → handle explicitly, log with context
- **Tight Coupling:** Direct imports across boundaries, concrete deps → interfaces, DI, clear boundaries
- **Magic Numbers/Strings:** Unexplained literals → named constants (`STATUS_APPROVED`, `ONE_DAY_MS`)
- **Unclear Naming:** Single-letter vars, abbreviations, generic `data`/`temp` → descriptive, domain-language names
- **Commented-Out Code:** "For later" blocks → delete, use git history
- **TODO Without Tracking:** `TODO`/`FIXME` without issue refs → create tracked issue
- **Missing Types:** `any`, untyped params, missing return types → explicit types, interfaces

</maintainability_issues>
