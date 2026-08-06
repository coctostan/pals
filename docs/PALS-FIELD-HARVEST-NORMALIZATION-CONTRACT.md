# PALS Field Harvest Normalization Contract

## 1. Purpose and Source Authority

Retroactive field harvest reads historical phase SUMMARY files across PALS field deployments and normalizes their module dispatch evidence into the row format fixed by `docs/PALS-MODULE-EFFICACY-LEDGER-CONTRACT.md`.

This document is **subordinate** to that contract. It adds only the parsing, mapping, and exclusion rules needed to read historical dialects. **On any conflict, `docs/PALS-MODULE-EFFICACY-LEDGER-CONTRACT.md` wins**, including the five-column schema, the six-value status enum, the Actioned trace rule, write ownership, and warm-artifact posture.

Harvested output is a **derived aid**. Each source SUMMARY remains authoritative for its own evidence. A harvested row is a pointer to evidence, never a replacement for it.

Harvest is **pull-based and read-only**:

- it never mutates a source deployment, including this repository's own `.paul/phases/**`;
- it never writes lifecycle artifacts (`STATE.md`, `PROJECT.md`, `MILESTONES.md`, `ROADMAP.md`);
- it never writes `.paul/MODULE-LEDGER.md`, which remains the forward-looking UNIFY-owned artifact;
- it collects no telemetry and requires no cooperation from the deployment being read.

## 2. Deployment Namespacing

Field deployments number their phases independently. `pals` Phase 127 and `quark` Phase 127 are unrelated units, so an un-namespaced `Phase` cell would silently merge them.

The `Phase` cell is therefore namespaced:

```text
{deployment}/{NN}-{PP}
```

- `{deployment}` is a stable lowercase slug supplied at harvest time (`pals`, `quark`, `hybrid-energy-reasoner`).
- `{NN}` is the phase number from the phase directory name.
- `{PP}` is the plan number from the SUMMARY filename.

When a SUMMARY carries no derivable plan number — legacy `SUMMARY.md` files predating the `{NN}-{PP}-SUMMARY.md` convention — the cell falls back to:

```text
{deployment}/{NN}
```

Absence of a plan number is **not** a parse failure. Only an underivable phase number is (see §7, `no-phase-id`).

This keeps the five-column schema intact. No sixth column is added.

## 3. Dialect Grammar

Historical SUMMARY files record module dispatch in five distinct shapes, plus one class that must be excluded. Every dialect below is source-backed by a real artifact.

### Dialect A — lowercase module rows

Markdown table whose first column holds lowercase module names.

Anchor: a table row whose first cell matches `^[a-z]{4}$` against the canonical registry.

Source: `quark/.paul/phases/127-resource-confinement-enforcement-and-audit/127-01-SUMMARY.md:90-95`

```text
| Module | Outcome | Phase 127 Surface |
| walt   | PASS | typecheck/build/test green at every fix pass; 1376 → 1430 / 1 skipped end-to-end |
| arch   | PASS_WITH_CONCERNS | `process-syscalls.ts` net +11 ... |
```

### Dialect B — uppercase combined skips

Markdown table where one cell names several modules at once, often with a non-enumerable remainder.

Anchor: a first cell containing `/` between two or more registry names.

Source: `hybrid-energy-reasoner/.paul/phases/52-research-note-loop-safety-contract-config-freeze-manifest-design/52-01-SUMMARY.md:81-95`

```text
| Module | Result | Evidence |
| ARCH/DOCS/IRIS/SETH and other advisory modules | PASS/SKIP | Scope was docs/test/design-only ... |
| CODI | skipped-no-symbols | PLAN pre-plan evidence had no explicit TS/JS files ... |
```

Named modules each emit a row. A remainder phrase such as `and other advisory modules` is not enumerable and emits an `ambiguous-module-set` manifest entry instead of guessed rows.

### Dialect C — `[dispatch]` prose

Bullet or paragraph lines carrying dispatch evidence with no table at all. This is the **largest** historical bucket.

Anchor: a line containing `[dispatch]`.

Source: `quark/.paul/phases/120-canonical-dual-llm-seeding-migration/120-01-SUMMARY.md:94-101`

```text
- [dispatch] post-unify: modules.yaml loaded; executing WALT(100), SKIP(200), CODI(220), RUBY(300).
- [dispatch] WALT post-unify: appended Phase 120 quality history row ...
```

