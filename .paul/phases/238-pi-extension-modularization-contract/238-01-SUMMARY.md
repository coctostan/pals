---
phase: 238-pi-extension-modularization-contract
plan: 01
subsystem: pi-runtime
tags: [extension-modularization, contract-baseline, docs-only, command-output-truth, risk-tier]
requires:
  - phase: 234-product-reality-drift-audit
    provides: Pi-extension monolith ranked as maintainability weakness #2 with candidate boundary list
  - phase: 235-risk-tiered-lifecycle-contract
    provides: tier-aware non-bypass rules and `.paul/*` authority preservation
  - phase: 236-validation-suite-decomposition-baseline
    provides: side-effect-free sourced helper pattern and command-output truth
  - phase: 237-artifact-consistency-guardrails
    provides: artifact consistency guardrail catching real lifecycle/index drift
provides:
  - Pi extension modularization contract baseline
  - 8-candidate subsystem inventory with source-cited identifiers
  - per-candidate classification (purity / risk tier / readiness / ordering)
  - Phase 239 first-spike selection (module-activity-parsing) with rejection reasons
  - bounded Phase 239 handoff (allowed scope and count drift cap)
affects:
  - phase-239-bounded-pi-extension-extraction-spike
  - future Pi extension modularization work
tech-stack:
  added: []
  patterns:
    - source-cited subsystem inventory before runtime extraction
    - bounded validation count handoff (max +1 per suite) for risky-tier spikes
key-files:
  created:
    - docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md
  modified: []
key-decisions:
  - "Decision: select `module-activity-parsing` (S5) as the Phase 239 first-spike candidate because it is pure transcript parsing with no Pi-API mutation and the smallest authority surface."
  - "Decision: bound Phase 239 validation count handoff at Pi 210→211 max and cross-harness 124→125 max; larger drift requires a separately approved later plan."
  - "Decision: keep CARL session-boundary surface out of the 8-candidate list because Phase 234 grouped session-boundary work under the existing CARL module rather than the Pi extension monolith hotspot."
patterns-established:
  - "Pattern: contract-then-implementation cadence for runtime extraction (Phase 238 contract → Phase 239 bounded spike)."
  - "Pattern: subsystem inventory must cite at least two top-level identifiers actually present in the source file; no inventing abstractions."
  - "Pattern: tiny / doc-only tier APPLY produces zero validation count drift and zero source/runtime/test/install/dependency/CI changes."
duration: ~10min
started: 2026-05-01T12:12:29Z
completed: 2026-05-01T12:22:00Z
---

# Phase 238 Plan 01: Pi Extension Modularization Contract Summary

Established the docs-only contract baseline for `drivers/pi/extensions/pals-hooks.ts` modularization: subsystem inventory, classification, Phase 239 first-spike selection, and bounded Phase 239 handoff. The Pi extension itself is unchanged by this plan.

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~10 minutes from APPLY approval through UNIFY merge gate |
| Started | 2026-05-01T12:12:29Z |
| Completed | 2026-05-01T12:22:00Z |
| Tasks | 4 completed |
| Product files modified | 1 (the new contract doc) |
| Lifecycle files updated | `.paul/STATE.md`, `.paul/ROADMAP.md`, this SUMMARY |

## Acceptance Criteria Results

