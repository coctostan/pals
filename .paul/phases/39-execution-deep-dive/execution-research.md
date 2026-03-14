# Execution Deep-Dive: Cross-Framework Research

Research across 12 AI coding frameworks examining how each handles code execution — from edit formats through error recovery and re-planning. Frameworks span IDE-integrated tools (Cursor, Cline, Continue.dev, Aider), autonomous agents (SWE-agent, OpenHands, Devin), multi-agent systems (MetaGPT, GPT Pilot), and methodology frameworks (OpenSpec, BMAD, Superpowers). Seven dimensions analyzed: edit format, context management during execution, task decomposition at runtime, error recovery, rollback strategy, step verification, and re-plan/divergence detection.

---

## 1. Aider

**Edit format:** SEARCH/REPLACE blocks with 4-level matching cascade: exact → whitespace-insensitive → indentation-preserving → fuzzy (difflib edit distance). Also supports whole-file, udiff, diff-fenced, and editor-diff formats selectable via `--edit-format`. Disabling flexible patching causes 9x increase in editing errors. Failed matches generate detailed mismatch feedback fed back to LLM.
**Context management:** Full chat history sent each turn. `ChatSummary` auto-summarizes older history when approaching `max_chat_history_tokens`. No incremental refresh — full file contents re-sent each turn.
**Task decomposition:** None explicit. Single LLM call + reflection loop. Architect Mode separates: architect model proposes, editor model executes.
**Error recovery:** Reflection loop, `max_reflections=3`. Failed edits, lint failures, and test failures all feed error output back to LLM for correction. After 3 reflections, execution halts with partial edits applied.
**Rollback:** Git auto-commit after each edit (Conventional Commits format). `/undo` reverts last aider commit. Dirty files pre-committed separately. Rollback is commit-granular, not edit-granular.
**Verification:** Auto-lint after each edit (built-in or `--lint-cmd`). Auto-test if configured via `--test-cmd` + `--auto-test`. Results feed reflection loop.
**Re-plan/divergence:** None formal. Match failures signal file drift. Max reflections is the only guardrail.

## 2. Cline

**Edit format:** Tool-based: `replace_in_file` (SEARCH/REPLACE with lenient matching) and `write_to_file` (full rewrite). All edits flow through `DiffViewProvider` — two-pane diff editor with streaming updates. Known reliability issues with `replace_in_file` in long sessions.
**Context management:** 3 specialized trackers: `FileContextTracker` (file ops with timestamps, stale detection via filesystem watchers), `ModelContextTracker` (token consumption), `EnvironmentContextTracker` (terminal state). Read deduplication via `dedupReadFileTools()`. Auto Compact at ~80% context usage. Configurable truncation strategies (half/quarter). Context persisted to `tasks/{taskId}/context_history.json`.
**Task decomposition:** Plan & Act two-phase. Plan Mode (read-only tools) → Act Mode (full tool access). Separate models configurable per phase. No automatic decomposition — sequential agent loop, LLM decides next action.
**Error recovery:** Human-in-the-loop per tool call via `Task.ask()`. No automatic retry. `attempt_completion` flow allows user reject + feedback. `.clineIgnore` blocks protected paths.
**Rollback:** Shadow git checkpoint system via `CheckpointTracker`. Auto-checkpoints on every change. Per-step rollback (not just last). `revertChanges()` handles new files (delete) and existing files (restore original).
**Verification:** Visual diff review before apply. VS Code diagnostics feedback (`newProblemsMessage`). Browser automation for visual verification. User can edit proposed changes in diff view.
**Re-plan/divergence:** `FileContextTracker` detects stale context (external file changes). Manual re-plan via mode switch. No formal drift detection.

## 3. Continue.dev

