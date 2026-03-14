# Testing & TDD Deep-Dive: Cross-Framework Research

Research across 12 AI coding frameworks examining how each handles testing — from test generation through failure diagnosis. Frameworks span IDE-integrated tools (Cursor, Cline, Continue.dev, Aider), autonomous agents (SWE-agent, OpenHands, Devin), multi-agent systems (MetaGPT, GPT Pilot), and methodology frameworks (OpenSpec, BMAD, Superpowers). Seven dimensions analyzed: test generation, test timing, coverage targeting, failure diagnosis, test quality enforcement, regression prevention, and unique techniques.

---

## 1. Aider

**Test generation:** No built-in test generation. Aider edits code and runs tests but does not create tests itself. Users provide `--test-cmd` to specify how to run tests.
**Test timing:** Test-after. Aider's `--auto-test` flag runs the test command after every code edit. Tests are external input, not generated.
**Coverage targeting:** None. Runs whatever test command the user provides — no coverage analysis or targeting.
**Failure diagnosis:** Reflection loop (`max_reflections = 3` in `base_coder.py`). Raw test stdout/stderr is piped back to the LLM as the next prompt. Same mechanism used for lint failures. Two config flags: `--test-cmd` and `--auto-test`.
**Test quality:** No enforcement. Tests are user-provided, assumed correct.
**Regression prevention:** `--auto-test` runs after every edit, catching regressions immediately. But only runs the user-specified command — no discovery of additional test suites.
**Unique:** **Reflection loop with raw output injection** — simplest possible test feedback: pipe test output directly as next LLM prompt, max 3 iterations. No parsing, no structured diagnosis.

## 2. Superpowers

**Test generation:** Enforced via `test-driven-development` SKILL.md. Tests are written by the agent as the first step of every feature. The skill loads `testing-anti-patterns.md` (6 anti-patterns: mock behavior, test-only methods, incomplete mocks, complexity thresholds) whenever tests are written.
**Test timing:** Strict test-first. Iron law: "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST." Code written before tests is **deleted** (not warned — deleted). 5-step sequence: write failing test → run (must fail) → implement → run (must pass) → commit.
**Coverage targeting:** Per-feature. Each feature gets tests for its behavior. No global coverage analysis or percentage targeting.
**Failure diagnosis:** Two independent subagent reviewers (spec compliance + code quality) review after implementation. If tests fail, agent iterates. Escalates to human after 5 review loops.
**Test quality:** 6-anti-pattern reference loaded during test writing. Two independent subagents review test code for quality. "Tests define the contract" — changing tests to match implementation is explicitly forbidden.
**Regression prevention:** Full test suite run before each commit. 5-step verification gate ensures all tests pass.
**Unique:** **Delete-before-test enforcement + anti-pattern reference injection.** No other framework deletes implementation code written before tests. The anti-pattern reference (loaded contextually during test writing) prevents common test quality issues at creation time.

## 3. GPT Pilot

**Test generation:** Auto-generates unit tests after each implementation step and integration tests after each task completion. 10 specialized agents, with test writing as an explicit step in the coding workflow.
**Test timing:** Test-after. Implementation happens first, then tests are generated to validate it. Tests are a verification step, not a design tool.
**Coverage targeting:** Per-step and per-task. Unit tests cover the code just written in each step. Integration tests cover cross-component behavior after task completion. No global coverage percentage targeting.
**Failure diagnosis:** **5-level recursive debugging.** When a test fails, a debugging cycle starts. If debugging introduces a new bug, a nested debugging cycle starts. This can recurse to depth 5, at which point it halts and escalates to the human developer. 3-tier verification hierarchy: automated tests > command runs > human intervention.
**Test quality:** Tests are generated from implementation context. Human developer reviews at each step. No automated quality scoring.
**Regression prevention:** Full test suite runs at each step. Integration tests at task boundaries catch cross-component regressions.
**Unique:** **5-level recursive debugging with human escalation.** No other framework allows debugging to recurse — debugging a bug can trigger debugging of a new bug, up to 5 levels deep before human escalation.

## 4. SWE-agent

