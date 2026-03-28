<purpose>
Facilitate vision articulation before planning a phase, then create CONTEXT.md for handoff to plan-phase.
Focus on user goals and constraints for the phase rather than Claude-authored assumptions.
</purpose>

<when_to_use>
- User wants to think through a phase before planning it
- Phase scope is unclear or has multiple possible approaches
- A discussion handoff is needed before /paul:plan
</when_to_use>

<loop_context>
N/A - This is a pre-planning workflow, not a loop phase.
After discussion, routes to /paul:plan (plan-phase).
</loop_context>

<required_reading>
.paul/STATE.md
.paul/PROJECT.md (hot-path requirements and progress brief)
.paul/PRD.md (selectively, if present and deeper product framing, deferred scope, assumptions, open questions, or dependency detail help the discussion)
.paul/ROADMAP.md (use the current milestone section to validate the phase, then read only the selected phase detail for scope and goals)
</required_reading>

<references>
@src/templates/CONTEXT.md (handoff format)
</references>

<process>

<step name="validate_phase" priority="first">
1. Parse phase number from $ARGUMENTS

**If argument missing:**
```
Error: Phase number required.

Usage: /paul:discuss <phase-number>
Example: /paul:discuss 10
```
Exit workflow.

2. Validate phase exists in the current milestone section of ROADMAP.md
3. Extract the selected phase detail: number, name, description, scope
**If phase not found:**
```
Error: Phase {N} not found in roadmap.
Available phases:
[list incomplete phases from roadmap]
```
Exit workflow.
</step>

<step name="phase_context">
**Present phase context:**
```
════════════════════════════════════════
PHASE DISCUSSION
════════════════════════════════════════
Phase: {phase_number} — {phase_name}
Status: {from ROADMAP.md}
Selected phase detail from ROADMAP.md:
{selected phase detail from ROADMAP.md}
{If prior phase completed:}
Prior phase: {prior_phase_name}
What was built: {summary}
────────────────────────────────────────
```

<step name="determine_planning_posture">
**Set the collaboration depth before shaping phase scope.**
1. Read `pals.json` if it exists and extract `planning.default_collaboration`.
2. Determine the effective default: project default from `pals.json`, otherwise `medium`.
3. Ask whether this run should keep the default or override it:
   ```
   Planning collaboration level: {default_collaboration} (project default)
   [1] Keep {default_collaboration}
   [2] low — minimal probing
   [3] medium — clarify constraints and success conditions
   [4] high — deeper shaping, assumptions, alternatives, and risks
   ```
4. Ask whether this phase is exploratory or direct-requirements:
   ```
   Is this phase discussion exploratory or direct-requirements?
   [1] Exploratory — we still need to shape the approach
   [2] Direct-requirements — the destination is mostly known; focus on clarifying and structuring it
   ```
5. Apply collaboration guidance to the remaining discussion: low → only essential follow-ups for the handoff; medium → clarify constraints, success conditions, and open questions; high → also probe assumptions, edge cases, and meaningful alternatives.
6. Apply mode guidance: exploratory → allow broader shaping before converging on plan-ready goals; direct-requirements → stay close to the user's stated scope and focus on clarifying + prioritizing it.
7. Use `.paul/PROJECT.md` as the default brief, consult `.paul/PRD.md` only when richer product framing, deferred items, assumptions, open questions, or dependency detail materially help the discussion, and avoid broad roadmap rereads after the selected phase detail is loaded.
8. Store `collaboration_level` and `planning_mode` for the phase handoff file.
</step>

<step name="explore_goals">
**The core question — goals first:**

```
What do you want to accomplish in this phase?

Don't worry about implementation details yet — just describe what
success looks like and any specific goals you have in mind.

(Examples: "Get research workflows working", "Make the CLI intuitive",
 "Ensure proper error handling")
```

Wait for user response.

**Follow-up if needed:** ask only for missing priorities, most important outcomes, or risks, then store responses as the `goals` list.
</step>