| Criterion | Status | Evidence |
|-----------|--------|----------|
| AC-1: Contract baseline preserves authority and adds no hidden state | PASS | `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` includes `## Authority and Non-Goals`, `## Tier-Aware Usage`, `no hidden state`, `no telemetry`, `Derived aid only`, `command-output truth`, `full authoritative read fallback`, and explicitly states `drivers/pi/extensions/pals-hooks.ts` is unchanged. |
| AC-2: Subsystem inventory is source-derived and bounded | PASS | 8 candidate subsystems S1-S8; each cites 3+ top-level identifiers actually present in `drivers/pi/extensions/pals-hooks.ts` (verified by direct read during APPLY). |
| AC-3: Each candidate is classified for Phase 239 readiness | PASS | `## Classification` table records purity, risk tier hint, extraction-readiness rationale, and ordering constraints per candidate (S1-S8). |
| AC-4: Exactly one first-spike candidate is selected with explicit rationale | PASS | `## Phase 239 First-Spike Selection` names `module-activity-parsing` (S5) with three selection reasons; each non-selected candidate (S1, S2, S3, S4, S6, S7, S8) has an explicit rejection reason. |
| AC-5: Phase 239 handoff is explicit and bounded | PASS | `## Phase 239 Handoff` records allowed file scope (`drivers/pi/extensions/`), bounded count handoff (Pi 210→211 max, cross-harness 124→125 max), required risky-tier evidence, and `## Out of Scope (Future Approved Plans Only)`. |
| AC-6: Validation truth and count baselines are unchanged | PASS | `bash tests/pi-end-to-end-validation.sh` reports `1..210`, `# Passed: 210`, `# Failed: 0`; `bash tests/cross-harness-validation.sh` reports `1..124`, `# Passed: 124`, `# Failed: 0`; `bash tests/helpers/artifact_consistency.sh` reports `artifact_consistency_check: PASS`. |

## Verification Results

| Check | Result |
|-------|--------|
| Focused contract doc marker check (Task 1) | PASS — `Phase 238`, `Plan 238-01`, `## Authority and Non-Goals`, `## Tier-Aware Usage`, `no hidden state`, `no telemetry`, `Derived aid only`, `command-output truth`, `full authoritative read fallback`, evidence-base citations all present. |
| Focused subsystem inventory marker check (Task 2) | PASS — `## Subsystem Inventory`, `## Classification`, all 8 candidate identifiers present; `### S1`–`### S8` headings present (count = 8). |
| Focused Phase 239 selection/handoff marker check (Task 3) | PASS — `## Phase 239 First-Spike Selection`, `## Phase 239 Handoff`, `## Out of Scope (Future Approved Plans Only)`, `drivers/pi/extensions/`, `Pi \`210→211\``, `cross-harness \`124→125\`` all present; `module-activity-parsing` mentioned 4 times across inventory/classification/selection/handoff. |
| `git diff --check` | PASS |
| `bash tests/pi-end-to-end-validation.sh` | PASS — `1..210`, `# Passed: 210`, `# Failed: 0` (unchanged from Phase 237 baseline). |
| `bash tests/cross-harness-validation.sh` | PASS — `1..124`, `# Passed: 124`, `# Failed: 0` (unchanged from Phase 237 baseline). |
| `bash tests/helpers/artifact_consistency.sh` | PASS — `artifact_consistency_check: PASS`, exit 0. |
| Workguard scope report | PASS — `runs/workguards/20260501T121229Z-phase-238-apply/workguard-report.json`, `changed=4`, `outside_allowed=0`, `over_budget=false`, `mode=enforce`. |

## Module Execution Reports

### APPLY Carry-Forward

- `[dispatch] pre-apply:` TODD/WALT baselines captured Pi `210/210` and cross-harness `124/124`; ARCH confirmed v2.5x baseline-first precedent; DEAN PASS (no manifests touched); IRIS clean; CODI skipped (no extractable TS/JS symbols — markdown-only deliverable); RUBY noted pre-existing `pals-hooks.ts` size debt that this phase explicitly does not touch.
- `[dispatch] post-task(Task 1):` header + Authority/Non-Goals + Tier-Aware Usage — markers PASS, no validation regression possible (docs-only).
- `[dispatch] post-task(Task 2):` 8-candidate subsystem inventory with source-cited identifiers + classification — markers PASS.
- `[dispatch] post-task(Task 3):` Phase 239 first-spike selection (module-activity-parsing) + bounded handoff — markers PASS.
- `[dispatch] post-task(Task 4):` final docs-only verification — Pi 210/210, cross-harness 124/124, artifact consistency PASS, `git diff --check` clean, Workguard `outside_allowed=0`/`over_budget=false`.
- `[dispatch] post-apply advisory:` ARCH/DOCS/IRIS/RUBY/DEAN/DAVE/CODI clean or expected; no advisory drift findings.
- `[dispatch] post-apply enforcement:` TODD validation suites stable at Pi 210/210 and cross-harness 124/124 (no count drift, as planned for tiny/doc-only tier); WALT shell + git diff + Workguard scope all PASS; DEAN no manifest changes.

