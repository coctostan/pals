<purpose>
Reconcile what was planned vs. what was built. Create SUMMARY.md documenting results, update STATE.md with new position, and close the loop to prepare for next PLAN.
</purpose>

<when_to_use>
- APPLY phase complete (all tasks executed or documented)
- Ready to close the current loop
- Need to record what was built for future reference
</when_to_use>

<loop_context>
Expected phase: UNIFY
Prior phase: APPLY (execution complete)
Next phase: PLAN (next plan or next phase)
</loop_context>

<required_reading>
@.paul/STATE.md
@.paul/phases/{phase}/{plan}-PLAN.md
</required_reading>

<references>
@~/.pals/references/loop-phases.md
@~/.pals/templates/SUMMARY.md
@~/.pals/references/tdd.md (for TDD audit criteria)
@~/.pals/workflows/transition-phase.md (loaded when last plan in phase)
</references>

<process>

<step name="gather_results" priority="first">
1. Recall execution from APPLY phase:
   - Which tasks completed successfully
   - Which tasks failed (if any)
   - Which checkpoints were resolved and how
   - Any deviations from the plan
2. Read PLAN.md to refresh:
   - Original acceptance criteria
   - Expected outputs
   - Task definitions
</step>

<step name="compare_plan_vs_actual">
1. For each acceptance criterion:
   - Was it satisfied? (PASS/FAIL)
   - Evidence of satisfaction
2. For each task:
   - Did it complete as specified?
   - Any modifications to approach?
3. Note deviations:
   - What differed from plan
   - Why it differed
   - Impact on outcomes
</step>

<step name="audit_tdd_execution">
**Only runs if plan frontmatter type is "tdd". Skip for other types.**

1. Check for TDD commits in git log:
   - RED commit: `git log --oneline --grep="test({phase}-{plan})"`
   - GREEN commit: `git log --oneline --grep="feat({phase}-{plan})"`
   - REFACTOR commit: `git log --oneline --grep="refactor({phase}-{plan})"` (optional)

2. Verify commit sequence:
   - RED must exist → if missing, flag: "RED commit not found — TDD discipline gap"
   - GREEN must exist → if missing, flag: "GREEN commit not found — implementation not committed"
   - REFACTOR: optional — note "skipped" or "applied"

3. Run test suite to confirm all tests still pass:
   - If pass: log "All tests passing at unify"
   - If fail: flag "Tests failing at unify — investigate before closing loop"

4. Prepare TDD results for SUMMARY.md:
   ```
   tdd_results:
     red_commit: {hash} | missing
     green_commit: {hash} | missing
     refactor_commit: {hash} | skipped
     tests_passing: yes | no
     discipline: clean | gaps found
   ```

5. If gaps found, add to STATE.md Deferred Issues:
   - "TDD discipline gap in {phase}-{plan}: {description}"
</step>

<step name="audit_quality_delta">
**WALT: Collect quality delta from apply phase reports**
@~/.pals/references/quality-delta.md

1. Recall WALT test report and lint report from the apply phase
2. Extract before/after metrics per quality-delta.md
3. Calculate trajectory indicators for each metric (▲/●/▼)
4. Determine overall quality verdict (improved/stable/degraded)
5. Prepare Quality section content for SUMMARY.md
6. If no WALT reports (tools not detected or pre-WALT plan): note "Quality: not tracked"
</step>

<step name="append_quality_history">
**Append quality snapshot to persistent history file**
@~/.pals/references/quality-history.md

1. After quality delta is captured (from audit_quality_delta step above):
   - Extract "after" values for tests, coverage, lint, types
   - Determine overall verdict
2. If `.paul/QUALITY-HISTORY.md` doesn't exist: create with header and first entry
3. If exists: append new row to Plan History table, update Cumulative Trajectory
4. If WALT reports were SKIP: append entry with "—" for all metrics
5. Follow format and edge cases from quality-history.md reference
</step>

<step name="audit_skill_invocations">
**Check specialized workflow usage (if configured):**

1. Check if .paul/SPECIAL-FLOWS.md exists:
   ```bash
   ls .paul/SPECIAL-FLOWS.md 2>/dev/null
   ```

2. If not exists: Skip this step entirely

3. If exists:
   a. Read SPECIAL-FLOWS.md
   b. For each skill with priority "required":
      - Check if skill was invoked during this APPLY phase
      - Mark as ✓ (invoked) or ○ (gap)
   c. If any gaps found:
      - Add to STATE.md Deviations section:
        ```markdown
        ### Skill Audit (Phase [N])
        | Expected | Invoked | Notes |
        |----------|---------|-------|
        | /skill-name | ○ | [reason if known] |
        ```
      - Warn user: "Skill gap(s) documented in STATE.md. Review before next phase."
   d. Do NOT block UNIFY for skill gaps (warn only)

