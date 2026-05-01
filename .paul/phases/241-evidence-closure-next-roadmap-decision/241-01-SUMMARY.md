---
phase: 241-evidence-closure-next-roadmap-decision
plan: 01
completed: 2026-05-01T19:35:00Z
duration: ~25 minutes (single session APPLY + UNIFY)
---

# Plan 241-01 — Evidence Closure + Install-Surface Generalization (SUMMARY)

## Objective

Close v2.55 by generalizing the Phase 239 install/uninstall one-off submodule deployment into a generalized Pi extension install surface, recording the resulting `driver.yaml` audit decision, adding bounded validation guardrails, and preserving the next-roadmap decision for v2.56.

## What Was Built

| File | Purpose | Lines (final) |
|------|---------|---------------|
| `drivers/pi/install.sh` | Generalized source-set rule: every `drivers/pi/extensions/*.ts` file is installed by basename into `~/.pi/agent/extensions/`; per-submodule `MODULE_ACTIVITY_SRC` special case removed | 425 (+21 / -10 net in scoped section) |
| `drivers/pi/uninstall.sh` | Iterates the resolved repo-owned extension source set; explicit fallback to known PALS extension basenames when `PALS_ROOT` is unavailable; never broad-deletes unrelated `~/.pi/agent/extensions/*.ts` | 88 (+56 / -7) |
| `drivers/pi/extensions/README.md` | Records the multi-file install boundary and the `driver.yaml` audit decision (existing `extensions/` directory entry is sufficient) | 227 (+9 / -1) |
| `drivers/pi/skill-map.md` | Mirrors the install boundary + audit language for the Pi-driver skill map | 140 (+1 / -1) |
| `tests/pi-end-to-end-validation.sh` | +1 localized TAP guardrail asserting generalized install/uninstall semantics, no `MODULE_ACTIVITY_SRC` one-off, no broad rm, and `driver.yaml` `extensions/` entry preserved | 1652 (+16) |
| `tests/cross-harness-validation.sh` | +1 localized TAP guardrail for shared docs + install-script invariant naming `drivers/pi/extensions/*.ts` and `driver.yaml` | 1268 (+19) |
| `.paul/STATE.md` | Loop position → APPLY ✓; PR #156 OPEN; resume pointer updated | (lifecycle) |
| `.paul/ROADMAP.md` | Phase 241 marked APPLY complete | (lifecycle) |
| `.paul/phases/241-evidence-closure-next-roadmap-decision/241-01-PLAN.md` | Approved Phase 241 plan | (lifecycle) |

`drivers/pi/driver.yaml` was **read/audit only** and intentionally **not modified** — see audit decision below.

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Generalized Pi extension install surface | PASS | `install.sh` loops `for ext_src in "$EXT_SRC_DIR"/*.ts`; live install of `pals-hooks.ts` + `module-activity-parsing.ts` succeeded with `[ok] Pi extensions installed: 2 files`; no per-submodule special case remains |
| AC-2 | Safe uninstall boundary | PASS | `uninstall.sh` resolves `PALS_ROOT_RESOLVED` then iterates the repo source set by basename; fallback list preserves usability without `PALS_ROOT`; no broad `rm -f $HOME/.pi/agent/extensions/*.ts` |
| AC-3 | Driver manifest audit decision recorded | PASS | `drivers/pi/driver.yaml` already lists `extensions/` under `files`; decision is recorded in `drivers/pi/extensions/README.md` and `drivers/pi/skill-map.md`; manifest unchanged |
| AC-4 | Bounded validation and scope | PASS | Pi `1..212/0` (cap met, +1 from 211 baseline); cross-harness `1..127/0` (cap met, +1 from 126 baseline); `bash tests/helpers/artifact_consistency.sh` PASS; `git diff --check` clean; non-lifecycle changes limited to the 6 plan-approved files |
| AC-5 | v2.55 closure evidence + v2.56 recommendation | PASS | This SUMMARY records install-surface generalization evidence, validation count reconciliation, driver.yaml audit outcome, deferred items, and one v2.56 recommendation (see "Next Phase / v2.56 Recommendation") |

## Verification Results