**Edit format:** Edit Mode uses instant apply with synchronous diff computation. Agent Mode uses `createFile` and `editExistingFile` tools. No context beyond current file in Edit Mode.
**Context management:** Pluggable context providers (`@File`, `@Code`, `@Docs`, `@Terminal`, `@Git Diff`, `@Repo Map`). `.continue/rules` for persistent project context. No auto-refresh during edits.
**Task decomposition:** None in Edit Mode. Agent Mode uses standard tool-use loop. Plan Mode available but no formal plan→execute handoff.
**Error recovery:** Agent Mode returns errors to LLM. No retry limits. No recovery in Edit Mode.
**Rollback:** Accept/reject binary choice in Edit Mode. No rollback in Agent Mode. No shadow git or checkpoints.
**Verification:** Visual diff only. No automated lint/test. Agent can run tests but must decide to.
**Re-plan/divergence:** None. Purely LLM-emergent behavior.

## 4. SWE-agent

**Edit format:** Custom ACI (Agent-Computer Interface): `str_replace` (exact match, must be unique), `insert` (after line), `create`, `view` (100-line sliding window with line numbers), `undo_edit`. Line-numbered viewing forces explicit navigation.
**Context management:** Full history in prompt. `state_command` returns JSON (open file, cwd, cursor position) after every action. 100-line viewing window is deliberate context constraint. Token overflow is unrecoverable error.
**Task decomposition:** None. Single action loop: `step()` → model query → action parse → environment communicate → observation. LLM plans implicitly.
**Error recovery:** Automatic lint gate after every edit (flake8/eslint/shellcheck). New lint errors → edit rejected and file restored from backup. 51.7% of trajectories contain at least one failed edit. Recovery probability 90.5% on first attempt, drops to 57.2% after prior failure. `RetryAgent` handles API failures (exponential backoff, max 20 retries).
**Rollback:** Per-edit file backup + `undo_edit`. Lint failures auto-revert. No git checkpoints. Disposable Docker container.
**Verification:** Automatic linting after every edit. Test-patch verification post-execution (not mid-execution). Trajectory files (`.traj`) for post-hoc analysis.
**Re-plan/divergence:** None. No plan = no divergence. Only max iterations and cost limits as guardrails.

## 5. OpenHands

**Edit format:** `FileEditAction` (targeted partial edits, generates diffs), `FileWriteAction` (whole-file). Legacy `edit_file_by_replace` deprecated due to causing suboptimal behavior. V1 SDK uses typed tool system via `ActionExecutionServer`.
**Context management:** Condenser system with multiple strategies: `LLMSummarizingCondenser` (default, summarizes when exceeding `max_size`), `ObservationMaskingCondenser`, `RecentEventsCondenser`, `AmortizedForgettingCondenser`. Condensation reduces costs up to 2x with equivalent performance. First N events always preserved.
**Task decomposition:** Single-agent action loop (CodeAct). Can execute Python, bash, file edits, browse web. `AgentController` manages loop. Sub-agent delegation supported but not commonly used.
**Error recovery:** `ErrorObservation` events flow back to agent. No automatic action retry. Security analyzer validates actions. Max iterations cap.
**Rollback:** No built-in rollback. Disposable container. EventStream preserves full history for theoretical replay.
**Verification:** No automatic linting. Agent-driven verification (must choose to run tests). Stuck detector as meta-verification.
**Re-plan/divergence:** **Stuck Detector** (enabled by default) monitors 5 patterns: repeating action-observation (4+ times), repeating action-error (3+ times), agent monologue (3+ consecutive), alternating patterns (6+ cycles), context window errors. Semantic comparison (tool name + content + thought). Auto-halts on detection.

## 6. Devin

