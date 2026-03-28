# Phase 159 Workflow Bloat Report

_Date:_ 2026-03-27  
_Phase:_ 159 — Workflow Bloat Audit

## Executive summary
Phase 159 confirms that a meaningful part of perceived Pi context bloat comes from **workflow layering around hot artifacts**, not only from the artifacts themselves.

Phase 158 showed that:
- `STATE.md` is the confirmed hot artifact
- `ROADMAP.md` is the main warm-path companion
- most other large `.paul/*` files are mainly archive/growth concerns

Phase 159 adds the workflow-side half of that picture:
- Pi runtime, Pi skill shells, and shared workflows repeatedly **restate** how those artifacts should be read
- planning/discussion/status flows repeatedly **bundle** the same hot artifacts together
- module dispatch and continuity contracts are **copied into multiple large workflows**, increasing baseline context cost before project-specific work begins

## Confirmed Findings
### Confirmed 1 — Pi skill shells are thin wrappers, but they still duplicate workflow entry contracts
Evidence:
- `paul-plan/SKILL.md`, `paul-apply/SKILL.md`, and `paul-resume/SKILL.md` each re-list artifact reads and then point to their corresponding shared workflow.
- The paired workflows (`plan-phase.md`, `apply-phase.md`, `resume-project.md`) immediately restate their own required-reading and process rules.
- Rough static route budgets are already large before reading project artifacts: `/paul:plan` ≈ **1,345 lines**, `/paul:apply` ≈ **1,091 lines** minimum, `/paul:resume` ≈ **753 lines**.

Implication:
- The wrapper layer is not the main source of truth, but it does add a recurring duplicate preamble on every major command path.

### Confirmed 2 — Planning-adjacent workflows repeatedly bundle the same hot artifacts
Evidence:
- `STATE + PROJECT` appears together in **7** workflow required-reading blocks.
- `STATE + ROADMAP` appears together in **7** workflow required-reading blocks.
- `STATE + PROJECT + ROADMAP` appears together in **5** workflow required-reading blocks.
- `plan-phase.md`, `discuss-phase.md`, `discuss-milestone.md`, and `roadmap-management.md` all reassemble overlapping live context bundles.

Implication:
- `ROADMAP.md` is workflow-amplified. Its cost is not just file size; it is how often planning/status/milestone flows ask for it.

### Confirmed 3 — The `PROJECT.md` hot-brief / `PRD.md` selective-read policy is good, but over-repeated
Evidence:
- The same rule appears in `plan-phase.md`, `discuss-phase.md`, `discuss-milestone.md`, and `phase-assumptions.md`.
- The wording is directionally consistent: use `PROJECT.md` first, consult `PRD.md` only when richer framing materially helps.

Implication:
- This is not a policy problem. It is a workflow-text duplication problem.
- The repo is paying multiple times to restate a rule it already decided correctly.

### Confirmed 4 — Module-dispatch scaffolding is a major source of workflow bulk
Evidence:
- `apply-phase.md` carries separate pre-apply, post-task, post-apply advisory, and post-apply enforcement dispatch sections.
- `unify-phase.md` carries pre-unify and post-unify dispatch sections with nearly the same registry/priority/load/report structure.
- The common steps are repeated each time: read `modules.yaml`, warn if missing, resolve hooks, sort, load refs, follow descriptions, log results.

Implication:
- A large share of APPLY/UNIFY workflow size comes from repeated dispatch contract prose rather than from unique phase logic.
- This is one of the clearest workflow-only cleanup targets because it does not require changing artifact authority.

### Confirmed 5 — Resume continuity is text-heavy before user-specific resume context even loads
Evidence:
- `context-management.md` explains light vs full continuity and handoff strategy.
- `paul-resume/SKILL.md` repeats the handoff search and archive behavior in wrapper form.
- `resume-project.md` then repeats active/archive handoff discovery and lifecycle handling in full.
- `pause-work.md` carries the other half of the same continuity model.

Implication:
- Resume is a fresh-session path, so continuity duplication is expensive exactly when context is least available.

### Confirmed 6 — Guided workflow UX deliberately duplicates canonical markers across markdown output and extension parsing
Evidence:
- Shared workflows emit canonical prompts such as `Would you like to see the plan?`, `Continue to APPLY?`, and `Continue to UNIFY?`.
- The extension README documents those same markers.
- `pals-hooks.ts` parses those same strings to drive additive Pi-native confirms/selects.

Implication:
- This duplication is partially necessary and should not be treated like accidental boilerplate.
- The optimization target is the surrounding prose and duplicated explanation, not the canonical markers themselves.

## Plausible Findings
### Plausible 1 — `ROADMAP.md` is more workflow-amplified than strictly necessary on some warm paths
Reasoning:
- It is repeatedly bundled into status, milestone, and planning/discussion flows.
- Some of those paths may only need the current milestone window or phase table, not the whole roadmap artifact.

Why still plausible, not fully confirmed:
- Phase 159 inspects declared read surfaces and wording, not runtime token traces for every path.

