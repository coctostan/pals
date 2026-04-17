<purpose>
Create an executable PLAN.md for the current or specified phase. The plan defines objective, acceptance criteria, tasks, boundaries, and verification - everything needed for APPLY phase execution.
</purpose>

<when_to_use>
- Starting a new phase after the prior loop closed (or for the first plan)
- Creating the next executable plan from roadmap state and any carried context
- Resuming work that needs a new approved plan before APPLY
</when_to_use>

<loop_context>
Expected phase: PLAN
Prior phase: UNIFY (previous plan complete) or none (first plan)
Next phase: APPLY (after plan approval)
</loop_context>

<required_reading>
.paul/STATE.md
.paul/PROJECT.md
.paul/ROADMAP.md (read the current milestone section first; expand only to the target phase detail or broader roadmap structure when the route genuinely needs it)
.paul/PRD.md (selectively, if present and deeper product framing, deferred scope, assumptions, open questions, or dependency detail are relevant)
.paul/phases/{prior-phase}/{plan}-SUMMARY.md (if exists and relevant)
modules.yaml (installed module registry — MUST read; drives pre-plan and post-plan hook dispatch)
</required_reading>

<references>
references/plan-format.md
references/checkpoints.md (if plan will have checkpoints)
references/module-dispatch.md
templates/PLAN.md
<!-- Module references (e.g., plan type overlays) are loaded dynamically via hook dispatch from the installed registry resolved as modules.yaml -->
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

<step name="check_config_version" priority="after-preconditions">
**Check if project pals.json needs migration.**

1. Read `pals.json` in project root. If absent, skip this step.
2. Read `schema_version` field from pals.json (may be missing on older projects).
3. Read `kernel_version` from installed `modules.yaml`.
4. If `schema_version` is missing or does not match `kernel_version`:
   - Run the `migrate_pals_json` step from `init-project.md`:
     - Add missing modules, git fields, planning, preferences, integrations with defaults
     - Preserve all existing user values
     - Set `schema_version` to current `kernel_version`
     - Show migration summary
   - Continue with planning after migration completes
5. If versions match: proceed (no migration needed, zero overhead).
</step>

<step name="identify_phase">
1. Read the current milestone section in ROADMAP.md to identify the first incomplete phase, its scope/goals, and any dependencies.
2. Expand to the target phase detail only after the candidate phase is identified.
3. If multiple phases are viable, ask the user which to plan and confirm the selection.
</step>

<step name="determine_planning_posture">
**Set the planning posture before shaping the executable plan.**

1. Check `.paul/phases/{NN}-{phase-name}/CONTEXT.md` for carried `Planning Mode`, `Collaboration Level`, and `Suggested Review Path`.
2. If no collaboration metadata exists in CONTEXT.md, read `pals.json` and use `planning.default_collaboration`; fallback = `medium`.
3. Offer a per-run override:
   ```
   Planning collaboration level: {default_collaboration} (project default)
   [1] Keep {default_collaboration}
   [2] low — minimal probing, move to executable structure quickly
   [3] medium — clarify ambiguities, constraints, and success conditions
   [4] high — deeper shaping, assumptions, alternatives, and risks
   ```
4. If planning mode was not already captured, ask whether this run is exploratory or direct-requirements.
5. Apply collaboration semantics: low → only what is needed for an executable plan; medium → clarify ambiguities and open questions; high → also surface assumptions, alternatives, and edge cases that materially affect execution.
6. Apply mode semantics: exploratory → allow limited shaping before locking the plan; direct-requirements → stay close to stated requirements and resolve only what execution needs.
7. Store `collaboration_level`, `planning_mode`, and any carried `review_preference` for later review routing.
</step>

<step name="prepare_codi_seed_candidates" priority="before-pre-plan-advisory">
**Prepare bounded CODI seeds for prose-heavy scopes before advisory dispatch.**
1. Review the target phase detail plus any carried context already selected for this planning run.
2. Assemble the repo-relative source-file set that will appear in the upcoming plan context block (`<context>`):
   - Keep only explicitly named repo files from the phase detail or carried context.
   - Keep only `.ts`, `.tsx`, `.js`, and `.jsx` files as CODI source selectors.
   - Treat those paths as bounded source selectors, not final `impact` candidates.
