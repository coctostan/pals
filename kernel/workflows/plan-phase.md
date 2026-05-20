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
Routine bounded inputs:
- `.paul/STATE.md` — `## Current Position`, `## Loop Position`, and `## Session Continuity` windows only.
- `.paul/ROADMAP.md` — current milestone section, then target phase detail only.
- `modules.yaml` — installed registry for pre-plan/post-plan dispatch.

Conditional inputs:
- `.paul/PROJECT.md` — smallest useful hot-brief window when STATE/ROADMAP lacks project value, constraints, metrics, or focus.
- `.paul/PRD.md` — only when product framing, deferred scope, assumptions, questions, or dependencies affect execution.
- Prior SUMMARY files — only for direct dependencies, decisions, or carried outputs.
</required_reading>

<hot_artifact_loading>
For hot `.paul/*` artifacts, locate the needed heading, marker, phase row, plan ID, status line, or section label first and read the smallest useful bounded window.

Routine PLAN loading starts with bounded STATE slices plus the current ROADMAP milestone/target phase slice. Full hot-artifact reads are fallback only for missing/contradictory fields, repair, migration, lifecycle writes, audits, or whole-artifact validation.
</hot_artifact_loading>

<references>
kernel/references/plan-format.md
kernel/references/checkpoints.md (if plan will have checkpoints)
kernel/references/module-dispatch.md
kernel/references/context-management.md
kernel/templates/PLAN.md
<!-- Module references (e.g., plan type overlays) are loaded dynamically via hook dispatch from the installed registry resolved as modules.yaml -->
</references>

<process>

<step name="load_plan_state_bounded" priority="first">
1. Confirm PLAN readiness from bounded STATE windows:
   - Locate `## Current Position`; read normally ≤20 lines for phase, status, blockers, and next action.
   - Locate `## Loop Position`; read normally ≤12 lines for PLAN/APPLY/UNIFY markers.
   - Locate `## Session Continuity` only when needed for plan path, carried context, or contradictions.
2. If STATE shows APPLY/UNIFY still open, stop and route closure before planning.
3. PLAN is read-only for source files; only plan/lifecycle artifacts may change.
</step>

<step name="identify_target_phase" priority="after-state">
1. Read ROADMAP current milestone section plus the target phase detail only.
2. If multiple phases are viable, ask the user to select one.
3. Read completed-history archives only for a concrete dependency, regression, or decision record.
4. If ROADMAP is bloated/malformed, read only enough to route repair through `roadmap-management.md`.
</step>

<step name="check_config_version" priority="after-target-phase">
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

<step name="determine_planning_posture">
1. Use carried CONTEXT metadata or `planning.default_collaboration` without prompting for routine direct-requirements phases.
2. Prompt only when the phase is ambiguous, exploratory, high-risk, checkpointed, or the user asks to override.
3. Apply levels: low = minimal probing; medium = resolve execution ambiguities; high = surface material assumptions, alternatives, and risks.
4. Store `collaboration_level`, `planning_mode`, and any `review_preference`.
</step>

<step name="prepare_codi_seed_candidates" priority="before-pre-plan-advisory">
1. Build `codi_seed_candidates` only from explicit TS/JS selectors already selected for the plan context.
2. Extract at most 1–5 stable top-level identifiers from those bounded selectors; do not infer, search broadly, or read a written PLAN.
3. Markdown/config/shell-only phases record no seeds and CODI skips cleanly.
4. Pass any seeds to pre-plan advisory dispatch and reuse them only in existing PLAN objective/context/source-file text.
</step>
<step name="pre_plan_advisory_hooks" priority="before-scope-analysis">
**Dispatch advisory pre-plan hooks via `kernel/references/module-dispatch.md`; advisory output informs the plan and never blocks.**

Call-site contract:
- Hook: `pre-plan` advisory modules whose hook description does NOT contain "block".
- Required local modules/output: TODD `tdd_candidates`, IRIS `review_flags`, DAVE `deploy_warning`, DOCS `doc_warnings`, CODI `blast_radius` using `codi_seed_candidates` when present, RUBY `debt_flags`.
- Context: planned `files_modified`, phase scope, and prepared CODI seeds.
- Required evidence: `[dispatch] pre-plan advisory: ...`; if registry resolution fails, `[dispatch] pre-plan advisory: modules.yaml NOT FOUND — WARNING`.
- Display all findings and pass accumulated `context_inject` to scope analysis.
</step>
<step name="pre_plan_enforcement_hooks" priority="after-advisory-before-scope">
**Dispatch blocking pre-plan hooks via `kernel/references/module-dispatch.md`; advisory context must already be visible.**

