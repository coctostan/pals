---
phase: 171-impact-integration-symbol-extraction
plan: 01
completed: 2026-04-16T20:23:17Z
duration: ~120 minutes (PLAN with empirical probing + mid-plan correction + APPLY + UNIFY, continuous session)
---

## Objective

Upgrade the CODI module from Phase 170's hello-world scaffolding to a live pre-plan advisory overlay that: (1) extracts explicit symbols from phase scope via strict textual rules (no magic inference); (2) calls `impact({ symbols: [singleSymbol], changeType: "behavior_change" })` **per extracted symbol** (NOT batched), wrapped with call-time graceful failure handling; (3) formats the returned blast radius as a markdown sub-section; (4) returns it as `context_inject.blast_radius` so the plan-phase workflow surfaces it inline in the generated PLAN.md's existing `<module_dispatch>` section. No PLAN.md template changes, no kernel/workflow/installer edits.

## What Was Built

| File | Purpose | Lines |
|------|---------|-------|
| `modules/codi/module.yaml` | CODI manifest with Phase 171 live-contract description: 7-step contract (extract → per-symbol call → format → return → partial-success → dispatch log → classifier safety); 5 per-symbol outcome categories; 5 dispatch log formats; advisory-only classification preserved | 99 (+59/−9 vs Phase 170) |
| `modules/codi/references/codi.md` | Reference doc: Purpose, v0.1 Scope (live), Symbol Extraction Rules, `impact` Call Contract (per-symbol + all-or-nothing rationale + input-self-filter quirk), `impact` Response Format (line shape + empty + unresolved pattern), Blast Radius Format (with worked 3-input example), Call-Time Failure Handling (hook-level skip paths + partial-success invariant), Codegraph Tool Dependency, Deferred Roadmap, Source Plan Reference | 124 (rewritten from 41) |

**Installed artifacts regenerated** via `bash drivers/pi/install.sh` (no installer code changes):
- `~/.pi/agent/skills/pals/modules.yaml` — CODI block now carries the full Phase 171 description (block-scalar folded to one long line); priority 220 and refs unchanged; 20 modules total (same count as Phase 170).
- `~/.pi/agent/skills/pals/references/codi.md` — updated reference copied via manifest `files.references` wiring.

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|---|---|---|---|
| AC-1 | Manifest `hooks.pre-plan.description` encodes the complete Phase 171 contract (per-symbol loop, all-or-nothing rationale, 5 outcomes, partial-success invariant, `context_inject.blast_radius` return, success log with R/U/K counts, advisory-only, no "block" token, no legacy "hello, objective=" string, exactly one pre-plan hook at priority 220 with refs intact) | ✅ PASS | Task 1 verify: "OK: Task 1 AC-1 structural checks pass". All 21 substring assertions pass (positive and negative). Installed registry excerpt confirms all substrings present after block-scalar folding. |
| AC-2 | Reference doc has all required sections (Purpose, v0.1 Scope, Symbol Extraction Rules, impact Call Contract, impact Response Format, Blast Radius Format with worked example, Call-Time Failure Handling, Codegraph Tool Dependency forward-looking, Deferred Roadmap, Source Plan Reference), ≤150 lines, no "block" token | ✅ PASS | Task 2 verify: "OK: Task 2 AC-2 structural checks pass (124 lines)". All 20 positive substring and 1 negative "block" assertion pass. |
| AC-3 | Installer regenerates the registry with CODI's updated description; advisory classification preserved (no "block" token); priority 220 and refs intact; reference doc copied into installed tree with matching content | ✅ PASS | `[ok] CODI module installed`, `[ok] modules.yaml generated (20 modules)`. CODI block assertions: priority 220 ✓, refs ✓, impact ✓, behavior_change ✓, context_inject ✓, advisory ✓, NO block ✓, NO hello-world ✓, reference doc copied and first 10 lines diff-match source ✓. |
| AC-4 | `pi-end-to-end-validation.sh` reports 159/159 passing (baseline preserved from Phase 170); no other module's metadata altered | ✅ PASS | `# Passed: 159 / # Failed: 0 / # Total: 159 / # ALL CHECKS PASSED`. Exact parity with Phase 170 baseline. |

## Verification Results

