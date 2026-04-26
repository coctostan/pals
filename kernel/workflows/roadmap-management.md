<purpose>
Handle roadmap operations: show project status with git-aware routing, add phases to the current milestone, and remove future phases.
</purpose>

<when_to_use>
- User requests project status (/paul:status)
- Milestone scope changes and needs a phase added or removed
- Roadmap cleanup is required without changing loop semantics
</when_to_use>

<loop_context>
N/A - This is a roadmap modification workflow, not a loop phase.
Can be invoked at any time during a milestone.
</loop_context>

<required_reading>
.paul/STATE.md
.paul/ROADMAP.md (read the current milestone section for show-status; expand to broader roadmap structure only for add/remove operations)
</required_reading>

<references>
@src/templates/ROADMAP.md (phase section format)
</references>

---

## Operation: show-status

<process>

<step name="read_state">
1. Read `.paul/STATE.md` for the current milestone, phase, plan, loop position, last activity, and progress.
2. Read the current milestone section in `.paul/ROADMAP.md` for the milestone theme, phase table, and completion counts.
</step>

<step name="check_git_state">
**Surface git/PR state for github-flow projects.**

1. Read pals.json and resolve GIT_WORKFLOW using 3-tier resolution:
   ```
   if git.workflow exists → use it
   else if git.branching exists → "legacy"
   else → "none"
   ```

2. **If GIT_WORKFLOW = "github-flow":**
   a. Detect current branch:
      ```bash
      git branch --show-current
      ```
   b. Read GIT_BASE_BRANCH from pals.json `git.base_branch` (default: "main")
   c. Check ahead/behind base:
      ```bash
      git fetch origin {GIT_BASE_BRANCH} --quiet 2>/dev/null
      git rev-list --left-right --count origin/{GIT_BASE_BRANCH}...HEAD 2>/dev/null
      ```
      Parse output: first number = BEHIND_COUNT, second = AHEAD_COUNT
   d. Check for open PR:
      ```bash
      gh pr view --json url,state,statusCheckRollup 2>/dev/null
      ```
   e. If PR exists, extract:
      - PR_URL from `url`
      - PR_STATE from `state` (OPEN, MERGED, CLOSED)
      - CI_STATE from `statusCheckRollup`: all SUCCESS → "passing", any FAILURE → "failing", else → "pending"
   f. If no PR exists: PR_URL = "none", PR_STATE = "N/A", CI_STATE = "N/A"
   g. Store: CURRENT_BRANCH, GIT_BASE_BRANCH, PR_URL, PR_STATE, CI_STATE, AHEAD_COUNT, BEHIND_COUNT

3. **If GIT_WORKFLOW != "github-flow":** skip entirely (no git state surfacing)
</step>

<step name="determine_next_action">
**Git-aware routing (github-flow only):**
If GIT_WORKFLOW = "github-flow" AND git state was collected:

| Git State | Override Next Action |
|-----------|---------------------|
| BEHIND_COUNT > 0 (branch behind base) | "Update branch from base: `git fetch origin {GIT_BASE_BRANCH} && git rebase origin/{GIT_BASE_BRANCH}` then re-push and recheck CI" |
| PR open + CI failing | "Fix CI failures, then merge PR" |
| PR open + CI passing + reviews pending (if `require_reviews: true`) | "Get PR reviewed" |
| PR open + CI passing + ready to merge | "Merge PR: `gh pr merge`" |
| No PR + loop complete (all ✓) | Normal routing (next PLAN will create branch) |

Behind-base routing takes precedence over merge readiness; otherwise fall through to the loop-position routing below.

**Loop-position routing:**
Based on loop position, determine **exactly ONE** next action:

| Loop State | Next Action |
|------------|-------------------|
| PLAN ○ (no plan yet) | `/paul:plan` |
| PLAN ✓, APPLY ○ (plan awaiting approval) | `/paul:apply [plan-path]` |
| PLAN ✓, APPLY ✓, UNIFY ○ (executed, not reconciled) | `/paul:unify [plan-path]` |
| All ✓ (loop complete) | `/paul:plan` (next phase) |
| Blocked | "Address blocker: [specific issue]" |
</step>

