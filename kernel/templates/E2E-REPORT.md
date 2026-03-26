# E2E Test Report: {run_name}

**Date:** {date}
**Protocol version:** v2.29 (kernel/references/e2e-test-protocol.md)

## Run Configuration

| Field | Value |
|-------|-------|
| Project | {project_name} ({greenfield/brownfield}) |
| Model(s) | {model_list} |
| Posture | {adversarial/real-dev/mixed} |
| Focus | {broad/targeted: specific_area} |
| Scope | {full lifecycle / partial: description} |
| Active dimensions | {list from catalog, e.g., A-H for broad} |
| Phases completed | {N} |
| Loops completed | {N} |

---

## Executive Summary

<!-- 3-5 sentences summarizing the overall findings. What worked, what didn't, what needs attention. -->

{summary}

**Overall health:** {healthy / needs attention / significant issues}
**Critical items:** {count}
**High items:** {count}

---

## Dimension Assessments

<!-- For each ACTIVE dimension from the run configuration, fill in a section below.
     Delete sections for inactive dimensions. -->

### A. Module Dispatch

**Score:** {percentage} ({pass/partial/fail})

<!-- Record L1/L2/L3 breakdown if applicable -->

| Level | Score | Notes |
|-------|-------|-------|
| L1 — Workflow compliance | {%} | {Did model follow dispatch steps?} |
| L2 — Actual dispatch | {%} | {Did hooks fire with real commands?} |
| L3 — Output quality | {%} | {Was output useful/actionable?} |

**Evidence:**

| Lifecycle Point | Hooks Expected | Hooks Fired | Commands Run | Notes |
|-----------------|---------------|-------------|--------------|-------|
| Pre-plan | {list} | {list} | {yes/no per hook} | {detail} |
| Post-apply advisory | {list} | {list} | {yes/no per hook} | {detail} |
| Post-apply enforcement | {list} | {list} | {yes/no per hook} | {detail} |
| Post-unify | {list} | {list} | {yes/no per hook} | {detail} |

### B. Artifact Quality

**Score:** {pass/partial/fail}

| Artifact | Present | Complete | Accurate | Notes |
|----------|---------|----------|----------|-------|
| PLAN.md | {yes/no} | {all sections?} | {clarity test pass?} | {detail} |
| SUMMARY.md | {yes/no} | {module reports?} | {reconciliation accurate?} | {detail} |
| STATE.md | {yes/no} | {all fields?} | {position tracking correct?} | {detail} |
| ROADMAP.md | {yes/no} | {status updated?} | {progress accurate?} | {detail} |
| quality-history.md | {yes/no/N/A} | {entry per phase?} | {trends correct?} | {detail} |

### C. Workflow Compliance

**Score:** {pass/partial/fail}

| Check | Result | Evidence |
|-------|--------|----------|
| Loop sequence (PLAN→APPLY→UNIFY) | {pass/fail} | {detail} |
| State transitions (○→✓ markers) | {pass/fail} | {detail} |
| Required steps executed | {pass/partial/fail} | {which steps skipped?} |
| Boundary respect | {pass/fail} | {any violations?} |
| Plan approval obtained | {pass/fail} | {detail} |
| Deviation handling | {pass/N/A} | {deviations detected and documented?} |

### D. Git Flow

<!-- Only for github-flow projects. Delete this section if not applicable. -->

**Score:** {pass/partial/fail}

| Check | Result | Evidence |
|-------|--------|----------|
| Branch creation | {pass/fail} | {branch name, created from base?} |
| Commit hygiene | {pass/partial/fail} | {scoped commits?} |
| PR lifecycle | {pass/fail} | {PR created, linked?} |
| Merge gate (4 sub-steps) | {pass/partial/fail} | {which sub-steps executed?} |
| CI integration | {pass/fail/N/A} | {CI passed before merge?} |
| Branch cleanup | {pass/fail} | {branch deleted after merge?} |
| Base sync | {pass/fail} | {not behind base at merge time?} |

### E. Init/Onboarding

<!-- Only for greenfield runs. Delete this section if not applicable. -->

**Score:** {pass/partial/fail}

| Check | Result | Notes |
|-------|--------|-------|
| Question count | {N} (target: ~8 greenfield, ~1 quick) | {unnecessary questions?} |
| Smart defaults | {pass/fail} | {irrelevant questions skipped?} |
| Brownfield detection | {pass/fail} | {correct identification?} |
| Artifact completeness | {pass/fail} | {all artifacts created?} |
| Module setup | {pass/fail} | {pals.json correct?} |
| First milestone | {pass/fail} | {explicit milestone created?} |

