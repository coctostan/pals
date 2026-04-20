---
phase: 181-root-cause-analysis
plan: 01
artifact: ANALYSIS
produced: 2026-04-20
status: complete
---

# Phase 181-01 Root-Cause Analysis

Read-only analysis of the two v2.41 CODI post-unify instrumentation failures surfaced by Phase 179's observation of quark `112-01` and quark `113-01`. Phase 181 is strictly observational — no source, module, workflow, or installed-registry file is edited here. All v2.41 artifacts remain byte-identical throughout.

**Integrity invariants preserved:**
- CODI source frozen at SHA `0d667560b65944801faaee270ab920786afa471a` for v2.41 interpretation.
- v2.42 measurement SHA `26f262c3af3b87221ba0872b55e89fdea7c02d52` governs the active instrument and is NOT exercised in Phase 181.
- No retroactive edit to any v2.41 artifact or any `CODI-HISTORY.md` row (pals or quark) is made or recommended.

---

## Section 1 — quark `112-01` Parser-Miss (AC-1)

### 1.1 Verbatim evidence

**Observed quark `112-01-PLAN.md` `<module_dispatch>` CODI line** (from `/Users/maxwellnewman/claude/quark/.paul/phases/112-security-correctness-runtime-wiring/112-01-PLAN.md` line 58, pipe-joined single-line advisory dispatch):

```
[dispatch] pre-plan advisory: ARCH(p75) → layered TypeScript repo ...
  | TODD(p100) → Vitest detected, strong TDD candidate
  | IRIS(p150) → no TODO/FIXME/HACK/XXX markers in planned source files
  | DOCS(p200) → nearby security docs already exist ...
  | DAVE(p200) → `.github/workflows/ci-cd.yml` present ...
  | SETH(p80) → no hardcoded-secret/auth red flags in planned files
  | CODI(p220) → partial blast radius injected
```

(Formatted across multiple lines here for readability; in the PLAN.md the entire list is one `[dispatch]` line. The CODI fragment is exactly: `CODI(p220) → partial blast radius injected`.)

**Blast Radius was actually injected** — confirmed by `### Blast Radius (CODI)` at line 73 of the same PLAN.md, with per-symbol fan-out rows for `makeProcessRun`, `createProcessSyscalls`, etc. CODI pre-plan produced real structural output. This is a measurement-surface failure, not absence of CODI value.

**Qualitative APPLY-consumption confirmed** — the quark `112-01-SUMMARY.md` `### CODI Influence on APPLY` block (line 83+) records **"CODI materially shaped APPLY: yes"** with specific attribution (boundary caution, file awareness, sequencing, avoided missed caller). Phase 179's SUMMARY echoes this and also contains the quark `### CODI` post-unify recap (lines 55–58 of `112-01-SUMMARY.md`) which itself records the parser-miss and the written row: `| 112-01 | 2026-04-18 | no-dispatch-found | — | — | — | — | n |`.

### 1.2 CODI post-unify's 5 search patterns (verbatim from installed `modules.yaml`)

From `/Users/maxwellnewman/.pi/agent/packs/pals/skills/pals/modules.yaml` `installed_modules.codi.hook_details.post-unify.description`, STEP 2 (PRIMARY READ) and STEP 3 (FALLBACK READ) search for these five strings — the primary read looks in PLAN.md's `<module_dispatch>` region, the fallback read looks in SUMMARY.md's `## Module Execution Reports` region. Pattern #1 is a template fragment; patterns #2–#5 are the four hook-level skip strings:

1. Success-log template: `impact × N symbols → R resolved, U unresolved, K total call-sites, injected blast_radius`
2. Skip: `no extractable symbols in phase scope`
3. Skip: `codegraph tools unavailable`
4. Skip: `impact loop errored:`
5. Skip: `impact returned empty blast radius for all symbols`

### 1.3 Pattern-match table (STEP 2 primary — PLAN.md `<module_dispatch>`)

