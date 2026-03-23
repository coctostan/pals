# Git Audit Report — Phase 84

Comprehensive inventory of git handling across all PALS workflows, with gap analysis against strict GitHub Flow.

---

## 1. init-project.md

### Git Operations
- **Detect git repo:** `git rev-parse --git-dir` (step: `configure_git`)
- **Detect remote:** `git remote get-url origin` (step: `configure_git`)
- **No git operations executed** — config is gathered and stored, nothing enforced

### Config Read/Written
- **Writes to pals.json `git` section:**
  - `remote` (null or URL)
  - `branching` ("feature-per-phase" or "direct-to-main")
  - `worktree_isolation` (true/false)
  - `auto_push` (true/false)
  - `auto_pr` (true/false)
  - `ci_checks` (true/false)
- **Defaults:** All automation off, branching = "feature-per-phase", worktree = false

### Enforcement Level
- **Pure config gathering** — no enforcement of any kind
- No `workflow` field exists
- No `base_branch` field
- No `merge_method` field
- No `delete_branch_on_merge` field
- No `require_pr_before_next_phase` field

### Gaps vs Strict GitHub Flow
1. No `workflow: "github-flow"` concept — only `branching` enum with two values
2. No `base_branch` — hardcoded assumption of `main` in transition-phase
3. No `merge_method` — squash/merge/rebase not configurable
4. No `delete_branch_on_merge` option
5. No `update_branch_when_behind` option
6. No `require_pr_before_next_phase` option
7. GitHub-hosted repo detection doesn't default to GitHub Flow settings

---

## 2. apply-phase.md

### Git Operations
- **Worktree creation:** `git worktree add` (step: `setup_worktree`, conditional on `git.worktree_isolation`)
- **Diff verification:** `git diff --name-only -- {paths}` (step: `execute_tasks`, ground-truth file check)
- **No branch operations** — no branch creation, no branch validation, no push, no PR

### Config Read
- `git.worktree_isolation` — only config field read

### Enforcement Level
- Worktree setup is **enforced** (blocks or offers fallback if it fails)
- File diff check is **enforced** (fails task if zero changes)
- **No branch enforcement** — does not check if on `main`, does not create feature branch, does not validate branch is based on latest `origin/main`

### Gaps vs Strict GitHub Flow
1. **No preflight check:** Does not verify work is not on `main`
2. **No branch creation:** Does not create short-lived feature branch from updated `main`
3. **No behind-main check:** Does not verify branch is up-to-date with `origin/main`
4. **No dirty tree check:** Does not surface unrelated working tree changes
5. **No post-APPLY push:** Does not push branch after successful APPLY
6. **No post-APPLY PR creation:** Does not create/update PR after successful APPLY
7. **No CI state surfacing:** Does not report check status
8. **No PR state recorded in STATE.md**

---

## 3. unify-phase.md

### Git Operations
- **Retroactive UNIFY:** `git log {last_commit}..HEAD --oneline` and `git diff {last_commit}..HEAD --stat` (step: `retroactive_unify`)
- **Drift detection:** `git diff --stat {last_commit}..HEAD` (step: `verify_plan_integrity`)
- **No merge operations** — does not check PR state, does not enforce merge before next phase

### Config Read
- None directly — reads STATE.md git state (branch, last commit)

### Enforcement Level
- Retroactive unify uses git log/diff as **read-only data source**
- **No merge gate** — can route to next PLAN without checking if current branch is merged

### Gaps vs Strict GitHub Flow
1. **Critical: No merge gate** — unify routes to next PLAN without verifying current work is merged into `main`
2. **No PR state check** — does not know if a PR exists, is open, or is merged
3. **No CI state check** — does not verify CI passed before routing forward
4. **No "resync main" requirement** — does not verify local `main` is updated before next phase
5. This is the **key lifecycle gap** identified in the requirements doc

---

## 4. transition-phase.md

### Git Operations
- **Read config:** `jq` reads from pals.json (step: `read_git_config`)
- **Worktree merge:** `git merge worktree/{phase}` (step: `commit_phase`, conditional)
- **Feature branch check:** `git branch --list "feature/{phase}*"` (step: `commit_phase`)
- **Feature branch merge:** `git checkout main && git merge feature/{phase} --no-ff` (step: `commit_phase`)
- **Branch delete:** `git branch -d feature/{phase}` (step: `commit_phase`)
- **Staging:** `git add .paul/ src/` and `git add -u` (step: `commit_phase`)
- **Commit:** `git commit -m "feat({phase}): ..."` (step: `commit_phase`)
- **Post-commit sanity check:** `git diff --cached --name-only` vs plan's `files_modified`
- **Push branch for CI:** `git push origin feature/{phase}` (step: `post_commit_automation`, conditional)
- **CI check:** `gh pr checks feature/{phase} --watch` (step: `post_commit_automation`, conditional)
- **Create PR:** `gh pr create --base main --head feature/{phase}` (step: `post_commit_automation`, conditional)
- **Push main:** `git push origin main` (step: `post_commit_automation`, conditional)
- **Fetch for diff:** `git fetch origin main` (step: `commit_phase`)

### Config Read
- `git.remote` — guards all remote operations
- `git.branching` — determines feature branch vs direct-to-main
- `git.auto_push` — controls push after merge
- `git.auto_pr` — controls PR creation
- `git.ci_checks` — controls CI check before merge

### Enforcement Level
- Feature branch merge is **interactive** (asks user yes/no)
- CI check is **advisory** (offers "merge anyway" on failure)
- PR creation is **automatic** when configured, but not enforced
- Push is **automatic** when configured, but not enforced

