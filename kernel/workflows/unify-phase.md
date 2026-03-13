<purpose>
Reconcile what was planned vs. what was built. Create SUMMARY.md documenting results, update STATE.md with new position, and close the loop to prepare for next PLAN.
</purpose>

<when_to_use>
- APPLY phase complete (all tasks executed or documented)
- Ready to close the current loop
- Need to record what was built for future reference
- After a hotfix (retroactive documentation via /paul:fix hotfix mode)
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
@~/.pals/workflows/transition-phase.md (always listed; executed only when check_phase_completion finds this is the last plan)
<!-- Module references are loaded dynamically via hook dispatch from ~/.pals/modules.yaml -->
</references>

<process>

<step name="detect_retroactive" priority="first">
**Check for retroactive UNIFY (hotfix mode):**

1. Read STATE.md — look for `Pending retroactive UNIFY` in Session Continuity
2. If found:
   - Switch to retroactive mode (skip gather_results, compare_plan_vs_actual)
   - Extract hotfix description and commit hash from the pending flag
   - Jump to `retroactive_unify` step
3. If not found:
   - Proceed with normal UNIFY (gather_results below)
</step>

<step name="retroactive_unify" condition="retroactive_flag_detected">
**Generate SUMMARY from git history (no PLAN.md exists):**

1. Read git log since last known commit in STATE.md:
   ```bash
   git log {last_commit}..HEAD --oneline
   git diff {last_commit}..HEAD --stat
   ```

2. If description not already captured, ask user:
   ```
   Retroactive UNIFY for hotfix.

   Changes since last commit:
   {git diff --stat output}

   What was fixed and why? (brief description)
   ```

3. Create SUMMARY in current phase directory:
   `.paul/phases/{phase-dir}/{phase}-{NN}-HOTFIX-SUMMARY.md`:

   ```markdown
   ---
   phase: {phase-slug}
   plan: hotfix
   type: hotfix
   completed: {ISO timestamp}
   ---

   ## Hotfix Summary

   **Issue:** {description}
   **Mode:** Hotfix (retroactive UNIFY)
   **Commit:** {hash}

   ### Files Changed
   | File | Change |
   |------|--------|
   {from git diff --stat}

   ### Context
   {user-provided description of what was fixed and why}

   ### Result
   Hotfix applied and documented retroactively.
   ```

4. Clear the retroactive flag from STATE.md:
   - Remove `Pending retroactive UNIFY` line from Session Continuity
   - Update Accumulated Context fix entry: remove "Pending retroactive UNIFY" note

5. Dispatch post-unify hooks normally (quality history should track hotfixes too)

6. Display completion:
   ```
   ════════════════════════════════════════
   RETROACTIVE UNIFY COMPLETE
   ════════════════════════════════════════

   Hotfix: {description}
   SUMMARY: {path}
   Retroactive flag cleared.

   Continue normal work.
   ════════════════════════════════════════
   ```

7. Skip remaining normal UNIFY steps (no plan to reconcile)
   - Do NOT run check_phase_completion or execute_transition for retroactive UNIFY
   - Hotfixes are side-loops, not phase progression
</step>

<step name="gather_results">
**Normal UNIFY path (not retroactive):**

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

<step name="pre_unify_hooks" priority="before-reconciliation">
**Dispatch pre-unify lifecycle hooks to registered modules.**

1. Read `~/.pals/modules.yaml` (if it exists)
2. Find modules with hooks registered for `pre-unify`
3. Sort by priority (ascending — lower runs first)
4. For each registered module:
   a. Load the module's hook-specific `refs` (from module.yaml hooks section, NOT all module refs)
   b. Follow the module's hook description for `pre-unify`
   c. Pass `annotations_from_apply` accumulated during the apply phase
   d. Collect `context_inject` data (e.g., quality trends, audit results)
5. If no modules registered for `pre-unify`: proceed (no-op, no warning)
6. Output dispatch log: `[dispatch] pre-unify: {MODULE(priority) → N inject keys | skip} | ...`
7. Store accumulated context for inclusion in SUMMARY.md
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

<step name="post_unify_hooks" priority="after-state-update">
**Dispatch post-unify lifecycle hooks to registered modules.**

1. Read `~/.pals/modules.yaml` (if it exists)
2. Find modules with hooks registered for `post-unify`
3. Sort by priority (ascending — lower runs first)
4. For each registered module:
   a. Load the module's hook-specific `refs` (from module.yaml hooks section)
   b. Follow the module's hook description for `post-unify`
   c. Pass `annotations_from_apply` and summary path
   d. Collect `side_effects` (e.g., "Recorded quality delta in history")
5. If no modules registered for `post-unify`: proceed (no-op, no warning)
6. Output dispatch log: `[dispatch] post-unify: {MODULE(priority) → N side effects | skip} | ...`
7. Log any side_effects reported by modules
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

**Accept:** "1", "yes", "continue" → run `/paul:plan` for next plan in same phase
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

**Anti-pattern:** Closing UNIFY and immediately offering `/paul:plan` for next phase WITHOUT running transition. This breaks system cohesion and skips git commits.
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
