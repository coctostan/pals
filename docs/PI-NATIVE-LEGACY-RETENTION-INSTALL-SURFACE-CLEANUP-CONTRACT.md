# Pi-Native Legacy Retention / Install-Surface Cleanup Contract

## Status

| Field | Value |
|---|---|
| Milestone | v2.52 Legacy Retention / Install-Surface Cleanup |
| Baseline phase | 222 — Legacy / Install-Surface Cleanup Contract Baseline |
| Artifact status | Phase 222 baseline contract plus Phase 223 implementation evidence and Phase 224 documentation/validation surfacing expectations |
| Implementation status | Phase 223 completed the first approved cleanup: root install/uninstall entry points are Pi-first by default when `~/.pi` exists, while frozen legacy/source-only Claude Code and Agent SDK paths require explicit `PALS_DRIVER` opt-in. Phase 224 may surface that evidence in docs/reports/validation only; it does not authorize additional runtime behavior, installer behavior, dependency, CI, GitHub Flow, helper delegation, lifecycle-authority, or cleanup changes. |
| Current validation baseline | Pi validation 203/203 and cross-harness validation 119/119 from fresh command output after v2.51 closure. |

## Purpose and non-authority boundary

v2.52 may clean frozen legacy and install surfaces only where validation classification proves cleanup is safe. Phase 222 is baseline-only: it defines source inputs, cleanup target inventory, retention/removal rules, preservation boundaries, verification requirements, failure conditions, and the Phase 223 handoff before any cleanup implementation begins.

Command-output truth remains authoritative. This contract, reports, widgets, summaries, helper reports, Pi surfaces, and historical validation reports may explain cleanup posture, but they do not prove pass/fail status and they do not authorize cleanup by themselves. Fresh focused marker checks, `PALS_ROOT="$PWD" bash drivers/pi/install.sh`, `bash tests/pi-end-to-end-validation.sh`, and `bash tests/cross-harness-validation.sh` remain the current validation truth for APPLY/UNIFY.

Phase 223 implementation evidence: no-`PALS_DRIVER` root install/uninstall flows now prefer the supported Pi surface when `~/.pi` exists; `PALS_DRIVER=claude-code`, `PALS_DRIVER=agent-sdk`, and `PALS_DRIVER=all` are explicit frozen legacy/source-only or all-driver maintenance opt-ins. Validation stayed stable at Pi 203/203 and cross-harness 119/119. Phase 224 surfacing may document and command-check this posture, but it creates no new cleanup authorization.

## Source inputs

