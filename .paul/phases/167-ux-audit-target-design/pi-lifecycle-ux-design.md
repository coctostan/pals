# Pi Lifecycle UX Design

## Design Goal
Redesign the existing Pi lifecycle surface so it feels calm, legible, and operationally clear during daily use.

This is a polish phase, not a new-surface phase.

## Primary UX Principles
1. **State first** — the panel exists to answer: where am I, what state is this in, and what should I do next?
2. **One calm panel** — do not invent additional widgets unless later implementation reveals a concrete need.
3. **Semantic color, not decoration** — color should indicate lifecycle meaning.
4. **Hierarchy over density** — milestone / phase / loop / next action must dominate quick actions, module chatter, and explanatory chrome.
5. **Preserve lifecycle truth** — `.paul/*` remains authoritative; this is a Pi presentation change only.

## Target 4-line primary panel
The main widget should become a strict 4-line layout.

Preferred structure:

```text
PALS Milestone: {milestone}
Phase: {phase}
Loop: PLAN ──▶ APPLY ──▶ UNIFY {marks/status}
Next action: {nextAction}
```

Example:

```text
PALS Milestone: Awaiting next milestone
Phase: None active
Loop: PLAN ──▶ APPLY ──▶ UNIFY ○ ○ ○ [Milestone complete - ready for next]
Next action: /paul:discuss-milestone or /paul:milestone
```

## Deliberate removals from the persistent panel
The following current elements should not remain in the calm 4-line panel:
- standalone `PALS Lifecycle` header line
- `Actions: ...`
- `More: ...`
- inline quick-action summary in the status line
- verbose module detail lines in the main widget

Rationale:
- these are secondary aids, not the main lifecycle state
- they materially increase visual noise
- they dilute the prominence of the next action

## Visual hierarchy

### Line 1 — milestone anchor
`PALS Milestone: {milestone}` is the panel title and first state line combined.

Intent:
- removes the redundant blank header idea
- immediately tells the user what milestone context they are in
- establishes the panel as a live state readout rather than a generic section label

### Line 2 — phase detail
`Phase: {phase}` remains explicit and plain.

Intent:
- keeps the current execution context visible
- should read as secondary to milestone, but still stronger than loop annotation text

### Line 3 — lifecycle state
`Loop: ...` remains the main status line for progress through PLAN / APPLY / UNIFY.

Intent:
- preserve the existing lifecycle truth already emitted from `.paul/STATE.md`
- make the bracketed trailing status feel like a state qualifier, not the whole message

### Line 4 — next action
`Next action: {command}` should be the most action-oriented line.

Intent:
- visually anchor the user’s immediate move
- keep command text easy to scan
- this is the one line that should feel most like a control surface

## Semantic color model
Color must encode meaning, not add novelty.

### Core semantics
- **Accent / identity** — use a stable accent for `PALS Milestone:` and lifecycle labels so the panel reads as one system
- **Ready / actionable** — use a positive-but-not-completion color for a clear next step or ready state
- **Active / in progress** — use a strong working-state color for the current phase when mid-loop
- **Complete / success** — use a success color for completed loop marks and milestone/phase completion states
- **Blocked / error** — use a blocking color only for genuine stop conditions
- **Caution / waiting** — use a warning color for awaiting approval, human verification, or stale/problem states

### Practical mapping
Recommended semantic targets:
- `PALS Milestone:` label → stable accent
- milestone value → neutral/high-contrast text
- `Phase:` label → stable accent
- phase value → active color when in progress; neutral when none active; success when complete-only views are shown
- loop marks:
  - `✓` → success
  - current active emphasis / in-progress bracket text → active color
  - `○` pending marks → neutral or muted text
  - blocked state text if present → blocked color
- `Next action:` label → stable accent
- next action command/value → ready/actionable color

### Restraints
- do not use more than a small semantic palette
- do not color every token independently
- do not turn the panel into a rainbow or a dashboard
- if Pi does not support rich styling in this exact surface, degrade gracefully to plain text while preserving the calmer structure

## Status-line posture
The compact status line should remain, but it should become **more terse than the widget**, not busier.

Recommended posture:
- keep milestone/phase/loop/next summary intent
- drop inline quick-action summary
- avoid verbose module chatter in the primary compact line unless later validation proves it is still necessary and non-disruptive
- preserve the same semantic language as the widget, even if the compact surface uses less text

In practice, the status line should summarize lifecycle state, not repeat shortcut help.

## Module visibility posture
This milestone is not anti-observability, but the persistent calm panel should not be the default home for verbose module details.

Recommendation:
- remove module detail lines from the main 4-line widget
- if any module visibility remains in the compact status path, it must be clearly subordinate and easy to omit
- Phase 169 may decide whether module visibility needs a lighter-touch alignment after the main polish lands

## Quick actions posture
Quick actions remain valid adapter functionality, but they should stop dominating persistent presentation.

Recommendation:
- preserve quick-action command registration and shortcut behavior
- remove persistent `Actions:` and `More:` lines from the main widget
- do not treat shortcut discoverability as the goal of the always-visible lifecycle panel

## Adjacent prompt / notification posture
Adjacent workflow surfaces should be touched only when they reinforce the same calmer language.

Allowed alignment work:
- tighten titles or summaries so they match the calmer lifecycle vocabulary
- ensure success / info / warning notifications use the same semantic meanings as the main panel
- keep guided workflow prompts explicit and canonical

Not allowed in this milestone:
- inventing extra widgets
- building a separate notification system
- moving lifecycle truth into Pi-native state
- expanding guided workflow into a larger UX platform project

## Non-goals
- no broader Pi productization push
- no new widget system
- no cross-harness redesign
- no lifecycle ownership changes
- no new `.paul/*` semantics
- no shortcut-centric dashboard mode

## Implementation-facing implications for Phase 168
Primary likely implementation targets:
- `renderLifecycleStatus(...)`
- `renderLifecycleWidget(...)`
- helper calls that inject quick actions or module details into those render paths

Likely edits:
- remove persistent quick-action rendering from the widget
- remove inline quick-action summary from the compact status line
- collapse the header + milestone into a stronger first line
- define the minimal rendering structure around the 4-line panel
- add semantic styling only if the Pi surface supports it cleanly; otherwise preserve the new layout and wording first

## Acceptance target for the implemented UX
Done should look like this:
- the lifecycle panel is a strict 4-line display
- the panel reads as calm rather than busy
- the next action is visually obvious
- lifecycle state is faster to scan than before
- color clarifies state rather than decorating the UI
