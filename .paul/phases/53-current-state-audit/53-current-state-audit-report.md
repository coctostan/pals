# Current-State Audit Report — Pi Port

## Executive summary

The current PALS Pi port is a **coherent first-pass adapter** that gets the fundamentals right:
- it uses Pi skills correctly
- it uses Pi extensions correctly
- it preserves shared artifact compatibility as the primary design goal
- it adds a useful `/paul-*` command layer without forking core workflow logic

The port does **not** appear fundamentally broken or conceptually wrong.

However, it is also clearly **basic** in how much of Pi’s native capability surface it uses. The current adapter reaches for the safest, thinnest mechanisms — skills, command wrappers, minimal notifications, and lightweight context injection — while leaving much of Pi’s richer command, UI, and session/runtime surface unused.

So the present-state conclusion is:

> The Pi port is directionally correct and artifact-safe, but it is probably **not yet the ideal use of Pi’s environment capabilities**.

That conclusion should be treated as a current-state baseline, not yet as the final recommendation set.

---

## Current architecture

### 1. Shared artifacts remain the source of truth
The Pi port keeps workflows, references, templates, and rules in shared markdown and installs them into Pi’s skill tree.

### 2. Pi-facing skills provide discoverability
11 Pi skills act as thin entry points for user-facing PALS operations.

### 3. A single extension provides runtime glue
The extension:
- registers `/paul-*` commands
- forwards them to `/skill:paul-*`
- detects PALS projects on `session_start`
- injects lightweight PALS state during active workflow turns

### 4. Installer composes everything into Pi’s expected locations
The Pi installer targets:
- `~/.pi/agent/skills/pals/...`
- `~/.pi/agent/extensions/pals-hooks.ts`

This is a classic adapter design: **thin Pi-native shell around shared cross-platform artifacts**.

---

## Confirmed strengths

### Strength 1: Artifact compatibility is genuinely preserved
The biggest success of the current design is that it does **not** fork the real workflow logic into Pi-specific copies.

Why this matters:
- shared workflow markdown stays authoritative
- shared templates and references stay reusable
- cross-platform updates can flow without duplicated maintenance
- Pi-specific code stays localized to the adapter edge

This is the strongest property of the current port.

### Strength 2: Skills are used in a Pi-native way
Pi’s documented skill model is a strong match for PALS wrappers, and the current adapter uses it correctly:
- valid naming
- valid placement
- valid `/skill:name` invocation model
- good fit with progressive disclosure

### Strength 3: Command wrappers improve ergonomics without changing semantics
Using extension-registered `/paul-*` commands that route into `/skill:paul-*` is a good compromise:
- users get friendlier commands
- skill behavior stays canonical
- command logic remains thin and low-risk

### Strength 4: The extension uses documented events correctly
The current use of `session_start` and `context` is grounded in Pi’s documented event system, not hacks or undocumented behavior.

### Strength 5: The adapter matches Pi’s philosophy
Pi explicitly expects workflows like plan mode or sub-agent systems to be layered on via extensions/skills/packages rather than built into core. PALS fits that philosophy well.

---

## Confirmed weaknesses / gaps

### Gap 1: The port uses only a narrow slice of Pi’s native power
This is the clearest current weakness.

The adapter currently does **not** make meaningful use of:
- richer command ergonomics (`getArgumentCompletions`, command browsing patterns)
- richer UI surfaces (`setStatus`, `setWidget`, selectors, guided interaction)
- extension state persistence (`appendEntry`) where useful
- more nuanced turn/session control features where appropriate

None of these are required for correctness, but their absence reinforces the feeling that the port is “basic.”

### Gap 2: Context injection is heuristic and intentionally shallow
The current `context` hook works, but it is lightweight and somewhat brittle:
- regex over recent messages
- only last 5 messages inspected
- small injected summary
- no deeper structured reasoning about workflow state

This does not look wrong, but it does look like a placeholder-quality first pass rather than a mature Pi-native integration.

### Gap 3: The command experience is functional, not polished
The `/paul-*` commands currently behave as forwarding aliases.

