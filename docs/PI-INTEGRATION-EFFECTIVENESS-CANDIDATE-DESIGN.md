# Pi Integration Effectiveness Candidate Design

## Status

| Field | Value |
|---|---|
| Milestone | v2.53 Pi Integration Efficiency & Effectiveness Exploration |
| Phase | 227 — Effectiveness Improvement Candidate Design |
| Plan | 227-01 |
| Artifact status | Phase 228 design handoff |
| Implementation status | Design documentation only; this artifact authorizes no runtime behavior change, no validation-script change, no dependency/CI change, no GitHub Flow automation change, no helper-delegation semantic change, no install-surface change, no lifecycle-authority change, and no `.paul/*` authority change. |

## Source Inputs

| Source | Design evidence used |
|---|---|
| `docs/PI-INTEGRATION-EFFICIENCY-EFFECTIVENESS-DISCOVERY.md` | Ranked artifact-slice targeting and deduplication first for efficiency gain, reliability gain, evidence readiness, and Phase 228 spike fit; defined authority boundaries, shortlist, pairing cautions, evidence requirements, and Phase 227 handoff questions. |
| `.paul/phases/226-pi-integration-efficiency-discovery/226-01-SUMMARY.md` | Reconciled Phase 226 as docs-only discovery, recorded stable validation baseline Pi 205/205 and cross-harness 121/121, and selected artifact-slice targeting/deduplication as the leading Phase 227 candidate unless guided workflow evidence proved stronger. |
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Defines artifact cost as a hot context surface, requires activation-gated/bounded/deduplicated/source-cited context injection, and names artifact-slice context loading as the first recommended safe reduction path. |
| `drivers/pi/extensions/README.md` | Documents the current artifact-slice inventory, schema markers (`Slice:`, `Source:`, `Freshness:`, `Bounds:`, `Content:`, `Fallback:`, `Authority:`), explicit activation gating, full-read fallback, and non-authority boundaries. |
| `drivers/pi/skill-map.md` | Confirms artifact-slice loading is adapter-side context aid only, not a workflow/skill authority, and that current slices are `current-lifecycle-state`, `active-roadmap-phase`, and `approved-plan-task-packet`. |
| `drivers/pi/extensions/pals-hooks.ts` | Read-only selector evidence: `getArtifactSliceSpecs` defines the current slice set and pattern selectors; `buildArtifactSlice` attaches freshness, bounds, fallback, and authority; `renderArtifactSlices` renders schema markers and truncates over budget; `buildPalsContextPayload` injects artifact slices before workflow/resource capsules after explicit activation. |

## Selected Candidate

**Artifact-slice targeting and deduplication** is the selected Phase 228 candidate.

### Artifact-slice targeting and deduplication rationale

The candidate should improve the existing artifact-slice context layer, not create a new authority surface. Phase 226 ranked this hotspot first because repeated STATE/ROADMAP/PLAN orientation still consumes fresh-session and lifecycle-prompt context even though slices already exist. It has the strongest combined profile:

- **Efficiency:** it directly targets repeated hot reads for lifecycle state, active roadmap routing, and approved PLAN task orientation.
- **Effectiveness:** better source-cited orientation reduces stale resume/APPLY setup mistakes while preserving full authoritative reads before consequential action.
- **Evidence readiness:** current docs, skill map, and `pals-hooks.ts` already expose the slice inventory, schema markers, bounds, freshness, fallback, and authority text.
- **Spike fit:** Phase 228 can limit itself to one runtime file plus docs/validation surfacing if approved, avoiding broad guided workflow, helper delegation, GitHub Flow, or install changes.

The selected behavior is not “summarize more.” It is **select and trim better**: choose the smallest relevant slice content for the active lifecycle moment, remove duplicate orientation that is already present elsewhere in the bounded payload, and keep freshness/fallback/authority markers visible.

## Alternates Deferred

| Alternate | Decision | Rationale |
|---|---|---|
| Guided workflow prompt/reply reliability | Deferred | It has high lifecycle-safety value, but it touches explicit user-intent routing. Pairing it with artifact-slice deduplication would mix context-payload work with confirm/select canonical reply evidence and no-auto/no-UI-only checks. |
| Module-dispatch evidence lens | Deferred | It is a strong evidence-quality candidate, but it risks drifting toward a Pi-owned module ledger unless designed separately around `[dispatch]` lines, installed `modules.yaml`, and PLAN/SUMMARY reports. |
| CARL bootstrap/resume precision | Not paired in this spike | It shares orientation concerns with artifact slices, but CARL behavior is session-boundary safety logic. Phase 228 should first prove slice targeting/deduplication before changing bootstrap/resume payloads. |
| Helper report inspection ergonomics | Deferred | Valuable for implementation-heavy phases, but Phase 228 should not reopen parent-owned APPLY/helper delegation semantics while proving runtime lens bounds. |
| GitHub Flow status lens | Deferred | Useful near PR/merge gates, but merge safety depends on fresh git/gh command evidence and workflow gates. It should remain separate from artifact payload trimming. |
| Validation/report classification surfacing | Deferred | Documentation surfacing can help, but command-output truth and validation-class posture are already protected; it is not the highest context-cost target. |

