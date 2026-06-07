# Project State

## Project Reference

See: .paul/PROJECT.md (v2.72 Shared Runtime Helper Extraction in progress; created 2026-06-04)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.72 Shared Runtime Helper Extraction (Phases 303–305) — extract pure/derived filesystem + state helpers out of `pals-hooks.ts` into a leaf `shared-runtime-helpers` sibling, repoint importers, fix the inverted helper-hub dependency; no lifecycle-authority change. Executes the twice-deferred v2.69 Phase 295 ranking, re-confirmed #1 by `.paul/assessments/2026-06-04-post-v2-71-next-milestone.md`. Phase 303 complete (contract authored); ready to plan Phase 304.

## Current Position

Milestone: v2.72 Shared Runtime Helper Extraction (in progress)
Phase: 305 of 305 (Validation + Closure) — planned, ready for APPLY
Plan: 305-01 (planned, approved-pending) — .paul/phases/305-validation-closure/305-01-PLAN.md
Status: Phase 305 planned — ready for APPLY (2 tasks: contract closure record + cross-harness closure guardrail)
Last activity: 2026-06-06 — Created Phase 305 PLAN (305-01): validation gate + contract `## Status After Phase 305` closure record + 8th closure-guardrail recipe application (cross-harness 253→254). Loop → PLAN ✓.
Next action: /paul:apply for Phase 305 Plan 305-01

