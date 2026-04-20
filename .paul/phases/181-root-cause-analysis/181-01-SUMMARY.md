---
phase: 181-root-cause-analysis
plan: 01
type: research
started: 2026-04-20
completed: 2026-04-20
status: closed — root-cause analysis delivered, Phase 182 scope envelope decided
---

# Phase 181-01 Summary

## Objective

Produce a narrow, artifact-grounded defect map that isolates ownership of the two v2.41 CODI post-unify instrumentation failures — quark `112-01` parser-miss and quark `113-01` hook-not-firing — across parser logic, hook registration, UNIFY dispatch, and installed-registry alignment, and deliver an explicit scope decision for the Phase 182 bounded fix. Research-only; no source, module, workflow, or installed-registry file modified.

## What Was Built

| File | Purpose | Lines |
|------|---------|-------|
| `.paul/phases/181-root-cause-analysis/181-01-ANALYSIS.md` | Three-section analysis artifact: §1 112-01 parser-miss ownership, §2 113-01 hook-not-firing ownership, §3 Phase 182 Scope Decision (blocks A–D) | 280 |
| `.paul/phases/181-root-cause-analysis/181-01-SUMMARY.md` | This file — plan-vs-actual reconciliation | this |

No source files, no module files, no workflow files, no installed-registry files, and no quark artifacts were modified.

## Headline Findings

1. **112-01 parser-miss owning layers:** `parser-too-strict` (primary) + `plan-wording-non-canonical` (secondary). The observed PLAN.md dispatch fragment `CODI(p220) → partial blast radius injected` fails all five STEP 2/3 patterns (success-log template + 4 skip strings) in **both** primary and fallback read paths. Blast Radius sub-section WAS injected and CODI materially shaped APPLY per quark SUMMARY — this is a measurement-surface failure, not absence of value. The `no-dispatch-found` token used in the ledger is indistinguishable from "CODI did not run at all," which is the actual defect.

2. **113-01 hook-not-firing owning layer:** **(c) UNIFY workflow dispatch** — CODI(220) was omitted from iteration during quark UNIFY. Other modules at priorities 100/200/300 ran normally. Layers (a) config drift, (b) installed-registry drift, (d) hook self-skip all rejected by direct artifact null-observation evidence. Sub-sub-cause within (c) — priority-sort semantics vs module-set enumeration vs boundary condition — explicitly deferred to Phase 182's first APPLY probe task (permitted by the plan's documented ambiguity escape).

3. **Installer/registry alignment: OUT of scope for Phase 182.** Layer (b) was rejected with direct artifact evidence — the installed `/Users/maxwellnewman/.pi/agent/packs/pals/skills/pals/modules.yaml` correctly exposes `installed_modules.codi.hook_details.post-unify.description` and `refs`. The defect lives in the UNIFY workflow dispatch iteration path, not in the installer → registry pipeline. No installer-script edit is authorized by Phase 181.

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | 112-01 parser-miss owned to a specific layer with reproducible artifact evidence | **PASS** | `181-01-ANALYSIS.md` §1.1–1.6: verbatim quark PLAN.md dispatch line + 5-pattern comparison table in both STEP 2 primary and STEP 3 fallback read paths, with zero matches in each table. Ownership categorized `both` (parser-too-strict primary + plan-wording-non-canonical secondary) with per-owner evidence paragraphs and "both are needed" justification. |
| AC-2 | 113-01 hook-not-firing owned to exactly one of (a)/(b)/(c)/(d) with null-observation evidence | **PASS** | `181-01-ANALYSIS.md` §2.1–2.4: Layer (a) rejected via verbatim `modules.codi.enabled: true` quote from quark `pals.json`. Layer (b) rejected via verbatim `installed_modules.codi.hook_details.post-unify` quote from installed `modules.yaml`. Layer (c) named as owner. Layer (d) rejected via STEP 7 log-emission absence analysis. Installer/registry implication named: NOT implicated. |
| AC-3 | Phase 182 scope envelope decided explicitly against v2.42 proposal bounded-scope rules | **PASS** | `181-01-ANALYSIS.md` §"Phase 182 Scope Decision" with four required blocks: (A) defect→edit-surface map (2 rows), (B) installer/registry OUT with evidence, (C) out-of-scope reaffirmation (6 bullets restated verbatim from v2.42 proposal), (D) authorization envelope naming 3 concrete edit surfaces + 1 explicit deferred probe; closed with the "no surface in D missing from A" invariant and the Phase 182 handoff sentence. |

