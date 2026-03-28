---
phase: 164-implementer-config-contract-alignment
plan: 01
completed: 2026-03-28T16:17:02Z
duration: same-session implementation and validation
---

## Objective
Align the canonical `pals.json` contract so explicit `agents.implementer` config is created by init, preserved by migration, documented in the schema reference, and covered by validation before delegated APPLY policy expands further.

## What Was Built
| File | Purpose | Lines |
|------|---------|-------|
| `kernel/workflows/init-project.md` | Added explicit `agents.implementer` migration guidance and canonical init JSON defaults so fresh and migrated projects share the same implementer config contract. | 1039 |
| `kernel/references/pals-json-schema.md` | Added an `agents` section documenting `agents.implementer.enabled` and `agents.implementer.model` plus migration expectations. | 148 |
| `tests/pi-end-to-end-validation.sh` | Added installed-surface assertions proving the Pi-installed init workflow and schema reference preserve explicit implementer config markers. | 946 |
| `tests/cross-harness-validation.sh` | Added cross-harness assertions proving both installed shared init workflows and schema references preserve the implementer config contract. | 570 |

## Acceptance Criteria Results
| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Init and migration produce the implementer config block | ✅ PASS | `kernel/workflows/init-project.md` now adds missing `agents.implementer` during migration and includes the `agents` block in the canonical generated `pals.json` example. |
| AC-2 | Schema documentation matches runtime expectations | ✅ PASS | `kernel/references/pals-json-schema.md` now documents `agents.implementer.enabled` and `agents.implementer.model` in a dedicated `## agents` section. |
| AC-3 | Validation catches future contract drift | ✅ PASS | `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` now assert the installed init/schema surfaces retain explicit implementer config markers after install. |

## Verification Results
- `grep -n '"agents"\|"implementer"' kernel/workflows/init-project.md`
  - Confirmed the canonical init workflow now contains the `agents` block and implementer defaults.
- `grep -n '## agents\|agents\.implementer' kernel/references/pals-json-schema.md`
  - Confirmed the schema reference now documents the implementer config fields.
- `PALS_ROOT="$PWD" bash drivers/pi/install.sh`
  - Reinstalled Pi assets successfully using the required environment expected by the driver installer.
- `bash tests/pi-end-to-end-validation.sh`
  - Passed: 151 / 151 checks.
- `bash tests/cross-harness-validation.sh`
  - Passed: 62 / 62 checks.
- `/usr/bin/git diff --stat -- kernel/workflows/init-project.md kernel/references/pals-json-schema.md tests/pi-end-to-end-validation.sh tests/cross-harness-validation.sh`
  - Confirmed exactly the planned four repo files changed (`62 insertions`).

## Module Execution Reports
### Carried Forward From APPLY
- ⚠️ APPLY did not execute normal post-apply module dispatch from a loaded installed registry at task time. The loop still produced durable verification via targeted grep checks plus Pi/cross-harness validation after reinstall.
- TODD / WALT: No standard repo-wide test/lint/typecheck baseline was available for this workflow/config phase. Validation remained contract-focused through installer-backed shell suites.
- DEAN: No supported package-manager audit manifest was present at the repo root, so dependency-audit blocking did not apply.

### Pre-UNIFY
- `[dispatch] pre-unify: SKIPPED — installed modules.yaml was not loaded as a normal workflow input during this session; no pre-unify context injectors were executed.`

### Post-UNIFY
- ⚠️ Post-unify hooks did not fire. Reason: installed modules.yaml was not loaded through the normal shared hook-dispatch path in this session. Quality history, knowledge capture, and debt analysis were not recorded for this loop.
- Despite skipped hook dispatch, the phase has durable verification evidence from the installer-backed validation suites added in this plan.

## Deviations
- The Pi driver installer cannot be invoked bare as `bash drivers/pi/install.sh`; it requires `PALS_ROOT="$PWD"` (or the root installer environment). Verification used the correct invocation and this should be remembered for future installer-backed validation work.
- The initial plan incorrectly marked `/carl`, `TODD`, and `WALT` as not loaded, which would have caused a false APPLY block. The plan was corrected to reflect runtime/module availability before execution continued.

## Key Patterns / Decisions
- Canonical config examples, migration guidance, and schema docs must move together whenever the runtime starts reading a new `pals.json` field.
- Validation for shared workflow contracts is strongest when it checks installed shared assets, not just repo source text.
- Delegated APPLY policy remains unchanged; this phase only aligned the config contract that Phase 165 will rely on.

## Skill Audit
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Normal PLAN → APPLY → UNIFY lifecycle executed. |
| /carl | ✓ | Treated as active via installed Pi runtime/extension path rather than a separate callable skill command. |
| TODD | ✓ | Present as required module overlay semantics for APPLY/UNIFY, though no normal hook dispatch evidence was produced in this session. |
| WALT | ✓ | Present as required module overlay semantics for APPLY/UNIFY, though no normal hook dispatch evidence was produced in this session. |

## Next Phase
Phase 165 should broaden delegated APPLY eligibility using the now-explicit implementer config contract, while preserving parent verification, module enforcement, fallback, and `.paul/*` authority.
