---
phase: 207-runtime-guided-reply-hardening
plan: 01
completed: 2026-04-28T12:55:46Z
subsystem: pi-guided-workflow-runtime
tags: [pi, guided-workflow, canonical-replies, merge-gate, validation]
requires:
  - phase: 206-guided-workflow-evidence-contract-baseline
    provides: guided workflow evidence contract and Phase 207 runtime-hardening handoff
provides:
  - contract-backed guided runtime moment inventory including merge-gate-routing
  - explicit confirm/select-only canonical reply send path
  - notify-only no-reply and no-auto/no-UI-only runtime guardrail markers
affects:
  - Phase 208 Documentation + Validation Surfacing
  - Phase 209 Evidence Reconciliation + Milestone Closure
tech-stack:
  added: []
  patterns:
    - guided workflow replies require transcript-visible canonical user messages after explicit UI action
    - merge-gate routing is notify/select-only and never infers merge intent
key-files:
  created:
    - .paul/phases/207-runtime-guided-reply-hardening/207-01-SUMMARY.md
  modified:
    - drivers/pi/extensions/pals-hooks.ts
    - .paul/STATE.md
    - .paul/ROADMAP.md
    - .paul/PROJECT.md
    - .paul/MILESTONES.md
    - .paul/QUALITY-HISTORY.md
    - .paul/CODI-HISTORY.md
key-decisions:
  - "Decision: Treat merge-gate routing as a guided moment but keep it notify/select-only and non-authoritative."
patterns-established:
  - "Pattern: guided_workflow.auto_present controls display only; it does not approve, continue, complete checkpoints, or create lifecycle state."
  - "Pattern: sendCanonicalWorkflowResponse is the single transcript-visible canonical reply send path for guided workflow UI."
duration: single session
started: 2026-04-28T12:31:00Z
completed: 2026-04-28T12:55:46Z
---

# Phase 207 Plan 01: Runtime Guided Reply Hardening Summary

**Hardened the Pi guided workflow runtime so guided moments, including merge-gate routing, can only route explicit transcript-visible canonical replies after confirm/select UI action and cannot become lifecycle authority.**

## Objective

Implement the Phase 206 guided workflow evidence contract in the repo-source Pi runtime before Phase 208 documentation/validation surfacing. Scope stayed bounded to `drivers/pi/extensions/pals-hooks.ts` outside normal `.paul/*` lifecycle artifacts.

## What Was Built

| File | Change | Purpose |
|------|--------|---------|
| `drivers/pi/extensions/pals-hooks.ts` | Modified | Added `merge-gate-routing` guided moment kind/config; added GitHub Flow route detection; documented no-auto/no-UI-only/no-inferred-merge guardrails; kept canonical replies behind explicit confirm/select delivery through `pi.sendUserMessage`. |
| `.paul/phases/207-runtime-guided-reply-hardening/207-01-PLAN.md` | Created during PLAN | Executable Phase 207 plan and CODI blast-radius evidence. |
| `.paul/phases/207-runtime-guided-reply-hardening/207-01-SUMMARY.md` | Created | Durable reconciliation artifact for Phase 207 Plan 207-01. |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|-----------|--------|----------|
| AC-1: Guided moment inventory is contract-backed | Pass | Runtime now includes `merge-gate-routing` alongside `plan-review`, `apply-approval`, `checkpoint-decision`, `checkpoint-human-verify`, `checkpoint-human-action`, `resume-next`, `continue-to-unify`, `phase-transition`, and `milestone-transition`; focused marker grep passed. |
| AC-2: Replies require explicit user action and transcript delivery | Pass | `presentGuidedWorkflowMoment` only calls `sendCanonicalWorkflowResponse` after `ctx.ui.confirm(...)` returns true or `ctx.ui.select(...)` maps to a displayed `GuidedWorkflowOption`; `sendCanonicalWorkflowResponse` delegates to `pi.sendUserMessage` with `{ deliverAs: "followUp" }` only when context is busy. |
| AC-3: Notify-only and checkpoint paths cannot continue lifecycle work | Pass | Runtime comments and control flow state that notify-only mode never sends a canonical reply; checkpoint decision/human verification/human action paths remain confirm/select/notify-driven and do not write lifecycle state. |
| AC-4: Merge-gate routing cannot infer or execute merge intent | Pass | Merge-gate routing detects GitHub Flow route prompts from text and presents notify/select only; no git/gh execution was added; exact option ids are required for selectable replies; no inferred merge intent is accepted. |
| AC-5: Runtime source is deployable and validation stays green | Pass | `PALS_ROOT="$PWD" bash drivers/pi/install.sh` passed; Pi validation passed 188/188; cross-harness validation passed 104/104; changed source outside lifecycle metadata stayed limited to `drivers/pi/extensions/pals-hooks.ts`. |

## Verification Results