| Source | Evidence used | Cleanup implication |
|---|---|---|
| `docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md` | Final v2.51 taxonomy, suite classification inventory, preservation rules, count-change reconciliation fields, and Phase 218-221 evidence chain. | This is the safety gate for cleanup: classify before weakening, relocating, archiving, deleting, or treating checks as legacy-only. |
| `.paul/phases/218-validation-classification-baseline/218-01-SUMMARY.md` | Baseline contract creation, Pi 200/200, cross-harness 116/116, taxonomy, and no-cleanup boundary. | Cleanup must preserve the class model and the initial command-output truth rule. |
| `.paul/phases/219-runtime-validation-suite-classification-hardening/219-01-SUMMARY.md` | Suite inventory markers, one localized guardrail per suite, Pi 201/201, cross-harness 117/117, and no validation cleanup. | Cleanup must not weaken the command-checked classification inventory. |
| `.paul/phases/220-documentation-report-surfacing/220-01-SUMMARY.md` | Non-authoritative docs/report surfacing, Pi 202/202, cross-harness 118/118, and report freshness boundaries. | Cleanup must keep docs/reports subordinate to command output and must not rely on stale report status. |
| `.paul/phases/221-evidence-reconciliation-milestone-closure/221-01-SUMMARY.md` | v2.51 closure evidence, Pi 203/203, cross-harness 119/119, PR #136 evidence, and explicit cleanup deferral. | This is the current command-output baseline and the handoff into v2.52 cleanup. |
| `.paul/phases/223-safe-cleanup-implementation/223-01-SUMMARY.md` | Phase 223 implementation evidence: Pi-first root install/uninstall defaults, explicit frozen legacy/source-only `PALS_DRIVER` opt-ins, stable Pi 203/203 and cross-harness 119/119 validation, and PR #138 evidence. | Phase 224 may surface the completed posture in docs/reports/validation while preserving command-output truth and not authorizing additional cleanup. |
| `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md` | Workstream inventory that marks Legacy Retention and Install-Surface Cleanup as last/deferred and dependent on validation classification. | Cleanup remains a separate product/support-surface decision, not an early context-efficiency shortcut. |
| `docs/PI-NATIVE-SEQUENCING-DEPENDENCY-PLAN.md` | Recommended order and risk gates requiring validation classification before legacy cleanup. | Phase 223 must preserve shared-invariant coverage and explicit product/support-surface authorization before cleanup. |
| `docs/PI-NATIVE-SUPPORT-INVENTORY.md` | Pi active support tier, Claude Code and Agent SDK frozen legacy posture, portability docs as historical reference, and active Pi install surfaces. | Candidate surfaces must be separated by support role: active Pi, frozen legacy, historical reference, validation-redesign, or future-decision. |
| `README.md` | Public support posture, Pi-first install path, frozen Claude/SDK statement, `.paul/*` authority, helper delegation, guided UI, capsules, artifact slices, and validation classification discovery. | User-facing support messaging must remain accurate after any install-surface cleanup. |
| `drivers/pi/driver.yaml` | Pi driver is active and declares workflow, hook, state, user interaction, and command registration capabilities. | Pi-Supported Runtime install behavior is protected and cannot regress during legacy cleanup. |
| `drivers/claude-code/driver.yaml` | Claude Code driver remains an unsupported/frozen historical surface with legacy install paths and capabilities. | It may be retained, archived, or source-only only after shared invariants are preserved elsewhere. |
| `drivers/agent-sdk/driver.yaml` | Agent SDK driver is unsupported/frozen and lacks slash command support. | It is cleanup-eligible only as frozen legacy/reference surface after shared-invariant review. |
| `tests/pi-end-to-end-validation.sh` | Current Pi-Supported Runtime and Shared Invariant command-output suite, expected 203/203. | Must stay green; no Phase 222 validation-script edits are authorized. |
| `tests/cross-harness-validation.sh` | Current Frozen Legacy Parity, Shared Invariant, and Artifact / Process command-output suite, expected 119/119. | Parity checks may be candidates later, but shared-invariant portions must be retained or replaced with equivalent command evidence. |

## Cleanup target inventory

| Target surface | Current support role | Primary validation class | Shared-invariant risk | Phase 222 posture |
|---|---|---|---|---|
| `drivers/pi/**`, Pi installer output, Pi skills, Pi extension, Pi skill map | Active supported runtime | Pi-Supported Runtime; Shared Invariant; Runtime Lens; Guided UI Safety; Helper Delegation | High: this surface proves current supported behavior. | retain |
| `drivers/claude-code/**` | Unsupported/frozen historical adapter | Frozen Legacy Parity; Shared Invariant where kernel/resource generation is proven | Medium/high: exact Claude parity may be frozen, but shared install/resource invariants may still live in cross-harness checks. | defer pending class-by-check review |
| `drivers/agent-sdk/**` | Unsupported/frozen historical proof-of-concept | Frozen Legacy Parity; historical reference | Medium: driver docs may preserve earlier portability and workflow-injection constraints. | defer pending reference/driver decision |
| `kernel/commands/paul/*.md` and Claude slash-command wrappers | Legacy slash-command UX pointers | Frozen Legacy Parity; Shared Invariant where they point to canonical workflows | Medium: wrappers may preserve user-routing evidence and historical command compatibility. | source-only or archive candidate, not removal by default |
| `docs/HARNESS-PORTABILITY.md`, `docs/PORTABILITY-ROADMAP.md`, and older portability references | Historical reference | Artifact / Process; Frozen Legacy Parity | Medium: historical hidden-state and artifact-first warnings may still protect current design. | archive or retain with frozen notices |
| README install/support messaging and root install scripts | Public support and install entry points | Pi-Supported Runtime; Artifact / Process; Shared Invariant | High: misleading install posture can break support expectations. | retain/update only with fresh verification |
| Cross-harness validation parity families | Historical parity plus shared invariant coverage | Frozen Legacy Parity; Shared Invariant; Artifact / Process | High until individual checks are split by class. | defer; split before removal |
| Historical validation reports | Archived evidence, not current proof | Artifact / Process | Low/medium: they are non-authoritative but preserve evidence lineage. | archive/retain with non-authority labels |
| `.paul/archive/**`, historical summaries, milestone records | Authoritative historical lifecycle truth | Artifact / Process; Shared Invariant | High: archives remain lifecycle evidence. | retain |
| `pals.json`, `kernel/references/git-strategy.md`, GitHub Flow workflow evidence | Active workflow safety | GitHub Flow Safety; Shared Invariant | High: merge/CI/review/base-sync gates are active invariants. | retain |
| `.pi/agents/pals-implementer.md` and helper-agent install surfacing | Active Pi helper surface under parent authority | Helper Delegation; Shared Invariant; Pi-Supported Runtime | High: cleanup must not imply helper-owned APPLY authority. | retain |

