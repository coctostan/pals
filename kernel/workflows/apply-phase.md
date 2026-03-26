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
.paul/STATE.md
.paul/phases/{phase}/{plan}-PLAN.md
modules.yaml (installed module registry — MUST read; drives pre-apply, post-task, and post-apply hook dispatch)
</required_reading>

<references>
references/checkpoints.md (if plan has checkpoints)
references/loop-phases.md
references/module-dispatch.md
<!-- Module references (e.g., execution overlays) are loaded dynamically via hook dispatch from the installed registry resolved as modules.yaml -->
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

<step name="github_flow_preflight" priority="after-approval">
**Conditional: GitHub Flow branch validation before work begins.**

1. **Resolve workflow mode:**
   ```bash
   GIT_WORKFLOW=$(jq -r '.git.workflow // empty' pals.json 2>/dev/null)
   if [ -z "$GIT_WORKFLOW" ]; then
     GIT_BRANCHING_CHECK=$(jq -r '.git.branching // empty' pals.json 2>/dev/null)
     if [ -n "$GIT_BRANCHING_CHECK" ]; then
       GIT_WORKFLOW="legacy"
     else
       GIT_WORKFLOW="none"
     fi
   fi
   ```

2. **If GIT_WORKFLOW != "github-flow":** Skip entire step (no-op). Proceed to load_plan.

3. **Read config fields:**
   ```bash
   GIT_BASE_BRANCH=$(jq -r '.git.base_branch // "main"' pals.json 2>/dev/null)
   GIT_UPDATE_WHEN_BEHIND=$(jq -r '.git.update_branch_when_behind // true' pals.json 2>/dev/null)
   GIT_REMOTE=$(jq -r '.git.remote // empty' pals.json 2>/dev/null)
   PHASE_NAME={phase-name}  # e.g., "85-core-loop-enforcement"
   ```

4. **Check 1 — Not on base_branch:**
   ```bash
   CURRENT=$(git rev-parse --abbrev-ref HEAD)
   ```
   - If `$CURRENT` = `$GIT_BASE_BRANCH`: create feature branch:
     ```bash
     git checkout -b "feature/${PHASE_NAME}" "${GIT_BASE_BRANCH}"
     ```
     Display: `Created feature/${PHASE_NAME} from ${GIT_BASE_BRANCH}`
   - If already on a non-base branch (e.g., `feature/{phase}*` or any other): continue on current branch

   After branch creation or detection, resolve the actual working branch:
   ```bash
   CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
   ```
   All subsequent steps use `${CURRENT_BRANCH}` — never assume branch name from phase name.

5. **Check 2 — base_branch up-to-date with remote (if remote set):**
   ```bash
   git fetch origin ${GIT_BASE_BRANCH} 2>/dev/null || true
   LOCAL=$(git rev-parse ${GIT_BASE_BRANCH})
   REMOTE=$(git rev-parse origin/${GIT_BASE_BRANCH} 2>/dev/null || echo "$LOCAL")
   ```
   If `$LOCAL` != `$REMOTE`:
   ```bash
   git checkout ${GIT_BASE_BRANCH} && git pull origin ${GIT_BASE_BRANCH}
   git checkout ${CURRENT_BRANCH}
   ```
   Display: `Updated ${GIT_BASE_BRANCH} from remote`

6. **Check 3 — Feature branch not behind base_branch:**
   ```bash
   BEHIND=$(git rev-list --count HEAD..${GIT_BASE_BRANCH})
   ```
   - If `$BEHIND` > 0 and `$GIT_UPDATE_WHEN_BEHIND` = true:
     ```bash
     git rebase ${GIT_BASE_BRANCH}
     ```
     Display: `Rebased feature branch onto ${GIT_BASE_BRANCH}`
   - If `$BEHIND` > 0 and `$GIT_UPDATE_WHEN_BEHIND` = false:
     ```
     ⚠️ Feature branch is ${BEHIND} commits behind ${GIT_BASE_BRANCH}.
     update_branch_when_behind is false — proceeding without rebase.
     ```

7. **Check 4 — Clean working tree:**
   ```bash
   git status --porcelain
   ```
   If dirty with unrelated changes (files outside plan scope):
   ```
   ⚠️ Working tree has unrelated changes:
   {git status --porcelain output}

   [1] Stash changes and continue
   [2] Continue anyway
   [3] Stop
   ```
   - If "1": `git stash push -m "pals-preflight-stash"`
   - If "2": proceed with warning logged
   - If "3": halt APPLY

