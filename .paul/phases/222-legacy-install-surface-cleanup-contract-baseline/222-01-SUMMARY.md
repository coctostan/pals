---
phase: 222-legacy-install-surface-cleanup-contract-baseline
plan: 01
subsystem: docs
tags:
  - pi-native
  - legacy-retention
  - install-surface-cleanup
  - validation-classification
  - command-output-truth
requires:
  - phase: 221-evidence-reconciliation-milestone-closure
    provides: final v2.51 validation classification closure and Pi 203/203, cross-harness 119/119 evidence
  - phase: 218-validation-classification-baseline
    provides: validation class taxonomy and classify-before-cleanup rules
  - phase: 219-runtime-validation-suite-classification-hardening
    provides: command-checked validation-suite classification inventory
  - phase: 220-documentation-report-surfacing
    provides: non-authoritative docs/report surfacing boundary
provides:
  - Phase 222 baseline-only legacy/install-surface cleanup contract
  - class-aware retain/archive/source-only/remove/defer decision matrix
  - preservation rules, failure conditions, count-change reconciliation fields, and Phase 223 handoff
affects:
  - 223-safe-cleanup-implementation
  - 224-documentation-validation-surfacing
  - 225-evidence-reconciliation-milestone-closure
tech-stack:
  added: []
  patterns:
    - baseline-only cleanup contract before any frozen legacy or install-surface cleanup
    - command-output truth remains authoritative over reports/contracts/summaries/helper reports/Pi surfaces
key-files:
  created:
    - docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md
    - .paul/phases/222-legacy-install-surface-cleanup-contract-baseline/222-01-SUMMARY.md
  modified:
    - .paul/PROJECT.md
    - .paul/ROADMAP.md
    - .paul/STATE.md
    - .paul/CODI-HISTORY.md
    - .paul/QUALITY-HISTORY.md
key-decisions:
  - "Decision: Establish a baseline-only cleanup contract before any legacy/install-surface cleanup."
  - "Decision: Treat Frozen Legacy Parity as non-authorizing for deletion unless Shared Invariant evidence is retained or replaced."
patterns-established:
  - "Pattern: Future cleanup plans must choose retain/archive/source-only/remove/defer per surface with validation class, shared-invariant risk, evidence required, and cleanup authorization."
  - "Pattern: Validation count changes require old/new count, reason, class affected, shared-invariant preservation rationale, command-output evidence, and cleanup authorization."
duration: ~25min
started: 2026-04-30T02:02:00Z
completed: 2026-04-30T02:20:00Z
---

# Phase 222 Plan 01: Legacy / Install-Surface Cleanup Contract Baseline Summary

Phase 222 created the v2.52 cleanup contract baseline: a class-aware, command-output-backed framework for later legacy/install-surface cleanup without changing runtime behavior, installers, validation scripts, dependency manifests, CI, GitHub Flow automation, helper delegation, lifecycle authority, or actual legacy surfaces.

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~25min |
| Started | 2026-04-30T02:02:00Z |
| Completed | 2026-04-30T02:20:00Z |
| Tasks | 3 completed |
| Files modified | 1 new source contract + lifecycle artifacts |
| Helper delegation | Not used; parent APPLY/UNIFY executed inline |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Cleanup contract source inputs are explicit | PASS | Contract names v2.51 classification, Phase 218-221 summaries, implementation workstreams, sequencing plan, support inventory, README, driver manifests, validation suites, and current Pi 203/203 + cross-harness 119/119 command-output baseline. |
| AC-2: Retention/removal matrix is safe and class-aware | PASS | Contract separates `retain`, `archive`, `source-only`, `remove`, and `defer`, with eligible validation classes, shared-invariant rule, required evidence, and Phase 223 eligibility. |
| AC-3: Protected boundaries prevent behavior changes | PASS | No runtime, installer, validation-script, dependency, CI, GitHub Flow, helper delegation, lifecycle authority, or actual legacy-surface source changed. |
| AC-4: Verification and failure conditions are executable | PASS | Contract includes marker-check families, count-change reconciliation fields, failure conditions, preservation rules, non-goals, and concrete Phase 223 eligible/ineligible categories. |
| AC-5: Current validation remains command-output-backed | PASS | Focused marker grep passed; `PALS_ROOT="$PWD" bash drivers/pi/install.sh` passed; Pi validation passed 203/203; cross-harness validation passed 119/119. Counts remained unchanged. |

