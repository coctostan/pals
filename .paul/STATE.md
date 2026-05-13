# Project State

## Project Reference

See: .paul/PROJECT.md (v2.65 active; functional-first agent guidance milestone created)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** v2.65 Functional-First Agent Guidance — lightweight “functional-first, not functional-only” coding guidance across agent conventions, brownfield mapping, TODD, RUBY, and optional ARCH advisory surfaces.

## Current Position

Milestone: v2.65 Functional-First Agent Guidance
Phase: 283 of 283 (ARCH Advisory + Closure) — Ready to plan
Plan: Not started
Status: Ready to plan
Last activity: 2026-05-13 — Phase 282 complete; transitioned to Phase 283
Next action: /paul:plan for Phase 283

Progress:
- v2.62 PALS Context Diet — STATE & Hot-Path Compression: [██████████] 100% (Phase 265 ✅ PR #180 `63365822`; Phase 266 ✅ PR #181 `a780bb7f`; Phase 267 ✅ PR #182 `068d7cb3`)
- v2.63 Workflow Instruction Audit + Context-Efficiency Rewrite: [██████████] 100% (Phase 272 ✅ PR #188 `df56ece1`; milestone complete)
- v2.64 Module Instruction Audit + Context-Efficiency Rewrite: [██████████] 100% ✓ (Phases 273–278 complete; closed 2026-05-12 via PR #196 `340eee03`; archive [v2.64](archive/roadmap/v2.64-module-instruction-audit-context-efficiency-rewrite.md))
- v2.65 Functional-First Agent Guidance: [██████████] 90% (Phases 279–282 complete; Phase 283 ready to plan)
- Pre-v2.61 milestone progress lifted to [.paul/archive/state/STATE-HISTORY-v2.44-v2.60.md](archive/state/STATE-HISTORY-v2.44-v2.60.md).

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ○        ○        ○     [Phase 283 ready to plan]
```

## Accumulated Context

### Current Summary

- PLAN/APPLY/UNIFY remains authoritative; `.paul/*` artifacts are lifecycle truth; archives under `.paul/archive/*` hold history.
- v2.64 completed the module instruction audit/context-efficiency rewrite and is archived.
- v2.65 is active and will add practical “functional-first, not functional-only” agent coding guidance without turning PALS into a functional-programming framework or overriding project conventions; Phases 279–282 are complete and Phase 283 ARCH Advisory + Closure is ready to plan.

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

> Pre-v2.61 fixes/deviations/skill audits archived at .paul/archive/state/STATE-HISTORY-v2.44-v2.60.md.

### Deferred Issues

- Future follow-up: apply the Phase 278 semantic-guardrail pattern to `tests/pi-end-to-end-validation.sh` checks 10, 185, 188, 190, 192 (5 baseline-inherited CODI marker-drift failures; identical-family fix using existing `tests/helpers/module_instruction_semantics.sh`).
- ci-generation.md and sonarqube-integration.md — future module candidates.
- Agent SDK hook dispatch shelved — not an active milestone driver.
- Tree-sitter repo map deferred.
- Multi-model routing exists via `pals.json` `agents`, `agent-dispatch.md`, and apply-phase dispatch logic.
- Pi extension submodule extraction completed v2.56–v2.61 wave (every active S* extracted); only S4 canonical reply delivery remains explicitly deferred as the integration point.
- Cross-file narrative duplication (3 explicit duplications across STATE/PROJECT/MILESTONES/ROADMAP) recorded as deferred debt per Phase 265 contract; remediation deferred to v2.63+.

### Blockers/Concerns

- Future work should preserve artifact-first truth and resist telemetry, Pi-owned authoritative execution state, or reopening the settled Phase 69/70 contract without new evidence.
- Pi runtime assistance must reduce model context burden without creating an opaque control plane or weakening PLAN/APPLY/UNIFY, module evidence, GitHub Flow safety, or parent-owned APPLY boundaries.

### Git State

Branch: main (PR #200 merged)
Last lifecycle state: Phase 282 UNIFY completed and merged via PR #200; merge commit `998c3771`; task commit `938618d0`; SUMMARY `.paul/phases/282-todd-ruby-guidance/282-01-SUMMARY.md`.
PR #200: merged — https://github.com/coctostan/pals/pull/200; Socket Security checks passed.
Transition state: Phase 282 complete; Phase 283 ready to plan.
Prior PRs: #196 / #195 / #194 / #192 / #191 / #190 / #189 / #188 / #181 / #180 / #179 / #178 / #177 / #176; earlier PR history archived at .paul/archive/state/STATE-HISTORY-v2.44-v2.60.md.

## Session Continuity

Last session: 2026-05-13 — Phase 282 UNIFY complete and PR #200 merged; Phase 283 ready to plan.
Stopped at: Phase 282 complete; transitioned to Phase 283.
Next action: /paul:plan for Phase 283
Resume file: .paul/ROADMAP.md
wip_result: none — UNIFY lifecycle artifacts merged via PR #200
Resume context:
- Phase 282 added TODD/RUBY functional-first guidance and installed-resource marker checks.
- Verification: `git diff --check` PASS; `bash -n` PASS; artifact consistency PASS; cross-harness PASS 224/224; Pi Phase 282 markers PASS with 5 inherited CODI failures remaining.
- Next lifecycle step should plan Phase 283 ARCH Advisory + Closure.
