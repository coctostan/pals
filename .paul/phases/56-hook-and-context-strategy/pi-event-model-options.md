# Pi Event Model Options

## Purpose
This document evaluates how the Pi adapter should handle PALS workflow-state injection during v2.3 Phase 56.

It is grounded in three constraints established by Phases 54 and 55:
- `.paul/*` artifacts remain the authoritative lifecycle truth
- Pi-native behavior should stay in the adapter layer
- context injection should become more deliberate without creating prompt bloat or a hidden Pi-only state machine

---

## 1. Current-state baseline

### Current extension behavior in code
The current Pi extension lives in `drivers/pi/extensions/pals-hooks.ts`.

Its actual behavior is small and understandable:
- registers `/paul-*` slash commands via `pi.registerCommand()`
- maps each command to a canonical Pi skill invocation by forwarding `/skill:paul-*` with `pi.sendUserMessage()`
- listens to `session_start` and reads `.paul/STATE.md` to surface a short notification
- listens to `context` and conditionally injects a small workflow summary into the message array

### State parsing behavior
`parsePalsState()` reads `.paul/STATE.md` and extracts only three workflow signals:
- `Phase:`
- the loop row under `PLAN ──▶ APPLY ──▶ UNIFY`
- `Next action:`

This means the adapter currently depends on durable shared artifacts for truth, which is architecturally correct, but it also means the runtime context model is narrow.

### Activation and injection behavior
The `context` hook currently:
1. inspects only the last five message contents
2. joins them into one string
3. checks a regex for `paul-(plan|apply|unify|resume|fix|init|status|pause|milestone|discuss|help)`
4. if matched, reparses `.paul/STATE.md`
5. appends a final message containing:
   - phase
   - loop
   - next action
   - a reminder to follow the loaded `SKILL.md`

### What this gets right
- artifact authority remains shared and durable
- commands remain wrappers over skills rather than a second workflow implementation
- the adapter is easy to audit because the behavior is small and explicit
- session start orientation and in-turn augmentation are already separated into different hooks

### What is currently shallow or inconsistent
The current implementation and surrounding docs reveal a few mismatches and weak points:

1. **Trigger quality is heuristic**
   - activation depends on recent-message regex checks rather than a stronger signal such as explicit command invocation or a better-defined pre-agent hook boundary
   - this is the main weakness identified in Phase 54

2. **Injected context is minimal**
   - only a tiny state summary is included
   - there is no distinction between orientation context and execution-context augmentation

3. **The injected message format is slightly awkward**
   - the code comment says it injects a system message, but it actually pushes `{ role: "user", content: ... }`
   - even if Pi tolerates this, the code/documentation intent is not perfectly aligned

4. **Some docs/comments still reflect an older mental model**
   - `drivers/pi/install.sh` still says Pi uses skills “not slash commands or hooks,” even though the same installer now installs `pals-hooks.ts`
   - `drivers/pi/extensions/README.md` says the `context` hook injects project state including active modules, but the code only injects phase, loop, and next action

### Current-state conclusion
The adapter is **directionally correct but underdesigned** in its event model.

It already preserves the most important architectural rule — `.paul/STATE.md` remains authoritative — but it still relies on weak activation logic and a narrow context payload. That matches the Phase 54/55 conclusion that workflow-state injection is the highest-value careful-layering problem.

---

## 2. Evaluation criteria

Each option is evaluated using the same criteria implied by the v2.2 analysis:

| Criterion | What it asks |
|-----------|--------------|
| Artifact authority | Does `.paul/STATE.md` remain the only lifecycle source of truth? |
| User value | Does the adapter make PALS feel more coherent and better timed in Pi? |
| Determinism | Is injection triggered by strong signals rather than fragile heuristics? |
| Prompt economy | Is only high-value context injected at the right moment? |
| Implementation risk | How likely is the model to create drift, ambiguity, or maintenance cost? |
| Recoverability | Can behavior be understood and reconstructed from shared artifacts plus readable adapter code? |

A good option should also keep responsibilities clearly separated:
- **commands** handle lifecycle entry and discoverability
- **events** handle orientation and targeted runtime augmentation
- **shared artifacts** hold durable workflow truth
- **Pi runtime state** may help with convenience later, but must not be required for correctness

---

## 3. Option A — Keep the `context`-centric model and refine it

### Summary
Retain `context` as the primary injection surface, but improve its heuristics, payload selection, and formatting.

