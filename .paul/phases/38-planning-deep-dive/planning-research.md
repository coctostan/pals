# Planning Deep-Dive: Cross-Framework Research

Research across 12 AI coding frameworks examining how each handles planning — from task decomposition through error recovery. Frameworks span IDE-integrated tools (Cursor, Cline, Continue.dev, Aider), autonomous agents (SWE-agent, OpenHands, Devin), multi-agent systems (MetaGPT, GPT Pilot), and methodology frameworks (OpenSpec, BMAD, Superpowers). Seven dimensions analyzed: decomposition, context gathering, scope control, plan structure, verification, error handling, and unique techniques.

---

## 1. OpenSpec

**Decomposition:** Strict 4-phase artifact chain: proposal → specs → design → tasks. Each capability gets its own spec file; design doc is conditional on complexity.
**Context:** Manual research of existing specs before defining capabilities. Configuration in `openspec/config.yaml`.
**Scope:** Each change gets its own directory. Completed changes archived. Design doc gated on necessity.
**Plan Structure:** YAML schema + Markdown artifacts. Directory per change containing `proposal.md`, `specs/`, `design.md`, `tasks.md`.
**Verification:** Schema dependency chain enforces phase ordering. Specs must include scenarios. Phase dependencies validated.
**Error Handling:** Pause and clarify. Delta operations use ADDED/MODIFIED/REMOVED semantics for incremental changes.
**Unique:** Schema-as-workflow-engine — `schema.yaml` serves as both artifact schema AND execution controller. Entire methodology portable in one YAML file.

## 2. BMAD

**Decomposition:** Role-based phases owned by persona agents (PM "John", Architect "Winston", SM "Bob"). Quick-flow agent "Barry" for solo devs.
**Context:** Dedicated `generate-project-context` workflow with 8 structured exploration areas.
**Scope:** Scale-adaptive depth. PM agent has VP (Validate PRD) checking comprehensiveness AND leanness. CC workflow for mid-implementation scope changes.
**Plan Structure:** Markdown with YAML frontmatter. Micro-file step architecture — each step is a self-contained instruction file loaded one at a time.
**Verification:** Separate validation workflows. Implementation Readiness (IR) check spans PRD, UX, architecture, and epics/stories.
**Error Handling:** Sequential step execution enforced. Steps halt at menus. CC workflow handles major mid-stream changes.
**Unique:** Persona-driven planning with enforced role boundaries + micro-file step architecture preventing context pollution.

## 3. Superpowers

**Decomposition:** Two-phase (brainstorming then writing-plans). Plans chunked at max 1000 lines. Each step targets 2-5 minutes of work.
**Context:** Explores project files, docs, commits. Plans must include exact file paths and complete code examples. Written for "enthusiastic junior engineer with no context."
**Scope:** Hard gate forbids ANY code until design approved. Multi-subsystem projects decomposed into sub-projects. YAGNI/DRY enforced.
**Plan Structure:** Markdown with chunks. Each task has minimum 5 checkbox steps (write failing test, run, implement, run, commit).
**Verification:** Subagent review loop per chunk (max 5 iterations). 5-step verification-before-completion gate.
**Error Handling:** Stop and ask, never force through. Same agent fixes its own plan. Escalate to human after 5 review loops.
**Unique:** "Enthusiastic junior engineer" test — forces extreme clarity by targeting someone with zero context. Context-isolated subagent dispatch for review.

## 4. Aider

**Decomposition:** No pre-planning. Single-shot with reflection loop (max 3). Architect Mode separates planning: architect model proposes, editor model executes.
**Context:** Tree-sitter repo map ranked with PageRank. Personalization weights (+50x for chat files, +10x for mentioned identifiers). Token budget with binary search for optimal file count.
**Scope:** Explicit `/add` file list. `.aiderignore`. `--subtree-only`. `allowed_to_edit()` gates. Auto-summarization on history overflow.
**Plan Structure:** No explicit plan document. SEARCH/REPLACE blocks inline. Architect Mode outputs natural language plan.
**Verification:** `apply_edits_dry_run()` validates before writing. Hierarchical matching cascade (exact → whitespace-flexible → fuzzy). Post-edit lint.
**Error Handling:** Failed edits show similar lines from actual file. Reflection loop retries after lint/test failures. Context overflow recovery.
**Unique:** PageRank-based repo map — tree-sitter call-graph ranked with PageRank for context selection, surfacing structurally important code.

