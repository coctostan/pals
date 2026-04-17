---
phase: 174-source-file-symbol-extraction
plan: 01
completed: 2026-04-17T13:56:50Z
duration: ~38 minutes (APPLY + UNIFY, continuous session)
---

## Objective

Extend CODI's extractor contract so plans can seed `impact` from repo-relative source files named in PLAN `<context>`, not just from roadmap/objective prose, while preserving v0.1's bounded, no-magic, advisory-only behavior.

## What Was Built

| File | Purpose | Lines |
|------|---------|-------|
| `modules/codi/module.yaml` | Expanded CODI Step 1 so upcoming-plan `<context>` repo-relative `.ts/.tsx/.js/.jsx` paths act as bounded source selectors, with a pinned top-level declaration set and preserved no-magic guardrails | 103 |
| `modules/codi/references/codi.md` | Mirrored the selector-vs-seed contract, ordering rules, declaration set, and install-surface rollout guidance for the new extractor behavior | 138 |
| `kernel/workflows/plan-phase.md` | Refined `prepare_codi_seed_candidates` to build deterministic source-derived seeds from the upcoming plan context without rereading a finished PLAN artifact | 368 |
| `tests/pi-end-to-end-validation.sh` | Added installed-surface semantic assertions covering Phase 174 source-selector markers | 1102 |
| `tests/cross-harness-validation.sh` | Added cross-harness semantic assertions covering the same source-selector markers across repo and installed surfaces | 708 |

**Supporting lifecycle artifacts during APPLY:**

- `.paul/phases/174-source-file-symbol-extraction/174-01-PLAN.md` was created and executed.
- `PALS_ROOT="$(pwd)" bash drivers/pi/install.sh` reinstalled the updated CODI/module/workflow surfaces.
- PR opened during APPLY: `#84` — `https://github.com/coctostan/pals/pull/84`.

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | CODI's manifest and reference doc include PLAN `<context>` source-file declaration extraction | ✅ PASS | `modules/codi/module.yaml` and `modules/codi/references/codi.md` now describe repo-relative source selectors, the `.ts/.tsx/.js/.jsx` extension set, the top-level declaration pass, stable-identifier extraction, and preserved safe-skip / partial-success guardrails. |
| AC-2 | Shared planning workflow prepares and reuses source-derived seeds deterministically | ✅ PASS | `kernel/workflows/plan-phase.md` now builds `codi_seed_candidates` from the upcoming plan context block, treats paths as selectors not final `impact` inputs, preserves source-file mention order plus declaration order within each file, and caps extracted identifiers at 1-5. |
| AC-3 | Repo and installed surfaces reflect the extractor iteration with explicit validation coverage and no later-phase scope creep | ✅ PASS | Installer rerun succeeded, both validation suites passed (`166/166`, `70/70`), and validation scripts now assert the new source-selector markers across repo and installed surfaces without touching later-phase install/docs/instrumentation work. |

## Verification Results

```text
=== Task 1 verify ===
grep -n 'source selectors\|top-level function declarations\|exported const / arrow bindings\|\.tsx\|\.jsx\|stable identifiers surfaced' modules/codi/module.yaml modules/codi/references/codi.md
  PASS — selector markers, declaration-set wording, and extension-set wording present in manifest/reference surfaces.

=== Task 2 verify ===
grep -n 'upcoming plan context block\|source selectors\|source-file mention order\|declaration order within each file\|stable extracted identifiers' kernel/workflows/plan-phase.md
  PASS — bounded upcoming-context source-selector pass and deterministic ordering markers present in `prepare_codi_seed_candidates`.

=== Task 3 verify ===
grep -n 'source selectors\|upcoming plan context block\|declaration order within each file' tests/pi-end-to-end-validation.sh tests/cross-harness-validation.sh
  PASS — Phase 174 semantic validation markers present in both validation suites.

PALS_ROOT="$(pwd)" bash drivers/pi/install.sh
  [ok] CODI module installed
  [ok] modules.yaml generated (20 modules)

bash tests/pi-end-to-end-validation.sh
  # Passed: 166
  # Failed: 0
  # Total:  166
  # ALL CHECKS PASSED

bash tests/cross-harness-validation.sh
  # Passed: 70
  # Failed: 0
  # Total:  70
  # ALL CHECKS PASSED
```

