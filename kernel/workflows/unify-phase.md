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
.paul/STATE.md
.paul/phases/{phase}/{plan}-PLAN.md
modules.yaml (installed module registry — MUST read if it exists; drives pre-unify and post-unify hook dispatch)
</required_reading>

<references>
references/loop-phases.md
references/module-dispatch.md
templates/SUMMARY.md
workflows/transition-phase.md (always listed; executed only when check_phase_completion finds this is the last plan)
<!-- Module references are loaded dynamically via hook dispatch from the installed registry resolved as modules.yaml -->
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

0. **Ground-truth diff check:**
   Before gathering from execution memory, verify what actually changed:
   ```bash
   git diff --stat {last_commit_from_STATE.md}..HEAD
   ```
   Compare this output against the plan's `files_modified` frontmatter:
   - If the plan lists non-`.paul/` files in `files_modified` but the diff shows **zero non-`.paul/` changes**: flag as **critical reconciliation mismatch**.
     ```
     ════════════════════════════════════════
     ⛔ RECONCILIATION MISMATCH
     ════════════════════════════════════════

     Plan files_modified claims:
       {non-.paul/ entries from files_modified}

     Actual changes since last commit:
       {git diff --stat output, or "only .paul/ files"}

     The plan claimed implementation changes that do not appear
     in the working tree. Do NOT proceed with SUMMARY creation
     until this is resolved.

     Options:
     [1] Investigate — review what happened during APPLY
     [2] Proceed as documentation-only — record mismatch in SUMMARY
     ════════════════════════════════════════
     ```
   - If "1": halt SUMMARY creation, return to investigation
   - If "2": proceed, but the SUMMARY MUST note the mismatch in its Deviations section
   - If diff and plan align (or plan only lists `.paul/` files): proceed normally

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
1. Read `modules.yaml` (installed module registry; see `references/module-dispatch.md`) if it exists
2. Resolve installed modules for `pre-unify` by finding `installed_modules.*.hook_details.pre-unify`
3. Sort by `hook_details.pre-unify.priority` ascending (lower runs first)
4. For each registered module:
   a. Load only the hook-specific `refs` listed in `hook_details.pre-unify.refs`
   b. Follow the hook description from `hook_details.pre-unify.description`
   c. Pass `annotations_from_apply` accumulated during the apply phase
   d. Collect `context_inject` data (e.g., quality trends, audit results)
5. If the registry only exposes the legacy flat `hooks` list and lacks `hook_details`, warn that the install is stale and prefer regenerating `modules.yaml` before relying on fallback behavior
6. If no modules registered for `pre-unify`: proceed (no-op, no warning)
7. Output dispatch log: `[dispatch] pre-unify: {MODULE(priority) → N inject keys | skip} | ...`
8. Store accumulated pre-unify context for reconciliation and later SUMMARY.md finalization alongside carried-forward apply annotations
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

**Reference:** references/specialized-workflow-integration.md
</step>

<step name="create_summary">
1. Create a SUMMARY.md draft at `.paul/phases/{phase}/{plan}-SUMMARY.md`
2. Include:
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
   - Module Execution Reports (keep this section open for finalization; seed it with any carried-forward apply annotations or pre-unify context that already needs to persist)
   - Deviations (if any, with explanations)
   - Key Patterns/Decisions (if any emerged)
   - Next Phase (what comes next)
3. Preserve the draft as a durable staging point for summary finalization. Do NOT treat the first write as the last write — post-unify module reports and recorded side effects must still be able to land in `Module Execution Reports` before the loop closes.
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
1. Read `modules.yaml` (installed module registry; see `references/module-dispatch.md`) if it exists
2. Resolve installed modules for `post-unify` by finding `installed_modules.*.hook_details.post-unify`
3. Sort by `hook_details.post-unify.priority` ascending (lower runs first)
4. For each registered module:
   a. Load only the hook-specific `refs` listed in `hook_details.post-unify.refs`
   b. Follow the hook description from `hook_details.post-unify.description`
   c. Pass `annotations_from_apply`, retained pre-unify context, and summary path
   d. Collect `module_reports` for durable inclusion in `Module Execution Reports`
   e. Collect `side_effects` (e.g., "Recorded quality delta in history")
