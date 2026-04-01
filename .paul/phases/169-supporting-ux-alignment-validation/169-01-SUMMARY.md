---
phase: 169-supporting-ux-alignment-validation
plan: 01
subsystem: ui
completed: 2026-04-01T19:53:03Z
duration: ~24 min
---

## Objective
Align the Pi-facing docs, discovery surfaces, and validation contract around the calmer lifecycle presentation shipped in Phase 168 so the documented and tested adapter behavior matches the strict milestone / phase / loop / next-action hierarchy.

## What Was Built
| File | Purpose | Lines |
|------|---------|-------|
| `drivers/pi/extensions/README.md` | Reframed the persistent lifecycle surface around milestone / phase / loop / next action and described shortcuts as entry points instead of persistent rows | 171 |
| `drivers/pi/skill-map.md` | Aligned the Pi discovery map to the calm lifecycle surface and kept shortcut/helper-agent guidance bounded | 101 |
| `drivers/pi/skills/paul-help/SKILL.md` | Updated help guidance so shortcut and canonical-skill explanations match the calm lifecycle contract | 51 |
| `tests/pi-end-to-end-validation.sh` | Added semantic guardrails that reject legacy `PALS Lifecycle` / `Actions:` / `More:` widget regressions while preserving existing adapter-boundary coverage | 1025 |

## Acceptance Criteria Results
| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Pi-facing docs describe the calmer lifecycle contract instead of the pre-Phase-168 presentation | PASS | README, skill map, and help skill now describe the persistent surface as milestone / phase / loop / next action and frame shortcuts as routing entry points |
| AC-2 | Validation protects the calmer lifecycle contract with semantic guardrails | PASS | `tests/pi-end-to-end-validation.sh` now asserts the calm 4-line hierarchy and rejects `PALS Lifecycle`, `Actions:`, and `More:` regressions without using brittle snapshots |
| AC-3 | Adjacent runtime wording and final verification stay aligned with the bounded Pi model | PASS | `drivers/pi/extensions/pals-hooks.ts` was inspected, no wording drift requiring source edits was found, and esbuild plus Pi end-to-end validation both passed |

## Verification Results
- `grep -q 'milestone, phase, loop, and next action' drivers/pi/extensions/README.md && grep -q 'Ctrl+Alt+N' drivers/pi/extensions/README.md && ! grep -q 'secondary "More" line' drivers/pi/extensions/README.md && grep -q 'shortcut' drivers/pi/skill-map.md && grep -q 'canonical' drivers/pi/skills/paul-help/SKILL.md` → PASS
- `bash tests/pi-end-to-end-validation.sh` → PASS (`159/159` checks)
- `npx -y esbuild drivers/pi/extensions/pals-hooks.ts --bundle --platform=node --format=cjs --outfile=/tmp/pals-hooks-p169.js --external:@mariozechner/pi-tui && bash tests/pi-end-to-end-validation.sh` → PASS
- PR branch: `feature/169-supporting-ux-alignment-validation` with PR `https://github.com/coctostan/pals/pull/79`

## Module Execution Reports
- `[dispatch] pre-unify: 0 modules registered for this hook`

### Carry-forward APPLY annotations
- TODD: the phase stayed on the existing shell-based Pi validation surface and finished with the full suite green.
- WALT: APPLY ended with `159 pass`, no regressions, and the calm lifecycle contract remained bounded to approved adapter events and additive Pi surfaces.
- DEAN: `npm audit --json` still reports `0 critical`, `1 high`, and `5 moderate`; no new critical/high vulnerabilities were introduced by this phase.
- DOCS: the expected drift around the calmer lifecycle surface was resolved in the touched Pi discovery docs.
- SKIP: APPLY confirmed the Phase 169 conditional runtime inspection was a no-op because `drivers/pi/extensions/pals-hooks.ts` already matched the intended calmer contract.

### WALT
| Metric | Before | After | Delta | Verdict |
|--------|--------|-------|-------|---------|
| Tests | `156 pass` | `159 pass` | `+3` | `↑ improving` |
| Coverage | `—` | `—` | `—` | `—` |
| Lint | `—` | `—` | `—` | `—` |
| Typecheck | `—` | `—` | `—` | `—` |

