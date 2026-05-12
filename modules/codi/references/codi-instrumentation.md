# CODI Instrumentation

## Purpose

CODI post-unify appends one advisory row per UNIFY to `.paul/CODI-HISTORY.md`.
It records observed dispatch evidence only; absent fields use `—`. It does not
own lifecycle state.

## Row schema
| Column | Description |
|--------|-------------|
| Plan | Plan id (e.g. `175-01`, `176-01`) — extracted from `summary_path`. |
| Date | ISO `YYYY-MM-DD` of the UNIFY event. |
| Outcome | One of seven tokens — see Outcome taxonomy below. |
| R | Count of resolved-with-call-sites symbols (success log's first integer). `—` on `injected-degraded`, any skipped-*, or `no-dispatch-found`. |
| U | Count of unresolved symbols (success log's second integer). `—` on `injected-degraded`, any skipped-*, or `no-dispatch-found`. |
| K | Count of total call-sites (success log's third integer). `—` on `injected-degraded`, any skipped-*, or `no-dispatch-found`. |
| Symbols | Comma-separated symbols probed, in the exact order they appear in the Blast Radius sub-section (PLAN.md primary, SUMMARY.md fallback). `—` when no symbols were probed. |
| blast_radius | `y` if injection occurred (outcome = `injected` or `injected-degraded`); `n` otherwise. |

Exact header row: `| Plan | Date | Outcome | R | U | K | Symbols | blast_radius |`.

## Outcome taxonomy

Use exactly one token:

- `injected` — canonical success log found.
- `injected-degraded` — no success log, but `### Blast Radius (CODI)` plus at
  least one symbol heading exists.
- `skipped-no-symbols` — no-symbols skip log found.
- `skipped-tool-unavailable` — codegraph-tools-unavailable skip log found.
- `skipped-loop-error` — impact-loop-error skip log found.
- `skipped-all-empty` — legacy token only; do not emit for new dispatches.
- `no-dispatch-found` — no recognized CODI success, skip, or degraded evidence.

## Data-source read order

1. PLAN.md `<module_dispatch>`.
2. SUMMARY.md `## Module Execution Reports`, only if PLAN has no recognized CODI
   success, skip, or degraded evidence.
3. `no-dispatch-found`, only if neither source matches.

PLAN is primary because CODI pre-plan evidence is created before SUMMARY module
reports are finalized.

Degraded evidence = `### Blast Radius (CODI)` plus at least one bold
`**{symbol}**` heading in the same source.

## Plan-path resolution

From `summary_path`:

1. Replace `-SUMMARY.md` with `-PLAN.md`; use that file if present.
2. Else glob `.paul/phases/*/{plan-id}-PLAN.md`.
3. Else classify `no-dispatch-found`.

Hotfix summaries also classify `no-dispatch-found`.

## File bootstrap

If `.paul/CODI-HISTORY.md` is missing, create exactly:

```md
# CODI Dispatch History
One row per UNIFY. Source: modules/codi/module.yaml post-unify hook.
See modules/codi/references/codi-instrumentation.md for schema, outcome taxonomy, and data-source read order.

| Plan | Date | Outcome | R | U | K | Symbols | blast_radius |
|------|------|---------|---|---|---|---------|--------------|
```

Append exactly one newline-terminated data row per UNIFY. File must end with a
newline.