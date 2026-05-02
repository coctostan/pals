---
phase: 249-s3-extraction-contract-bounded-submodule-plan
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - docs/PI-NATIVE-GUIDED-WORKFLOW-DETECTION-EXTRACTION-CONTRACT.md
  - docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md
  - docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md
  - .paul/STATE.md
  - .paul/PROJECT.md
  - .paul/MILESTONES.md
  - .paul/ROADMAP.md
  - .paul/handoffs/archive/HANDOFF-2026-05-02-v2-57-complete-ready-v2-58-milestone.md
autonomous: true
---

# Phase 249 — S3 Extraction Contract + Bounded Submodule Plan

## Acceptance Criteria Results

| AC | Status | Evidence |
|----|--------|----------|
| AC-1: S3 extraction contract exists and is bounded | **PASS** | `docs/PI-NATIVE-GUIDED-WORKFLOW-DETECTION-EXTRACTION-CONTRACT.md` created with all 10 S3 identifiers, forbidden-scope list, Phase 250 handoff, and acceptance checklist. |
| AC-2: Guided workflow safety invariants are preserved | **PASS** | Contract explicitly cites `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` and preserves option parsing semantics, transcript-visible canonical replies, no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, no inferred merge intent, `.paul/*` authority, module evidence, GitHub Flow evidence, and command-output validation truth. |
| AC-3: Phase 250 source-change boundary is executable | **PASS** | Existing extraction docs updated with Phase 250 validation expectations, allowed sibling-module shape, marker checks, install verification, and prohibited surfaces. |
| AC-4: Phase 249 remains docs-only and validation-backed | **PASS** | No runtime/source/test/install/dependency/CI files modified. Pi 223/223, cross-harness 131/131, artifact_consistency PASS, `git diff --check` clean. |

## Files Created

- `docs/PI-NATIVE-GUIDED-WORKFLOW-DETECTION-EXTRACTION-CONTRACT.md` (new)

## Files Modified

- `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md`
  - Status updated to "Active Phase 250 handoff baseline"
  - S3 table row promoted from "conditional secondary" to "bounded Phase 250 contract target"
  - Phase 249 outcome section added
  - Phase 250 validation expectations section added
- `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md`
  - Phase 249 outcome section added after Phase 246 outcome
  - Links to new S3 contract; preserves S4/S6/S7/S8 deferrals
- `.paul/STATE.md` — loop position updated to PLAN ✓ APPLY ✓ UNIFY ○; v2.58 progress 25%; Git State updated
- `.paul/PROJECT.md` — v2.58 status updated to 1 of 4 phases; Phase 249 applied
- `.paul/MILESTONES.md` — Phase 249 applied, awaiting UNIFY
- `.paul/ROADMAP.md` — trimmed to 120 lines to satisfy active-window line budget
- `.paul/handoffs/archive/HANDOFF-2026-05-02-v2-57-complete-ready-v2-58-milestone.md` — archived stale handoff

## Focused Marker-Check Evidence

| Marker / Pattern | Location | Matches |
|------------------|----------|---------|
| `detectGuidedWorkflowMoment`, `parseGuidedWorkflowOptions`, `detectExplicitCanonicalResponse`, `isMergeGateRoutingPrompt`, `extractMergeGateRoutingSummary`, `makeGuidedWorkflowSignature`, `summarizeWorkflowPrompt`, `extractNextActionSummary`, `isValidOptionId` | S3 contract | 9 |
| `GUIDED_WORKFLOW_LOOKBACK`, `GUIDED_WORKFLOW_SIGNATURE_BYTES` | S3 contract | 2 |
| `Phase 249`, `guided-workflow-detection` | Extraction baseline | 17 |
| `Phase 249`, `guided-workflow-detection` | Modularization contract | 8 |
| `S4 canonical`, `no inferred merge intent` | Extraction baseline | 7 |
| `S4/S6/S7/S8 deferrals` | Modularization contract | 1 |

## Validation Command Output and Count Reconciliation

### Pi End-to-End Validation

```
1..223
# Passed: 223
# Failed: 0
# Total:  223
# ALL CHECKS PASSED
```

