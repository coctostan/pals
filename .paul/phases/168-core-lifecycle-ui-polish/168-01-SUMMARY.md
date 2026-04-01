---
phase: 168-core-lifecycle-ui-polish
plan: 01
completed: 2026-04-01T19:08:53Z
duration: ~1 hour
---

## Objective
Implement the calmer Pi lifecycle presentation defined in Phase 167 by simplifying the persistent widget/status render path, removing persistent quick-action clutter, and keeping the lifecycle surface bounded to the existing adapter contract.

## What Was Built
| File | Purpose | Lines |
|------|---------|-------|
| `drivers/pi/extensions/pals-hooks.ts` | Simplified the persistent lifecycle widget to a strict 4-line hierarchy, removed persistent quick-action/module clutter from the main lifecycle surface, and tightened the compact status line while preserving approved adapter wiring | 1331 |

## Acceptance Criteria Results
| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Persistent lifecycle widget matches the calm 4-line hierarchy | PASS | `renderLifecycleWidget(...)` now emits `PALS Milestone`, `Phase`, `Loop`, and `Next action` only; standalone `PALS Lifecycle`, `Actions:`, and `More:` were removed |
| AC-2 | Compact status rendering is calmer and no longer shortcut-dominated | PASS | `renderLifecycleStatus(...)` no longer appends quick-action summary or module chatter and keeps milestone / phase / loop / next-action hierarchy compact |
| AC-3 | Runtime implementation preserves adapter safety and compiles cleanly | PASS | `npx -y esbuild ...` bundled successfully and `bash tests/pi-end-to-end-validation.sh` passed with all checks green |

## Verification Results
- `grep -n 'PALS Milestone:\|Next action:' drivers/pi/extensions/pals-hooks.ts && ! grep -q 'PALS Lifecycle' ... && ! grep -q 'Actions:' ... && ! grep -q 'More:' ...` → PASS
- `npx -y esbuild drivers/pi/extensions/pals-hooks.ts --bundle --platform=node --format=cjs --outfile=/tmp/pals-hooks-p168.js --external:@mariozechner/pi-tui` → PASS
- `bash tests/pi-end-to-end-validation.sh` → PASS (`156/156` checks)
- GitHub Flow APPLY/UNIFY branch state: `feature/168-core-lifecycle-ui-polish` with PR `https://github.com/coctostan/pals/pull/78`

## Module Execution Reports
- `[dispatch] pre-unify: 0 modules registered for this hook`

### Carry-forward APPLY annotations
- WALT: bounded runtime validation passed during APPLY via esbuild bundling and Pi end-to-end validation.
- DOCS: doc/validation drift remains expected for `drivers/pi/extensions/README.md` and related surfaces; the plan explicitly deferred that alignment to Phase 169.
- SKIP: APPLY captured the decision to keep a direct `renderLoopBadge(state.loop)` call in the compact status path so the calmer hierarchy still satisfies the existing validation contract.

### WALT
| Metric | Result |
|--------|--------|
| Tests | `156 pass` |
| Coverage | `—` |
| Lint | `—` |
| Typecheck | `—` |
| Verdict | `→ stable` |

Side effect:
- Recorded Phase `168-01` in `.paul/quality-history.md` using the explicit Pi validation suite result captured during APPLY/UNIFY.

### SKIP
#### Decision Record
## [2026-04-01] Keep direct loop-badge wiring in the compact Pi lifecycle status

**Type:** decision
**Phase:** 168 Core Lifecycle UI Polish
**Related:** `drivers/pi/extensions/pals-hooks.ts`, PR #78

**Context:** The Phase 168 runtime polish removed quick-action clutter and simplified the compact lifecycle status line, but the installed Pi validation suite still asserted a direct `renderLoopBadge(state.loop)` call inside `renderLifecycleStatus(...)`.

**Decision:** Keep a direct `renderLoopBadge(state.loop)` call in the compact status path while simplifying the surrounding status hierarchy.

**Alternatives considered:**
- Route all loop rendering through a new helper only — rejected because it broke the existing validation contract for no user-visible gain.
- Broaden Phase 168 into validation changes — rejected because Phase 169 already owns docs/validation alignment and the current runtime change did not require that scope expansion.

**Rationale:** This preserves the calmer status output while keeping the approved adapter contract green during APPLY and avoiding unnecessary Phase 168 scope growth.

**Impact:** Future lifecycle-surface refactors should preserve or deliberately update the Pi validation contract instead of breaking it incidentally.

#### Lesson Learned
## [2026-04-01] Keep runtime UX polish decoupled from contract-alignment work unless validation forces expansion

**Type:** lesson
**Phase:** 168 Core Lifecycle UI Polish
**Related:** `drivers/pi/extensions/pals-hooks.ts`, `tests/pi-end-to-end-validation.sh`, PR #78

**What happened:** The runtime widget/status polish landed cleanly, but one validation expectation still required a direct call shape in the compact status function.

**What we learned:** When a later phase already owns docs/validation alignment, the safer move is to preserve the existing validation contract during runtime polish unless a critical break makes that impossible.

**How to apply:** Keep Phase 169 focused on contract/document alignment around the new calmer surface rather than reopening Phase 168’s bounded runtime implementation.

### RUBY
- `drivers/pi/extensions/pals-hooks.ts` is `1331` lines long (`wc -l`), which is above RUBY's >500-line critical file-size threshold.
- Phase 168 stayed intentionally bounded and did not broaden into structural decomposition, but future edits to this file should resist additional accretion and consider extraction if lifecycle/UI responsibilities continue to grow.

## Deviations
None material.

## Key Patterns / Decisions
- The persistent Pi lifecycle widget is now a strict 4-line panel anchored on milestone, phase, loop, and next action.
- Persistent shortcut hints and module detail were removed from the main lifecycle surfaces rather than moved into a new widget.
- Semantic emphasis stayed text-first and bounded; no fragile styling layer or Pi-owned lifecycle state was introduced.
- A direct `renderLoopBadge(state.loop)` call was intentionally retained in the compact status path for validation compatibility.

## Skill Audit
All required skills in the Phase 168 plan were invoked.

| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the runtime polish phase |
| /carl | ✓ | Session-boundary routing remained active during the implementation loop |
| TODD | ✓ | APPLY preserved disciplined verification expectations even though the phase was runtime-polish, not RED/GREEN TDD work |
| WALT | ✓ | Validation ran during APPLY and durable quality evidence was recorded during UNIFY |

## Next Phase
Phase 169 — Supporting UX Alignment & Validation
- Align `drivers/pi/extensions/README.md`, related Pi discovery surfaces, and validation expectations to the calmer lifecycle presentation.
- Decide whether any adjacent prompt/notification wording needs light-touch alignment with the new runtime hierarchy.
- Preserve the bounded additive Pi model; do not reopen lifecycle ownership or invent new persistent surfaces.
