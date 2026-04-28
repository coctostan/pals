# Project: pals

## Description

PALS - Project Automation & Lifecycle System. Based on PAUL and CARL along with their pals TODD and WALT. They team up to give users an agentic coding framework that makes development friendly while keeping lifecycle truth in portable markdown artifacts.

## Core Value

The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

## Current focus

v2.49 Workflow/Resource Capsule Contract is complete. The milestone defined the workflow/resource capsule contract, hardened Pi runtime capsule loading, surfaced capsule behavior in docs/validation, and reconciled final closure evidence with Pi 197/197 and cross-harness 112/112 validation.

The immediate next recommended milestone is Delegated APPLY Packet/Report Contract, followed by Pi-Native Validation Classification and Legacy Retention / Install-Surface Cleanup. Future work should preserve `.paul/*`, PLAN/APPLY/UNIFY, module evidence, GitHub Flow gates, parent-owned APPLY, explicit approval/checkpoint behavior, command-output validation truth, and full authoritative reads for consequential work.

## Hot-path reading model

| Artifact | Role | Notes |
|----------|------|-------|
| `.paul/STATE.md` | Current lifecycle truth | Read for current phase, loop position, blockers, decisions, and next action. |
| `.paul/ROADMAP.md` | Current milestone/phase plan | Read targeted slices for active milestone and next phases. |
| `.paul/MILESTONES.md` | Compact milestone index | Links to archived completed milestone detail. |
| `.paul/archive/INDEX.md` | Archive entry point | Catalogs cold but still-authoritative project history. |
| `.paul/archive/project/PROJECT-HISTORY.md` | Detailed project/product history | Use when historical validated requirements or decisions are needed. |
| `.paul/SPECIAL-FLOWS.md` | Specialized flow routing | Use for command/skill routing beyond normal lifecycle. |

## Active requirements summary

PALS is a portable, markdown-first lifecycle framework with these active/current guarantees:

- PLAN/APPLY/UNIFY remains the authoritative development loop.
- `.paul/*` artifacts remain lifecycle truth; no telemetry, hidden runtime state, Pi-owned persistence, or local memory replaces them.
- Kernel workflows stay platform-agnostic and are installed through driver adapters.
- Pi integration remains a thin, artifact-safe shell with command routing, lifecycle UI, guided workflow helpers, and bounded context injection.
- Module overlays dispatch from the installed `modules.yaml` registry and surface evidence through canonical workflow artifacts.
- GitHub Flow mode enforces branch/PR/CI/merge discipline when enabled in `pals.json`.
- `pals-implementer` may help with bounded delegated APPLY tasks, but parent APPLY owns verification, module gates, fallback, and `.paul/*` lifecycle writes.
- CODI v0.1 is an advisory, TS/JS-touching codegraph helper with bounded source-selector extraction and post-unify instrumentation history.
- v2.44 context optimization preserves archive links, historical authority, module evidence, GitHub Flow safety, and parent-owned APPLY while protecting reduced recurring read cost with anti-regrowth validation.
- v2.45 established Pi-native runtime assistance as the primary future architecture direction: Phases 192-196 reset support tiers, mapped Pi capabilities, designed context-efficiency guardrails, validated artifact-slice loading, and produced the final implementation roadmap while keeping `.paul/*` artifacts authoritative.

## Current milestone posture

| Milestone | Status | Purpose |
|-----------|--------|---------|
| v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation | Complete | Natural quark observations showed qualitative value but measurement gaps. |
| v2.42 CODI v0.1 — Post-Unify Instrumentation Fix | Complete | Shipped bounded parser/hook instrumentation repair and accepted CODI v0.1 as good enough. |
| v2.43 PALS Context Diet — Archive, Compact, Compress | Complete | Moved cold history into indexed archives, compacted hot/warm artifacts, compressed workflow prose, and added anti-regrowth validation guardrails. |
| v2.44 PALS Context Optimization — Process & Artifacts | Complete | Reduced recurring context cost across workflows and lifecycle artifacts while preserving artifact-first truth, module evidence, and GitHub Flow safety; Phase 191 validation now protects the gains. |
| v2.45 Pi-Native PALS Architecture | Complete | Repositioned PALS around Pi as the supported runtime, validated artifact-slice context loading, and produced the final architecture proposal plus implementation roadmap. |
| v2.46 Pi-Native Implementation Planning | Complete | Processed v2.45 findings and architecture into implementation workstreams, sequencing, validation/evidence strategy, and a final executable implementation plan proposal before build milestones begin. |
| v2.47 Artifact-Slice Contract Hardening | Complete | Hardened activation-gated, bounded, source-cited, freshness-aware artifact slices and full-read fallback as the first Pi-native context-efficiency build milestone. |
| v2.49 Workflow/Resource Capsule Contract | Complete | Defined and hardened safe orientation capsules for installed resources without replacing authoritative workflow reads; final validation passed Pi 197/197 and cross-harness 112/112. |

