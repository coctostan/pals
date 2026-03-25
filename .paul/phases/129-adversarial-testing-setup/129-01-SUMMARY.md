---
phase: 129-adversarial-testing-setup
plan: 01
type: execute
completed: 2026-03-25
duration: ~3 hours
---

# Phase 129 Plan 01: Adversarial Testing Setup Summary

**Ran 2 adversarial PAUL loops on pi-verify — one with kimi-coder (K2.5), one with sonnet-4-6 — assessing PALS at three levels: workflow compliance, module dispatch, and module output quality.**

## What Was Built

| Artifact | Purpose | Location |
|----------|---------|----------|
| adversarial-results.md | Three-level comparison: Kimi vs Sonnet | .paul/phases/129-adversarial-testing-setup/ |
| kimi-evidence/ | PLAN, SUMMARY, STATE from kimi loop | .paul/phases/129-adversarial-testing-setup/kimi-evidence/ |
| sonnet-evidence/ | PLAN, SUMMARY, STATE, quality-history from sonnet loop | .paul/phases/129-adversarial-testing-setup/sonnet-evidence/ |

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Kimi loop completes full PAUL cycle | ✅ PASS | Full PLAN→APPLY→UNIFY loop completed; artifacts preserved |
| AC-2 | Sonnet loop completes full PAUL cycle | ✅ PASS | Full loop + GitHub Flow (branch, PR #10, merge) |
| AC-3 | Three-level assessment documented | ✅ PASS | adversarial-results.md with per-model scores and grep evidence |

## Verification Results

### Post-hoc artifact analysis
- Kimi: `[dispatch]` markers found in PLAN.md (11 pre-plan entries) — all theoretical
- Sonnet: `[dispatch]` markers in PLAN + real tool execution (pnpm audit, pnpm test, grep) — actual findings with file:line references
- Both loops produced properly structured PLAN.md and SUMMARY.md artifacts

## Module Execution Reports

### Dispatch Evidence Summary

| Hook Point | Kimi | Sonnet |
|-----------|------|--------|
| pre-plan advisory (11 modules) | Documented, not executed | Executed with real tools |
| pre-plan enforcement (DEAN) | Theoretical | **BLOCKED with 2 CVEs** |
| post-plan (TODD) | Not evident | Suggested TDD, correctly overridden |
| pre-apply (TODD/WALT) | Not evident | Baselines recorded |
| post-task (TODD) | Not evident | `pnpm test` after each task |
| post-apply advisory (11 modules) | Listed as "Pending" | **All fired: IRIS, OMAR, GABE, LUKE, ARIA, PETE, DANA, REED, DOCS, RUBY, SKIP** |
| post-apply enforcement (WALT, DEAN, TODD) | Listed as "Pending" | **WALT: 67/67 ✓, DEAN: Δ=0, TODD: gap flagged** |
| post-unify (WALT, SKIP, RUBY) | Not evident | **WALT: quality-history.md, SKIP: decisions, RUBY: debt check** |

[dispatch] post-unify: WALT(100) → skip (no pals source changes) | SKIP(200) → 1 decision captured | RUBY(300) → skip

### SKIP Knowledge Capture

#### 2026-03-25: Module dispatch is model-dependent
Type: decision
Phase: 129
Context: Adversarial testing revealed that kimi-coder documents module instructions as expectations while sonnet-4-6 executes them as shell commands
Decision: Model quality determines module value — modules produce real findings with capable models, documentation-only with weaker ones
Alternatives considered: None — this is an empirical observation, not a design choice
Rationale: Sonnet ran pnpm audit, pnpm test, grep for patterns; kimi described what should happen
Impact: Future PALS documentation should note that module quality is model-dependent; weaker models may need more explicit "run this command" instructions

## Deviations

| Deviation | Impact | Resolution |
|-----------|--------|------------|
| Kimi consumed MILESTONE-CONTEXT.md during v1.0 completion, not v1.1 creation | Minor — had to recreate context file | Recreated MILESTONE-CONTEXT.md between loops |
| Sonnet also consumed MILESTONE-CONTEXT.md during v1.0 completion | Same pattern as kimi | Same fix |
| Kimi skipped GitHub Flow entirely | Significant — no branch/PR/merge | Documented as L1 failure |
| Kimi ran on main, not feature branch | Cleanup required between loops | Reset pi-verify state manually |
| pi-verify's origin/main diverged from local (different repo state in cmux) | Kimi loop ran against wrong repo initially | Fixed by creating workspace with correct directory |

## Key Findings

1. **Sonnet 4.6 achieves near-perfect PALS execution** — 100% workflow, 100% dispatch, 94% module quality. Modules produce actionable findings with specific file:line references.

2. **Kimi K2.5 follows workflow structure but treats modules as documentation** — 71% workflow (missed GitHub Flow + migration), 12% dispatch (markers only), 0% actual module execution.

3. **DEAN blocking is the star differentiator** — Sonnet's DEAN ran `pnpm audit --json`, found 2 critical CVEs, and blocked plan creation. This is exactly the kind of value that justifies the module system.

4. **GitHub Flow compliance is model-dependent** — Kimi ignored it entirely; Sonnet created branches, pushed, created PRs, and ran merge gates.

5. **pals.json auto-migration works** — Sonnet detected schema_version mismatch and migrated from 8 to 18 modules. Kimi did not.

## Lessons Learned

1. **Module instructions may need to be more imperative for weaker models.** Kimi understood the structure but didn't execute the commands described in modules.yaml hook descriptions. More explicit "MUST run: `pnpm audit --json`" phrasing might help.

2. **cmux workspace creation doesn't control pi's working directory.** Pi opens in its own workspace. The cd must happen in the shell before pi starts.

3. **Both models handle the PAUL lifecycle competently.** The workflow structure (PLAN→APPLY→UNIFY) is robust. The gap is in execution depth.

## Deferred Issues

- Module instruction wording audit — could more imperative phrasing help weaker models?
- Phase 130 (real-user feature dev) will test whether sonnet-quality module output helps during genuine development
- Phase 131 (greenfield) will test whether modules add value on a new project

---

*Summary created: 2026-03-25*