5. If the registry only exposes the legacy flat `hooks` list and lacks `hook_details`, warn that the install is stale and prefer regenerating `modules.yaml` before relying on fallback behavior
6. If no modules registered for `post-unify`: proceed (no-op, no warning)
7. Output dispatch log: `[dispatch] post-unify: {MODULE(priority) → N reports / N side effects | skip} | ...`
8. Store accumulated post-unify module reports and logged side_effects for summary finalization
</step>
<step name="finalize_summary" priority="after-post-unify">
1. Re-open the SUMMARY.md draft before phase-completion routing.
2. Finalize `## Module Execution Reports` using one durable reporting path:
   - carried-forward `annotations_from_apply`
   - any pre-unify `context_inject` that materially informed reconciliation
   - `module_reports` returned by post-unify hooks
   - recorded `side_effects` that should remain visible after the loop closes
3. If no module evidence exists after reconciliation, omit the section entirely instead of leaving placeholder comments.
4. Save the finalized SUMMARY.md before `check_phase_completion` or transition routing runs.
</step>

<step name="github_flow_merge_gate" priority="after-summary">
**Conditional: Block next PLAN until PR is merged in github-flow mode.**

1. **Resolve workflow mode:**
   ```bash
   GIT_WORKFLOW=$(jq -r '.git.workflow // empty' pals.json 2>/dev/null)
   if [ -z "$GIT_WORKFLOW" ]; then
     GIT_BRANCHING_CHECK=$(jq -r '.git.branching // empty' pals.json 2>/dev/null)
     if [ -n "$GIT_BRANCHING_CHECK" ]; then GIT_WORKFLOW="legacy"; else GIT_WORKFLOW="none"; fi
   fi
   ```

2. **If GIT_WORKFLOW != "github-flow":** Skip entire step (no-op). Proceed to check_phase_completion. Legacy/none routing is unchanged.

3. **Read enforcement config:**
   ```bash
   GIT_REQUIRE_PR=$(jq -r '.git.require_pr_before_next_phase // false' pals.json 2>/dev/null)
   GIT_CI_CHECKS=$(jq -r '.git.ci_checks // false' pals.json 2>/dev/null)
   GIT_REQUIRE_REVIEWS=$(jq -r '.git.require_reviews // false' pals.json 2>/dev/null)
   GIT_MERGE_METHOD=$(jq -r '.git.merge_method // "squash"' pals.json 2>/dev/null)
   GIT_DELETE_BRANCH=$(jq -r '.git.delete_branch_on_merge // true' pals.json 2>/dev/null)
   GIT_BASE_BRANCH=$(jq -r '.git.base_branch // "main"' pals.json 2>/dev/null)
   GIT_REMOTE=$(jq -r '.git.remote // empty' pals.json 2>/dev/null)
   GIT_AUTO_PR=$(jq -r '.git.auto_pr // false' pals.json 2>/dev/null)
   PHASE_NAME={phase-name}
   CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
   ```

4. **If require_pr_before_next_phase != true:** Skip merge gate. Proceed to check_phase_completion.

5. **Push latest changes** (SUMMARY.md and STATE.md updates are on feature branch):
   ```bash
   git add -A
   git commit -m "docs(${PHASE_NAME}): UNIFY artifacts" --allow-empty
   git push origin ${CURRENT_BRANCH} 2>/dev/null || true
   ```