8. **Display preflight summary:**
   ```
   ────────────────────────────────────────
   GitHub Flow Preflight ✓
   ────────────────────────────────────────
   Branch:     ${CURRENT_BRANCH}
   Base:       ${GIT_BASE_BRANCH}
   Behind:     0 commits
   Tree:       clean
   ────────────────────────────────────────
   ```
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

<step name="setup_worktree" priority="after-skills">
**Optional: Create git worktree for isolated execution.**

1. Read pals.json git config:
   ```bash
   WORKTREE_ISOLATION=$(jq -r '.git.worktree_isolation // false' pals.json 2>/dev/null)
   ```

2. **If false or absent:** Skip (no-op). All execution happens on current branch. Proceed to pre_apply_hooks.

3. **If true:**
   a. Derive worktree name from phase:
      ```bash
      PHASE_NAME={phase-name}  # e.g., "37-resilience-and-isolation"
      WORKTREE_DIR=".worktree-${PHASE_NAME}"
      WORKTREE_BRANCH="worktree/${PHASE_NAME}"
      ```

   b. Create worktree:
      ```bash
      git worktree add "${WORKTREE_DIR}" -b "${WORKTREE_BRANCH}"
      ```

   c. Copy .paul/ state into worktree (worktrees share git but not working directory):
      ```bash
      cp -r .paul/ "${WORKTREE_DIR}/.paul/"
      cp pals.json "${WORKTREE_DIR}/pals.json" 2>/dev/null || true
      ```

   d. Record worktree in STATE.md Session Continuity:
      ```markdown
      Worktree: {WORKTREE_DIR} (branch: {WORKTREE_BRANCH})
      ```

   e. **All subsequent task execution happens in the worktree directory.**
      File paths in tasks are relative to the worktree root.

   f. Display:
      ```
      Worktree created: {WORKTREE_DIR}
      Branch: {WORKTREE_BRANCH}
      All execution will happen in isolated worktree.
      ```

4. **If worktree creation fails** (e.g., dirty working tree):
   ```
   ════════════════════════════════════════
   ⚠️ Worktree creation failed
   ════════════════════════════════════════

   Error: {git error message}

   Options:
   [1] Continue without worktree (execute on current branch)
   [2] Fix issue and retry
   [3] Stop
   ════════════════════════════════════════
   ```
   - If "1": Proceed without worktree, log deviation
   - If "2": Wait for user, retry worktree creation
   - If "3": Halt APPLY

**Note:** Fix loop workflows (/paul:fix) do NOT use worktrees regardless of config.
</step>

<step name="pre_apply_hooks" priority="before-tasks">
**Dispatch pre-apply baseline hooks. These record baselines for post-apply comparison.**
1. Read `modules.yaml` (installed module registry; see `references/module-dispatch.md`). If not found, emit `[dispatch] pre-apply: modules.yaml NOT FOUND — WARNING` and skip dispatch.
2. Resolve installed modules for `pre-apply`:
   - TODD (p50): verify test files exist, record test baseline
   - WALT (p100): run test suite, record baseline counts (total/passing/failing)
3. For each: load refs, follow description, collect `context_inject` (baselines)
4. If module returns `action: block` (e.g., TODD finds no test files): surface reason, offer fix/override/stop
5. Output dispatch log: `[dispatch] pre-apply: {MODULE(priority) → baseline recorded | BLOCK(reason)} | ...`
</step>

<step name="execute_tasks">
**Note:** Module-provided execution overlays (loaded via post-plan hooks during planning) may have modified the plan's task structure. Execute tasks as they appear in the approved plan — overlays are already applied.

For each <task> in order:

**If type="auto":**
1. Log task start: "Task N: [name]"
2. Execute <action> content:
   - Create/modify files specified in <files>
   - Follow specific instructions
   - Respect boundaries (DO NOT CHANGE protected files)
3. Run <verify> command/check
4. Record result using structured status (adapted from Superpowers status protocol):
   - PASS: verification succeeded, task complete
   - PASS_WITH_CONCERNS: verification passed but with issues worth noting (e.g., warnings, edge cases untested). Log concerns for UNIFY review.
   - BLOCKED: task cannot proceed due to missing context, wrong assumptions, or plan gap. Escalate — do not force through.