<step name="display_status">
Display to user with ONE next action:
```
════════════════════════════════════════
PAUL PROJECT STATUS
════════════════════════════════════════
Project: [from PROJECT.md or STATE.md]
Milestone: [name] ([X]% complete)
Phase: [N] of [M] - [Phase Name]
Plan: [NN-PP] - [status]
┌─────────────────────────────────────┐
│  PLAN ──▶ APPLY ──▶ UNIFY          │
│   [✓/○]    [✓/○]    [✓/○]          │
└─────────────────────────────────────┘

{If GIT_WORKFLOW = "github-flow":}
Git State:
┌─────────────────────────────────────┐
│  Branch: {CURRENT_BRANCH}           │
│  Base:   {GIT_BASE_BRANCH}          │
│  PR:     {PR_URL} ({PR_STATE})      │
│  CI:     {CI_STATE}                 │
│  Sync:   {BEHIND_COUNT} behind / {AHEAD_COUNT} ahead │
└─────────────────────────────────────┘
Last Activity: [timestamp]
────────────────────────────────────────
▶ NEXT: [single command with path]
  [brief description of what it does]
────────────────────────────────────────
```

If GIT_WORKFLOW is not "github-flow", omit the Git State block. If no PR exists, show "PR: none (N/A)". Show exactly ONE suggested action with the standard PAUL routing format and no numbered options.
</step>

</process>

---

## Operation: add-phase

<process>

<step name="add_validate" priority="first">
1. Read the current milestone section in ROADMAP.md
2. Identify highest phase number in that active milestone table
3. Calculate next phase number = highest + 1
**If no active milestone:**
- Error: "No active milestone. Run /paul:milestone first."
- Exit workflow
</step>

<step name="add_gather_info">
Ask for phase details:

```
Adding phase {next_number} to {milestone_name}.

Phase name?
(Example: "Testing", "Documentation", "Performance")
```

Wait for response. Store as `phase_name`.

Optional follow-up:
```
Brief description? (Press Enter to skip)
```

Store as `phase_description` or derive from name.
</step>

<step name="add_update_roadmap">
Update ROADMAP.md:

1. **Update milestone header:**
   ```markdown
   Phases: {X} of {new_total} complete
   ```

2. **Add to phases table:**
   ```markdown
   | {next_number} | {phase_name} | TBD | Not started | - |
   ```

3. **Add phase details section:**
   ```markdown
   ### Phase {next_number}: {phase_name}

   Focus: {phase_description}
   Plans: TBD (defined during /paul:plan)
   Status: Not started
   ```

4. **Update footer timestamp**
</step>

<step name="add_create_directory">
Create phase directory:

```bash
mkdir -p .paul/phases/{NN}-{phase-slug}
```

Where:
- `NN` = zero-padded phase number
- `phase-slug` = lowercase, hyphenated phase name
</step>

<step name="add_update_state">
Update STATE.md:

1. **Last activity:**
   ```markdown
   Last activity: {timestamp} — Added Phase {number}: {name}
   ```

2. **Decisions (add to table):**
   ```markdown
   | Added Phase {number}: {name} | Phase {current} | Extends milestone scope |
   ```
</step>

<step name="add_confirm">
Display confirmation:

```
════════════════════════════════════════
PHASE ADDED
════════════════════════════════════════

Phase {number}: {name}
Directory: .paul/phases/{slug}/

{milestone_name} now has {total} phases.

ROADMAP.md updated ✓
STATE.md updated ✓

Continue with current work or plan this phase later.
════════════════════════════════════════
```
</step>

</process>

---

## Operation: remove-phase

<process>

<step name="remove_validate" priority="first">
1. Read the current milestone section in ROADMAP.md
2. Find target phase by number or name within that active milestone slice
3. Check phase status
**Validation rules:**
- Phase must be "Not started" — cannot remove in-progress or complete phases
- Phase must be in current milestone
- Cannot remove if it's the only remaining phase
**If validation fails:**
```
Cannot remove Phase {number}: {name}
Reason: {status is not "Not started" / only remaining phase / not in current milestone}
Only future (not started) phases can be removed.
```
Exit workflow.
</step>

<step name="remove_confirm_intent">
Ask for confirmation:

```
════════════════════════════════════════
REMOVE PHASE?
════════════════════════════════════════

Phase {number}: {name}
Status: Not started

This will:
- Remove from ROADMAP.md
- Delete .paul/phases/{slug}/ (if empty)
- Renumber subsequent phases

[1] Yes, remove | [2] Cancel
════════════════════════════════════════
```

Wait for confirmation. If "2" or "cancel" → exit.
</step>

<step name="remove_update_roadmap">
Update ROADMAP.md:

1. **Remove phase from table**

2. **Remove phase details section**

3. **Renumber subsequent phases:**
   - Phase 7 removed → Phase 8 becomes 7, Phase 9 becomes 8, etc.
   - Update both table and details sections

4. **Update milestone header:**
   ```markdown
   Phases: {X} of {new_total} complete
   ```

5. **Update footer timestamp**
</step>

