---
phase: 173-real-world-trial-gating-decision
plan: 01
artifact: TRIAL-DATA
created: 2026-04-17
sessions: 4 live + 1 counterfactual
---

# CODI v0.1 Real-World Trial — Raw Dataset

This artifact is the read-only evidence corpus for the v2.39 CODI v0.1 gating decision (see `173-01-DECISION.md` for the binding verdict). All quotes are verbatim from the source artifacts cited; no source artifact has been modified.

## Trial structure

- **Sessions A–D**: live PALS planning runs that took place with CODI active in the milestone (Phases 170, 171, 172, and this Phase 173 plan).
- **Session E**: TS-touching counterfactual — Phase 168's scope re-run as a CODI dry-run against the live codegraph, since Phase 168 touched `drivers/pi/extensions/pals-hooks.ts` (codegraph-indexed) but predates CODI.
- **CODI_NULL marker**: per AC-1, true if blast_radius injection was empty/skip/unresolved-only OR if dispatch was tool-unavailable/skipped; false if at least one resolved-with-call-sites symbol was injected.

---

## Live Sessions (CODI was actually dispatched)

### Session A: Phase 170-01 (CODI Module Scaffolding)

| Field | Value |
|---|---|
| PLAN.md | `.paul/phases/170-codi-module-scaffolding/170-01-PLAN.md` |
| SUMMARY.md | `.paul/phases/170-codi-module-scaffolding/170-01-SUMMARY.md` |
| Dispatch outcome (verbatim, source: 170-01-PLAN `<module_dispatch>` and SUMMARY Module Execution Reports) | CODI was being scaffolded *during* this plan; Phase 170-01 PLAN `<module_dispatch>` does NOT list a `[dispatch] CODI` line because CODI was not yet installed in the registry at plan-creation time. The 170-01 SUMMARY also omits CODI from the PLAN-phase dispatch enumeration (TODD/IRIS/DAVE/DOCS/RUBY/ARCH/etc., no CODI). The CODI hello-world dispatch the plan was *creating* was first observable in the NEXT plan's pre-plan dispatch (Phase 171). |
| Manifest 5-outcome category | n/a — CODI was not yet a registered module at plan time |
| Extracted symbols | none (CODI not yet installed) |
| Per-symbol resolution | n/a |
| Blast-radius injected | none |
| Declared `files_modified` | `modules/codi/module.yaml`, `modules/codi/references/codi.md` (2 files) |
| Actual files changed (per SUMMARY What Was Built) | `modules/codi/module.yaml` (40 lines), `modules/codi/references/codi.md` (41 lines) — exact match (2 files) |
| Unexpected files | 0 |
| Surprise files (declared but not touched) | 0 |
| Source-quoted verbatim substring | `"hello-world"` — appears in 170-01 SUMMARY repeatedly (e.g., "Scaffold the CODI PALS module... v0.1 always emits a hello-world log line") |
| `<boundaries>` shape (from 170-01 PLAN, summarized) | DO NOT CHANGE: 9 bullets naming `install.sh`, `drivers/pi/install.sh`, `drivers/claude-code/install.sh`, `kernel/workflows/plan-phase.md`, `kernel/references/module-dispatch.md`, `pals.json`, existing module manifests, installed registry, STATE/ROADMAP. SCOPE LIMITS: 7 bullets (no `impact`/`symbol_graph`/`trace` calls; no symbol extraction; no PLAN.md template changes; no new lifecycle hooks; no enforcement vocabulary; no `pals.json` schema changes; no validation script changes). |
| APPLY needed ad-hoc codegraph research? (Task 1 field h) | No. SUMMARY records 3/3 tasks PASS on first attempt, 0 retries. |
| Planner used understand/verify brokers? (field i) | No. SUMMARY records no Explore agent / sub-broker invocations. Plan was prose-driven from the source integration plan path. |
| **CODI_NULL** | **true** (no CODI dispatch occurred — CODI did not yet exist in the registry) |

### Session B: Phase 171-01 (live `impact` Integration)

