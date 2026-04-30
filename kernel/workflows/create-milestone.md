<purpose>
Define a new milestone in the project, create its roadmap structure, initialize phase directories, and update project state. Use MILESTONE-CONTEXT.md if available from discuss-milestone.
</purpose>

<when_to_use>
- User explicitly requests a new milestone
- Triggered after /paul:discuss-milestone with carried context
- Previous milestone is complete and the next milestone needs structure
</when_to_use>

<loop_context>
N/A - This is a milestone setup workflow, not a loop phase.
After create-milestone, project is ready for first phase PLAN.
</loop_context>

<required_reading>
.paul/STATE.md
.paul/MILESTONE-CONTEXT.md (if exists)
.paul/ROADMAP.md (consult only the slice needed to insert the new milestone and derive the next available phase number)
</required_reading>

<references>
@src/templates/ROADMAP.md (milestone section format)
@src/templates/milestone-context.md (handoff structure)
@references/context-management.md
</references>

<process>

<step name="load_context" priority="first">
1. Check for MILESTONE-CONTEXT.md:
   ```bash
   cat .paul/MILESTONE-CONTEXT.md 2>/dev/null
   ```
2. **If found:**
   - Display: "Loading context from discuss-milestone..."
   - Parse: Features, Scope, Phase Mapping, Constraints
   - Store for use in subsequent steps
   - Read only the roadmap slice needed to preserve surrounding structure and derive the next available phase number
   - Skip to step 4 (update_roadmap)
3. **If not found:**
   - Display: "No discussion context found. Let's define the milestone."
   - Proceed to step 2 (get_milestone_info)
</step>

<step name="determine_planning_posture">
**Set the collaboration depth before milestone creation.**

1. If `MILESTONE-CONTEXT.md` exists, look for carried `Planning Mode`, `Collaboration Level`, and `Suggested Review Path`.
2. If no collaboration level is carried in the handoff, read `pals.json` and use `planning.default_collaboration`; fallback = `medium`.
3. Offer a quick override if the user wants to adjust collaboration before roadmap changes.
4. If no planning mode is available from the handoff, ask whether this run is exploratory or direct-requirements.
5. Apply collaboration guidance while asking any remaining milestone questions: low → minimal probing; medium → clarify constraints and phase grouping; high → also probe assumptions, risks, and alternatives where helpful.
6. Store the effective `planning_mode` and `collaboration_level` for review + reporting.
</step>

<step name="get_milestone_info">
**Only if no MILESTONE-CONTEXT.md exists.**

Ask one question at a time:

**Question 1: Milestone name/version**
```
What version/name for this milestone?

Example: "v0.3 Roadmap Management" or "v1.0 Production Release"
```
Wait for response. Store as `milestone_name`.

**Question 2: Theme**
```
What's the focus of this milestone? (1 sentence)
```
Wait for response. Store as `milestone_theme`.
</step>

<step name="identify_phases">
**Only if no MILESTONE-CONTEXT.md exists.**

Ask about phases:

```
What phases will this milestone include?

(Example: "Templates, Workflows, Commands" or "3 phases for auth, dashboard, deployment")
```

Wait for response. Parse into phase list.

For each phase, derive:
- Phase number (next available phase number from ROADMAP.md)
- Phase name
- Brief description
</step>

<step name="review_milestone_structure">
Apply contextual verbosity: default to a compact quick recap, expand only when the user asks or decisions are unresolved.

```
Would you like to see the plan before I update ROADMAP.md?
[1] Quick recap | [2] Detailed recap | [3] Full plan | [4] No review needed
```

- **Quick recap:** milestone name, theme, phase count, and top constraints.
- **Detailed recap:** scope, phase mapping, constraints, and open questions.
- **Full plan:** full milestone section, phase table, and roadmap structure about to be written.
- **No review needed:** continue immediately.

If the user requests adjustments after a review, refine the milestone structure before writing files.
Store the selected path as `review_preference`.
</step>