### What this would look like
- keep `session_start` for initial orientation notifications
- keep `context` as the main place where workflow context is appended to active conversations
- strengthen activation beyond the current last-five-messages regex
- inject slightly richer structured state when PALS work is clearly active
- possibly derive activation from recent explicit `/paul-*` or `/skill:paul-*` usage instead of generic string matches alone

### Advantages
- smallest delta from the current adapter
- likely lowest implementation cost
- preserves the already-working split between session orientation and in-turn augmentation
- stays strongly artifact-compatible as long as `.paul/STATE.md` remains the input

### Drawbacks
- still makes the `context` hook do most of the conceptual work
- may remain somewhat reactive and message-heuristic-driven even after improvement
- can easily slide into “inject on lots of turns” behavior if not tightly bounded
- does not fully answer the design pressure from Phase 54 around whether `before_agent_start` should own some responsibility

### Risk profile
**Medium**

The main risk is not correctness, but settling for an incremental improvement that leaves the architecture underspecified.

### Fit with v2.2 findings
This option improves the current weakness, but only partially. It is safer than a big redesign, yet it may be too conservative for the highest-ranked recommendation.

---

## 4. Option B — Move primary workflow injection to `before_agent_start`

### Summary
Treat `before_agent_start` as the main lifecycle injection point, using it to attach PALS workflow context before the agent begins work on a turn or command.

### What this would look like
- keep `session_start` for one-time orientation
- move most runtime state injection from `context` to `before_agent_start`
- use `before_agent_start` to detect whether the upcoming turn is PALS-related and, if so, inject a concise artifact-derived summary before agent execution begins
- reserve `context` for little or no workflow-state work

### Advantages
- conceptually stronger timing boundary than late message inspection
- may produce cleaner “inject right before work starts” behavior
- reduces dependence on retroactive parsing of the recent message window
- better matches the desire for deliberate event architecture instead of heuristic augmentation

### Drawbacks
- puts more pressure on a single pre-agent event whose exact ergonomics may vary with the actual Pi runtime model
- may still need a command-derived or message-derived signal to know whether the turn is truly PALS-related
- if used too aggressively, can inject context on turns where it is not actually needed
- can become harder to reason about if it silently performs broad augmentation without clear activation rules

### Risk profile
**Medium-High**

This is a promising direction, but it increases architectural commitment. If the activation logic is not sharply defined, the adapter could become more magical without becoming more precise.

### Fit with v2.2 findings
This option directly addresses the documented concern that the current event architecture has not yet been optimized. But by itself it does not solve the full responsibility split between orientation, activation, and targeted prompt shaping.

---

## 5. Option C — Hybrid event model with explicit responsibility split

### Summary
Use a hybrid strategy where different Pi surfaces own different jobs:
- `session_start` handles lightweight orientation
- command routing provides the strongest activation signal when users enter through `/paul-*`
- a pre-agent surface such as `before_agent_start` decides whether a PALS turn needs augmentation
- `context` is used narrowly, only when a small additional prompt-shaped summary is still helpful

### Proposed responsibility split

#### 1. `session_start` → orientation only
Use `session_start` to:
- detect a PALS project
- show phase/loop/next-action visibility via lightweight notification or future UI surfaces
- avoid heavy prompt injection

#### 2. Command invocation → explicit workflow activation signal
When `/paul-*` commands forward to `/skill:paul-*`, the adapter should treat this as a strong signal that PALS workflow help is relevant.

This is stronger than the current heuristic because it reflects an actual lifecycle entry surface rather than inferred intent from free text.

#### 3. `before_agent_start` → primary decision point for targeted injection
Use `before_agent_start` as the place to answer:
- is this turn clearly PALS-related?
- if yes, what is the minimum artifact-derived context needed now?
- should the injected payload be an orientation summary, an execution summary, or nothing?

This makes injection deliberate and time-bounded.

#### 4. `context` → narrow fallback or final shaping layer
Keep `context` only for small, well-bounded augmentation when needed, rather than as the main architecture.

Examples:
- attach a concise workflow summary if the turn is clearly inside an active PALS sequence and pre-agent context alone is insufficient
- avoid using `context` as a broad regex-driven “maybe inject” surface on every turn

### Advantages
- best separation of concerns
- strongest path away from shallow regex heuristics without requiring Pi-only lifecycle truth
- allows command-driven certainty where available and event-time judgment where needed
- preserves the useful parts of the current adapter while clarifying what each event is for
- aligns closely with the ideal-state language from Phase 54: artifact reads for durable truth, event-timed injection for relevance, optional runtime convenience only at the edge