## Verification Results

| Command | Result | Evidence |
|---------|--------|----------|
| Focused contract marker grep | PASS | Found `Phase 222`, `baseline-only`, `Frozen Legacy Parity`, `Shared Invariant`, `Pi-Supported Runtime`, `retain`, `archive`, `source-only`, `remove`, `defer`, `command-output truth`, and `Phase 223 handoff`. |
| Task 2 focused marker grep | PASS | Found preservation rules, explicit non-goals, marker-check families, old/new count fields, validation class affected, shared-invariant preservation rationale, command-output evidence, cleanup authorization, failure conditions, and eligible/ineligible Phase 223 handoff markers. |
| `PALS_ROOT="$PWD" bash drivers/pi/install.sh` | PASS | Pi driver install completed; modules.yaml generated with 20 modules. |
| `bash tests/pi-end-to-end-validation.sh` | PASS | `1..203`; `# Passed: 203`; `# Failed: 0`; `# ALL CHECKS PASSED`. |
| `bash tests/cross-harness-validation.sh` | PASS | `1..119`; `# Passed: 119`; `# Failed: 0`; `# ALL CHECKS PASSED`. |
| SETH security marker scan | PASS | No hardcoded secret or dangerous eval/exec markers found in the new contract. |
| IRIS marker scan | PASS | No TODO/FIXME/HACK/XXX markers found in the new contract. |
| Workguard scope report | PASS | `changed=6`, `outside_allowed=0`, `over_budget=false` for the APPLY scope report; after commits, working tree was clean. |

## Count-Change Reconciliation

| Suite | Old Count | New Count | Reason | Validation Class Affected | Shared-Invariant Preservation | Command Evidence |
|-------|----------:|----------:|--------|---------------------------|-------------------------------|------------------|
| Pi validation | 203 | 203 | Phase 222 created a docs-only cleanup contract; no validation checks were added, weakened, relocated, archived, removed, or reclassified. | Pi-Supported Runtime; Shared Invariant; Runtime Lens; Guided UI Safety; Helper Delegation; GitHub Flow Safety; Artifact / Process remain preserved. | PLAN/APPLY/UNIFY, `.paul/*`, module evidence, parent-owned APPLY, explicit approvals/checkpoints, command-output truth, and Pi-supported install behavior remain unchanged. | `bash tests/pi-end-to-end-validation.sh` passed 203/203. |
| Cross-harness validation | 119 | 119 | Phase 222 created a docs-only cleanup contract; no parity checks or shared-invariant checks changed. | Frozen Legacy Parity; Shared Invariant; Artifact / Process remain preserved and explicitly separated in the contract. | Frozen legacy parity is not treated as deletion authorization; shared lifecycle semantics remain protected until replacement evidence exists. | `bash tests/cross-harness-validation.sh` passed 119/119. |

## Module Execution Reports

### Pre-apply / Apply carry-forward

- `[dispatch] pre-apply: TODD, WALT`
- TODD: shell validation suites were the approved proof path; execute plan did not require RED/GREEN/REFACTOR restructuring for a docs contract.
- WALT baseline before APPLY remained Pi 203/203 and cross-harness 119/119.
- `[dispatch] post-task(Task 1): TODD` — focused marker grep and full validation passed after creating the source-input and decision-matrix portions of the contract.
- `[dispatch] post-task(Task 2): TODD` — focused marker grep, installer verification, Pi 203/203, and cross-harness 119/119 passed after preservation boundaries, verification requirements, and handoff were added.
- `[dispatch] post-task(Task 3): TODD` — SUMMARY/STATE/ROADMAP reconciliation completed during UNIFY.