<step name="remove_cleanup_directory">
Handle phase directory:

```bash
rmdir .paul/phases/{NN}-{slug} 2>/dev/null
```

**If directory not empty:**
- Warn: "Directory not empty — preserved at .paul/phases/{slug}/"
- User can manually delete if desired

**If directory empty or doesn't exist:**
- Silently removed or was never created
</step>

<step name="remove_renumber_directories">
**If subsequent phases exist:**

Renumber phase directories to match ROADMAP.md:

```bash
mv .paul/phases/08-name .paul/phases/07-name
mv .paul/phases/09-name .paul/phases/08-name
```

**Note:** This is why we only allow removing "Not started" phases — they have no artifacts yet.
</step>

<step name="remove_update_state">
Update STATE.md:

1. **Last activity:**
   ```markdown
   Last activity: {timestamp} — Removed Phase {number}: {name}
   ```

2. **Decisions (add to table):**
   ```markdown
   | Removed Phase {original_number}: {name} | Phase {current} | Scope reduction |
   ```

3. **If removed phase was "next":**
   - Update current position to reflect new next phase
</step>

<step name="remove_confirm">
Display confirmation:

```
════════════════════════════════════════
PHASE REMOVED
════════════════════════════════════════

Removed: Phase {original_number}: {name}
{renumbered_phases count} phases renumbered.

{milestone_name} now has {total} phases.

ROADMAP.md updated ✓
STATE.md updated ✓
════════════════════════════════════════
```
</step>

</process>

---

## Operation: repair-bloated-roadmap

Use when `ROADMAP.md` has accumulated long completed milestone or completed phase history inline.

<process>

<step name="repair_detect" priority="first">
1. Read `.paul/STATE.md` and only the current milestone section of `.paul/ROADMAP.md` first.
2. Expand to completed-history sections only to confirm bloat indicators:
   - Multiple completed milestones with full phase detail inline
   - Large `<details>` blocks duplicating completed plan lists
   - Live ROADMAP dominated by cold history instead of current routing
3. If the active/current milestone routing is missing or malformed, preserve that routing before moving history.
</step>

<step name="repair_archive_completed_history">
1. Create `.paul/archive/roadmap/` if needed.
2. Move completed milestone detail into one or more roadmap archive files using the milestone archive convention.
3. Add return links from each archive to live `ROADMAP.md`, `STATE.md`, and archive index.
4. Treat archive files as authoritative project truth; do not delete historical detail.
</step>

<step name="repair_compact_live_roadmap">
1. Replace the moved inline history with a compact completed milestone index.
2. Keep the live ROADMAP focused on overview, active/current milestone, current phase table/details, and near-future planned milestone summaries.
3. For add/remove/show-status behavior, stay scoped to the current milestone section unless broader history is genuinely required.
4. Update footer timestamp and archive index links.
</step>

<step name="repair_confirm">
Display the archive path(s), the compacted live ROADMAP sections, and the next lifecycle action from STATE.md. Do not change PLAN/APPLY/UNIFY loop state unless a separate lifecycle command requires it.
</step>

</process>

---

<output>
**add-phase:**
- ROADMAP.md updated with new phase
- Phase directory created
- STATE.md decision logged

**remove-phase:**
- ROADMAP.md updated (phase removed, subsequent renumbered)
- Phase directory removed (if empty)
- Subsequent directories renumbered
- STATE.md decision logged
</output>

<success_criteria>
**add-phase:**
- [ ] Next phase number calculated correctly
- [ ] Phase added to ROADMAP.md table and details
- [ ] Directory created
- [ ] STATE.md updated
- [ ] Milestone total updated

**remove-phase:**
- [ ] Phase status validated (not started only)
- [ ] User confirmed removal
- [ ] Phase removed from ROADMAP.md
- [ ] Directory cleaned up
- [ ] Subsequent phases renumbered
- [ ] STATE.md updated
</success_criteria>

<validation_rules>
**add-phase:**
- Active milestone must exist
- Phase name required
- Cannot add duplicate phase names (warning only)

**remove-phase:**
- Phase must exist
- Phase must be "Not started"
- Cannot remove last phase in milestone
- Cannot remove phase with artifacts (PLAN.md, SUMMARY.md)
</validation_rules>

<error_handling>
**No active milestone:**
- Route to /paul:milestone or /paul:init

**Phase directory not empty:**
- Preserve directory, warn user
- User can manually clean up

**Renumbering conflicts:**
- If directory already exists at target number, warn and skip
- Report which directories couldn't be renamed

**ROADMAP.md malformed:**
- Report parsing error
- Suggest manual fix
</error_handling>
