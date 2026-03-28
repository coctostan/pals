---
phase: 161-wrapper-entrypoint-slimming
plan: 01
completed: 2026-03-28T01:56:10Z
duration: ~1 session
---

## Objective
Slim the core Pi wrapper skill shells so they behave as true command-local entrypoints instead of restating workflow-owned read bundles and process prose, while keeping route-specific guardrails explicit and preserving shared workflow authority.

## What Was Built

| File | Purpose | Lines |
|------|---------|------:|
| `drivers/pi/skills/paul-{apply,discuss,fix,init,milestone,pause,plan,resume,status,unify}/SKILL.md` | Slimmed the 10 core lifecycle wrappers to canonical-workflow pointers plus route-specific guardrails | 182 |
| `drivers/pi/skills/paul-help/SKILL.md` | Kept the Pi help surface explicit about `/paul-*` wrappers, canonical `/skill:paul-*` entrypoints, shortcuts, and module overlays | 50 |
| `tests/pi-end-to-end-validation.sh` | Added thin-wrapper semantic checks for the slimmer contract without relying on duplicated read-scaffolding assertions | 879 |

Total repo-source output updated for this phase: **1111 lines** across **12 modified source files**.

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Core Pi wrappers become command-local shells | PASS | The 10 targeted lifecycle wrappers now point to canonical workflows and retain only route-local guardrails; duplicated `Read project state:` scaffolding was removed |
| AC-2 | High-signal entrypoint semantics remain explicit | PASS | `paul-apply`, `paul-resume`, `paul-status`, `paul-plan`, `paul-discuss`, `paul-init`, `paul-milestone`, `paul-fix`, `paul-pause`, `paul-unify`, and `paul-help` still preserve their safety-relevant routing semantics |
| AC-3 | The slimmer wrapper contract is deployed and regression-proofed | PASS | `PALS_DRIVER=pi bash install.sh`, `bash tests/pi-end-to-end-validation.sh`, and `bash tests/cross-harness-validation.sh` all passed after the wrapper changes were installed |

## Reconciliation: Plan vs Actual

### Task 1 — Slim the core Pi lifecycle wrapper shells to a command-local contract
**Planned:** rewrite the core lifecycle wrappers so they keep canonical workflow references and only wrapper-specific notes.

**Actual:** completed as planned.
Key outcomes included:
- all 10 targeted lifecycle wrappers were reduced to concise command-local shells
- route-specific guardrails stayed explicit, including parent-authoritative APPLY, authoritative `STATE.md` resume/status routing, collaboration-aware planning semantics, and loop-specific pause/fix/unify expectations
- lifecycle truth remained in shared workflows and `.paul/*` artifacts

### Task 2 — Align the help surface and Pi validation script with the slimmer wrapper contract
**Planned:** keep the help surface explicit and harden validation around semantic wrapper guarantees instead of duplicated prose.

**Actual:** completed as planned.
Key outcomes included:
- `paul-help` now explains the wrapper-vs-canonical model more directly
- Pi validation now checks for thin-wrapper semantics and the absence of duplicated read-bundle scaffolding
- validation remained section-local to the existing Pi skill/discovery coverage instead of becoming a broader script refactor

### Task 3 — Reinstall the Pi surface and run full regression validation
**Planned:** reinstall the Pi driver surface and prove the slimmer wrapper contract with Pi and cross-harness validation.

**Actual:** completed with one minor variance.
- the Pi surface was reinstalled from repo-source files and the validation suites passed
- `install.sh` and `tests/cross-harness-validation.sh` were used as verification surfaces only; they did not require repo edits
- this is a plan metadata over-scope issue, not an implementation failure

## Verification Results

### Ground-truth reconciliation
- `git --no-pager diff --stat HEAD^..HEAD` matched the expected wrapper/help/validation changes plus normal lifecycle bookkeeping artifacts for the phase
- Planned repo-source edits matched actual source edits except for `install.sh` and `tests/cross-harness-validation.sh`, which were exercised as verification surfaces but not modified
- No installed runtime copies under `~/.pi/agent/...` were edited directly; all changes stayed in repo-source files

### File and contract checks
- `for f in drivers/pi/skills/paul-{apply,discuss,fix,init,milestone,pause,plan,resume,status,unify}/SKILL.md; do test -f "$f" || exit 1; grep -qi 'workflow' "$f" || exit 1; ! grep -q 'Read project state:' "$f" || exit 1; done` ✅
- `bash tests/pi-end-to-end-validation.sh` → **143/143 passed** ✅
- `PALS_DRIVER=pi bash install.sh && bash tests/pi-end-to-end-validation.sh && bash tests/cross-harness-validation.sh` → **Pi install successful, 143/143 Pi checks passed, 60/60 cross-harness checks passed** ✅
- Phase plan count vs summary count after summary creation: **1 / 1** ✅

### Skill audit
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for Phase 161 |
| /carl | ✓ | Session-boundary routing remained configured during execution |
| TODD | ✓ | APPLY/UNIFY validation path preserved regression checks for the modified wrapper contract |
| WALT | ✓ | Validation suites were run during APPLY and quality history was updated during UNIFY |

