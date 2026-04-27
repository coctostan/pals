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
modules.yaml (installed module registry — MUST read; drives pre-unify and post-unify hook dispatch)
</required_reading>

<references>
references/loop-phases.md
references/module-dispatch.md
references/git-strategy.md
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
**Dispatch pre-unify lifecycle hooks via `references/module-dispatch.md`.**

Call-site contract:
- Hook: `pre-unify` lifecycle dispatch.
- Context/output: `annotations_from_apply`; collect `context_inject` for reconciliation and SUMMARY finalization.
- Blocking: follow enforcement semantics only if a module explicitly returns `action: block`; otherwise continue.
- Required evidence: `[dispatch] pre-unify: ...`; if no modules are registered, emit `[dispatch] pre-unify: 0 modules registered for this hook`; if registry resolution fails, emit `[dispatch] pre-unify: modules.yaml NOT FOUND — WARNING`.
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
⚠️ **MANDATORY — DO NOT SKIP THIS STEP.**
STOP after state update and dispatch post-unify modules via `references/module-dispatch.md`; this persistence layer records quality history, decisions, CODI history, and debt notes.

Call-site contract:
- Hook: `post-unify` persistence dispatch.
- Context/output: `annotations_from_apply`, retained pre-unify context, and summary path; collect `module_reports` plus side effects for durable `Module Execution Reports`.
- Blocking: follow enforcement semantics only if a module explicitly returns `action: block`; otherwise persist results and continue.
- Required evidence: `[dispatch] post-unify: ...`; if no modules are registered, emit `[dispatch] post-unify: 0 modules registered for this hook`; if none executed, state `[dispatch] post-unify: SKIPPED — {reason}`; if registry resolution fails, emit `[dispatch] post-unify: modules.yaml NOT FOUND — WARNING`.
</step>
<step name="finalize_summary" priority="after-post-unify">
1. Re-open the SUMMARY.md draft before phase-completion routing.
2. Finalize `## Module Execution Reports` from one durable path: carried-forward `annotations_from_apply`, material pre-unify `context_inject`, post-unify `module_reports`, and recorded side effects.
3. **Module evidence validation (MANDATORY):** If modules are enabled in `pals.json` but no dispatch evidence exists, record WARNING: "Modules enabled but zero dispatch evidence found — verify modules.yaml was loaded during PLAN and APPLY." Do not proceed until the warning is in SUMMARY.md.
4. **Post-unify dispatch audit:** If `post_unify_hooks` evidence is absent or all skipped, add: '⚠️ Post-unify hooks did not fire. Reason: {reason or "unknown — verify modules.yaml was loaded"}. Quality history, knowledge capture, and debt analysis were not recorded for this loop.'
5. Save the finalized SUMMARY.md before `check_phase_completion` or transition routing runs.
</step>

<step name="merge_gate_resolve" priority="after-summary">
**Merge Gate Step 1 of 5: Resolve config and check if merge gate applies via `references/git-strategy.md`.**

1. Resolve `GIT_WORKFLOW` with the shared 3-tier recipe in `references/git-strategy.md`.
2. **If `GIT_WORKFLOW != "github-flow"`:** Display: `Merge gate: skipped (not github-flow)`. Skip all `merge_gate_*` steps. Proceed to `check_phase_completion`.
3. Read the github-flow gate fields from `pals.json`: `require_pr_before_next_phase`, `ci_checks`, `require_reviews`, `merge_method`, `delete_branch_on_merge`, `base_branch`, `remote`, `auto_pr`; resolve `CURRENT_BRANCH`.
4. **If `require_pr_before_next_phase != true`:** Display: `Merge gate: skipped (not required)`. Skip remaining `merge_gate_*` steps. Proceed to `check_phase_completion`.
5. Stage and commit the latest UNIFY artifacts, then push `CURRENT_BRANCH` before PR checks, following `references/git-strategy.md`.
6. Display: `Merge gate: resolving... config loaded, proceeding to PR checks.`
</step>

<step name="merge_gate_pr" priority="after-merge-gate-resolve">
⚠️ **MANDATORY if merge_gate_resolve did not skip.**
**Merge Gate Step 2 of 5: Ensure PR exists, CI passes, and reviews are approved.**
Use `references/git-strategy.md` for the exact command sequence.

1. **Gate 1 — PR exists:**
   - Read PR state for `CURRENT_BRANCH`.
   - If no PR exists and `GIT_AUTO_PR = true` with a remote, create it and re-read PR state.
   - Otherwise BLOCK with:
     ```
     ⛔ MERGE GATE: No PR exists for ${CURRENT_BRANCH}
     Next action: Create a PR, then re-run /paul:unify
     ```
   - Record PR URL in STATE.md `### Git State` if newly created.
2. **Gate 2 — CI passing:**
   - Surface PR checks with `gh pr checks ${CURRENT_BRANCH}`.
   - If `ci_checks=true` and any check is failing, BLOCK with:
     ```
     ⛔ MERGE GATE: CI checks failing.
     CI failure is blocking in github-flow mode. There is no "merge anyway" option.
     Next action: Fix CI failures and re-push, then re-run /paul:unify
     ```