<step name="explore_approach">
**Ask about approach:**

```
How do you want to approach this phase?

Consider:
- Any specific patterns or libraries to use/avoid?
- Constraints or limitations?
- Dependencies on other work?
```

Wait for user response.

Store responses as `approach` notes.
</step>

<step name="synthesize_context">
From the discussion, derive:

1. **Key goals:**
   - Synthesize main objectives from discussion
   - Confirm: "So the main goals are: {goals}. Sound right?"

2. **Approach notes:**
   - Capture technical direction
   - Note any constraints mentioned

3. **Open questions:**
   - Identify anything still unclear
   - Note items to research or decide during planning

Confirm with user before proceeding.
</step>

<step name="review_context">
Offer progressive review before writing the phase handoff:

```
Would you like to review this before I save the phase context?

[1] Quick recap
[2] Detailed recap
[3] Full plan
[4] No review needed
```

- **Quick recap:** show the phase goal, main approach, and biggest constraints
- **Detailed recap:** show goals, approach notes, constraints, open questions, and assumptions
- **Full plan:** show the full CONTEXT.md draft that will be written
- **No review needed:** continue immediately

If the user asks for changes after a review, keep discussing instead of routing forward.
Store the selected path as `review_preference`.
</step>

<step name="write_context">
Create `.paul/phases/{NN}-{name}/CONTEXT.md`:

Use CONTEXT.md template format. Include `Planning Mode`, `Collaboration Level`, and `Suggested Review Path` from the discussion.

Display:
```
Context saved to .paul/phases/{NN}-{name}/CONTEXT.md

This file persists across /clear so you can take a break if needed.
```
</step>

<step name="handoff">
Route to plan-phase:

```
════════════════════════════════════════
DISCUSSION COMPLETE
════════════════════════════════════════

Phase: {phase_number} — {phase_name}
Goals: {goal_count}
Mode: {planning_mode} | Collaboration: {collaboration_level}
Status: Ready for planning

Context saved for handoff.

────────────────────────────────────────
▶ NEXT: /paul:plan
  Create the plan structure from this context
────────────────────────────────────────

Type "yes" to proceed, or continue discussing.
```

**Accept:** "yes", "go", "plan" → run `/paul:plan`
</step>

</process>

<output>
- .paul/phases/{NN}-{name}/CONTEXT.md created (handoff file)
- Goals and approach articulated
- Ready for /paul:plan to consume
</output>

<success_criteria>
- [ ] Phase validated against ROADMAP.md
- [ ] Phase context presented
- [ ] Goals explored (user-driven)
- [ ] Approach discussed
- [ ] Context synthesized and confirmed
- [ ] CONTEXT.md written to phase directory
- [ ] Clear handoff to /paul:plan
</success_criteria>

<anti_patterns>
**Asking abstract questions first:**
DON'T: "What's the scope of this phase?"
DO: "What do you want to accomplish?"

**Assuming approach before goals:**
DON'T: "What libraries will you use?"
DO: Derive approach from goals discussed.

**Skipping confirmation:**
DON'T: Write context immediately after one question.
DO: Confirm the synthesis makes sense before writing.

**Not persisting context:**
DON'T: End discussion without writing CONTEXT.md
DO: Always write the file so /clear doesn't lose progress.

**Duplicating assumptions workflow:**
DON'T: Surface Claude's assumptions here.
DO: Focus on user input. Use /paul:assumptions for Claude's analysis.
</anti_patterns>

<error_handling>
**User unsure what to accomplish:**
- Reference ROADMAP.md phase description
- Suggest: "Based on the roadmap, this phase should..."
- Offer: "We can start with the roadmap goals and refine"

**Scope too large:**
- Suggest splitting into multiple plans
- Ask: "What's the most critical part?"

**User wants to skip discussion:**
- Route directly to /paul:plan
- Note: "Going straight to planning — no discussion context will be available"
</error_handling>