**Edit format:** Full IDE environment (VS Code fork). Standard editor operations. No public documentation on internal edit representation.
**Context management:** Devin Wiki (auto-indexes repos every few hours), Devin Search (agentic codebase exploration with Deep Mode), Repo Knowledge (structured knowledge from connected GitHub orgs). Knowledge base + retrieval approach vs. context window stuffing. Memory versioned with checkpoints.
**Task decomposition:** Explicit planner-executor architecture. Planner LLM expands goals into steps, self-critiques. Universal Planner (v2.0+) handles loops. Playbooks for recurring tasks with per-step retry.
**Error recovery:** Autonomous compile-test-iterate loop until green. Human chat intervention when stuck. Dynamic re-planning (v3.0) — alters strategy autonomously. Checkpoint restore with hints for retry.
**Rollback:** Full checkpoint/timeline system — scrub and restore both files AND memory. Machine Snapshots (~15s, save entire VM state). Session fork for parallel execution paths. Playbook step retry after rollback.
**Verification:** Compile-test loop per step. Interactive plan review before execution. Deviation notification when plan diverges.
**Re-plan/divergence:** **Deviation detection + notification** — informs user of notable plan departures. Dynamic re-planning (v3.0) — autonomous strategy alteration on roadblocks. Plans treated as living documents.

## 7. MetaGPT

**Edit format:** Whole-file rewrite, one file at a time. LLM returns complete file in markdown code block, parsed by `CodeParser.parse_code()`.
**Context management:** Per-file: design doc + task doc + all sibling files as full code blocks via `get_codes()`. Incremental mode injects ALL repo files. Debug logs from prior test runs included.
**Task decomposition:** Project Manager produces ordered file list. Engineer processes sequentially, one file per `WriteCode` invocation. No sub-step decomposition within a file.
**Error recovery:** `tenacity` retry (6 attempts, exponential backoff) for API calls. Test failure → `DebugError` invoked with code + test + stderr → rewrite. Max 3 debug cycles before accepting.
**Rollback:** None. Iterate forward. After 3 retries, last version accepted regardless.
**Verification:** `WriteCodeReview` loop (LGTM/LBTM, configurable iterations). QA Engineer runs tests via `subprocess.Popen`. Review has 6 structured questions.
**Re-plan/divergence:** None. Fixed file list, never revised during execution.

## 8. GPT Pilot

**Edit format:** Hybrid: CodeMonkey produces complete new file content. Changes reviewed via unified diff with per-hunk decisions: APPLY/IGNORE/REWORK. Steps strongly typed: SAVE_FILE, COMMAND, HUMAN_INTERVENTION, UTILITY_FUNCTION.
**Context management:** 3-step contextual code fetching before each step: select files → narrow to functions → fetch actual code. `FileDescription` metadata (summary + references) enables intelligent selection. Conversation slicing (`convo.slice(3, limit)`) when conversations grow.
**Task decomposition:** Developer agent breaks tasks into typed `TaskSteps` via structured JSON output (`require_schema(TaskSteps)`). Orchestrator dispatches: SAVE_FILE → CodeMonkey, COMMAND → Executor, HUMAN_INTERVENTION → wait.
**Error recovery:** `MAX_CODING_ATTEMPTS=3` (CodeMonkey retries). `MAX_REVIEW_RETRIES=2`. Troubleshooter agent for user-reported issues. `LOOP_THRESHOLD=3` triggers `try_next_alternative_solution()`. Bug Hunter agent for systematic investigation. Recursion depth 5 → halt + human intervention.
**Rollback:** Database state snapshots. Rewindable to any development step. `state_manager.save_file()` persists changes.
**Verification:** 3-tier: automated tests (regression suite), command runs with LLM output analysis, human verification. Executor runs commands with user approval. Troubleshooter generates `TestSteps` for user validation.
**Re-plan/divergence:** Iteration-based — `IterationStatus` enum tracks states (FIND_SOLUTION → IMPLEMENT_SOLUTION → AWAITING_USER_TEST → PROBLEM_SOLVER). New iterations patch current task. Loop detection (3+ iterations) → alternative solutions or human escalation.

## 9. Superpowers

