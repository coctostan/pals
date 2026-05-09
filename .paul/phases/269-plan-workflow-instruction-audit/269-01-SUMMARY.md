---
phase: 269-plan-workflow-instruction-audit
plan: 01
completed: 2026-05-09
status: complete
---

# Phase 269 Plan 269-01 SUMMARY

## Objective

Rewrite the plan workflow so routine planning uses bounded lifecycle context, proportional collaboration prompts, concise review output, and semantic validation instead of passing through marker prose alone.

## What Was Built

| File | Purpose |
|------|---------|
| `kernel/workflows/plan-phase.md` | Rewritten plan workflow procedure: bounded STATE/ROADMAP-first planning, conditional PROJECT/PRD/prior-summary reads, proportional planning posture prompts, compact CODI seed rules, selective context loading, compact plan/review/update instructions. |
| `tests/pi-end-to-end-validation.sh` | Added Pi/install semantic guardrails for plan workflow behavior and repointed legacy marker checks to the new compact wording. |
| `tests/cross-harness-validation.sh` | Added shared cross-harness semantic guardrails for plan workflow behavior and compact CODI/review marker checks. |
| `.paul/phases/269-plan-workflow-instruction-audit/269-01-SUMMARY.md` | Durable reconciliation record for Phase 269. |

## Audit Findings

The original `kernel/workflows/plan-phase.md` had selective-loading policy text, but routine procedure still encouraged avoidable context growth:

- preconditions used broad `Read STATE.md to confirm` wording instead of bounded STATE windows;
- required-reading framed PROJECT/PRD/prior SUMMARY context as routine instead of conditional;
- target phase/context loading was duplicated across identify/analyze/load steps;
- planning posture always offered a per-run collaboration menu, adding ceremony for routine direct-requirements phases;
- CODI seed preparation carried too much inline detail for a hook whose deeper rules already live in module references;
- review/state-update sections repeated large templates and background instead of concise operational requirements;
- existing validation could pass on targeted-read/review-menu markers without proving operational bounded behavior.

## Acceptance Criteria Results

| AC | Result | Evidence |
|----|--------|----------|
| AC-1: bounded lifecycle context order | PASS | `load_plan_state_bounded` now confirms PLAN readiness from bounded STATE windows and `identify_target_phase` reads ROADMAP current milestone plus target phase detail only before optional context. |
| AC-2: concise/proportional planning posture | PASS | `determine_planning_posture` now uses carried CONTEXT metadata or `planning.default_collaboration` without prompting for routine direct-requirements phases; prompts are limited to ambiguity, exploratory/high-risk/checkpointed work, or user override. |
| AC-3: bounded context/CODI prep | PASS | `prepare_codi_seed_candidates` now limits CODI to explicit TS/JS selectors and bounded top-level identifier extraction; markdown/config/shell-only phases skip cleanly. `load_context_selectively` limits PLAN context to selected slices, direct dependencies, and relevant source. |
| AC-4: concise review with approval gates | PASS | `review_plan` now defaults to compact recap while preserving `[1] Quick recap`, `[2] Detailed recap`, `[3] Full plan`, and `[4] No review needed`. |
| AC-5: semantic validation | PASS | Pi and cross-harness suites now assert bounded STATE/ROADMAP-first semantics, lifecycle-before-optional-context order, proportional prompts, absence of broad/eager routine planning instructions, and updated CODI/review markers. |
| AC-6: collaborative bounded rewrite | PASS | APPLY used a section-by-section approval checkpoint; each section was proposed, tightened when requested, edited, and verified before proceeding. Scope stayed within planned files plus routine `.paul/*` lifecycle artifacts. |

## Verification Results

Intentional RED check after Task 1:

- `bash tests/pi-end-to-end-validation.sh` failed with 8 plan-workflow-specific failures against the old workflow text.

Final checks:

- `bash tests/pi-end-to-end-validation.sh` — PASS, 284/284.
- `bash tests/cross-harness-validation.sh` — PASS, 160/160.
- `git diff --check` — PASS.
- Workguard scope report — PASS, `changed=7`, `outside_allowed=0`, `over_budget=false`.

## Module Execution Reports

- `[dispatch] pre-unify: 0 modules registered for this hook`.
- WALT post-unify: quality history updated for 269-01 with Pi 284/284 and cross-harness 160/160; trend ↑ improving.
- CODI post-unify: `skipped-no-symbols` recorded; phase scope is markdown/shell workflow validation with no codegraph symbols.
- SKIP post-unify: captured the Phase 269 collaboration decision and lesson that plan workflow validation must inspect operational bounded-read behavior and proportional prompt semantics.
- RUBY post-unify: no refactor-blocking debt in `plan-phase.md` after compaction; validation scripts remain large existing shell suites and Phase 269 additions were localized.

## Deviations / Notes

- No helper delegation used; parent APPLY retained authority as planned.
- The user explicitly requested tighter wording in several sections; the final workflow is materially shorter than the original while preserving module dispatch and approval gates.
- Task 1's cross-harness RED result was not run before the rewrite, but the final suite includes matching cross-harness semantic assertions and passed after the workflow rewrite.
- Existing validation marker checks were updated where the workflow intentionally replaced old phrases (`Would you like to see the plan?`, older CODI prose, and `full read`) with compact equivalents.

## Key Patterns / Decisions

- Context-efficiency requires operational procedure order, not just selective-loading policy prose.
- Routine direct-requirements planning should not force a collaboration menu; prompts should appear only when the scope needs them.
- Module-specific workflow hooks can stay in the lifecycle workflow, but detailed hook mechanics should live in module references where possible.
- Validation should assert both positive semantics and absence of old broad/eager instructions.

## Next Phase

Phase 270 should apply the same instruction-audit approach to `kernel/workflows/apply-phase.md`, focusing on execution-time context efficiency, parent-owned APPLY boundaries, helper delegation limits, checkpoint payload size, verification load, lifecycle artifact reads/writes, and instructions that encourage broad artifact scans or brittle validation.