```
$ PALS_ROOT="$PWD" bash drivers/pi/install.sh | grep -E "Pi extension"
  [ok] Pi extension installed: ~/.pi/agent/extensions/module-activity-parsing.ts
  [ok] Pi extension installed: ~/.pi/agent/extensions/pals-hooks.ts
  [ok] Pi extensions installed: 2 files

$ bash tests/pi-end-to-end-validation.sh | tail -3
# Total:  212

# ALL CHECKS PASSED

$ bash tests/cross-harness-validation.sh | tail -3
# Total:  127

# ALL CHECKS PASSED

$ bash tests/helpers/artifact_consistency.sh | tail -1
artifact_consistency_check: PASS

$ git diff --check
(clean)
```

## Driver Manifest Audit Decision

`drivers/pi/driver.yaml`:

```yaml
files:
  - install.sh
  - uninstall.sh
  - skill-map.md
  - skills/
  - extensions/
```

The `extensions/` entry is a directory entry that already covers every `*.ts` sibling under `drivers/pi/extensions/`. No per-file enumeration is required, and the manifest does not need to be edited as new repo-owned extensions are extracted (e.g., future S1/S2/S3/S4/S6/S7/S8 submodules per `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md`).

**Decision:** `driver.yaml` is left unchanged. Audit decision is recorded in `drivers/pi/extensions/README.md` ("Multi-File Extension Install Boundary") and `drivers/pi/skill-map.md`. If a future phase finds contrary evidence (e.g., a packaging consumer that requires per-file manifest enumeration), the decision can be revisited then.

## Module Execution Reports

### APPLY phase (carried forward)

- `[dispatch] pre-apply baseline:` Pi `1..211/0`, cross-harness `1..126/0`, `artifact_consistency` PASS, `git diff --check` clean, DEAN PASS (no manifests in scope).
- `[dispatch] post-task(Task 1):` install/uninstall syntax + grep guardrails PASS; full suite reruns deferred to Task 3 official validation.
- `[dispatch] post-task(Task 2):` docs grep guardrails PASS; multi-file install boundary + driver.yaml audit text confirmed in both README.md and skill-map.md.
- `[dispatch] post-task(Task 3):` Pi `1..212/0` (+1, within cap), cross-harness `1..127/0` (+1, within cap), `artifact_consistency` PASS, `git diff --check` clean, live `bash drivers/pi/install.sh` installs 2 extensions via the source set.
- `[dispatch] post-apply advisory:` TODD / IRIS / RUBY / DOCS / CODI / DEAN / SETH PASS — no advisory blockers; installer one-off debt eliminated; docs updated; no manifest/lockfile/CI changes; uninstall avoids broad deletion.
- `[dispatch] post-apply enforcement:` WALT / DEAN / TODD PASS — no regression vs baseline; counts within bounded caps Pi 1..212 and cross-harness 1..127.

### UNIFY phase

- `[dispatch] pre-unify:` TODD/WALT/IRIS/RUBY/DOCS/SKIP — no blockers; APPLY annotations carried forward into this SUMMARY.
- `[dispatch] post-unify:` SKIP records v2.55 closure evidence and the v2.56 recommendation in this SUMMARY; no separate persistence module wrote to additional locations. Quality history, decisions, debt notes, and CODI history are captured in this SUMMARY plus per-task git commits.

### Skill audit

| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle authority for resume → apply → unify |
| /carl | ✓ | Session-boundary monitoring active across the session |
| TODD | ✓ | Bounded TAP guardrails added per plan |
| WALT | ✓ | Quality gating: validation suites + artifact consistency + diff check |

All required skills invoked ✓.

## Deviations

**One small lifecycle correction during APPLY pre-flight, no plan deviation:**

- During pre-apply baseline collection, `tests/helpers/artifact_consistency.sh` initially failed because `.paul/STATE.md` `Resume file` pointed at the now-archived handoff path `.paul/HANDOFF-2026-05-01-phase-241-plan-awaiting-approval.md`. Per the resume workflow's stated rule ("If STATE.md points to an archived handoff, that is still a valid resume context path"), the pointer was updated to `.paul/handoffs/archive/HANDOFF-2026-05-01-phase-241-plan-awaiting-approval.md`. This is a routine handoff-archive bookkeeping fix, fully within `.paul/*` lifecycle authority, and was committed alongside the planning metadata. No plan tasks were affected.