**Edit format:** Delegated to host harness (Claude Code Edit, Codex, etc.). Framework constrains process, not edit format.
**Context management:** Strict isolation — each subagent gets fresh context, never inherits session history. Controller pre-digests plan and provides exactly what each subagent needs. Subagents never read plan directly.
**Task decomposition:** Bite-sized tasks (2-5 min each). Sequential dispatch (no parallel implementation — conflict risk). Model selection by complexity: cheap for mechanical, standard for integration, capable for architecture.
**Error recovery:** 4-status protocol: DONE → proceed. DONE_WITH_CONCERNS → assess. NEEDS_CONTEXT → provide + re-dispatch. BLOCKED → assess: context problem / needs reasoning (upgrade model) / too large (decompose) / plan wrong (escalate to human). Fix subagent dispatched for failures (controller never fixes directly).
**Rollback:** Git worktrees for branch isolation. `using-git-worktrees` skill required before implementation. Discard option at completion. No mid-task rollback — review loop catches bad changes, implementer fixes forward.
**Verification:** Mandatory TDD: RED (failing test) → verify RED → GREEN (minimal passing code) → verify GREEN → REFACTOR. Two-stage review gate: spec compliance review then code quality review (separate subagents). Final whole-project review after all tasks.
**Re-plan/divergence:** No autonomous re-plan. BLOCKED status escalates to human. Spec compliance review catches over-building and under-building (plan drift). Framework philosophy: plans should be right before execution begins.

## 10. OpenSpec

**Edit format:** Edit-format agnostic — delegates to host tool. Owns delta operations (ADDED/MODIFIED/REMOVED/RENAMED) for specs only.
**Context management:** Dynamic instruction generation: project context + artifact rules + template content. Dependency content auto-injected. Clean context window recommended before `/opsx:apply`.
**Task decomposition:** Artifact dependency graph (BLOCKED/READY/DONE). Non-linear execution possible — any READY artifact actionable. Checkbox tasks in `tasks.md`.
**Error recovery:** No automated retry. Git reset as recovery. `/opsx:continue` for resuming after manual fix. Validation gates before archiving.
**Rollback:** Git is the rollback mechanism. Directory-per-change isolation allows discard. Delta specs not merged until explicit `/opsx:sync`.
**Verification:** `/opsx:verify` with Zod schemas + custom rules. `ValidationReport` with errors/warnings/info. Strict mode promotes warnings to errors.
**Re-plan/divergence:** Artifacts described as "fluid — update anytime." `/opsx:sync` reconciles drift. No formal divergence detection.

## 11. BMAD

**Edit format:** Edit-format agnostic — delegates to host tool. Owns workflow structure and step sequencing only.
**Context management:** JIT step loading (each step file loads only when prior completes). Document sharding (90% token savings). `project-context.md` as constitutional document. Path variable resolution.
**Task decomposition:** SM shards epics → stories with dependency chains. Shard-code-test micro-loop. Sequential step files with HALT enforcement.
**Error recovery:** Halt-and-report — developer agent stops and reports conflicts, never improvises. HALT commands force execution stops. No automated retry. "Obedient craftsman" design.
**Rollback:** Git only. SHA256 manifest tracks file modifications. Forward-only state machine (no step rollback by design).
**Verification:** `stepsCompleted[]` audit trail. PO validates PRD/architecture alignment. QA code review. Developer runs tests/lint. Enterprise CI/CD gates. HALT as human checkpoint.
**Re-plan/divergence:** Prevented architecturally — HALT enforcement, sequential loading, constrained action menus. Conflicts trigger halt, not adaptation. Constitutional checks via `project-context.md`.

## 12. Cursor