Call-site contract:
- Hook: `pre-plan` enforcement modules whose hook description contains "block".
- Required local module/output: DEAN (p50) dependency audit and `dep_warnings`; critical/high findings may block plan creation.
- Required evidence: `[dispatch] pre-plan enforcement: ...` with PASS/BLOCK detail.
- On block: offer fix/override/stop. On DEAN override, create `.paul/dean-baseline.json` with current severity counts, packages, ISO timestamp, acknowledgement, and staleness window; log the decision in STATE.md.
- Pass ALL advisory + enforcement `context_inject` to `analyze_scope`.
</step>

<step name="analyze_scope">
1. Size from target phase + dispatch context: 1–2 clear files = light; 3–5 = standard; 5+ or cross-cutting = split candidate.
2. Target 2–3 tasks.
3. Set `files_modified`, checkpoint needs, `autonomous`, and plan type.
4. Reuse `codi_seed_candidates` only in existing objective/context/source-file text.
</step>

<step name="load_context_selectively">
1. PLAN context includes only selected STATE/ROADMAP slices, direct prior SUMMARY dependencies, and relevant source files.
2. Read PROJECT/PRD only when needed for purpose, constraints, assumptions, or dependencies.
3. Use archive labels/indexes unless concrete dependency requires detail.
4. If ROADMAP has completed-history bloat, note repair without loading it.
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
1. Create `.paul/phases/{NN}-{phase-name}/`.
2. Write `{NN}-{plan}-PLAN.md` from the template with required frontmatter and sections.
3. Every task needs repo-relative `<files>`, specific `<action>`, programmatic `<verify>`, and AC-linked `<done>`.
4. For installed-runtime effects, edit repo source only and include install/deploy validation; never plan direct home-directory edits.
</step>

<step name="validate_plan">
1. Check required frontmatter/sections.
2. Ensure ACs are testable and tasks satisfy Files + Action + Verify + Done.
3. Confirm boundaries and checkpoint placement.
4. Ensure `<module_dispatch>` records pre-plan evidence, or warn that dispatch output is missing.
</step>

<step name="post_plan_hooks" priority="after-plan-creation">
**Dispatch post-plan lifecycle hooks via `kernel/references/module-dispatch.md`.**

Call-site contract:
- Hook: `post-plan`; current required module: TODD, which may restructure test-driven plans or suggest TDD conversion when existing tests cover the planned files.
- Context: plan path, plan content, and `context_from_pre_plan`.
- Outputs: ordered `plan_modifications` applied to PLAN.md, plus an inline note when overlays changed the plan.
- Required evidence: `[dispatch] post-plan: ...`; if no modules are registered, emit `[dispatch] post-plan: 0 modules registered for this hook`; if registry resolution fails, emit `[dispatch] post-plan: modules.yaml NOT FOUND — WARNING`.
</step>

<step name="review_plan">
Default to a compact recap unless detail is requested. Preserve explicit choices:
```
Plan created: [plan-path]
Goal: [one-line goal]
Tasks: [N] ([short task names])
Constraints: [major constraints]

Review: [1] Quick recap | [2] Detailed recap | [3] Full plan | [4] No review needed
```
If changes are requested, refine the plan before APPLY routing. Store `review_preference`.
</step>


<step name="update_state" priority="required">
**Required lifecycle write.**
1. Update STATE Current Position with milestone, phase, plan, status, last activity, next action, and progress.
2. Update Loop Position to `PLAN ✓ / APPLY ○ / UNIFY ○`.
3. Update Session Continuity with last session, stopped-at, next action, resume file, and compact resume context.
4. Update ROADMAP milestone/phase status: first plan starts the milestone if needed; target phase becomes Planning.
5. Report concise success with plan path, phase, key tasks/checkpoints, and apply choices: `[1] Approved, run APPLY | [2] Questions first | [3] Pause here`.
</step>

</process>

<output>
PLAN.md at `.paul/phases/{NN}-{phase-name}/{NN}-{plan}-PLAN.md`

Example: `.paul/phases/04-workflows-layer/04-01-PLAN.md`
</output>

<error_handling>
**STATE.md missing:** infer only if safe from ROADMAP; otherwise ask user to repair/init.
**ROADMAP.md missing:** stop; planning requires roadmap context.
**Phase dependencies unmet:** name the unmet dependency and stop until resolved.
</error_handling>
