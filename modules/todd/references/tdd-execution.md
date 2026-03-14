<purpose>
TDD execution spec. Phase-gated RED-GREEN-REFACTOR with atomic commits.
Referenced by apply-phase.md when executing `type: tdd` plans.
</purpose>

<references>
kernel/references/tdd.md
kernel/references/tdd-plan-generation.md
</references>

<process>

<step name="detect_test_command" priority="first">
Check in order: `package.json` → npm/jest/vitest, `Cargo.toml` → cargo test, `pyproject.toml` → pytest, `go.mod` → go test, `mix.exs` → mix test, `Makefile` → make test.
No runner found → ask user. Store as `test_command`. Optionally store `test_command_focused` for single-file runs.
</step>

<step name="execute_red" gate="entry">
**RED: Write failing test**

**Test anti-patterns to avoid** (inspired by Superpowers anti-pattern injection):
- No mock behavior assertions without verifying mock setup matches real interface
- No test-only methods on production code just to make testing easier
- No incomplete mocks that silently return undefined/null for untested paths
- Mock complexity > 10 lines → consider integration test instead

1. Read RED task and `<feature><behavior>` from plan
2. Create test file (project conventions, descriptive names: "should [behavior] when [condition]")
3. Run `test_command` and **classify failure reason** (inspired by SWE-agent/Superpowers "failing for the right reason" validation):
   - **CORRECT FAILURE — missing module/function/method:** Impl doesn't exist yet. This is the expected RED state. Log: "RED verified — failing for the right reason (missing impl)."
   - **WRONG FAILURE — syntax error in test:** STOP. Fix test syntax before proceeding. Do not count as valid RED.
   - **WRONG FAILURE — import/config error for test framework:** STOP. Configure framework before proceeding.
   - **WRONG FAILURE — unrelated test breaks:** STOP. Investigate coupling before proceeding.
   - **Tests PASS (unexpected):** STOP. Do NOT proceed. Present options: fix test / feature exists / stop.
4. Commit: `git commit -m "test({phase}-{plan}): add failing test for [feature]"`
5. Store `red_commit_hash`. Unlock GREEN.
</step>

<step name="execute_green" gate="red_complete">
**GREEN: Implement to pass**

**GATE:** `red_commit_hash` must exist. If not → STOP: "Cannot start GREEN without verified RED phase."

**CONTRACT RULE:** Do NOT modify tests to make them pass. Tests define the contract. If tests seem wrong, go back to RED to fix them. (Inspired by Cline anti-pattern: agents that change tests to match broken implementation.)

1. Read GREEN task and `<feature><implementation>` from plan
2. Write MINIMAL implementation — just make tests green, no cleverness
3. Run `test_command`:
   - **ALL pass:** Log success.
   - **New tests fail:** Read test output and use it for diagnosis (inspired by Aider's reflection loop). Iterate implementation (max 2 attempts, DO NOT change tests). Stalled → present options.
   - **Existing tests break:** Fix without changing new test expectations.
4. Commit: `git commit -m "feat({phase}-{plan}): implement [feature]"`
5. Store `green_commit_hash`. Unlock REFACTOR.
</step>

<step name="execute_refactor" gate="green_complete">
**REFACTOR: Clean up**

**GATE:** `green_commit_hash` must exist. If not → STOP: "Cannot start REFACTOR without verified GREEN phase."

1. Review: extract constants, rename for clarity, remove duplication, simplify
2. No improvements needed → log skip, proceed to results (no commit)
3. If changes made → run `test_command`:
   - **Pass:** Commit `refactor({phase}-{plan}): clean up [feature]`
   - **Break:** Undo breaking change, re-verify, log partial application
4. Store `refactor_commit_hash` if committed.
</step>

<step name="return_results">
```
TDD Execution Results:
  RED:      ✓ verified (commit: {hash})
  GREEN:    ✓ verified (commit: {hash})
  REFACTOR: ✓ complete / skipped (commit: {hash} / none)
  Total commits: 2-3
  All tests passing: yes
```
</step>

</process>

<error_handling>
- **Test command not found:** Ask user.
- **RED passes unexpectedly:** Stop. Do NOT proceed — undermines TDD.
- **GREEN fails after 3 iterations:** Stop. Rethink test expectations or approach.
- **REFACTOR breaks tests:** Undo immediately. Never commit broken tests.
- **Git commit fails:** Check init/hooks, report to user.
</error_handling>

<anti_patterns>
- **Changing tests to match implementation:** Tests define the contract. Go back to RED to fix tests. NEVER weaken assertions to make GREEN pass.
- **Skipping RED verification:** Must verify failure first — and failure must be for the RIGHT reason.
- **Ignoring test output on failure:** Always read and use test stdout/stderr to diagnose the issue before retrying.
- **Over-engineering GREEN:** Simplest passing code. Elegance in REFACTOR.
- **New behavior in REFACTOR:** REFACTOR changes HOW, not WHAT.
- **Batching commits:** Each phase gets its own commit for audit trail.
- **Excessive mocking:** If mock setup exceeds ~10 lines, consider integration test instead.
</anti_patterns>
