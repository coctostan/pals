# PALS Module E2E Test Log — Phase 100

**Date:** 2026-03-24
**Test pane:** surface:23, Pi with Kimi for Coding (K2.5)
**Starting context:** 69.9% | **Ending context:** 78.9%
**Fix 04 status:** Deployed (kernel/ prefix removed, fresh install.sh run)

## Critical Finding

**ALL 8 MODULES FAILED TO DISPATCH — AGAIN.**

The kernel/ path fix is deployed and verified (zero `kernel/` references in installed files, modules.yaml exists at correct path). But the model (Kimi K2.5) **never reads modules.yaml** and **never outputs dispatch logs**.

### Evidence

| Hook Point | Expected Modules | Dispatch Log | modules.yaml Read | Verdict |
|------------|-----------------|--------------|-------------------|---------|
| pre-plan | TODD, DEAN, DOCS, IRIS, RUBY, DAVE | ❌ None | ❌ Never read | NOT DISPATCHED |
| post-plan | TODD | ❌ None | ❌ Never read | NOT DISPATCHED |
| pre-apply | TODD, WALT | ❌ None | ❌ Never read | NOT DISPATCHED |
| post-task | TODD (per task) | ❌ None | ❌ Never read | NOT DISPATCHED |
| post-apply | TODD, WALT, DEAN, DOCS, IRIS, SKIP, DAVE | ❌ None | ❌ Never read | NOT DISPATCHED |
| post-unify | WALT, SKIP, RUBY | ❌ None | ❌ Never read | NOT DISPATCHED |

### Files Read by Model (full session)
```
.paul/STATE.md (multiple times)
.paul/ROADMAP.md
src/verify.ts (multiple reads)
src/index.ts
src/types.ts
.github/workflows/ci.yml
README.md
paul-apply/SKILL.md
paul-status/SKILL.md
```

**modules.yaml was NEVER read.** The model follows the SKILL.md → workflow.md chain but skips the module dispatch steps entirely.

### SUMMARY.md Confirmation
The generated SUMMARY says: "No module hooks registered for post-unify phase." — identical to v2.15 results before the path fix.

## Root Cause Analysis (Updated)

### Original diagnosis (Fix 04): Path mismatch
- `kernel/modules.yaml` path didn't exist in installed tree
- **Status: FIXED** — path now correct, modules.yaml at `modules.yaml`

### Actual root cause: Model doesn't execute dispatch steps
The workflows contain dispatch instructions like:
```
1. Read `modules.yaml` (installed module registry)
2. Resolve installed modules for `pre-plan` by finding `installed_modules.*.hook_details.pre-plan`
3. Sort by priority ascending
4. For each registered module: load refs, follow description
```

But the model (Kimi K2.5) treats these as optional/ignorable. It:
- Reads the workflow file
- Follows the main steps (create plan, execute tasks, create SUMMARY)
- **Completely skips** the module dispatch substeps
- Writes "No module hooks registered" in the SUMMARY without checking

### Why the model skips dispatch
1. **The dispatch steps are embedded in larger workflow files** — the model may not parse them as mandatory
2. **No enforcement mechanism** — the workflow says "if it exists" and "no-op, no warning" for missing modules, making the entire dispatch block feel optional
3. **Context pressure** — at 70-79% context, the model may be economizing by skipping what it perceives as optional steps
4. **Model-specific behavior** — Kimi K2.5 may handle instruction-following differently than Claude. The dispatch instructions may need to be more prominent or structured differently.

## Recommendations

### Option A: Make dispatch impossible to skip (workflow restructuring)
- Move dispatch from embedded substeps to **top-level mandatory steps** with clear gates
- Add: "⚠️ MANDATORY: Read modules.yaml before proceeding. If modules.yaml exists, you MUST dispatch hooks."
- Change "no-op, no warning" to "no-op, but log: '[dispatch] No modules.yaml found — skipping'"

### Option B: Move dispatch into the SKILL.md (earlier in the chain)
- The model reliably reads SKILL.md. Put dispatch instructions there instead of buried in workflows
- "Before following the workflow, read modules.yaml and collect module context"

### Option C: Make dispatch a required file read (structural)
- The plan-phase workflow already has `<required_reading>`. Add modules.yaml to that list
- The model reliably reads files listed in required_reading

### Option D: Accept that module dispatch is model-dependent
- Document that module dispatch requires a model that follows detailed substep instructions
- Test with different models (Claude Sonnet 4.6, GPT-5, etc.)

## What DID Work

Despite no module dispatch, the full loop worked cleanly:
- Plan created (5 tasks)
- Apply executed (26 tests passing, chalk added, CI workflow created, README updated)
- Unify with merge gate (PR #3 merged)
- GitHub Flow (branch → PR → squash merge → cleanup)
- CARL observed at 78.9% approaching safety ceiling
- Widget updated correctly throughout
