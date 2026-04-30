# Pi-Native Validation Classification Contract

## Status

| Field | Value |
|---|---|
| Milestone | v2.51 Pi-Native Validation Classification |
| Baseline phase | 218 — Validation Classification Baseline |
| Artifact status | Final v2.51 closure contract for validation-suite classification, Phase 219 hardening, Phase 220 documentation/report surfacing, and Phase 221 evidence reconciliation |
| Implementation status | Phase 218 established the baseline contract with Pi 200/200 and cross-harness 116/116 command evidence and PR #133. Phase 219 hardened the validation suites with command-output-backed classification inventories, Pi 201/201 and cross-harness 117/117, and PR #134. Phase 220 surfaced the classification in docs/reports/Pi discovery only as non-authoritative context, with Pi 202/202 and cross-harness 118/118 and PR #135. Phase 221 closes v2.51 by adding one final closure guardrail per suite; expected final counts are Pi 202→203 and cross-harness 118→119. Runtime files, install surfaces, dependency manifests, CI config, GitHub Flow automation, legacy wrappers, cleanup scope, and lifecycle authority semantics remain unchanged. |

## Purpose and boundary

PALS must classify validation checks by support purpose before any check is weakened, relocated, archived, deleted, or treated as legacy-only. This contract turns the Phase 200 validation/evidence strategy into a v2.51 baseline for the current Pi and cross-harness validation suites.

Command-output truth remains authoritative: reports, widgets, summaries, helper reports, lenses, and this classification contract may explain validation posture, but they do not mark validation green by themselves. Fresh command output from focused marker checks, `bash tests/pi-end-to-end-validation.sh`, and `bash tests/cross-harness-validation.sh` remains the validation truth for APPLY/UNIFY.

Phase 218 was baseline-only; Phase 219 added explicit classification markers and local guardrails. Phase 220 updated docs/report surfaces so the model is discoverable, but reports, widgets, summaries, helper reports, and Pi surfaces remain non-authoritative. Phase 221 reconciles final v2.51 closure evidence while preserving the rule that fresh command output remains authoritative. Legacy Retention / Install-Surface Cleanup remains deferred until classification closure completes and separate product approval is explicit.

## Source inputs

| Source | Evidence used | Contract implication |
|---|---|---|
| `.paul/phases/218-validation-classification-baseline/218-01-PLAN.md` | Approved Phase 218 objective, acceptance criteria, suite-family minimums, scope boundaries, and verification commands. | This contract must cover taxonomy, current suite inventory, count-change reconciliation, no-cleanup preservation rules, and Phase 219 handoff while keeping validation scripts read-only. |
| `docs/PI-NATIVE-VALIDATION-EVIDENCE-STRATEGY.md` | Phase 200 validation principles, class taxonomy, current suite classification, preservation rules, and command-output evidence requirements. | Supplies the class names, blocking posture, command-output truth rule, and classify-before-weakening requirement. |
| `.paul/phases/217-evidence-reconciliation-milestone-closure/217-01-SUMMARY.md` | v2.50 closure baseline: Pi validation passed 200/200 and cross-harness validation passed 116/116. | Establishes the current command-output baseline that Phase 218 preserves and Phase 219 must reconcile against if counts change. |
| `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md` | Runtime Lens and Shared Invariant evidence for bounded artifact slices, source citations, fallback, and no hidden state. | Classification must preserve runtime-lens proof and shared-invariant coverage before any cleanup. |
| `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` | Guided UI Safety evidence for canonical replies, no auto-approval, no auto-continue, checkpoint blocking, and no UI-only lifecycle decisions. | Guided workflow checks remain safety evidence and cannot be treated as visual polish only. |
| `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md` | Runtime Lens evidence for capsules as derived aids with source/type/freshness/bounds/fallback and blocking-semantics exclusions. | Capsule checks remain runtime-lens and shared-invariant evidence until equivalent command proof exists. |
| `docs/PI-NATIVE-DELEGATED-APPLY-PACKET-REPORT-CONTRACT.md` | Helper Delegation evidence for parent-owned packets, structured reports, allowed/forbidden files, fallback triggers, parent verification, and no helper-owned lifecycle writes. | Helper delegation validation remains parent-verifiable command evidence, not helper-owned lifecycle authority. |
| `tests/pi-end-to-end-validation.sh` | Current Pi validation suite category families and TAP output. | Read-only Phase 218 input; Phase 219 may add explicit classification markers. |
| `tests/cross-harness-validation.sh` | Current cross-harness validation suite category families and TAP output. | Read-only Phase 218 input; Phase 219 may add explicit classification markers. |
| `.paul/phases/219-runtime-validation-suite-classification-hardening/219-01-SUMMARY.md` | Phase 219 command evidence: Pi validation passed 201/201 and cross-harness validation passed 117/117 after one localized classification guardrail per suite. | Establishes the hardened current command baseline that Phase 220 docs/report surfacing must cite without making reports authoritative. |
| `.paul/phases/218-validation-classification-baseline/218-01-SUMMARY.md` | Phase 218 command evidence: contract baseline created, Pi validation passed 200/200, cross-harness validation passed 116/116, and PR #133 evidence recorded. | Establishes the v2.51 baseline evidence chain without changing validation scripts. |
| `.paul/phases/220-documentation-report-surfacing/220-01-SUMMARY.md` | Phase 220 command evidence: docs/report surfacing remained non-authoritative, Pi validation passed 202/202, cross-harness validation passed 118/118, and PR #135 evidence recorded. | Establishes the closure-entry command baseline that Phase 221 must reconcile without making reports authoritative. |
| `docs/PI-VALIDATION-REPORT.md` and `docs/VALIDATION-REPORT.md` | Historical 2026-03-14 report artifacts with old counts. | Reports must be labeled archival/non-authoritative for current status and route readers to fresh suite commands plus this contract. |