Progress:
- v2.62 PALS Context Diet — STATE & Hot-Path Compression: [██████████] 100% (Phase 265 ✅ PR #180 `63365822`; Phase 266 ✅ PR #181 `a780bb7f`; Phase 267 ✅ PR #182 `068d7cb3`)
- v2.63 Workflow Instruction Audit + Context-Efficiency Rewrite: [██████████] 100% (Phase 272 ✅ PR #188 `df56ece1`; milestone complete)
- v2.64 Module Instruction Audit + Context-Efficiency Rewrite: [██████████] 100% ✓ (Phases 273–278 complete; closed 2026-05-12 via PR #196 `340eee03`; archive [v2.64](archive/roadmap/v2.64-module-instruction-audit-context-efficiency-rewrite.md))
- v2.65 Functional-First Agent Guidance: [██████████] 100% ✓ (Phases 279–283 complete; closed 2026-05-13 via PRs #197 / #198 / #199 / #200 / #201)
- v2.66 Plannotator Integration — Rich UI Review Surfaces: [██████████] 100% ✓ (Phases 284–287 complete; PRs #202–#205)
- v2.67 Validation Hygiene: [██████████] 100% ✓ (Phases 288–290 complete; final validation Pi 335/335, cross-harness 246/246; archive [v2.67](archive/roadmap/v2.67-validation-hygiene.md))
- v2.68 Plannotator Retraction: [██████████] 100% ✓ (Phases 291–292 complete; PRs #209/#210)
- v2.69 Pi Runtime Context Offload — S4 First: [██████████] 100% ✓ (Phase 293 ✅ PR #212; Phase 294 ✅ PR #213; Phase 295 ✅ PR #214 merged `08b0e891`)
- v2.70 Strategic Milestone Assessment: [██████████] 100% ✓ (Phases 296–298 complete; closed 2026-06-02 via PR #217 `9c5cdda8`, tag `v2.70`; archive [v2.70](archive/roadmap/v2.70-strategic-milestone-assessment.md))
- v2.71 HTML Presentation Packets — Human Review Briefs: [██████████] 100% ✓ (Phases 299–302 complete; closed 2026-06-04 via PR #222 squash `96a556bc`, tag `v2.71`; archive [v2.71](archive/roadmap/v2.71-html-presentation-packets.md))
- v2.72 Shared Runtime Helper Extraction: [██████░░░░] 67% (Phases 303–305; Phase 303 ✅ PR #223; Phase 304 ✅ complete 2026-06-06, PR #224; Phase 305 pending)
- Pre-v2.61 milestone progress lifted to [.paul/archive/state/STATE-HISTORY-v2.44-v2.60.md](archive/state/STATE-HISTORY-v2.44-v2.60.md).

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ○        ○     [Phase 305 planned — ready for APPLY]
```

## Accumulated Context

### Current Summary

- PLAN/APPLY/UNIFY remains authoritative; `.paul/*` artifacts are lifecycle truth; archives under `.paul/archive/*` hold history.
- v2.64 completed the module instruction audit/context-efficiency rewrite and is archived.
- v2.65 Functional-First Agent Guidance closed 2026-05-13 across Phases 279–283: authoritative contract, AGENTS/init Engineering Principles + brownfield map-codebase signals, TODD pure-logic TDD + RUBY Extract Pure Core advisory guidance, and advisory ARCH side-effect-boundary guidance — all with project conventions and local idioms preserved as authoritative and no new default blocking functional-style gates.

> Pre-v2.61 history archived at .paul/archive/state/STATE-HISTORY-v2.44-v2.60.md.

### Current Decisions

| Decision | Source | Impact |
|----------|--------|--------|
| v2.61 extraction wave closed | Phases 261-264 | S8 command-routing extracted/surfaced, v2.61 closed via PRs #176-#179; Path A ROADMAP/context-budget regression escalated to v2.62. |
| v2.62 context diet closed | Phases 265-267 | Context-diet contract, hot artifact compaction, selective-loading guardrails, and v2.62 closure shipped via PRs #180-#182. |
| v2.63 workflow instruction audit closed | Phases 268-272 | Resume/plan/apply/unify/pause workflows rewritten collaboratively with semantic guardrails; v2.63 completed via PR #188. |
| v2.64 module instruction audit complete | Phases 273-278 | All six phases complete: contract/cohort map (PR #190), base/dispatch rewrite (PR #191), TODD/WALT/DEAN enforcement (PR #192), IRIS/REV/SKIP/CODI/DOCS/RUBY advisory (PR #194), ARCH/SETH/OMAR/PETE/REED/VERA domain cohort (PR #195), and Phase 278 semantic guardrails + closure (PR #196 merged as `340eee03`; cross-harness 195→202 PASS). |
| v2.65 milestone created | /paul:milestone + docs/FUNCTIONAL-FIRST-AGENT-GUIDANCE-RESEARCH.md | New five-phase milestone opened for functional-first agent guidance across AGENTS/init, map-codebase conventions, TODD, RUBY, and optional ARCH advisory language; Phase 279 ready to plan. |
| Phase 279 plan created | 279-01-PLAN.md | Plan 279-01 scopes Phase 279 to a single new contract document, `docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md`, with downstream implementation surfaces explicitly out of scope until later phases. |
| Phase 279 APPLY complete | Plan 279-01 / PR #197 | Created `docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md`, preserved the research note as provenance, committed docs as `8493c957`, and opened PR #197. |
| Phase 279 contract authority established | 279-01-SUMMARY.md | `docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md` is the authoritative v2.65 implementation boundary after Phase 279 UNIFY; the research note remains provenance/background and loses conflicts. |
| Phase 280 convention surface established | 280-01-SUMMARY.md / PR #198 | Generated `AGENTS.md` and init workflow now include compact functional-first Engineering Principles while keeping Project Conventions authoritative; Pi and cross-harness validations guard installed convention-surface markers. |
| Phase 281 brownfield convention detection established | 281-01-SUMMARY.md / PR #199 | Map-codebase now asks for source-backed local functional/style signals and templates preserve brownfield functional/effect-boundary idioms without requiring functional architecture conversion. |
| Phase 282 TODD/RUBY functional-first guidance established | 282-01-SUMMARY.md / PR #200 | TODD now highlights pure input-to-output logic as high-value TDD scope and RUBY now documents Extract Pure Core as advisory, behavior-preserving, test-backed guidance; Pi and cross-harness installed-resource marker checks guard both surfaces. |
| Phase 283 ARCH advisory + v2.65 closure | 283-01-SUMMARY.md / PR #201 | ARCH module metadata, principles, patterns, drift, and onboarding references surface side-effect boundary drift (Pure Core, Explicit Effects) as advisory only; `The Leaking Effect` common-drift label added; Pi + cross-harness installed-resource marker checks (5 + 10 assertions) guard ARCH Phase 283 markers; v2.65 milestone closed. |

| 2026-05-20: Phase 294 S4 delivery extraction completed | 294-01-SUMMARY.md / PR #213 | `guided-workflow-delivery.ts` owns canonical guided-workflow reply delivery/config while `pals-hooks.ts` remains orchestration; validation passed install 9 extensions, Pi 329/329, cross-harness 234/234. |
| 2026-05-21: Phase 295 context-offload ranking completed | 295-01-SUMMARY.md / PR #214 | Measured S4 offload (`pals-hooks.ts` 671→546 lines; S4 sibling 148 lines), ranked shared filesystem/state helper extraction as the next contract-first recommendation, and added Pi/cross-harness guardrails; validation Pi 331/331, cross-harness 235/235. |
| 2026-06-04: v2.71 milestone complete | /paul:milestone | HTML Presentation Packets (Phases 299–302) shipped static, artifact-derived, optional/non-blocking/non-authoritative HTML review briefs for milestone/PLAN/APPLY/UNIFY + README/contract surfacing + CC↔Pi parity guardrails; closed via PR #222 `96a556bc`, tag `v2.71`; cross-harness 253/253, Pi e2e 342/342. Detail archived ([v2.71](archive/roadmap/v2.71-html-presentation-packets.md)). Next candidate: shared runtime helper extraction. |
> Pre-v2.61 decisions archived at .paul/archive/state/STATE-HISTORY-v2.44-v2.60.md. Earlier historical decisions through Phase 185 Plan 185-01 archived at .paul/archive/state/STATE-HISTORY-v0-v2.43.md.

### Fixes / Deviations / Skill Audits

- v2.61 Phases 261-264: parent-owned APPLY/UNIFY, no helper delegation; S8 extraction/surfacing completed; inherited Path A validation regression carried to v2.62.
- v2.62 Phases 265-267: parent-owned APPLY/UNIFY; hot artifact compaction/selective-loading guardrails completed; validation green by Phase 267.
- v2.63 Phases 268-272: parent-owned collaborative section loops for all lifecycle workflow rewrites; final validation green (Pi 312/312, cross 202/202); PR #188 merged.
- v2.64 Phases 273-278: parent-owned module-instruction audit/rewrite (base/dispatch, TODD/WALT/DEAN, advisory, domain cohorts) + semantic guardrails in `tests/helpers/module_instruction_semantics.sh`; cross-harness 195→202 PASS; PRs #190/#191/#192/#194/#195/#196. Detail archived ([v2.64](archive/roadmap/v2.64-module-instruction-audit-context-efficiency-rewrite.md)).
- v2.65 Phases 279-283: parent-owned functional-first guidance (contract, AGENTS/init, brownfield map-codebase, TODD/RUBY, advisory ARCH side-effect boundaries) with installed-resource marker checks; no new default blocking gates; cross-harness 234/234; PRs #197-#201. Detail archived ([v2.65](archive/roadmap/v2.65-functional-first-agent-guidance.md)).
- v2.66 Phases 284-287: parent-owned optional/advisory Plannotator plan/code-review surfaces; cross-harness 246/246; PRs #202-#205. Later retracted in v2.68.
- v2.67 Phases 288-290: cleared inherited CODI marker drift and hot-artifact budget drift; final Pi 335/335, cross-harness 246/246. Detail archived ([v2.67](archive/roadmap/v2.67-validation-hygiene.md)).
- v2.68 Phases 291-292: parent-owned Plannotator retraction (deleted `plannotator-bridge.ts` + contract, purged markers); Pi 328/328, cross-harness 234/234; PR #210 `7c38f42e`.

- Phase 294 PLAN/APPLY/UNIFY: Extracted S4 canonical guided-workflow reply delivery/config into `drivers/pi/extensions/guided-workflow-delivery.ts`, repointed Pi validation/docs, appended CODI/WALT history rows, and transitioned to Phase 295. Validation: install 9 extensions, `git diff --check`, artifact_consistency PASS, Pi 329/329, cross-harness 234/234; PR #213 checks passed.
- Phase 295 PLAN/APPLY/UNIFY: Created source-backed context-offload measurement and next-target ranking report, surfaced it in Pi docs, added recommendation-only validation guardrails, appended CODI/WALT history rows, passed merge gate, and closed v2.69. Validation: `git diff --check`, artifact_consistency PASS, Pi 331/331, cross-harness 235/235; PR #214 merged `08b0e891`.
- Fix (ff, 2026-06-01): Cleared inherited PROJECT.md byte-budget overage (25,331 → 23,763 B; ceil 25,000) carried in from v2.69 finalize commit `c5dd4255`, by collapsing five duplicated v2.64 per-phase decision rows (Phases 273-277) into one archive-pointing row; no history lost (detail in `PROJECT-HISTORY-v2.61-v2.66.md` + v2.64 roadmap archive). Validation: Pi 331/331, cross-harness 235/235, artifact_consistency PASS.
> Pre-v2.61 fixes/deviations/skill audits archived at .paul/archive/state/STATE-HISTORY-v2.44-v2.60.md.

### Deferred Issues

- ci-generation.md and sonarqube-integration.md — future module candidates.
- Agent SDK hook dispatch shelved — not an active milestone driver.
- Tree-sitter repo map deferred.
- Multi-model routing exists via `pals.json` `agents`, `agent-dispatch.md`, and apply-phase dispatch logic.
- S4 canonical reply delivery promoted from deferred integration point to active v2.69 scope.
- Cross-file narrative duplication (3 explicit duplications across STATE/PROJECT/MILESTONES/ROADMAP) recorded as deferred debt per Phase 265 contract; remediation remains deferred.

### Blockers/Concerns

- Future work should preserve artifact-first truth and resist telemetry, Pi-owned authoritative execution state, or reopening the settled Phase 69/70 contract without new evidence.
- Pi runtime assistance must reduce model context burden without creating an opaque control plane or weakening PLAN/APPLY/UNIFY, module evidence, GitHub Flow safety, or parent-owned APPLY boundaries.

### Git State

Branch: main; synced with origin/main after the Phase 304 merge (feature branch `feature/304-extraction-import-repoint` deleted local + remote).
Last lifecycle state: v2.72 Phase 304 complete — shared-runtime-helpers leaf extracted + 9 importers repointed; merged. Ready for transition to Phase 305.
PR #224: merged — https://github.com/coctostan/pals/pull/224 (`11c8112f`, squash, branch deleted). PR #223 merged (`ee5a9010`, squash); PR #222 merged (`96a556bc`, squash); PR #221 merged (`259489d0`, squash); PR #219 merged (`a2b2a2fa`, squash).
Transition state: v2.72 in progress — Phase 304 of 305 complete (2 of 3); Phase 305 (Validation + Closure) ready to plan.
Prior PRs: #221 / #219 / #218 / #217 / #207 / #206 / #205 / #204 / #203 / #202 / #201 / #200 / #199 / #198 / #197 / #196 / #195 / #194 / #192 / #191 / #190 / #189 / #188; earlier PR history archived at .paul/archive/state/STATE-HISTORY-v2.44-v2.60.md.

## Session Continuity

Last session: 2026-06-06 — Phase 304 completed + merged (PR #224 `11c8112f`); created Phase 305 PLAN (305-01).
Stopped at: Phase 305 planned (305-01 approved-pending), ready for APPLY.
Next action: /paul:apply for Phase 305 Plan 305-01
Resume file: .paul/phases/305-validation-closure/305-01-PLAN.md
git: branch `main`, synced after PR #224 `11c8112f` (Phase 304 squash; feature branch deleted). Baseline green: Pi e2e 343/343, cross-harness 253/253, artifact consistency PASS.
Resume context:
- v2.72 extracted pure/derived filesystem + state helpers (`compactWhitespace`, `selectBoundedLines`, `escapeRegExp`, `extractLoopSignature`, `readFileOr`, `getFileFreshness`, `parsePalsState` + `PalsStateSnapshot`) out of `pals-hooks.ts` into the leaf `shared-runtime-helpers` sibling; ctx/event helpers + CARL/routing stayed out. Phase 303 = contract ✅, 304 = extract+repoint ✅ (9 files), 305 = validate+close (next).
- Decision basis: post-v2.71 strategic assessment `.paul/assessments/2026-06-04-post-v2-71-next-milestone.md` re-confirmed shared runtime helper extraction as #1 (twice-deferred v2.69 Phase 295 ranking). Baseline to preserve: Pi e2e 342/342, cross-harness 253/253, artifact consistency PASS.
- Rising alternative for next milestone: validation-suite decomposition (`tests/pi-end-to-end-validation.sh` 2,812 lines + `tests/cross-harness-validation.sh` 2,249 lines).