3. Build `codi_seed_candidates` deterministically:
   - First keep extractor-friendly explicit symbol identifiers already named in the phase detail/objective.
   - If the remaining scope is still prose-heavy, do a lightweight, read-only pass over only the selected source selectors for this upcoming plan context block.
   - From each selected source file, extract only stable top-level declarations: top-level `function` declarations, top-level `class` declarations, exported named declarations, and exported `const` / arrow bindings.
   - Ignore nested declarations, type-only constructs, re-export-only barrels, installed-runtime paths, and non-code files.
4. Candidate rules:
   - Every candidate must be directly observed in the phase detail/objective, carried context, or the bounded read over selected source selectors.
   - Prefer explicit phase/objective identifiers first.
   - Then source-derived declarations, preserving source-file mention order and declaration order within each file.
   - Cap the final candidate set at 1-5 stable extracted identifiers.
5. Guardrails:
   - No semantic guessing, no invented abstractions, no codebase-wide fishing, and no reread of a previously written PLAN artifact.
   - Markdown/config-only phases may record no seeds; CODI may skip cleanly and planning continues.
6. Pass `codi_seed_candidates` forward to pre-plan advisory dispatch and later reuse them inside the existing objective/context/source-file structure. Do NOT add new PLAN template sections.
</step>
<step name="pre_plan_advisory_hooks" priority="before-scope-analysis">
**Dispatch advisory pre-plan hooks first — these inform the plan but never block.**
1. Read `modules.yaml` (installed module registry; see `references/module-dispatch.md`). If not found, emit `[dispatch] pre-plan advisory: modules.yaml NOT FOUND — WARNING` and skip dispatch.
2. Resolve installed modules for `pre-plan` whose hook description does NOT contain "block":
   - TODD (p100): scan for test files/frameworks, inject tdd_candidates
   - IRIS (p150): scan files for anti-pattern signatures, inject review_flags
   - DAVE (p200): check for CI/CD config patterns, inject deploy_warning
   - DOCS (p200): scan for stale/missing docs, inject doc_warnings
   - CODI (p220): use `codi_seed_candidates` when present; otherwise fall back to explicit phase-scope extraction, inject `blast_radius`, or safe-skip
   - RUBY (p250): check files for tech debt heuristics, inject debt_flags
3. For each: load refs, follow description, collect `context_inject`. Pass `codi_seed_candidates` to CODI when populated.
4. Output dispatch log: `[dispatch] pre-plan advisory: {MODULE(priority) → N inject keys | skip} | ...`
5. Display all advisory findings to the user.
</step>
<step name="pre_plan_enforcement_hooks" priority="after-advisory-before-scope">
**Dispatch enforcement pre-plan hooks — these can block plan creation.**
1. Resolve installed modules for `pre-plan` whose hook description contains "block":
   - DEAN (p50): run dependency audit, inject dep_warnings — block if critical
2. For each: load refs, follow description, collect `context_inject`
3. Output dispatch log: `[dispatch] pre-plan enforcement: {MODULE(priority) → N inject keys | BLOCK(reason)} | ...`
4. If any block: surface with advisory context already visible, offer fix/override/stop
5. **DEAN baseline recording (on override):** If DEAN blocked and user chose "override":
   a. MUST create `.paul/dean-baseline.json` with current severity counts:
      ```json
      {
        "created": "{ISO timestamp}",
        "acknowledged_by": "user override during plan-phase",
        "staleness_days": {from pals.json modules.dean.baseline_staleness_days, default 30},
        "severity": {current counts from audit},
        "packages": [{list of critical/high package names with versions}]
      }
      ```
   b. Display: "DEAN baseline recorded. Future plans will only block on NEW vulnerabilities."
   c. Log to STATE.md Decisions: "DEAN baseline established: {N} critical, {M} high acknowledged"
6. Pass ALL accumulated `context_inject` (advisory + enforcement) to analyze_scope
</step>

<step name="analyze_scope">
1. Review the target phase detail in ROADMAP.md rather than re-reading unrelated milestone history.
2. If `codi_seed_candidates` exist, keep them in working scope notes and reuse them inside the plan's existing objective/context/source-file text so CODI sees the same explicit names without any PLAN template change.
3. Assess change size to scale planning depth: 1-2 files with clear scope → lighter plan; 3-5 files → standard plan; 5+ files or cross-cutting work → consider splitting.
4. Target 2-3 tasks per plan; if the work needs more than 3, consider splitting into multiple plans.
5. Identify files that will be modified and whether checkpoints are needed:
   - Visual verification required? → checkpoint:human-verify
   - Architecture decision needed? → checkpoint:decision
   - Unavoidable manual action? → checkpoint:human-action
