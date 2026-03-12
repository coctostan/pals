<purpose>
TDD workflow overlay for plan creation and execution. Orchestrates the TDD lifecycle:
detection during pre-plan, plan restructuring during post-plan, and phase-gated
RED/GREEN/REFACTOR execution during apply.

This workflow is loaded by kernel hook dispatch when TODD's hooks fire.
It can also be invoked standalone to create a TDD-type plan directly.
</purpose>

<when_to_use>
- Loaded by kernel plan-phase.md at pre-plan hook (TDD detection)
- Loaded by kernel plan-phase.md at post-plan hook (plan restructuring)
- Loaded by kernel apply-phase.md at pre-apply/post-task/post-apply hooks (execution enforcement)
- Invoked standalone when user wants to create a TDD plan explicitly
</when_to_use>

<references>
@modules/todd/references/tdd-detection.md
@modules/todd/references/tdd-plan-generation.md
@modules/todd/references/tdd-execution.md
@modules/todd/references/tdd.md
</references>

<hooks>

<hook name="pre-plan" priority="100">
## TDD Candidate Detection

**When:** Kernel dispatches pre-plan hooks before scope analysis.

**Action:**
1. Read the phase scope from ROADMAP.md
2. Apply detection heuristics from @references/tdd-detection.md:
   - Classify work as STRONG / MODERATE / SKIP for TDD suitability
   - Check for positive signals (defined contract, behavioral spec, edge cases)
   - Check for negative signals (visual output, integration-heavy, trivial logic)
3. Return context_inject:
   ```
   context_inject:
     tdd_assessment: STRONG | MODERATE | SKIP
     tdd_signals: [list of positive/negative signals]
     tdd_recommendation: "Create TDD plan" | "Split scope" | "Use standard plan"
   ```
4. If STRONG or MODERATE: suggest `type: tdd` to the plan creation step
5. If SKIP: no suggestion (kernel defaults to `type: execute`)

**Does NOT block.** Detection is advisory — user confirms type selection.
</hook>

<hook name="post-plan" priority="100">
## TDD Plan Restructuring

**When:** Kernel dispatches post-plan hooks after plan is written.

**Action:**
1. Check plan frontmatter: if `type: tdd`, apply TDD overlay
2. If type is NOT tdd: no-op (return without modifications)
3. If type IS tdd, restructure the plan per @references/tdd-plan-generation.md:
   a. Replace standard acceptance criteria with TDD AC (AC-1: RED, AC-2: GREEN, AC-3: REFACTOR)
   b. Add `<feature>` section with behavior specification
   c. Restructure `<tasks>` into exactly 3 tasks: RED → GREEN → REFACTOR
   d. Add context budget note (40% target)
   e. Add commit guidance from @references/tdd.md
4. Return plan_modifications with the restructured sections

**Does NOT block.** Modifications are applied to the plan file.
</hook>

<hook name="pre-apply" priority="50">
## RED Phase Enforcement

**When:** Kernel dispatches pre-apply hooks before task execution begins.

**Action:**
1. Check plan frontmatter: if `type: tdd`, enforce TDD execution
2. If type is NOT tdd: no-op
3. If type IS tdd:
   a. Detect test command per @references/tdd-execution.md (check package.json, Cargo.toml, etc.)
   b. Store test_command for use in post-task hook
   c. Inject context: "This is a TDD plan. Execute tasks in strict RED → GREEN → REFACTOR order. Do not proceed to GREEN without verified RED (failing test committed)."
4. Return context_inject:
   ```
   context_inject:
     tdd_mode: true
     test_command: "{detected command}"
     enforcement: "strict RED → GREEN → REFACTOR sequencing"
   ```

**Does NOT block** (unless test framework is missing — then block with remediation).
</hook>

<hook name="post-task" priority="100">
## GREEN Phase Verification

**When:** Kernel dispatches post-task hooks after each individual task completes.

**Action:**
1. Check if tdd_mode is active (from pre-apply context_inject)
2. If not active: no-op
3. If active, check which task just completed:
   a. After RED task: verify tests FAIL
      - Run test_command
      - If tests fail for the right reason: "RED verified — tests fail as expected"
      - If tests pass unexpectedly: block with "RED PHASE FAILED: tests pass unexpectedly"
   b. After GREEN task: verify ALL tests PASS
      - Run test_command
      - If all pass: "GREEN verified — all tests pass"
      - If new tests fail: block with "GREEN PHASE STALLED"
      - If existing tests break: block with "Regression detected"
   c. After REFACTOR task: verify ALL tests STILL PASS
      - Run test_command
      - If all pass: "REFACTOR verified — tests still pass"
      - If any break: block with "REFACTOR broke tests — undo changes"

**MAY block** if phase verification fails. Provides remediation options.
</hook>

<hook name="post-apply" priority="200">
## REFACTOR Opportunity Signal

**When:** Kernel dispatches post-apply hooks after all tasks complete.

**Action:**
1. Check if tdd_mode was active
2. If not active: no-op
3. If active:
   a. Collect TDD execution results (RED/GREEN/REFACTOR commit hashes)
   b. Return annotation:
      ```
      annotations:
        tdd_results:
          red: "verified (commit: {hash})"
          green: "verified (commit: {hash})"
          refactor: "complete/skipped (commit: {hash}/none)"
          all_tests_passing: true
      ```

**Does NOT block.** Annotations are included in apply finalize step.
</hook>

</hooks>

<standalone_usage>
## Standalone TDD Plan Creation

When invoked directly (not via hook dispatch):

1. Read ROADMAP.md for current phase scope
2. Run TDD detection from @references/tdd-detection.md
3. If suitable: create TDD plan following @references/tdd-plan-generation.md
4. If not suitable: inform user and suggest `type: execute` instead

This is equivalent to running pre-plan + post-plan hooks manually.
</standalone_usage>