| Command | Result | Evidence |
|---------|--------|----------|
| `grep -n "merge-gate-routing\|plan-review\|apply-approval\|checkpoint-decision\|checkpoint-human-verify\|checkpoint-human-action\|resume-next\|continue-to-unify\|phase-transition\|milestone-transition" drivers/pi/extensions/pals-hooks.ts` | Pass | Matched the full guided moment inventory and `merge-gate-routing` source markers. |
| `grep -n "no auto-approval\|no auto-continue\|no skipped checkpoints\|no UI-only lifecycle decisions\|no inferred merge intent\|notify-only mode never sends\|pi.sendUserMessage\|deliverAs: \"followUp\"\|ctx.ui.confirm\|ctx.ui.select" drivers/pi/extensions/pals-hooks.ts` | Pass | Matched durable no-auto/no-UI-only/no-inferred-merge guardrails plus canonical send path and explicit confirm/select gates. |
| `PALS_ROOT="$PWD" bash drivers/pi/install.sh` | Pass | Installer completed; Pi extension installed to `~/.pi/agent/extensions/pals-hooks.ts`; modules.yaml generated with 20 modules. |
| `bash tests/pi-end-to-end-validation.sh` | Pass | TAP summary: `1..188`; Passed: 188; Failed: 0; Total: 188; `# ALL CHECKS PASSED`. |
| `bash tests/cross-harness-validation.sh` | Pass | TAP summary: `1..104`; Passed: 104; Failed: 0; Total: 104; `# ALL CHECKS PASSED`. |
| `git diff --stat origin/main...HEAD` | Pass | `drivers/pi/extensions/pals-hooks.ts | 58 +++++++++++++++++++++++++++++++++++--`; 1 file changed, 55 insertions(+), 3 deletions(-). |

## Module Execution Reports

### Pre-UNIFY Dispatch

[dispatch] pre-unify: 0 modules registered for this hook in installed `modules.yaml`; no blocking pre-unify annotations were produced.

### Carried Forward from PLAN/APPLY

| Module / Skill | Evidence |
|----------------|----------|
| /paul | PLAN/APPLY/UNIFY lifecycle remained parent-owned; `.paul/*` lifecycle artifacts are authoritative. |
| /carl | Active pause handoff was consumed and archived after resume proceeded; no autonomous lifecycle decision was made. |
| TODD | Plan remained `execute`, not `tdd`; validation suite evidence substituted for TDD conversion because this repo-source extension uses shell/TAP validation rather than a JS unit-test harness. |
| WALT | Baseline and post-apply validation passed: Pi 188/188 and cross-harness 104/104. |
| CODI | `[dispatch] CODI: pre-plan advisory → impact × 5 symbols → 5 resolved, 0 unresolved, 12 total call-sites, injected blast_radius`; symbols: `detectGuidedWorkflowMoment`, `presentGuidedWorkflowMoment`, `sendCanonicalWorkflowResponse`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`. |
| ARCH | Planned and changed source belongs in the Pi driver extension layer; existing `pals-hooks.ts` large-file debt is pre-existing and unchanged in scope. |
| DOCS | Advisory drift accepted by plan boundary: user-facing docs and validation marker surfacing are Phase 208 scope. |
| DEAN/SETH | No dependency manifests changed; secret/danger scans found no blocking issues in the changed file. |
| IRIS/RUBY | ESLint complexity run using the historical `--no-eslintrc` command is unavailable under current ESLint (`Invalid option '--eslintrc'`); fallback line-count check recorded `1513` lines and pre-existing large-file debt. |

### Post-UNIFY Dispatch

| Module | Result |
|--------|--------|
| WALT | Appended `.paul/QUALITY-HISTORY.md` row for `207-01` with `188 pass + 104 pass`, stable trend. |
| CODI | Appended `.paul/CODI-HISTORY.md` row for `207-01` with injected blast radius from PLAN (`detectGuidedWorkflowMoment`, `presentGuidedWorkflowMoment`, `sendCanonicalWorkflowResponse`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`). |
| SKIP | Captured the durable pattern that `guided_workflow.auto_present` is display-only and that guided replies require transcript-visible canonical user-message flow. |
| RUBY | Recorded no new refactor requirement beyond pre-existing `pals-hooks.ts` large-file debt; Phase 207 deliberately avoided broad decomposition. |

[dispatch] post-unify: {WALT appended quality row | CODI appended injected row | SKIP captured guided runtime reply pattern | RUBY recorded pre-existing large-file debt only}

## Accomplishments

- Added contract-backed `merge-gate-routing` as a first-class guided workflow moment.
- Preserved existing guided moments while extending detection to GitHub Flow route handoffs.
- Kept canonical replies exclusively on the transcript-visible `pi.sendUserMessage` path after explicit confirm/select results.
- Made notify-only mode return without sending any canonical reply.
- Marked `guided_workflow.auto_present` as display-only runtime behavior, not lifecycle state or approval.
- Preserved scope: no docs/skill-map/validation-script surfacing, dependencies, CI, telemetry, hidden state, git/gh automation, or broad extension refactor.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Encode contract-backed guided moment routing | `210bf9f0` | feat | Added `merge-gate-routing`, display config, GitHub Flow route detection, and exact option-id routing behavior. |
| Task 2: Guard canonical reply delivery against auto and UI-only decisions | `a5118652` | feat | Documented single canonical reply path; kept auto-present config display-only; required explicit confirm/select matches before sending. |
| Task 3: Install repo-source runtime and record validation evidence | no separate source commit | verify | Ran focused marker greps, installer, Pi validation, cross-harness validation, and changed-file scope review. |