5. Note <done> criteria satisfied
5a. **Ground-truth file check (mandatory):**
    After running <verify>, confirm files listed in <files> were actually modified:
    ```bash
    git diff --name-only -- {paths from <files> tag}
    ```
    - If <files> lists specific paths but `git diff` shows **zero changes** to those paths: **FAIL the task**. Do not mark as PASS.
    - If the task edited a path outside the repo (e.g., `~/.pi/`, `~/.claude/`, `~/.carl/`): this is a **plan defect**. HALT and notify:
      ```
      ⚠️ PLAN DEFECT: Task edited files outside the repo.
      Edited: {out-of-repo path}
      Repo source: {expected repo path, if known}

      The repo source copy must be the edit target. Fix the plan or
      redirect edits to the repo path before continuing.
      ```
    - Exception: tasks whose <files> tag is empty or whose type is `checkpoint:*` are exempt from this check.
6. **Divergence check** (adapted from Devin deviation detection):
   After each task, briefly compare what was actually done vs what the plan specified:
   - Files modified match plan's `<files>` list? Unexpected files touched?
   - Action taken matches plan's `<action>`? Significant departures?
   - If divergence is minor (e.g., extra helper file): note it, continue
   - If divergence is significant (e.g., different approach, skipped requirement): **notify user** before proceeding:
     ```
     ⚠️ DEVIATION: Task N diverged from plan
     Plan: [what plan said]
     Actual: [what happened]
     Continue? [yes/adjust plan/stop]
     ```
6. **Dispatch post-task enforcement hooks:**
   a. Read `modules.yaml` (installed module registry; see `references/module-dispatch.md`), or confirm already loaded. If not found, emit `[dispatch] post-task: modules.yaml NOT FOUND — WARNING` and skip dispatch.
   b. Resolve installed modules for `post-task` (currently: TODD at p100)
   c. For each registered module:
      - Load hook-specific `refs`
      - Follow hook description (e.g., run test suite, compare against baseline)
      - Pass task name, task result, and `context_inject` from pre-apply
   d. If module returns `action: block`:
      - Surface the reason to the user
      - Offer: fix the issue / skip this task / stop APPLY
   e. Output dispatch log: `[dispatch] post-task(Task N): {MODULE(priority) → PASS | BLOCK(reason)} | ...`
   f. Note: post-task has no advisory modules — only TODD enforcement. Advisory output comes at post-apply.

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

<step name="advisory_module_dispatch" priority="after-tasks">
⚠️ **MANDATORY — DO NOT SKIP THIS STEP.**
STOP after task execution. You MUST dispatch advisory modules NOW before proceeding to enforcement.
**Dispatch advisory (non-blocking) post-apply modules. This step runs BEFORE enforcement so advisory output is ALWAYS visible.**
1. Read `modules.yaml` (installed module registry; see `references/module-dispatch.md`), or confirm already loaded. If not found, emit `[dispatch] post-apply advisory: modules.yaml NOT FOUND — WARNING` and skip dispatch.
2. Resolve installed modules for `post-apply` whose hook description does NOT contain "block" — these are advisory-only modules:
   - IRIS (review patterns, p250)
   - DOCS (doc drift detection, p250)
   - RUBY (debt detection, p300)
   - SKIP (knowledge extraction, p300)
3. Sort by priority ascending, run each:
   a. Load hook-specific `refs`
   b. Follow hook description
   c. Pass `context_inject` from pre-apply
   d. Collect `annotations` (code smells, security flags, debt reports, doc drift, knowledge suggestions)
4. Output dispatch log: `[dispatch] post-apply advisory: {MODULE(priority) → N annotations | skip} | ...`
5. Display ALL advisory annotations to the user.
6. This step NEVER blocks — advisory modules inform, they do not gate.
7. If you did not execute any advisory module hooks above, you MUST state why:
   `[dispatch] post-apply advisory: SKIPPED — {reason}`