Recently completed: v2.49 Workflow/Resource Capsule Contract closed the third Pi-native build milestone with source-cited, bounded, derived-only workflow/resource capsules, final evidence reconciliation, PR #128, Pi validation 197/197, and cross-harness validation 112/112.
See `.paul/ROADMAP.md` for current routing, `.paul/MILESTONES.md` for the compact milestone index, `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` for v2.45 architecture inputs, and `.paul/archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md` for v2.44 phase detail.

## Constraints

- CARL remains architecturally independent as Pi extension event integration, not a PALS workflow hook.
- TODD and WALT have no standalone operation; they are PALS-native module overlays.
- `/carl:*` namespace is preserved and not merged into `/paul:*`.
- Kernel files must remain platform-agnostic and avoid harness-specific assumptions.
- Module interfaces must stay simple enough to build a new pal in one session.
- Existing functionality must not regress during archive/compaction work.
- Archive files are still authoritative historical truth, not disposable summaries.

## Key current decisions

| Decision | Source | Impact |
|----------|--------|--------|
| Artifacts are authoritative; prompts are interpretive. | v2.0 / artifact spec lineage | Keeps PALS portable across harnesses. |
| Preserve the minimal kernel, modular pals, universal drivers architecture. | v0.4+ / Core Value | Prevents driver or module work from owning lifecycle truth. |
| Keep Pi adapter additive and artifact-safe. | v2.1-v2.5, v2.38 | Pi improves UX without forking workflow semantics. |
| Keep module execution proof visible in workflow artifacts. | v2.7-v2.8, v2.27 | Dispatch evidence and reports remain durable and reviewable. |
| Parent APPLY remains authoritative when using `pals-implementer`. | v2.34-v2.37 | Subagents can help, but lifecycle ownership stays in the parent flow. |
| CODI v0.1 ships as good enough after bounded instrumentation repair. | v2.42 | Future CODI work should be real-usage-driven, not prerequisite to current context-diet work. |
| Separate total artifact growth from repeated hot-path read cost. | Phase 158 | v2.43 optimizes context pressure without deleting history. |
| Archive cold history before compacting sensitive hot artifacts. | Phase 184 | Phase 185 proves links/indexes before touching `STATE.md` structure. |
| Keep live roadmaps as active-window artifacts with completed detail in authoritative archives. | Phase 185 | Future roadmap writes preserve current routing inline while preventing completed-history bloat. |
| Centralize shared module-dispatch mechanics in `kernel/references/module-dispatch.md` while keeping hook-local obligations in workflows. | Phase 186 | Reduces hot-path workflow prose and drift risk without hiding post-unify persistence or GitHub Flow merge-gate semantics. |
| Guard context-diet gains with semantic validation and a practical line ceiling | Phase 187 | Future hot workflow edits must retain lifecycle/module/merge-gate markers and stay under the 1711 Phase 186 pre-compression ceiling. |
| Treat Claude Code command wrappers as legacy/reference thin pointers while keeping Pi skills as the active user-facing surface | Phase 188 | Reduces recurring wrapper context cost without expanding Claude-specific support beyond routing parity. |
| Hot-path read cost is concentrated in `.paul/ROADMAP.md` (744 lines, ~690 historical) and duplicated GitHub Flow stanzas across 5+ workflows; Pi adapter and Claude wrappers are deferred. | Phase 189 Plan 189-01 | Phase 190 primary work is ROADMAP archive split + GitHub Flow centralization; Pi adapter modularization and Claude wrapper handling are gated on a product-level Claude Code support-tier decision. |
| Phase 190 artifact simplification uses active-window artifacts plus reference-owned shared mechanics. | Phase 190 Plans 190-01/190-02 | ROADMAP history and duplicated workflow mechanics are authoritative but no longer repeated in hot-path reads. |
| Defer Pi adapter modularization to a future driver-quality milestone. | Phase 190 Plan 190-02 | Keeps v2.44 focused on process/artifact read-cost reductions without changing Pi runtime behavior. |
| Prefer structural anti-regrowth checks over long exact-prose assertions. | Phase 191 Plan 191-01 | Validation protects context-diet gains through line budgets, archive pointers, occurrence ceilings, and short semantic anchors across source and installed surfaces. |
| Claude Code compatibility is unsupported/frozen; PALS may become Pi-native. | v2.45 milestone creation | Future architecture can leverage Pi extensions without preserving cross-harness parity, while keeping `.paul/*` artifacts authoritative. |
| Pi is the supported runtime; Claude Code and Agent SDK are unsupported/frozen historical surfaces. | Phase 192 Plan 192-01 | Current architecture work should use `docs/PI-NATIVE-SUPPORT-INVENTORY.md` as the support-tier classification source while preserving `.paul/*` artifact authority. |
| Pi runtime assistance must stay derived, bounded, and artifact-backed rather than authoritative lifecycle state. | Phase 193 Plan 193-01 | Phase 194 may design context-efficiency helpers using Pi commands, hooks, UI, context injection, module visibility, CARL, and helper agents, but must cite artifacts and preserve PLAN/APPLY/UNIFY, module evidence, GitHub Flow, and parent-owned APPLY boundaries. |
| Pi-native context assistance must remain derived, bounded, disposable, and source-cited. | Phase 194 Plan 194-01 | Phase 195 spikes may reduce context cost through artifact slices, workflow/resource capsules, runtime lenses, guided UI, and helper reports, but `.paul/*`, installed resources, git/PR evidence, and validation output stay authoritative. |
| Artifact-slice context loading is the recommended first Phase 195 spike. | Phase 194 Plan 194-01 | Start with a read-only prototype that proves citation, freshness, bounded output, and fallback-to-full-read behavior before broader workflow capsules or UI changes. |
| Validation should separate Pi-supported runtime checks, shared invariants, and frozen legacy parity. | Phase 194 Plan 194-01 | Future validation redesign can preserve safety while preventing unsupported Claude Code / Agent SDK parity from silently blocking Pi-native architecture decisions. |
| Artifact-slice context loading is a validated Pi-native context-efficiency candidate. | Phase 195 Plan 195-01 | Phase 196 should decide whether to promote activation-gated, bounded, source-cited, freshness-marked, read-only slices into the final architecture proposal. |
| Promote activation-gated artifact-slice loading as the first Pi-native context-efficiency implementation pattern. | Phase 196 Plan 196-01 | Next implementation milestone should harden the source-cited/freshness-marked/full-read-fallback slice contract before workflow capsules, guided UI hardening, helper-agent packet compression, validation classification, or legacy cleanup. |
| Classify validation as Pi-supported runtime, shared invariant, or frozen legacy parity before weakening checks. | Phase 196 Plan 196-01 | Future validation redesign can optimize for Pi without accidentally deleting shared invariant protection. |