## 5. Cline

**Decomposition:** Explicit Plan Mode vs Act Mode toggle. Plan Mode restricts tools to `read_file`, `search_files`, `plan_mode_respond` only. User switches to Act Mode for execution.
**Context:** FileContextTracker with timestamps (`cline_read_date`, `cline_edit_date`, `user_edit_date`). Chokidar file watchers detect external changes.
**Scope:** Model-specific token budgets with reserved buffers. Three truncation severities. Working directory hard-locked.
**Plan Structure:** `task_progress` Markdown checklist persisted as parameter on every tool call. Updated silently, survives context compaction.
**Verification:** Per-tool-call user confirmation. System prompt rules enforce verification behavior.
**Error Handling:** Checkpoint snapshots for recovery. Truncation validates tool_use/tool_result pairing integrity.
**Unique:** Plan Mode restricts tool palette — LLM literally cannot edit files until user approves plan. `task_progress` checklist survives compaction.

## 6. Continue.dev

**Decomposition:** No explicit multi-step planning. Chat + tool-call loop. Subagent delegation for agentic workflows.
**Context:** Pluggable context provider system. CodebaseContextProvider uses embedding-based semantic retrieval. `@mentions` for manual selection.
**Scope:** Token management with 2% safety buffer. Oldest-first message pruning. EditAggregator batches small edits.
**Plan Structure:** None — LLM conversational output IS the plan.
**Verification:** Streaming diff preview via async generator. Tool policies gate execution permissions.
**Error Handling:** Graceful degradation. PrefetchQueue for resilience through pre-computation.
**Unique:** Embedding-based semantic codebase retrieval as primary context mechanism, with pluggable provider architecture.

## 7. SWE-agent

**Decomposition:** No explicit plan. ReACT-style thought-action-observation loop. One command per turn. Planning is emergent from constraints.
**Context:** Purpose-built ACI tools: `find_file`, `search_dir`, `search_file`, `open` (100 lines at a time), `scroll`, `goto`. Results capped at 50.
**Scope:** Structural constraints enforce discipline — one command/turn, 100-line viewer, search caps, edit linting blocks invalid edits.
**Plan Structure:** Implicit only — exists in THOUGHT sections of trajectory. No explicit plan artifact.
**Verification:** Bug reproduction first. Edit linting gate blocks syntactically invalid changes before they land.
**Error Handling:** Edit rejection via linting. RetryAgent for multi-attempt strategies. Cost/token limits enforce termination.
**Unique:** ACI design > prompt engineering — planning quality shaped by tool design constraints rather than planning prompts.

## 8. OpenHands

**Decomposition:** Explicit 4-phase workflow: EXPLORATION → ANALYSIS → IMPLEMENTATION → VERIFICATION. Planning Agent writes `PLAN.md` in read-only mode.
**Context:** Unified code action space (Python/bash). Editor, Shell, Browser tools. Exploration directive requires understanding before proposing.
**Scope:** Re-plan on failure protocol. Planning Agent restricted to read-only tools + `PLAN.md` write. CODE_QUALITY section enforces exploration-first.
**Plan Structure:** Explicit `PLAN.md` file with templated sections (Current State, Implementation, Testing). Deep planning includes API signatures + validation strategy.
**Verification:** ANALYSIS as distinct step between exploration and implementation. Read-only constraint prevents jumping to code.
**Error Handling:** TROUBLESHOOTING prompt section. Re-planning protocol. AgentDelegateAction for specialized sub-agents. Mode switching.
**Unique:** Dual-mode Plan/Execute with read-only constraint — planning agent literally cannot modify code, only write `PLAN.md`.

## 9. Devin

