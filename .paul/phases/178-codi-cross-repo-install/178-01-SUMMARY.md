---
phase: 178-codi-cross-repo-install
plan: 01
subsystem: modules
completed: 2026-04-18T20:46:11Z
duration: 35min
started: 2026-04-18T20:11:00Z
---

# Phase 178 Plan 01: CODI Cross-Repo Install (quark) Summary

**CODI is now enabled in quark, quark's codegraph was refreshed against current TS, and quark's CODI history file was seeded without writing any synthetic trial rows.**

## Objective

Install CODI in the quark repo as the v2.41 cross-repo trial bed without touching quark source or pals CODI source. The phase needed to enable `modules.codi` in `quark/pals.json`, refresh `quark/.codegraph/graph.db`, create `quark/.paul/CODI-HISTORY.md`, and capture a direct structural smoke test proving the refreshed graph resolves a current quark symbol.

## What Was Built

| File | Purpose | Lines / Evidence |
|------|---------|------------------|
| `/Users/maxwellnewman/claude/quark/pals.json` | Enable CODI in quark with the canonical two-field config block | `+4/-0` diff; file now 135 lines |
| `/Users/maxwellnewman/claude/quark/.codegraph/graph.db` | Refresh quark's codegraph so Phase 179 natural work resolves against current TS | 1,990,656 bytes; mtime `2026-04-18 16:34:43` |
| `/Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md` | Seed canonical CODI instrumentation target without synthetic rows | 7 lines, 331 bytes, 0 data rows |
| `.paul/PROJECT.md` | Record v2.41 / Phase 178 status in pals lifecycle artifacts | updated during APPLY |
| `.paul/ROADMAP.md` | Track v2.41 current milestone and Phase 178 progress | updated during APPLY |
| `.paul/STATE.md` | Track Phase 178 execution state, git state, and next action | updated during APPLY |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: CODI enabled in quark via `pals.json` | Pass | `modules.codi = { enabled: true, description: "Codegraph-driven structural injection (safe skip when codegraph is unavailable)" }`; total modules = 21 |
| AC-2: quark codegraph refreshed and `impact` resolves current TS | Pass | Local `pi-codegraph` Bun invocation reindexed quark and resolved `deriveTools` to `src/kernel/context.ts:40:506b  assembleContext  behavioral  depth:1` |
| AC-3: `quark/.paul/CODI-HISTORY.md` seeded with canonical header | Pass | Header matches Phase 176 contract exactly; file ends with trailing newline; zero data rows remain |
| AC-4: quark validation baseline unchanged and pals lifecycle artifacts reflect progress | Pass with concerns | pals validation remained green (`172/172`, `75/75`). quark regression check showed `949 passed | 1 failed | 1 skipped (951)`; the lone failure was external Anthropic API credit exhaustion in `test/e2e/hello.test.ts`, not a Phase 178 code/config regression |

## Verification Results

### Task 1 — quark CODI enablement

```text
PASS: modules.codi added; total modules now 21
```

Exact diff:

```diff
@@ -16,6 +16,10 @@
       "continue_threshold": 0.4,
       "safety_ceiling": 0.5
     },
+    "codi": {
+      "enabled": true,
+      "description": "Codegraph-driven structural injection (safe skip when codegraph is unavailable)"
+    },
     "dana": {
       "enabled": true,
       "description": "Data pattern & migration safety"
```

### Task 2 — direct codegraph smoke test

```text
{"indexed":35,"skipped":153,"removed":0,"errors":0,"timings":{"tree-sitter":1256,"lsp":2673,"ast-grep":79,"coverage":0,"git":402}}
---IMPACT---
## Trust
status: fresh
evidence: ast-grep,git,lsp,tree-sitter  stale-files: 0/188
src/kernel/context.ts:40:506b  assembleContext  behavioral  depth:1  [fan-in:0, fan-out:3, roles:entry-point, coverage:untested, co-change:0.00, chain-confidence:0.90]
```

Minimum file check:

```text
PASS: codegraph exists
-rw-r--r--@ 1 maxwellnewman  staff  1990656 Apr 18 16:34 /Users/maxwellnewman/claude/quark/.codegraph/graph.db
```

### Task 3 — quark CODI history bootstrap

```text
PASS: header present; 0 data rows
       7 /Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md
     331 /Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md
```

### Task 4 — validation surfaces

pals validation:

