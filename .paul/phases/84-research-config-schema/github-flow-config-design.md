# GitHub Flow Config Schema Design

## 1. New pals.json Git Section Schema

```json
"git": {
  "workflow": "github-flow",
  "remote": "https://github.com/org/repo.git",
  "base_branch": "main",
  "merge_method": "squash",
  "auto_push": true,
  "auto_pr": true,
  "ci_checks": true,
  "delete_branch_on_merge": true,
  "update_branch_when_behind": true,
  "require_pr_before_next_phase": true,
  "require_reviews": false
}
```

## 2. Field Definitions

### workflow
- **Type:** `"github-flow" | "legacy" | "none"`
- **Default:** `"none"` (no git ops if absent)
- **Behavior:**
  - `"github-flow"` — strict GitHub Flow enforcement. All enforcement fields below are active. Loop progression is gated by merge state.
  - `"legacy"` — maps to current `branching: "feature-per-phase"` behavior. All git ops are advisory, not blocking. This is what existing projects get on migration.
  - `"none"` — no git operations. All git steps are no-ops.
- **Read by:** init-project, apply-phase, unify-phase, transition-phase, resume-project, pause-work, fix-loop, complete-milestone, status

### remote
- **Type:** `string | null`
- **Default:** `null`
- **Behavior:** If null, all remote operations (push, PR, CI checks) are silently skipped. Unchanged from current behavior.
- **Read by:** transition-phase, complete-milestone

### base_branch
- **Type:** `string`
- **Default:** `"main"`
- **Behavior:** The branch all feature branches are created from and merged back into. Replaces hardcoded `main` references in transition-phase.
- **Read by:** apply-phase (preflight), transition-phase (merge target), resume-project (ahead/behind check)

### merge_method
- **Type:** `"squash" | "merge" | "rebase"`
- **Default:** `"squash"`
- **Behavior:** Passed to `gh pr merge --squash|--merge|--rebase`. Only used in github-flow mode.
- **Read by:** transition-phase (merge step)

### auto_push
- **Type:** `boolean`
- **Default:** `true` in github-flow, `false` in legacy
- **Behavior:** Auto-push feature branch after APPLY. Auto-push base_branch and tags after merge. Unchanged semantics but default flips in github-flow mode.
- **Read by:** transition-phase, complete-milestone

### auto_pr
- **Type:** `boolean`
- **Default:** `true` in github-flow, `false` in legacy
- **Behavior:**
  - **github-flow:** PR is created BEFORE merge (after push). UNIFY checks PR state. Merge happens via `gh pr merge`.
  - **legacy:** PR is created AFTER local merge (current behavior).
- **Read by:** apply-phase (post-apply), transition-phase, unify-phase (merge gate)

### ci_checks
- **Type:** `boolean`
- **Default:** `true` in github-flow, `false` in legacy
- **Behavior:**
  - **github-flow:** CI must pass before merge is allowed. No "merge anyway" escape hatch. If CI fails, the next action is "fix CI", not "proceed".
  - **legacy:** CI is advisory. "Merge anyway" offered on failure (current behavior).
- **Read by:** transition-phase (pre-merge), unify-phase (merge gate)

### delete_branch_on_merge
- **Type:** `boolean`
- **Default:** `true`
- **Behavior:** After PR merge, delete both local and remote feature branch. Uses `gh pr merge --delete-branch` when merging via PR. Falls back to `git push origin --delete` + `git branch -d` for local merge.
- **Read by:** transition-phase (post-merge cleanup)

### update_branch_when_behind
- **Type:** `boolean`
- **Default:** `true`
- **Behavior:** Before starting work (apply-phase preflight), check if feature branch is behind base_branch. If behind and this is true, auto-rebase/merge from base. If behind and this is false, warn but don't block.
- **Read by:** apply-phase (preflight)

### require_pr_before_next_phase
- **Type:** `boolean`
- **Default:** `true` in github-flow, `false` in legacy
- **Behavior:** **THE MERGE GATE.** When true, unify-phase will not route to the next PLAN until the current phase's PR is merged into base_branch. This is the central enforcement mechanism.
- **Read by:** unify-phase (transition routing), resume-project (next action logic), status (next action suggestion)

### require_reviews
- **Type:** `boolean`
- **Default:** `false`
- **Behavior:** When true, PR must have at least one approving review before merge is allowed. Checked via `gh pr view --json reviewDecision`.
- **Read by:** transition-phase (pre-merge), unify-phase (merge gate)

## 3. Backward Compatibility

### Migration from existing config

