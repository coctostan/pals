# Current Lifecycle Surface Audit

## Scope
Audit the current Pi lifecycle presentation for Phase 167 before any UI changes are made.

Evidence sources:
- `drivers/pi/extensions/pals-hooks.ts`
- `drivers/pi/extensions/README.md`
- `README.md`
- `tests/pi-end-to-end-validation.sh`

## Executive Summary
The current Pi lifecycle experience is built from one extension file, but it presents as three closely related surfaces:
1. a compact status string via `setStatus(...)`
2. a multi-line widget via `setWidget(...)`
3. guided workflow prompts/notifications layered on top of canonical workflow output

The user complaint is well-grounded. The main always-visible surface is noisy for two reasons:
- the widget spends two lines on quick actions (`Actions:` / `More:`) that are operationally secondary to lifecycle state
- the status line and widget both mix lifecycle state with optional module activity and shortcut hints, so the most important information is not visually dominant

## Current Surface Inventory

### 1. Persistent status line
Rendered by `renderLifecycleStatus(...)` in `drivers/pi/extensions/pals-hooks.ts:400-412` and pushed via `syncLifecycleUi(...)` at `drivers/pi/extensions/pals-hooks.ts:435-447`.

Current composition:
- `PALS`
- `Phase: ...`
- compact loop badge from `renderLoopBadge(...)`
- optional module activity from `renderModuleActivity(...)`
- `Next: ...`
- quick-action summary from `renderQuickActionSummary(...)`

Current format example shape:
- `PALS • Phase: 167 of 3 (...) • PLAN✓○○ • Modules: ... • Next: /paul:apply ... • Actions: ...`

Assessment:
- Good: phase, loop, and next action are present.
- Problem: the line is overloaded; quick actions and module activity compete with the actual lifecycle state.
- Problem: status hierarchy is weak because everything is flattened into one bullet-delimited sentence.

### 2. Persistent widget
Rendered by `renderLifecycleWidget(...)` in `drivers/pi/extensions/pals-hooks.ts:414-434` and pushed via `syncLifecycleUi(...)` at `drivers/pi/extensions/pals-hooks.ts:435-447`.

Current composition:
- header: `PALS Lifecycle`
- `Milestone: ...`
- `Phase: ...`
- `Loop: ...`
- `Next action: ...`
- optional module detail lines from `renderModuleActivityDetails(...)`
- quick actions line: `Actions: ...`
- overflow quick actions line: `More: ...`

Current example shape:
- `PALS Lifecycle`
- `Milestone: Awaiting next milestone`
- `Phase: None active`
- `Loop: PLAN ──▶ APPLY ──▶ UNIFY ○ ○ ○ [Milestone complete - ready for next]`
- `Next action: /paul:discuss-milestone or /paul:milestone`
- optional module lines
- `Actions: Status Ctrl+Alt+S | Resume Ctrl+Alt+R | Help Ctrl+Alt+H`
- `More: Milestone Ctrl+Alt+M`

Assessment:
- Good: milestone / phase / loop / next action are already the right core fields.
- Problem: the first line is a standalone header that consumes vertical space without adding state.
- Problem: `Actions:` and `More:` make the panel feel like a shortcut cheat sheet instead of a lifecycle instrument panel.
- Problem: optional module detail lines can further push the key lifecycle lines downward.

### 3. Quick-action layer
Built by `getQuickActions(...)` and `renderQuickActionSummary(...)` in `drivers/pi/extensions/pals-hooks.ts:216-245`.

Current behavior:
- next action may add a `Next` quick action
- persistent shortcuts include `Status`, `Resume`, `Help`, `Milestone`
- primary quick actions are rendered inline first; overflow goes to `More:`

Assessment:
- Good: shortcuts exist and remain adapter-only.
- Problem: quick actions are being rendered in the persistent lifecycle surface, even though they are not the primary information the user wants to see.
- Problem: the docs currently normalize this behavior instead of treating it as optional UX chrome.

### 4. Optional live module visibility
Built by `extractRecentModuleActivity(...)`, `renderModuleActivity(...)`, and `renderModuleActivityDetails(...)` in `drivers/pi/extensions/pals-hooks.ts:289-398`.

Current behavior:
- module activity can appear inline in the status line
- module details can appear as extra lines in the widget
- docs explicitly describe this as part of the always-visible status/widget surface

