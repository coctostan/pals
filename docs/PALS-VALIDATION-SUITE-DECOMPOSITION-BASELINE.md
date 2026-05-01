# PALS Validation Suite Decomposition Baseline

**Phase:** 236 — Validation Suite Decomposition Baseline  
**Plan:** `.paul/phases/236-validation-suite-decomposition-baseline/236-01-PLAN.md`  
**Risk tier:** Risky, because this phase touches validation-suite structure.  
**Status:** Baseline plus first behavior-preserving TAP/reporting helper extraction.

## Evidence Base

This baseline is derived from:

- `docs/PALS-MAINTAINABILITY-PRODUCT-REALITY-AUDIT.md`, which ranks marker/prose-heavy validation suites as the highest maintainability weakness.
- `docs/PALS-RISK-TIERED-LIFECYCLE-CONTRACT.md`, which requires full validation, explicit scope proof, count reconciliation, and non-bypass rules for validation-suite decomposition.
- `tests/pi-end-to-end-validation.sh`, current command-output baseline `209/209`.
- `tests/cross-harness-validation.sh`, current command-output baseline `123/123`.

Command-output truth remains authoritative: this document guides future decomposition work but does not replace validation command output, `.paul/*` lifecycle artifacts, module blockers, GitHub Flow gates, or parent-owned APPLY verification.

## Current Baseline Counts

| Suite | Command | Current TAP plan | Current passed count | Phase 236 rule |
|---|---|---:|---:|---|
| Pi end-to-end | `bash tests/pi-end-to-end-validation.sh` | `1..209` | `209/209` | Preserve exactly in this phase. |
| Cross-harness | `bash tests/cross-harness-validation.sh` | `1..123` | `123/123` | Preserve exactly in this phase. |

## Suite Category Inventory

| Suite | Category | Validation class / purpose | Risk-tier implication | Current marker/prose sensitivity | Recommended decomposition / helper target |
|---|---|---|---|---|---|
| Pi | Installer Deployment | Pi-supported runtime install behavior and artifact deployment | Risky because installer regressions can invalidate the supported runtime | Mixes structural file checks with exact install-surface markers | Later extract installer setup/count helpers; keep assertions unchanged until separately approved. |
| Pi | Module Execution Evidence | Module evidence and durable lifecycle reporting | Risky because module blockers and evidence paths are lifecycle guarantees | Marker-sensitive around module reports, blockers, and persistence language | Later group module evidence assertions behind named helper functions with explicit expected markers. |
| Pi | Skill Structural Validity | Pi skill wrapper and installed resource integrity | Risky because missing skill wrappers break command routing | File-presence and wrapper marker checks are contract-sensitive | Later extract skill inventory data into a table-driven assertion source. |
| Pi | Thin Wrapper Contract | Contextual verbosity and wrapper slimness guarantees | Normal-to-risky depending on whether checks stay structural | Wording-sensitive around concise wrapper semantics and exact wrapper names | Later convert repeated wrapper grep blocks into structured wrapper contract assertions. |
| Pi | Delegated APPLY / REV Boundaries | Helper delegation and review authority boundaries | Risky because parent-owned APPLY and REV boundaries must not weaken | Highly marker-sensitive around no helper-owned lifecycle authority | Preserve markers; later extract helper-boundary marker sets into named fixtures. |
| Pi | Shared Workflow Prose Contract | Shared lifecycle prose and workflow invariants | Risky because PLAN/APPLY/UNIFY authority must remain explicit | Exact phrases protect lifecycle semantics but can be brittle | Later split lifecycle-invariant marker sets from incidental prose checks. |
| Pi | Context-Diet Regression Guardrails | Archive/read-cost and line-budget protection | Normal when ceilings are structural; risky if assertions are rewritten | Sensitive to line ceilings and archive-link markers | Shared line-ceiling helpers are already good candidates; keep ceilings data-driven. |
| Pi | CODI Plan-Phase Distribution | CODI advisory/runtime packaging evidence | Normal-to-risky because CODI is advisory but installed artifacts must remain coherent | Marker-sensitive around advisory/non-authority boundaries | Later group CODI source/install/report markers into one fixture-backed category. |
| Pi | Extension Structural Validity | Pi extension source and runtime-lens integrity | Risky because Pi runtime behavior is supported product behavior | Strongly marker-sensitive around artifact slices, capsules, guided replies, and no hidden state | Later decompose into extension-schema, guided-workflow, and artifact-slice assertion groups. |
| Pi | Driver Manifest Accuracy | Pi driver manifest correctness | Normal unless install routing changes | Mostly structural file/manifest markers | Candidate for table-driven manifest assertions. |
| Pi | Pi Discovery Surfaces | README/skill-map/discovery docs for Pi users | Normal docs/report surfacing; risky if support posture changes | Marker-sensitive around support-tier and command-output truth phrasing | Later separate product-story markers from runtime contract markers. |
| Pi | Collaborative Planning Model | Planning UX and workflow collaboration markers | Normal-to-risky depending on lifecycle semantics touched | Sensitive around approval/checkpoint boundaries | Later group collaboration markers into a lifecycle UX fixture. |
| Pi | UX Readability & Color Enrichment | Pi UX readability, labels, and color output | Normal unless transcript semantics change | Some markers are product-copy-sensitive rather than contract-sensitive | Later isolate style/UX checks from lifecycle transcript authority checks. |
| Pi | Validation Classification Inventory | Validation-class inventory and count reconciliation | Risky because classification protects future cleanup/decomposition decisions | Highly marker-sensitive around class names and count-change reconciliation | Later maintain one suite inventory fixture shared by both validation commands. |
| Cross-harness | Installer Parity | Cross-driver install parity and portability | Risky because shared invariant behavior spans adapters | Structural counts plus exact driver-path assumptions | Later extract driver setup/count helpers; keep parity assertions intact. |
| Cross-harness | Shared APPLY / REV Boundaries | Cross-harness helper/review authority boundaries | Risky because boundaries must stay shared across adapters | Marker-sensitive around parent-owned APPLY and REV non-authority | Later share boundary marker fixtures with Pi suite where semantics overlap. |
| Cross-harness | Durable Module Evidence Path | Module evidence artifact durability across harnesses | Risky because module evidence is a lifecycle input | Sensitive to module report and `.paul/*` artifact markers | Later table-drive module evidence path checks. |
| Cross-harness | Portability Compliance | Harness-neutral kernel and driver separation | Risky if kernel portability or driver assumptions change | Marker-sensitive around Pi vs frozen legacy support posture | Later split kernel portability checks from legacy/frozen-surface checks. |
| Cross-harness | Shared Collaborative Planning Model | Shared planning semantics across harnesses | Risky when approval/checkpoint/lifecycle semantics are touched | Wording-sensitive around explicit approval and checkpoint boundaries | Later use shared lifecycle UX marker fixture. |
| Cross-harness | Context-Diet Regression Guardrails | Shared anti-regrowth and archive-boundary checks | Normal when structural; risky if ceilings/authority markers change | Line ceilings and archive markers are structural but exact | Continue table-driven ceiling helpers; avoid incidental prose assertions. |
| Cross-harness | CODI Plan-Phase Distribution | CODI distribution and shared advisory boundaries | Normal-to-risky because CODI is advisory but installed behavior must remain portable | Marker-sensitive around source distribution and advisory semantics | Later group CODI checks into a shared structured fixture. |
| Cross-harness | Artifact Spec Compliance | `.paul/*` artifact spec and lifecycle truth | Risky because artifacts are authoritative lifecycle truth | Highly marker-sensitive around `.paul/*`, PLAN/APPLY/UNIFY, and command-output truth | Later separate immutable artifact-contract markers from report-copy markers. |
| Cross-harness | Driver Manifest Completeness | Driver manifest coverage across adapters | Normal unless driver support posture changes | Mostly structural manifest/path assertions | Candidate for data-driven manifest inventory assertions. |
| Cross-harness | Validation Classification Inventory | Shared validation class inventory and count reconciliation | Risky because it governs future weakening/removal decisions | Highly marker-sensitive around class names and cross-harness count reconciliation | Later maintain shared validation-class fixture consumed by both suites. |