**Reconciliation:** Baseline expected Pi 223/223. Actual: 223/223 passed. No count delta.  
**Pre-apply note:** Two failures were observed on the first run (ROADMAP line budget 121 > 120; active handoff drift). These were resolved during APPLY by trimming ROADMAP.md to 120 lines and archiving the stale v2.57 handoff file. Second run: all green.

### Cross-Harness Validation

```
1..131
# Passed: 131
# Failed: 0
# Total:  131
# ALL CHECKS PASSED
```

**Reconciliation:** Baseline expected cross-harness 131/131. Actual: 131/131 passed. No count delta.

### Artifact Consistency

```
artifact_consistency_check: PASS
```

**Reconciliation:** PASS after resolving the active-handoff drift.

### Git Diff Check

```
# (no output — clean)
```

## Module Execution Reports

- **[dispatch] pre-apply:** modules.yaml NOT FOUND — WARNING. Installed registry unavailable in this environment; no module hooks fired.
- **[dispatch] post-apply advisory:** SKIPPED — modules.yaml NOT FOUND
- **[dispatch] post-apply enforcement:** SKIPPED — modules.yaml NOT FOUND

> ⚠️ WARNING: No post-apply modules fired. Verify modules.yaml was loaded. Module Execution Reports will be empty in SUMMARY.md.

### Post-UNIFY Module Dispatch

- **[dispatch] pre-unify:** 0 modules registered for this hook.
- **[dispatch] post-unify:** CODI appended `no-dispatch-found` row for 249-01 (PLAN.md had no CODI blast_radius block). WALT recorded quality delta (Pi 223/223 → 223/223, cross-harness 131/131 → 131/131, artifact_consistency PASS). SKIP processed SUMMARY for knowledge capture.

## GitHub Flow Evidence

- **Workflow mode:** github-flow
- **Base branch:** main
- **Feature branch:** `feature/249-s3-extraction-contract-bounded-submodule-plan`
- **Commits on feature branch:** 4
  1. `docs(249-01): create S3 guided-workflow-detection extraction contract`
  2. `docs(249-01): update extraction baseline and modularization contract with Phase 249 handoff`
  3. `chore(249-01): reconcile ROADMAP line budget and archive stale handoff`
  4. `docs(249-01): update lifecycle artifacts for APPLY complete`
- **PR:** Not yet created (will be created during UNIFY postflight if configured)
- **CI:** N/A until PR opened
- **Merge intent:** No merge intent inferred; merge gate handled in UNIFY.

## Deferred Scope and Phase 250 Handoff

### Deferred

- **S4 canonical-reply delivery** (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`) — explicitly forbidden in S3 contract
- **S6 lifecycle UI** — explicitly forbidden
- **S7 context injection** — explicitly forbidden
- **S8 command routing** — explicitly forbidden
- **Runtime/source extraction** — Phase 250 owns the first source-changing step
- **Docs/validation surfacing** — Phase 251
- **Evidence closure + next roadmap** — Phase 252

### Phase 250 Handoff

Phase 250 must:

1. Create `drivers/pi/extensions/guided-workflow-detection.ts` as a sibling module following the ratified S5+S1+S2 pattern.
2. Preserve all 10 S3 identifiers through explicit import or single-defined re-export.
3. Preserve `GUIDED_WORKFLOW_LOOKBACK` and `GUIDED_WORKFLOW_SIGNATURE_BYTES` as single-defined markers.
4. End with the loader-compat invariant: no-op default-exported factory with literal marker phrase `No-op Pi extension factory`.
5. Edit `drivers/pi/extensions/pals-hooks.ts` only to import and delegate to the new module; no behavior change.
6. Run focused marker checks before and after extraction.
7. Run `PALS_ROOT="$PWD" bash drivers/pi/install.sh` to verify the new sibling is in the install source set.
8. Run Pi validation (expected 223/223), cross-harness validation (expected 131/131), and artifact_consistency; reconcile any delta from command output.
9. Ensure `git diff --check` is clean.
10. Preserve all guided-workflow safety invariants from `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`.

---

*Completed: Phase 249 / Plan 249-01 APPLY.*  
*Authority: Derived aid only; `.paul/*` artifacts and command-output truth remain authoritative lifecycle truth.*
