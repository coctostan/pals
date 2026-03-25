# v2.23 E2E Assessment: Module Dispatch Failure Analysis

**Date:** 2026-03-25
**Milestone:** v2.23 pi-verify v1.0 — Ship-Ready Product
**Method:** True E2E via cmux pane, Kimi for Coding (K2.5) driving PALS lifecycle
**Verdict:** Product development succeeded, module validation failed completely

---

## What Happened

v2.23 was designed to stress-test all 18 PALS modules under real development on pi-verify. Four phases ran (Identity & Cleanup, Multi-Language Core, Config & Parallel, Publish Prep). pi-verify shipped from template scaffolding to npm-ready v1.0.0 with 67 tests.

**Zero modules produced visible evidence of firing across all 4 phases.** No `[dispatch]` logs, no Module Execution Reports, no `quality-history.md`, no knowledge entries. The entire module system was invisible.

## Root Cause

`modules.yaml` is installed globally at `~/.pi/agent/skills/pals/modules.yaml` (300 lines, all 18 modules). It was present the entire time. The process failed to ensure it was read and acted on.

Seven compounding process failures allowed the module system to be silently skipped while producing artifacts that look complete.

---

## Process Failure #1: Duplicate Step Number in SKILL.md

**Files:** `paul-plan/SKILL.md`, `paul-apply/SKILL.md`, `paul-unify/SKILL.md`

```
5. Read the module registry (if it exists):
   - File: `../modules.yaml`
5. Follow the plan-phase workflow:
```

Step 5 appears twice. A model scanning instructions treats the second step 5 (the main action) as the real one and skips the first (modules.yaml read).

**Fix:** Renumber. modules.yaml → step 5, follow workflow → step 6.

---

## Process Failure #2: "If It Exists" Qualifier on Every Module Read

**Files:** All three SKILL.md files, all three workflow files, `references/module-dispatch.md`

| Location | Text |
|----------|------|
| SKILL.md (plan/apply/unify) | "Read the module registry (if it exists)" |
| plan-phase.md (x3 steps) | "Read `modules.yaml` ... if it exists" |
| apply-phase.md (x4 steps) | "Read `modules.yaml` ... if it exists" |
| unify-phase.md (x3 steps) | "Read `modules.yaml` ... if it exists" |
| module-dispatch.md L57 | "If `modules.yaml` is missing, treat hook dispatch as a no-op" |

**Total: 10+ "if it exists" qualifiers** making the entire module system optional at every entry point.

**Fix:** SKILL.md reads should be MUST READ (the file IS installed globally). Keep graceful degradation in the dispatch reference but require a WARNING log when the registry isn't found.

---

## Process Failure #3: No Dispatch Log When Modules Don't Fire

**Files:** `plan-phase.md`, `unify-phase.md`

```
plan-phase.md L241:
  "If no modules registered for post-plan: proceed (no-op, no warning)"

unify-phase.md (pre-unify and post-unify):
  Same pattern — "no-op, no warning"
```

The `[dispatch]` log format exists and is well-defined. But it's only emitted when modules ARE found. When nothing fires: complete silence. No "0 modules dispatched" line. No signal that the step ran at all.

**Fix:** Always emit dispatch log. `[dispatch] pre-plan: 0 modules found (registry not loaded)` or `[dispatch] pre-plan: 0 modules registered for this hook`.

---

## Process Failure #4: PLAN Template Has No Module Section

**File:** `templates/PLAN.md`

The PLAN.md template contains zero mentions of modules, dispatch, or hooks. A plan is considered "valid" without any module input. Pre-plan hooks (TODD TDD detection, DEAN dependency audit, IRIS anti-pattern scan, DOCS doc drift, RUBY debt check) are supposed to inform the plan — but the plan artifact has no place to record their findings.

**Fix:** Add a required section to the PLAN template:
```markdown
## Pre-Plan Module Dispatch
<!-- Required. Record dispatch results from pre-plan hooks. -->
<!-- If no modules fired, state why (e.g., "modules.yaml not found"). -->
```

---

## Process Failure #5: SUMMARY Template Module Section Is Optional

**File:** `templates/SUMMARY.md`

```
Line 77: "If no module evidence survives finalization, omit this section entirely."
```

This gives the model explicit permission to produce a SUMMARY with no module data. Phase 13's SUMMARY demonstrated the failure mode: `"No module hooks triggered during this phase."` — the model acknowledged hooks exist, reported them as not triggered, and moved on without investigating why.

**Fix:** Section should be REQUIRED. If no modules fired, the section must state WHY (registry not found, no hooks registered for this phase, modules read but produced no output, etc.).

---

## Process Failure #6: No Downstream Validation

**Files:** All three workflow files

Nothing in the PALS lifecycle checks whether module dispatch actually happened:

- APPLY doesn't check "did pre-plan hooks run during planning?"
- UNIFY doesn't check "did post-apply hooks produce output?"
- `update_state` doesn't check "were modules consulted?"
- The workflow proceeds identically whether 18 modules fired or zero

The result: a complete PLAN→APPLY→UNIFY loop with all green checkmarks and zero module participation.

**Fix:** Add a validation step. At minimum, the finalize step in each phase should verify that expected dispatch logs exist. If modules are enabled in `pals.json` but no dispatch occurred, emit a WARNING.

---

## Process Failure #7: Two-Layer Duplication Without Reinforcement

**Files:** SKILL.md files + workflow files

The SKILL.md says "read modules.yaml" as a setup step. Each workflow step independently says "read modules.yaml if it exists" again. These two layers were meant to provide redundancy.

