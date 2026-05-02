# Pi-Native Extension Extraction Target Baseline

**Phase:** 242 Extension Extraction Target Baseline  
**Plan:** 242-01  
**Status:** Active Phase 243 handoff baseline

## Purpose

This baseline chooses and bounds the next Pi extension submodule extraction wave from `drivers/pi/extensions/pals-hooks.ts`.

Phase 239 already extracted S5 `module-activity-parsing` into `drivers/pi/extensions/module-activity-parsing.ts`. Phase 241 then generalized the Pi extension install/uninstall surface so every repo-owned sibling `*.ts` file under `drivers/pi/extensions/` is installed by basename. Phase 243 can therefore extract one or more approved submodules without reopening installer or `driver.yaml` work unless contrary packaging evidence appears.

This document is a derived aid only. It is not lifecycle truth, validation truth, module truth, or GitHub Flow truth. Shared `.paul/*` artifacts, approved PLAN/APPLY/UNIFY artifacts, module reports, GitHub Flow command evidence, and validation command output remain authoritative.

## Evidence Base

- `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` — original S1-S8 inventory, risk/readiness classification, and preservation constraints.
- `.paul/phases/241-evidence-closure-next-roadmap-decision/241-01-SUMMARY.md` — confirms the generalized extension source-set install rule and records the `driver.yaml` audit decision.
- `drivers/pi/extensions/pals-hooks.ts` — current supported Pi runtime source and remaining subsystem host.
- `drivers/pi/extensions/module-activity-parsing.ts` — S5 extraction proof and sibling-module pattern.
- `drivers/pi/extensions/README.md` — Pi extension install boundary, command model, and derived-aid authority language.

## Current Extraction State