**Decomposition:** Compound AI system with dedicated Planner model (separate from Coder). Plan → implement chunk → test → fix → checkpoint review → next chunk.
**Context:** Indexes main branch at session start. Preliminary plan includes relevant files, key findings, implementation questions, code citations with IDE deep-links.
**Scope:** ACU limits (10 max/session). Interactive approval gate (30s window or explicit). Playbook guardrails with Forbidden Actions + Specifications.
**Plan Structure:** Explicit, user-visible, editable in UI. Step-by-step with code citations. Playbooks (`.devin.md`) as reusable templates.
**Verification:** Planner self-critiques each step. Separate Critic model reviews for security/logic errors. Plan → code → sandbox test → critic review.
**Error Handling:** Dynamic re-planning. Debugger agent analyzes failures. Critic loop catches issues. Weaker with mid-task requirement changes.
**Unique:** Multi-model compound planning — architecturally separate models for planning, coding, and review. Playbook persistence across sessions.

## 10. Cursor

**Decomposition:** Agent mode dynamically determines steps. Plan Mode (Shift+Tab) separates: ask questions → research → plan → user review → build.
**Context:** RAG-based codebase indexing. Chunked at function granularity, embedded, stored in vector DB. `grep` for exact matches, semantic search for conceptual. `.cursor/rules/` with globs auto-inject.
**Scope:** Fresh conversations when shifting tasks. `@Past Chats` for selective context. Rules should be narrow and focused.
**Plan Structure:** Editable Markdown files saved to `~/` or `.cursor/plans/` for team sharing. Free-form, not rigid schema.
**Verification:** Two-stage rule activation (glob injection + semantic relevance evaluation). User reviews plan before build. Revert and refine if execution diverges.
**Error Handling:** No formal re-planning. Revert, refine, re-run. Rules added reactively after repeated mistakes.
**Unique:** `.mdc` rule format with two-stage activation — glob-based injection + AI semantic relevance evaluation. Soft routing for instructions.

## 11. MetaGPT

**Decomposition:** 5-role sequential waterfall: PM → Architect → Project Manager → Engineer → QA. ActionNode trees with typed, validated outputs.
**Context:** Publish-subscribe message architecture. Downstream agents subscribe selectively by role. No vector search — structured document flow only.
**Scope:** Enforced cardinality (max 3 product goals, 3-5 user stories). Pydantic validation prevents hallucinated or missing content.
**Plan Structure:** PRD with typed fields (Language, Goals, User Stories, Competitive Analysis, Requirements with P0/P1/P2). JSON/Markdown enforced by ActionNode.
**Verification:** Three-template review cycle per node: SIMPLE → REVIEW → REVISE. Classifies new requirements as BUG vs REQUIREMENT.
**Error Handling:** 3-retry debug loop. Incremental requirement merging. Relatedness check before creating/refining documents.
**Unique:** Structured document schemas as inter-agent contracts — Pydantic-validated ActionNode trees with generate-review-revise triple.

## 12. GPT Pilot

**Decomposition:** 4-agent pipeline: Spec Writer → Architect → Tech Lead → Developer. Hierarchy: epics → tasks → steps (4 types: COMMAND, SAVE_FILE, HUMAN_INTERVENTION, UTILITY_FUNCTION).
**Context:** `get_relevant_files_parallel()` identifies contextually important files. Architect validates tech choices by running test commands locally.
**Scope:** Complexity classification (SIMPLE/MODERATE/COMPLEX) gates planning depth. Technology blocklist. `remove_duplicate_steps()`. Dual goals per task.
**Plan Structure:** Specification → Architecture → Development Plan (epics) → Tasks → Steps. Conversational approval/rejection, not user-editable Markdown.
**Verification:** Multi-gate human approval. Spec diffs shown. Architect runs dependency test commands. XML tag validation with 2 retries. Dual-goal tasks.
**Error Handling:** 2-retry for malformed responses. Recursive debugging with human escalation at depth > 5. Iteration branching.
**Unique:** Dual-goal task validation — every task has TWO completion criteria (programmatic test + human review) defined at planning time.

---

## Cross-Cutting Comparison Matrix