That is a perfectly valid baseline, but compared to what Pi allows, it is minimal. There is little command-time affordance, discovery help, completion, or runtime guidance.

### Gap 4: Adapter documentation/comments show some drift
There are signs that parts of the Pi adapter documentation still describe an earlier “skills only” model even though the shipped adapter now clearly includes commands and hooks.

This is not a runtime defect, but it weakens confidence and makes future auditing harder.

### Gap 5: Pi-native UX parity with Claude Code is not yet demonstrated
The current adapter proves compatibility and basic usability, but it does not yet prove that Pi users get a comparably seamless lifecycle experience.

That is the central question for the remaining phases.

---

## Open questions

These questions remain unresolved after the current-state audit and should drive Phase 54.

### Open question 1: Is `context` the best hook for workflow-state injection?
It is valid, but is it the ideal mechanism versus:
- `before_agent_start`
- `input` preprocessing
- a hybrid approach
- command-triggered injection patterns

### Open question 2: How much richer should Pi-specific UX become before it threatens artifact simplicity?
The current adapter is intentionally thin. Phase 54 needs to determine where the sweet spot lies between:
- preserving cross-platform simplicity
- delivering a more native Pi feel

### Open question 3: Should `/paul-*` remain simple wrappers, or become stronger Pi-native interaction points?
Current wrappers are low-risk. But Pi supports significantly richer command interactions.

Phase 54 should determine whether that should remain out of scope, become adapter-only enhancement, or be deferred to a future v2 model.

### Open question 4: Should PALS exploit more of Pi’s session/runtime model while still keeping `.paul/STATE.md` authoritative?
Pi has state and session features that could potentially complement artifact state without replacing it.

The key question is where that becomes useful versus dangerous duplication.

### Open question 5: Is global-only installation the right product choice for Pi?
Pi supports both global and project-local resources. The current adapter chooses global installation.

That is compatible, but Phase 54 should consider whether the ideal artifact-compatible experience wants more flexible installation modes.

---

## Artifact compatibility assessment

### What the current design gets right
- Keeps shared markdown artifacts central
- Avoids Pi-specific forks of workflow behavior
- Uses wrappers instead of duplicate logic
- Reads `.paul/STATE.md` directly instead of inventing a parallel runtime truth source

### What would need care later
Future Pi-native improvements may still be compatible if they remain:
- adapter-only
- additive
- recoverable from shared artifacts
- non-authoritative relative to `.paul/*`

The main risk area for future work is not skills or commands — it is creating Pi-only stateful behavior that starts competing with artifact truth.

---

## Phase 54 investigation threads

Phase 54 should focus on the gap between **current implementation** and **ideal artifact-compatible Pi usage**.

Recommended investigation threads:

1. **Best hook architecture for PALS state injection in Pi**
   - Compare current `context` approach with alternatives supported by Pi

2. **Best command architecture for `/paul-*` in Pi**
   - Determine whether current wrapper design is sufficient or obviously underpowered

3. **Best Pi-native UX improvements that remain artifact-safe**
   - Status/header/widget/selector opportunities
   - session visibility improvements
   - checkpoint/approval ergonomics

4. **Best install/discovery model**
   - Global vs project-local vs mixed deployment choices

5. **Best boundary between shared artifacts and Pi-specific runtime glue**
   - Clarify what belongs in skills, extension code, installer logic, or future v2 wrappers

---

## Bottom-line handoff

### Confirmed strengths
- Artifact-safe adapter architecture
- Correct use of Pi skills
- Correct use of Pi extension basics
- Sensible `/paul-*` wrapper model
- Strong philosophical fit with Pi’s extensible design

### Confirmed gaps
- Thin use of Pi-native capability surface
- Minimal command ergonomics
- Heuristic/shallow context injection
- Minor docs/comment drift
- No demonstrated parity yet with a truly seamless Claude Code-like lifecycle experience

### Handoff statement for Phase 54
The current Pi port should be treated as a **correct baseline implementation** — not as a failed experiment, but not yet as a proven ideal integration either.

Phase 54 should now determine:

> **What the best artifact-compatible Pi-native version of this adapter should actually look like, and how far the current implementation is from that target.**