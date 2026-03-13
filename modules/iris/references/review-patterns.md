<overview>
Review patterns by category. /paul:review selects applicable patterns based on file types and change characteristics.
</overview>

<code_smells>

## Code Smells

- **Duplication:** Identical/near-identical blocks → extract shared function/module
- **Long Functions:** >~40 lines or multiple responsibilities → split into named functions
- **Deep Nesting:** >3 indentation levels → early returns, guard clauses, extract blocks
- **Feature Envy:** Function uses another module's data more than its own → move logic there
- **God Objects:** >~300 line files, >10 methods on different concerns → split by responsibility
- **Primitive Obsession:** Strings/numbers where domain types fit → enums, value objects
- **Shotgun Surgery:** One change = edits across many files → consolidate or add facade

</code_smells>

<security_concerns>

## Security Concerns

- **SQL/Command Injection:** String concat with user input in SQL/shell → parameterized queries, array-based execution
- **XSS:** User input rendered unescaped (`dangerouslySetInnerHTML`, `innerHTML`) → framework auto-escaping, sanitize library
- **Hardcoded Secrets:** API keys/tokens/passwords in source → env vars, secret managers, gitignored .env
- **Unsafe Deserialization:** `eval()`, `pickle.loads()`, `yaml.load()` on untrusted input → validate first, use safe loaders
- **Missing Input Validation:** API endpoints without validation → schema validation (Zod, Pydantic)
- **Insecure Randomness:** `Math.random()`/`random.random()` for security values → `crypto.randomUUID()`, `secrets` module
- **Path Traversal:** File paths from user input without sanitization → allowlist, `path.resolve()` + boundary check

</security_concerns>

<performance_antipatterns>

## Performance Anti-Patterns

- **N+1 Queries:** DB queries inside loops → eager loading, joins, batch `WHERE id IN (...)`
- **Allocations in Loops:** Creating objects/arrays in tight loops → hoist outside, buffer pools
- **Blocking I/O in Async:** Sync file/network in async functions → async equivalents (`fs.promises`, `aiohttp`)
- **Missing Pagination:** Unbounded result sets → cursor-based pagination with default limits
- **Unbounded Queries:** `SELECT *` without WHERE on large tables → filters, select needed columns
- **Excessive Logging:** Logging in loops, large objects, debug in prod paths → appropriate levels, structured logging

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
