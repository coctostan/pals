<purpose>
Execute an approved PLAN.md under parent APPLY authority: run tasks in order, verify each, stop at checkpoints, and record bounded evidence for UNIFY.
</purpose>

<when_to_use>
- User explicitly approved a specific PLAN.md
- Bounded STATE fields confirm the same phase/plan and no unresolved blocker
</when_to_use>

<loop_context>
Expected phase: APPLY
Prior phase: PLAN approved
Next phase: UNIFY after execution
</loop_context>

<required_reading>
- Bounded `.paul/STATE.md` fields for current position, loop position, blockers, and approved plan.
- Approved PLAN sections only: frontmatter/files, tasks, boundaries, files, acceptance criteria, and checkpoints.
- Installed `modules.yaml` registry for pre-apply, post-task, and post-apply hook dispatch.
</required_reading>

<hot_artifact_loading>
When touching hot `.paul/*` lifecycle artifacts (`STATE.md`, `PROJECT.md`, `MILESTONES.md`, `ROADMAP.md`), locate the relevant heading, marker, phase row, plan ID, resume file, status line, or section label first and read the smallest useful bounded window.
Escalate to a full read only as an explicit fallback when fields are missing or contradictory, or when the task requires whole-artifact rewrite, audit, repair, migration, lifecycle write, or whole-artifact validation.
</hot_artifact_loading>

<references>
kernel/references/checkpoints.md — Load checkpoint guidance only if the approved PLAN contains any `checkpoint:*` task.
kernel/references/loop-phases.md
kernel/references/module-dispatch.md
kernel/references/git-strategy.md
kernel/references/subagent-criteria.md — load-only-if considering `pals-implementer` delegation.
</references>

<process>

<step name="load_apply_state_bounded" priority="first">
1. Confirm explicit approval for the requested PLAN path; never infer approval from context.
2. Read only bounded STATE fields needed to match approval against current phase/plan, loop readiness, blockers, and resume path if needed.
3. Proceed only when approval, STATE, and PLAN path agree; otherwise ask: "Approve APPLY for [path]?"
</step>

<step name="github_flow_preflight" priority="after-approval">
**Conditional: GitHub Flow branch validation before work begins.**
Use `kernel/references/git-strategy.md` for exact commands.

1. Resolve `GIT_WORKFLOW`; if not `github-flow`, skip to `load_plan_sections`.
2. Read only needed `pals.json` git fields: `base_branch`, `update_branch_when_behind`, `remote`.
3. Enforce shared preflight gates: non-base branch, refreshed base, behind-branch update, unrelated-change handling.
4. Resolve `CURRENT_BRANCH` after branch actions; emit `GitHub Flow Preflight ✓` with branch, base, sync, and tree status.
</step>

<step name="load_plan_sections">
Load approved PLAN sections only: frontmatter/files, tasks, boundaries, files, acceptance criteria, and checkpoints.
Extract the ordered task list, scope boundaries, required skills, verify/done criteria, and checkpoint presence.
Defer `kernel/references/checkpoints.md` until the first checkpoint task.
</step>

<step name="verify_required_skills" priority="blocking">
If the PLAN lists required skills, confirm each was invoked. Missing skills block APPLY: show missing load commands and accept only `ready` to re-check or `override` to continue with a STATE deviation.
</step>

<step name="setup_worktree" priority="after-skills">
If `pals.json` enables `git.worktree_isolation`, create a phase-named worktree/branch, copy only bounded active APPLY context (`pals.json` and needed `.paul/*` files), record path/branch in STATE, and run tasks there.
If disabled, continue on the current branch. If setup fails, ask: continue without worktree and log deviation, retry, or stop. `/paul:fix` never uses worktrees.
</step>

<step name="pre_apply_hooks" priority="before-tasks">
Dispatch `pre-apply` via `kernel/references/module-dispatch.md`; record task order, validation baselines, blocking responses, and visible evidence (`[dispatch] pre-apply: ...` or registry warning).
</step>

<step name="execute_tasks">
Execute approved tasks in order; post-plan module overlays are already part of the approved PLAN.
Route each task by type:
- `auto` → `execute_auto_task`
- `checkpoint:*` → `handle_checkpoints`
- unknown type → block for user guidance
</step>

<step name="execute_auto_task">
1. Default to inline parent APPLY.

2. Consider `pals-implementer` only after loading `kernel/references/subagent-criteria.md`.

3. Delegation gate: delegation may be used for a single eligible task or sequential task step only when all are true:
   - PLAN has `autonomous: true`
   - task files/action/verify/done are explicit and repo-local
   - no checkpoint, human decision/action, external approval, GitHub Flow decision, or merge intent is inside the task
   - parent can verify the result as equivalent to inline APPLY

4. If any gate fails, stay inline. ambiguous, exploratory, cross-repo, checkpointed, or non-equivalent work stays inline.