| Framework | Explicit Plan Artifact | Plan/Execute Separation | Human Gate | Auto-Verification | Re-planning | Context Strategy |
|---|---|---|---|---|---|---|
| OpenSpec | Yes (multi-file) | Yes (phase chain) | Per-phase | Schema validation | Delta ops | Manual research |
| BMAD | Yes (micro-files) | Yes (role-based) | Menu halts | IR check | CC workflow | 8-area exploration |
| Superpowers | Yes (chunked MD) | Yes (hard gate) | Design approval | Subagent review x5 | Same-agent fix | File/doc/commit scan |
| Aider | No | Architect Mode only | No | Dry-run + lint | Reflection x3 | PageRank repo map |
| Cline | Checklist (inline) | Yes (mode toggle) | Per-tool-call | User confirmation | Checkpoint revert | File tracker + watchers |
| Continue.dev | No | No | No | Diff preview | No | Embedding retrieval |
| SWE-agent | No (implicit) | No | No | Edit linting | RetryAgent | Purpose-built ACI |
| OpenHands | Yes (PLAN.md) | Yes (read-only lock) | No | Analysis phase | Re-plan on failure | Unified action space |
| Devin | Yes (UI-editable) | Yes (separate models) | 30s approval | Critic model | Dynamic re-plan | Branch indexing |
| Cursor | Yes (optional MD) | Yes (Plan Mode) | Plan review | Rule activation | Revert + refine | RAG + vector DB |
| MetaGPT | Yes (typed PRD) | Yes (role pipeline) | No | Review-revise triple | Requirement merge | Pub-sub documents |
| GPT Pilot | Yes (hierarchy) | Yes (agent pipeline) | Multi-gate | Dual-goal + test | Recursive debug | Parallel file retrieval |

| Framework | Plan Granularity | Scope Control Mechanism | Error Recovery Style |
|---|---|---|---|
| OpenSpec | Capability-level specs | Directory-per-change + archival | Pause and clarify |
| BMAD | Micro-file steps | Scale-adaptive + leanness check | Halt at menus |
| Superpowers | 2-5 min steps, 1000-line chunks | YAGNI/DRY + sub-project decomposition | Stop and ask (escalate at 5) |
| Aider | Single-shot | File whitelist + subtree lock | Reflection loop (max 3) |
| Cline | Checklist items | Token budget + 3 truncation levels | Checkpoint snapshots |
| Continue.dev | Conversational | 2% buffer + oldest-first pruning | Graceful degradation |
| SWE-agent | Per-turn commands | Tool constraints (100-line cap) | Edit rejection + retry |
| OpenHands | 4-phase workflow | Read-only planning constraint | Re-plan protocol |
| Devin | Chunk-per-cycle | ACU limits + playbook guardrails | Debugger agent |
| Cursor | Free-form steps | Fresh conversations + focused rules | Revert and refine |
| MetaGPT | Typed document fields | Pydantic cardinality enforcement | 3-retry + merge |
| GPT Pilot | Epic → task → step types | Complexity classification gates | Recursive debug (depth > 5 escalation) |

---

## Decisions: Adopt / Adapt / Reject

| # | Technique (Source) | Decision | Rationale | Implemented |
|---|---|---|---|---|
| 1 | Plan/Execute Read-Only Separation (OpenHands) | **Adapt** | Added read-only constraint instruction to validate_preconditions | ✓ plan-phase.md |
| 2 | Dual-Goal Task Validation (GPT Pilot) | **Adopt** | Clarified verify=programmatic, done=human-reviewable in validate_plan | ✓ plan-phase.md |
| 3 | Schema-as-Workflow-Engine (OpenSpec) | **Reject** | Contradicts PALS markdown-based simplicity | — |
| 4 | "Junior Engineer" Clarity Test (Superpowers) | **Adopt** | Added clarity test question to validate_plan step | ✓ plan-phase.md |
| 5 | PageRank Repo Map (Aider) | **Reject** | Requires tree-sitter/Python; deferred in Phase 36 | — |
| 6 | Multi-Model Compound Planning (Devin) | **Reject** | PALS is model-agnostic markdown; not applicable | — |
| 7 | Tool Palette Restriction by Mode (Cline) | **Reject** | PALS runs as prompts, can't restrict tools at runtime | — |
| 8 | Validated Plan Schemas (MetaGPT) | **Adapt** | Merged into existing validate_plan as checklist, not Pydantic | ✓ plan-phase.md |
| 9 | Complexity-Gated Planning Depth (GPT Pilot) | **Adopt** | Added change-size heuristic to analyze_scope step | ✓ plan-phase.md |
| 10 | Checkpoint + Re-plan Protocol (OpenHands/Devin) | **Defer** | Belongs in Phase 39 (Execution Deep Dive), not planning | — |
