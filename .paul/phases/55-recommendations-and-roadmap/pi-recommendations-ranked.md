# Pi Recommendations — Ranked

## Ranking method
These recommendations are ranked using four criteria derived from Phases 53 and 54:

1. **User value** — how much the change improves the day-to-day Pi experience
2. **Artifact-compatibility safety** — how safely the change preserves shared markdown authority
3. **Implementation risk/complexity** — how much design or runtime risk the change introduces
4. **Strategic leverage** — how much the change unlocks or de-risks later Pi work

The ranking intentionally favors improvements that make PALS feel more native in Pi **without** creating Pi-only lifecycle truth.

---

## Recommendation 1 — Redesign workflow-state injection around a clearer event model

### Problem addressed
The current Pi adapter uses a valid but shallow context strategy:
- lightweight regex triggers
- only recent-message inspection
- small generic state summary

This is the highest-impact weakness because it directly affects how coherent PALS feels in Pi.

### Proposed improvement
Rework workflow-state injection so it uses a more deliberate event architecture, likely centered on a better-defined combination of:
- `context`
- `before_agent_start`
- possibly `input` or command-triggered augmentation

The goal is not to inject more text blindly; it is to inject the **right lifecycle context at the right moment** while keeping `.paul/STATE.md` authoritative.

### Expected user value
**Very high**
- stronger session coherence
- better lifecycle continuity
- more reliable awareness of current phase, plan, and next action
- reduced “basic wrapper” feel

### Implementation risk / complexity
**Medium-High**
- requires event-model design choices
- must avoid prompt bloat and duplicated truth
- needs careful testing against real PALS flows

### Artifact-compatibility posture
**Compatible with strong guardrails**
Safe if:
- `.paul/STATE.md` remains the source of truth
- Pi event logic stays additive and reconstructible from artifacts

### Recommended timing / phase bucket
**Rank #1 — careful adapter layering**

### Why it ranks here
This is the most important issue identified in Phase 54 and the highest-leverage improvement for making PALS feel truly Pi-native.

---

## Recommendation 2 — Upgrade `/paul-*` command ergonomics and discoverability

### Problem addressed
The current `/paul-*` commands are correct but minimal. They act mostly as forwarding aliases and underuse Pi’s command ergonomics.

### Proposed improvement
Strengthen the command layer while keeping skills canonical:
- improve command descriptions
- add argument completions where useful
- add discovery helpers or selector-based command browsing
- provide better command-time guidance around common lifecycle actions

### Expected user value
**Very high**
- immediate usability gains
- clearer lifecycle entry points
- better discoverability for new Pi users

### Implementation risk / complexity
**Low-Medium**
- mostly additive extension work
- limited architectural risk if commands remain wrappers

### Artifact-compatibility posture
**Strongly artifact-compatible**
This is adapter-only UX work as long as command handlers do not fork workflow semantics.

### Recommended timing / phase bucket
**Rank #2 — safe-now improvement**

### Why it ranks here
This is one of the clearest high-value, low-risk gains available to the adapter.

---

## Recommendation 3 — Add lightweight Pi-native lifecycle visibility UI

### Problem addressed
PALS is available in Pi, but not especially visible. The current adapter uses notifications, yet it does not strongly surface lifecycle state inside the UI.

### Proposed improvement
Use Pi UI primitives to make lifecycle state easier to see and revisit, for example:
- lightweight status/header indicators
- optional widgets for current phase/loop/next action
- more guided visibility around pause/resume/status moments

### Expected user value
**High**
- stronger orientation
- better resume flow
- more confidence that PALS is actively helping, not just installed

### Implementation risk / complexity
**Medium**
- UI choices must stay lightweight and non-intrusive
- requires judgment about visibility vs clutter

### Artifact-compatibility posture
**Strongly artifact-compatible**
UI can remain a pure presentation layer over `.paul/*` artifacts.

### Recommended timing / phase bucket
**Rank #3 — safe-now improvement**

### Why it ranks here
This is a major Pi-native win with relatively low compatibility risk and complements better command ergonomics.

---

## Recommendation 4 — Introduce guided checkpoint and approval affordances in Pi UI

### Problem addressed
PALS lifecycle checkpoints exist conceptually, but the Pi adapter does not yet exploit Pi’s richer interaction primitives to make those moments feel guided and native.

### Proposed improvement
Use Pi UI affordances for key lifecycle moments such as:
- plan approval
- checkpoint decisions
- resume routing
- milestone/phase transition awareness

### Expected user value
**High**
- smoother lifecycle flow
- less reliance on remembering exact text responses
- clearer transition points for users

### Implementation risk / complexity
**Medium**
- requires careful alignment with shared workflow semantics
- should not create Pi-only behavior that changes lifecycle meaning

### Artifact-compatibility posture
**Compatible with guardrails**
Safe if the UI only guides actions already grounded in shared artifacts and workflow files.

### Recommended timing / phase bucket
**Rank #4 — careful adapter layering**

### Why it ranks here
This is a meaningful usability improvement, but it should follow the more foundational context and command work.

