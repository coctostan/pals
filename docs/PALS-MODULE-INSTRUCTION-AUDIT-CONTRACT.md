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

## Audit Rubric

Later module rewrite phases must apply every check below to the approved cohort before proposing edits:

1. **Context efficiency:** Is the instruction short enough for hot-path use, or can it be replaced with a bounded reference, compact table, or decision rule without losing semantics?
2. **Semantic enforcement:** Does the instruction define what must happen, what blocks, what skips, and what evidence proves the outcome, rather than only naming marker phrases?
3. **Lifecycle compatibility:** Does the instruction preserve PLAN/APPLY/UNIFY ownership of lifecycle truth, verification, fallback, user checkpoints, and `.paul/*` writes?
4. **Hook classification:** Is the hook clearly advisory, enforcement, or a workflow-local split cohort, and does the text match that classification?
5. **Skip/block/pass evidence:** Are skip, warning, pass, block, override, fix, and stop outcomes visible and durable enough for the next lifecycle phase?
6. **Bounded source loading:** Does the instruction tell agents to load only the hook-local refs, section windows, or approved files needed for the task?
7. **Compact output:** Does the instruction default to concise dispatch lines and expand only for blockers, ambiguity, failures, warnings, or durable evidence needs?
8. **Durable evidence destinations:** Does the instruction say whether evidence belongs in PLAN, APPLY annotations, SUMMARY Module Execution Reports, STATE, a history file, or no durable artifact?
9. **User-decision preservation:** Does the instruction preserve approval checkpoints, override choices, deviations, and decisions that UNIFY must reconcile?
10. **Installed/runtime source-of-truth boundaries:** Does the instruction respect installed `modules.yaml` for runtime dispatch while leaving source `modules/*` files authoritative for approved rewrite edits?
11. **Operational correctness:** Can an agent execute the instruction with available Pi/PALS tools without hidden assumptions, broad searches, shell-only behavior, or unstated external state?
12. **Holistic correctness:** Is the instruction still true, useful, and proportionate for the module's current purpose?

## Holistic Module Review Questions

Every later cohort audit must answer these questions for each approved file or section:

- Is any instruction redundant with another workflow, manifest field, module reference, or shared dispatch rule?
- Is any instruction confusing because it mixes module advice with lifecycle authority or hides who owns the decision?
- Is any instruction stale ceremony retained only because an old workflow used to need it?
- Does any instruction encourage marker-only compliance instead of concrete behavior, evidence, or validation?
- Does any instruction contradict the installed registry contract, hook taxonomy, PLAN/APPLY/UNIFY lifecycle, or module source files?
- Is any instruction over-specified, forcing broad scans, noisy output, unnecessary commands, or repeated context loading?
- Is any instruction under-specified, leaving block/skip/pass behavior, evidence destinations, or verification criteria ambiguous?
- Is any instruction shell-specific, harness-specific, or installed-path-specific without a real need?
- Is any instruction impossible to execute with the tools available to PAUL/APPLY/UNIFY?
- Is any instruction no longer true because module dispatch, Pi native tools, GitHub Flow, or PALS state handling changed?
- Is any instruction simply wrong, even if it sounds plausible or uses the right marker words?
- Would a new pal author or APPLY agent perform the intended behavior after reading only the bounded approved context?

## Advisory vs Enforcement Semantics

Advisory modules inform the lifecycle. They may annotate, summarize, persist reports, or recommend follow-up, but they must not block progression. Advisory output still needs visible `[dispatch] ...` evidence when it runs or skips.

Enforcement modules may block only when the approved workflow allows blocking and the module presents concrete evidence. A block must identify the failing condition, affected file or source surface when applicable, expected behavior, observed behavior, and the allowed recovery path: fix, override where the workflow permits it, or stop.

A workflow-local split such as `post-apply advisory` vs `post-apply enforcement` must keep the shared hook taxonomy while preserving the lifecycle call site's authority over exact blocking behavior.

## Collaborative Rewrite Protocol

Phases 274-277 must use a section-by-section collaborative protocol before mutating instruction-sensitive sources.

For each file or section proposed for mutation, the APPLY agent must present:

- current excerpt or bounded source summary;
- concrete problem being solved;
- proposed wording or focused diff;
- affected lifecycle, hook, module, or installed-registry semantics;
- verification expectation for the changed section;
- whether the change affects advisory/enforcement behavior, evidence destinations, or user decision handling.

The protocol forbids:

- bulk rewrites;
- helper-owned lifecycle writes;
- edits ahead of explicit approval;
- marker-only fixes;
- broad source searches when a bounded file or section read is sufficient;
- rewriting unrelated module surfaces while working on a cohort;
- weakening PLAN/APPLY/UNIFY authority to satisfy module-local prose.

After each approved edit, the APPLY agent must re-read the changed section or file, verify the intended wording landed, and record a compact decision/evidence note for the phase SUMMARY. If a requested change would alter lifecycle authority or module behavior beyond the approved phase boundary, APPLY must stop and route back to planning or explicit user decision.


