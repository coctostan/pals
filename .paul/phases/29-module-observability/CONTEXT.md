# Phase 29 Context — Module Observability

## Goals

1. Address all 10 structural holes identified in Phase 28 system audit
2. Make the module system fully transparent — clear dispatch, defined schemas, user-visible output
3. Add robustness guidance for edge cases — failures, ordering, recovery, adaptation
4. Maintain Phase 28 context budgets (150-line cap per reference file)

## Plan Structure

### Plan 29-01: Structural Foundations
Per-hook reference mapping, schemas, templates, dispatch log.

Audit holes addressed: #1, #3, #6, #8 (+ original Phase 29 scope)

| Deliverable | Audit Hole | Description |
|-------------|-----------|-------------|
| Per-hook reference mapping in module.yaml | #8 + #1 | Each hook points to specific refs (not all refs). Gives dispatch concrete instructions instead of summaries. |
| `context_inject` schema definition | #3 | Formal schema with format, fields, and example for data passing between hooks |
| SUMMARY.md frontmatter template | #6 | Document the undocumented fields (requires, provides, affects, tech-stack, key-files, patterns-established) |
| Dispatch log in kernel workflows | original | User-visible output showing which hooks fired, which modules contributed, during plan/apply/unify |

### Plan 29-02: Robustness & Safety
Failure handling, edge cases, recovery, workflow completeness.

Audit holes addressed: #2, #4, #5, #7, #9, #10

| Deliverable | Audit Hole | Description |
|-------------|-----------|-------------|
| Hook failure cascading guidance | #2 + #4 | What happens when pre-apply fails — does post-apply fire? Ordering dependency documentation. |
| Non-standard project adaptation | #5 | Guidance for "found but non-standard" (not just "not found → skip") |
| State recovery playbook | #7 | Non-destructive recovery when STATE.md drifts from actual state |
| Transition workflow reference fix | #9 | Add transition workflow to unify's `<references>` block |
| Partial failure guidance | #10 | What to do when multi-file tasks partially complete |

## Approach Notes

- Plan 29-01 first — robustness guidance depends on dispatch model being clear
- Per-hook ref mapping is the highest-impact change (fixes 2 holes, reduces context waste)
- All additions must fit within existing 150-line budgets or justify new files
- Focus on context-efficient robustness: minimal additions, maximum clarity

## Open Questions

- How verbose should the dispatch log be? (recommend: single line per hook, expandable on request)
- Should `context_inject` be a new file or added to an existing reference? (recommend: kernel-level, not module)
- Phase 30 likely unnecessary after this — confirm at unify time

## Prior Phase Context

Phase 28 delivered:
- 43% context reduction (4,507 → 2,550 lines across 27 files)
- 150-line hard cap per reference file
- Per-module budgets (750 core, 350 standard)
- System audit identifying the 10 holes this phase addresses

---
*Created: 2026-03-13 from /paul:discuss*