### F. Session Management

<!-- Include if pause/resume tested. Delete if not applicable. -->

**Score:** {pass/partial/fail}

| Check | Result | Evidence |
|-------|--------|----------|
| CARL detection | {pass/fail/N/A} | {phase boundary detected?} |
| Handoff quality | {pass/partial/fail} | {enough context for resume?} |
| Resume accuracy | {pass/fail} | {correct position and next action?} |
| Context continuity | {pass/fail} | {decisions/deviations preserved?} |

### G. Model Behavior

<!-- Most valuable in multi-model runs. -->

**Score:** {pass/partial/fail}

| Check | Result | Notes |
|-------|--------|-------|
| Instruction following | {pass/partial/fail} | {follows vs interprets/skips?} |
| Tool usage | {pass/partial/fail} | {runs commands vs describes?} |
| Autonomous behavior | {pass/fail} | {proceeds on auto, stops at checkpoints?} |
| Error recovery | {pass/partial/fail/N/A} | {follows retry/escalate protocol?} |
| Boundary respect | {pass/fail} | {stays within scope?} |
| State management | {pass/partial/fail} | {updates artifacts correctly?} |

### H. Planning Quality

**Score:** {pass/partial/fail}

| Check | Result | Notes |
|-------|--------|-------|
| Scope sizing (2-3 tasks) | {pass/fail} | {actual task count} |
| Task specificity | {pass/partial/fail} | {files + action + verify + done?} |
| AC quality | {pass/partial/fail} | {testable Given/When/Then?} |
| Checkpoint placement | {pass/N/A} | {appropriate?} |
| Boundary protection | {pass/partial/fail} | {meaningful boundaries?} |
| Module input | {pass/partial/fail} | {pre-plan output informed plan?} |

---

## Cross-Model Comparison

<!-- Include this section only for multi-model runs. Delete entirely for single-model runs. -->

|              | L1 Workflow | L2 Dispatch | L3 Quality | Artifact | Workflow | Git Flow | Overall |
|--------------|-------------|-------------|------------|----------|----------|----------|---------|
| {Model A}    | {%}         | {%}         | {%}        | {score}  | {score}  | {score}  | {%}     |
| {Model B}    | {%}         | {%}         | {%}        | {score}  | {score}  | {score}  | {%}     |

**Key insight:** {1-2 sentences on the most significant model difference}

---

## Itemized Findings

<!-- Each finding gets its own section. Use the format below consistently.
     Number sequentially. Include ALL findings — don't filter during the test.
     Severity and milestone mapping happen here. -->

### Item 1: {Title}

**Source:** {phase/observation that surfaced this}
**Problem:** {what's wrong — specific and evidence-based}
**Evidence:** {specific artifacts, logs, command output, observations}
**Fix:** {suggested resolution — actionable, not vague}
**Risk:** {what could go wrong with the fix}
**Priority:** {Critical/High/Medium/Low}
**Milestone candidate:** {suggested future milestone name}

---

### Item 2: {Title}

**Source:** {phase/observation}
**Problem:** {description}
**Evidence:** {specifics}
**Fix:** {suggestion}
**Risk:** {tradeoffs}
**Priority:** {severity}
**Milestone candidate:** {milestone}

---

<!-- Add more items as needed. Each gets its own ### section with --- separator. -->

---

## Milestone Mapping

<!-- Group findings into suggested future milestones. This section feeds directly
     into the next /paul:discuss-milestone as input. -->

| Milestone | Items | Theme | Priority |
|-----------|-------|-------|----------|
| **{milestone_name}** | {item_numbers} | {1-sentence theme} | **Next** |
| **{milestone_name}** | {item_numbers} | {1-sentence theme} | After {prev} |
| **{milestone_name}** | {item_numbers} | {1-sentence theme} | Defer |

### {Milestone Name} — Estimated Phases

<!-- Rough phase breakdown for each suggested milestone. -->

- Phase {N}: {name} ({items covered})
- Phase {N+1}: {name} ({items covered})
- Phase {N+2}: {name} ({items covered})

### {Milestone Name} — Estimated Phases

- Phase {N}: {name} ({items covered})
- Phase {N+1}: {name} ({items covered})

---

## Appendix: Run Log

<!-- Optional. Paste or reference the real-time observation notes from during the run. -->

```
[Phase N, Step] Observation
[Phase N, Step] FINDING: {severity} — {description}
...
```

---

*Report generated using E2E Test Protocol v2.29. Reference: kernel/references/e2e-test-protocol.md*