## Retention/removal decision matrix

| Action | Meaning | Eligible validation classes | Shared-invariant rule | Evidence required | Phase 223 eligibility |
|---|---|---|---|---|---|
| retain | Keep the surface active or authoritative in its current location. | Pi-Supported Runtime, Shared Invariant, GitHub Flow Safety, Helper Delegation, Guided UI Safety, Runtime Lens, Artifact / Process | Required whenever the surface directly proves current lifecycle or Pi-supported runtime behavior. | Fresh command output; source citations; no-regression marker grep. | Eligible when cleanup would risk current guarantees or no safe replacement exists. |
| archive | Move or label a surface as historical while preserving discoverability and provenance. | Artifact / Process, Frozen Legacy Parity, historical-reference surfaces | Allowed only if all Shared Invariant evidence is retained elsewhere or replaced by equivalent command evidence. | Archive path, backlink/redirect, non-authority/frozen notice, validation count reconciliation if checks move. | Eligible for stale docs/reports or legacy prose after lineage and links are preserved. |
| source-only | Keep repo source but stop advertising or installing it as an active support path. | Frozen Legacy Parity, historical-reference, validation-redesign surfaces | Allowed only if active Pi install behavior and shared workflows remain covered. | Installer/docs diff, support-posture update, Pi installer verification, cross-harness count rationale. | Eligible for unsupported Claude/SDK adapters only after product approval and class-aware validation review. |
| remove | Delete a surface entirely. | Frozen Legacy Parity only after shared-invariant separation; never direct Shared Invariant or active Pi proof. | Blocked unless command evidence proves no `.paul/*`, PLAN/APPLY/UNIFY, module evidence, GitHub Flow, parent APPLY, checkpoint/approval, archive, or command-output truth coverage is lost. | Product/support-surface authorization, old/new validation counts, replacement proof, rollback path, PR evidence. | Rare; Phase 223 may propose only if evidence is explicit and scoped. |
| defer | Leave untouched pending better classification, product decision, or replacement proof. | Any class with unresolved overlap, especially Frozen Legacy Parity + Shared Invariant. | Default when a check or surface mixes parity-only evidence with shared lifecycle semantics. | Named blocker, owner/future phase, required analysis. | Eligible when cleanup cannot be made safe in one bounded plan. |

Frozen Legacy Parity is not automatically safe to delete. It only means the surface is not an active Pi product target. Any Frozen Legacy Parity item that also carries Shared Invariant, Artifact / Process, Helper Delegation, GitHub Flow Safety, or Pi-Supported Runtime evidence must be retained, split, or replaced before cleanup.

## Preservation rules

