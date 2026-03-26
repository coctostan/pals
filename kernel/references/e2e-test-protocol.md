# E2E Test Protocol

A structured protocol for end-to-end testing of PALS. Load this document during `/paul:discuss-milestone` when planning an E2E test run.

## Purpose & When to Use

**What this is:** A reusable framework for conducting structured E2E tests of the PALS lifecycle. It replaces the ad-hoc per-run specification that was used in v2.23, v2.25, and v2.26-28.

**When to use:**
- After major PALS changes (new modules, workflow rewrites, structural enforcement changes)
- Periodic validation (confirm PALS still works end-to-end under real conditions)
- New model evaluation (test how a new LLM handles PALS workflows)
- Regression check after milestone-level work

**What it provides:**
- Standard monitoring dimensions with assessment criteria
- Flexible run configuration (greenfield/brownfield, adversarial/real-dev, single/multi-model)
- Scoring model with evidence-based grading
- Report template that produces actionable items for follow-up milestones

---

## Run Configuration

Each E2E test run is configured with these parameters. Not every parameter applies to every run — pick what matters for the test goal.

### Project Type

| Type | What It Exercises | When to Use |
|------|-------------------|-------------|
| **Greenfield** | Init flow, first milestone creation, blank-slate artifact population, module defaults | Testing onboarding, init improvements, new-user experience |
| **Brownfield** | Existing codebase integration, brownfield detection, codebase mapping, module interaction with real code | Testing module dispatch quality, workflow compliance on real projects |

### Test Posture

| Posture | Description | When to Use |
|---------|-------------|-------------|
| **Adversarial** | Deliberately test edge cases, omit information, give ambiguous instructions, test error recovery | Finding failure modes, testing module robustness |
| **Real-dev** | Build something genuine, follow normal workflow, don't artificially stress the system | Validating that PALS adds value in normal use, measuring friction |
| **Mixed** | Start with real-dev, introduce adversarial elements mid-run | Most comprehensive — finds both value gaps and failure modes |

### Model Configuration

| Mode | Description | When to Use |
|------|-------------|-------------|
| **Single model** | One model for the entire run — deep-dive into that model's behavior | Focused evaluation, regression testing |
| **Multi-model** | Same project through multiple models — compare dispatch/compliance/quality | Cross-model baseline, identifying model-dependent issues |
| **Rotation** | Different models for different phases — tests handoff resilience | Testing context continuity and artifact quality as handoff medium |

### Focus Area

| Focus | Description | Active Dimensions |
|-------|-------------|-------------------|
| **Broad audit** | Exercise all PALS capabilities, monitor everything | All dimensions active |
| **Module dispatch** | Focused on whether modules fire and produce value | Module Dispatch, Artifact Quality |
| **Workflow compliance** | Focused on loop integrity, state management, transitions | Workflow Compliance, Git Flow |
| **Init/onboarding** | Focused on first-run experience | Init/Onboarding, Planning Quality |
| **Targeted module** | Exercise a specific module (e.g., DEAN, TODD) | Module Dispatch (scoped to target) |
| **Targeted workflow** | Exercise a specific workflow (e.g., fix-loop, pause/resume) | Workflow Compliance (scoped to target) |

### Run Scope

| Scope | Description |
|-------|-------------|
| **Full lifecycle** | Init → multiple PLAN/APPLY/UNIFY loops → milestone complete. Most thorough. |
| **Single loop** | One PLAN → APPLY → UNIFY cycle. Faster, tests core loop only. |
| **Partial** | Specific workflow segment (e.g., just init, just pause/resume, just fix-loop). |

---

## Monitoring Dimensions Catalog

Each dimension has: what it measures, how to assess it, scoring criteria, and what evidence to collect. **Not all dimensions apply to every run** — the run configuration determines which are active.

### A. Module Dispatch

**What it measures:** Whether PALS modules actually fire and produce useful output during the lifecycle.

**Assessment levels:**
- **L1 — Workflow compliance:** Did the model follow the dispatch steps in the workflow? (Read modules.yaml, resolve hooks, attempt dispatch)
- **L2 — Actual dispatch:** Did hooks fire with real commands? (grep, pnpm audit, eslint, etc. — not just "dispatch noted")
- **L3 — Output quality:** Was the module output useful? (Actionable findings, correct blocking, meaningful reports)

**How to assess:**