## Phase 228 Spike Contract

### Expected Future Repo Surfaces

A future Phase 228 plan may approve a tightly bounded implementation across these likely surfaces:

| Surface | Expected role | Approval requirement |
|---|---|---|
| `drivers/pi/extensions/pals-hooks.ts` | Runtime slice targeting/deduplication implementation: selector rules, duplicate trimming, output bounds, freshness/fallback marker preservation. | Must be explicitly listed in Phase 228 `<files>`. |
| `drivers/pi/extensions/README.md` | User-facing Pi docs for changed slice targeting/deduplication behavior and unchanged authority boundaries. | Docs-only surfacing after runtime behavior changes. |
| `drivers/pi/skill-map.md` | Adapter surface map updates if slice inventory, behavior, or validation classes change. | Only if Phase 228 changes externally visible slice behavior. |
| `tests/pi-end-to-end-validation.sh` | Pi-supported runtime and runtime-lens marker checks for new behavior. | Only if Phase 228 approves validation-script edits and reconciles count changes. |
| `tests/cross-harness-validation.sh` | Shared invariant checks only if behavior affects shared guarantees. | Avoid unless Phase 228 identifies a shared invariant gap. |

Phase 228 should not edit dependency manifests, CI configuration, install/uninstall scripts, GitHub Flow automation, helper-agent contracts, or `.paul/*` authority semantics for this candidate.

### Target Behavior

The smallest useful spike should prove these behaviors:

1. **Smarter artifact-slice selection** — current lifecycle state, active roadmap phase, and approved plan task packet should include only lines relevant to the active PALS moment.
2. **Duplicate trimming** — the bounded PALS payload should avoid repeating the same phase/plan/next-action facts across state, roadmap, and plan slices when one cited source is enough for orientation.
3. **Freshness and fallback clarity** — each emitted slice must keep `Source:`, `Freshness:`, `Bounds:`, `Fallback:`, and `Authority:` visible even after trimming.
4. **Full-read fallback preservation** — output must continue to state that full authoritative reads are required before edits, approved PLAN execution, lifecycle writes, GitHub Flow decisions, validation pass/fail, module completion, APPLY completion, or UNIFY completion.
5. **No hidden persistence** — deduplication must be computed from current artifact reads and runtime payload assembly only; no telemetry, cache, hidden Pi memory, or Pi-owned lifecycle/module/validation ledger.

### Output Bounds

| Slice | Proposed Phase 228 bound | Notes |
|---|---|---|
| `current-lifecycle-state` | Prefer 6-10 high-signal lifecycle lines; preserve source/freshness/fallback/authority markers. | Should include current milestone/phase/plan/loop/next-action where available. |
| `active-roadmap-phase` | Prefer only active milestone/phase routing lines and immediate Phase 228 handoff lines. | Must not expand completed-history archives. |
| `approved-plan-task-packet` | Prefer task names, files, verify commands, boundaries, and acceptance target summaries; trim duplicate objective prose already present in state/roadmap slices. | PLAN remains the executable authority; this is orientation only. |
| Whole artifact-slice block | Preserve the existing max-character truncation guard or replace it only with an equal-or-stricter documented budget. | Truncation must still end with full authoritative read fallback language. |

### Freshness, Citation, and Fallback Rules

- Every artifact-derived claim must cite the repo-relative `Source:` path for the slice.
- Every source that can change during the session must expose `Freshness:`.
- Bounds must describe both the source range/selector and maximum payload budget.
- If a source is missing or selector output is empty, the slice should degrade to an unavailable-source note plus full-read fallback, not silently disappear.
- If a slice conflicts with a full read or command output, the full read or command output wins.

### Validation Classes

Expected Phase 228 validation classification:

| Class | Expected use |
|---|---|
| Runtime Lens | Protect slice targeting, duplicate trimming, budget markers, freshness markers, and fallback text. |
| Pi-Supported Runtime | Protect Pi extension behavior and Pi docs for the supported runtime. |
| Shared Invariant | Protect `.paul/*` authority, PLAN/APPLY/UNIFY authority, parent-owned APPLY, module evidence, GitHub Flow safety, command-output truth, and full-read fallback. |
| Artifact / Process | Protect durable evidence requirements, changed-file scope, and validation count reconciliation if test scripts change. |
| Guided UI Safety | Not expected unless Phase 228 explicitly touches guided prompt/reply behavior; otherwise should remain out of scope. |