4. If all required skills invoked:
   - Note in SUMMARY.md: "Skill audit: All required skills invoked ✓"

**Reference:** @references/specialized-workflow-integration.md
</step>

<step name="create_summary">
1. Create SUMMARY.md at `.paul/phases/{phase}/{plan}-SUMMARY.md`
2. Include:

   **Frontmatter:**
   ```yaml
   ---
   phase: NN-name
   plan: NN
   completed: ISO timestamp
   duration: approximate time
   ---
   ```

   **Sections:**
   - Objective (brief restatement)
   - What Was Built (table: file, purpose, lines)
   - Acceptance Criteria Results (table: AC, description, status)
   - Verification Results (command outputs)
   - Deviations (if any, with explanations)
   - Key Patterns/Decisions (if any emerged)
   - Next Phase (what comes next)
</step>

<step name="update_state">
1. Update STATE.md:

   **Current Position:**
   - Phase: N of M - Complete (or In Progress if more plans)
   - Plan: complete
   - Status: Ready for next PLAN
   - Last activity: timestamp

   **Progress:**
   - Update milestone percentage
   - Update phase percentage (100% if complete)

   **Loop Position:**
   ```
   PLAN ──▶ APPLY ──▶ UNIFY
     ✓        ✓        ✓     [Loop complete - ready for next PLAN]
   ```

   **Session Continuity:**
   - Update stopped at
   - Update next action
   - Update resume file (point to SUMMARY)
</step>

<step name="check_phase_completion">
**Determine if this is the last plan in the phase:**

1. Count PLAN.md files in current phase directory
2. Count SUMMARY.md files (including the one just created)
3. Compare counts:
   - If PLAN count = SUMMARY count → Last plan, trigger transition
   - If PLAN count > SUMMARY count → More plans remain in phase
</step>

<step name="route_based_on_completion">
**If more plans remain in phase:**

Report with quick continuation:
```
════════════════════════════════════════
LOOP COMPLETE
════════════════════════════════════════

Plan: {NN}-{plan} — [description]
[summary of what was built]
[deviations if any]

Phase {N} progress: {X}/{Y} plans complete

---
Continue to next plan?

[1] Yes, plan {NN+1} | [2] Pause here
════════════════════════════════════════
```

**Accept:** "1", "yes", "continue" → run `/pals:plan` for next plan in same phase
</step>

<step name="execute_transition" priority="required" gate="blocking">
**If last plan in phase — TRANSITION IS MANDATORY:**

⚠️ **NEVER skip this step. This is what makes PAUL a system, not random loops.**

1. Announce clearly:
   ```
   ════════════════════════════════════════
   PHASE {N} COMPLETE — TRANSITION REQUIRED
   ════════════════════════════════════════
   ```

2. **MUST read and execute:** @~/.pals/workflows/transition-phase.md

3. Transition handles (do not skip any):
   - Evolve PROJECT.md (requirements validated → shipped)
   - Update ROADMAP.md (phase status → complete)
   - Git commit for phase: `feat({phase}): {description}`
   - Clean stale handoffs
   - Route to next phase or milestone completion

4. **Only after transition completes** → offer next phase routing

**Anti-pattern:** Closing UNIFY and immediately offering `/pals:plan` for next phase WITHOUT running transition. This breaks system cohesion and skips git commits.
</step>

</process>

<output>
- SUMMARY.md at `.paul/phases/{phase}/{plan}-SUMMARY.md`
- Updated STATE.md
- Updated ROADMAP.md (if phase complete)
</output>

<error_handling>
**APPLY not complete:**
- Check STATE.md for actual position
- If APPLY incomplete, cannot UNIFY
- Return to APPLY to complete or document blockers

**Missing execution context:**
- If no memory of execution results, read any logs
- Ask user to confirm what was completed
- Document uncertainty in SUMMARY.md

**PLAN.md missing:**
- Cannot reconcile without original plan
- Ask user to locate or reconstruct
</error_handling>

<anti_patterns>
**Skipping SUMMARY:**
Every completed plan MUST have a SUMMARY.md. No exceptions.

**Partial state updates:**
Update ALL of: SUMMARY, STATE, ROADMAP (if phase done). Don't leave partial.

**Vague summaries:**
"It worked" is not a summary. Document files, AC results, deviations specifically.

**Forgetting loop position:**
Always show the visual loop position in STATE.md.
</anti_patterns>
