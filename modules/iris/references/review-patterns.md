<overview>
Review patterns organized by category. Each pattern describes what to look for, why it matters, and how to fix it. Use these during code review to catch common issues.

**Usage:** /paul:review selects applicable patterns based on file types and change characteristics. Not all patterns apply to every review — relevance is context-dependent.
</overview>

<code_smells>

## Code Smells

### Duplication
- **Look for:** Identical or near-identical code blocks across files or within the same file
- **Why it matters:** Duplicated logic diverges over time, creating inconsistent behavior and doubling maintenance cost
- **Suggested fix:** Extract shared logic into a function, method, or module

### Long Functions/Methods
- **Look for:** Functions exceeding ~40 lines or methods doing more than one thing
- **Why it matters:** Long functions are harder to test, harder to name, and harder to reuse
- **Suggested fix:** Split into smaller functions with descriptive names reflecting each responsibility

### Deep Nesting
- **Look for:** More than 3 levels of indentation (nested if/for/try blocks)
- **Why it matters:** Deep nesting makes control flow difficult to follow and increases cyclomatic complexity
- **Suggested fix:** Use early returns, guard clauses, or extract nested blocks into named functions

### Feature Envy
- **Look for:** A function that accesses data from another object/module more than its own
- **Why it matters:** Indicates misplaced logic — the function may belong in the other module
- **Suggested fix:** Move the logic to the class/module whose data it primarily uses

### God Objects/Files
- **Look for:** Files exceeding ~300 lines or classes with >10 methods touching different concerns
- **Why it matters:** Concentrates too much responsibility, making changes risky and testing difficult
- **Suggested fix:** Split into focused modules, each with a single responsibility

### Primitive Obsession
- **Look for:** Using strings/numbers where a domain type would be clearer (e.g., status as string instead of enum)
- **Why it matters:** Loses type safety and domain semantics; allows invalid states
- **Suggested fix:** Introduce domain types, enums, or value objects

### Shotgun Surgery
- **Look for:** A single change requiring edits across many files
- **Why it matters:** High coupling — changes ripple unpredictably, and forgetting one file causes bugs
- **Suggested fix:** Consolidate related logic or introduce a facade/adapter

</code_smells>

<security_concerns>

## Security Concerns

### SQL/Command Injection
- **Look for:** String concatenation or template literals building SQL queries or shell commands with user input
- **Why it matters:** Allows attackers to execute arbitrary SQL or system commands
- **Suggested fix:** Use parameterized queries for SQL; use array-based command execution for shell

### Cross-Site Scripting (XSS)
- **Look for:** User input rendered in HTML without escaping; `dangerouslySetInnerHTML`, `innerHTML`, or template `{!! !!}` with user data
- **Why it matters:** Allows attackers to inject scripts that run in other users' browsers
- **Suggested fix:** Use framework auto-escaping; sanitize HTML input with a trusted library

### Hardcoded Secrets
- **Look for:** API keys, passwords, tokens, or connection strings in source code; `.env` files committed to git
- **Why it matters:** Secrets in code are visible to anyone with repository access
- **Suggested fix:** Use environment variables, secret managers, or `.env` files (gitignored)

### Unsafe Deserialization
- **Look for:** `eval()`, `pickle.loads()`, `JSON.parse()` on untrusted input without validation, `yaml.load()` without SafeLoader
- **Why it matters:** Allows arbitrary code execution through crafted input
- **Suggested fix:** Validate and sanitize input before deserialization; use safe loaders

### Missing Input Validation
- **Look for:** API endpoints accepting user input without validation; form submissions without server-side checks
- **Why it matters:** Invalid input can cause crashes, data corruption, or security vulnerabilities
- **Suggested fix:** Validate at system boundaries using schema validation (Zod, Pydantic, etc.)

### Insecure Randomness
- **Look for:** `Math.random()`, `random.random()` used for security-sensitive values (tokens, IDs, passwords)
- **Why it matters:** Predictable random values can be guessed by attackers
- **Suggested fix:** Use `crypto.randomUUID()`, `secrets` module, or OS-level CSPRNG

