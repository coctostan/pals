<purpose>
Create an executable PLAN.md for the current or specified phase. The plan defines objective, acceptance criteria, tasks, boundaries, and verification - everything needed for APPLY phase execution.
</purpose>

<when_to_use>
- Starting a new phase (ROADMAP shows next phase ready)
- Previous plan completed (loop closed with UNIFY)
- First plan in a project (after init-project)
- Resuming work that needs a new plan
</when_to_use>

<loop_context>
Expected phase: PLAN
Prior phase: UNIFY (previous plan complete) or none (first plan)
Next phase: APPLY (after plan approval)
</loop_context>

<required_reading>
.paul/STATE.md
.paul/ROADMAP.md
.paul/PROJECT.md
.paul/phases/{prior-phase}/{plan}-SUMMARY.md (if exists and relevant)
</required_reading>

<references>
kernel/references/plan-format.md
kernel/references/checkpoints.md (if plan will have checkpoints)
kernel/templates/PLAN.md
<!-- Module references (e.g., plan type overlays) are loaded dynamically via hook dispatch from kernel/modules.yaml -->
</references>

<process>

<step name="validate_preconditions" priority="first">
1. Read STATE.md to confirm:
   - Loop position is ready for PLAN (prior UNIFY complete or first plan)
   - No blockers preventing planning
2. If STATE.md shows mid-loop (APPLY or UNIFY incomplete):
   - Warn user: "Previous loop not closed. Complete UNIFY first or reset."
   - Do not proceed until resolved
