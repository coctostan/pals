# CODI — Codegraph-Driven Structural Injection

## Purpose

PALS plans need accurate structural facts — which files are actually affected, which boundaries matter, which tests are at risk — and today those facts are guessed during `analyze_scope`. CODI bakes codegraph's structural truth into PLAN.md so the plan already carries the answers the agent would otherwise have to "remember" to call codegraph for mid-APPLY. The structural-truth source becomes a pre-plan hook, not a tool surface competing for the agent's attention.

## v0.1 Scope (Current)

- **Hook:** `pre-plan` only, priority 220, advisory-only. The manifest description must never contain the classifier-reserved halt-keyword in any casing — the shared dispatch classifier in `plan-phase.md` uses strict substring matching to distinguish advisory from enforcement hooks, so CODI uses "halt", "skip", "stop", or "reject" instead.
- **Behavior:** on dispatch, CODI extracts explicit symbols from phase scope, calls `impact` ONCE PER SYMBOL with `changeType: "behavior_change"`, formats the aggregated per-symbol responses as a Blast Radius markdown sub-section, and returns it as `context_inject.blast_radius`.
- **Partial-success invariant:** if some symbols resolve and others don't, both halves are surfaced together — never all-or-nothing.
- Emit exactly one `[dispatch] CODI: ...` log line per dispatch.
- NO MAGIC INFERENCE — only explicit textual matches feed `impact`.

## Symbol Extraction Rules

**Scanned sources:**

1. The current-phase detail section in `.paul/ROADMAP.md`.
2. The in-progress objective text for the plan being created.
3. Source-file path tokens explicitly mentioned in phase scope (e.g., in a source plan reference or the roadmap phase focus text).

**Accept rules:**

- Backtick-quoted identifiers: `fooFn`, `Bar.baz`, `snake_case`, `camelCase`.
- File-path-shaped tokens — contain `/` AND either end with a known source-code extension OR start with a repo-root directory such as `src/`, `modules/`, `kernel/`, `drivers/`, `.paul/`.
- Explicit phrases of the form "symbol X" or "the function X".

**Reject rules:**

- English prose words.
- Shell-command backticks: `ls`, `git status`, `grep -n`, and similar.
- Config literals: `true`, `false`, quoted option values.
- Tokens of 2 characters or fewer.
- Stopwords (minimum set): `yes`, `no`, `on`, `off`, `null`, `none`. The manifest may extend this set without reference-doc updates.

**Guardrail:** When in doubt, extract fewer symbols — CODI tolerates an empty unresolved list and the partial-success path handles unknowns gracefully.

## `impact` Call Contract

- **Signature expected:** `impact({ symbols: string[], changeType: "behavior_change" })` returning plain text.
- **`changeType` rationale:** `"behavior_change"` captures the broadest semantic downstream impact without assuming signature or removal changes; matches the source-plan recommendation.
- **Call pattern: PER SYMBOL, NOT BATCHED.** For each extracted symbol, issue one `impact({ symbols: [singleSymbol], changeType: "behavior_change" })` call. **Rationale:** empirical testing during Phase 171 planning showed `impact` is all-or-nothing on unresolved input — a batched call containing any unknown symbol returns only `Symbol "..." not found` and destroys ALL resolved data. Per-symbol calls give per-symbol outcome isolation and enable the partial-success invariant.
- **Input-self-filter quirk:** `impact` excludes input symbols from their own downstream output. Resolving `fooFn` returns `fooFn`'s callers, not `fooFn` itself. This is a property of the tool, not CODI; document but do not compensate.
- **Cost:** N calls per dispatch, where N is the extracted-symbol count (typically ≤10 given strict accept rules). Acceptable for pre-plan advisory dispatch.

## `impact` Response Format

- **Line shape** (resolved with call-sites) — one line per affected call-site:

  ```
  {file}:{line}:{hash}  {symbol}  behavioral  depth:N  [fan-in:.., fan-out:.., roles:.., coverage:.., co-change:.., chain-confidence:..]
  ```

