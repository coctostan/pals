---
phase: 301-apply-unify-delivery-presentation
plan: 01
subsystem: kernel
tags: [html-presentation-packets, apply-packet, unify-packet, delivery-briefs, workflow-wiring, static-html, lifecycle-authority]

requires:
  - phase: 300-milestone-plan-presentation
    provides: optional non-blocking milestone + PLAN packet wiring precedent and the finalized-moment insertion pattern
  - phase: 299-presentation-contract-template-model
    provides: v2.71 packet authority contract, static HTML template model, and `.paul/presentation-packets/{phase-or-milestone}/{packet-id}.html` storage convention
provides:
  - optional non-blocking APPLY HTML presentation packet generation wired into apply-phase finalize
  - optional non-blocking UNIFY HTML presentation packet generation wired into unify-phase via render_unify_packet
  - complete v2.71 packet-type coverage across milestone, PLAN, APPLY, and UNIFY moments
affects:
  - Phase 302 Surfacing + Validation Closure

tech-stack:
  added: []
  patterns:
    - optional non-blocking delivery-brief generation modeled on the Phase 300 milestone/PLAN packet wiring
    - contract-anchored derived static HTML review artifacts instantiated from a fixed template at finalized APPLY/UNIFY moments

key-files:
  created: []
  modified:
    - kernel/workflows/apply-phase.md
    - kernel/workflows/unify-phase.md

key-decisions:
  - "Decision: APPLY packet generation lives in apply-phase finalize after the STATE PLAN ✓ → APPLY ✓ → UNIFY ○ write and before the Continue-to-UNIFY prompt, so routing stays last and reachable; UNIFY packet generation lives in a dedicated render_unify_packet step after finalize_summary and before github_flow_merge_gate."
  - "Decision: Both packet steps are optional, non-blocking, default-skip, main-session only, source-cited, and never write lifecycle state or gate routing/merge, mirroring the Phase 300 milestone/PLAN precedent."
  - "Decision: Phase 301 wires generation only; no `.html` packet instances are committed and packets remain derived/non-authoritative under `.paul/presentation-packets/`."

patterns-established:
  - "Pattern: Delivery presentation packets render at finalized APPLY/UNIFY lifecycle moments, instantiate the fixed template, and proceed identically whether rendered or skipped."
  - "Pattern: Packet wiring cites docs/PALS-HTML-PRESENTATION-PACKETS-CONTRACT.md as authoritative on conflict and enforces escaping, inline CSS, no JS/network, and per-claim citations inline."

duration: ~1 session
started: 2026-06-04T00:00:00Z
completed: 2026-06-04T00:00:00Z
---

# Phase 301 Plan 01: APPLY + UNIFY Delivery Presentation Packet Wiring Summary

**Wired optional, non-blocking generation of APPLY and UNIFY HTML presentation packets into the apply-phase and unify-phase workflows, instantiating the Phase 299 contract/template at the finalized APPLY and UNIFY lifecycle moments without touching lifecycle authority — completing v2.71 packet-type coverage across milestone, PLAN, APPLY, and UNIFY.**

## Performance

