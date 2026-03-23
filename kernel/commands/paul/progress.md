---
name: pals:progress
description: Smart status with routing - suggests ONE next action
argument-hint: "[context]"
allowed-tools: [Read]
---

<objective>
Show current progress and **route to exactly ONE next action**. Prevents decision fatigue by suggesting a single best path.

**When to use:**
- Mid-session check on progress
- After `/paul:resume` for more context
- When unsure what to do next
- To get a tailored suggestion based on your current focus
</objective>

<execution_context>
</execution_context>

<context>
$ARGUMENTS

.paul/STATE.md
.paul/ROADMAP.md
</context>

<process>

<step name="load_state">
Read `.paul/STATE.md` and `.paul/ROADMAP.md`:
- Current phase and total phases
- Current plan (if any)
- Loop position (PLAN/APPLY/UNIFY markers)
- Roadmap progress
- Performance metrics (if tracked)
- Blockers or concerns
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
<step name="calculate_progress">
Determine overall progress:

**Milestone Progress:**
- Phases complete: X of Y
- Current phase progress: Z%

**Current Loop:**
- Position: PLAN/APPLY/UNIFY
- Status: [what's happening]
</step>

<step name="consider_user_context">
**If `[context]` argument provided:**

User has given additional context about their current focus or constraint.
Factor this into routing decision:
- "I need to fix a bug first" → prioritize that over planned work
- "I only have 30 minutes" → suggest smaller scope
- "I want to finish this phase" → stay on current path
- "I'm stuck on X" → suggest debug or research approach

**If no argument:** Use default routing based on state alone.
</step>

<step name="determine_routing">
Based on state (+ user context if provided), determine **ONE** next action:
**Git-aware routing (github-flow only):**
If GIT_WORKFLOW = "github-flow" AND git state was collected:

| Git State | Override Next Action |
|-----------|---------------------|
| PR open + CI failing | "Fix CI failures, then merge PR" |
| BEHIND_COUNT > 0 (branch behind base) | "Update branch from base: `git fetch origin {GIT_BASE_BRANCH} && git rebase origin/{GIT_BASE_BRANCH}` then re-push and recheck CI" |
| PR open + CI passing + reviews pending (if `require_reviews: true`) | "Get PR reviewed" |
| PR open + CI passing + ready to merge | "Merge PR: `gh pr merge`" |
| No PR + loop complete (all ✓) | Normal routing (next PLAN will create branch) |

Note: BEHIND_COUNT > 0 fires even if the PR is ready to merge. Merging a behind-base
branch risks post-merge CI failures. Always update from base first.

If no git override applies, fall through to the default routing below.

**Default routing (no user context):**
| Situation | Single Suggestion |
|-----------|-------------------|
| No plan exists | `/paul:plan` |
| Plan awaiting approval | "Approve plan to proceed" |
| Plan approved, not executed | `/paul:apply [path]` |
| Applied, not unified | `/paul:unify [path]` |
| Loop complete, more phases | `/paul:plan` (next phase) |
| Milestone complete | "Create next milestone or ship" |
| Blockers present | "Address blocker: [specific]" |
| Context at DEEP/CRITICAL | `/paul:pause` |
**With user context:** Adjust suggestion to align with stated intent.
**IMPORTANT:** Suggest exactly ONE action. Not multiple options.
</step>

<step name="display_progress">
Show progress with single routing:
```
════════════════════════════════════════
PAUL PROGRESS
════════════════════════════════════════
Milestone: [name] - [X]% complete
├── Phase 1: [name] ████████████ Done
├── Phase 2: [name] ████████░░░░ 70%
├── Phase 3: [name] ░░░░░░░░░░░░ Pending
└── Phase 4: [name] ░░░░░░░░░░░░ Pending
┌─────────────────────────────────────┐
│  PLAN ──▶ APPLY ──▶ UNIFY          │
│    ✓        ✓        ○             │
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

────────────────────────────────────────
▶ NEXT: /paul:unify .paul/phases/02-features/02-03-PLAN.md
  Close the loop and update state.
────────────────────────────────────────
Type "yes" to proceed, or provide context for a different suggestion.
```

**Note:** If GIT_WORKFLOW is not "github-flow", omit the entire Git State block.
</step>

<step name="context_advisory">
If context is at DEEP or CRITICAL bracket:

```
⚠️ Context Advisory: Session at [X]% capacity.
   Recommended: /paul:pause before continuing.
```
</step>

</process>

<success_criteria>
- [ ] Overall progress displayed visually
- [ ] Current loop position shown
- [ ] Exactly ONE next action suggested (not multiple)
- [ ] User context considered if provided
- [ ] Context advisory shown if needed
</success_criteria>