3. **Gate 3 — Reviews approved:**
   - If `require_reviews=true`, require an approved review decision or BLOCK with:
     ```
     ⛔ MERGE GATE: PR review required. Status: ${REVIEW_DECISION}
     Next action: Get PR reviewed, then re-run /paul:unify
     ```
4. Display gate status:
   ```
   ────────────────────────────────────────
   1. PR exists:     ✓
   2. CI passing:    ✓ / skipped
   3. Reviews:       ✓ / skipped
   ────────────────────────────────────────
   ```
</step>

<step name="merge_gate_review" priority="after-merge-gate-pr" condition="rev_pr_review_enabled">
⚠️ **CONDITIONAL: Only runs if REV module pr_review is enabled.**
**Merge Gate Step 3 of 5: Code review via REV subagent.**

1. Read REV config:
   ```bash
   REV_ENABLED=$(jq -r '.modules.rev.enabled // false' pals.json 2>/dev/null)
   REV_PR_REVIEW=$(jq -r '.modules.rev.pr_review // false' pals.json 2>/dev/null)
   REV_BLOCK_ON_CRITICAL=$(jq -r '.modules.rev.pr_review_block_on_critical // true' pals.json 2>/dev/null)
   REV_MODEL=$(jq -r '.modules.rev.model // empty' pals.json 2>/dev/null)
   ```

2. **If REV_ENABLED != true OR REV_PR_REVIEW != true:** Skip silently. Display: "3. Code review: skipped". Proceed to merge_gate_merge.

3. **If enabled:** Assemble full-branch diff review:
   a. Run `git diff ${GIT_BASE_BRANCH}...HEAD` to get full branch diff
   b. Read each changed file in full
   c. Read `AGENTS.md` if exists
   d. Read installed `modules/rev/references/review-prompt.md` for the prompt template
   e. Substitute placeholders and dispatch:
      ```
      Agent({
        subagent_type: "code-reviewer",
        prompt: assembled_review_prompt,
        description: "Code review: PR merge gate",
        run_in_background: false,
        model: REV_MODEL || undefined
      })
      ```

4. **Parse verdict from reviewer output:**
   - **NOT READY (Critical findings)** AND `REV_BLOCK_ON_CRITICAL = true`:
     ```
     ⛔ MERGE GATE: Code review found Critical issues.
     {list critical findings}
     Fix before merging.
     ```
     BLOCK — do not proceed to merge.
   - **READY WITH CONCERNS (Important/Minor only):** Display findings as advisory, proceed.
     Display: "3. Code review: ⚠️ CONCERNS"
   - **READY:** Display: "3. Code review: ✓ READY"

5. **If Agent tool not available:** Warn and skip:
   ```
   ⚠️ REV pr_review enabled but pi-subagents not available. Skipping code review.
   ```
   Display: "3. Code review: skipped (no pi-subagents)"
</step>

<step name="merge_gate_merge" priority="after-merge-gate-review">
⚠️ **MANDATORY if merge_gate_pr passed.**
**Merge Gate Step 4 of 5: Merge PR and sync local base branch.**
Use `references/git-strategy.md` for the exact merge/sync commands.

1. **Gate 4 — PR merged:**
   - If the PR is not already merged, either merge it with `gh pr merge ${CURRENT_BRANCH} --${GIT_MERGE_METHOD} --delete-branch` or BLOCK for manual merge and re-run `/paul:unify`.
2. **Gate 5 — Base synced:**
   - After merge, switch to `GIT_BASE_BRANCH` and pull the latest remote state.
3. Display: `Synced local ${GIT_BASE_BRANCH} with remote`
</step>

<step name="merge_gate_cleanup" priority="after-merge-gate-merge">
**Merge Gate Step 5 of 5: Branch cleanup and state update.**

1. **Gate 6 — Branch clean:**
   - If `delete_branch_on_merge=true`, delete `CURRENT_BRANCH` locally per `references/git-strategy.md`; otherwise preserve it and note why.
2. **Display final merge gate summary:**
   ```
   ────────────────────────────────────────
   MERGE GATE STATUS
   ────────────────────────────────────────
   1. PR exists:     ✓
   2. CI passing:    ✓ / skipped
   3. Code review:   ✓ READY / ⚠️ CONCERNS / ⛔ BLOCKED / skipped
   4. Reviews:       ✓ / skipped
   5. PR merged:     ✓
   6. Base synced:   ✓
   7. Branch clean:  ✓
   ────────────────────────────────────────
   ```
3. **MUST update STATE.md Git State:**
   ```markdown
   ### Git State
   Branch: ${GIT_BASE_BRANCH}
   Last commit: {short-hash after merge}
   PR: {url} (state: MERGED)
   ```
4. **Proceed to `check_phase_completion`.**

**Note:** Retroactive UNIFY (hotfix mode) skips all `merge_gate_*` steps entirely — hotfixes are exempt from the merge gate per design decision D6. The `detect_retroactive` step at the top of unify-phase already short-circuits before reaching these gates.
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