## Verification Results

Per-task verify commands from PLAN.md, all executed post-write:

- Task 1 verify: `grep -c "112-01"` → 17 (expected ≥1); `grep -c "impact × N symbols"` → 3 (expected ≥1). **PASS**
- Task 2 verify: `grep -c "113-01"` → 14 (expected ≥3 distinct artifact quotes); config/registry/workflow evidence grep → 10 matches across all three layers. **PASS**
- Task 3 verify: `grep -c "Phase 182"` → 18 (expected ≥6); integrity-token grep (retroactive / v2.41 artifact / both SHA freezes) → 8 hits; block-header grep (`^### A\.|^### B\.|^### C\.|^### D\.|^## Phase 182 Scope Decision`) → 5 matches (expected ≥5). **PASS**

Ground-truth diff check: `git diff --stat 59fb050b..HEAD` shows only `.paul/` file changes. Plan's `files_modified` claimed only `.paul/` paths. Reconciliation aligns — no non-`.paul/` file changes claimed or made.

## Module Execution Reports

### Pre-plan dispatch (during /paul:plan)

- `[dispatch] pre-plan advisory: ARCH(p75) → skip — no source files in scope (research phase) | SETH(p80) → skip — no code files in scope | TODD(p100) → skip — no implementation path in research phase | IRIS(p150) → skip — markdown-only analysis scope | DOCS(p200) → 0 annotations — analysis artifact is new, no paired source-file drift | DAVE(p200) → skip — no CI config changes | CODI(p220) → skipped — no extractable symbols in phase scope | RUBY(p250) → skip — no code surface`
- `[dispatch] pre-plan enforcement: DEAN(p50) → PASS — no dependency manifest changes; existing `.paul/dean-baseline.json` baseline honored`
- `[dispatch] post-plan: TODD(p100) → skip — research plan type; no RED/GREEN/REFACTOR restructuring applicable | 1 module registered, 0 modifications applied`

### Pre-apply dispatch

- `[dispatch] pre-apply: TODD(p50) → skip — research phase has no test-first surface (N/A per plan's skills section)`
- `[dispatch] pre-apply: WALT(p100) → baseline recorded — no project test command to run on markdown-only research phase; baseline is zero (consistent with Phase 179 precedent)`

### Post-task dispatch (TODD only for post-task)

- `[dispatch] post-task(Task 1): TODD(p100) → skip — research-only phase, no test-first surface`
- `[dispatch] post-task(Task 2): TODD(p100) → skip — research-only phase, no test-first surface`
- `[dispatch] post-task(Task 3): TODD(p100) → skip — research-only phase, no test-first surface`

### Post-apply advisory dispatch

- `[dispatch] post-apply advisory: IRIS(p250) → 0 real annotations — 1 grep hit for TODO/FIXME/HACK/XXX inside a verbatim quark-artifact quote in `181-01-ANALYSIS.md` line 29 (`| IRIS(p150) → no TODO/FIXME/HACK/XXX markers in planned source files`), which is a false positive on quoted content, not a repo anti-pattern marker.`
- `[dispatch] post-apply advisory: DOCS(p250) → 0 annotations — analysis artifact is new under `.paul/phases/181-*/`; no paired source-file drift, and no functional code changed so README.md/CHANGELOG.md updates are not expected.`
- `[dispatch] post-apply advisory: RUBY(p300) → 0 annotations — markdown-only artifact (280 lines total); code complexity analysis not applicable.`
- `[dispatch] post-apply advisory: SKIP(p300) → knowledge captured inline in ANALYSIS.md §1.6 (parser-miss ownership categorization with both-owner evidence) and §2.3 ((c)/(d) disambiguation heuristic with four-point rationale); formalized in SKIP post-unify pass below.`

