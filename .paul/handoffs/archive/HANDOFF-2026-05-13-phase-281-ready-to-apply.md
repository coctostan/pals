# PAUL Handoff

status: paused
created: 2026-05-13T00:15:00Z
phase: 281 of 283 — Brownfield Convention Detection
plan: `.paul/phases/281-brownfield-convention-detection/281-01-PLAN.md` — PLAN complete; APPLY not started
loop: PLAN ✓ / APPLY ○ / UNIFY ○
state_authority: .paul/STATE.md
resume_action: /paul:apply .paul/phases/281-brownfield-convention-detection/281-01-PLAN.md
wip_result: skipped — github-flow base branch (`main`); pause leaves uncommitted PLAN/lifecycle/handoff changes for resume

git_snapshot:
  workflow: github-flow
  branch: main
  base: main
  pr: none for Phase 281 yet
  ci: N/A — APPLY not started
  sync: 0 ahead / 0 behind origin/main before pause artifacts
  note: snapshot only; resume rechecks live git state when github-flow routing applies

progress:
  done:
    - Phase 280 completed and merged via PR #198 (`dd55bf12`); merge-gate lifecycle recorded with `2ad31fe1`.
    - Phase 281 PLAN created at `.paul/phases/281-brownfield-convention-detection/281-01-PLAN.md`.
    - STATE and ROADMAP now route to Phase 281 APPLY.
  in_progress:
    - APPLY has not started.
    - Current uncommitted changes are pause/plan lifecycle artifacts for Phase 281 and this handoff.
  blockers:
    - None.
  decisions:
    - Phase 281 detection must be descriptive and source-backed; do not require brownfield repos to adopt functional architecture.
    - Do not touch generated AGENTS/init text, TODD/RUBY, ARCH, dependency config, or generated `.paul/codebase/` outputs during Phase 281 APPLY.

files:
  - path: .paul/STATE.md
    reason: Resume source of truth; points to Phase 281 PLAN complete / APPLY pending.
  - path: .paul/ROADMAP.md
    reason: Current milestone table marks Phase 281 Planning with plan path.
  - path: .paul/phases/281-brownfield-convention-detection/281-01-PLAN.md
    reason: Approved next APPLY target.
  - path: kernel/workflows/map-codebase.md
    reason: Planned APPLY target for brownfield functional/style signal detection prompts.
  - path: kernel/templates/codebase/architecture.md
    reason: Planned APPLY target for Brownfield Functional/Effect Boundaries section.
  - path: kernel/templates/codebase/conventions.md
    reason: Planned APPLY target for Brownfield Functional Style Signals section.
  - path: tests/pi-end-to-end-validation.sh
    reason: Planned APPLY target for installed Pi marker checks.
  - path: tests/cross-harness-validation.sh
    reason: Planned APPLY target for cross-harness marker checks.

handoff_lifecycle:
  prior_active: archived: .paul/handoffs/archive/HANDOFF-2026-05-12-phase-280-ready-to-plan.md
  note: archived handoffs are history; STATE remains source of truth

resume:
  command: /paul:resume
  expected_next: /paul:apply .paul/phases/281-brownfield-convention-detection/281-01-PLAN.md
