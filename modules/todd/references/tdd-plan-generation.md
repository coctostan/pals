<purpose>
TDD plan generation spec. Creates PLAN.md with RED/GREEN/REFACTOR task structure and 40% context budget.
Referenced by plan-phase.md when plan type is "tdd".
</purpose>

<references>
references/tdd.md
references/tdd-detection.md
</references>

<process>

<step name="confirm_tdd_suitability">
1. Run TDD detection from tdd-detection.md
2. STRONG → proceed. MODERATE → suggest splitting, ask user. SKIP → recommend `type: execute`, ask user.
</step>

<step name="gather_feature_specification">
From user or ROADMAP.md scope, gather:
1. **Feature name**
2. **Behavior:** Happy path, edge cases, error cases (input → output)
3. **Files:** Source and test files to create/modify

If inferrable from ROADMAP.md, confirm rather than ask.
</step>

<step name="generate_tdd_plan">
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

**Objective:** Goal, purpose (why TDD helps here), output files. **Context budget: 40%.**

**Context:** .paul/PROJECT.md, .paul/ROADMAP.md, .paul/STATE.md, relevant source files.

**Acceptance Criteria (always these three):**
- AC-1: Failing test written (fails for RIGHT reason — missing impl, not syntax)
- AC-2: Implementation passes all tests (new + existing)
- AC-3: Refactor complete (or skipped), all tests still pass

**Feature section:**
```markdown
<feature>
  <name>[Feature]</name>
  <files>[source, test]</files>
  <behavior>
    Cases:
    - [input] → [output]
    - [edge case] → [handling]
    - [error case] → [error]
  </behavior>
  <implementation>[Approach, not code]</implementation>
</feature>
```

**Tasks (always RED → GREEN → REFACTOR):**
- RED: Write failing tests covering behavior cases. DO NOT write implementation. Verify tests FAIL for right reason.
- GREEN: Write MINIMAL code to pass. No cleverness. Verify ALL tests pass.
- REFACTOR: Review for improvements (constants, naming, duplication). Skip if unnecessary. Verify tests still pass.

**Boundaries:** One feature only. No behavior beyond tests. No "while I'm here" changes.

**Verification:** Test file exists, all pass, minimal impl, refactoring didn't break tests.
</step>

<step name="commit_guidance">
```
RED:      test({phase}-{plan}): add failing test for [feature]
GREEN:    feat({phase}-{plan}): implement [feature]
REFACTOR: refactor({phase}-{plan}): clean up [feature] (only if changes made)
```
</step>

</process>

<anti_patterns>
- **Batching features:** One feature per TDD plan. Trivial enough to batch = skip TDD.
- **Vague behavior:** Specify input → output. "Should work correctly" is not a spec.
- **Testing implementation:** Tests describe WHAT, not HOW.
- **Skipping RED verification:** Must fail first to know tests are valid.
- **Over-engineering GREEN:** Minimal only. Elegance comes in REFACTOR.
</anti_patterns>
