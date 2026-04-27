# Pi-Native Artifact-Slice Contract

## Status

| Field | Value |
|---|---|
| Milestone | v2.47 Artifact-Slice Contract Hardening |
| Phase | 202 — Slice Inventory + Contract Baseline |
| Artifact status | Contract baseline for Phase 203+ implementation |
| Implementation status | No runtime, workflow, validation-script, dependency, GitHub Flow, installed-runtime, report, or legacy-surface changes are approved by this artifact |

## Purpose

This document defines the artifact-slice contract that v2.47 implementation work must harden before broader Pi-native context surfaces are built. It converts the Phase 195 spike and v2.46 implementation-planning outputs into a stable baseline for slice names, schema fields, freshness and bounds rules, fallback requirements, validation evidence, and authority boundaries.

The contract is intentionally conservative. Artifact slices may reduce repeated orientation context, but they remain derived aids over authoritative markdown and command evidence. They do not replace `.paul/*`, installed workflow resources, module-dispatch evidence, GitHub Flow command evidence, validation output, explicit user replies, or parent-owned APPLY verification.

## Contract-Baseline Boundary

Phase 202 may define the contract that later phases implement, but it does not authorize edits to:

- Pi extension runtime behavior, installed extension copies, installer behavior, or generated runtime outputs.
- Kernel workflow semantics, module source behavior, or installed module registry behavior.
- Validation scripts, validation reports, dependency manifests, CI configuration, or GitHub Flow automation.
- Claude Code wrappers, Agent SDK surfaces, portability docs, or other frozen legacy surfaces.
- `.paul/*` lifecycle authority, PLAN/APPLY/UNIFY ownership, module evidence, GitHub Flow gates, parent-owned APPLY, explicit approval/checkpoint behavior, archive authority, or full-read fallback.

## Source Inputs

