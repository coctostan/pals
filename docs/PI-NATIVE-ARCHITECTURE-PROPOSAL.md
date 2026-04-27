# Pi-Native PALS Architecture Proposal

## Status

| Field | Value |
|---|---|
| Milestone | v2.45 Pi-Native PALS Architecture |
| Phase | 196 — Final Pi-Native Architecture Proposal |
| Proposal status | Final architecture proposal for implementation planning |
| Supported runtime direction | Pi is the active supported runtime |
| Authority model | `.paul/*` artifacts, shared workflows, installed module registry evidence, git/PR evidence, and validation output remain authoritative |

## Source Inputs

| Source | Phase | Evidence used |
|---|---:|---|
| `docs/PI-NATIVE-SUPPORT-INVENTORY.md` | 192 | Pi is the supported runtime; Claude Code and Agent SDK are frozen legacy / historical reference surfaces; `.paul/*` authority remains intact. |
| `docs/PI-RUNTIME-CAPABILITY-MAP.md` | 193 | Pi already provides command routing, installed resource resolution, lifecycle UI, bounded context injection, module visibility, guided workflow UX, CARL session boundaries, and helper-agent delegation surfaces. |
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | 194 | Runtime assistance must be derived, bounded, cited, freshness-aware, disposable, and backed by full authoritative reads for decisions. |
| `.paul/phases/195-exploratory-pi-native-spikes/195-01-SUMMARY.md` | 195 | Activation-gated artifact-slice loading was implemented and validated as a safe candidate Pi-native context-reduction pattern. |
| `.paul/PROJECT.md`, `.paul/STATE.md`, `.paul/ROADMAP.md` | current | The active product posture remains minimal kernel, modular pals, universal drivers, with PLAN/APPLY/UNIFY as the lifecycle loop. |

## Executive Decision Summary

PALS should move forward as a Pi-native lifecycle system while preserving its portable markdown authority model. Pi is the supported runtime for new user experience, context-efficiency, guided workflow, and helper-agent work. Claude Code and Agent SDK surfaces should remain frozen legacy or historical reference unless a later product decision explicitly revives them.

The final architecture is not a Pi-owned control plane. Pi should improve command discovery, context loading, lifecycle visibility, guided user interactions, session continuity, and bounded delegation by deriving compact assistance from authoritative artifacts and command evidence. The model remains artifact-first: PLAN/APPLY/UNIFY defines work, `.paul/*` records lifecycle truth, installed `modules.yaml` and `[dispatch]` output provide module evidence, GitHub Flow evidence gates merges, and validation commands prove readiness.

The Phase 195 artifact-slice spike should be promoted as the first implementation pattern because it demonstrated a useful reduction in repeated read burden without creating hidden state, telemetry, lifecycle writes, or a second source of truth.

## Target Architecture

The target architecture keeps PALS' core value intact: **the Linux of Harness Engineering — minimal kernel, modular pals, universal drivers**. Pi becomes the primary supported driver and runtime shell, but the kernel and lifecycle artifacts remain portable and reviewable.

```text
┌──────────────────────────────────────────────────────────────┐
│ Pi presentation, routing, and context surfaces               │
│ /paul-* commands, shortcuts, status/widget, guided UI,       │
│ bounded activation-gated context payloads                    │
└───────────────────────────────▲──────────────────────────────┘
                                │ derived, cited, disposable
┌───────────────────────────────┴──────────────────────────────┐
│ Runtime assistance lenses                                     │
│ artifact slices, workflow/resource capsules, module evidence, │
│ GitHub Flow state, CARL bootstrap, helper-agent reports       │
└───────────────────────────────▲──────────────────────────────┘
                                │ reads, summarizes, verifies
┌───────────────────────────────┴──────────────────────────────┐
│ Installed resources and external evidence                    │
│ installed workflows/references/templates/rules, modules.yaml, │
│ git/gh state, validation command output                       │
└───────────────────────────────▲──────────────────────────────┘
                                │ interpreted by workflows
┌───────────────────────────────┴──────────────────────────────┐
│ Authoritative lifecycle artifacts                            │
│ .paul/STATE.md, PROJECT.md, ROADMAP.md, PLAN, SUMMARY,        │
│ handoffs, archives                                            │
└──────────────────────────────────────────────────────────────┘
```

### Authority Boundaries

- `.paul/*` artifacts remain lifecycle truth. Pi extension memory, widgets, hidden context, helper-agent transcripts, and UI selections are derived aids only.
- PLAN/APPLY/UNIFY remains the authoritative loop: PLAN defines approved work, APPLY executes and verifies under parent control, and UNIFY reconciles results into durable artifacts.
- Module evidence remains visible through installed `modules.yaml`, `[dispatch] ...` lines, and PLAN/SUMMARY/STATE reports. Pi may display this evidence, but must not keep an independent module ledger.
- GitHub Flow gates remain explicit and evidence-backed. Pi may surface branch, PR, CI, review, merge, and sync state, but must not bypass base-sync, CI, review, merge, or cleanup gates.
- Parent APPLY owns official verification, fallback judgment, checkpoints, module enforcement, task result classification, and `.paul/*` writes even when `pals-implementer` completes bounded implementation tasks.
- Full authoritative reads remain required for edits, approved PLAN execution, lifecycle writes, GitHub Flow gates, ambiguity, stale facts, or contested decisions.

## Phase Evidence Synthesis

### Phase 192 — Support-Tier Reset

Phase 192 established the product direction: Pi is the active supported runtime, while Claude Code and Agent SDK surfaces are frozen legacy or historical reference. This frees future architecture from active cross-harness parity pressure while preserving historical files as useful evidence and shared-invariant protection.

The key constraint from Phase 192 is that runtime support-tier reset does not change lifecycle authority. `.paul/*`, shared workflows, module evidence, parent-owned APPLY, and GitHub Flow remain outside Pi runtime ownership.

### Phase 193 — Pi Runtime Capability Mapping

Phase 193 showed that Pi already has enough primitives for native lifecycle assistance: command registration, canonical skill routing, installed resource resolution, lifecycle status/widget rendering, bounded context injection, guided workflow UX, module activity visibility, CARL session boundaries, helper-agent delegation, and git/status surfacing.

The important classification is that many of these primitives are guardrail or presentation surfaces, not authority surfaces. They can make lifecycle work easier and cheaper, but cannot own decisions or lifecycle state.

### Phase 194 — Context-Efficiency Architecture

Phase 194 defined the read/citation contract and context-cost model. The architecture goal is to reduce repeated orientation and routing cost by loading smaller, cited, freshness-marked slices rather than hiding or replacing authoritative artifacts.

It rejected opaque Pi memory, telemetry-owned context engines, auto-approval, hidden module ledgers, merge-gate bypasses, helper-owned APPLY, broad workflow-summary replacement, and active Claude/SDK parity as unsafe or misaligned with the support-tier decision.

### Phase 195 — Artifact-Slice Spike

Phase 195 validated the first concrete implementation pattern: activation-gated, read-only artifact slices for explicit PALS activations. The spike added bounded slices for `.paul/STATE.md`, `.paul/ROADMAP.md`, and discoverable current PLAN artifacts, with source citations, freshness markers, fallback language, and structural validation.

This pattern is safe to promote because it is derived, bounded, disposable, source-cited, freshness-marked, and explicitly backed by full authoritative reads for edits, lifecycle decisions, stale or contested facts, and GitHub Flow gates.
