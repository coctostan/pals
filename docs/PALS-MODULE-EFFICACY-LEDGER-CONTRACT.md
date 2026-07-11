# PALS Module Efficacy Ledger Contract

## Purpose

The Module Efficacy Ledger aggregates module dispatch outcomes recorded in phase SUMMARY files so maintainers can see which installed modules contribute findings and which findings lead to action. It normalizes forward-looking evidence for Phase 306 and provides the target format for Phase 307's retroactive harvest.

The ledger is a warm, derived review aid. It does not replace module execution reports, SUMMARY files, lifecycle artifacts, command output, or human decisions.

## Source Authority

This contract is authoritative for the ledger format, append behavior, interpretation, and exemption rules. The evidence represented by each row remains authoritative at its cited SUMMARY source.

`.paul/STATE.md`, `.paul/PROJECT.md`, `.paul/MILESTONES.md`, `.paul/ROADMAP.md`, PLAN, APPLY, and UNIFY remain lifecycle truth. If this ledger conflicts with those artifacts or a source SUMMARY, the lifecycle artifact or source SUMMARY wins.

## Row Format

Every normalized record uses this column order:

```text
Phase | Module | Status | Finding? | Actioned?
```

| Column | Meaning |
|---|---|
| `Phase` | Phase or plan identifier that owns the source SUMMARY. |
| `Module` | Canonical uppercase module name. |
| `Status` | One of `PASS`, `PASS_WITH_CONCERNS`, `WARN`, `BLOCK`, `SKIP`, or `NOTE`. |
| `Finding?` | `yes` when the report contains a concrete finding, warning, concern, or blocker; otherwise `no`. |
| `Actioned?` | `yes` only when a finding is traceably fed into a later fix pass, PLAN task, or logged debt entry; `no` when it was not; `n/a` when `Finding?` is `no`. |

Rows include SKIP and no-scope dispatches. Dispatch count therefore measures invocation evidence, not only useful findings.

## Authority and Write Ownership

The ledger is a **Derived aid**. It never approves, blocks, merges, closes a phase, changes lifecycle routing, disables a module, or demotes a module.

Only the PALS UNIFY workflow owns routine appends to `.paul/MODULE-LEDGER.md`. Modules report evidence but never write their own ledger rows. Helpers, adapters, and presentation surfaces also do not own ledger writes. Append failure is non-blocking and must not change STATE, ROADMAP, merge-gate, phase-completion, or transition outcomes.

Configuration changes remain explicitly human-approved. Efficacy output may identify review candidates, but it cannot edit `pals.json`, auto-disable, or auto-demote a module.

## Artifact Posture

`.paul/MODULE-LEDGER.md` is a **warm artifact**:

- it is excluded from hot-artifact byte budgets defined by `docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md`;
- it must not add ledger rows, counters, or narrative to `.paul/STATE.md`;
- routine lifecycle reads do not load it unless efficacy information is requested;
- it is regenerable from source SUMMARY Module Execution Reports and may be repaired or replaced without changing lifecycle truth.

## Actioned Trace Rule

`Actioned? = yes` requires a traceable downstream action, not intent or acknowledgment. Accepted traces are:

1. a later fix pass that names the finding;
2. an approved PLAN task that incorporates the finding; or
3. a logged debt entry that preserves the finding and recovery owner.

The canonical example is the quark ARCH god-file observation whose measured file-size evidence changed from 124 to 127 lines and was carried into a later action record. The later fix, task, or debt reference is what makes the finding actioned; the numeric change alone does not.

When no trace exists, record `no`. Never infer action from a later PASS.

## Efficacy Interpretation

Per-module efficacy is summarized as `dispatches | findings | actioned`:

- `dispatches` counts every normalized row, including `SKIP` and no-scope rows;
- `findings` counts rows where `Finding? = yes`;
- `actioned` counts rows where `Actioned? = yes`.

A zero-finding advisory module may be surfaced as a demotion candidate for human review. This is a prompt for judgment, not an automatic recommendation or configuration mutation.

### Enforcement-module exemption

WALT, DEAN, TODD, and SETH are sticky enforcement modules on any project where they have ever had scope. They must never be suggested for demotion based on zero findings. A prior in-scope dispatch anywhere in the ledger activates the exemption even if later rows are SKIP or no-scope.

## UNIFY Append Contract

After finalizing a SUMMARY, UNIFY reads only its bounded `## Module Execution Reports` section and emits one row per module subsection or explicit module skip line. It creates `.paul/MODULE-LEDGER.md` from `kernel/templates/MODULE-LEDGER.md` on first append, then appends normalized rows without rewriting prior history.

Unparseable or incomplete evidence produces a compact warning and continues. Ledger creation or append failure is always non-blocking and never gates GitHub Flow, phase completion, or transition routing.

## Phase 307 Harvest Compatibility

Historical SUMMARY files contain three known dispatch-table dialects. Phase 307 owns parsing those dialects and normalizing them into this row format. Phase 306 does not retroactively harvest data and does not weaken the requirement that every harvested row retain a source phase or plan identifier.

## Non-goals

- No retroactive SUMMARY harvest in Phase 306.
- No automatic module disablement, demotion, or `pals.json` mutation.
- No module-owned or adapter-owned ledger writes.
- No hot-artifact growth or STATE ledger counters.
- No replacement for source SUMMARY evidence or lifecycle authority.