```text
pi-end-to-end-validation.sh: 172/172 passed
cross-harness-validation.sh: 75/75 passed
```

quark regression check:

```text
Test Files  1 failed | 56 passed | 1 skipped (58)
Tests  1 failed | 949 passed | 1 skipped (951)
```

Failure detail:

```text
FAIL  test/e2e/hello.test.ts > hello world e2e > runs a full kernel loop with real LLM call and tool round-trip
Error: 400 ... "Your credit balance is too low to access the Anthropic API."
```

## Module Execution Reports
### Dispatch Summary
- `[dispatch] pre-unify: 0 modules registered for this hook`
- `[dispatch] post-unify: WALT (p100) → 1 report / 1 side effect | SKIP (p200) → 2 reports / 0 side effects | CODI (p220) → skip (phase boundary) | RUBY (p300) → skip (no in-repo code files changed)`

### WALT — Quality History
| Metric | Before | After | Delta | Trajectory |
|--------|--------|-------|-------|------------|
| Tests | 172 pass + 75 pass | 172 pass + 75 pass | 0 | → stable |
| Coverage | — | — | — | — |
| Lint | — | — | — | — |
| Types | — | — | — | — |

**Overall:** → stable

**Side effect recorded:** appended `178-01 | 2026-04-18 | 172 pass + 75 pass | — | — | — | → stable` to `.paul/QUALITY-HISTORY.md`.

### CODI — Instrumentation
- Pre-plan CODI outcome for `178-01` was `skipped-no-symbols` by design because this setup phase carried no repo-relative TS/JS `<context>` scope.
- Post-unify CODI persistence was **intentionally skipped in pals** for this phase to respect the v2.41 boundary that keeps `pals/.paul/CODI-HISTORY.md` read-only while quark is the actual trial host.
- Result: `quark/.paul/CODI-HISTORY.md` remains seeded with the canonical header and **0 rows** at Phase 178 exit. The first organic row must come from Phase 179's first natural quark UNIFY.

### SKIP — Knowledge Capture
#### 2026-04-18 Open v2.41 cross-repo trial on quark
**Type:** decision
**Phase:** 178-codi-cross-repo-install
**Related:** `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/phases/178-codi-cross-repo-install/178-01-{PLAN,SUMMARY}.md`, `/Users/maxwellnewman/claude/quark/pals.json`

**Context:** pals cannot provide honest TS-heavy Signal 1/2 evidence for CODI because the repo is markdown-dominated. Phase 178 needed a real trial host where CODI could observe natural implementation work without changing CODI itself.

**Decision:** Use quark as the v2.41 trial host, enable CODI there, refresh quark's codegraph, and keep pals CODI source frozen for the duration of the milestone.

**Alternatives considered:**
- Continue trialing inside pals — rejected because it cannot generate the missing natural-scope TS evidence.
- Pick a different repo — rejected because quark already has PALS history, TS density, and the shared installed registry.

**Rationale:** quark provides the missing structural conditions while preserving parity-by-construction through the shared installed registry.

**Impact:** Phase 179 can now collect natural CODI rows without changing CODI behavior mid-trial.

#### 2026-04-18 Phase 179 is strictly observational
**Type:** decision
**Phase:** 178-codi-cross-repo-install
**Related:** `.paul/STATE.md`, `.paul/ROADMAP.md`, `/Users/maxwellnewman/claude/quark/.paul/CODI-HISTORY.md`

**Context:** Session C in Phase 177 showed how controlled self-trials can overstate CODI value. Phase 178 needed to preserve trial honesty while still preparing the instrument.

**Decision:** Keep Phase 179 strictly observational: no controlled self-trials, no synthetic CODI rows, and no tuning quark plan scope to feed CODI nicer symbols.

**Alternatives considered:**
- Seed a CODI row during setup — rejected because it would be synthetic evidence.
- Tune Phase 179 scope around CODI output — rejected because it would bias the trial.

**Rationale:** observational-only collection is the cleanest way to answer Q2 without self-fulfilling evidence.

**Impact:** the next meaningful signal comes only from natural quark work landing under CODI.

### RUBY — Debt Analysis
Skipped. This phase changed only lifecycle artifacts in pals plus bounded setup files in quark (`pals.json`, `.codegraph/graph.db`, `.paul/CODI-HISTORY.md`). No in-repo code-file diff justified complexity or refactor analysis.