| Complete v2.45 findings triage before workstream design. | Phase 197 Plan 197-01 | Phase 198-201 planning should use `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` as the classified source input while preserving planning-only boundaries until sequencing and validation strategy are complete. |
| Treat artifact-slice contract hardening as the most implementation-ready candidate while leaving final sequencing to Phase 199. | Phase 198 Plan 198-01 | Phase 199 should test whether artifact slices go first and whether the workstream should split; Phase 198 does not finalize build order. |
| Classify validation before legacy cleanup. | Phase 198 Plan 198-01 | Legacy retention/install-surface cleanup remains deferred until shared-invariant vs frozen-parity validation checks are classified and protected. |
| Use artifact-slice contract hardening → guided workflow evidence → workflow/resource capsules → delegated APPLY packet/report compression → Pi-native validation classification → legacy cleanup as the default sequencing hypothesis. | Phase 199 Plan 199-01 | Phase 200 should pressure-test validation/evidence needs, and Phase 201 should decide final executable build milestones without treating Phase 199 as implementation authorization. |
| Command output remains validation truth, and future Pi-native implementation plans must classify checks before weakening them. | Phase 200 Plan 200-01 | Phase 201 must carry validation classes, command-output evidence, durable artifact evidence, and readiness gates into executable build milestone proposals. |
| Recommend Artifact-Slice Contract Hardening as the next Pi-native build milestone. | Phase 201 Plan 201-01 | The next milestone should harden activation-gated, bounded, source-cited, freshness-aware artifact slices and full-read fallback before broader capsules, helper compression, validation classification, or legacy cleanup. |
| Create v2.47 Artifact-Slice Contract Hardening as the first Pi-native build milestone. | v2.47 milestone creation | Phase 202 starts with slice inventory, schema, freshness/bounds/fallback rules, protected files, validation classes, and non-goals before runtime hardening. |
| Define artifact-slice contract baseline before runtime hardening. | Phase 202 Plan 202-01 | Phase 203 must cite `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md`, implement only approved slice-hardening surfaces, and preserve source citations, freshness, bounds, fallback, read-only behavior, and non-authority language. |
| Harden runtime artifact slices before broader surfacing work. | Phase 203 Plan 203-01 | The Pi extension now emits named, contract-shaped slices for `current-lifecycle-state`, `active-roadmap-phase`, and `approved-plan-task-packet`; Phase 204 can document/surface this behavior without reopening broader capsules, helper compression, validation classification, or legacy cleanup. |
| Surface artifact slices as orientation aids without weakening full-read fallback or command-output truth. | Phase 204 Plan 204-01 | User-facing docs now make `current-lifecycle-state`, `active-roadmap-phase`, and `approved-plan-task-packet` discoverable while preserving `.paul/*`, workflow artifacts, GitHub Flow evidence, module reports, and validation command output as authority. |
| Close v2.47 with validation/evidence reconciliation only. | Phase 205 Plan 205-01 | Artifact-slice contract hardening is complete; broader guided workflow evidence, capsules, helper compression, validation classification, and legacy cleanup remain separate future milestones. |
| Create v2.48 Guided Workflow Evidence Hardening as the second Pi-native build milestone. | Phase 206 Plan 206-01 creation | Phase 206 starts with a docs-only contract baseline for guided moments, canonical replies, transcript evidence, validation classes, and no-auto/no-UI-only boundaries before runtime guided reply hardening. |
| Define the guided workflow evidence contract baseline before runtime hardening. | Phase 206 Plan 206-01 UNIFY | Phase 207 should harden `drivers/pi/extensions/pals-hooks.ts` against `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`, preserving transcript-visible canonical replies and no-auto/no-UI-only boundaries. |
| Close v2.48 with evidence reconciliation only. | Phase 209 Plan 209-01 | Workflow/Resource Capsule Contract is the next recommended Pi-native build milestone; do not reopen guided workflow runtime hardening, helper compression, broad validation classification, legacy cleanup, or lifecycle authority without a new approved plan. |
| Define workflow/resource capsule contract before runtime loading. | Phase 210 Plan 210-01 | Phase 211 must harden runtime capsule loading against `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md`, preserving installed-resource citations, schema markers, full-read fallback, blocking-semantics exclusions, command-output truth, and derived-only non-authority boundaries. |
Detailed historical decisions are archived in [.paul/archive/project/PROJECT-HISTORY.md](archive/project/PROJECT-HISTORY.md).

## Success Criteria

- Single `git clone` + install path gets PALS working on the supported Pi runtime.
- Full PLAN/APPLY/UNIFY loop works on real projects with module dispatch evidence.
- Context optimization materially reduces hot-path read cost while preserving history and lifecycle authority.
- PALS remains the user-friendly end-to-end agentic coding framework for Pi-first development while preserving historical artifact-first constraints.

## Specialized Flows

See: `.paul/SPECIAL-FLOWS.md`

Quick Reference:

- `/paul` → Project planning & lifecycle management
- `/carl` → Session boundary manager — autonomous session transitions
- TODD → Test-driven development enforcement
- WALT → Quality gating & validation

## Archive

- Project history: [.paul/archive/project/PROJECT-HISTORY.md](archive/project/PROJECT-HISTORY.md)
- Milestone index: [.paul/MILESTONES.md](MILESTONES.md)
- Active roadmap: [.paul/ROADMAP.md](ROADMAP.md)
- Current state: [.paul/STATE.md](STATE.md)
- Archive catalog: [.paul/archive/INDEX.md](archive/INDEX.md)

---

*Created: 2026-03-11*
*Last updated: 2026-04-28 after Phase 213 / v2.49 merge-gate completion.*