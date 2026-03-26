# v2.25 E2E Adversarial Testing — Actionable Items

**Generated:** 2026-03-25
**Source:** Phase 129 (adversarial), Phase 130 (real dev), Phase 131 (greenfield)
**Purpose:** Consolidated findings from 3 models (Kimi K2.5, GPT-5.4, Sonnet 4.6) across adversarial, brownfield, and greenfield testing. These items drive the next 2-3 milestones.

---

## Cross-Model Performance Summary

|              | L1 Workflow | L2 Dispatch | L3 Quality |
|--------------|-------------|-------------|------------|
| Kimi K2.5 (adversarial) | 71% (10/14) | 12% (1/8) | 0% (0/16) |
| GPT-5.4 brownfield | 86% | 70% | 65% |
| GPT-5.4 greenfield | 92% | 75% | 80% |
| Sonnet 4.6 (adversarial) | 100% (14/14) | 100% (8/8) | 94% (15/16) |

**Key insight:** GPT-5.4 performs better on greenfield than brownfield (92/75/80 vs 86/70/65). Post-unify hooks fired on greenfield but not brownfield — possibly fresher context.

---

## Item 1: Module Instruction Wording Audit

**Source:** Phase 129 — Kimi K2.5 documented dispatch but never executed it
**Problem:** modules.yaml hook descriptions use descriptive language ("scan files for patterns, inject context") that weaker models interpret as documentation rather than executable instructions. Kimi wrote `[dispatch] pre-plan advisory: SETH(p80) → inject sec_warnings | hardcoded secrets expected` without ever running grep or any tool.
**Evidence:** Kimi PLAN.md has 11 dispatch markers, all theoretical. Zero shell commands executed for module hooks. Sonnet read the same descriptions and ran `pnpm audit --json`, `grep -n`, `pnpm test`.
**Fix:** Audit all 18 module hook descriptions in modules.yaml. Rewrite descriptive language to imperative:
- Before: "Scan files_modified for security-sensitive patterns. Inject sec_warnings with finding counts."
- After: "MUST run: `grep -rn 'AKIA\\|BEGIN.*PRIVATE KEY\\|api[_-]\\?key.*=' {files_modified}`. Report each match with file:line. Inject sec_warnings with counts."
**Risk:** Over-prescriptive instructions may conflict with models that already interpret them correctly (sonnet). Need to balance imperative clarity with flexibility.
**Priority:** High — affects whether modules produce any value on non-frontier models
**Milestone candidate:** v2.27 Module Dispatch Hardening

---

## Item 2: Post-Apply Dispatch Enforcement

**Source:** Phase 129 (kimi), Phase 130 (GPT-5.4 brownfield)
**Problem:** Post-apply hooks (advisory: IRIS, DOCS, RUBY, SKIP; enforcement: WALT, DEAN, TODD) are the highest-value dispatch point — they check the actual code that was just written. But only Sonnet consistently runs them. Kimi listed all as "Pending" and never executed. GPT-5.4 ran WALT/DEAN on brownfield but skipped most advisory modules.
**Evidence:**
- Kimi: Module Execution Reports table has "Pending" for all 11 post-apply modules
- GPT-5.4 brownfield: WALT + DEAN fired, advisory modules not evident
- GPT-5.4 greenfield: Post-apply not evident, but post-unify fired
- Sonnet: All 14 modules fired with file:line output
**Fix:** The apply-phase.md workflow has two steps: `advisory_module_dispatch` and `enforcement_module_dispatch`. These may need:
1. Stronger structural separation (separate `<step>` blocks with explicit "STOP and execute these commands")
2. A dispatch checkpoint that blocks UNIFY if no dispatch evidence is recorded
3. A "dispatch audit" in unify-phase that warns if Module Execution Reports is empty
**Risk:** Adding blocking checks could slow down capable models that already dispatch correctly
**Priority:** High — post-apply is where modules catch real issues
**Milestone candidate:** v2.27 Module Dispatch Hardening

---

## Item 3: DEAN "Remember Baseline" Mechanism