### Skill Audit
| Expected | Invoked | Notes |
|----------|---------|-------|
| /paul | ✓ | Full PLAN → APPLY → UNIFY loop executed for Phase 178 |
| /carl | ✓ | Session-boundary behavior remained active during the phase |
| TODD | n/a | Setup phase; no implementation/test-first surface |
| WALT | ✓ | Validation ran in APPLY and quality history was recorded in UNIFY |

## Deviations

| Type | Count | Impact |
|------|-------|--------|
| Command adjustment | 2 | Verification remained valid, but the exact shell forms in the plan were not the working forms in this environment |
| Environment concern | 1 | quark's test suite was not fully green because of external Anthropic billing state, not because Phase 178 introduced a regression |
| Lifecycle timing correction | 1 | APPLY kept Phase 178 accurately in `UNIFY pending` state; phase-complete wording was deferred to UNIFY rather than claimed early |

**Total impact:** Bounded and documented. The core setup objective succeeded without scope creep or source-code edits in quark.

### Details

1. **Impact verification used direct local `pi-codegraph` execution.**
- **Planned:** current agent `impact()` / pi-triggered refresh
- **Actual:** the in-session `impact()` surface returned `Symbol "deriveTools" not found`, so a local Bun invocation of `pi-codegraph` reindexed quark and verified the symbol directly
- **Why:** current extension/runtime graph state for quark was stale or absent in this session
- **Impact:** verification evidence is stronger, because the summary includes the fresh index result verbatim

2. **quark vitest command required an explicit quark cwd.**
- **Planned:** `cd /Users/maxwellnewman/claude/quark && npx vitest run --reporter=dot`
- **Actual:** `node node_modules/vitest/vitest.mjs run --reporter=dot` was executed under `env -C /Users/maxwellnewman/claude/quark`
- **Why:** shell command dispatch kept resolving to the parent repo without an explicit process-level cwd handoff
- **Impact:** the verification still exercised the correct quark suite and produced a trustworthy result

3. **quark suite showed one external-failure test.**
- **Issue:** `test/e2e/hello.test.ts` failed because Anthropic credits were exhausted
- **Impact:** AC-4 is recorded as pass-with-concerns rather than a clean pass
- **Assessment:** no evidence links the failure to the Phase 178 config/codegraph/history changes

## Key Patterns / Decisions

| Decision | Rationale | Impact |
|----------|-----------|--------|
| Use quark as the v2.41 CODI trial bed while keeping pals CODI source frozen | pals cannot produce honest TS-heavy Signal 1/2 evidence; quark can | preserves trial integrity and causal independence for Phase 179 |
| Seed `quark/.paul/CODI-HISTORY.md` with header only | first organic row must come from a natural quark UNIFY, not this setup phase | prevents synthetic evidence from polluting the trial set |
| Treat external test-environment failures separately from regression evidence | the observed quark failure was Anthropic billing-related, not introduced by this phase | keeps the trial honest without overstating validation confidence |

## Issues Encountered

| Issue | Resolution |
|-------|------------|
| In-session `impact()` lookup did not resolve `deriveTools` | Reindexed quark with local `pi-codegraph` execution and captured the fresh output verbatim |
| Quark vitest invocation initially ran against the wrong cwd | Re-ran vitest with explicit quark cwd via `env -C` |
| Quark e2e test hit Anthropic credit exhaustion | Recorded as external environment concern; did not attempt to change quark source or test configuration |

## Next Phase

Phase 178 leaves quark ready for natural CODI observation. The next real work is not more setup: it is the user's pre-authored quark patches landing as one or more natural quark PALS phases under CODI. `quark/.paul/CODI-HISTORY.md` must remain at zero rows until the first such natural quark UNIFY writes line 8.

## Next Phase Readiness

**Ready:**
- quark now has `modules.codi` enabled with the canonical config block
- quark's codegraph resolves current TS symbols
- quark's CODI history file is bootstrapped and empty
- pals lifecycle artifacts and PR flow reflect v2.41 in progress

**Concerns:**
- quark's `test/e2e/hello.test.ts` currently depends on external Anthropic billing state
- current session-level `impact()` surface was not sufficient for verification without a local reindex pass

**Blockers:**
- None for Phase 179 trial collection itself
- Merge gate / PR completion still governs when this PALS phase is fully closed on `main`

---
*Phase: 178-codi-cross-repo-install, Plan: 01*
*Completed: 2026-04-18*