### Pre-UNIFY

- `[dispatch] pre-unify: 0 modules registered for this hook` — installed registry has post-unify persistence hooks but no pre-unify hooks.
- Skill audit: required `/paul`, TODD, and WALT workflow/module paths invoked; `/carl` automatic session-boundary integration active.

### Post-UNIFY

- `[dispatch] CODI post-unify: hook body entered for 238-01` — PLAN recorded `CODI: skipped — no extractable TS/JS symbols in phase scope`; `.paul/CODI-HISTORY.md` appended `238-01` as `skipped-no-symbols` with `blast_radius=n`.
- `[dispatch] WALT post-unify:` quality history appended `238-01` with `210 pass + 124 pass`, no coverage/lint/type metrics tracked, verdict `→ stable`.
- `[dispatch] SKIP post-unify:` durable knowledge captured in this SUMMARY: contract-then-implementation cadence; subsystem inventory must cite ≥2 source identifiers; tiny/doc-only tier produces zero count drift and zero source/runtime/test/install/dependency/CI changes.
- `[dispatch] RUBY post-unify:` debt note retained — `drivers/pi/extensions/pals-hooks.ts` remains the largest TS hotspot (1,684 lines); Phase 238 inventories and classifies it without churning the file; Phase 239 will execute the bounded extraction spike inside the contract.

## Accomplishments

- Created a durable, source-cited Pi extension modularization contract following the v2.5x baseline-first precedent.
- Inventoried 8 candidate subsystems (S1-S8) — each citing actual top-level identifiers in `drivers/pi/extensions/pals-hooks.ts`.
- Classified each candidate by purity, risk tier hint, extraction readiness, and ordering constraints.
- Selected exactly one Phase 239 first-spike candidate (`module-activity-parsing`, S5) with explicit selection rationale and rejection reasons for the other 7 candidates.
- Defined a bounded Phase 239 handoff: allowed file scope under `drivers/pi/extensions/`, validation count cap (Pi 210→211 max, cross-harness 124→125 max), and explicit out-of-scope set.
- Preserved `.paul/*` authority, command-output truth, GitHub Flow gates, module evidence, parent-owned APPLY, helper-delegation boundaries, full authoritative read fallback, guided-workflow canonical reply semantics, and validation count baselines (Pi 210/210, cross-harness 124/124).

## Task Commits

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Header + Authority/Non-Goals + Tier-Aware Usage | `2e806ebc` | docs | Created `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` header sections. |
| Task 2: Subsystem inventory + classification | `2e806ebc` | docs | Added 8 source-cited candidates and the classification table. |
| Task 3: Phase 239 selection + handoff | `2e806ebc` | docs | Added Phase 239 first-spike selection, rejection reasons, bounded handoff, and out-of-scope set. |
| Task 4: Docs-only verification | `2e806ebc` | docs | Verified Pi 210/210, cross-harness 124/124, artifact consistency PASS, Workguard scope clean. |

