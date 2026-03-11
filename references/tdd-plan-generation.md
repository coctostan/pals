<purpose>
TDD plan generation specification. Defines how to create a TDD-specific PLAN.md with RED/GREEN/REFACTOR task structure, feature behavior specification, and 40% context budget.

**Referenced by plan-phase.md when plan type is "tdd".**
</purpose>

<when_to_use>
- plan-phase.md determines the plan type should be "tdd"
- TDD detection (see @references/tdd-detection.md) returns STRONG or MODERATE assessment
- User explicitly requests a TDD plan
</when_to_use>

<references>
@~/.pals/references/tdd.md
@~/.pals/references/tdd-detection.md
</references>

<process>

<step name="confirm_tdd_suitability">
1. Run TDD detection from @references/tdd-detection.md against the phase scope
2. Display assessment:
   ```
   TDD Assessment: [STRONG | MODERATE | SKIP]

   Signals:
     + [positive signals]
     - [negative signals]

   Recommendation: [recommendation]
   ```
3. If STRONG: proceed with TDD plan
4. If MODERATE: suggest splitting scope, ask user to confirm
5. If SKIP: recommend switching to `type: execute`, ask user to confirm
</step>

<step name="gather_feature_specification">
Ask user (or infer from ROADMAP.md phase scope):

1. **Feature name:** What is the feature being built?
2. **Behavior:** What are the expected input → output cases?
   - Happy path: input → expected output
   - Edge cases: empty/null/boundary → expected handling
   - Error cases: invalid input → expected error behavior
3. **Files:** Source file(s) and test file(s) that will be created/modified

If behavior can be fully inferred from ROADMAP.md scope, confirm rather than ask.
</step>

<step name="generate_tdd_plan">
Generate PLAN.md with the following structure:

**Frontmatter:**
```yaml
---
phase: XX-name
plan: NN
type: tdd
wave: N
depends_on: []
files_modified: [source files, test files]
autonomous: true
---
```

**Objective section:**
```markdown
<objective>
## Goal
Implement [feature name] using TDD RED-GREEN-REFACTOR cycle.

## Purpose
TDD ensures [feature] has a clean interface designed from behavior specification.
Design benefit: [why TDD improves this specific feature].

## Output
- Working, tested [feature name]
- Test file: [test file path]
- Source file: [source file path]

**Context budget: 40%** — TDD cycles (RED → GREEN → REFACTOR) are heavier than linear execution.
</objective>
```

**Context section:**
```markdown
<context>
## Project Context
@.paul/PROJECT.md
@.paul/ROADMAP.md
@.paul/STATE.md

## Source Files
@[relevant existing source files]
</context>
```

**Acceptance Criteria (always these three for TDD):**
```markdown
<acceptance_criteria>

## AC-1: Failing Test Written
\```gherkin
Given the feature does not yet exist
When the test file is created with behavior specifications
Then running the test suite produces a FAILING test
And the failure is for the RIGHT reason (missing implementation, not syntax error)
\```

## AC-2: Implementation Passes All Tests
\```gherkin
Given a failing test exists for [feature]
When minimal implementation is written to satisfy the test
Then running the test suite produces a PASSING test
And no other existing tests are broken
\```

## AC-3: Refactor Complete
\```gherkin
Given all tests pass after implementation
When code is reviewed for obvious improvements
Then refactoring is applied (or skipped if unnecessary)
And all tests still pass after refactoring
\```

</acceptance_criteria>
```

**Feature section (TDD-specific):**
```markdown
<feature>
  <name>[Feature name]</name>
  <files>[source file], [test file]</files>
  <behavior>
    [Expected behavior in testable terms]

    Cases:
    - [input 1] → [expected output 1]
    - [input 2] → [expected output 2]
    - [edge case] → [expected handling]
    - [error case] → [expected error]
  </behavior>
  <implementation>[How to implement once tests pass — approach, not code]</implementation>
</feature>
```

