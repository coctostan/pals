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

## Promoted Patterns

### Promote: Activation-Gated Artifact-Slice Loading

Artifact-slice loading should become the first implementation-grade Pi-native context-efficiency pattern. The promoted contract is:

- Trigger only after explicit PALS activation such as `/paul-*` or `/skill:paul-*`.
- Read repo-local authoritative artifacts only.
- Keep output bounded and intentionally shallow.
- Include `Source:` path citations and freshness markers.
- Include fallback language requiring full authoritative reads for edits, lifecycle decisions, stale or contested facts, and GitHub Flow gates.
- Avoid `.paul/*` writes, hidden persistence, telemetry, caches that act as truth, and lifecycle ledgers.

This pattern should be generalized cautiously from current state/roadmap/plan slices into named lifecycle slices only after each slice has a citation schema, a size bound, a freshness rule, and a validation check.

### Promote Later: Workflow/Resource Capsules

Workflow/resource capsules are valuable but riskier than artifact slices because they summarize authoritative process prose. They should follow artifact slices and must cite installed workflow/reference paths. Capsules are appropriate for stable orientation content such as task anatomy, checkpoint prompt shape, module-dispatch evidence conventions, and GitHub Flow preflight/postflight reminders.

Capsules must not replace full reads of workflow sections that include blocking behavior, override paths, STOP/DO NOT SKIP semantics, checkpoint handling, lifecycle writes, or merge gates.

### Promote Later: Guided Workflow Evidence Hardening

Pi guided UI should continue to reduce prompt friction only when it sends explicit canonical user replies into the transcript. Future work should strengthen auditability for plan review, APPLY approval, checkpoint decisions, continue-to-UNIFY prompts, and merge-gate routing.

### Promote Later: Helper-Agent Packet and Report Compression

`pals-implementer` can reduce parent context burden for bounded repo-local tasks, but only with parent-owned task packets and structured result reports. Future work should formalize packet fields, required report schema, allowed-file checks, fallback triggers, and parent verification obligations.

## Deferred or Rejected Options

| Option | Decision | Reason |
|---|---|---|
| Hidden Pi lifecycle state | Reject | Breaks portable markdown truth and makes future sessions unauditable. |
| Telemetry-owned context engine | Reject | Creates opaque runtime authority and privacy/scope risk. |
| Auto-approval or auto-continue | Reject | Violates explicit approval and checkpoint invariants. |
| Merge-gate bypass from Pi status/widget | Reject | Risks merging behind-base or failing-CI work. |
| Helper-agent-owned APPLY | Reject | Undermines parent verification, fallback, module gates, checkpoints, and `.paul/*` writes. |
| Broad replacement of workflow reads with summaries | Reject | Summaries can omit blocking semantics; use capsules for orientation only. |
| Active Claude Code / Agent SDK parity as a constraint | Reject for current work | Conflicts with Phase 192 support-tier reset; preserve historical references and shared invariants instead. |
| Validation-script rewrite during architecture closure | Defer | The final proposal may route validation redesign, but implementation belongs in a later bounded milestone. |

## Migration Roadmap

1. **Stabilize artifact-slice contracts.** Define the stable output schema for source path, slice label, freshness, size bounds, and fallback instructions. Keep slices read-only and activation-gated.
2. **Expand named artifact slices gradually.** Add only high-value slices for current lifecycle state, active roadmap phase, current PLAN task packet, recent SUMMARY decisions, and module evidence. Each new slice needs validation and source citations.
3. **Add workflow/resource capsules.** Introduce installed-resource capsules for stable orientation content after artifact-slice citation and fallback behavior is proven.
4. **Harden guided workflow replies.** Make Pi confirm/select flows visibly canonical in transcripts and impossible to confuse with auto-approval or UI-only decisions.
5. **Formalize helper-agent packet/report compression.** Improve delegated APPLY ergonomics while keeping parent APPLY authoritative for eligibility, verification, fallback, and lifecycle writes.
6. **Reclassify validation.** Move reporting toward Pi-supported runtime checks, shared invariant checks, and frozen legacy parity checks while keeping existing validation green during transition.
7. **Decide legacy retention/removal.** Make explicit product decisions for Claude Code wrappers, Agent SDK surfaces, portability docs, and cross-harness parity checks after Pi-native implementation patterns are validated.

## Legacy Surface Guidance

| Surface | Guidance | Timing |
|---|---|---|
| Claude Code command wrappers and driver | Keep frozen as legacy/reference. Do not expand active parity. | Revisit after Pi-native context patterns and validation classification are stable. |
| Agent SDK driver | Keep as proof-of-concept/historical reference. Do not optimize new architecture around SDK limits. | Revisit in a retention/removal milestone. |
| Portability docs | Keep as historical reference, especially artifact-first and hidden-state warnings. Mark current product direction as Pi-supported. | Update only when needed for clarity, not as active parity work. |
| Cross-harness validation | Continue running while it protects shared invariants. Reclassify parity-only checks before deletion or weakening. | Validation classification milestone. |
| Pi validation | Treat as primary local validation for supported runtime behavior. Expand for artifact slices, capsules, guided UI safety, helper-agent reports, and GitHub Flow surfacing. | Ongoing Pi-native implementation milestones. |

## Implementation Roadmap

### Recommended Follow-On Milestone A — Artifact Slice Contract Hardening

Goal: turn the Phase 195 spike into a stable Pi-native context-slice contract. Candidate work includes schema documentation, additional slice names, source/freshness formatting, validation coverage, and fallback marker checks.

### Recommended Follow-On Milestone B — Workflow Capsules and Guided UI Evidence

Goal: reduce recurring workflow prompt cost without weakening lifecycle semantics. Candidate work includes installed workflow/resource capsules, explicit path citations, plan-review/apply/checkpoint UI auditability, and tests that prove no auto-continue path exists.

### Recommended Follow-On Milestone C — Delegated APPLY Packet Compression

Goal: make `pals-implementer` delegation cheaper to inspect while preserving parent authority. Candidate work includes task-packet templates, required structured reports, allowed-file diff checks, stop/fallback triggers, and parent-owned verification evidence.

### Recommended Follow-On Milestone D — Pi-Native Validation Classification

Goal: classify validation as Pi-supported runtime, shared invariant, or frozen legacy parity. Candidate work includes clearer validation reports, guardrails for newly implemented Pi runtime lenses, and non-destructive migration of parity-only assertions.

### Recommended Follow-On Milestone E — Legacy Retention and Install Surface Cleanup

Goal: decide what frozen legacy surfaces stay installed, move to archives, or remain source-only references. This milestone should happen after validation classification so shared invariants are not accidentally removed.

## Non-Goals

- Do not move lifecycle truth out of `.paul/*` artifacts.
- Do not create hidden Pi memory, telemetry-owned context, persistent caches that act as truth, or a new lifecycle ledger.
- Do not allow Pi UI to auto-approve, auto-continue, skip checkpoints, or merge work.
- Do not let helper agents own APPLY, checkpoints, official verification, module gates, fallback, or `.paul/*` writes.
- Do not bypass GitHub Flow branch, PR, CI, review, merge, base-sync, or cleanup gates.
- Do not delete or archive Claude Code, Agent SDK, portability, or cross-harness validation surfaces as part of this proposal.
- Do not rewrite validation scripts, workflows, drivers, module manifests, installers, or dependency manifests as part of this proposal.
- Do not treat runtime slices or workflow capsules as substitutes for full authoritative reads when facts are stale, ambiguous, contested, or lifecycle-changing.