## Validation class taxonomy

| Class | Purpose | Evidence | Blocking posture |
|---|---|---|---|
| Pi-Supported Runtime | Proves the supported Pi runtime, installer, skills, extension, manifests, lifecycle UI, and Pi discovery surfaces work as designed. | Pi installer output, installed skill/resource structure, extension command/hook behavior, driver manifest checks, Pi docs and discovery markers. | Blocking for Pi-native milestones that touch Pi runtime, installer, skill/resource deployment, extension behavior, driver manifests, or Pi-facing discovery. |
| Shared Invariant | Protects PALS lifecycle semantics independent of runtime. | `.paul/*` authority markers, PLAN/APPLY/UNIFY loop markers, module evidence, GitHub Flow safety, parent-owned APPLY, explicit approval/checkpoint rules, context-diet guardrails, archive/handoff traceability. | Blocking until a future approved plan intentionally relocates or retires the invariant with equivalent command evidence. |
| Frozen Legacy Parity | Preserves historical compatibility evidence for Claude Code, Agent SDK, and cross-harness install surfaces after the support-tier reset. | Claude Code wrapper parity, legacy installer parity, cross-harness file-count parity, historical portability docs, driver parity checks. | Non-authorizing by itself for new Pi behavior; do not weaken or delete until shared-invariant coverage is identified and product approval is explicit. |
| Runtime Lens | Proves Pi-derived context assistance remains bounded, cited, freshness-aware where facts can change, disposable, and backed by full authoritative reads. | Artifact-slice markers, workflow/resource capsule markers, source citations, freshness/bounds/fallback text, activation gating, no hidden persistence, full-read fallback. | Blocking for artifact-slice, capsule, module lens, GitHub Flow lens, CARL bootstrap, or context-injection changes. |
| Guided UI Safety | Proves Pi UI assistance cannot silently continue lifecycle work, approve work, satisfy checkpoints, or hide user intent. | Canonical transcript replies, explicit user action, checkpoint blocking, no auto-approval, no auto-continue, no UI-only lifecycle decisions, no inferred merge intent. | Blocking for guided workflow, checkpoint, approval, continue-to-UNIFY, or merge-gate UI changes. |
| Helper Delegation | Proves `pals-implementer` remains bounded, parent-packeted, file-scoped, fallback-safe, and parent-verifiable. | Parent-owned task packet fields, structured helper report fields, allowed/forbidden file scope, changed-file diff checks, fallback triggers, parent official verification, no helper-owned `.paul/*` lifecycle writes. | Blocking for helper-agent packet/report compression, delegated APPLY ergonomics, or helper-agent installation/contract changes. |
| GitHub Flow Safety | Proves branch, PR, CI, review, merge, base-sync, and branch-cleanup behavior remain workflow-owned and command-evidence-backed. | `git branch`, ahead/behind counts, `gh pr view`, `gh pr checks`, PR URL/state, CI status, merge-gate summaries, base sync and branch cleanup output. | Blocking for git status, route, PR, CI, merge-gate, or next-action automation changes. |
| Artifact / Process | Proves lifecycle artifacts, plans, summaries, validation reports, and process evidence remain reviewable, fresh, and subordinate to command output. | PLAN source inputs/boundaries, SUMMARY AC results, STATE/ROADMAP updates, Module Execution Reports, validation report freshness labels, historical-report disclaimers. | Blocking for lifecycle writes, validation reports, documentation artifacts that shape implementation planning, and evidence reconciliation phases. |

