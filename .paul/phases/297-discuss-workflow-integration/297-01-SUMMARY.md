---
phase: 297-discuss-workflow-integration
plan: 01
subsystem: kernel
tags: [strategic-assessment, discuss-milestone, workflow-wiring, capability-detection, v2.70, allowed-tools]

requires:
  - phase: 296-strategic-assessment-contract-template
    provides: authoritative strategic-assessment contract + STRATEGIC-ASSESSMENT output template
provides:
  - optional, non-blocking strategic-assessment checkpoint wired into kernel/workflows/discuss-milestone.md (five lenses, four-part output, main-session only)
  - capability-detection tool access (Bash/Glob/Grep) on the /paul:discuss-milestone and /paul:discuss command surfaces
affects:
  - 298-strategic-assessment-validation (installed-resource marker checks for the wired workflow + command surfaces)

tech-stack:
  added: []
  patterns:
    - "Optional collaborative checkpoint inserted into a discuss workflow between recap and feature exploration, non-authoritative and non-blocking"
    - "Command entry surfaces declare the tool access their wired workflow needs (capability-detection requires Bash/Glob/Grep)"

key-files:
  created: []
  modified:
    - kernel/workflows/discuss-milestone.md
    - kernel/commands/paul/discuss-milestone.md
    - kernel/commands/paul/discuss.md

key-decisions:
  - "Decision: insert the checkpoint as a new strategic_assessment step between determine_planning_posture and explore_features (satisfies contract placement; reuses collaboration_level)"
  - "Decision: grant Bash/Glob/Grep on both discuss command surfaces because the five capability-detection lenses cannot inspect the project with Read/Write/AskUserQuestion alone"
  - "Decision: archive the consumed PLAN-stage handoff to restore artifact-consistency rather than leaving it active on disk"

patterns-established:
  - "Pattern: optional discuss-mode checkpoints default to skip, never gate the conversation, and hand non-authoritative actionable points into downstream steps"

duration: ~30min
started: 2026-06-01T15:20:00Z
completed: 2026-06-01T15:50:00Z
---

# Phase 297 Plan 01: Discuss Workflow Integration Summary

**Wired the optional, non-blocking strategic-assessment checkpoint into `discuss-milestone.md` per the Phase 296 contract — five capability-detecting lenses, fixed four-part output to `.paul/assessments/{date}-{slug}.md`, main-session only (no subagents, no Pi UI) — and granted the two discuss command surfaces the Bash/Glob/Grep access the lenses require.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~30 min |
| Started | 2026-06-01T15:20:00Z |
| Completed | 2026-06-01T15:50:00Z |
| Tasks | 2 completed |
| Files modified | 3 |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: Optional, non-blocking checkpoint between recap and feature exploration | Pass | `strategic_assessment` step inserted between `determine_planning_posture` and `explore_features` (verified step ordering 85 → 119 → 153); offers `[1] run / [2] skip`, declining proceeds with no penalty; marked OPTIONAL/NON-BLOCKING. |
| AC-2: Checkpoint honors the Phase 296 contract | Pass | Five lenses in contract order with per-lens capability detection + explicit not-applicable/partial skips; fixed four-part output (Findings → Strategic options → Ranked recommendation → Actionable points); instantiates `kernel/templates/STRATEGIC-ASSESSMENT.md` to `.paul/assessments/{date}-{slug}.md`; recommendation tagged non-authoritative; "NO subagents, NO Pi UI surfaces" stated inline. |
| AC-3: Actionable points feed feature discussion; sections updated | Pass | `assessment_actionables`/`assessment_path` threaded into `explore_features` and `synthesize_scope` (non-authoritative); `required_reading`, `references`, `success_criteria`, `anti_patterns` all updated; checkpoint writes no lifecycle state. |
| AC-4: Capability-detection tool access granted; no regression | Pass | Both command surfaces now `allowed-tools: [Read, Write, Bash, Glob, Grep, AskUserQuestion]` and reference the contract + template. Pi e2e 331/331, cross-harness 235/235, artifact_consistency PASS, `git diff --check` clean. |

