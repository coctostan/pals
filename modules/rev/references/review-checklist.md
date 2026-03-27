# REV Review Checklist — 8 Dimensions

## 1. Correctness

**What to check:** Does the code do what the diff claims? Logic errors, off-by-ones, wrong comparisons, null handling, incorrect return values, missing early returns.

**Severity guide:**
- **Critical:** Wrong behavior that would affect users or data
- **Important:** Edge case logic error that could trigger under specific conditions

**Examples:**
- `if (count > 0)` when it should be `>= 0` (off-by-one)
- Missing null check before property access on optional value
- Wrong variable used in comparison (`a > b` when `a > c` was intended)

---

## 2. Edge Cases

**What to check:** Null/undefined inputs, empty arrays/strings, concurrent access, boundary values (0, -1, MAX_INT), error paths, race conditions.

**Severity guide:**
- **Important:** Edge case that is likely to occur in production
- **Minor:** Edge case that requires unusual conditions to trigger

**Examples:**
- Function receives empty array but assumes at least one element
- No handling for network timeout in API call
- Date logic doesn't account for timezone or DST transitions

---

## 3. Naming & Clarity

**What to check:** Would someone new understand this in 6 months? Misleading names, unclear intent, missing comments on non-obvious logic, overly clever code, inconsistent naming conventions.

**Severity guide:**
- **Important:** Actively misleading name that will cause bugs during maintenance
- **Minor:** Unclear but not misleading — could be better

**Examples:**
- Variable named `data` that holds a specific subset of user records
- Complex regex without a comment explaining what it matches
- Function named `process()` with no indication of what it processes

---

## 4. Architecture Fit

**What to check:** Does this change belong here structurally? Layer violations, wrong module, responsibility creep, circular dependencies, god objects growing.

**Severity guide:**
- **Important:** Structural violation that will compound over time
- **Minor:** Cosmetic placement issue, easy to fix later

**Examples:**
- Database query logic placed in a UI component
- Utility function added to a domain-specific module it doesn't belong to
- Single file growing to handle multiple unrelated responsibilities

---

## 5. Performance

**What to check:** O(n²) hiding in loops, unnecessary re-renders, N+1 queries, large allocations in hot paths, synchronous I/O in async contexts, missing pagination.

**Severity guide:**
- **Critical:** Production impact on response times or resource usage
- **Important:** Detectable performance issue under normal load

**Examples:**
- Nested loop over two arrays that could be a single pass with a Set
- `SELECT *` without LIMIT in a user-facing endpoint
- Re-creating a large object on every render when it could be memoized

---

## 6. Security Surface

**What to check:** New attack vectors, unvalidated input, auth gaps, secrets exposure, injection risks (SQL, XSS, command), missing rate limiting on sensitive endpoints.

**Severity guide:**
- **Critical:** Exploitable vulnerability (injection, auth bypass, secret leak)
- **Important:** Attack surface expanded without mitigation

**Examples:**
- User input passed directly to SQL query without parameterization
- API endpoint missing authentication middleware
- Hardcoded API key or password in source code

---

## 7. Test Coverage

**What to check:** Are important paths tested? Are tests testing the right thing (not just running without assertions)? Are edge cases from dimension 2 covered? Do tests break if the logic changes?

**Severity guide:**
- **Important:** Critical business logic path has no test coverage
- **Minor:** Edge case or error path not covered by tests

**Examples:**
- New payment processing function with no test
- Test that asserts `expect(result).toBeDefined()` but doesn't check the value
- Happy path tested but error/rejection path has no coverage

---

## 8. Rollback Safety

**What to check:** If this breaks in production, how hard is it to undo? Database migrations (especially destructive), API contract changes, state mutations, feature flag usage, data format changes.

**Severity guide:**
- **Important:** Irreversible change without explicit rollback plan
- **Minor:** Change is easily reverted by deploying previous version

**Examples:**
- `DROP COLUMN` migration without data backup strategy
- Removing a public API field that external consumers depend on
- Changing serialization format without backward compatibility