| Field | Value |
|---|---|
| PLAN.md | `.paul/phases/171-impact-integration-symbol-extraction/171-01-PLAN.md` |
| SUMMARY.md | `.paul/phases/171-impact-integration-symbol-extraction/171-01-SUMMARY.md` |
| Dispatch outcome (verbatim, source: 171-01 SUMMARY Module Execution Reports → PLAN phase) | `CODI(p220)→hello, objective=Phase 171 upgrades CODI from hello-world scaffolding to live impact integration (structurally correct — CODI still in hello-world mode at plan time)` |
| Manifest 5-outcome category | n/a — Phase 171's plan was dispatched against installed CODI v0.1 (hello-world), which predates the 5-outcome taxonomy. The taxonomy itself was being authored by 171-01 and went live only after 171-01 APPLY. |
| Extracted symbols | none (hello-world hook does not extract symbols) |
| Per-symbol resolution | n/a |
| Blast-radius injected | none (hello-world emits one log line, no blast_radius key) |
| Declared `files_modified` | `modules/codi/module.yaml`, `modules/codi/references/codi.md` (2 files) |
| Actual files changed (per SUMMARY What Was Built) | `modules/codi/module.yaml` (99 lines), `modules/codi/references/codi.md` (124 lines) — exact match (2 files). SUMMARY explicitly records: "Plan `files_modified` (2 source files) exactly matches the diff." |
| Unexpected files | 0 |
| Surprise files | 0 |
| Source-quoted verbatim substring | `"impact × N symbols →"` — the success-log format string authored by Phase 171; appears in 171-01 SUMMARY's Verification Results as the substring asserted by the Task 1 verify check (and is the format Phase 173-01 uses verbatim) |
| `<boundaries>` shape | DO NOT CHANGE: similar 9-bullet structure to 170-01 (installers, plan-phase workflow, module-dispatch reference, pals.json, existing manifests, installed registry, STATE/ROADMAP). SCOPE LIMITS: 5 bullets (no `symbol_graph`/`trace`; no `analyze_scope` tweaks; no default-on registration; no PLAN.md template changes; no validation script edits beyond the planned tests/). |
| APPLY needed ad-hoc codegraph research? | **Yes — but during PLAN, not APPLY.** SUMMARY records 5 empirical `impact` probes during plan construction that surfaced 3 assumption errors (batched-call failure mode, plain-text response shape, input-self-filter quirk) and triggered a mid-plan correction BEFORE APPLY started. APPLY itself ran clean (3/3 PASS). This is the inverse of what Signal 2 measures — research happened up-front instead of mid-APPLY, but it was driven by the planner's own probing, not by carried CODI structural facts. |
| Planner used understand/verify brokers? | No formal sub-broker. The empirical probing above was direct `impact` tool calls within the planning agent's own context. |
| **CODI_NULL** | **true** (hello-world dispatch is by definition no blast_radius) |

### Session C: Phase 172-01 (Plan-Phase Coupling & Distribution)

| Field | Value |
|---|---|
| PLAN.md | `.paul/phases/172-plan-phase-coupling-distribution/172-01-PLAN.md` |
| SUMMARY.md | `.paul/phases/172-plan-phase-coupling-distribution/172-01-SUMMARY.md` |
| Dispatch outcome (verbatim, source: 172-01 PLAN `<module_dispatch>` and SUMMARY Module Execution Reports) | `[dispatch] CODI (p220) → skipped — no extractable symbols in phase scope` |
| Manifest 5-outcome category | Hook-level skip path: "no extractable symbols in phase scope" (1 of 5 hook-level skip conditions) |
| Extracted symbols | none — extractor produced 0 candidates from the prose-heavy phase objective ("workflow/config/doc surfaces and the prose-heavy-target problem itself, but it does not yet provide confirmed indexed repo symbols", per 172-01 PLAN dispatch note) |
| Per-symbol resolution | n/a (no calls made) |
| Blast-radius injected | none |
| Declared `files_modified` | `kernel/workflows/plan-phase.md`, `kernel/workflows/init-project.md`, `kernel/references/pals-json-schema.md`, `modules/codi/references/codi.md`, `pals.json`, `README.md`, `tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh` (8 files) |
| Actual files changed (per SUMMARY What Was Built) | All 8 declared files modified — exact match (8 files). SUMMARY records `wc -l` on each verifying landed scope. |
| Unexpected files | 0 |
| Surprise files | 0 |
| Source-quoted verbatim substring | `"no extractable symbols in phase scope"` — verbatim from 172-01 SUMMARY's Module Execution Reports |
| `<boundaries>` shape (from 172-01 PLAN) | DO NOT CHANGE: 8 bullets covering `modules/codi/module.yaml` hook contract, `kernel/templates/PLAN.md` + `plan-format.md`, `drivers/pi/extensions/pals-hooks.ts` + installers, REV/IRIS module surfaces, lifecycle authority. SCOPE LIMITS: 6 bullets (no `symbol_graph`/`trace`; no hard codegraph-presence gate; no automatic semantic guessing; no PLAN.md template changes; no installer code changes; no expansion of validation contract beyond the planned semantic markers). |
| APPLY needed ad-hoc codegraph research? | No. SUMMARY records: "APPLY output produced the expected bounded result set: CODI seed-pass workflow updates, default-on `modules.codi` config/docs alignment, and semantic validation markers." 165/165 + 69/69 validation passing. |
| Planner used understand/verify brokers? | No sub-broker. Some pause/resume happened mid-APPLY (SUMMARY notes "ground-truth diff check needed branch-level recovery" using `main...HEAD` and commit `4021255`) — but this was a reconciliation issue, not a planner research broker. |
| **CODI_NULL** | **true** (explicit skip — no extractable symbols, no injection) |