### Gaps vs Strict GitHub Flow
1. **CI failure is not blocking** — offers "merge anyway" option
2. **PR is created AFTER merge** — should be created BEFORE merge, CI runs on PR
3. **No merge method control** — always uses `--no-ff`, no squash/rebase option
4. **No branch deletion after merge** — deletes feature branch locally, but no `delete_branch_on_merge` config
5. **No update-branch-when-behind check** — merges without verifying branch is current with `main`
6. **Ordering issue:** Creates PR after merge to main — in GitHub Flow, PR comes FIRST, then merge via PR

---

## 5. pause-work.md

### Git Operations
- **Status check:** `git status` (for summarizing recent modifications)
- **WIP commit:** `git add .paul/ src/` + `git commit -m "wip({phase}): paused at {plan}"` (step: `optional_commit`)
- **Feature branch creation:** `git checkout -b feature/{phase-name}` (step: `optional_commit`, conditional on branch choice)

### Config Read
- `git.branching` — determines default branch choice (main or feature)

### Enforcement Level
- WIP commit is **optional** (user chooses)
- Branch choice respects config default but allows override

### Gaps vs Strict GitHub Flow
1. **No PR state preservation** — does not record current PR URL/state in handoff
2. **No CI state preservation** — does not record whether CI passed/failed
3. **No behind-main detection** — does not note if branch is behind `main`
4. Branch creation at pause time is fine, but lacks the full git continuity data needed for informed resume

---

## 6. fix-loop.md

### Git Operations
- **Standard mode:** `git add {files}` + `git commit` implicitly via standard flow
- **Fast-forward mode:** `git add {changed files}` + `git commit -m "fix(ff): {description}"` (step: `ff_commit`)
- **Hotfix mode:** `git status --porcelain`, `git diff --stat`, `git add {files}`, `git commit -m "hotfix: {description}"` (steps: `hotfix_check_changes`, `hotfix_commit`)

### Config Read
- None — fix loop deliberately skips git config and hooks (fast-forward design)

### Enforcement Level
- Fix commits go to **current branch** — no branch awareness
- No push, no PR, no CI check

### Gaps vs Strict GitHub Flow
1. Fast-forward commits directly to whatever branch is checked out — could commit to `main` directly
2. No enforcement that fixes go through PR flow
3. Acceptable: fix loop is designed for lightweight side-work, not main loop — but GitHub Flow mode should at minimum prevent direct-to-main commits

---

## 7. resume-project.md

### Git Operations
- **None** — zero git handling

### Config Read
- None

### Enforcement Level
- **Completely git-unaware**

### Gaps vs Strict GitHub Flow
1. **Does not surface current branch**
2. **Does not surface PR URL/state**
3. **Does not surface CI state**
4. **Does not detect behind-main**
5. **Does not inform next-action routing based on git state** — if work is on an unmerged PR, resume suggests `/paul:plan` instead of "merge PR first"
6. This is a **significant gap** — resume is the re-entry point and should give full situational awareness

---

## 8. complete-milestone.md

### Git Operations
- **Version alignment commit:** `git add` + `git commit -m "chore: align version"` (step: `verify_version_alignment`)
- **Git tag:** `git tag -a "{version}" -m "..."` (step: `git_tag`)
- **Push tag + main:** `git push origin main` + `git push origin {version}` (step: `git_tag`, conditional on auto_push)

### Config Read
- `git.remote` — guards remote operations
- `git.auto_push` — controls push behavior

### Enforcement Level
- Tag creation is **automatic**
- Push is **conditional** on config

### Gaps vs Strict GitHub Flow
1. **No PR-based merge verification** — does not check that all phases were merged via PRs
2. Generally acceptable — milestone completion is metadata, not implementation work
3. Minor: could verify all feature branches are cleaned up before tagging

---

## GitHub Flow Requirements Coverage Summary

| # | Requirement | Current Coverage | Gap Severity |
|---|------------|-----------------|--------------|
| 1 | **Branch from main** | `transition-phase.md` creates feature branches, but `apply-phase.md` has no preflight to verify/create branch before work starts | **HIGH** — work can start on wrong branch |
| 2 | **Short-lived feature branch** | `branching: "feature-per-phase"` encourages per-phase branches, but nothing enforces short-livedness or prevents long-lived branches | **MEDIUM** — convention exists but not enforced |
| 3 | **PR to main** | `transition-phase.md` has `auto_pr` but creates PR AFTER merging locally — inverted from GitHub Flow where PR comes first | **HIGH** — PR ordering is wrong |
| 4 | **CI before merge** | `transition-phase.md` has `ci_checks` but CI failure is non-blocking ("merge anyway" offered) | **HIGH** — CI is advisory, not enforcing |
| 5 | **Merge before next phase** | **Not implemented** — `unify-phase.md` routes to next PLAN without checking merge state | **CRITICAL** — the central gap |
| 6 | **Auto-delete merged branch** | `transition-phase.md` deletes local branch after merge, but no config to delete remote branch | **LOW** — mostly working locally |
| 7 | **Next branch from updated main** | **Not implemented** — no preflight in `apply-phase.md` to ensure main is current before branching | **HIGH** — stale base possible |

### Summary

The **critical gap** is #5: PALS can complete UNIFY and route to the next PLAN without the current work being merged. This breaks the fundamental GitHub Flow contract.

The **high gaps** (#1, #3, #4, #7) all relate to missing enforcement points:
- apply-phase needs a preflight (branch validation + creation)
- transition-phase needs PR-first ordering (not post-merge PR)
- CI needs to be blocking in github-flow mode
- apply-phase needs to verify branch base is current

The existing git infrastructure in `transition-phase.md` is the strongest foundation — it reads config, handles branching, does CI/PR/push. But it operates post-merge rather than pre-merge, which is inverted from GitHub Flow.
