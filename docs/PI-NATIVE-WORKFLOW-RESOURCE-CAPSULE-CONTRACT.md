# Pi-Native Workflow/Resource Capsule Contract

## Status

| Field | Value |
|---|---|
| Milestone | v2.49 Workflow/Resource Capsule Contract |
| Phase | 210 — Workflow/Resource Capsule Contract Baseline |
| Artifact status | Contract baseline for Phase 211+ runtime/docs/validation hardening |
| Implementation status | No runtime capsule loading, validation-script change, dependency change, CI change, helper-compression change, legacy cleanup, GitHub Flow automation change, or lifecycle-authority change is approved by this artifact |

## Purpose

This document defines the workflow/resource capsule contract for future Pi-native context-efficiency work. A workflow/resource capsule is a short, installed-resource-oriented aid that helps a model or reviewer remember stable process/resource shape without repeatedly loading entire installed workflow, reference, template, rule, or module-resource files.

Capsules are deliberately narrower than authoritative workflow reads. They may orient the reader to stable installed resources such as PLAN task anatomy, checkpoint prompt categories, module-dispatch evidence conventions, and GitHub Flow preflight/postflight reminders, but they cannot replace the installed resource, `.paul/*` lifecycle artifacts, command output, module evidence, PR/CI evidence, or transcript-visible user intent.

## Contract-Baseline Boundary

Phase 210 creates this contract only. It does not implement capsule generation or loading, alter Pi runtime behavior, update validation scripts, change installed runtime copies, revise kernel workflow semantics, add dependencies, modify CI, compress delegated APPLY packets/reports, classify broad validation suites, clean legacy surfaces, or change lifecycle authority.

Later phases must still use normal PALS lifecycle controls: approved PLAN, parent-owned APPLY, official verification commands, module dispatch evidence, GitHub Flow gates when enabled, UNIFY reconciliation, and `.paul/*` lifecycle writes.

## Source Inputs

