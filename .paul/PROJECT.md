# Project: pals

## Description

PALS - Project Automation & Lifecycle System. Based on PAUL and CARL along with their pals TODD and WALT. They team up to give users an agentic coding framework that makes development friendly while keeping lifecycle truth in portable markdown artifacts.

## Core Value

The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

## Current focus

Latest completed milestone: **v2.65 Functional-First Agent Guidance** — closed 2026-05-13 across Phases 279–283. Phase 283 added optional, non-blocking ARCH side-effect-boundary advisory guidance (Pure Core, Explicit Effects) plus Pi/cross-harness installed-resource marker validation; project conventions and local idioms remain authoritative and no new blocking functional-style gate ships. No active milestone.

Phase 234 (v2.55 baseline audit) findings were addressed across v2.55 phases 235–241; detail lives in archive history.

## Hot-path reading model

| Artifact | Role | Notes |
|----------|------|-------|
| `.paul/STATE.md` | Current lifecycle truth | Read for current phase, loop position, blockers, decisions, and next action. v2.62 budget ≤ 20 KB. |
| `.paul/ROADMAP.md` | Current milestone/phase plan | Read targeted slices for active milestone and next phases. v2.62 budget ≤ 12 KB / ≤ 120 lines. |
| `.paul/MILESTONES.md` | Compact milestone index | Links to archived completed milestone detail. v2.62 budget ≤ 18 KB. |
| `.paul/PROJECT.md` | Project brief | Description, hot-path model, active requirements, current milestone posture, durable decisions, success criteria, archive entry points. v2.62 budget ≤ 25 KB. |
| `.paul/archive/INDEX.md` | Archive entry point | Catalogs cold but still-authoritative project history. |
| `.paul/archive/project/PROJECT-HISTORY.md` and `PROJECT-HISTORY-v2.55-v2.60.md` | Detailed project/product history | Use when historical validated requirements or pre-v2.61 milestone posture/decisions are needed. |
| `.paul/SPECIAL-FLOWS.md` | Specialized flow routing | Use for command/skill routing beyond normal lifecycle. |

Authoritative v2.62 contract: `docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md` (Phase 265 baseline) — hot/warm/cold split rules, archive structure, per-section byte budgets, 14 preservation invariants, Phase 266/267 handoff.

## Active requirements summary

PALS is a portable, markdown-first lifecycle framework with these active/current guarantees:

- PLAN/APPLY/UNIFY remains the authoritative development loop.
- `.paul/*` artifacts remain lifecycle truth; no telemetry, hidden runtime state, Pi-owned persistence, or local memory replaces them.
- Kernel workflows stay platform-agnostic and are installed through driver adapters.
- Pi integration remains a thin, artifact-safe shell with command routing, lifecycle UI, guided workflow helpers, and bounded context injection.
- Module overlays dispatch from the installed `modules.yaml` registry and surface evidence through canonical workflow artifacts.
- GitHub Flow mode enforces branch/PR/CI/merge discipline when enabled in `pals.json`.
- `pals-implementer` may help with bounded delegated APPLY tasks, but parent APPLY owns task packets, structured report acceptance, actual changed-file diff checks, verification, module gates, fallback, checkpoints, GitHub Flow gates, and `.paul/*` lifecycle writes.
- CODI v0.1 is an advisory, TS/JS-touching codegraph helper with bounded source-selector extraction and post-unify instrumentation history.
- v2.43/v2.44 context optimization preserves archive links, historical authority, module evidence, GitHub Flow safety, and parent-owned APPLY while protecting reduced recurring read cost with anti-regrowth validation.
- v2.45 established Pi-native runtime assistance as the primary architecture direction: artifact-slice loading, workflow/resource capsules, guided workflow evidence, delegated APPLY packets, and Pi-Native validation classification all shipped while keeping `.paul/*` artifacts authoritative.
- v2.56–v2.61 extracted every active S* sibling Pi extension (S5/S1/S2/S3/S7/S6/S8); only S4 canonical reply delivery is explicitly deferred as the integration point.
- v2.62 compacted the four hot lifecycle artifacts to per-section byte budgets and added Selective Artifact Loading + anti-regrowth TAPs, without weakening lifecycle authority, helper compatibility, validation truth, or full authoritative read fallback.
- v2.64 rewrote module instruction sources for context efficiency and semantic enforcement, adding `tests/helpers/module_instruction_semantics.sh`; PLAN/APPLY/UNIFY remain authoritative for module rewrites.

