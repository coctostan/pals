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