| Pattern | Matches `CODI(p220) → partial blast radius injected`? | Evidence |
|---------|-----------------------------------------------------|----------|
| #1 success-log template | **No** | Success template requires `impact × {N} symbols → {R} resolved, {U} unresolved, {K} total call-sites, injected blast_radius`. Observed string contains none of the substrings `impact ×`, `resolved`, `unresolved`, `total call-sites`. It contains `injected` but only as part of `blast radius injected` (no space-separated `injected blast_radius` marker). |
| #2 `no extractable symbols in phase scope` | **No** | Substring absent. |
| #3 `codegraph tools unavailable` | **No** | Substring absent. |
| #4 `impact loop errored:` | **No** | Substring absent. |
| #5 `impact returned empty blast radius for all symbols` | **No** | Substring absent. |

STEP 2 outcome: zero matches → STEP 3 fallback triggered.

### 1.4 Pattern-match table (STEP 3 fallback — SUMMARY.md `## Module Execution Reports`)

Important timing note: per `modules/codi/references/codi-instrumentation.md` "Why PLAN.md is primary," `post_unify_hooks` runs **before** `finalize_summary`, so at hook-dispatch time SUMMARY.md's `## Module Execution Reports` section has not yet been populated with carry-forward CODI content. However, the quark `112-01-SUMMARY.md` DOES contain a post-hoc `## Module Execution Reports` section (line 47+) authored during `finalize_summary`, which in principle would satisfy a later out-of-order re-read. Checking that section's wording retrospectively:

Observed wording in quark `112-01-SUMMARY.md` `## Module Execution Reports`:
- Line 49: `[dispatch] post-unify: WALT(100) → 1 side effect | CODI(220) → 1 side effect | RUBY(300) → 1 report | SKIP(200) → 1 report`
- Line 55–58: `### CODI` block with the prose `Reason: the Phase 112 plan contains the injected Blast Radius section, but not the exact post-unify dispatch line format that the CODI instrumentation expects for automatic 'injected' classification.`

| Pattern | Matches in SUMMARY.md `## Module Execution Reports`? | Evidence |
|---------|-----------------------------------------------------|----------|
| #1 success-log template | **No** | No `impact × N symbols → R resolved, U unresolved, K total call-sites, injected blast_radius` substring anywhere in the section. The `CODI(220) → 1 side effect` fragment is dispatch-log shorthand, not the success template. |
| #2–#5 skip strings | **No** | None of the four verbatim skip strings appears. |

STEP 3 outcome: zero matches. Even retrospectively with the populated `## Module Execution Reports` section available, fallback would not have rescued the match. The Reason prose in `### CODI` IS an explanation of the parser-miss but is NOT itself a pattern the classifier recognizes.

STEP 4 outcome: `no-dispatch-found` recorded for `112-01` in quark `.paul/CODI-HISTORY.md` — which is exactly what was observed.

### 1.5 Substring gap — what the parser literally does not see

The observed fragment `CODI(p220) → partial blast radius injected` is semantically a success-log (it reports that Blast Radius was injected, albeit partially) but does not contain the machine-readable shape the parser requires:

- missing `impact × N symbols →` prefix
- missing explicit `{R} resolved` count
- missing `{U} unresolved` count
- missing `{K} total call-sites` count
- the word `injected` appears but adjacent to `blast radius` rather than followed by `blast_radius` (the template uses the underscore form)

Any one of these five template-substring requirements, checked as strict literal substring matches, would be enough to reject the match. All five are missing. This is maximal template strictness: the parser insists on the exact success-log shape CODI itself emits from its own STEP 6, with no tolerance for paraphrased or count-free dispatch lines.

### 1.6 Ownership categorization

**Chosen: `both` — primary ownership `parser-too-strict`, secondary ownership `plan-wording-non-canonical`.**