### Post-apply enforcement dispatch

- `[dispatch] post-apply enforcement: WALT(p100) → PASS — no project source/test/lint/typecheck changes; baseline preserved`
- `[dispatch] post-apply enforcement: DEAN(p150) → PASS — no dependency manifest changes; `.paul/dean-baseline.json` baseline honored with zero delta`
- `[dispatch] post-apply enforcement: TODD(p200) → PASS — research phase, no TDD sequencing required (N/A per plan)`

### Pre-unify dispatch

- `[dispatch] pre-unify: 0 modules registered for this hook`

### Post-unify dispatch

- `[dispatch] post-unify: WALT(p100) → 1 side effect — appended `.paul/QUALITY-HISTORY.md` and `.paul/quality-history.md` row for Phase 181 (research phase; test counts unchanged; trend → stable)`
- `[dispatch] post-unify: SKIP(p200) → 1 report — knowledge entries captured inline in this SUMMARY's Key Patterns / Decisions section plus STATE.md Decisions table rows for the two ownership assignments and the Phase 182 scope decision`
- `[dispatch] post-unify: CODI(p220) → appended skipped-no-symbols row for 181-01` — STEP 2 primary-read of PLAN.md `<module_dispatch>` matched pattern #2 (`no extractable symbols in phase scope`); STEP 4 outcome = `skipped-no-symbols`; STEP 5 fields R/U/K/Symbols = `—`, blast_radius = `n`; STEP 6 appended row `| 181-01 | 2026-04-20 | skipped-no-symbols | — | — | — | — | n |` to `.paul/CODI-HISTORY.md`.
- `[dispatch] post-unify: RUBY(p300) → skipped — no source-code changes in phase scope`

Self-reflexive note on CODI's 181-01 row: this phase analyzes the same class of measurement surface it itself is measured by. Phase 181's row is `skipped-no-symbols` (correct and honest, not a defect) because Phase 181 has no `.ts/.tsx/.js/.jsx` files in `<context>`. This is the DESIRED behavior and is structurally different from the two v2.41 defects (where CODI DID extract symbols and produce Blast Radius but the post-unify surface lost the signal). Phase 181's own CODI row is a correctly-classified skip, not evidence of the parser-miss or hook-not-firing defects analyzed in the artifact.

### Skill audit

| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for Phase 181 analysis |
| /carl | ✓ | Session-boundary routing remained active across the phase |
| TODD | N/A | Research-only markdown analysis phase; no implementation path or RED/GREEN/REFACTOR work applied. Consistent with Phase 159 / Phase 179 precedent. |
| WALT | N/A | No project test/lint/typecheck path meaningfully gated by analysis edits. Plan's skills section documented N/A explicitly. |

**Skill audit: all required skills either invoked or documented N/A ✓**

## Deviations

1. **PR #90 had squash-merged into `main` by the time APPLY began, but `.paul/STATE.md` Git State still claimed `PR: #90 (state: open)`.** During GitHub Flow preflight the branch `feature/180-re-trial-gating-decision` was found to be 1 commit behind `origin/main` (squash-merge of its own content). A new working branch `feature/181-root-cause-analysis` was created and cleanly rebased to `origin/main` via `git reset --hard origin/main` after stashing the in-flight v2.42 milestone-open + Phase 181 plan artifacts. Rebase was avoided because the squash-merge of PR #90 had linearized the commit history. **Impact: minor — stale STATE.md Git State text was corrected during finalize; no plan artifact changed.** No lifecycle disruption.

2. **Unrelated Pi runtime config drift (`.pi/settings.json` updates + `.pi/npm/.gitignore`) was present in the working tree before APPLY began.** These were unstaged during the APPLY commit (`git reset HEAD .pi/settings.json .pi/npm/`) so only in-scope Phase 181 changes were committed. **Impact: none on Phase 181 scope — the Pi config drift remains in the working tree and is unrelated to v2.42 instrumentation work.**