Assessment:
- Good: this is useful as observability.
- Problem: it is secondary information but can visually compete with milestone / phase / loop / next action.
- Problem: for the specific user request, module visibility is part of the clutter budget unless it is reduced or moved off the main calm panel.

### 5. Guided workflow prompts / notifications
Detected in `detectGuidedWorkflowMoment(...)` and presented by `presentGuidedWorkflowMoment(...)` in `drivers/pi/extensions/pals-hooks.ts:659-882`.

Current behavior:
- watches canonical prompts such as `Would you like to see the plan?`, `Continue to APPLY`, `Continue to UNIFY`, `CHECKPOINT:`, and `▶ NEXT:`
- uses `notify`, `confirm`, and `select` to help route canonical responses
- does not create a second persistent widget system

Assessment:
- These are adjacent surfaces, not separate persistent TUI panels.
- They matter for consistency, but they are not the main clutter source.
- The design implication is to align wording/semantics with the main lifecycle panel, not to invent new widgets.

## What the docs currently claim

### Pi extension README
`drivers/pi/extensions/README.md:39-62` explicitly documents:
- quick actions and shortcuts as part of the lifecycle widget
- `Actions:` / `More:` behavior in the always-visible UI
- live module visibility in the always-visible status/widget

`drivers/pi/extensions/README.md:132-137` also states that `turn_end` refreshes the always-visible lifecycle status/widget so shortcut hints and recent module activity stay aligned.

### Root README
The root `README.md` presents Pi guided workflow UX as a key feature and serves as a broader contract surface for the adapter, so any sustained change in lifecycle presentation language should eventually stay consistent there as well.

## What the validation currently guards
`tests/pi-end-to-end-validation.sh:602-665` verifies:
- the extension uses both `setStatus` and `setWidget`
- milestone / phase / loop / next action are surfaced
- lifecycle UI refreshes on approved adapter events
- canonical guided workflow detection remains wired

What it does **not** currently guard:
- absence of `Actions:` in the persistent widget
- absence of `More:` in the persistent widget
- calmer 4-line layout
- semantic visual hierarchy or color intent

## Missing semantic color model
There is no explicit lifecycle color model in the persistent render path.

Evidence:
- `renderLifecycleStatus(...)` and `renderLifecycleWidget(...)` return plain strings/lines only
- the only explicit semantic UI levels observed in this audit are transient `notify(..., "info")` and `notify(..., "success")` calls inside guided workflow handling (`drivers/pi/extensions/pals-hooks.ts:850-881`)

Assessment:
- The persistent lifecycle surface currently communicates state almost entirely through text and ordering, not through semantic color.
- This matches the user complaint that it is hard to see what is going on quickly.

## Concrete clutter sources

| Source | Evidence | Why it feels noisy |
|---|---|---|
| Standalone `PALS Lifecycle` header | `drivers/pi/extensions/pals-hooks.ts:425` | consumes a full line without adding operational state |
| `Actions:` line | `drivers/pi/extensions/pals-hooks.ts:420` | turns the panel into a shortcut reference instead of a state display |
| `More:` line | `drivers/pi/extensions/pals-hooks.ts:421` | adds another low-priority line to the persistent panel |
| Inline quick actions in status | `drivers/pi/extensions/pals-hooks.ts:407-408` | makes the compact status line longer and less scannable |
| Optional module detail lines | `drivers/pi/extensions/pals-hooks.ts:389-397`, `430` | can push core lifecycle state down the widget |
| Bullet-flattened status hierarchy | `drivers/pi/extensions/pals-hooks.ts:402-411` | makes primary vs secondary information visually equivalent |

## Hot conclusions for Phase 168
1. The correct core panel is already present conceptually: milestone, phase, loop, next action.
2. The current clutter mainly comes from layering quick actions, optional module visibility, and a redundant header into the same persistent surface.
3. Guided workflow prompts are adjacent UX, but they are not a reason to expand the widget system.
4. The persistent render path needs semantic emphasis, not more information.

## Phase 167 design implications
- Remove persistent `Actions:` / `More:` from the main calm panel.
- Collapse the header and milestone label into a stronger first line.
- Keep the panel centered on milestone, phase, loop, and next action.
- Define a semantic color model for lifecycle meaning, not decorative variety.
- Treat prompts/notifications as alignment work only if they reinforce the same language.
