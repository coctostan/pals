# Implementation Handoff

## Purpose
Convert the Phase 167 audit and design work into a bounded handoff for the two remaining phases in milestone v2.38.

## What Phase 167 established
Phase 167 confirms that the current Pi lifecycle surface already contains the correct core data, but it presents too much secondary information in the always-visible panel.

The main problems are now explicit:
- redundant standalone header line
- persistent `Actions:` and `More:` lines
- quick-action summary mixed into the compact status line
- optional module visibility competing with the main lifecycle state
- no explicit semantic color model for the persistent lifecycle render path

The target is also explicit:
- a calm 4-line widget
- milestone / phase / loop / next action as the primary hierarchy
- semantic color meaning rather than decorative styling
- no new widget system

## Core implementation scope — Phase 168
Phase 168 should focus on the runtime rendering path only.

### Primary implementation file
- `drivers/pi/extensions/pals-hooks.ts`

### Primary functions likely to change
- `renderLifecycleStatus(...)`
- `renderLifecycleWidget(...)`
- helper usage around `renderQuickActionSummary(...)`
- helper usage around `renderModuleActivity(...)` / `renderModuleActivityDetails(...)`

### Expected core changes
1. Replace the current widget composition with the strict 4-line panel:
   - `PALS Milestone: ...`
   - `Phase: ...`
   - `Loop: ...`
   - `Next action: ...`
2. Remove persistent `Actions:` and `More:` from the widget.
3. Remove quick-action summary from the compact status line.
4. Reduce or remove module detail rendering from the main calm panel.
5. Introduce semantic styling only if it can be done cleanly in Pi’s status/widget surfaces.

### Constraints for Phase 168
- do not change `.paul/*` lifecycle authority
- do not create extra widgets or panels
- do not redesign command routing or guided workflow semantics
- do not turn the milestone into generic Pi UX expansion

## Supporting alignment / validation scope — Phase 169
Phase 169 should pick up the contract surfaces after the rendering change lands.

### Likely follow-up files
- `tests/pi-end-to-end-validation.sh`
- `drivers/pi/extensions/README.md`
- possibly `README.md` if it materially describes the old quick-action / lifecycle widget behavior in a way that would now drift

### Expected follow-up work
1. Update validation so it still protects the core lifecycle contract while allowing the calmer layout.
2. Decide whether validation should explicitly guard against the old noisy persistent elements (`Actions:` / `More:` in the widget, inline quick-action summary in status).
3. Refresh Pi-facing documentation so it matches the new calmer lifecycle presentation.
4. Align any adjacent prompt/notification wording only where it directly supports the same visual/state language.

## Risks / open questions

### 1. Pi styling capability may be narrower than desired
The design specifies semantic color meaning, but Phase 168 should verify what the actual `setStatus(...)` / `setWidget(...)` surfaces support cleanly.

Implication:
- layout and hierarchy come first
- color is additive if supported well
- if rich styling is awkward or unavailable, do not block the calmer layout on it

### 2. Module visibility may need a secondary home later
This milestone intentionally deprioritizes verbose module visibility in the main panel.

Implication:
- if the change makes module visibility too hard to notice, that is a later product choice, not a reason to keep the current cluttered panel
- Phase 169 can document the new posture, but should not reopen the milestone into a visibility redesign

### 3. Validation may currently be too weak on presentation semantics
Current tests protect field presence and hook wiring, but not the calmer structure.

Implication:
- Phase 169 should add semantic guardrails carefully
- avoid brittle exact-line or cosmetic snapshot assertions unless they clearly protect the intended contract

## Recommended execution split

### Phase 168 ownership
- runtime render path
- widget/status simplification
- semantic emphasis implementation

### Phase 169 ownership
- validation updates
- doc alignment
- any small prompt/notification wording alignment directly implied by the new lifecycle language

## Verification guidance for later phases

### Phase 168 likely verification
- inspect the runtime output in Pi after installing the updated extension
- verify the main panel is the intended 4-line structure
- verify quick actions still exist functionally even though they are no longer persistent panel lines
- verify next action is easier to scan than before

### Phase 169 likely verification
- `bash tests/pi-end-to-end-validation.sh`
- any targeted grep assertions for updated lifecycle wording/contract surfaces
- manual confirmation that docs and validation now match the implemented lifecycle surface

## Explicit non-goals for the remainder of v2.38
- no new widget inventory
- no new Pi-owned workflow state
- no major guided workflow redesign
- no cross-harness UI parity milestone hidden inside this work
- no broad product/adoption cleanup

## Phase 168 handoff
Implement the calm 4-line lifecycle panel in `drivers/pi/extensions/pals-hooks.ts`, remove persistent quick-action clutter from the main lifecycle surface, and add semantic emphasis only if Pi supports it cleanly.

## Phase 169 handoff
After the runtime change lands, align `tests/pi-end-to-end-validation.sh` and the Pi-facing docs so the calmer lifecycle surface is the documented and validated contract.