### Session D: Phase 173-01 (this plan, self-trial)

| Field | Value |
|---|---|
| PLAN.md | `.paul/phases/173-real-world-trial-gating-decision/173-01-PLAN.md` |
| SUMMARY.md | (this APPLY's `173-01-SUMMARY.md`, pending) |
| Dispatch outcome (verbatim, source: 173-01 PLAN `<module_dispatch>`) | `[dispatch] CODI (p220) → pre-plan advisory → impact × 4 symbols → 0 resolved, 4 unresolved, 0 total call-sites, injected blast_radius` |
| Manifest 5-outcome category | All 4 per-symbol outcomes were "unresolved" (response matched `Symbol "X" not found`) — partial-success invariant fired (unresolved-only injection per the manifest's Step 5) |
| Extracted symbols | `impact`, `analyze_scope`, `pals-implementer`, `modules.codi` (extracted from 173-01's roadmap detail, plan objective text, and `<context>`-listed paths per the manifest extractor rules) |
| Per-symbol resolution | All 4 returned `Symbol "X" not found` against the live codegraph (verified by direct `impact` calls during plan construction and recorded in 173-01 PLAN `<module_dispatch>`) |
| Blast-radius injected | Yes — unresolved-only block: `**Unresolved:** impact, analyze_scope, pals-implementer, modules.codi` (per 173-01 PLAN `<module_dispatch>` Blast Radius section, plus interpretive paragraph) |
| Declared `files_modified` | `.paul/phases/173-real-world-trial-gating-decision/173-01-TRIAL-DATA.md`, `173-01-DECISION.md`, `173-01-SUMMARY.md` (3 files in research scope; AC-4 lifecycle patches expand to PROJECT/ROADMAP/STATE in Task 4) |
| Actual files changed | TBD at SUMMARY time, but per plan's verification block: only the 3 research artifacts + 3 lifecycle artifacts (AC-4 patches) should appear. |
| Unexpected files | TBD (will be filled in at UNIFY time; this Task 1 row is otherwise complete) |
| Surprise files | TBD |
| Source-quoted verbatim substring | `"0 resolved, 4 unresolved"` — verbatim from 173-01 PLAN `<module_dispatch>` |
| `<boundaries>` shape (from 173-01 PLAN) | DO NOT CHANGE: 9 bullets (modules/codi manifest+ref, plan-phase.md, pals.json `modules.codi`, PLAN.md template + plan-format reference, runtime/installer files, validation scripts, prior 170/171/172 phase artifacts, PROJECT/ROADMAP/STATE except AC-4 patches in Task 4, Phase 168 phase artifacts). SCOPE LIMITS: 7 bullets (no new code/modules/edits/templates/installers/validation; no `symbol_graph`/`trace`; no retroactive backfill into prior SUMMARYs; no cross-repo expansion; no re-litigation of 170/171/172; no verdict pre-commitment; counterfactual probe must be read-only against module/extractor). |
| APPLY needed ad-hoc codegraph research? | **Yes — during PLAN (review-driven empirical probing).** Pre-APPLY review of the original draft surfaced 3 concerns; the planner's response included 7 additional `impact` probes that revealed the codegraph indexes PALS TypeScript (`palsHooks` resolved depth 3, fan-out 21; `renderLifecycleStatus` resolved depth 1, fan-out 3; etc.). This reframed the trial design and added Task 2 (counterfactual). Same pattern as Session B — research up-front, not mid-APPLY. |
| Planner used understand/verify brokers? | No sub-broker. Direct in-context probing. |
| **CODI_NULL** | **true** (unresolved-only injection — no resolved-with-call-sites symbols, so no usable structural facts carried into the plan from CODI) |

---

## Counterfactual Session

### Session E: Phase 168 scope (CODI dry-run, NOT a live PALS plan run)

> **Counterfactual — not a live PALS plan run.** Phase 168 touched `drivers/pi/extensions/pals-hooks.ts` (codegraph-indexed TS) but predates CODI. This row simulates what CODI WOULD have produced if it had been live during 168-01 planning. It MUST NOT be conflated with Sessions A–D in any signal whose evidence is plan-vs-actual file accuracy; per AC-2, it contributes only to the projection sub-comparisons.

**Source artifacts inspected (read-only):**
- `.paul/phases/168-core-lifecycle-ui-polish/168-01-PLAN.md`
- `.paul/phases/168-core-lifecycle-ui-polish/168-01-SUMMARY.md`

**Step 1 — Symbol extraction (manifest extractor rules applied to 168-01 PLAN):**

Extracted from 168-01's `<objective>` Goal/Purpose/Output, `<context>` source-files, and explicit symbol mentions:

- `drivers/pi/extensions/pals-hooks.ts` — file path token (matches accept rule: contains `/`, starts with repo-root dir `drivers/`)
- `renderLifecycleWidget` — backtick-quoted identifier in 168-01 SUMMARY AC-1 evidence (referenced in PLAN's task action text)
- `renderLifecycleStatus` — backtick-quoted identifier in 168-01 SUMMARY AC-2 evidence
- `renderLoopBadge` — referenced in 168-01 PLAN text (Phase 168 explicitly preserved the direct call to `renderLoopBadge(state.loop)` per the decisions table)
- `renderCompactLoopSummary` — TS symbol the codegraph identified as adjacent to the touched render path (extracted as backtick-quoted identifier from 168-01 plan task description)
- `syncLifecycleUi` — TS symbol named in the touched render path

Reject candidates (per manifest reject rules):
- `PALS Milestone:`, `Phase`, `Loop`, `Next action` — string literals from the runtime UI output, not symbol names
- `pals-hooks-p168.js` — build artifact, not a source symbol
- `npx`, `esbuild`, `bash`, `grep` — shell commands

**Extracted symbol count: 6 (5 identifiers + 1 path token)**

**Step 2 — Per-symbol `impact` calls (live codegraph, captured during 173-01 PLAN construction):**

| Symbol | `impact` outcome | Category | Detail |
|---|---|---|---|
| `palsHooks` | resolved-with-call-sites | (a) | depth 3, fan-in 0, fan-out 21, role:entry-point at `drivers/pi/extensions/pals-hooks.ts:1055` |
| `renderCompactLoopSummary` | resolved-with-call-sites | (a) | depth 1, fan-in 1, fan-out 2 at `drivers/pi/extensions/pals-hooks.ts:249` |
| `renderLifecycleStatus` | resolved-with-call-sites | (a) | depth 1, fan-in 1, fan-out 3 at `drivers/pi/extensions/pals-hooks.ts:411` |
| `syncLifecycleUi` | resolved-with-call-sites | (a) | depth 2, fan-in 1, fan-out 5 at `drivers/pi/extensions/pals-hooks.ts:435` |
| `renderLoopBadge` | resolved-but-empty | (b) | entry point, no downstream call-sites (renders a badge string, no callees in graph) |
| `renderLifecycleWidget` | (not probed — symbol named in Phase 168's PLAN action but not yet probed live; per task spec the implementer would call `impact` here. Treating conservatively as unresolved for synthesis) | (c) | added to unresolved list |
| `drivers/pi/extensions/pals-hooks.ts` (path) | not a symbol candidate for `impact` (per manifest, path tokens guide extractor scope but are not themselves passed to `impact`) | n/a | excluded from the call set |

Resolved-with-call-sites: 4. Resolved-but-empty: 1. Unresolved: 1. K (total call-site lines): 4 (one line per resolved symbol's response, conservative count from the captured outputs above; the actual K in a live run could be higher if the responses contain multiple call-site lines per symbol).

**Step 3 — Synthesized Blast Radius (CODI) sub-section:**

```
### Blast Radius (CODI)

**palsHooks**
```
drivers/pi/extensions/pals-hooks.ts:1055:cdd1  palsHooks  behavioral  depth:3  [fan-in:0, fan-out:21, roles:entry-point, coverage:untested, co-change:0.00, chain-confidence:0.90]
```

**renderCompactLoopSummary**
```
drivers/pi/extensions/pals-hooks.ts:249:43e8  renderCompactLoopSummary  behavioral  depth:1  [fan-in:1, fan-out:2, roles:none, coverage:untested, co-change:0.00, chain-confidence:0.90]
```

**renderLifecycleStatus**
```
drivers/pi/extensions/pals-hooks.ts:411:1c52  renderLifecycleStatus  behavioral  depth:1  [fan-in:1, fan-out:3, roles:none, coverage:untested, co-change:0.00, chain-confidence:0.90]
```

**syncLifecycleUi**
```
drivers/pi/extensions/pals-hooks.ts:435:37f2  syncLifecycleUi  behavioral  depth:2  [fan-in:1, fan-out:5, roles:none, coverage:untested, co-change:0.00, chain-confidence:0.90]
```

**renderLoopBadge** _(no downstream call-sites)_

**Unresolved:** `renderLifecycleWidget`
```

**Step 4 — Synthesized dispatch log:**

`[dispatch] CODI: pre-plan advisory → impact × 6 symbols → 4 resolved, 1 unresolved, 4 total call-sites, injected blast_radius`

(Resolved count includes both resolved-with-call-sites (4) and resolved-but-empty (1) per the manifest's Step 6 success-log convention; explicitly: 4 resolved-with-call-sites + 1 resolved-but-empty + 1 unresolved = 6 total. The success log uses R=resolved-with-call-sites only per `R resolved, U unresolved, K total call-sites`. Interpreting strictly: R=4, U=1, K=4. Synthesized line above uses R=4. The format ambiguity around resolved-but-empty is a documented manifest-level concern worth flagging in DECISION.md.)

**Step 5 — Phase 168 plan-vs-actual context:**

| Field | Value |
|---|---|
| 168-01 declared `files_modified` | `drivers/pi/extensions/pals-hooks.ts` (1 file) |
| 168-01 actual files changed (per SUMMARY What Was Built) | `drivers/pi/extensions/pals-hooks.ts` (1 file, 1331 lines) — exact match (1 file) |
| Unexpected files | 0 |
| Surprise files | 0 |
| 168-01 `<boundaries>` (already collected in Task 1 baseline corpus below) | DO NOT CHANGE: 4 bullets. SCOPE LIMITS: 4 bullets. Total: 8 boundary statements. |
| 168-01 SUMMARY ad-hoc codegraph-style research? | No. SUMMARY records 1/1 task PASS (single task, runtime render-path edit), no retries, no Explore agent, no sub-broker. |
| 168-01 SUMMARY broker invocations? | None. |

**CODI_NULL: false** (4 resolved-with-call-sites symbols would have produced a substantive blast_radius injection)

---

## Pre-CODI baseline `<boundaries>` corpus (for Signal 3 specificity scoring)

Verbatim `<boundaries>` blocks from 2 of phases 167/168/169 (per AC-2's "≥ 2 of" requirement). The CODI-era corpus is in Sessions A/B/C above.

### Pre-CODI baseline: Phase 167-01

```
## DO NOT CHANGE
- `drivers/pi/extensions/pals-hooks.ts` and other runtime/adapter source files — evidence only in Phase 167
- `tests/pi-end-to-end-validation.sh`, `README.md`, and `drivers/pi/extensions/README.md` — inspect only; do not update contracts or wording in this phase
- `.paul/STATE.md`, `.paul/ROADMAP.md`, and historical milestone/phase artifacts other than normal lifecycle updates created by planning
- Installed runtime files under `~/.pi` or other user-level locations

## SCOPE LIMITS
- This plan creates audit/design artifacts only under `.paul/phases/167-ux-audit-target-design/`
- Do not implement the TUI polish yet; Phase 168 owns code changes
- Do not add new widgets or broader Pi surfaces unless the audit uncovers a concrete need worth documenting for later discussion
- Do not change lifecycle authority, command routing semantics, or shared `.paul/*` ownership
- Do not turn this phase into general Pi productization, onboarding, or cross-harness work
```

Counts: 4 DO NOT CHANGE bullets / 4 SCOPE LIMITS bullets / 5 named files in DO NOT CHANGE.

### Pre-CODI baseline: Phase 168-01

```
## DO NOT CHANGE
- `drivers/pi/extensions/README.md`, `README.md`, `drivers/pi/skill-map.md`, and `tests/pi-end-to-end-validation.sh` unless a critical verification break leaves no safe alternative; planned alignment belongs to Phase 169
- guided workflow detection/continuation semantics beyond any incidental wording cleanup strictly required by the render-path change
- `.paul/*` lifecycle authority, command routing semantics, or CARL session-boundary behavior
- installed runtime files under `~/.pi/agent/...`

## SCOPE LIMITS
- This plan modifies the runtime render path in `drivers/pi/extensions/pals-hooks.ts`
- Do not add new widgets, panels, or dashboards
- Do not reopen module-visibility design beyond what is necessary to keep the main panel calm
- Do not redesign documentation or validation contracts in this phase
- Keep the implementation additive, bounded, and easy for Phase 169 to document/validate afterward
```

Counts: 4 DO NOT CHANGE bullets / 5 SCOPE LIMITS bullets / 4 named files in DO NOT CHANGE.

### Pre-CODI baseline median (n=2)
- DO NOT CHANGE bullets: median 4
- Named files in DO NOT CHANGE: median 4.5
- SCOPE LIMITS bullets: median 4.5

### CODI-era counts (from Sessions A/B/C)
- 170-01: 9 / ~9 / 7
- 171-01: 9 / ~9 / 5
- 172-01: 8 / ~8 / 6
- **CODI-era median (n=3): DO NOT CHANGE 9 / named files ~9 / SCOPE LIMITS 6**

---

## Signal Scoring

Per AC-2, signals 1, 2, 4 exclude CODI_NULL=true rows from numerator-and-denominator. Sessions A, B, C, D are all CODI_NULL=true (no resolved-with-call-sites injection). Session E (counterfactual, CODI_NULL=false) contributes only to projection sub-comparisons.

### Signal 1 — Fewer unexpected files in APPLY

- **Rubric (CODI-null-aware):** pass = ≥ 2/3 of NON-CODI_NULL sessions had ≤ 1 unexpected file beyond declared `files_modified`; partial = 1/2 or 1/3; fail = 0; not-applicable = fewer than 2 non-CODI_NULL rows AND no counterfactual contribution.
- **Live evidence (Sessions A–D, after CODI_NULL exclusion):** 0 non-CODI_NULL rows. Signal cannot be scored from live evidence alone.
- **Score: not-applicable — trial sample lacks CODI-active evidence for this signal.**
- **Counterfactual addition (Session E projection):** Phase 168's actual declared-vs-actual was 1 declared / 1 actual = 0 unexpected files. The blast_radius for `palsHooks` (fan-out 21) would have surfaced 21 callees; if any were touched in APPLY, they would have been declared up-front. SUMMARY shows 0 unexpected files actually occurred; the synthetic blast_radius would have either confirmed the bounded scope (information cost only) OR surfaced callees the planner would then have added to declared files (preventing surprise). Qualitative judgment: **moderate value** — the resolved blast_radius provides verification, not surprise prevention, in this specific case because Phase 168 was already correctly scoped to one file.

### Signal 2 — Drop in mid-APPLY codegraph calls (interpreted as "plans carried structural facts forward")

- **Rubric (CODI-null-aware):** same denominator-restriction as Signal 1.
- **Live evidence:** 0 non-CODI_NULL rows.
- **Score: not-applicable — trial sample lacks CODI-active evidence for this signal.**
- **Honest cross-cutting note:** Sessions B and D both showed extensive codegraph research happened DURING PLAN (5 probes in Session B, 7 in Session D), driven by the planner's empirical-probing instinct. This is the inverse of what Signal 2 measures: research moved up-front, not eliminated. CODI's blast_radius injection didn't drive that pattern (CODI was CODI_NULL in both); the planner did it independently.
- **Counterfactual addition (Session E projection):** Would Phase 168 APPLY have benefited from carrying a Blast Radius block for `palsHooks` (depth 3, fan-out 21) into the plan? **Limited yes.** Phase 168's APPLY ran clean (1/1 PASS, no retries) because the work was localized to one file. The blast_radius would have been visible context for the planner when writing `<boundaries>` — see Signal 3 — but APPLY did not need it. Different scope (e.g., a refactor across multiple call sites of `renderLifecycleStatus`) would benefit more.

### Signal 3 — More specific `<boundaries>`

- **Rubric:** compare CODI-era `<boundaries>` (170/171/172) against pre-CODI `<boundaries>` (167/168) on three sub-axes — DO NOT CHANGE bullets, named files in those bullets, SCOPE LIMITS bullets. Pass = CODI-era median is greater on ≥ 2 sub-axes; partial = greater on 1; fail = no improvement or regression.
- **Comparison:**

| Sub-axis | Pre-CODI median (n=2) | CODI-era median (n=3) | CODI-era greater? |
|---|---|---|---|
| DO NOT CHANGE bullets | 4 | 9 | **yes** |
| Named files in DO NOT CHANGE | 4.5 | ~9 | **yes** |
| SCOPE LIMITS bullets | 4.5 | 6 | **yes** |

CODI-era is greater on **3 of 3 sub-axes**.

- **Score: pass.**
- **Honesty caveat (REQUIRED):** All 3 CODI-era sessions were CODI_NULL=true. The improved specificity is therefore **almost entirely attributable to general planner maturity / discipline shift in v2.39's milestone**, NOT to CODI injecting blast_radius. The 170/171/172 boundary blocks were authored without any blast_radius input from CODI. This signal scores "pass" structurally but the rubric measurement does not establish causation by CODI. This is precisely the concern raised in pre-APPLY review.
- **Counterfactual sub-comparison (Session E projection):** With Session E's resolved blast_radius, 168-01's `<boundaries>` could have grown a CODI-derived bullet such as: "DO NOT CHANGE: callers of `renderCompactLoopSummary` outside the planned render-path edit (`pals-hooks.ts:249` fan-out:2)" — adding 1–3 specific boundary bullets grounded in resolved call-site evidence, named files: +2–6 (depending on which call-site files are surfaced). **Projected score: projected-pass** for the counterfactual case. CODI-active TS scopes can plausibly add 10–25% to boundary specificity above the existing planner-discipline baseline. This is the strongest evidence for CODI's value envelope in the entire dataset.

### Signal 4 — No need for understand/verify brokers

- **Rubric (CODI-null-aware):** same denominator-restriction as Signal 1.
- **Live evidence:** 0 non-CODI_NULL rows.
- **Score: not-applicable — trial sample lacks CODI-active evidence for this signal.**
- **Live cross-cutting note:** None of Sessions A–D invoked formal Explore-agent or sub-broker calls during APPLY. All planner-side codegraph probing happened in-context during PLAN, not via brokers. Signal 4 is therefore "no broker substitution observed" in absolute terms across all 4 live sessions, but this is a property of the planner's working pattern, not CODI's contribution.
- **Counterfactual addition (Session E projection):** Phase 168 APPLY did not invoke any research broker (single-file scope). The synthetic blast_radius would not have replaced any broker call — there were none. **Projected score: not-applicable** for the counterfactual case; Signal 4 cannot be evaluated in this counterfactual either.

---

## Cross-cutting observations

### Observation 1: Live trial sample is uniformly CODI_NULL

All 4 live PALS planning sessions in the v2.39 milestone are CODI_NULL=true. Sessions A and B because CODI was being built (no impact calls possible); Session C because the prose-heavy phase scope produced 0 extracted symbols (explicit hook-level skip per the manifest); Session D because the extracted markdown-layer identifiers (`impact`, `analyze_scope`, `pals-implementer`, `modules.codi`) all returned `Symbol "X" not found` against the live codegraph index.

The dominant outcome across live sessions is the explicit skip path. Quote from 172-01 SUMMARY (verbatim): `[dispatch] CODI (p220) → skipped — no extractable symbols in phase scope`. Quote from 173-01 PLAN (verbatim): `0 resolved, 4 unresolved`.

**This means signals 1, 2, 4 are unscoreable from the live trial alone.** Only signal 3 (which measures `<boundaries>` quality independent of CODI injection) could be scored — and its causation could not be attributed to CODI.

### Observation 2: Structural reframing surfaced by counterfactual probe

The codegraph DOES index PALS TypeScript with rich blast-radius. Direct probe results captured during 173-01 PLAN construction:

- `palsHooks` → resolved, depth 3, **fan-out 21**, role:entry-point at `drivers/pi/extensions/pals-hooks.ts:1055`
- `renderCompactLoopSummary` → resolved, depth 1, fan-out 2
- `renderLifecycleStatus` → resolved, depth 1, fan-out 3
- `syncLifecycleUi` → resolved, depth 2, fan-out 5
- `renderLoopBadge` → resolved-but-empty (entry point)

The 0/4 unresolved on Session D was NOT a "markdown-heavy framework repo" problem. It was extractor-vs-scope alignment: the extractor ran on prose-heavy planning text and pulled markdown-layer manifest identifiers, which are not in the codegraph's TS index. When given TS symbols, CODI works as designed.

**Implication:** Phases 170–172 had no TS in scope; their CODI_NULL outcomes were correct extractor behavior, not CODI failures or repo-representativeness problems. CODI's value envelope is bounded by **extractor-vs-scope alignment**, not by repo type or codegraph availability.

### Observation 3: Phase 172's prose-heavy seed coupling did not change Phase 173's hit-rate

Phase 172 explicitly added "lightweight optional symbol-enumeration tweak to `analyze_scope` so prose-heavy objectives still produce CODI targets" (per 172-01 PLAN objective). Phase 173-01 is the first downstream test of that coupling: the seed pass extracted 4 symbols (`impact`, `analyze_scope`, `pals-implementer`, `modules.codi`) — a non-zero extraction, so the seed coupling worked at the extraction layer. But all 4 returned `Symbol "X" not found` because they're not codegraph-indexed identifiers.

The seed coupling reduces "0 extractable symbols" hook-level skips by surfacing prose-mentioned tokens, but it does not improve resolution rate when the prose-mentioned tokens are markdown-layer identifiers rather than indexed code symbols. **The fix may be in the wrong layer**: improving extraction from PLAN-referenced source files (which Phase 168's `<context>` source-file list would have given CODI direct access to TS symbols like `palsHooks`) might have higher payoff than enriching prose-side extraction.

### Observation 4: Trial setting calibration

The live trial set tests CODI on its **near-worst-case** scope (markdown manifest + workflow + config + docs work). The counterfactual tests it on its **best-case** scope (TS-touching work in indexed code, scoped to a single file with 21 downstream call-sites available as boundary context). Real PALS users will see a mix; iterate/ship/kill should be calibrated against both, and the rubric's CODI-null-aware down-weighting is what allows that calibration to be honest.

### Observation 5: Empirical probing during PLAN is now a robust pattern

Sessions B, D both did extensive in-context `impact` probing during PLAN (5 probes in B, 7 in D), each surfacing assumption errors that materially improved the plan before APPLY. This is the Phase 171 pattern operating as designed — but it's **the planner's pattern, not CODI's contribution**. CODI was CODI_NULL in both cases. If anything, this pattern partially substitutes for what CODI would inject, suggesting CODI's marginal value is highest precisely when the planner skips manual probing.

### Observation 6: Format ambiguity in success-log resolved count (worth recording)

Session E's synthesis surfaced an ambiguity in the manifest's success-log format. The manifest specifies `R resolved, U unresolved, K total call-sites` but does not explicitly state whether R counts resolved-with-call-sites only OR resolved-with-call-sites + resolved-but-empty. Phase 173-01's own dispatch (`0 resolved, 4 unresolved`) is unambiguous (no resolved at all), but Session E's mixed outcome (4+1+1) requires a convention. Recording as a v0.1 documentation gap that would belong in any ITERATE_V0_1 task list.

---

End of TRIAL-DATA.md. See `173-01-DECISION.md` for the binding verdict.
