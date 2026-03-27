---
phase: 157-validation-and-polish
plan: 01
completed: 2026-03-27T20:41:25Z
duration: same-session validation, documentation polish, and live verification
---

## Objective
Validate the PALS-native implementer path in real repo use, harden automated proof around delegated APPLY and REV separation, and polish the final Pi operating-model documentation without regressing the parent-authoritative lifecycle model.

## What Was Built
| File | Purpose | Lines |
|------|---------|-------|
| `tests/pi-end-to-end-validation.sh` | Added durable Pi-side proof for agent installation, bounded parent-authority contract markers, and delegated APPLY vs REV separation. | 750 |
| `tests/cross-harness-validation.sh` | Added shared-surface assertions for delegated APPLY / REV boundaries and tightened one durable-reporting assertion to stable existing markers. | 541 |
| `README.md` | Documented Pi's three install surfaces, `pals-implementer`, parent-authoritative delegated APPLY, and separate REV review routing. | 288 |
| `drivers/pi/extensions/README.md` | Documented Pi extension/skill/project-agent install boundaries and bounded delegated APPLY semantics. | 174 |
| `drivers/pi/skill-map.md` | Documented the three Pi install surfaces and clarified that `pals-implementer` is a helper, not a second APPLY authority. | 103 |
| `CHANGELOG.md` | Added the v2.34.0 validation/polish entry for proof hardening, install visibility, and final operating-model docs. | 318 |
| `.paul/QUALITY-HISTORY.md` | Recorded the first durable quality-history baseline for the validation suites used in this loop. | 12 |
| `.paul/STATE.md` | Recorded APPLY completion, archived handoff consumption, and UNIFY/transition state for the loop. | 152 |

## Acceptance Criteria Results
| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Automated validation covers delegated APPLY and REV separation | ✅ PASS | `tests/pi-end-to-end-validation.sh` now proves `~/.pi/agent/agents/pals-implementer.md` is installed, preserves parent-authority contract markers, and keeps delegated APPLY distinct from `/paul:review` + `code-reviewer`; `tests/cross-harness-validation.sh` now verifies only shared, non-Pi-install-specific boundary assertions. |
| AC-2 | Live validation proves the operating model end-to-end | ✅ PASS | Temporary-HOME install with `PALS_ROOT=$(pwd) HOME="$TEMP_HOME" bash drivers/pi/install.sh` produced `~/.pi/agent/agents/pals-implementer.md`; both validation suites passed; targeted grep checks confirmed delegated APPLY remains parent-authoritative and REV remains intact. |
| AC-3 | Documentation matches the shipped behavior | ✅ PASS | `README.md`, `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, and `CHANGELOG.md` now explicitly describe Pi's three install surfaces, bounded delegated APPLY, and `/paul:review` as the separate `code-reviewer` path. |

## Verification Results
- `bash tests/pi-end-to-end-validation.sh`
  - Passed: 123/123 checks.
- `bash tests/cross-harness-validation.sh`
  - Passed: 60/60 checks after tightening one durable-reporting assertion to existing stable markers and adding explicit README multi-driver wording.
- `TEMP_HOME=$(mktemp -d) && PALS_ROOT=$(pwd) HOME="$TEMP_HOME" bash drivers/pi/install.sh && test -f "$TEMP_HOME/.pi/agent/agents/pals-implementer.md"`
  - Passed: temp-HOME Pi install created the expected installed helper agent.
- `grep -n 'pals-implementer' kernel/workflows/apply-phase.md drivers/pi/skills/paul-apply/SKILL.md drivers/pi/extensions/pals-hooks.ts .pi/agents/pals-implementer.md`
  - Confirmed delegated APPLY still routes through `pals-implementer` across workflow, Pi skill, extension guidance, and agent definition surfaces.
- `grep -n 'code-reviewer\|/paul:review' drivers/pi/skills/paul-review/SKILL.md README.md drivers/pi/extensions/README.md`
  - Confirmed REV remains the separate on-demand review path and was not repurposed for delegated APPLY.

## Module Execution Reports
### Carried Forward From APPLY
- ⚠️ Post-apply advisory/enforcement module dispatch did not run during APPLY. No apply-phase module annotations were carried forward into UNIFY for this loop.

### Pre-UNIFY
- `[dispatch] pre-unify: 0 modules registered for this hook`

### Post-UNIFY
#### WALT
- Created `.paul/QUALITY-HISTORY.md` with a baseline entry for plan `157-01` using this loop's durable validation evidence: `tests/pi-end-to-end-validation.sh` passed 123/123 checks and `tests/cross-harness-validation.sh` passed 60/60 checks.
- Coverage, lint, and typecheck remain `—` for this plan because the repo's relevant proof surface here is shell-based validation rather than a repo-wide coverage/lint/typecheck pipeline.
- Side effect: quality history is now present for future unify comparisons.

#### SKIP
## 2026-03-27 Validate delegated APPLY with explicit Pi install surfaces
**Type:** decision
**Phase:** 157 Validation & Polish
**Related:** `tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh`, `README.md`, `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`

**Context:** Phase 156 shipped the bounded `pals-implementer` path, but the repo still needed durable proof that Pi installs the helper agent correctly, that delegated APPLY remains parent-authoritative, and that REV is still a separate on-demand review path.

**Decision:** Encode the proof directly in the validation suites and document Pi as three explicit install surfaces: skill/kernel files, extension runtime, and project-shipped helper agents.

**Alternatives considered:**
- Leave the proof implicit in source files only — rejected because the operating model would remain easy to misread and validation would not protect it.
- Treat REV and delegated APPLY as interchangeable subagent paths — rejected because it would blur authority boundaries and reopen settled design decisions.

**Rationale:** Text-based assertions against stable source markers and explicit install-surface docs make the shipped behavior durable, reviewable, and harder to regress.

**Impact:** Future work now has executable proof for the implementer path and clearer docs without moving lifecycle truth into Pi.

#### RUBY
- Changed files remain bounded, but the two validation scripts are large orchestration assets (`tests/pi-end-to-end-validation.sh` at 750 lines and `tests/cross-harness-validation.sh` at 541 lines).
- Phase 157 kept changes additive and localized; future refinement can still extract helper functions if these validation surfaces continue to grow.
- No new debt hotspot was introduced outside those already-large validation scripts.

## Deviations
- No material scope deviation from the approved plan.
- One bounded follow-up polish emerged during live validation: the cross-harness durable-reporting assertion for RUBY was tightened to match stable existing markers in `modules/ruby/module.yaml`, and `README.md` gained the exact multi-driver wording the shared validation suite expects.
- APPLY archived the active root handoff into `.paul/handoffs/archive/` as part of standard lifecycle bookkeeping.

## Key Patterns / Decisions
- Delegated APPLY remains a helper path, not a second lifecycle authority.
- Pi's runtime model is now explicit as three shipped surfaces: skills/kernel, extension, and project-shipped agents.
- Durable proof is strongest when assertions target stable behavior markers instead of brittle line-number assumptions.

## Next Phase
Phase 157 is the last phase of milestone v2.34. After transition and merge-gate handling, the project is ready either to define the next milestone or pause with v2.34 complete.
