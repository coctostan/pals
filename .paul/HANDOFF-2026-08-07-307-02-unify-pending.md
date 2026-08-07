# PAUL Handoff

status: paused
created: 2026-08-07
phase: 307 of 308 — Retroactive Field Harvest
plan: 307-02 / APPLY complete, merged, awaiting UNIFY
loop: PLAN ✓ / APPLY ✓ / UNIFY ○
state_authority: .paul/STATE.md
resume_action: /paul:unify for Plan 307-02
wip_result: skipped — no uncommitted lifecycle changes; only untracked derived HTML packets, which must never be committed

git_snapshot:
  workflow: github-flow
  branch: main
  base: main
  pr: https://github.com/coctostan/pals/pull/228 — MERGED (`190012be`, 2026-08-07T03:12Z)
  ci: passing (2/2 at merge)
  sync: level with origin/main
  note: snapshot only; resume rechecks live git state when github-flow routing applies

progress:
  done:
    - External harvest committed: quark 73 rows / 121 manifest, hybrid-energy-reasoner 76 / 17, pals re-harvested 226 / 270. Both external roots proven byte-identical by recursive checksum (54,650 and 4,143 files).
    - Write-boundary defect fixed: `mkdir -p` ran before the boundary checks, so a rejected run still created `<deployment>/.paul/field-harvest`. Regression-locked by a path-set comparison, not a file hash.
    - Three contract amendments, each driven by a full-set audit: §3/§7 `unrecognized-dispatch-shape`, §4 colon-delimited outcome prefix, §7 non-empty manifest detail.
    - Contract §10 written before the generator; `tools/rollup-field-harvest.sh` matches the hand-written golden; `.paul/field-harvest/HARVEST-ROLLUP.md` reconciles exactly with all three ledgers.
    - Guardrails wired (Pi 355 → 362, cross-harness 257 → 259, zero failures); DOCS advisory closed via README `Tools` section; ROADMAP trimmed 112 B.
    - PR #228 merged; feature branch deleted local and remote; post-merge STATE drift repaired in `8b71026f`.
  in_progress:
    - None. APPLY is closed; UNIFY has not started.
  blockers:
    - None.
  decisions:
    - Absence of evidence and unreadable evidence are distinct findings — 60 units reclassified so thin parser coverage cannot read as low module usage in Phase 308.
    - Read-only guarantees are path-tested, not checksum-tested; `mkdir` never precedes a boundary check.
    - The roll-up derives only from committed harvest output, never from source SUMMARYs, so it cannot disagree with its inputs.

files:
  - path: .paul/phases/307-retroactive-field-harvest/307-02-PLAN.md
    reason: the plan UNIFY reconciles against; SUMMARY is still owed
  - path: .paul/field-harvest/HARVEST-ROLLUP.md
    reason: Phase 308's evidence base — 375 rows, 408 unparseable, 52% corpus unparseable share
  - path: docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md
    reason: amended §3/§4/§7 and new §10; authority for anything UNIFY asserts about the harvest
  - path: .paul/ROADMAP.md
    reason: 127 B of headroom under the 12,000-byte ceiling; Phase 307 closure writes must fit

unify_debt:
  - Write `.paul/phases/307-retroactive-field-harvest/307-02-SUMMARY.md`, including the per-reason audit disposition table.
  - Reconcile three deviations: `tools/harvest-module-ledger.sh` edited outside `files_modified` (required by Task 1's own verify clause); `tests/helpers/field_harvest.sh` touched in Task 1 rather than Task 2; `.paul/ROADMAP.md` trimmed to make room for closure.
  - Merge gate is already satisfied — PR #228 merged. Do not expect an open PR.
  - Phase 307 completion writes close the phase; Phase 308 is next and is the milestone's last.

handoff_lifecycle:
  prior_active: archived: .paul/handoffs/archive/HANDOFF-2026-08-07-307-02-apply-pending.md
  note: archived handoffs are history; STATE remains source of truth

resume:
  command: /paul:resume
  expected_next: /paul:unify for Plan 307-02
