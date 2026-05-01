# PALS Risk-Tiered Lifecycle Contract

**Status:** Phase 235 design contract  
**Created:** 2026-05-01  
**Milestone:** v2.55 Maintainability & Product Reality Hardening  
**Plan:** `.paul/phases/235-risk-tiered-lifecycle-contract/235-01-PLAN.md`

## Purpose

PALS should keep its safety and traceability while making evidence proportional to the risk of the work.

Phase 234 identified that lifecycle ceremony is useful but too uniform: a tiny documentation correction, a normal implementation task, a validation-suite refactor, and an urgent repair should not all carry the same evidence shape. This contract defines risk tiers that future workflow phases may implement. It is design-only and does not alter current PLAN/APPLY/UNIFY runtime behavior.

Lower ceremony means more focused evidence, not missing evidence. `.paul/*` artifacts, approved plans, command output, module dispatch, GitHub Flow evidence, and validation results remain the durable truth sources.

## Evidence Base

This contract summarizes only the Phase 235-relevant findings from:

- `docs/PALS-MAINTAINABILITY-PRODUCT-REALITY-AUDIT.md`
- `docs/PALS-CRITICAL-REVIEW-NEXT-ROADMAP.md`

Relevant findings:

- Process ceremony is a medium-high maintainability risk when every change requires the same level of artifact and validation detail.
- Current safety boundaries are a product strength and must remain intact.
- Validation truth, module evidence, GitHub Flow gates, parent-owned APPLY, and `.paul/*` lifecycle artifacts are not optional.
- Future improvements should reduce repeated context and proof cost without creating hidden runtime state, hidden telemetry, or alternate lifecycle authority.

## Contract Status and Design-Only Scope

This document is a contract-first design artifact. It does not:

- change PAUL workflow behavior
- relax APPLY approval requirements
- change validation scripts or validation pass/fail semantics
- change module dispatch, module blocker handling, or module manifests
- change GitHub Flow branch, PR, CI, review, merge, or cleanup gates
- change Pi runtime, driver, helper-agent, dependency, install, uninstall, or CI behavior
- create telemetry, hidden Pi state, product analytics, or any runtime ledger outside `.paul/*`

Future implementation requires a separate approved PLAN.

## Tier Model Overview

| Tier | Use case | Expected lifecycle posture |
|------|----------|----------------------------|
| tiny/doc-only | Bounded documentation, copy, marker, or metadata clarification with no behavior change | Minimal approved plan shape, focused marker/read verification, concise APPLY/UNIFY evidence |
| normal | Ordinary implementation or documentation+source work with contained risk | Current lifecycle with scoped verification, module evidence, and changed-file proof |
| risky | Runtime, workflow, validation, lifecycle-authority, GitHub Flow, dependency, CI, or broad refactor work | Full lifecycle evidence, broad validation, expanded module review, stricter scope proof, possible review/checkpoints |
| hotfix | Urgent repair to restore broken behavior, blocked validation, bad release, or unusable lifecycle state | Patch under strict bounds first, then retroactively reconcile complete durable evidence |

The tiers are routing guidance for future workflow behavior. Until separately implemented, current PALS workflows remain authoritative.

## Tier: tiny/doc-only

### Use Cases

- New or updated documentation that explains an already-approved behavior or contract.
- Typo, formatting, link, or wording cleanup that does not alter runtime semantics.
- Marker-only or report-only updates that preserve an existing validation contract.
- Lifecycle artifact bookkeeping required by PLAN/APPLY/UNIFY for a docs-only phase.

### Inclusion Criteria

All of these must be true:

- Changed files are limited to documentation, reports, comments, or approved lifecycle artifacts.
- No runtime, workflow, module, validation-suite, dependency, install, CI, GitHub Flow, or driver behavior changes.
- The change can be verified with focused grep/read checks plus `git diff --check` or equivalent whitespace/syntax proof.
- The plan can name the exact files and expected markers before APPLY starts.
- No module blocker, GitHub Flow blocker, validation failure, or user decision is unresolved.

### Exclusion / Escalation Triggers

Escalate to normal or risky when any of these appears:

- Any source/runtime/test/workflow/config/dependency/CI file changes.
- Any prose could be read as weakening approval, validation, module, GitHub Flow, parent-owned APPLY, or `.paul/*` authority.
- Existing validation fails for reasons not clearly unrelated to the docs-only change.
- Documentation claims new behavior that has not been implemented and validated.
- Scope grows beyond the named docs artifact or approved lifecycle bookkeeping.

### Examples

- Create a contract document that future phases will implement later.
- Update a README section to describe already-shipped behavior.
- Reconcile a historical validation count note in a phase report.

