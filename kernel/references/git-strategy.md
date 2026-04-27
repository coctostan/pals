<overview>
Git integration for PAUL workflow.
</overview>

<configuration>
## Git Configuration (pals.json)
Set during `/paul:init` or manually.

### Workflow Modes

PALS supports three git workflow modes, configured via the `workflow` field:

| Mode | Behavior | Enforcement |
|------|----------|-------------|
| `github-flow` | Strict GitHub Flow — branch validation, auto-PR, merge gate blocks next phase until PR is merged. Requires `gh` CLI. | Active: preflight/postflight in apply-phase, merge gate in unify-phase, git-aware routing in status/resume/pause |
| `legacy` | Advisory git ops — feature-per-phase branching, optional push/PR/CI. Current behavior for existing projects. | Passive: no blocking gates, all automation optional |
| `none` | No git operations. All git steps are no-ops. | None |

### Workflow Resolution (3-Tier)

Call sites in `kernel/workflows/apply-phase.md`, `kernel/workflows/unify-phase.md`, `kernel/workflows/transition-phase.md`, `kernel/workflows/roadmap-management.md`, and `kernel/workflows/pause-work.md` must resolve workflow mode the same way:

```bash
GIT_WORKFLOW=$(jq -r '.git.workflow // empty' pals.json 2>/dev/null)
if [ -z "$GIT_WORKFLOW" ]; then
  GIT_BRANCHING=$(jq -r '.git.branching // empty' pals.json 2>/dev/null)
  [ -n "$GIT_BRANCHING" ] && GIT_WORKFLOW="legacy" || GIT_WORKFLOW="none"
fi
```

**Backward compatibility:** Existing projects with `branching: "feature-per-phase"` or `branching: "direct-to-main"` automatically resolve to `workflow: "legacy"` with zero behavior change. No migration required.

### Full Config Schema

| Field | Type | Default | Modes | Read by |
|-------|------|---------|-------|---------|
| `workflow` | `"github-flow" \| "legacy" \| "none"` | `"none"` | All | All workflows |
| `remote` | `string` \| `null` | `null` | All | transition-phase, complete-milestone |
| `base_branch` | `string` | `"main"` | github-flow | apply-phase, unify-phase, transition-phase, roadmap-management, pause-work |
| `merge_method` | `"squash" \| "merge" \| "rebase"` | `"squash"` | github-flow | unify-phase, transition-phase |
| `auto_push` | `boolean` | `true` (github-flow), `false` (legacy) | github-flow, legacy | apply-phase, transition-phase, complete-milestone |
| `auto_pr` | `boolean` | `true` (github-flow), `false` (legacy) | github-flow, legacy | apply-phase, unify-phase, transition-phase |
| `ci_checks` | `boolean` | `true` (github-flow), `false` (legacy) | github-flow, legacy | apply-phase, unify-phase, transition-phase, roadmap-management, pause-work |
| `delete_branch_on_merge` | `boolean` | `true` | github-flow | unify-phase, transition-phase |
| `update_branch_when_behind` | `boolean` | `true` | github-flow | apply-phase, transition-phase |
| `require_pr_before_next_phase` | `boolean` | `true` (github-flow), `false` (legacy) | github-flow | unify-phase |
| `require_reviews` | `boolean` | `false` | github-flow | unify-phase, roadmap-management |

**Legacy fields:** `branching` is preserved for backward compatibility in legacy and none templates. GitHub Flow templates omit `branching` entirely — the `workflow` field is authoritative. `worktree_isolation` is orthogonal to workflow mode.

### Shared GitHub Flow Recipes

When a workflow says to follow `references/git-strategy.md`, it should keep only call-site gates, skip conditions, and displayed evidence inline.

#### APPLY preflight responsibilities

- Resolve `GIT_WORKFLOW`; skip the step when the mode is not `github-flow`.
- Read `base_branch`, `update_branch_when_behind`, `remote`, and the current phase context.
- Ensure work starts on a non-base feature branch; create `feature/{phase-name}` from the base branch when currently on the base branch.
- Resolve `CURRENT_BRANCH` after any branch creation and use it for every downstream command.
- Refresh the local base branch from remote when a remote is configured.
- If the working branch is behind base, rebase when `update_branch_when_behind=true`; otherwise warn and continue.
- Check working-tree cleanliness and require stash/continue/stop handling when unrelated changes are present.
- Emit the visible `GitHub Flow Preflight ✓` summary with branch, base, behind, and tree status.

