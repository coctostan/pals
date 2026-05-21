# Project State

## Project Reference

See: .paul/PROJECT.md (v2.69 Pi Runtime Context Offload active; Phase 293 ready to plan)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.69 Pi Runtime Context Offload — S4 First active. Safe TypeScript runtime offload should reduce agent contextual workload without moving lifecycle authority out of `.paul/*`, PLAN/APPLY/UNIFY, command output, GitHub Flow evidence, or transcript-visible canonical replies.

## Current Position

Milestone: v2.69 Pi Runtime Context Offload — S4 First
Phase: 295 of 295 (Context-Offload Measurement + Next Target Ranking)
Plan: .paul/phases/295-context-offload-measurement-next-target-ranking/295-01-PLAN.md
Status: APPLY complete; awaiting UNIFY
Last activity: 2026-05-21 — Phase 295 APPLY completed: report/docs/validation guardrails implemented; validation passed (git diff --check clean, artifact_consistency PASS, Pi 331/331, cross-harness 235/235).
Next action: /paul:unify .paul/phases/295-context-offload-measurement-next-target-ranking/295-01-PLAN.md

Progress:
- v2.62 PALS Context Diet — STATE & Hot-Path Compression: [██████████] 100% (Phase 265 ✅ PR #180 `63365822`; Phase 266 ✅ PR #181 `a780bb7f`; Phase 267 ✅ PR #182 `068d7cb3`)
- v2.63 Workflow Instruction Audit + Context-Efficiency Rewrite: [██████████] 100% (Phase 272 ✅ PR #188 `df56ece1`; milestone complete)
- v2.64 Module Instruction Audit + Context-Efficiency Rewrite: [██████████] 100% ✓ (Phases 273–278 complete; closed 2026-05-12 via PR #196 `340eee03`; archive [v2.64](archive/roadmap/v2.64-module-instruction-audit-context-efficiency-rewrite.md))
- v2.65 Functional-First Agent Guidance: [██████████] 100% ✓ (Phases 279–283 complete; closed 2026-05-13 via PRs #197 / #198 / #199 / #200 / #201)
- v2.66 Plannotator Integration — Rich UI Review Surfaces: [██████████] 100% ✓ (Phases 284–287 complete; PRs #202–#205)
- v2.67 Validation Hygiene: [██████████] 100% ✓ (Phases 288–290 complete; final validation Pi 335/335, cross-harness 246/246; archive [v2.67](archive/roadmap/v2.67-validation-hygiene.md))
- v2.68 Plannotator Retraction: [██████████] 100% ✓ (Phases 291–292 complete; PRs #209/#210)
- v2.69 Pi Runtime Context Offload — S4 First: [██████████] 97% (Phase 293 ✅ PR #212 `17578fb0`; Phase 294 ✅ PR #213 merged; Phase 295 APPLY ✅, UNIFY pending)
- Pre-v2.61 milestone progress lifted to [.paul/archive/state/STATE-HISTORY-v2.44-v2.60.md](archive/state/STATE-HISTORY-v2.44-v2.60.md).

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ○     [Phase 295 APPLY complete; ready for UNIFY]
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
> Pre-v2.61 decisions archived at .paul/archive/state/STATE-HISTORY-v2.44-v2.60.md. Earlier historical decisions through Phase 185 Plan 185-01 archived at .paul/archive/state/STATE-HISTORY-v0-v2.43.md.

### Fixes / Deviations / Skill Audits

- v2.61 Phases 261-264: parent-owned APPLY/UNIFY, no helper delegation; S8 extraction/surfacing completed; inherited Path A validation regression carried to v2.62.
- v2.62 Phases 265-267: parent-owned APPLY/UNIFY; hot artifact compaction/selective-loading guardrails completed; validation green by Phase 267.
- v2.63 Phases 268-272: parent-owned collaborative section loops for all lifecycle workflow rewrites; final validation green (Pi 312/312, cross 202/202); PR #188 merged.
- Phase 273 UNIFY: module audit contract/cohort map finalized; WALT/CODI rows recorded; PR #190 merged; no helper delegation.
- Phase 274 APPLY/UNIFY: base module/dispatch docs rewritten; artifact consistency repaired in UNIFY; PR #191 merged as `e18666ab`; transitioned to Phase 275.
- Phase 275 PLAN: Created `275-01-PLAN.md` for nine TODD/WALT/DEAN enforcement surfaces with compact audit/checkpoint, per-section approval loop, no helper delegation, and Phase 274 authority baseline.
- Phase 275 APPLY: Completed parent-owned collaborative rewrite of nine TODD/WALT/DEAN enforcement instruction surfaces; every section followed excerpt/problem/proposal/approval/edit/re-read; validation green after compacting STATE back under budget.
- Phase 275 UNIFY: Created `275-01-SUMMARY.md`, appended WALT/CODI history rows, updated lifecycle artifacts, and transitioned to Phase 276.
- Phase 276 PLAN: Created and revised `276-01-PLAN.md` for the IRIS/REV/SKIP/CODI/DOCS/RUBY advisory module cohort: v2.63-style compact audit first, then file-by-file and section-by-section BEFORE/AFTER proposal packets before mutation, no helper delegation by default, and explicit non-blocking/persistence/bounded-source guardrails; consumed ready-to-plan handoff archived.
- Phase 276 APPLY: Completed parent-owned collaborative section rewrite for CODI, SKIP, IRIS, REV, DOCS, and RUBY advisory/on-demand instruction surfaces; every mutated section used BEFORE/AFTER approval and re-read verification; source commits `3768048f` and `7a0ea261`; `artifact_consistency.sh` and `git diff --check` passed; cross-harness suite failed seven historical CODI marker checks after intentional tightening/removal of stale markers, deferred to Phase 278 validation reconciliation.
- Phase 276 UNIFY: Created `276-01-SUMMARY.md`; appended CODI and WALT history rows for `276-01`; updated lifecycle artifacts and transitioned to Phase 277. Cross-harness CODI marker drift remains deferred to Phase 278.
- Phase 277 PLAN: Created `277-01-PLAN.md` for the backend/runtime cross-cutting half of the domain optional cohort (ARCH, SETH, OMAR, PETE, REED, VERA — 14 files) using the v2.63/Phase 275/276 collaborative protocol: compact audit, file-by-file BEFORE/AFTER section loop, blocking checkpoint, no helper delegation, advisory/non-blocking guardrails, bounded source loading. UI/UX/data/deploy/DEAN-deferred half (ARIA/LUKE/GABE/DANA/DAVE) reserved for a follow-up Phase 277 plan.
- Phase 277 APPLY/UNIFY: Rewrote ARCH/SETH/OMAR/PETE/REED/VERA manifests and primary references section-by-section; converted broad command recipes and module-owned BLOCK/critical drift into bounded advisory evidence with compact schemas; created `277-01-SUMMARY.md`, appended WALT/CODI rows, and merged PR #195 as `aeff3f0a`. ARIA/LUKE/GABE/DANA/DAVE and DEAN deferred references remain follow-up scope; inherited CODI marker failures remain Phase 278 work.
- Phase 278 PLAN/APPLY/UNIFY: Replaced 7 inherited Phase 276 CODI marker-drift cross-harness failures with grouped semantic guardrails backed by reusable TAP-free helpers in `tests/helpers/module_instruction_semantics.sh`; added Phase 278 closure section to `docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md`; cross-harness 195→202 PASS, artifact_consistency PASS, `git diff --check` clean. `tests/pi-end-to-end-validation.sh` 307/312 (5 baseline-inherited CODI marker-drift failures unchanged pre/post via `git stash` comparison) recorded as Phase 278 follow-up scope. Plan 278-01 PR #196 ready for merge gate; parent-owned APPLY/UNIFY, no helper delegation.
- Phase 278 UNIFY: Created `278-01-SUMMARY.md`, appended CODI and WALT history rows for `278-01`, updated lifecycle artifacts.
- Phase 279 PLAN: Created `279-01-PLAN.md` for a docs-only contract phase. Scope is one new contract document; AGENTS/init, map-codebase, TODD, RUBY, ARCH, validation scripts, dependencies, and new modules are out of scope for APPLY.
- Phase 279 APPLY: Created `docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md`; preserved `docs/FUNCTIONAL-FIRST-AGENT-GUIDANCE-RESEARCH.md` as in-scope provenance; validation `git diff --check` and `bash tests/helpers/artifact_consistency.sh` passed; post-apply modules skipped/warned as docs-only/no runner; docs commit `8493c957`; PR #197 opened with no checks reported initially.
- Phase 279 UNIFY: Created `279-01-SUMMARY.md`, appended CODI and WALT history rows for `279-01`, marked Phase 279 complete, and transitioned to Phase 280. Contract authority hierarchy is now active for v2.65 planning.
- Phase 280 UNIFY: Created `280-01-SUMMARY.md`, appended CODI and WALT history rows for `280-01`, marked Phase 280 complete, and prepared transition to Phase 281. New marker checks passed; existing CODI/artifact-consistency validation baseline failures remain unrelated follow-up scope.
- Phase 281 UNIFY: Created `281-01-SUMMARY.md`, appended CODI and WALT history rows for `281-01`, marked Phase 281 complete, and prepared transition to Phase 282. New brownfield marker checks passed; inherited CODI/PROJECT/artifact-consistency validation failures remain unrelated follow-up scope.
- Phase 282 UNIFY: Created `282-01-SUMMARY.md`, appended CODI and WALT history rows for `282-01`, marked Phase 282 complete, and prepared transition to Phase 283. TODD/RUBY marker checks passed; inherited Pi CODI marker failures remain unrelated follow-up scope.
- Phase 283 PLAN/APPLY/UNIFY: Added advisory ARCH side-effect-boundary guidance and Pi+cross-harness installed-resource marker validation (5 + 10 assertions). Verification: `git diff --check` clean, both validation scripts pass `bash -n`, `artifact_consistency` PASS, cross-harness 234/234 PASS, Pi 322/328 with 6 baseline-inherited CODI/PROJECT-budget failures identical pre/post via `git stash`. Created `283-01-SUMMARY.md`, appended CODI and WALT history rows for `283-01`, marked Phase 283 complete, closed v2.65 milestone. Parent-owned APPLY/UNIFY, no helper delegation; one minor in-loop fix (lowercased `functional-first` in two ARCH hook descriptions so rendered modules.yaml carries the asserted marker).
- Phase 285 APPLY: Added `drivers/pi/extensions/plannotator-bridge.ts` with optional/advisory Plannotator event helpers (`requestPlanReview`, `requestCodeReview`, `awaitReviewResult`), surfaced the bridge in Pi docs/skill map, added Pi marker checks, archived the consumed Phase 285 handoff, and refreshed MILESTONES current-phase pointers. Verification: `git diff --check` clean, `bash -n` validation scripts PASS, artifact_consistency PASS, cross-harness 234/234 PASS, Pi 324/331 with seven inherited CODI/PROJECT/ROADMAP-budget failures unrelated to Phase 285 markers.
- Phase 285 UNIFY: Created `285-01-SUMMARY.md`, appended CODI and WALT history rows for `285-01`, marked Phase 285 complete, merged PR #203 after Socket checks passed, and transitioned to Phase 286. Phase 286 should wire the new bridge into `/paul:plan` with opt-in prompt and plan-review sidecars.
- Phase 286 PLAN/APPLY/UNIFY: Added opt-in Plannotator plan-review workflow semantics to `/paul:plan`, advisory `PLAN-REVIEW-NOTES.md` / `PLAN-FEEDBACK-{iteration}.md` sidecar rules, APPLY advisory-note loading, and Pi/cross-harness marker validation. Cross-harness passed 240/240; Pi Phase 286 markers passed with inherited CODI/PROJECT/ROADMAP-budget failures classified separately. PR #204 opened; Socket checks passed.
- Phase 287 PLAN/APPLY/UNIFY: Added opt-in Plannotator code-review workflow semantics to `/paul:apply` and `/paul:unify`, advisory `CODE-REVIEW-NOTES.md`, no auto `/paul:fix`, REV/GitHub Flow non-override guardrails, and Pi/cross-harness marker validation. Cross-harness passed 246/246; Pi Phase 287 markers passed with inherited CODI/PROJECT/ROADMAP-budget failures classified separately. PR #205 opened; Socket checks passed.
- v2.67 milestone created: Validation Hygiene targets inherited Pi e2e CODI marker-drift failures and PROJECT/ROADMAP byte-budget concerns with semantic-helper and hot-artifact hygiene phases before closure validation.
- Phase 288 UNIFY: Pi e2e CODI installed-resource marker checks now use shared semantic helpers; Pi validation is `334/335` with only PROJECT byte-budget drift remaining for Phase 289, and cross-harness remains `246/246`.
- Phase 289 UNIFY: Created `289-01-SUMMARY.md`, archived v2.61–v2.66 PROJECT detail to `.paul/archive/project/PROJECT-HISTORY-v2.61-v2.66.md`, kept PROJECT 24,347 bytes and ROADMAP 11,360 bytes, cleared Pi e2e to `335/335`, and kept cross-harness `246/246`. Phase 290 owns final v2.67 validation closure.
- Phase 290 UNIFY: Created `290-01-SUMMARY.md`, appended CODI/WALT history rows, recorded final v2.67 validation closure evidence, and marked v2.67 ready for GitHub Flow merge gate and milestone completion.

- Phase 294 PLAN/APPLY/UNIFY: Extracted S4 canonical guided-workflow reply delivery/config into `drivers/pi/extensions/guided-workflow-delivery.ts`, repointed Pi validation/docs, appended CODI/WALT history rows, and transitioned to Phase 295. Validation: install 9 extensions, `git diff --check`, artifact_consistency PASS, Pi 329/329, cross-harness 234/234; PR #213 checks passed.
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

Branch: main (PR #213 merged 2026-05-21T01:01:04Z; local main synced with origin/main)
Last lifecycle state: Phase 294 complete; PR #213 squash merge commit `683054fe`; Phase 295 ready to plan.
PR #213: merged — https://github.com/coctostan/pals/pull/213. PR #212 merged (`17578fb0`) closed Phase 293.
Transition state: v2.67 closed at squash `4143598b`; v2.68 closed via PR #210 squash `7c38f42e`; v2.69 opened via PR #211 squash `e5ab4459`.
Prior PRs: #207 / #206 / #205 / #204 / #203 / #202 / #201 / #200 / #199 / #198 / #197 / #196 / #195 / #194 / #192 / #191 / #190 / #189 / #188; earlier PR history archived at .paul/archive/state/STATE-HISTORY-v2.44-v2.60.md.

## Session Continuity

Last session: 2026-05-21 — Phase 295 APPLY completed.
Stopped at: APPLY complete; UNIFY not started.
Next action: /paul:unify .paul/phases/295-context-offload-measurement-next-target-ranking/295-01-PLAN.md
Resume file: .paul/phases/295-context-offload-measurement-next-target-ranking/295-01-PLAN.md
wip_result: not needed — APPLY task commits created on feature branch; lifecycle metadata remains pending UNIFY
Resume context:
- APPLY branch: `feature/295-context-offload-measurement-next-target-ranking`.
- Task commits: `082dd32b` report, `893a4270` Pi docs surfacing, `d7c20033` validation guardrails.
- Validation: `git diff --check` exit 0; `bash tests/helpers/artifact_consistency.sh` PASS; `bash tests/pi-end-to-end-validation.sh` PASS 331/331; `bash tests/cross-harness-validation.sh` PASS 235/235.
- Next lifecycle action is `/paul:unify .paul/phases/295-context-offload-measurement-next-target-ranking/295-01-PLAN.md`.