**Source:** Phase 130 — DEAN blocked every single plan with the same pre-existing vulnerabilities
**Problem:** pi-verify has 2 critical + 16 high vulnerabilities in its dependency tree (basic-ftp, fast-xml-parser CVEs). These are pre-existing and not introduced by any PALS plan. But DEAN blocks plan creation every time, requiring manual "override" input. Across 2 loops, the user had to override DEAN 3 times for the same baseline.
**Evidence:**
- Phase 130 Loop 1 (cleanup): DEAN BLOCK → override
- Phase 130 Loop 2 (feature): DEAN BLOCK → override
- GPT-5.4 correctly identified "pre-existing, not introduced by this plan" each time
**Fix:** Add a "baseline acknowledged" mechanism:
1. After first DEAN override, record the baseline severity counts in pals.json or .paul/dean-baseline.json
2. On subsequent plans, compare current audit against the acknowledged baseline
3. Only BLOCK if NEW critical/high vulnerabilities are detected (delta > 0)
4. Re-trigger full block if baseline file is older than N days (configurable)
5. Clear baseline on milestone boundary or explicit user action
**Risk:** Could mask genuinely new vulnerabilities if baseline is stale
**Priority:** Medium — friction-heavy but correct behavior; override works as escape hatch
**Milestone candidate:** v2.28 DEAN Baseline Management (or fold into v2.27)

---

## Item 4: Post-Unify Hook Enforcement

**Source:** Phase 129 (kimi), Phase 130 (GPT-5.4 brownfield), Phase 131 (GPT-5.4 greenfield)
**Problem:** Post-unify hooks (WALT quality-history, SKIP knowledge capture, RUBY debt analysis) are the persistence layer — they record what happened for future reference. Kimi never runs them. GPT-5.4 skips them on brownfield but runs them on greenfield.
**Evidence:**
- Kimi: No post-unify evidence in any artifacts
- GPT-5.4 brownfield (Phase 130): No quality-history.md, no SKIP captures, no RUBY analysis
- GPT-5.4 greenfield (Phase 131): WALT created quality-history.md (8/8→12/12), SKIP captured 3 decisions, RUBY flagged src/index.ts growth
- Sonnet: WALT appended quality-history.md, SKIP captured DEAN override decision, RUBY ran debt check
**Fix:**
1. unify-phase.md `post_unify_hooks` step needs stronger structural enforcement
2. Consider making quality-history.md creation a REQUIRED artifact of UNIFY (not just a module hook)
3. Add a "post-unify dispatch check" that warns if zero modules fired
**Risk:** Over-enforcement on simple/cleanup phases where post-unify has nothing to report
**Priority:** Medium — persistence is important but not blocking
**Milestone candidate:** v2.27 Module Dispatch Hardening

---

## Item 5: GitHub Flow Merge Gate Hardening

**Source:** Phase 129 (kimi), Phase 130 (GPT-5.4)
**Problem:** The GitHub Flow merge gate in unify-phase.md is the most complex workflow step (6 gates: PR exists, CI passing, reviews approved, PR merged, base synced, branch cleanup). Only Sonnet executes it. GPT-5.4 explicitly noted "I did not attempt the merge gate." Kimi ignored GitHub Flow entirely.
**Evidence:**
- Kimi: Stayed on main, no branch, no PR, no merge gate
- GPT-5.4: Created feature branch, but explicitly skipped merge gate ("I did not attempt the GitHub-flow merge gate or phase commit automation here")
- GPT-5.4 Phase 16: Reused Phase 15's branch instead of creating a new one
- Sonnet: Full lifecycle — branch, push, PR #10, merge, cleanup
**Fix:**
1. The merge gate is in a single massive `<step>` block. Consider breaking into smaller, individually addressable steps
2. Add a pre-UNIFY check: "If pals.json git.workflow = github-flow AND you are on a feature branch, you MUST execute the merge gate before closing the loop"
3. Consider a "merge gate reminder" in the UNIFY output that models can't skip past
**Risk:** Breaking the merge gate into smaller steps might make sonnet less efficient
**Priority:** Medium — only matters for github-flow projects
**Milestone candidate:** v2.27 Module Dispatch Hardening (or separate v2.29)

---

## Item 6: Smart Question Gating in Init