**Edit format:** Two-stage: frontier LLM generates changes, then Apply Model (fine-tuned Llama-3-70B) performs full-file rewrite. ~1000 tok/s via speculative edits (original file as draft token prior). Search/replace blocks for diffs (robustness over line-numbered hunks). Tab completions, Cmd+K inline, Composer multi-file.
**Context management:** Semantic codebase indexing. Agent finds files on-demand via grep + semantic search. `.cursor/rules/` for persistent instructions. `@Past Chats` for selective history. Parallel agents in isolated git worktrees.
**Task decomposition:** Plan Mode generates editable step-by-step plans (stored in `.cursor/plans/`). Agent Mode executes multi-step workflows autonomously. Up to 8 parallel agents from single prompt. Cloud agents create branches + PRs.
**Error recovery:** Autonomous error loop: execute → read terminal → fix → retry. Debug Mode with runtime instrumentation. Agent Review for line-by-line issue detection. Recommended recovery: revert → refine plan → re-run.
**Rollback:** Automatic checkpoints before significant changes (local, separate from git). Per-agent undo. Git worktree isolation for parallel agents. Previously rejected changes revisitable.
**Verification:** Auto-run terminal commands (tests/lint/builds). Hook system (`.cursor/hooks/`). Typecheck enforcement. Real-time diff view. Agent Review pass. Selective accept/reject.
**Re-plan/divergence:** Plan Mode revert-and-refine pattern. New conversations recommended when agent loses focus. Multi-agent comparison (run parallel approaches, merge best). No automated drift detection.

---

## Comparison Matrix

### Edit Format

| Framework | Approach | Granularity | Key Innovation |
|-----------|----------|-------------|----------------|
| Aider | SEARCH/REPLACE blocks | Block-level | 4-level matching cascade (exact→fuzzy) |
| Cline | Tool-based (replace_in_file) | Block-level | DiffViewProvider with streaming |
| Continue.dev | Instant apply | Region-level | Sync diff computation |
| SWE-agent | str_replace (exact match) | Block-level | 100-line window forces navigation |
| OpenHands | FileEditAction (diffs) | Block-level | Typed action system |
| Devin | Full IDE editor | Character-level | VS Code fork |
| MetaGPT | Whole-file rewrite | File-level | One file at a time |
| GPT Pilot | Whole-file + diff review | Hunk-level | Per-hunk APPLY/IGNORE/REWORK |
| Superpowers | Delegated to harness | Varies | Process constraints, not edit format |
| OpenSpec | Delegated to harness | Varies | Delta semantics for specs |
| BMAD | Delegated to harness | Varies | JIT step loading |
| Cursor | Two-stage (generate + apply) | File-level | Speculative edits at 1000 tok/s |

### Error Recovery

| Framework | Auto-Retry | Max Retries | Escalation Path |
|-----------|-----------|-------------|-----------------|
| Aider | Yes (reflection loop) | 3 | Halt with partial edits |
| Cline | No (human per tool call) | N/A | User feedback |
| Continue.dev | No | N/A | User cancels |
| SWE-agent | Yes (lint auto-revert) | Per-edit | Max iterations/cost |
| OpenHands | No | N/A | Stuck detector halts |
| Devin | Yes (compile-test loop) | Unlimited | Dynamic re-plan / human chat |
| MetaGPT | Yes (debug cycle) | 3 | Accept last version |
| GPT Pilot | Yes (multi-level) | 3 coding + 5 recursion | Alternative solutions → human |
| Superpowers | No (status protocol) | N/A | Model upgrade → decompose → human |
| OpenSpec | No | N/A | Manual fix + continue |
| BMAD | No (halt-and-report) | N/A | Human always |
| Cursor | Yes (error loop) | Unlimited | Revert + refine plan |

### Rollback Strategy

| Framework | Mechanism | Granularity | Auto/Manual |
|-----------|-----------|-------------|-------------|
| Aider | Git auto-commit + /undo | Commit | Manual (/undo) |
| Cline | Shadow git checkpoints | Per-step | Manual (click checkpoint) |
| SWE-agent | File backup + undo_edit | Per-edit | Auto (lint fail) + Manual |
| OpenHands | None (disposable container) | Session | Manual (discard) |
| Devin | Checkpoint timeline + VM snapshots | Per-checkpoint | Manual (scrub timeline) |
| MetaGPT | None | N/A | N/A |
| GPT Pilot | Database state snapshots | Per-step | Manual (rewind) |
| Superpowers | Git worktrees | Per-branch | Manual (discard branch) |
| Cursor | Automatic checkpoints + worktrees | Per-change | Manual (click checkpoint) |
| Continue.dev | Accept/reject only | Per-edit | Manual |
| OpenSpec | Git + directory isolation | Per-change | Manual |
| BMAD | Git only | Per-commit | Manual |