```
=== Task 1 ===
OK: Task 1 AC-1 structural checks pass (authoritative parse validation runs in Task 3 via installer)

=== Task 2 ===
OK: Task 2 AC-2 structural checks pass (124 lines)

=== Task 3 (installer + registry + no-regression) ===
[ok] CODI module installed
[ok] modules.yaml generated (20 modules)
✓ CODI install log present
✓ registry generated log present
✓ codi: block present in installed registry
✓ priority: 220
✓ refs (references/codi.md)
✓ impact (content substring)
✓ behavior_change (content substring)
✓ context_inject (content substring)
✓ advisory (content substring, case-insensitive)
✓ no block token (negative assertion)
✓ no hello-world string (negative assertion)
✓ reference doc copied
✓ first 10 lines of reference doc match source

=== WALT post-apply quality gate ===
tests/pi-end-to-end-validation.sh: 159/159 passing (no regressions from Phase 170 baseline)
```

## Module Execution Reports

**PLAN phase:**
- `[dispatch] pre-plan advisory: TODD(p100)→skip (no source code) | IRIS(p150)→pass (no TODO/FIXME/HACK) | ARIA(p190)→skip (no UI files) | DAVE(p200)→skip (no CI) | DOCS(p200)→pass (reference doc update inline) | CODI(p220)→hello, objective=Phase 171 upgrades CODI from hello-world scaffolding to live impact integration (structurally correct — CODI still in hello-world mode at plan time) | RUBY(p250)→pass | ARCH(p75)→pass (self-contained module update) | LUKE/DANA/GABE/OMAR/PETE/REED/VERA→skip`
- `[dispatch] pre-plan enforcement: DEAN(p50)→skip (no dependency manifest) | SETH(p80)→pass | ARCH circular-dep→pass`
- `[dispatch] post-plan: TODD(p100)→skip (execute type, no tdd_candidates) | 0 other modules registered`

**APPLY phase:**
- `[dispatch] pre-apply: TODD(p50)→skip (no source code in plan scope) | WALT(p100)→BASELINE (pi-end-to-end-validation.sh: 159/159 recorded)`
- `[dispatch] post-task (Task 1/2/3): TODD(p100)→skip (no test scope) ×3`
- `[dispatch] post-apply advisory: IRIS(p250)→PASS | DOCS(p250)→PASS | LUKE(p160)→skip | OMAR(p170)→skip | RUBY(p300)→skip | SKIP(p300)→1 decision candidate (classifier-safety tightening — see Decisions below)`
- `[dispatch] post-apply enforcement: WALT(p100)→PASS (159/159, no regression) | ARCH(p75)→PASS | SETH(p80)→PASS | DEAN(p150)→skip | TODD(p200)→skip | ARIA/PETE/REED/VERA/GABE/DANA/DAVE→skip`

**UNIFY phase:**
- `[dispatch] pre-unify: 0 modules registered for this hook`
- `[dispatch] post-unify: RUBY(p300)→skip (no source code for complexity analysis) | SKIP(p300)→records Phase 171 decisions from this phase | WALT(p100)→records quality entry for 2026-04-16 (159/159 preserved)`

**Gate summary:** no blocks anywhere. No regressions. CODI live contract shipped as advisory-only per design.

## Deviations

- **Mid-plan empirical correction (tracked as high-collab win, not a failure).** During planning, probing the real `impact` tool revealed that the original "single batched call" assumption was materially wrong — batching is all-or-nothing on unresolved input, which would destroy partial results. The plan was revised BEFORE APPLY started: AC-1 updated (per-symbol loop, 5 outcomes, partial-success), AC-2 added `impact Response Format` section, Tasks 1–2 action specs updated, verify commands tightened with new substring checks, success log updated from `impact({N symbols}) → K call-sites` to `impact × N symbols → R resolved, U unresolved, K total call-sites`. Reference doc section count rose from 10 to 11. File growth: 347 → 371 lines. No APPLY cycles were wasted on the incorrect contract. This is exactly what high-collab direct-requirements planning is designed to catch.
- **Task 1 PASS_WITH_CONCERNS (in-loop rename).** Initial Task 1 attempt contained 5 natural-prose occurrences of the classifier-reserved halt-keyword ("Blast Radius block", "detail block", "sub-block", "fenced code block"), which violated the Phase 170 invariant that the manifest description must never contain that token in any casing. All 5 were renamed in-loop to "sub-section" / "code region" / "detail section" before Task 1 was marked PASS. Task 2's reference doc was written clean from the start using the same vocabulary. Phase 170's invariant applied only to intent-bearing text; Phase 171 tightened it to full natural prose on the module surface (see Key Patterns / Decisions).
- **`.pi/prompt-assembler/` out-of-scope runtime cache left untracked.** The Pi runtime creates a prompt-assembler cache directory during normal operation. It appeared as an untracked directory during APPLY preflight and was intentionally excluded from the commit. This is out-of-scope for Phase 171 but worth revisiting: adding `.pi/prompt-assembler/` to `.gitignore` would prevent the recurring noise in `git status`.
- **No material task-level deviations detected by the divergence check.** Plan `files_modified` (2 source files) exactly matches the diff. All 3 tasks PASS with exact scope match. The pre-existing `.paul/PROJECT.md` / `.paul/ROADMAP.md` deltas visible in `git diff 0a64311..HEAD` are from Phase 170's transition commit (`20a67f1`), not from this plan.

