<purpose>
Create HANDOFF.md file and update STATE.md when pausing work mid-session. Enables seamless resumption in fresh session with full context restoration.
</purpose>

<when_to_use>
- Before ending a session (planned or context limit approaching)
- Switching to different project
- Context window at DEEP or CRITICAL bracket
- User explicitly pauses work
</when_to_use>

<loop_context>
Any position in PLAN/APPLY/UNIFY loop. Captures state regardless of where loop is.
</loop_context>

<required_reading>
.paul/STATE.md
.paul/PROJECT.md
</required_reading>

<references>
@kernel/references/context-management.md
@kernel/templates/HANDOFF.md
</references>

<process>

<step name="detect_position" priority="first">
1. Read `.paul/STATE.md` to get:
   - Current phase and plan
   - Loop position (PLAN/APPLY/UNIFY markers)
   - Last activity
2. Identify current working directory:
   ```bash
   ls -t .paul/phases/*/PLAN*.md 2>/dev/null | head -1
   ```
3. Resolve GIT_WORKFLOW from pals.json using 3-tier resolution:
   ```
   if git.workflow exists → use it
   else if git.branching exists → "legacy"
   else → "none"
   ```
4. If GIT_WORKFLOW = "github-flow":
   a. Detect current branch: `git branch --show-current`
   b. Read GIT_BASE_BRANCH from pals.json `git.base_branch` (default: "main")
   c. Check ahead/behind: `git rev-list --left-right --count origin/{GIT_BASE_BRANCH}...HEAD 2>/dev/null`
   d. Check PR state: `gh pr view --json url,state,statusCheckRollup 2>/dev/null`
   e. Store: CURRENT_BRANCH, GIT_BASE_BRANCH, PR_URL, PR_STATE, CI_STATE, BEHIND_COUNT
</step>

<step name="gather_session_context">
**Collect complete state for handoff:**

Ask user (or infer from conversation):
1. **Work completed this session** - What got done?
2. **Work in progress** - What's partially done?
3. **Decisions made** - Key choices and rationale
4. **Blockers/issues** - Anything stuck?
5. **Mental context** - The approach, what you were thinking

If user doesn't provide, summarize from:
- Recent file modifications (`git status`)
- Conversation history
- STATE.md changes
</step>

<step name="create_handoff">
**Create HANDOFF file:**

```bash
# Generate filename
TIMESTAMP=$(date +%Y-%m-%d)
HANDOFF_FILE=".paul/HANDOFF-${TIMESTAMP}.md"
```

**Write content (NOT from template, populate directly):**

```markdown
# PAUL Handoff

**Date:** [current timestamp]
**Status:** [paused/blocked/context-limit]

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** [from PROJECT.md]
**Core value:** [from PROJECT.md]

---

## Current State

**Version:** [from STATE.md]
**Phase:** [N] of [total] — [phase name]
**Plan:** [plan-id] — [status]

**Loop Position:**
```
PLAN ──▶ APPLY ──▶ UNIFY
  [✓/○]    [✓/○]    [✓/○]
```

{If GIT_WORKFLOW = "github-flow":}
## Git State

| Field | Value |
|-------|-------|
| Branch | {CURRENT_BRANCH} |
| Base | {GIT_BASE_BRANCH} |
| PR | {PR_URL or "none"} ({PR_STATE or "N/A"}) |
| CI | {CI_STATE or "N/A"} |
| Behind base | {BEHIND_COUNT} commits (or "Up to date") |

{End if}

---

## What Was Done

- [Accomplishment 1]
- [Accomplishment 2]
- [Accomplishment 3]

---

## What's In Progress

- [In-progress item with status]

---

## What's Next

**Immediate:** [specific next action]

**After that:** [following action]

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/STATE.md` | Live project state |
| `.paul/ROADMAP.md` | Phase overview |
| [current plan path] | [plan purpose] |

---

## Resume Instructions

1. Read `.paul/STATE.md` for latest position
2. Check loop position
3. Run `/paul:resume` or `/paul:progress`