A roster line (`executing WALT(100), SKIP(200), ...`) establishes which modules were dispatched. A per-module line supplies that module's outcome. A module named in the roster with no per-module line and no explicit status is recorded as `NOTE` with `Finding? = no`, because invocation is evidenced but outcome is not.

### Dialect D — uppercase per-module hook table

Markdown table with a `Hook` column and uppercase module names that may carry a parenthesized hook suffix.

Anchor: a header row containing both `Module` and `Hook`.

Source: `quark/.paul/phases/85-kernel-correctness/85-01-SUMMARY.md:45-50`

```text
| Module | Hook | Result |
| WALT (post-apply) | enforcement | PASS (517/517) |
| DEAN (post-apply) | enforcement | PASS (0 vulns) |
```

The parenthesized hook and any trailing parenthesized detail on the result are stripped before mapping.

### Dialect F — count-based outcomes

Markdown table, structurally identical to A or D, whose outcome cell reports a **finding count** instead of a status token.

Anchor: an outcome cell matching `^[0-9]+ <noun>`.

Source: `.paul/phases/132-smart-question-gating/132-01-SUMMARY.md:57-63` and `.paul/phases/133-greenfield-fast-path/133-01-SUMMARY.md:65-70`

```text
| Module | Hook | Result |
| IRIS | post-apply | 0 concerns (net size reduction: 914→854) |
| DOCS | post-apply | 0 drift (internal workflow change) |
| RUBY | post-apply | 0 debt (reduced) |
| SKIP | post-apply | 1 decision captured |
```

These record that a module ran and what it found, without using status vocabulary. Mapping is defined in §4.

### Module cell normalization

Across all table dialects, a module cell may carry a hook suffix in either form:

```text
WALT (post-apply)     parenthesized
WALT post-unify       space-separated
```

The **leading word** identifies the module. Trailing hook and qualifier words are discarded. A leading word that does not resolve against the canonical registry is `unknown-module` (§7); it is never guessed from the remaining words.

### Dispatch table qualification

A `Module` first column is **not** sufficient to make a table dispatch evidence. Phase SUMMARYs also contain module *design grade* tables and *dependency upgrade* tables with the same first column:

```text
| Module | Domain | Criteria | Grade |     <- design grades, NOT dispatch
| Module | Before | After | Upgraded In |   <- dependency upgrades, NOT dispatch
```

A table qualifies as dispatch evidence only when its header also contains one of these outcome columns, which is then read as the status cell in this preference order:

```text
Status  >  Result  >  Outcome  >  Report  >  Evidence
```

`Hook` is a qualifier, never the status column. There is **no positional fallback**: a table with no recognized outcome column is not dispatch evidence and contributes no rows and no manifest entries. Guessing a column would fabricate dispatch records out of unrelated tables, which is worse than harvesting nothing.

### Dialect E — explicit status line (current)

The shape emitted by the current UNIFY workflow: an `### MODULE` heading followed by an inline status triple.

Anchor: `Status:` together with `Finding?:` on the same line.

Source: `.paul/phases/306-ledger-contract-unify-integration-config-surfacing/306-01-SUMMARY.md:133-143`

```text
### ARCH

`Status: WARN | Finding?: yes | Actioned?: no` — Post-apply measured the existing ...
```

This is the only dialect that states `Finding?` and `Actioned?` directly. Those tokens are authoritative when present (§5, §6).

### Class X — nested foreign evidence (excluded)

Nested trees under a phase directory that contain SUMMARY files **not owned by that phase** — adversarial or comparative test evidence captured from another agent or another project.

Anchor: a SUMMARY at nesting depth greater than one below `.paul/phases/`, or whose frontmatter `phase:` disagrees with its owning phase directory.

Source: `.paul/phases/129-adversarial-testing-setup/{sonnet,kimi}-evidence/14-01-SUMMARY.md`, whose frontmatter declares `phase: 14-module-bait-implementation` while sitting under Phase 129.

These are **excluded**, not parsed. Harvesting them would attribute foreign module behavior to the host deployment.

### Precedence

A single SUMMARY may match several dialects. Resolve in this order and stop at the first match:

```text
E  >  A / B / D  >  C
```

Rationale: E carries explicit `Finding?`/`Actioned?` tokens and loses the least information. Table dialects carry per-module structure. Prose C is the weakest evidence and is used only when no structured form exists. Class X exclusion is evaluated **before** dialect detection.

