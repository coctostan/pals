# Project: pals

## Description

PALS - Project Automation & Lifecycle System. Based on PAUL and CARL along with their pals TODD and WALT. They team up to give users an agentic coding framework that makes development friendly while keeping lifecycle truth in portable markdown artifacts.

## Core Value

The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

## Current focus

v2.43 PALS Context Diet — Archive, Compact, Compress.

Current work is reducing hot-path context cost without weakening PLAN/APPLY/UNIFY, module dispatch, GitHub Flow, or `.paul/*` artifact authority. Phase 185 is proving an archive-link convention on lower-risk artifacts before compacting the sensitive hot artifacts (`STATE.md`) and warm-path roadmap artifacts (`ROADMAP.md`).

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
- v2.43 reduction work must preserve archive links and historical authority while making hot artifacts materially smaller.

## Current milestone posture

| Milestone | Status | Purpose |
|-----------|--------|---------|
| v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation | Complete | Natural quark observations showed qualitative value but measurement gaps. |
| v2.42 CODI v0.1 — Post-Unify Instrumentation Fix | Complete | Shipped bounded parser/hook instrumentation repair and accepted CODI v0.1 as good enough. |
| v2.43 PALS Context Diet — Archive, Compact, Compress | Active | Move cold history into indexed archives, compact hot/warm artifacts, then compress workflow prose. |

See `.paul/MILESTONES.md` for the compact milestone index and `.paul/ROADMAP.md` for phase sequencing.

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

Detailed historical decisions are archived in [.paul/archive/project/PROJECT-HISTORY.md](archive/project/PROJECT-HISTORY.md).

## Success Criteria

- Single `git clone` + install path gets PALS working across supported harnesses.
- Full PLAN/APPLY/UNIFY loop works on real projects with module dispatch evidence.
- Context diet work materially reduces hot-path read cost while preserving history and lifecycle authority.
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
*Compacted: 2026-04-26 during Phase 185 archive-link rollout.*