Evidence for `parser-too-strict` as primary owner:
- CODI's pre-plan STEP 6 emits a single canonical success-log line when it injects Blast Radius. That canonical line IS the source of truth for STEP 2's primary-read pattern. However, in the 112-01 observation, the quark phase's pre-plan workflow did not produce that exact line verbatim in PLAN.md's `<module_dispatch>`. Instead, an upstream model/workflow process rendered a summarized advisory list. The parser responded to the summarization by classifying as `no-dispatch-found`, which is the same token used for absent CODI entirely — **the two cases are indistinguishable in the ledger**. This ledger ambiguity is the actual defect: the parser has no signal for "I see CODI advisory output but not in the expected format."
- The `### Blast Radius (CODI)` sub-section WAS present in the PLAN.md (line 73). A parser that recognized Blast Radius sub-section presence as a secondary success signal could have classified this as `injected-degraded` or similar, preserving the distinction between "CODI ran but wording drifted" (here) and "CODI did not run at all" (e.g., hotfix mode with no PLAN.md).

Evidence for `plan-wording-non-canonical` as secondary owner:
- The canonical pre-plan STEP 6 emit contract is fixed and produces the exact template. The drift in 112-01 is that the upstream summarizer — whatever produced the pipe-joined single-line `[dispatch] pre-plan advisory: ...` consolidation — compressed CODI's canonical success line into a paraphrase. If that upstream consolidation were contract-guarded to preserve CODI's exact STEP 6 line verbatim inside the combined advisory, STEP 2's primary read would have matched and no parser change would be needed.
- This is a workflow-wording / plan-creation-output drift, not a CODI advisory-behavior issue. It can be addressed without reopening CODI's advisory step, extractor rules, or Blast Radius format.

Both owners are needed because fixing only one leaves the other defect latent:
- Parser-only fix: would classify the observed 112-01 string correctly, but any other future plan-wording drift (truncation, emoji, additional prose) would rediscover the same ledger ambiguity.
- Plan-wording-only fix: would restore the canonical success line in combined-advisory contexts, but hand-written or legacy plans (including the v2.41 snapshot already frozen) would still look like `no-dispatch-found` forever — acceptable for frozen v2.41, but the ledger still can't distinguish `CODI ran but classifier lost it` from `CODI did not run` going forward.

Either fix is bounded. The decision between fixing one, the other, or both with tightened coupling is a Phase 182 design call — Phase 181's role is only to name the owning layer(s). Both layers are named with evidence.

### 1.7 Read-only constraints honored

- No edit to quark `112-01-PLAN.md`, `112-01-SUMMARY.md`, or `.paul/CODI-HISTORY.md`.
- No retroactive row repair. The observed `no-dispatch-found` row remains the v2.41 record.
- No CODI source file edit. SHA `0d667560b65944801faaee270ab920786afa471a` freeze preserved.
- No workflow file edit.

---

## Section 2 — quark `113-01` Hook-Not-Firing (AC-2)

### 2.1 Verbatim evidence

**Pre-plan CODI dispatched cleanly** — from `/Users/maxwellnewman/claude/quark/.paul/phases/113-security-correctness-ii/113-01-PLAN.md` line 87:

```
[dispatch] pre-plan advisory: CODI(220) → impact × 5 symbols → 2 resolved-with-call-sites,
  3 resolved-but-empty, 0 unresolved, 5 total call-sites, injected blast_radius. ...
```

The canonical success-log template IS present verbatim (`impact × 5 symbols → 2 resolved-with-call-sites, 3 resolved-but-empty, 0 unresolved, 5 total call-sites, injected blast_radius`). STEP 2's primary-read pattern #1 WOULD match this line if the post-unify hook ran.

**Post-unify did not produce CODI output** — from quark `113-01-SUMMARY.md` `## Post-unify dispatch (required)` section (line 152+):

- Line 156: `**WALT (priority 100) — Quality delta recording:**` → ran
- Line 167: `**SKIP (priority 200) — Knowledge capture from SUMMARY:**` → ran
- Line 171: `**RUBY (priority 300) — Post-unify debt / complexity analysis:**` → ran
- **No CODI(220) entry at all.**