</step>
<step name="enforcement_module_dispatch" priority="after-advisory">
⚠️ **MANDATORY — DO NOT SKIP THIS STEP.**
STOP after advisory dispatch. You MUST dispatch enforcement modules NOW.
**Dispatch enforcement (blocking) post-apply modules. Advisory output is already visible above.**
1. Read `modules.yaml` if not already loaded. If not found, emit `[dispatch] post-apply enforcement: modules.yaml NOT FOUND — WARNING` and skip dispatch.
2. Resolve installed modules for `post-apply` whose hook description contains "block" — these are enforcement modules:
   - WALT (quality gate: tests + lint + typecheck vs baseline, p100)
   - DEAN (dependency audit vs baseline, p150)
   - TODD (full test suite + refactor candidates, p200)
3. Sort by priority ascending, run each:
   a. Load hook-specific `refs`
   b. Follow hook description
   c. Pass `context_inject` and baselines from pre-apply
   d. Collect result: PASS or BLOCK with reason
4. Output dispatch log: `[dispatch] post-apply enforcement: {MODULE(priority) → PASS | BLOCK(reason)} | ...`
5. If any module returned `action: block`:
   - The user already has full advisory context from the step above
   - Surface blocking reason(s) with fix/override/stop options
6. If all enforcement modules pass: proceed to finalize
7. Store accumulated `annotations` from both steps for inclusion in finalize step
8. If you did not execute any enforcement module hooks above, you MUST state why:
   `[dispatch] post-apply enforcement: SKIPPED — {reason}`
</step>

<step name="handle_failures">
If a task verification fails:

1. **Stop immediately** - do not proceed to next task
2. **Report clearly:**
   - Which task failed
   - What verification check failed
   - What was expected vs actual
3. **Bounded retry** (adapted from Aider reflection loop):
   - Retry: attempt the task again (max 2 retries on the same task)
   - After 2 failed retries: escalate — do NOT keep retrying the same approach
   - On escalation, offer:
     - **Revert and refine** (adapted from Cursor revert-and-refine pattern): revert task changes, adjust the approach or plan, then re-attempt
     - Skip: mark as failed, continue (creates deviation)
     - Stop: halt execution, prepare for debugging
4. **Record resolution to STATE.md:**
   - Add to `### Decisions` section: `| [date]: Task [N] [retry/skip/stop/revert-refine] - [reason] | Phase [N] | [impact] |`

5. **Partial task failure** (multi-file task where some files were modified before failure):
   - **Assess:** Run `git diff` to see which files were changed vs what the task planned
   - **Preserve:** Files that were correctly modified and pass independent verification
   - **Revert:** Files in broken/incomplete state — use `git checkout <file>` for specific files (not `git checkout .`)
   - **Resume:** After fixing root cause, re-run only the remaining work — do not repeat already-verified changes
   - **Record:** Note which files were preserved vs reverted in the deviation log for UNIFY

6. **Never revert blindly:** Always check `git diff` before reverting. Partial work may include correct changes that should be kept. Reverting everything wastes completed work and may mask the actual failure point.

7. **Stuck/loop detection** (adapted from OpenHands stuck detector):
   Monitor for unproductive patterns during execution:
   - Same error appearing 3+ times across retries → approach is wrong, not just buggy
   - Alternating between two states (fix A breaks B, fix B breaks A) for 2+ cycles → architectural issue
   - Making changes that get reverted repeatedly → stop and reassess
   When a stuck pattern is detected: **halt execution**, report the pattern to the user, and suggest either reverting to pre-task state and refining the plan, or escalating to a different approach.
</step>

<step name="track_progress">
Throughout execution:

1. Maintain mental log of:
   - Tasks completed (with results — PASS, PASS_WITH_CONCERNS, or BLOCKED)
   - Tasks failed (with reasons and retry count)
   - Checkpoints resolved (with decisions/approvals)
   - Deviations from plan (from per-task divergence checks)
2. This information feeds into UNIFY phase

3. **Re-plan trigger assessment** (deferred from Phase 38 — re-plan/divergence protocol):
   After each task, evaluate whether accumulated deviations warrant re-planning:
   - **Continue as-is:** Minor deviations, plan still valid, remaining tasks unaffected
   - **Adapt in-flight:** Moderate deviation — adjust remaining task approach without formal re-plan (note adaptation for UNIFY)
   - **Re-plan:** Major divergence — stop APPLY, return to PLAN phase with learnings. Triggers:
     - 2+ tasks with significant deviations
     - A BLOCKED task that reveals the plan's assumptions were wrong
     - Discovered requirements that make remaining tasks invalid
   If re-plan triggered: update STATE.md loop position back to PLAN ○, note reason, and suggest `/paul:plan` with the new context.
