---
phase: 201-final-implementation-plan-proposal
plan: 01
subsystem: implementation-planning
tags:
  - pi-native
  - implementation-roadmap
  - artifact-slices
  - validation-evidence
requires:
  - phase: 197-v2.45-findings-triage
    provides: classified v2.45 findings and implementation boundaries
  - phase: 198-implementation-workstream-design
    provides: candidate workstreams, surfaces, dependencies, and open questions
  - phase: 199-sequencing-dependency-plan
    provides: recommended implementation order and dependency/risk gates
  - phase: 200-validation-evidence-strategy
    provides: validation classes, command-output evidence rules, and durable artifact requirements
provides:
  - final v2.46 Pi-native implementation-plan proposal
  - recommended next build milestone: Artifact-Slice Contract Hardening
  - candidate follow-on build sequence with validation/evidence requirements
affects:
  - future Pi-native implementation build milestones
  - artifact-slice contract hardening
  - guided workflow evidence hardening
tech-stack:
  added: []
  patterns:
    - source-cited Pi-native implementation roadmap
    - artifact-slice hardening before broader context surfaces
    - command-output validation truth for build milestones
key-files:
  created:
    - docs/PI-NATIVE-IMPLEMENTATION-PLAN.md
  modified:
    - .paul/STATE.md
    - .paul/ROADMAP.md
    - .paul/PROJECT.md
    - .paul/MILESTONES.md
    - .paul/QUALITY-HISTORY.md
    - .paul/CODI-HISTORY.md
key-decisions:
  - "Decision: recommend Artifact-Slice Contract Hardening as the next build milestone."
  - "Decision: keep validation classification before legacy cleanup."
  - "Decision: preserve command-output evidence and artifact-first lifecycle authority for all future Pi-native implementation work."
patterns-established:
  - "Future Pi-native build milestones should carry validation classes, command evidence, durable artifact evidence, fallback triggers, and explicit non-authority boundaries."
duration: ~30min
started: 2026-04-27T21:00:00Z
completed: 2026-04-27T21:50:00Z
---

# Phase 201 Plan 01: Final Implementation Plan Proposal Summary

Phase 201 created the final v2.46 implementation-plan proposal, converting Phases 197-200 into an executable Pi-native build roadmap while preserving docs-only scope and all lifecycle authority boundaries.

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~30 minutes across APPLY + UNIFY reconciliation |
| Started | 2026-04-27T21:00:00Z |
| Completed | 2026-04-27T21:50:00Z |
| Tasks | 3 completed |
| Files modified | 1 product artifact plus lifecycle metadata |

## Objective

Create `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md`, the final v2.46 implementation-plan proposal that converts Phase 197 findings, Phase 198 workstreams, Phase 199 sequencing, and Phase 200 validation/evidence strategy into a concrete next-build roadmap with protected authority boundaries.

## What Was Built

