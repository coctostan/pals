# CODI Instrumentation
## Purpose

Phase 177's re-trial rubric (`S_pass_nonnull ≥ 3`) needs outcome-at-a-glance history across live sessions. The CODI post-unify hook appends one row per UNIFY to `.paul/CODI-HISTORY.md`; this doc specifies the schema and the parser's read contract. Advisory-only: the hook records what already happened during pre-plan dispatch; it never mutates PLAN.md, SUMMARY.md, or module state.

The hook now emits an early trace line — `[dispatch] CODI post-unify: hook body entered for {plan-id}` — before plan-path resolution. That trace makes future silent non-entry distinguishable from parser misses.

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

Seven tokens, each mapped from a pre-plan CODI dispatch signal or a post-unify degraded-evidence fallback:
- `injected` — success-log `[dispatch] CODI: pre-plan advisory → impact × N symbols → R resolved, U unresolved, K total call-sites, injected blast_radius`. Blast Radius was written to PLAN.md.
- `injected-degraded` — no canonical success-log line survived, but the source still contains `### Blast Radius (CODI)` plus at least one bold symbol subheading. This means CODI ran and Blast Radius survived, but the exact success-count line did not.
- `skipped-no-symbols` — `[dispatch] CODI: skipped — no extractable symbols in phase scope`. Typical for markdown/yaml-only phases.
- `skipped-tool-unavailable` — `[dispatch] CODI: skipped — codegraph tools unavailable`. The `impact` tool was not present in the agent's tool namespace.
- `skipped-loop-error` — `[dispatch] CODI: skipped — impact loop errored: <short reason>`. Catastrophic loop failure (not per-symbol).
- `skipped-all-empty` — `[dispatch] CODI: skipped — impact returned empty blast radius for all symbols`. All per-symbol calls returned empty AND none were unresolved.
- `no-dispatch-found` — fallback when neither PLAN.md nor SUMMARY.md yields a recognized CODI line or degraded injected evidence. Hotfix plans (no sibling PLAN.md) and CODI-absent phases land here.

## Data-source read order
1. **PLAN.md `<module_dispatch>` (primary)** — written at plan-creation time and never mutated afterward. Durable source.
2. **SUMMARY.md Module Execution Reports (fallback)** — used only when PLAN.md yields no recognized CODI line and no degraded injected evidence. Serves historical / post-finalize reads.
3. **`no-dispatch-found`** — if neither (1) nor (2) matches a recognized CODI line or degraded injected evidence.

**Why PLAN.md is primary:** `post_unify_hooks` runs BEFORE `finalize_summary` in `kernel/workflows/unify-phase.md`, so at hook-dispatch time SUMMARY.md's `## Module Execution Reports` section has not yet been populated with carry-forward CODI content. PLAN.md's `<module_dispatch>` region is the only durable source available when the hook fires.

**Degraded-evidence rule:** after checking the five canonical dispatch strings, the parser may still classify `injected-degraded` when the same source contains both `### Blast Radius (CODI)` and at least one bold `**{symbol}**` subheading. This preserves the distinction between “CODI absent” and “CODI ran but the exact success line drifted away.”

## Plan-path resolution

Given `summary_path = .paul/phases/{phase-dir}/{plan-id}-SUMMARY.md`:
1. Derive `plan_path` by string-substituting `-SUMMARY.md` → `-PLAN.md`. If that file exists, use it.
2. Otherwise, glob `.paul/phases/*/[0-9]*-PLAN.md` and match on the plan id extracted from `summary_path`.
3. If STILL no PLAN.md exists, record `no-dispatch-found` and skip to field extraction.
## Hotfix behavior

Hotfix mode creates `{phase}-{NN}-HOTFIX-SUMMARY.md` with no sibling PLAN.md. The post-unify hook still emits the early `hook body entered` trace, then records `no-dispatch-found` because CODI does not dispatch on hotfix plans. Row fields: R/U/K/Symbols all `—`; blast_radius = `n`.

## File bootstrap

On first write, the hook creates `.paul/CODI-HISTORY.md` with the header section specified in the manifest STEP 6:
```
# CODI Dispatch History
One row per UNIFY. Source: modules/codi/module.yaml post-unify hook.
See modules/codi/references/codi-instrumentation.md for schema, outcome taxonomy, and data-source read order.
| Plan | Date | Outcome | R | U | K | Symbols | blast_radius |
|------|------|---------|---|---|---|---------|--------------|
```

Subsequent writes append exactly one newline-terminated data row. The file MUST end with a newline after every append so no two rows share a line.

## Worked examples

Canonical success example:

```
| 175-01 | 2026-04-17 | injected | 4 | 0 | 10 | renderCompactLoopSummary, renderLifecycleStatus, syncLifecycleUi, renderLoopBadge | y |
```

Field provenance:
- **R=4, U=0, K=10** — extracted from the success-log line in `175-01-PLAN.md` `<module_dispatch>`: `impact × 4 symbols → 4 resolved, 0 unresolved, 10 total call-sites, injected blast_radius`.
- **Symbols** — extracted from `175-01-PLAN.md` Blast Radius bold subheadings, order preserved: `renderCompactLoopSummary, renderLifecycleStatus, syncLifecycleUi, renderLoopBadge`.
- **Outcome = `injected`** — success-log pattern matched.
- **blast_radius = `y`** — injection occurred.
- **Date = 2026-04-17** — from `175-01-SUMMARY.md` frontmatter `completed:` field.
Degraded injected example:

```
| 182-01 | 2026-04-20 | injected-degraded | — | — | — | makeProcessRun, createProcessSyscalls | y |
```

Field provenance:

- **Outcome = `injected-degraded`** — no canonical success-log line matched, but `### Blast Radius (CODI)` and bold symbol subheadings survived.
- **R/U/K = `—`** — the exact success-count line was not preserved, so counts cannot be recovered honestly.
- **Symbols** — extracted from the surviving Blast Radius headings, order preserved.
- **blast_radius = `y`** — Blast Radius evidence survived even though the canonical success line did not.

## CODI-disabled case
If `modules.codi.enabled` is `false` in `pals.json`, the registry does not resolve CODI's post-unify hook and no row is written. This is intentional and matches the general enabled/disabled contract. Users who toggle CODI mid-trial should note gap rows in `.paul/CODI-HISTORY.md` by phase number and consult `.paul/phases/173-real-world-trial-gating-decision/173-01-TRIAL-DATA.md` for the historical pre-hook record of Phases 170–174.