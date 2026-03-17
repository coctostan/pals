<purpose>
Resume PAUL work after a session break. Reads STATE.md to restore context, determines current loop position, and routes to exactly ONE next action. Includes handoff lifecycle management.
</purpose>

<when_to_use>
- Starting a new session on an existing PAUL project
- Context was cleared (new conversation)
- Handoff from another session
- User asks to "continue" or "resume" PAUL work
</when_to_use>

<loop_context>
Determined dynamically by reading STATE.md.
This workflow figures out where we are, not assumes it.
</loop_context>

<philosophy>
**Single next action:** Resume determines state and suggests exactly ONE action.
No multiple options. Prevents decision fatigue. User can redirect if needed.

**Handoff lifecycle:** Handoffs are consumed on resume, then archived or deleted.
</philosophy>

<required_reading>
.paul/STATE.md
</required_reading>

<references>
@kernel/references/context-management.md
@kernel/references/loop-phases.md
</references>

<process>

<step name="verify_paul_exists" priority="first">
1. Check for .paul/ directory:
   ```bash
   ls .paul/STATE.md 2>/dev/null
   ```
2. If not found:
   - "No PAUL project found. Run /paul:init first."
   - Exit workflow
3. If found: proceed with resume
</step>

<step name="detect_handoffs">
**Check for handoff files:**
1. Search for active handoff files first:
   ```bash
   ls -t .paul/HANDOFF*.md 2>/dev/null | head -5
   ```

2. Search archived handoffs as fallback:
   ```bash
   ls -t .paul/handoffs/archive/HANDOFF*.md 2>/dev/null | head -5
   ```

3. If handoff argument provided ($ARGUMENTS):
   - Use specified handoff path
   - Validate it exists
4. If no argument but handoffs found:
   - Prefer the most recent active handoff
   - If no active handoff exists, use the most recent archived handoff
   - Note: `.paul/HANDOFF-{context}.md` is the standard active pattern

5. Track handoff for lifecycle:
   - Store path for later archive/delete
   - If the selected handoff is already archived, do not move it again after resume proceeds
</step>

<step name="load_state">
1. Read `.paul/STATE.md`
2. Extract:
   - Current Position (phase, plan, status)
   - Loop Position (PLAN/APPLY/UNIFY markers)
   - Last activity (what was happening)
   - Session Continuity section:
     - Stopped at
     - Next action
     - Resume file
     - Resume context
</step>

<step name="load_resume_context">
1. If handoff detected in previous step:
   - Read handoff file content
   - Present as "HANDOFF CONTEXT DETECTED" section
   - Extract key information (decisions, gaps, next actions)

2. If resume file specified in STATE.md (and no handoff):
   - Read the resume file (PLAN, SUMMARY)

3. Build mental picture of:
   - What was accomplished
   - What's in progress
   - What's next
   - Any decisions or gaps from handoff
</step>

<step name="determine_single_action">
Based on loop position, determine **exactly ONE** next action:

| Loop State | Single Next Action |
|------------|-------------------|
| PLAN ○ (no plan yet) | `/paul:plan` |
| PLAN ✓, APPLY ○ (plan awaiting approval) | `/paul:apply [plan-path]` |
| PLAN ✓, APPLY ✓, UNIFY ○ (executed, not reconciled) | `/paul:unify [plan-path]` |
| All ✓ (loop complete) | `/paul:plan` (next phase) |
| Blocked | "Address blocker: [specific issue]" |

**Do NOT offer multiple options.** Pick the ONE correct action.
</step>

<step name="report_and_route">
Display to user with ONE next action:

```
════════════════════════════════════════
PAUL PROJECT RESUMED
════════════════════════════════════════

Project: [from PROJECT.md]
Phase: [N] of [M] - [Phase Name]
Plan: [NN-PP] - [plan description]

Loop Position:
┌─────────────────────────────────────┐
│  PLAN ──▶ APPLY ──▶ UNIFY          │
│   [✓/○]    [✓/○]    [✓/○]          │
└─────────────────────────────────────┘

Last Session: [timestamp]
Stopped at: [what was happening]

────────────────────────────────────────
▶ NEXT: [single command with path]
  [brief description of what it does]
────────────────────────────────────────

Type "yes" to proceed, or provide context for a different action.
```

**IMPORTANT:** Do NOT show numbered options (1, 2, 3, 4).
Show exactly ONE suggested action with the standard PAUL routing format.
</step>

<step name="handoff_lifecycle">
**After user proceeds with work:**
When user confirms next action (e.g., "yes", "1", "approved"):
1. **Archive handoff** (if one was consumed from the active root location):
   ```bash
   mkdir -p .paul/handoffs/archive
   mv .paul/HANDOFF-{context}.md .paul/handoffs/archive/
   ```
   - Preserves history while removing from active path
   - If the consumed handoff was already in `.paul/handoffs/archive/`, leave it in place
   - Alternative: delete if archive not needed
2. **Clean orphaned handoffs:**
   ```bash
   # Find active handoffs older than current phase
   find .paul -maxdepth 1 -name "HANDOFF*.md" -mtime +7 -type f
   ```
   - Move to archive or delete
   - Prevents accumulation of stale active handoffs
3. **Update STATE.md:**
   - Clear "Resume file" if it pointed to an active handoff that was archived
   - If STATE.md points to an archived handoff, that is still a valid resume context path
   - Handoff context now integrated into session
</step>
</process>

<output>
- Context restored from STATE.md and/or handoff
- Handoff content presented if detected
- User informed of current position
- Exactly ONE next action suggested
- User can proceed or redirect
- Handoff archived after work proceeds
</output>

<error_handling>
**STATE.md corrupted or incomplete:**
- Report what's missing
- Suggest: `/paul:init` to reinitialize (destructive) or manual repair

**Conflicting information:**
- STATE.md says X, but files suggest Y
- Report discrepancy
- Ask user to clarify actual state

**No resume context:**
- If SESSION CONTINUITY section empty:
- Fall back to loop position
- Suggest based on what files exist

**Stale handoff:**
- If handoff older than STATE.md modifications
- Trust STATE.md, note handoff may be outdated
</error_handling>