**Current format:**
```json
"git": {
  "remote": "...",
  "branching": "feature-per-phase",
  "worktree_isolation": false,
  "auto_push": false,
  "auto_pr": false,
  "ci_checks": false
}
```

**Migration rules:**
1. If `workflow` field is absent but `branching` exists → treat as `workflow: "legacy"`
2. If `branching: "feature-per-phase"` → `workflow: "legacy"` (existing behavior preserved)
3. If `branching: "direct-to-main"` → `workflow: "legacy"` (direct-to-main is a legacy sub-mode)
4. If neither `workflow` nor `branching` exists → `workflow: "none"`
5. `worktree_isolation` is preserved in all modes (orthogonal to workflow mode)
6. New fields (`base_branch`, `merge_method`, `delete_branch_on_merge`, `update_branch_when_behind`, `require_pr_before_next_phase`, `require_reviews`) default to their type defaults when absent

**No destructive migration.** Existing pals.json files work without changes. The `branching` field is read as a fallback when `workflow` is absent.

### Config resolution pseudocode

```
function resolveGitWorkflow(config):
  if config.git.workflow exists:
    return config.git.workflow
  if config.git.branching exists:
    return "legacy"
  return "none"
```

## 4. Behavioral Contract Per Workflow

### apply-phase.md — NEW: GitHub Flow Preflight

**Trigger:** `workflow: "github-flow"` is active
**When:** After `validate_approval`, before `setup_worktree`
**New step:** `github_flow_preflight`

| Check | Action if failed | Blocking? |
|-------|-----------------|----------|
| Not on base_branch | Create feature branch `feature/{phase-name}` from base_branch | Yes — cannot work on base_branch |
| Feature branch behind base_branch | If `update_branch_when_behind`: rebase/merge from base. Else: warn. | Configurable |
| base_branch not up-to-date with remote | `git fetch origin && git rebase origin/{base_branch}` | Yes — stale base |
| Working tree dirty with unrelated changes | Surface clearly, ask to stash or commit | Yes — clean state required |

**Post-APPLY (after tasks):**
- If `auto_push`: push feature branch
- If `auto_pr`: create PR via `gh pr create --base {base_branch} --head feature/{phase-name}`
- Record PR URL in STATE.md Git State section
- If `ci_checks`: surface check state via `gh pr checks`

**Legacy mode:** No preflight. Current behavior preserved.
**None mode:** No git ops.

### unify-phase.md — NEW: Merge Gate

**Trigger:** `workflow: "github-flow"` AND `require_pr_before_next_phase: true`
**When:** After SUMMARY.md creation, before routing to next PLAN
**New step:** `github_flow_merge_gate`

| Check | Action | Blocking? |
|-------|--------|----------|
| PR exists for current branch | If not: create PR (if auto_pr) or prompt user | Yes |
| CI checks passing | If `ci_checks`: check via `gh pr checks`. If failing → next action = "fix CI" | Yes |
| Reviews approved | If `require_reviews`: check via `gh pr view --json reviewDecision` | Configurable |
| PR merged | Check via `gh pr view --json state`. If not merged → next action = "merge PR" | Yes |
| Local base_branch synced | After merge: `git checkout {base_branch} && git pull origin {base_branch}` | Yes |
| Feature branch deleted | If `delete_branch_on_merge`: delete local + remote branch | Non-blocking |

**Next action routing (strict order):**
1. If PR doesn't exist → "Create PR"
2. If CI failing → "Fix CI failures"
3. If reviews pending → "Get PR reviewed"
4. If PR not merged → "Merge PR"
5. If base_branch not synced → "Pull latest base_branch"
6. All clear → "Ready for /paul:plan Phase {N+1}"

**Legacy mode:** No merge gate. Routes directly to next PLAN (current behavior).
**None mode:** No git ops. Routes directly to next PLAN.

### transition-phase.md — MODIFIED: PR-first ordering

**github-flow changes:**
- `commit_phase`: commits to feature branch (not base_branch)
- `post_commit_automation`: PR creation moves BEFORE merge (inverted from current)
- Merge happens via `gh pr merge --{merge_method} --delete-branch` instead of local `git merge`
- CI check failure is blocking (no "merge anyway" option)
- Branch cleanup uses `delete_branch_on_merge` config

**Legacy mode:** Current behavior preserved (local merge, PR after, CI advisory).

### init-project.md — MODIFIED: GitHub Flow defaults