## Module Execution Reports
**PLAN phase:**
- `[dispatch] ARCH (p75) → pass` — planned work stayed bounded to the CODI manifest/reference/workflow surfaces; existing large validation files were flagged as caution-only.
- `[dispatch] TODD (p100) → skip` — no `.test` / `.spec` implementation scope for this workflow/docs/yaml phase.
- `[dispatch] IRIS (p150) → pass` — no TODO/FIXME/HACK/XXX markers in planned files.
- `[dispatch] DOCS (p200) → pass` — the canonical CODI reference doc was already in scope.
- `[dispatch] CODI (p220) → unresolved-only injection expected` — Phase 174's own planning run still dispatched against the v2.39 installed extractor, consistent with Milestone Invariant 2.
- `[dispatch] DEAN / SETH / ARCH circular-dep → pass-or-skip with no blocks`.
**APPLY phase:**
- APPLY produced the expected bounded result set: CODI manifest/reference extraction updates, `prepare_codi_seed_candidates` source-selector logic, and minimal semantic validation markers.
- `PALS_ROOT="$(pwd)" bash drivers/pi/install.sh` completed successfully, making the new extractor contract live on the installed Pi surface.
- `bash tests/pi-end-to-end-validation.sh` and `bash tests/cross-harness-validation.sh` both passed after reinstall, proving repo and installed surfaces aligned.
- DOCS advisory remained limited to changelog drift (`CHANGELOG.md` untouched while functional repo files changed); no later-phase installer/docs instrumentation work slipped into scope.
**UNIFY phase:**
- `[dispatch] pre-unify: 0 modules registered for this hook`
- `[dispatch] post-unify: WALT(p100) → 1 report / 1 side effect | SKIP(p200) → 1 report / 0 side effects | RUBY(p300) → 1 report / 0 side effects`

**Post-unify durable reports:**
- **WALT report:** Recorded Phase `174-01` in `.paul/QUALITY-HISTORY.md` as `166 pass + 70 pass`, coverage/lint/types `—`, trend `↑ improving` (both validation suites gained one passing check from the new source-selector assertions).
- **SKIP report:**

  ## [2026-04-17] CODI Phase 174 source files are bounded selectors, not `impact` inputs
  **Type:** decision
  **Phase:** 174-source-file-symbol-extraction
  **Related:** `modules/codi/module.yaml`, `modules/codi/references/codi.md`, `kernel/workflows/plan-phase.md`

  **Context:** Phase 173 proved codegraph value on TS-touching scope, but CODI still extracted markdown-layer tokens from prose-heavy plan text.

  **Decision:** Upcoming-plan `<context>` repo-relative `.ts/.tsx/.js/.jsx` paths are bounded selectors used for read-only declaration extraction; only extracted stable identifiers become final `impact` candidates.

  **Alternatives considered:**
  - Pass raw file paths straight to `impact` — rejected because file paths are selectors, not graph symbols.
  - Expand into codebase-wide or semantic inference — rejected because it breaks CODI's no-magic bounded scope.

  **Rationale:** This fixes extractor-vs-scope alignment with minimal surface area and preserves v0.1's advisory safety model.

  **Impact:** Phase 175 planning is the first live session expected to benefit from source-file selector extraction.

  ## [2026-04-17] Extraction-layer fixes beat broader tool expansion for CODI v0.1
  **Type:** lesson
  **Phase:** 174-source-file-symbol-extraction
  **Related:** `modules/codi/module.yaml`, `modules/codi/references/codi.md`, `kernel/workflows/plan-phase.md`, `tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh`

  **What happened:** Phase 174 closed the trial gap by improving extractor inputs instead of adding new codegraph tools or PLAN template sections.

  **What we learned:** The highest-leverage improvement was choosing better explicit inputs, not widening CODI's scope.

  **How to apply:** Keep later CODI iterations bounded; only add new tool surfaces when extractor/input quality no longer explains the observed trial outcomes.