1. Preserve `.paul/*` lifecycle authority. No cleanup may replace STATE, ROADMAP, PLAN, SUMMARY, archive, handoff, or decision truth with Pi extension memory, hidden runtime state, telemetry, reports, helper transcripts, or UI state.
2. Preserve PLAN/APPLY/UNIFY. Cleanup must not skip approval, parent-owned APPLY verification, task result classification, checkpoint handling, or UNIFY reconciliation.
3. Preserve module evidence. Installed `modules.yaml`, `[dispatch] ...` lines, module annotations, and Module Execution Reports must remain visible and artifact-backed.
4. Preserve GitHub Flow safety. Branch, PR, CI, review, merge, base sync, and branch cleanup gates remain command-evidence-backed; no cleanup may bypass merge-gate routing.
5. Preserve parent-owned APPLY. `pals-implementer` remains optional, bounded, packeted, file-scoped, fallback-safe, and parent-verifiable; helper agents do not own `.paul/*` lifecycle writes or official verification.
6. Preserve explicit approvals and checkpoints. Pi guided UX may send canonical transcript replies only after explicit user action; cleanup must not introduce auto-approval, auto-continue, skipped checkpoints, UI-only lifecycle decisions, or inferred merge intent.
7. Preserve command-output truth. Reports, widgets, summaries, helper reports, contracts, and Pi surfaces may cite validation posture but cannot mark validation green.
8. Preserve archive history. Historical artifacts under `.paul/archive/**`, phase summaries, validation reports, and support-tier decisions remain reviewable provenance unless a separate approved plan creates an equivalent archive and backlink.
9. Preserve active Pi install behavior. `drivers/pi/install.sh`, `drivers/pi/driver.yaml`, Pi skills, Pi extension, and Pi helper-agent install expectations remain protected unless a future Pi-supported runtime plan explicitly scopes changes.
10. Preserve count-change reconciliation. Any validation count/posture change must record old count, new count, reason, validation class affected, shared-invariant preservation rationale, command-output evidence, and cleanup authorization.

## Explicit non-goals for Phase 222

Phase 222 does not authorize:

- runtime behavior changes;
- installer changes;
- validation-script edits or new guardrails;
- dependency manifest or lockfile changes;
- CI configuration changes;
- GitHub Flow automation changes;
- helper-agent semantics changes;
- lifecycle authority changes;
- broad README/report/Pi docs surfacing changes;
- removal, relocation, archive, source-only conversion, or deletion of any legacy/install surface.

## Marker-check families for Phase 223+

Future cleanup plans should choose focused marker checks from these families before and after edits:

| Family | Required marker intent | Example markers |
|---|---|---|
| Validation class coverage | Affected checks/surfaces name primary and secondary classes. | `Pi-Supported Runtime`, `Shared Invariant`, `Frozen Legacy Parity`, `Artifact / Process` |
| Support posture | User-facing surfaces distinguish Pi-supported runtime from frozen legacy references. | `Pi is the supported runtime`, `unsupported/frozen historical surfaces` |
| Non-authority | Reports/contracts/summaries/widgets remain explanatory, not pass/fail proof. | `command-output truth`, `fresh command output remains authoritative` |
| Lifecycle authority | `.paul/*`, PLAN/APPLY/UNIFY, parent APPLY, checkpoints, and GitHub Flow remain protected. | `.paul/*`, `PLAN/APPLY/UNIFY`, `parent-owned APPLY`, `GitHub Flow Safety` |
| Install behavior | Pi installer and generated installed resources still match supported expectations. | `Pi installer`, `modules.yaml generated`, `pals-implementer` |
| Cleanup action rationale | Retain/archive/source-only/remove/defer decisions remain explicit. | `retain`, `archive`, `source-only`, `remove`, `defer` |
| Handoff readiness | The next implementation phase can execute without guessing. | `Phase 223 handoff`, `eligible`, `ineligible`, `failure conditions` |

## Count-change reconciliation fields

When cleanup changes validation counts, moves checks, archives checks, deletes checks, or changes blocking posture, the PLAN and SUMMARY must record:

| Required field | Purpose |
|---|---|
| Old count | Prior command-output total for the affected suite or family. |
| New count | New command-output total after the approved cleanup. |
| Reason | Why the count or posture changed, tied to approved scope. |
| Validation class affected | Primary and secondary classes changed or preserved. |
| Shared-invariant preservation rationale | How `.paul/*`, PLAN/APPLY/UNIFY, module evidence, GitHub Flow safety, parent-owned APPLY, explicit approvals/checkpoints, artifact/process evidence, and command-output truth remain protected. |
| Command-output evidence | Fresh focused marker output, installer output when applicable, and full validation output proving the new state. |
| Cleanup authorization | Product/support-surface approval for Frozen Legacy Parity or install-surface cleanup. |