## Current command-output baseline

The v2.51 evidence chain starts with the Phase 218 baseline, then adds one localized guardrail per suite in each approved hardening/surfacing/closure step:

| Suite | Phase 218 baseline | Phase 219 hardening | Phase 220 surfacing | Phase 221 closure target | Source |
|---|---:|---:|---:|---:|---|
| `bash tests/pi-end-to-end-validation.sh` | 200/200 passing | 201/201 passing | 202/202 passing | 203/203 passing | `.paul/phases/218-validation-classification-baseline/218-01-SUMMARY.md`; `.paul/phases/219-runtime-validation-suite-classification-hardening/219-01-SUMMARY.md`; `.paul/phases/220-documentation-report-surfacing/220-01-SUMMARY.md` |
| `bash tests/cross-harness-validation.sh` | 116/116 passing | 117/117 passing | 118/118 passing | 119/119 passing | `.paul/phases/218-validation-classification-baseline/218-01-SUMMARY.md`; `.paul/phases/219-runtime-validation-suite-classification-hardening/219-01-SUMMARY.md`; `.paul/phases/220-documentation-report-surfacing/220-01-SUMMARY.md` |

These counts are not self-validating when copied into artifacts. Each APPLY/UNIFY must preserve fresh command output and reconcile count changes with class-aware rationale.

## Current suite classification inventory

The current suite families below are derived from the visible category sections in `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh`. Phase 218 does not edit those scripts; Phase 219 should add explicit markers or leave categories as read-only baseline evidence according to the `Phase 219 action` column.

### `tests/pi-end-to-end-validation.sh`