### Plausible 2 — Authority/additive disclaimers could be centralized further without losing safety
Reasoning:
- The same “shared `.paul/*` artifacts remain authoritative” message appears in runtime injection, extension docs, and surrounding guided-workflow explanations.

Why still plausible:
- Some duplication may be intentionally defensive for model reliability. The safe lower bound still needs design judgment.

### Plausible 3 — Module dispatch would benefit from a shared protocol abstraction or compressed reference pattern
Reasoning:
- APPLY and UNIFY reprint the same registry procedure many times.

Why still plausible:
- The repo has not yet tested whether shorter indirection preserves model compliance as well as the current explicit prose.

## Open Questions
### Open 1 — How much of the workflow-side cost is actually paid on every run versus only declared in files?
Phase 159 shows declared load surfaces and duplication, but not a full runtime token trace for every command path.

### Open 2 — How small can Pi skill shells become before command-local guidance stops being reliable?
The shells are mostly wrappers today, but some local orientation is still useful.

### Open 3 — Can module-dispatch scaffolding be compressed without reducing compliance or visibility?
This looks high-value, but it depends on how much explicit structure the model actually needs.

## Candidate Reduction Directions
These stay implementation-free. They are workflow-side candidates only.

### 1) Thin Pi skill shells to true command-local deltas
Candidate direction:
- Keep command description, minimum routing hints, and path to the shared workflow.
- Remove repeated explanations that the workflow itself immediately restates.

Why this is bounded:
- It changes wrapper text, not artifact authority or lifecycle semantics.

### 2) Consolidate repeated required-reading bundles around hot artifacts
Candidate direction:
- Treat `STATE.md` as the stable default.
- Pull `ROADMAP.md`, `PROJECT.md`, and `PRD.md` only where the path genuinely needs them, or point to narrower windows/sections instead of the whole artifact.

Why this is bounded:
- It narrows workflow read discipline without redesigning the artifacts themselves.

### 3) Factor module-dispatch protocol out of repeated APPLY/UNIFY prose
Candidate direction:
- Replace copied dispatch boilerplate with a shared compact contract or a smaller reference pattern while preserving visible dispatch logs and missing-registry warnings.

Why this is bounded:
- It targets workflow bulk, not module behavior or module truth.

### 4) Collapse resume continuity explanation toward one implementation layer
Candidate direction:
- Keep the full lifecycle in the shared workflow.
- Reduce wrapper and reference duplication to only the minimum needed for routing and fresh-session clarity.

Why this is bounded:
- It preserves handoff capability while reducing repeated explanatory text.

### 5) Keep canonical guided-workflow markers, but trim surrounding explanation
Candidate direction:
- Preserve strings like `Would you like to see the plan?`, `Continue to APPLY?`, `Continue to UNIFY?`, `CHECKPOINT:`, and `▶ NEXT:`.
- Remove repeated prose around them where the extension and workflow already enforce the same semantics.

Why this is bounded:
- It preserves the extension/parser contract while reducing narrative repetition.

### 6) Centralize the stable authority/additive rule once per route, not multiple times nearby
Candidate direction:
- Keep one strong statement that shared `.paul/*` artifacts remain authoritative.
- Avoid repeating the same explanation in docs, runtime payload, and nearby wrapper/workflow text unless the layer truly adds unique meaning.

Why this is bounded:
- It changes wording density, not behavior.

## What stays in the workflow lane vs Phase 160
### Stays in the workflow lane
- wrapper-shell slimming
- required-reading narrowing
- module-dispatch prose compression
- continuity guidance consolidation
- guided-marker surrounding-prose cleanup
- authority/additive wording deduplication

### Hand off to Phase 160
- ranking workflow-side reductions against artifact-side reductions
- deciding whether the highest-value fix is artifact compaction, workflow slimming, or a combined approach
- packaging final recommendations into tactical-now vs structural-later changes

## Phase 160 Hand-off
Phase 160 should assume the following are now established:
1. **Artifact-side and workflow-side costs are separate but compounding.**
2. **`STATE.md` remains the primary hot artifact.** Workflow trimming should not undermine its authority role.
3. **`ROADMAP.md` is the main warm-path artifact whose cost is visibly amplified by workflow bundling.**
4. **Module dispatch prose is one of the largest workflow-only growth candidates.**
5. **Resume/handoff continuity is text-heavy in exactly the low-context scenario where that cost hurts most.**
6. **Canonical guided-workflow markers are mostly intentional duplication and should be preserved unless a better parser contract exists.**

## Bottom line
Phase 159 does **not** support the blanket claim that Pi context pain is mainly caused by large `.paul/*` artifacts.

It supports a narrower, stronger conclusion:
- **Artifacts create the base cost.**
- **Workflow layering around those artifacts adds meaningful recurring overhead.**
- **The strongest workflow-side bloat candidates are wrapper preambles, repeated hot-artifact bundles, copied module-dispatch scaffolding, and duplicated continuity/authority prose.**
- **Phase 160 can now rank combined reductions without guessing.**
