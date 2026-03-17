<purpose>
Facilitate vision articulation before creating a milestone. Acts as a thinking partner to explore what the user wants to build, then creates MILESTONE-CONTEXT.md for handoff to create-milestone.

**Philosophy:** Features first — everything else (scope, phases, constraints) derives from what the user wants to build.
</purpose>

<when_to_use>
- User completed previous milestone, considering what's next
- User wants to think through scope before committing
- User has rough ideas but needs to articulate them
- Before /paul:milestone when planning is desired
</when_to_use>

<loop_context>
N/A - This is a pre-planning workflow, not a loop phase.
After discussion, routes to /paul:milestone (create-milestone).
</loop_context>

<required_reading>
.paul/STATE.md
.paul/PROJECT.md (current requirements and progress)
.paul/MILESTONES.md (previous milestone accomplishments, if exists)
</required_reading>

<references>
@src/templates/milestone-context.md (handoff format)
</references>

<process>

<step name="check_state" priority="first">
1. Read STATE.md for current position
2. Read MILESTONES.md (if exists) for prior accomplishments

3. **If active milestone exists:**
   ```
   You have an active milestone: {milestone_name}

   [1] Complete current milestone first
   [2] Start discussion for NEXT milestone (plan ahead)
   ```
   Wait for decision.

4. **If no active milestone:**
   - Display: "Let's define your next milestone."
   - Proceed to milestone_context step
</step>

<step name="milestone_context">
**Present prior accomplishments (if any):**

```
════════════════════════════════════════
MILESTONE DISCUSSION
════════════════════════════════════════

{If MILESTONES.md exists:}
Previous milestone: {last_milestone_name}
Accomplishments:
- {accomplishment_1}
- {accomplishment_2}
- {accomplishment_3}

{If PROJECT.md has validated requirements:}
Shipped so far:
- {validated_requirement_1}
- {validated_requirement_2}

{If PROJECT.md has active requirements:}
Still planned:
- {active_requirement_1}
- {active_requirement_2}

────────────────────────────────────────
```

This gives user context for the discussion.
</step>

<step name="determine_planning_posture">
**Set the collaboration depth before shaping milestone scope.**

1. Read `pals.json` if it exists and extract `planning.default_collaboration`
2. Determine the effective default:
   - project default from `pals.json`
   - fallback = `medium`
3. Ask whether this run should keep the default or override it:
   ```
   Planning collaboration level: {default_collaboration} (project default)

   [1] Keep {default_collaboration}
   [2] low — minimal probing
   [3] medium — clarify constraints and open questions
   [4] high — deeper shaping, assumptions, alternatives, and risks
   ```
4. Ask whether this milestone is exploratory or direct-requirements:
   ```
   Is this milestone discussion exploratory or direct-requirements?

   [1] Exploratory — we still need to shape options and tradeoffs
   [2] Direct-requirements — the destination is mostly known; focus on clarifying and structuring it
   ```
5. Apply collaboration guidance to the remaining discussion:
   - low → ask the core feature question and only essential follow-ups
   - medium → clarify constraints, success conditions, and open questions
   - high → also probe assumptions, milestone-level risks, and meaningful alternatives
6. Apply mode guidance:
   - exploratory → allow broader shaping before converging on milestone structure
   - direct-requirements → stay close to the user's stated scope and focus on clarifying + prioritizing it
7. Store `collaboration_level` and `planning_mode` for the milestone handoff file.
</step>

<step name="explore_features">
**The core question — features first:**

```
What do you want to build next?

Don't worry about phases or structure yet — just describe the features,
capabilities, or improvements you have in mind.

(Examples: "Add milestone management", "Fix auth flow and add OAuth",
 "Build dashboard with real-time updates")
```

Wait for user response.

**Follow-up if needed:**
- "Any other features you're considering?"
- "What's the main problem this solves?"
- "What would 'done' look like for this?"

Store responses as `features` list.
</step>

<step name="synthesize_scope">
From the features discussed, derive:

1. **Milestone name/version:**
   - Infer from features (e.g., "Auth features" → "v0.4 Authentication")
   - Or ask: "What would you call this milestone?"