#### APPLY postflight responsibilities

- Resolve `GIT_WORKFLOW`; skip the step when the mode is not `github-flow`.
- Read `auto_push`, `auto_pr`, `ci_checks`, `remote`, `base_branch`, and resolve `CURRENT_BRANCH`.
- Stage and commit implementation work on the current feature branch before any remote operations.
- If a remote exists and `auto_push=true`, push `CURRENT_BRANCH`.
- If a remote exists and `auto_pr=true`, create or reuse the PR targeting `base_branch`, then record the PR URL/state.
- If `ci_checks=true`, surface PR check state for visibility only; blocking enforcement happens in UNIFY.
- Emit the visible `GitHub Flow Postflight ✓` summary with branch, push, PR, and CI status.

#### UNIFY merge-gate responsibilities

- Resolve `GIT_WORKFLOW`; skip the gate when the mode is not `github-flow`.
- Read `require_pr_before_next_phase`, `ci_checks`, `require_reviews`, `merge_method`, `delete_branch_on_merge`, `base_branch`, `remote`, `auto_pr`, and resolve `CURRENT_BRANCH`.
- If PR enforcement is off, display `Merge gate: skipped (not required)` and continue.
- Commit and push the latest UNIFY artifacts on the feature branch before checking PR state.
- Gate order is fixed: PR exists/create-if-allowed → CI passing → reviews approved (if required) → PR merged → base synced → branch cleaned.
- `CI failure is blocking` in github-flow mode; there is no merge-anyway path.
- Update `STATE.md` Git State after merge and show the final merge-gate summary.
- Workflow-local extras, such as REV code review, stay inline in the workflow between review approval and merge.

#### Status / resume / roadmap routing responsibilities

- Resolve `GIT_WORKFLOW`; only github-flow collects git state.
- Gather `CURRENT_BRANCH`, `GIT_BASE_BRANCH`, ahead/behind counts, PR URL/state, and CI state.
- Use the same routing priority everywhere: behind base → PR open + CI failing → PR open + CI passing + reviews pending → PR open + CI passing + ready to merge → normal loop routing.
- Status displays and resume guidance must surface exactly one next action from that priority order.

#### Pause / WIP continuity responsibilities

- Resolve `GIT_WORKFLOW`; if github-flow, capture branch/base/PR/CI/behind state in the handoff.
- Offer WIP commit only when workflow mode is not `none`.
- Use `git add -A` for the WIP commit path.
- In github-flow, commit only on the current feature branch.
- In legacy mode, offer the config-driven default between main and feature-branch WIP strategies and record the chosen strategy in STATE when it affects later reconciliation.

#### Phase transition / milestone tagging responsibilities

- Resolve the shared git fields once and reuse `CURRENT_BRANCH`; never assume a phase-derived branch name.
- In github-flow, UNIFY owns the feature-to-base merge; transition-phase stages and commits phase metadata on the current branch and must not locally merge the feature branch back to base.
- Post-transition remote automation follows the same push/CI/PR rules above, including the blocking github-flow CI rule.
- Milestone/tag flows reuse the same base branch, remote, and auto-push expectations when creating annotated release tags.
</configuration>

<core_principle>

**Commit outcomes, not process.**

The git log should read like a changelog of what shipped, not a diary of planning activity.

</core_principle>

<commit_points>

| Event                   | Commit? | Why                                              |
| ----------------------- | ------- | ------------------------------------------------ |
| PROJECT + ROADMAP init  | YES     | Project initialization                           |
| PLAN.md created         | NO      | Intermediate - commit with plan completion       |
| Research notes          | NO      | Intermediate                                     |
| **Task completed**      | YES     | Atomic unit of work (1 commit per task)          |
| **Plan completed**      | YES     | Metadata commit (SUMMARY + STATE + ROADMAP)      |
| HANDOFF created         | YES     | WIP state preserved                              |

</commit_points>

<commit_formats>

## Project Initialization

```
docs: initialize [project-name] ([N] phases)

[One-liner from PROJECT.md]

Phases:
1. [phase-name]: [goal]
2. [phase-name]: [goal]
3. [phase-name]: [goal]
```