## Current milestone posture

| Milestone | Status | Purpose |
|-----------|--------|---------|
| v2.61 Pi Extension Submodule Extraction Wave — S8 Command Routing Extraction | Complete (4 of 4 phases) — closed 2026-05-07 via Phase 264 closure (PRs #176 `423c467e` / #177 `19555747` / #178 `6f725276` / #179 `bc81fa84`) | Extracted S8 `command-routing` from `drivers/pi/extensions/pals-hooks.ts` into a sibling Pi extension module (`drivers/pi/extensions/command-routing.ts`, 230 LOC; twelve-entry `COMMANDS` array preserved byte-for-byte; four exported S8 functions; three closure factories; four command-routing constants exact-string single-defined; canonical `detectCommandSignal` regex literal; two exported types; loader-compat no-op default factory) while preserving S4 canonical reply delivery, the 12-iteration registration loop, and all 5 `Key.ctrlAlt("[nsrhm]")` invocations byte-for-byte in `pals-hooks.ts`. Patterns durable: sibling-surfacing recipe ratified a 6th time — durable across the full active S\* set (S5/S1/S2/S3/S7/S6/S8); sibling-extraction recipe ratified a 7th time (S5+S1+S2+S3+S7+S6+S8 — wave closed except S4); type-only back-import + TAP-assertion repoint + `inline → export` promotion patterns each ratified ×3; 4-symbol `inline → export` lockstep promotion (closures sharing a `let` must move together); first-ever closure-record-convention establishment on a contract that ships without a pre-baked status placeholder; closure-guardrail recipe ratified a 6th time (Phase 245/248/252/256/260/264). Final v2.61 validation: Pi 234→243 (+9), cross-harness 137→138 (+1 closure guardrail; 1 inherited Path A `not ok 31` carried), install 7→8. Path A inherited regression (Pi `not ok 102` / cross-harness `not ok 31`, ROADMAP active-window line-budget) escalated to v2.62 per Phase 264 recorded decision. |
| v2.62 PALS Context Diet — STATE & Hot-Path Compression | Complete (3 of 3 phases) — Phase 265 closed 2026-05-08 via PR #180 `63365822`; Phase 266 closed 2026-05-08 via PR #181 `a780bb7f`; Phase 267 closed 2026-05-08 via PR #182 `068d7cb3` | Applied the v2.43/v2.44 archive-and-compact recipe to STATE.md, PROJECT.md, MILESTONES.md, and ROADMAP.md, then changed PALS workflow behavior so hot artifacts are loaded as pertinent slices by default. Phase 265 produced `docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md`; Phase 266 archived/compacted hot artifacts to 63,415 B aggregate and resolved Path A (Pi 243/243, cross-harness 138/138); Phase 267 added Selective Artifact Loading, anti-regrowth TAPs (Phase 191 pattern), the 7th closure-guardrail recipe application, v2.62 closure aggregation, `267-01-SUMMARY.md`, and v2.63 recommended-not-approved candidate recording. |
| v2.63 Workflow Instruction Audit + Context-Efficiency Rewrite | Complete (5 of 5 phases) — closed 2026-05-10 via PR #188 `df56ece1` | Audited and rewrote lifecycle workflow instruction files one by one. Resume, plan, apply, unify, and pause workflows now use bounded operational loading, concise lifecycle routing, semantic guardrails, compact module evidence, GitHub Flow safety, required transition semantics, and compact agent-oriented PAUSE handoff packets. |
| v2.64 Module Instruction Audit + Context-Efficiency Rewrite | Complete (6 of 6 phases) — closed 2026-05-12 via PR #196 `340eee03` (Phase 273 PR #190 `f8861d44`; Phase 274 PR #191 `e18666ab`; Phase 275 PR #192 `44b795d5`; Phase 276 PR #194 `8c8dfb46`; Phase 277 PR #195 `aeff3f0a`; Phase 278 PR #196 `340eee03`) | Extended the v2.63 section-by-section workflow rewrite pattern into module manifests, module references, module workflow overlays, and shared module-dispatch/base-module documentation. Phase 277 aligned the ARCH/SETH/OMAR/PETE/REED/VERA domain optional cohort. Phase 278 added semantic module-instruction guardrails: reusable TAP-free `tests/helpers/module_instruction_semantics.sh`, replaced 7 inherited Phase 276 CODI marker-drift cross-harness failures with grouped behaviour signals (195→202 PASS), and recorded the closure pattern in `docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md`. Detail: [archive/roadmap/v2.64-module-instruction-audit-context-efficiency-rewrite.md](archive/roadmap/v2.64-module-instruction-audit-context-efficiency-rewrite.md). |
| v2.65 Functional-First Agent Guidance | Complete (5 of 5 phases) — closed 2026-05-13 across Phases 279–283 (PRs #197 / #198 / #199 / #200 / #201) | Added practical “functional-first, not functional-only” agent coding guidance without turning PALS into an FP framework or overriding project conventions. Phase 279 created the authoritative implementation contract (`docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md`); Phase 280 added generated AGENTS/init Engineering Principles plus installed-resource marker checks; Phase 281 added brownfield map-codebase/template signal detection for local idioms and effect boundaries; Phase 282 added TODD/RUBY pure-logic TDD and Extract Pure Core guidance plus installed marker checks; Phase 283 added advisory ARCH side-effect-boundary guidance (Pure Core, Explicit Effects), `The Leaking Effect` drift label, and Pi+cross-harness installed-resource marker validation, closing the milestone without a new default blocking gate.
| v2.66 Plannotator Integration — Rich UI Review Surfaces | Active (1 of 4 phases complete) — Phase 284 closed 2026-05-14 via PR #202 | Integrates PALS with `@plannotator/pi-extension` for opt-in rich UI review while preserving `.paul/*` lifecycle authority. Phase 284 created `docs/PALS-PLANNOTATOR-UI-INTEGRATION-CONTRACT.md` as the authoritative contract for consumed event/result fields, advisory sidecars, non-adoption, opt-in, failure modes, validation classification, and Phase 285 empirical-probe deferrals. |

> Pre-v2.61 milestone posture archived at .paul/archive/project/PROJECT-HISTORY-v2.55-v2.60.md (covers v2.41–v2.60). Pre-v2.55 detail at .paul/archive/project/PROJECT-HISTORY.md.

Latest closed milestone pointer: **v2.65 Functional-First Agent Guidance** — closed 2026-05-13. Source of truth for v2.65 scope is `docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md`; the research note remains provenance/background.

See `.paul/ROADMAP.md` for current routing, `.paul/MILESTONES.md` for the compact milestone index, `docs/PALS-CRITICAL-REVIEW-NEXT-ROADMAP.md` for v2.55 source context, `.paul/archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md` for v2.44 phase detail, and `docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md` for the v2.62 authoritative contract.

## Constraints

- CARL remains architecturally independent as Pi extension event integration, not a PALS workflow hook.
- TODD and WALT have no standalone operation; they are PALS-native module overlays.
- `/carl:*` namespace is preserved and not merged into `/paul:*`.
- Kernel files must remain platform-agnostic and avoid harness-specific assumptions.
- Module interfaces must stay simple enough to build a new pal in one session.
- Existing functionality must not regress during archive/compaction work.
- Archive files are still authoritative historical truth, not disposable summaries.
- Hot-path lifecycle artifacts must respect per-section byte budgets defined in `docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md`; cross-file narrative deduplication is deferred debt and is NOT remediated within v2.62.

## Key current decisions

| Decision | Source | Impact |
|----------|--------|--------|
| Artifacts are authoritative; prompts are interpretive. | v2.0 / artifact spec lineage | Keeps PALS portable across harnesses. |
| Preserve the minimal kernel, modular pals, universal drivers architecture. | v0.4+ / Core Value | Prevents driver or module work from owning lifecycle truth. |
| Keep Pi adapter additive and artifact-safe. | v2.1-v2.5, v2.38 | Pi improves UX without forking workflow semantics. |
| Keep module execution proof visible in workflow artifacts. | v2.7-v2.8, v2.27 | Dispatch evidence and reports remain durable and reviewable. |
| Parent APPLY remains authoritative when using `pals-implementer`. | v2.34-v2.37; Phase 215 | Subagents can help, but lifecycle ownership stays in the parent flow; parent must inspect structured reports and actual `git diff --name-only` before PASS. |
| Pi is the supported runtime; Claude Code and Agent SDK are unsupported/frozen historical surfaces. | Phase 192 | Architecture work uses `docs/PI-NATIVE-SUPPORT-INVENTORY.md` as support-tier source while preserving `.paul/*` artifact authority. |
| Pi runtime assistance must stay derived, bounded, source-cited, and disposable. | Phases 193–196 | Future Pi context-efficiency work cites artifacts and preserves PLAN/APPLY/UNIFY, module evidence, GitHub Flow, and parent-owned APPLY boundaries. |
| Classify validation before weakening checks (Pi-supported runtime / shared invariant / frozen legacy parity / runtime lens / guided UI safety / helper delegation / GitHub Flow safety / artifact/process). | Phase 196 / v2.51 | Future validation redesign optimizes for Pi without deleting shared invariant protection. |
| Root install/uninstall surfaces are Pi-first by default; frozen legacy/source-only drivers require explicit `PALS_DRIVER=...` opt-in. | Phase 223 | Aligns public install entry points with supported Pi runtime posture while preserving legacy source/reference access and command-output validation truth. |
| Risk-tiered lifecycle (tiny/doc-only, normal, risky, hotfix) focuses evidence rather than bypassing it. | Phase 235 | Future tier routing reduces ceremony only by focusing proof; explicit APPLY approval, validation truth, GitHub Flow gates, module blockers, parent-owned APPLY, lifecycle writes, `.paul/*` authority, command-output truth, full-read fallback, no hidden Pi state, and no telemetry remain non-bypass rules. |
| 2026-05-02: Sibling-module extraction (S5+S1+S2+S3+S7+S6+S8) is the durable Pi-extension modularization pattern; sibling-surfacing recipe is the canonical Documentation + Validation Surfacing shape; Pi extension loader-compat invariant is per-extraction (no-op default-exported factory). | Phases 239 / 243 / 246 / 250 / 254 / 258 / 262 | Future S* sibling extractions follow this recipe; only S4 canonical reply delivery is explicitly deferred as the integration point. |
| 2026-05-04: Type-only back-import and TAP-assertion repoint patterns are documented sibling-extraction techniques. | Phase 254 | Sibling type-imports from `./pals-hooks` are erased at runtime so the dependency graph stays acyclic; pre-existing TAP definition-string assertions repoint to imported-identifier assertions in the same plan-scope file as a bounded, no-net-count-change reconciliation. |
| 2026-05-07: Closure-guardrail recipe is durable across six consecutive milestones (Phase 245/248/252/256/260/264). | Phase 264 | One bounded `+1` cross-harness closure guardrail per milestone closure preserves command-output truth and shared-invariant protection; Phase 267 will apply it a 7th time. |
| 2026-05-07: 4-symbol `inline → export` lockstep promotion durable rule — closures sharing a `let` must move together. | Phase 262 | First applied to `let activationState` + `markActivation` / `getActiveActivation` / `consumeActivationTurn`; future closures sharing closed-over `let` must move as a lockstep group. |
| 2026-05-12: Module-instruction validation must verify grouped behaviour signals, not single literal markers; canonical literal dispatch log strings stay in their documented home (e.g. `references/codi.md`) and manifests verify behaviour-step semantics only; helper file `tests/helpers/module_instruction_semantics.sh` returns shell success/failure only so callers retain TAP ownership. | Phase 278 Plan 278-01 | Every future module-instruction audit guardrail requires multiple independent contract signals; marker-only compliance is rejected by construction. |
| 2026-05-12: Functional-first agent guidance uses a contract-over-research authority hierarchy. | Phase 279 Plan 279-01 (`279-01-SUMMARY.md`) | `docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md` is authoritative for v2.65 implementation after Phase 279 UNIFY; `docs/FUNCTIONAL-FIRST-AGENT-GUIDANCE-RESEARCH.md` remains provenance/background. Doctrine is “functional-first, not functional-only”; project conventions remain authoritative; no new module or default blocking FP gate is expected. |
| 2026-05-13: Generated agent convention defaults stay advisory, editable, and subordinate to project conventions. | Phase 280 Plan 280-01 (`280-01-SUMMARY.md`) | `kernel/templates/AGENTS.md` and `kernel/workflows/init-project.md` now place compact Engineering Principles before Project Conventions; validation scripts guard the installed markers without adding a dependency, module, or blocking functional-style gate. |
| 2026-05-13: TODD/RUBY functional-first guidance stays advisory, behavior-preserving, and validation-guarded. | Phase 282 Plan 282-01 (`282-01-SUMMARY.md`) | TODD now treats pure input-to-output business logic as high-value TDD scope and RUBY now documents Extract Pure Core as optional behavior-preserving/test-backed refactoring guidance; Pi and cross-harness installed-resource marker checks guard both without adding a default functional-style blocking gate. |
| 2026-05-13: ARCH side-effect-boundary guidance stays advisory and project-convention-aware; v2.65 closes without a default functional-style blocking gate. | Phase 283 Plan 283-01 (`283-01-SUMMARY.md`; PR #201) | ARCH module metadata, principles, patterns, drift, and onboarding references now surface side-effect boundary drift (Pure Core, Explicit Effects) as advisory evidence only, preserving project conventions and local idioms; Pi and cross-harness installed-resource marker checks (5 + 10 assertions) guard the new ARCH Phase 283 markers across both harnesses. |
| 2026-05-14: Plannotator integration uses a PALS-owned contract and advisory sidecars; upstream UI/source remains provenance. | Phase 284 Plan 284-01 (`284-01-SUMMARY.md`; PR #202) | `docs/PALS-PLANNOTATOR-UI-INTEGRATION-CONTRACT.md` is authoritative for v2.66 consumed event/result fields, non-adoption, opt-in, sidecar contracts, and failure modes. Ambiguous upstream details (`savedPath` format, extension-presence probe, abandoned UI behavior) are deferred to Phase 285 empirical probes rather than inferred. |
| 2026-05-07: Path A inherited regression (Pi `not ok 102` / cross-harness `not ok 31`, ROADMAP active-window line-budget) escalated to v2.62 per Phase 264 recorded decision; reconciled inline by Phase 266 ROADMAP warm compaction (no separate `/paul:fix` required). | Phase 264 / Phase 265 | Closure scope bounded to evidence + 1 guardrail; in-flight trim would expand scope beyond closure-recipe precedent. Phase 266 ROADMAP active-window compaction is the same root cause. |
| 2026-05-08: Single-Write-per-artifact recipe ratified for context-diet contracts and large lifecycle-artifact compaction. | Phase 265 / Phase 266 | One `Write` per file overwrite (computed offline) replaces many sequential `Edit`s for large markdown artifacts; Edit gets brittle on hash-drift. Used Phase 265 for the 39 KB / 395-line contract and Phase 266 for STATE/PROJECT/MILESTONES/ROADMAP. |
| 2026-05-08: Hot/warm/cold split rules and per-section byte budgets are the v2.62 authoritative contract. | Phase 265 (`docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md`) | STATE.md ≤ 20 KB / PROJECT.md ≤ 25 KB / MILESTONES.md ≤ 18 KB / ROADMAP.md ≤ 12 KB AND ≤ 120 lines / aggregate ≤ 80 KB. v2.61 (just-closed) and v2.62 (active) rows stay hot; pre-v2.61 lifts to archive. Phase 266 cannot deviate without recording it in SUMMARY.md; Phase 267 ratifies with anti-regrowth TAPs (Phase 191 pattern; line-ceiling validation calibrated against ~80 bytes/line). |
| 2026-05-08: Cross-file narrative duplication recorded as deferred debt (3 explicit duplications across STATE/PROJECT/MILESTONES/ROADMAP). | Phase 265 | Remediation requires architectural single-source-of-truth choice and would re-litigate v2.43/v2.44 separation-of-concerns; correctly deferred to v2.63+. v2.62 stays bounded to archive-and-compact. |
| 2026-05-08: Phase 267 implemented Selective Artifact Loading and closed v2.62 while preserving full authoritative read fallback. | Phase 267 Plan 267-01 (`267-01-PLAN.md`, `267-01-SUMMARY.md`) | Workflows locate relevant headings/markers/rows first and read bounded windows instead of whole hot artifacts by default; full read remains an explicit fallback for rewrite, audit, repair, migration, lifecycle write, or whole-artifact validation. Anti-regrowth TAPs protect budgets and markers; v2.63 cross-file narrative deduplication / single-source summary architecture is recommended, not approved. |
| 2026-05-09: Phase 268 made resume context-efficiency operational rather than marker-only. | Phase 268 Plan 268-01 (`268-01-PLAN.md`, `268-01-SUMMARY.md`) | Resume now derives lifecycle position from bounded STATE windows first, treats handoffs/resume files as conditional fallback context, removes broad/eager routine reads, and has semantic Pi/cross-harness guardrails that reject false-positive wording-only compliance. |
| 2026-05-09: Phase 271 made UNIFY reconciliation bounded, SUMMARY-first, and semantically guarded. | Phase 271 Plan 271-01 (`271-01-PLAN.md`, `271-01-SUMMARY.md`) | UNIFY now loads bounded STATE/session/PLAN/execution evidence, keeps SUMMARY as the durable reconciliation artifact, records compact mandatory post-unify module reports, preserves ordered GitHub Flow gates, and requires last-plan transition routing. Pi/cross-harness validation rejects broad/eager UNIFY reads, duplicate narrative writes, optional dispatch, marker-only module evidence, unsafe merge ordering, or skipped transitions. |
| 2026-05-10: Phase 272 closed v2.63 with bounded PAUSE and compact agent handoffs. | Phase 272 Plan 272-01 (`272-01-SUMMARY.md`) | `pause-work.md` now starts from bounded STATE windows, writes compact agent-oriented handoff packets, archives/supersedes stale active handoffs, records `wip_result`, treats `git_snapshot` as pause-time context, and validates PAUSE semantics in Pi/cross-harness suites. |
| 2026-05-11: Phase 273 established the v2.64 module instruction audit contract and cohort map. | Phase 273 Plan 273-01 (`273-01-PLAN.md`, `273-01-SUMMARY.md`); PR #190 `f8861d44` | Later module rewrite phases start from `docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md`, preserve the v2.63 collaborative section-by-section protocol, use the Phase 274-278 cohort map, and reject marker-only module compliance in Phase 278 guardrails. |
| 2026-05-11: Phase 274 aligned base module docs and dispatch reference to installed registry authority. | Phase 274 Plan 274-01 (`274-01-PLAN.md`, `274-01-SUMMARY.md`); PR #191 `e18666ab` | Module docs now distinguish source `modules/*/module.yaml` authoring truth from installed `modules.yaml` runtime dispatch truth, load hook-local refs only, keep advisory/enforcement semantics explicit, preserve compact `[dispatch]` evidence, and leave lifecycle blocking authority with PLAN/APPLY/UNIFY call sites. |
| 2026-05-11: Phase 275 aligned the first core enforcement module cohort. | Phase 275 Plan 275-01 (`275-01-PLAN.md`, `275-01-SUMMARY.md`) | TODD/WALT/DEAN approved manifest/reference sections now require concrete evidence for block/pass/skip behavior, workflow-owned recovery, no invented counts/metrics, bounded auto-fix, and no lifecycle-authority drift. Deferred TODD/WALT/DEAN secondary surfaces remain explicit for future plans. |
| 2026-05-11: Phase 276 aligned the advisory/on-demand module cohort. | Phase 276 Plan 276-01 (`276-01-PLAN.md`, `276-01-SUMMARY.md`); PR #194 `8c8dfb46` | IRIS/REV/SKIP/CODI/DOCS/RUBY approved manifest/reference sections are advisory/on-demand with bounded source loading, explicit provenance, named persistence destinations and schemas, visible skip/no-scope behavior, and no lifecycle-authority claim. Cross-harness CODI marker drift from intentionally removed stale markers is deferred to Phase 278 validation reconciliation. |
| 2026-05-12: Phase 277 aligned the backend/runtime domain optional module cohort. | Phase 277 Plan 277-01 (`277-01-PLAN.md`, `277-01-SUMMARY.md`); PR #195 `aeff3f0a` | ARCH/SETH/OMAR/PETE/REED/VERA manifests and primary references now use bounded advisory evidence, compact output/context schemas, no-invented-facts/no-coverage guardrails, and workflow-owned blocking response. ARIA/LUKE/GABE/DANA/DAVE and DEAN deferred refs remain follow-up scope; inherited CODI marker failures remain Phase 278 closure work. |

> Pre-v2.61 decisions archived at .paul/archive/project/PROJECT-HISTORY-v2.55-v2.60.md (lifts pre-v2.61 row history). Pre-v2.55 historical decisions at .paul/archive/project/PROJECT-HISTORY.md.

## Success Criteria

- Single `git clone` + install path gets PALS working on the supported Pi runtime.
- Full PLAN/APPLY/UNIFY loop works on real projects with module dispatch evidence.
- Context optimization materially reduces hot-path read cost while preserving history and lifecycle authority (v2.62: ~228 KB → ≤ 80 KB aggregate hot-path read total).
- PALS remains the user-friendly end-to-end agentic coding framework for Pi-first development while preserving historical artifact-first constraints.

## Specialized Flows

*Last updated: 2026-05-14 after Phase 284 completion; v2.66 active.*

Quick Reference:

- `/paul` → Project planning & lifecycle management
- `/carl` → Session boundary manager — autonomous session transitions
- TODD → Test-driven development enforcement
- WALT → Quality gating & validation

## Archive

- Project history (pre-v2.55): [.paul/archive/project/PROJECT-HISTORY.md](archive/project/PROJECT-HISTORY.md)
- Project history (v2.55–v2.60): [.paul/archive/project/PROJECT-HISTORY-v2.55-v2.60.md](archive/project/PROJECT-HISTORY-v2.55-v2.60.md)
- Milestone index: [.paul/MILESTONES.md](MILESTONES.md)
- Active roadmap: [.paul/ROADMAP.md](ROADMAP.md)
- Current state: [.paul/STATE.md](STATE.md)
- Archive catalog: [.paul/archive/INDEX.md](archive/INDEX.md)

---

*Created: 2026-03-11*
*Last updated: 2026-05-14 after Phase 284 completion; v2.66 active.*