**Tasks (always RED → GREEN → REFACTOR):**
```markdown
<tasks>

<task type="auto">
  <name>RED: Write failing test for [feature]</name>
  <files>[test file path]</files>
  <action>
    Create test file following project test conventions.
    Write tests covering:
    - [behavior case 1]
    - [behavior case 2]
    - [edge case]
    - [error case]

    Tests must describe BEHAVIOR, not implementation.
    Use descriptive names: "should [expected behavior] when [condition]"

    DO NOT write any implementation code yet.
  </action>
  <verify>
    Run test suite — tests MUST FAIL.
    If tests pass: feature already exists or test is wrong. Investigate before proceeding.
    Failure must be for the right reason (missing function/module, not syntax error).
  </verify>
  <done>AC-1 satisfied: Failing test committed</done>
</task>

<task type="auto">
  <name>GREEN: Implement [feature] to pass tests</name>
  <files>[source file path]</files>
  <action>
    Write MINIMAL code to make all tests pass.
    - No cleverness, no optimization — just make tests green
    - Follow the test's expectations exactly
    - Do not add behavior beyond what tests specify

    Avoid: premature optimization, extra features, "while I'm here" improvements.
  </action>
  <verify>
    Run test suite — ALL tests MUST PASS (both new and existing).
    If new tests pass but existing tests break: fix without changing new test expectations.
  </verify>
  <done>AC-2 satisfied: Implementation passes all tests</done>
</task>

<task type="auto">
  <name>REFACTOR: Clean up [feature] (if needed)</name>
  <files>[source file path], [test file path]</files>
  <action>
    Review implementation for obvious improvements:
    - Extract constants for magic values
    - Rename for clarity
    - Remove duplication
    - Simplify logic

    If no improvements needed, skip this task (note: "No refactoring needed").

    DO NOT add new behavior or change test expectations.
  </action>
  <verify>
    Run test suite — ALL tests MUST STILL PASS.
    If any test breaks: undo refactoring change that caused it.
  </verify>
  <done>AC-3 satisfied: Refactor complete (or skipped), all tests pass</done>
</task>

</tasks>
```

**Boundaries:**
```markdown
<boundaries>

## DO NOT CHANGE
- [files outside this feature's scope]
- [existing test files for other features]

## SCOPE LIMITS
- One feature only: [feature name]
- No behavior beyond what tests specify
- No "while I'm here" improvements to surrounding code

</boundaries>
```

**Verification:**
```markdown
<verification>
Before declaring plan complete:
- [ ] Test file exists with behavior specifications
- [ ] All tests pass (new and existing)
- [ ] Implementation is minimal — no extra behavior
- [ ] Refactoring (if any) didn't break tests
</verification>
```

**Success Criteria:**
```markdown
<success_criteria>
- Failing test written and verified (RED)
- Minimal implementation passes all tests (GREEN)
- Code reviewed and cleaned up (REFACTOR)
- No existing tests broken
</success_criteria>
```

**Output:**
```markdown
<output>
After completion, create `.paul/phases/XX-name/{phase}-{plan}-SUMMARY.md`
</output>
```
</step>

<step name="commit_guidance">
Include commit message guidance in the plan (referenced from @references/tdd.md):

```
Commits for this TDD plan:
  RED:      test({phase}-{plan}): add failing test for [feature]
  GREEN:    feat({phase}-{plan}): implement [feature]
  REFACTOR: refactor({phase}-{plan}): clean up [feature] (only if changes made)
```

These commits are created during APPLY phase execution.
</step>

</process>

<output>
A PLAN.md file with:
- type: tdd in frontmatter
- 40% context budget note
- <feature> section with behavior specification
- Standard TDD acceptance criteria (AC-1, AC-2, AC-3)
- RED → GREEN → REFACTOR task sequence
- Commit message guidance
</output>

<anti_patterns>
**Batching features:**
One feature per TDD plan. If features are trivial enough to batch, skip TDD for them.

**Vague behavior:**
"It should work correctly" is not a behavior spec. Specify input → output cases.

**Testing implementation:**
Tests describe WHAT, not HOW. "Returns formatted date" not "calls formatDate helper".

**Skipping RED verification:**
If tests don't fail first, you don't know they're testing the right thing.

**Over-engineering GREEN:**
Minimal implementation only. Elegance comes in REFACTOR.
</anti_patterns>