| File | Change | Purpose | Lines |
|------|--------|---------|-------|
| `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` | Created | Defines recommended Pi-native build milestone order, acceptance-criteria families, validation classes, command-output evidence, durable artifact evidence, readiness checklist, and next-build handoff. | 218 |
| `.paul/phases/201-final-implementation-plan-proposal/201-01-PLAN.md` | Preserved | Approved source plan for Phase 201 reconciliation. | 203 |
| `.paul/phases/201-final-implementation-plan-proposal/201-01-SUMMARY.md` | Created | Durable UNIFY reconciliation artifact. | this file |
| `.paul/STATE.md` | Updated | Marks Phase 201 and v2.46 complete, records decisions, and routes to next milestone planning after merge. | lifecycle |
| `.paul/ROADMAP.md` | Updated | Marks Phase 201 complete and v2.46 fully complete. | lifecycle |
| `.paul/PROJECT.md` | Updated | Current focus and key decisions now reflect v2.46 completion and next build recommendation. | lifecycle |
| `.paul/MILESTONES.md` | Updated | Compact milestone index records v2.46 as complete. | lifecycle |
| `.paul/QUALITY-HISTORY.md` | Updated | Records stable Phase 201 validation result. | module history |
| `.paul/CODI-HISTORY.md` | Updated | Records CODI skipped-no-symbols outcome for markdown-only phase scope. | module history |
| `.paul/handoffs/archive/HANDOFF-2026-04-27-phase-201-apply-complete-unify-pending.md` | Archived | Consumed active handoff after resume context was integrated. | handoff lifecycle |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|-----------|--------|----------|
| AC-1: Source-grounded roadmap proposal | PASS | Proposal cites `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md`, `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md`, `docs/PI-NATIVE-SEQUENCING-DEPENDENCY-PLAN.md`, `docs/PI-NATIVE-VALIDATION-EVIDENCE-STRATEGY.md`, and `.paul/phases/200-validation-evidence-strategy/200-01-SUMMARY.md`. |
| AC-2: Executable build milestone recommendations | PASS | Proposal names Artifact-Slice Contract Hardening first, then Guided Workflow Evidence Hardening, Workflow/Resource Capsule Contract, Delegated APPLY Packet/Report Contract, Pi-Native Validation Classification, and Legacy Retention / Install-Surface Cleanup. |
| AC-3: Authority boundaries and non-goals preserved | PASS | Proposal explicitly preserves `.paul/*` authority, PLAN/APPLY/UNIFY, module evidence, GitHub Flow gates, parent-owned APPLY, explicit approvals/checkpoints, full-read fallback, and excludes hidden Pi state, telemetry, auto-approval, helper-owned APPLY, merge-gate bypass, dependency additions, and unclassified legacy cleanup. |
| AC-4: Validation and durable evidence requirements are explicit | PASS | Proposal includes `Validation Classes`, `Command-Output Evidence`, `Durable Artifact Evidence`, `Readiness Checklist`, and `Next Build Handoff`. |
| AC-5: Validation remains green | PASS | Marker greps passed; `bash tests/pi-end-to-end-validation.sh` passed 186/186; `bash tests/cross-harness-validation.sh` passed 100/100. |

## Verification Results

| Command | Result |
|---------|--------|
| `grep -n "Planning-Only Boundary\|Source Inputs\|Recommended First Build Milestone\|Candidate Build Sequence\|Validation Classes\|Command-Output Evidence\|Durable Artifact Evidence\|Readiness Checklist\|Next Build Handoff" docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` | PASS — all required sections found at lines 18, 29, 62, 102, 137, 152, 164, 187, and 202. |
| `bash tests/pi-end-to-end-validation.sh` | PASS — 186 passed, 0 failed, 186 total. |
| `bash tests/cross-harness-validation.sh` | PASS — 100 passed, 0 failed, 100 total. |
| `git diff --stat origin/main..HEAD` before UNIFY metadata | PASS — implementation branch contains `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` with 218 insertions. |
| PR #115 CI before UNIFY metadata | PASS — Socket Security Project Report and Pull Request Alerts succeeded. |

## Module Execution Reports

[dispatch] pre-unify: 0 modules registered for this hook.

### Carried-Forward APPLY Module Evidence

| Module / Cohort | Result |
|-----------------|--------|
| TODD / WALT | Existing validation stayed green: Pi 186/186 and cross-harness 100/100. |
| DEAN | No root dependency manifest or lockfile; no audit command applied and no dependency block was raised. |
| SETH | Markdown-only docs artifact had no security-sensitive source patterns. |
| Docs / advisory checks | Docs-only scope was expected; the planned implementation proposal artifact was created under `docs/`. |
| CODI | Markdown-only phase scope had no extractable TS/JS symbols or source selectors. |
| ARIA, LUKE, GABE, DANA, OMAR, PETE, REED, VERA, ARCH | No UI/API/data/runtime/performance/resilience/privacy/architecture-sensitive implementation files changed. |

### WALT Post-Unify Quality History

[dispatch] post-unify: WALT recorded quality history for 201-01.

| Metric | Before | After | Delta | Trajectory |
|--------|--------|-------|-------|------------|
| Pi validation | 186 pass | 186 pass | 0 | → stable |
| Cross-harness validation | 100 pass | 100 pass | 0 | → stable |
| Coverage | — | — | — | — skipped |
| Lint | — | — | — | — skipped |
| Typecheck | — | — | — | — skipped |