| Source | Evidence used | Contract implication |
|---|---|---|
| `.paul/phases/195-exploratory-pi-native-spikes/195-01-SUMMARY.md` | Phase 195 proved activation-gated, read-only artifact slices for `.paul/STATE.md`, `.paul/ROADMAP.md`, and discoverable current PLAN artifacts with source citations, freshness markers, fallback language, and structural validation. | Preserve the proven spike contract and generalize it only through named slices with explicit bounds and validation. |
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Phase 194 defined read tiers, context-cost surfaces, citation rules, full-read requirements, rejected hidden-state designs, and validation classes for runtime lenses. | Every slice must cite sources, mark freshness where facts change, stay disposable, and require full reads for lifecycle-changing decisions. |
| `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Phase 196 promoted activation-gated artifact-slice loading as the first implementation-grade Pi-native context-efficiency pattern. | Artifact slices are the foundation for later capsules, guided UI evidence, helper packets, validation classification, and legacy cleanup. |
| `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md` | Phase 198 classified Artifact-Slice Contract Hardening as implementation-ready and listed expected outputs: named slice inventory, stable schema, docs, and validation markers. | Phase 202 must settle inventory, schema, docs/evidence requirements, and guardrails before runtime work begins. |
| `docs/PI-NATIVE-SEQUENCING-DEPENDENCY-PLAN.md` | Phase 199 recommended artifact slices first and identified risk gates: block hidden state, missing citations, missing freshness, or full-read replacement. | This contract defines those gates as implementation blockers for Phase 203+. |
| `docs/PI-NATIVE-VALIDATION-EVIDENCE-STRATEGY.md` | Phase 200 made command output validation truth and required marker checks plus Pi/cross-harness validation for artifact-slice hardening. | Runtime implementation must preserve marker output, TAP counts, durable SUMMARY evidence, and shared-invariant validation. |
| `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` | Phase 201 recommended Artifact-Slice Contract Hardening first and named likely repo surfaces and protected boundaries. | Phase 203 should target repo source surfaces only after this contract defines entry conditions and non-goals. |
| `.paul/phases/201-final-implementation-plan-proposal/201-01-SUMMARY.md` | Phase 201 UNIFY recorded the decision to harden artifact slices before guided workflow evidence, capsules, helper compression, validation classification, or legacy cleanup. | This contract keeps those deferrals explicit and prevents scope creep in the first build milestone. |

## Settled Decisions

| Decision | Contract consequence |
|---|---|
| Pi is the supported runtime for new context-efficiency work. | Artifact-slice hardening optimizes for Pi runtime behavior and evidence while preserving shared lifecycle invariants. |
| `.paul/*` artifacts remain lifecycle truth. | Slices may quote or summarize `.paul/*`, but no slice owns lifecycle state, phase transitions, decisions, approvals, validation status, or module outcomes. |
| Artifact slices are derived, bounded, disposable, source-cited, freshness-aware aids. | Slice output must include source paths, slice labels, freshness markers where facts can change, bounds, fallback language, and non-authority language. |
| Command output remains validation truth. | Pi summaries, reports, slices, capsules, helper reports, and historical reports cannot mark validation green without fresh command output. |
| Full authoritative reads remain mandatory for consequential work. | Edits, lifecycle writes, approved PLAN execution, GitHub Flow gates, stale/ambiguous/contested facts, and decisions require full markdown or command reads. |
| Legacy cleanup remains deferred. | This contract must not delete, weaken, archive, or reclassify frozen Claude Code / Agent SDK / portability / parity surfaces. |

## Non-Negotiable Authority Boundaries

Artifact-slice implementations derived from this contract must preserve these boundaries as acceptance criteria:

- `.paul/*` artifacts remain lifecycle truth; no hidden Pi state, telemetry-owned context, local memory, widget state, helper transcript, or UI selection becomes authoritative.
- PLAN/APPLY/UNIFY remains the lifecycle loop; PLAN defines approved work, APPLY executes and verifies under parent control, and UNIFY reconciles durable artifacts.
- Installed `modules.yaml`, `[dispatch] ...` lines, PLAN/SUMMARY/STATE reports, and validation command output remain module and quality evidence; Pi must not create a separate module ledger.
- GitHub Flow gates remain workflow- and command-evidence-backed; Pi may surface branch/PR/CI status only as a derived aid and must not bypass branch creation, base sync, CI, review, merge, or cleanup gates.
- Parent APPLY owns helper eligibility, official verification, fallback judgment, checkpoints, module enforcement, task result classification, and `.paul/*` lifecycle writes.
- Full authoritative reads remain required for edits, approved PLAN execution, lifecycle writes, GitHub Flow gates, stale or contested facts, ambiguity, and decisions that change lifecycle state.
- Explicit approval and checkpoint behavior must stay transcript- or artifact-visible; UI-only decisions, auto-approval, auto-continue, skipped checkpoints, and inferred merge intent are not allowed.

## Phase 202 Output Boundary

This contract is a planning/evidence artifact for the first v2.47 build milestone. It does not by itself change Pi runtime behavior or prove Phase 203 implementation complete. Phase 203 must still create its own approved PLAN, run parent-owned APPLY, preserve module evidence, verify command output, use GitHub Flow gates, and reconcile results through UNIFY.

## Named Slice Inventory

The initial hardening target is a small inventory of high-value lifecycle slices. Phase 203 may implement all or a subset, but each implemented slice must follow the schema in this document.

| Slice | Source authority | Intended use | Freshness requirement | Full-read fallback |
|---|---|---|---|---|
| `current-lifecycle-state` | `.paul/STATE.md` | Orient the model to milestone, phase, plan, loop marks, next action, blockers, and current decisions after explicit PALS activation. | Required; STATE can change during planning, APPLY, UNIFY, resume, and merge gates. | Required before lifecycle writes, resume conflicts, approvals, or decisions. |
| `active-roadmap-phase` | `.paul/ROADMAP.md` | Show current milestone table row, target phase focus, and near-future phase routing without reading completed-history archives. | Required; ROADMAP changes during phase and milestone transitions. | Required before changing phase status, adding phases, or interpreting ambiguous routing. |
| `approved-plan-task-packet` | `.paul/phases/**/{plan}-PLAN.md` | Surface approved task names, files, verification commands, acceptance criteria, and boundaries during APPLY orientation. | Required; plan approval and task status can change across sessions. | Always required before executing approved PLAN tasks or editing files. |
| `recent-summary-decisions` | `.paul/phases/**/{plan}-SUMMARY.md` | Summarize recent decisions, deviations, validation baseline, and follow-on recommendations when they are a direct input to new planning. | Required when summary is used for current routing or implementation decisions. | Required when decisions are contested, stale, or used to change scope. |
| `module-evidence-baseline` | Installed `modules.yaml`, PLAN `<module_dispatch>`, SUMMARY `Module Execution Reports`, `.paul/QUALITY-HISTORY.md`, `.paul/CODI-HISTORY.md` | Orient the model to active hook evidence, recent validation counts, and module persistence without inventing a Pi module ledger. | Required; module evidence and validation counts change per loop. | Required before marking hooks complete, classifying validation, or reconciling UNIFY evidence. |

## Slice Output Schema

Every slice output must include these fields or equivalent labels:

| Field | Required content | Notes |
|---|---|---|
| `Slice` | Stable slice name from the inventory. | Use explicit names; avoid ad hoc unnamed blobs. |
| `Source` | Repo-relative authoritative path(s), and command name when the fact is command-derived. | Use paths like `.paul/STATE.md`, not installed/runtime absolutes unless the source is an installed resource. |
| `Freshness` | When the source was read or a clear freshness phrase such as `fresh at injection time`; include staleness warning for volatile facts. | Required for STATE, ROADMAP, PLAN, SUMMARY, module evidence, git/PR/CI, and validation facts. |
| `Bounds` | Size or scope bound, such as line cap, section cap, item cap, or named-field cap. | A slice must be intentionally shallow and deduplicated. |
| `Content` | The bounded excerpt, table, or summary. | Must be derived from the cited source only; do not infer missing facts. |
| `Fallback` | Full-read rule naming when to read the authoritative source. | Must be explicit enough for a future model to know when the slice is insufficient. |
| `Authority` | Non-authority language: the slice or Pi output is derived and cannot replace lifecycle artifacts or command output. | Required for any slice used in PLAN/APPLY/UNIFY context. |

Minimum textual markers for implementation and validation are `Slice:`, `Source:`, `Freshness:`, `Bounds:`, `Fallback:`, and a non-authority phrase such as `Derived aid only`.

## Freshness and Bounds

Freshness and bounds are part of the safety contract, not presentation polish.

| Source category | Freshness rule | Suggested bound |
|---|---|---|
| STATE current position and loop state | Mark fresh at read/injection time and warn that STATE must be reread before lifecycle writes. | Current Position + Loop Position + Session Continuity next action, capped to the fields needed for routing. |
| ROADMAP current milestone/phase | Mark fresh at read/injection time and warn that ROADMAP must be reread before phase/milestone writes. | Current milestone table row plus target phase detail; no completed-history archive expansion. |
| Approved PLAN task packet | Mark fresh at read/injection time and warn that full PLAN is required before execution. | Current task names, files, AC links, verification commands, and boundaries; no broad plan rewrite. |
| Recent SUMMARY decisions | Mark source completion date when available and warn if STATE/ROADMAP is newer or conflicting. | Decisions/deviations/follow-on notes only; prefer one recent direct dependency. |
| Module and validation evidence | Mark source artifact date or command output time when known; warn that current command output is required for pass/fail. | Recent dispatch/report rows and TAP counts only; no Pi-owned ledger or pass signal. |

If freshness cannot be determined, the slice must say so and must recommend a full read before any consequential use.

## Full-Read Fallback Triggers

A slice is never sufficient for these actions:

- Editing a file or preparing anchored edits.
- Executing an approved PLAN task, including task files, acceptance criteria, boundaries, and verification commands.
- Writing `.paul/*` lifecycle artifacts, changing loop position, or reconciling SUMMARY/STATE/ROADMAP.
- Resolving stale, ambiguous, missing, contested, or conflicting facts.
- Making or recording decisions that alter lifecycle state, milestone scope, support posture, or validation classification.
- Running or evaluating GitHub Flow gates, including branch creation, base sync, PR state, CI state, review readiness, merge, and cleanup.
- Marking validation green, module hooks complete, APPLY complete, or UNIFY complete.
- Deciding whether a helper-agent result is equivalent to parent inline APPLY.

## Acceptable Slice Wording

Acceptable wording:

```text
Slice: current-lifecycle-state
Source: .paul/STATE.md
Freshness: fresh at PALS activation time; reread STATE before lifecycle writes.
Bounds: Current Position + Loop Position + Session Continuity only.
Content: Milestone v2.47; Phase 202; PLAN ✓ / APPLY ○ / UNIFY ○; next action is APPLY for 202-01.
Fallback: Full authoritative read of .paul/STATE.md is required before updates, decisions, or conflict resolution.
Authority: Derived aid only; .paul/STATE.md remains lifecycle truth.
```

Unacceptable wording:

```text
PALS is ready. Continue to APPLY.
```

The unacceptable example omits source, freshness, bounds, fallback, and non-authority language. It also risks turning a runtime summary into lifecycle routing authority.

## Schema Non-Goals

The schema does not define a permanent storage format, telemetry event, cache key, database record, separate validation report, helper-agent transcript schema, or Pi-owned lifecycle ledger. It defines visible runtime output expectations and validation markers for repo-source implementation work.

## Validation Classes

Phase 203 and later artifact-slice implementation plans must declare these validation classes before editing runtime files:

| Class | Required for artifact-slice hardening | Blocking posture |
|---|---|---|
| Runtime Lens | Any slice output, context injection, status lens, lifecycle widget/context payload, or bounded runtime summary. | Blocking: slices must be activation-gated, source-cited, freshness-aware, bounded, read-only, and fallback-safe. |
| Pi-Supported Runtime | Pi extension, Pi docs, skill-map, installer, or installed Pi runtime behavior changes. | Blocking for supported Pi behavior touched by implementation. |
| Shared Invariant | `.paul/*` authority, PLAN/APPLY/UNIFY, module evidence, GitHub Flow safety, parent-owned APPLY, approvals/checkpoints, archives, or full-read fallback. | Blocking until equivalent command evidence proves the invariant remains protected. |
| Artifact / Process | PLAN/SUMMARY/STATE/ROADMAP/docs/report/history changes that shape lifecycle truth or future implementation evidence. | Blocking for lifecycle writes and durable reconciliation. |
| Frozen Legacy Parity | Claude Code, Agent SDK, portability docs, or cross-driver parity surfaces. | Label before weakening; no cleanup is allowed in v2.47 slice hardening unless a later approved plan explicitly scopes validation classification. |

## Marker-Check Families

Runtime hardening must include marker checks for the families below. The exact commands may change by plan, but command output remains the evidence truth.

| Family | Required proof |
|---|---|
| Activation gating | Slice output is emitted only after explicit PALS activation such as `/paul-*` or `/skill:paul-*`; no ambient broad PALS injection for unrelated prompts. |
| Source citations | Every artifact-derived slice includes `Source:` or equivalent path citations to repo-local authoritative artifacts or command evidence. |
| Freshness markers | Volatile facts include `Freshness:` language or an equivalent timestamp/read-time phrase. |
| Bounds | Slice helpers define explicit item, line, section, or byte/character limits and avoid completed-history expansion. |
| Fallback language | Output includes `Fallback:` language requiring full authoritative reads for edits, lifecycle decisions, stale/contested facts, GitHub Flow gates, and validation pass/fail. |
| Read-only behavior | Slice helpers do not write `.paul/*`, generated runtime files, validation reports, caches, telemetry, or lifecycle ledgers. |
| No hidden persistence | Runtime assistance remains disposable and transcript-visible; no hidden Pi memory becomes source of truth. |
| No authority replacement | Slices cannot mark validation, module dispatch, GitHub Flow, APPLY, or UNIFY complete without workflow and command evidence. |

## Command-Output Evidence

Future APPLY/UNIFY phases that implement this contract must preserve reviewer-auditable command output:

- Marker greps over changed runtime/docs/validation files showing schema, fallback, source, freshness, bounds, read-only/no-hidden-state, and activation-gating markers.
- `bash tests/pi-end-to-end-validation.sh` output with TAP summary counts and final pass/fail status; Phase 200/201/202 baseline is 186/186 before any new Phase 203 checks.
- `bash tests/cross-harness-validation.sh` output with TAP summary counts and final pass/fail status; current baseline is 100/100 for shared invariants.
- `git diff --stat` and changed-file review proving work stayed inside approved repo-source surfaces.
- GitHub Flow evidence during UNIFY: current branch, base branch, ahead/behind state, PR URL/state, CI/check state, and merge-gate result.
- Module evidence in PLAN/SUMMARY, including `[dispatch] ...` lines and WALT/TODD validation outcomes.
- If validation counts change, SUMMARY must state old count, new count, reason, validation class affected, and shared-invariant preservation rationale.

Pi summaries, reports, slices, capsules, helper reports, and historical reports may explain results, but they cannot replace current command output.

## Failure Conditions

Phase 203+ implementation must block or re-plan if any of these occur:

- A slice omits source citation for an artifact-derived claim.
- A slice presents volatile STATE/ROADMAP/PLAN/SUMMARY/git/validation facts without freshness or staleness language.
- Slice output has no explicit bounds or can expand completed history unboundedly.
- Runtime code writes `.paul/*`, creates hidden persistence, stores telemetry-owned context, or creates a Pi-owned lifecycle/module/validation ledger.
- Slice text implies it can replace full reads for edits, lifecycle writes, approved PLAN execution, GitHub Flow gates, stale/ambiguous/contested facts, or decisions.
- Validation summaries or runtime UI imply pass/fail without command output.
- Implementation broadens into workflow/resource capsules, guided workflow semantics, helper packet/report compression, validation classification, legacy cleanup, dependency additions, CI configuration, or install-surface cleanup without a new approved plan.

## Phase 203 Handoff

Recommended Phase 203 framing:

| Field | Handoff |
|---|---|
| Goal | Harden repo-source Pi runtime artifact-slice behavior against this contract. |
| Likely repo surfaces | `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, `tests/pi-end-to-end-validation.sh` if validation markers are explicitly scoped. |
| Protected files | Installed runtime copies outside the repo, `.paul/*` lifecycle artifacts except normal PLAN/APPLY/UNIFY writes, validation reports unless explicitly scoped, dependency manifests, CI config, legacy drivers, Claude Code wrappers, Agent SDK surfaces, portability docs. |
| Entry conditions | Approved Phase 203 PLAN cites this contract, names implemented slices, declares validation classes, lists protected files, and defines marker commands before runtime edits begin. |
| Required validation | Marker greps, Pi validation, cross-harness validation, changed-file diff review, module reports, and GitHub Flow PR/CI evidence. |
| Explicit deferrals | Workflow/resource capsules, guided workflow evidence, delegated APPLY packet/report compression, validation classification, legacy retention/removal, dependency additions, CI changes, telemetry, hidden state, auto-approval, helper-owned APPLY, and merge-gate bypass. |

## Durable Evidence Requirements

- PLAN must cite this contract, list implemented slice names, validation classes, repo surfaces, protected files, fallback triggers, non-goals, module-dispatch evidence, and verification commands.
- APPLY must preserve per-task marker output, official verification, changed-file checks, deviations, retries, fallback decisions, and post-task/post-apply module results.
- SUMMARY must reconcile acceptance criteria, actual changed files, validation output, module reports, git/PR state, decisions, deviations, and follow-on recommendations.
- STATE and ROADMAP may be updated only by normal lifecycle workflows after APPLY/UNIFY, not by runtime slice helpers.
- Module histories and quality history remain durable evidence for hook outcomes and validation deltas.

## Conclusion

The artifact-slice contract is ready for implementation only when later plans treat it as a constraint, not as runtime authorization. The safe path is: define the contract here, harden the existing Pi slice behavior next, preserve full-read fallback and command-output validation truth, and defer broader context surfaces until their own proof and authority boundaries are explicit.
