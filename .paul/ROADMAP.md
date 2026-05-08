# Roadmap: pals

## Overview
PALS — the Linux of Harness Engineering. Minimal kernel, modular pals, universal drivers. PAUL (project lifecycle) is the kernel. CARL (context rules), TODD (TDD enforcement), and WALT (quality gating) are first-party modules. Drivers make it run on any agentic coding platform.

## Milestones
Closed-milestone detail archived (see `## Completed Milestones` table below; pre-v2.44 detail in [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md); v2.44 detail in [archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md)).

## Current Milestone

**v2.62 PALS Context Diet — STATE & Hot-Path Compression**
Status: 🚧 In Progress | Mode: direct-requirements (Phase 265+) | Phases: 2 of 3 complete | Created: 2026-05-07
Theme: Apply the v2.43/v2.44 archive-and-compact recipe to STATE.md, PROJECT.md, MILESTONES.md, and ROADMAP.md (the four hot lifecycle artifacts). Bring aggregate hot-path resume read total ~228 KB → ≤ 80 KB (~65% reduction) without weakening lifecycle authority, helper compatibility, validation truth, Pi runtime expectations, CARL session-boundary expectations, or full authoritative read fallback. Path A inherited regression (Pi `not ok 102` / cross-harness `not ok 31`, ROADMAP active-window line-budget) reconciled inline by Phase 266 active-window compaction (same root cause). Cross-file narrative deduplication explicitly **deferred** (architectural; would re-litigate v2.43/v2.44). Authoritative contract: `docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md` (Phase 265). 4th application of v2.43's archive-and-compact recipe; 7th application of the closure-guardrail recipe in Phase 267 (Phase 245/248/252/256/260/264/267).