Plan metadata commit: created during UNIFY after this SUMMARY and lifecycle updates.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` | Created | Pi extension modularization contract baseline: authority/non-goals, tier-aware usage, 8-candidate subsystem inventory, classification, Phase 239 first-spike selection, bounded handoff, count reconciliation, out-of-scope. |
| `.paul/STATE.md` | Modified | Records APPLY/UNIFY progress, validation evidence, PR state, and next routing. |
| `.paul/ROADMAP.md` | Modified | Marks Phase 238 plan as complete after UNIFY/transition. |
| `.paul/MILESTONES.md` | Modified | Live Status row + Current/Future Milestone Pointer advanced to Phases 234-238 complete and Phase 239 ready to plan. |
| `.paul/QUALITY-HISTORY.md` | Modified | Appends WALT quality history for 238-01. |
| `.paul/CODI-HISTORY.md` | Modified | Appends CODI post-unify history for 238-01. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Select `module-activity-parsing` (S5) as the Phase 239 first-spike candidate. | Pure transcript parsing; no `pi.*` API mutation; no filesystem writes; no lifecycle authority; smallest authority surface (only `DISPATCH_MARKER` and `MODULE_REPORTS_HEADER` need preservation); highest reuse potential for Phase 240/241 evidence work. | Phase 239 plans inside an unambiguous boundary that minimizes Pi-API coupling and lets behavior preservation be proven with focused marker checks plus existing validation suites. |
| Bound Phase 239 validation count handoff at Pi 210→211 max and cross-harness 124→125 max. | Phase 235 risky-tier evidence requires bounded count change reconciliation; an extraction spike that needs more than +1 per suite is too large for a first spike. | Phase 239 either ships as a pure refactor (counts unchanged) or with at most one localized guardrail per suite; larger drift requires a separately approved later plan. |
| Keep CARL session-boundary surface out of the 8-candidate list. | Phase 234 grouped session-boundary work under the existing CARL module rather than the Pi extension monolith hotspot; the candidate list reflects that scoping. | Future plans may promote a CARL-extraction candidate if Phase 239 evidence shows it is the correct extraction target; this plan does not pre-decide that. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None |
| Scope additions | 0 | None |
| Deferred | 0 | Out-of-scope items remain explicitly future-plans-only. |

**Total impact:** Plan executed as approved within the narrow tiny/doc-only scope; no boundary violations, no count drift.

### Auto-fixed Issues

None.

### Deferred Items

No new deferred issue. Out-of-scope items (multi-subsystem extraction, cross-driver runtime modularization, new Pi UI affordances, schema redesigns, telemetry, brittle-prose conversion) remain explicitly listed in the contract's `## Out of Scope` section and require separately approved future plans.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| `drivers/pi/extensions/pals-hooks.ts` size debt remains pre-existing. | Phase 238 explicitly does not touch the file; Phase 239 will execute the bounded extraction spike inside this contract. |
| The original Phase 234 candidate list named "command routing, activation/slices, capsules, guided workflow, CARL/session boundary, module activity parsing" but a direct read of `pals-hooks.ts` revealed finer-grained boundaries (e.g., guided-workflow detection vs canonical-reply delivery; PALS context injection as its own surface). | Promoted finer-grained subsystems into the 8-candidate inventory while explicitly noting CARL is grouped under its own module rather than the extension monolith. Recorded as a decision. |

## Next Phase Readiness

**Ready:**
- Phase 239 Bounded Pi Extension Extraction Spike can plan inside the explicit contract: target file (`drivers/pi/extensions/pals-hooks.ts`), selected subsystem (`module-activity-parsing`, S5), bounded count handoff (Pi 210→211 max, cross-harness 124→125 max), and required risky-tier evidence are all defined.
- Validation truth remains command-output: Pi 210/210, cross-harness 124/124.
- Artifact consistency guardrail still passes; the sourced-helper pattern from Phase 237 remains available.

**Concerns:**
- `drivers/pi/extensions/pals-hooks.ts` remains a 1,684-line hotspot until Phase 239 ships.
- Phase 239 must reread the source before spike work because exact line numbers may shift relative to this contract's identifier citations.

**Blockers:**
- None.

---
*Phase: 238-pi-extension-modularization-contract, Plan: 01*  
*Completed: 2026-05-01*
