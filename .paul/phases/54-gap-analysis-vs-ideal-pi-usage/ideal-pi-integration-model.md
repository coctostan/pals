# Ideal Pi Integration Model

## Purpose
This document defines the **ideal artifact-compatible Pi integration model** for PALS.

It is intentionally constrained by one non-negotiable rule:

> Shared markdown artifacts (`kernel/`, `modules/`, `.paul/*`) remain the authoritative workflow layer across harnesses.

So the ideal Pi target is **not** “rewrite PALS to feel uniquely Pi-native at any cost.”
It is:

> **Use Pi’s native skill, command, event, UI, and packaging surfaces as deeply as useful while keeping Pi-specific behavior adapter-only, additive, and recoverable from shared artifacts.**

---

## Design guardrails

Any ideal-state Pi design should satisfy all of these:

1. **Artifact authority remains shared**
   - Workflow semantics still live in shared markdown artifacts.
   - `.paul/STATE.md`, PLANs, SUMMARYs, ROADMAP, and PROJECT remain the durable source of truth.

2. **Pi-native behavior stays at the edge**
   - Skills, extension code, and installer logic may improve discovery, context, UX, and orchestration.
   - They should not fork core workflow meaning.

3. **Pi additions are additive, not competing truth sources**
   - Pi runtime/session state may complement artifact state.
   - It must not become a second authoritative lifecycle state machine.

4. **User ergonomics should improve without hiding the artifacts**
   - Pi-native commands, UI, and notifications should help users move through PALS.
   - But the underlying file-based lifecycle should remain visible and inspectable.

5. **Cross-harness portability remains intact**
   - A Pi optimization is ideal only if it does not force shared workflow files to become Pi-specific.

---

## 1. Skills and discovery model

### Ideal state
PALS should continue to use Pi skills as the **primary discoverability and invocation surface** for lifecycle capabilities.

That means:
- one user-facing Pi skill per major PALS operation
- valid Pi naming and directory structure
- thin but trustworthy wrappers that point into shared workflow/reference/template files
- skill descriptions optimized for Pi’s progressive-disclosure model

### Why this is ideal in Pi terms
Pi explicitly supports skills as on-demand capability packages and expects them to be loaded lazily. That matches PALS well because PALS already organizes behavior in markdown workflows and references.

### Artifact-compatibility constraint
Skills should remain wrappers over shared artifacts, not alternate implementations.

### Implication
The ideal future is **not** fewer skills or more Pi-only logic inside skills. The ideal is **better-crafted wrappers** with clearer descriptions, sharper invocation expectations, and consistent command/skill interplay.

---

## 2. Slash command routing and ergonomics

### Ideal state
`/paul-*` commands should remain a Pi-native convenience layer over canonical skills, but become significantly more ergonomic.

Ideal behavior includes:
- command descriptions that clearly signal what each lifecycle action does
- argument completions where relevant
- possible selector/discovery helpers for PALS commands or plans
- command-time guidance that reduces guesswork
- wrappers that still route into shared workflow behavior rather than duplicating logic

### Why this is ideal in Pi terms
Pi explicitly supports `registerCommand()`, argument completions, command listing, and richer command-driven flows. Using only bare forwarding leaves native command affordances underused.

### Artifact-compatibility constraint
Commands must remain a routing and interaction layer, not a place where lifecycle semantics split away from shared markdown workflows.

### Implication
The ideal command layer is **stronger than aliasing**, but still **weaker than a forked runtime controller**.

---

## 3. Extension structure and event usage

### Ideal state
The Pi extension should remain small enough to understand, but mature enough to use the right event surfaces deliberately.

Ideal extension behavior would:
- use documented Pi events intentionally, not heuristically by default
- distinguish session-start awareness from turn-by-turn workflow augmentation
- use the best event or combination of events for state injection, command support, and lightweight runtime glue
- keep extension logic focused on Pi-specific orchestration concerns

### Why this is ideal in Pi terms
Pi’s extension model is the documented place to build workflow-specific runtime behavior. PALS should use that surface confidently, not minimally out of caution alone.

### Artifact-compatibility constraint
Extension logic must interpret and surface shared artifact state, not replace it.

### Implication
The ideal model likely still uses:
- `session_start` for orientation
- command registration for lifecycle ergonomics
- one or more prompt/context events for targeted augmentation

But it should do so with a clearer architecture than “light regex hook plus notification.”

---

## 4. Context injection and session-awareness strategy

### Ideal state
Pi should receive **the minimum high-value workflow context at the right time**, with context drawn from `.paul/STATE.md` and nearby artifacts.

