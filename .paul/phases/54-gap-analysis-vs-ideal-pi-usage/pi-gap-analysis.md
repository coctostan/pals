# Pi Gap Analysis

## Method
This document compares the **current Pi adapter** established in Phase 53 against the **ideal artifact-compatible Pi integration model** defined for Phase 54.

For each dimension, it identifies:
- current state
- ideal state
- the actual gap
- severity
- confidence
- artifact-compatibility implications
- whether the gap is best handled as adapter-only work now, careful wrapper layering, or future-state divergence

---

## Gap severity scale

- **Critical** — materially limits whether PALS can feel like a strong Pi integration
- **High** — important deficiency that meaningfully weakens native fit or maintainability
- **Medium** — clear improvement area, but not a blocker to basic success
- **Low** — polish, hygiene, or optional enhancement

---

## 1. Skills and invocation model

### Current state
- Skills are correctly placed and named.
- They are intentionally thin wrappers over shared workflow/reference/template markdown.
- They provide Pi-native discoverability through `/skill:paul-*`.

### Ideal state
- Skills remain the canonical discoverability layer.
- Wrapper behavior stays thin, but descriptions and routing conventions are polished and consistently aligned with the command surface.

### Gap
There is **no major structural gap** in the skill model itself. The current implementation is already close to ideal.

The real remaining gap is secondary:
- skill wording and surrounding UX could better clarify when users should use `/skill:...` directly versus `/paul-*`
- the two surfaces are valid, but not yet fully harmonized as one coherent user experience

### Severity
**Low**

### Confidence
**High**

### Artifact-compatibility implications
This area is strongly artifact-compatible already because skills are wrappers over shared files.

### Best handling
**Adapter-only improvement now**
- tighten wording and cross-surface consistency
- preserve the current architectural pattern

---

## 2. Command routing and discoverability

### Current state
- `/paul-*` commands are registered correctly.
- Handlers forward to `/skill:paul-*` via `sendUserMessage()`.
- The command layer is valid but minimal.

### Ideal state
- Commands remain wrappers over canonical skill behavior.
- They also provide stronger Pi-native ergonomics such as argument completions, selection helpers, and clearer discoverability.

### Gap
The current command layer is **functionally correct but underpowered**.

What is missing relative to ideal:
- argument completions where useful
- richer command discovery patterns
- command-time guidance for lifecycle actions
- stronger integration with Pi’s command ergonomics surface

### Severity
**High**

### Confidence
**High**

### Artifact-compatibility implications
This is a strong candidate for compatibility-safe improvement because better commands can remain a pure adapter layer over shared workflow artifacts.

### Best handling
**Adapter-only improvement now**
- expand command ergonomics without changing shared artifact semantics

---

## 3. Extension event architecture

### Current state
- `session_start` is used for project detection and notification.
- `context` is used for lightweight workflow-state injection.
- The extension architecture is coherent, but sparse.

### Ideal state
- Event choice should be deliberate and stable.
- Session orientation, context augmentation, and command support should each use the best Pi event surface available.
- The extension should have a clearer event model than a mostly heuristic first pass.

### Gap
The gap is not that the current events are wrong.
The gap is that the **event architecture has not yet been optimized against Pi’s full documented runtime model**.

Open design pressure remains around:
- whether `context` is the best primary injection point
- whether `before_agent_start` should carry some responsibility
- whether a hybrid model would be cleaner and more robust

### Severity
**High**

### Confidence
**Medium-High**

### Artifact-compatibility implications
This can likely remain artifact-compatible if event logic continues to read from shared files and avoids Pi-only lifecycle truth.

### Best handling
**Careful adapter-only layering**
- this is safe to improve in Pi code, but architectural choices matter more here than in command polish

---

## 4. Context injection and workflow-state visibility

### Current state
- The extension reads `.paul/STATE.md` and injects a small summary.
- Triggering is based on recent-message regex checks.
- Only a narrow amount of state is surfaced.

### Ideal state
- Inject only high-value lifecycle context at the right time.
- Use stronger triggering and richer structure where justified.
- Keep artifact truth central.

### Gap
This is one of the most important current gaps.

What is missing relative to ideal:
- stronger activation logic than “recent text looks PALS-like”
- more intentional timing for state injection
- richer structured visibility into current plan/loop/next action where useful
- better balance between relevance and prompt economy

### Severity
**Critical**

### Confidence
**High**

### Artifact-compatibility implications
This area is compatibility-sensitive.
Improvement is possible, but only if:
- `.paul/STATE.md` stays authoritative
- Pi runtime logic does not become a competing state machine

### Best handling
**Careful adapter-only layering**
- likely one of the most important Phase 55 recommendation areas

---

## 5. Pi-native UI and interaction affordances

### Current state
- PALS currently uses `ctx.ui.notify()` only.
- There is no richer status line, widget, selector-driven checkpoint flow, or lifecycle visualization.

### Ideal state
- Pi should visibly reflect current PALS state when helpful.
- UI primitives should improve orientation, discoverability, and checkpoint handling.
- The UI should remain a thin presentation layer over shared artifacts.

### Gap
The adapter currently leaves a large amount of Pi-native UX value unused.

Missing relative to ideal:
- always-visible or at least easy-to-access lifecycle state indicators
- richer interactive approval/decision affordances
- selector or helper-based discovery for commands and actions
- stronger workflow visibility inside the Pi session itself

### Severity
**High**

### Confidence
**High**

### Artifact-compatibility implications
Mostly compatibility-safe, because UI can remain a read-and-present layer over shared artifacts.