## Key Patterns / Decisions

- **Empirical probing during PLAN is a high-value practice when a tool's contract materially shapes the plan.** Phase 171's `impact` probing (3 calls with realistic, edge-case inputs) surfaced three assumption errors that would have caused silent data loss or incorrect skip logs in APPLY: (a) batched call failure mode, (b) plain-text response shape (not structured), (c) input-self-filter quirk. The cost was ~5 tool calls during PLAN; the benefit was zero wasted APPLY cycles and a more honest contract. Worth codifying as an informal pattern for future CODI-family phases that depend on under-documented runtime tools.
- **Classifier-safety discipline tightens at the module surface, not just the description.** Phase 170 established that the manifest description MUST NEVER contain the advisory-vs-enforcement halt-keyword in any casing. Phase 171 extends that to the **full module surface** (manifest description + reference doc natural prose), because any unintentional use in natural prose would still be a time bomb for future module edits that reference the classifier rule. Naming convention: "sub-section" and "code region" replace the common alternative across all CODI surfaces. Worth carrying into future module design as a first-party pattern.
- **"Per-symbol, not batched" is the correct call pattern for any codegraph tool that is all-or-nothing on unresolved input.** This is now likely to generalize to `symbol_graph` (v0.2) and `trace` (v0.3) when they ship, because they'll share the same tool semantics. Documenting early so future PALS module authors don't have to rediscover the batching failure mode.
- **Partial-success invariant decouples per-symbol outcomes from hook-level skip paths.** Phase 171's 5 per-symbol outcomes (resolved-with-call-sites / resolved-but-empty / unresolved / call-errored / tool-unavailable) map cleanly onto a 4-path hook-level skip set (tool-unavailable / no-extractable-symbols / catastrophic-loop-error / all-empty-none-unresolved). Keeping the two layers distinct is what makes the partial-success guarantee coherent. Reflected in both the manifest description (Step 5) and the reference doc (Scope distinction subsection).
- **Success log carries diagnostic granularity (R/U/K) rather than a single count.** This is what enables Phase 173's real-world trial to observe which outcome paths actually fire in practice — the raw success log is the observability surface.
- **Worked example in the reference doc is the critical artifact for contract clarity.** The Blast Radius Format section contains a 3-input worked example (one resolved-with-call-sites, one resolved-but-empty, one unresolved) that shows exactly what the injected markdown looks like. This example is more useful than any amount of prose specification for downstream agents trying to produce the correct output.

## Skill Audit (Phase 171)

| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Lifecycle flow covered PLAN → APPLY → UNIFY for the CODI live-contract upgrade, including a mid-plan correction driven by empirical probing |
| /carl | ✓ | Session-boundary routing remained active across planning (with probing), apply, and unify in a continuous session |
| TODD | ✓ | Pre-apply, post-task (×3), and post-apply dispatches all recorded skip decisions for this no-source-code scope — consulted and responded correctly, not silently skipped |
| WALT | ✓ | Pre-apply baseline recorded (159/159); post-apply enforcement ran `pi-end-to-end-validation.sh` and produced PASS (159/159, exact parity with Phase 170 baseline); quality history entry recorded during post-unify |

## Next Phase

**Phase 172: Plan-Phase Coupling & Distribution.** Scope from ROADMAP: add a lightweight optional symbol-enumeration tweak to `analyze_scope` so prose-heavy objectives still produce CODI targets; register CODI default-on in the `pals.json` schema with graceful skip when `pi-codegraph` or the codegraph index is absent; document setup UX. **No PLAN.md template changes** (those remain deferred to v0.4).

Phase 172 will test whether Phase 171's live contract actually produces useful blast-radius injections against prose-heavy objectives that don't already contain explicit symbols — effectively a plan-side ergonomic tweak that complements the hook-side contract shipped here.

After Phase 172, Phase 173 runs the real-world trial on 2–3 live PALS planning sessions and produces the ship-v0.2 / iterate / kill decision artifact that gates all v0.2+ work.
