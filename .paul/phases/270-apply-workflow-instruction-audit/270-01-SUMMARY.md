---
phase: 270-apply-workflow-instruction-audit
plan: 01
completed: 2026-05-09
duration: one APPLY/UNIFY loop
---

# Phase 270 Plan 270-01 Summary

## Objective
Rewrite the APPLY workflow so execution stays parent-owned, bounded, and verifiable without over-reading lifecycle artifacts, over-expanding helper delegation packets, or carrying checkpoint/verification ceremony beyond what APPLY needs.

## What Changed

| File | Purpose | Result |
|------|---------|--------|
| `kernel/workflows/apply-phase.md` | Core APPLY workflow instructions | Rewritten from a broad, template-heavy workflow to a 184-line bounded procedure with named steps for approval/PLAN loading, parent-owned delegation, checkpoint blocking, targeted verification, failure handling, and finalize routing. |
| `tests/pi-end-to-end-validation.sh` | Pi/install validation | Added/retained semantic apply-workflow guardrails that reject broad/eager apply reads, helper-owned lifecycle authority, non-blocking checkpoints, and unbounded diff instructions. |
| `tests/cross-harness-validation.sh` | Shared cross-harness validation | Added/retained matching semantic apply-workflow guardrails across Claude Code, Pi, and repo source workflow copies. |
| `.paul/STATE.md` | Lifecycle state | Updated through APPLY completion and then UNIFY closure. |
| `.paul/ROADMAP.md` | Current milestone status | Updated to mark Phase 270 complete and Phase 271 as next. |
| `.paul/CODI-HISTORY.md`, `.paul/QUALITY-HISTORY.md` | Post-unify module persistence | Recorded post-unify CODI and WALT outcomes. |

## Task Results

| Task | Status | Evidence |
|------|--------|----------|
| Task 1: Add semantic apply-workflow guardrails | PASS | Guardrails produced expected RED failures against the old broad/verbose APPLY workflow, then passed after the rewrite. |
| Checkpoint: Confirm section-by-section rewrite protocol | PASS | User approved proceeding and reviewed/tightened section wording before each edit. |
| Task 2: Collaboratively rewrite apply workflow section by section | PASS | `apply-phase.md` now uses bounded STATE/PLAN loading, compact parent-owned helper rules, compact checkpoints, and targeted verification/failure handling. |
| Task 3: Install/validate and record evidence | PASS | `git diff --check`, Pi validation, cross-harness validation, and Workguard scope report passed. |

## Acceptance Criteria Results

| AC | Result | Evidence |
|----|--------|----------|
| AC-1: APPLY starts from bounded approval and plan loading | PASS | `apply-phase.md` now has `load_apply_state_bounded` and `load_plan_sections`; validation checks require bounded STATE fields and approved PLAN sections only. |
| AC-2: Parent-owned delegation is compact and non-ambiguous | PASS | Delegation defaults inline, has a hard gate, preserves parent ownership over verification/module gates/fallback/checkpoints/GitHub Flow/lifecycle writes, and forbids helper-owned `.paul/*` writes. |
| AC-3: Checkpoint handling is lean but blocking | PASS | `handle_checkpoints` loads checkpoint guidance only for `checkpoint:*`, uses compact payloads, waits for user response, and blocks unresolved checkpoints. |
| AC-4: Verification and failure handling stay grounded | PASS | Workflow uses parent-run official verification, ground-truth scope checks, bounded retry, targeted repair/revert, and no blind revert. |
| AC-5: Validation catches semantic regressions | PASS | Pi and cross-harness suites now fail on broad/eager apply instructions and marker-only compliance. |
| AC-6: Rewrite is collaborative, bounded, and green | PASS | Rewrite proceeded section-by-section with user approval; final validation is green and Workguard reported no out-of-scope changes. |

## Verification Results

| Command / Check | Result |
|-----------------|--------|
| `git diff --check` | PASS |
| `bash tests/pi-end-to-end-validation.sh` | PASS — 292/292 |
| `bash tests/cross-harness-validation.sh` | PASS — 172/172 |
| Workguard scope report | PASS — changed=6, outside_allowed=0, over_budget=false |

## Module Execution Reports

- `[dispatch] pre-unify: 0 modules registered for this hook`
- `[dispatch] post-unify: WALT PASS — appended `.paul/QUALITY-HISTORY.md` row for Phase 270 (Pi 292/292, cross-harness 172/172; trend ↑ improving).`
- `[dispatch] post-unify: CODI PASS — appended `.paul/CODI-HISTORY.md` row for `270-01` with `skipped-no-symbols` because this phase changed workflow markdown/shell validation, not extractable code symbols.`
- `[dispatch] post-unify: SKIP PASS — durable decisions/lessons recorded in STATE and this SUMMARY; no separate knowledge artifact required.`
- `[dispatch] post-unify: RUBY PASS — no refactor-blocking debt introduced; target workflow shrank materially and validation script additions remained localized.`

## Deviations

| Deviation | Impact |
|-----------|--------|
| `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` already contained the planned semantic apply guardrails at resume time. | No scope issue. Task 1 verified those guardrails produced expected RED failures against the old workflow and passed after the rewrite. |
| Compatibility marker strings were preserved in `apply-phase.md` to keep existing helper-delegation guardrails green. | Intentional; kept validation stable while still removing broad/eager operational instructions. |

## Decisions and Lessons

- Section-by-section rewrite with user wording review is effective for instruction-sensitive workflow changes: it catches verbosity and ambiguity before mutation.
- APPLY instructions are clearer for agents when written as linear gates: default inline → delegation gate → parent acceptance → fallback → verification/status.
- Semantic validation should continue checking operational behavior, not just prose markers.

## Next Phase

Phase 271: Unify Workflow Instruction Audit + Context-Efficiency Rewrite.

Focus: inspect `kernel/workflows/unify-phase.md` for reconciliation/summary behavior that duplicates narrative across artifacts, over-expands module evidence, weakens source-of-truth boundaries, or lets closure pass with prose markers instead of semantic evidence.
