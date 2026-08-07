# Project State

## Project Reference

See: .paul/PROJECT.md (latest completed milestone: v2.73 Module Efficacy Ledger + Field Harvest, completed 2026-08-07)
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers
**Current focus:** Finalize v2.73 archive/index/tag closure, then discuss the next milestone; validation-suite decomposition remains a candidate, not an approved commitment.

## Current Position

Milestone: v2.73 Module Efficacy Ledger + Field Harvest — closure in progress
Phase: 308 of 308 (Proposal Batch + Validation/Closure) — complete
Plan: None active
Status: All 3 phases and 4 plans complete; milestone archive/index prepared; closure PR and tag pending
Last activity: 2026-08-07 — Created v2.73 roadmap archive and evolved MILESTONES/PROJECT/ROADMAP for milestone closure.
Next action: Complete the milestone closure PR and create tag `v2.73`

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
- v2.72 Shared Runtime Helper Extraction: [██████████] 100% ✓ (Phases 303–305 complete; closed 2026-06-07 via PR #225 squash `ad9ea9dd`, tag `v2.72`; archive [v2.72](archive/roadmap/v2.72-shared-runtime-helper-extraction.md))
- v2.73 Module Efficacy Ledger + Field Harvest: [██████████] 100% ✓ (Phases 306–308 complete; PRs #226–#231; archive/index closure prepared; tag `v2.73` pending)
- Pre-v2.61 milestone progress lifted to [.paul/archive/state/STATE-HISTORY-v2.44-v2.60.md](archive/state/STATE-HISTORY-v2.44-v2.60.md).

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ○        ○        ○     [Milestone v2.73 phase work complete; archive/tag closure in progress]
```

## Accumulated Context

### Current Summary

- PLAN/APPLY/UNIFY remains authoritative; `.paul/*` artifacts are lifecycle truth; archives under `.paul/archive/*` hold history.
- v2.64 completed the module instruction audit/context-efficiency rewrite and is archived.
- v2.65 Functional-First Agent Guidance closed 2026-05-13 across Phases 279–283: authoritative contract, AGENTS/init Engineering Principles + brownfield map-codebase signals, TODD pure-logic TDD + RUBY Extract Pure Core advisory guidance, and advisory ARCH side-effect-boundary guidance — all with project conventions and local idioms preserved as authoritative and no new default blocking functional-style gates.
- Phase 306 completed via PR #226: forward-looking ledger contract/template, non-blocking UNIFY append, human-gated config efficacy, six Pi checks, and a 19-row bootstrap ledger.
- Plan 307-01 completed via PR #227: field-harvest normalization contract (dialects A–F + exclusion X), read-only fixture-tested harvester, and a pals self-harvest of 207 rows / 270 manifest entries validated by an exact 19/19 reproduction of the forward 306-01 ledger rows.
- Phase 307 completed via PRs #227/#228: deterministic three-deployment harvest + audited manifest + §10 roll-up; final evidence is 375 normalized rows / 408 unparseable with a 52% corpus caveat.
- v2.73 phase work completed across Phases 306–308: derived efficacy ledger, deterministic three-deployment harvest (375 normalized / 408 unparseable), 17/17 source-audited dispositions, three proposed-only human routes, four TAP guardrails, final Pi 364/364 and cross-harness 261/261. Milestone archive/index closure is prepared.

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
| 2026-07-10: Module efficacy ledger is derived and workflow-owned | Phase 306 / PR #226 | SUMMARY reports remain source evidence; ledger writes never gate lifecycle flow. |
| 2026-07-10: Config efficacy stays human-gated | Phase 306 / PR #226 | Advisory zero-finding modules may be reviewed; WALT/DEAN/TODD/SETH remain demotion-exempt wherever scoped. |
| 2026-07-10: Actioned counts require trace evidence | Phase 306 / PR #226 | Only a later fix, PLAN task, or logged debt entry supports `Actioned? = yes`. |
| 2026-08-07: Retroactive harvest never coerces or infers | Plan 307-01 / PR #227 | Unmapped status tokens and unknown modules go to `UNPARSEABLE.md`, never to a guessed row; `Actioned? = yes` is never emitted retroactively, so harvested actioned counts are a floor. |
| 2026-08-07: Overlap-diff is the acceptance test for retroactive extraction | Plan 307-01 / PR #227 | Harvesting a phase the forward path already wrote (306-01, 19/19 exact) validates contract and parser against evidence neither produced; Plan 307-02 inherits this technique. |
| 2026-08-07: Absence of evidence and unreadable evidence are distinct findings | Plan 307-02 / PR #228 | 60 units claimed `no-dispatch-evidence` while carrying an unparsed `Module Execution Reports` section; they now emit `unrecognized-dispatch-shape`. Collapsing the two would let thin parser coverage read as low module usage in Phase 308. |
| 2026-08-07: Read-only guarantees must be path-tested, not checksum-tested | Plan 307-02 / PR #228 | A rejected harvest still created an empty directory inside both real deployments; file hashes could not see it. Boundary tests compare path sets, and `mkdir` never precedes a boundary check. |
| 2026-08-07: Roll-ups derive only from committed normalized artifacts | Plan 307-02 / PR #228 | One normalization path prevents aggregate output from disagreeing with the ledgers; absent deployment/module observations render as `—`, never measured zero. |
| 2026-08-07: v2.73 proposals remain proposed-only | 308-01-SUMMARY.md / PRs #229–#231 / [v2.73 archive](archive/roadmap/v2.73-module-efficacy-ledger-field-harvest.md) | Harvest aggregates are discovery aids; source SUMMARYs and human decision authority win. Quark 120-01's normalized `BLOCK` is an overstatement, and no proposal authorizes implementation. |
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
- Phase 308 PLAN/APPLY/UNIFY: Source-audited 17/17 findings, authored three proposed-only human routes, added four TAP guardrails, compacted PROJECT below budget, and closed validation at Pi 364/364 / cross-harness 261/261. PR #229 merged implementation early; PR #230 merged lifecycle closure (`34633c26`).
- Fix (ff, 2026-06-01): Cleared inherited PROJECT.md byte-budget overage (25,331 → 23,763 B; ceil 25,000) carried in from v2.69 finalize commit `c5dd4255`, by collapsing five duplicated v2.64 per-phase decision rows (Phases 273-277) into one archive-pointing row; no history lost (detail in `PROJECT-HISTORY-v2.61-v2.66.md` + v2.64 roadmap archive). Validation: Pi 331/331, cross-harness 235/235, artifact_consistency PASS.
- Phase 306 APPLY: parent-owned inline execution; T1 commit was retried after a stale command context and landed after T2/T3 without content deviation. Pi suite 347/349 vs baseline 341/343; inherited ROADMAP byte-budget and artifact-consistency failures unchanged.
- Plan 307-01 APPLY/UNIFY: parent-owned inline execution, no helper delegation; skills /paul, TODD, WALT all invoked (/carl n/a — no session boundary inside APPLY). Deviations: contract amended twice mid-APPLY (dialect F + three normalization gaps, in-mandate per Task 3), unplanned parser split to `tools/lib/parse-summary.awk`, 11 fixtures vs 9 planned, Task 2 write-boundary redesigned in Task 3. Validation Pi 349→355, cross-harness 254→257, zero failures both sides; 0 boundary violations.
- Plan 307-02 APPLY/UNIFY: parent-owned TDD/spec-first execution; external roots unchanged (54,650 + 4,143 files), path-creation boundary defect fixed, three audited contract amendments, 375/408 roll-up, DOCS advisory closed. Deviations: one essential unplanned harvester edit, helper touched early, 112-byte ROADMAP trim, authorized pals re-harvest. Validation Pi 355→362, cross-harness 257→259, zero failures.
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

Branch: `docs/v2.73-milestone-closure`; base: `main`; started synced 0 behind / 0 ahead.
PR: milestone closure PR pending.
CI: pending closure PR; inherited final phase validation Pi 364/364, cross-harness 261/261, artifact consistency PASS.
Last commit: `e7fe6d9a` on `origin/main` before milestone closure work.

## Session Continuity

Last session: 2026-08-07 — Began v2.73 milestone archive/index/tag closure after all phase work passed.
Stopped at: Milestone closure artifacts prepared on `docs/v2.73-milestone-closure`; PR/tag pending.
Next action: Complete the milestone closure PR and create tag `v2.73`
Resume file: .paul/MILESTONES.md
closure_result: pending PR merge and tag.
transition_result: Phase 308 complete (1 PLAN / 1 SUMMARY); v2.73 has 3 phases / 4 plans complete.
Resume context:
- Permanent roadmap archive created at `.paul/archive/roadmap/v2.73-module-efficacy-ledger-field-harvest.md`; live MILESTONES/PROJECT/ROADMAP evolved.
- Final phase validation remains Pi 364/364, cross-harness 261/261, artifact consistency PASS, diff hygiene clean, and all hot-artifact budgets green.
- After merge/tag, route exactly to `/paul:discuss-milestone`.
