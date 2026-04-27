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
@references/context-management.md
@templates/HANDOFF.md
references/git-strategy.md
</references>

<process>

<step name="detect_position" priority="first">
1. Read `.paul/STATE.md` to get current phase/plan, loop position, and last activity.
2. Identify the latest plan path in the working tree.
3. Resolve `GIT_WORKFLOW` with the shared 3-tier contract from `references/git-strategy.md`.
4. If `GIT_WORKFLOW = "github-flow"`, collect `CURRENT_BRANCH`, `GIT_BASE_BRANCH`, PR URL/state, CI state, and ahead/behind data using the shared pause/status recipe from `references/git-strategy.md`.
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
**If git repo, offer WIP commit with explicit flow based on workflow mode.**
Use `references/git-strategy.md` for shared workflow resolution and WIP continuity rules.

1. Resolve `GIT_WORKFLOW` with the shared 3-tier contract from `references/git-strategy.md`.
2. **If `GIT_WORKFLOW = "none"`:** skip the commit step entirely.
3. Ask whether to create a WIP commit.
4. If the user declines, skip to confirm.
5. If the user accepts:
   - use `git add -A`
   - in `github-flow`, commit on the current feature branch only
   - in `legacy`, offer the config-driven default between main and feature-branch WIP strategies
   - if a legacy feature branch is created or chosen, record the branch strategy in STATE so transition-phase can reconcile it later
6. Use the standard `wip({phase}): paused at {plan}` commit message format from `references/git-strategy.md`.
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