### Drawbacks
- more design work than a simple `context` refinement
- requires discipline to keep the responsibility boundaries crisp
- slightly higher implementation complexity because more than one event surface participates

### Risk profile
**Medium**

This option is more ambitious than Option A, but safer than a monolithic `before_agent_start` redesign because it avoids making one event carry every concern.

### Fit with v2.2 findings
This option best matches the combined guidance from:
- Phase 54 ideal-state model
- Phase 54 gap analysis calling for stronger activation and more intentional timing
- Phase 55 ranking of workflow-state injection redesign as the top careful-layering opportunity
- the roadmap principle that sensitive runtime improvements need explicit guardrails

---

## 6. Comparative assessment

| Option | Artifact authority | User value | Determinism | Prompt economy | Implementation risk | Overall |
|--------|--------------------|------------|-------------|----------------|---------------------|---------|
| A. Refined `context`-centric | Strong | Medium | Medium-Low | Medium | Medium | Good incremental fix, but likely not enough |
| B. `before_agent_start`-led | Strong if disciplined | High | High | Medium-High | Medium-High | Strong idea, but too concentrated in one surface |
| C. Hybrid responsibility split | Strong | Very High | High | High | Medium | Best balance of native fit and compatibility safety |

### Why Option C scores highest
Option C is strongest because it solves the real architectural problem rather than just moving it around.

The problem is not merely “which Pi hook is best.” The real question is how to assign different kinds of workflow help to the right surfaces without creating hidden truth or noisy prompts.

Option C answers that clearly:
- `session_start` gives orientation
- commands give explicit activation when available
- `before_agent_start` makes the main injection decision
- `context` becomes a narrow supporting tool instead of the whole strategy

---

## 7. Recommendation

### Recommended direction
**Choose Option C: a hybrid event model with explicit responsibility split.**

### Recommended architecture
1. Keep `.paul/STATE.md` as the only authoritative lifecycle source
2. Keep `/paul-*` commands as convenience wrappers over canonical skills
3. Use command invocation and other strong turn signals to mark likely PALS activity
4. Move primary runtime injection decisions to `before_agent_start`
5. Reduce `context` to a narrow, well-bounded augmentation role or fallback role
6. Keep `session_start` focused on orientation and visibility, not large prompt payloads

### What should remain command-driven
- lifecycle entry and discoverability
- future command selectors/helpers
- explicit invocation of PALS workflows

### What should belong in event hooks
- project detection
- timing-sensitive context injection
- lightweight lifecycle visibility and orientation
- context shaping based on authoritative artifact state

### What should explicitly stay out of the adapter
- canonical workflow semantics
- durable lifecycle state beyond `.paul/*`
- Pi-only approval semantics that differ from the shared workflow files
- hidden session logic required to resume or audit work

---

## 8. Guardrails for later implementation

Any APPLY implementation based on this recommendation should preserve all of the following:

1. **Artifact authority guardrail**
   - `.paul/STATE.md` remains authoritative for phase, loop, and next action
   - Pi runtime logic may read and summarize state, not redefine it

2. **Prompt-economy guardrail**
   - inject only the smallest context needed for the current PALS moment
   - prefer structured summaries over verbose workflow restatements

3. **Activation-quality guardrail**
   - prefer explicit command or strong lifecycle signals over loose text regex heuristics
   - if heuristics remain, they should be secondary and clearly bounded

4. **Recoverability guardrail**
   - adapter behavior should remain legible in code and explainable in docs
   - no hidden Pi-only mechanism should be necessary to understand why context was injected

5. **Scope guardrail**
   - Phase 56 should define strategy only
   - command ergonomics belong to Phase 57
   - wording/docs cleanup belongs to Phase 58

---

## 9. Implementation implications for a future APPLY plan

A later implementation plan should likely include work such as:
- defining an explicit activation model for PALS-related turns
- refactoring `pals-hooks.ts` so each event has one clear responsibility
- correcting the injected-message role/comment mismatch
- aligning extension docs and installer comments with the implemented event architecture
- adding lightweight verification notes for how the new injection model should behave during `/paul-plan`, `/paul-apply`, and resume flows

The implementation should be judged successful if it makes PALS feel more coherent in Pi while remaining fully understandable from:
- shared artifacts
- readable adapter code
- accurate adapter documentation
