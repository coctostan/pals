<worktree_isolation>

## Purpose

Git worktree isolation creates a separate working directory for APPLY phase execution. If execution fails or produces bad output, the worktree is discarded — zero cleanup needed on the main branch.

## When to Use

- Multi-phase projects where failed execution shouldn't pollute main
- Risky or experimental changes where rollback cost is high
- Team environments where main must stay clean
- Any project where "undo a bad APPLY" is painful

## How It Works in PALS

```
1. PLAN approved → setup_worktree creates isolated copy
2. APPLY executes tasks in worktree directory
3. UNIFY succeeds → transition merges worktree branch back
4. UNIFY fails → user can discard worktree (zero cleanup)
```

### Worktree Lifecycle

**Creation (apply-phase.md → setup_worktree):**
```bash
git worktree add .worktree-{phase-name} -b worktree/{phase-name}
```
- Directory: `.worktree-{phase-name}` at project root
- Branch: `worktree/{phase-name}` (distinct from `feature/` branches)
- All task execution happens inside the worktree directory

**Merge-back (transition-phase.md → commit_phase):**
```bash
git checkout main  # or source branch
git merge worktree/{phase-name} --no-ff -m "Merge worktree/{phase-name}"
git worktree remove .worktree-{phase-name}
git branch -d worktree/{phase-name}
```

**Discard on failure:**
```bash
git worktree remove --force .worktree-{phase-name}
git branch -D worktree/{phase-name}
```

## Configuration

In `pals.json`:
```json
"git": {
  "worktree_isolation": false
}
```

- `false` (default): APPLY runs directly on current branch (existing behavior)
- `true`: APPLY creates worktree, merges back on success
- When absent or false, all worktree logic is skipped (no-op)

## Interaction with Other Git Features

| Feature | Worktree Behavior |
|---------|-------------------|
| `branching: "feature-per-phase"` | Worktree branch created FROM feature branch |
| `branching: "direct-to-main"` | Worktree branch created FROM main |
| `auto_push` | Push happens after worktree merge-back |
| `auto_pr` | PR created after worktree merge-back |
| Fix loop (`/paul:fix`) | Does NOT use worktrees (lightweight by design) |

## Important Notes

- Add `.worktree-*` to `.gitignore` — worktree directories should not be tracked
- One worktree per phase (no parallel worktrees)
- Worktree path recorded in STATE.md for session continuity
- If session breaks during worktree APPLY, resume detects and continues in worktree

</worktree_isolation>