**Source:** Phase 131 — GPT-5.4 greenfield init asked 17 questions, 7 unnecessary
**Problem:** The init-project.md workflow asks every question regardless of context. A greenfield project with no GitHub repo was asked about SonarQube, specialized skills, worktrees, auto-PR creation, and CI checks — all irrelevant.
**Evidence:** Full question log from Phase 131:
1. Map codebase? (brownfield misdetection)
2. Exploratory vs direct? ✅
3. Collaboration level? ✅
4. What are you building? ✅
5. Primary users? ✅
6. Problem/opportunity? ✅
7. Must-have/deferred? ✅
8. Constraints? ✅
9. Project name confirm? ✅
10. SonarQube? ❌ (irrelevant for greenfield)
11. Specialized skills? ❌ (jargon)
12. Module toggle? ⚠️ (no explanations)
13. GitHub repo? ✅
14. Git workflow? ✅
15. Worktrees? ❌ (advanced)
16. Auto-create PR? ❌ (chose "no GitHub")
17. Wait for CI? ❌ (chose "no GitHub")
**Fix:** Add conditional logic to init-project.md:
```
if no_github_repo:
    skip questions 15, 16, 17
if greenfield (no source files):
    skip questions 1, 10, 11
    default modules to all-enabled silently
```
**Priority:** High — first-run experience determines adoption
**Milestone candidate:** v2.26 Init/Onboarding Overhaul

---

## Item 7: Brownfield Detection Threshold Fix

**Source:** Phase 131 — empty src/ and test/ directories triggered brownfield detection
**Problem:** The brownfield detection heuristic checks for directory existence, not actual source files. An empty scaffold (just `mkdir src test`) triggers "Existing codebase detected. Map codebase now?" which is misleading for a greenfield project.
**Evidence:** GPT-5.4 detected `package.json`, `src/`, `test/`, `.git/` and offered codebase mapping on a project with zero source files.
**Fix:** Change the brownfield detection in init-project.md:
- Before: Check for `src/` or `lib/` or `app/` directory existence
- After: Check for actual source files: `find src lib app -name '*.ts' -o -name '*.js' -o -name '*.py' -o -name '*.rs' | head -1`
- If no source files found → greenfield path, skip codebase mapping offer
- If source files found → brownfield path, offer mapping
**Priority:** High — confusing first-run experience
**Milestone candidate:** v2.26 Init/Onboarding Overhaul

---

## Item 8: Reduce Greenfield to ~8 Questions

**Source:** Phase 131 — 17 questions is too many for init
**Problem:** A new user doing `paul:init` on a fresh project answers 17 questions before any artifact is created. The onboarding fatigue is significant. By question 10 the user is just pressing "skip" on everything.
**Fix:** Greenfield fast path:
1. What are you building? (1-2 sentences)
2. Primary users?
3. Must-have vs deferred?
4. Project name confirm
5. GitHub repo? (yes/no)
6. Git workflow? (only if GitHub chosen)
7. Collaboration level?
8. Confirm and create

Everything else gets smart defaults:
- SonarQube: disabled
- Specialized skills: none
- Modules: all enabled
- Worktrees: no
- Auto-PR: yes if GitHub Flow, no otherwise
- CI checks: yes if GitHub Flow, no otherwise
**Priority:** High — adoption barrier
**Milestone candidate:** v2.26 Init/Onboarding Overhaul

---

## Item 9: Explicit First Milestone in Init

**Source:** Phase 131 — GPT-5.4 set "v0.1 Initial Release" in STATE.md during init without formally running /paul:milestone
**Problem:** The init flow implicitly creates a milestone by setting it in STATE.md and ROADMAP.md, but doesn't run the create-milestone workflow. This creates ambiguity about whether the milestone was formally created or just inferred by the model.
**Evidence:** After init, STATE.md showed "Milestone: v0.1 Initial Release" and the lifecycle sidebar showed it, but no /paul:milestone was invoked. The model went straight to /paul:plan.
**Fix:** Two options:
1. Init explicitly calls create-milestone as a final step (adds one more question: "Milestone name?")
2. Init creates a minimal default milestone ("v0.1 Initial Release") and documents that the user can customize via /paul:milestone
Option 2 is simpler and doesn't add another question.
**Priority:** Medium — works but is ambiguous
**Milestone candidate:** v2.26 Init/Onboarding Overhaul

---

## Item 10: Module Explanations During Init

**Source:** Phase 131 — new users see "Which PALS modules would you like to enable?" with zero context
**Problem:** The module toggle question during init lists module names (TODD, WALT, DEAN, etc.) without explaining what they do. A new user has no basis for making an informed choice.
**Evidence:** GPT-5.4's init showed "All are enabled by default. Press Enter to accept, or send numbers to toggle off." with no descriptions of what each module does.
**Fix:** Add brief one-liner descriptions grouped by concern:
```
Quality & Testing:
  TODD — enforces test coverage and TDD workflows
  WALT — gates quality (tests, lint, typecheck pass/fail)
  
Security & Dependencies:
  DEAN — audits dependencies for vulnerabilities
  SETH — scans for hardcoded secrets and injection risks
  
Code Quality:
  IRIS — reviews code for anti-patterns and smells
  RUBY — flags technical debt and refactoring candidates
  
[etc.]
```
Or simpler: just default to all enabled and skip the question entirely for greenfield (see Item 8).
**Priority:** Low — smart defaults (Item 8) may eliminate this question entirely
**Milestone candidate:** v2.26 Init/Onboarding Overhaul