| Current suite family | Primary class | Secondary class | Preserve / future-use note | Phase 219 action |
|---|---|---|---|---|
| Installer Deployment | Pi-Supported Runtime | Shared Invariant | Preserve as blocking proof that the Pi installer deploys skills, kernel resources, generated `modules.yaml`, extension files, and helper-agent surfaces. | Add explicit classification markers near installer/deployment checks if script hardening touches this family. |
| Module Execution Evidence | Shared Invariant | Pi-Supported Runtime | Preserve as blocking proof that installed module metadata, hook refs, durable summary evidence, and helper boundary markers remain visible. | Add explicit Shared Invariant / Pi-Supported Runtime labels for module-evidence checks. |
| Skill Structural Validity | Pi-Supported Runtime | Shared Invariant | Preserve as active Pi runtime evidence for installed skill frontmatter, workflow references, and wrapper shape. | Add labels where structural skill checks protect current Pi runtime behavior. |
| Thin Wrapper Contract | Shared Invariant | Pi-Supported Runtime | Preserve because thin wrappers carry explicit approval, parent-owned APPLY, collaboration, resume routing, GitHub Flow status, and reconciliation semantics. | Add labels for lifecycle-invariant wrapper checks; do not treat as cosmetic wrapper parity. |
| Delegated APPLY / REV Boundaries | Helper Delegation | Shared Invariant | Preserve as blocking proof for bounded `pals-implementer`, parent authority, REV separation, and helper-agent install evidence. | Add Helper Delegation markers and keep parent-owned APPLY language command-checked. |
| Shared Workflow Prose Contract | Shared Invariant | Runtime Lens | Preserve targeted-read, review-menu, roadmap routing, and module-dispatch evidence markers that future capsules must not obscure. | Add Shared Invariant markers; leave prose-volume checks structural rather than exact-copy where possible. |
| Context-Diet Regression Guardrails | Shared Invariant | Runtime Lens | Preserve active-window budgets, archive pointers, duplicated GitHub Flow ceilings, and hot workflow/reference anti-regrowth budgets. | Add labels for guardrail checks that protect shared semantics and runtime-lens context cost. |
| CODI Plan-Phase Distribution | Shared Invariant | Helper Delegation | Preserve source-selector, safe-skip, instrumentation, and durable CODI evidence markers as module/helper evidence. | Add classification labels if CODI checks move or split; otherwise keep as read-only baseline evidence. |
| Extension Structural Validity | Pi-Supported Runtime | Runtime Lens / Guided UI Safety | Preserve command registration, lifecycle UI, context injection, artifact-slice markers, guided workflow detection, module visibility, and derived-only lifecycle widgets. | Add Pi-Supported Runtime labels, with Runtime Lens / Guided UI Safety labels for context and guided UI checks. |
| Driver Manifest Accuracy | Pi-Supported Runtime | Shared Invariant | Preserve declared Pi capabilities and installer target accuracy. | Add classification labels if manifest checks are reorganized. |
| Pi Discovery Surfaces | Pi-Supported Runtime | Runtime Lens / Helper Delegation | Preserve command/skill/workflow mapping, shortcuts, installation boundaries, helper-agent explanation, and live module visibility as derived-only behavior. | Add labels for Pi-facing discovery and helper/lens subfamilies. |
| Collaborative Planning Model | Shared Invariant | Guided UI Safety | Preserve collaboration defaults, exploratory/direct mode selection, and plan review menu visibility. | Add Shared Invariant / Guided UI Safety labels before any review-menu or planning-surface cleanup. |
| UX Readability & Color Enrichment | Pi-Supported Runtime | Guided UI Safety | Preserve when readability protects lifecycle clarity and explicit intent; treat pure visual polish as lower risk than checkpoint/approval evidence. | Label intent/readability checks; avoid upgrading purely cosmetic checks into lifecycle blockers without rationale. |

### `tests/cross-harness-validation.sh`

| Current suite family | Primary class | Secondary class | Preserve / future-use note | Phase 219 action |
|---|---|---|---|---|
| Installer Parity | Frozen Legacy Parity | Shared Invariant | Preserve carefully: file-count parity and Claude install behavior are frozen legacy evidence, while shared kernel/resource generation can still protect shared invariants. | Add labels that distinguish parity-only checks from shared-invariant install/resource checks. |
| Shared APPLY / REV Boundaries | Shared Invariant | Helper Delegation | Preserve because delegated APPLY guardrails, parent-owned APPLY, and REV separation protect semantics across runtimes. | Add Shared Invariant / Helper Delegation markers before any helper or review-routing cleanup. |
| Durable Module Evidence Path | Shared Invariant | Artifact / Process | Preserve durable workflow/template/spec/SUMMARY module evidence. | Add Artifact / Process labels where checks prove durable reporting rather than runtime behavior. |
| Portability Compliance | Shared Invariant | Frozen Legacy Parity | Preserve where checks prevent harness-specific kernel/module language; classify exact path assumptions before weakening. | Add labels separating active portability invariants from frozen parity assumptions. |
| Shared Collaborative Planning Model | Shared Invariant | Guided UI Safety | Preserve collaboration modes and review-menu semantics independent of runtime. | Add labels if planning UX checks are moved or merged. |
| Context-Diet Regression Guardrails | Shared Invariant | Runtime Lens | Preserve shared workflow ceilings, GitHub Flow markers, module-dispatch markers, delegated APPLY markers, and context-diet budgets. | Add labels that show which checks protect shared invariants versus runtime-lens context cost. |
| CODI Plan-Phase Distribution | Shared Invariant | Helper Delegation | Preserve CODI source-selector contracts, safe setup, and durable instrumentation across installed registries. | Add labels if CODI checks are split; otherwise leave as read-only baseline evidence. |
| Artifact Spec Compliance | Shared Invariant | Artifact / Process | Preserve STATE/PROJECT/ROADMAP structure, artifact-first contract, report freshness, validation evidence, and lifecycle artifact requirements. | Add Artifact / Process labels and keep command-output truth distinct from report text. |
| Driver Manifest Completeness | Frozen Legacy Parity | Shared Invariant | Treat cross-driver capability parity as frozen legacy evidence unless a check protects a current shared driver contract. | Add labels before weakening driver parity or driver-manifest completeness checks. |

