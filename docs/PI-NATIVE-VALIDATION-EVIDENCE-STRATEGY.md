# Pi-Native Validation and Evidence Strategy

## Status

| Field | Value |
|---|---|
| Milestone | v2.46 Pi-Native Implementation Planning |
| Phase | 200 — Validation + Evidence Strategy |
| Artifact status | Planning input for Phase 201 final implementation-plan proposal |
| Implementation status | No runtime, workflow, validation-script, dependency, GitHub Flow, report, or legacy-surface changes are approved by this artifact |

## Purpose

This document defines how future Pi-native implementation milestones should prove behavior while preserving the artifact-first PALS contract. It turns the Phase 199 sequencing/dependency plan into validation classes, command-output evidence rules, and Phase 201 readiness constraints.

Phase 200 is implementation planning, not implementation hardening. This strategy can guide later plans, but it does not authorize edits to Pi runtime behavior, shared workflow semantics, validation scripts, dependency manifests, GitHub Flow behavior, Claude Code wrappers, Agent SDK surfaces, portability docs, installed runtime copies, or validation reports.

## Planning-Only Boundary

This artifact provides validation and evidence strategy only. Future implementation still requires an approved PLAN, parent-owned APPLY, module dispatch evidence, official verification output, GitHub Flow gates when enabled, UNIFY reconciliation, and `.paul/*` lifecycle writes.

Non-negotiable boundaries for all later validation decisions:

- `.paul/*` artifacts remain lifecycle truth; Pi context, widgets, helper-agent reports, guided UI choices, and context slices are derived aids only.
- PLAN/APPLY/UNIFY remains authoritative: PLAN approves work, APPLY executes and verifies under parent control, and UNIFY reconciles durable artifacts.
- Installed `modules.yaml`, `[dispatch] ...` lines, PLAN/SUMMARY/STATE reports, git/PR evidence, and validation command output remain evidence sources; Pi must not create hidden ledgers.
- GitHub Flow gates remain command-evidence-backed; Pi may surface branch/PR/CI state but must not bypass branch creation, base sync, CI, review, merge, or cleanup gates.
- Parent APPLY owns eligibility, official verification, fallback judgment, checkpoints, module enforcement, task result classification, and `.paul/*` writes even when `pals-implementer` helps.
- Runtime context aids must be source-cited, freshness-aware where facts can change, bounded, disposable, and backed by full authoritative reads for edits, lifecycle decisions, stale/contested facts, GitHub Flow gates, or ambiguity.
- No hidden Pi state, telemetry-owned context, auto-approval, auto-continue, UI-only lifecycle decision, helper-owned APPLY, merge-gate bypass, lifecycle ledger, or Pi-owned validation pass signal is allowed.

## Source Inputs

