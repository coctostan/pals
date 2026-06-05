# Project: pals

## Description

PALS - Project Automation & Lifecycle System. Based on PAUL and CARL along with their pals TODD and WALT. They team up to give users an agentic coding framework that makes development friendly while keeping lifecycle truth in portable markdown artifacts.

## Core Value

The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

## Current focus

No active milestone. Latest completed: **v2.71 HTML Presentation Packets — Human Review Briefs** — all 4 phases (299–302) complete, closed 2026-06-04 (PR #222 `96a556bc`, tag `v2.71`). Shipped a static packet contract/template, wired optional milestone/PLAN/APPLY/UNIFY brief generation, surfaced packets, and added CC↔Pi packet-surface guardrails while preserving `.paul/*` lifecycle authority. Run `/paul:discuss-milestone` or `/paul:milestone` for the next milestone.

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
- v2.56–v2.61 extracted the active S* sibling Pi extensions (S5/S1/S2/S3/S7/S6/S8); v2.69 extracted S4 canonical reply delivery into `guided-workflow-delivery.ts`, measured `pals-hooks.ts` context offload, and ranked shared filesystem/state helper extraction as the next contract-first recommendation.
- v2.62 compacted the four hot lifecycle artifacts to per-section byte budgets and added Selective Artifact Loading + anti-regrowth TAPs, without weakening lifecycle authority, helper compatibility, validation truth, or full authoritative read fallback.
- v2.64 rewrote module instruction sources for context efficiency and semantic enforcement, adding `tests/helpers/module_instruction_semantics.sh`; PLAN/APPLY/UNIFY remain authoritative for module rewrites.
- v2.71 added optional, non-blocking, derived/static HTML presentation packets (review briefs) for milestone/PLAN/APPLY/UNIFY moments under `.paul/presentation-packets/{phase-or-milestone}/{packet-id}.html`; packets are source-cited, budget-exempt, and never approve/block/merge/rewrite lifecycle state — `.paul/*`, PLAN/APPLY/UNIFY, module reports, and command output stay authoritative.

## Current milestone posture

| Milestone | Status | Purpose |
|-----------|--------|---------|
| v2.61–v2.66 (S8 Command Routing Extraction → Plannotator Integration) | Complete — closed 2026-05-07 → 2026-05-14 via PRs #176–#205 | S8 command-routing extraction, PALS Context Diet (hot/warm/cold split + byte budgets + selective loading + anti-regrowth TAPs), workflow + module instruction audits with semantic guardrails, functional-first agent guidance, and optional/advisory Plannotator surfaces (later retracted in v2.68). Detail archived in `.paul/archive/project/PROJECT-HISTORY-v2.61-v2.66.md`, `.paul/archive/roadmap/v2.64-...md`, and `.paul/archive/roadmap/v2.65-...md`. |
| v2.67 Validation Hygiene | Complete (3 of 3 phases) — closed 2026-05-19 | Cleared inherited Pi e2e baseline failures carried through v2.66: CODI marker drift, PROJECT/ROADMAP hot-artifact budget drift, and final validation closure. Evidence: `.paul/archive/roadmap/v2.67-validation-hygiene.md`. |
| v2.69 Pi Runtime Context Offload — S4 First | Complete (3 of 3 phases) — closed 2026-05-22 via PR #214 | Phase 293 created the S4 offload contract, Phase 294 extracted `guided-workflow-delivery.ts`, and Phase 295 measured context offload (`pals-hooks.ts` 671→546 lines) while ranking shared filesystem/state helper extraction as the next recommendation. |
| v2.70 Strategic Milestone Assessment | Complete (3 of 3 phases) — closed 2026-06-02 via PR #217 `9c5cdda8` (tag `v2.70`) | Shipped an optional, non-blocking, contract-first strategic-assessment checkpoint in `/paul:discuss`: five evidence lenses, four-part non-authoritative output to `.paul/assessments/{date}-{slug}.md`, pinned by Pi e2e 331→336 + cross-harness 235→241 marker checks. |
| v2.71 HTML Presentation Packets — Human Review Briefs | Complete (4 of 4 phases) — closed 2026-06-04 via PR #222 `96a556bc` (tag `v2.71`) | Shipped a static packet contract (`docs/PALS-HTML-PRESENTATION-PACKETS-CONTRACT.md`) + template, wired optional/non-blocking milestone/PLAN/APPLY/UNIFY brief generation into the four lifecycle workflows, surfaced packets (README + contract Status), and added CC↔Pi packet-surface parity + invariant + no-committed-`.html` guardrails. All packets derived/non-authoritative; cross-harness 253/253, Pi e2e 342/342. Detail: [v2.71 archive](archive/roadmap/v2.71-html-presentation-packets.md). |

> Pre-v2.61 milestone posture archived at .paul/archive/project/PROJECT-HISTORY-v2.55-v2.60.md (covers v2.41–v2.60). v2.61–v2.66 detail archived at .paul/archive/project/PROJECT-HISTORY-v2.61-v2.66.md. Pre-v2.55 detail at .paul/archive/project/PROJECT-HISTORY.md.

Current milestone pointer: **None active.** Latest closed milestone: **v2.71 HTML Presentation Packets — Human Review Briefs** (Phases 299–302; PRs #218/#219/#221/#222; tag `v2.71`). Run `/paul:discuss-milestone` or `/paul:milestone` to define the next milestone; standing candidate is shared filesystem/state helper extraction / Pi runtime context offload continuation (v2.69 Phase 295 recommendation).

See `.paul/ROADMAP.md` for current routing, `.paul/MILESTONES.md` for the compact milestone index, `docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md` for hot-artifact budget authority, and `tests/helpers/module_instruction_semantics.sh` for the semantic-helper validation pattern relevant to v2.67.

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
| 2026-05-02: Sibling-module extraction (S5+S1+S2+S3+S7+S6+S8) is the durable Pi-extension modularization pattern; sibling-surfacing recipe is canonical; loader-compat invariant is per-extraction (no-op default-exported factory). | Phases 239/243/246/250/254/258/262 | Future S* sibling extractions follow this recipe; only S4 was deferred (extracted in v2.69). |
| 2026-05-04: Type-only back-import and TAP-assertion repoint patterns are documented sibling-extraction techniques. | Phase 254 | Sibling type-imports from `./pals-hooks` are erased at runtime so the dependency graph stays acyclic; pre-existing TAP definition-string assertions repoint to imported-identifier assertions in the same plan-scope file as a bounded, no-net-count-change reconciliation. |
| 2026-05-07: Closure-guardrail recipe is durable across six consecutive milestones (Phase 245/248/252/256/260/264). | Phase 264 | One bounded `+1` cross-harness closure guardrail per milestone closure preserves command-output truth and shared-invariant protection; Phase 267 will apply it a 7th time. |
| 2026-05-07: 4-symbol `inline → export` lockstep promotion durable rule — closures sharing a `let` must move together. | Phase 262 | First applied to `let activationState` + `markActivation` / `getActiveActivation` / `consumeActivationTurn`; future closures sharing closed-over `let` must move as a lockstep group. |
| 2026-05-12: Module-instruction validation must verify grouped behaviour signals, not single literal markers; canonical literal dispatch log strings stay in their documented home (e.g. `references/codi.md`) and manifests verify behaviour-step semantics only; helper file `tests/helpers/module_instruction_semantics.sh` returns shell success/failure only so callers retain TAP ownership. | Phase 278 Plan 278-01 | Every future module-instruction audit guardrail requires multiple independent contract signals; marker-only compliance is rejected by construction. |
| 2026-05-12: Functional-first agent guidance uses a contract-over-research authority hierarchy. | Phase 279 Plan 279-01 (`279-01-SUMMARY.md`) | `docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md` is authoritative for v2.65 implementation after Phase 279 UNIFY; `docs/FUNCTIONAL-FIRST-AGENT-GUIDANCE-RESEARCH.md` remains provenance/background. Doctrine is “functional-first, not functional-only”; project conventions remain authoritative; no new module or default blocking FP gate is expected. |
| 2026-05-13: Generated agent convention defaults stay advisory, editable, and subordinate to project conventions. | Phase 280 Plan 280-01 (`280-01-SUMMARY.md`) | `kernel/templates/AGENTS.md` and `kernel/workflows/init-project.md` now place compact Engineering Principles before Project Conventions; validation scripts guard the installed markers without adding a dependency, module, or blocking functional-style gate. |
| 2026-05-13: TODD/RUBY functional-first guidance stays advisory, behavior-preserving, and validation-guarded. | Phase 282 Plan 282-01 (`282-01-SUMMARY.md`) | TODD now treats pure input-to-output business logic as high-value TDD scope and RUBY now documents Extract Pure Core as optional behavior-preserving/test-backed refactoring guidance; Pi and cross-harness installed-resource marker checks guard both without adding a default functional-style blocking gate. |
| 2026-05-13: ARCH side-effect-boundary guidance stays advisory and project-convention-aware; v2.65 closes without a default functional-style blocking gate. | Phase 283 Plan 283-01 (`283-01-SUMMARY.md`; PR #201) | ARCH module metadata, principles, patterns, drift, and onboarding references now surface side-effect boundary drift (Pure Core, Explicit Effects) as advisory evidence only, preserving project conventions and local idioms; Pi and cross-harness installed-resource marker checks (5 + 10 assertions) guard the new ARCH Phase 283 markers across both harnesses. |
| 2026-05-19: v2.66 Plannotator integration retracted in v2.68; no live PALS surface remains. | Phase 291 Plan 291-01 (`291-01-SUMMARY.md`; PR #209) + Phase 292 Plan 292-01 (`292-01-SUMMARY.md`) | Bridge code (`plannotator-bridge.ts`), kernel workflow opt-in steps, sidecar references (`PLAN-REVIEW-NOTES.md` / `PLAN-FEEDBACK-{iteration}.md` / `CODE-REVIEW-NOTES.md`), Plannotator marker assertions across Pi e2e + cross-harness suites (Pi 335→328; cross-harness 246→234), and `docs/PALS-PLANNOTATOR-UI-INTEGRATION-CONTRACT.md` are all removed. v2.66 archive evidence (Phases 284–287 plans/summaries, MILESTONES.md v2.66 row, `PROJECT-HISTORY-v2.61-v2.66.md`) remains authoritative historical truth. |
| 2026-05-20: S4 canonical reply delivery extracted into a dedicated Pi extension sibling. | Phase 294 Plan 294-01 (`294-01-SUMMARY.md`; PR #213) | `drivers/pi/extensions/guided-workflow-delivery.ts` now owns `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`, `GuidedWorkflowAutoPresent`, `GuidedWorkflowConfig`, and `GUIDED_WORKFLOW_DEFAULTS`; `pals-hooks.ts` remains runtime orchestration and imports S4 delivery/config. Validation: install 9 extensions, Pi 329/329, cross-harness 234/234. |
| 2026-05-22: v2.69 context-offload closure recommends shared filesystem/state helper extraction next. | Phase 295 Plan 295-01 (`295-01-SUMMARY.md`; PR #214 squash `08b0e891`) | S4 offload measured `pals-hooks.ts` 671→546 lines and S4 sibling 148 lines; next milestone should start contract-first on shared helper extraction unless user redirects. Recommendation remains non-authoritative until a future approved PLAN.
| 2026-06-02: v2.70 Strategic Milestone Assessment complete — optional, non-blocking, contract-first, main-session-only strategic-assessment checkpoint shipped in `/paul:discuss`. | Phases 296–298 (PRs #215 `ef8af629`, #216 `00c7d6c1`, #217) | `docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md` authoritative (five lenses, four-part non-authoritative output); `kernel/templates/STRATEGIC-ASSESSMENT.md` durable under `.paul/assessments/`. Pinned by Pi e2e 331→336 + cross-harness 235→241. No subagents, no Pi UI. |
| 2026-05-07: Path A inherited regression (Pi `not ok 102` / cross-harness `not ok 31`, ROADMAP active-window line-budget) escalated to v2.62 per Phase 264 recorded decision; reconciled inline by Phase 266 ROADMAP warm compaction (no separate `/paul:fix` required). | Phase 264 / Phase 265 | Closure scope bounded to evidence + 1 guardrail; in-flight trim would expand scope beyond closure-recipe precedent. Phase 266 ROADMAP active-window compaction is the same root cause. |
| 2026-05-08: Single-Write-per-artifact recipe ratified for context-diet contracts and large lifecycle-artifact compaction. | Phase 265 / Phase 266 | One `Write` per file overwrite (computed offline) replaces many sequential `Edit`s for large markdown artifacts; Edit gets brittle on hash-drift. Used Phase 265 for the 39 KB / 395-line contract and Phase 266 for STATE/PROJECT/MILESTONES/ROADMAP. |
| 2026-05-08: Hot/warm/cold split rules and per-section byte budgets are the v2.62 authoritative contract. | Phase 265 (`docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md`) | STATE.md ≤ 20 KB / PROJECT.md ≤ 25 KB / MILESTONES.md ≤ 18 KB / ROADMAP.md ≤ 12 KB AND ≤ 120 lines / aggregate ≤ 80 KB. v2.61 (just-closed) and v2.62 (active) rows stay hot; pre-v2.61 lifts to archive. Phase 266 cannot deviate without recording it in SUMMARY.md; Phase 267 ratifies with anti-regrowth TAPs (Phase 191 pattern; line-ceiling validation calibrated against ~80 bytes/line). |
| 2026-05-08: Cross-file narrative duplication recorded as deferred debt (3 explicit duplications across STATE/PROJECT/MILESTONES/ROADMAP). | Phase 265 | Remediation requires architectural single-source-of-truth choice and would re-litigate v2.43/v2.44 separation-of-concerns; correctly deferred to v2.63+. v2.62 stays bounded to archive-and-compact. |
| 2026-05-08: Phase 267 implemented Selective Artifact Loading and closed v2.62 while preserving full authoritative read fallback. | Phase 267 Plan 267-01 (`267-01-PLAN.md`, `267-01-SUMMARY.md`) | Workflows locate relevant headings/markers/rows first and read bounded windows instead of whole hot artifacts by default; full read remains an explicit fallback for rewrite, audit, repair, migration, lifecycle write, or whole-artifact validation. Anti-regrowth TAPs protect budgets and markers; v2.63 cross-file narrative deduplication / single-source summary architecture is recommended, not approved. |
| 2026-05-09: Phase 268 made resume context-efficiency operational rather than marker-only. | Phase 268 Plan 268-01 (`268-01-PLAN.md`, `268-01-SUMMARY.md`) | Resume now derives lifecycle position from bounded STATE windows first, treats handoffs/resume files as conditional fallback context, removes broad/eager routine reads, and has semantic Pi/cross-harness guardrails that reject false-positive wording-only compliance. |
| 2026-05-09: Phase 271 made UNIFY reconciliation bounded, SUMMARY-first, and semantically guarded. | Phase 271 Plan 271-01 (`271-01-PLAN.md`, `271-01-SUMMARY.md`) | UNIFY now loads bounded STATE/session/PLAN/execution evidence, keeps SUMMARY as the durable reconciliation artifact, records compact mandatory post-unify module reports, preserves ordered GitHub Flow gates, and requires last-plan transition routing. Pi/cross-harness validation rejects broad/eager UNIFY reads, duplicate narrative writes, optional dispatch, marker-only module evidence, unsafe merge ordering, or skipped transitions. |
| 2026-05-10: Phase 272 closed v2.63 with bounded PAUSE and compact agent handoffs. | Phase 272 Plan 272-01 (`272-01-SUMMARY.md`) | `pause-work.md` now starts from bounded STATE windows, writes compact agent-oriented handoff packets, archives/supersedes stale active handoffs, records `wip_result`, treats `git_snapshot` as pause-time context, and validates PAUSE semantics in Pi/cross-harness suites. |
| 2026-05-11/12: v2.64 module-instruction audit aligned every cohort to installed-registry authority (Phases 273-277). | Phase 273-277 Plans; PRs #190/#191/#194/#195 | Module rewrites start from `docs/PALS-MODULE-INSTRUCTION-AUDIT-CONTRACT.md`; source `modules/*/module.yaml` authoring truth stays distinct from installed `modules.yaml` dispatch truth; lifecycle blocking authority stays with PLAN/APPLY/UNIFY. Per-phase detail archived ([v2.64 roadmap](archive/roadmap/v2.64-module-instruction-audit-context-efficiency-rewrite.md)). |
| 2026-06-04: v2.71 HTML Presentation Packets complete — static, derived, non-authoritative human review briefs for all four lifecycle moments. | Phases 299–302 (`299/300/301/302-01-SUMMARY.md`; PRs #218/#219/#221/#222, tag `v2.71`) | `docs/PALS-HTML-PRESENTATION-PACKETS-CONTRACT.md` + `kernel/templates/HTML-PRESENTATION-PACKET.md` are authoritative; optional/non-blocking generation wired into create-milestone/plan-phase/apply-phase/unify-phase; packets stay static (no JS/network/external deps), source-cited, budget-exempt, and incapable of changing lifecycle state. CC↔Pi surface-parity + invariant + no-committed-`.html` guardrails added; cross-harness 253/253, Pi e2e 342/342. Detail: [v2.71 roadmap archive](archive/roadmap/v2.71-html-presentation-packets.md). |

> Pre-v2.61 decisions archived at .paul/archive/project/PROJECT-HISTORY-v2.55-v2.60.md (lifts pre-v2.61 row history). Pre-v2.55 historical decisions at .paul/archive/project/PROJECT-HISTORY.md.

## Success Criteria

- Single `git clone` + install path gets PALS working on the supported Pi runtime.
- Full PLAN/APPLY/UNIFY loop works on real projects with module dispatch evidence.
- Context optimization materially reduces hot-path read cost while preserving history and lifecycle authority (v2.62: ~228 KB → ≤ 80 KB aggregate hot-path read total).
- PALS remains the user-friendly end-to-end agentic coding framework for Pi-first development while preserving historical artifact-first constraints.

## Specialized Flows

Quick Reference:

- `/paul` → Project planning & lifecycle management
- `/carl` → Session boundary manager — autonomous session transitions
- TODD → Test-driven development enforcement
- WALT → Quality gating & validation

## Archive

- Project history (pre-v2.55): [.paul/archive/project/PROJECT-HISTORY.md](archive/project/PROJECT-HISTORY.md)
- Project history (v2.55–v2.60): [.paul/archive/project/PROJECT-HISTORY-v2.55-v2.60.md](archive/project/PROJECT-HISTORY-v2.55-v2.60.md)
- Project history (v2.61–v2.66): [.paul/archive/project/PROJECT-HISTORY-v2.61-v2.66.md](archive/project/PROJECT-HISTORY-v2.61-v2.66.md)
- Roadmap closure (v2.67): [.paul/archive/roadmap/v2.67-validation-hygiene.md](archive/roadmap/v2.67-validation-hygiene.md)
- Roadmap closure (v2.71): [.paul/archive/roadmap/v2.71-html-presentation-packets.md](archive/roadmap/v2.71-html-presentation-packets.md)
- Milestone index: [.paul/MILESTONES.md](MILESTONES.md)
- Active roadmap: [.paul/ROADMAP.md](ROADMAP.md)
- Current state: [.paul/STATE.md](STATE.md)
- Archive catalog: [.paul/archive/INDEX.md](archive/INDEX.md)

---

*Created: 2026-03-11*
*Last updated: 2026-06-04 after v2.71 milestone completion; all v2.71 phases (299–302) complete, no milestone active.*