Side effect:
- Recorded Phase `169-01` in `.paul/quality-history.md` with the updated `159 pass` validation result.

### SKIP
#### Decision Record
## [2026-04-01] Keep Phase 169 lifecycle alignment semantic and documentation-first when runtime wording already matches

**Type:** decision
**Phase:** 169 Supporting UX Alignment & Validation
**Related:** `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, `drivers/pi/skills/paul-help/SKILL.md`, `tests/pi-end-to-end-validation.sh`, PR #79

**Context:** Phase 169 explicitly allowed a small wording cleanup in `drivers/pi/extensions/pals-hooks.ts` if adjacent runtime copy drifted from the calmer lifecycle contract introduced in Phase 168.

**Decision:** Keep the runtime source unchanged because inspection showed the existing `pals-hooks.ts` wording already matched the calmer lifecycle hierarchy; perform the alignment entirely in docs and semantic validation instead.

**Alternatives considered:**
- Force a runtime wording edit anyway — rejected because it would add churn without changing user-visible behavior or improving the contract.
- Reopen the Phase 168 render hierarchy to make the validation easier to express — rejected because the runtime already met the intended bounded additive Pi model.

**Rationale:** The safest alignment is to document and validate the shipped behavior rather than perturb a working runtime path just to make the change feel broader.

**Impact:** Future Pi UX follow-up work should prefer semantic contract checks and documentation alignment before touching stable lifecycle rendering code.

#### Lesson Learned
## [2026-04-01] Semantic guardrails are a better fit than snapshot assertions for the Pi lifecycle surface

**Type:** lesson
**Phase:** 169 Supporting UX Alignment & Validation
**Related:** `tests/pi-end-to-end-validation.sh`, PR #79

**What happened:** The calmer lifecycle follow-up needed stronger validation, but the meaningful regressions were structural (`PALS Lifecycle`, `Actions:`, `More:` coming back) rather than exact line-by-line output changes.

**What we learned:** Guarding for approved fields and bounded legacy-regression markers keeps the Pi contract durable without overfitting tests to cosmetic wording or formatting.

**How to apply:** Keep future Pi lifecycle validation structural and contract-oriented unless a user-visible formatting guarantee is genuinely part of the feature.

### RUBY
- `npx eslint --no-eslintrc --rule 'complexity: [warn, 10]' --format json drivers/pi/extensions/pals-hooks.ts` reported no complexity warnings.
- `wc -l` still shows `drivers/pi/extensions/pals-hooks.ts` at `1331` lines and `tests/pi-end-to-end-validation.sh` at `1025` lines, both above RUBY's critical file-size threshold.
- This phase kept edits precise and avoided growing `pals-hooks.ts`, but future work should continue resisting accretion in these two large files.

## Deviations
### Summary
| Type | Count | Impact |
|------|-------|--------|
| Conditional no-op | 1 | No scope or behavior impact |
| Scope additions | 0 | None |
| Deferred | 0 | None |

**Total impact:** No material deviation. The only variance was that the planned conditional inspection of `drivers/pi/extensions/pals-hooks.ts` confirmed no change was necessary.

## Key Patterns / Decisions
- Keep the persistent Pi lifecycle surface described as milestone / phase / loop / next action, with shortcuts framed as entry points rather than persistent rows.
- Prefer semantic validation guardrails over brittle snapshot assertions for the Pi lifecycle contract.
- Treat `drivers/pi/extensions/pals-hooks.ts` as stable runtime behavior unless source inspection proves actual wording drift.

## Skill Audit
All required skills in the Phase 169 plan were invoked.

| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the docs and validation alignment phase |
| /carl | ✓ | Session-boundary routing remained active while the phase moved across APPLY and UNIFY |
| TODD | ✓ | APPLY kept validation sequencing disciplined even though the work stayed on an existing shell validation surface |
| WALT | ✓ | Validation ran during APPLY and durable quality evidence was recorded during UNIFY |

## Next Phase
Phase 169 is the final phase of v2.38.
- Milestone completion is ready once merge-gate and transition steps finish.
- The next lifecycle action should be next-milestone routing rather than another plan inside v2.38.