### Post-apply advisory modules

- `[dispatch] post-apply advisory: ARCH, ARIA, DANA, DAVE, DOCS, GABE, IRIS, LUKE, OMAR, PETE, REED, SKIP, VERA`
- ARCH: new docs contract is in the expected docs layer; `wc -l` reported 179 lines, below god-file thresholds.
- ARIA/LUKE: no UI files changed.
- DANA/GABE/VERA: no data, migration, API, schema, or privacy implementation files changed.
- DAVE: no CI config files changed.
- DOCS: planned docs contract created near related Pi-native contracts; broader docs surfacing remains future Phase 224 scope.
- IRIS: no TODO/FIXME/HACK/XXX markers found.
- OMAR/PETE/REED: no production runtime, async I/O, retry, route, observability, or performance-sensitive source changed.
- SKIP: decision record candidate — establish the cleanup contract baseline before implementation; do not treat Frozen Legacy Parity as safe-to-delete without shared-invariant replacement evidence.

### Post-apply enforcement modules

- `[dispatch] post-apply enforcement: DEAN, SETH, TODD, WALT`
- DEAN: no dependency manifests/lockfiles changed; dependency audit not applicable. PASS.
- SETH: no hardcoded secret or dangerous eval/exec patterns in the new contract. PASS.
- TODD/WALT: full-suite evidence remained green at Pi 203/203 and cross-harness 119/119, failed=0. PASS.

### Pre-unify / Post-unify persistence

- `[dispatch] pre-unify: 0 modules registered for this hook`.
- Skill audit: `/paul` invoked, `/carl` active via Pi extension, TODD/WALT module dispatch active; all required skills satisfied.
- `[dispatch] CODI post-unify: hook body entered for 222-01`; PLAN pre-plan evidence contained `skipped — no extractable symbols in phase scope`, so `.paul/CODI-HISTORY.md` received `222-01 | skipped-no-symbols | — | — | — | — | n`.
- `[dispatch] WALT post-unify`: `.paul/QUALITY-HISTORY.md` updated with `222-01 | 2026-04-30 | 203 pass + 119 pass | — | — | — | → stable`.
- `[dispatch] SKIP post-unify`: knowledge capture recorded the baseline-only cleanup decision and Frozen Legacy Parity / Shared Invariant separation as durable summary evidence.
- `[dispatch] RUBY post-unify`: new contract is 179 lines; no refactor concern. Existing validation-script size debt remains pre-existing/future driver-quality scope.
- `[dispatch] post-unify: CODI, WALT, SKIP, RUBY` completed without blocking results.

## GitHub Flow Evidence

| Field | Value |
|-------|-------|
| Branch | `feature/222-legacy-install-surface-cleanup-contract-baseline` |
| Base | `main` |
| PR | https://github.com/coctostan/pals/pull/137 |
| APPLY commits | `284e49ed` cleanup contract baseline; `20c74566` apply postflight state; `a3708f08` apply CI state update |
| PR checks before UNIFY merge gate | Socket Security Project Report SUCCESS; Socket Security Pull Request Alerts SUCCESS |
| UNIFY merge gate | Pending final merge-gate resolution during transition closeout. |

## Accomplishments

- Created `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md` as the Phase 222 baseline-only cleanup contract.
- Defined class-aware cleanup target inventory across Pi-supported runtime surfaces, frozen Claude Code / Agent SDK surfaces, portability docs, cross-harness parity checks, historical reports, lifecycle archives, GitHub Flow safety, and helper delegation.
- Established the retain/archive/source-only/remove/defer matrix and made `defer` the default for mixed Frozen Legacy Parity + Shared Invariant surfaces.
- Preserved command-output truth and current validation counts: Pi 203/203 and cross-harness 119/119.
- Created an executable Phase 223 handoff with eligible and ineligible cleanup categories.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Create cleanup contract source inputs and decision matrix | `284e49ed` | docs | Created the contract with status, purpose/non-authority boundary, source inputs, cleanup target inventory, and retain/archive/source-only/remove/defer matrix. |
| Task 2: Add preservation boundaries, verification requirements, and handoff | `284e49ed` | docs | Added preservation rules, non-goals, marker-check families, count-change reconciliation fields, failure conditions, and Phase 223 handoff. |
| Task 3: Record Phase 222 evidence for lifecycle reconciliation | UNIFY metadata commit pending | docs | Created this SUMMARY, updated lifecycle state, and recorded CODI/WALT post-unify evidence. |

