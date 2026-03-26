# E2E Test Report: v2.29 Protocol Validation — pi-monitor

**Date:** 2026-03-26
**Protocol version:** v2.29 (kernel/references/e2e-test-protocol.md)

## Run Configuration

| Field | Value |
|-------|-------|
| Project | pi-monitor (greenfield webapp — Next.js + TypeScript + Tailwind) |
| Model(s) | anthropic/claude-sonnet-4-6:high |
| Posture | real-dev |
| Focus | broad audit (all 8 dimensions) |
| Scope | full lifecycle — init → 3 plans across 2 phases + Phase 3 plan created |
| Active dimensions | A-H (all) |
| Phases completed | 2 of 4 (foundation, state-core) |
| Loops completed | 3 (01-01, 02-01, 02-02) + Phase 3 plan created |

---

## Executive Summary

Sonnet 4.6 delivers excellent PALS execution quality. Module dispatch is near-perfect — all hooks fire with real commands at every lifecycle point (pre-plan, post-apply advisory, post-apply enforcement, post-unify). Planning quality is strong: well-scoped phases, proper plan splitting (Phase 2 into 2 plans), and correct dependency management. The most significant issue is the Pi extension's guided workflow auto-cascading through approval checkpoints without user control, bypassing review opportunities at plan approval and UNIFY transitions. Init greenfield fast path works well (4 questions).

**Overall health:** Healthy — PALS core works well; Pi guided workflow UX needs attention
**Critical items:** 0
**High items:** 1 (guided workflow auto-approve cascade)
**Medium items:** 2
**Low items:** 1

---

## Dimension Assessments

### A. Module Dispatch

**Score:** 95% (pass)

| Level | Score | Notes |
|-------|-------|-------|
| L1 — Workflow compliance | 100% | Model followed dispatch steps at every lifecycle point — read modules.yaml, resolved hooks, ran dispatch |
| L2 — Actual dispatch | 95% | Real commands at every point: `find`, `grep`, `npm audit`, `npm run type-check`, `npm run build`. One minor: DOCS and SKIP occasionally "skip" when they could contribute |
| L3 — Output quality | 90% | Module output is actionable: DEAN reports vulnerability counts, WALT gives type-check + build results, GABE checks REST conventions, LUKE/ARIA fire on UI files |

**Evidence:**

| Lifecycle Point | Hooks Expected | Hooks Fired | Commands Run | Notes |
|-----------------|---------------|-------------|--------------|-------|
| Pre-plan (Phase 1) | ARCH, TODD, DAVE, DEAN, SETH | ARCH, TODD, DAVE, DEAN | Yes — find, grep, ls | SETH not visible in Phase 1 scrollback |
| Post-apply (Phase 1) | WALT, DEAN, TODD + advisory | WALT ✓, DEAN ✓, TODD ✓ | npm run type-check, npm run build, npm audit | All enforcement gates passed |
| Pre-plan (Phase 2, 02-01) | DEAN, SETH + advisory | DEAN(p50) ✓, SETH(p80) ✓ | npm audit, secret grep | Both with real output |
| Post-apply (Phase 2, 02-01) | All advisory + enforcement | IRIS ✓, DOCS skip, RUBY ✓, SKIP skip, WALT ✓, DEAN ✓, TODD ✓ | wc -l, type-check | Full dispatch with line counts |
| Post-apply (Phase 2, 02-02) | All | GABE ✓ (REST check), WALT ✓, DEAN ✓ | type-check, build | GABE fired for API routes — validated REST conventions |
| Pre-plan (Phase 3) | LUKE, ARIA + standard | LUKE ✓, ARIA ✓, TODD, IRIS, DEAN, SETH | Yes | UI-specific modules fired for session-cards phase |

### B. Artifact Quality

**Score:** Pass

| Artifact | Present | Complete | Accurate | Notes |
|----------|---------|----------|----------|-------|
| PLAN.md | Yes | All sections present | Tasks have files + action + verify + done | Clarity test passes — executable without questions |
| SUMMARY.md | Yes | AC results table, task results, module reports | Reconciliation accurate | AC mapped correctly, deviations documented |
| STATE.md | Yes | All fields populated | Position tracking correct at each transition | Model self-corrected stale "Current focus" during transition |
| ROADMAP.md | Yes | Phase statuses updated | Progress bars accurate (50% after Phase 2) | Phase completion and milestone progress tracked |
| pals.json | Yes | 18 modules, git config, planning config | Correct schema | Created during init with all expected fields |