### Expected Lifecycle Posture

- Approved PLAN still required.
- APPLY remains parent-owned.
- Verification may be focused: marker checks, targeted reads, `git diff --check`, changed-file review.
- Full validation can be skipped only with explicit docs-only rationale and alternate focused proof.
- UNIFY summary can be concise but must still record files changed, verification, scope proof, deviations, and module reports.

## Tier: normal

### Use Cases

- Small-to-medium implementation work with bounded files and clear verification.
- Documentation and validation surfacing for already-approved runtime changes.
- Localized tests, scripts, helpers, or docs that do not alter lifecycle authority.
- Behavior-preserving refactors with narrow blast radius.

### Inclusion Criteria

All of these should be true:

- The PLAN identifies affected files, expected behavior, verification commands, and acceptance criteria.
- Risk is local and reversible.
- Existing module hooks can review the change without special interpretation.
- GitHub Flow and validation gates can run normally.
- No lifecycle authority, `.paul/*` truth model, module blocking semantics, command-output truth, or helper delegation authority changes.

### Exclusion / Escalation Triggers

Escalate to risky when the change touches:

- `kernel/workflows/`, shared lifecycle references, or PAUL loop semantics.
- validation-suite structure or pass counts in a way that changes gate meaning.
- `drivers/pi/extensions/` runtime behavior or guided workflow behavior.
- GitHub Flow automation, PR/CI/merge gates, branch management, or release flow.
- dependency manifests, install/uninstall scripts, module manifests, or CI configuration.
- broad refactors, multi-subsystem extraction, or hard-to-revert edits.

### Examples

- Add a localized validation guardrail for an already-documented invariant.
- Update docs and skill map for a shipped runtime feature.
- Refactor a small pure helper with unchanged behavior and stable validation.

### Expected Lifecycle Posture

- Current PLAN/APPLY/UNIFY loop remains the default.
- Module dispatch runs and blockers are honored.
- Verification includes relevant tests, lint/typecheck when available, focused marker checks, and `git diff --check`.
- Changed-file scope must match the plan, with deviations recorded.
- UNIFY records validation results, module reports, GitHub Flow evidence, decisions, and summary artifacts.

## Tier: risky

### Use Cases

- Runtime behavior in supported Pi extension or drivers.
- Workflow, lifecycle, checkpoint, APPLY/UNIFY, helper delegation, or `.paul/*` authority changes.
- Validation-suite decomposition, count changes, or pass/fail semantics changes.
- GitHub Flow behavior, CI, dependency, install/uninstall, or module manifest changes.
- Large refactors, broad file moves, subsystem extraction, or multi-phase behavior changes.

### Inclusion Criteria

Any one of these is enough to classify work as risky:

- A failure could weaken lifecycle truth, approval boundaries, validation truth, module blockers, GitHub Flow safety, or parent-owned APPLY.
- A change affects many users or future phases.
- The verification strategy is multi-command, cross-surface, or needs count reconciliation.
- A rollback would be non-trivial.
- The work introduces or removes automation.

### Exclusion / Escalation Triggers

Escalate to checkpointed human decision or split into smaller plans when:

- The plan cannot name bounded files or verification commands.
- More than one lifecycle authority surface changes at once.
- Validation failure diagnosis is ambiguous.
- Module blockers conflict or require policy judgment.
- GitHub Flow gates cannot be satisfied normally.
- The implementation would require hidden runtime state, telemetry, or non-`.paul/*` authority.

### Examples

- Modify `kernel/workflows/apply-phase.md` or `kernel/references/module-dispatch.md`.
- Split `tests/pi-end-to-end-validation.sh` into helpers while preserving counts.
- Extract a subsystem from `drivers/pi/extensions/pals-hooks.ts`.
- Change helper delegation packet/report boundaries.

### Expected Lifecycle Posture

- Full approved PLAN with explicit boundaries, failure modes, and rollback notes.
- Parent APPLY must inspect diffs and rerun official verification.
- Module advisory and enforcement output should be expanded when warnings or blockers appear.
- Full relevant validation should run unless a blocker is explicitly escalated.
- Workguard or equivalent changed-file scope proof is expected for broad edits.
- Human checkpoints or code review should be used when authority, validation, or GitHub Flow behavior changes.
- UNIFY must reconcile count changes, scope deviations, module reports, GitHub Flow state, decisions, and downstream risk.

## Tier: hotfix

### Use Cases

