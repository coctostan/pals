# Phase 56 Report — Pi Hook and Context Strategy

## Decision summary

### Recommendation
Adopt a **hybrid Pi event model** for PALS workflow-state injection.

This model should:
- keep `session_start` for lightweight project orientation
- treat explicit `/paul-*` command use as the strongest workflow-activation signal when available
- use `before_agent_start` as the primary decision point for targeted artifact-derived context injection
- keep `context` only as a narrow supporting or fallback shaping surface

### Why this is the recommendation
This is the best balance of:
- native Pi fit
- stronger timing and activation discipline
- prompt economy
- artifact-compatibility safety
- maintainability of the adapter

It improves the current extension architecture without turning the adapter into a second lifecycle engine.

---

## Problem being solved

The current Pi adapter is already architecturally safe in one important way: it reads `.paul/STATE.md` rather than inventing a Pi-only workflow truth source.

But the runtime interaction model is still too shallow:
- workflow activation depends on recent-message regex matching
- the injected payload is minimal and generic
- event responsibilities are not fully clarified
- some docs/comments still reflect an older skills-only mental model

This creates the “basic wrapper” feel identified in v2.2.

The goal of this phase is therefore not to redesign PALS itself.
It is to make the **Pi shell around PALS** more deliberate, better timed, and easier to reason about.

---

## Current-state diagnosis

The current adapter behavior is split across two hooks:
- `session_start` for notification/orientation
- `context` for workflow-state injection

That split is directionally correct, but the `context` hook currently carries too much conceptual ambiguity.
It is doing the most important runtime adaptation work while relying on weak activation logic.

The main issue is not simply that `context` is used.
The issue is that the adapter still lacks a clearly defined responsibility model for:
- orientation
- activation
- prompt shaping
- lifecycle visibility

---

## Chosen target architecture

### 1. `session_start` owns orientation
Use `session_start` to:
- detect whether the current project is a PALS project
- surface phase / loop / next-action awareness
- provide lightweight UI feedback only

This hook should help users orient, not dump large prompt context.

### 2. Command entry owns the strongest explicit activation signal
When a user invokes `/paul-*`, the adapter already knows they are entering a PALS lifecycle flow.

That signal should become part of the event strategy:
- command usage should be treated as higher confidence than generic message-text inference
- command routing should remain a wrapper over canonical skills, not a new workflow implementation

### 3. `before_agent_start` owns primary injection decisions
Use `before_agent_start` as the main place to decide:
- whether the upcoming turn is truly PALS-related
- whether context injection is needed at all
- which minimal artifact-derived summary is appropriate for the moment

This should become the primary runtime decision boundary because it is better aligned with turn execution than late message-window heuristics.

### 4. `context` becomes a narrow supporting surface
Keep `context` only for limited purposes such as:
- adding a very small final workflow summary when a clearly active PALS turn still benefits from it
- serving as a fallback shaping layer if `before_agent_start` alone cannot cleanly express the needed augmentation

The important change is conceptual: `context` should no longer be the default architectural center of workflow-state injection.

---

## Guardrails

The implementation must preserve all of the following guardrails.

### Guardrail 1 — `.paul/*` remains authoritative
- `.paul/STATE.md` remains the source of truth for current phase, loop, and next action
- PLANs, SUMMARYs, ROADMAP, and PROJECT remain the durable workflow record
- Pi runtime behavior may read, summarize, and present this state only

### Guardrail 2 — No hidden Pi-only lifecycle state machine
- Pi may hold transient convenience signals if needed later
- Pi must not become the only place where workflow position or lifecycle truth is known
- resume, audit, and cross-harness continuity must remain possible from shared artifacts alone

### Guardrail 3 — Injection must be minimal and purposeful
- inject the smallest useful summary for the current moment
- do not restate large workflow documents in prompt context
- prefer structured summaries over verbose narrative

### Guardrail 4 — Activation logic should prefer strong signals
- explicit command invocation should outrank heuristic text matching
- if heuristics remain, they should be secondary and tightly bounded
- avoid “always maybe inject” behavior across unrelated turns

### Guardrail 5 — Adapter code must stay legible
- each event should have one clear job
- documentation and comments must match real behavior
- the event model should be explainable to maintainers without reverse-engineering hidden interactions

---

## Why other options were not chosen

### Why not keep a refined `context`-centric model?
That path is safe and incremental, but it does not fully solve the design problem.
It improves the current behavior without clearly reassigning responsibilities.

### Why not move everything to `before_agent_start`?
That would be cleaner than the current heuristic model in some ways, but it concentrates too much responsibility in one surface.
A hybrid split is safer because it distinguishes orientation, explicit activation, and prompt shaping instead of collapsing them.

---

## Recommended trigger model

A future implementation should follow an activation ladder like this:

1. **Explicit command signal**
   - `/paul-*` or forwarded `/skill:paul-*`
   - highest-confidence indicator of active PALS intent

2. **Current artifact state signal**
   - `.paul/STATE.md` indicates an active plan, pending checkpoint, or obvious lifecycle continuation need

3. **Bounded heuristic signal**
   - only if needed, limited textual heuristics may detect likely PALS work
   - these should be fallback logic, not the main architecture

This model preserves flexibility without making fuzzy message matching the main engine.

---

## Recommended context payload strategy

When injection is warranted, the adapter should prefer a concise structured payload such as:
- current milestone / phase
- loop position
- current plan path if relevant
- next action
- only the smallest additional routing hint needed for the present turn

It should generally avoid:
- long restatements of workflow documents
- copying large portions of `.paul/STATE.md`
- injecting context on every turn just because PALS exists in the repo

---

## Success signals for implementation

A later implementation should be considered successful if:
- PALS turns in Pi feel more coherent and intentional
- lifecycle context appears at the right time more often than today
- unrelated turns do not accumulate unnecessary workflow prompt mass
- users can still understand the system by reading `.paul/*` plus the adapter code/docs
- no Pi-only lifecycle truth is required for resume or audit

---

## Suggested implementation outline for a later APPLY plan

### Step 1 — Refactor event responsibilities
- separate orientation, activation, and injection responsibilities in `drivers/pi/extensions/pals-hooks.ts`
- make the event-role split explicit in code comments and function structure

### Step 2 — Add an explicit activation model
- treat command invocation as a first-class activation signal
- design `before_agent_start` logic around strong signals plus bounded fallbacks

### Step 3 — Redesign the injected payload
- define one concise structured payload format
- ensure it is derived from shared artifacts only
- remove or reduce ad hoc message-window shaping logic

### Step 4 — Correct code/doc drift
- fix the injected-message role/comment mismatch if still present
- update `drivers/pi/extensions/README.md`
- update installer comments so they reflect the extension-enabled architecture accurately

### Step 5 — Validate against core lifecycle flows
Test the new strategy against:
- `/paul-resume`
- `/paul-plan`
- `/paul-apply`
- milestone transitions
- non-PALS turns in the same project

The implementation should prove both relevance and restraint.

---

## Relationship to later phases

This recommendation intentionally leaves the following work for later phases:
- **Phase 57**: command routing and discoverability improvements
- **Phase 58**: adapter consistency and wording cleanup

Those phases should build on this strategy rather than redefining it.

---

## Final decision

For v2.3 Phase 56, the recommended direction is:

> **Use a hybrid Pi event model in which `session_start` handles orientation, command entry provides strong activation signals, `before_agent_start` becomes the primary workflow-context decision point, and `context` is reduced to a narrow supporting role — all while keeping `.paul/*` authoritative.**

That is the clearest path to a more Pi-native PALS experience without sacrificing portability or artifact-first lifecycle truth.