<step name="update_roadmap">
Read only the roadmap slice needed to insert the new milestone and preserve surrounding structure:
1. Add the milestone header section.
   ```markdown
   ## Current Milestone
   **{milestone_name}** ({version})
   Status: 🚧 In Progress
   Phases: 0 of {phase_count} complete
   ```
2. Add the phases table rows.
   ```markdown
   | Phase | Name | Plans | Status | Completed |
   |-------|------|-------|--------|-----------|
   | {N} | {name} | TBD | Not started | - |
   ```
3. Add the phase details sections.
   ```markdown
   ### Phase {N}: {name}
   Focus: {description}
   Plans: TBD (defined during /paul:plan)
   ```
4. Update the footer timestamp.
</step>

<step name="create_phase_directories">
For each phase in the new milestone:

```bash
mkdir -p .paul/phases/{NN}-{name-slug}
```

Where:
- `NN` = zero-padded phase number
- `name-slug` = lowercase, hyphenated phase name
</step>

<step name="update_state">
Update STATE.md:

1. **Current Position:**
   ```markdown
   ## Current Position

   Milestone: {milestone_name}
   Phase: {first_phase_number} of {total} ({first_phase_name})
   Plan: Not started
   Status: Ready to plan
   Last activity: {timestamp} — Milestone created
   ```

2. **Progress:**
   ```markdown
   Progress:
   - {milestone_name}: [░░░░░░░░░░] 0%
   ```

3. **Loop Position:**
   ```markdown
   ## Loop Position

   Current loop state:
   ```
   PLAN ──▶ APPLY ──▶ UNIFY
     ○        ○        ○     [Ready for first PLAN]
   ```
   ```

4. **Session Continuity:**
   ```markdown
   ## Session Continuity

   Last session: {timestamp}
   Stopped at: Milestone created, ready to plan
   Next action: /paul:plan for Phase {first_phase_number}
   Resume file: .paul/ROADMAP.md
   ```
</step>

<step name="cleanup_context">
**If MILESTONE-CONTEXT.md existed:**

Delete the handoff file:
```bash
rm .paul/MILESTONE-CONTEXT.md
```

Display: "Cleaned up milestone context handoff."

**Note:** This file is temporary — its job is done once milestone is created.
</step>

<step name="offer_next">
Use contextual verbosity for routine completion: concise created/updated evidence plus ONE next action; expand only for blockers, malformed context, or user-requested detail.
Display completion with ONE next action:

```
════════════════════════════════════════
MILESTONE CREATED
════════════════════════════════════════

Milestone: {milestone_name}
Theme: {milestone_theme}
Phases: {phase_count}
Mode: {planning_mode} | Collaboration: {collaboration_level}

Created:
  .paul/phases/{phase-1-slug}/     ✓
  .paul/phases/{phase-2-slug}/     ✓
  .paul/phases/{phase-N-slug}/     ✓

ROADMAP.md updated ✓
STATE.md updated ✓

────────────────────────────────────────
▶ NEXT: /paul:plan
  Begin planning Phase {first_phase_number}: {first_phase_name}
────────────────────────────────────────

Type "yes" to proceed, or ask questions first.
```

**Do NOT suggest multiple next steps.** ONE action only.
</step>

</process>

<output>
- ROADMAP.md updated with new milestone section
- Phase directories created in .paul/phases/
- STATE.md updated with new position
- MILESTONE-CONTEXT.md deleted (if existed)
- Clear routing to /paul:plan
</output>

<success_criteria>
- [ ] MILESTONE-CONTEXT.md loaded if exists
- [ ] User prompted only if no context exists
- [ ] ROADMAP.md has new milestone section
- [ ] Phase directories created
- [ ] STATE.md reflects new milestone position
- [ ] MILESTONE-CONTEXT.md cleaned up
- [ ] Single next action offered
</success_criteria>

<error_handling>
**MILESTONE-CONTEXT.md malformed:**
- Report parsing error
- Fall back to manual questions
- Clean up malformed file

**Phase directory exists:**
- Check if empty → proceed
- If has content → warn about overwrite, ask to confirm

**ROADMAP.md missing:**
- Create basic structure
- Or route to /paul:init if project not initialized
</error_handling>