**Test generation:** Vanilla SWE-agent writes reproduction scripts (not formal tests) to confirm bugs exist. Companion system e-Otter++ uses a 3-phase pipeline: (1) LLM localizer + action planner + test generator, (2) critic LLM checks "is this test failing for the right reason?", (3) selector picks from 10 candidates using fail-to-pass behavior, prioritizing assertion failures, with coverage as tiebreaker. e-Otter++ uses **heterogeneous prompting** (5 issue morphs × 5 context masks = 10 diverse candidates).
**Test timing:** Test-after. Canonical workflow: understand issue → reproduce bug → edit source → re-run reproduction → submit patch. Companion TDFlow inverts this (tests as input, making them pass is the task), achieving 88.8% on SWE-Bench Lite.
**Coverage targeting:** No coverage targeting in vanilla. e-Otter++ uses coverage as tiebreaker for candidate test selection.
**Failure diagnosis:** Lint gate after every `str_replace` edit — flake8/eslint/shellcheck runs automatically, rejecting edits with new lint errors and auto-restoring from backup. 51.7% of trajectories have 1+ failed edits; recovery probability 90.5% on first attempt. No structured retry for test failures.
**Test quality:** e-Otter++ critic LLM validates "failing for the right reason." Surrogate patch validation: tests run against approximate fixes, discarding tests that don't achieve fail-to-pass.
**Regression prevention:** SWE-bench uses FAIL_TO_PASS + PASS_TO_PASS test splits (both must pass). But agent itself doesn't run full test suite during workflow — this is infrastructure-level validation.
**Unique:** **Surrogate patch test selection.** Since the real fix doesn't exist during test generation, e-Otter++ generates approximate patches and validates test candidates against them. Tests achieving fail-to-pass on surrogate patches are prioritized.

## 5. OpenHands

**Test generation:** No dedicated test generation module. CodeActAgent can write tests if instructed but this is emergent, not structured.
**Test timing:** Agent-decided. Framework is agnostic about test timing. In SWE-bench evaluation, typically follows reproduce-edit-verify (test-after).
**Coverage targeting:** No built-in coverage targeting. Evaluation harness validates FAIL_TO_PASS + PASS_TO_PASS splits.
**Failure diagnosis:** Event-stream iterative debugging. Agent executes commands, reads Observation events (stdout, stderr, return code), decides next action. **Stuck Detector** (enabled by default) monitors 5 unproductive patterns: repeating action-observation 4+ times, repeating action-error 3+ times, monologue 3+ consecutive turns, alternating patterns 6+ cycles, context window errors. Uses semantic comparison (tool name + content + thought). Auto-halts when stuck.
**Test quality:** No automated quality enforcement for agent-generated tests. Platform itself uses 3-tier testing (programmatic on commit, LLM-based daily, benchmark on-demand).
**Regression prevention:** PASS_TO_PASS test splits in evaluation harness. Docker container isolation (each instance in own container).
**Unique:** **5-pattern Stuck Detector with semantic matching.** Prevents unproductive test-fix loops by monitoring behavior patterns (not just test results). Most sophisticated loop-detection in any open-source agent framework.

## 6. Devin

**Test generation:** Playbook-driven fleet execution. Humans write testing playbooks (conventions, mocking patterns, edge case expectations). Fleet of Devin instances executes in parallel across repos. Knowledge system stores repo-specific testing conventions for cross-session learning. Playbooks accessible via `!macro` shortcuts.
**Test timing:** User-directed. Can operate test-first or test-after. Bug fixes follow test-after pattern (fix with regression test). Coverage improvement tasks are test-after by definition. No framework-enforced TDD cycle.
**Coverage targeting:** Explicit coverage targeting documented. Devin runs test suites, reads coverage reports, identifies low-coverage files, writes targeted tests. Companies report 50-60% → 80-90% coverage improvements. Targeting is file-level and function-level, not line/branch-level.
**Failure diagnosis:** CI auto-fix loop. Creates PR → CI runs → if fails, reads error logs → iterates → pushes again. Repeats until CI passes (no documented iteration limit). Users can comment "Ignore failures in [area]" to bypass. Dynamic re-planning (v3.0) autonomously alters strategy when stuck. Checkpoint restore with hints for retry from known-good state.
**Test quality:** Multi-layered: human review explicitly required ("first-pass test writing"), Knowledge persistence for feedback, Devin Review scans diffs with severity categories (red/yellow/gray), CI as quality gate.
**Regression prevention:** CI pipeline runs all existing tests on every PR. Bug fix PRs include regression tests. Knowledge base prevents anti-pattern regression across sessions.
**Unique:** **Fleet-scale playbook execution with persistent per-repo Knowledge.** Reusable playbooks + parallel execution across hundreds of repos + organizational learning that improves test quality over time.