## 4. Status Mapping

The mapping is a **total function over observed tokens**. Comparison is case-insensitive after trimming whitespace, backticks, bold markers, and trailing parenthesized detail.

### Outcome cell suffix

An outcome cell frequently carries an explanation after an em-dash or a spaced hyphen:

```text
Skip — no TS/JS source files changed
SKIP/PASS — no dependency manifest changed
PASS - appended quality history row
```

Only the **leading token** before the first ` — `, ` – `, or ` - ` separator is the status. The remainder is explanatory prose and is discarded. This is lexical truncation, not interpretation: the leading token is still subject to the mapping table below, and still becomes `unmapped-status` if absent from it.

| Source token | Normalized |
|---|---|
| `PASS`, `pass` | `PASS` |
| `PASS_WITH_CONCERNS` | `PASS_WITH_CONCERNS` |
| `PASS_WITH_BASELINE` | `PASS_WITH_CONCERNS` |
| `PASS_WITH_KNOWN_BASELINE` | `PASS_WITH_CONCERNS` |
| `PASS_WITH_RETRY` | `PASS_WITH_CONCERNS` |
| `PASS-no-block` | `PASS_WITH_CONCERNS` |
| `WARN`, `warning only` | `WARN` |
| `BLOCK` | `BLOCK` |
| `SKIP`, `skip` | `SKIP` |
| `skipped-no-symbols` | `SKIP` |
| `NOT_APPLICABLE`, `n/a` | `SKIP` |
| `NOTE`, `captured in SUMMARY` | `NOTE` |

### Count-based outcomes (dialect F)

An outcome cell of the form `N <noun>` reports a finding count rather than a status. The count and the noun together determine the row:

| Outcome cell | Normalized | `Finding?` |
|---|---|---|
| `0 <noun>` for any recognized noun | `PASS` | `no` |
| `N <noun>` where N ≥ 1 and noun ∈ {`concern(s)`, `drift`, `debt`, `flag(s)`, `issue(s)`} | `PASS_WITH_CONCERNS` | `yes` |
| `N decision(s) captured` for any N | `NOTE` | `no` |

Recognized nouns are exactly: `concern`, `concerns`, `drift`, `debt`, `flag`, `flags`, `issue`, `issues`, `decision`, `decisions`.

A count paired with an unrecognized noun is `unmapped-status`. The no-silent-coercion rule below applies unchanged — the count form is a mapping entry, not a licence to interpret arbitrary prose.

Captured decisions are `NOTE` with `Finding? = no` because a recorded decision is knowledge capture, not a defect the module found.

### Combined alternates

A token of the form `X/Y` (`PASS/SKIP`, `SKIP/PASS`, `PASS/WARN`) states that the outcome varied across the modules it covers. It resolves to the **weaker claim** under this total order:

```text
SKIP  <  NOTE  <  PASS  <  PASS_WITH_CONCERNS  <  WARN  <  BLOCK
```

`PASS/SKIP` therefore resolves to `SKIP`, and `PASS/WARN` resolves to `PASS`. Choosing the weaker value guarantees harvest never **overstates** module efficacy. A module credited with fewer confirmed passes is a recoverable understatement; a module credited with passes it never demonstrated corrupts the efficacy signal that Phase 308 depends on.

### No silent coercion

**Any token absent from this table is NOT coerced.** It does not become `NOTE`, it does not become `SKIP`, and it is not guessed from surrounding prose. It produces an `unmapped-status` manifest entry and no ledger row.

Extending the mapping requires adding a row to this table with a cited source artifact. Growth of the `unmapped-status` bucket is the intended signal that this contract is incomplete.

## 5. `Finding?` Derivation

1. An explicit in-source `Finding?:` token wins (Dialect E only).
2. Otherwise derive from normalized status:

| Status | `Finding?` |
|---|---|
| `PASS_WITH_CONCERNS`, `WARN`, `BLOCK` | `yes` |
| `PASS`, `SKIP`, `NOTE` | `no` |

Prose is never scanned for finding-like language. A module that "noticed something" in narrative text but reported `PASS` records `no`.

## 6. `Actioned?` Derivation

1. An explicit in-source `Actioned?:` token wins (Dialect E only).
2. Otherwise:

| `Finding?` | `Actioned?` |
|---|---|
| `yes` | `no` |
| `no` | `n/a` |