| Check | Method | Evidence |
|-------|--------|----------|
| modules.yaml loaded | Search plan/apply output for `[dispatch]` log lines | Log lines present/absent |
| Pre-plan hooks fired | Check PLAN.md `<module_dispatch>` section | Dispatch results recorded with command output |
| Post-apply hooks fired | Check apply output for advisory + enforcement dispatch | Module annotations present with file:line references |
| Post-unify hooks fired | Check SUMMARY.md Module Execution Reports | Reports populated (not empty/placeholder) |
| Commands actually ran | Look for real tool output (JSON, grep matches, test results) | Tool output vs "dispatch noted" prose |
| Blocking worked correctly | Check if DEAN/WALT/TODD blocked when they should have | Block message with evidence, or correct pass |

**Scoring:**

| Score | Criteria |
|-------|----------|
| **Pass (90-100%)** | All registered hooks fire at each lifecycle point with real command execution and useful output |
| **Partial (50-89%)** | Some hooks fire but others are skipped, or hooks fire but with prose instead of tool output |
| **Fail (0-49%)** | Most hooks don't fire, or all dispatch is theoretical/documented rather than executed |

### B. Artifact Quality

**What it measures:** Whether PALS artifacts (plans, summaries, state) are accurate, complete, and useful.

**How to assess:**

| Artifact | Checks |
|----------|--------|
| **PLAN.md** | Has all required sections (objective, AC, tasks, boundaries, verification). Tasks have files + action + verify + done. ACs are testable Given/When/Then. Clarity test: could someone execute this without asking questions? |
| **SUMMARY.md** | Accurately reconciles plan vs actual. Module Execution Reports populated (not empty). Deviations documented. Decisions captured. |
| **STATE.md** | Position tracking accurate at each lifecycle point. Loop markers (✓/○) match actual state. Session continuity section populated. |
| **ROADMAP.md** | Phase status updated correctly. Milestone progress accurate. |
| **quality-history.md** | Entry added per phase (if WALT fires). Trend direction correct. |

**Scoring:**

| Score | Criteria |
|-------|----------|
| **Pass** | All artifacts accurate, complete, and useful. Module reports populated. |
| **Partial** | Artifacts exist but have gaps (empty module reports, inaccurate state, missing reconciliation) |
| **Fail** | Artifacts missing, grossly inaccurate, or placeholder-only |

### C. Workflow Compliance

**What it measures:** Whether the PLAN → APPLY → UNIFY loop is followed correctly with proper state transitions.

**How to assess:**

| Check | Method |
|-------|--------|
| Loop sequence | Was PLAN → APPLY → UNIFY followed without skipping steps? |
| State transitions | Did STATE.md update correctly at each transition (○→✓ markers, position, last activity)? |
| Required steps | Were required steps executed (not just documented)? Especially: pre-plan hooks, plan review, post-apply dispatch, unify reconciliation. |
| Boundary respect | Were DO NOT CHANGE boundaries in the plan respected? |
| Plan approval | Was explicit approval obtained before APPLY? |
| Deviation handling | Were deviations detected, documented, and addressed? |

**Scoring:**

| Score | Criteria |
|-------|----------|
| **Pass** | Full loop compliance with correct state transitions at every point |
| **Partial** | Loop followed but some state transitions missed or some steps documented rather than executed |
| **Fail** | Steps skipped, loop broken (e.g., straight to APPLY without PLAN), or state never updated |

### D. Git Flow

**What it measures:** Whether GitHub Flow operations execute correctly (branch, PR, merge gate, cleanup). **Only active for github-flow projects.**

**How to assess:**

| Check | Method |
|-------|--------|
| Branch creation | Feature branch created from base before APPLY work begins |
| Commit hygiene | Commits scoped to plan work with descriptive messages |
| PR lifecycle | PR created after APPLY, linked to phase work |
| Merge gate | All 4 sub-steps execute in UNIFY (resolve conflicts, create/verify PR, merge, cleanup) |
| CI integration | CI checks pass before merge (if ci_checks enabled) |
| Branch cleanup | Feature branch deleted after merge |
| Base sync | Branch is not behind base at merge time |

**Scoring:**

| Score | Criteria |
|-------|----------|
| **Pass** | Full Git Flow lifecycle executed correctly — branch, PR, CI, merge, cleanup |
| **Partial** | Some operations executed but others skipped (e.g., PR created but merge gate skipped) |
| **Fail** | No Git Flow operations executed, or stayed on main throughout |

### E. Init/Onboarding

**What it measures:** The quality of the initial project setup experience. **Only active for greenfield runs or when testing init specifically.**

**How to assess:**