Baseline counts were Pi validation passed 200/200 and cross-harness validation passed 116/116 at Phase 218; current closure-entry counts are Pi 202/202 and cross-harness 118/118 after Phase 220; Phase 221 may add only the approved final closure guardrails and must reconcile Pi 202→203 and cross-harness 118→119.

## Preservation rules

Future plans must apply these rules before changing validation checks, validation reports, support-tier surfaces, or cleanup scope:

1. Always classify before weakening, relocating, archiving, deleting, or treating checks as legacy-only.
2. Do not remove parity-only checks in the same step that first classifies them; retention/removal requires a later product/support-surface decision.
3. Do not weaken Shared Invariant checks without equivalent command evidence and explicit rationale.
4. Do not let stale validation reports, widgets, summaries, helper reports, or this contract replace command-output truth.
5. Do not combine broad validation cleanup with unrelated runtime, installer, helper-agent, GitHub Flow, dependency, CI, or lifecycle-authority changes.
6. Keep validation scripts read-only unless the approved plan explicitly scopes validation-suite classification hardening.
7. Keep Legacy Retention / Install-Surface Cleanup remains deferred until classification closure completes and separate product approval is explicit.

## Count-change reconciliation

When any future plan changes validation counts, moves checks, archives checks, deletes checks, or changes blocking posture, the PLAN and SUMMARY must record:

| Required field | Purpose |
|---|---|
| Old count | The prior command-output total for the affected suite or family. |
| New count | The new command-output total after the approved change. |
| Reason | Why the count or posture changed, tied to approved scope. |
| Validation class affected | The primary and secondary classes changed or preserved. |
| Shared-invariant preservation rationale | How `.paul/*`, PLAN/APPLY/UNIFY, module evidence, GitHub Flow safety, parent-owned APPLY, explicit approvals/checkpoints, artifact/process evidence, and command-output truth remain protected. |
| Command-output evidence | Fresh focused marker output and full validation output proving the new state. |
| Cleanup authorization | Product/support-surface approval when Frozen Legacy Parity or install-surface cleanup is involved. |

A count decrease is not automatically a regression, and a count increase is not automatically an improvement. The classification, rationale, and fresh command output decide whether the change is acceptable.

## Phase 219 handoff

Phase 219 should harden the validation suites against this baseline without reopening runtime behavior or legacy cleanup. Its bounded scope should be:

- add explicit classification markers or local guardrail checks to `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` only where they make existing validation purpose more reviewable;
- preserve the baseline families listed above unless an approved plan gives class-aware rationale;
- record old count, new count, reason, validation class affected, shared-invariant preservation rationale, and command-output evidence for any count change;
- keep reports and documentation surfacing for Phase 220 unless marker hardening needs a narrow contract citation;
- keep Legacy Retention / Install-Surface Cleanup deferred until Phase 219 completes and product approval is explicit.

## Phase 220 documentation/report surfacing boundary

Phase 220 may update README, Pi-facing docs, this contract, and historical validation reports so validation classification is easier to discover. That surfacing must preserve command-output truth: docs/reports/widgets/summaries/helper reports/Pi surfaces may cite Pi 201/201 and cross-harness 117/117 as the current Phase 219 command baseline, but they do not mark validation green and must point to fresh `bash tests/pi-end-to-end-validation.sh` and `bash tests/cross-harness-validation.sh` output for current pass/fail status.

Any Phase 220 validation count change must be bounded to documentation/report surfacing guardrails only, with explicit reconciliation. The planned surfacing guardrails are Pi 201→202 and cross-harness 117→118; no validation cleanup, runtime behavior change, installer change, dependency change, CI change, GitHub Flow change, helper delegation change, or lifecycle-authority change is authorized.