Ideal context behavior means:
- injecting lifecycle context when PALS work is active or about to begin
- keeping injections concise, structured, and purpose-driven
- preferring signals stronger than shallow recent-message regex alone when feasible
- avoiding unnecessary prompt bloat
- preserving `.paul/STATE.md` as the authority for lifecycle position

### Why this is ideal in Pi terms
Pi explicitly supports prompt/context shaping through extensions. That surface exists so harness-specific workflows can become more coherent without changing core Pi.

### Artifact-compatibility constraint
Any injected context must be reproducible from shared artifacts. Pi-specific session memory may help, but it cannot become the only place important lifecycle state lives.

### Implication
The ideal model likely combines:
- artifact reads for durable truth
- event-timed injection for relevance
- optional Pi session annotations for convenience only

---

## 5. Pi-native UX and visibility

### Ideal state
PALS should feel visibly alive inside Pi, not just available.

Ideal UX may include:
- lightweight status/header/widget indicators of current PALS phase or next action
- clearer checkpoint/approval flows using Pi UI primitives when helpful
- better lifecycle discoverability for users who do not already know the command set
- context-aware notifications that orient without spamming

### Why this is ideal in Pi terms
Pi exposes status lines, widgets, selectors, prompts, and custom UI specifically so packages can create native-feeling workflows.

### Artifact-compatibility constraint
UI must remain a presentation layer over shared artifact truth. It should visualize or guide workflow state, not become the hidden source of workflow reality.

### Implication
The ideal Pi experience should be **more visible and guided than today**, while still allowing a user to inspect the real state directly in `.paul/*` artifacts.

---

## 6. Installer / discovery / packaging model

### Ideal state
PALS should support the Pi installation model that best matches its product intent, while acknowledging Pi supports both global and project-local resources.

Ideal options to evaluate:
- global install as the default for reusable framework behavior
- optional project-local install for repo-scoped usage or experimentation
- clean support for reloadable extension/skill development workflows

### Why this is ideal in Pi terms
Pi documents both global and project-local resource locations. Ignoring one mode entirely may be acceptable, but only if it is a product decision rather than an accidental limitation.

### Artifact-compatibility constraint
Packaging choices should not require separate Pi-only copies of shared workflow artifacts.

### Implication
The ideal packaging model may still default global, but it should do so intentionally and document why.

---

## 7. State handling and persistence

### Ideal state
PALS should remain artifact-first while using Pi-native persistence only where it adds convenience without introducing lifecycle drift.

Ideal state handling means:
- `.paul/STATE.md` remains authoritative
- Pi session persistence can store ephemeral annotations, recent helper state, or UX metadata
- persistent Pi state never becomes required to resume or understand the workflow

### Why this is ideal in Pi terms
Pi provides session persistence because some workflow state is useful at runtime. PALS can benefit from that, but only if it avoids duplicating lifecycle truth.

### Artifact-compatibility constraint
Anything important enough to matter across sessions, harnesses, or audits must still land in shared artifacts.

### Implication
The ideal model uses Pi persistence sparingly and asymmetrically: useful for convenience, never required for correctness.

---

## 8. Documentation and operator clarity

### Ideal state
The adapter should explain itself clearly enough that a maintainer can understand:
- what is canonical shared behavior
- what Pi-specific code adds
- which Pi capabilities are intentionally used or intentionally deferred
- why certain apparently richer options are not yet chosen

### Why this is ideal in Pi terms
Pi is a harness for extensible workflows. Clear package/operator documentation is part of making those workflows trustworthy.

### Artifact-compatibility constraint
Docs must reinforce the separation between shared artifacts and adapter-specific behavior.

### Implication
The ideal Pi adapter is not just technically correct; it is legible about its boundaries.

---

## Ideal-state evaluation rubric

A Pi integration change is closer to ideal if it does more of the following:
- improves native discoverability without forking logic
- improves lifecycle visibility without creating parallel truth
- improves command ergonomics without bypassing skills/artifacts
- improves context timing/quality without adding noisy prompt mass
- uses Pi-native UI where it clarifies workflow state or checkpoints
- stays adapter-only, additive, and recoverable from shared artifacts

A change is farther from ideal if it:
- moves canonical behavior out of shared artifacts into Pi-only code
- creates Pi-only lifecycle truth or state dependence
- hides important workflow steps behind opaque runtime behavior
- makes PALS harder to reason about cross-harness

---

## Bottom line
The ideal artifact-compatible Pi model for PALS is:

> **A Pi-native shell that is meaningfully richer than today in commands, context timing, and UX visibility — but still decisively grounded in shared markdown artifacts as the single source of workflow truth.**

That is the standard the current implementation should now be measured against.