| Phase | Name | Status | Plans |
|-------|------|--------|-------|
| 265 | PALS Hot-Path Context Audit + Diet Contract | ✅ Complete (PR #180 `63365822`) | `.paul/phases/265-pals-hot-path-context-audit-diet-contract/265-01-PLAN.md` + `265-01-SUMMARY.md` |
| 266 | Archive + Compact Hot Artifacts | ✅ Complete (PR #181 `a780bb7f`) | `.paul/phases/266-archive-compact-hot-artifacts/266-01-PLAN.md` + `266-01-SUMMARY.md` |
| 267 | Selective Artifact Loading + Anti-Regrowth Guardrails + v2.62 Closure | 🔵 Ready to plan | TBD |

### Phase 265: PALS Hot-Path Context Audit + Diet Contract — ✅ Complete
Audit STATE/PROJECT/MILESTONES/ROADMAP for active-vs-cold split; identify cross-file duplication (record but don't fix — deferred); identify preservation invariants; measure baseline; produce `docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md` (~39 KB / 395 lines: hot/warm/cold split, archive structure, per-section live-byte budgets, 14 preservation invariants, Phase 266/267 handoff). Docs-only. AC-1–AC-4 PASS. Pi 242/243 unchanged with inherited Path A `not ok 102`; cross-harness 137/138 unchanged with inherited `not ok 31`; artifact_consistency PASS; install surface unchanged; single-Write-per-artifact recipe ratified for context-diet contracts. PR #180 squash-merged 2026-05-08T15:20:52Z as `63365822`.

### Phase 266: Archive + Compact Hot Artifacts — ✅ Complete
Archived cold STATE.md history to `.paul/archive/state/STATE-HISTORY-v2.44-v2.60.md`, lifted PROJECT pre-v2.61 posture/decision detail to `.paul/archive/project/PROJECT-HISTORY-v2.55-v2.60.md`, and compacted hot artifacts to STATE 18,843 B / PROJECT 18,777 B / MILESTONES 14,610 B / ROADMAP 11,185 B (60 lines), aggregate 63,415 B ≤ 80 KB. Path A resolved inline: Pi 243/243 PASS and cross-harness 138/138 PASS. Deviations recorded in SUMMARY: PROJECT archive lift, MILESTONES corrective 5-line Edit, and Phase 267 selective-loading handoff.
Plans: `.paul/phases/266-archive-compact-hot-artifacts/266-01-PLAN.md` + `.paul/phases/266-archive-compact-hot-artifacts/266-01-SUMMARY.md`; PR #181 squash-merged 2026-05-08T16:56:53Z as `a780bb7f`.

### Phase 267: Selective Artifact Loading + Anti-Regrowth Guardrails + v2.62 Closure — 🔵 Ready to plan
Add selective artifact loading contracts so PALS workflows locate relevant headings/markers/rows and read bounded windows instead of whole hot artifacts by default; ratify the achieved v2.62 budgets with Phase-191-style structural anti-regrowth checks; apply the **7th** closure-guardrail-recipe application (Phase 245/248/252/256/260/264/267); aggregate v2.62 closure evidence; record v2.63 candidate (recommended-not-approved). Scope input: `.paul/phases/266-archive-compact-hot-artifacts/266-02-SELECTIVE-ARTIFACT-LOADING-HANDOFF.md`.
Plans: TBD (defined during /paul:plan).

### Latest completed milestone: v2.61 Pi Extension Submodule Extraction Wave — S8 Command Routing Extraction
Result: Phases 261–264 complete. v2.61 closed after Phase 264 PR #179 squash-merged 2026-05-07T20:47:10Z as `bc81fa84`. Shipped S8 `command-routing` sibling extraction (`drivers/pi/extensions/command-routing.ts`, 230 LOC; twelve-entry `COMMANDS` array preserved byte-for-byte; loader-compat no-op default factory) while preserving S4 canonical reply delivery in `pals-hooks.ts` (832 → 672 LOC; -160 LOC) and the no-UI-only-lifecycle-decisions invariant. Patterns ratified: sibling-surfacing recipe (6th ratification — durable across full active S\* set), sibling-extraction recipe (7th application: S5+S1+S2+S3+S7+S6+S8 — wave closed except S4), type-only back-import + TAP-assertion repoint + `inline → export` promotion patterns each ratified ×3, the 4-symbol `inline → export` lockstep promotion durable rule (closures sharing a `let` must move together). Final validation: install 8; Pi 1..243 / 242 / 1 (inherited Path A `not ok 102`); cross-harness 1..138 / 137 / 1 (inherited `not ok 31`); artifact_consistency PASS. PRs: #176 `423c467e`, #177 `19555747`, #178 `6f725276`, #179 `bc81fa84`. Path A inherited regression escalated to v2.62 per Phase 264 recorded decision. Per-phase detail with PR numbers and durations lives in [`.paul/MILESTONES.md`](MILESTONES.md) and in the completed-milestone table below.

## Completed Milestones

| Milestone | Completed | Phases | Summary |
|-----------|-----------|--------|---------|
| v2.44 PALS Context Optimization — Process & Artifacts | 2026-04-27 | 188-191 | Reduced recurring PALS context cost across wrappers, hot artifacts, workflow references, and validation guardrails. [archive](archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md) |
| v2.45 Pi-Native PALS Architecture | 2026-04-27 | 192-196 | Repositioned PALS around Pi as the supported runtime; produced `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md`. |
| v2.46 Pi-Native Implementation Planning | 2026-04-27 | 197-201 | Produced `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md`. |
| v2.47 Artifact-Slice Contract Hardening | 2026-04-28 | 202-205 | `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md`; activation-gated, bounded, source-cited slices. |
| v2.48 Guided Workflow Evidence Hardening | 2026-04-28 | 206-209 | `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`; transcript-visible canonical replies; Pi 193/193, cross-harness 109/109. |
| v2.49 Workflow/Resource Capsule Contract | 2026-04-28 | 210-213 | `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md`; Pi 197/197, cross-harness 112/112. |
| v2.50 Delegated APPLY Packet/Report Contract | 2026-04-29 | 214-217 | `docs/PI-NATIVE-DELEGATED-APPLY-PACKET-REPORT-CONTRACT.md`; parent-owned packets/reports; Pi 200/200, cross-harness 116/116. |
| v2.51 Pi-Native Validation Classification | 2026-04-30 | 218-221 | `docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md`; Pi 203/203, cross-harness 119/119. |
| v2.52 Legacy Retention / Install-Surface Cleanup | 2026-04-30 | 222-225 | Pi-first install/uninstall by default with explicit frozen legacy/source-only opt-ins; Pi 205/205, cross-harness 121/121. |
| v2.53 Pi Integration Efficiency & Effectiveness Exploration | 2026-04-30 | 226-229 | Artifact-slice targeting/deduplication runtime spike; Pi 208/208, cross-harness 122/122. |
| v2.54 Contextual Verbosity Paring | 2026-04-30 | 230-233 | `docs/PALS-CONTEXTUAL-VERBOSITY-AUDIT.md`; Pi 209/209, cross-harness 123/123. |
| v2.55 Maintainability & Product Reality Hardening | 2026-05-01 | 234-241 | Product-reality audit, risk-tiered lifecycle contract, validation-suite decomposition baseline, artifact consistency guardrails, Pi extension modularization contract, bounded S5 extraction spike, first-run happy-path scenario doc, generalized Pi extension install surface; Pi 212/212, cross-harness 127/127. |
| v2.56 Pi Extension Submodule Extraction Wave | 2026-05-02 | 242-245 | S1 `artifact-slice-rendering` sibling extraction; sibling Pi extension loader-compat hotfix; Pi 218/218, cross-harness 129/129; install 3. |
| v2.57 Pi Extension Submodule Extraction Wave — S2 Workflow/Resource Capsule Rendering | 2026-05-02 | 246-248 | `workflow-resource-capsule-rendering.ts` (4th sibling); Pi 223/223, cross-harness 131/131; install 4. |
| v2.58 Pi Extension Submodule Extraction Wave — S3 Guided Workflow Detection | 2026-05-03 | 249-252 | `guided-workflow-detection.ts` (5th sibling); Pi 227/227, cross-harness 135/135; install 5. |
| v2.59 Pi Extension Submodule Extraction Wave — S7 PALS Context Injection | 2026-05-05 | 253-256 | `pals-context-injection.ts` (6th sibling, 88 LOC); type-only back-import + TAP-assertion repoint patterns first formally named; Pi 231/231, cross-harness 136/136; install 6. |
| v2.60 Pi Extension Submodule Extraction Wave — S6 Lifecycle UI Extraction | 2026-05-07 | 257-260 | `lifecycle-ui.ts` (7th sibling, 123 LOC); no-UI-only-lifecycle-decisions invariant verified shipped; Pi 235/235, cross-harness 137/137; install 7. |
| v2.61 Pi Extension Submodule Extraction Wave — S8 Command Routing Extraction | 2026-05-07 | 261-264 | `command-routing.ts` (8th and final unclaimed sibling, 230 LOC); per-sibling S1–S8 wave closed except S4; first-ever closure-record-convention establishment via `## Status After Phase 262` on the S8 contract; closure-guardrail recipe ratified 6× (Phase 245/248/252/256/260/264); 4-symbol `inline → export` lockstep promotion durable rule; Pi 242/243 with inherited Path A `not ok 102`; cross-harness 137/138 with inherited `not ok 31`; install 8. PRs #176/#177/#178/#179. |

Detailed completed milestone history through v2.43 is archived. See [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md) for the full per-milestone `<details>` blocks; the compact list of completed milestones lives in [`.paul/MILESTONES.md`](MILESTONES.md).
---
*Last updated: 2026-05-08 — v2.62 Phase 266 complete via PR #181 `a780bb7f`; hot artifacts compacted to 63,415 B aggregate and Path A validation failure resolved. v2.62 is 2 of 3 phases complete; Phase 267 ready to plan selective artifact loading + anti-regrowth guardrails + closure.*
