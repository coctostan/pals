---
phase: 156-pals-implementer-integration
plan: 01
completed: 2026-03-27T18:45:00Z
duration: same-day implementation with two follow-up fixes
---

## Objective
Implement the first PALS-native implementer path for Pi so APPLY can delegate eligible bounded tasks through a `pals-implementer` agent while keeping verification, module enforcement, fallback, and `.paul/*` lifecycle authority in the parent.

## What Was Built
| File | Purpose | Lines |
|------|---------|-------|
| `.pi/agents/pals-implementer.md` | New delegated APPLY agent definition with explicit parent-authority guardrails and structured reporting contract. | 56 |
| `kernel/workflows/apply-phase.md` | Added eligibility rules, task-packet requirements, `Agent()` dispatch contract, structured subagent report shape, and inline fallback triggers. | 723 |
| `drivers/pi/skills/paul-apply/SKILL.md` | Updated Pi skill guidance so delegated APPLY remains task-bounded and parent-controlled. | 57 |
| `pals.json` | Added minimal `agents.implementer` config surface for enable/model policy. | 93 |
| `drivers/pi/extensions/pals-hooks.ts` | Added bounded Pi guidance clarifying that delegated APPLY is prompt/workflow-first and parent-authoritative. | 1331 |
| `drivers/pi/install.sh` | Follow-up installer support to copy project-shipped Pi agents from `.pi/agents` into `~/.pi/agent/agents` for cross-repo use. | 380 |
| `.paul/STATE.md` | Recorded APPLY completion, follow-up fix context, and later UNIFY/transition state. | 149 |
| `.paul/ROADMAP.md` | Moved milestone tracking from Phase 156 planning into Phase 156 complete / Phase 157 next. | 620 |

## Acceptance Criteria Results
| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Repo-local implementer path is concrete and bounded | ✅ PASS | `.pi/agents/pals-implementer.md` exists, is task-bounded, forbids `.paul/*` lifecycle ownership, and requires explicit reporting back to the parent. |
| AC-2 | APPLY delegation remains parent-controlled and fallback-safe | ✅ PASS | `kernel/workflows/apply-phase.md` now defines eligibility, task packet assembly, foreground `Agent()` dispatch, required report fields, and explicit inline fallback triggers. |
| AC-3 | Config and Pi-facing behavior stay narrow and non-regressive | ✅ PASS | `pals.json` only adds `agents.implementer`; `drivers/pi/extensions/pals-hooks.ts` adds bounded guidance only; REV call sites remain untouched. |

## Verification Results
- `grep -n "pals-implementer\|task-bounded\|\.paul/\*\|report" .pi/agents/pals-implementer.md`
  - Confirmed the agent identity, `.paul/*` lifecycle guardrails, and report-oriented output contract.
- `grep -n "pals-implementer\|Agent()\|fallback\|delegat\|eligib\|report" kernel/workflows/apply-phase.md drivers/pi/skills/paul-apply/SKILL.md`
  - Confirmed parent-controlled delegation, `Agent()` dispatch, fallback rules, and Pi skill wording updates.
- `grep -n "implementer\|pals-implementer" pals.json drivers/pi/extensions/pals-hooks.ts`
  - Confirmed minimal config plus bounded Pi guidance.
- `bash -n drivers/pi/install.sh`
  - Passed shell syntax validation after adding global agent install support.
- Installer smoke test with a temporary `HOME`
  - Confirmed `drivers/pi/install.sh` creates `~/.pi/agent/agents/pals-implementer.md` during install.
- Local targeted lint/syntax check for touched orchestration files
  - No immediate issues surfaced for `kernel/workflows/apply-phase.md` or `drivers/pi/extensions/pals-hooks.ts` during local validation.

## Module Execution Reports
### Carried Forward From APPLY
- TODD / WALT: No runnable repo-wide test suite or baseline quality command was detected, so APPLY verification remained targeted to workflow/installer changes rather than full-suite regression checks.
- DEAN: No supported package-manager manifest was detected at the repo root, so dependency audit blocking did not apply in this phase.
- DOCS: Delegated APPLY and installer-supported agent behavior changed without corresponding README / CHANGELOG updates. This remains doc drift for Phase 157.

### Pre-UNIFY
- `[dispatch] pre-unify: 0 modules registered for this hook`

### Post-UNIFY
#### WALT
- No quality data to record for this phase. Repo-wide test/lint/typecheck baselines were not available, so `.paul/quality-history.md` was not updated.

#### SKIP
## 2026-03-27 Install project-shipped Pi agents globally
Type: decision
Phase: 156
Context: The initial Phase 156 implementation introduced `.pi/agents/pals-implementer.md`, but repo-local discovery alone would not make the agent available in other repos that only consume installed PALS assets.
Decision: Update `drivers/pi/install.sh` to copy project-shipped Pi agents from `.pi/agents` into `~/.pi/agent/agents` during install.
Alternatives considered:
- Keep the implementer repo-local only — rejected because installed PALS would not provide the agent outside the PALS repo.
- Rely on project-agent scope/config alone — rejected because cross-repo availability would become implicit and fragile.
Rationale: Global installation preserves the single-install contract and matches how Pi skills/extensions are provisioned.
Impact: `pals-implementer` is now available as a user-level Pi agent after install while remaining repo-authored in source control.

#### RUBY
- `kernel/workflows/apply-phase.md` (723 lines) and `drivers/pi/extensions/pals-hooks.ts` (1331 lines) remain large orchestration files.
- The delegated APPLY changes were additive and bounded, but future extraction/refinement remains appropriate in Phase 157+.
- The installer change is localized, but the APPLY workflow remains the primary concentration of orchestration complexity.

## Deviations
- `drivers/pi/install.sh` was added after the initial APPLY implementation because repo-local agent discovery alone was insufficient for cross-repo use. This expanded the phase slightly beyond the original `files_modified` list but aligned with the install contract and user-facing goal.
- Final `pals-implementer` defaults were tuned after the first implementation commit (`model`, `thinking`, `extensions`, `skills`) without changing the authority contract or file scope.
- Branch diff includes an unexpected documentation-only edit in `.paul/phases/151-research-and-design/rev-design.md`; it was not part of 156-01 scope and should be reviewed separately.

## Key Patterns / Decisions
- Parent-controlled delegation, not subagent-owned lifecycle state, remains the governing pattern.
- A PALS-native implementer needs both a repo-authored definition and an install path when the goal is cross-repo usability after install.
- Pi guidance remains prompt/workflow-first; the extension only surfaces bounded reminders and does not become a second lifecycle engine.

## Next Phase
Phase 157 should validate delegated APPLY end-to-end against real tasks, confirm installer-provisioned `pals-implementer` behavior outside the PALS repo, verify module/verification equivalence versus inline APPLY, preserve REV behavior, and close the remaining documentation drift.
