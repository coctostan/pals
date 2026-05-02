---
phase: 246-s2-workflow-resource-capsule-rendering-extraction
plan: 01
completed: 2026-05-02T05:30:00Z
duration: ~30 minutes (PLAN + APPLY + UNIFY same session)
---

# Plan 246-01 — Summary

## Objective (recap)

Extract the S2 `workflow-resource-capsule-rendering` subsystem from `drivers/pi/extensions/pals-hooks.ts` into a new sibling Pi extension module `drivers/pi/extensions/workflow-resource-capsule-rendering.ts`, mirroring the Phase 239 S5 + Phase 243 S1 sibling-module recipe and carrying the Phase 245 Pi extension loader-compat invariant (no-op default-exported factory + `No-op Pi extension factory` marker comment) as a hard constraint. Preserve every visible capsule marker, payload bound, fallback string, authority string, schema-marker tuple, file-source contract, and call-site behavior. Keep `pals-hooks.ts` as imports + a delegated call for the S2 subsystem.

## What Was Built

| File | Purpose | Lines | Status |
|------|---------|-------|--------|
| `drivers/pi/extensions/workflow-resource-capsule-rendering.ts` | New sibling Pi extension; single-defined S2 markers/caps/fallback/authority/schema-marker tuple; exports `MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS`, `MAX_WORKFLOW_RESOURCE_CAPSULE_LINES`, `WORKFLOW_RESOURCE_CAPSULE_FALLBACK`, `WORKFLOW_RESOURCE_CAPSULE_AUTHORITY`, `WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS`, `renderWorkflowResourceCapsules`; ends with `No-op Pi extension factory` JSDoc + `export default function (_pi: unknown): void {}` | 192 (new) | ✓ Created |
| `drivers/pi/extensions/pals-hooks.ts` | Imports `renderWorkflowResourceCapsules` from `./workflow-resource-capsule-rendering`; S2 inline definitions removed (5 constants, 2 types, 4 functions); call site `...renderWorkflowResourceCapsules(cwd)` preserved verbatim; shared helpers (`compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, type `PalsStateSnapshot`) preserved | 1273 (was 1415; −142) | ✓ Modified |
| `tests/pi-end-to-end-validation.sh` | Existing capsule runtime-markers TAP block repointed from `$EXT_SRC` to the new sibling; three Phase 246 guardrails appended after the Phase 245 loader-compat blocks (single-defined + import-wired + negative-assertion via `tap_file_contains_none`) | +35 / −1 | ✓ Modified |

Lifecycle artifacts: `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/MILESTONES.md`, `.paul/phases/246-s2-workflow-resource-capsule-rendering-extraction/246-01-PLAN.md` (already at APPLY commit), `.paul/phases/246-s2-workflow-resource-capsule-rendering-extraction/246-01-SUMMARY.md` (this file).

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | New sibling Pi extension module created with S5/S1-shape and loader-compat marker | **PASS** | `grep -c "Authority: Derived aid only" drivers/pi/extensions/workflow-resource-capsule-rendering.ts` = 4 (header + module-level constant + capsule-level + factory comment); `grep -c "No-op Pi extension factory"` = 1; `grep -c "^export default function"` = 1; `grep -c "export function renderWorkflowResourceCapsules"` = 1; `grep -c "Capsule: plan-task-anatomy"` = 2 (JSDoc marker list + spec entry); `grep -c "MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS = 6_000"` = 1. Helper imports tightened to `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines` (only those used). |
| AC-2 | `pals-hooks.ts` shrinks by exactly the S2 footprint and remains import-wired | **PASS** | `grep -c 'import { renderWorkflowResourceCapsules } from "./workflow-resource-capsule-rendering";' drivers/pi/extensions/pals-hooks.ts` = 1; `grep -c "MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS = 6_000"` = 0; `grep -c "function buildWorkflowResourceCapsule"` = 0; `grep -c "function renderWorkflowResourceCapsules"` = 0; `grep -c "WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS = \["` = 0; `grep -c "renderWorkflowResourceCapsules(cwd)"` = 1 (call site preserved); `grep -c "export function selectBoundedLines"` = 1 (helper preserved); `grep -c "export function compactWhitespace"` = 1 (helper preserved). LOC delta 1415 → 1273 (−142, slightly more than the planned ~110 because the inline-block deletion absorbed surrounding blank-line structure). |
| AC-3 | Pi runtime behavior and install surface preserved | **PASS** | `PALS_ROOT="$PWD" bash drivers/pi/install.sh` → `[ok] Pi extensions installed: 4 files` (was 3); the four installed files (`pals-hooks.ts`, `module-activity-parsing.ts`, `artifact-slice-rendering.ts`, `workflow-resource-capsule-rendering.ts`) all carry default-exported factories (the prior three from Phase 245 hotfix; the fourth is the new sibling). The repointed `Workflow/resource capsule runtime markers preserve schema, fallback, and non-authority` TAP block continues to pass against the new file, proving every visible marker, source-type marker, fallback, and non-authority phrase still renders byte-exactly. |
| AC-4 | Pi e2e suite gains exactly the Phase 246 guardrails; existing capsule block repointed; suite stays green; cross-harness unchanged | **PASS (with anticipated multi-block delta)** | `bash tests/pi-end-to-end-validation.sh` → `# Total: 221`, `# Failed: 0` (was 218; **+3 net**, not the +1 estimate). The +3 is one repointed block keeping count flat plus three new blocks: (a) positive assertion on the new sibling under shared title `Phase 246 sibling extraction (workflow-resource-capsule-rendering): single-defined and import-wired`, (b) positive `import { renderWorkflowResourceCapsules } ...` assertion on `pals-hooks.ts`, (c) `tap_file_contains_none` negative assertion that `pals-hooks.ts` no longer defines `function buildWorkflowResourceCapsule(`, `function renderWorkflowResourceCapsules(`, or `WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS = [`. AC-4 explicitly authorized this: "the suite runs green at 1..219/0 ... otherwise reconcile actuals in SUMMARY". `bash tests/cross-harness-validation.sh` → `# Total: 129`, `# Failed: 0` (unchanged). `bash tests/helpers/artifact_consistency.sh` → `artifact_consistency_check: PASS`. `git diff --check` → exit 0. |
| AC-5 | Boundary preservation — no out-of-scope edits | **PASS** | `git diff --name-only c2aacd54..HEAD` shows: `.paul/MILESTONES.md`, `.paul/ROADMAP.md`, `.paul/STATE.md`, `.paul/phases/246-s2-workflow-resource-capsule-rendering-extraction/246-01-PLAN.md`, `.paul/phases/246-s2-workflow-resource-capsule-rendering-extraction/246-01-SUMMARY.md` (added in UNIFY), `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/extensions/workflow-resource-capsule-rendering.ts`, `tests/pi-end-to-end-validation.sh`. No edits to `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, `drivers/pi/install.sh`, `drivers/pi/uninstall.sh`, `drivers/pi/driver.yaml`, `kernel/`, `modules/`, `package.json`, `tests/helpers/`, `tests/cross-harness-validation.sh`, `.github/`, or `pals.json`. No `.paul/*` artifact authority reassigned. No new contract docs authored. Install surface produces `4 files`. |

## Verification Results

```
$ bash tests/pi-end-to-end-validation.sh
# Passed: 221
# Failed: 0
# Total:  221

# ALL CHECKS PASSED
```

```
$ bash tests/cross-harness-validation.sh
# Passed: 129
# Failed: 0
# Total:  129

# ALL CHECKS PASSED
```

```
$ bash tests/helpers/artifact_consistency.sh
artifact_consistency_check: PASS
```

```
$ git diff --check
(exit 0; clean)
```

```
$ PALS_ROOT="$PWD" bash drivers/pi/install.sh
  [ok] Pi extension installed: ~/.pi/agent/extensions/artifact-slice-rendering.ts
  [ok] Pi extension installed: ~/.pi/agent/extensions/module-activity-parsing.ts
  [ok] Pi extension installed: ~/.pi/agent/extensions/pals-hooks.ts
  [ok] Pi extension installed: ~/.pi/agent/extensions/workflow-resource-capsule-rendering.ts
  [ok] Pi extensions installed: 4 files
```

## Module Execution Reports

### Pre-plan advisory
- **CODI:** 2 symbols (`buildWorkflowResourceCapsule`, `renderWorkflowResourceCapsules`) resolved at depth 1–3, behavioral, chain-confidence ≈0.90. Resolved 2/2.
- **TODD:** No spec/unit tests; existing TAP shell suites carry validation. Plan stays `execute`. Test-suite update required (capsule TAP block repoint + Phase 246 guardrails).
- **ARCH:** Cycle-avoidance posture confirmed — no further default-arg surgery needed beyond Phase 243's existing fix; Phase 245 loader-compat invariant flagged as a hard constraint on the new sibling.
- **IRIS / RUBY:** Pre-existing `pals-hooks.ts` size debt reduced by S2 footprint (~110 LOC plan estimate; actual −142 LOC).
- **DEAN:** No new dependencies; PASS.
- **DAVE / DOCS:** No installer/`driver.yaml`/dep/CI changes; surfacing of the new sibling deferred to Phase 247.

### Pre-apply baseline
Pi e2e 218/218; cross-harness 129/129; artifact_consistency PASS captured before APPLY.

### Post-task hooks (×4)
- T1 (author new sibling): TODD/CODI/ARCH/IRIS/RUBY clean; no regressions.
- T2 (rewire pals-hooks): clean; helpers preserved as planned.
- T3 (repoint TAP + add guardrails): suite green at +3 net; multi-block split AC-anticipated.
- T4 (install + validate): `4 files` install; all four official validations pass.

### Post-apply advisory
- CODI ✓ (chain stable; no new fan-in spikes); TODD ✓ (TAP-only, no spec/unit drift); IRIS ✓ (sibling boundary clean); RUBY ✓ (S2 footprint cleanly relocated); DOCS ✓ (deferred to Phase 247 per plan); DAVE ✓ (install surface auto-covered, 3→4 files clean).

### Post-apply enforcement
- WALT ✓ Pi 221/221 + cross-harness 129/129 + artifact_consistency PASS + `git diff --check` clean.
- DEAN ✓ no new dependencies.
- ALL GATES PASS.

### Post-unify hooks
- SKIP / IRIS / RUBY persistence: this SUMMARY records the durable S2 extraction recipe match (S5 + S1 + S2 now all use the same sibling-module pattern with shared helpers exported from `pals-hooks.ts` and trailing no-op default factory). Knowledge artifact: third independent confirmation of the recipe — pattern is now ratified, not provisional.
- REV: skipped (opt-in via `/paul:review`; not enabled for `pr_review` in `pals.json`).
- DEAN persistence: dependency state unchanged from baseline.

## Deviations

| Plan estimate | Actual | Reason | Impact |
|---------------|--------|--------|--------|
| Pi e2e count delta `+1` | `+3` (218 → 221) | Multi-block split: (a) repointed existing capsule block (count flat), (b) positive on new sibling, (c) positive `import` on `pals-hooks.ts`, (d) `tap_file_contains_none` negative assertion. AC-4 explicitly authorized "reconcile actuals in SUMMARY". | None — suite green; precedent-aligned with Phase 244/245 multi-file split. |
| `pals-hooks.ts` LOC delta `−110` | `−142` | Inline-block deletion absorbed surrounding blank-line structure and grouped-import vertical space. | None — pure hygiene; behavior unchanged. |
| Plan T1 imports list mentioned `escapeRegExp` and `PalsStateSnapshot` as conditional | Final imports include only `compactWhitespace`, `readFileOr`, `getFileFreshness`, `selectBoundedLines` | Static check during T1 confirmed `escapeRegExp` and `PalsStateSnapshot` are not referenced by S2 code; T1 step 3 directed: "if a static analysis pass shows they are unreferenced, omit them … to keep the module imports tight". | None — followed plan instruction. |
| Mid-APPLY discovery: pre-existing 2 baseline failures (`Repo ROADMAP stays within active-window line budget`, `PALS artifact consistency guardrail`) | Resolved before APPLY proceeded | The `/paul:milestone` step earlier in the session pushed `.paul/ROADMAP.md` past the active-window budget and left `.paul/MILESTONES.md` Live Status pointing at v2.56-closed instead of v2.57-active. | Resolved inline by compacting the v2.57 milestone block in `ROADMAP.md` (104 lines, restored), aligning the STATE phase-name format to the ROADMAP table, and updating `MILESTONES.md` Live Status to point at Phase 246. Logged here for transparency; no functional impact on Phase 246 extraction. |

## Key Patterns / Decisions

- **Sibling-module pattern is now ratified by triple confirmation.** S5 (Phase 239), S1 (Phase 243), and S2 (Phase 246) all follow the same shape: dedicated `drivers/pi/extensions/<name>.ts`, helpers imported from `./pals-hooks`, single-defined exact-marker exports, trailing no-op default-exported factory + `No-op Pi extension factory` marker. Future S3/S4/S6/S7/S8 extractions can apply this recipe verbatim.
- **Phase 245 Pi extension loader-compat invariant is now a per-extraction acceptance criterion**, asserted inline in the extraction TAP block rather than waiting for a separate hotfix phase. This catches loader breakage at extraction time rather than at the next session start.
- **Negative-assertion via `tap_file_contains_none`** proves moved symbols actually leave the original file, not just that the new file got them. This complements the positive single-defined check on the new sibling and prevents accidental double-definition.
- **Helper-import tightening** at extraction time (omit unreferenced helpers like `escapeRegExp`/`PalsStateSnapshot`) keeps the new module imports honest and the boundary surface minimal.
- **Decision: defer S3 to v2.58 at the earliest.** The `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md` baseline classifies S3 `guided-workflow-detection` as "larger and contract-sensitive, conditional secondary candidate only after S1/S2 bounds are stable." Phase 246 stabilizes S2 but does not validate S3 readiness; the baseline says wait. This plan honors that.

## Next Phase

- **Phase 247: Documentation + Validation Surfacing.** Surface the new S2 sibling across `drivers/pi/extensions/README.md`, `drivers/pi/skill-map.md`, `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md` (status-row update), and `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` (S2 row update). Add a cross-harness `tap_file_contains_all` block asserting docs name `workflow-resource-capsule-rendering.ts` alongside the other three siblings; co-locate with the existing Phase 244 surfacing block.
- Phase 248 will then aggregate v2.57 evidence into `.paul/MILESTONES.md` and `.paul/PROJECT.md` and record the v2.58 recommendation (default candidate: S3 `guided-workflow-detection` conditional secondary, contingent on S2 stability).

Skill audit: this plan did not declare a `<skills>` section, and `.paul/SPECIAL-FLOWS.md` does not currently mark per-plan skills as required for sibling extractions; standard /paul, TODD, WALT lifecycle was followed inline. No gaps to record.
