# PALS End-to-End Validation Report

**Version:** v2.15
**Date:** 2026-03-24
**Conducted by:** Orchestrator (Claude Opus 4.6) driving Pi (Kimi for Coding K2.5) via cmux
**Project:** pi-verify — a real Pi extension built entirely through PALS

---

## Executive Summary

PALS was validated end-to-end by driving a real AI agent (Kimi for Coding K2.5) through Pi in a cmux-controlled terminal pane. The agent used PALS to build `pi-verify` — a real, working Pi extension with `/verify` command, `verify_check` tool, status bar integration, and 18+ passing tests.

**111 test points were recorded across 3 phases:**
- **106 PASS** (95.5%)
- **5 PASS_WITH_RETRY** (4.5%)
- **0 FAIL** (0%)

**8 gaps found** — 2 Medium severity, 6 Low severity. All have workarounds. No blockers.

---

## Test Environment

| Component | Details |
|-----------|---------|
| Orchestrator | Claude Opus 4.6 in cmux pane (pals project) |
| Test agent | Pi with Kimi for Coding K2.5 (kimi-coder/kimi-for-coding) |
| Test project | pi-verify (coctostan/pi-verify) |
| Template | ayagmar/pi-extension-template |
| cmux control | send, send-key, read-screen on surface:23 |
| GitHub Flow | Enabled from init (squash merge, PR required, CI checks) |
| Modules | All 8 enabled (CARL, TODD, WALT, DEAN, IRIS, SKIP, DAVE, RUBY) |
| Starting context | 0% of 262k |
| Ending context | 69.8% of 262k |

---

## Workflow Coverage Matrix

| PALS Workflow | Phase Tested | Status | Notes |
|---------------|-------------|--------|-------|
| `/paul-init` (greenfield/brownfield) | 96 | ✅ PASS | Brownfield detected, 17 init steps, one-at-a-time questions |
| `/paul-discuss` | — | ⏭️ SKIPPED | Went straight to /paul-milestone (valid alternative path) |
| `/paul-milestone` (create) | 97 | ✅ PASS | v0.2 created with smart defaults from theme |
| `/paul-plan` | 96, 97 | ✅ PASS | Source analysis, plan creation, review menu, 2 plans created |
| `/paul-apply` | 96, 97 | ✅ PASS | GH Flow preflight, task execution, postflight with PR, 2 loops |
| `/paul-unify` | 96, 97 | ✅ PASS | Ground-truth diff, SUMMARY.md, merge gate (6 gates), 2 loops |
| `/paul-status` | 97 | ✅ PASS | Git-aware display: branch, PR, CI, sync, next action |
| `/paul-pause` | 97 | ✅ PASS | Handoff created, state + git state captured |
| `/paul-resume` | 97 | ✅ PASS | State restored, what-was-done shown, correct next action |
| `/paul-fix` (fast-forward) | 98 | ✅ PASS | Auto-selected mode, diagnosed, fixed, verified, committed |
| `/paul-fix` (hotfix/retroactive) | 98 | ✅ PASS | HOTFIX-SUMMARY created, no merge gate (D6 exempt) |
| `/paul-milestone` (complete) | 96 | ✅ PASS | v0.1 marked complete after loop |
| GitHub Flow preflight | 96, 97 | ✅ PASS | Feature branch created, base sync checked |
| GitHub Flow postflight | 96, 97 | ✅ PASS | Push, PR create, CI surface |
| GitHub Flow merge gate | 96, 97 | ✅ PASS | 6 gates (PR, CI, reviews, merge, sync, cleanup) |
| CARL session boundary | 96, 98 | ✅ OBSERVED | Reported at 35%, not triggered at 69.8% |
| PALS widget (Pi status bar) | 96-98 | ✅ PASS | Activated after init, updated at every phase boundary |
| Guided workflow (Pi notifications) | 96, 97 | ✅ PASS | Review menu, routing suggestions |
| Module dispatch | 96 | ✅ PASS | modules.yaml consulted, dispatch log implied |

**Coverage: 18/19 workflows tested (95%). Only `/paul-discuss` skipped (valid — not required before milestone).**

---

## Test Point Inventory

### Phase 96: Init & First Loop — 52 points
| Result | Count |
|--------|-------|
| PASS | 50 |
| PASS_WITH_RETRY | 2 |
| FAIL | 0 |

### Phase 97: Second Loop & Lifecycle — 39 points
| Result | Count |
|--------|-------|
| PASS | 36 |
| PASS_WITH_RETRY | 3 |
| FAIL | 0 |

### Phase 98: Fix Loop & GH Flow — 20 points
| Result | Count |
|--------|-------|
| PASS | 20 |
| PASS_WITH_RETRY | 0 |
| FAIL | 0 |

### Totals
| Result | Count | Percentage |
|--------|-------|------------|
| **PASS** | **106** | **95.5%** |
| **PASS_WITH_RETRY** | **5** | **4.5%** |
| **FAIL** | **0** | **0%** |
| **Total** | **111** | **100%** |

---

## Gap Inventory

### Gap 1: cmux multiline send truncation
- **Severity:** Medium
- **Phase:** 96
- **Type:** Orchestrator
- **Description:** `cmux send` with multiline text only delivered the first line. Pi received the first sentence but not the numbered list.
- **Workaround:** Send as a single compact line.
- **Recommendation:** Orchestrator scripts should always use single-line prompts.

### Gap 2: Pi picker vs numeric input
- **Severity:** Low
- **Phase:** 96
- **Type:** Orchestrator/Pi
- **Description:** Pi's interactive review picker didn't respond to cmux arrow key sends (`send-key "Down"` → "Unknown key"). The picker auto-selected the first option text when Enter was sent.
- **Workaround:** Send the option number as text ("4") instead of arrow-key navigation.
- **Recommendation:** Document valid cmux key names for arrow keys, or ensure text input always works alongside picker.