**github-flow changes:**
- New Question 2 option: "GitHub Flow (recommended for GitHub repos)" in addition to existing options
- If GitHub repo detected and user selects GitHub Flow:
  - `workflow: "github-flow"`
  - `base_branch: "main"` (detect from remote HEAD)
  - `merge_method: "squash"`
  - `auto_push: true`
  - `auto_pr: true`
  - `ci_checks: true`
  - `delete_branch_on_merge: true`
  - `update_branch_when_behind: true`
  - `require_pr_before_next_phase: true`
  - `require_reviews: false`
- Existing options map to `workflow: "legacy"` with current defaults

**Legacy mode:** Current init flow unchanged.

### resume-project.md — NEW: Git State Surfacing

**github-flow changes (new step: `check_git_state`):**
- Surface in resume display:
  - Current branch name
  - base_branch name
  - PR URL (from STATE.md)
  - PR state (open/merged/closed via `gh pr view`)
  - CI state (passing/failing/pending via `gh pr checks`)
  - Ahead/behind base_branch (`git rev-list --left-right --count`)
- Next action routing uses git state:
  - If PR open with failing CI → "Fix CI failures"
  - If PR open, CI passing, not merged → "Merge PR"
  - If no branch, work merged → normal loop routing

**Legacy mode:** No git state surfacing (current behavior).
**None mode:** No git ops.

### pause-work.md — MODIFIED: Git/PR continuity data

**github-flow changes:**
- Add to handoff template:
  - `Branch: {current_branch}`
  - `Base: {base_branch}`
  - `PR: {url} (state: {open|merged|closed})`
  - `CI: {passing|failing|pending}`
  - `Behind base: {N commits}` or `Up to date`
- Replace `branching` config reads with `workflow` config reads

**Legacy mode:** Current branch strategy recording preserved.

### fix-loop.md — MINIMAL changes

**github-flow changes:**
- Standard fix: commit to current feature branch (not base_branch)
- Fast-forward: if on base_branch in github-flow mode, warn and suggest feature branch
- Hotfix: allow direct-to-base_branch commits (hotfix is an escape hatch by design)

**Legacy mode:** Current behavior preserved.

### complete-milestone.md — MINIMAL changes

**github-flow changes:**
- Verify all phase PRs are merged before milestone completion
- Tag created on base_branch (explicit, not implicit)

**Legacy mode:** Current behavior preserved.

## 5. Key Design Decisions

### D1: Merge gate lives in unify-phase, not transition-phase

**Decision:** The merge gate (require_pr_before_next_phase) is checked in `unify-phase.md` before routing to the next PLAN.

**Rationale:** Transition-phase handles the mechanical git ops (commit, push, PR create). Unify-phase owns the lifecycle routing decision ("what's next?"). The merge gate is a lifecycle decision: "is the previous work shipped?" That belongs in the routing layer, not the mechanical layer.

### D2: PR created after APPLY, checked in UNIFY

**Decision:** apply-phase creates the PR (post-apply). unify-phase checks merge state (merge gate).

**Rationale:** This matches real GitHub Flow timing:
1. Do work (APPLY)
2. Push + create PR (end of APPLY)
3. CI runs (async)
4. Review work / write SUMMARY (UNIFY)
5. Check merge readiness (UNIFY merge gate)
6. Merge (UNIFY or manual)
7. Start next phase

### D3: CI failure is blocking in github-flow mode

**Decision:** When `workflow: "github-flow"` and `ci_checks: true`, CI failure blocks merge. No "merge anyway" escape.

**Rationale:** Strict GitHub Flow means CI is a hard gate. The escape hatch is `ci_checks: false` or `workflow: "legacy"`.

### D4: Branch naming stays `feature/{phase-name}`

**Decision:** Keep existing `feature/{phase-name}` convention.

**Rationale:** It's already established, descriptive, and consistent with the per-phase lifecycle.

### D5: `gh` CLI is required for github-flow mode

**Decision:** GitHub Flow enforcement uses `gh` CLI for PR operations, CI checks, and merge.

**Rationale:** `gh` is the standard GitHub CLI. PALS already references `gh pr` in transition-phase. Init should validate `gh` is available when github-flow is selected.

### D6: Hotfix mode is exempt from merge gate

**Decision:** `/paul:fix --hotfix` can commit directly to any branch, including base_branch.

**Rationale:** Hotfix is an explicit escape hatch for urgent fixes. Requiring PR for hotfixes defeats the purpose. The retroactive UNIFY records it.

### D7: Legacy mode is a true superset of current behavior

**Decision:** `workflow: "legacy"` preserves 100% of current git behavior. No enforcement, all advisory.

**Rationale:** Existing projects must not break. Migration is opt-in via changing `workflow` to `"github-flow"`.