## Phase 221 v2.51 closure evidence reconciliation

Phase 221 closes v2.51 by reconciling the complete evidence chain from Phase 218 through Phase 220 and adding exactly one final closure guardrail to each validation suite. This closure is evidence reconciliation only: it does not weaken, delete, relocate, archive, or treat any check as legacy-only, and it does not start Legacy Retention / Install-Surface Cleanup.

Final v2.51 closure evidence requirements:

| Phase | Evidence | Validation counts | PR evidence | Closure implication |
|---|---|---:|---|---|
| Phase 218 | Validation classification contract baseline created from the Phase 200 taxonomy and v2.50 closure evidence. | Pi 200/200; cross-harness 116/116 | PR #133 | Establishes classify-before-cleanup, command-output truth, no-cleanup preservation rules, and count-change reconciliation requirements. |
| Phase 219 | Validation-suite inventory markers and one localized classification guardrail per suite. | Pi 201/201; cross-harness 117/117 | PR #134 | Hardens Shared Invariant, Artifact / Process, Helper Delegation, Runtime Lens, and Pi-Supported Runtime markers without changing runtime or cleanup semantics. |
| Phase 220 | README, Pi docs, skill map, contract, and historical report surfacing with non-authority notices. | Pi 202/202; cross-harness 118/118 | PR #135 | Makes classification discoverable while preserving command-output truth and routing current pass/fail proof to fresh validation commands. |
| Phase 221 | Final v2.51 closure markers and count reconciliation guardrails. | Pi 202→203; cross-harness 118→119 | Current phase PR | Closes the milestone with final command-output evidence while Legacy Retention / Install-Surface Cleanup remains deferred. |

Count-change reconciliation for Phase 221:

| Suite | Old count | New count | Reason | Validation class affected | Shared-invariant preservation rationale | Command-output evidence |
|---|---:|---:|---|---|---|---|
| Pi validation | 202 | 203 | One final v2.51 closure guardrail checks Phase 218/219/220 evidence, PR #133/#134/#135, command-output truth, count-change reconciliation, and cleanup deferral. | Shared Invariant; Artifact / Process; Pi-Supported Runtime; Runtime Lens | PLAN/APPLY/UNIFY, `.paul/*`, module evidence, parent-owned APPLY, explicit approval/checkpoint boundaries, and command-output truth remain protected; runtime, installer, dependency, CI, GitHub Flow, helper delegation, and lifecycle-authority semantics remain unchanged. | `bash tests/pi-end-to-end-validation.sh` must pass 203/203 after APPLY. |
| Cross-harness validation | 118 | 119 | One final shared closure guardrail checks Phase 218/219/220 evidence, PR #133/#134/#135, Shared Invariant / Artifact / Process markers, command-output truth, count-change reconciliation, and cleanup deferral. | Shared Invariant; Artifact / Process; Frozen Legacy Parity only where existing parity checks remain preserved | Shared lifecycle semantics stay covered across harnesses; frozen legacy parity is classified but not cleaned up; current pass/fail proof remains fresh command output. | `bash tests/cross-harness-validation.sh` must pass 119/119 after APPLY. |

Reports, widgets, summaries, helper reports, Pi surfaces, and this contract do not mark validation green. Fresh command output remains authoritative for final v2.51 closure.

## Readiness checklist

A future validation-changing plan is ready only when all applicable items are true:

- [ ] Source inputs and affected validation-suite families are named.
- [ ] Primary and secondary validation classes are explicit.
- [ ] Protected Shared Invariant coverage is listed.
- [ ] Frozen Legacy Parity checks are separated from active shared-invariant evidence.
- [ ] Command-output verification commands and expected evidence are listed.
- [ ] Count-change reconciliation fields are planned before edits begin.
- [ ] Reports, widgets, summaries, helper reports, and classification contracts are explicitly non-authoritative for pass/fail status.
- [ ] Legacy Retention / Install-Surface Cleanup remains deferred unless a separate post-classification product approval and milestone explicitly authorize it.