**quark `.paul/CODI-HISTORY.md` has no `113-01` row** (verified: the file contains `112-01` with `no-dispatch-found` but no `113-01` entry).

The difference between this case and the 112-01 parser-miss matters: 112-01 produced a row with the wrong outcome (`no-dispatch-found`). 113-01 produced no row at all. That absence is diagnostic — it rules out any layer that would have produced SOME row.

### 2.2 Four-layer null-observation check

Per STEP 5 of CODI's post-unify hook description in the installed `modules.yaml`: "If `.paul/CODI-HISTORY.md` does not exist, create it with the exact header section ... Then append exactly one newline-terminated data row ... The file MUST end with a newline after every append so no two rows share a line." STEP 5 is **defensive** — it creates the file if missing, and it appends regardless of what STEP 4 categorized (including `no-dispatch-found`). **Therefore: if any CODI STEP ran to completion, a row would exist.** The fact that no row exists means the failure is **upstream of STEP 5** — either the hook did not execute at all, or the hook exited before reaching STEP 6's `APPEND ROW` logic.

#### Layer (a) — quark `pals.json` config drift

From `/Users/maxwellnewman/claude/quark/pals.json`:

```json
"codi": {
  "enabled": true,
  "description": "Codegraph-driven structural injection (safe skip when codegraph is unavailable)"
}
```

**quark has `modules.codi.enabled: true`.** This layer is NOT the owner — config permits dispatch.

Null-observation evidence: if config had disabled CODI, the installed-registry resolution step in `unify-phase.md` `post_unify_hooks` would skip CODI entirely, but it would also skip CODI pre-plan — and pre-plan ran cleanly with the canonical success log (line 87 of PLAN.md). CODI being enabled for pre-plan but disabled for post-unify is not a config shape this schema permits.

#### Layer (b) — installed-registry drift

From `/Users/maxwellnewman/.pi/agent/packs/pals/skills/pals/modules.yaml` `installed_modules.codi`:

```yaml
hooks: [pre-plan, post-unify]
hook_details:
  pre-plan:
    priority: 220
    description: "..."
    refs: [references/codi.md]
  post-unify:
    priority: 220
    description: "..."
    refs: [references/codi-instrumentation.md]
```

**The installed registry exposes CODI's `post-unify` hook_details to quark at UNIFY time**, including description and refs. This layer is NOT the owner — the registry consumed by quark during UNIFY correctly advertises the post-unify hook.

Null-observation evidence: if installed-registry drift had hidden the post-unify hook, the canonical dispatch log would still have emitted `[dispatch] post-unify: 0 modules registered for this hook` or similar, but it also would have hidden the hook from CODI pre-plan — and pre-plan fired. The registry entry either exposes both hooks or neither (there is no per-hook selective exposure in the installed schema).

Therefore installer/registry alignment is NOT implicated by the 113-01 defect.

#### Layer (c) — UNIFY workflow dispatch

From the installed `unify-phase.md` `post_unify_hooks` step (line 280 of the workflow): "Resolve installed modules for `post-unify` by finding `installed_modules.*.hook_details.post-unify`" and "Sort by `hook_details.post-unify.priority` ascending (lower runs first)".

The observed `113-01-SUMMARY.md` `## Post-unify dispatch (required)` section lists WALT(100), SKIP(200), RUBY(300) — note these are in priority order. CODI(220) would sort between SKIP(200) and RUBY(300). **CODI is absent from the iteration result**, but WALT, SKIP, and RUBY are all present. The dispatch loop ran and produced output for three modules but not for CODI.

