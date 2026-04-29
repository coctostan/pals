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
references/checkpoints.md — load-only-if the approved PLAN contains any `checkpoint:*` task
references/loop-phases.md
references/module-dispatch.md
references/git-strategy.md
references/subagent-criteria.md — load-only-if APPLY is actively considering delegation of an eligible auto task to repo-local `pals-implementer`
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
Use `references/git-strategy.md` for the exact bash recipe.

1. Resolve `GIT_WORKFLOW` with the shared 3-tier recipe in `references/git-strategy.md`.
2. **If `GIT_WORKFLOW != "github-flow"`:** Skip the entire step (no-op). Proceed to `load_plan`.
3. Read the github-flow preflight fields from `pals.json`: `base_branch`, `update_branch_when_behind`, `remote`, and phase context.
4. Before work starts, enforce the shared preflight gates from `references/git-strategy.md`:
   - create or reuse a non-base feature branch
   - refresh the base branch from remote when configured
   - rebase if the working branch is behind base and `update_branch_when_behind=true`
   - if unrelated working-tree changes exist, require stash/continue/stop handling
5. Resolve `CURRENT_BRANCH` after any branch creation and use it for all downstream commands — never assume a branch name from phase name.
6. Emit the visible `GitHub Flow Preflight ✓` summary with branch, base, behind, and tree status.
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
**Dispatch pre-apply baseline hooks via `references/module-dispatch.md`.**

Call-site contract:
- Hook: `pre-apply` baseline dispatch.
- Context/output: plan task order and detected validation commands; record baselines for post-task and post-apply comparison.
- Blocking: honor enforcement-capable `action: block` responses with fix/override/stop options.
- Required evidence: `[dispatch] pre-apply: ...`; if nothing fires, still emit the visible hook line; if registry resolution fails, `[dispatch] pre-apply: modules.yaml NOT FOUND — WARNING`.
</step>

<step name="execute_tasks">
**Note:** Module-provided execution overlays (loaded via post-plan hooks during planning) may have modified the plan's task structure. Execute tasks as they appear in the approved plan — overlays are already applied.

For each <task> in order:
Load-only-if note: if the approved plan contains any `checkpoint:*` task, read `references/checkpoints.md` before checkpoint execution; otherwise do not load it.


**If type="auto":**
1. Log task start: "Task N: [name]"
2. Decide execution mode:
   - Default to inline APPLY in the parent session.
   - load-only-if delegation is being considered for this eligible auto task: read `references/subagent-criteria.md`, then evaluate delegation against that reference plus the Delegated APPLY Packet/Report Contract.
   - Delegation to repo-local `pals-implementer` is optional, task-bounded, and allowed only when all of the following are true:
     - approved plan is `autonomous: true`
     - the task is a bounded autonomous unit the parent can describe, inspect, and verify as equivalent to inline APPLY
     - `<files>`, `<action>`, `<verify>`, and `<done>` are clear and bounded
     - no checkpoint, human decision/action, external approval, GitHub Flow decision, or merge intent is required inside the task
     - file scope is repo-local and explicit
     - `.paul/*` lifecycle ownership, official verification, module enforcement, fallback judgment, task status, checkpoints, GitHub Flow gates, and state/report writes remain in the parent
     - delegation may be used for a single eligible task or sequential task step; it is not limited to parallel-only work
     - ambiguous, exploratory, cross-repo, checkpointed, or non-equivalent work stays inline in the parent session; decision-heavy work also stays inline
