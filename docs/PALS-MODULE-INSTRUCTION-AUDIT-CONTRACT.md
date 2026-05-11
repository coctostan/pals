# PALS Module Instruction Audit Contract

Status: Phase 273 baseline  
Authority tier: derived planning aid  
Scope: PALS module instruction sources  
Milestone: v2.64

## Purpose

This contract defines the v2.64 audit protocol for PALS module instruction sources before any module source is rewritten. It turns the v2.63 workflow-instruction rewrite pattern into a module-facing, docs-first baseline: later phases must audit the current instruction surface, propose a bounded rewrite order, wait for approval, edit section by section, re-read what changed, and preserve verification evidence.

Phase 273 does not change module behavior. It creates a shared map so Phases 274-278 can improve module instructions without rediscovering the module roster, weakening PLAN/APPLY/UNIFY authority, or performing bulk cleanup.

## Evidence Base

The current module contract is based on these source facts:

- `docs/MODULE-SPEC.md` states that PAUL core runs the plan/apply/unify loop and manages project state, while modules extend the kernel through lifecycle hooks.
- `docs/MODULE-SPEC.md` treats each module `module.yaml` as the module's declaration of provided files, subscribed hooks, dependencies, priorities, descriptions, and hook-local refs.
- `docs/MODULE-SPEC.md` requires `hooks.<point>.refs` so the kernel loads the reference files needed for that hook rather than all module references.
- `docs/MODULE-SPEC.md` defines hook data flow: `pre-apply` may inject context for task and post-apply steps, `post-task` annotations accumulate, and `post-apply` annotations feed UNIFY and summary finalization.
- `docs/MODULE-SPEC.md` defines blocking cascade behavior: `pre-apply` blocks stop task execution; `post-task` blocks stop remaining tasks while still allowing post-apply reporting; `post-apply` blocks prevent UNIFY.
- `docs/MODULE-SPEC.md` preserves graceful no-op behavior: missing or unregistered modules are skipped with no kernel-specific conditionals.
- `docs/MODULE-BUILDERS-GUIDE.md` says modules extend the PALS kernel through lifecycle hooks, live under `modules/{name}/`, and register only the hooks they need.
- `docs/MODULE-BUILDERS-GUIDE.md` tells authors to keep reference files focused and notes that the kernel loads only refs declared for a specific hook.
- `kernel/references/module-dispatch.md` says `modules.yaml` is a logical installed-registry path and the installed registry is authoritative for active module dispatch.
- `kernel/references/module-dispatch.md` requires compact visible `[dispatch] ...` evidence for every dispatch attempt, including skip and warning cases.
- `kernel/references/module-dispatch.md` distinguishes advisory hooks, which annotate and never block, from enforcement hooks, which may block with evidence and workflow-owned handling.
- `kernel/references/module-dispatch.md` keeps lifecycle authority at the workflow call site: shared dispatch mechanics do not own mandatory STOP/DO NOT SKIP semantics.

## Authority and Non-Goals

This document is a derived planning aid. It is not lifecycle truth and does not override source artifacts.

Authoritative sources remain:

- `.paul/STATE.md` for current lifecycle state and next action.
- `.paul/ROADMAP.md` for approved phase scope.
- `.paul/PROJECT.md` for project constraints and PAUL/CARL/module separation.
- PLAN and SUMMARY artifacts for phase-specific commitments and reconciliation.
- `docs/MODULE-SPEC.md`, `docs/MODULE-BUILDERS-GUIDE.md`, `kernel/**`, and `modules/**` for their own source definitions until later approved phases change them.

Non-goals for Phase 273:

- No module manifests, references, workflows, kernel workflows, validation scripts, runtime drivers, install scripts, dependency files, CI files, or installed home-directory copies are rewritten.
- No module capability, hook priority, advisory/enforcement behavior, or lifecycle gate is changed.
- No marker phrase is sufficient proof of compliance without a concrete source surface or verification obligation.

## Source Inventory

### Shared and base instruction surfaces

Later phases must audit these shared/base surfaces before editing them:

- `docs/MODULE-SPEC.md` — module manifest format, hook contract, hook data flow, blocking behavior, no-op behavior, and filesystem layout.
- `docs/MODULE-BUILDERS-GUIDE.md` — module authoring workflow, manifest examples, hook registration guidance, reference-file guidance, and builder expectations.
- `kernel/references/module-dispatch.md` — installed registry resolution, dispatch procedure, hook taxonomy, evidence-line convention, durable evidence destinations, and project-config vs installed-registry boundary.
- `kernel/references/evidence-discipline.md` — evidence preservation and durable proof expectations for hook output.
- `kernel/references/context-management.md` — compact-output and bounded-loading expectations for module dispatch and lifecycle reports.
- `kernel/references/specialized-workflow-integration.md` — boundaries between base lifecycle workflows and specialized module/workflow overlays.

### Kernel call-site surfaces

Instruction wording for module behavior also appears where lifecycle workflows invoke hooks:

- `kernel/workflows/plan-phase.md` — pre-plan and post-plan dispatch and PLAN evidence persistence.
- `kernel/workflows/apply-phase.md` — pre-apply, post-task, post-apply advisory/enforcement dispatch, task verification, and APPLY evidence handoff.
- `kernel/workflows/unify-phase.md` — pre-unify/post-unify dispatch, summary finalization, durable module reports, and merge-gate interactions.

### Module source classes

Every installed module cohort must account for these instruction-surface classes:

- Module manifests: `modules/*/module.yaml`.
- Module references: `modules/*/references/*.md`.
- Module workflow overlays: `modules/*/workflows/*.md`.

### Installed module roster

The installed module directories visible under `modules/` are:

- `arch`
- `aria`
- `codi`
- `dana`
- `dave`
- `dean`
- `docs`
- `gabe`
- `iris`
- `luke`
- `omar`
- `pete`
- `reed`
- `rev`
- `ruby`
- `seth`
- `skip`
- `todd`
- `vera`
- `walt`

Roster count: 20 installed module directories.

### Phase 273 inventory boundary

Phase 273 inventories surfaces only. It does not normalize, rewrite, rank, or judge individual module instructions. Later phases must use this inventory as their starting source list, then perform bounded file/section reads for their approved cohort.
