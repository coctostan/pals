# Module Gap Report

## Executive Readout
The audit shows a clear split between **wiring reality** and **user visibility**:
- the current Pi installed registry is aligned with source manifests,
- shared workflows do contain real dispatch stages across PLAN/APPLY/UNIFY,
- but the current user experience gives only weak proof of which modules actually ran and what they produced.

The main risk is **not** "source manifests are lying about hooks." The main risk is that **real or potential module activity is hard for users to see, and some UNIFY-stage outputs have no proven reporting path.**

## Confirmed Working / Already Wired

| Finding | Evidence | Why it matters |
|--------|----------|----------------|
| Source manifests and the current Pi installed registry match | `modules/*/module.yaml` vs `/Users/maxwellnewman/.pi/agent/skills/pals/modules.yaml` | Current Pi install is not obviously drifted or stale; declared hooks are materially present in runtime metadata |
| Shared workflows define dispatch stages for all seven lifecycle hook points | `kernel/workflows/plan-phase.md`, `apply-phase.md`, `unify-phase.md`, plus `kernel/references/module-dispatch.md` | The lifecycle model has real hook slots for PLAN/APPLY/UNIFY rather than purely conceptual module marketing |
| APPLY has the strongest declared module participation today | Installed registry shows `todd` + `walt` before APPLY, `todd` after each task, and seven modules on `post-apply` | The system’s richest declared module behavior is concentrated where users most expect enforcement and audit feedback |
| CARL is intentionally outside PAUL lifecycle dispatch | `modules/carl/module.yaml` and installed registry both show no PAUL lifecycle hooks | CARL should not be counted as a missing PLAN/APPLY/UNIFY participant |

## Confirmed Gaps

| Severity | Bucket | Finding | Affected module(s) | Lifecycle phase(s) | Evidence | Why it matters to the user concern | Later phase |
|----------|--------|---------|--------------------|--------------------|----------|------------------------------------|-------------|
| High | Visibility gap | **Persistent Pi lifecycle surfaces never identify which modules ran or what they produced.** The status bar/widget shows milestone, phase, loop, next action, and shortcuts, but no per-module activity. | `dave`, `dean`, `docs`, `iris`, `ruby`, `skip`, `todd`, `walt` | PLAN / APPLY / UNIFY | `drivers/pi/extensions/pals-hooks.ts`; `tests/pi-end-to-end-validation.sh` checks only lifecycle/status fields and loop badge wiring | Users can see lifecycle progress but cannot answer "which extra modules did anything just now?" from the live UI | `70-visibility-ux` |
| High | Execution gap | **Post-unify-only module outputs have no proven path into the generated SUMMARY.** `create_summary` runs before `post-unify`, no current module registers `pre-unify`, and `post-unify` only describes collecting side effects afterward. | `walt`, `skip`, `ruby` | UNIFY | `kernel/workflows/unify-phase.md`; installed registry shows no `pre-unify` hooks and three `post-unify` hooks | Real module work can happen after summary creation, leaving the end report unable to prove that those modules contributed | `69-gap-fixes` |
| Medium | Visibility gap | **Early and mid-loop hooks are mostly silent unless the assistant manually narrates them.** PLAN-time overlays and APPLY task-stage enforcement can influence behavior without a dedicated user-facing trace. | PLAN: `dean`, `todd`, `iris`, `dave`, `docs`, `ruby`; APPLY: `todd`, `walt` | PLAN / APPLY | `kernel/workflows/plan-phase.md` and `apply-phase.md` define dispatch + logs; Pi extension surfaces guided workflow moments, not module traces | Users may experience changed plans, guardrails, or task gating without a stable per-module explanation surface | `70-visibility-ux` |
| Medium | Execution-proof gap | **Validation currently proves registry presence and UI wiring, not end-to-end module execution.** | All lifecycle modules | PLAN / APPLY / UNIFY | `tests/cross-harness-validation.sh`, `tests/pi-end-to-end-validation.sh` check `modules.yaml`, `hook_details`, refs, UI markers, and overlay discovery wording | The user’s "is this invisible bloat or real execution?" question remains only partially answerable from validation today | `69-gap-fixes` |
| Low | Visibility gap | **The SUMMARY template advertises `Module Execution Reports`, but current evidence only clearly supports post-apply-style annotations; module-specific end reporting is conditional rather than dependable.** | Mostly `walt`, `dean`, `dave`, `todd`, `docs`, `iris`, `skip`, plus post-unify-only `walt` / `skip` / `ruby` | APPLY / UNIFY | `kernel/templates/SUMMARY.md`, `kernel/workflows/apply-phase.md`, `kernel/workflows/unify-phase.md` | End reports can imply stronger module reporting than the current workflow ordering and data path actually guarantee | `70-visibility-ux` |

## Intentional Non-Hook / Advisory Cases

| Case | Evidence | Interpretation |
|------|----------|----------------|
| CARL has no PAUL lifecycle hooks | `modules/carl/module.yaml`, installed registry | Intentional architecture choice, not a defect |
| No module currently uses `pre-unify` | Source manifests + installed registry | Present-day catalog choice; only becomes a defect when combined with the desire for pre-summary module reporting |
| Several modules are primarily advisory overlays rather than always-visible gates | Hook descriptions in source manifests / installed registry | Not every module is supposed to block or visibly interrupt the user every run |

## Items Best Left to Phase 71 Recommendations

| Item | Why it belongs to recommendations rather than immediate fixes |
|------|--------------------------------------------------------------|
| Decide how far to go with module-centric proof (lightweight dispatch logs vs richer execution ledger / telemetry) | The audit confirms the need for stronger proof, but not yet the right durability, UX cost, or portability tradeoff |
| Decide whether `pre-unify` should stay empty or become the summary-prep handoff point for module reporting | The gap is confirmed, but the best long-term ownership model is still a design choice |
| Decide how much module visibility should live in persistent Pi UI vs apply/unify textual reports vs validation artifacts | The audit proves current visibility is weak, but the final balance is product-direction work, not just patch work |

## Prioritized Follow-On Sequence
1. **Phase 69 (`69-gap-fixes`)**
   - close execution-proof gaps
   - fix the summary/order/data-path issue for post-unify-only module outputs
2. **Phase 70 (`70-visibility-ux`)**
   - make module participation legible in live lifecycle UX and end reporting
   - reduce the current need to infer module activity from assistant narration
3. **Phase 71 (`71-recommendations`)**
   - choose the long-term proof / visibility model without overbuilding or breaking portability

## Bottom Line
The audit does **not** support the claim that the module system is pure dead weight in the current Pi install.
It **does** support the claim that the current experience is too opaque:
- users cannot easily tell which modules fired,
- validations do not yet prove live execution end-to-end,
- and UNIFY reporting is weakest exactly where post-unify modules are supposed to contribute.

## Await Direction
Phase 68 should stop here.
- The audit artifacts now answer the current-state question with code-backed evidence.
- Do **not** begin `69-gap-fixes`, `70-visibility-ux`, or `71-recommendations` until the user explicitly chooses the next direction.