## Module Cohort Map

Phases 274-278 must use this cohort map unless a later approved PLAN narrows scope further.

### Phase 274: Shared/base module surfaces

Inclusion rules:

- Module-facing docs: `docs/MODULE-SPEC.md` and `docs/MODULE-BUILDERS-GUIDE.md`.
- Shared dispatch/evidence/context references: `kernel/references/module-dispatch.md`, `kernel/references/evidence-discipline.md`, `kernel/references/context-management.md`, and `kernel/references/specialized-workflow-integration.md`.
- Kernel call-site wording where module dispatch semantics are described in `kernel/workflows/plan-phase.md`, `kernel/workflows/apply-phase.md`, and `kernel/workflows/unify-phase.md`.

Primary outcome: base dispatch and module-authoring instructions agree on installed registry authority, hook-local refs, advisory/enforcement behavior, compact evidence, and lifecycle ownership.

### Phase 275: Core enforcement modules

Inclusion rules:

- `todd` — TDD/test discipline and task-level blocking behavior.
- `walt` — quality/test baseline, post-apply gates, and quality-history behavior.
- `dean` — dependency/security audit behavior where dependency risk may block progression.
- Any hook descriptions in the approved cohort that can block progression or enforce quality, security, dependency, or lifecycle behavior.

Primary outcome: enforcement text blocks only with evidence, names recovery handling, and does not overreach into advisory or lifecycle-owned decisions.

### Phase 276: Review, knowledge, and codegraph advisory modules

Inclusion rules:

- `iris` — review-quality and defect-pattern guidance.
- `rev` — review workflows and review reports.
- `skip` — knowledge/citation and source-persistence behavior.
- `codi` — codegraph blast-radius extraction and history persistence.
- `docs` — documentation-drift guidance.
- `ruby` — technical-debt and refactor-suggestion guidance.
- Compact-evidence and persistence rules for all listed modules.

Primary outcome: advisory modules provide useful evidence and durable summaries without blocking, pretending to be lifecycle truth, or expanding context unnecessarily.

### Phase 277: Domain optional modules

Inclusion rules:

- `arch` — architecture boundaries and drift checks.
- `seth` — security patterns and secret/injection checks.
- `gabe` — API compatibility and endpoint guidance.
- `aria` — accessibility checks.
- `luke` — UX/design consistency checks.
- `dana` — data/migration/query guidance.
- `dave` — deployment/CI/CD checks.
- `omar` — observability/logging/health guidance.
- `pete` — performance checks.
- `reed` — resilience/retry/timeout checks.
- `vera` — privacy/PII checks.
- Any remaining domain-specific references not completed in earlier phases.

Primary outcome: domain modules remain actionable and bounded while avoiding false positives, stale commands, cross-harness assumptions, and lifecycle-authority drift.

### Phase 278: Validation guardrails and closure

Inclusion rules:

- Semantic validation guardrails for module dispatch behavior.
- Registry/doc consistency checks across installed `modules.yaml`, source `modules/*/module.yaml`, and module docs.
- Install/runtime verification where approved by the Phase 278 PLAN.
- Evidence closure and milestone-completion preparation.
- Validation suites such as `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` when approved for guardrail changes.

Primary outcome: v2.64 closes with validation that detects marker-only module compliance and confirms dispatch semantics still match the contract.

## Phase 274 Handoff

Phase 274 must begin with a compact audit of shared/base surfaces and a proposed file/section order. It must include a blocking approval checkpoint before edits. Approved edits must proceed section by section, with scoped validation after each changed section and SUMMARY evidence describing decisions, changed semantics, and any deferred issues.

Required Phase 274 focus:

- Align module spec, builder guide, dispatch reference, evidence/context references, and workflow call-site language.
- Confirm installed registry authority and source-file authority are not confused.
- Confirm shared docs describe advisory vs enforcement semantics consistently.

## Phase 275 Handoff

Phase 275 must begin with a compact audit of TODD, WALT, DEAN, and blocking hook descriptions, then present the proposed file/section order. It must stop for approval before edits. Approved edits must preserve enforcement power only where concrete evidence and recovery handling exist.

Required Phase 275 focus:

- Tests, quality gates, and dependency/security blockers must report baseline, observed result, delta, and allowed recovery.
- Enforcement modules must not claim authority over `.paul/*` lifecycle truth, merge gates, or user approval decisions.
- SUMMARY evidence must identify any changed block/override/stop semantics.

## Phase 276 Handoff

Phase 276 must begin with a compact audit of IRIS, REV, SKIP, CODI, DOCS, RUBY, and persistence/evidence behavior, then present the proposed file/section order. It must stop for approval before edits. Approved edits must keep advisory modules advisory and compact.

Required Phase 276 focus:

- Advisory modules cannot block progression.
- Persistent advisory artifacts must have clear destinations and schemas.
- Codegraph, citation, review, docs, and debt instructions must be executable without broad or magical inference.

## Phase 277 Handoff

