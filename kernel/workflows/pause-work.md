<purpose>
Create a compact active handoff and update STATE.md Session Continuity when pausing work. Preserve enough context for a fresh `/paul:resume` without copying broad project history; STATE remains the resume source of truth.
</purpose>

<when_to_use>
- Before ending a session (planned or context limit approaching)
- Switching to a different project
- Context window at DEEP or CRITICAL bracket
- User explicitly pauses work
</when_to_use>

<loop_context>
Any position in the PLAN/APPLY/UNIFY loop. PAUSE captures the current lifecycle position; it does not advance the loop.
</loop_context>

<required_reading>
Routine bounded inputs:
- `.paul/STATE.md` — Current Position, Loop Position, Session Continuity, and Git State only when present or needed.
- `kernel/references/git-strategy.md` — only for workflow-mode, pause Git State, and WIP continuity rules.

Conditional inputs:
- Current PLAN path — only when STATE or the active loop position names one.
- `.paul/PROJECT.md` — smallest useful project-name/core-value window only when needed and not already known.
</required_reading>

<hot_artifact_loading>
For hot `.paul/*` artifacts, locate the needed heading, marker, phase row, plan ID, status line, resume file, or section label first and read the smallest useful bounded window.

Routine PAUSE starts with bounded STATE slices and does not full-read PROJECT, ROADMAP, MILESTONES, archived handoffs, or prior summaries. Use full read fallback only for missing/contradictory fields, repair, migration, audit, or whole-artifact validation.
</hot_artifact_loading>

<references>
kernel/references/context-management.md
kernel/references/git-strategy.md
</references>

<process>

<step name="load_pause_state_bounded" priority="first">
1. Verify `.paul/STATE.md` exists. If missing, stop with the missing-state error.
2. Locate `## Current Position`; read the smallest useful window for phase, plan, status, blockers, and last activity.
3. Locate `## Loop Position`; read the smallest useful window for PLAN/APPLY/UNIFY markers.
4. Locate `## Session Continuity`; read the smallest useful window for existing resume file and next-action fields.
5. Resolve the latest plan path from STATE first. If STATE lacks it, inspect only the active phase directory under `.paul/phases/` and prefer the current plan ID over a repo-wide search.
6. Resolve `GIT_WORKFLOW` with the shared 3-tier contract from `kernel/references/git-strategy.md`.
7. If `GIT_WORKFLOW = "github-flow"`, collect compact branch/PR/CI/ahead-behind state using the shared pause/status recipe from `kernel/references/git-strategy.md`.
8. If `GIT_WORKFLOW != "github-flow"`, skip PR/CI/ahead-behind collection unless needed for an optional WIP commit decision.
</step>

<step name="build_compact_handoff_payload">
Build a compact handoff payload from bounded evidence already loaded in this session. Infer first; ask the user only for missing blockers, decisions, or next-action ambiguity.

Include only:
- current state: phase, plan/status, and loop markers
- completed work and in-progress work since the last durable lifecycle update
- blockers and decisions that affect resume behavior
- changed files relevant to the pause point, filtered to planned/lifecycle paths when possible
- Git State when relevant: branch/PR/CI/ahead-behind summary from the bounded GitHub Flow step
- exactly one resume action

Do not include:
- unrelated project history
- large templates or copied background sections
- archived handoff content except a short note that a prior active handoff was superseded
- raw full `git status` output when a short changed-file summary is enough
</step>

<step name="optional_wip_commit">
Run this before `write_handoff_and_state` so the handoff can record the WIP result.

1. Reuse `GIT_WORKFLOW` from `load_pause_state_bounded`; resolve it from `kernel/references/git-strategy.md` only if missing.
2. If `GIT_WORKFLOW = "none"` or there are no uncommitted changes, set `wip_result: skipped` and continue.
3. Ask the user whether to create a WIP commit.

If approved:
- Use `git add -A`.
- Commit with `wip({phase}): pause at [plan/task]`.
- For `github-flow`, commit on the current feature branch only when it is non-base. Do not create branches, open PRs, merge, or rebase in PAUSE.
- For `legacy`, follow the configured legacy WIP strategy.
- Set `wip_result` to the commit hash.