3. **If delegation is considered:**
   a. Read config:
      ```bash
      IMPLEMENTER_ENABLED=$(jq -r '.agents.implementer.enabled // true' pals.json 2>/dev/null)
      IMPLEMENTER_MODEL=$(jq -r '.agents.implementer.model // empty' pals.json 2>/dev/null)
      ```
   b. Require all of:
      - `Agent()` is available
      - repo-local `.pi/agents/pals-implementer.md` exists and is valid
      - `IMPLEMENTER_ENABLED = true`
   c. Build a **Parent-owned task packet** before dispatch. Include a lifecycle reminder and these fields:
      - `packet_id`: stable identifier such as `{phase}-{plan}-task-{N}`
      - `plan_path`: repo-relative approved PLAN path
      - `task_name`: exact task name from the PLAN
      - `objective` and exact task `<action>` content
      - `Allowed files:` repo-relative files the helper may create or modify
      - `Forbidden files:` `.paul/*` lifecycle artifacts, installed absolute paths, generated install outputs, dependency manifests/lockfiles, CI config, GitHub Flow automation, plan-protected files, and any other file not explicitly allowed
      - `context_sources`: relevant plan/design excerpts and immediate supporting repo files
      - `verification_to_attempt`: task-local checks the helper may run before reporting
      - `Parent-run official verification:` the exact `<verify>` command/check the parent will rerun before PASS
      - `module_caveats`: task-local module expectations from pre-apply context
      - `checkpoint_status`: explicit statement that no checkpoint/human action is delegated, or that the task is ineligible if one is required
      - `Fallback triggers:` missing or stale packet/PLAN/context, ambiguity, scope creep, checkpoint or human-decision needs, unverifiable checks, out-of-scope edits, `.paul/*` lifecycle needs, GitHub Flow/CI/review/merge questions, hidden helper state, report defects, or non-equivalent results
      - `report_schema`: required structured helper report fields
      - `Authority: Derived aid only; no helper-owned .paul/* lifecycle writes.` Parent APPLY owns verification, module gates, fallback, task status, checkpoints, GitHub Flow, and lifecycle writes.
      - Compatibility marker: parent owns verification, module gates, fallback, and state/report writes.
   d. Resolve model in this order:
      - explicit per-dispatch override from the parent workflow
      - `pals.json` `agents.implementer.model`
      - `.pi/agents/pals-implementer.md` frontmatter model
      - runtime default
   e. Dispatch in foreground mode:
      ```javascript
      Agent({
        subagent_type: "pals-implementer",
        prompt: assembled_task_packet,
        description: `Apply task ${N}: ${task_name}`,
        run_in_background: false,
        inherit_context: false,
        model: IMPLEMENTER_MODEL || undefined,
      })
      ```
   f. Require a **structured helper report** from the subagent covering:
      - `status`: complete, blocked, or fallback_recommended
      - `packet_id`
      - `task_name`
      - `files_changed`
      - `summary`
      - `commands_run`
      - `verification_attempted`
      - `verification_results`
      - `deviations`
      - `concerns`
      - `fallback_recommended`
      - `parent_review_required`
   g. Parent acceptance is mandatory before any PASS:
      - read the structured helper report and reject missing/malformed/unverifiable fields
      - run a changed-file diff check: compare report `files_changed`, `git diff --name-only -- {allowed_files}`, and full `git diff --name-only` against `Allowed files:` and PLAN boundaries
      - inspect content diffs for changed files
      - rerun the official `<verify>` in the parent session as `Parent-run official verification:`
      - run required module hooks and classify task status only by parent judgment
   h. Fall back immediately to inline APPLY if any of the following is true:
      - the task fails eligibility
      - config disables the path
      - `Agent()` is unavailable
      - `.pi/agents/pals-implementer.md` is missing or invalid
      - the subagent returns `blocked`
      - `fallback_recommended = true`
      - the report is incomplete, malformed, stale, or unverifiable
      - the run touched or proposes touching files outside approved scope
      - helper output claims `.paul/*` lifecycle writes, official validation authority, module gate satisfaction, checkpoint completion, GitHub Flow/CI/review/merge readiness, hidden helper state, or lifecycle truth
      - the parent cannot judge the result as equivalent to inline APPLY
4. Execute `<action>` content:
   - If delegated path is accepted: review the returned report, inspect claimed file changes, and continue under parent control.
   - If inline path is used or fallback is triggered: create/modify files specified in `<files>`, follow specific instructions, and respect boundaries (DO NOT CHANGE protected files).
