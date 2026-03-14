<overview>
TDD is about design quality, not coverage metrics. Red-green-refactor forces behavior-first thinking, producing cleaner interfaces. TDD work is heavier (2-3 cycles per feature), so TDD features get dedicated plans with 40% context budget.
</overview>

<when_to_use_tdd>

## When to Use TDD

**TDD candidates (`type: tdd`):** Business logic with defined I/O, API endpoints, data transformations, validation rules, algorithms, state machines, utility functions.

**Skip TDD (`type: execute`):** UI/styling, config changes, glue code, scripts/migrations, simple CRUD, exploratory prototyping.

**Heuristic:** Can you write `expect(fn(input)).toBe(output)` before writing `fn`? Yes → TDD. No → standard plan.

</when_to_use_tdd>

<tdd_plan_structure>

## TDD Plan Structure

One feature per plan. `type: tdd` in frontmatter. Sections: Objective, Context, Acceptance Criteria (AC-1: failing test, AC-2: impl passes, AC-3: refactor), Feature (behavior spec), Verification, Boundaries.

</tdd_plan_structure>

<execution_flow>

## Red-Green-Refactor Cycle

**RED:** Create test file → write behavior tests → run tests (MUST fail) → if passes, investigate → commit `test({phase}-{plan}): ...`

**GREEN:** Write minimal code → run tests (MUST pass) → fix if existing tests break → commit `feat({phase}-{plan}): ...`

**REFACTOR:** Review for improvements → run tests (MUST still pass) → commit only if changes: `refactor({phase}-{plan}): ...`

Result: 2-3 atomic commits per TDD plan. Example:
```
test(08-02): add failing test for email validation
feat(08-02): implement email validation
refactor(08-02): extract regex to constant (optional)
```

</execution_flow>

<test_quality>

## Good Tests

- **Test behavior, not implementation:** "returns formatted date" not "calls formatDate helper"
- **One concept per test:** Separate tests for valid, empty, malformed input
- **Descriptive names:** "should reject empty email", not "test1"
- **No implementation details:** Test public API, not private methods

## Test Quality Heuristics (inspired by BMAD quality scoring)

Advisory checks to assess test quality after RED phase:

- **Assertion density:** Each test should have at least 1 meaningful assertion. Tests with no assertions are worthless.
- **Behavior vs implementation:** Assertions should check WHAT (return value, state change, side effect) not HOW (which helper was called, internal method order).
- **Edge case coverage:** For each happy path test, consider: empty input, null/undefined, boundary values, error states. At least 1 edge case per feature.
- **Mock hygiene:** Mocks should match real interfaces. Mock complexity > ~10 lines → prefer integration test.
- **Test isolation:** Each test should pass independently. No shared mutable state between tests. No order dependency.

</test_quality>

<context_budget>

## Context Budget: ~40%

Lower than standard 50% because RED/GREEN/REFACTOR each involve file reads, test runs, potential debugging. Single feature focus ensures full quality throughout.

</context_budget>

<error_handling>

## Error Handling

- **RED passes:** Feature may exist or test is wrong. Investigate before proceeding.
- **GREEN fails:** Debug implementation. Don't skip to refactor. Keep iterating.
- **REFACTOR breaks tests:** Undo. Refactor in smaller steps.
- **Unrelated tests break:** Stop and investigate coupling.

</error_handling>

<operational_workflows>

## PAUL Integration

- **Planning:** tdd-plan-generation.md (plan structure), tdd-detection.md (candidate detection)
- **Execution:** tdd-execution.md (phase-gated RED→GREEN→REFACTOR)
- **Auditing:** unify-phase.md audit_tdd_execution (verify commits via git log, run tests, document in SUMMARY.md)

</operational_workflows>