## Module Execution Reports

Carried-forward APPLY annotations plus pre-/post-unify dispatch results.

### Pre-apply (APPLY)
- `[dispatch] pre-apply: TODD(50)` → skipped — non-TDD execute plan (markdown/workflow wiring); no RED/test-first task.
- `[dispatch] pre-apply: WALT(100)` → no JS/TS runner; project quality suite is the bash validation harness. Baseline captured: artifact_consistency PASS, `git diff --check` clean.

### Post-task (APPLY)
- `[dispatch] post-task(Task 1/2): TODD(100)` → SKIPPED — markdown/workflow-only, no test command applies.
- `[dispatch] post-task(Task 2/2): TODD(100)` → SKIPPED — markdown/command-file-only, no test command applies.

### Post-apply advisory (APPLY)
- ARCH(125)/SETH(130)/GABE(140)/DANA(155)/LUKE(160)/ARIA(165)/OMAR(170)/DAVE(175)/PETE(175)/REED(180)/VERA(185) → skipped — no in-scope source/API/UI/CI/data/observability/perf/resilience/privacy files.
- DOCS(250) → NOT_APPLICABLE — documentation/module-instruction change.
- IRIS(250) → No review markers introduced in changed files.
- SKIP(300) → advisory knowledge candidate: discuss command surfaces required Bash/Glob/Grep to be granted so the strategic-assessment checkpoint's capability detection can run (captured below in Decisions).

### Post-apply enforcement (APPLY)
- `[dispatch] post-apply enforcement: WALT(100)` → PASS — Pi e2e 331/331, cross-harness 235/235, artifact_consistency PASS (== baseline), `git diff --check` clean; no quality regression.
- `[dispatch] post-apply enforcement: DEAN(150)` → PASS — no dependency manifest/lockfile changes; carry counts forward.
- `[dispatch] post-apply enforcement: TODD(200)` → SKIPPED — non-TDD markdown/workflow scope, no full suite applies.

### Pre-unify (UNIFY)
- `[dispatch] pre-unify: 0 modules registered for this hook`.

### Post-unify (UNIFY)
- `[dispatch] post-unify: CODI(220)` → no CODI evidence in PLAN module_dispatch (markdown/command scope, pre-plan CODI skipped — no TS/JS seeds) → no-dispatch-found row appended to `.paul/CODI-HISTORY.md`.
- `[dispatch] post-unify: RUBY(300)` → NOT_APPLICABLE — module-instruction/workflow change is not code debt.
- `[dispatch] post-unify: SKIP(200)` → knowledge entry recorded (see SKIP advisory candidate above): discuss command surfaces must declare the tool access their wired workflow needs.
- `[dispatch] post-unify: WALT(100)` → quality delta from APPLY reports appended to `.paul/QUALITY-HISTORY.md`; no JS/TS runner — bash harness PASS, no numeric delta to track.

## Accomplishments

- Wired the v2.70 strategic-assessment checkpoint into `kernel/workflows/discuss-milestone.md` as a new optional `strategic_assessment` step placed exactly between the prior-accomplishments recap (`determine_planning_posture`) and feature exploration (`explore_features`), faithful to `docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md`.
- Implemented all five evidence lenses in contract order with per-lens capability detection and explicit not-applicable/partial skips; the fixed four-part output instantiates `kernel/templates/STRATEGIC-ASSESSMENT.md` to a durable `.paul/assessments/{date}-{slug}.md` artifact.
- Threaded the assessment's actionable points and ranked recommendation into `explore_features`/`synthesize_scope` as non-authoritative input, and updated the workflow's required_reading, references, success_criteria, and anti_patterns.
- Granted Bash/Glob/Grep on both `/paul:discuss-milestone` and `/paul:discuss` command surfaces so the lenses can actually inspect the project, and referenced the contract + template in both command contexts.

