# Refactor Principles

RUBY's foundational guidelines for when, why, and how to refactor code safely.

## Philosophy

- **Small safe steps:** Each refactoring should be a single, behavior-preserving transformation. Never combine multiple refactorings into one change.
- **Always test-backed:** Only refactor code that has test coverage. If tests don't exist, write them first (characterization tests), then refactor.
- **Behavior-preserving:** Refactoring changes structure, not behavior. If behavior changes, it's not a refactoring — it's a rewrite.
- **Incremental over big-bang:** Prefer many small improvements over large rewrites. Extract-and-replace beats rewrite-in-place.

## When to Refactor

| Timing | Rationale |
|--------|-----------|
| After milestones | Natural pause point; codebase is stable, tests are passing |
| Before new features | Clean foundation makes new work faster and less error-prone |
| High-churn files | Files changed frequently benefit most from clarity improvements |
| During bug fixes | You already understand the context; leave it better than you found it |
| Code review findings | When review surfaces structural issues, address them promptly |

## When NOT to Refactor

| Situation | Why Not |
|-----------|---------|
| During active feature work | Context switching increases risk; finish the feature first |
| Without test coverage | No safety net means refactoring can silently break behavior |
| Under deadline pressure | Rushed refactoring creates new problems; defer to after deadline |
| If it doesn't reduce complexity | Refactoring for refactoring's sake is waste; measure improvement |
| Stable, rarely-changed code | Low-churn code has low ROI for refactoring effort |

## Risk Assessment

Before refactoring, evaluate three dimensions:

### Blast Radius
- How many callers/consumers does this code have?
- Are there external consumers (APIs, libraries, shared modules)?
- High blast radius → smaller steps, more verification

### Test Coverage
- Does the code under change have tests?
- Do the tests cover edge cases or just happy path?
- Low coverage → write characterization tests first

### Complexity Delta
- Will the refactoring actually reduce complexity?
- Measure: fewer lines, lower cyclomatic complexity, clearer naming
- If complexity stays the same or increases → reconsider

## The Boy Scout Rule

> Leave the code better than you found it.

- Scope improvements to files you're already touching
- Don't go on a refactoring spree across unrelated files
- Small improvements compound over time
- Document why you made the change (commit message, not code comment)

## Refactoring vs Rewriting

| Refactoring | Rewriting |
|-------------|-----------|
| Incremental, step-by-step | Replace wholesale |
| Behavior preserved at each step | Behavior re-implemented |
| Low risk per change | High risk, big-bang |
| Can stop at any point | Must finish to have working code |
| Preferred for most situations | Reserved for fundamentally broken designs |

**Default to refactoring.** Only consider rewriting when:
- The existing design cannot support the required behavior
- The code has no tests and is too tangled to add them
- A rewrite is scoped small enough to complete in one session