## 7. OpenSpec

**Test generation:** Does not generate or execute tests. Produces the contract that tests validate against. GIVEN/WHEN/THEN scenarios written in specs before code.
**Test timing:** Spec-first (upstream of both tests and implementation). Scenarios in specs serve as test cases when translated to code.
**Coverage targeting:** Structural: `openspec validate` gates on every requirement having scenarios. Ensures behavioral coverage through spec completeness.
**Failure diagnosis:** N/A — no test execution.
**Test quality:** `openspec validate` enforces RFC 2119 normative terms (MUST/SHALL) in scenarios. Schema validation ensures spec completeness.
**Regression prevention:** Spec artifacts are version-controlled. Delta operations (ADDED/MODIFIED/REMOVED) track changes.
**Unique:** **Spec-as-test-contract.** Scenarios in specs ARE the test specification. Test frameworks implement them but OpenSpec defines what must be tested.

## 8. BMAD

**Test generation:** Two specialized agents with orthogonal concerns. **Quinn** (pragmatic): generates working API + E2E tests from source code via 5-step workflow — reads code, identifies testable paths, writes tests, runs them, iterates on failures. **TEA** (strategic): 9 workflows covering ATDD, risk-based P0-P3 prioritization, 0-100 test quality scoring, traceability matrices, and release gates with PASS/CONCERNS/FAIL/WAIVED outcomes.
**Test timing:** Quinn is test-after by default. TEA's ATDD workflow supports test-first (acceptance tests from requirements before implementation).
**Coverage targeting:** TEA provides risk-based prioritization (P0-P3). P0 tests cover critical paths, P3 covers edge cases. Not coverage-percentage-based but risk-weighted.
**Failure diagnosis:** Quinn iterates on test failures (run → diagnose → fix → re-run). TEA provides strategic oversight with release gate decisions.
**Test quality:** TEA scores test quality 0-100 across dimensions. Traceability matrices map tests to requirements. Release gates provide PASS/CONCERNS/FAIL/WAIVED outcomes.
**Regression prevention:** TEA's traceability ensures all requirements have test coverage. Release gates catch regressions before deployment.
**Unique:** **Dual-agent testing (tactical + strategic).** Quinn writes/runs tests. TEA evaluates test strategy, scores quality, and gates releases. No other framework separates test execution from test evaluation into independent agents.

## 9. MetaGPT

**Test generation:** QA Engineer agent writes tests after Engineer agent writes code. Cross-agent split prevents "marking your own homework."
**Test timing:** Test-after. Engineer writes code → QA Engineer writes tests → Engineer runs tests in self-correction loop (max 3 retries).
**Coverage targeting:** Per-module. QA Engineer writes tests for each module the Engineer implements. No global coverage analysis.
**Failure diagnosis:** Self-correction loop: Engineer runs tests, reads failures, debugs against PRD + design docs + execution history. Max 3 retries before halting.
**Test quality:** Cross-agent separation (different agent writes tests vs. code) provides inherent quality check. Tests are derived from PRD requirements.
**Regression prevention:** Limited. MetaGPT generates fresh codebases rather than modifying existing ones, so regression is less of a concern. Full test suite runs during self-correction loop.
**Unique:** **Cross-agent test authoring.** The agent that writes code is not the agent that writes tests. This separation prevents the common failure mode where an LLM writes tests that match its own (potentially buggy) implementation rather than the actual specification.

## 10. Cursor

