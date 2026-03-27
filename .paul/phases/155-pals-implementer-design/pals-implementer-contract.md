# Phase 155 Design — PALS Implementer Contract

## Intent

Define a repo-controlled, PALS-native implementer path for `@tintinweb/pi-subagents` that can use a fresh subagent context without changing the authority model of PALS.

The design target is not the current generic runtime `implementer`. The design target is a new repo-owned contract that uses:
- repo-local `.pi/agents/*.md` definitions
- parent dispatch through `Agent()`
- `.paul/*` artifacts as the authoritative lifecycle record
- inline APPLY as the behavioral reference model

---

## Design Drivers

The Phase 154 audit established the constraints this contract must preserve:
- inline APPLY is still the canonical execution path today
- current generic `implementer` / `worker` prompts are not PALS-aware
- module authority currently lives in shared workflows plus installed `modules.yaml`
- Pi bounded injection is intentionally small and should stay small
- REV is already a deliberate subagent path and must not be changed by this design

This means the future implementer must be introduced as a controlled adapter around APPLY, not as a replacement lifecycle engine.

---

## Lifecycle Authority

### Authoritative Layers

1. **`.paul/*` remains the durable lifecycle truth**
   - `STATE.md` remains authoritative for current position and next action
   - PLAN files remain the execution contract
   - SUMMARY files remain the durable reconciliation artifact
   - ROADMAP / PROJECT remain the cross-session planning truth

2. **The parent APPLY workflow remains the lifecycle orchestrator**
   - task ordering
   - checkpoint handling
   - module dispatch policy
   - verification policy
   - divergence detection
   - STATE / SUMMARY updates
   - fallback decisions

3. **The subagent is an execution worker, not a lifecycle owner**
   - it may perform bounded implementation work for a task or task slice
   - it must report results back to the parent
   - it does not become the source of truth for plan progress or loop state

---

## Parent Responsibilities

The parent APPLY session keeps all responsibilities that define PALS semantics.

### 1. Plan and task control
- select when subagent routing is allowed
- choose the exact task or task slice to delegate
- preserve approved task order from PLAN.md
- stop for checkpoints instead of delegating through them blindly

### 2. Lifecycle and artifact authority
- read PLAN, STATE, and relevant context artifacts
- maintain the execution log for later UNIFY
- update `STATE.md`
- create and finalize `SUMMARY.md`
- record deviations, concerns, and decisions

### 3. Module orchestration
- load installed `modules.yaml`
- run pre-apply baselines
- decide which module semantics stay parent-only vs subagent-visible
- run post-task and post-apply enforcement/advisory hooks
- remain responsible for all blocking gate decisions

### 4. Verification authority
- own the final verification judgment for each task
- run plan-defined `<verify>` steps or validate equivalent evidence returned by the subagent
- enforce file-scope checks (`git diff --name-only -- {task files}`)
- determine PASS / PASS_WITH_CONCERNS / BLOCKED

### 5. Safety and fallback
- detect when subagent execution is unavailable, ambiguous, or non-equivalent
- decide when to retry in parent-controlled mode
- fall back to inline APPLY without losing lifecycle continuity

---

## Subagent Responsibilities

The subagent exists to provide a fresh execution window for bounded implementation work while staying inside a parent-defined contract.

### Allowed scope
- execute one task or one explicitly bounded task slice
- read the files named by the parent prompt
- modify only repo files the parent permits
- run bounded local verification relevant to the delegated task
- return a structured result to the parent

### Required outputs back to parent
The subagent must return enough structure for the parent to continue APPLY deterministically:
- what it changed
- which files it touched
- commands it ran
- verification results it observed
- blockers or unresolved concerns
- whether it believes fallback or parent follow-up is required

### Prohibited scope
- no direct authorship of `STATE.md`, `ROADMAP.md`, or lifecycle summaries as authoritative updates
- no independent checkpoint resolution
- no independent merge-gate or UNIFY decisions
- no assumption that global `implementer` semantics equal PALS semantics
- no invention of Pi-only lifecycle state

---

