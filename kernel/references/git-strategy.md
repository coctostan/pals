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
| `github-flow` | Strict GitHub Flow — branch validation, auto-PR, merge gate blocks next phase until PR is merged. Requires `gh` CLI. | Active: preflight/postflight in apply-phase, 6-gate merge gate in unify-phase, git-aware routing in resume/pause |
| `legacy` | Advisory git ops — feature-per-phase branching, optional push/PR/CI. Current behavior for existing projects. | Passive: no blocking gates, all automation optional |
| `none` | No git operations. All git steps are no-ops. | None |

### Config Resolution (3-Tier)

Workflow mode is resolved using a 3-tier priority:

```
function resolveGitWorkflow(config):
  if config.git.workflow exists:     → use it (github-flow | legacy | none)
  if config.git.branching exists:    → "legacy" (backward compatible)
  else:                              → "none"
```

**Backward compatibility:** Existing projects with `branching: "feature-per-phase"` or `branching: "direct-to-main"` automatically resolve to `workflow: "legacy"` with zero behavior change. No migration required.

### Full Config Schema

| Field | Type | Default | Modes | Read by |
|-------|------|---------|-------|---------|
| `workflow` | `"github-flow"` \| `"legacy"` \| `"none"` | `"none"` | All | All workflows |
| `remote` | `string` \| `null` | `null` | All | transition-phase, complete-milestone |
| `base_branch` | `string` | `"main"` | github-flow | apply-phase (preflight), transition-phase, resume-project |
| `merge_method` | `"squash"` \| `"merge"` \| `"rebase"` | `"squash"` | github-flow | transition-phase |
| `auto_push` | `boolean` | `true` (github-flow), `false` (legacy) | github-flow, legacy | apply-phase (postflight), transition-phase |
| `auto_pr` | `boolean` | `true` (github-flow), `false` (legacy) | github-flow, legacy | apply-phase (postflight), unify-phase (merge gate) |
| `ci_checks` | `boolean` | `true` (github-flow), `false` (legacy) | github-flow, legacy | unify-phase (merge gate), transition-phase |
| `delete_branch_on_merge` | `boolean` | `true` | github-flow | transition-phase, unify-phase (merge gate) |
| `update_branch_when_behind` | `boolean` | `true` | github-flow | apply-phase (preflight) |
| `require_pr_before_next_phase` | `boolean` | `true` (github-flow), `false` (legacy) | github-flow | unify-phase (merge gate), resume-project |
| `require_reviews` | `boolean` | `false` | github-flow | unify-phase (merge gate) |

**Legacy fields:** `branching` is preserved for backward compatibility in legacy and none templates. GitHub Flow templates omit `branching` entirely — the `workflow` field is authoritative. `worktree_isolation` is orthogonal to workflow mode.

### Key Behavioral Patterns

**Preflight (apply-phase):** Before task execution in github-flow mode, validates: correct branch, not behind base, base is fresh from remote, clean working tree. Creates feature branch if needed.

**Postflight (apply-phase):** After task execution in github-flow mode, pushes feature branch (if `auto_push`), creates PR (if `auto_pr`), surfaces CI state.

**Merge Gate (unify-phase):** After SUMMARY.md creation in github-flow mode, enforces 6 sequential gates before routing to next PLAN: PR exists → CI passing → reviews approved → PR merged → base synced → branch cleaned. CI failure is blocking with no escape hatch.

**Lifecycle Awareness (init/resume/pause):** Init offers GitHub Flow as a first-class option with `gh` CLI and `gh auth status` validation (distinguishes CLI-missing from CLI-present-but-unauthenticated). Resume surfaces git/PR/CI state and routes next action based on git state priority (CI failing → fix CI, behind base → update branch, PR ready → merge). Pause captures git/PR continuity data in handoff using `git add -A` for complete staging.

**Status Parity (progress):** The `/paul:progress` command surfaces the same GitHub Flow git state as resume — branch, base, PR URL/state, CI state, and ahead/behind sync. Both status and resume use identical git-aware routing tables, ensuring they never disagree about the next step.
**Reading config in workflows:**
```bash
GIT_WORKFLOW=$(jq -r '.git.workflow // empty' pals.json 2>/dev/null)
# 3-tier fallback if workflow field absent:
if [ -z "$GIT_WORKFLOW" ]; then
  BRANCHING=$(jq -r '.git.branching // empty' pals.json 2>/dev/null)
  [ -n "$BRANCHING" ] && GIT_WORKFLOW="legacy" || GIT_WORKFLOW="none"
fi
```
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
