<purpose>
Execute an approved PLAN.md by running tasks in order, verifying each, handling checkpoints, and recording results for UNIFY phase reconciliation.
</purpose>

<when_to_use>
- User has approved a PLAN.md (explicit approval required)
- STATE.md shows loop position at PLAN complete, ready for APPLY
- No unresolved blockers from planning phase
</when_to_use>

<loop_context>
Expected phase: APPLY
Prior phase: PLAN (approval just received)
Next phase: UNIFY (after execution completes)
</loop_context>

<required_reading>
@.paul/STATE.md
@.paul/phases/{phase}/{plan}-PLAN.md
</required_reading>

<references>
@~/.pals/references/checkpoints.md (if plan has checkpoints)
@~/.pals/references/loop-phases.md
@~/.pals/workflows/apply-phase-tdd.md (if plan type is tdd)
</references>

<process>

<step name="validate_approval" priority="first">
1. Confirm user has explicitly approved the plan
   - Do NOT assume approval
   - Look for explicit signal: "approved", "execute", "go ahead", etc.
2. Read STATE.md to verify:
   - Loop position shows PLAN complete
   - Correct phase and plan identified
3. If approval unclear:
   - Ask: "Plan ready at [path]. Approve execution?"
   - Wait for explicit approval before proceeding
</step>

<step name="load_plan">
1. Read the PLAN.md file
2. Parse frontmatter:
   - autonomous: determines checkpoint handling
   - files_modified: track what we'll change
   - depends_on: verify dependencies met
3. Extract tasks from <tasks> section
4. Note boundaries from <boundaries> section
5. Load acceptance criteria for verification reference
6. If frontmatter type is "tdd":
   - Set tdd_mode = true
   - Log: "TDD plan detected — will use RED-GREEN-REFACTOR execution"
</step>

<step name="verify_required_skills" priority="blocking">
**BLOCKING CHECK: Required skills must be loaded before execution.**

1. Check if PLAN.md has a <skills> section
2. If no <skills> section: proceed (no skill requirements)
3. If <skills> section exists:
   a. For each skill marked "required":
      - Check if skill has been invoked in current session
      - If not invoked: add to missing_skills list
   b. If missing_skills is not empty:
      - **BLOCK execution**
      - Display:
        ```
        ════════════════════════════════════════
        ⛔ BLOCKED: Required skills not loaded
        ════════════════════════════════════════

        This plan requires the following skills:

        Missing:
        - /skill-name → Run: /skill-name
        - /skill-name → Run: /skill-name

        Load these skills now, then type "ready" to continue.
        Or type "override" to proceed without (not recommended).
        ════════════════════════════════════════
        ```
      - Wait for user input
      - If "ready": re-check skills, proceed if all loaded
      - If "override":
        - Log deviation to STATE.md Decisions: "Override: Proceeded without required skills [list]"
        - Proceed with warning
   c. If all required skills loaded:
      - Display: "✓ All required skills loaded"
      - Proceed to execute_tasks

**This check runs BEFORE any task execution, ensuring skills are in place.**
</step>

<step name="walt_baseline" priority="before-tasks">
**WALT: Capture baseline test results (before task execution)**
@~/.pals/references/quality-runner.md

1. Detect test runner using quality-detection.md heuristics
2. If no test runner detected: log "WALT: No test runner detected — skipping", set walt_gate = SKIP
3. If test runner detected: run test command, capture baseline counts (passed/failed/skipped) and exit code
4. Store baseline results for post-apply comparison
5. If test runner fails to execute: warn and set walt_gate = SKIP

**Note:** Baseline failures are expected — they establish the "known state" before apply changes anything.
</step>

<step name="execute_tasks">
**If plan frontmatter type is "tdd":**
Delegate task execution to @workflows/apply-phase-tdd.md
- The TDD overlay handles RED-GREEN-REFACTOR sequencing with phase-gating
- Each phase produces an atomic commit (test/feat/refactor)
- Results return here for the finalize step
- Skip the standard task-by-task execution below

For each <task> in order:

**If type="auto":**
1. Log task start: "Task N: [name]"
2. Execute <action> content:
   - Create/modify files specified in <files>
   - Follow specific instructions
   - Respect boundaries (DO NOT CHANGE protected files)
3. Run <verify> command/check
4. Record result:
   - PASS: verification succeeded
   - FAIL: verification failed (stop and report)
5. Note <done> criteria satisfied

**If type="checkpoint:human-verify":**
1. Stop execution
2. Present checkpoint clearly:
   ```
   ════════════════════════════════════════
   CHECKPOINT: Human Verification
   ════════════════════════════════════════

   Task [N] of [Total]: [name]

   What was built:
   [what-built content]

   How to verify:
   [how-to-verify content]

   [resume-signal content]
   ════════════════════════════════════════
   ```
3. Wait for user response
4. On "approved": continue to next task
5. On issues reported: address issues, re-verify, or note deviation

**If type="checkpoint:decision":**
1. Stop execution
2. Present decision with options:
   ```
   ════════════════════════════════════════
   CHECKPOINT: Decision Required
   ════════════════════════════════════════

   Decision: [decision content]
   Context: [context content]

   Options:
   [option-a]: [name] - Pros: [pros] / Cons: [cons]
   [option-b]: [name] - Pros: [pros] / Cons: [cons]

   [resume-signal content]
   ════════════════════════════════════════
   ```