## Module Execution Reports

[dispatch] pre-unify: 0 modules registered for this hook

### Carried forward from APPLY
- `[dispatch] pre-apply: SKIPPED — shell-based validation continued to serve as the practical baseline path for this wrapper/documentation-focused implementation pass`
- `[dispatch] post-apply advisory: SKIPPED — no material advisory annotations surfaced for the wrapper/help/validation changes`
- `[dispatch] post-apply enforcement: WALT → PASS | DEAN → SKIPPED (no supported package manager or audit target detected) | TODD → PASS`

### Post-unify
- WALT (p100): PASS — quality delta is **improving**. Added `161-01` to `.paul/QUALITY-HISTORY.md` with tests at **143 pass + 60 pass**, coverage/lint/types unchanged (`—`), trend `↑ improving`
- SKIP (p200): PASS — captured durable knowledge from this phase:
  - **Decision Record:**
    - **Title:** Keep Pi wrapper shells as command-local deltas while retaining route-specific guardrails
    - **Type:** decision
    - **Phase:** 161 — Wrapper & Entrypoint Slimming
    - **Related:** `drivers/pi/skills/paul-apply/SKILL.md`, `drivers/pi/skills/paul-plan/SKILL.md`, `drivers/pi/skills/paul-resume/SKILL.md`, PR #70
    - **Context:** Phase 160 recommended workflow-first context reduction, and the wrapper layer was identified as a safe place to cut repeated read scaffolding without changing lifecycle truth.
    - **Decision:** Slim the Pi wrapper shells down to canonical workflow references plus only the route-specific guardrails that are safety-relevant.
    - **Alternatives considered:**
      - Leave the wrappers verbose — rejected because it preserves recurring duplicate context with little additional safety value.
      - Move lifecycle semantics into Pi-only wrappers — rejected because it would split authority away from shared workflows and `.paul/*` artifacts.
    - **Rationale:** The wrapper layer should express entrypoint deltas, not restate shared workflow internals.
    - **Impact:** Future wrapper cleanup should preserve command-local semantics while continuing to keep shared markdown workflows authoritative.
  - **Decision Record:**
    - **Title:** Prefer semantic thin-wrapper validation over brittle line-count or prose-shape assertions
    - **Type:** decision
    - **Phase:** 161 — Wrapper & Entrypoint Slimming
    - **Related:** `tests/pi-end-to-end-validation.sh`, `drivers/pi/skills/paul-help/SKILL.md`, PR #70
    - **Context:** The wrappers became intentionally shorter, so validation needed to prove the new contract without coupling to exact phrasing or file length.
    - **Decision:** Add checks for workflow references, route-specific guardrails, and absence of duplicated read-bundle scaffolding instead of line-count-based assertions.
    - **Alternatives considered:**
      - Keep previous structural-only checks — rejected because they would not prove the thinner contract.
      - Add brittle line-count checks — rejected because wrapper wording should stay free to evolve as long as the semantic contract holds.
    - **Rationale:** Semantic assertions are more stable and better aligned with the actual lifecycle guarantees.
    - **Impact:** Future validation changes should prefer behavior/contract evidence over prose-shape coupling.
  - **Lesson Learned:**
    - **Title:** Thin wrapper contracts need explicit semantic tests to stay durable
    - **Type:** lesson
    - **Phase:** 161 — Wrapper & Entrypoint Slimming
    - **Related:** `drivers/pi/skills/paul-help/SKILL.md`, `tests/pi-end-to-end-validation.sh`, PR #70
    - **What happened:** The wrapper shells were trimmed successfully, but the existing validation suite initially lacked checks for some retained resume/collaboration semantics.
    - **What we learned:** Wrapper slimming is safest when the validation layer checks retained guardrails directly, not just file existence or generic workflow mentions.
    - **How to apply:** Treat future wrapper/entrypoint cleanup as contract work: trim prose, then add semantic coverage for the retained behavior.
- RUBY (p300): WARN — `wc -l` on changed files shows the wrapper/help files are compact, but `tests/pi-end-to-end-validation.sh` is now **879 lines**, which remains the main debt hotspot in this phase. Suggested future refactor: split repeated assertion helpers or category-specific checks before expanding the script further.

## Deviations
- Task 3's `<files>` list included `install.sh` and `tests/cross-harness-validation.sh`, but those files were used only as verification surfaces and did not require repo edits.

## Key Patterns / Decisions
- Wrapper shells are a safe reduction target when they remain command-local and keep shared workflows authoritative
- Resume/status safety depends on preserving authoritative `STATE.md` routing and single-next-action semantics even as prose is reduced
- Thin-wrapper validation should assert retained behavior semantically instead of freezing wrapper wording
- The Pi validation suite is effective but increasingly large; future cleanup should target its structure before further expansion

## Merge Gate Status
- PR `#70` exists and CI is currently passing: https://github.com/coctostan/pals/pull/70
- Reviews are not required by `pals.json`
- Merge gate is ready for final PR merge resolution in UNIFY

## Next Phase
After the merge gate clears, transition to **Phase 162 — Workflow Read-Discipline Reduction**.
