# Greenfield Project Results — Phase 131

**Date:** 2026-03-25
**Model:** openai-codex/gpt-5.4 (medium thinking)
**Project:** pi-bench — Pi extension for LLM benchmarking within Pi
**Loops:** 2 (v0.1 Bench Command MVP, v0.2 History & Formatting)

---

## Init/Onboarding Audit

### Question Count: Too Many

The greenfield init flow asked **9+ questions** before creating artifacts:

| # | Question | Necessary? | Notes |
|---|----------|-----------|-------|
| 1 | Map codebase? | ⚠️ | Detected "brownfield" on empty scaffold — overkill |
| 2 | Exploratory vs direct-requirements? | ✅ | Good |
| 3 | Collaboration level? | ✅ | Good |
| 4 | What are you building? | ✅ | Core question |
| 5 | Primary users? | ✅ | Good |
| 6 | Problem/opportunity? | ✅ | Good |
| 7 | Must-have / deferred? | ✅ | Good |
| 8 | Constraints/dependencies? | ✅ | Good |
| 9 | Project name confirm? | ✅ | Quick |
| 10 | SonarQube? | ❌ | Irrelevant for greenfield — should default to "no" |
| 11 | Specialized skills? | ❌ | New user won't know what this means |
| 12 | Module toggle? | ⚠️ | Reasonable but new user won't know modules |
| 13 | GitHub repo? | ✅ | Necessary |
| 14 | Git workflow? | ✅ | Necessary |
| 15 | Worktrees? | ❌ | Advanced feature, irrelevant for most greenfield |
| 16 | Auto-create PR? | ❌ | We chose "no GitHub repo" — this question is contradictory |
| 17 | Wait for CI? | ❌ | Same — irrelevant without remote |

**Verdict: 7 unnecessary questions.** Questions 10, 11, 15, 16, 17 should be skipped for greenfield. Question 1 (brownfield detection) should have a smarter threshold (empty src/ = greenfield, not brownfield). Question 12 should default silently.

### Specific Gaps

1. **Brownfield misdetection:** Empty `src/` and `test/` dirs triggered brownfield detection. An empty scaffold is greenfield. The heuristic should check for actual source files, not just directory existence.

2. **Git automation questions after "no GitHub":** Asking about auto-PR and CI checks after the user chose "no GitHub repo / local only" is contradictory. These should be auto-skipped.

3. **SonarQube question for new project:** No new project needs SonarQube. This should only appear during brownfield onboarding or as a `/paul:config` option later.

4. **"Specialized skills" question is jargon:** A new PALS user has no idea what this means. Should be omitted from init and documented elsewhere.

5. **No milestone created during init:** GPT-5.4 went from init → plan without explicitly creating a milestone via /paul:milestone. The init flow set "v0.1 Initial Release" in STATE.md but the milestone workflow wasn't formally invoked. This is ambiguous — did init create it, or did the model infer it?

6. **No pals.json migration needed** (fresh project) — but the model still checked, which is correct.

### What Worked Well

- One-question-at-a-time flow is good
- Project description gathering (questions 4-8) is excellent
- Correct detection of git repo and gh availability
- All .paul/ artifacts created properly (PROJECT.md, PRD.md, ROADMAP.md, STATE.md)
- 18 modules enabled by default
- pals.json created with correct structure

---

## Loop Results

### Loop 1: v0.1 Bench Command MVP

| Criteria | Result |
|----------|--------|
| PLAN.md created | ✅ Well-structured with frontmatter, AC, tasks |
| Module dispatch in plan | ✅ 8 modules logged (ARCH, TODD, IRIS, DAVE, DOCS, RUBY, DEAN, SETH) |
| APPLY executed | ✅ src/index.ts created with /bench command |
| Tests added | ✅ test/bench.test.ts (tests pass) |
| SUMMARY.md written | ✅ |
| TypeScript compiles | ✅ |
| Pi API research | ✅ Used grep + code_search to find real Pi APIs |

### Loop 2: v0.2 History & Formatting

| Criteria | Result |
|----------|--------|
| Milestone created | ✅ v0.2 Benchmark History & Presentation |
| PLAN.md created | ✅ |
| Module dispatch | ✅ ARCH, TODD, IRIS, DAVE, DOCS, RUBY, DEAN, SETH all logged |
| APPLY executed | ✅ History persistence + /bench history command |
| Tests expanded | ✅ 12 total (up from initial) |
| SUMMARY.md written | ✅ |
| CARL fired | ✅ Phase boundary detection at 65%, created fresh session |

### Module Behavior on Greenfield

| Module | Greenfield Value |
|--------|-----------------|
| TODD | ✅ Detected test directory, noted "tdd candidate present" — shaped test coverage |
| DEAN | ⚠️ "Skip, no lockfile/audit baseline available" — correct but no value on zero-dep project |
| SETH | ✅ "No hardcoded secret findings, no block" — correct, quick pass |
| ARCH | ✅ "Flat TypeScript structure still appropriate" — useful architecture guidance |
| DOCS | ✅ "README exists but minimal; update recommended" — correctly flagged |
| RUBY | ✅ "Watch src/index.ts size as logic is added" — proactive debt warning |
| IRIS | ✅ "No existing anti-patterns" — clean baseline |
| DAVE | ✅ "No CI config detected; advisory only, CI deferred" — correct |

**Verdict:** Modules are useful even on greenfield. DEAN has nothing to audit (no deps), but others provide useful baseline guidance.

---

## L1/L2/L3 Assessment — GPT-5.4 Greenfield

### L1 — Workflow Compliance (Greenfield)