**Test generation:** No built-in test generation tool. Agent mode can write tests when prompted. Official best practices prescribe red-green-refactor via Agent mode.
**Test timing:** Official docs recommend test-first (TDD best practices). YOLO mode enables auto-iteration: run tests → read failures → fix → re-run. MDC rules (`.cursor/rules/*.mdc`) with glob-based activation can enforce test-first conventions per project.
**Coverage targeting:** No coverage tool integration. Testing scope is user-directed.
**Failure diagnosis:** **Debug Mode (Cursor 2.2):** generates multiple competing hypotheses about a failure, instruments code with logging, asks human to reproduce, then produces targeted 2-3 line fix from runtime data. Most sophisticated failure diagnosis of any IDE-integrated tool.
**Test quality:** MDC rules can enforce project-specific testing conventions. Debug Mode's multi-hypothesis approach validates fixes more thoroughly.
**Regression prevention:** YOLO mode runs full test suite on each iteration. MDC rules can mandate running existing tests before committing.
**Unique:** **Multi-hypothesis Debug Mode.** Generates competing failure hypotheses, instruments code, uses runtime data to converge on the actual cause. No other tool takes this empirical debugging approach.

## 11. Cline

**Test generation:** No TDD mode (community actively requesting one). Agent can write tests when prompted but has documented tendency to modify tests to match broken implementation.
**Test timing:** No enforced timing. Agent decides. Known anti-pattern: agent changes tests instead of fixing code.
**Coverage targeting:** No coverage integration.
**Failure diagnosis:** Terminal output feedback loop only. Known issues with output capture failures and repetitive action loops. Plan/Act mode helps strategic thinking but doesn't enforce test discipline.
**Test quality:** No enforcement. Documented tendency to weaken tests to match implementation is a known quality issue.
**Regression prevention:** No specific mechanism. Agent may or may not run existing tests.
**Unique:** **Browser-based visual E2E testing via Computer Use.** Cline can launch a browser, interact with the app, capture screenshots and console logs for visual verification. Only IDE tool with built-in visual testing.

## 12. Continue.dev

**Test generation:** `.continue/checks/` markdown files define agent-powered checks that run on every PR as GitHub status checks. Test coverage check verifies structural coverage (test file exists for each source file, exported functions have tests) and generates suggested diffs when missing.
**Test timing:** CI-gate (post-commit, pre-merge). Tests are not part of the development loop — they're enforced at PR time.
**Coverage targeting:** Structural coverage: verifies test files exist for source files and exported functions have test coverage. Not percentage-based but structural completeness.
**Failure diagnosis:** No iterative test-fix loop. One-shot suggestion at PR time. Developers fix manually.
**Test quality:** Checks are version-controlled markdown with acceptance rate metrics. Quality is measured by how often developers accept the check's suggestions.
**Regression prevention:** CI checks run on every PR. Blocking checks can prevent merge if tests are missing.
**Unique:** **PR-level agent-powered checks with acceptance metrics.** Testing enforcement happens at CI gate, not in IDE. Checks are markdown files (version-controlled, reviewable) with measurable acceptance rates.

---

## Cross-Cutting Comparison Matrix

### Test Generation & Timing

| Framework | Generates Tests? | Default Timing | TDD Enforced? |
|-----------|-----------------|----------------|---------------|
| Aider | No | Test-after (auto-run) | No |
| Superpowers | Yes (agent writes) | **Test-first (strict)** | **Yes (deletes code)** |
| GPT Pilot | Yes (auto-generated) | Test-after | No |
| SWE-agent | Reproduction scripts | Test-after | No (TDFlow companion does) |
| OpenHands | Emergent | Agent-decided | No |
| Devin | Yes (playbook-driven) | User-directed | No |
| OpenSpec | No (specs only) | Spec-first | N/A |
| BMAD | Yes (dual-agent) | Test-after (Quinn) / Test-first (TEA ATDD) | Partial (TEA) |
| MetaGPT | Yes (QA agent) | Test-after | No |
| Cursor | No (agent can) | Recommended test-first | No (MDC rules can) |
| Cline | No (agent can) | Agent-decided | No |
| Continue.dev | Structural checks | CI-gate | No |

### Failure Diagnosis

| Framework | Mechanism | Max Retries | Escalation |
|-----------|-----------|-------------|------------|
| Aider | Reflection loop (raw output) | 3 | None (halt) |
| Superpowers | Subagent review + iterate | 5 review loops | Human |
| GPT Pilot | **5-level recursive debugging** | 5 levels deep | Human |
| SWE-agent | Lint gate + re-run script | Cost/iteration limit | None (halt) |
| OpenHands | Event-stream + **Stuck Detector** | Max iterations | None (halt) |
| Devin | **CI auto-fix loop** | No documented limit | Dynamic re-plan → human |
| Cursor | **Multi-hypothesis Debug Mode** | User-directed | Human |
| MetaGPT | Self-correction loop | 3 | None (halt) |