3. **Read-only constraint:** Plan phase must not modify source files — only produce plan artifacts. (Inspired by OpenHands' read-only planning agent)
</step>

<step name="identify_phase">
1. Read ROADMAP.md to determine:
   - Which phase is next (first incomplete phase)
   - Phase scope and goals
   - Dependencies on prior phases
2. If multiple phases available, ask user which to plan
3. Confirm phase selection before proceeding
</step>

<step name="pre_plan_hooks" priority="before-scope-analysis">
**Dispatch pre-plan lifecycle hooks to registered modules.**

1. Read `kernel/modules.yaml` (if it exists)
2. Find modules with hooks registered for `pre-plan`
3. Sort by priority (ascending — lower runs first)
4. For each registered module:
   a. Load the module's hook-specific `refs` (from module.yaml hooks section, NOT all module refs)
   b. Follow the module's hook description for `pre-plan`
   c. Collect `context_inject` data (e.g., type suggestions, candidate files)
   d. If module returns `action: block` — stop and surface the `reason` to the user
5. If no modules registered for `pre-plan`: proceed (no-op, no warning)
6. Output dispatch log: `[dispatch] pre-plan: {MODULE(priority) → N inject keys | skip | block} | ...`
7. Pass accumulated `context_inject` to analyze_scope (e.g., type suggestions feed into step 6)
</step>

<step name="analyze_scope">
1. Review phase goals from ROADMAP.md
2. **Assess change size** to scale planning depth: (Inspired by GPT Pilot's complexity gating)
   - 1-2 files, clear scope → lighter plan (fewer ACs, simpler verify)
   - 3-5 files → standard plan (full ACs, explicit verify per task)
   - 5+ files or cross-cutting → consider splitting into multiple plans
3. Estimate number of tasks needed:
   - Target: 2-3 tasks per plan
   - If >3 tasks, consider splitting into multiple plans
4. Identify files that will be modified
4. Determine if checkpoints are needed:
   - Visual verification required? → checkpoint:human-verify
   - Architecture decision needed? → checkpoint:decision
   - Unavoidable manual action? → checkpoint:human-action (rare)
5. Set autonomous flag: true if no checkpoints, false otherwise
6. Determine plan type:
   - Default type is `execute`
   - Dispatch `pre-plan` hooks (see pre_plan_hooks step) — modules may suggest alternative types based on their own heuristics
   - If a module suggests a non-default type via `context_inject`: present the suggestion to the user for confirmation
   - User confirms or overrides the type selection
</step>

<step name="load_context">
1. Read PROJECT.md for:
   - Core requirements and constraints
   - Value proposition (what matters)
2. If prior phase exists, read its SUMMARY.md for:
   - What was built
   - Decisions made
   - Any deferred issues
3. Read source files relevant to this phase's work
4. Do NOT reflexively chain all prior summaries - only load what's genuinely needed
</step>

<step name="check_specialized_flows">
**Check for SPECIAL-FLOWS.md and populate skills section.**

1. Check if `.paul/SPECIAL-FLOWS.md` exists
2. If exists:
   - Read SPECIAL-FLOWS.md
   - Extract skills marked as "required" for the work type being planned
   - Match against phase/plan work being done
   - Prepare <skills> section content for PLAN.md
3. If not exists:
   - Add comment: "No SPECIAL-FLOWS.md - skills section omitted"
   - Skip skills section in PLAN (or include minimal placeholder)
4. Display reminder if required skills found:
   ```
   ════════════════════════════════════════
   ⚠️  REQUIRED SKILLS for this plan:
   ════════════════════════════════════════
   - /skill-1 (work type: X)
   - /skill-2 (work type: Y)

   These must be loaded before /paul:apply will proceed.
   ════════════════════════════════════════
   ```

**Note:** The skills section is populated from SPECIAL-FLOWS.md during plan creation.
Required skills will BLOCK apply-phase until confirmed loaded.
</step>

<step name="create_plan">
1. Create phase directory: `.paul/phases/{NN}-{phase-name}/`
2. Generate PLAN.md following template structure:

   **Frontmatter:**
   - phase: NN-name
   - plan: 01 (or next number if multiple plans in phase)
   - type: execute (or other type suggested by pre-plan hooks and confirmed by user)
     **If type is non-default:** Post-plan hooks from the suggesting module will modify the plan structure accordingly. The kernel writes the standard plan, then dispatches post-plan hooks which may restructure tasks.
   - wave: 1 (adjust if dependencies exist)
   - depends_on: [] (or prior plan IDs if genuine dependency)
   - files_modified: [list all files]
   - autonomous: true/false

   **Sections:**
   - <objective>: Goal, Purpose, Output
   - <context>: references to project files and source
   - <acceptance_criteria>: Given/When/Then for each criterion
   - <tasks>: Task definitions with files, action, verify, done
   - <boundaries>: DO NOT CHANGE, SCOPE LIMITS
   - <verification>: Overall completion checks
   - <success_criteria>: Measurable completion
   - <output>: SUMMARY.md location

3. Ensure every task has:
   - Clear files list
   - Specific action (not vague)
   - Verification command/check
   - Done criteria linking to AC-N
</step>

<step name="validate_plan">
1. Check all sections present
2. Verify acceptance criteria are testable
3. Confirm tasks are specific enough (files + action + verify + done)
   - `<verify>` = programmatic proof (command, check, test) — how to prove it worked
   - `<done>` = human-reviewable outcome (links to AC-N) — what "complete" looks like
   (Inspired by GPT Pilot's dual-goal task validation)
4. **Clarity test:** Could someone with no project context execute this plan from the PLAN.md alone? If not, tasks are too vague. (Inspired by Superpowers' "junior engineer" test)
5. Ensure boundaries protect completed work
6. Validate checkpoint placement (if any):
   - After automated work completes
   - Before dependent decisions
   - Not too frequent (avoid checkpoint fatigue)
</step>

<step name="post_plan_hooks" priority="after-plan-creation">
**Dispatch post-plan lifecycle hooks to registered modules.**

1. Read `kernel/modules.yaml` (if it exists)
2. Find modules with hooks registered for `post-plan`
3. Sort by priority (ascending — lower runs first)
4. For each registered module:
   a. Load the module's hook-specific `refs` (from module.yaml hooks section)
   b. Follow the module's hook description for `post-plan`
   c. Pass the plan path, plan content, and `context_from_pre_plan`
   d. Collect `plan_modifications` (e.g., task restructuring)
   e. Apply modifications to the plan in priority order
5. If no modules registered for `post-plan`: proceed (no-op, no warning)
6. Output dispatch log: `[dispatch] post-plan: {MODULE(priority) → N modifications | skip} | ...`
7. If modifications were applied: note in plan that module overlays were applied
</step>

<step name="update_state" priority="required">
**This step is REQUIRED. Do not skip.**

1. **Update STATE.md** with exact content:

   ```markdown
   ## Current Position

   Milestone: v0.1 [Milestone Name]
   Phase: [N] of [total] ([Phase Name]) — Planning
   Plan: [NN-PP] created, awaiting approval
   Status: PLAN created, ready for APPLY
   Last activity: [timestamp] — Created [plan-path]

   Progress:
   - Milestone: [░░░░░░░░░░] X%
   - Phase [N]: [░░░░░░░░░░] 0%

   ## Loop Position

   Current loop state:
   ```
   PLAN ──▶ APPLY ──▶ UNIFY
     ✓        ○        ○     [Plan created, awaiting approval]
   ```

   ## Session Continuity

   Last session: [timestamp]
   Stopped at: Plan [NN-PP] created
   Next action: Review and approve plan, then run /paul:apply [plan-path]
   Resume file: [plan-path]
   ```

2. **Update ROADMAP.md** milestone status:
   - If first plan of milestone: Change "Not started" → "In progress"
   - Update phase status: "Not started" → "Planning"

3. **Report with quick continuation prompt:**
   ```
   ════════════════════════════════════════
   PLAN CREATED
   ════════════════════════════════════════

   Plan: [plan-path]
   Phase: [N] — [Phase Name]

   [plan summary - key tasks, checkpoints]

   ---
   Continue to APPLY?

   [1] Approved, run APPLY | [2] Questions first | [3] Pause here
   ```
4. **Accept quick inputs:** "1", "approved", "yes", "go" → run `/paul:apply [plan-path]`
</step>

</process>

<output>
PLAN.md at `.paul/phases/{NN}-{phase-name}/{NN}-{plan}-PLAN.md`

Example: `.paul/phases/04-workflows-layer/04-01-PLAN.md`
</output>

<error_handling>
**STATE.md missing:**
- Offer to create from ROADMAP.md inference
- Or ask user to run init-project first

**ROADMAP.md missing:**
- Cannot plan without roadmap
- Ask user to create ROADMAP.md or run init-project

**Phase dependencies not met:**
- Warn user which prior phases must complete first
- Do not create plan until dependencies satisfied
</error_handling>