In practice, they provide two independent chances to skip. If the model skips the SKILL.md read (due to duplicate step numbering), each workflow dispatch step tries again. But if the model also skips the workflow dispatch steps (due to "if it exists" + context pressure), nothing catches it.

The two layers don't reinforce each other — they duplicate the same weak instruction.

**Fix:** SKILL.md should be the authoritative read. Workflow dispatch steps should reference the already-loaded registry rather than re-reading.

---

## Module-by-Module Assessment

**We cannot assess individual module performance.** The process failures above mean we have no evidence of any module firing. We cannot distinguish between:

- Module was read, dispatched, and produced output that wasn't logged
- Module was read but dispatch step was skipped
- modules.yaml was never read at all

| Module | Expected in v1.0 | Evidence Found | Verdict |
|--------|-------------------|----------------|---------|
| TODD | Pre-apply baseline, post-task regression check, post-apply full suite | None | Unknown |
| WALT | Pre-apply baseline, post-apply quality gate, post-unify quality-history.md | No quality-history.md created | Likely did not fire |
| IRIS | Pre-plan anti-pattern scan, post-apply code review | None | Unknown |
| RUBY | Pre-plan debt detection, post-unify debt analysis | None | Unknown |
| DOCS | Pre-plan doc catalog, post-apply drift detection | None | Unknown |
| SKIP | Post-apply knowledge extraction, post-unify decision records | No knowledge entries from v1.0 | Likely did not fire |
| DEAN | Pre-plan dependency audit | None (27 known vulns not flagged) | Likely did not fire |
| DAVE | Pre-plan CI config check, post-apply CI validation | None | Unknown |
| ARCH | Pre-plan architecture pattern detection, post-apply boundary check | None | Unknown |
| SETH | Pre-plan security scan, post-apply secret/injection check | None | Unknown |
| PETE | Pre-plan performance assessment, post-apply perf check | None | Unknown |
| GABE | Pre-plan API assessment, post-apply contract check | None | Unknown |
| LUKE | Pre-plan UI health, post-apply UI review | N/A (no UI files) | Expected skip |
| ARIA | Pre-plan a11y assessment, post-apply a11y review | N/A (no UI files) | Expected skip |
| DANA | Pre-plan data assessment, post-apply data review | N/A (no data files) | Expected skip |
| OMAR | Pre-plan observability check, post-apply sensitive data check | None | Unknown |
| REED | Pre-plan resilience check, post-apply timeout/retry check | None | Unknown |
| VERA | Pre-plan privacy assessment, post-apply PII check | None | Unknown |

---

## What the E2E Did Prove

Despite the module failure, the test validated other aspects of PALS:

1. **Lifecycle structure works.** PLAN→APPLY→UNIFY ran 4 complete loops without state confusion.
2. **Session resilience works.** 3 context resets, 1 API error, clean resume each time.
3. **Real development produces real friction.** Type errors, lint failures, test failures — all resolved autonomously.
4. **GitHub Flow integration works.** Feature branches, commits, PRs, CI checks.
5. **cmux pane orchestration works.** Sending commands, reading screens, confirming prompts.
6. **Third-party model (Kimi) can drive PALS.** Not just Claude/Sonnet — the workflow is model-portable.

## What Must Be Fixed Before Re-Testing

All 7 process failures above. The fixes are in:
- `paul-plan/SKILL.md`, `paul-apply/SKILL.md`, `paul-unify/SKILL.md` (step numbering, "if it exists" removal)
- `workflows/plan-phase.md`, `workflows/apply-phase.md`, `workflows/unify-phase.md` (mandatory dispatch logging, validation steps)
- `references/module-dispatch.md` (warning on missing registry instead of silent no-op)
- `templates/PLAN.md` (add module dispatch section)
- `templates/SUMMARY.md` (make module section required)

---

## Addendum: E2E Module System Debug (2026-03-25)

### Deployment chain (verified working)

```
modules/todd/module.yaml (source)
    ↓ install.sh → Python installer
modules/todd/references/*.md → copied to ~/.pi/agent/skills/pals/references/
modules.yaml → generated at ~/.pi/agent/skills/pals/modules.yaml
    ✅ All 18 modules installed, all refs copied, registry generated correctly
```

### Runtime chain (suspected failure point)

```
User runs /paul:plan in pi-verify (CWD: /Users/maxwellnewman/claude/pi-verify)
    ↓
Pi loads SKILL.md from ~/.pi/agent/skills/pals/paul-plan/SKILL.md
    ↓
SKILL.md step 5: "Read ../modules.yaml"
    → Resolves to ~/.pi/agent/skills/pals/modules.yaml ✅
    → BUT: step 5 is DUPLICATED (two step 5s), model may skip to 5b
    ↓
Model follows plan-phase.md workflow
    ↓
Workflow step: "Read modules.yaml if it exists"
    → BARE PATH — no kernel/ prefix, no ../
    → Model tries CWD: /Users/maxwellnewman/claude/pi-verify/modules.yaml
    → DOES NOT EXIST → "if it exists" → silent no-op
    ↓
All dispatch steps find no registry → no hooks → no logs
```

### Suspected bugs (UNVERIFIED — needs reproduction)

1. **Path resolution:** Workflows use bare `modules.yaml` instead of documented `kernel/modules.yaml` convention. May have been caused by an earlier PALS phase that removed the kernel/ prefix.
2. **Duplicate step number:** SKILL.md has two step 5s.
3. **Silent failure:** "if it exists" + "no-op, no warning" = zero signal.

**STATUS: These are hypotheses, not confirmed fixes. Need isolated reproduction and instrumented testing before applying changes.**

---

*Assessment created: 2026-03-25*
*Reference for: v2.24 milestone planning*