### Coverage & Quality

| Framework | Coverage Targeting | Quality Enforcement |
|-----------|--------------------|---------------------|
| Aider | None | None |
| Superpowers | Per-feature | **Anti-pattern reference injection** |
| GPT Pilot | Per-step/task | Human review |
| SWE-agent | Tiebreaker only (e-Otter++) | Critic LLM + surrogate validation |
| OpenHands | None | None |
| Devin | **File/function-level targeting** | Multi-layered (human + Knowledge + Review) |
| BMAD | **Risk-based P0-P3** | **0-100 quality scoring** |
| MetaGPT | Per-module | Cross-agent separation |
| Continue.dev | **Structural completeness** | Acceptance rate metrics |

---

## Decision Table: Techniques for TODD

| # | Technique | Source | Decision | Rationale |
|---|-----------|--------|----------|-----------|
| 1 | Anti-pattern reference injection during test writing | Superpowers | **Adopt** | TODD already loads refs per hook; adding test anti-pattern awareness during RED phase prevents common quality issues at creation time |
| 2 | Cross-agent test authoring (different entity writes tests vs code) | MetaGPT | **Reject** | PALS is single-agent; cross-agent separation requires multi-agent architecture |
| 3 | 5-level recursive debugging | GPT Pilot | **Reject** | Over-complex for PALS; bounded retry (max 2, from Phase 39) is sufficient |
| 4 | CI auto-fix loop (unbounded iteration until CI passes) | Devin | **Reject** | PALS operates pre-CI; bounded retry is safer than unbounded loops |
| 5 | Reflection loop with raw test output | Aider | **Adapt** | TODD's GREEN phase should pipe test output back to LLM for diagnosis (lighter than Aider's 3-iteration default; use PALS's existing 2-retry bound) |
| 6 | Delete code written before tests | Superpowers | **Reject** | Too aggressive for PALS; TODD already blocks GREEN without verified RED |
| 7 | Surrogate patch test selection | SWE-agent/e-Otter++ | **Reject** | Applicable to bug reproduction, not general TDD; too complex |
| 8 | Fleet-scale playbook execution | Devin | **Reject** | Multi-instance architecture; not applicable to single-session PALS |
| 9 | Multi-hypothesis Debug Mode | Cursor | **Reject** | Requires IDE integration; PALS is platform-agnostic |
| 10 | Structural coverage checks at PR gate | Continue.dev | **Adapt** | TODD can check structural test coverage (test file exists for modified source file) during pre-apply hook as advisory signal |
| 11 | Dual-agent testing (tactical + strategic) | BMAD | **Reject** | Single-agent architecture; but BMAD's quality scoring concept is adaptable |
| 12 | Test quality scoring (0-100) | BMAD | **Adapt** | TODD can add advisory test quality heuristics (assertion count, behavior vs implementation testing, edge case coverage) to tdd.md |
| 13 | Risk-based test prioritization (P0-P3) | BMAD | **Reject** | Adds complexity; TODD's per-feature TDD scope is already well-bounded |
| 14 | Stuck Detector for test-fix loops | OpenHands | **Already adopted** | Phase 39 added stuck detection to apply-phase.md |
| 15 | "Failing for the right reason" validation | SWE-agent/e-Otter++, Superpowers | **Adopt** | TODD's RED phase should explicitly classify failure reason: missing impl (correct) vs syntax error (stop) vs import error (stop) — already partially there, strengthen |
| 16 | Spec-as-test-contract (GIVEN/WHEN/THEN scenarios) | OpenSpec | **Already adopted** | PALS acceptance criteria already use Given/When/Then format |
| 17 | Browser-based visual E2E | Cline | **Reject** | Platform-specific; PALS is platform-agnostic |
| 18 | Test tendency to modify tests to match broken impl | Cline (anti-pattern) | **Adopt (as guard)** | Add explicit guard to tdd-execution.md: "Do NOT modify tests to make them pass — tests define the contract" |

**Summary: 3 adopt, 3 adapt, 12 reject/already-adopted**

---

*Research conducted: 2026-03-14*
*Frameworks: 12 analyzed across 7 testing dimensions*
*Sources: GitHub repos, official docs, papers, blog posts (cited per framework)*