## Wording-Sensitive Checks

Protected contract markers must remain explicit until a later approved plan replaces them with structured assertions. These include markers for:

- `command-output truth` and command output as authoritative validation evidence.
- `.paul/*` artifact authority and PLAN/APPLY/UNIFY lifecycle authority.
- Module blockers, module reports, and durable module evidence.
- GitHub Flow gates, CI/review/merge safety, and no inferred merge intent.
- Parent-owned APPLY, delegated helper non-authority, and REV boundaries.
- Pi-supported runtime boundaries, frozen legacy/source-only posture, full authoritative read fallback, no hidden Pi state, and no telemetry.
- Validation classification names and count-change reconciliation markers.

Brittle prose assertions are candidates for later structured conversion when they validate incidental wording, long copied paragraphs, category-specific historical summaries, or repeated README/report phrasing that can be expressed as explicit fields, fixtures, or marker sets without weakening the protected contracts above.

## First Extraction Boundary

Phase 236 authorizes only the first extraction boundary: shared TAP/reporting helpers. The helper file is `tests/helpers/tap.sh`, sourced by both validation suites after each caller initializes `SCRIPT_DIR`, `REPO_ROOT`, `PASS`, `FAIL`, and `TOTAL`.

This boundary is intentionally narrow because it removes duplicated helper mechanics without moving assertion logic, changing TAP descriptions, changing installer behavior, adding or removing checks, or changing TAP counts. The helper must be safe to source, emit no output when sourced, and preserve caller-owned counters.

No validation assertion or count change is authorized in this phase. Pi validation must remain `209/209`; cross-harness validation must remain `123/123`.

## Future Structured Assertion Candidates

These candidates are documented for later approved plans only:

1. Shared marker fixtures for lifecycle authority, `.paul/*` authority, parent-owned APPLY, delegated helper boundaries, module evidence, and GitHub Flow safety.
2. Table-driven category inventories that map suite category, validation class, source file, required markers, and expected failure detail.
3. Driver manifest inventory assertions for installed paths and adapter manifests.
4. Installer setup/count helpers for temporary HOME creation, install invocation, and artifact count comparison.
5. Validation classification fixtures shared by Pi and cross-harness suites to reduce duplicated class-name and count-reconciliation prose.
6. Report-surface assertions that distinguish historical evidence markers from live command-output truth.
7. Line-ceiling and pattern-count configuration tables for context-diet guardrails.

Any future conversion must run through PLAN/APPLY/UNIFY approval, preserve command-output truth, reconcile TAP count changes explicitly if any are approved, and retain full validation evidence under the applicable risk tier.
