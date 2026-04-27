# Project: pals

## Description

PALS - Project Automation & Lifecycle System. Based on PAUL and CARL along with their pals TODD and WALT. They team up to give users an agentic coding framework that makes development friendly while keeping lifecycle truth in portable markdown artifacts.

## Core Value

The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

## Current focus

v2.44 PALS Context Optimization — Process & Artifacts is complete.

v2.44 completed context optimization across PALS process and artifacts: Phase 188 slimmed workflow prompt/skill wrappers; Phase 189 measured remaining hot-path reads and ranked reductions; Phase 190 simplified active artifact structure by archiving completed ROADMAP history, centralizing GitHub Flow stanzas, hoisting module-dispatch taxonomy, and making APPLY optional refs conditional; Phase 191 refreshed anti-regrowth validation to lock the new budgets across Pi, Claude Code, and repo-source surfaces.

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

## Current milestone posture

| Milestone | Status | Purpose |
|-----------|--------|---------|
| v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation | Complete | Natural quark observations showed qualitative value but measurement gaps. |
| v2.42 CODI v0.1 — Post-Unify Instrumentation Fix | Complete | Shipped bounded parser/hook instrumentation repair and accepted CODI v0.1 as good enough. |
| v2.43 PALS Context Diet — Archive, Compact, Compress | Complete | Moved cold history into indexed archives, compacted hot/warm artifacts, compressed workflow prose, and added anti-regrowth validation guardrails. |
| v2.44 PALS Context Optimization — Process & Artifacts | Complete | Reduced recurring context cost across workflows and lifecycle artifacts while preserving artifact-first truth, module evidence, and GitHub Flow safety; Phase 191 validation now protects the gains. |

See `.paul/MILESTONES.md` for the compact milestone index, `.paul/ROADMAP.md` for active routing, and `.paul/archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md` for v2.44 phase detail.

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

Detailed historical decisions are archived in [.paul/archive/project/PROJECT-HISTORY.md](archive/project/PROJECT-HISTORY.md).

## Success Criteria

- Single `git clone` + install path gets PALS working across supported harnesses.
- Full PLAN/APPLY/UNIFY loop works on real projects with module dispatch evidence.
- Context optimization materially reduces hot-path read cost while preserving history and lifecycle authority.
- PALS remains the user-friendly end-to-end agentic coding framework for Claude Code, Pi, and future harnesses.

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
*Last updated: 2026-04-27 after v2.44 milestone completion.*