**Overall:** → stable. `.paul/QUALITY-HISTORY.md` appended `201-01` with `186 pass + 100 pass`.

### SKIP Post-Unify Knowledge Capture

[dispatch] post-unify: SKIP captured durable knowledge entries from this summary.

#### 2026-04-27 Artifact-Slice Contract Hardening goes first

**Type:** decision  
**Phase:** 201 — Final Implementation Plan Proposal  
**Related:** `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md`, Phase 195 artifact-slice spike, Phase 200 validation/evidence strategy

**Context:** v2.46 needed to turn v2.45 architecture into executable build milestones. Artifact-slice loading is the only Pi-native context-efficiency pattern already proven through a read-only spike with source citation, freshness, activation gating, and full-read fallback.

**Decision:** Recommend Artifact-Slice Contract Hardening as the first build milestone after v2.46 closes.

**Alternatives considered:**
- Start with guided workflow evidence hardening — useful, but depends on explicit intent proof and has broader lifecycle-decision risk.
- Start with validation classification — safe as an override if evidence changes, but the artifact-slice contract is the most implementation-ready context-efficiency gain.
- Start with legacy cleanup — rejected until validation classification and product approval are explicit.

**Rationale:** Hardening the proven slice contract first maximizes near-term context reduction while keeping `.paul/*` truth, command output, module evidence, and full-read fallback intact.