2. **Estimated phases:**
   - Group features into logical phases
   - Typical: 2-4 phases per milestone
   - Ask: "Does this grouping make sense? {phase_breakdown}"

3. **Constraints:**
   - Derive from discussion
   - Ask: "Any constraints or limitations to keep in mind?"

4. **Theme (one sentence):**
   - Synthesize: "So the focus is: {theme}. Sound right?"

Confirm with user before proceeding.
</step>

<step name="review_scope">
Offer progressive review before writing the milestone handoff:

```
Would you like to review this before I save the milestone context?

[1] Quick recap
[2] Detailed recap
[3] Full plan
[4] No review needed
```

- **Quick recap:** show the milestone goal, main feature groups, and biggest constraints
- **Detailed recap:** show features, proposed phases, constraints, open questions, and assumptions
- **Full plan:** show the full milestone-context draft / phase mapping that will be written
- **No review needed:** continue immediately

If the user asks for changes after a review, keep discussing instead of routing forward.
Store the selected path as `review_preference`.
</step>

<step name="write_context">
Create `.paul/MILESTONE-CONTEXT.md`:

```markdown
# Milestone Context

**Generated:** {date}
**Status:** Ready for /paul:milestone
**Planning Mode:** {planning_mode}
**Collaboration Level:** {collaboration_level}
**Suggested Review Path:** {review_preference}

## Features to Build

{features as bullets with descriptions}

## Scope

**Suggested name:** {milestone_name}
**Estimated phases:** {phase_count}
**Focus:** {theme}

## Phase Mapping

| Phase | Focus | Features |
|-------|-------|----------|
| {next_phase} | {focus} | {features} |
| {next_phase+1} | {focus} | {features} |

## Constraints

{constraints as bullets}

## Additional Context

{any other notes from discussion}

---

*This file is temporary. It will be deleted after /paul:milestone creates the milestone.*
```

Display:
```
Context saved to .paul/MILESTONE-CONTEXT.md

This file persists across /clear so you can take a break if needed.
```
</step>

<step name="handoff">
Route to create-milestone:

```
════════════════════════════════════════
DISCUSSION COMPLETE
════════════════════════════════════════

Milestone: {milestone_name}
Features: {feature_count}
Phases: {phase_count}
Mode: {planning_mode} | Collaboration: {collaboration_level}

Context saved for handoff.

────────────────────────────────────────
▶ NEXT: /paul:milestone
  Create the milestone structure from this context
────────────────────────────────────────

Type "yes" to proceed, or continue discussing.
```

**Accept:** "yes", "go", "create" → run `/paul:milestone`
</step>

</process>

<output>
- .paul/MILESTONE-CONTEXT.md created (handoff file)
- Features, scope, and phases articulated
- Ready for /paul:milestone to consume
</output>

<success_criteria>
- [ ] Prior accomplishments presented (if any)
- [ ] Features explored (user-driven)
- [ ] Scope synthesized from features
- [ ] Phase mapping suggested
- [ ] MILESTONE-CONTEXT.md written
- [ ] Clear handoff to /paul:milestone
</success_criteria>

<anti_patterns>
**Asking abstract questions first:**
DON'T: "What's the scope of the next milestone?"
DO: "What do you want to build?"

**Assuming phases before features:**
DON'T: "How many phases do you want?"
DO: Derive phases from the features discussed.

**Skipping confirmation:**
DON'T: Write context immediately after one question.
DO: Confirm the synthesis makes sense before writing.

**Not persisting context:**
DON'T: End discussion without writing MILESTONE-CONTEXT.md
DO: Always write the file so /clear doesn't lose progress.
</anti_patterns>

<error_handling>
**User unsure what to build:**
- Reference PROJECT.md active requirements
- Suggest: "What's the most painful thing right now?"
- Offer: "We can start with one feature and expand"

**Scope too large:**
- Suggest splitting: "That sounds like 2-3 milestones"
- Ask: "What's the minimum viable version?"

**User wants to skip discussion:**
- Route directly to /paul:milestone
- Note: "Going straight to milestone creation — no discussion context will be available"
</error_handling>