**Retroactive harvest MUST NOT infer `Actioned? = yes`.**

`docs/PALS-MODULE-EFFICACY-LEDGER-CONTRACT.md` §"Actioned Trace Rule" requires a traceable downstream action — a later fix pass naming the finding, an approved PLAN task incorporating it, or a logged debt entry — and explicitly forbids inferring action from a later `PASS`. A parser reading one SUMMARY in isolation cannot establish that trace. Historical SUMMARYs carry no `Actioned?` column at all, so any `yes` a parser produced would be fabricated.

Promoting a harvested row to `Actioned? = yes` is a **Phase 308 human-confirmed activity** performed against cited cross-phase evidence. It is never a parser output.

The consequence is deliberate and must be read correctly: **harvested `actioned` counts are a floor, not a measurement.** A low retroactive actioned count is evidence that the trace was never recorded, not evidence that findings were ignored.

## 7. `unparseable-phase`

A harvest unit is `unparseable-phase` when it cannot be normalized without invention. Each is recorded in the manifest with deployment, path, reason code, and detail.

| Reason code | Meaning |
|---|---|
| `no-dispatch-evidence` | No `## Module Execution Reports` section, no module table, and no `[dispatch]` line. The phase predates dispatch recording. |
| `no-phase-id` | Phase number not derivable from the path or frontmatter. A missing *plan* number is not this (see §2). |
| `unknown-module` | Module name does not resolve against the canonical registry. |
| `unmapped-status` | Status token outside the §4 mapping table. |
| `ambiguous-module-set` | Combined row with a non-enumerable remainder such as `and other advisory modules`. Named modules still emit rows; the remainder does not. |
| `excluded-foreign-evidence` | Class X nested non-owning evidence tree. An exclusion, not a parse failure. |

Canonical registry (matched case-insensitively): `arch`, `aria`, `codi`, `dana`, `dave`, `dean`, `docs`, `gabe`, `iris`, `luke`, `omar`, `pete`, `reed`, `rev`, `ruby`, `seth`, `skip`, `todd`, `vera`, `walt`.

`unknown-module`, `unmapped-status`, and `ambiguous-module-set` are **row-scoped**: the rest of the SUMMARY still harvests normally. `no-dispatch-evidence`, `no-phase-id`, and `excluded-foreign-evidence` are **unit-scoped**.

**Never fabricate a ledger row to avoid a manifest entry.** The manifest is the honest record of what could not be normalized, and it is a first-class output — a large or lopsided manifest is a finding about this contract, not noise to be suppressed.

## 8. Output Artifacts and Posture

| Artifact | Owner | Posture |
|---|---|---|
| `.paul/field-harvest/{deployment}-MODULE-LEDGER.md` | harvest tooling | warm, derived, regenerable |
| `.paul/field-harvest/UNPARSEABLE.md` | harvest tooling | warm, derived, regenerable |
| `.paul/MODULE-LEDGER.md` | PALS UNIFY workflow | **never written by harvest** |

Harvest artifacts are:

- **warm** — excluded from the hot-artifact byte budgets in `docs/PALS-STATE-CONTEXT-DIET-CONTRACT.md`, which cover only `STATE.md`, `PROJECT.md`, `MILESTONES.md`, and `ROADMAP.md`;
- **derived** — fully regenerable from source SUMMARYs, and safe to delete or replace without any loss of lifecycle truth;
- **non-authoritative** — they never approve, block, merge, close a phase, change routing, disable a module, or demote a module.

Ledger files carry the `| Phase | Module | Status | Finding? | Actioned? |` header from §Row Format of the ledger contract. The manifest carries `| Deployment | Path | Reason | Detail |`.

Output is deterministically ordered by phase then module so that re-running harvest over unchanged inputs produces byte-identical files. Determinism is what makes these artifacts reviewable in diffs.

## 9. Non-goals

- No telemetry, instrumentation, or push-based collection from field deployments.
- No writes of any kind into a harvested deployment.
- No writes to `.paul/MODULE-LEDGER.md` or to any lifecycle artifact.
- No automatic `pals.json` mutation, module demotion, or module disablement.
- No inference of `Actioned? = yes` (§6).
- No coercion of unmapped status tokens (§4).
- No replacement of source SUMMARY evidence or lifecycle authority.
- No claim that harvested counts measure module value; they measure recorded dispatch evidence, which is a different and weaker thing.