| Metric | Value |
|--------|-------|
| Duration | ~1 session |
| Started | 2026-06-04 |
| Completed | 2026-06-04 |
| Tasks | 2 completed |
| Files modified | 2 kernel workflow files + lifecycle artifacts |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: APPLY packet generation wired into apply-phase as optional and non-blocking | Pass | `kernel/workflows/apply-phase.md` `finalize` gained an optional, default-skip APPLY-packet offer inserted after the STATE `PLAN ✓ → APPLY ✓ → UNIFY ○` write (item 3) and before the renumbered `Continue to UNIFY?` prompt (item 5); on Yes instantiates `kernel/templates/HTML-PRESENTATION-PACKET.md` as an `APPLY` packet at `.paul/presentation-packets/{NN}-{phase}/{NN}-{plan}-apply.html`; routing prompt unchanged and reachable when skipped. Task 1 grep verification PASS. |
| AC-2: UNIFY packet generation wired into unify-phase as optional and non-blocking | Pass | `kernel/workflows/unify-phase.md` gained a dedicated `render_unify_packet` step (`priority="after-finalize-summary"`) between `finalize_summary` and `github_flow_merge_gate`; on Yes instantiates the template as a `UNIFY` packet at `.paul/presentation-packets/{NN}-{phase}/{NN}-{plan}-unify.html`; merge gate, `check_phase_completion`, and transition routing remain unchanged and reachable when skipped. Task 2 grep verification PASS and emitted `NO_OUT_OF_SCOPE_CHANGES`. |
| AC-3: Both wirings preserve the contract authority boundary and static-HTML/citation rules | Pass | Both steps require reading bounded authoritative slices and citing them, escaping artifact/command/diff content, inline CSS only, no JavaScript, no network assets, and state packets cannot approve/block/merge/rewrite lifecycle state; both reference `docs/PALS-HTML-PRESENTATION-PACKETS-CONTRACT.md` as authoritative on conflict, with `not available — <reason>` / `skipped — <reason>` conventions for absent inputs. |
| AC-4: No out-of-scope changes; existing validation stays green | Pass | Only `kernel/workflows/apply-phase.md` and `kernel/workflows/unify-phase.md` changed (plus lifecycle `.paul/*`); no `.html` instances committed; no `tests/` or `drivers/` changes; no doc-contract edits. `git diff --check` clean, artifact_consistency PASS, cross-harness 241/241 PASS, Pi e2e 336/336 PASS. |

## Module Execution Reports

### Pre-Plan / Post-Plan Carry-Forward
- `[dispatch] pre-plan advisory`: workflow-markdown-only plan; TODD/IRIS/CODI/RUBY/DAVE not applicable or skipped (no TS/JS, no tests, no deploy surface, no source selectors → no CODI seeds); DOCS flagged keeping contract/template cross-references and storage-path strings consistent across both workflows and aligned with the Phase 300 wiring.
- `[dispatch] pre-plan enforcement`: DEAN PASS — no dependency manifests in scope.
- `[dispatch] post-plan`: TODD kept plan type `execute`; no RED/GREEN/REFACTOR restructuring for workflow-wiring scope.

### APPLY Verification / Quality Evidence
- `[dispatch] pre-apply`: WALT captured validation baseline; task order [Task 1, Task 2]; no blocking modules.
- Task 1 official grep verification: PASS (apply-html path, contract ref, template ref, Continue-to-UNIFY prompt all present).
- Task 2 official grep verification: PASS and emitted `NO_OUT_OF_SCOPE_CHANGES` (render_unify_packet, unify-html path, contract ref, github_flow_merge_gate boundary all present).
- `[dispatch] post-task(Task 1)`: DOCS — contract/template cross-references and storage path added consistently; no drift.
- `[dispatch] post-task(Task 2)`: DOCS — references and step wiring consistent with Phase 300 / Task 1; no out-of-scope drift.
- `[dispatch] post-apply advisory`: DOCS cross-refs consistent across both workflows; CODI N/A (no TS/JS); RUBY N/A (workflow docs).
- `[dispatch] post-apply enforcement`: WALT PASS — `git diff --check` clean; `bash tests/helpers/artifact_consistency.sh` PASS; `bash tests/cross-harness-validation.sh` PASS 241/241; `bash tests/pi-end-to-end-validation.sh` PASS 336/336 (prior PROJECT.md byte-budget debt resolved; full green restored).

### Pre-Unify / Post-Unify Dispatch
- `[dispatch] pre-unify: 0 modules registered for this hook`.
- `[dispatch] post-unify`: see finalization below.

## Accomplishments

