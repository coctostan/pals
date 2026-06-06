# PAUL Handoff

status: paused
created: 2026-06-05
phase: 304 of 305 — Extraction + Import Repoint
plan: 304-01 (planned, approved-pending; ready for APPLY)
loop: PLAN ✓ / APPLY ○ / UNIFY ○
state_authority: .paul/STATE.md
resume_action: /paul:apply for Phase 304 Plan 304-01
wip_result: base-branch (on `main`; GitHub Flow forbids WIP commit on base branch)

git_snapshot:
  workflow: github-flow
  branch: main (no feature branch yet — APPLY will create it)
  base: main
  pr: none
  ci: N/A
  sync: 0 ahead / 0 behind origin/main
  note: snapshot only; resume rechecks live git state when github-flow routing applies. Uncommitted `.paul/*` lifecycle artifacts present (Phase 304 PLAN + STATE/ROADMAP edits); they move onto the feature branch at APPLY start. `.paul/presentation-packets/` is derived — do NOT commit (v2.71 no-committed-.html guardrail).

progress:
  done:
    - Phase 303 closed + merged (PR #223 squash `ee5a9010`); shared-runtime-helpers contract authored.
    - Repaired lifecycle-artifact hygiene from the 303 transition (PROJECT.md was 25,718 B > 25,000 budget; MILESTONES pointer lagged) → commit `be02493b`. Baseline restored green.
    - Created Phase 304 PLAN (304-01): extract 8 helper symbols into a leaf, repoint 9 importers + Pi-e2e TAPs. STATE Loop → PLAN ✓; ROADMAP Phase 304 → Planning.
    - Verified baseline this session: Pi e2e 342/342, cross-harness 253/253, artifact consistency PASS.
  in_progress:
    - Phase 304 APPLY not started (paused at apply-decision prompt).
  blockers:
    - none
  decisions:
    - Move set fixed by Phase 303 contract (8 symbols): compactWhitespace, escapeRegExp, selectBoundedLines, readFileOr, getFileFreshness, parsePalsState, extractLoopSignature + PalsStateSnapshot type → new leaf drivers/pi/extensions/shared-runtime-helpers.ts.
    - Leaf is Node-only (fs/path); NO back-import to pals-hooks needed (PalsStateSnapshot moves WITH the helpers) — unlike S6/S7/S8 which needed type-only back-imports.
    - Stay-put on ./pals-hooks: collectRecentAssistantTexts, MAX_WIDGET_MODULE_DETAILS, MAX_VISIBLE_MODULES, RECENT_MODULE_ACTIVITY_LOOKBACK, ActivationState (+ CARL/activation/routing).
    - Installer auto-discovers the new *.ts (no install.sh edit); install count 8→9.
    - TAP-assertion repoint needed in tests/pi-end-to-end-validation.sh (~lines 1835, 1886 pin old import locations); grep all 8 moved symbols + pals-hooks to catch every hit (Phase 262 lesson: contracts under-enumerate TAP candidates).
    - No installed modules.yaml registry (kernel-source repo) → dispatch records honest NOT FOUND warnings.

files:
  - path: .paul/phases/304-extraction-import-repoint/304-01-PLAN.md
    reason: The approved-pending plan to execute on resume (3 tasks, 3 ACs).
  - path: docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md
    reason: Authoritative spec the plan executes (helper inventory + importer map + leaf/cycle rules).
  - path: drivers/pi/extensions/pals-hooks.ts
    reason: Source file the 8 symbols are extracted FROM (Task 1).
  - path: tests/pi-end-to-end-validation.sh
    reason: TAP assertions to repoint + new bounded leaf block (Task 3).
  - path: .paul/phases/262-bounded-s8-submodule-extraction/262-01-SUMMARY.md
    reason: Closest precedent (S8 extraction) for repoint discipline + verification approach.

handoff_lifecycle:
  prior_active: none (Phase 303 handoff already archived to .paul/handoffs/archive/)
  note: archived handoffs are history; STATE remains source of truth

resume:
  command: /paul:resume
  expected_next: /paul:apply for Phase 304 Plan 304-01
