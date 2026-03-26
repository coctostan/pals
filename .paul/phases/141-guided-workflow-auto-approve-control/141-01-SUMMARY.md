---
phase: 141-guided-workflow-auto-approve-control
plan: 01
completed: 2026-03-26
duration: ~15 minutes
---

## Objective
Add per-transition-type auto-approve configuration to the Pi guided workflow so users retain control at critical decision points while routine transitions auto-present.

## What Was Built

| File | Purpose | Changes |
|------|---------|---------|
| drivers/pi/extensions/pals-hooks.ts | Core guided workflow gating | +75 lines: GuidedWorkflowAutoPresent type, GuidedWorkflowConfig type, GUIDED_WORKFLOW_DEFAULTS constant, loadGuidedWorkflowConfig(), shouldAutoPresent(), presentGuidedWorkflowMoment() config parameter + notify-only branch, maybePresentGuidedWorkflow loads config |
| pals.json | Project config | Added `guided_workflow.auto_present` section with 9 per-type boolean settings |
| kernel/workflows/init-project.md | Init workflow | Added guided_workflow to pals.json template and migration step |
| kernel/references/pals-json-schema.md | Schema documentation | Added guided_workflow section with 9 fields documented (v2.30) |

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Config schema exists and loads correctly | ✅ PASS | GuidedWorkflowConfig type + loadGuidedWorkflowConfig() reads pals.json with fallback to defaults |
| AC-2 | Critical transitions default to notify-only | ✅ PASS | plan_review: false, apply_approval: false, phase_transition: false, milestone_transition: false |
| AC-3 | Routine transitions default to auto-present | ✅ PASS | continue_to_unify: true, checkpoint_*: true, resume_next: true |
| AC-4 | User can override per-type behavior | ✅ PASS | loadGuidedWorkflowConfig reads pals.json overrides, shouldAutoPresent maps kind→config key |
| AC-5 | Init creates safe defaults | ✅ PASS | init-project.md pals.json template includes guided_workflow section; migration adds it to existing projects |

## Verification Results

- `grep 'GuidedWorkflowConfig' pals-hooks.ts` → type definition found ✓
- `grep 'loadGuidedWorkflowConfig' pals-hooks.ts` → function found ✓
- `grep 'auto_present' pals.json` → 9 config entries ✓
- `grep 'guided_workflow' init-project.md` → 3 locations (migration, summary, template) ✓
- `diff` source vs installed extension → identical ✓
- Default behavior verified via GUIDED_WORKFLOW_DEFAULTS constant ✓

## Module Execution Reports

### Advisory (post-apply)
- IRIS(250): 10 pre-existing `any` type usages in pals-hooks.ts — no new occurrences introduced
- DOCS(250): No doc drift detected for changed files
- RUBY(300): pals-hooks.ts at 1306 lines — pre-existing size, +75 lines net from this plan

### Enforcement (post-apply)
- WALT(100): No test suite — PASS (baseline zero)
- DEAN(150): No package manager — skip
- TODD(200): No test suite — PASS

## Deviations

| Deviation | Impact |
|-----------|--------|
| +1 file: kernel/references/pals-json-schema.md updated | Positive — schema docs now include guided_workflow fields for v2.30. Not in original plan files_modified but improves documentation completeness. |

## Key Patterns/Decisions

| Decision | Rationale |
|----------|-----------|
| Hyphen-to-underscore mapping in shouldAutoPresent() | GuidedWorkflowMoment kinds use hyphens ("plan-review") but pals.json uses underscores ("plan_review"); config loader maps between them |
| Config is optional with full defaults | Existing projects without guided_workflow section get safe defaults; zero breakage |
| Notify-only mode uses single info notification | Keeps user informed without blocking UI; they respond in the chat prompt naturally |

## Next Phase
Phase 142: Menu Parser Hardening (E2E Item 2)