### C. Workflow Compliance

**Score:** Pass (with guided workflow caveat)

| Check | Result | Evidence |
|-------|--------|----------|
| Loop sequence (PLAN→APPLY→UNIFY) | ✅ Pass | All 3 loops followed correct sequence |
| State transitions (○→✓ markers) | ✅ Pass | STATE.md updated at every transition point |
| Required steps executed | ✅ Pass | Pre-plan hooks, post-apply advisory+enforcement, post-unify all executed |
| Boundary respect | ✅ Pass | No boundary violations observed |
| Plan approval obtained | ⚠️ Partial | Pi guided workflow auto-approved some transitions without user input |
| Deviation handling | ✅ Pass | "Deviations: none" correctly noted when no deviations occurred |
| Phase transition | ✅ Pass | transition-phase.md executed: PROJECT.md evolved, ROADMAP updated, state consistency verified |
| State consistency | ✅ Pass | Model detected and self-corrected stale state during Phase 1→2 transition |

### D. Git Flow

**Score:** N/A (partial — legacy mode)

| Check | Result | Evidence |
|-------|--------|----------|
| Branch creation | N/A | Legacy mode — direct to main |
| Commit hygiene | ✅ Pass | Phase commits with descriptive messages (commit 5f4d8f5 for Phase 2) |
| PR lifecycle | N/A | No remote configured |
| Merge gate | Skipped | "Merge gate: skipped (legacy)" — correct behavior |

### E. Init/Onboarding

**Score:** Pass

| Check | Result | Notes |
|-------|--------|-------|
| Question count | 4 (target: ~4-8 greenfield) | ✅ Excellent — fast path worked |
| Smart defaults | ✅ Pass | Skipped SonarQube, specialized skills, module toggle, git automation details |
| Brownfield detection | ✅ Pass | Correctly detected greenfield (empty repo with only .git and .megapowers) |
| Artifact completeness | ✅ Pass | PROJECT.md, PRD.md, ROADMAP.md, STATE.md, pals.json all created |
| Module setup | ✅ Pass | 18 modules enabled in pals.json |
| First milestone | ✅ Pass | v0.1 Initial Release created with default phases |
| Question quality | ✅ Pass | Questions were clear, examples provided, answers captured accurately |

⚠️ Minor: Next action prompt appeared truncated ("▶ NEXT: /") — should show full command path.

### F. Session Management

**Score:** Partial (limited testing)

| Check | Result | Evidence |
|-------|--------|----------|
| CARL detection | Not tested | No session boundary hit during test window |
| Handoff quality | Not tested | No pause/resume exercised |
| Resume accuracy | Partial | Session was interrupted (Megapowers fix), resumed correctly via explicit /paul:unify |
| Context continuity | ✅ Pass | Context preserved across session resume — STATE.md and artifacts intact |

### G. Model Behavior

**Score:** Pass

| Check | Result | Notes |
|-------|--------|-------|
| Instruction following | ✅ Pass | Followed workflow steps faithfully — read required files, executed hooks, updated state |
| Tool usage | ✅ Pass | Ran all commands (find, grep, npm audit, npm run build, npm run type-check) — never just described |
| Autonomous behavior | ✅ Pass | Proceeded on auto tasks, presented checkpoints (approval menus) |
| Error recovery | ✅ Pass | Recovered from garbled guided workflow input ("Didn't catch that — did you mean [1]?") |
| Boundary respect | ✅ Pass | Stayed within plan scope |
| State management | ✅ Pass | Updated STATE.md, ROADMAP.md, PROJECT.md correctly. Self-corrected stale state. |

### H. Planning Quality

**Score:** Pass

| Check | Result | Notes |
|-------|--------|-------|
| Scope sizing (2-3 tasks) | ✅ Pass | All plans had 2 tasks. Phase 2 split into 2 plans (good scope management) |
| Task specificity | ✅ Pass | Files + action + verify + done on every task. Specific function signatures. |
| AC quality | ✅ Pass | Testable Given/When/Then — e.g., "npm run build → clean, 0 TS errors" |
| Checkpoint placement | ✅ Pass | All plans autonomous:true (appropriate — no human verification needed) |
| Boundary protection | ✅ Pass | Boundaries present and meaningful |
| Module input | ✅ Pass | LUKE/ARIA advisories "factored into plan tasks" for Phase 3 UI work |