| Check | Method |
|-------|--------|
| Question count | How many questions asked? (Greenfield target: ~8, Quick mode: ~1) |
| Smart defaults | Did irrelevant questions get skipped? (e.g., no GitHub → skip PR questions) |
| Brownfield detection | Did it correctly identify greenfield vs brownfield? |
| Artifact completeness | Were all required artifacts created? (STATE.md, PROJECT.md, ROADMAP.md, pals.json) |
| Module setup | Were modules configured correctly in pals.json? |
| First milestone | Was an explicit first milestone created? |

**Scoring:**

| Score | Criteria |
|-------|----------|
| **Pass** | Correct detection, smart defaults, reasonable question count, all artifacts complete |
| **Partial** | Artifacts created but with unnecessary questions, wrong detection, or missing defaults |
| **Fail** | Init broken, artifacts incomplete, or user experience unacceptable |

### F. Session Management

**What it measures:** Whether session boundaries, handoffs, and resume work correctly.

**How to assess:**

| Check | Method |
|-------|--------|
| CARL detection | Does CARL detect phase boundaries correctly? (Pi extension only) |
| Handoff quality | Does the handoff file contain enough context for clean resume? |
| Resume accuracy | Does /paul:resume correctly identify position and suggest the right next action? |
| Context continuity | Is accumulated context (decisions, deviations, fixes) preserved across sessions? |
| Pause/resume round-trip | Can you pause mid-phase and resume without losing state? |

**Scoring:**

| Score | Criteria |
|-------|----------|
| **Pass** | Clean pause/resume with no context loss, correct position detection, useful handoff |
| **Partial** | Resume works but some context lost or wrong next-action suggested |
| **Fail** | Resume fails, handoff missing or unusable, or state corrupted |

### G. Model Behavior

**What it measures:** How well the LLM follows PALS workflow instructions. **Most valuable in multi-model runs.**

**How to assess:**

| Check | Method |
|-------|--------|
| Instruction following | Does the model follow workflow steps as written, or interpret/skip them? |
| Tool usage | Does the model run actual commands (grep, test, audit) or describe what it would do? |
| Autonomous behavior | Does the model proceed autonomously on auto tasks and stop at checkpoints? |
| Error recovery | When something fails, does the model follow the retry/escalate protocol? |
| Boundary respect | Does the model stay within plan scope and boundaries? |
| State management | Does the model update STATE.md and other artifacts correctly? |

**Scoring:**

| Score | Criteria |
|-------|----------|
| **Pass** | Model follows instructions faithfully, runs commands, manages state, respects boundaries |
| **Partial** | Model follows most instructions but skips some steps or describes rather than executes |
| **Fail** | Model ignores workflow structure, doesn't run commands, or breaks state |

### H. Planning Quality

**What it measures:** Whether plans are well-structured, appropriately scoped, and executable.

**How to assess:**

| Check | Method |
|-------|--------|
| Scope sizing | Are plans 2-3 tasks? Is scope appropriate for the phase? |
| Task specificity | Do all tasks have files + action + verify + done? Would they pass the clarity test? |
| AC quality | Are acceptance criteria testable Given/When/Then? |
| Checkpoint placement | Are checkpoints placed where genuinely needed (not too many, not too few)? |
| Boundary protection | Are boundaries meaningful and complete? |
| Module input | Did pre-plan module output inform the plan? |

**Scoring:**

| Score | Criteria |
|-------|----------|
| **Pass** | Plans are clear, well-scoped, executable, with testable ACs and informed by module output |
| **Partial** | Plans exist but are vague in places, ACs aren't fully testable, or modules didn't inform scope |
| **Fail** | Plans are too vague to execute, missing required sections, or scope is wildly off |

---

## Execution Guide

### Pre-Run Setup

1. **Choose a project:** Pick or create a project that exercises the dimensions you want to test.
   - Greenfield: create a new empty directory, run `/paul:init`
   - Brownfield: use an existing project with real code
2. **Configure pals.json:** Set git workflow, modules, and preferences for the test.
3. **Set up environment:** If using cmux panes, configure the pane for the model under test.
4. **Document run configuration:** Record project type, posture, model(s), focus, and scope before starting.
5. **Activate monitoring dimensions:** Decide which dimensions from the catalog to actively monitor based on run configuration.

### During Run — Per Lifecycle Point

**Init (if greenfield):**
- Count questions asked
- Note which questions were skipped/defaulted
- Check brownfield detection accuracy
- Verify all artifacts created

**Plan phase (/paul:plan):**
- Check for `[dispatch]` pre-plan log lines
- Verify PLAN.md has all required sections
- Check task specificity (files + action + verify + done)
- Note whether module findings informed the plan
- Verify STATE.md updated (loop: PLAN ✓)