| Source | Evidence used | Strategy implication |
|---|---|---|
| `docs/PI-NATIVE-SEQUENCING-DEPENDENCY-PLAN.md` | Phase 199 validation/evidence questions, validation-class dependencies, Phase 201 handoff, readiness criteria, and sequencing conclusion. | Primary source for the validation/evidence questions this Phase 200 artifact must answer. |
| `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md` | Six candidate workstreams, likely repo surfaces, validation/evidence expectations, dependencies, risk gates, and open questions. | Defines which future workstreams need evidence requirements before Phase 201 proposes build milestones. |
| `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` | Settled decisions, authority boundaries, promoted/rejected patterns, workstream seeds, and Phase 200 questions. | Supplies the baseline requirement to classify Pi-supported runtime, shared invariant, frozen legacy parity, runtime lens, guided UI safety, and helper delegation checks. |
| `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Final v2.45 authority model, promoted patterns, migration roadmap, implementation roadmap, validation classes, evidence requirements, and non-goals. | Establishes the validation class taxonomy and the command-evidence-backed authority model. |
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Context-cost surfaces, non-negotiable guardrails, read/citation contract, assistance components, validation redesign requirements, and rejected designs. | Defines citation, freshness, boundedness, full-read fallback, and command-output truth requirements. |
| `docs/PI-RUNTIME-CAPABILITY-MAP.md` | Pi runtime primitive classifications, lifecycle mapping, guardrails, and validation/CI surfacing notes. | Grounds evidence in current Pi capabilities and separates usable runtime surfaces from guardrail-only or validation-redesign surfaces. |
| `tests/pi-end-to-end-validation.sh` | Current Pi validation categories and assertions for installer deployment, module evidence, skill structure, extension behavior, driver manifests, context-diet guardrails, CODI, guided workflow, helper delegation, and discovery surfaces. | Source for Pi-supported runtime and runtime-lens classification. The script remains command truth, not a report to rewrite in this phase. |
| `tests/cross-harness-validation.sh` | Current cross-harness categories for installer parity, shared apply/REV boundaries, durable module evidence, portability, artifact spec, context-diet guardrails, CODI distribution, and driver manifests. | Source for shared invariant vs frozen legacy parity classification. The script remains command truth, not a report to rewrite in this phase. |
| `docs/PI-VALIDATION-REPORT.md` | Historical Pi report from 2026-03-14 with 75 checks. | Historical example only; current validation truth comes from fresh command output. |
| `docs/VALIDATION-REPORT.md` | Historical cross-harness report from 2026-03-14 with 45 checks. | Historical example only; current validation truth comes from fresh command output. |

## Validation Strategy Principles

1. **Command output is validation truth.** Reports, widgets, summaries, and Pi lenses can explain results, but they cannot mark validation green without the actual command output.
2. **Classify before weakening.** A check must be labeled by support purpose before any future plan weakens, relocates, archives, or deletes it.
3. **Protect shared invariants first.** `.paul/*` authority, PLAN/APPLY/UNIFY, module evidence, GitHub Flow gates, parent-owned APPLY, explicit approval/checkpoints, and archive/handoff traceability remain blocking product invariants.
4. **Treat frozen legacy parity as evidence, not current product direction.** Claude Code and Agent SDK parity can remain useful historical proof, but parity-only checks should not silently veto Pi-native design after classification.
5. **Add runtime-lens proof with every new lens.** Artifact slices, capsules, module lenses, GitHub Flow lenses, CARL bootstrap, and helper reports need source citations, freshness where facts can change, bounds, activation/intent proof, and full-read fallback.
6. **Keep guided UI auditable.** Any UI confirmation, selection, checkpoint, approval, continue-to-UNIFY, or merge-gate route must emit explicit canonical transcript or artifact evidence.
7. **Keep helper delegation parent-verifiable.** Helper-agent context compression is safe only when packet fields, report fields, changed files, attempted commands, fallback triggers, and parent official verification remain inspectable.
8. **Do not combine validation classification with cleanup.** Legacy retention or install-surface cleanup waits until shared-invariant coverage is identified and product approval is explicit.

## Validation Class Taxonomy

| Class | Purpose | Blocking posture | Example evidence |
|---|---|---|---|
| Pi-Supported Runtime | Proves active Pi behavior and install/runtime surfaces work as designed. | Blocking for Pi-native implementation milestones that touch Pi runtime or install behavior. | Pi installer output, `/paul-*` routing, skill/resource installation, extension commands/hooks, lifecycle UI, context injection, guided workflow UX, CARL behavior, helper-agent installation, module registry generation. |
| Shared Invariant | Protects PALS lifecycle semantics independent of runtime. | Blocking until a future plan intentionally relocates or retires the invariant with equivalent evidence. | `.paul/*` authority markers, PLAN/APPLY/UNIFY loop markers, module evidence requirements, GitHub Flow safety markers, parent-owned APPLY language, explicit approval/checkpoint rules, context-diet budgets, archive/handoff traceability. |
| Frozen Legacy Parity | Preserves historical compatibility evidence for Claude Code, Agent SDK, and cross-harness installation surfaces after the support-tier reset. | Non-authorizing by itself for new Pi behavior; do not weaken or delete until shared-invariant coverage is identified. | Claude Code wrapper parity, legacy installer parity, exact cross-harness path assumptions, historical portability docs, driver parity checks. |
| Runtime Lens | Proves Pi-derived context assistance remains bounded, cited, freshness-aware, disposable, and backed by full reads. | Blocking for artifact-slice, workflow/resource capsule, module lens, GitHub Flow lens, CARL bootstrap, or context-injection changes. | Source citations, freshness markers, size/bounds checks, activation gating, duplicate-context trimming, no hidden persistence, full-read fallback text. |
| Guided UI Safety | Proves Pi UI assistance cannot silently continue lifecycle work or hide user intent. | Blocking for guided workflow, checkpoint, approval, continue-to-UNIFY, or merge-gate UI changes. | Canonical transcript replies, explicit user action, checkpoint blocking, no auto-approval, no auto-continue, no UI-only lifecycle decisions, no merge-gate bypass. |
| Helper Delegation | Proves `pals-implementer` remains bounded and parent-verifiable. | Blocking for helper-agent packet/report compression or delegated APPLY ergonomics changes. | Required packet/report fields, allowed/forbidden file scope, changed-file diff checks, fallback triggers, parent official verification, no helper-owned `.paul/*` lifecycle writes. |
| GitHub Flow Safety | Proves branch/PR/CI/review/merge/base-sync behavior remains workflow- and command-evidence-owned. | Blocking for any git status, route, PR, CI, merge-gate, or next-action automation change. | `git branch`, ahead/behind counts, `gh pr view`, `gh pr checks`, merge-gate summaries, PR URL/state, CI status, base sync and branch cleanup output. |
| Artifact / Process | Proves lifecycle artifacts, reports, plans, summaries, and validation reports remain reviewable and fresh. | Blocking for lifecycle writes and documentation artifacts that shape implementation planning. | PLAN source inputs and boundaries, SUMMARY AC results, STATE/ROADMAP updates, Module Execution Reports, validation report freshness labels, historical-report disclaimers. |

## Current Suite Classification

### `tests/pi-end-to-end-validation.sh`

| Current suite area | Primary class | Secondary class | Preserve / future use |
|---|---|---|---|
| Installer Deployment | Pi-Supported Runtime | Shared Invariant | Keep blocking for Pi install structure, skill/resource deployment, modules.yaml generation, extension installation, and helper-agent install evidence. |
| Module Execution Evidence | Shared Invariant | Pi-Supported Runtime | Keep blocking because installed registry metadata, post-unify module refs, durable summary evidence, and helper-agent boundary markers protect visible module evidence. |
| Skill Structural Validity | Pi-Supported Runtime | Shared Invariant | Keep blocking for installed Pi skill shape and workflow references; wrapper validity remains active Pi runtime evidence. |
| Thin Wrapper Contract | Shared Invariant | Pi-Supported Runtime | Keep blocking where wrappers preserve explicit approval, parent-owned APPLY, collaboration, resume routing, GitHub Flow status, and reconciliation semantics. |
| Delegated APPLY / REV Boundaries | Helper Delegation | Shared Invariant | Keep blocking for bounded `pals-implementer` installation and parent-authority language; add future packet/report field checks here or nearby. |
| Shared Workflow Prose Contract | Shared Invariant | Runtime Lens | Keep blocking for targeted reads, review menus, roadmap routing, and module-dispatch evidence markers that future capsules must not obscure. |
| Context-Diet Regression Guardrails | Shared Invariant | Runtime Lens | Keep blocking for active-window line budgets, archive pointers, duplicated GitHub Flow prose ceilings, and hot workflow/reference anti-regrowth budgets. |
| CODI Plan-Phase Distribution | Shared Invariant | Helper Delegation | Keep blocking for source-selector and CODI evidence markers; classify as module/helper evidence rather than UI runtime behavior. |
| Extension Structural Validity | Pi-Supported Runtime | Runtime Lens / Guided UI Safety | Keep blocking for command registration, lifecycle UI, context injection, artifact-slice markers, guided workflow detection, module visibility, and bounded lifecycle widgets. |
| Driver Manifest Accuracy | Pi-Supported Runtime | Shared Invariant | Keep blocking for Pi declared capabilities and installer target accuracy. |
| Pi Discovery Surfaces | Pi-Supported Runtime | Runtime Lens / Helper Delegation | Keep blocking for command/skill/workflow mapping, shortcuts, install boundaries, helper-agent explanation, and live module visibility as derived-only behavior. |
| Collaborative Planning Model | Shared Invariant | Guided UI Safety | Keep blocking for collaboration defaults, mode selection, and plan review menu visibility. |
| UX Readability & Color Enrichment | Pi-Supported Runtime | Guided UI Safety | Keep blocking only when it protects lifecycle clarity; treat visual polish as lower risk than explicit intent and checkpoint evidence. |

### `tests/cross-harness-validation.sh`

| Current suite area | Primary class | Secondary class | Preserve / future use |
|---|---|---|---|
| Installer Parity | Frozen Legacy Parity | Shared Invariant | Reclassify carefully: file-count parity and Claude install behavior are frozen legacy evidence, while shared kernel/resource generation can protect shared invariants. |
| Shared APPLY / REV Boundaries | Shared Invariant | Helper Delegation | Keep blocking because delegated APPLY guardrails and REV separation protect parent-owned APPLY across runtimes. |
| Durable Module Evidence Path | Shared Invariant | Artifact / Process | Keep blocking because module evidence must remain durable in workflows, specs, templates, and summaries. |
| Portability Compliance | Shared Invariant | Frozen Legacy Parity | Keep blocking where it prevents harness-specific kernel/module language; parity-only path assumptions need explicit classification before weakening. |
| Shared Collaborative Planning Model | Shared Invariant | Guided UI Safety | Keep blocking for collaboration modes and review menu preservation independent of runtime. |
| Context-Diet Regression Guardrails | Shared Invariant | Runtime Lens | Keep blocking for shared workflow ceilings, GitHub Flow markers, module dispatch markers, and context-diet budgets. |
| CODI Plan-Phase Distribution | Shared Invariant | Helper Delegation | Keep blocking for source-selector contracts and durable CODI instrumentation across installed registries. |
| Artifact Spec Compliance | Shared Invariant | Artifact / Process | Keep blocking for STATE/PROJECT/ROADMAP structure and artifact-first contract. |
| Driver Manifests | Frozen Legacy Parity | Shared Invariant | Treat cross-driver capability parity as frozen legacy evidence unless the check protects a still-current shared driver contract. |

## Historical Validation Reports

| Report | Status | How future plans may use it |
|---|---|---|
| `docs/PI-VALIDATION-REPORT.md` | Historical example generated 2026-03-14; counts are stale relative to current 186-check Pi validation output. | Use as report-format history only. Do not cite it as current validation truth or update it in Phase 200 APPLY. |
| `docs/VALIDATION-REPORT.md` | Historical example generated 2026-03-14; counts are stale relative to current 100-check cross-harness validation output. | Use as report-format history only. Do not cite it as current validation truth or update it in Phase 200 APPLY. |

## Preservation Rules

- Do not delete, weaken, or relabel a Shared Invariant check until a future approved plan identifies equivalent command evidence or explicitly retires the invariant.
- Do not let Frozen Legacy Parity checks silently block a Pi-native implementation proposal solely because a frozen surface does not receive equivalent new behavior.
- Do not remove parity-only checks in the same step that first classifies them; retention/removal requires a later product/support-surface decision.
- Do not let Pi summaries, widgets, reports, or context slices replace validation command output.
- Do not rewrite validation scripts as part of a runtime feature plan unless that plan is explicitly scoped to validation classification or validation-script implementation.
- Keep fresh APPLY/UNIFY command output as the source of truth even when historical reports exist.

## Future Workstream Evidence Requirements

| Workstream | Minimum command-output evidence | Durable artifact evidence | Additional risk gate |
|---|---|---|---|
| Artifact-Slice Contract Hardening | Marker checks plus `bash tests/pi-end-to-end-validation.sh`; keep `bash tests/cross-harness-validation.sh` green for shared invariants. | PLAN cites slice source inputs, schema, bounds, freshness rules, fallback language, and protected files; SUMMARY records exact validation output and changed files. | Block if slices omit `Source:` citations, omit freshness for changing facts, write `.paul/*`, create hidden persistence, or replace full reads for edits/lifecycle decisions. |
| Guided Workflow Evidence Hardening | Structural checks for canonical replies/no-auto-continue plus Pi validation; cross-harness validation remains green for shared approval/checkpoint invariants. | PLAN names guided moments and reply schema; SUMMARY records transcript-visible evidence, checkpoint/approval behavior, and no UI-only decision proof. | Block if UI state alone records a decision, prompts auto-continue, checkpoints can be skipped, or approval/merge intent is inferred. |
| Workflow/Resource Capsule Design | Marker checks proving citations and blocking-semantics exclusions, plus Pi and cross-harness validation. | PLAN records installed resource paths, capsule eligibility rules, exclusion list, and full-read fallback criteria; SUMMARY confirms full workflow reads remain required for blocking semantics. | Block if capsules hide STOP/DO NOT SKIP, override paths, checkpoints, lifecycle writes, module gates, merge gates, or ambiguity handling. |
| Delegated APPLY Packet/Report Compression | Static checks for packet/report fields, allowed-file rules, fallback markers, and parent official verification; Pi and cross-harness validation remain green. | PLAN records packet template, report schema, allowed/forbidden files, verification rules, and parent lifecycle reminder; SUMMARY records helper report review, parent official verify, file-scope check, and fallback decisions. | Block if helper owns `.paul/*` writes, checkpoints, module gates, official verification, fallback judgment, or APPLY completion status. |
| Pi-Native Validation Classification | Marker checks over validation scripts/reports plus full Pi and cross-harness validation. | PLAN identifies exact assertions/classes changed; SUMMARY records before/after counts, classification rationale, and unchanged shared-invariant coverage. | Block if shared invariants are weakened, parity-only checks are removed before classification, or reports replace command output. |
| Legacy Retention and Install-Surface Cleanup | Classification marker checks, retained shared-invariant validation, fresh Pi/cross-harness validation, and GitHub Flow evidence if install surfaces change. | PLAN records product decision, retention/removal matrix, archive/source-only handling, and preserved shared-invariant evidence; SUMMARY records exact removed/retained surfaces and validation proof. | Block unless validation classification is complete and product approval is explicit. Do not silently delete historical proof or shared-invariant coverage. |

## Command-Output Evidence

Future APPLY/UNIFY phases should preserve command output in a way a reviewer can audit without trusting Pi summaries:

- Marker greps must show matched lines or enough output to identify the checked file and marker family.
- `bash tests/pi-end-to-end-validation.sh` output must include TAP summary counts and final pass/fail status; current Phase 200 baseline is 186/186.
- `bash tests/cross-harness-validation.sh` output must include TAP summary counts and final pass/fail status; current Phase 200 baseline is 100/100.
- GitHub Flow evidence must include current branch, base branch, ahead/behind status, PR URL/state when applicable, CI/check state, and merge-gate result during UNIFY.
- Dependency or security audit evidence, when applicable, must include command name, severity counts, baseline comparison, and any override decision.
- Helper delegation evidence must include the parent-owned task packet, helper report fields, parent file-scope diff check, and parent-run official verification output.
- When expected validation counts change in a future approved plan, SUMMARY must state the old count, new count, reason, class affected, and shared-invariant preservation rationale.

## Durable Artifact Evidence

| Artifact | Required evidence when future work uses this strategy |
|---|---|
| PLAN | Source inputs, acceptance criteria, validation classes affected, protected files, boundaries, module-dispatch evidence, command-output verification plan, and any Pi-assisted context/capsule/helper usage that materially shaped the plan. |
| APPLY notes / task results | Per-task PASS/PASS_WITH_CONCERNS/BLOCKED status, official verify command output, changed-file check, deviations, fallback/retry decisions, and post-task/post-apply module outputs. |
| SUMMARY | Acceptance-criteria results, actual changed files, validation command output, module reports, GitHub Flow state, deviations, decisions, helper-agent review results if used, and follow-on validation recommendations. |
| STATE | Current lifecycle position, loop state, current decisions, blockers/concerns, Git state, and session continuity only after workflow-owned writes. |
| ROADMAP | Phase status, completion notes, next-phase routing, and milestone progress without replacing SUMMARY detail. |
| Historical reports | Report freshness label and explicit note that current validation truth comes from command output, unless a future approved plan updates reports as part of classification work. |

## Phase 201 Handoff

Phase 201 should produce the final executable implementation-plan proposal only after applying these validation constraints:

- Name the validation class for every proposed build milestone and every changed check: Pi-Supported Runtime, Shared Invariant, Frozen Legacy Parity, Runtime Lens, Guided UI Safety, Helper Delegation, GitHub Flow Safety, or Artifact / Process.
- Propose Artifact-Slice Contract Hardening first unless this strategy or later evidence shows validation classification must precede any runtime-context change.
- Keep Guided Workflow Evidence Hardening early because explicit intent/no-auto-continue proof lowers risk before broader workflow/resource capsules.
- Keep Workflow/Resource Capsule Design after citation/fallback and blocking-semantics exclusion rules are explicit.
- Keep Delegated APPLY Packet/Report Compression after packet/report schema and allowed-file verification rules are explicit.
- Treat Pi-Native Validation Classification as either a dedicated early build milestone or an explicit prerequisite slice inside the first validation-script/report-changing milestone.
- Defer Legacy Retention and Install-Surface Cleanup until validation classification protects shared invariants and product approval is explicit.
- For every proposed milestone, include exact repo surfaces, protected files, validation commands, expected TAP/count evidence, module evidence, GitHub Flow evidence, and durable artifact writes.
- Exclude hidden Pi state, telemetry, auto-approval, auto-continue, helper-owned APPLY, merge-gate bypass, lifecycle ledgers, dependency additions, and unclassified legacy cleanup from the first build proposal.

## Validation Readiness Checklist

A future workstream is ready to enter a build milestone only when all applicable items are true:

- [ ] Source inputs and repo surfaces are named precisely enough for a bounded PLAN.
- [ ] The workstream's validation class or classes are explicit.
- [ ] Protected files and scope limits are explicit.
- [ ] Acceptance criteria preserve `.paul/*` authority, PLAN/APPLY/UNIFY ownership, module evidence, GitHub Flow gates, parent-owned APPLY, explicit approvals/checkpoints, and full-read fallback.
- [ ] Runtime assistance remains derived, bounded, disposable, source-cited, freshness-aware where needed, and backed by full authoritative reads.
- [ ] Guided UI behavior, if touched, creates explicit canonical transcript/artifact evidence and cannot auto-approve, auto-continue, skip checkpoints, or merge.
- [ ] Helper-agent work, if touched, remains parent-packeted, parent-verified, file-scoped, fallback-safe, and forbidden from lifecycle ownership.
- [ ] Validation commands and expected evidence are named before implementation begins.
- [ ] Shared invariants remain protected before any parity-only check or frozen legacy surface is weakened.
- [ ] Historical validation reports are either explicitly treated as stale examples or updated by an approved validation-classification plan.
- [ ] No hidden Pi state, telemetry, UI-only decision, helper-owned APPLY, merge-gate bypass, lifecycle ledger, or Pi-owned validation pass signal is introduced.

## Phase 200 Conclusion

Validation strategy should move toward Pi-supported runtime proof plus shared invariant protection, while clearly labeling frozen legacy parity. Phase 201 can now propose executable implementation milestones with explicit command-output evidence, durable artifact evidence, and class-specific risk gates instead of treating validation as an undifferentiated parity suite.