No other deviations. All three tasks executed exactly as planned. `driver.yaml` audit decision is "no edit needed" per AC-3 — recorded, not silently skipped.

## Key Patterns / Decisions

- **Source-set install rule over enumeration.** The Pi installer now treats `drivers/pi/extensions/*.ts` as a glob source set. This is the canonical pattern for repo-owned extension surfaces and removes recurring per-file installer drift as new extensions are extracted from `pals-hooks.ts` per the modularization contract.
- **`driver.yaml` directory entry is sufficient.** No per-file manifest enumeration is required for current packaging needs. Audit decision recorded in docs; manifest preserved as-is.
- **Uninstall safety boundary.** Uninstall iterates the repo source set when `PALS_ROOT` is resolvable, with an explicit fallback list of known PALS extension basenames when it is not. The earlier broad `rm -f` shape is explicitly avoided, so unrelated Pi extensions under `~/.pi/agent/extensions/` are preserved.
- **Bounded validation guardrails.** Each suite gained exactly one TAP assertion within the pre-declared caps (Pi `211 → 212`, cross-harness `126 → 127`), preventing suite churn while making the source-set semantics enforceable at validation time.

## Scope Proof

- Non-lifecycle files modified by this plan: 6 (matches `files_modified` frontmatter exactly).
- `.paul/*` lifecycle artifacts modified: STATE.md, ROADMAP.md, archived handoffs, this SUMMARY, the plan itself.
- Out-of-scope files NOT touched: `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/extensions/module-activity-parsing.ts`, `drivers/pi/driver.yaml`, `kernel/**`, `modules/**`, `.pi/agents/**`, `drivers/claude-code/**`, `drivers/agent-sdk/**`, `tests/helpers/**`, manifests, lockfiles, CI configuration, all `docs/PI-NATIVE-*-CONTRACT.md`, `docs/PALS-*` contract docs, `docs/PALS-FIRST-RUN-HAPPY-PATH.md`.
- Authority preserved: `.paul/*` artifact authority, `/paul-*` command surface, guided workflow canonical replies, artifact-slice/capsule behavior, helper delegation semantics, GitHub Flow gates, validation command-output truth.

## v2.55 Closure Status

Phase 241 is the final phase of v2.55 Maintainability & Product Reality Hardening (8 of 8 phases complete after this SUMMARY merges).

v2.55 outcomes shipped across phases 234–241:
- Phase 234–236: validation-suite decomposition baseline + artifact consistency guardrails (PR #150–#152).
- Phase 237: artifact consistency guardrails closure (PR #152).
- Phase 238: Pi extension modularization contract (PR #153).
- Phase 239: bounded Pi extension extraction spike — first S5 submodule extracted (PR #154).
- Phase 240: first-run happy-path scenario doc shipped (PR #155).
- Phase 241 (this plan): generalized Pi extension install surface, recorded `driver.yaml` audit decision, bounded validation guardrails, v2.56 recommendation (PR #156).

## Deferred (intentional, surfaced to v2.56)

- Local context-cost evidence work (Phase 240 deferred this; not done in Phase 241 by scope).
- Additional Pi extension submodule extractions (S1/S2/S3/S4/S6/S7/S8 per the modularization contract).
- Optional demo project preset.

These were explicitly out of scope for Phase 241 per its boundaries; they remain candidates for v2.56.

## Next Phase / v2.56 Recommendation

**Recommended v2.56 focus (one):** **Pi extension submodule extraction wave** — continue the Phase 239/241 pattern by extracting the next bounded submodule(s) from `pals-hooks.ts` (e.g., S1 lifecycle widget, S6 guided workflow UX, or another low-risk S-target per `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md`) using the now-generalized install surface. This compounds the maintainability dividend of Phase 241 (no further installer edits required) and continues monotone progress on extension modularization.

Alternative candidates if extraction is paused:
- Local context-cost evidence (deferred from Phase 240/241).
- Demo project preset for first-run UX.

Final v2.56 selection should happen via `/paul:milestone` after PR #156 merges and v2.55 is closed.

## Loop State After UNIFY

```
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ✓        ✓     [Plan 241-01 complete; v2.55 closure evidence shipped]
```

PR #156 (OPEN) carries this SUMMARY. Merge gate evaluates next.