## Delegation Unit

The recommended delegation unit is **task-level, not whole-APPLY-level**.

That means:
- parent starts APPLY
- parent loads plan, modules, and context
- parent delegates an eligible task to a custom `pals-implementer` subagent
- parent resumes after the subagent returns
- parent performs verification, module dispatch, and state/report updates

This keeps the lifecycle boundary stable while still gaining a fresh context window for implementation-heavy work.

Whole-loop delegation would make checkpoint handling, module discipline, and state authority too implicit.

---

## Fallback

Fallback must be explicit and cheap.

The fallback target is always **inline APPLY in the parent session**.

Fallback is required when any of the following is true:
- `Agent()` / `pi-subagents` is unavailable
- repo-local agent definition is missing or invalid
- the parent cannot assemble bounded task context with confidence
- the delegated task needs interactive checkpoint handling
- the subagent returns incomplete or unverifiable results
- module or verification behavior would become weaker than inline APPLY
- the delegated run touches files outside the approved task scope

Fallback behavior:
1. keep the current APPLY session open
2. record that subagent routing was skipped or abandoned
3. continue the same task inline under the parent-controlled workflow
4. preserve the same approved plan and loop position

Fallback is a normal operating mode, not a failure of the phase design.

---

## Equivalence to Inline APPLY

A subagent-backed task is acceptable only if the parent can still judge it as behaviorally equivalent to inline APPLY.

### Equivalence requirements
A delegated task must preserve all of the following properties:
- the approved plan remains the execution contract
- parent workflow still controls task order
- required verification still runs
- module enforcement still fires at the parent boundary
- checkpoints still block in the parent
- lifecycle artifacts remain authoritative in `.paul/*`
- deviations and concerns are still captured for UNIFY

### Equivalence does **not** require
- identical prompt text to inline APPLY
- identical tool-call sequencing
- identical model choice
- identical execution location for every command

### Equivalence test
A reviewer should be able to compare inline APPLY vs delegated APPLY and answer yes to these questions:
1. Did the same plan/task contract govern the work?
2. Could the parent still prove what changed and why?
3. Did verification and module gates remain parent-authoritative?
4. Could the loop still continue into UNIFY without hidden state?
5. Would a resume from `.paul/*` still make sense with no access to subagent memory?

If any answer is no, the design is not equivalent enough and must fall back.

---

## Reporting Contract

The parent/subagent boundary needs a simple, reviewable reporting shape.

Recommended result fields from the subagent:
- `status`: pass | pass_with_concerns | blocked
- `task_name`
- `files_changed`
- `commands_run`
- `verification_attempted`
- `verification_results`
- `concerns`
- `fallback_recommended`
- `summary`

The parent may accept the content as plain markdown, but the semantic contract should match these fields so Phase 156 can implement deterministic parsing or structured conventions without reopening authority questions.

---

## REV Compatibility

REV remains a separate, deliberately narrow subagent path.

This design must not:
- change `code-reviewer` dispatch behavior
- repurpose REV config as generic implementer config
- blur implementation execution and review responsibilities

The future implementer may borrow patterns from REV:
- repo-owned prompt assembly
- optional model override layering
- graceful degradation when `Agent()` is unavailable

But it must remain a separate contract.

---

## Non-Goals

### Non-Goals
- making the generic runtime `implementer` authoritative for PALS APPLY
- turning Pi extension state into workflow truth
- pushing all module logic into the subagent
- replacing inline APPLY as the reference model
- changing REV semantics or merge-gate behavior
- redesigning shared PLAN/APPLY/UNIFY artifacts around Pi-specific runtime assumptions
- requiring every subagent type in Pi to become PALS-aware

---

## Recommended Contract Statement

The future `pals-implementer` should be treated as:

> a repo-controlled, task-bounded execution subagent dispatched by the parent APPLY workflow through `Agent()`, where the parent retains lifecycle, verification, module, and artifact authority, and where inline APPLY remains the fallback and equivalence reference.

That is the narrowest design that satisfies the audit findings without weakening PALS lifecycle discipline.