## Task Commits

Each task committed atomically:

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Wire strategic-assessment step into discuss-milestone.md | `f06f662a` | feat | Optional, non-blocking five-lens checkpoint between recap and feature exploration; four-part output to .paul/assessments/; handoff threading; section updates |
| Task 2: Grant capability-detection tools to discuss command surfaces | `7933a5b6` | feat | Add Bash/Glob/Grep to allowed-tools on both discuss commands; reference contract + template |

Plan metadata: committed with the UNIFY lifecycle commit (SUMMARY + STATE + ROADMAP + archived handoff).

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `kernel/workflows/discuss-milestone.md` | Modified | Added optional `strategic_assessment` step + handoff threading + section updates (+58 lines) |
| `kernel/commands/paul/discuss-milestone.md` | Modified | allowed-tools += Bash/Glob/Grep; context refs to contract + template |
| `kernel/commands/paul/discuss.md` | Modified | allowed-tools += Bash/Glob/Grep; context refs to contract + template (milestone mode) |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Insert as a new `strategic_assessment` step between `determine_planning_posture` and `explore_features` | Satisfies the contract's "between recap and feature exploration" placement and reuses `collaboration_level` for probing depth | Phase 298 validates this step exists and is non-blocking; checkpoint is skippable by default |
| Grant Bash/Glob/Grep on both discuss command surfaces | The five capability-detection lenses cannot inspect the project (file counts, marker grep, build/test status, output locations) with only Read/Write/AskUserQuestion | The wired checkpoint can actually run; precedent that command surfaces declare the tool access their workflow needs |
| Archive the consumed PLAN-stage handoff | A consumed handoff left active on disk + an annotated `Resume file:` line tripped the artifact-consistency guardrail | Restored artifact_consistency PASS; STATE Resume file now points at the archived path |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 1 | Trivial — archived a consumed handoff to restore artifact-consistency; no scope impact |
| Scope additions | 0 | None |
| Deferred | 0 | None |

**Total impact:** Plan executed as written; one lifecycle-hygiene auto-fix, no scope creep.

### Auto-fixed Issues

**1. [Lifecycle hygiene] Consumed handoff left active during PLAN**
- **Found during:** post-apply enforcement (WALT) — Pi e2e check 309 (artifact_consistency guardrail) failed.
- **Issue:** The PLAN step annotated STATE's `Resume file:` with a parenthetical (making the path non-existent) and left `.paul/HANDOFF-2026-06-01-phase297-ready-to-plan.md` active on disk.
- **Fix:** `git mv` the handoff to `.paul/handoffs/archive/`; repointed STATE `Resume file:` to the archived path.
- **Files:** `.paul/STATE.md`, `.paul/handoffs/archive/HANDOFF-2026-06-01-phase297-ready-to-plan.md`
- **Verification:** `tests/helpers/artifact_consistency.sh` → PASS; Pi e2e re-run 331/331.
- **Commit:** included in the UNIFY lifecycle commit.

### Deferred Items

None - plan executed exactly as written.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| Pi e2e check 309 (artifact_consistency) failed after task commits | Root cause was the PLAN-stage handoff/Resume-file drift, not the source edits; archived the handoff and repointed STATE — re-run green. |

## Next Phase Readiness

**Ready:**
- The checkpoint is wired and both command surfaces can run it; Phase 298 can add installed-resource marker checks against the new workflow step and the contract/template references.
- All validation green (Pi e2e 331/331, cross-harness 235/235, artifact_consistency PASS); hot-artifact byte budgets unchanged.

**Concerns:**
- Phase 298 should add explicit validation that the `strategic_assessment` step is present, optional/non-blocking, references the contract + template, and that both command surfaces grant Bash/Glob/Grep — none of these are pinned by tests yet.

**Blockers:**
- None.

---
*Phase: 297-discuss-workflow-integration, Plan: 01*
*Completed: 2026-06-01*