</step>

<step name="github_flow_postflight" priority="after-hooks">
**Conditional: Push branch and create PR after successful execution.**

1. **Resolve workflow mode** (same pattern as preflight):
   ```bash
   GIT_WORKFLOW=$(jq -r '.git.workflow // empty' pals.json 2>/dev/null)
   if [ -z "$GIT_WORKFLOW" ]; then
     GIT_BRANCHING_CHECK=$(jq -r '.git.branching // empty' pals.json 2>/dev/null)
     if [ -n "$GIT_BRANCHING_CHECK" ]; then GIT_WORKFLOW="legacy"; else GIT_WORKFLOW="none"; fi
   fi
   ```

2. **If GIT_WORKFLOW != "github-flow":** Skip entire step (no-op). Proceed to finalize.

3. **Read config fields:**
   ```bash
   GIT_AUTO_PUSH=$(jq -r '.git.auto_push // false' pals.json 2>/dev/null)
   GIT_AUTO_PR=$(jq -r '.git.auto_pr // false' pals.json 2>/dev/null)
   GIT_CI_CHECKS=$(jq -r '.git.ci_checks // false' pals.json 2>/dev/null)
   GIT_REMOTE=$(jq -r '.git.remote // empty' pals.json 2>/dev/null)
   GIT_BASE_BRANCH=$(jq -r '.git.base_branch // "main"' pals.json 2>/dev/null)
   PHASE_NAME={phase-name}
   CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
   ```

4. **If no remote set:** Skip all remote operations silently. Proceed to finalize.

5. **Stage and commit implementation work:**
   ```bash
   git add -A
   git commit -m "feat(${PHASE_NAME}): {description}" --allow-empty
   ```

6. **Push feature branch (if auto_push=true):**
   ```bash
   git push origin ${CURRENT_BRANCH}
   ```
   Display: `Pushed ${CURRENT_BRANCH} to origin`

7. **Create PR (if auto_pr=true):**
   ```bash
   # Check if PR already exists for this branch
   EXISTING_PR=$(gh pr view ${CURRENT_BRANCH} --json url -q '.url' 2>/dev/null || echo "")
   ```
   - If PR exists: Display `PR already exists: ${EXISTING_PR}`
   - If no PR:
     ```bash
     gh pr create --base ${GIT_BASE_BRANCH} --head ${CURRENT_BRANCH} \
       --title "feat(${PHASE_NAME}): {description}" \
       --body "Phase {N} — auto-generated by PALS."
     ```
   - Record PR URL in STATE.md `### Git State` section:
     ```markdown
     PR: {url} (state: open)
     ```

8. **Surface CI check state (if ci_checks=true):**
   ```bash
   gh pr checks ${CURRENT_BRANCH}
   ```
   Display CI results (informational — blocking enforcement happens in unify-phase merge gate, not here):
   ```
   ────────────────────────────────────────
   CI Status: {passing|failing|pending}
   Note: CI is informational here. Merge gate
   in UNIFY will enforce before next phase.
   ────────────────────────────────────────
   ```

9. **Display postflight summary:**
   ```
   ────────────────────────────────────────
   GitHub Flow Postflight ✓
   ────────────────────────────────────────
   Branch:  ${CURRENT_BRANCH}
   Pushed:  {yes/no}
   PR:      {url or "not created"}
   CI:      {status or "not checked"}
   ────────────────────────────────────────
   ```
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
3. Include module annotations from post-apply hooks (if any):
   - Append reports collected from registered modules
   - Show combined gate result if any module provided quality gates
   **Dispatch evidence check:** If BOTH advisory and enforcement dispatch logs show
   "SKIPPED" or are absent entirely, MUST display:
   '⚠️ WARNING: No post-apply modules fired. Verify modules.yaml was loaded.
   Module Execution Reports will be empty in SUMMARY.md.'
4. Report with quick continuation prompt:
   ```
   ════════════════════════════════════════
   APPLY COMPLETE
   ════════════════════════════════════════
   [execution summary]

   [module annotations if any]

   ---
   Continue to UNIFY?

   [1] Yes, run UNIFY | [2] Pause here
   ```
4. **Accept quick inputs:** "1", "yes", "continue", "go" → run `/paul:unify [plan-path]`
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