### Non-Goals

- Do not add new lifecycle authority to Pi runtime context.
- Do not create hidden state, telemetry, cache, or a Pi-owned module/validation ledger.
- Do not change guided workflow confirm/select behavior, checkpoint behavior, or canonical reply routing.
- Do not change helper delegation semantics or parent-owned APPLY boundaries.
- Do not change GitHub Flow automation, merge gates, CI routing, or PR behavior.
- Do not change install/uninstall posture or dependency manifests.
- Do not refactor validation-script size debt as part of this spike.

### Stop/Defer Conditions

Stop Phase 228 and return to PLAN if implementation would require any of these:

- changing more than one runtime behavior family beyond artifact-slice targeting/deduplication;
- altering guided UI, helper delegation, GitHub Flow, install, dependency, or CI behavior;
- treating slice output as sufficient for edits, APPLY completion, UNIFY completion, validation pass/fail, module completion, or lifecycle writes;
- weakening existing validation markers without replacement;
- increasing validation counts without explicit reconciliation;
- exceeding the approved changed-file budget or Workguard scope.

## Phase 228 Handoff

### Acceptance Targets

Phase 228 should be considered successful only if fresh command output and artifact evidence show:

1. Artifact-slice payloads remain activation-gated, source-cited, freshness-marked, bounded, read-only, disposable, and labeled `Derived aid only`.
2. Duplicate lifecycle/roadmap/plan orientation is measurably trimmed or explicitly bounded with before/after output evidence.
3. Full-read fallback and command-output truth remain visible.
4. No `.paul/*` authority, PLAN/APPLY/UNIFY authority, module evidence, parent-owned APPLY, GitHub Flow gate, explicit approval/checkpoint, helper delegation, install-surface, dependency, or CI semantics change.
5. Validation count changes, if any, are explained as localized guardrails for the approved runtime-lens behavior.

### Marker Checks

A Phase 228 plan should include focused checks for markers like:

```text
Artifact slices
Source:
Freshness:
Bounds:
Fallback:
Authority:
Derived aid only
full authoritative read
activation-gated
no hidden Pi state
command-output truth
```

It should also check any new deduplication markers or before/after budget labels added by the implementation.

### Command-Output Verification Requirements

Recommended Phase 228 verification sequence:

1. Focused marker greps for slice schema, deduplication/budget text, fallback, and non-authority boundaries.
2. `PALS_ROOT="$PWD" bash drivers/pi/install.sh` if the Pi extension or installed docs are changed.
3. `bash tests/pi-end-to-end-validation.sh` for Pi-supported runtime proof.
4. `bash tests/cross-harness-validation.sh` when shared invariant markers or cross-harness validation are touched.
5. `git diff --name-only` to prove changed-file scope.

Fresh command output remains the validation authority; docs and copied counts are explanatory only.

### Changed-File Budget

Recommended maximum changed-file budget for Phase 228:

- Preferred: 3 files — `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/extensions/README.md`, and `tests/pi-end-to-end-validation.sh`.
- Allowed only with explicit justification: `drivers/pi/skill-map.md` and `tests/cross-harness-validation.sh`.
- Out of scope by default: dependency manifests, CI, install/uninstall scripts, helper-agent contracts, GitHub Flow automation, shared workflows, and unrelated docs.

### Workguard

Recommended Phase 228 Workguard scope:

```text
allowed:
  - drivers/pi/extensions/pals-hooks.ts
  - drivers/pi/extensions/README.md
  - drivers/pi/skill-map.md
  - tests/pi-end-to-end-validation.sh
  - tests/cross-harness-validation.sh
  - .paul/**
maxChangedFiles: 8
```

Use a narrower scope if the approved Phase 228 plan touches fewer files.

### Fallback/Defer Conditions

If artifact-slice targeting cannot show clear output-size or duplication improvement without weakening source citations, fallback markers, or full-read requirements, Phase 228 should defer implementation and return to design. If reliability evidence for guided workflow prompt/reply behavior becomes stronger than context-cost evidence, create a separate guided workflow reliability plan rather than expanding the artifact-slice spike.

## Scope Safety Proof

Phase 227 authorizes **design documentation only**.

This artifact preserves these boundaries:

- no runtime behavior change;
- no validation-script change;
- no dependency/CI change;
- no GitHub Flow automation change;
- no helper-delegation semantic change;
- no install-surface change;
- no lifecycle-authority change;
- no `.paul/*` authority change.

The only approved non-lifecycle output for Phase 227 is `docs/PI-INTEGRATION-EFFECTIVENESS-CANDIDATE-DESIGN.md`. Future implementation requires a new approved Phase 228 plan.