---

*Handoff created: [timestamp]*
```

Be specific enough for a fresh Claude to understand immediately.
</step>

<step name="update_state">
**Update `.paul/STATE.md` Session Continuity section:**

```markdown
## Session Continuity

Last session: [timestamp]
Stopped at: [what was happening]
Next action: [clear directive]
Resume file: .paul/HANDOFF-[date].md
Resume context:
- [bullet 1 - key context]
- [bullet 2 - key context]
- [bullet 3 - key context]
```
</step>

<step name="optional_commit">
**If git repo, offer WIP commit with explicit flow based on workflow mode:**

**Read git config using 3-tier workflow resolution:**
```bash
GIT_WORKFLOW=$(jq -r '.git.workflow // empty' pals.json 2>/dev/null)
if [ -z "$GIT_WORKFLOW" ]; then
  GIT_BRANCHING=$(jq -r '.git.branching // empty' pals.json 2>/dev/null)
  GIT_WORKFLOW=${GIT_BRANCHING:+"legacy"}
  GIT_WORKFLOW=${GIT_WORKFLOW:-"none"}
fi
```

**If GIT_WORKFLOW = "none":** skip commit step entirely.
**Question 1 — Commit WIP?**
```
────────────────────────────────────────
Would you like to commit your work-in-progress?
────────────────────────────────────────
[yes] / [no]
```

**If no:** Skip to confirm step.

**If GIT_WORKFLOW = "github-flow":**
- Always commit to feature branch (github-flow requires feature branches)
- Skip Question 2 (branch choice is predetermined)
```bash
# Commit to current feature branch (already on it in github-flow)
git add -A
git commit -m "wip({phase}): paused at {plan}

Co-Authored-By: Claude <noreply@anthropic.com>"
```

**If GIT_WORKFLOW = "legacy" — Question 2 — Branch choice:**
If `GIT_BRANCHING` = `direct-to-main`: default is option 1.
If `GIT_BRANCHING` = `feature-per-phase` (or unset): default is option 2.
```
────────────────────────────────────────
Where should this WIP commit go?
[2] feature branch — Create feature/{phase-name} branch first {* if feature-per-phase}
Press enter for default, or choose explicitly.
────────────────────────────────────────
```

If user presses enter or says "default", use the config-driven default.
**If main (option 1):**
```bash
git add -A
git commit -m "wip({phase}): paused at {plan}

Co-Authored-By: Claude <noreply@anthropic.com>"
```
**If feature branch (option 2):**
```bash
# Create and switch to feature branch
git checkout -b feature/{phase-name}
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
git add -A
git commit -m "wip({phase}): paused at {plan}

Co-Authored-By: Claude <noreply@anthropic.com>"
# Record branch strategy in STATE.md for transition-phase
```
**Update STATE.md Session Continuity with branch info:**
```markdown
Git strategy: {main|${CURRENT_BRANCH}}
```
This enables transition-phase.md to know the branch strategy when reconciling.
</step>

<step name="confirm">
**Display confirmation:**

```
════════════════════════════════════════
PAUL SESSION PAUSED
════════════════════════════════════════

Handoff created: .paul/HANDOFF-[date].md

Current State:
  Phase: [N] of [M]
  Plan: [status]
  Loop: [PLAN/APPLY/UNIFY position]

To resume later:
  /paul:resume

════════════════════════════════════════
```
</step>

</process>

<output>
- HANDOFF-{date}.md created in .paul/
- STATE.md updated with session continuity
- Optional WIP commit with branch choice (main or feature/{phase})
- Git strategy recorded in STATE.md for transition-phase
- User knows how to resume
</output>

<error_handling>
**No .paul/ directory:**
- "No PAUL project found. Nothing to pause."

**STATE.md missing or corrupted:**
- Create minimal handoff from available context
- Note the gap in handoff file

**Git not available:**
- Skip commit step, still create handoff
</error_handling>
