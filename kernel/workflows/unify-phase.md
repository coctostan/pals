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
Routine bounded inputs:
- `.paul/STATE.md` — Current Position, Loop Position, Session Continuity, and Git State / last commit only when needed.
- `.paul/phases/{phase}/{plan}-PLAN.md` — frontmatter/files_modified, acceptance criteria, tasks, verification, boundaries, module_dispatch, and output target.
- `modules.yaml` — installed registry for pre-unify/post-unify dispatch.

Conditional inputs:
- Changed-file evidence — targeted changed-file evidence from PLAN paths and the working tree when reconciling results.
- `workflows/transition-phase.md` — only when `check_phase_completion` finds this is the last plan.
</required_reading>

<hot_artifact_loading>
For hot `.paul/*` artifacts, locate the relevant heading, marker, phase row, plan ID, status line, or section label first and read the smallest useful bounded window.
Use full read fallback only when bounded windows are missing, contradictory, or insufficient for lifecycle write/audit/repair.
</hot_artifact_loading>

<references>
kernel/references/loop-phases.md
kernel/references/module-dispatch.md
kernel/references/git-strategy.md
kernel/templates/SUMMARY.md
workflows/transition-phase.md (always listed; executed only when check_phase_completion finds this is the last plan)
<!-- Module references are loaded dynamically via hook dispatch from the installed registry resolved as modules.yaml -->
</references>

<process>

<step name="load_unify_state_bounded" priority="first">
1. Read bounded STATE loop/session fields only:
   - Current Position
   - Loop Position
   - Session Continuity
   - Git State / last commit when needed
2. If Session Continuity contains `Pending retroactive UNIFY`:
   - Set mode = retroactive
   - Capture hotfix description, commit/range, and changed-file evidence
   - Continue to `retroactive_unify`
3. Otherwise:
   - Confirm APPLY is complete for the current plan
   - Continue to `load_plan_reconciliation_sections`
</step>

<step name="retroactive_unify" condition="retroactive_flag_detected">
1. Gather targeted changed-file evidence for the recorded hotfix/base range.
2. If the hotfix description is missing, ask for one brief description.
3. Create `.paul/phases/{phase-dir}/{phase}-{NN}-HOTFIX-SUMMARY.md` with issue, mode, commit/range, files changed, and result.
4. Clear the retroactive flag from STATE.md.
5. Dispatch post-unify hooks normally.
6. Skip normal plan reconciliation and phase transition; hotfixes are side-loops, not phase progression.
</step>

<step name="load_plan_reconciliation_sections">
1. Read only approved PLAN sections needed as reconciliation inputs:
   - frontmatter/files_modified
   - acceptance criteria
   - tasks and verification
   - boundaries
   - module_dispatch
   - output/SUMMARY target
2. Collect targeted changed-file evidence from PLAN paths and the working tree.
3. If PLAN files and changed-file evidence contradict each other, carry `reconciliation_mismatch` into `compare_plan_vs_actual`.
4. Collect APPLY annotations as inputs: task status, verification results, checkpoint decisions, failures, and deviations.
</step>

<step name="pre_unify_hooks" priority="before-reconciliation">
Dispatch pre-unify hooks via `kernel/references/module-dispatch.md`.

Call-site contract:
- Hook: `pre-unify`.
- Context/output: APPLY annotations and reconciliation inputs; collect `context_inject`.
- Blocking: only if a module explicitly returns `action: block`.
- Required evidence: `[dispatch] pre-unify: ...`; if none registered, emit `[dispatch] pre-unify: 0 modules registered for this hook`; if registry resolution fails, emit `[dispatch] pre-unify: modules.yaml NOT FOUND — WARNING`.
</step>

<step name="compare_plan_vs_actual">
Produce `reconciliation_facts`:
- Acceptance criteria: PASS/FAIL plus evidence.
- Tasks: status, verification result, and material deviations.
- Files: planned changed, unplanned changed, and any `reconciliation_mismatch`.
- Decisions/checkpoints: final choice or approval outcome when relevant.
</step>

<step name="audit_skill_invocations">
1. If the PLAN has no `<skills>` section, skip.
2. Compare required PLAN skills with observed APPLY activity.
3. Produce `skill_audit`: all-invoked note or non-blocking gaps for SUMMARY deviations.
</step>

<step name="create_summary">
1. Create `.paul/phases/{phase}/{plan}-SUMMARY.md` from reconciliation inputs.
2. SUMMARY is the detailed reconciliation artifact:
   - objective/result
   - files changed and purpose
   - acceptance criteria results
   - task/verification results
   - deviations and checkpoint decisions
   - `## Module Execution Reports` placeholder
   - brief Next Phase note