| Source | Evidence used | Contract implication |
|---|---|---|
| `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` | Recommends Workflow/Resource Capsule Contract after artifact-slice hardening and guided workflow evidence; requires capsule eligibility rules, installed path citations, STOP/DO NOT SKIP/checkpoint/lifecycle/merge-gate exclusions, and full-read fallback. | This contract must define eligibility, schema, exclusions, validation classes, command evidence, and Phase 211+ handoffs before runtime work. |
| `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md` | Defines the proven slice schema fields (`Slice`, `Source`, `Freshness`, `Bounds`, `Content`, `Fallback`, `Authority`), `Derived aid only` language, source/freshness/bounds markers, full-read fallback triggers, and failure conditions. | Capsules reuse the citation/freshness/bounds/fallback/authority shape, adapted to installed resources and logical resource paths. |
| `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` | Protects canonical transcript replies, no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, no inferred merge intent, and command-output truth. | Capsules must not summarize guided decisions as authority or imply prompt/UI state can continue lifecycle work. |
| `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Promotes workflow/resource capsules later than artifact slices and says they must cite installed workflow/reference paths; capsules cannot replace full reads for blocking behavior, override paths, checkpoints, lifecycle writes, or merge gates. | Capsules may orient to stable process prose only when installed-resource citations and exclusions are explicit. |
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Classifies installed resource capsules as a read tier for repeated workflow/reference reminders; full authoritative reads remain required for decisions, edits, blocking behavior, and ambiguity. | The read model must distinguish orientation capsules from full installed-resource reads. |
| `docs/PI-NATIVE-SEQUENCING-DEPENDENCY-PLAN.md` | Places Workflow/Resource Capsule Design after stable citation/fallback proof and guided workflow evidence; blocks capsules if they hide STOP/DO NOT SKIP, overrides, checkpoints, lifecycle writes, module enforcement, or merge-gate semantics. | Runtime capsule loading is not ready until this contract names risk gates and marker-check families. |
| `docs/PI-NATIVE-VALIDATION-EVIDENCE-STRATEGY.md` | Requires marker checks proving citations and blocking-semantics exclusions, plus Pi and cross-harness validation; summaries cannot replace command output. | Later validation must prove capsule source citations, full-read fallback, exclusion language, and command-backed evidence. |
| `.paul/phases/209-evidence-reconciliation-milestone-closure/209-01-SUMMARY.md` | Handoff says v2.47 proved artifact-slice assistance, v2.48 proved guided workflow evidence, and next work should define workflow/resource capsules without replacing `.paul/*`, PLAN/APPLY/UNIFY, module evidence, GitHub Flow evidence, or command-output truth. | Phase 210 must preserve the v2.48 closure baseline and avoid reopening guided runtime behavior. |

## Installed Resource Inputs

These are eligible source families for later capsules only when the capsule output cites the installed/logical resource path and requires a full authoritative read before action:

| Installed/logical resource | Stable orientation content that may be capsule-eligible | Full-read authority remains |
|---|---|---|
| `kernel/workflows/plan-phase.md` | Planning posture, plan shape, source/context selection reminders, review-menu shape, and PLAN artifact output orientation. | Preconditions, module dispatch behavior, required state/ROADMAP updates, approval routing, and any exact STOP/required sequencing. |
| `kernel/workflows/apply-phase.md` | APPLY lifecycle shape, task execution anatomy, high-level module hook sequence, and GitHub Flow preflight/postflight names. | Explicit approval, checkpoints, required skills, task verification, module enforcement, file-scope checks, failure handling, APPLY completion, and lifecycle writes. |
| `kernel/workflows/unify-phase.md` | UNIFY reconciliation shape, SUMMARY sections, merge-gate step names, and transition routing orientation. | Merge gate execution, PR/CI/review/merge decisions, state/roadmap writes, transition execution, and post-unify persistence. |
| `kernel/workflows/resume-project.md` | Single-next-action routing shape, handoff lifecycle orientation, and git-aware status categories. | Current routing, handoff consumption, STATE trust decisions, git/PR status, and any resume action. |
| `kernel/references/module-dispatch.md` | Hook taxonomy, evidence-line convention, installed registry shape, and durable evidence destinations. | Actual module registry contents, hook dispatch, block/override handling, and module evidence persistence. |
| `kernel/references/checkpoints.md` | Checkpoint type taxonomy and prompt shape. | Checkpoint execution, user responses, human verification/action completion, and any decision recorded in STATE/SUMMARY. |
| `kernel/references/git-strategy.md` | Git workflow mode vocabulary, GitHub Flow phase names, preflight/postflight/merge-gate overview, and commit-point concepts. | Branch creation, base sync, PR creation, CI/review/merge gates, merge commands, cleanup, and git evidence. |
| `kernel/references/plan-format.md` | PLAN frontmatter, section inventory, task anatomy, acceptance-criteria shape, and boundary reminders. | Actual approved PLAN contents and any execution decision based on a plan. |
| `kernel/templates/PLAN.md` | Template labels and allowed task-type vocabulary. | Actual plan generation, plan validation, checkpoint placement, and approved plan execution. |

## Capsule Eligibility

A resource or content fragment is eligible for a workflow/resource capsule only when all conditions below are true:

1. **Installed-resource based:** The source is an installed or repo-source kernel/module resource such as a workflow, reference, template, rule, or module reference. Project lifecycle artifacts (`.paul/*`) are not workflow/resource capsule sources; they belong to artifact slices or full reads.
2. **Stable orientation content:** The capsule describes stable shape, vocabulary, section anatomy, or reminder-level sequencing that is unlikely to change during a single lifecycle loop.
3. **Source-cited:** Every claim can point to a source path such as `kernel/workflows/apply-phase.md` or logical installed path such as `workflows/apply-phase.md`.
4. **Bounded:** The capsule is shallow, deduplicated, and intentionally smaller than the source. It must never expand whole workflow sections or copied STOP/required prose into a parallel workflow.
5. **Fallback-safe:** The capsule explicitly states when the full installed resource or project artifact must be read.
6. **Derived aid only:** The capsule includes non-authority language that prevents it from being used as a lifecycle decision, validation result, module result, GitHub Flow result, approval, or checkpoint completion.
7. **Validation-ready:** Later runtime/docs/validation work can prove the capsule has source citations, bounds, fallback, and blocking-semantics exclusions with marker checks and validation output.

### Capsule-eligible examples

| Capsule candidate | Eligible orientation | Required source citation |
|---|---|---|
| `plan-task-anatomy` | PLAN sections, task fields (`files`, `action`, `verify`, `done`), and BDD acceptance-criteria shape. | `kernel/references/plan-format.md`, `kernel/templates/PLAN.md` |
| `apply-task-loop-orientation` | APPLY runs tasks in order, runs official verification, records PASS/PASS_WITH_CONCERNS/BLOCKED, and checks changed files. | `kernel/workflows/apply-phase.md` |
| `checkpoint-type-orientation` | `checkpoint:human-verify`, `checkpoint:decision`, and `checkpoint:human-action` vocabulary and prompt shape. | `kernel/references/checkpoints.md` |
| `module-dispatch-evidence-orientation` | Hook names, advisory vs enforcement taxonomy, `[dispatch] ...` evidence-line convention, and SUMMARY evidence destination. | `kernel/references/module-dispatch.md` |
| `github-flow-phase-orientation` | Names of APPLY preflight/postflight and UNIFY merge-gate responsibilities at reminder level. | `kernel/references/git-strategy.md` |
| `resume-single-next-action-orientation` | Resume should surface exactly one next action after reading STATE and git status. | `kernel/workflows/resume-project.md` |

## Ineligible Resource and Content Categories

The following must not be treated as workflow/resource capsule authority:

| Category | Why ineligible as capsule authority | Required handling |
|---|---|---|
| `.paul/*` lifecycle truth (`STATE.md`, `ROADMAP.md`, `PROJECT.md`, PLAN, SUMMARY, handoffs, archives) | These are live project/lifecycle artifacts, not installed resource prose; they can change during PLAN/APPLY/UNIFY. | Use full reads or separately contracted artifact slices with freshness/fallback; write only through workflows. |
| Command output, validation pass/fail, TAP counts, dependency audits, git/gh output, PR/CI state | Current command output is evidence truth and can become stale immediately. | Run/read commands directly and preserve output in APPLY/UNIFY/SUMMARY. |
| PLAN/APPLY/UNIFY loop state or task status | Lifecycle state belongs to `.paul/*` and parent workflow judgment. | Read STATE/PLAN/SUMMARY and workflow output; do not infer from capsules. |
| Module hook results or enforcement outcomes | Installed `modules.yaml`, `[dispatch] ...` lines, and Module Execution Reports are evidence. | Read registry and durable reports; run hooks through lifecycle workflows. |
| Explicit approvals, checkpoint responses, UI decisions, merge intent | User intent must be transcript-visible or artifact-recorded. | Require canonical replies and workflow processing. |
| GitHub Flow gates, branch/base/PR/CI/review/merge/cleanup status | Safety-critical and command-evidence-backed. | Use git/gh commands and full workflow gate reads. |
| STOP, DO NOT SKIP, override/fix/stop paths, blocking errors | Summaries can omit required blocking semantics. | Full authoritative workflow/reference read is mandatory. |
| Stale, ambiguous, contested, conflicting, or missing facts | Capsule output is derived and may be incomplete. | Reread authoritative source and record discrepancies. |
| Runtime behavior claims not proven by current code/validation | Phase 210 does not implement runtime capsule loading. | Treat as future handoff only until Phase 211+ validates behavior. |

## Capsule Output Schema

Every workflow/resource capsule must expose these fields or equivalent labels. The field names are stable markers for Phase 211+ runtime and validation work.

| Field | Required content | Notes |
|---|---|---|
| `Capsule` | Stable capsule name, e.g. `module-dispatch-evidence-orientation`. | No unnamed prose blobs. |
| `Source` | Installed/logical source path and, when available, repo-source path. | Use paths like `kernel/workflows/apply-phase.md` or logical installed paths like `workflows/apply-phase.md`; avoid hidden absolute install-root paths in user-facing output. |
| `Source type` | One of `workflow`, `reference`, `template`, `rule`, `module-resource`, or `mixed-installed-resource`. | Helps validation classify capsule origin. |
| `Freshness` | When the resource was read/generated or a clear phrase such as `fresh at capsule generation time`; include staleness warnings if generated from installed resources that may be updated. | Required even for stable resources because installs can be regenerated. |
| `Bounds` | Line, section, item, token/character, or named-topic cap. | Must prove the capsule is bounded and not a workflow replacement. |
| `Content` | Stable orientation content derived only from cited installed resources. | No new workflow semantics, no inferred lifecycle state, no command results. |
| `Fallback` | Exact full-read rule naming when to read the installed resource, project artifact, or command output. | Must mention full authoritative read before action when blocking semantics or lifecycle decisions are involved. |
| `Authority` | Non-authority statement, including the phrase `Derived aid only`. | Required marker: capsule is not lifecycle, module, validation, approval, checkpoint, or GitHub Flow authority. |

Minimum textual markers for later validation are `Capsule:`, `Source:`, `Source type:`, `Freshness:`, `Bounds:`, `Fallback:`, and `Derived aid only`.

## Installed Resource Citations

Capsules must cite both the logical resource identity and the source path a reviewer can open. Acceptable citation examples:

```text
Capsule: checkpoint-type-orientation
Source: kernel/references/checkpoints.md (logical installed resource: references/checkpoints.md)
Source type: reference
Freshness: fresh at capsule generation time; regenerate after driver/resource install changes.
Bounds: checkpoint type names + prompt-shape summary only; no execution protocol replacement.
Content: checkpoint:human-verify confirms completed automated work; checkpoint:decision presents options; checkpoint:human-action is rare and only for no-CLI/API actions.
Fallback: Full authoritative read of kernel/references/checkpoints.md and the active PLAN is mandatory before handling a checkpoint or continuing APPLY.
Authority: Derived aid only; checkpoint prompts remain blocking until the workflow receives a valid user response.
```

```text
Capsule: module-dispatch-evidence-orientation
Source: kernel/references/module-dispatch.md (logical installed resource: references/module-dispatch.md)
Source type: reference
Freshness: fresh at capsule generation time; installed modules.yaml can differ by runtime install.
Bounds: hook names, evidence-line convention, and destination reminders only.
Content: lifecycle hooks emit visible [dispatch] lines; advisory hooks annotate, enforcement hooks can block; UNIFY persists post-unify reports in SUMMARY.
Fallback: Full authoritative read of installed modules.yaml, kernel/references/module-dispatch.md, PLAN, and SUMMARY is mandatory before dispatching hooks or judging module evidence.
Authority: Derived aid only; capsules do not fire hooks, classify blocks, or persist module reports.
```

Unacceptable capsule output:

```text
APPLY can continue. Modules passed. Merge is safe.
```

This is invalid because it has no source citation, freshness, bounds, fallback, or `Derived aid only` authority marker, and it converts orientation into lifecycle, module, and GitHub Flow authority.

## Blocking-Semantics Exclusions

Capsules may point to these topics, but they must not summarize them as final authority or use them to continue lifecycle work:

- STOP, HALT, BLOCKED, REQUIRED, MANDATORY, `DO NOT SKIP`, and equivalent blocking workflow semantics.
- Explicit plan approval, APPLY approval, human-verification approval, checkpoint decisions, and checkpoint human actions.
- PLAN/APPLY/UNIFY lifecycle writes to STATE, ROADMAP, PROJECT, PLAN, SUMMARY, handoffs, histories, or archives.
- Task verification, PASS/PASS_WITH_CONCERNS/BLOCKED task classification, retry/skip/stop choices, and file-scope diff checks.
- Module dispatch/enforcement, hook order, block/fix/override/stop handling, module reports, and installed `modules.yaml` contents.
- GitHub Flow branch creation, base sync, ahead/behind state, PR creation, CI checks, review gates, merge-gate routing, PR merge, base sync after merge, and branch cleanup.
- Validation pass/fail, TAP counts, quality baselines, dependency/security audit outcomes, lint/typecheck status, and current command-output evidence.
- APPLY completion, UNIFY completion, phase transitions, milestone transitions, and merge-gate completion.
- Override paths, ambiguity resolution, contested facts, stale source conflicts, and missing evidence.
- Runtime behavior claims for Phase 211+ until command-backed validation proves them.

If a capsule mentions one of these topics, it must state that a full authoritative read of the relevant installed workflow/reference and current project artifact or command output is mandatory before action.

## Full-Read Fallback Triggers

A workflow/resource capsule is never sufficient for these actions:

- Executing an approved PLAN task or editing any file.
- Reading task files, boundaries, acceptance criteria, verification commands, or done criteria before APPLY.
- Writing `.paul/*` lifecycle artifacts or changing loop/phase/milestone state.
- Handling a checkpoint, human approval, explicit decision, human action, or resume signal.
- Running, interpreting, or persisting module dispatch results.
- Evaluating GitHub Flow state, creating a branch/PR, checking CI/reviews, merging, syncing base, or cleaning branches.
- Marking validation green, interpreting test/lint/typecheck/audit output, or comparing quality baselines.
- Marking APPLY complete, UNIFY complete, phase complete, or milestone complete.
- Taking an override/fix/skip/stop path.
- Resolving stale, conflicting, ambiguous, missing, or contested capsule output.
- Making support-tier, validation-classification, legacy-retention, dependency, CI, or lifecycle-authority decisions.

Fallback language must be explicit, for example: `Fallback: Full authoritative read of kernel/workflows/apply-phase.md, the active PLAN, and current command output is mandatory before executing APPLY or marking task results.`

## Read Model

| Read tier | Use for | Example | Not enough for |
|---|---|---|---|
| Full authoritative read | Decisions, edits, task execution, blocking semantics, merge gates, lifecycle writes, ambiguity, or contested facts. | `read` the current PLAN; read `kernel/workflows/apply-phase.md`; run `gh pr checks`. | N/A — this is authority when fresh and source-backed. |
| Bounded artifact slice | Current project/lifecycle orientation from `.paul/*` artifacts when separately contracted. | `current-lifecycle-state`, `approved-plan-task-packet`. | File edits, lifecycle writes, approved task execution, stale/conflicting facts. |
| Workflow/resource capsule | Stable installed-resource orientation. | `checkpoint-type-orientation`, `module-dispatch-evidence-orientation`. | STOP/DO NOT SKIP rules, checkpoint handling, module enforcement, GitHub Flow gates, validation results. |
| Runtime lens/status UI | Low-risk presentation of current state or recent activity. | Lifecycle widget, module activity lens, git status lens. | Lifecycle decisions, validation truth, merge approval, command evidence. |
| Command output | Current validation/git/audit truth. | TAP output, `git status`, `gh pr checks`. | Replacing `.paul/*` lifecycle writes or source artifacts. |

## Validation Classes

Phase 211+ plans that implement, surface, or validate workflow/resource capsules must declare applicable validation classes:

| Class | Required when | Blocking posture |
|---|---|---|
| Runtime Lens | Capsule generation/loading, context injection, resource summaries, module lenses, GitHub Flow lenses, or CARL/resource orientation changes. | Blocking: capsules must be source-cited, freshness-aware, bounded, disposable, read-only, fallback-safe, and explicitly non-authoritative. |
| Pi-Supported Runtime | `drivers/pi/extensions/pals-hooks.ts`, Pi docs, install surfaces, command routing, context payloads, or runtime hooks change. | Blocking for supported Pi behavior touched by implementation. |
| Shared Invariant | Capsule work could affect `.paul/*` authority, PLAN/APPLY/UNIFY, module evidence, parent-owned APPLY, checkpoints, explicit approvals, GitHub Flow safety, archives, or command-output truth. | Blocking until equivalent command evidence proves invariant preservation. |
| Guided UI Safety | Capsules appear adjacent to prompts, approvals, checkpoints, resume-next, continue-to-UNIFY, pause/stop, phase/milestone transition, or merge-gate UI. | Blocking for no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent. |
| GitHub Flow Safety | Capsules mention branch, base, PR, CI, review, merge, cleanup, or status routing. | Blocking for any GitHub Flow automation or surfacing change. |
| Artifact / Process | PLAN/SUMMARY/STATE/ROADMAP/docs/report/history evidence changes shape future lifecycle truth or planning evidence. | Blocking for durable artifacts and lifecycle writes. |
| Helper Delegation | Capsules feed delegated APPLY packet/report compression or helper result review. | Blocking if helper context could obscure parent-owned verification, file-scope checks, fallback, checkpoints, module enforcement, or `.paul/*` writes. |
| Frozen Legacy Parity | Capsule work touches Claude Code, Agent SDK, portability, cross-driver parity, or legacy install surfaces. | Label before weakening; no legacy cleanup is approved by this contract. |

## Marker-Check Families for Later Phases

Future runtime/docs/validation phases should add or preserve marker checks for these families:

| Surface | Marker family |
|---|---|
| `drivers/pi/extensions/pals-hooks.ts` | Capsule names; `Capsule:`, `Source:`, `Source type:`, `Freshness:`, `Bounds:`, `Fallback:`, `Derived aid only`; installed-resource citations; full-read fallback before action; no hidden persistence; no lifecycle authority. |
| `drivers/pi/extensions/README.md` | User-facing explanation that workflow/resource capsules orient only, cite installed resources, and cannot replace full reads for blocking semantics, lifecycle writes, checkpoints, GitHub Flow gates, module enforcement, validation pass/fail, APPLY completion, or UNIFY completion. |
| `drivers/pi/skill-map.md` | Command/skill/resource map explains capsules as adapter-side orientation aids over installed resources with full-read fallback. |
| `tests/pi-end-to-end-validation.sh` | Pi-Supported Runtime and Runtime Lens checks for capsule schema markers, source citations, freshness/bounds/fallback, no hidden state, and no authority replacement. |
| `tests/cross-harness-validation.sh` | Shared Invariant checks for STOP/DO NOT SKIP exclusion, checkpoint blocking, module evidence, GitHub Flow safety, parent-owned APPLY, `.paul/*` authority, and command-output truth. |
| SUMMARY/STATE/ROADMAP lifecycle artifacts | Durable evidence that any runtime/docs/validation count change is command-backed and reconciled during UNIFY. |

## Command-Output Evidence Requirements

Future APPLY/UNIFY phases that implement this contract must preserve reviewer-auditable command output:

- Focused marker greps showing capsule schema, installed-resource citations, `Source type`, `Derived aid only`, blocking-semantics exclusions, full-read fallback, validation classes, failure conditions, and phase handoffs.
- `bash tests/pi-end-to-end-validation.sh` output with TAP summary counts and final pass/fail status.
- `bash tests/cross-harness-validation.sh` output with TAP summary counts and final pass/fail status.
- `git diff --stat` and changed-file review proving work stayed inside approved repo-source surfaces.
- GitHub Flow evidence during UNIFY: branch, base, ahead/behind, PR URL/state, CI/check state, merge-gate result, and base sync/branch cleanup if applicable.
- Module dispatch evidence in PLAN/SUMMARY, including `[dispatch] ...` lines and WALT/TODD quality outcomes.
- Count reconciliation when validation totals change: old count, new count, reason, validation class affected, and shared-invariant preservation rationale.

Reports, widgets, capsules, slices, helper reports, and historical reports may explain command evidence, but they cannot replace current command output.

## Failure Conditions

Phase 211+ implementation or docs/validation surfacing must block or re-plan if any of these occur:

- A capsule omits installed/logical source citation for an installed-resource claim.
- A capsule omits `Source type`, freshness, bounds, fallback, or `Derived aid only` authority markers.
- Capsule content copies or rephrases blocking semantics in a way that hides STOP, DO NOT SKIP, MANDATORY, REQUIRED, checkpoint, approval, module enforcement, override, or merge-gate obligations.
- Capsule output implies it can execute APPLY, complete UNIFY, mark validation green, fire module hooks, approve a checkpoint, choose an override, merge a PR, or write lifecycle artifacts.
- Runtime code writes `.paul/*`, creates hidden persistence, stores telemetry-owned context, creates a Pi-owned lifecycle/module/validation ledger, or treats cached capsule content as truth.
- GitHub Flow status or validation pass/fail is summarized without current command output.
- Capsule work changes workflow semantics, validation scripts, dependency manifests, CI, delegated APPLY packet/report behavior, broad validation classification, legacy cleanup, install-surface behavior, or lifecycle authority without a separately approved plan.
- Fresh Pi and cross-harness validation are missing, failing, or summarized without TAP/command evidence.

## Explicit Deferrals

This contract defers the following work:

- Runtime capsule loading or context injection changes — Phase 211 owns this.
- Pi docs, skill-map, settings, and validation-marker surfacing beyond this baseline — Phase 212 owns this unless Phase 211 explicitly scopes a bounded subset.
- Evidence reconciliation, validation count updates, and milestone closure — Phase 213 owns this.
- Delegated APPLY packet/report compression.
- Broad Pi-native validation classification or parity weakening.
- Legacy retention, install-surface cleanup, Claude Code or Agent SDK support changes.
- Dependency additions, CI configuration, telemetry, hidden state, helper-owned APPLY, merge-gate automation, workflow semantic rewrites, or lifecycle-authority changes.

## Handoff Requirements

### Phase 211 — Runtime Capsule Loading Hardening

Phase 211 should harden repo-source Pi runtime capsule behavior against this contract without broad redesign:

- Define a small named capsule inventory, preferably starting with `plan-task-anatomy`, `checkpoint-type-orientation`, `module-dispatch-evidence-orientation`, and `github-flow-phase-orientation` only if bounded.
- Emit the stable output schema markers: `Capsule:`, `Source:`, `Source type:`, `Freshness:`, `Bounds:`, `Fallback:`, and `Derived aid only`.
- Cite installed/logical resource paths and avoid hidden absolute install-root paths in user-facing output.
- Prove capsules are activation-gated or otherwise only injected in explicit PALS contexts.
- Keep capsules read-only and disposable: no `.paul/*` writes, hidden persistence, telemetry, cache-as-truth, module ledger, validation ledger, or lifecycle ledger.
- Require full authoritative reads for approved PLAN execution, APPLY/UNIFY, lifecycle writes, checkpoints, module reports, GitHub Flow decisions, validation assessment, stale/conflicting output, and edits/actions based on capsule content.
- Preserve guided workflow evidence boundaries: no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent.

### Phase 212 — Documentation + Validation Surfacing

Phase 212 should make the contract user- and reviewer-visible:

- Update `drivers/pi/extensions/README.md` and `drivers/pi/skill-map.md` to explain workflow/resource capsules as installed-resource orientation aids only.
- Add marker checks in `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` for schema, citation, fallback, exclusion, validation-class, command-output-truth, and non-authority markers.
- Keep validation output command-backed and reconcile any count changes.
- Avoid turning docs/validation surfacing into runtime behavior changes beyond approved Phase 211 scope, delegated APPLY compression, broad validation classification, legacy cleanup, CI, dependencies, or lifecycle-authority changes.

### Phase 213 — Evidence Reconciliation + Milestone Closure

Phase 213 should reconcile actual v2.49 behavior against this baseline:

- SUMMARY records acceptance-criteria results, changed files, exact validation command output, module reports, GitHub Flow state, decisions, deviations, validation count changes, and remaining deferrals.
- STATE/ROADMAP/PROJECT update only through normal lifecycle writes.
- Milestone closure occurs only if workflow/resource capsules remain source-cited, bounded, freshness-aware, fallback-safe, read-only, and non-authoritative.
- Closure must explicitly confirm that capsules did not replace `.paul/*`, PLAN/APPLY/UNIFY, module evidence, GitHub Flow gates, checkpoint/approval blocking, parent-owned APPLY, or command-output validation truth.

## Acceptance Checklist for This Contract

- [x] Capsule Eligibility rules name eligible installed resource categories and ineligible content categories.
- [x] Capsule Output Schema includes `Capsule`, `Source`, `Source type`, `Freshness`, `Bounds`, `Content`, `Fallback`, and `Authority`.
- [x] Installed Resource Citations examples point back to full source files.
- [x] `Derived aid only` non-authority language is required.
- [x] STOP, DO NOT SKIP, checkpoint, lifecycle writes, module enforcement, GitHub Flow, validation pass/fail, APPLY completion, and UNIFY completion semantics are excluded from capsule authority.
- [x] Full authoritative read fallback triggers are explicit.
- [x] Runtime Lens, Pi-Supported Runtime, Shared Invariant, Guided UI Safety, GitHub Flow Safety, Artifact / Process, Helper Delegation, and Frozen Legacy Parity validation classes are named.
- [x] Failure Conditions and Phase 211, Phase 212, and Phase 213 handoffs are executable.