---

## Itemized Findings

### Item 1: Pi Guided Workflow Auto-Approve Cascade

**Source:** Multiple lifecycle points — discuss→milestone→plan cascade, APPLY→UNIFY transitions, Plan approval
**Problem:** Pi's guided workflow extension auto-sends approval responses (e.g., "yes", "1", "approved") at PALS checkpoint menus without waiting for user input. This cascades through multiple workflow transitions in a single auto-chain. The user loses control at plan approval, UNIFY continuation, and phase transition points. During this test, the guided workflow auto-approved the Phase 3 plan and started APPLY before I could select "Pause here."
**Evidence:**
- Init completion → discuss-milestone → milestone creation → plan: entire chain auto-approved
- "PALS guided workflow → sending 'yes'" / "→ sending '1'" / "→ sending 'approved'" visible in output
- Phase 3 plan approval: auto-sent "approved" before user could navigate to "Pause here" option
**Fix:** The Pi guided workflow should only auto-send at lifecycle transitions when the user has explicitly opted into auto-continue mode. Default behavior should present the menu and wait. Consider adding a `guided_workflow.auto_approve` setting in pals.json (default: false) or making it per-transition-type.
**Risk:** Making auto-approve opt-in might slow down experienced users who want the cascade. A per-type control (auto-approve transitions but pause at plan approval) might be the right balance.
**Priority:** High — users lose control of the development process at critical decision points
**Milestone candidate:** v2.30 Pi Guided Workflow UX

---

### Item 2: Guided Workflow Menu Parsing Garbled Output

**Source:** Phase 2→3 transition
**Problem:** Pi's guided workflow parsed a garbled menu when the UNIFY output contained `[id]` as part of API route documentation (`DELETE /api/sessions/[id]`). The menu showed `[id] remove → 204` as a selectable option mixed with the real choices `[1] Yes, plan Phase 3` and `[2] Pause here`. The guided workflow then sent "id" as its selection.
**Evidence:** Screen output showed menu with `→ [id] remove → 204` as first option. Model responded: "Didn't catch that — did you mean [1] Yes, plan Phase 3 or something else?"
**Fix:** Pi's guided workflow menu parser needs to filter candidates more strictly — only match `[N]` where N is a number, or `[word]` patterns that match known PALS response patterns (yes/no/approved/pause). Reject patterns that look like code/documentation content.
**Risk:** Over-filtering could miss legitimate PALS menu options. The parser needs a whitelist approach rather than regex matching any bracketed text.
**Priority:** Medium — model recovered gracefully but wastes a turn and could confuse in automated scenarios
**Milestone candidate:** v2.30 Pi Guided Workflow UX

---

### Item 3: Init Next Action Prompt Truncated

