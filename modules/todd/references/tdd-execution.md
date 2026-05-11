<purpose>
TDD execution spec. Phase-gated RED-GREEN-REFACTOR with atomic commits.
Referenced by apply-phase.md when executing `type: tdd` plans.
</purpose>

<references>
references/tdd.md
references/tdd-plan-generation.md
</references>

<process>

<step name="detect_test_command" priority="first">
Check in order: `package.json` → npm/jest/vitest, `Cargo.toml` → cargo test, `pyproject.toml` → pytest, `go.mod` → go test, `mix.exs` → mix test, `Makefile` → make test.
No runner found → ask user. Store as `test_command`. Optionally store `test_command_focused` for single-file runs.
</step>

<step name="execute_red" gate="entry">
**RED: Write failing test**

**Test anti-patterns to avoid**:
- No mock behavior assertions unless mock setup matches the real interface
- No test-only production methods
- No incomplete mocks that silently return undefined/null
- Mock setup >10 lines → consider integration test instead

1. Read RED task and `<feature><behavior>` from plan.
2. Create the test using project conventions and descriptive names: "should [behavior] when [condition]".
3. Run `test_command` and classify the result:
   - **VALID RED:** the new/changed test fails for the expected behavior gap. Record command, exit status, and failure summary.
   - **INVALID RED:** syntax, import, framework, config, or unrelated-test failure. BLOCK with expected vs observed evidence.
   - **UNEXPECTED PASS:** BLOCK; the test did not prove missing behavior.
4. On VALID RED, commit: `git commit -m "test({phase}-{plan}): add failing test for [feature]"`.
5. Record `red_commit_hash`, command, and RED failure summary. Unlock GREEN.
</step>

<step name="execute_green" gate="red_complete">
**GREEN: Implement to pass**

**GATE:** `red_commit_hash` must exist. If missing, BLOCK: "Cannot start GREEN without verified RED evidence."

**CONTRACT RULE:** Do not weaken tests to make GREEN pass. If the test is wrong, return to RED and record why.

1. Read GREEN task and `<feature><implementation>` from plan.
2. Write the minimal implementation needed to satisfy the RED test.
3. Run `test_command`:
   - **PASS:** record command and result.
   - **STILL FAILS:** retry implementation at most twice using test output. If still failing, BLOCK with expected vs observed evidence.
   - **REGRESSION:** existing tests now fail. BLOCK; fix without weakening the new test or stop for parent APPLY decision.
4. Commit: `git commit -m "feat({phase}-{plan}): implement [feature]"`.
5. Record `green_commit_hash` and result summary. Unlock REFACTOR.
</step>

<step name="execute_refactor" gate="green_complete">
**REFACTOR: Clean up**

**GATE:** `green_commit_hash` must exist. If missing, BLOCK: "Cannot start REFACTOR without verified GREEN evidence."

1. Improve clarity, duplication, naming, or simplicity only.
2. If no safe improvement is needed, record `refactor_skipped` with reason.
3. If changes are made, run `test_command`:
   - **PASS:** commit `refactor({phase}-{plan}): clean up [feature]`.
   - **BREAK:** undo only the breaking refactor change, re-run tests, and record evidence.
4. Record `refactor_commit_hash` if committed.
</step>

<step name="return_results">
Return compact evidence for parent APPLY and SUMMARY:

TDD Execution Results:
  RED:      ✓ verified (commit: {hash}, failure: {summary})
  GREEN:    ✓ verified (commit: {hash}, result: {summary})
  REFACTOR: ✓ complete / skipped (commit: {hash} / reason)
  Test command: {test_command}
  All tests passing: yes/no
</step>

<error_handling>
- **Test command not found:** BLOCK for parent APPLY/user decision.
- **RED invalid or passes unexpectedly:** BLOCK; do not proceed to GREEN.
- **GREEN still fails after two retries:** BLOCK with expected vs observed evidence.
- **REFACTOR breaks tests:** undo only the breaking refactor change and re-verify.
- **Git commit fails:** report command/error; parent APPLY decides retry or stop.
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
