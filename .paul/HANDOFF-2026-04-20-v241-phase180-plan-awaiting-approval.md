# PAUL Handoff

**Date:** 2026-04-20
**Status:** paused — Phase 180 PLAN created and amended, awaiting APPLY approval

---

## READ THIS FIRST

You have no prior context. This document tells you everything.

**Project:** pals — Project Automation & Lifecycle System
**Core value:** The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers

This pause happened after Phase 180's PLAN.md was drafted and amended with four user-approved refinements. The user has questions/concerns cleared and paused before running APPLY.

---

## Current State

**Milestone:** v2.41 CODI v0.1 — Natural-Scope Evidence & Signal-1/2 Validation (80%)
**Phase:** 180 of ~3 — Re-Trial + Gating Decision (last phase of v2.41)
**Plan:** `180-01` created and amended; awaiting APPLY approval
**Scoping decision:** Option C — qualitative-alone v2.41 verdict + v2.42 opens as instrumentation-fix milestone under fresh SHA freeze

**Loop Position:**
```text
PLAN ──▶ APPLY ──▶ UNIFY
  ✓        ○        ○     [Plan created, awaiting approval]
```

## Git State

| Field | Value |
|-------|-------|
| Branch | main |
| Base | main |
| Last commit | `ee0190d chore(179-organic-observation): transition to Phase 180` |
| PR | none yet (Phase 180 APPLY will create feature branch + PR) |
| Working tree | modified: `.paul/ROADMAP.md`, `.paul/STATE.md`; untracked: `.paul/phases/180-re-trial-gating-decision/` |

---

## What Was Done This Session

- Ran `/paul:resume` from prior `apply-paused` handoff → archived that handoff.
- Finalized Phase 179 SUMMARY with three findings, ran UNIFY with full module dispatch (WALT stable row, SKIP inline, CODI `skipped-no-symbols` row, RUBY skip), merge gate passed, PR #89 squash-merged as `1653bca`, feature branch deleted, local main synced.
- Ran transition-phase: evolved `.paul/PROJECT.md` Key Decisions, updated `.paul/STATE.md` Current Position to Phase 180, archived stale handoff.
- Decided Phase 180 scoping together with the user: **Option C** (qualitative-alone v2.41 verdict under the unchanged rubric + v2.42 proposal for the instrumentation fix with fresh SHA freeze).
- Drafted `.paul/phases/180-re-trial-gating-decision/180-01-PLAN.md` (3 tasks: DECISION, v2.42 proposal, close v2.41).
- User asked for questions/concerns/gaps. Surfaced six items including: Signal 1–4 definitions missing, Q2 scoring tension, Q3 framing-effect risk, ARCH(p75) advisory gap, `qualitative caveat` flirting with rule-editing, milestone-closure routing (must go to `/paul:milestone`, not `/paul:plan`).
- Applied all four recommended amendments:
  - (a) Task 1 action now requires Signal 1–4 definitions sourced verbatim from `173-01-DECISION.md` per-signal recap. Mechanical-first scoring order mandated.
  - (b) Q2 gets explicit two-pass treatment (mechanical pass → likely `uncertain`; qualitative pass → likely `yes`). Only the mechanical pass influences the verdict letter. Qualitative pass lives in separate Interpretation note that explicitly does not influence the verdict.
  - (c) ARCH(p75) added to advisory dispatch list in `<module_dispatch>`.
  - (d) Task 3 action, verify, AC-5 Gherkin, and verification checklist all lock Session Continuity Next action to `/paul:milestone` (NOT `/paul:plan`).
- User answered Q1 "keep open" (verdict not pre-announced in plan) and Q2 "not sure" (preserved structurally via the two-pass Q2 treatment — both readings visible in the record).
- User chose pause at the APPLY gate.

---

## What's In Progress

Phase 180 PLAN is complete and amended. APPLY has not started. The plan is ready for user approval and `/paul:apply` routing.

---

## What's Next

**On resume:**

```
/paul:apply .paul/phases/180-re-trial-gating-decision/180-01-PLAN.md
```

That will execute the 3 tasks:

1. **(auto)** Compute v2.41 verdict by applying the unchanged Phase 173/177 rubric to Phase 179 evidence → `180-01-DECISION.md`. Mechanical-first scoring (Signal 1–4 definitions verbatim from Phase 173), Q2 two-pass treatment, Q3 framing effect stated openly if Option C routes it. Verdict letter computed, Interpretation note separate.

