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
.paul/PROJECT.md (hot-path requirements and progress brief)
.paul/PRD.md (selectively, if present and deeper product framing, deferred scope, assumptions, open questions, or dependency detail help shape the milestone)
.paul/MILESTONES.md (previous milestone accomplishments, if exists)
docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md (only when the user opts into the optional strategic assessment — authoritative lens/capability-detection/output/authority spec)
kernel/templates/STRATEGIC-ASSESSMENT.md (only when the user opts into the optional strategic assessment — output-artifact shape)
</required_reading>

<references>
kernel/templates/milestone-context.md (handoff format)
kernel/templates/STRATEGIC-ASSESSMENT.md (strategic-assessment output format, for the optional checkpoint)
docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md (five lenses, capability detection, four-part output, non-authoritative stance)
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
7. Use `.paul/PROJECT.md` as the default brief and consult `.paul/PRD.md` only when richer product framing, deferred items, assumptions, open questions, or dependency detail materially help shape the milestone
8. Store `collaboration_level` and `planning_mode` for the milestone handoff file.
</step>

<step name="strategic_assessment">
**Optional: take stock before exploring features.**

This checkpoint implements `docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md` (authoritative; the contract wins on any conflict). It sits between the prior-accomplishments recap and feature exploration.

**It is OPTIONAL and NON-BLOCKING. It is main-session collaborative only: NO subagents, NO Pi UI surfaces, NO background automation. It never writes STATE/PROJECT/ROADMAP/MILESTONES lifecycle state.**

1. Offer it; default to skip:
   ```
   Before features — run a quick strategic assessment to take stock of where the project actually is?

   [1] Yes — gather lightweight evidence across five lenses and rank the next target
   [2] Skip — go straight to "what do you want to build next?"
   ```
   On `[2]` / skip / decline: proceed directly to explore_features with no penalty. Do nothing else here.

2. On `[1]`, gather evidence across the five lenses IN CONTRACT ORDER. For each lens: probe for the capability first, run a lightweight inspection when present, and SKIP an absent capability with an explicit `skipped: not applicable — {reason}` (use `partial: {what was available}` for partial availability). Never fail the checkpoint; never fabricate counts or trends. Let `collaboration_level` modulate depth (low = headline signals only; high = deeper dives where the conversation warrants).
   1. **Vision alignment** — Core Value + Success Criteria (PROJECT.md or equivalent) vs. the themes of the last N milestones (ROADMAP.md / MILESTONES.md). Note drift. If no vision statement, infer lightly from README/top-level docs and mark `partial`; if neither exists, skip not-applicable.
   2. **Trajectory** — convergence vs. sprawl: milestone-theme drift over time, deferred-debt accumulation, decision-log churn / re-litigation. Skip not-applicable when history is insufficient.
   3. **Codebase reality** — lightweight signals: repo size/growth, largest files, TODO/FIXME/HACK density (grep), test presence, obvious duplication/dead code. Skip optional analyzers (complexity/duplication tools) gracefully when absent; docs-only repos are `partial`.
   4. **Buildable/runnable reality** — detect build/test/validation tooling (package scripts, Makefile, test runners, validation harnesses); run what exists and report results. For each absent capability, skip with `not applicable — no {build|test|validation} tooling detected`. Never invent pass/fail counts.
   5. **Data & outputs** — detect output locations (results dirs, benchmark/validation logs, history files); summarize present outputs and their trend (improving/flat/regressing). Skip not-applicable when no inspectable outputs exist; never fabricate trends.

3. Produce the fixed four-part output IN ORDER:
   - **Findings** — evidence-backed observations by lens (in lens order), not-applicable lenses noted explicitly.
   - **Strategic options** — candidate next directions, each with tradeoffs (cost, risk, value, dependencies).
   - **Ranked recommendation** — a single recommended next target, explicitly tagged **non-authoritative**, with the reasoning that ranks it first.
   - **Actionable points** — concrete handoff items that feed the feature discussion.

4. Instantiate `kernel/templates/STRATEGIC-ASSESSMENT.md` and write it to `.paul/assessments/{date}-{slug}.md` (date = today; slug from the milestone-boundary/theme). Create the `.paul/assessments/` directory on demand. This artifact is **durable posterity**, NOT a hot-path lifecycle artifact, and is **exempt from STATE/PROJECT/ROADMAP/MILESTONES byte budgets**.

5. Store the produced actionable points as `assessment_actionables` and the artifact path as `assessment_path` for handoff to explore_features / synthesize_scope. Confirm with the user, then continue to explore_features.
</step>

<step name="explore_features">
**If the optional strategic assessment ran**, briefly surface its `assessment_actionables` as candidate seeds for this question (non-authoritative — do not override the user's own answer): "From the assessment, possible next targets are: {assessment_actionables}. Use any of these as a starting point, or tell me what you'd rather build."

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

When the optional strategic assessment ran, let its ranked recommendation and `assessment_actionables` inform the name, phase grouping, and theme — explicitly non-authoritative; the user decides. Cite `assessment_path` if the user wants the full reasoning.
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
- [ ] Optional strategic assessment offered (skippable, non-blocking); if run, assessment written to `.paul/assessments/{date}-{slug}.md` and actionable points fed into feature discussion
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

**Making the strategic assessment blocking or mandatory:**
DON'T: Gate feature discussion on running the assessment.
DO: Keep it optional and skippable; declining proceeds with no penalty.

**Spawning a subagent or Pi UI for the assessment:**
DON'T: Dispatch a subagent or open a Pi UI surface to run it.
DO: Run it inline in the main session as a conversation.

**Fabricating evidence for absent capabilities:**
DON'T: Invent counts, pass/fail numbers, or trends when a capability is missing.
DO: Skip with an explicit `not applicable — {reason}` note.

**Treating the ranked recommendation as authoritative:**
DON'T: Let the assessment decide the milestone.
DO: Keep it non-authoritative; the user decides, and only a future approved PLAN authorizes work.
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