### Re-plan/Divergence Detection

| Framework | Detection | Response | Automated? |
|-----------|-----------|----------|------------|
| Aider | Match failures only | Reflection retry | Partial |
| Cline | Stale context (file watchers) | Manual mode switch | Partial |
| SWE-agent | None | Max iterations | No |
| **OpenHands** | **Stuck detector (5 patterns)** | **Auto-halt** | **Yes** |
| **Devin** | **Deviation notification** | **Dynamic re-plan (v3.0)** | **Yes** |
| MetaGPT | None | Fixed plan | No |
| **GPT Pilot** | **Loop detection (3+ iterations)** | **Alternative solutions → human** | **Yes** |
| Superpowers | Spec compliance review | Fix code to match plan | Partial |
| OpenSpec | None | Manual artifact update | No |
| BMAD | Prevented architecturally | HALT | No |
| Cursor | None (human reviews diffs) | Revert + refine plan | No |
| Continue.dev | None | N/A | No |

---

## Decision Table

Based on cross-framework analysis, final adopt/adapt/reject decisions for apply-phase.md:

| # | Technique | Source | Decision | Rationale | Impact |
|---|-----------|--------|----------|-----------|--------|
| 1 | Stuck/loop detection | OpenHands | **Adopt** | Detects unproductive patterns (3+ same errors, alternating states). Prevents wasted iterations. | Added to handle_failures step |
| 2 | Deviation notification | Devin | **Adopt** | Per-task plan-vs-actual comparison catches drift before it compounds. | Added as divergence check in execute_tasks |
| 3 | Revert-and-refine pattern | Cursor | **Adopt** | When approach fails, revert + refine plan beats iterating on broken approach. | Added as escalation option in handle_failures |
| 4 | Bounded reflection retries | Aider | **Adapt** | Max 2 retries per task, then escalate. Lighter than Aider's 3 + reflection loop. | Formalized in handle_failures bounded retry |
| 5 | Structured completion status | Superpowers | **Adapt** | PASS/PASS_WITH_CONCERNS/BLOCKED (3 states vs Superpowers' 4). More nuanced than binary PASS/FAIL. | Enhanced result recording in execute_tasks |
| 6 | Re-plan protocol | Phase 38 deferred | **Adapt** | 3-tier response (continue/adapt/re-plan) based on accumulated deviation severity. | Added as re-plan trigger assessment in track_progress |
| 7 | Lint-gate auto-revert | SWE-agent | **Reject** | PALS doesn't control the edit layer; host tool handles linting. | N/A |
| 8 | Per-hunk review | GPT Pilot | **Reject** | Adds process overhead; PALS checkpoint system covers review needs. | N/A |
| 9 | 3-step context fetching | GPT Pilot | **Reject** | PALS uses @-references and Agent tool; different paradigm. | N/A |
| 10 | Checkpoint timeline | Devin/Cline/Cursor | **Reject** | Git commits already serve this role in PALS workflow. | N/A |
| 11 | Context isolation for subagents | Superpowers | **Reject** | PALS subagents already get fresh context via Agent tool. | N/A |
| 12 | Conversation slicing | GPT Pilot | **Reject** | Handled by Claude's auto-compression; not PALS's concern. | N/A |

**Summary:** 3 adopted, 3 adapted, 6 rejected. All improvements merged into existing apply-phase.md steps (zero new steps added). Re-plan protocol (deferred from Phase 38) implemented.

---

*Research completed: 2026-03-14*
*12 frameworks × 7 dimensions analyzed*