5. Parent APPLY owns verification, module gates, fallback, checkpoints, GitHub Flow, and lifecycle writes; helper-owned .paul/* lifecycle writes are forbidden. Authority: Derived aid only; no helper-owned .paul/* lifecycle writes.
   Compatibility marker: parent owns verification, module gates, fallback, and state/report writes.

6. If delegation is used, require `Agent()`, enabled implementer config, and repo-local `.pi/agents/pals-implementer.md`; dispatch foreground with `subagent_type: "pals-implementer"`.

7. Send a Parent-owned task packet with a lifecycle reminder and compact task packet fields: `packet_id`, plan path, task name/action, `Allowed files:`, `Forbidden files:`, context excerpts, verification to attempt, `Parent-run official verification:`, module caveats, checkpoint status, `Fallback triggers:`, `report_schema`, and authority reminder.

8. Require a compact structured helper report: status, packet_id, files_changed, commands_run, verification_attempted/results, deviations/concerns, fallback recommendation, and parent review required.

9. Helper output is review input only. Before PASS, parent must inspect changed files against PLAN scope, run a changed-file diff check, run Parent-run official verification, run required hooks, and classify status by parent judgment only.

10. Fall back to inline APPLY when delegation is disabled, unavailable, stale, ambiguous, unverifiable, out-of-scope, or claims helper authority over `.paul/*`, official verification, module gates, checkpoints, GitHub Flow, lifecycle writes, or lifecycle truth.

11. Unauthorized helper edits are blocking boundary contamination: identify, repair/revert if safe, or halt for user guidance before continuing.

12. Run the official `<verify>` in the parent session. Ground-truth check: planned `<files>` changed when expected, no unapproved paths changed, action matches plan, and significant divergence blocks for user decision.

13. Record PASS, PASS_WITH_CONCERNS, or BLOCKED.

14. Dispatch `post-task` hooks via `kernel/references/module-dispatch.md`; record `[dispatch] post-task(Task N): ...`, `SKIPPED`, or registry warning.
</step>

<step name="handle_checkpoints">
Load checkpoint guidance only if the task type is `checkpoint:*`.
For each checkpoint: stop, show a compact checkpoint payload, wait for user response, and do not proceed past unresolved checkpoints.

Payload:
- `checkpoint:human-verify`: task, what was built, how to verify, resume signal.
- `checkpoint:decision`: decision, context, options/pros/cons, resume signal.
- `checkpoint:human-action`: required manual action, instructions, APPLY verification, resume signal.

After response:
- `checkpoint:human-verify`: continue on approval; otherwise fix/re-verify or record deviation.
- `checkpoint:decision`: apply selected option; record in STATE when the choice changes implementation direction or must be cited by UNIFY.
- `checkpoint:human-action`: run planned verification before continuing.
- unknown checkpoint type: block for user guidance.
</step>

<step name="advisory_module_dispatch" priority="after-tasks">
Dispatch post-apply advisory modules via `kernel/references/module-dispatch.md` before enforcement; record annotations for UNIFY and evidence (`[dispatch] post-apply advisory: ...`, `SKIPPED`, or `modules.yaml NOT FOUND — WARNING`).
</step>

<step name="enforcement_module_dispatch" priority="after-advisory">
Run blocking post-apply enforcement modules via `kernel/references/module-dispatch.md`; record baseline comparisons, PASS/BLOCK results, and evidence (`[dispatch] post-apply enforcement: ...`, `SKIPPED`, or `modules.yaml NOT FOUND — WARNING`). On BLOCK, offer fix/override/stop before finalize.
</step>


<step name="handle_failures">
On task verification failure:
1. Stop before the next task; report failed task, failed check, expected vs actual, and changed-file scope.
2. Retry at most twice with a changed approach. If errors repeat, fixes oscillate, or retries undo prior work, halt for user guidance.
3. Preserve verified partial work; repair or revert only specific broken files after targeted scope/diff review. Never revert blindly.
4. Record retry, skip, stop, revert/refine, or blocker evidence for STATE and UNIFY.
</step>

<step name="track_progress">
After each task, track PASS / PASS_WITH_CONCERNS / BLOCKED, retries, checkpoints, deviations, and module notes for UNIFY.
If deviations invalidate the remaining plan, stop APPLY, record why, update STATE to require PLAN again, and suggest `/paul:plan`.
</step>

<step name="github_flow_postflight" priority="after-hooks">
After successful task execution and scope review, if `GIT_WORKFLOW=github-flow`, use `kernel/references/git-strategy.md` postflight: commit on `CURRENT_BRANCH`, push/create or reuse PR when configured, surface PR/CI status, and emit `GitHub Flow Postflight ✓`.
If not github-flow, skip to finalize. CI is informational in APPLY; UNIFY owns merge readiness.
</step>

<step name="finalize">
Finalize only when all tasks are PASS/PASS_WITH_CONCERNS, or when the user explicitly accepts a skip/stop deviation.
1. Summarize tasks, failures/deviations, PR/CI status, and module annotations.
2. If both advisory and enforcement dispatches are absent or `SKIPPED`, warn that Module Execution Reports may be empty.
3. If APPLY completed, update STATE: PLAN ✓ → APPLY ✓ → UNIFY ○, last activity, resume file, and next action.
4. Prompt: `Continue to UNIFY?` Accept `1`, `yes`, `continue`, or `go` to run `/paul:unify [plan-path]`.
</step>
</process>

<output>
- Planned files modified and parent-verified
- Task/deviation/module evidence ready for UNIFY
- STATE updated only when APPLY is complete
</output>

<error_handling>
- Plan missing or approval mismatch: confirm plan path.
- Boundary violation: stop; do not modify protected files.
- Verification failure: use `handle_failures`; do not mark task complete.
- Checkpoint unresolved: wait, remind, or pause; do not continue.
</error_handling>

<anti_patterns>
- Starting without explicit approval
- Accepting helper output without parent verification
- Modifying protected files
- Proceeding past unresolved checkpoints
</anti_patterns>