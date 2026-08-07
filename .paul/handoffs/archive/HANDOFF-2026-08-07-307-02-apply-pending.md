# PAUL Handoff

status: paused
created: 2026-08-07
phase: 307 of 308 — Retroactive Field Harvest
plan: 307-02 / planned, awaiting APPLY approval
loop: PLAN [✓] / APPLY [○] / UNIFY [○]
state_authority: .paul/STATE.md
resume_action: /paul:apply for Plan 307-02
wip_result: skipped — base-branch (on `main`; github-flow forbids WIP commits on base and PAUSE must not create branches)

git_snapshot:
  workflow: github-flow
  branch: main
  base: main
  pr: none — Plan 307-01's PR #227 merged as `ec14b2b7`; no PR open for 307-02
  ci: N/A — nothing pushed since the 307-01 merge
  sync: 0 ahead / 0 behind origin/main
  note: snapshot only; resume rechecks live git state when github-flow routing applies

progress:
  done:
    - Plan 307-01 UNIFY completed and merged via PR #227 (`ec14b2b7`, squash, branch deleted). SUMMARY written, 19 rows appended to `.paul/MODULE-LEDGER.md`, QUALITY/CODI history rows appended, prior handoff archived.
    - Plan 307-02 created at `.paul/phases/307-retroactive-field-harvest/307-02-PLAN.md` — 3 tasks, `type: tdd`, autonomous, AC-1..AC-4.
    - PLAN reconnaissance via `--dry-run` (zero writes to either external root): quark 154 SUMMARYs → 73 rows / 121 manifest (107 `no-dispatch-evidence`); hybrid-energy-reasoner 62 SUMMARYs → 72 rows / 21 manifest (17 `unmapped-status`).
    - STATE and ROADMAP updated for the new plan; ROADMAP trimmed from 12,035 B back to 11,985 B to stay under its 12,000 B ceiling.
    - Validation green at pause: Pi 355/355, cross-harness 257/257, artifact_consistency PASS.
  in_progress:
    - none; PLAN is complete and APPLY has not started.
  blockers:
    - none
  decisions:
    - **Uncommitted by design.** `307-02-PLAN.md`, `.paul/STATE.md`, and `.paul/ROADMAP.md` are uncommitted in the working tree on `main`. This matches how 307-01 ran: APPLY creates the feature branch and the plan commit lands there (`945a457d` for 307-01). Do NOT hand-commit these to `main`.
    - Roll-up format does not exist yet. Contract §10 is creating authority, not restating it, and must be written BEFORE the generator (Task 2 is spec-first, then RED goldens, then GREEN).
    - Roll-up derives from committed `.paul/field-harvest/*-MODULE-LEDGER.md`, never re-parsed from source SUMMARYs — one normalization path so the roll-up can never disagree with its inputs.
    - External roots are read-only but user-writable, so the guarantee is tool-enforced. Task 1 requires pre/post recursive checksums plus a write-boundary negative test against the REAL roots, not fixtures.
    - quark's 107 `no-dispatch-evidence` (69% of its corpus vs 47% for pals) was spot-checked on 3 files only. AC-2 requires full-set verification before the roll-up reports it as a Phase 308 finding.
    - `.paul/ROADMAP.md` has ~15 B of headroom. Task 3 must trim completed-phase detail in the same change if Phase 307 closure writes push it over 12,000 B.
    - Expect at least one contract amendment from the foreign corpora; 307-01 amended twice on a corpus it authored. Zero amendments should be read as a shallow audit, not success.

files:
  - path: .paul/phases/307-retroactive-field-harvest/307-02-PLAN.md
    reason: the approved-pending plan APPLY executes; uncommitted, untracked
  - path: .paul/STATE.md
    reason: lifecycle routing updated for 307-02; uncommitted
  - path: .paul/ROADMAP.md
    reason: Phase 307 plan lineup updated and byte-trimmed; uncommitted
  - path: .paul/phases/307-retroactive-field-harvest/307-01-SUMMARY.md
    reason: direct dependency; carries the deviations and techniques 307-02 inherits
  - path: docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md
    reason: §1–§9 authority; Task 2 adds §10, Task 1 may amend §3/§4
  - path: tools/harvest-module-ledger.sh
    reason: harvester run against both external roots in Task 1; contains the three-tier write boundary and the shared-manifest merge
  - path: tools/lib/parse-summary.awk
    reason: dialect parser; absorbs any foreign-corpus gap found in Task 1
  - path: .paul/field-harvest/UNPARSEABLE.md
    reason: pals's 270 entries must survive the multi-deployment merge unchanged
  - path: tests/helpers/field_harvest.sh
    reason: guardrail helper extended with roll-up checks in Task 2
  - path: .paul/presentation-packets/
    reason: untracked derived packets; regenerable, safe to ignore or delete

handoff_lifecycle:
  prior_active: none — `.paul/handoffs/archive/HANDOFF-2026-08-06-307-01-unify-pending.md` was archived during this session's resume
  note: archived handoffs are history; STATE remains source of truth

resume:
  command: /paul:resume
  expected_next: /paul:apply for Plan 307-02
