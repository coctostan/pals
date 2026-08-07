# PAUL Handoff

status: paused
created: 2026-08-06
phase: 307 of 308 — Retroactive Field Harvest
plan: 307-01 / APPLY complete, awaiting UNIFY
loop: PLAN [✓] / APPLY [✓] / UNIFY [○]
state_authority: .paul/STATE.md
resume_action: /paul:unify for Plan 307-01
wip_result: skipped — only untracked item is `.paul/presentation-packets/`, a derived regenerable packet; all 5 phase commits are pushed

git_snapshot:
  workflow: github-flow
  branch: feature/307-retroactive-field-harvest
  base: main
  pr: https://github.com/coctostan/pals/pull/227 — OPEN, MERGEABLE
  ci: passing (Socket Security: Project Report + Pull Request Alerts)
  sync: 5 ahead of main, 0 behind; branch level with its own remote
  note: snapshot only; resume rechecks live git state when github-flow routing applies

progress:
  done:
    - Phase 307 split into 307-01 (contract + harvester + pals self-harvest) and 307-02 (quark/hybrid execution + roll-up), per the roadmap split trigger
    - Task 1 `814fb090` — created docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md, subordinate to the Phase 306 ledger contract
    - Task 2 `25e662df` — 11 dialect/edge fixtures + hand-written goldens (RED), then tools/harvest-module-ledger.sh + tools/lib/parse-summary.awk (GREEN); mutation-tested non-vacuous
    - Task 3 `61c88252` — self-harvested this repo to .paul/field-harvest/ (207 rows, 270 manifest entries) and wired guardrails into both suites
    - `f7b0111c` — STATE marked APPLY complete
    - Validation: Pi 349→355/355, cross-harness 254→257/257, zero failures both sides; artifact_consistency PASS
    - Optional APPLY packet rendered at .paul/presentation-packets/307-retroactive-field-harvest/307-01-apply.html
  in_progress:
    - none; APPLY is closed and PR #227 is open awaiting the UNIFY merge gate
  blockers:
    - none
  decisions:
    - Dialect coverage is six, not the three the roadmap assumed; contract was amended twice DURING APPLY (dialect F count-based outcomes, em-dash prose-suffix stripping, space-separated hook suffixes, dispatch-table qualification). Task 3 explicitly authorized this. UNIFY must record it as a deviation.
    - Task 2's write-boundary guard was wrong and was redesigned in Task 3: it now protects source evidence (.paul/phases) rather than the whole repo, so self-harvest works while external deployments stay unwritable. Negative-tested both directions.
    - 111 residual `unmapped-status` entries left deliberately un-coerced; 151 `no-dispatch-evidence` phases verified genuine. Both are Phase 308 input, not defects.
    - Retroactive harvest never emits `Actioned? = yes`; harvested actioned counts are a floor, not a measurement.
    - Cross-check evidence for UNIFY: harvested `pals/306-01` reproduces all 19 rows UNIFY independently wrote to .paul/MODULE-LEDGER.md in Phase 306.

files:
  - path: .paul/phases/307-retroactive-field-harvest/307-01-PLAN.md
    reason: approved plan; UNIFY reconciles plan-vs-actual against its AC-1..AC-4 and boundaries
  - path: docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md
    reason: Task 1 output, amended twice during Task 3; the amendments are the main UNIFY deviation
  - path: tools/harvest-module-ledger.sh
    reason: harvester; contains the redesigned three-tier write boundary
  - path: tools/lib/parse-summary.awk
    reason: dialect parser implementing the contract
  - path: tests/fixtures/field-harvest/expected-rows.tsv
    reason: hand-written golden; the specification, never regenerated from program output
  - path: tests/helpers/field_harvest.sh
    reason: behavioral guardrails sourced by both validation suites
  - path: .paul/field-harvest/pals-MODULE-LEDGER.md
    reason: 207 harvested rows; the self-harvest deliverable
  - path: .paul/field-harvest/UNPARSEABLE.md
    reason: 270 manifest entries; the honest record of what could not be normalized
  - path: .paul/MODULE-LEDGER.md
    reason: must remain byte-identical; UNIFY-owned forward ledger, never written by harvest

handoff_lifecycle:
  prior_active: none
  note: archived handoffs are history; STATE remains source of truth

resume:
  command: /paul:resume
  expected_next: /paul:unify for Plan 307-01