A count decrease is not automatically a regression, and a count increase is not automatically an improvement. The class-aware rationale and fresh command output decide whether the change is acceptable.

## Failure conditions

Cleanup must block if any of these occur:

- a Shared Invariant loses coverage without equivalent command evidence;
- stale reports, summaries, widgets, helper reports, Pi surfaces, or contracts replace fresh validation commands;
- Pi-supported runtime install behavior regresses;
- `drivers/pi/install.sh`, installed Pi skills, Pi extension, Pi agents, or generated `modules.yaml` behavior changes outside approved scope;
- GitHub Flow branch/PR/CI/review/merge/base-sync evidence is weakened or bypassed;
- helper delegation appears to own `.paul/*` lifecycle writes, official verification, checkpoints, module gates, fallback judgment, or APPLY completion status;
- `.paul/*` archive or lifecycle history is deleted without an approved replacement and backlink;
- a Frozen Legacy Parity check is removed before its shared-invariant portion is split, retained, or replaced;
- validation counts change without old/new count reconciliation and command-output evidence;
- cleanup exceeds the files and actions approved by the current PLAN.

## Phase 223 handoff

Phase 223 may plan safe cleanup implementation only if it starts from this contract and keeps fresh command output authoritative.

### Eligible Phase 223 categories

- Add frozen/historical notices to legacy docs when no active runtime behavior changes.
- Convert unsupported/frozen surfaces to source-only posture when install and README messaging remain accurate and validated.
- Archive stale reports or portability prose when backlinks, provenance, and non-authority labels are preserved.
- Split validation checks or docs language so Frozen Legacy Parity evidence is distinguishable from Shared Invariant evidence.
- Remove a legacy-only surface only after product/support-surface authorization, replacement proof, count reconciliation, and rollback path are explicit.

### Ineligible Phase 223 categories unless separately planned

- Editing `drivers/pi/install.sh`, Pi extension runtime behavior, shared workflows, kernel rules, module manifests, validation scripts, dependency manifests, lockfiles, CI config, GitHub Flow automation, or helper-agent authority semantics.
- Treating this contract as cleanup authorization without a new approved PLAN.
- Deleting `.paul/*` archives, phase summaries, historical decisions, or validation evidence lineage.
- Weakening command-output truth, full-read fallback, approval/checkpoint blocking, parent-owned APPLY, or merge-gate evidence.

### Minimum Phase 223 verification set

- Focused marker grep for the affected support posture, validation classes, cleanup action, and preservation rules.
- `PALS_ROOT="$PWD" bash drivers/pi/install.sh` when install surfaces or driver messaging are touched.
- `bash tests/pi-end-to-end-validation.sh` with expected Pi 203/203 unless count changes are explicitly reconciled.
- `bash tests/cross-harness-validation.sh` with expected cross-harness 119/119 unless count changes are explicitly reconciled.
- `git diff --name-only` proving changes are limited to approved cleanup surfaces plus normal `.paul/*` lifecycle artifacts.

## Readiness checklist

A cleanup implementation plan is ready only when all applicable items are true:

- [ ] Source inputs and affected surfaces are named.
- [ ] Cleanup action is one of retain, archive, source-only, remove, or defer.
- [ ] Primary and secondary validation classes are explicit.
- [ ] Shared Invariant coverage is retained, split, or replaced with equivalent command evidence.
- [ ] Frozen Legacy Parity evidence is separated from active Pi-supported runtime behavior.
- [ ] Command-output verification commands and expected counts are listed.
- [ ] Count-change reconciliation fields are planned before edits begin.
- [ ] Reports, widgets, summaries, helper reports, Pi surfaces, and contracts are non-authoritative for pass/fail status.
- [ ] Product/support-surface cleanup authorization is explicit when cleanup affects frozen legacy or install surfaces.
- [ ] Phase 223 handoff categories are followed without expanding into unrelated runtime, installer, validation-script, dependency, CI, GitHub Flow, helper, or lifecycle-authority changes.