**Source:** Init completion
**Problem:** The init completion banner showed "▶ NEXT: /" with the command path truncated. Should show the full next action (e.g., "▶ NEXT: /paul:plan" or "/paul:discuss-milestone").
**Evidence:** Screen output after init: `▶ NEXT: /` followed by a newline and closing ```.
**Fix:** Check init-project.md final step — the next action template may have a line break issue or the output is being truncated by the Pi TUI at a column boundary.
**Risk:** Low — cosmetic issue, doesn't affect functionality
**Priority:** Medium — degrades first-run experience when user doesn't know what to do next
**Milestone candidate:** v2.30 Pi Guided Workflow UX (or v2.31 Polish)

---

### Item 4: Guided Workflow Menu Label Mismatch

**Source:** Phase 2 plan 02-01 UNIFY → 02-02 routing
**Problem:** After UNIFY completed loop for plan 02-01, the guided workflow menu header said "Continue to UNIFY?" but the actual state was loop-complete and routing to the next plan (02-02). The menu label was stale/incorrect.
**Evidence:** Loop state showed ✓ ✓ ✓, lifecycle widget showed "Loop closed — ready for Plan 02-02", but menu said "Continue to UNIFY?"
**Fix:** The Pi guided workflow should read the current loop state when rendering menu labels, not cache the label from the previous lifecycle point.
**Risk:** Low — options themselves were correct, only the header label was wrong
**Priority:** Low — cosmetic confusion, doesn't cause incorrect behavior
**Milestone candidate:** v2.30 Pi Guided Workflow UX

---

## Milestone Mapping

| Milestone | Items | Theme | Priority |
|-----------|-------|-------|----------|
| **v2.30 Pi Guided Workflow UX** | 1, 2, 3, 4 | Fix auto-approve cascade, menu parsing, label accuracy, and truncated prompts | **Next** |

### v2.30 Estimated Phases

- Phase 141: Guided Workflow Auto-Approve Control (Item 1 — add opt-in auto-approve, default to wait-for-user)
- Phase 142: Menu Parser Hardening (Item 2 — whitelist-based menu detection, reject code/doc content)
- Phase 143: Label Accuracy & Polish (Items 3, 4 — fix truncation, sync menu labels with loop state)

---

## Protocol Feedback

**Was the protocol practical to follow?** Yes — the monitoring dimensions provided clear structure for what to observe at each lifecycle point. Without the protocol, these observations would have been ad-hoc notes. The scoring model made it easy to assess each dimension.

**Were any dimensions hard to assess?**
- **Session Management (F):** Hard to fully assess without deliberately pausing/resuming. The test naturally flowed through loops without session boundaries.
- **Git Flow (D):** Limited assessment because the test project used legacy mode (no remote). A github-flow test would exercise this more.

**Are any dimensions missing?**
- **Pi Extension Behavior:** A dimension specifically for Pi's guided workflow, notification, and widget behavior would have been useful. Currently scattered across C (workflow compliance) and G (model behavior).
- **Context Efficiency:** How much context the model uses per loop could be tracked (this run: 16.9% of 1M after 3 plans).

**Suggested protocol improvements:**
1. Add a "Pi Extension" dimension (or sub-dimension under C) for guided workflow, widget, notification behavior
2. Add context usage tracking to the run log format
3. Add a "test pause point" suggestion — protocol should recommend pausing at least once to test session management
4. The protocol's scoring model worked well — no changes needed there

---

## Appendix: Run Log

```
[Init, Q1] Greenfield detected correctly. "Question 1 of ~4" — fast path.
[Init, Q2-4] All questions relevant, well-phrased with examples. 4 total.
[Init, artifacts] PROJECT.md, PRD.md, ROADMAP.md, STATE.md, pals.json all created. 18 modules.
[Init, complete] ⚠️ Next action prompt truncated: "▶ NEXT: /"
[Init→discuss] Pi guided workflow auto-cascaded discuss→milestone→plan without user review
[Phase 1, pre-plan] ARCH, TODD, DAVE, DEAN all fired with real find/grep/ls commands
[Phase 1, apply] 8 files created. npm run type-check ✓, npm run build ✓, npm audit ✓ (0 vulns)
[Phase 1, post-apply] WALT ✓, DEAN ✓, TODD ✓. Module gates all passed.
[Phase 1, unify] SUMMARY written with AC mapping, task table, module reports. Transition executed.
[Phase 1, transition] State consistency self-corrected (stale "Current focus")
[Phase 2, plan] Split into 2 plans (02-01 parser+store, 02-02 API routes) — good scope management
[Phase 2, 02-01 pre-plan] DEAN(p50) ✓ 0 vulns, SETH(p80) ✓ 0 secrets
[Phase 2, 02-01 post-apply] IRIS 0 issues, RUBY 123+84 lines OK, WALT type-check ✓, DEAN ✓, TODD ✓
[Phase 2, 02-02 apply] GABE ✓ REST conventions checked on API routes
[Phase 2, 02-02 post-apply] type-check ✓, build ✓, GABE validated POST/DELETE patterns
[Phase 2, unify] Both plans reconciled. Phase 2 complete. Milestone 50%.
[Phase 2→3 transition] FINDING: Medium — Guided workflow sent "id" from garbled menu
[Phase 3, pre-plan] LUKE ✓, ARIA ✓ fired for UI phase — advisories factored into plan
[Phase 3, plan] 03-01-PLAN.md created with SessionCard, useSessionPolling, Dashboard components
[Phase 3, approval] FINDING: High — Guided workflow auto-sent "approved", bypassing "Pause here"
```

---

*Report generated using E2E Test Protocol v2.29. Reference: kernel/references/e2e-test-protocol.md*