What to commit:
```bash
git add .paul/
git commit
```

## Task Completion (During APPLY)

Each task gets its own commit immediately after completion.

```
{type}({phase}-{plan}): {task-name}

- [Key change 1]
- [Key change 2]
- [Key change 3]
```

**Commit types:**
- `feat` - New feature/functionality
- `fix` - Bug fix
- `test` - Test-only (TDD RED phase)
- `refactor` - Code cleanup (TDD REFACTOR phase)
- `perf` - Performance improvement
- `chore` - Dependencies, config, tooling
- `docs` - Documentation changes

**Examples:**

```bash
# Standard task
git add src/api/auth.ts src/types/user.ts
git commit -m "feat(08-02): create user registration endpoint

- POST /auth/register validates email and password
- Checks for duplicate users
- Returns JWT token on success
"

# TDD task - RED phase
git add src/__tests__/jwt.test.ts
git commit -m "test(07-02): add failing test for JWT generation

- Tests token contains user ID claim
- Tests token expires in 1 hour
- Tests signature verification
"
```

## Plan Completion (After UNIFY)

After all tasks committed, one final metadata commit captures plan completion.

```
docs({phase}-{plan}): complete [plan-name]

AC Results:
- AC-1: [PASS/FAIL]
- AC-2: [PASS/FAIL]

SUMMARY: .paul/phases/XX-name/{phase}-{plan}-SUMMARY.md
```

What to commit:
```bash
git add .paul/phases/XX-name/
git add .paul/STATE.md
git add .paul/ROADMAP.md
git commit
```

**Note:** Code files NOT included - already committed per-task.

## Handoff (WIP)

```
wip({phase}): paused at plan [NN] task [X]/[Y]

Current: [task name]
[If blocked:] Blocked: [reason]
```

What to commit:
```bash
git add .paul/
git commit
```

</commit_formats>

<example_log>

**Per-task commits (PAUL approach):**

```
# Phase 08.5 - Quality Patterns
d4e5f6 docs(08.5-01): complete quality references
a1b2c3 feat(08.5-01): create git-strategy.md
7g8h9i feat(08.5-01): create tdd.md
4d5e6f feat(08.5-01): create quality-principles.md

# Phase 08 - Documentation
3m4n5o docs(08-02): complete workflow docs
6p7q8r feat(08-02): create unify-phase.md
9s0t1u feat(08-02): create apply-phase.md
2v3w4x docs(08-01): complete command docs
5y6z7a feat(08-01): create resume.md command
8b9c0d feat(08-01): create pause.md command

# Phase 07 - Session Continuity
1e2f3g docs(07-01): complete handoff workflow
4h5i6j feat(07-01): create pause-work.md
7k8l9m feat(07-01): add session continuity to STATE.md

# Initialization
0n1o2p docs: initialize paul-framework (8 phases)
```

Each plan produces 2-4 commits (tasks + metadata). Clear, granular, bisectable.

</example_log>

<anti_patterns>

**Still don't commit (intermediate artifacts):**
- PLAN.md creation (commit with plan completion)
- Research notes
- Minor planning tweaks
- "Fixed typo in roadmap"

**Do commit (outcomes):**
- Each task completion (feat/fix/test/refactor)
- Plan completion metadata (docs)
- Project initialization (docs)
- Handoffs (wip)

**Key principle:** Commit working code and shipped outcomes, not planning process.

</anti_patterns>

<commit_strategy_rationale>

## Why Per-Task Commits?

**Context engineering for AI:**
- Git history becomes primary context source for future Claude sessions
- `git log --grep="{phase}-{plan}"` shows all work for a plan
- `git diff <hash>^..<hash>` shows exact changes per task
- Less reliance on parsing SUMMARY.md = more context for actual work

**Failure recovery:**
- Task 1 committed ✅, Task 2 failed ❌
- Claude in next session: sees task 1 complete, can retry task 2
- Can `git reset --hard` to last successful task

**Debugging:**
- `git bisect` finds exact failing task, not just failing plan
- `git blame` traces line to specific task context
- Each commit is independently revertable

**Observability:**
- Solo developer + Claude workflow benefits from granular attribution
- Atomic commits are git best practice
- "Commit noise" irrelevant when consumer is Claude, not humans

</commit_strategy_rationale>