3. Wait for user selection
4. **Record decision to STATE.md:**
   - Open `.paul/STATE.md`
   - Find `### Decisions` under `## Accumulated Context`
   - Add row: `| [date]: [Decision summary] | Phase [N] | [Impact on work] |`
   - Example: `| 2026-01-28: Install in sandbox for testing | Phase 1 | Project created in sandbox/box2-paul-test |`
5. Continue with chosen direction

**If type="checkpoint:human-action":**
1. Stop execution
2. Present required action:
   ```
   ════════════════════════════════════════
   CHECKPOINT: Human Action Required
   ════════════════════════════════════════

   Action: [action content]

   Instructions:
   [instructions content]

   After completion, I will verify:
   [verification content]

   [resume-signal content]
   ════════════════════════════════════════
   ```
3. Wait for user confirmation
4. Run verification check
5. Continue if verified, report if failed
</step>

<step name="walt_post_apply" priority="after-tasks">
**WALT: Run post-apply tests and check for regressions**
@~/.pals/references/quality-runner.md

1. If walt_gate = SKIP (from baseline step): skip test comparison, include SKIP report in summary
2. Run test command again, capture result counts and exit code
3. Compare against baseline using regression detection logic from quality-runner.md
4. Determine test gate result:
   - No regressions → test_gate = PASS
   - Regressions + strict mode → test_gate = BLOCK (present report, offer fix/override/stop)
   - Regressions + lenient mode → test_gate = WARN (display warning, continue)
5. Store WALT test report for inclusion in finalize step

**WALT: Run lint, typecheck, and format checks**
@~/.pals/references/quality-lint.md

6. Run format check → auto-fix → lint check → auto-fix → typecheck (order matters)
7. Determine lint gate result per quality-lint.md gating rules (strict for types, lenient for lint)
8. Combine gates: overall walt_gate = most restrictive of test_gate and lint_gate
   - Either BLOCK → BLOCK | Both PASS → PASS | Otherwise WARN or SKIP
9. If overall BLOCK: present combined report, offer fix/override/stop
10. Store WALT lint report alongside test report for finalize step
</step>

<step name="handle_failures">
If a task verification fails:

1. **Stop immediately** - do not proceed to next task
2. **Report clearly:**
   - Which task failed
   - What verification check failed
   - What was expected vs actual
3. **Offer options:**
   - Retry: attempt the task again
   - Skip: mark as failed, continue (creates deviation)
   - Stop: halt execution, prepare for debugging
4. **Record resolution to STATE.md:**
   - Add to `### Decisions` section: `| [date]: Task [N] [retry/skip/stop] - [reason] | Phase [N] | [impact] |`
</step>

<step name="track_progress">
Throughout execution:

1. Maintain mental log of:
   - Tasks completed (with results)
   - Tasks failed (with reasons)
   - Checkpoints resolved (with decisions/approvals)
   - Deviations from plan
2. This information feeds into UNIFY phase
</step>

<step name="finalize">
After all tasks attempted:

1. Summarize execution:
   - Tasks completed: N of M
   - Failures: list any
   - Deviations: list any
2. Update STATE.md:
   - Loop position: PLAN ✓ → APPLY ✓ → UNIFY ○
   - Last activity: timestamp and completion status
3. Include WALT reports in summary (if quality checks were run):
   - Append WALT test report from quality-runner.md report format
   - Append WALT lint report from quality-lint.md report format
   - Show combined gate result (PASS/WARN/SKIP)
4. Report with quick continuation prompt:
   ```
   ════════════════════════════════════════
   APPLY COMPLETE
   ════════════════════════════════════════
   [execution summary]

   [WALT test report if applicable]
   [WALT lint report if applicable]

   ---
   Continue to UNIFY?

   [1] Yes, run UNIFY | [2] Pause here
   ```
4. **Accept quick inputs:** "1", "yes", "continue", "go" → run `/pals:unify [plan-path]`
</step>

</process>

<output>
- Modified files as specified in PLAN.md
- Execution log (mental, for UNIFY)
- STATE.md updated with APPLY complete
</output>

<error_handling>
**Plan not found:**
- Check STATE.md for correct path
- Ask user to confirm plan location

**Boundary violation attempted:**
- Stop immediately
- Report which boundary would be violated
- Do not modify protected files

**Verification command fails:**
- Report the failure
- Offer retry/skip/stop options
- Do not mark task as complete

**Checkpoint timeout:**
- Remind user checkpoint is waiting
- Do not proceed without response
- Offer to save state and continue later
</error_handling>

<anti_patterns>
**Assuming approval:**
Do NOT start APPLY without explicit user approval of the plan.

**Skipping verification:**
Every task MUST have its verify step run. No "it looks right" assumptions.

**Ignoring boundaries:**
If a task would modify a protected file, STOP. Do not rationalize violations.

**Proceeding past checkpoints:**
Checkpoints are blocking. Do not continue without user response.
</anti_patterns>
