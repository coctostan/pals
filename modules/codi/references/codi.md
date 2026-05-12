# CODI — Codegraph-Driven Structural Injection

## Purpose

CODI adds advisory `impact` evidence to PLAN.md. It reports explicit symbol
probes; it does not infer scope, choose files/tests, block workflow steps, or
own `.paul/*` lifecycle truth.

## Current Scope

- **Hook:** `pre-plan`, priority 220, advisory.
- **Inputs:** explicit symbol text from ROADMAP phase detail or plan objective,
  plus top-level/exported declarations from explicitly listed repo-relative
  `.ts`, `.tsx`, `.js`, or `.jsx` context files.
- **Output:** optional `Blast Radius (CODI)` section in PLAN.md.
- **Invariant:** one `impact` call per symbol; failed, empty, or unresolved
  calls do not erase resolved calls.
- **Out of scope:** broad search, semantic guessing, test selection,
  `files_modified` selection, lifecycle gates, and `.paul/*` writes.

## Symbol Extraction Rules

**Allowed reads:**
1. Current phase detail in `.paul/ROADMAP.md`.
2. Objective text being drafted for the PLAN.
3. Explicit repo-relative `.ts`, `.tsx`, `.js`, or `.jsx` files listed in
   PLAN `<context>`.

**Accepted seeds:**
- Backtick identifiers: `fooFn`, `Bar.baz`, `snake_case`, `camelCase`.
- Phrases: `symbol X` or `function X`.
- From listed source selectors: top-level function/class declarations,
  exported named declarations, and exported const/arrow bindings.

**Rejected seeds:**
- Nested declarations, type-only constructs, re-export-only barrels, installed
  runtime paths, English prose, shell-command backticks, config literals/flags,
  stopwords, and tokens of 2 characters or fewer.
- Broad search and semantic guessing.

**Order:** direct text seeds first; then source-selector declarations in file
mention order and declaration order.

When unsure, extract fewer symbols.

## `impact` Call Contract

- Call `impact({ symbols: [symbol], changeType: "behavior_change" })`.
- Call once per extracted symbol. Never batch symbols.
- Classify each call alone; failures do not erase other results.
- Empty string = resolved with no downstream call-sites.
- `Symbol "<input>" not found` = unresolved.
- `impact` omits the queried symbol itself; do not add self-references.

## Blast Radius Output

Place CODI output in PLAN.md `<module_dispatch>`.

- Heading: `### Blast Radius (CODI)`.
- Non-empty `impact` output except `Symbol "<input>" not found`: resolved.
  Add `**{symbol}**` and fenced raw output.
- Empty string: resolved-empty. Add `**{symbol}**` and
  `_(no downstream call-sites)_`.
- `Symbol "<input>" not found` or thrown call: unresolved. Add to final
  `**Unresolved:**` list; mark thrown calls `(call errored)`.
- If all calls are unresolved/errored, still inject unresolved-only output.
- Suppress output only for hook-level skips.

## Failure Handling and Dispatch Logs

Hook-level skips produce no Blast Radius section:

- no seeds → `[dispatch] CODI: skipped — no extractable symbols in phase scope`
- no `impact` tool → `[dispatch] CODI: skipped — codegraph tools unavailable`
- loop failure → `[dispatch] CODI: skipped — impact loop errored: <short reason>`

Per-symbol outcomes always produce Blast Radius output, including resolved-empty,
unresolved, and call-errored outcomes.

```text
[dispatch] CODI: pre-plan advisory → impact × N symbols → R resolved, U unresolved, K total call-sites, injected blast_radius
```

Counts:
- `N`: extracted symbols called with `impact`
- `R`: symbols with non-empty resolved output
- `U`: unresolved or call-errored symbols
- `K`: raw call-site lines across resolved output

## Applicability and Safe Skips

- Use CODI only when explicit symbols or listed TS/JS source selectors produce
  extracted symbols.
- For markdown/config/workflow-only scope, no symbols, or missing `impact`, emit
  the documented skip line and continue planning.
- Do not create `.codegraph/` gates, lifecycle blockers, or fallback broad
  searches.
- Source edits affect live dispatch only after registry/ref refresh.
- Post-unify history: `references/codi-instrumentation.md`.
