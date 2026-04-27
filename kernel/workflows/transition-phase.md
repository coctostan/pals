<purpose>
Handle phase-level transition after all plans in a phase are complete. Evolves PROJECT.md, verifies phase completion, cleans up, and routes to next phase or milestone completion.

**Invoked by:** unify-phase.md when it detects "last plan in phase"
**Scope:** Phase N → Phase N+1 (or milestone completion)
</purpose>

<when_to_use>
- All plans in current phase have SUMMARY.md files
- Phase is ready to close
- Moving to next phase or completing milestone
</when_to_use>

<required_reading>
.paul/STATE.md
.paul/PROJECT.md
.paul/ROADMAP.md
.paul/phases/{current-phase}/*-SUMMARY.md
</required_reading>

<process>

<step name="verify_phase_completion" priority="first">
1. Count PLAN.md files in current phase directory
2. Count SUMMARY.md files in current phase directory
3. **Verification:**
   - If counts match: Phase complete
   - If counts don't match: Phase incomplete

**If incomplete:**
```
════════════════════════════════════════
PHASE INCOMPLETE
════════════════════════════════════════

Phase {N} has incomplete plans:
- {phase}-01-SUMMARY.md ✓
- {phase}-02-SUMMARY.md ✗ Missing
- {phase}-03-SUMMARY.md ✗ Missing

Options:
[1] Continue current phase (execute remaining plans)
[2] Mark complete anyway (skip remaining plans)
[3] Review what's left
════════════════════════════════════════
```

Wait for user decision before proceeding.

**If complete:** Continue to next step.
</step>

<step name="cleanup_handoffs">
1. Check for stale handoffs in phase directory:
   ```bash
   ls .paul/phases/{current-phase}/HANDOFF*.md 2>/dev/null
   ```
2. If found, delete them — phase is complete, handoffs are stale
3. Note: Active handoffs at `.paul/` root are preserved
</step>

<step name="evolve_project">
**Read phase summaries:**
```bash
cat .paul/phases/{current-phase}/*-SUMMARY.md
```

**Assess and update PROJECT.md:**

1. **Requirements validated?**
   - Any requirements shipped in this phase?
   - Move to Validated section: `- ✓ [Requirement] — Phase X`

2. **Requirements invalidated?**
   - Any requirements discovered unnecessary or wrong?
   - Move to Out of Scope: `- [Requirement] — [reason]`

3. **Requirements emerged?**
   - New requirements discovered during building?
   - Add to Active: `- [ ] [New requirement]`

4. **Key Decisions to log?**
   - Extract decisions from SUMMARY.md files
   - Add to Key Decisions table

5. **Core value still accurate?**
   - If product meaningfully changed, update description
   - Keep it current

**Update footer:**
```markdown
---
*Last updated: [date] after Phase [X]*
```
</step>

<step name="review_accumulated_context">
Update STATE.md Accumulated Context section:

**Decisions:**
- Note 3-5 recent decisions from this phase
- Full log lives in PROJECT.md

**Blockers/Concerns:**
- Resolved blockers: Remove from list
- Unresolved: Keep with "Phase X" prefix
- New concerns from summaries: Add

**Deferred Issues:**
- Update count if issues were logged
- Note if many accumulated
</step>

<step name="update_state_for_transition">
Update STATE.md Current Position:

```markdown
## Current Position

Phase: [N+1] of [total] ([Next phase name])
Plan: Not started
Status: Ready to plan
Last activity: [today] — Phase [N] complete, transitioned to Phase [N+1]

Progress: [updated bar based on completed plans]
```

Update Session Continuity:
```markdown
## Session Continuity

Last session: [today]
Stopped at: Phase [N] complete, ready to plan Phase [N+1]
Next action: /paul:plan for Phase [N+1]
Resume file: .paul/ROADMAP.md
```
</step>

<step name="update_roadmap_completion">
Update ROADMAP.md:

1. Mark current phase complete:
   - Status: ✅ Complete
   - Completed: [date]
   - Plan count: X/X

2. Update progress summary:
   - Phases: Y of Z complete
   - Calculate percentage
</step>

<step name="read_git_config" priority="before-commit">
**Resolve transition git behavior via `references/git-strategy.md`.**

1. Use the shared 3-tier workflow resolution from `references/git-strategy.md`.
2. Read only the git fields needed here: `branching`, `remote`, `auto_push`, `auto_pr`, `ci_checks`, `base_branch`, `merge_method`, `delete_branch_on_merge`, `update_branch_when_behind`, `require_pr_before_next_phase`, `require_reviews`, and `worktree_isolation`.
3. Resolve `CURRENT_BRANCH` and use it for all downstream operations — never assume a phase-derived branch name.
4. In `github-flow`, UNIFY owns the feature-to-base merge; transition only stages and commits phase metadata on the current branch, then follows the shared post-commit automation contract from `references/git-strategy.md`.
5. If `pals.json` is absent or the git section is missing, default to safe/off behavior.
</step>

<step name="commit_phase">
**Git commit for completed phase:**

**0. Check for worktree from this phase:**

```bash
WORKTREE_ISOLATION=$(jq -r '.git.worktree_isolation // false' pals.json 2>/dev/null)
git worktree list 2>/dev/null | grep "worktree/{phase}" || WORKTREE_FOUND=false
```

**If worktree found AND worktree_isolation=true:**

```
────────────────────────────────────────
Worktree detected: .worktree-{phase-name}
Branch: worktree/{phase-name}

Merging worktree back to source branch...
────────────────────────────────────────
```

Merge worktree branch:
```bash
# Determine source branch (main or feature branch)
SOURCE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
git merge worktree/{phase-name} --no-ff -m "Merge worktree/{phase-name} into ${SOURCE_BRANCH}"
```

If merge succeeds:
```bash
git worktree remove .worktree-{phase-name}
git branch -d worktree/{phase-name}
```
Display: `Worktree merged and cleaned up.`

If merge has conflicts:
```
⚠️ Conflicts merging worktree/{phase-name}.

Options:
[1] Resolve conflicts manually, then continue
[2] Keep worktree branch (do not merge)
[3] Discard worktree (lose worktree changes)
```

Clean STATE.md Session Continuity — remove `Worktree:` line.

**If no worktree found or worktree_isolation=false:** Continue to feature branch check.

**1. Check for feature branches from this phase:**
If `GIT_BRANCHING` = `direct-to-main`: skip feature branch check, commit directly to `${GIT_BASE_BRANCH}`.
If `GIT_BRANCHING` = `feature-per-phase` (default):
```bash
git branch --list "${CURRENT_BRANCH}"
```

**1a. GitHub Flow mode — skip local merge:**

**If GIT_WORKFLOW = "github-flow":**
- Do NOT merge feature branch to `${GIT_BASE_BRANCH}` locally.
- The feature-to-base merge is handled by the unify-phase merge gate via `gh pr merge`.
- Stay on the feature branch for staging and committing.
- Skip directly to step 3 (Stage phase files).

**If GIT_WORKFLOW = "legacy" or "none":** Continue with existing merge behavior below.

**2. If feature branch exists (legacy/none mode only):**
```
────────────────────────────────────────
git fetch origin ${GIT_BASE_BRANCH} 2>/dev/null || true
Checking for conflicts with ${GIT_BASE_BRANCH}...
────────────────────────────────────────
```
Check for conflicts:
```bash
git fetch origin ${GIT_BASE_BRANCH} 2>/dev/null || true
git diff ${GIT_BASE_BRANCH}...${CURRENT_BRANCH} --stat
```
**If no conflicts:**
```
No conflicts detected.
Merge ${CURRENT_BRANCH} to ${GIT_BASE_BRANCH}? [yes/no]
```
If yes:
```bash
git checkout ${GIT_BASE_BRANCH}
git merge ${CURRENT_BRANCH} --no-ff -m "Merge ${CURRENT_BRANCH} into ${GIT_BASE_BRANCH}"
git branch -d ${CURRENT_BRANCH}
```
**If conflicts exist:**
```
⚠️ Conflicts detected between ${CURRENT_BRANCH} and ${GIT_BASE_BRANCH}.
Cannot auto-merge. Options:
[1] Resolve conflicts manually, then re-run transition
[2] Keep on feature branch (do not merge)
[3] Force merge anyway (not recommended)
```

**3. Stage phase files:**
```bash
git add .paul/phases/{phase}/ .paul/STATE.md .paul/PROJECT.md .paul/ROADMAP.md
git add -u  # Stage all modifications to already-tracked files
# Stage new files in known project directories (if any were created):
git add drivers/ kernel/ modules/ tests/ docs/ src/ 2>/dev/null || true
```

**3a. Post-stage sanity check:**
Compare staged files against the plan's `files_modified` frontmatter:
```bash
git diff --cached --name-only
```
Parse the plan's `files_modified` list. If the plan lists non-`.paul/` files but **none** appear in the staged diff:

```
════════════════════════════════════════
⚠️ COMMIT SANITY CHECK FAILED
════════════════════════════════════════

Plan claims modifications to:
  {files_modified entries that are not .paul/ paths}

Actually staged (non-.paul/):
  {staged non-.paul/ files, or "none"}

This usually means implementation edits went to a file outside
the repo (e.g., ~/.pi/ instead of drivers/pi/) or were never made.

Options:
[1] Review and fix — verify edits target repo source files
[2] Commit anyway — this phase is documentation-only
[3] Abort commit
════════════════════════════════════════
```

- If "1": halt commit, return to investigation
- If "2": proceed, but record deviation in STATE.md: "Commit sanity override: plan claimed non-.paul/ changes but none staged"
- If "3": abort

**If all `files_modified` entries are `.paul/` paths, or non-`.paul/` files do appear in the staged diff:** proceed without prompting.
**4. Create phase commit:**
```bash
git commit -m "$(cat <<'EOF'
feat({phase}): {phase-description}

Phase {N} complete:
- {plan-01 summary}
- {plan-02 summary}
- {plan-03 summary}

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

**5. Record git state for complete-milestone:**
Update STATE.md Accumulated Context:
```markdown
### Git State
Last commit: {short-hash}
Branch: ${GIT_BASE_BRANCH}
Feature branches merged: {list or "none"}
```

Display:
```
Git commit created: {short-hash}
  feat({phase}): {phase-description}
```
</step>

<step name="post_commit_automation" priority="after-commit">
**Conditional automation based on pals.json git config.**
Use `references/git-strategy.md` for the exact push/CI/PR recipe.

1. All remote operations require `GIT_REMOTE` to be set. If remote is null/empty, skip them silently.
2. If `ci_checks=true`, push the relevant branch and surface CI status.
   - In `github-flow`, `CI failure is blocking` with no merge-anyway path.
   - In `legacy` or `none`, keep CI advisory and preserve the existing retry/keep-branch handling.
3. If `auto_pr=true` and remote set, create or reuse the PR for `CURRENT_BRANCH`.
4. If `auto_push=true` and remote set, push when ready.
5. In `github-flow`, do not locally merge the feature branch here; UNIFY's merge gate remains authoritative for merge, base sync, and cleanup.
</step>

<step name="verify_state_consistency" priority="critical">
**CRITICAL: Verify state files are aligned before declaring transition complete.**

State consistency is foundational to PAUL. If STATE.md, PROJECT.md, or ROADMAP.md are misaligned, all downstream work breaks — resume fails, progress tracking is wrong, context is lost.

**1. Re-read all three files completely:**
```bash
cat .paul/STATE.md
cat .paul/PROJECT.md
cat .paul/ROADMAP.md
```

**2. Verify alignment across these fields:**

| Field | STATE.md | PROJECT.md | ROADMAP.md |
|-------|----------|------------|------------|
| Version | `Version:` field | Current State table | Version Overview |
| Phase | `Phase:` field | (implicit in Active) | Phase Structure table |
| Status | `Status:` field | `Status:` in table | Phase status column |
| Focus | `Current focus:` header | (matches Active) | Current Milestone |

**3. Check for stale references:**
- No "blocked on X" if X is complete
- No "IN PROGRESS" for completed phases
- Current focus matches current phase, not previous
- Progress bars match actual plan counts

**4. If ANY misalignment found:**
```
════════════════════════════════════════
⚠️ STATE CONSISTENCY ERROR
════════════════════════════════════════

Misalignment detected:
| Field | STATE.md | PROJECT.md | ROADMAP.md |
|-------|----------|------------|------------|
| {field} | {value} | {value} | {value} |

Fix ALL misalignments before proceeding.
This is a blocking error — do not route to next phase.
════════════════════════════════════════
```

**Fix the issues, then re-verify.**

**5. If aligned:**
```
State consistency: ✓
  STATE.md    — Phase {N+1}, v{version}, ready to plan
  PROJECT.md  — v{version}, {active_count} active requirements
  ROADMAP.md  — Phase {N} ✅, Phase {N+1} 🔵
```

**Only proceed to route_next after verification passes.**
</step>

<step name="check_agents_md_staleness" priority="after-state-consistency">
**Advisory: Check if AGENTS.md is stale.**

This check is non-blocking — it never halts transitions.

1. Check if AGENTS.md exists in project root:
   ```bash
   ls AGENTS.md 2>/dev/null
   ```
   If not found: skip silently. Not all projects have AGENTS.md.

2. If found, compare enabled module list:
   - Extract module names from AGENTS.md (look for `**Active modules:**` line)
   - Extract enabled module names from pals.json
   - If lists differ (modules added, removed, or toggled):
     ```
     ────────────────────────────────────────
     ⚠️  AGENTS.md may be stale.
     Module list has changed since AGENTS.md was generated.
     Regenerate PALS Workflow section? [y/N]
     ────────────────────────────────────────
     ```
   - If user says yes: regenerate only the PALS Workflow section (preserve Boundaries and Project Conventions)
   - If user says no or presses Enter: skip, no state changes
   - If lists match: skip silently

3. **Never block.** This is advisory. Default is [N] (skip).
</step>

<step name="route_next">
**Check if milestone complete:**

1. Read ROADMAP.md
2. Find all phases in current milestone
3. If current phase is LAST in milestone → Route B (milestone complete)
4. If more phases remain → Route A (next phase)

---

**Route A: More phases remain**

```
════════════════════════════════════════
PHASE {N} COMPLETE
════════════════════════════════════════

✓ All {X} plans complete
✓ PROJECT.md evolved
✓ Ready for next phase

---
Next: Phase {N+1} — {Name}

[1] Yes, plan Phase {N+1} | [2] Pause here
════════════════════════════════════════
```

**Accept:** "1", "yes", "continue" → run `/paul:plan` for Phase N+1

---

**Route B: Milestone complete**

```
════════════════════════════════════════
MILESTONE COMPLETE
════════════════════════════════════════

🎉 {version} is 100% complete — all {N} phases finished!

✓ All phases unified
✓ PROJECT.md evolved
✓ Ready for next milestone or release

---
What's next?

[1] Start next milestone | [2] Review accomplishments | [3] Pause here
════════════════════════════════════════
```

</step>

</process>

<output>
- PROJECT.md evolved with validated/invalidated requirements
- STATE.md updated for new phase
- ROADMAP.md marked complete
- Stale handoffs cleaned
- Git commit created for phase: feat({phase}): {description}
- Feature branches merged if applicable
- User routed to next phase or milestone
</output>

<success_criteria>
- [ ] Phase PLAN/SUMMARY count verified
- [ ] Stale handoffs cleaned
- [ ] PROJECT.md evolved (requirements, decisions)
- [ ] STATE.md updated (position, context, session)
- [ ] ROADMAP.md marked complete
- [ ] Feature branches merged (if any)
- [ ] Git commit created for phase
- [ ] **STATE CONSISTENCY VERIFIED** (all three files aligned - BLOCKING)
- [ ] User knows next steps with quick continuation
</success_criteria>