Neither deviation altered the plan's acceptance criteria, boundaries, or analysis content.

## Key Patterns / Decisions

1. **Ledger-ambiguity is the actual v2.41 instrumentation defect, not any single per-phase miss.** The `no-dispatch-found` token does double duty (hotfix mode AND parser-miss AND hook-not-firing all collapse to it), which is why two natural observations surfaced two different owning layers but produced identical-looking ledger rows. Phase 182's parser-widening edit must introduce at least one new outcome token (e.g., `injected-degraded`) to break this collapse. **Decision recorded for STATE.md.**

2. **STEP 5's defensive append logic is the single most useful diagnostic signal in CODI's post-unify contract.** Because STEP 5 creates the file if missing and appends regardless of STEP 4's categorization, the absence of ANY row for a given plan-id is diagnostic of "hook did not reach STEP 5," which lets Phase 181 rule out every layer whose failure mode would still have produced a row. This pattern — make the append step defensive so its absence is diagnostic — should be preserved and considered for other post-unify modules. **Decision recorded for STATE.md.**

3. **Null-observation evidence is rigorous in markdown-described hooks.** For `113-01`, the absence of a `[dispatch] CODI post-unify: ...` log line in the quark SUMMARY was sufficient to reject layer (d). When the hook runner is an LLM interpreting a description, the four STEP exit paths defined in the description are the only exits the runner is expected to take; any exit outside those paths is itself an observable pattern. **Decision recorded for STATE.md.**

4. **Phase 181 is authorized to recommend workflow-wording edits (`plan-phase.md` combined-advisory contract) without reopening CODI advisory behavior.** The test for this is: does the proposed edit preserve Blast Radius injection, per-symbol extractor rules, and R/U/K success-log semantics identical? If yes, it's a workflow-wording guard and permitted in the Phase 182 authorization envelope. If no, it would reopen advisory scope and must be rejected. Block D of the Phase 182 Scope Decision applies this test. **Decision recorded for STATE.md.**

5. **Sub-sub-cause deferral to Phase 182 APPLY probe is a legitimate Phase 181 outcome** when the artifact evidence cannot discriminate between two candidate sub-causes within a single owning layer. The plan's `<action>` for Task 2 explicitly permitted `"ambiguous — resolve during Phase 182 APPLY probe"` as a valid outcome, and the STEP-1 trace guard authorized in block D of the Phase 182 Scope Decision IS the probe instrument. This preserves Phase 181's read-only invariant while not forcing a premature sub-sub-cause commitment. **Decision recorded for STATE.md.**

## Next Phase

**Phase 182 — Bounded Instrumentation Fix.** Opens cleanly from `.paul/phases/181-root-cause-analysis/181-01-ANALYSIS.md` blocks A–D without re-deriving defect ownership. Authorized edit surfaces:

1. `modules/codi/module.yaml` post-unify hook description STEP 2 + STEP 3 pattern set — widen to recognize Blast Radius sub-section presence as a secondary success signal; introduce an outcome token (e.g., `injected-degraded`) that distinguishes CODI-ran-but-drifted from CODI-absent.
2. `modules/codi/module.yaml` post-unify hook description STEP 1 pre-entry — add a hook-firing guard trace so silent non-entry becomes observable and distinguishable from not-iterated.
3. (optional secondary fix for 112-01) `plan-phase.md` combined-advisory consolidation wording contract — preserve CODI's canonical STEP 6 success line verbatim inside the pipe-joined `[dispatch] pre-plan advisory:` list.
4. (Phase 182 APPLY probe required before additional edits) disambiguate the (c.ii) sub-sub-cause between priority-sort semantics, module-set enumeration, and boundary condition; the STEP-1 trace guard from #2 is the probe instrument.

Phase 182 must preserve all out-of-scope invariants per the v2.42 proposal: CODI pre-plan advisory behavior, `impact`/codegraph value-envelope, `symbol_graph`/`trace`/v0.2 expansion, broader module-system architecture, retroactive v2.41 artifact edits, and Blast Radius markdown format / extractor rules / classifier-safety token all remain untouched.