5. Run the official `<verify>` command/check in the parent session.
6. Record result using structured status (adapted from Superpowers status protocol):
   - PASS: verification succeeded, task complete
   - PASS_WITH_CONCERNS: verification passed but with issues worth noting (e.g., warnings, edge cases untested). Log concerns for UNIFY review.
   - BLOCKED: task cannot proceed due to missing context, wrong assumptions, plan gap, or non-equivalent delegated execution. Escalate — do not force through.
7. Note <done> criteria satisfied
7a. **Ground-truth file check (mandatory):**
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
      redirect edits to the repo path before continuing.
      ```
    - Exception: tasks whose <files> tag is empty or whose type is `checkpoint:*` are exempt from this check.
8. **Divergence check** (adapted from Devin deviation detection):
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
9. **Dispatch post-task enforcement hooks via `references/module-dispatch.md`:**
   - Hook: `post-task` enforcement dispatch.
   - Context/output: current task name/result plus pre-apply baselines; record regression signals for UNIFY.
   - Blocking: compare validation results against baselines, block on regression, and surface fix/skip/stop options.
   - Required evidence: `[dispatch] post-task(Task N): ...`; if nothing runs, emit a visible `SKIPPED` line; if registry resolution fails, `[dispatch] post-task(Task N): modules.yaml NOT FOUND — WARNING`.

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
STOP after task execution and dispatch advisory post-apply modules via `references/module-dispatch.md` before enforcement so advisory output is always visible.

Call-site contract:
- Hook: `post-apply` advisory cohort.
- Context/output: changed files plus pre-apply context; collect code smells, doc drift, debt, and knowledge annotations for UNIFY.
- Blocking: never block here; display all annotations.
- Required evidence: `[dispatch] post-apply advisory: ...`; if none executed, state `[dispatch] post-apply advisory: SKIPPED — {reason}`; if registry resolution fails, `[dispatch] post-apply advisory: modules.yaml NOT FOUND — WARNING`.
</step>
<step name="enforcement_module_dispatch" priority="after-advisory">
⚠️ **MANDATORY — DO NOT SKIP THIS STEP.**
STOP after advisory dispatch and run blocking post-apply modules via `references/module-dispatch.md`.

Call-site contract:
- Hook: `post-apply` enforcement cohort.
- Context/output: changed files, task results, annotations, and pre-apply baselines; collect PASS/BLOCK gate results for finalize and UNIFY.
- Blocking: compare tests/lint/typecheck/audit/full-suite results against baselines and surface any BLOCK with fix/override/stop options.
- Required evidence: `[dispatch] post-apply enforcement: ...`; if none executed, state `[dispatch] post-apply enforcement: SKIPPED — {reason}`; if registry resolution fails, `[dispatch] post-apply enforcement: modules.yaml NOT FOUND — WARNING`.
- If all enforcement passes, proceed to finalize with accumulated annotations.
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
Use `references/git-strategy.md` for the exact bash recipe.

1. Resolve `GIT_WORKFLOW` with the shared 3-tier recipe in `references/git-strategy.md`.
2. **If `GIT_WORKFLOW != "github-flow"`:** Skip the entire step (no-op). Proceed to `finalize`.
3. Read the github-flow postflight fields from `pals.json`: `auto_push`, `auto_pr`, `ci_checks`, `remote`, `base_branch`; resolve `CURRENT_BRANCH`.
4. Stage and commit the implementation work on `CURRENT_BRANCH` before any remote operations.
5. If a remote is configured, follow the shared postflight recipe from `references/git-strategy.md` to push when `auto_push=true`, create or reuse a PR when `auto_pr=true`, record the PR URL/state, and surface CI when `ci_checks=true`.
6. Emit the visible `GitHub Flow Postflight ✓` summary with branch, push, PR, and CI status. CI remains informational here; blocking enforcement happens in UNIFY.
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