| Candidate | Current state | Phase 243 posture |
|-----------|---------------|-------------------|
| S1 `artifact-slice-rendering` | Extracted to `drivers/pi/extensions/artifact-slice-rendering.ts` (Phase 243 / PR #158) | Shipped — sibling-module pattern repeated |
| S2 `workflow-resource-capsule-rendering` | Still inline in `pals-hooks.ts` | Approved primary candidate, pairable with S1 if bounded |
| S3 `guided-workflow-detection` | Still inline in `pals-hooks.ts` | Conditional secondary candidate only after S1/S2 bounds are stable |
| S4 `guided-workflow-canonical-reply` | Still inline in `pals-hooks.ts` | Deferred; runtime-coupled Pi message mutation |
| S5 `module-activity-parsing` | Already extracted to `module-activity-parsing.ts` | Not a Phase 243 extraction target |
| S6 `lifecycle-ui` | Still inline in `pals-hooks.ts` | Deferred; Pi UI mutation and S5/S7 coupling |
| S7 `pals-context-injection` | Still inline in `pals-hooks.ts` | Conditional later candidate; authority/activation tags make it moderate risk |
| S8 `command-routing` | Still inline in `pals-hooks.ts` | Deferred; highest user-visible command/shortcut surface |

S5 is already extracted and remains the proof that a sibling extension module can preserve behavior when marker ownership and import boundaries are explicit.

## Approved Phase 243 Extraction Wave

Phase 243 may extract **one or more approved** candidates from this wave:

1. **S1 `artifact-slice-rendering` — approved primary.**
   - Strong pure candidate: build/render helpers consume state and filesystem reads, then return derived orientation text.
   - Key call chain from CODI: `buildArtifactSlice` → `renderArtifactSlices` → `buildPalsContextPayload` → `palsHooks`.
   - Required preservation markers:
     - `ARTIFACT_SLICE_SCHEMA_MARKERS`
     - `MAX_ARTIFACT_SLICE_CHARS`
     - `MAX_ARTIFACT_SLICE_LINES`
     - `ARTIFACT_SLICE_FALLBACK`
     - `ARTIFACT_SLICE_AUTHORITY`
     - visible schema strings: `Slice:`, `Source:`, `Freshness:`, `Bounds:`, `Content:`, `Fallback: full authoritative read`, `Authority: Derived aid only`

2. **S2 `workflow-resource-capsule-rendering` — approved primary, pairable with S1.**
   - Strong pure candidate: structurally similar to S1 and already contract-protected by the workflow/resource capsule contract.
   - Key call chain from CODI: `buildWorkflowResourceCapsule` → `renderWorkflowResourceCapsules` → `buildPalsContextPayload` → `palsHooks`.
   - Required preservation markers:
     - `WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS`
     - `MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS`
     - `MAX_WORKFLOW_RESOURCE_CAPSULE_LINES`
     - `WORKFLOW_RESOURCE_CAPSULE_FALLBACK`
     - `WORKFLOW_RESOURCE_CAPSULE_AUTHORITY`
     - visible schema strings: `Capsule:`, `Source:`, `Source type:`, `Freshness:`, `Bounds:`, `Content:`, `Fallback: full authoritative read`, `Authority: Derived aid only`

3. **S3 `guided-workflow-detection` — conditional secondary.**
   - May be considered only if Phase 243 deliberately chooses a guided-workflow detection slice instead of, or after, the S1/S2 pure pair.
   - It must remain separate from S4 canonical-reply delivery unless a later approved plan proves that extraction preserves transcript-visible canonical replies.
   - Required preservation markers include `GUIDED_WORKFLOW_LOOKBACK`, `GUIDED_WORKFLOW_SIGNATURE_BYTES`, option parsing semantics, merge-gate routing detection, and no inferred merge intent.

S4, S6, S7, and S8 are not approved for Phase 243 extraction by default. They require a later plan or an explicit Phase 243 re-plan because they touch Pi message mutation, Pi UI mutation, authority/activation tags, or the user-facing command surface.

## Multi-Module Extraction Rule

Phase 243 may extract **one or more approved** candidates when all of the following are true:

- Each extracted module has a clear sibling file under `drivers/pi/extensions/`.
- Each module owns one coherent subsystem and preserves existing function names or call-site semantics through explicit imports.
- Exact marker strings remain single-defined or intentionally re-exported from the extracted module.
- The `pals-hooks.ts` diff is primarily imports plus calls into extracted helpers, not a behavior rewrite.
- The combined diff remains reviewable in one APPLY plan and can be verified with focused grep/marker checks plus full validation.
- The generalized install surface from Phase 241 covers the new sibling `*.ts` files without extra installer edits.

If S1 and S2 are extracted together, keep them either as two sibling modules (`artifact-slice-rendering.ts` and `workflow-resource-capsule-rendering.ts`) or as a clearly justified shared orientation-rendering boundary. Prefer two sibling modules unless shared helper extraction is necessary to avoid duplicated marker/fallback logic.

## Phase 243 Handoff

Recommended default Phase 243 scope:

- Extract S1 `artifact-slice-rendering` first.
- Extract S2 `workflow-resource-capsule-rendering` in the same plan only if S1's import/type boundary is straightforward and no extra installer, manifest, dependency, CI, or lifecycle-authority work is needed.
- Preserve S3 as an optional secondary candidate only if the S1/S2 pair is deliberately deferred.

Phase 243 should target repo source files only. It must not edit installed runtime copies under `~/.pi/agent/extensions/`. If APPLY needs runtime verification, it should run the repo installer after source changes rather than editing installed files directly.

Because Phase 241 generalized the install surface, Phase 243 does **not** need installer or `driver.yaml` edits solely because it adds a new sibling `*.ts` extension module under `drivers/pi/extensions/`. Reopen installer or manifest work only if fresh command-output or packaging evidence contradicts the Phase 241 audit decision.

## Preservation Boundaries

Any Phase 243 extraction must preserve:

- `.paul/*` artifact authority and full authoritative read fallback.
- PLAN/APPLY/UNIFY lifecycle ownership.
- Parent-owned APPLY verification, module gates, fallback judgment, checkpoints, GitHub Flow gates, and lifecycle writes.
- Module evidence and validation command-output truth.
- No hidden state, telemetry, generated lifecycle ledger, Pi-owned validation ledger, or cache-as-truth.
- No auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent.
- `Authority: Derived aid only` language on derived runtime orientation surfaces.
- Existing command names, shortcuts, canonical replies, and activation behavior unless a future approved plan explicitly targets those surfaces.

## Phase 243 Outcome

Phase 243 Plan 01 executed the approved primary candidate and closed the wave's first extraction:

- **S1 `artifact-slice-rendering` extracted** to `drivers/pi/extensions/artifact-slice-rendering.ts` per the Phase 239 S5 sibling-module precedent. Markers (`ARTIFACT_SLICE_SCHEMA_MARKERS`, `MAX_ARTIFACT_SLICE_CHARS=3000`, `MAX_ARTIFACT_SLICE_LINES=8`, the slice banner, the `Fallback: full authoritative read…` line, and the `Authority: Derived aid only…` line) are preserved single-defined in the new sibling.
- **S2 `workflow-resource-capsule-rendering` reserved** for a future approved plan (e.g., Plan 243-02 if scheduled); it remains inline in `pals-hooks.ts` and is not extracted by Phase 243.
- **Helpers exported from `drivers/pi/extensions/pals-hooks.ts`:** `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, and the type `PalsStateSnapshot`. Future S2-S8 sibling extractions import these helpers from `./pals-hooks` rather than duplicating them.
- **Canonical `default-arg cycle-avoidance` pattern:** any shared cap (e.g., `selectBoundedLines`'s `maxLines`) moves from a default-arg referencing a sibling-owned constant to a required parameter at the helper signature, with each call site passing its local cap explicitly. This eliminates the latent circular-import risk between `pals-hooks.ts` and any sibling module that owns the cap constant.
- **Install / validation evidence:** `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports `[ok] Pi extensions installed: 3 files`. Pi e2e: `1..214 / # Failed: 0`. Cross-harness: `1..127 / # Failed: 0`. `bash tests/helpers/artifact_consistency.sh` PASS. `git diff --check` clean. PR #158 merged 2026-05-02 (squash + delete-branch).

The approved-wave selection prose, preservation constraints, forbidden-scope rules, and validation expectations above remain in force verbatim — this section surfaces outcome only and does not re-litigate selection.

## Forbidden Scope for Phase 243 by Default

- S4 canonical reply delivery, unless a new approved plan specifically covers Pi message mutation.
- S6 lifecycle UI extraction, unless S1/S2/S5 boundaries prove the supporting parse/render dependencies first.
- S7 context-injection extraction, unless the plan protects `STATE_AUTHORITY_TAG`, `ACTIVATION_SIGNAL_TAG`, `LEGACY_PALS_CONTEXT_HEADER`, and `PALS_CONTEXT_CUSTOM_TYPE` exactly.
- S8 command routing extraction, unless a later plan focuses on command/shortcut compatibility.
- Installer, uninstall, or `driver.yaml` edits solely for new extension siblings.
- Dependency, CI, kernel, module registry, Claude Code driver, Agent SDK driver, or lifecycle artifact authority changes.

## Validation Expectations

A Phase 243 APPLY plan should include focused source checks and full validation:

- Grep/read checks that exact S1/S2 markers remain present in the expected source files.
- Checks that `drivers/pi/extensions/pals-hooks.ts` imports the extracted module(s) from repo sibling paths.
- Checks that new sibling `*.ts` modules are covered by the generalized install source set.
- `bash tests/pi-end-to-end-validation.sh`
- `bash tests/cross-harness-validation.sh`
- `bash tests/helpers/artifact_consistency.sh`
- `git diff --check`

If a future plan changes validation counts, it must reconcile the count change in its SUMMARY using command-output evidence.

## Deferred Candidates

- S3 is conditional because guided workflow detection is larger and contract-sensitive.
- S4 is deferred because it sends canonical replies through Pi message flow.
- S6 is deferred because it mutates Pi UI and consumes module/context outputs.
- S7 is deferred because exact authority and activation tags are lifecycle-sensitive.
- S8 is deferred because command routing is the highest user-visible compatibility surface.

## Summary Decision

Phase 243's approved extraction wave is S1 + S2, with permission to extract **one or more approved** candidates if bounded reviewability and validation are preserved. S5 is already extracted. S3 is a conditional fallback/secondary candidate. S4/S6/S7/S8 remain deferred by default.