2. **(checkpoint:human-verify)** Review the DECISION artifact before v2.42 opens. 10 verification items in the checkpoint (decision rule verbatim; Signal definitions verbatim; S_pass_nonnull and S_pass_signal3 explicit; Q2 both passes visible; Q3 framing stated; verdict letter follows mechanical pass; Interpretation note separate and flagged non-influencing; no rubric edits; no silent ledger repair).

3. **(auto)** Write `.paul/proposals/v2.42-post-unify-instrumentation-fix.md` — names both Phase 179 instrumentation gaps (parser-miss 112-01; hook-not-firing 113-01), specifies fresh SHA freeze discipline distinct from `0d667560b65944801faaee270ab920786afa471a`, scopes fix to measurement surface only, preserves v2.41 qualitative record as untouched input.

4. **(auto)** Close v2.41: write `180-01-SUMMARY.md`, update `.paul/ROADMAP.md` (v2.41 Complete, v2.42 Next Milestone), update `.paul/STATE.md` (Session Continuity Next action = `/paul:milestone`), update `.paul/PROJECT.md` Key Decisions.

**After UNIFY:** transition-phase runs. Because Phase 180 is the LAST phase of v2.41, transition routes to milestone-close, not phase-plan. Resume will then suggest `/paul:milestone` to close v2.41 and open v2.42.

---

## Key Files

| File | Purpose |
|------|---------|
| `.paul/phases/180-re-trial-gating-decision/180-01-PLAN.md` | Amended Phase 180 plan awaiting APPLY |
| `.paul/phases/179-organic-observation/179-01-SUMMARY.md` | Authoritative trial evidence for Phase 180's verdict |
| `.paul/phases/177-re-trial-gating-decision/177-01-DECISION.md` | Source of the unchanged decision rule |
| `.paul/phases/173-real-world-trial-gating-decision/173-01-DECISION.md` | Source of the Signal 1–4 definitions |
| `.paul/CODI-HISTORY.md` | pals-side ledger (reference only) |
| `/Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md` | Trial host ledger (reference only) |
| `.paul/STATE.md` | Session continuity points at this handoff |
| `.paul/ROADMAP.md` | Phase 180 marked Planning; v2.41 still In Progress |

---

## Integrity Invariants (Active)

- **CODI-source freeze:** pals `modules/codi/*` frozen at SHA `0d667560b65944801faaee270ab920786afa471a` for the entire duration of v2.41, including through the v2.41 verdict landing. Phase 180 MUST NOT touch CODI source.
- **Rule freeze:** Phase 173/177 decision rule and Signal 1–4 definitions apply verbatim; no edits.
- **Evidence freeze:** Phase 179 SUMMARY is cited, not revised. No retroactive reclassification of quark `112-01` or `113-01` rows.
- **No synthetic evidence, no mid-trial CODI patching, no manual `CODI-HISTORY.md` edits.**
- **Verdict openness:** DECISION is computed in Task 1 execution. No verdict letter is pre-announced in the plan.
- **Milestone-closure routing:** Phase 180's UNIFY must route to milestone-close (`/paul:milestone`), not phase-plan.

---

## Resume Instructions

1. Run `/paul:resume` to restore context via STATE.md + this handoff. It will surface this handoff, verify git state, and route to the APPLY gate.
2. Review the amended plan at `.paul/phases/180-re-trial-gating-decision/180-01-PLAN.md` if desired.
3. Approve and run `/paul:apply .paul/phases/180-re-trial-gating-decision/180-01-PLAN.md`.

---

## Mental Context

- The six surfaced gaps during plan review were real. The four amendments closed the important ones. The two remaining (`.paul/proposals/` directory existence, `qualitative caveat` phrasing risk) are addressed structurally by the mechanical-first scoring order and the verify clause on the DECISION.
- Option C was the honest scoping choice. It preserves v2.41's CODI-source freeze absolutely through the verdict and frames v2.42 as the instrumentation-fix milestone with its own frozen source. The v2.41 trial was designed to observe whether CODI's advisory works on natural scope (answered `yes` qualitatively); fixing the instrument mid-trial would have contaminated that signal.
- The two-pass Q2 treatment is the cleanest way to honor the user's "not sure" without forcing a single Q2 score. Both readings stay visible in the DECISION artifact; the verdict letter follows the mechanical pass while the qualitative pass lives in the Interpretation note.
- Resume routing must not default to `/paul:plan` after Phase 180's UNIFY — this was caught during plan review and locked explicitly across Task 3 action, verify, AC-5, and verification checklist.

---

*Handoff created: 2026-04-20*