3. Leave `Module Execution Reports` open for post-unify finalization.
</step>

<step name="update_lifecycle_artifacts">
1. Update STATE.md with compact routing facts:
   - current phase/plan status
   - loop position
   - last activity
   - next action
   - resume file
2. Update ROADMAP.md only when phase/plan status or routing changes.
3. STATE/ROADMAP updates stay compact and routing-focused; avoid duplicate narrative across hot lifecycle artifacts.
</step>

<step name="post_unify_hooks" priority="after-state-update">
Dispatch post-unify hooks via `kernel/references/module-dispatch.md`; post-unify dispatch is mandatory before loop closure.

Call-site contract:
- Hook: `post-unify`.
- Context/output: summary path plus reconciliation/module inputs; collect compact module reports and side effects.
- Blocking: only if a module explicitly returns `action: block`.
- Required evidence: `[dispatch] post-unify: ...`; if no modules are registered, emit `[dispatch] post-unify: 0 modules registered for this hook`; if registry resolution fails, emit `[dispatch] post-unify: modules.yaml NOT FOUND — WARNING`.
</step>

<step name="finalize_summary" priority="after-post-unify">
1. Finalize SUMMARY.md before phase-completion or transition routing.
2. Write compact module reports and side effects under `## Module Execution Reports`.
3. If post-unify dispatch evidence is missing, add a warning: `missing dispatch evidence warning must be recorded in SUMMARY`.
4. Save SUMMARY.md before `check_phase_completion`.
</step>

<step name="github_flow_merge_gate" priority="after-summary-finalized">
1. Resolve `GIT_WORKFLOW` using `kernel/references/git-strategy.md`.
2. If not `github-flow`, display `Merge gate: skipped (not github-flow)` and continue to `check_phase_completion`.
3. Resolve github-flow fields once: base_branch, remote, auto_pr, ci_checks, require_reviews, merge_method, delete_branch_on_merge, require_pr_before_next_phase, and current branch.
4. If `require_pr_before_next_phase != true`, display `Merge gate: skipped (not required)` and continue to `check_phase_completion`.

Use `kernel/references/git-strategy.md` for command recipes and keep this gate ordered:
Merge gate order: PR exists/create-if-allowed → CI passing → reviews approved → PR merged → base synced → branch cleaned.

5. Commit and push finalized UNIFY artifacts before checking PR state.
6. PR gate:
   - create or reuse PR when `auto_pr=true`
   - block if no PR exists and auto-create is unavailable
7. CI gate:
   - if `ci_checks=true`, block on failing or missing required checks
   - CI failure is blocking in github-flow mode
8. Review gate:
   - if `require_reviews=true`, block until approved
   - if REV PR review is enabled in `pals.json`, run `/paul:review` via the on-demand `subagent_type: "code-reviewer"` path and block on critical findings when configured
9. Merge/sync gate:
   - merge the PR with configured method
   - sync local base branch
   - clean the feature branch when configured
10. Update STATE Git State with compact branch/base/PR/commit evidence.
11. Display one compact merge-gate summary and continue to `check_phase_completion`.
</step>

<step name="check_phase_completion">
1. Count PLAN.md and SUMMARY.md files in the current phase directory.
2. If counts match, this was the last plan; continue to `execute_transition`.
3. If more plans remain, report loop complete and route to `/paul:plan` for the next plan.
</step>

<step name="execute_transition" priority="required" gate="blocking">
If this is the last plan in the phase, transition routing is mandatory after the last plan.

1. Read `workflows/transition-phase.md`.
2. Execute transition requirements there; do not duplicate them here.
3. Only after transition completes, route to the next phase or milestone completion.
</step>
</process>

<output>
- SUMMARY.md at `.paul/phases/{phase}/{plan}-SUMMARY.md`
- Compact STATE.md routing update
- ROADMAP.md status update only when routing/status changes
- Transition executed when this is the last plan
</output>

<error_handling>
**APPLY not complete:** return to APPLY or document blockers before UNIFY.

**Missing execution context:** collect targeted APPLY annotations, verification output, or changed-file evidence; document uncertainty in SUMMARY if still unresolved.

**PLAN.md missing:** ask user to locate or reconstruct the approved plan before reconciliation.
</error_handling>

<anti_patterns>
- Skipping SUMMARY.
- Updating STATE/ROADMAP with duplicate SUMMARY narrative.
- Skipping transition routing after the last plan.
- Closing UNIFY with vague, unverifiable evidence.
</anti_patterns>