- Repair broken validation that blocks all normal work.
- Restore unusable lifecycle state or bad `.paul/*` routing after a failed operation.
- Fix a released defect or broken install/uninstall path that prevents normal use.
- Patch a critical docs or workflow contradiction that would cause unsafe agent behavior.

### Inclusion Criteria

All of these must be true:

- The problem is urgent enough that waiting for the full normal planning cadence would increase risk.
- The hotfix can be bounded to the smallest safe change.
- The agent can preserve or inspect current evidence before mutation when evidence is fragile.
- The fix path does not require bypassing validation truth, module blockers, GitHub Flow gates, or `.paul/*` artifact authority.

### Exclusion / Escalation Triggers

Do not use hotfix when:

- The issue is merely inconvenient or cosmetic.
- The fix requires broad redesign.
- There is no way to verify the patch.
- The proposed patch would hide evidence, rewrite history without reconciliation, add telemetry, or create hidden state.
- A module blocker or GitHub Flow gate indicates a real safety issue that must be fixed rather than bypassed.

### Examples

- Repair a syntax error introduced in a validation suite so the suite can run again.
- Restore a missing required lifecycle marker that blocks resume/status routing.
- Patch an installer regression that prevents PALS from installing at all.

### Expected Lifecycle Posture

- Patch first only inside strict approved bounds.
- Record why hotfix routing was necessary.
- Preserve fragile evidence before mutating logs, reports, generated state, or lifecycle artifacts when relevant.
- Run the narrowest proof that demonstrates the fix, then run broader validation as soon as practical.
- Retroactively reconcile durable documentation: plan/hotfix summary, changed files, verification output, module reports, scope proof, decisions, and follow-up work.
- Hotfix does not authorize permanent undocumented behavior.

## Non-Bypass Rules

Risk tiers may reduce or focus evidence. They may not bypass these rules:

1. **Explicit APPLY approval** — APPLY starts only after explicit user approval of the selected PLAN or an explicitly authorized hotfix path.
2. **Validation truth** — validation status is based on command output and focused proof, not UI state, inference, or helper claims.
3. **GitHub Flow gates** — branch, PR, CI, review, merge, and cleanup semantics remain enforced when GitHub Flow mode is active.
4. **Module blockers** — enforcement-capable module blockers must be fixed, explicitly escalated, or intentionally overridden with recorded rationale when the workflow allows override.
5. **Parent-owned APPLY** — parent APPLY owns task status, verification, module gates, fallback judgment, checkpoints, GitHub Flow gates, lifecycle writes, and final PASS/BLOCK classification.
6. **Delegated APPLY boundaries** — helper agents may provide bounded implementation aid only; they do not own `.paul/*` lifecycle writes, official verification, module gates, checkpoint completion, GitHub Flow decisions, or lifecycle truth.
7. **Lifecycle writes** — lifecycle artifact mutations happen only through approved PAUL workflow responsibilities or explicitly authorized hotfix reconciliation.
8. **`.paul/*` artifact authority** — `.paul/*` remains authoritative lifecycle truth; generated UI, helper reports, summaries, caches, or hidden runtime state cannot replace it.
9. **Command-output truth** — copied summaries are evidence only when grounded in actual command output or explicitly labeled historical/scoped rationale.
10. **Full authoritative read fallback** — bounded slices, capsules, summaries, or helper reports are derived aids; consequential workflow action requires full authoritative reads when needed.
11. **No hidden Pi state** — Pi runtime assistance may orient and route, but it must not create an opaque lifecycle ledger or hidden control plane.
12. **No telemetry** — proportional evidence must be local and artifact-backed; no product analytics or hidden telemetry is authorized.

## Per-Tier Evidence Matrix