Apply postflight commits: `20c74566`, `a3708f08`.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md` | Created | Baseline-only cleanup contract for safe Phase 223 implementation planning. |
| `.paul/phases/222-legacy-install-surface-cleanup-contract-baseline/222-01-PLAN.md` | Created during planning / committed during APPLY | Approved executable plan for Phase 222. |
| `.paul/phases/222-legacy-install-surface-cleanup-contract-baseline/222-01-SUMMARY.md` | Created | Durable UNIFY reconciliation artifact. |
| `.paul/STATE.md` | Modified | Routes lifecycle through APPLY/UNIFY and records validation/GitHub Flow evidence. |
| `.paul/ROADMAP.md` | Modified | Records Phase 222 completion and routes to Phase 223. |
| `.paul/PROJECT.md` | Modified | Updates hot project context for v2.52 and Phase 222 completion. |
| `.paul/CODI-HISTORY.md` | Modified | Adds post-unify `skipped-no-symbols` row for 222-01. |
| `.paul/QUALITY-HISTORY.md` | Modified | Adds WALT quality row for stable 203 + 119 validation. |
| `.paul/handoffs/archive/HANDOFF-2026-04-30-phase-222-plan-awaiting-approval.md` | Created by archive move | Preserves consumed handoff history after APPLY proceeded. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Establish cleanup contract before implementation | Legacy/install-surface cleanup can remove useful shared-invariant evidence if done before target classification and preservation rules are explicit. | Phase 223 has a safe baseline and must not guess cleanup eligibility. |
| Treat Frozen Legacy Parity as non-authorizing for deletion | Frozen support status does not prove a surface lacks Shared Invariant, Artifact / Process, Helper Delegation, GitHub Flow, or Pi-Supported Runtime evidence. | Future cleanup must split/retain/replace shared-invariant coverage before remove/source-only decisions. |
| Keep Phase 222 docs-only and baseline-only | The plan's purpose was contract creation; changing installers, validation scripts, dependencies, CI, GitHub Flow, helper semantics, lifecycle authority, or legacy surfaces would obscure evidence. | No count changes occurred; Pi and cross-harness validation remain stable. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Process adaptations | 1 | Task 1 and Task 2 contract content was written in one file-creation pass, then verified with the planned focused greps and full validation. |
| Scope additions | 0 | None. |
| Deferred | 1 | Actual cleanup implementation remains deferred to Phase 223. |

**Total impact:** No product, runtime, validation, install, helper, CI, GitHub Flow, or lifecycle authority deviation. The only adaptation was editing efficiency for one planned docs file.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Initial git commit hit a transient stale `.git/index.lock` error. | Retried after confirming the lock file was absent; commit succeeded. |
| CI was pending immediately after PR creation. | Rechecked during UNIFY; Socket Security Project Report and Pull Request Alerts were both SUCCESS. |

## Next Phase Readiness

**Ready:**
- Phase 223 can plan bounded cleanup from `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`.
- Cleanup action choices are explicit: retain, archive, source-only, remove, or defer.
- Future count changes have required reconciliation fields and command-output proof requirements.

**Concerns:**
- Frozen Legacy Parity and Shared Invariant evidence may be mixed in cross-harness validation and legacy install surfaces; Phase 223 should default to `defer` unless separation/replacement evidence is concrete.
- Existing validation-suite large-file debt remains pre-existing/future driver-quality scope.

**Blockers:**
- None for Phase 223 planning after PR #137 merge-gate completion.

---
*Phase: 222-legacy-install-surface-cleanup-contract-baseline, Plan: 01*
*Completed: 2026-04-30*