If declined or unsafe:
- Set `wip_result` to the skipped reason, such as `declined`, `base-branch`, or `commit-failed`.

`write_handoff_and_state` records `wip_result` in STATE Session Continuity and the handoff packet.
</step>

<step name="write_handoff_and_state">
1. Identify prior active handoffs matching `.paul/HANDOFF*.md`.
2. Before writing the new handoff, archive or supersede prior active handoffs:
   - Move still-relevant active handoffs to `.paul/handoffs/archive/`.
   - Delete obsolete active handoffs only when safe.
   - Record the prior-active result in `handoff_lifecycle`.
   - archived handoffs remain history; STATE remains the resume source of truth.

3. Create `.paul/HANDOFF-{YYYY-MM-DD}-{context}.md` as a compact agent packet, not a narrative template:

```markdown
# PAUL Handoff

status: [paused | blocked | context-limit]
created: [timestamp]
phase: [N of M — phase name]
plan: [plan-id/status]
loop: PLAN [✓/○] / APPLY [✓/○] / UNIFY [✓/○]
state_authority: .paul/STATE.md
resume_action: [exactly one next action]
wip_result: [skipped | commit hash | skipped reason]

git_snapshot:
  workflow: [github-flow | legacy | none]
  branch: [branch or N/A]
  base: [base or N/A]
  pr: [none | url/state]
  ci: [passing | failing | pending | N/A]
  sync: [behind/ahead or N/A]
  note: snapshot only; resume rechecks live git state when github-flow routing applies

progress:
  done:
    - [compact completed item]
  in_progress:
    - [compact in-progress item]
  blockers:
    - [none or blocker]
  decisions:
    - [resume-relevant decision only]

files:
  - path: [file]
    reason: [why relevant]

handoff_lifecycle:
  prior_active: [none | archived: path | superseded: path]
  note: archived handoffs are history; STATE remains source of truth

resume:
  command: /paul:resume
  expected_next: [must exactly match resume_action]
```

If `GIT_WORKFLOW = "none"` and git state does not affect the next action, collapse `git_snapshot` to `git_snapshot: workflow none`.

4. Update `.paul/STATE.md` `## Session Continuity` with:
   - `Last session`
   - `Stopped at`
   - `Next action`
   - `Resume file`
   - `wip_result`
   - 2–4 compact resume-context bullets

5. Ensure STATE `Next action`, handoff `resume_action`, and handoff `resume.expected_next` match exactly.
</step>

<step name="confirm">
Use contextual verbosity for routine pause confirmation: short handoff path, current loop position, `wip_result`, and exact resume action. Expand only for blockers, WIP commit failures, stale handoff cleanup, or user-requested detail.

Display:
```text
PAUL SESSION PAUSED

Handoff: .paul/HANDOFF-[date].md
STATE updated: Session Continuity
Loop: [PLAN/APPLY/UNIFY position]
WIP: [wip_result]

Resume:
  /paul:resume
Expected next:
  [exactly one resume action]
```
</step>

</process>

<output>
- Compact active handoff created in `.paul/`
- Prior active handoff archived/superseded when applicable
- `.paul/STATE.md` Session Continuity updated
- `wip_result` recorded when WIP handling ran
- User sees `/paul:resume` plus exactly one expected next action
</output>

<error_handling>
**No `.paul/` directory:**
- "No PAUL project found. Nothing to pause."

**STATE.md missing:**
- Stop without creating a normal handoff.
- Report that STATE is required because it is the resume source of truth.

**STATE.md corrupted or contradictory:**
- Stop before writing a handoff unless the user explicitly requests an emergency handoff.
- If emergency handoff is requested, mark `status: emergency`, include `state_authority: unavailable`, and keep the payload minimal.

**Git not available or WIP commit failed:**
- Set `wip_result` to the skipped/failed reason.
- Still write handoff and STATE when STATE is valid.
</error_handling>