### Path Traversal
- **Look for:** File paths constructed from user input without sanitization; `../` patterns in file access
- **Why it matters:** Allows reading/writing arbitrary files on the server
- **Suggested fix:** Validate paths against an allowlist; use `path.resolve()` and verify the result is within expected directory

</security_concerns>

<performance_antipatterns>

## Performance Anti-Patterns

### N+1 Queries
- **Look for:** Database queries inside loops; fetching related records one at a time instead of batch
- **Why it matters:** Creates O(N) database round-trips instead of O(1), causing latency that scales with data size
- **Suggested fix:** Use eager loading, joins, or batch queries (e.g., `WHERE id IN (...)`)

### Unnecessary Allocations in Loops
- **Look for:** Creating objects, arrays, or strings inside tight loops when they could be pre-allocated or reused
- **Why it matters:** Generates garbage collection pressure and memory churn
- **Suggested fix:** Hoist allocations outside the loop; use buffer pools for hot paths

### Blocking I/O in Async Contexts
- **Look for:** Synchronous file reads, network calls, or sleep in async functions or event handlers
- **Why it matters:** Blocks the event loop/thread pool, causing all concurrent operations to stall
- **Suggested fix:** Use async equivalents (`fs.promises`, `aiohttp`, `tokio::fs`)

### Missing Pagination
- **Look for:** API endpoints returning unbounded result sets; queries without LIMIT
- **Why it matters:** Memory exhaustion and slow responses as data grows
- **Suggested fix:** Add pagination (cursor-based preferred) with reasonable default limits

### Unbounded Queries
- **Look for:** `SELECT *` or queries without WHERE clauses on large tables
- **Why it matters:** Full table scans become progressively slower as data grows
- **Suggested fix:** Add appropriate WHERE filters; select only needed columns

### Excessive Logging
- **Look for:** Logging inside loops, logging large objects, debug-level logging in production paths
- **Why it matters:** I/O overhead from logging can dominate hot-path performance
- **Suggested fix:** Log at appropriate levels; use structured logging; avoid logging in tight loops

</performance_antipatterns>

<maintainability_issues>

## Maintainability Issues

### Missing Error Handling
- **Look for:** Uncaught promise rejections, empty catch blocks, swallowed errors, missing error boundaries
- **Why it matters:** Silent failures hide bugs and make debugging difficult
- **Suggested fix:** Handle errors explicitly; log with context; propagate or convert to user-facing messages

### Tight Coupling
- **Look for:** Direct imports across module boundaries; concrete class dependencies instead of interfaces
- **Why it matters:** Changes in one module cascade to dependents; makes testing and replacement difficult
- **Suggested fix:** Depend on interfaces/abstractions; use dependency injection; define clear module boundaries

### Magic Numbers/Strings
- **Look for:** Unexplained numeric literals or string constants in logic (e.g., `if (status === 3)`, `timeout: 86400000`)
- **Why it matters:** Intent is unclear; same value may appear in multiple places and diverge
- **Suggested fix:** Extract to named constants with descriptive names (e.g., `STATUS_APPROVED`, `ONE_DAY_MS`)

### Unclear Naming
- **Look for:** Single-letter variables (outside loops), abbreviations, misleading names, generic names like `data`, `temp`, `result`
- **Why it matters:** Code is read far more than written; unclear names force readers to trace logic to understand intent
- **Suggested fix:** Use descriptive names that reveal purpose; match domain language

### Commented-Out Code
- **Look for:** Blocks of code commented out "for later" or "just in case"
- **Why it matters:** Adds noise; creates confusion about whether it's needed; version control preserves history
- **Suggested fix:** Delete it; retrieve from git history if needed later

### TODO Without Tracking
- **Look for:** `TODO`, `FIXME`, `HACK` comments without associated issue/ticket references
- **Why it matters:** Untracked TODOs accumulate indefinitely and are never addressed
- **Suggested fix:** Create a tracked issue for each TODO; reference the issue ID in the comment

### Missing Types/Interfaces
- **Look for:** `any` types, untyped function parameters, missing return types in TypeScript/typed languages
- **Why it matters:** Loses compiler-checked correctness; enables runtime type errors
- **Suggested fix:** Add explicit types; define interfaces for data shapes; avoid `any`

</maintainability_issues>