6. Set `autonomous: true` if no checkpoints are needed; otherwise `false`.
7. Default plan type is `execute`. If a pre-plan hook suggests a different type, present the suggestion to the user and let the user confirm or override it.
</step>
<step name="load_context">
1. Read `.paul/PROJECT.md` first as the hot-path brief for the core value, description, scope snapshot, top constraints, success metrics, and key decisions.
2. Read the current milestone section plus the target phase detail in `.paul/ROADMAP.md`; do not pull unrelated milestone history unless this route genuinely needs it.
3. If `.paul/PRD.md` exists, read only the sections that add deeper product framing, deferred items, assumptions, open questions, current-vs-desired-state detail, or dependency context.
4. If a prior phase exists, read its SUMMARY.md for what was built, decisions made, and deferred issues.
5. If `.paul/phases/{NN}-{phase-name}/CONTEXT.md` exists, read it as the discussion handoff and reuse any Planning Mode / Collaboration Level metadata it carries.
6. Read only the source files relevant to this phase; do not reflexively chain unrelated prior artifacts.
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
   - All file paths in <files> MUST be repo-relative (relative to the repo root)
   - NEVER use absolute paths to installed/runtime copies outside the repo:
     ✗ ~/.pi/agent/extensions/pals-hooks.ts
     ✗ ~/.claude/hooks/carl-hook.py
     ✗ ~/.carl/manifest
     ✓ drivers/pi/extensions/pals-hooks.ts
     ✓ modules/todd/references/tdd.md
     ✓ modules/walt/references/quality-runner.md
   - If the work affects an installed runtime file, the plan MUST:
     (a) Target the repo source copy in <files>
     (b) Include a deploy/install step (e.g., `bash drivers/pi/install.sh`) as a subsequent action
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
7. **Module dispatch validation:** If modules are enabled in `pals.json` and pre-plan dispatch ran, verify the plan records dispatch results (in `<module_dispatch>` section or inline). If no dispatch log was recorded, emit WARNING: "Pre-plan module dispatch produced no recorded output — verify modules.yaml was loaded."
</step>

<step name="post_plan_hooks" priority="after-plan-creation">
**Dispatch post-plan lifecycle hooks to registered modules.**
1. Read `modules.yaml` (installed module registry; see `references/module-dispatch.md`), or confirm already loaded from prerequisite read. If not found, emit `[dispatch] post-plan: modules.yaml NOT FOUND — WARNING` and skip dispatch.
2. Resolve installed modules for `post-plan` by finding `installed_modules.*.hook_details.post-plan`
3. Sort by `hook_details.post-plan.priority` ascending (lower runs first)
4. For each registered module:
   a. Load only the hook-specific `refs` listed in `hook_details.post-plan.refs`
   b. Follow the hook description from `hook_details.post-plan.description`
   c. Pass the plan path, plan content, and `context_from_pre_plan`
   d. Collect `plan_modifications` (e.g., task restructuring)
   e. Apply modifications to the plan in priority order
5. If the registry only exposes the legacy flat `hooks` list and lacks `hook_details`, warn that the install is stale and prefer regenerating `modules.yaml` before relying on fallback behavior
6. If no modules registered for `post-plan`: emit `[dispatch] post-plan: 0 modules registered for this hook`
7. Output dispatch log: `[dispatch] post-plan: {MODULE(priority) → N modifications | skip} | ...`
8. If modifications were applied: note in plan that module overlays were applied
</step>

<step name="review_plan">
Offer progressive disclosure before APPLY routing:

```
Would you like to see the plan?

[1] Quick recap
[2] Detailed recap
[3] Full plan
[4] No review needed
```

- **Quick recap:** show the goal, main tasks, major constraints, and open questions/assumptions
- **Detailed recap:** show the acceptance criteria, task structure, files, constraints, deferred items, and open questions
- **Full plan:** show the full PLAN.md artifact
- **No review needed:** continue immediately

If the user requests changes after a review, refine the plan before proceeding to APPLY routing.
Store the selected path as `review_preference`.
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