- **Empty string** (resolved but no callers): legitimate signal for entry-point or unreferenced symbols — NOT a failure.
- **Unresolved pattern:** `Symbol "<input>" not found` — a short single-line string. Detect via pattern match.
- CODI consumes the raw text and preserves it verbatim inside fenced code regions; it does NOT parse individual call-site lines. Codegraph's output format is pi-codegraph's contract to stabilize, not CODI's.

## Blast Radius Format

- Sub-section heading: `### Blast Radius (CODI)`
- For each resolved-with-call-sites symbol: a `**{symbol}**` subheading followed by a fenced code region containing the raw `impact` output verbatim.
- For each resolved-but-empty symbol: a `**{symbol}**` subheading followed by `_(no downstream call-sites)_` on its own line.
- A final `**Unresolved:**` bulleted list if any symbols failed resolution or errored, annotated `(call errored)` where applicable.
- Omit any sub-part that would be empty. If all outcomes were unresolved, STILL inject the sub-section (unresolved-only) — only hook-level skip conditions suppress injection entirely.
- **Placement:** inline within the plan's existing `<module_dispatch>` section at plan-generation time. No PLAN.md template changes (deferred to v0.4).

**Worked example** — input `["palsHooks", "parsePalsState", "nonexistentFn"]` yields:

```markdown
### Blast Radius (CODI)

**palsHooks**
_(no downstream call-sites)_

**parsePalsState**
```
drivers/pi/extensions/pals-hooks.ts:1055:cdd1  palsHooks  behavioral  depth:1  [fan-in:0, fan-out:21, roles:entry-point, coverage:untested, co-change:0.00, chain-confidence:0.90]
```

**Unresolved:**
- `nonexistentFn`
```

## Call-Time Failure Handling

CODI does not pre-check codegraph tool availability. There is no reliable filesystem marker that proves the runtime agent-tools (`impact`, `symbol_graph`, `trace`) are present in the current session — those are properties of the agent's tool namespace, not project state.

**Scope distinction.** Per-symbol outcomes (resolved-with-call-sites / resolved-but-empty / unresolved / call-errored) contribute to the injected Blast Radius content and to the success-log R/U/K counts. Hook-level skip conditions suppress injection entirely and emit a skip log instead.

**Hook-level skip paths** (exact dispatch log strings):

- tool unavailable → `[dispatch] CODI: skipped — codegraph tools unavailable`
- no extractable symbols → `[dispatch] CODI: skipped — no extractable symbols in phase scope`
- catastrophic loop error → `[dispatch] CODI: skipped — impact loop errored: <short reason>`
- all symbols resolved-but-empty AND none unresolved → `[dispatch] CODI: skipped — impact returned empty blast radius for all symbols`

**Success log** (any injection, even unresolved-only):

```
[dispatch] CODI: pre-plan advisory → impact × N symbols → R resolved, U unresolved, K total call-sites, injected blast_radius
```

**Partial-success invariant.** The hook MUST inject resolved outcomes together with the unresolved list whenever at least one per-symbol result was produced. Never all-or-nothing at the hook level. No error propagates to the plan; no partial structural facts are silently dropped.

## Codegraph Tool Dependency (forward-looking)

- `impact` — **IN USE** starting Phase 171 (this phase). Provides the downstream blast-radius surface.
- `symbol_graph` — v0.2 (upstream dependency context). Deferred.
- `trace` — v0.3 (conditional, for runtime-behavior plans). Deferred.

The v2.39 source plan explicitly recommends: *"build CODI v0.1 before finalizing the codegraph cuts."* Keeping v0.2+ deferred preserves optionality while the codegraph surface settles.

## Deferred Roadmap

- **v0.2** — add `symbol_graph` for upstream dependency context.
- **v0.3** — conditional `trace` for runtime-behavior plans.
- **v0.4** — formalize `<impact>` / `<dependencies>` / `<runtime_paths>` PLAN.md template sections.
- **v0.5+** — CODI at other PALS hooks (pre-apply / post-task / pre-unify).
- **Future** — reconsider whether a project-state gate (e.g. `.codegraph/` presence) should bypass dispatch entirely once v0.1 usage reveals the real cost of dispatching on projects without codegraph support.

## Source Plan Reference

Conceptual driver: `~/pi/workspace/thinkingSpace/plans/pals-codi-integration-plan.md`.
