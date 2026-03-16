---
phase: 61-ux-polish-validation-interoperability-guardrails
plan: 01
completed: 2026-03-16T15:27:08Z
duration: 1 session
---

# Phase 61 Plan 01: UX Polish, Validation & Interoperability Guardrails Summary

## Objective
Polish the Pi lifecycle surface wording and placement, strengthen low-clutter validation guardrails, and verify that Pi's convenience layer remains interoperable with Claude Code-oriented PALS usage without creating Pi-only workflow truth.

## What Was Built
| File | Purpose | Notes |
|------|---------|-------|
| `drivers/pi/extensions/pals-hooks.ts` | Tightened always-visible lifecycle wording and bounded quick-action presentation | Added explicit 3-primary / 5-total quick-action limits, renamed visible quick-action copy to a lighter `Actions:` / `More:` format, and surfaced session-start guidance clarifying that TODD/WALT load via `modules.yaml` + workflow dispatch rather than standalone Pi skills. |
| `drivers/pi/extensions/README.md` | Documented the polished Pi extension surface and module-overlay model | README now explains bounded quick actions, `modules.yaml`-driven module overlays, and the adapter-only relationship between `/paul-*`, `/skill:paul-*`, and Pi runtime events. |
| `drivers/pi/skill-map.md` | Clarified how Pi loads workflow and module surfaces | Skill map now explicitly distinguishes canonical skills from installed module overlays and explains that TODD/WALT are dispatched from `modules.yaml` during PLAN/APPLY/UNIFY. |
| `drivers/pi/skills/paul-help/SKILL.md` | Improved user-facing Pi guidance | Help now tells users that TODD/WALT are module overlays in Pi, not standalone skills to invoke manually. |
| `tests/pi-end-to-end-validation.sh` | Locked in low-clutter and module-overlay guardrails | Validation now checks the bounded quick-action contract and verifies that Pi discovery surfaces explain module overlays vs standalone skills. |
| `tests/cross-harness-validation.sh` | Corrected and extended Pi ↔ Claude Code interoperability checks | Validation now expects Pi's current runtime capability model (`hook_register=true`, `command_register=true`), checks that Pi `modules.yaml` includes TODD/WALT overlays, and verifies README multi-driver guidance. |
| `README.md` | Updated top-level multi-driver and interoperability guidance | README now presents Claude Code, Pi, and Agent SDK together, explains Pi's wrapper/canonical skill surfaces, and notes that Pi installs module overlays via `modules.yaml`. |
| `.paul/phases/61-ux-polish-validation-interoperability-guardrails/61-01-SUMMARY.md` | Recorded execution and reconciliation for UNIFY | Captures the first end-to-end Pi execution findings and the resulting guardrails. |

## Acceptance Criteria Results
| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | The Pi lifecycle surface is cleaner without losing guidance | Pass | `drivers/pi/extensions/pals-hooks.ts` now keeps the visible quick-action layer explicitly bounded and uses lighter `Actions:` / `More:` wording while still surfacing milestone, phase, loop, and next action from `.paul/STATE.md`. |
| AC-2 | Pi guardrails preserve adapter-only routing and lifecycle truth | Pass | Pi docs, help text, and validation all preserve `/paul-*` wrappers, `/skill:paul-*` canonical entry points, one automatic context injection site, and `.paul/*` as the only lifecycle truth. |
| AC-3 | Pi behavior is explicitly interoperable with Claude Code-oriented PALS usage | Pass | `README.md` and `tests/cross-harness-validation.sh` now describe the multi-driver model accurately and validate Pi's current capability/overlay behavior alongside Claude Code surfaces. |

## Verification Results
| Check | Result |
|-------|--------|
| `npx -y esbuild drivers/pi/extensions/pals-hooks.ts --bundle --platform=node --format=cjs --outfile=/tmp/pals-hooks.js --external:@mariozechner/pi-tui` | Pass |
| `grep -n "setStatus\|setWidget\|Actions:\|/skill:paul-\|Ctrl+Alt+N\|modules.yaml" drivers/pi/extensions/pals-hooks.ts drivers/pi/extensions/README.md drivers/pi/skill-map.md drivers/pi/skills/paul-help/SKILL.md` | Pass |
| `bash tests/pi-end-to-end-validation.sh` | Pass (90/90 checks passed) |
| `bash tests/cross-harness-validation.sh` | Pass (47/47 checks passed) |

## Deviations
### Summary
| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 2 | Low |
| Scope additions | 0 | None |
| Deferred | 0 | None |

**Total impact:** Low. The plan executed within scope, and the only meaningful deviations were corrective guardrails discovered during the first real Pi end-to-end execution.

### Auto-fixed Issues
**1. Pi skill-vs-module loading ambiguity**
- **Found during:** APPLY startup before task execution
- **Issue:** The workflow treated TODD/WALT as required standalone skills even though Pi installs them as module overlays via `modules.yaml`
- **Fix:** Interpreted them conservatively as installed module overlays for this execution, documented the behavior in Pi-facing docs/help, and added validation coverage so the distinction is explicit going forward
- **Files:** `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, `drivers/pi/skills/paul-help/SKILL.md`, `tests/pi-end-to-end-validation.sh`, `README.md`
- **Verification:** `bash tests/pi-end-to-end-validation.sh`, manual inspection of installed `~/.pi/agent/skills/pals/modules.yaml`

**2. Stale Pi capability expectation in cross-harness validation**
- **Found during:** Task 3 verification
- **Issue:** `tests/cross-harness-validation.sh` still expected `hook_register=false` and `command_register=false` even though `drivers/pi/driver.yaml` now correctly declares both as `true`
- **Fix:** Updated the test to match the current Pi driver model and added README/overlay checks to make the newer contract explicit
- **Files:** `tests/cross-harness-validation.sh`, `README.md`
- **Verification:** `bash tests/cross-harness-validation.sh`

## Key Patterns / Decisions
| Decision | Rationale | Impact |
|----------|-----------|--------|
| Keep the Pi quick-action layer bounded to 3 primary / 5 total actions | Preserves low-clutter always-visible UX while still exposing the most important lifecycle entry points | Makes the lifecycle surface easier to scan and easier to regression-test |
| Explain TODD/WALT as module overlays in Pi instead of pretending they are standalone skills | Matches how the installer and `modules.yaml` actually work today | Removes confusion during first-run APPLY and makes module dispatch semantics explicit |
| Validate Pi and Claude Code surfaces together at the repository level | Cross-harness drift was already visible in validation expectations | Makes future Pi adapter changes safer and easier to audit |

## Issues Encountered
| Issue | Resolution |
|-------|------------|
| First real Pi APPLY surfaced confusion around how TODD/WALT are “loaded” | Investigated installer + `modules.yaml` behavior, documented the true model, and treated it as a conservative module-overlay interpretation rather than a blocker |
| Cross-harness validation no longer matched the current Pi manifest | Updated the test contract to the manifest actually shipped in the repo and re-ran the suite successfully |

## Skill Audit
Required skill note: `/paul` was invoked normally. TODD and WALT were not separate Pi skills; for this phase they were confirmed as installed module overlays via `~/.pi/agent/skills/pals/modules.yaml` and workflow dispatch semantics. No unresolved specialized-flow gaps remain.

## Next Phase
Phase 61 is complete.

Next up:
- **Milestone complete — v2.4 Pi Native UX Layer**
- All three phases (59-61) are now complete and unified
- Suggested next action: `/skill:paul-milestone`

---
*Phase: 61-ux-polish-validation-interoperability-guardrails, Plan: 01*
*Completed: 2026-03-16*