Phase 277 must begin with a compact audit of ARCH, SETH, GABE, ARIA, LUKE, DANA, DAVE, OMAR, PETE, REED, VERA, and any remaining domain references, then present the proposed file/section order. It must stop for approval before edits. Approved edits must be scoped to the domain cohort.

Required Phase 277 focus:

- Domain checks must define applicable file types, skip conditions, warning/block criteria, and evidence format.
- Stale shell commands or harness-specific instructions must be removed or narrowed when a Pi-native or platform-neutral instruction is available.
- Domain modules must not introduce dependencies, CI behavior, runtime changes, or telemetry outside approved scope.

## Phase 278 Guardrail Handoff

Phase 278 must convert this contract into focused semantic validation and closure evidence. Guardrails must reject marker-only module compliance and verify at least:

- advisory modules cannot block;
- enforcement modules block only with concrete evidence and allowed recovery handling;
- dispatch skip/pass/block evidence is visible;
- hook refs remain bounded and hook-local;
- module manifests and docs agree on module surfaces;
- installed registry authority is distinct from source rewrite authority;
- user-approved rewrite protocol was followed and recorded in phase summaries;
- helper agents did not own lifecycle writes, module gates, or official verification.

Phase 278 must also confirm whether README/skill-map or builder-facing docs need surfacing updates after the module rewrites, without adding unapproved runtime or dependency changes.

## Verification Expectations

Before APPLY or UNIFY claims this contract satisfied Phase 273, verification must include:

- focused marker checks for all required sections in this document;
- focused marker checks for all 20 installed module names;
- focused marker checks for holistic review questions about redundancy, confusion, stale ceremony, marker-only compliance, contradiction, over/under-specification, and simply wrong guidance;
- confirmation that the contract requires the v2.63 collaborative rewrite protocol for Phases 274-277;
- changed-file scope review showing no module, kernel, test, runtime, dependency, CI, install, or home-directory source was changed by Phase 273;
- `git diff --check`;
- existing validation suites run, or a docs-only scoped skip recorded with alternate focused proof.

Docs-only scoped skip rationale for Phase 273: this phase creates a planning contract only and does not modify executable code, module manifests, kernel workflows, tests, dependencies, or CI. Focused content checks plus `git diff --check` are acceptable APPLY evidence; UNIFY may decide whether to run broader validation for repository confidence.

## Out of Scope

Phase 273 explicitly excludes:

- module source rewrites in `modules/**`;
- kernel source rewrites in `kernel/**`;
- test or semantic guardrail implementation in `tests/**`;
- runtime driver, installer, package/dependency, or CI changes;
- installed home-directory edits under `~/.pi/agent/skills/pals/*` or any other runtime installation surface;
- telemetry changes;
- weakening PLAN/APPLY/UNIFY authority;
- removing module capabilities without a later approved rewrite-phase decision;
- treating this contract as lifecycle truth.

## Phase 278 Closure: Semantic Validation Guardrails

Phase 278 Plan 278-01 closes the v2.64 module instruction audit milestone by
replacing inherited marker-only validation drift with grouped semantic
guardrails. The pattern is durable for future module-instruction audits and
applies to any check that previously expected a stale literal-marker phrase.

**Pattern.** Each cross-harness check for a module-instruction contract must
verify a behaviour group, not a single literal phrase:

- TS/JS source-selector breadth (`.ts` / `.tsx` / `.js` / `.jsx`);
- bounded explicit-seed extraction (top-level, exported, explicit, bounded);
- per-symbol impact contract (`impact` plus one of {per seed, once per,
  singleSymbol, never batched});
- safe-skip / advisory posture (skip, advisory, never block, codegraph index
  unavailable);
- visible dispatch evidence (`[dispatch] CODI` plus one of {success counts,
  N/R/U/K, skip reason, skip log});
- post-unify instrumentation (`CODI-HISTORY.md`, `codi-instrumentation.md`,
  `no-dispatch-found`, append-row schema, PLAN-primary/SUMMARY-fallback read
  order);
- durable module-report semantics (e.g. WALT `module_report` +
  `Module Execution Reports`, RUBY post-unify `changed files` + refactor/debt
  signals).

**Failure mode rejected.** A check that passes when a single magic phrase is
present (and would still pass after the rest of the module instruction is
deleted or weakened) is not acceptable. Every guardrail requires multiple
independent contract signals; helpers in `tests/helpers/module_instruction_semantics.sh`
encode these groups and return shell success/failure only so callers retain
TAP ownership.

**Authority.** Semantic guardrails verify contracts; they are not lifecycle
truth. PLAN/APPLY/UNIFY remain authoritative for module rewrites, and helper
edits to validation surfaces must stay inside the validation/helper/contract
file set approved by their PLAN.

**Follow-up scope.** Plan 278-01 covered `tests/cross-harness-validation.sh`.
The same semantic pattern should be applied to `tests/pi-end-to-end-validation.sh`
in a follow-up plan (checks 10, 185, 188, 190, 192 carry the same inherited
CODI marker drift).