# Quality & Validation Deep Dive — 12 Framework Research

**Phase:** 41 — Quality & Validation
**Date:** 2026-03-14
**Methodology:** 4 parallel subagent batches × 3 frameworks, 7 dimensions each

## Research Dimensions

1. Quality gate timing
2. Regression detection
3. Lint/format integration
4. Quality metrics & trending
5. Gate configurability
6. Validation feedback
7. Recovery from quality failures

---

## Framework Findings

### Aider

| Dimension | Finding |
|-----------|---------|
| Gate timing | Post-edit: `--auto-lint` (default on) lints after every AI edit; `--auto-test` (default off) runs tests after edit |
| Regression detection | Exit-code only — no baseline capture, no before/after comparison |
| Lint/format | Built-in linters + custom via `--lint-cmd`. Per-language: `--lint "language: cmd"`. Auto-fix: sends errors to LLM for repair |
| Metrics & trending | None — no history, no dashboard |
| Configurability | Minimal: on/off toggles, custom lint command. No strictness levels |
| Validation feedback | Raw test/lint output fed to LLM as context for next fix attempt |
| Recovery | Auto-fix loop — no max retry limit (known bug: can loop infinitely, Issue #1090) |

**Key insight:** Lint-error-to-LLM feedback loop is the core pattern. Unbounded retry is the cautionary tale.

### Superpowers (Windsurf/Codeium)

| Dimension | Finding |
|-----------|---------|
| Gate timing | Post-edit: Cascade auto-lints after every code edit, fixes at no credit cost |
| Regression detection | None — edit-level only, no project-level baseline |
| Lint/format | Tight ESLint/Prettier/Black integration. Auto-fix ~60% of issues. Invisible + free |
| Metrics & trending | None |
| Configurability | Windsurf Rules (global/workspace/enterprise) guide AI style, not gate thresholds |
| Validation feedback | Transparent — user sees corrected code, not the error |
| Recovery | Auto-fix in next edit. No retry limit or escalation documented |

**Key insight:** "Invisible auto-fix" — user never sees lint errors, only corrected code.

### GPT Pilot

| Dimension | Finding |
|-----------|---------|
| Gate timing | Two-tier: unit tests after each step, integration tests after each task. CodeMonkey validates spec-to-code match |
| Regression detection | TDD-based — accumulated test suite IS the baseline. Re-run all on changes |
| Lint/format | None — focuses on functional correctness only |
| Metrics & trending | None — `user_review_goal` per task is descriptive, not metric |
| Configurability | Debugging recursion depth limit (5 levels). `user_review_goal` per task |
| Validation feedback | Test results + command execution verification + human review for visual elements |
| Recovery | **Recursive conversation debugging** — nested debug conversations, unwinds on fix. Hard limit: 5 levels deep, then escalates to human |

**Key insight:** Recursive debugging with depth limit is sophisticated recovery. Two-tier test timing (fast unit per-task, full integration per-phase) is well-structured.

### SWE-agent

| Dimension | Finding |
|-----------|---------|
| Gate timing | **Edit-time**: linter fused into edit command — invalid edits rejected immediately, never written |
| Regression detection | None built-in. SWE-CI benchmark measures zero-regression rate externally |
| Lint/format | Hard-coded Python syntax linter in edit function. Syntax only, not style. +3% resolve rate improvement |
| Metrics & trending | None — one-shot agent, no persistent state |
| Configurability | Not configurable — linter is hard-coded |
| Validation feedback | Error message + file snippet around error location on failed edit |
| Recovery | Retry with corrected syntax. Invalid edit fully discarded (not partially applied). Recovery rate degrades with successive failures |

**Key insight:** Edit-time validation (reject bad edits before they're written) is the tightest gate possible. Ablation proves it works (+3% resolve rate).

### OpenHands

| Dimension | Finding |
|-----------|---------|
| Gate timing | No built-in gates. Agent-directed via sandbox shell access. openhands-resolver adds CI-level gate via GitHub GraphQL API |
| Regression detection | Outsourced to project's existing CI |
| Lint/format | No integration — agent can run tools but not systematic |
| Metrics & trending | None |
| Configurability | openhands-resolver: trigger label, target scope, repo.md instructions |
| Validation feedback | CI failure info injected into agent prompt. Raw terminal output in sandbox |
| Recovery | **CI-failure-to-prompt injection**: detect failure → inject failure info → agent fixes → push again |

**Key insight:** CI-failure-to-prompt injection — structured failure data fed to agent context for the fix attempt.

### Devin

| Dimension | Finding |
|-----------|---------|
| Gate timing | Multi-point: during dev (per-iteration), pre-push (lint/format/compile), post-push (CI monitoring), PR review |
| Regression detection | Relies on existing test suite. Can write regression tests to increase coverage (40% increase reported) |
| Lint/format | Configured via Knowledge/Playbooks. Devin Review adds AI review with **3-tier severity: red/yellow/gray** |
| Metrics & trending | Org-level: PR merge rates (34%→67%), speed (4x), coverage (50-60%→80-90%). Not user-facing per-project |
| Configurability | Knowledge (persistent per-repo), Playbooks (reusable templates), CI config. Can "ignore failures in [area]" |
| Validation feedback | **3-tier severity**: red (probable bug), yellow (warning), gray (FYI). PR-level structured feedback |
| Recovery | **Closed-loop CI retry**: push → monitor CI → detect failure → fix → retry until pass. Human can intervene via Slack |

**Key insight:** 3-tier severity (bug/warning/FYI) and closed-loop CI retry are both strong patterns.

### OpenSpec

| Dimension | Finding |
|-----------|---------|
| Gate timing | Two gates: proposal approval (pre-code), spec validation (`openspec validate` — ad-hoc, pre-commit, CI) |
| Regression detection | Delta markers (ADDED/MODIFIED/REMOVED) categorize every spec change explicitly |
| Lint/format | Built-in hooks: sensitive-file-guard, markdown-lint. `openspec validate` as "linter for requirements" |
| Metrics & trending | None — tracks spec completeness, not trends |
| Configurability | `config.yaml` + `--strict` flag. Limited |
| Validation feedback | Specific errors: missing headers, missing scenarios, invalid markers |
| Recovery | Manual — troubleshooting table maps errors to fixes. No auto-fix |

**Key insight:** Delta markers (ADDED/MODIFIED/REMOVED) make change classification explicit rather than implicit.

### BMAD

| Dimension | Finding |
|-----------|---------|
| Gate timing | Multi-stage: self-check audit (post-task), adversarial code review (post-impl), finding resolution (interactive), QA checklist (pre-close) |
| Regression detection | Adversarial review examines diffs. Quinn (QA agent) runs regression verification. TEA provides risk-based strategy (P0-P3) |
| Lint/format | code-quality-checklist + security-checklist templates. Coverage thresholds ("coverage > 85%"). Quinn auto-detects test frameworks |
| Metrics & trending | Findings classified by **severity** (Critical/High/Medium/Low) and **validity** (real/noise/undecided). No longitudinal trending |
| Configurability | Mandatory minimum finding count (3-10 per review) — controversial (Issue #1332: forces fabricated critiques). project-context.md for custom standards |
| Validation feedback | Findings tied to file:line, classified by severity. Resolution modes: walk-through, auto-fix-real, acknowledge |
| Recovery | Halts on 3 consecutive failures, unclear fixes, blocking deps, or ambiguous decisions. Non-blocking issues noted and continued |

**Key insight:** Severity + validity classification is powerful. Mandatory minimum findings is controversial — forces false positives.

### MetaGPT

| Dimension | Finding |
|-----------|---------|
| Gate timing | Post-code-generation: Engineer generates → executes/tests → QA Engineer writes tests → tests executed → results fed back |
| Regression detection | Compares against PRD/design docs in memory — specification-based, not code-baseline |
| Lint/format | None — focuses on functional correctness via execution |
| Metrics & trending | Research metrics only: Executability score (1-4), Human Revision Cost. Not user-facing |
| Configurability | Retry limit configurable (default max 3) |
| Validation feedback | Error traces fed to Engineer agent with design context for debugging |
| Recovery | **Bounded retry**: test-fix-retest loop until pass or max retries (default 3). Terminates on exhaustion |

**Key insight:** Bounded retry with configurable limit and error-trace-as-context is clean. Human Revision Cost is an interesting meta-metric.

### Cursor

| Dimension | Finding |
|-----------|---------|
| Gate timing | Post-edit: "Iterate on Lints" reads IDE diagnostics, auto-fixes. Hooks (v1.7+) fire at `afterFileEdit`, `beforeShellExecution`, `stop`, etc. |
| Regression detection | None built-in |
| Lint/format | Iterate on Lints reads IDE language server diagnostics. `afterFileEdit` hooks can run formatters. Primarily catches tsc errors, not all ESLint rules |
| Metrics & trending | None — `afterShellExecution` hook exposes data for custom collection |
| Configurability | Hooks: enterprise > project > user priority. `failClosed` option. `loop_limit` for auto-continue. Iterate on Lints is on/off only |
| Validation feedback | Hooks inject `agent_message`/`user_message` on deny. Lint fixes shown as diffs in chat |
| Recovery | Iterate-on-lints loop across multiple responses. Hooks return allow/deny/ask with guidance |

**Key insight:** Hook permission model (allow/deny/ask) with injected messages for guidance. `failClosed` as safety default.

### Cline

| Dimension | Finding |
|-----------|---------|
| Gate timing | Real-time: monitors linter/compiler during task execution. Human-in-the-loop approval per file change. Hooks (v3.36+) at 6 lifecycle events |
| Regression detection | None — Checkpoint system allows manual rollback but not automated regression detection |
| Lint/format | Auto-monitors IDE diagnostics, self-corrects. Agent-directed terminal lint/test. No block vs warn distinction |
| Metrics & trending | None |
| Configurability | Auto-approve per action type (read/edit/command/browser/MCP). `.clinerules` for advisory standards. PreToolUse hooks can block operations |
| Validation feedback | Diff preview before apply. Step-by-step breakdowns. Hook context injection |
| Recovery | Self-correction loop for lint/compiler errors. Checkpoint/restore for workspace rollback. No retry limit |

**Key insight:** Checkpoint/restore on quality failure — workspace rollback as recovery mechanism.

### Continue.dev

| Dimension | Finding |
|-----------|---------|
| Gate timing | **PR-time**: AI checks run as GitHub status checks on every PR. Local via `cn` CLI pre-push |
| Regression detection | AI-powered diff analysis — evaluates PR diff against natural-language criteria. Implicitly diff-based |
| Lint/format | **Replaces traditional linting with AI checks** in markdown. Natural-language criteria instead of ESLint rules. Binary pass/fail |
| Metrics & trending | None — per-PR status only |
| Configurability | Checks as markdown files in `.continue/checks/` with YAML frontmatter. Source-controlled, per-check granularity |
| Validation feedback | GitHub status checks (green/red). **Suggested fixes as diffs** on failure |
| Recovery | Suggested fix diffs on failure — human decides whether to apply. Re-run on next push |

**Key insight:** Natural-language quality checks as source-controlled markdown + suggested fix diffs on failure.

---

## Non-Framework Approaches

### SonarQube / SonarCloud

| Dimension | Finding |
|-----------|---------|
| Gate timing | During/after static analysis, CI-triggered. PR-level: new-code conditions only |
| Regression detection | "Clean as You Code" — zero new issues condition on new code diff |
| Lint/format | SonarQube IS the analyzer. Quality profiles define active rules per language |
| Metrics & trending | **Best-in-class**: Activity page with configurable multi-metric graphs, event tracking (gate changes, version markers) |
| Configurability | **Highly configurable**: custom gates with any metric+operator+threshold. Fudge factor ignores conditions on <20 new lines |
| Validation feedback | PR decoration (pass/fail). Dashboard with gate status, metrics, issues. Email notifications |
| Recovery | No auto-fix. Failed gate = "don't merge." Manual fix + re-analyze |

### GitHub Actions Quality Workflows

| Dimension | Finding |
|-----------|---------|
| Gate timing | PR event-triggered status checks. Required vs optional via branch protection |
| Regression detection | Via third-party tools (Codecov, Coveralls). reviewdog `added` filter = new violations only |
| Lint/format | Workflow steps. `--output-format=github` for inline annotations. `continue-on-error` controls blocking |
| Metrics & trending | Third-party only (SonarCloud, Code Climate) |
| Configurability | Branch protection rules, rulesets, continue-on-error per step, per-tool thresholds |
| Validation feedback | Status checks, **PR inline annotations** (Checks API, 3 severities), Markdown summaries (64K) |
| Recovery | Manual fix + re-push. Some teams pair with AI agents for auto-fix |

### Pre-commit Hook Patterns (pre-commit.com, husky, lint-staged)

| Dimension | Finding |
|-----------|---------|
| Gate timing | Git hook trigger points (pre-commit, pre-push, commit-msg). lint-staged: staged files only |
| Regression detection | Not addressed directly. Can run tests but no baseline comparison |
| Lint/format | Primary use case. **Auto-fix + auto-re-stage** pattern. `fail_fast`, per-hook config, file-type filtering |
| Metrics & trending | None |
| Configurability | Per-hook: stages, file types, args, exclude, fail_fast, verbose. Meta-hooks validate config itself |
| Validation feedback | CLI stdout/stderr. Per-file processing status |
| Recovery | **Stash-and-restore**: backup state pre-run, restore on failure. Auto-fix as primary recovery |

### ESLint/Prettier CI Integration

| Dimension | Finding |
|-----------|---------|
| Gate timing | PR push via GitHub Actions. Pre-commit locally via husky/lint-staged |
| Regression detection | reviewdog `added` filter = only newly introduced violations |
| Lint/format | reviewdog for PR annotations. lint-action supports 20+ linters with auto-fix + auto-commit |
| Metrics & trending | Not built-in |
| Configurability | `--max-warnings 0`, reviewdog `fail_level` (none/any/info/warning/error), per-linter auto_fix toggle |
| Validation feedback | **PR inline annotations** on exact violation lines. Review comments with rule doc links |
| Recovery | Auto-fix + auto-commit pattern. Cannot push to forks |

---

## Comparison Matrix

| Framework | Gate Timing | Regression | Lint Integration | Trending | Configurability | Feedback | Recovery |
|-----------|------------|------------|-----------------|----------|----------------|----------|----------|
| Aider | Post-edit | Exit-code | Built-in + custom | None | Minimal | Raw to LLM | Unbounded retry |
| Superpowers | Post-edit | None | Tight, invisible | None | Rules (style) | Transparent fix | Auto-fix |
| GPT Pilot | Two-tier (step+task) | TDD suite | None | None | Depth limit | Test+cmd+human | Recursive debug (5 deep) |
| SWE-agent | **Edit-time** | None | Syntax in edit cmd | None | Not configurable | Error+snippet | Retry, discard bad |
| OpenHands | None (agent-directed) | CI-outsourced | None | None | Repo.md | CI→prompt inject | CI-to-prompt loop |
| Devin | Multi-point | Test suite | Knowledge/Playbooks | Org-level | Knowledge+Playbooks | **3-tier severity** | **Closed-loop CI** |
| OpenSpec | Pre-code + validate | Delta markers | Spec linting | None | --strict flag | Specific errors | Manual |
| BMAD | Multi-stage | Adversarial review | Checklists | Severity class | Min findings (controversial) | **Severity+validity** | Halt on 3 failures |
| MetaGPT | Post-generation | Spec-based | None | Research only | Retry limit (3) | Error traces | **Bounded retry** |
| Cursor | Post-edit + hooks | None | IDE diagnostics | None | Hooks (3-tier) | Injected messages | Lint loop + hooks |
| Cline | Real-time | Checkpoints | IDE monitoring | None | Per-action approve | Diff preview | **Checkpoint/restore** |
| Continue.dev | **PR-time AI** | Diff-based AI | **NL checks** | None | Markdown files | **Suggested fix diffs** | Fix suggestions |
| **WALT (current)** | Pre/post-apply | Baseline+count | Lint/format/type | **History+trends** | strict/lenient | **Structured reports** | Block/warn/skip |

### WALT's Current Strengths (vs field)
- **Only framework with quality trending** — history, trajectory, streaks, regression detection across phases
- **Structured before/after reports** — most frameworks give raw output
- **Configurable gate modes** — strict/lenient per category
- **Multi-category integration** — tests + lint + format + types in one system

### WALT's Gaps (vs best-in-class)
- **No severity classification** — everything is pass/fail, no bug vs warning vs FYI
- **No failure-to-context feedback** — blocks but doesn't help agent fix
- **No small-change exemption** — same gates for 1-line fix and 500-line feature
- **No bounded auto-fix retry** — blocks immediately, no retry attempt
- **No diff-based filtering** — gates on all findings, not just newly introduced
- **Recovery options limited** — fix/override/stop, no guided retry with context

---

## Candidate Techniques

| # | Technique | Source | Category |
|---|-----------|--------|----------|
| T1 | 3-tier severity classification (bug/warning/FYI) | Devin Review | Feedback |
| T2 | Failure-to-context injection (feed errors to agent for fix) | OpenHands, Aider | Recovery |
| T3 | Small-change exemption / fudge factor (<20 lines = soften gates) | SonarQube | Configurability |
| T4 | Bounded auto-fix retry (max N attempts before escalating) | MetaGPT, PALS TODD | Recovery |
| T5 | Diff-based filtering (gate only on new violations, not legacy) | reviewdog, Continue.dev | Regression |
| T6 | Suggested fix on failure (generate fix diff, not just report) | Continue.dev | Recovery |
| T7 | Advisory mode (surface findings but never block) | SonarQube soft gate | Configurability |
| T8 | Event-tagged history (tag entries with significant events) | SonarQube Activity | Trending |
| T9 | Config self-validation (check WALT config correctness) | pre-commit meta-hooks | Configurability |
| T10 | Two-tier test timing (fast per-task, full per-phase) | GPT Pilot | Gate timing |
| T11 | Checkpoint/restore on quality failure | Cline | Recovery |
| T12 | Natural-language quality checks as markdown | Continue.dev | Lint/format |
| T13 | Recursive debugging with depth limit | GPT Pilot | Recovery |
| T14 | Edit-time validation (reject before write) | SWE-agent | Gate timing |
| T15 | PR annotation output format | GitHub Actions/reviewdog | Feedback |
| T16 | Staged-only validation (check only changed files) | lint-staged | Gate timing |
| T17 | Zero-regression rate as tracked metric | SWE-CI benchmark | Trending |
| T18 | failClosed safety default (block on gate crash) | Cursor hooks | Configurability |

---

## Decision Table

| # | Technique | Decision | Rationale |
|---|-----------|----------|-----------|
| T1 | 3-tier severity (bug/warning/FYI) | **Adopt** | WALT's pass/fail is too coarse. Adding a FYI tier reduces noise while surfacing informational findings. Fits quality-runner and quality-lint reports cleanly. |
| T2 | Failure-to-context injection | **Adopt** | When WALT blocks, the agent has no guidance. Structuring failure data as actionable context (what failed, why, suggested fix direction) directly improves recovery. |
| T3 | Small-change exemption | **Adapt** | Full SonarQube fudge factor too complex. Simpler: if plan modifies ≤5 files and 0 test files, run lint/format gates in lenient mode regardless of config. Document as "lightweight gate for lightweight changes." |
| T4 | Bounded auto-fix retry | **Reject** | WALT is markdown-driven, not a runtime. Auto-fix retry is the agent's job (PALS apply-phase already has bounded retries via execution improvements in Phase 39). WALT should report, not retry. |
| T5 | Diff-based filtering | **Adapt** | Full reviewdog filtering requires file-level diff parsing WALT can't do. Simpler: note in regression detection that pre-existing failures (baseline) should not count as regressions — WALT already does this via baseline comparison. Add explicit guidance: "known failures in baseline are informational, not blocking." |
| T6 | Suggested fix on failure | **Reject** | Fix generation is the agent's domain, not the quality gate's. WALT should describe what failed clearly (T2), not generate code fixes. Keeps WALT's role clean. |
| T7 | Advisory mode | **Adopt** | Adding a third gate mode (`advisory`) alongside `strict`/`lenient` fills a real gap for prototyping/research phases. Advisory surfaces everything in reports but never blocks. |
| T8 | Event-tagged history | **Adapt** | Full SonarQube event system too heavy. Simpler: add an optional `event` column to quality-history table entries — "major refactor", "new module", "dependency upgrade" — to explain metric shifts. |
| T9 | Config self-validation | **Reject** | WALT config is minimal (strict/lenient per category). No complex config to validate. Over-engineering for current scope. |
| T10 | Two-tier test timing | **Reject** | WALT already runs at pre-apply (baseline) and post-apply (result). Adding per-task test runs would require post-task hooks that WALT doesn't register for — and would slow execution. TODD already handles per-task test quality. |
| T11 | Checkpoint/restore on failure | **Reject** | Git already provides this (revert specific files). PALS apply-phase handles partial failure recovery (Phase 39 improvements). Adding workspace snapshots duplicates existing mechanisms. |
| T12 | Natural-language quality checks | **Reject** | Interesting but fundamentally different paradigm. WALT uses deterministic tool output, not LLM judgment. NL checks would be inconsistent across runs. Better as a separate module (IRIS already does code review). |
| T13 | Recursive debugging | **Reject** | GPT Pilot's recursive debugging is an execution pattern, not a quality gate pattern. PALS's execution layer (apply-phase) handles debugging. WALT should gate, not debug. |
| T14 | Edit-time validation | **Reject** | SWE-agent's approach requires runtime integration (fused into edit command). WALT operates at phase boundaries via markdown hooks, not at edit time. Would require fundamental architecture change. |
| T15 | PR annotation output format | **Reject** | WALT outputs to terminal/reports, not GitHub. PR annotations require GitHub API integration that's outside WALT's scope. DAVE module handles deploy/CI concerns. |
| T16 | Staged-only validation | **Adapt** | Full lint-staged scoping requires file-level tracking. Simpler: add guidance that lint/format checks should scope to `files_modified` from the plan frontmatter when possible, not the entire project. Advisory, not enforced. |
| T17 | Zero-regression rate as metric | **Adopt** | Simple to compute: count plans with zero test regressions / total plans. Add to quality-trends.md as a new trend metric alongside streaks and stalls. |
| T18 | failClosed safety default | **Reject** | WALT already handles tool failures gracefully (Gate=SKIP, warn, continue). Adding a failClosed mode would block workflows when tools crash, which contradicts WALT's "don't block on tool issues" philosophy. |

### Summary

| Decision | Count | Techniques |
|----------|-------|------------|
| **Adopt** | 4 | T1 (3-tier severity), T2 (failure-to-context), T7 (advisory mode), T17 (zero-regression rate) |
| **Adapt** | 3 | T3 (small-change exemption), T5 (diff-based guidance), T8 (event-tagged history), T16 (scoped validation) |
| **Reject** | 11 | T4, T6, T9, T10, T11, T12, T13, T14, T15, T18 |

---

*Research completed: 2026-03-14*
*12 frameworks + 4 non-framework approaches analyzed across 7 dimensions*
