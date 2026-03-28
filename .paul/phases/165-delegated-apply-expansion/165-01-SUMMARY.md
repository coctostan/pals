---
phase: 165-delegated-apply-expansion
plan: 01
completed: 2026-03-28T17:54:54Z
duration: same-session implementation and validation
---

## Objective
Broaden delegated APPLY eligibility so more bounded autonomous tasks can route through `pals-implementer` under explicit parent control, without weakening verification, module enforcement, fallback, or `.paul/*` lifecycle authority.

## What Was Built
| File | Purpose | Lines |
|------|---------|-------|
| `kernel/workflows/apply-phase.md` | Broadened delegated APPLY eligibility from a parallel-leaning posture to a bounded parent-verifiable task model while preserving explicit parent authority and inline fallback boundaries. | 725 |
| `kernel/references/subagent-criteria.md` | Distinguished generic subagent parallelism from the narrower PALS delegated APPLY contract and updated the decision framework around parent authority and equivalence. | 185 |
| `.pi/agents/pals-implementer.md` | Aligned the repo-owned implementer agent with the broader bounded-task posture, explicit task-local verification reporting, and stronger stop/fallback triggers. | 62 |
| `drivers/pi/skills/paul-apply/SKILL.md` | Kept the thin Pi wrapper aligned with the broadened but still parent-authoritative delegated APPLY contract. | 19 |
| `tests/pi-end-to-end-validation.sh` | Added installed-surface assertions that the Pi-installed apply workflow, Pi wrapper, and installed `pals-implementer` retain the broadened bounded-delegation markers. | 951 |
| `tests/cross-harness-validation.sh` | Added cross-harness assertions that both installed shared apply workflows preserve the broadened parent-controlled delegation markers. | 574 |

## Acceptance Criteria Results
| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Delegated APPLY eligibility is broadened without weakening parent authority | ✅ PASS | `kernel/workflows/apply-phase.md` now allows a single eligible task or sequential task step when the parent can still verify equivalence, while keeping `.paul/*`, module enforcement, fallback, and official verification in the parent. |
| AC-2 | Repo-owned delegated APPLY surfaces stay aligned with the widened contract | ✅ PASS | `.pi/agents/pals-implementer.md` and `drivers/pi/skills/paul-apply/SKILL.md` now describe the broader bounded-task posture, verification/reporting expectations, and explicit ambiguity/non-equivalence fallback. |
| AC-3 | Validation catches delegation-contract drift across repo and installed surfaces | ✅ PASS | `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` now assert the broadened delegation markers on installed apply workflow / skill / agent surfaces after reinstall. |

## Verification Results
- `grep -n 'eligible\|delegat\|pals-implementer\|fallback\|equivalent' kernel/workflows/apply-phase.md kernel/references/subagent-criteria.md`
  - Confirmed the canonical APPLY workflow and shared criteria now encode the broadened bounded-delegation model and explicit inline fallback boundaries.
- `grep -n 'pals-implementer\|bounded\|fallback\|verification\|module enforcement' .pi/agents/pals-implementer.md drivers/pi/skills/paul-apply/SKILL.md`
  - Confirmed the repo-owned agent and Pi thin wrapper remain aligned with the parent-authoritative contract.
- `PALS_ROOT="$PWD" bash drivers/pi/install.sh`
  - Reinstalled Pi assets successfully so installed-surface validation checked the actual deployed workflow/skill/agent files.
- `bash tests/pi-end-to-end-validation.sh`
  - Passed: 151 / 151 checks.
- `bash tests/cross-harness-validation.sh`
  - Passed: 62 / 62 checks.
- `/usr/bin/git diff --stat -- kernel/workflows/apply-phase.md kernel/references/subagent-criteria.md .pi/agents/pals-implementer.md drivers/pi/skills/paul-apply/SKILL.md tests/pi-end-to-end-validation.sh tests/cross-harness-validation.sh`
  - Confirmed the planned six repo files changed for the implementation and proof surfaces.

## Module Execution Reports
### Post-Apply Advisory
- `[dispatch] post-apply advisory: IRIS(skip — workflow/skill/validation text changes only, no code-review smell surface beyond the explicit contract edits) | DOCS(0 annotations — the changed shared/Pi guidance stayed internally aligned with the canonical contract) | RUBY(skip — no refactor/debt-specific source changes outside the targeted delegation contract wording) | SKIP(1 annotation — remember that delegated APPLY validation is strongest when it checks installed surfaces, not only repo source text)`

### Post-Apply Enforcement
- `[dispatch] post-apply enforcement: WALT(PASS — Pi installer plus Pi and cross-harness validation suites passed) | DEAN(skip — no dependency manifest or lockfile changed in this phase) | TODD(PASS — contract-focused shell validation covered the changed workflow/skill/test surfaces and caught no regression)`

## Deviations
- The installed `modules.yaml` was available during APPLY, but this phase still used targeted contract verification and installer-backed shell suites rather than a richer repo-wide lint/typecheck baseline. That was sufficient for the workflow/config/test scope of this phase.

## Key Patterns / Decisions
- Delegated APPLY should be framed around bounded parent-verifiable task packets, not generic parallel subagent heuristics.
- The repo-owned `pals-implementer`, thin Pi wrapper, and shared workflow text must move together whenever delegated APPLY policy changes.
- Installed-surface validation remains the durable proof mechanism for shared workflow contract changes.

## Skill Audit
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Normal PLAN → APPLY execution completed for Phase 165. |
| /carl | ✓ | Treated as active via the installed Pi runtime/extension path during the session. |
| TODD | ✓ | Enforced through APPLY/validation expectations; contract-focused verification passed. |
| WALT | ✓ | Enforced through post-change validation gates; installer-backed suites passed. |

## Next Phase
Run `/skill:paul-unify .paul/phases/165-delegated-apply-expansion/165-01-PLAN.md` to reconcile the executed work, update milestone artifacts, and close Phase 165.
