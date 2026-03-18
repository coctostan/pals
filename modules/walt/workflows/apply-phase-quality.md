<purpose>
Quality lifecycle overlay for apply and unify phases. Orchestrates WALT's quality gating:
baseline capture during pre-apply, regression detection + lint gating during post-apply,
and quality history recording during post-unify.

This workflow is loaded by kernel hook dispatch when WALT's hooks fire.
</purpose>

<when_to_use>
- Loaded by kernel apply-phase.md at pre-apply hook (baseline capture)
- Loaded by kernel apply-phase.md at post-apply hook (quality gate)
- Loaded by kernel unify-phase.md at post-unify hook (history recording)
</when_to_use>

<references>
@modules/walt/references/quality-detection.md
@modules/walt/references/quality-runner.md
@modules/walt/references/quality-lint.md
@modules/walt/references/quality-delta.md
@modules/walt/references/quality-history.md
</references>

<hooks>

<hook name="pre-apply" priority="100">
## Baseline Capture

**When:** Kernel dispatches pre-apply hooks before task execution begins.

**Load:** @references/quality-detection.md, @references/quality-runner.md

**Action:**
1. Detect quality tools using heuristics from quality-detection.md:
   - Scan for ecosystem markers (package.json, Cargo.toml, go.mod, pyproject.toml)
   - For detected ecosystem, identify: test runner, linter, type checker, formatter
   - Build quality profile (tool name, command, coverage command, auto-fix command)
   - If no ecosystem detected: set `walt_skip: true`, return early

2. If test runner detected, capture baseline per quality-runner.md:
   - Run the detected test command (e.g., `npx vitest run`, `python -m pytest`)
   - Parse output for: passed count, failed count, skipped count
   - If coverage command available: run it, parse total coverage %
   - Record baseline results
   - Timeout: 120 seconds — if exceeded, warn and set tests to "skip"

3. Return context_inject:
   ```
   context_inject:
     walt_skip: false
     quality_profile:
       ecosystem: "{detected}"
       tools: {test, lint, typecheck, format entries}
     baseline:
       test_exit_code: {0 or non-zero}
       tests_passed: {N}
       tests_failed: {N}
       tests_skipped: {N}
       coverage: {N% or "not tracked"}
   ```

4. If no test runner detected but other tools exist (lint/typecheck):
   ```
   context_inject:
     walt_skip: false
     quality_profile: {tools without test entry}
     baseline: null
   ```

**Does NOT block.** Baseline capture is informational — failure to capture does not prevent apply.
</hook>

<hook name="post-apply" priority="100">
## Quality Gate

**When:** Kernel dispatches post-apply hooks after all tasks complete.

**Load:** @references/quality-runner.md, @references/quality-lint.md

**Action:**
1. Check context_inject from pre-apply:
   - If `walt_skip: true`: produce minimal skip reports, return annotations, done
   - If no quality_profile: same as skip

2. **Test regression detection** (per quality-runner.md):
   a. If test runner in quality_profile:
      - Run test command again (result capture)
      - Parse output for: passed, failed, skipped counts
      - If coverage available: run coverage, parse %
      - Compare to baseline from pre-apply context_inject:
        - If both exit 0 and passed >= baseline passed: Gate = PASS (no-regression shortcut)
        - If result.failed > baseline.failed: regressions detected
        - Regression count = result.failed - baseline.failed
      - Determine test gate: PASS / BLOCK (strict, default) / WARN (lenient) / SKIP
   b. If no test runner: test gate = SKIP

3. **Lint, typecheck, format checks** (per quality-lint.md):
   Execute in order — format first, then lint, then typecheck:

   a. **Format check + auto-fix:**
      - If format tool in profile: run check command
      - If issues found and auto-fix available: run auto-fix, record "{N} format issues auto-fixed"
      - If clean: record "Format: clean"
      - If no format tool: skip silently

   b. **Lint check + auto-fix:**
      - If lint tool in profile: run lint command, capture issue count
      - If issues found and auto-fix available: run fix, re-run check, record "N found, M fixed, R remaining"
      - If clean: record "Lint: clean"
      - If no lint tool: skip silently

   c. **Type check:**
      - If typecheck tool in profile: run command, capture error count
      - Record "{N} type errors" or "Types: clean"
      - Never auto-fix type errors
      - If no typecheck tool: skip silently

   - Determine lint gate: PASS / BLOCK (type errors, strict default) / WARN (lint issues, lenient default) / SKIP

4. **Combined gate** (most restrictive):
   - Test BLOCK or Lint BLOCK → overall BLOCK
   - Test WARN or Lint WARN (and no BLOCK) → overall WARN
   - Both PASS → overall PASS
   - Either SKIP → use the other's result

5. **If BLOCK** (strict mode regressions or type errors):
   - Return `action: block` with reason and remediation options:
     ```
     [1] Fix now (recommended)
     [2] Override and continue (records deviation)
     [3] Stop apply execution
     ```

6. Return annotations:
   ```
   annotations:
     walt_test_report:
       before: {passed, failed, skipped, coverage}
       after: {passed, failed, skipped, coverage}
       regressions: {count}
       new_passes: {count}
       gate: {PASS|BLOCK|WARN|SKIP}
     walt_lint_report:
       format: "{N} auto-fixed" or "clean" or "skipped"
       lint: "{N} found, {M} fixed, {R} remaining" or "clean" or "skipped"
       types: "{N} errors" or "clean" or "skipped"
       gate: {PASS|BLOCK|WARN|SKIP}
     walt_combined_gate: {PASS|BLOCK|WARN|SKIP}
   ```

**MAY block** if strict mode and regressions or type errors detected.
</hook>

<hook name="post-unify" priority="100">
## Quality History Recording

**When:** Kernel dispatches post-unify hooks after state update while `SUMMARY.md` / `FIX-SUMMARY.md` is still open for finalization.

**Load:** @references/quality-delta.md, @references/quality-history.md
**Action:**
1. Check for WALT annotations from the apply phase:
   - Look for walt_test_report and walt_lint_report in apply annotations
   - If no annotations found (pre-WALT plan or WALT skipped): use "not tracked" values

2. **Compute quality delta** (per quality-delta.md):
   - Extract "before" and "after" values from walt_test_report
   - Calculate per-metric trajectory:
     - Tests passing: delta = after - before (positive = improved)
     - Tests failing: delta = after - before (negative = improved)
     - Coverage: delta = after% - before% (positive = improved)
     - Lint issues: remaining count (no before/after comparison for lint)
     - Type errors: count (no before/after comparison)
   - Determine per-metric trajectory indicator: improved / stable / degraded / skipped
   - Determine overall verdict: improved (any up, none down) / stable (all same) / degraded (any down)
3. **Return a durable quality `module_report` for `Module Execution Reports`** (per quality-delta.md metric format):
   - Prepare the quality table with Before/After/Delta/Trajectory columns
   - Or a minimal "Not tracked" report if no data exists
   - Hand the report back to the kernel so summary finalization persists it after post-unify completes
4. **Append to .paul/QUALITY-HISTORY.md** (per quality-history.md):
   - If file doesn't exist: create with header, trajectory lines, and table header
   - Append new row to Plan History table with plan ID, date, after values, verdict
   - Update Cumulative Trajectory summary (append new values, truncate at 8 with ...→)
5. Return a side-effect note such as "Recorded quality delta in quality-history.md" when history was updated so the kernel can preserve that action in the final summary log when relevant

**Does NOT block.** History recording is append-only and informational, and the durable summary report is returned to the kernel before loop close.
</hook>

</hooks>
