# Roadmap: pals

## Overview
PALS — the Linux of Harness Engineering. Minimal kernel, modular pals, universal drivers. PAUL (project lifecycle) is the kernel. CARL (context rules), TODD (TDD enforcement), and WALT (quality gating) are first-party modules. Drivers make it run on any agentic coding platform.

## Milestones

### v0.1 Fork & Unify (Complete)
Phases: 6 of 6 complete — 2026-03-11

### v0.2 Polish (Complete)
Status: Complete
Phases: 1 of 1 complete — 2026-03-11

### v0.3 Smart Context & Migration (Complete)
Status: Complete
Phases: 2 of 2 complete — 2026-03-11

### v0.4 Kernel & Modules (Complete)
Status: ✅ Complete
Completed: 2026-03-12
Phases: 4 of 4 complete

### v0.5 TODD & WALT Go Live (Complete)
Status: ✅ Complete
Completed: 2026-03-12
Phases: 3 of 3 complete

## Current Milestone

**v2.51 Pi-Native Validation Classification**
Status: 🚧 In progress
Phases: 2 of 4 complete pending PR #134 merge — started 2026-04-29; Phase 219 UNIFY summary created

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 218 | Validation Classification Baseline | 218-01 | ✅ Complete | 2026-04-29 |
| 219 | Runtime/Validation Suite Classification Hardening | 219-01 | ✅ Complete pending merge | 2026-04-29 |
| 220 | Documentation + Report Surfacing | TBD | Not started | — |
| 221 | Evidence Reconciliation + Milestone Closure | TBD | Not started | — |

### Phase 218: Validation Classification Baseline
Focus: Define the validation classification inventory and taxonomy for current Pi and cross-harness suites before weakening, relocating, archiving, or deleting any validation check.
Plans: 218-01 — create the validation classification baseline contract for current Pi/cross-harness suite families, preservation rules, count-change reconciliation, and Phase 219 hardening handoff.
APPLY result: Created `docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md` with taxonomy, suite-family inventory, preservation rules, count-change reconciliation, and Phase 219 handoff. Validation passed Pi 200/200 and cross-harness 116/116; validation scripts remained read-only.
UNIFY result: SUMMARY `.paul/phases/218-validation-classification-baseline/218-01-SUMMARY.md` records AC results, source accounting, unchanged validation counts, module reports, PR #133 evidence, and Phase 219 readiness.

### Phase 219: Runtime/Validation Suite Classification Hardening
Focus: Apply classification markers and guardrails to validation suites so Pi-Supported Runtime, Shared Invariant, Frozen Legacy Parity, Runtime Lens, Guided UI Safety, Helper Delegation, GitHub Flow Safety, and Artifact / Process checks are distinguishable and command-output-backed.
Plans: 219-01 — add explicit validation-classification inventory markers and one localized TAP guardrail per validation suite, reconciling expected counts Pi 200→201 and cross-harness 116→117 while deferring cleanup and broad report surfacing.
APPLY result: Added `VALIDATION CLASSIFICATION INVENTORY` sections to `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh`, with one localized self-checking TAP guardrail per suite. Validation passed Pi 201/201 and cross-harness 117/117; count changes are limited to the new classification guardrails and legacy cleanup/report surfacing remain deferred.
UNIFY result: SUMMARY `.paul/phases/219-runtime-validation-suite-classification-hardening/219-01-SUMMARY.md` records AC results, focused marker evidence, Pi 201/201, cross-harness 117/117, validation count reconciliation, module reports, PR #134 evidence, and Phase 220 readiness.

### Phase 220: Documentation + Report Surfacing
Focus: Surface the classification model in docs and any explicitly scoped report artifacts without making stale reports replace current command-output truth.
Plans: TBD (defined during /paul:plan)

### Phase 221: Evidence Reconciliation + Milestone Closure
Focus: Reconcile classification evidence, validation count changes, module/GitHub Flow evidence, lifecycle metadata, and handoff boundaries before any Legacy Retention / Install-Surface Cleanup milestone begins.
Plans: TBD (defined during /paul:plan)

### Previous milestone: v2.50 Delegated APPLY Packet/Report Contract
Result: Phases 214-217 complete. Phase 217 reconciled Phase 214/215 baseline evidence, Phase 216 docs/validation surfacing evidence, final Helper Delegation and Shared Invariant validation markers, command-output proof, module/GitHub Flow evidence, and lifecycle metadata; validation passes Pi 200/200 and cross-harness 116/116; PR #132 merged. v2.50 hands off to Pi-Native Validation Classification.
## Completed Milestones

| Milestone | Completed | Phases | Summary | Archive |
|-----------|-----------|--------|---------|---------|
| v2.44 PALS Context Optimization — Process & Artifacts | 2026-04-27 | 188-191 | Reduced recurring PALS context cost across wrappers, hot artifacts, workflow references, and validation guardrails. | [archive](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md) |
| v2.45 Pi-Native PALS Architecture | 2026-04-27 | 192-196 | Repositioned PALS around Pi as the supported runtime, mapped Pi capabilities, designed context-efficiency architecture, validated artifact-slice context loading, and produced the final Pi-native architecture proposal. | active artifacts |
| v2.46 Pi-Native Implementation Planning | 2026-04-27 | 197-201 | Converted v2.45 architecture into implementation findings, workstreams, sequencing, validation/evidence strategy, and a final executable Pi-native implementation-plan proposal. | active artifacts |
| v2.47 Artifact-Slice Contract Hardening | 2026-04-28 | 202-205 | Hardened activation-gated, bounded, source-cited, freshness-aware artifact slices and full-read fallback across contract baseline, runtime hardening, docs/skill-map surfacing, and validation/evidence reconciliation. | active artifacts |
| v2.48 Guided Workflow Evidence Hardening | 2026-04-28 | 206-209 | Proved guided workflow evidence across contract baseline, runtime canonical replies, docs/settings validation surfacing, and final evidence reconciliation while preserving explicit user intent and command-output truth. | active artifacts |
| v2.49 Workflow/Resource Capsule Contract | 2026-04-28 | 210-213 | Defined and hardened source-cited, bounded, derived-only workflow/resource capsules; surfaced docs/validation evidence; closed with Pi 197/197 and cross-harness 112/112. | active artifacts |
| v2.50 Delegated APPLY Packet/Report Contract | 2026-04-29 | 214-217 | Formalized parent-owned delegated APPLY task packets and structured helper reports; hardened runtime/helper boundaries; surfaced docs/validation markers; closed with Pi 200/200 and cross-harness 116/116. | active artifacts |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-04-29 — Phase 219 UNIFY summary created; PR #134 merge gate pending.*