Candidate sub-causes inside layer (c):
- (c.i) The dispatch loop iterated CODI but CODI produced no log line (hook ran silently) — **ruled out** by STEP 5's defensive append: if CODI ran, a row would exist in `CODI-HISTORY.md`. It does not.
- (c.ii) The dispatch loop did NOT iterate CODI at all — **candidate owner**. Possible reasons: priority-sort comparator using string rather than integer semantics; module resolution filtering CODI out; the workflow's "Sort by `hook_details.post-unify.priority` ascending" reading the priority as a string (`"220"`) and producing lexicographic ordering that interacts with some skip heuristic; an enumeration boundary where the first 3 modules at priorities 100/200/300 satisfied a cap.

This sub-case is plausible but not proven from artifacts alone. Phase 181 cannot distinguish "CODI silently omitted from iteration" from "CODI iterated but hook exited early before STEP 1 produced any log signature" using only the read-only quark artifact set.

#### Layer (d) — CODI post-unify hook self-skip

STEP 1 of CODI's post-unify description in the installed `modules.yaml`: "Post-unify context provides `summary_path`. Derive `plan_path` by substituting `-SUMMARY.md` → `-PLAN.md` on `summary_path`. If that file does not exist, glob `.paul/phases/*/[0-9]*-PLAN.md` and match on the plan id extracted from `summary_path`. If STILL no PLAN.md exists (hotfix mode: `summary_path` ends in `-HOTFIX-SUMMARY.md`), record outcome = `no-dispatch-found` and proceed to STEP 5 with `—` in R, U, K, Symbols and `n` in blast_radius."

**If STEP 1 resolved the plan path (normal case), STEPs 2–6 run and STEP 6 appends a row — any outcome, including `no-dispatch-found` on pattern miss, produces a row.** If STEP 1 failed hotfix-style, the description still says "record outcome = `no-dispatch-found` and proceed to STEP 5." So even degenerate STEP 1 paths still lead to STEP 5 APPEND ROW.

**For no row to exist, CODI's post-unify hook must have exited before entering STEP 5 via a path the description does not contemplate.** The description has no pre-STEP-1 early return. If the hook were dispatched and its description loaded, no path specified in the manifest leads to zero rows.

This layer is only the owner if the hook ran but exited for a reason outside the manifest description — e.g., the hook loader crashed before reading the description, or the dispatch runtime returned before invoking the hook body, or a pre-STEP-1 evaluation of the description triggered a classifier safety short-circuit.

**Null-observation evidence against layer (d):** the `113-01-SUMMARY.md` has no `[dispatch] CODI post-unify: ...` log line at all — no success, no skip, no error message. The hook did not reach STEP 7's log emission. STEP 7 runs AFTER STEP 6 APPEND. If STEP 6 failed silently (file write error), the log line would still have been attempted at STEP 7 if the hook body started at all. The cleanest explanation of "no log line, no row" is that the hook body never started.

### 2.3 Distinguishing (c) from (d)

Both (c.ii) "workflow did not iterate CODI" and (d) "hook body never started even though iterated" produce the same observed artifact absence. Phase 181 cannot discriminate them from the artifact set alone.

However, the evidence leans toward **(c.ii) — workflow dispatch did not iterate CODI** for these reasons:

1. Other modules at priorities 100, 200, 300 ran normally. If the dispatch iteration mechanism were broken generically, more than one module would have been skipped.
2. CODI specifically sits at priority 220, which is the only priority in the CODI-post-unify set that is in-between other modules. A priority-sort or deduplication bug that accidentally treats 220 as equivalent to an already-processed 200 entry is a plausible class of failure consistent with "exactly CODI(220) missing, nothing else missing."
3. Layer (d) would require a hook-body failure that produced zero observable side effects including the log line — this is a very narrow failure mode for a markdown-described hook (no binary to crash; the hook runner is the LLM interpreting the description).
4. The installed `unify-phase.md` `post_unify_hooks` step does not specify strict integer-typed priority comparison semantics; the priority field's data type is registry-YAML-dependent and can be interpreted as string or integer by the dispatch runtime.

**Primary owning layer: (c) — UNIFY workflow dispatch**, specifically the iteration/selection path that failed to include CODI(220) in the module set processed during 113-01 UNIFY.

