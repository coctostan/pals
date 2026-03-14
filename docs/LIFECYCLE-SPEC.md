# PALS Lifecycle Specification

This spec defines the state machine that drives PALS project execution.
Any harness adapter must implement these transitions with the same
preconditions and postconditions.

**References:** [HARNESS-PORTABILITY.md](HARNESS-PORTABILITY.md), [ADAPTER-CONTRACT.md](ADAPTER-CONTRACT.md)

---

## Loop States

| State | Description | STATE.md Status | Loop Diagram |
|-------|-------------|-----------------|--------------|
| READY | No active plan — ready to plan | Ready to plan | ○ ○ ○ |
| PLANNING | plan-phase workflow in progress | Planning | ◉ ○ ○ |
| PLANNED | Plan created, awaiting user approval | Approved (awaiting) | ✓ ○ ○ |
| APPLYING | apply-phase workflow executing | Applying | ✓ ◉ ○ |
| APPLIED | Apply complete, ready for unify | Applied | ✓ ✓ ○ |
| UNIFYING | unify-phase workflow in progress | Unifying | ✓ ✓ ◉ |
| UNIFIED | Loop closed, ready for next plan or milestone complete | Complete | ✓ ✓ ✓ |

---

## Valid Transitions

### READY → PLANNING

- **Trigger:** User invokes plan workflow (e.g., `/paul:plan`)
- **Preconditions:** STATE.md loop shows ○○○ or ✓✓✓; no active blockers
- **Postconditions:** Plan-phase workflow begins; STATE.md status updates
- **STATE.md Changes:** Status → "Planning", Loop → ◉○○

### PLANNING → PLANNED

- **Trigger:** plan-phase workflow completes successfully
- **Preconditions:** PLAN.md created in correct phase directory
- **Postconditions:** PLAN.md exists with all required sections; ROADMAP.md phase status updated to "Planning"
- **STATE.md Changes:** Status → "PLAN created, ready for APPLY", Loop → ✓○○, Plan field updated

### PLANNED → APPLYING

- **Trigger:** User explicitly approves plan (must be explicit approval, not assumed)
- **Preconditions:** PLAN.md exists and is approved; required skills loaded (if skills section exists)
- **Postconditions:** apply-phase begins executing tasks
- **STATE.md Changes:** Status → "Applying", Loop → ✓◉○

### APPLYING → APPLIED

- **Trigger:** All tasks in PLAN.md completed (or post-apply hooks finish)
- **Preconditions:** All auto tasks have PASS or PASS_WITH_CONCERNS; all checkpoints resolved
- **Postconditions:** All files_modified created/updated; post-apply hooks dispatched
- **STATE.md Changes:** Status → "Applied", Loop → ✓✓○

### APPLIED → UNIFYING

- **Trigger:** User invokes unify workflow (e.g., `/paul:unify`)
- **Preconditions:** Apply complete; STATE.md shows ✓✓○
- **Postconditions:** unify-phase begins reconciliation
- **STATE.md Changes:** Status → "Unifying", Loop → ✓✓◉

### UNIFYING → UNIFIED

- **Trigger:** unify-phase workflow completes
- **Postconditions:** SUMMARY.md created/finalized; STATE.md accumulated context updated; post-unify hooks dispatched; ROADMAP.md phase status updated
- **STATE.md Changes:** Status → "Complete", Loop → ✓✓✓

### UNIFIED → READY

- **Trigger:** transition-phase workflow OR user begins next plan
- **Preconditions:** SUMMARY.md exists for completed plan
- **Postconditions:** If more plans in phase: ready for next plan. If phase complete: ROADMAP.md updated. If milestone complete: milestone marked complete.
- **STATE.md Changes:** Reset to ○○○ for next plan, or milestone complete status

---

## Invalid Transitions

