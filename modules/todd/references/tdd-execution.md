<purpose>
TDD execution spec. Phase-gated RED-GREEN-REFACTOR with atomic commits.
Referenced by apply-phase.md when executing `type: tdd` plans.
</purpose>

<references>
@~/.pals/references/tdd.md
@~/.pals/references/tdd-plan-generation.md
</references>

<process>

<step name="detect_test_command" priority="first">
Check in order: `package.json` → npm/jest/vitest, `Cargo.toml` → cargo test, `pyproject.toml` → pytest, `go.mod` → go test, `mix.exs` → mix test, `Makefile` → make test.
No runner found → ask user. Store as `test_command`. Optionally store `test_command_focused` for single-file runs.
</step>

<step name="execute_red" gate="entry">
**RED: Write failing test**

1. Read RED task and `<feature><behavior>` from plan
2. Create test file (project conventions, descriptive names: "should [behavior] when [condition]")
3. Run `test_command`:
   - **Tests FAIL (expected):** Verify failure is correct reason (missing impl, not syntax/import error). Log success.
   - **Tests PASS (unexpected):** STOP. Present options: fix test / feature exists / stop.
4. Commit: `git commit -m "test({phase}-{plan}): add failing test for [feature]"`
5. Store `red_commit_hash`. Unlock GREEN.
</step>

<step name="execute_green" gate="red_complete">
**GREEN: Implement to pass** (requires `red_commit_hash`)

1. Read GREEN task and `<feature><implementation>` from plan
2. Write MINIMAL implementation — just make tests green, no cleverness
3. Run `test_command`:
   - **ALL pass:** Log success.
   - **New tests fail:** Iterate (max 3 attempts, DO NOT change tests). Stalled → present options.
   - **Existing tests break:** Fix without changing new test expectations.
4. Commit: `git commit -m "feat({phase}-{plan}): implement [feature]"`
5. Store `green_commit_hash`. Unlock REFACTOR.
</step>

<step name="execute_refactor" gate="green_complete">
**REFACTOR: Clean up** (requires `green_commit_hash`)

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
- **Changing tests to match implementation:** Tests define the contract. Go back to RED to fix tests.
- **Skipping RED verification:** Must verify failure first.
- **Over-engineering GREEN:** Simplest passing code. Elegance in REFACTOR.
- **New behavior in REFACTOR:** REFACTOR changes HOW, not WHAT.
- **Batching commits:** Each phase gets its own commit for audit trail.
</anti_patterns>