---

## Recommendation 5 — Clean up adapter docs, comments, and help-surface consistency

### Problem addressed
Some installer comments, docs, and help text still reflect an earlier skills-only mental model, even though the adapter now includes commands and hooks.

### Proposed improvement
Align:
- installer comments
- extension README/docs
- help text
- skill-facing language
- operator-facing explanations of what is canonical vs adapter-specific

### Expected user value
**Medium**
- clearer maintenance model
- easier future audits
- better trust in the adapter’s shape

### Implementation risk / complexity
**Low**

### Artifact-compatibility posture
**Strongly artifact-compatible**
Pure clarity and maintenance work.

### Recommended timing / phase bucket
**Rank #5 — safe-now improvement**

### Why it ranks here
It is not as transformative as runtime improvements, but it is cheap, safe, and improves long-term maintainability.

---

## Recommendation 6 — Clarify and possibly expand installation scope options

### Problem addressed
The current adapter uses documented global locations but does not clearly justify whether global-only is a deliberate product strategy or just the initial implementation choice.

### Proposed improvement
Decide and document whether PALS on Pi should support:
- global-only install
- optional project-local install
- a mixed strategy depending on user intent

### Expected user value
**Medium**
- better fit for different user workflows
- cleaner mental model around install scope

### Implementation risk / complexity
**Medium**
- packaging and operational implications need thought
- may affect docs and install/uninstall behavior

### Artifact-compatibility posture
**Strongly artifact-compatible**
Packaging scope does not inherently threaten shared artifact truth.

### Recommended timing / phase bucket
**Rank #6 — safe-now improvement or bounded follow-on work**

### Why it ranks here
Useful, but less central than command/context/UI quality.

---

## Recommendation 7 — Use Pi session persistence only for bounded convenience metadata

### Problem addressed
The adapter currently avoids Pi-native persistence entirely. That protects artifact truth, but may also leave UX value unused.

### Proposed improvement
Explore small, explicitly bounded uses of Pi persistence for convenience only, such as:
- UI state helpers
- transient session annotations
- optional navigation aids

Not for:
- authoritative lifecycle status
- replacing `.paul/STATE.md`
- storing canonical phase/plan truth

### Expected user value
**Medium**
- can improve polish and convenience
- may help status/help/resume surfaces

### Implementation risk / complexity
**Medium-High**
- easy to misuse
- risk of creating state duplication if boundaries are weak

### Artifact-compatibility posture
**Sensitive**
Only safe if clearly non-authoritative.

### Recommended timing / phase bucket
**Rank #7 — careful adapter layering / later track**

### Why it ranks here
Potentially useful, but easier to get wrong than the higher-ranked recommendations.

---

## Recommendation 8 — Defer Pi-only semantic divergence to a future-state track

### Problem addressed
Some possible Pi-native enhancements could go too far and create Pi-only lifecycle semantics or truth sources.

### Proposed improvement
Make this a deliberate non-goal for near-term work:
- do not move workflow semantics into Pi TypeScript
- do not create Pi-managed lifecycle truth that competes with `.paul/*`
- do not optimize for native feel at the cost of cross-harness coherence

### Expected user value
**Indirect but important**
- protects PALS identity
- keeps future work coherent
- prevents architectural drift

### Implementation risk / complexity
**Low** as a recommendation, **High** if violated

### Artifact-compatibility posture
**Essential safeguard**

### Recommended timing / phase bucket
**Rank #8 — future-state guardrail**

### Why it ranks here
It is less a feature than an important strategic constraint on all later work.

---

## Consolidated ranking table

| Rank | Recommendation | User Value | Risk | Compatibility Posture | Timing Bucket |
|------|----------------|-----------|------|------------------------|---------------|
| 1 | Redesign workflow-state injection around a clearer event model | Very High | Medium-High | Compatible with guardrails | Careful layering |
| 2 | Upgrade `/paul-*` command ergonomics and discoverability | Very High | Low-Medium | Strongly compatible | Safe-now |
| 3 | Add lightweight Pi-native lifecycle visibility UI | High | Medium | Strongly compatible | Safe-now |
| 4 | Introduce guided checkpoint and approval affordances in Pi UI | High | Medium | Compatible with guardrails | Careful layering |
| 5 | Clean up adapter docs, comments, and help-surface consistency | Medium | Low | Strongly compatible | Safe-now |
| 6 | Clarify and possibly expand installation scope options | Medium | Medium | Strongly compatible | Safe-now / bounded follow-on |
| 7 | Use Pi session persistence only for bounded convenience metadata | Medium | Medium-High | Sensitive | Later careful layering |
| 8 | Defer Pi-only semantic divergence to a future-state track | Strategic | Low | Essential safeguard | Future-state guardrail |

---

## Bottom line
The recommendations point in one direction:

> **Keep the artifact-safe core exactly where it is, and invest in a better Pi-native shell around it.**

The highest-priority work is not re-architecture.
It is **better context timing, better command ergonomics, and better lifecycle visibility**.