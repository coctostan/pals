# PALS Artifact Consistency Guardrails

**Phase:** 237 Artifact Consistency Guardrails
**Plan:** 237-01
**Status:** Active — guardrail contract for `.paul/*` index/session-pointer drift detection.

## Purpose

PALS depends on durable `.paul/*` artifacts as the single source of lifecycle truth. Several hot artifacts repeat the same milestone/phase/plan/loop/session-continuity values:

- `.paul/STATE.md` (current position, loop position, session continuity)
- `.paul/ROADMAP.md` (current milestone phase table and Phase NN entries)
- `.paul/MILESTONES.md` (live status, current/future milestone pointer)
- `.paul/phases/<phase-slug>/<plan>-SUMMARY.md` (phase frontmatter)
- `.paul/HANDOFF-*.md` and `.paul/handoffs/archive/HANDOFF-*.md`

When these artifacts disagree, lifecycle routing becomes ambiguous. Phase 234 ranked this as maintainability weakness #3 (lifecycle/index artifact drift). Phase 235 requires that any new safety mechanism preserve `.paul/*` authority and add no hidden state, telemetry, or alternate ledger. Phase 236 preserved validation command-output truth and the safe sourced-helper extraction pattern.

This document describes lightweight, source-cited guardrails that **report** drift and never **decide** lifecycle truth or repair artifacts.

## Evidence Base

- `docs/PALS-MAINTAINABILITY-PRODUCT-REALITY-AUDIT.md` — Phase 234 audit: lifecycle/index drift recommendation for Phase 237 cross-checks.
- `docs/PALS-RISK-TIERED-LIFECYCLE-CONTRACT.md` — Phase 235 contract: tier-aware evidence; non-bypass rules for `.paul/*` authority, no hidden state, and no telemetry.
- `.paul/STATE.md` — authoritative current-position and session-continuity record.
- `.paul/ROADMAP.md` — current milestone phase table.
- `.paul/MILESTONES.md` — live milestone index pointer.
- `.paul/phases/236-validation-suite-decomposition-baseline/236-01-SUMMARY.md` — direct predecessor; preserved Pi 209/209 and cross-harness 123/123, established the side-effect-free sourced helper pattern.

## Guarded Artifacts and Drift Classes

| Drift Class | Compares | Failure Signal |
|-------------|----------|----------------|
| Current state vs roadmap | `.paul/STATE.md` "Phase: N of M" against `.paul/ROADMAP.md` current milestone phase table | STATE names a phase number/slug that the ROADMAP table does not list as the current focus phase. |
| Milestone index pointer | `.paul/MILESTONES.md` Live Status row + Current/Future Milestone Pointer | Pointer names a milestone or phase that disagrees with STATE/ROADMAP (e.g., still announces an already-complete phase as "ready to plan"). |
| Latest completed phase SUMMARY | `.paul/ROADMAP.md` reference like `.paul/phases/<slug>/<plan>-SUMMARY.md` | Referenced SUMMARY path is missing or has frontmatter that disagrees with the SUMMARY path. |
| Resume-file existence | `.paul/STATE.md` `Resume file:` value | Non-empty path that does not exist in the working tree. |
| Active handoff vs STATE | Active root `.paul/HANDOFF*.md` files | An active root handoff exists but is not the `Resume file:` STATE points at; archived `.paul/handoffs/archive/HANDOFF*.md` files never fail this check. |

The checker reports each finding as concise diagnostic text and returns a non-zero exit code when any drift class fails.

## Authority and Non-Goals

- The guardrail **reports drift only**. It does not write `.paul/*`, repair artifacts, or decide lifecycle status.
- It is **not authoritative**. `.paul/*` artifacts remain the only source of lifecycle truth; PLAN/APPLY/UNIFY remains the only lifecycle loop.
- It must be **safe to source**: no checks run on `source`; no output is emitted; no environment side effects beyond declaring functions.
- It must **never** persist state, write caches, emit telemetry, contact the network, install dependencies, or introduce a non-`.paul/*` source of truth.
- It does not relax explicit approval, GitHub Flow gates, module evidence, parent-owned APPLY, helper-delegation boundaries, command-output validation truth, or full authoritative read fallback.
- Validation count truth is still command-output: `bash tests/pi-end-to-end-validation.sh` and `bash tests/cross-harness-validation.sh` remain the official sources.

## Tier-Aware Usage

Following `docs/PALS-RISK-TIERED-LIFECYCLE-CONTRACT.md`:

- **Tiny / doc-only tier:** the guardrail's PASS is supportive evidence, not a substitute for command-output truth; failures should still be repaired before merge.
- **Normal tier:** failures should be repaired in the active phase or explicitly documented as a deviation in the SUMMARY.
- **Risky tier (e.g., this phase):** failures must be repaired before APPLY completes; the checker is sourced from the official validation suites so artifact drift cannot land silently.
- **Hotfix tier:** the guardrail still runs through validation; if a hotfix legitimately leaves a transitional drift, it must be documented and reconciled in the follow-up unify pass.

The guardrail is intentionally lightweight. It does not replace narrative review, plan authorship, SUMMARY writing, or `.paul/STATE.md` updates.

## Validation Count Reconciliation

Phase 236 baseline:

- Pi end-to-end validation: `1..209` / `# Passed: 209`
- Cross-harness validation: `1..123` / `# Passed: 123`

Phase 237 expected, reconciled as guardrail additions only:

- Pi end-to-end validation: `209→210`, final `1..210` / `# Passed: 210`
- Cross-harness validation: `123→124`, final `1..124` / `# Passed: 124`

The Pi suite gains exactly one localized artifact-consistency assertion. The cross-harness suite gains exactly one localized artifact-consistency assertion. No existing assertion is renamed, removed, or altered. Fresh command output remains authoritative; this document is a derived contract aid, not a count-of-record source.

## Implementation Notes

- Helper file: `tests/helpers/artifact_consistency.sh` — sourced by both validation suites; defines `artifact_consistency_check "$REPO_ROOT"`.
- Helper requirements: pure POSIX-ish bash, no `jq`, no network, no writes; emits diagnostics only on failure.
- Both suites add exactly one TAP assertion using the existing `tap_check`/`tap_ok`/`tap_not_ok` helpers from `tests/helpers/tap.sh`.
- Existing markers and validation-classification inventories in both suites remain intact.

## Out of Scope (Future Approved Plans Only)

- Automatic repair of detected drift.
- Pi runtime warnings, banner UI, or guided-workflow prompts based on drift.
- New SUMMARY frontmatter schema, new MILESTONES schema, or canonicalized session-continuity format.
- Broader workflow enforcement (e.g., blocking PRs purely because the guardrail reports drift outside lifecycle scope).
- Conversion of brittle prose checks elsewhere in the validation suites.

---

*Created: Phase 237 / Plan 237-01.*
*Authority: Derived contract aid only; `.paul/*` artifacts remain authoritative lifecycle truth.*
