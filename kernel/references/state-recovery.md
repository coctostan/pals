<state_recovery>

## Purpose

Non-destructive recovery when STATE.md drifts from actual project state. STATE.md is the live project state file — when it falls out of sync with reality, this playbook restores accuracy without losing accumulated context.

## Detecting State Drift

Symptoms that STATE.md has drifted:

| Symptom | Likely Cause |
|---------|-------------|
| STATE says APPLY complete but planned files are unchanged | Session ended mid-apply without state update |
| Loop position shows PLAN ✓ but no PLAN.md exists in phase directory | Plan was deleted or never written |
| Progress percentages don't match completed plan count | Manual edit or missed unify update |
| Git State section shows old commit but recent commits exist | Multiple sessions without state refresh |
| Session Continuity points to non-existent resume file | Handoff archived or file moved |

## Recovery Steps

Execute in order. Each step is non-destructive — it reads artifacts to reconstruct truth.

### Step 1: Determine True Loop Position from Artifacts

```bash
# List all PLAN and SUMMARY files in current phase
ls .paul/phases/{current-phase}/*-PLAN.md *-SUMMARY.md 2>/dev/null
```

**Interpretation:**
- PLAN exists, no SUMMARY → loop is at PLAN ✓, APPLY ○ (or mid-apply)
- PLAN + SUMMARY both exist → loop complete (PLAN ✓, APPLY ✓, UNIFY ✓)
- Neither exists → phase not started, loop at PLAN ○
- Multiple PLANs, fewer SUMMARYs → count matched pairs to find current plan

### Step 2: Check Git Log for Actual Work

```bash
# Recent commits show what was actually built
git log --oneline -10
# Check if planned files were modified
git diff --name-only HEAD~3
```

**Interpretation:**
- Recent `feat(phase-N):` commit → phase was completed (transition ran)
- Recent `wip(v0.X):` commit → work was saved mid-session
- No relevant commits → work may be uncommitted or not yet done

### Step 3: Reconstruct STATE.md Sections

Update each section based on artifacts found:

**Current Position:**
- Set phase/plan from artifact inventory (step 1)
- Set status from loop position
- Set last activity from most recent file modification or git commit timestamp

**Loop Position:**
- Match to artifact state: PLAN only → `✓ ○ ○`; PLAN+SUMMARY → `✓ ✓ ✓`

**Progress:**
- Count completed plans vs total plans in phase for phase percentage
- Count completed phases vs total phases in milestone for milestone percentage

**Session Continuity:**
- Point resume file to most recent PLAN.md or SUMMARY.md
- Set next action based on loop position

### Step 4: Validate Against ROADMAP.md

Cross-check reconstructed state against ROADMAP.md:
- Phase count in STATE matches ROADMAP phase list
- Milestone status matches completed phase count
- No contradictions between the two files

## What to Preserve

**Always keep:**
- `## Accumulated Context` section (Decisions, Deferred Issues, Blockers) — this is institutional memory that cannot be reconstructed from artifacts
- `### Git State` — update to current, don't delete history notes

**Safe to reconstruct:**
- `## Current Position` — derived from artifacts
- `## Loop Position` — derived from artifacts
- `## Session Continuity` — derived from most recent activity

## Anti-Patterns

**Never delete STATE.md and recreate from scratch.** The Accumulated Context section contains decisions and deferred issues that exist nowhere else. Deleting it loses project memory.

**Never run `/paul:init` to "fix" state.** Init creates a new project — it does not repair an existing one. It will overwrite PROJECT.md, ROADMAP.md, and STATE.md.

**Never assume STATE.md is wrong without checking artifacts.** Sometimes STATE.md is correct and the user's expectation is stale. Verify before modifying.

## When to Escalate

If recovery steps cannot determine true state:
- `.paul/` directory is missing critical files (PROJECT.md, ROADMAP.md)
- Phase directories have been deleted or renamed
- Git history has been rewritten (force push, rebase)

In these cases, inform the user and suggest manual reconstruction with their input rather than guessing.

</state_recovery>