- **RUBY report:** No JS/TS implementation files changed for ESLint complexity analysis. `wc -l` still surfaces existing file-size debt in `tests/pi-end-to-end-validation.sh` (1102, critical), `tests/cross-harness-validation.sh` (708, critical), and `kernel/workflows/plan-phase.md` (368, warn). Phase 174's edits were bounded marker/wiring changes, so no refactor candidate is required now; future phases should keep these files surgical.
- **Side effects:** WALT appended `174-01` to `.paul/QUALITY-HISTORY.md`.

## Deviations

- **No material execution deviations.** Tasks 1–3 completed within the plan's bounded surfaces and all acceptance criteria passed.
- **Validation scope expanded only where the plan explicitly allowed it.** The two legacy validation scripts received small semantic-marker assertions and no broader refactor.
- **Git history includes lifecycle artifacts in the APPLY range.** The branch diff from `ce3b96f..1c3d2b7` includes `.paul/ROADMAP.md`, `.paul/STATE.md`, archived handoff movement, and the committed PLAN artifact alongside the planned implementation files. This is normal lifecycle bookkeeping, not scope creep.

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Treat repo-relative `.ts/.tsx/.js/.jsx` paths in the upcoming plan `<context>` block as bounded source selectors, not direct `impact` inputs | Fixes Phase 173's extractor-vs-scope mismatch without widening CODI into semantic guessing or codebase-wide search | Phase 175 becomes the first live planning session expected to exercise the new extractor path |
| Build source-derived seeds from the upcoming plan context instead of rereading a finished PLAN artifact | Keeps planning read discipline intact and makes CODI seeding deterministic before the plan is written | Preserves existing PLAN template shape while improving CODI's input quality |
| Keep Phase 174 validation bounded to stable semantic markers in the existing Pi and cross-harness suites | Proves the new contract on repo and installed surfaces without turning this phase into a broad validation rewrite | Later phases remain responsible for installer probing, value-envelope docs, and instrumentation |

## Key Patterns / Decisions

- **The Phase 173 gap was in extraction, not codegraph capability.** This phase confirms the highest-leverage fix is to read the right explicit inputs (upcoming-plan source selectors) rather than to widen CODI into new tools or broader inference.
- **Selector-vs-seed separation keeps CODI honest.** Raw repo-relative file paths are useful for bounded reads but should not be passed straight to `impact`; only extracted stable identifiers become final candidates.
- **Deterministic ordering is sufficient.** Explicit identifiers first, then source-derived declarations in source-file mention order and declaration order within each file, gives a stable 1-5 candidate set without new planner complexity.
- **Milestone Invariant 2 remains intact.** Phase 174 shipped the extractor iteration, but its own planning run was still expected CODI_NULL because the installed surface was only refreshed during APPLY.

## Skill Audit (Phase 174)

| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the Phase 174 source-selector iteration |
| /carl | ✓ | Session-boundary/runtime path remained active throughout the loop |
| TODD | ✓ | Required verification overlay stayed active even though the phase used execute-style shell validation rather than TDD restructuring |
| WALT | ✓ | Installer-backed validation ran during APPLY and quality evidence was recorded during UNIFY |

## Next Phase

**Phase 175: Install-Time Detection + Value-Envelope Docs + Format Fix.** The newly installed Phase 174 extractor is now live, so Phase 175 planning becomes the first real session expected to exercise source-file selector extraction. That next phase remains bounded to install-time codegraph detection, honest value-envelope documentation, and the loose-end success-log format clarification deferred from Phase 173.