**Impact:** The next milestone should target `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, and validation markers before broader capsules, helper compression, or cleanup.

#### 2026-04-27 Build milestones must carry validation classes and durable evidence

**Type:** decision  
**Phase:** 201 — Final Implementation Plan Proposal  
**Related:** `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md`, `docs/PI-NATIVE-VALIDATION-EVIDENCE-STRATEGY.md`

**Context:** Future Pi-native implementation work may touch runtime lenses, guided UI, helper delegation, validation scripts, GitHub Flow surfacing, and frozen legacy surfaces. Those changes must not weaken shared invariants accidentally.

**Decision:** Future build plans must name validation classes, command-output evidence, durable artifact evidence, fallback triggers, and non-authority boundaries before implementation begins.

**Alternatives considered:**
- Let each future plan infer evidence ad hoc — rejected because it risks deleting or downgrading invariants without a classification record.
- Treat Pi summaries or reports as sufficient validation — rejected because command output remains truth.

**Rationale:** Up-front evidence classification keeps Pi-native implementation fast without making runtime aids authoritative.

**Impact:** PLAN/SUMMARY/STATE/ROADMAP, validation output, module histories, and GitHub Flow evidence remain the durable review path for future work.

#### 2026-04-27 Legacy cleanup remains deferred until classification and approval

**Type:** trade-off  
**Phase:** 201 — Final Implementation Plan Proposal  
**Related:** Claude Code / Agent SDK frozen surfaces, validation classification, future cleanup milestone

**Options matrix:**

| Option | Pros | Cons | Outcome |
|--------|------|------|---------|
| Clean legacy surfaces immediately | Reduces repo and validation surface sooner | Risks deleting shared-invariant coverage before classification | Rejected |
| Keep all legacy surfaces forever | Avoids accidental regression | Lets frozen parity silently block Pi-native direction | Rejected |
| Classify validation first, then decide retention/removal | Preserves invariants and allows intentional cleanup | Requires an extra milestone before cleanup | Chosen |

**Reasoning:** Legacy retention/removal is a product/support decision, not just a cleanup task. It should follow validation classification and explicit approval.

**Impact:** Legacy Retention and Install-Surface Cleanup remains last in the recommended sequence.

### CODI Post-Unify Instrumentation

[dispatch] CODI post-unify: hook body entered for 201-01  
[dispatch] CODI post-unify: appended skipped-no-symbols row for 201-01

CODI recorded `skipped-no-symbols` because Phase 201 was markdown-only and the PLAN documented no extractable TS/JS symbols or source selectors.

### RUBY Post-Unify Debt Review

[dispatch] post-unify: RUBY reviewed docs-only scope.

`docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` is 218 lines. No implementation functions, classes, runtime code, or complexity-bearing source files changed. No technical-debt or refactoring concern was introduced.

### Skill Audit

All required lifecycle skills were active or invoked: `/paul`, `/carl`, TODD, and WALT. Module dispatch evidence is preserved in this SUMMARY.

## Accomplishments

- Created a source-grounded final v2.46 implementation-plan proposal.
- Recommended Artifact-Slice Contract Hardening as the next build milestone.
- Defined a conservative candidate build sequence through guided workflow evidence, workflow/resource capsules, helper packet/report compression, validation classification, and legacy cleanup.
- Preserved command-output validation truth and artifact-first lifecycle authority for all future implementation work.
- Kept scope docs-only and preserved green validation.

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Tasks 1-3: Create final implementation proposal | `2b956979` | docs | Created `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` with source inputs, roadmap sequence, validation classes, evidence rules, boundaries, readiness checklist, and next-build handoff. |

Plan metadata commit: created during UNIFY after this summary was finalized.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` | Created | Phase 201 final implementation-plan proposal output. |
| `.paul/phases/201-final-implementation-plan-proposal/201-01-PLAN.md` | Added to lifecycle artifacts | Approved plan retained with UNIFY metadata. |
| `.paul/phases/201-final-implementation-plan-proposal/201-01-SUMMARY.md` | Created | UNIFY reconciliation and module persistence. |
| `.paul/STATE.md` | Modified | Phase 201 / v2.46 completion and next milestone routing. |
| `.paul/ROADMAP.md` | Modified | Phase 201 and v2.46 marked complete. |
| `.paul/PROJECT.md` | Modified | Current focus and key decisions updated after v2.46 completion. |
| `.paul/MILESTONES.md` | Modified | v2.46 recorded as a completed milestone. |
| `.paul/QUALITY-HISTORY.md` | Modified | Stable validation row appended for 201-01. |
| `.paul/CODI-HISTORY.md` | Modified | CODI skipped-no-symbols row appended for 201-01. |
| `.paul/handoffs/archive/HANDOFF-2026-04-27-phase-201-apply-complete-unify-pending.md` | Added | Consumed resume handoff archived. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Recommend Artifact-Slice Contract Hardening first. | It is the most proven Pi-native context-efficiency pattern and has clear validation/evidence requirements. | Next milestone should harden slice schema, citation, freshness, bounds, and full-read fallback before broader context surfaces. |
| Keep validation classification before legacy cleanup. | Shared invariants must be separated from frozen legacy parity before weakening or removing checks. | Legacy cleanup remains last and requires classification plus product approval. |
| Preserve command-output evidence and durable artifact evidence for future implementation work. | Prevents Pi runtime aids, widgets, reports, capsules, or helper outputs from becoming hidden authority. | Future PLANs and SUMMARYs must cite commands, validation counts, module evidence, git/PR state, fallback triggers, and non-authority boundaries. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None |
| Scope additions | 0 | None |
| Deferred | 0 | None |

**Total impact:** Plan executed as written. No runtime, workflow, validation-script, dependency, GitHub Flow, report, installed runtime, legacy-surface, or lifecycle-authority behavior changed.

### Auto-fixed Issues

None.

### Deferred Items

No new deferrals were introduced by Phase 201. The proposal intentionally carries forward deferrals for workflow/resource capsules, guided workflow evidence, helper packet/report compression, validation classification, and legacy cleanup into future build milestones.

## Issues Encountered

None.

## Next Phase Readiness

**Ready:**
- v2.46 is ready to close after the GitHub Flow merge gate for PR #115.
- The next milestone should be created for Artifact-Slice Contract Hardening.
- Future plans have source inputs, acceptance-criteria families, validation classes, evidence requirements, and protected boundaries to start from.

**Concerns:**
- Future implementation must not treat the Phase 201 proposal as build authorization; normal milestone creation, PLAN approval, APPLY verification, module gates, GitHub Flow gates, and UNIFY reconciliation still apply.
- Legacy cleanup must stay deferred until validation classification and explicit product/support approval are complete.

**Blockers:**
- None.

---
*Phase: 201-final-implementation-plan-proposal, Plan: 01*
*Completed: 2026-04-27*