| Attempted Transition | Why It Is Invalid |
|----------------------|-------------------|
| READY → APPLYING | Cannot apply without a plan |
| READY → UNIFYING | Cannot unify without applying |
| PLANNED → UNIFYING | Cannot unify without applying first |
| APPLYING → PLANNING | Cannot re-plan while applying (must finish or stop) |
| Any state → PLANNED without going through PLANNING | Plans must be created through the plan workflow |

---

## Special: Re-plan Protocol

When major divergence is detected during APPLYING, an exceptional transition is permitted:

**APPLYING → READY**

- **Triggered by:**
  - 2+ tasks with significant deviations
  - BLOCKED task revealing wrong assumptions
  - Discovered requirements making remaining tasks invalid
- **Behavior:**
  - STATE.md records reason for re-plan
  - Previous PLAN.md preserved (not deleted)
  - Loop resets to ○○○ to allow a fresh plan

---

## Phase-Level State Machine

| Phase State | Meaning | Driven By |
|-------------|---------|-----------|
| Not started | No plans created yet | Default |
| Planning | First plan being created | plan-phase start |
| In progress | At least one plan applying/complete | apply-phase start |
| Complete | All plans in phase done + unified | Last plan unified |

---

## Milestone-Level State Machine

| Milestone State | Meaning | Driven By |
|-----------------|---------|-----------|
| Not started | No phases started | Default |
| In Progress | At least one phase in progress | First phase starts |
| Complete | All phases complete | Last phase unified + complete-milestone |

---

## Fix Loop (Side-Loop)

The fix loop is a lightweight side-loop that runs alongside the main loop.

### 3 Fix Modes

1. **Standard:** Compressed PLAN-APPLY-UNIFY in one pass. All hooks fire. Creates fix branch.
2. **Fast-forward:** Zero overhead. Skip ALL hooks. Direct fix + commit. No branch.
3. **Hotfix:** Execute first, document after. Fix → commit → retroactive UNIFY.

### Fix Loop Rules

- Fixes are side-loops, NOT phase progression
- Fix state tracked in STATE.md Session Continuity, not Current Position
- Main loop position unchanged during fix
- Fast-forward skips all module hooks by design
- No worktree isolation in fix loop (regardless of config)

---

## Artifact Obligations Per Transition

| Transition | Must Read | Must Write |
|------------|-----------|------------|
| → PLANNING | STATE.md, ROADMAP.md, PROJECT.md | — |
| → PLANNED | Prior SUMMARY.md (if dep), source files | PLAN.md, STATE.md, ROADMAP.md |
| → APPLYING | PLAN.md, STATE.md | STATE.md |
| → APPLIED | Task results | STATE.md |
| → UNIFYING | PLAN.md, apply results, STATE.md | — |
| → UNIFIED | — | SUMMARY.md, STATE.md, ROADMAP.md |

---

## Hook Dispatch Points

Hooks fire at specific lifecycle transitions. See HOOK-CONTRACT.md for full details.

| Hook | Fires During | Modules That Register |
|------|-------------|----------------------|
| pre-plan | PLANNING | DEAN, TODD, IRIS, DOCS, DAVE, RUBY |
| post-plan | PLANNING→PLANNED | TODD |
| pre-apply | PLANNED→APPLYING | TODD, WALT |
| post-task | APPLYING (per task) | TODD |
| post-apply | APPLYING→APPLIED | WALT, DEAN, DAVE, TODD, IRIS, DOCS, SKIP |
| post-unify | UNIFYING→UNIFIED | WALT, SKIP, RUBY |

---

## Portability Implications

- Loop state must be derivable from STATE.md alone — no hidden conversational context
- An adapter can determine the valid next action by reading STATE.md loop position
- Transitions are triggered by workflow invocation, not by specific command syntax
- The same `.paul/` artifacts drive the same lifecycle regardless of which harness reads them

---

*Lifecycle Specification — v2.0 Portability & Cross-Harness*

*Created: 2026-03-14*