---

## Item 11: Conditional Git Automation Questions

**Source:** Phase 131 — asked about auto-PR and CI checks after choosing "no GitHub repo / local only"
**Problem:** Init asked "Auto-create PR on phase transition?" and "Wait for CI checks before merge?" after the user explicitly chose "No GitHub repo / local only." These questions are contradictory — you can't create PRs without a remote.
**Evidence:** Question sequence: GitHub repo? → "3" (no GitHub) → Git workflow? → "3" (direct to main) → Worktrees? → "1" (no) → Auto-create PR? / Wait for CI? — these last two are impossible without a remote.
**Fix:** In init-project.md, gate git automation questions:
```
if git.remote is null or git.workflow is "none" or "legacy":
    skip auto_push, auto_pr, ci_checks, require_reviews questions
    set all to false
```
**Priority:** High — contradictory questions undermine user trust
**Milestone candidate:** v2.26 Init/Onboarding Overhaul

---

## Item 12: Remove "Specialized Skills" from Init

**Source:** Phase 131 — "Do you have specialized skills or commands?" is jargon
**Problem:** The SPECIAL-FLOWS.md concept is an advanced feature. Asking about it during init confuses new users who have no context for what "specialized skills" means in PALS.
**Evidence:** GPT-5.4 was asked "Do you have specialized skills or commands for this project?" — the user answered "2" (skip) because the question was meaningless for a new project.
**Fix:** Remove the question from init-project.md. Add it to:
- /paul:config as an option
- Documentation as a "power user" feature
- Post-init guidance: "To add specialized workflows, see /paul:flows"
**Priority:** Low — skip works, but the question shouldn't be there
**Milestone candidate:** v2.26 Init/Onboarding Overhaul

---

## Item 13: `/paul:init --quick` Mode

**Source:** Phase 131 — experienced users want to skip the interview
**Problem:** Even with smart defaults, the init flow requires multiple interactions. An experienced PALS user starting a new project just wants `.paul/` created with sensible defaults and a milestone ready.
**Fix:** Add a `--quick` flag (or detect when user says "quick" or "just init"):
1. Infer project name from package.json/directory name
2. Ask only: "What are you building? (1-2 sentences)"
3. Default everything else: medium collaboration, all modules, no GitHub, direct-to-main, no SonarQube, no skills
4. Create all artifacts and a "v0.1 Initial Release" milestone
5. Route to /paul:plan
**Priority:** Low — nice to have, not blocking
**Milestone candidate:** v2.26 Init/Onboarding Overhaul (or defer to v2.27)

---

## Milestone Mapping

| Milestone | Items | Theme | Priority |
|-----------|-------|-------|----------|
| **v2.26 Init/Onboarding Overhaul** | 6, 7, 8, 9, 10, 11, 12, 13 | Fix greenfield friction — smart defaults, fewer questions, better detection | **Next** |
| **v2.27 Module Dispatch Hardening** | 1, 2, 4, 5 | Make modules actually fire across models — imperative instructions, structural enforcement | After v2.26 |
| **v2.28 DEAN Baseline Management** | 3 | "Remember override" for pre-existing vulns | After v2.27 (or fold into v2.27) |

### v2.26 Estimated Phases (Init/Onboarding)
- Phase 132: Smart question gating + brownfield detection fix (Items 6, 7, 11)
- Phase 133: Greenfield fast path + explicit milestone creation (Items 8, 9, 10, 12)
- Phase 134: Quick mode + validation (Item 13 + end-to-end test)

### v2.27 Estimated Phases (Module Dispatch)
- Phase 135: Module instruction wording audit (Item 1 — rewrite all 18 module hook descriptions)
- Phase 136: Post-apply/post-unify enforcement (Items 2, 4 — structural workflow changes)
- Phase 137: GitHub Flow merge gate simplification (Item 5 — break into smaller steps)

### v2.28 Estimated Phase (DEAN)
- Phase 138: DEAN baseline mechanism (Item 3 — pals.json or .paul/dean-baseline.json)

---

*Generated from v2.25 E2E Adversarial Testing results. All items have evidence references in Phase 129/130/131 artifacts.*