| Criteria | Result |
|----------|--------|
| Read SKILL.md | ✅ |
| Read modules.yaml | ✅ (inferred from dispatch markers) |
| PLAN.md proper structure | ✅ Both plans have frontmatter, AC, tasks |
| APPLY execution | ✅ Code created, tests pass, TypeScript compiles |
| SUMMARY.md written | ✅ Both summaries with Module Execution Reports |
| STATE.md updated | ✅ All transitions tracked |
| PROJECT.md populated | ✅ 65 lines with real content |
| PRD.md populated | ✅ 68 lines |
| pals.json created | ✅ schema_version 2.0.0, 18 modules |
| Git commits at transitions | ✅ 2 phase commits + scaffold |
| GitHub Flow | N/A — chose "legacy / direct-to-main" (correct for local-only) |
| Milestone creation | ⚠️ Implicit during init, not via /paul:milestone |
| CARL session management | ✅ Fired at 65% context, created fresh session |

**L1 Score: ~92% (12/13)** — Only gap is implicit milestone creation.

### L2 — Module Dispatch

| Hook Point | Loop 1 | Loop 2 |
|-----------|--------|--------|
| pre-plan advisory (ARCH, TODD, IRIS, DAVE, DOCS, RUBY) | ✅ All 6 logged | ✅ All 6 logged |
| pre-plan enforcement (DEAN, SETH) | ✅ DEAN skip (no deps), SETH no block | ✅ DEAN no block, SETH no block |
| post-apply | Not evident in PLAN/SUMMARY | Not evident |
| post-unify (WALT, SKIP, RUBY) | ✅ **All 3 fired with real output** | ✅ **All 3 fired with real output** |

**Key finding:** GPT-5.4 on greenfield runs pre-plan dispatch AND post-unify dispatch (WALT, SKIP, RUBY all fired). Post-apply advisory/enforcement is the gap — same as Phase 130 brownfield behavior.

**L2 Score: ~75% (6/8 hook points)** — pre-plan + post-unify strong, post-apply missing.

### L3 — Module Output Quality

| Module | Output | Value |
|--------|--------|-------|
| WALT | quality-history.md: 8/8→12/12, lint clean, typecheck clean, ↑ improving | ✅ Real tracking |
| SKIP | Decisions captured: package-level defaults, direct ctx.modelRegistry path, markdown output | ✅ Real knowledge |
| RUBY | "Watch src/index.ts size" + "extract history/storage/report helpers" | ✅ Actionable debt warning |
| ARCH | "Flat TypeScript structure appropriate" | ✅ Useful baseline |
| TODD | "tdd candidate present, test/ exists" | ✅ Shaped coverage |
| DOCS | "README minimal; update recommended" | ✅ Correct flag |
| DEAN | "Skip, no lockfile" | ⚠️ Correct but no value |
| SETH | "No hardcoded secrets" | ✅ Quick pass |
| IRIS | "No anti-patterns" | ✅ Clean baseline |
| DAVE | "No CI detected, deferred" | ✅ Correct |

**L3 Score: ~80% (8/10 modules produced useful output)**

### GPT-5.4 Greenfield vs Brownfield Comparison

| Dimension | Brownfield (Phase 130) | Greenfield (Phase 131) |
|-----------|----------------------|------------------------|
| L1 Workflow | ~86% | ~92% |
| L2 Dispatch | ~70% | ~75% |
| L3 Quality | ~65% | ~80% |
| Post-unify hooks | Not evident | ✅ WALT + SKIP + RUBY all fired |
| CARL | Not observed | ✅ Fired at phase boundary |
| GitHub Flow | ⚠️ Partial (branch yes, merge gate no) | N/A (correct — local only) |
| DEAN | ✅ Ran pnpm audit | ⚠️ Skip (no deps) |

**Verdict:** GPT-5.4 performs BETTER on greenfield than brownfield. The simpler context (no existing bait/cleanup baggage) let it focus on clean execution. Post-unify hooks fired on greenfield but not brownfield — possibly because the greenfield session was fresher.

---

## Recommendations for v2.26+ Init/Onboarding

### High Priority

1. **Smart question gating:** Skip SonarQube, skills, worktrees, and git automation questions based on context:
   - No GitHub repo → skip all remote-related questions
   - Greenfield → skip SonarQube and specialized skills
   - Default worktrees to "no" unless explicitly enabled

2. **Brownfield detection threshold:** Check for actual source files (`find src -name '*.ts' -o -name '*.js' | head -1`), not just directory existence. Empty scaffold = greenfield.

3. **Reduce to ~8 questions for greenfield:** Description (4-8), name confirm, GitHub yes/no, git workflow, collaboration level. Everything else should have smart defaults.

### Medium Priority

4. **Init should explicitly create the first milestone** rather than implicitly setting it in STATE.md. The model merged init+milestone which works but is ambiguous.

5. **Module explanations during init:** Brief one-liner for each module category (e.g., "TODD enforces test coverage, WALT gates quality") so new users understand what they're enabling.

6. **Git automation questions should be conditional:** Only ask about PRs/CI after choosing GitHub Flow or feature branches with a remote.

### Low Priority

7. **"Specialized skills" should be removed from init** and moved to a post-init discovery mechanism.

8. **Add a "quick start" mode:** `/paul:init --quick` that accepts all defaults and only asks for project description.

---

## Evidence References

- Phase 1 PLAN: `gpt54-greenfield/01-01-PLAN.md`
- Phase 1 SUMMARY: `gpt54-greenfield/01-01-SUMMARY.md`
- Phase 2 PLAN: `gpt54-greenfield/02-01-PLAN.md`
- Phase 2 SUMMARY: `gpt54-greenfield/02-01-SUMMARY.md`
- pi-bench: 12 tests passing, 2 source files, /bench + /bench history commands

---

*Analysis completed: 2026-03-25*