- Made the final two Phase 299 packet types real by wiring optional APPLY delivery-brief generation into `apply-phase.md` finalize and optional UNIFY closure-brief generation into `unify-phase.md` via a dedicated `render_unify_packet` step.
- Completed v2.71 packet-type coverage: milestone + PLAN (Phase 300) and now APPLY + UNIFY (Phase 301) all have optional static-HTML review briefs at their finalized lifecycle moments.
- Preserved the v2.71 authority boundary: both packet steps are optional, non-blocking, default-skip, source-cited, escaped, and incapable of changing lifecycle state or gating routing/merge.
- Kept scope tight: generation-only wiring, no committed `.html` instances, no validation-harness or driver changes (Phase 302).
- Confirmed full-green validation: artifact_consistency PASS, cross-harness 241/241, Pi e2e 336/336.

## Task Commits

Each task committed atomically:

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: Wire optional APPLY-packet generation into apply-phase.md finalize | `c17e0ef4` | feat | Added optional APPLY-packet offer in finalize plus contract/template references and required-reading entry. |
| Task 2: Wire optional render_unify_packet step into unify-phase.md | `c04fe93a` | feat | Added dedicated render_unify_packet step between finalize_summary and github_flow_merge_gate plus references. |

Plan metadata / UNIFY commit: pending at SUMMARY creation time.

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `kernel/workflows/apply-phase.md` | Modified | Added optional APPLY-packet offer in `finalize` (after STATE update, before Continue-to-UNIFY) plus contract/template references/required-reading; generates APPLY packets at the contract path. |
| `kernel/workflows/unify-phase.md` | Modified | Added dedicated optional `render_unify_packet` step after `finalize_summary` and before `github_flow_merge_gate` plus contract/template references. |
| `.paul/phases/301-apply-unify-delivery-presentation/301-01-PLAN.md` | Created before APPLY | Approved executable plan. |
| `.paul/STATE.md` | Modified | Lifecycle routing progressed PLAN → APPLY → UNIFY. |
| `.paul/ROADMAP.md` | Modified | Phase 301 status progressed from Ready-to-plan to Planning/Applied. |
| `.paul/handoffs/archive/HANDOFF-2026-06-04-phase-301-ready-to-plan.md` | Moved | Archived consumed handoff during PLAN. |

## Decisions Made

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Place APPLY packet generation in `finalize` after the STATE update and before the Continue-to-UNIFY prompt; UNIFY packet generation in a dedicated `render_unify_packet` step after `finalize_summary`. | Packets should render at finalized lifecycle moments using authoritative, settled state without disturbing routing. | The Continue-to-UNIFY prompt and the merge gate remain the final, always-reachable routing steps. |
| Keep both packet steps optional, non-blocking, default-skip, and non-authoritative. | Reviewability must improve without reviving live UI or weakening `.paul/*` authority or merge gating. | Skipping leaves all routing, merge gate, and transition unchanged; packets never approve, block, merge, or rewrite state. |
| Wire generation only; do not commit `.html` instances. | Packets are derived, regenerable, and disposable; committing them adds noise and budget risk. | `.paul/presentation-packets/` stays out of hot-artifact budgets and out of committed history. |

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | 0 | None. |
| Scope additions | 0 | None. |
| Deferred | 0 | None. |

**Total impact:** Plan executed exactly as approved; both tasks landed in scope with full-green validation.

### Auto-fixed Issues

None.

### Deferred Items

None.

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| None. | The prior PROJECT.md byte-budget debt noted in Phase 300 is already resolved; Pi e2e is 336/336. |

## Next Phase Readiness

**Ready:**
- All four v2.71 packet types (milestone, PLAN, APPLY, UNIFY) now have optional, non-blocking, contract-anchored generation wired at their finalized lifecycle moments.
- Phase 302 (Surfacing + Validation Closure) can add workflow surfacing guidance, docs, and validation guardrails that prove packets remain derived, static, non-authoritative, and free of external UI dependencies.
- Validation baseline full green: artifact_consistency PASS, cross-harness 241/241, Pi e2e 336/336.

**Concerns:**
- Future surfacing/validation work must keep escaping and citation discipline; unescaped artifact/command content would violate the contract.

**Blockers:**
- None for Phase 302 after this PR merges.

---
*Phase: 301-apply-unify-delivery-presentation, Plan: 01*
*Completed: 2026-06-04*