**Apply phase (/paul:apply):**
- Check for GitHub Flow preflight (if applicable)
- Monitor task execution — commands run vs described
- Watch for `[dispatch]` post-apply advisory + enforcement log lines
- Check for deviation detection
- Verify STATE.md updated (loop: APPLY ✓)
- Check for GitHub Flow postflight (if applicable)

**Unify phase (/paul:unify):**
- Check SUMMARY.md — accurate reconciliation? Module reports populated?
- Watch for post-unify hooks (WALT quality-history, SKIP knowledge, RUBY debt)
- Check merge gate execution (if GitHub Flow)
- Verify STATE.md updated (loop: all ✓)
- Check ROADMAP.md updated

**Milestone transitions:**
- Verify milestone completion artifacts
- Check handoff file quality
- Test resume if pausing between milestones

### Real-Time Notes

Capture observations as they happen. Don't rely on post-hoc reconstruction. Use this format:

```
[Phase N, Step] Observation
[Phase N, Step] FINDING: {severity} — {description}
```

Example:
```
[Phase 1, pre-plan] DEAN fired with pnpm audit --json, found 2 critical
[Phase 1, apply] FINDING: Medium — IRIS dispatch logged but no grep output visible
[Phase 1, unify] SKIP captured 2 decisions, WALT updated quality-history.md
```

---

## Scoring Model

### Per-Dimension Scoring

Each active dimension gets a score using the criteria defined in the dimension catalog:

| Dimension | Score | Evidence Summary |
|-----------|-------|------------------|
| Module Dispatch | {%} or {pass/partial/fail} | {1-line evidence} |
| Artifact Quality | ... | ... |
| ... | ... | ... |

### Cross-Model Comparison (if multi-model)

Use the L1/L2/L3 breakdown for direct comparison:

|              | L1 Workflow | L2 Dispatch | L3 Quality | Overall |
|--------------|-------------|-------------|------------|---------|
| {Model A}    | {%}         | {%}         | {%}        | {%}     |
| {Model B}    | {%}         | {%}         | {%}        | {%}     |

### Finding Severity

Each finding is classified:

| Severity | Definition | Action |
|----------|------------|--------|
| **Critical** | Blocks value delivery — PALS cannot function correctly | Must fix in next milestone |
| **High** | Degrades experience significantly — users will hit this regularly | Should fix in next milestone |
| **Medium** | Friction or polish issue — noticeable but workable | Fix when convenient |
| **Low** | Nice-to-have improvement — minor or cosmetic | Defer or batch |

### Weighting by Focus

When a run has a specific focus area, weight the relevant dimensions higher:

| Focus | Primary Dimensions (2x weight) | Secondary Dimensions (1x) |
|-------|---------------------------------|---------------------------|
| Broad audit | All equal | N/A |
| Module dispatch | Module Dispatch, Artifact Quality | All others |
| Workflow compliance | Workflow Compliance, Git Flow | All others |
| Init/onboarding | Init/Onboarding, Planning Quality | All others |

---

## Integration with PAUL Lifecycle

### Loading During Milestone Discussion

When planning an E2E test milestone, reference this protocol:

1. During `/paul:discuss-milestone`, mention this is an E2E test run
2. The discussion should determine the run configuration (project type, posture, model(s), focus, scope)
3. Phase mapping should align with the execution guide:
   - Phase 1 might be protocol setup + init (if greenfield)
   - Subsequent phases are PLAN/APPLY/UNIFY loops
   - Final phase is report generation + findings consolidation

### Monitoring Dimensions → Phase Objectives

Map active dimensions to phase-level monitoring objectives:

```
Phase N objectives:
  - [x] Module Dispatch: check pre-plan and post-apply hooks
  - [x] Artifact Quality: verify PLAN.md completeness
  - [ ] Git Flow: check branch creation and PR lifecycle
```

### Report → Next Milestone

The E2E report (see `kernel/templates/E2E-REPORT.md`) produces:
- Itemized findings with severity and milestone candidates
- Milestone mapping table grouping findings into suggested milestones
- Phase estimates per milestone candidate

This feeds directly into the next `/paul:discuss-milestone` as input, completing the improvement loop:

```
E2E Test → Report → Discuss Milestone → Plan → Execute → ... → E2E Test
```

---

*Protocol created for PALS v2.29. Reference: v2.23 (pi-verify), v2.25 (adversarial testing), v2.26-28 (action item follow-through).*