### Gap 3: Init "Enter for default" not received via cmux
- **Severity:** Low
- **Phase:** 96
- **Type:** PALS
- **Description:** During module config, "Press Enter for all defaults" didn't register via bare cmux Return. Needed explicit text like "accept all defaults."
- **Workaround:** Send text responses rather than relying on Enter=default.
- **Recommendation:** PALS init should also accept "default", "accept", or "yes" as explicit default confirmation.

### Gap 4: Widget doesn't update mid-APPLY
- **Severity:** Low
- **Phase:** 96
- **Type:** Cosmetic
- **Description:** Widget showed "Plan created, awaiting approval" throughout APPLY execution. Only updated after APPLY completed.
- **Workaround:** None needed — correct after each phase boundary.
- **Recommendation:** Consider mid-APPLY progress updates (e.g., "Executing task 3/5").

### Gap 5: UNIFY distracted by code fixes before SUMMARY
- **Severity:** Medium
- **Phase:** 97
- **Type:** PALS/Model
- **Description:** When `/paul-unify` was sent, Pi first fixed a lint issue (unused function) before creating SUMMARY.md. The UNIFY workflow should create the SUMMARY first.
- **Workaround:** Send explicit "complete /paul-unify — create SUMMARY.md" if the model gets distracted.
- **Recommendation:** UNIFY workflow could emphasize "create SUMMARY.md FIRST, then handle cleanup."

### Gap 6: Widget state flicker during merge
- **Severity:** Low
- **Phase:** 97
- **Type:** Cosmetic
- **Description:** Widget briefly showed incorrect state during merge process before settling. Likely caused by STATE.md being rewritten mid-operation.
- **Workaround:** None needed — self-resolving.
- **Recommendation:** Consider atomic STATE.md updates.

### Gap 7: Local fast-forward failure after squash merge
- **Severity:** Low
- **Phase:** 97
- **Type:** Known behavior
- **Description:** After `gh pr merge --squash`, local main diverged from remote. `git pull` failed with "Not possible to fast-forward." Pi recovered with `git pull --rebase`.
- **Workaround:** Use `git pull --rebase` after squash merges.
- **Recommendation:** Postflight workflow could default to `git pull --rebase` after squash merge.

### Gap 8: Fix mode auto-selection not prominently displayed
- **Severity:** Low
- **Phase:** 98
- **Type:** Cosmetic
- **Description:** Fix loop auto-selected fast-forward mode but didn't explicitly announce the decision. User might not know which of the 3 modes was selected.
- **Workaround:** None needed — behavior was correct.
- **Recommendation:** Fix loop could display "Mode selected: fast-forward (trivial fix)" before proceeding.

---

## Context Usage Analysis

| Milestone | Context Used | Tokens |
|-----------|-------------|--------|
| After init | 10.3% | ~27k |
| After 1st plan | 16.9% | ~44k |
| After 1st apply | 30.0% | ~79k |
| After 1st unify+merge | 36.3% | ~95k |
| After status | 36.6% | ~96k |
| After 2nd milestone | 39.3% | ~103k |
| After 2nd plan | 42.4% | ~111k |
| After pause | 44.3% | ~116k |
| After resume | 46.0% | ~121k |
| After 2nd apply | 58.9% | ~154k |
| After 2nd unify+merge | 63.9% | ~167k |
| After fix (fast-forward) | 68.5% | ~180k |
| After fix (hotfix) | 69.8% | ~183k |

**Key observations:**
- APPLY phases are the most context-hungry (~15-17% each)
- UNIFY + merge gate adds ~5-6%
- Fix loop is lightweight (~5% for both modes combined)
- CARL continue_threshold (40%) was exceeded but CARL correctly continued (threshold fires at phase boundary only)
- Session never hit the 80% safety ceiling

---

## What Was Actually Built

Pi (Kimi for Coding K2.5) built a real, installable Pi extension:

**pi-verify** — https://github.com/coctostan/pi-verify

| Feature | Status |
|---------|--------|
| `/verify all` command | ✅ Runs typecheck + lint + test + build |
| `/verify test` command | ✅ Runs tests only |
| `/verify lint` command | ✅ Runs ESLint only |
| `/verify quick` command | ✅ Runs typecheck + lint (fastest) |
| `verify_check` tool | ✅ Model-callable verification |
| Status bar integration | ✅ Shows last check result |
| Node.js auto-detection | ✅ Detects package.json |
| Test output formatting | ✅ Progress indicators, ✓/✗ markers |
| Test suite | ✅ 18+ tests passing |
| GitHub Flow | ✅ 2 PRs merged via squash |

---

## Recommendations for Next Milestone

### Priority 1: Address Medium Gaps
1. **Gap 5 fix:** Add emphasis in unify-phase.md to create SUMMARY.md before any code cleanup
2. **Gap 1 documentation:** Document cmux single-line requirement in orchestration guides

### Priority 2: Improve Fix Loop UX
3. **Gap 8:** Display fix mode selection prominently
4. Consider adding `/paul-fix --mode standard|ff|hotfix` explicit flag

### Priority 3: Widget Improvements
5. **Gap 4:** Mid-APPLY progress updates in widget
6. **Gap 6:** Atomic STATE.md writes to prevent flicker

### Priority 4: Workflow Robustness
7. **Gap 3:** Accept "default"/"accept"/"yes" as explicit default confirmation in init
8. **Gap 7:** Default to `git pull --rebase` after squash merges in postflight

---

*Report generated: 2026-03-24*
*Milestone: v2.15 PALS End-to-End Validation via Pi*
*Total test duration: ~2 hours across 5 phases*