6. **Gate checks (strict order — stop at first failure):**

   **Gate 1 — PR exists:**
   ```bash
   PR_JSON=$(gh pr view ${CURRENT_BRANCH} --json url,state,reviewDecision 2>/dev/null || echo "")
   ```
   - If empty (no PR):
     - If `GIT_AUTO_PR` = true and remote set:
       ```bash
       gh pr create --base ${GIT_BASE_BRANCH} --head ${CURRENT_BRANCH} \
         --title "feat(${PHASE_NAME}): {description}" \
         --body "Phase {N} — auto-generated by PALS."
       ```
       Re-read PR_JSON after creation.
     - If not auto_pr:
       ```
       ⛔ MERGE GATE: No PR exists for ${CURRENT_BRANCH}
       Next action: Create a PR, then re-run /paul:unify
       ```
       BLOCK — do not proceed to check_phase_completion.
   - Record PR URL in STATE.md `### Git State` if newly created.

   **Gate 2 — CI checks passing (if ci_checks=true):**
   ```bash
   gh pr checks ${CURRENT_BRANCH}
   ```
   - If any check failing:
     ```
     ════════════════════════════════════════
     ⛔ MERGE GATE: CI checks failing
     ════════════════════════════════════════

     CI failure is blocking in github-flow mode.
     There is no "merge anyway" option.

     Next action: Fix CI failures and re-push, then re-run /paul:unify
     ════════════════════════════════════════
     ```
     BLOCK — do not proceed.
   - If ci_checks=false: skip this gate (mark as "skipped").

   **Gate 3 — Reviews approved (if require_reviews=true):**
   ```bash
   REVIEW_DECISION=$(echo $PR_JSON | jq -r '.reviewDecision // "REVIEW_REQUIRED"')
   ```
   - If `$REVIEW_DECISION` != "APPROVED":
     ```
     ⛔ MERGE GATE: PR review required
     Review status: ${REVIEW_DECISION}
     Next action: Get PR reviewed, then re-run /paul:unify
     ```
     BLOCK — do not proceed.
   - If require_reviews=false: skip this gate (mark as "skipped").

   **Gate 4 — PR merged:**
   ```bash
   PR_STATE=$(echo $PR_JSON | jq -r '.state')
   ```
   - If `$PR_STATE` != "MERGED":
     ```
     ────────────────────────────────────────
     PR is approved and CI passing. Ready to merge.

     [1] Merge via gh pr merge --${GIT_MERGE_METHOD}
     [2] Merge manually, then re-run /paul:unify
     ────────────────────────────────────────
     ```
     - If "1":
       ```bash
       gh pr merge ${CURRENT_BRANCH} --${GIT_MERGE_METHOD} --delete-branch
       ```
     - If "2": BLOCK — user will merge manually and re-run.

   **Gate 5 — Local base_branch synced (after merge confirmed):**
   ```bash
   git checkout ${GIT_BASE_BRANCH}
   git pull origin ${GIT_BASE_BRANCH}
   ```
   Display: `Synced local ${GIT_BASE_BRANCH} with remote`

   **Gate 6 — Feature branch cleanup (if delete_branch_on_merge=true):**
   ```bash
   git branch -d ${CURRENT_BRANCH} 2>/dev/null || true
   ```
   Display: `Cleaned up ${CURRENT_BRANCH}` or `Branch already removed`

7. **All gates passed — display summary:**
   ```
   ────────────────────────────────────────
   MERGE GATE STATUS
   ────────────────────────────────────────
   1. PR exists:     ✓
   2. CI passing:    ✓ / skipped
   3. Reviews:       ✓ / skipped
   4. PR merged:     ✓
   5. Base synced:   ✓
   6. Branch clean:  ✓

   ✓ Merge gate passed — proceeding to phase completion
   ────────────────────────────────────────
   ```

8. **Update STATE.md Git State:**
   ```markdown
   ### Git State
   Branch: ${GIT_BASE_BRANCH}
   Last commit: {short-hash after merge}
   PR: {url} (state: MERGED)
   ```

9. **Proceed to check_phase_completion.**

**Note:** Retroactive UNIFY (hotfix mode) skips this step entirely — hotfixes are exempt from the merge gate per design decision D6. The `detect_retroactive` step at the top of unify-phase already short-circuits before reaching this gate.
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

2. **MUST read and execute:** workflows/transition-phase.md

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
