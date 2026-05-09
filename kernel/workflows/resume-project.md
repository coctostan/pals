<purpose>
Resume PAUL by reading the smallest required STATE windows, deriving the current loop position, and routing to exactly one next action.
</purpose>

<when_to_use>
- Starting a new session on an existing PAUL project
- Context was cleared (new conversation)
- Handoff from another session
- User asks to "continue" or "resume" PAUL work
</when_to_use>

<loop_context>
Do not assume the lifecycle position from handoffs, filenames, or prior chat.
Derive it from `.paul/STATE.md` first.
</loop_context>

<required_reading>
Start with bounded section windows in `.paul/STATE.md`, not a full-file read.

Do not load handoffs, resume files, PROJECT, ROADMAP, or archived context until STATE routing shows they are needed.

Full-read STATE only when bounded windows are missing, contradictory, or insufficient for lifecycle write/audit/repair.
</required_reading>

<hot_artifact_loading>
When touching hot `.paul/*` lifecycle artifacts (`STATE.md`, `PROJECT.md`, `MILESTONES.md`, `ROADMAP.md`), locate the relevant heading, marker, phase row, plan ID, resume file, status line, or section label first and read the smallest useful bounded window.
Escalate to a full read only as an explicit fallback when fields are missing or contradictory, or when the task requires whole-artifact rewrite, audit, repair, migration, lifecycle write, or whole-artifact validation.
</hot_artifact_loading>

<references>
@references/context-management.md
@references/loop-phases.md
</references>

<process>

<step name="verify_paul_exists" priority="first">
1. Verify `.paul/STATE.md` exists.
2. If not found:
   - "No PAUL project found. Run /paul:init first."
   - Exit workflow.
3. If found: continue to bounded STATE loading.
</step>

<step name="load_state_bounded" priority="after-verify">
1. Locate `## Current Position`; read the smallest useful window, normally ≤20 lines.
   Extract phase number/name, plan ID/path if present, status, and blockers.
2. Locate `## Loop Position`; read the smallest useful window, normally ≤12 lines.
   Extract PLAN/APPLY/UNIFY completion markers and inline status note.
3. Locate `## Session Continuity`; read the smallest useful window, normally ≤18 lines.
   Extract stopped-at, next action, resume file, and resume context.
4. If required facts are missing or contradictory, expand to the nearest surrounding section window first.
5. Full-read STATE only if bounded windows cannot resolve the contradiction or whole-artifact validation is required.
6. Store these STATE facts as the routing source of truth.
</step>

<step name="resolve_optional_handoff_context" priority="after-load-state">
Use STATE facts from `load_state_bounded` to decide whether extra context is needed.

1. If the user supplied a handoff or resume path:
   - validate that path exists;
   - mark it as selected context.
2. Else if STATE `Resume file` names a handoff, PLAN, or SUMMARY:
   - mark that path as selected context only if needed to explain stopped-at, next action, blocker, or routing.
3. Else if STATE facts are missing or contradictory:
   - inspect active `.paul/HANDOFF*.md` files only as a fallback;
   - choose the most relevant active handoff by phase/plan/status, not merely the newest file.
4. Archived handoffs are not routine context.
   Use an archived handoff only when the user supplied it, STATE points to it, or no adequate active/STATE context exists.
5. If STATE already provides enough current context, select no handoff/resume file.
</step>

<step name="load_needed_resume_context" priority="after-resolve-optional-context">
If no extra context was selected, skip this step.

If selected context is a handoff:
1. Read only the smallest useful sections, usually:
   - `Current State`
   - `What's Next`
   - `Key Decisions / Constraints`
   - `Resume Instructions`
2. Full-read the handoff only if these sections are missing, malformed, or contradictory.
3. Extract only decisions, blockers, gaps, and next action evidence needed for routing.

If selected context is a PLAN or SUMMARY:
1. Read only the bounded status/task/result section needed to confirm routing.
2. Full-read only if bounded sections cannot resolve the current loop state.
</step>

<step name="check_config_version" priority="after-load-state">
1. If `pals.json` is absent, skip this step.
2. Read only `schema_version` from `pals.json`.
3. Read `kernel_version` from installed `modules.yaml`.
4. If `schema_version` is missing or differs from `kernel_version`, run `migrate_pals_json` from `init-project.md`, preserving existing user values.
</step>

<step name="check_git_state">
1. Resolve `GIT_WORKFLOW`:
   - `git.workflow` → use it
   - else `git.branching` → `legacy`
   - else → `none`
2. If `GIT_WORKFLOW != "github-flow"`, skip this step.
3. For github-flow, collect current branch, base branch, ahead/behind count, PR URL/state, and CI state.
4. If git/PR checks fail, keep STATE-based routing and report git state as unavailable.
</step>

<step name="determine_single_action">
If github-flow git state was collected, apply overrides in this order:
1. Behind base → update branch from base, then re-push/recheck CI.
2. PR open + CI failing → fix CI failures, then recheck.
3. PR open + CI passing + reviews required → get PR reviewed.
4. PR open + CI passing + ready to merge → merge PR.

Otherwise route from STATE loop position:
- PLAN ○ → `/paul:plan`
- PLAN ✓, APPLY ○ → `/paul:apply [plan-path]`
- PLAN ✓, APPLY ✓, UNIFY ○ → `/paul:unify [plan-path]`
- All ✓ → `/paul:plan`
- Blocked → address the blocker
</step>

<step name="report_and_route">
1. Report only facts already loaded from STATE, optional selected context, and git state when collected.
2. For routine resumes, include:
   - phase/plan/status;
   - compact PLAN/APPLY/UNIFY markers;
   - stopped-at or last activity if available;
   - git state only when github-flow state was collected;
   - exactly one `NEXT` action from `determine_single_action`.
3. Do not load PROJECT, ROADMAP, handoff, or archive files only to decorate the report.
4. Expand output only for blockers, missing/contradictory STATE, selected handoff context, failed git checks, or user-requested detail.
5. Do not show numbered options.
6. End by asking the user to proceed with the single next action or provide redirecting context.
</step>

<step name="handoff_lifecycle">
Run only after the user proceeds with the selected next action.

1. If no handoff was selected and read, skip this step.
2. If the consumed handoff was already archived, leave it in place.
3. If the consumed handoff was active at `.paul/HANDOFF*.md`:
   - move only that file to `.paul/handoffs/archive/`;
   - update STATE `Resume file` only if it pointed to the old active path.
4. Do not scan for or clean unrelated/orphaned handoffs during routine resume.
5. Record only the minimal lifecycle note needed for continuity.
</step>
</process>

<output>
- Current phase/plan/status and loop position.
- Optional selected-context note only when extra context was actually loaded.
- Exactly one next action.
- Proceed/redirect prompt.
</output>

<error_handling>
**STATE windows missing or incomplete:**
- Expand to the nearest surrounding STATE section.
- Full-read STATE only if bounded windows still cannot recover required facts.
- If still incomplete, report missing fields and ask for repair guidance.

**Conflicting information:**
- Prefer STATE over handoffs, filenames, archives, and prior chat.
- Ask for clarification only when the conflict changes the next action.

**No Session Continuity:**
- Route from Current Position and Loop Position.
- Do not search archived handoffs just to add narrative context.

**Stale selected handoff:**
- Trust newer STATE facts and mention the handoff may be stale.
</error_handling>