| Evidence area | tiny/doc-only | normal | risky | hotfix |
|---------------|---------------|--------|-------|--------|
| Minimum plan detail | Objective, exact docs/artifacts, focused markers, explicit docs-only boundary | Objective, files, actions, acceptance criteria, verification commands | Full boundaries, risks, rollback/fallback, checkpoints/review needs, validation strategy | Short emergency scope and rationale before patch when feasible; full reconciliation after |
| Verification requirements | Focused grep/read checks, `git diff --check`, changed-file review; full validation optional with recorded docs-only rationale | Relevant tests/validation, focused checks, `git diff --check`, changed-file review | Full relevant validation, count reconciliation, focused marker checks, diff inspection, regression analysis | Narrow proof immediately; broader validation as soon as practical; reconcile any skipped proof |
| Module evidence expectations | Dispatch evidence recorded; no-scope skips acceptable when accurate | Pre/post hooks recorded; warnings addressed or noted | Expanded module reports; blockers fixed/escalated/overridden with rationale | Module evidence preserved if available; blockers cannot be hidden; reconcile after patch |
| Scope proof | Planned docs plus lifecycle bookkeeping only | Planned file set plus justified minor deviations | Workguard or equivalent changed-file proof expected; no unexpected surfaces | Smallest safe changed-file set; preserve evidence before risky mutation |
| Summary requirements | Concise AC result, files, focused proof, scoped validation rationale if used | AC results, commands, module reports, deviations, changed files | Detailed validation, module reports, risk/deviation/count reconciliation, downstream handoff | Hotfix reason, patch scope, verification, skipped/broadened validation status, follow-up tasks |
| GitHub Flow handling | Normal branch/PR/CI gates if configured; no special bypass | Normal GitHub Flow preflight/postflight/merge gate | Expanded PR/CI/review evidence when gate semantics or risky surfaces are touched | Urgency does not bypass active GitHub Flow gates; reconcile branch/PR evidence after patch |
| Escalate to stricter tier when | Any behavior/config/test/workflow/runtime file changes or safety prose weakens | Authority, validation, GitHub Flow, dependency, CI, module, or broad runtime surfaces are touched | Scope is too broad, verification is ambiguous, or policy decision is needed | Fix is no longer urgent/bounded or cannot be verified |

## Scope Proof and Changed-File Expectations

Every tier requires evidence that the actual changed files match the approved scope:

- tiny/doc-only: changed files should be the named docs/report artifact plus expected `.paul/*` lifecycle artifacts.
- normal: changed files should match the PLAN `<files>` list or have recorded minor deviations.
- risky: changed files should be inspected against the PLAN boundaries and Workguard or equivalent drift evidence should be considered mandatory for broad edits.
- hotfix: changed files should be the smallest repair set and must be reconciled after the urgent patch.

A lower tier cannot be used to smuggle in source, workflow, validation, module, dependency, CI, install, or GitHub Flow changes.

## Escalation Rules

Escalate immediately to a stricter tier or a human checkpoint when:

- actual changed files exceed the approved tier scope
- verification fails or cannot be run as planned
- a module returns a blocker
- GitHub Flow preflight/postflight/merge-gate evidence is ambiguous or failing
- the change affects lifecycle authority, validation truth, command-output truth, helper delegation, `.paul/*` authority, or full-read fallback
- the task requires hidden state, telemetry, or a new source of truth
- the agent cannot confidently distinguish documentation-only claims from behavior changes

Escalation should be recorded as a deviation or decision in the appropriate lifecycle artifact.

## Future Implementation Boundaries

Later phases may implement this contract only after separate PLAN approval. Allowed future work may include:

- Phase 236: classify validation expectations by tier and reduce wording-sensitive validation friction without reducing truth.
- Phase 237: make artifact consistency checks tier-aware while preserving `.paul/*` authority.
- Phase 240: demonstrate tiny/doc-only or normal tier behavior in a first-run happy path.
- Phase 241: reconcile whether proportional evidence reduced maintenance cost without weakening safety.

A future implementation may add routing prompts, tier labels, focused verification templates, or summary templates. It must not silently relax gates.

## Deferred / Non-Goals for Phase 235

Phase 235 does not change:

- workflows
- validation scripts
- Pi runtime or extensions
- drivers
- modules or module manifests
- dependency files
- install/uninstall behavior
- CI configuration
- GitHub Flow behavior
- helper-agent authority
- lifecycle artifact authority

Phase 235 also does not add telemetry, product analytics, hidden state, or a new runtime-owned ledger.

## Verification Markers

Focused checks for this contract should confirm the document contains:

- `tiny/doc-only`
- `normal`
- `risky`
- `hotfix`
- `Non-Bypass Rules`
- `Per-Tier Evidence Matrix`
- `Escalation Rules`
- `hotfix reconciliation`
- `Future Implementation Boundaries`
- `Deferred / Non-Goals for Phase 235`
- `design-only`
- `explicit APPLY approval`
- `validation truth`
- `GitHub Flow gates`
- `module blockers`
- `parent-owned APPLY`
- `lifecycle writes`
- `` `.paul/*` artifact authority ``
- `command-output truth`
- `full authoritative read fallback`
- `no hidden Pi state`
- `no telemetry`

## Success Criteria

This contract is successful when future phases can implement risk-tiered lifecycle behavior without guessing:

- how to classify tiny/doc-only, normal, risky, and hotfix work
- what evidence each tier owes
- when to escalate
- which rules can never be bypassed
- which surfaces are explicitly out of scope until a future approved PLAN

The intended outcome is a cheaper safety model, not a weaker one.