**Deferred sub-sub-layer resolution:** whether (c.ii) happens via priority-sort semantics, module-set enumeration, or a boundary condition specific to quark's phase-directory layout is a Phase 182 APPLY-probe question. Phase 181's role is only to name (c) as the owner with layers (a), (b), (d) rejected. Phase 182's first probe task should reproduce the 113-01 setup and add a `[dispatch] post-unify: ... CODI(220) → ...` trace line to distinguish (c.ii) from (d) before implementing the fix.

### 2.4 Installer/registry implication — NOT implicated

Layer (b) was rejected with artifact evidence (installed `modules.yaml` correctly exposes CODI's post-unify hook_details). The installer `drivers/pi/install.sh` produces the installed registry, so if layer (b) were the owner, installer/manifest alignment would be in scope for Phase 182. Since layer (b) is ruled out, **installer/registry alignment is OUT of scope for Phase 182.**

### 2.5 Read-only constraints honored

- No edit to any quark file (PLAN.md, SUMMARY.md, CODI-HISTORY.md, pals.json).
- No edit to the installed `modules.yaml`.
- No edit to `modules/codi/module.yaml` or its references.
- No edit to `unify-phase.md` or any workflow file.
- No installer invocation.
- v2.41 CODI source freeze `0d667560b65944801faaee270ab920786afa471a` preserved.

---

## Phase 182 Scope Decision

### A. Defect → edit surface map

| Defect | Owning layer | Phase 182 edit surface | Edit description (one line) |
|--------|--------------|------------------------|-----------------------------|
| 112-01 parser-miss | `parser-too-strict` (primary) + `plan-wording-non-canonical` (secondary) | `modules/codi/module.yaml` post-unify STEP 2 + STEP 3 pattern set; optionally `plan-phase.md` combined-advisory wording contract | Widen STEP 2/3 to recognize Blast Radius sub-section presence as a secondary success signal producing an `injected-degraded` or equivalent non-`no-dispatch-found` outcome; optionally constrain the combined-advisory consolidation path in `plan-phase.md` to preserve CODI's canonical STEP 6 success line verbatim inside the pipe-joined `[dispatch] pre-plan advisory:` list. |
| 113-01 hook-not-firing | `workflow-dispatch` (c.ii — iteration did not include CODI(220)). Sub-sub-layer ambiguous between priority-sort semantics / module-set enumeration / boundary condition. | `modules/codi/module.yaml` post-unify (add a hook-firing guard / self-trace) + probable touch to installed `unify-phase.md` `post_unify_hooks` step; ambiguous — resolve during Phase 182 APPLY probe | Add a pre-STEP-1 minimal trace that emits `[dispatch] CODI post-unify: ...` unconditionally once the hook body starts, so "iterated but body-did-not-start" becomes observable and distinguishable from "not iterated"; Phase 182's first probe task must reproduce the 113-01 signature to disambiguate (c.ii) internal sub-cause before the full fix lands. |

### B. Installer/registry alignment decision

**OUT of scope for Phase 182** because layer (b) (installed-registry drift) was rejected with direct artifact evidence: the installed `modules.yaml` correctly exposes `installed_modules.codi.hook_details.post-unify.description` and `refs`, and the 113-01 defect lives in the UNIFY workflow dispatch iteration path (layer c), not in the installer → registry pipeline. No installer-script edit is authorized by Phase 181's analysis.

### C. Out-of-scope reaffirmation (verbatim from v2.42 proposal)

- CODI pre-plan advisory behavior — untouched in Phase 182
- `impact` / codegraph value-envelope redesign — untouched in Phase 182
- `symbol_graph`, `trace`, or any v0.2 expansion — untouched in Phase 182
- broader module-system architecture changes — untouched in Phase 182
- retroactive edits to any v2.41 artifact or any `CODI-HISTORY.md` row — forbidden
- Blast Radius markdown format / extractor rules / classifier-safety token — untouched unless the 112-01 owning layer explicitly names one of them

The 112-01 owning layers (`parser-too-strict` and `plan-wording-non-canonical`) do NOT name Blast Radius markdown format, extractor rules, or the classifier-safety token. Therefore those three remain untouched in Phase 182. The parser widening in block A targets STEP 2/3 pattern-set tolerance only — it preserves the success-log template as the primary match and adds secondary signals; it does not alter Blast Radius sub-section format, per-symbol extractor rules, or the halt-keyword substring-matching invariant.

### D. Phase 182 authorization envelope

Phase 182 is authorized to touch only the following surfaces, each derived from block A:

- **`modules/codi/module.yaml` — post-unify hook description STEP 2 and STEP 3 pattern set.** Bounded edit kind: widen STEP 2/3 to recognize Blast Radius sub-section presence as a secondary success signal and introduce an outcome token (e.g., `injected-degraded`) that distinguishes "CODI ran but classifier-template drift" from `no-dispatch-found`. Ownership evidence: Section 1.6 `parser-too-strict` primary owner; Section 1.5 substring-gap analysis names exactly which template substrings are missing. Must preserve: Blast Radius markdown format, extractor rules, classifier-safety token, per-symbol outcome semantics, `impact`/codegraph value-envelope.

- **`modules/codi/module.yaml` — post-unify hook description STEP 1 pre-entry.** Bounded edit kind: add a hook-firing guard that emits `[dispatch] CODI post-unify: hook body entered for {plan-id}` (or equivalent minimal trace) unconditionally when STEP 1 begins, so silent non-entry becomes observable. Ownership evidence: Section 2.3 (c)/(d) ambiguity requires a probe to discriminate; the guard itself both fixes the observability gap and supports the Phase 182 probe task that disambiguates sub-causes. Must preserve: STEP 1 plan-path resolution logic, STEP 5 APPEND ROW defensive behavior, STEP 7 log-line shape, classifier-safety token discipline.

- **`plan-phase.md` combined-advisory consolidation wording (optional secondary fix for 112-01).** Bounded edit kind: constrain the `[dispatch] pre-plan advisory:` combined-line consolidation to preserve CODI's canonical STEP 6 success line verbatim inside the pipe-joined list rather than paraphrasing (`partial blast radius injected`). Ownership evidence: Section 1.6 `plan-wording-non-canonical` secondary owner. This is a workflow-wording guard, NOT an advisory-semantics change — it preserves CODI pre-plan behavior, Blast Radius injection, extractor rules, and success-log R/U/K semantics identical. Optional because the parser-widening fix alone closes the ledger ambiguity; this second fix closes the root cause in plan-phase.md as well, preventing future drift. Phase 182 may elect one or both; Phase 181 authorizes both.

- **(ambiguous — resolve during Phase 182 APPLY probe)** whether the 113-01 (c.ii) sub-cause is priority-sort semantics, module-set enumeration, or a boundary condition specific to quark's phase-directory layout. Phase 182's first probe task reproduces the 113-01 signature under the fresh v2.42 SHA `26f262c3af3b87221ba0872b55e89fdea7c02d52` and uses the STEP-1 trace guard added above to collect discriminating evidence. The probe result determines whether additional edits to the installed `unify-phase.md` `post_unify_hooks` step are needed; if yes, that becomes an authorized surface AFTER the probe completes, not before.

**No surface appears in block D that does not appear in block A.** Installer/registry surfaces, advisory behavior, Blast Radius format, extractor rules, classifier token, `impact`/codegraph value-envelope, v0.2 scope, and broader module-system architecture are all explicitly absent from this envelope per block C.

---

Phase 182 opens cleanly from `181-01-ANALYSIS.md` blocks A–D without re-deriving defect ownership. The analysis names two defects with single (or explicitly-deferred) owning layers, enumerates Phase 182's authorized edit surfaces, reaffirms the v2.42 proposal's out-of-scope boundaries verbatim, and decides installer/registry alignment is OUT of scope with artifact evidence.