### Best handling
**Adapter-only improvement now**
- this is a major native-fit opportunity without requiring shared workflow divergence

---

## 6. Installer / packaging / deployment model

### Current state
- Installation is global-only.
- This is valid under Pi’s documented locations.
- Project-local Pi installation is not offered.

### Ideal state
- Installation model should be an explicit product choice.
- Global may remain the default, but local or mixed modes should be considered deliberately.

### Gap
The gap is not compliance; the installer is compliant.
The gap is that the current packaging model is **narrower than Pi’s supported deployment options** and does not clearly justify that choice.

### Severity
**Medium**

### Confidence
**Medium-High**

### Artifact-compatibility implications
High compatibility. Supporting more installation modes does not inherently threaten shared artifacts.

### Best handling
**Adapter-only improvement now** or **intentional defer**
- depending on product strategy, this may be worth adding or explicitly rejecting in documentation

---

## 7. State handling and persistence

### Current state
- The extension reparses `.paul/STATE.md` on demand.
- It uses no Pi-native persistence.
- Artifact truth is well preserved.

### Ideal state
- `.paul/STATE.md` remains authoritative.
- Pi-native persistence may hold ephemeral convenience state only.

### Gap
This is a nuanced gap.

What is missing relative to ideal:
- selective Pi-native convenience state where it would improve UX
- richer session-aware ergonomics

What is already correct:
- avoiding duplicated lifecycle truth is the right instinct

### Severity
**Medium**

### Confidence
**Medium**

### Artifact-compatibility implications
Potentially risky if done poorly; safe if persistence remains non-authoritative.

### Best handling
**Careful adapter-only layering**
- use Pi persistence only for convenience metadata, not lifecycle truth

---

## 8. Documentation and operator clarity

### Current state
- The adapter generally documents itself well enough to audit.
- Some comments and docs still describe an older skills-only mental model.

### Ideal state
- Docs and comments should accurately describe the extension-enabled adapter and its intended boundaries.

### Gap
There is a straightforward maintenance gap: documentation drift.

This is not a runtime correctness issue, but it does create:
- audit friction
- operator confusion
- maintainability risk over time

### Severity
**Medium**

### Confidence
**High**

### Artifact-compatibility implications
None. This is a hygiene and clarity issue.

### Best handling
**Adapter-only improvement now**
- low-risk, high-clarity cleanup

---

## 9. Overall native fit with Pi’s philosophy

### Current state
- PALS is philosophically aligned with Pi.
- Pi expects workflows like this to be layered via extensions and skills.

### Ideal state
- Philosophical fit should be matched by equally strong practical use of Pi-native ergonomics.

### Gap
The remaining gap is not conceptual fit; it is **execution depth**.

PALS has already chosen the right broad strategy.
It has not yet pushed far enough into Pi-native affordances to fully realize that strategy.

### Severity
**High**

### Confidence
**High**

### Artifact-compatibility implications
This is largely about adapter maturity, not shared-artifact risk.

### Best handling
**Phase 55 recommendation synthesis**
- this gap is the umbrella conclusion that organizes the more specific gaps above

---

## Consolidated gap table

| Dimension | Current vs Ideal | Severity | Confidence | Compatibility posture | Likely handling |
|-----------|------------------|----------|------------|-----------------------|-----------------|
| Skills and invocation model | Close to ideal; mainly UX harmonization left | Low | High | Safe | Adapter-only now |
| Command routing and discoverability | Valid but underpowered | High | High | Safe | Adapter-only now |
| Extension event architecture | Coherent but not yet optimized | High | Medium-High | Sensitive but manageable | Careful adapter layering |
| Context injection / workflow-state visibility | Most important structural weakness | Critical | High | Sensitive | Careful adapter layering |
| Pi-native UI / interaction affordances | Major underused surface | High | High | Safe | Adapter-only now |
| Installer / packaging model | Valid but narrower than Pi supports | Medium | Medium-High | Safe | Adapter-only now or intentional defer |
| State handling / persistence | Good instincts, but conservative | Medium | Medium | Sensitive | Careful adapter layering |
| Documentation / operator clarity | Drift present | Medium | High | Safe | Adapter-only now |
| Overall native fit | Direction right, depth insufficient | High | High | Safe if artifact authority preserved | Phase 55 framing |

---

## Compatibility-safe improvements vs more sensitive areas

### Safely artifact-compatible now
These appear safe to improve without threatening PALS’ cross-harness architecture:
- command ergonomics and discoverability
- richer status/visibility UI
- command/skill wording consistency
- adapter documentation cleanup
- clearer installer mode documentation

### Compatible but architecturally sensitive
These appear feasible, but require discipline because they shape runtime behavior more deeply:
- rethinking the best event model for state injection
- improving context augmentation strategy
- using Pi persistence for convenience metadata
- making checkpoint/approval flows more Pi-native

### Potential future-state divergence territory
These ideas should be treated cautiously and likely belong to a later v2 discussion if they drift too far:
- Pi-only workflow semantics not recoverable from shared artifacts
- Pi-native lifecycle truth that competes with `.paul/STATE.md`
- adapter logic that meaningfully changes PLAN/APPLY/UNIFY semantics only on Pi

---

## Bottom line
The current Pi adapter is **much closer to “correct baseline” than to “failed design.”**

Its main gaps are not about using the wrong Pi primitives.
They are about leaving too much Pi-native value on the table.

The most important conclusion from the gap analysis is:

> **PALS does not need a Pi-specific redesign of its core artifact model. It needs a more mature Pi-native shell around that model, especially for context injection, command ergonomics, and lifecycle visibility.**