Plan metadata: committed during UNIFY after lifecycle reconciliation.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `drivers/pi/extensions/pals-hooks.ts` | Modified | Runtime guided reply hardening implementation. |
| `.paul/phases/207-runtime-guided-reply-hardening/207-01-PLAN.md` | Created | Approved executable plan. |
| `.paul/phases/207-runtime-guided-reply-hardening/207-01-SUMMARY.md` | Created | Durable reconciliation artifact. |
| `.paul/STATE.md` | Modified | Close Phase 207 and route to Phase 208 planning after transition. |
| `.paul/ROADMAP.md` | Modified | Mark Phase 207 complete and Phase 208 ready to plan. |
| `.paul/PROJECT.md` | Modified | Update current focus and active requirements for Phase 207 completion. |
| `.paul/MILESTONES.md` | Modified | Update current/future milestone pointer. |
| `.paul/QUALITY-HISTORY.md` | Modified | WALT post-unify quality history row for 207-01. |
| `.paul/CODI-HISTORY.md` | Modified | CODI post-unify instrumentation row for 207-01. |
| `.paul/handoffs/archive/HANDOFF-2026-04-28-phase-207-plan-created-awaiting-approval.md` | Archived | Consumed resume handoff after work proceeded. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Treat merge-gate routing as a guided moment but keep it notify/select-only. | GitHub Flow route prompts are user-facing guided workflow moments, but merge intent must never be inferred from displayed PR/CI state. | Pi can surface or route exact workflow options, while git/gh commands and merge evidence remain workflow-owned. |
| Keep `guided_workflow.auto_present` display-only. | Config controls whether the Pi UI affordance appears; it must not alter lifecycle truth or skip prompts. | Future docs and validation should describe auto-present as display behavior only, not approval or checkpoint state. |
| Avoid broad extension decomposition despite large-file debt. | The approved phase was runtime reply hardening, not adapter refactoring. | `pals-hooks.ts` remains large; any decomposition should be separately planned. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None. |
| Scope additions | 0 | None. |
| Process adaptation | 2 | Active pause handoff was archived during resume; advisory DOCS drift was accepted because Phase 208 owns docs/validation surfacing. |

**Total impact:** Planned runtime source change was delivered as approved. No source-scope deviation occurred.

### Auto-fixed Issues

None.

### Deferred Items

- Phase 208 owns Pi extension docs, skill-map surfacing, guided workflow settings documentation, and focused validation markers for these runtime guarantees.
- Phase 209 owns final guided workflow evidence reconciliation and milestone closure.
- Workflow/resource capsules, delegated APPLY packet/report compression, broad validation classification, and legacy retention/install-surface cleanup remain deferred future milestones.
- `drivers/pi/extensions/pals-hooks.ts` remains a large file; decomposition remains outside Phase 207 scope.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| ESLint command from the RUBY hook reference used `--no-eslintrc`, which current ESLint rejects. | Treated as RUBY fallback condition and recorded line-count debt instead of blocking UNIFY. |
| Docs drift warning appeared because `README.md`/`CHANGELOG.md` were not updated. | Accepted as planned boundary: Phase 208 owns docs/validation surfacing. |

## GitHub Flow Evidence

| Gate | Result |
|------|--------|
| Branch | `feature/207-runtime-guided-reply-hardening` during APPLY/UNIFY. |
| PR | #122 — https://github.com/coctostan/pals/pull/122 |
| CI before merge | Passing: Socket Security Project Report SUCCESS; Socket Security Pull Request Alerts SUCCESS. |
| Merge gate | Pending final metadata commit/push at summary creation; UNIFY merge gate will merge PR #122, sync `main`, and record final state before routing onward. |

## Next Phase Readiness

**Ready:**
- Phase 208 can surface the runtime guarantees in Pi docs, skill-map, guided workflow settings documentation, and focused validation markers.
- Runtime markers now exist for guided moment inventory, `merge-gate-routing`, no-auto/no-UI-only/no-inferred-merge, notify-only no-reply behavior, and canonical send path.
- Current validation remains green: Pi 188/188 and cross-harness 104/104.

**Concerns:**
- Phase 208 should avoid expanding into workflow/resource capsules, helper packet/report compression, validation classification, or legacy cleanup.
- `pals-hooks.ts` large-file debt remains pre-existing; future refactor work should be separately planned.

**Blockers:**
- None for Phase 208 planning after GitHub Flow merge gate completes.

---

*Phase: 207-runtime-guided-reply-hardening, Plan: 01*
*Completed: 2026-04-28*
