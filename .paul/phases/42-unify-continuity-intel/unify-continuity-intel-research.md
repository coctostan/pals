# UNIFY, Continuity & Codebase Intelligence — Competitive Research

**Date:** 2026-03-14
**Phase:** 42 of 42 — v1.1 Deep Competitive Audit
**Frameworks analyzed:** 15 (12 agentic frameworks + 3 non-framework tools)

---

## Research Methodology

4 parallel research subagents, each analyzing 3 frameworks across 3 domains:
- **Batch 1:** Superpowers/10x, Aider, GPT Pilot
- **Batch 2:** SWE-agent, OpenHands, Devin
- **Batch 3:** OpenSpec/BMAD, MetaGPT, Cursor
- **Batch 4:** Cline, Continue.dev, Windsurf + tree-sitter, LSP, ctags

---

## Domain 1: Reconciliation (UNIFY Equivalent)

### Comparison Matrix

| Framework | Plan vs Actual | Deviation Tracking | Retrospectives | State Write-Back | Loop Closure | Learning from Outcomes | Phase Transitions |
|-----------|---------------|-------------------|----------------|-----------------|-------------|----------------------|-------------------|
| Superpowers/10x | Not present | Not present | Not present | Partial (10X.md) | Not present | Not present | Not present |
| Aider | Indirect (lint/test loop) | Git diff (manual) | Not present | Not present | Partial (auto-lint/test) | Not across sessions | Not present |
| GPT Pilot | Indirect (Reviewer agent) | Task status state machine | Not present | Yes (DB snapshots) | Yes (Reviewer→CodeMonkey) | Within-project knowledge_base | Yes (Epics→Tasks→Steps) |
| SWE-agent | Not present | Not present | Not present | Not present | Not present | Manual (trajectory→demo) | Not present |
| OpenHands | Not present | Not present | Not present (Condenser = compression) | Not present | Not present | Not present | Not present |
| Devin | Session Insights (post-hoc) | Issue timeline | Yes (3 artifacts) | Not present | Yes (Insights→relaunch) | Partial (Knowledge flagging) | Not present |
| BMAD | Not present | Not present | Not present | Not present | Loose (bmad-help) | Not present | Agent persona handoff |
| MetaGPT | WriteCodeReview (LGTM/LBTM) | code_todos + _is_pass() | Code summaries only | Yes (shared memory + JSON) | Partial (review loop) | Static examples only | SOP message-watching |
| Cursor | Not present | Manual (user-driven) | Not present | Plans saved to workspace | Not present | Manual (Rules) | Not present |
| Cline | Not present | Not present | Manual (Memory Bank) | Manual trigger | Not present | Not present | new_task handoff |
| Continue.dev | Not present | Not present | Not present | Manual (rules files) | Not present | Not present | Not present |
| Windsurf | Partial (plan revised in-place) | Background agent revises plan | Auto-summarization | Autonomous memory gen | Partial (plan+memory) | Via Memories system | Background planning agent |

### Key Findings

**No framework has a formal plan-vs-actual reconciliation loop equivalent to PALS UNIFY.** This is a genuine differentiator.

**Closest approaches:**
1. **Devin Session Insights** — post-hoc retrospective with 3 artifacts (issue timeline, improved prompt, Knowledge evaluation). Human-triggered, not embedded in execution architecture.
2. **MetaGPT WriteCodeReview** — compares implementation against System Design, returns LGTM/LBTM with ordered findings. File-level only, no project-level retrospective.
3. **GPT Pilot Reviewer agent** — validates implementation, cycles back to CodeMonkey on failure. No summary artifact generated.
4. **Windsurf persistent plan file** — background agent updates plan as execution proceeds. Closest to a "living reconciliation document" but no explicit comparison step.

### Candidate Techniques — Reconciliation

| ID | Technique | Source | Description |
|----|-----------|--------|-------------|
| R1 | Post-session retrospective artifacts | Devin | Generate structured retrospective: issue timeline, outcome evaluation, improved approach for next attempt |
| R2 | Per-task pass/fail gate with structured verdict | MetaGPT | LLM evaluates completion against acceptance criteria, returns (bool, reason). Failures create remediation record |
| R3 | Design-vs-implementation review action | MetaGPT | Dedicated review comparing code against architectural doc, producing ordered findings list |
| R4 | Archive signal triggering retrospective | MetaGPT | Explicit end-of-phase signal that automatically triggers summary/retrospective generation |
| R5 | Persistent plan as live reconciliation doc | Windsurf | Plan saved as local file, updated in-place during execution. Original steps preserved, completed marked, deviations recorded |
| R6 | Trajectory-to-pattern pipeline | SWE-agent | Extract winning action sequences from successful sessions as reusable patterns for future planning |

---

## Domain 2: Session Continuity (Pause/Resume Equivalent)

### Comparison Matrix

| Framework | Persistence Mechanism | Checkpoints | Context Restoration | Stale Detection | Multi-Session | Context Window Mgmt | Crash Recovery |
|-----------|----------------------|-------------|--------------------|-----------------|--------------|--------------------|----------------|
| Superpowers/10x | Named resume flag | 10X.md | From 10X.md | Not present | Not present | Model routing tiers | Resume flag |
| Aider | Chat history file + git | Git commits | --restore-chat-history | Not present | Not present | Auto-summarization (oldest first) | Git (completed edits safe) |
| GPT Pilot | Full relational DB | DB snapshots | --project + --step | Yes (offline_changes_check) | Yes (DB persistence) | Per-agent conversation threads | Dual-state (current/next) |
| SWE-agent | Not present | Not present | Not present | Not present | Parallel retry agents | Windowed history (last_n) | Not present |
| OpenHands | JSON event stream | conversation.json | --resume <id> | Not present | AgentDelegateAction | Pluggable Condenser system | JSON persistence |
| Devin | VM snapshot + Knowledge | Playbooks | Knowledge + Playbooks | Not present | Scheduled sessions | Not disclosed | VM snapshot (loses session) |
| BMAD | .augment/ directory | AGENTS.md | Re-invoke persona | Not present | Party Mode (planned) | Persona-scoped partitioning | Re-invoke persona |
| MetaGPT | Consolidated team.json | team.json snapshots | --recover_path | Not present | Multi-agent core design | Per-role RoleContext memory | Interrupted-action recovery |
| Cursor | Rules + saved plans | In-session checkpoints | Auto-inject rules | Not present | Team Rules | Relevance-filtered rules | Checkpoints (file state only) |
| Cline | Memory Bank (6 .md files) | Shadow Git (per tool use) | Read Memory Bank files | File tracking metadata | new_task chaining | Auto-compact + dedup | Shadow Git rollback |
| Continue.dev | .continue/rules/ | Not present | Auto-load rules | Not present | Not present | Embeddings retrieval | Not present |
| Windsurf | Memories (auto-tagged) + rules | Named conversation checkpoints | 5-layer context assembly pipeline | Not present | Multiple Cascades | Periodic summarization | Reference prior conversations |

### Key Findings

**Standout mechanisms by category:**

1. **Crash recovery:** GPT Pilot's dual-state pattern (current_state/next_state with commit semantics) and Cline's shadow Git (commits after every tool use to separate .git repo) are the two most robust approaches.

2. **Context window management:** OpenHands' pluggable Condenser system is the most sophisticated — supports NoOp, RecentEvents, LLMSummarizing, and domain-specific condensers (BrowserOutput). Aider's auto-summarization compresses oldest messages first. Both preserve recent events verbatim.

3. **Stale state detection:** Only GPT Pilot has this (offline_changes_check). Cline tracks file metadata (read_date, edit_date, user_edit_date) but doesn't alert on staleness.

4. **Context restoration:** Windsurf's 5-layer pipeline (rules → memories → active files → codebase retrieval → recent actions) is the most systematic approach. Ensures consistent reconstruction without monolithic documents.

5. **Session handoff:** Cline's new_task packages a structured context block (completed work, current state, next steps, references) directly into the new session's prompt.

### Candidate Techniques — Session Continuity

| ID | Technique | Source | Description |
|----|-----------|--------|-------------|
| S1 | Pluggable condenser with oldest-first LLM summarization | OpenHands | Compress oldest events first via LLM summary, keep recent events verbatim. Domain-specific condensers for different output types |
| S2 | Dual-state commit pattern for crash safety | GPT Pilot | Maintain current_state (committed) and next_state (in-flight). Promote on success, discard on crash |
| S3 | Offline changes detection on resume | GPT Pilot | Scan workspace for files modified after last session timestamp. Flag conflicts before resuming |
| S4 | Shadow Git checkpoint system | Cline | Separate .git repo for per-operation checkpoints. Supports rollback without polluting user's git history |
| S5 | Structured context handoff block | Cline | Package completed work, current state, next steps, references as structured block for next session |
| S6 | 5-layer context assembly pipeline | Windsurf | Fixed sequence: rules → memories → active files → codebase retrieval → recent actions |
| S7 | Autonomous memory generation with semantic tags | Windsurf | Auto-identify and tag important context during execution (#tech_stack, #key_decision). Inject at session start |
| S8 | Interrupted-action recovery | MetaGPT | Track current action index, clear unfinished messages on recovery, re-trigger from exact interruption point |
| S9 | File tracking metadata for staleness | Cline | Track cline_read_date, cline_edit_date, user_edit_date per file. Detect when cached versions diverge from disk |
| S10 | Prev_state_id audit chain | GPT Pilot | Every state snapshot links to predecessor, creating inspectable/diffable history of agent decisions |

---

## Domain 3: Codebase Intelligence (Brownfield Equivalent)

### Comparison Matrix

| Framework | Index Type | Dependency Graphs | Convention Detection | Incremental Updates | Hub Detection | Adoption Workflow |
|-----------|-----------|-------------------|---------------------|--------------------|--------------|--------------------|
| Superpowers/10x | None (manual 10X.md) | Not present | Manual | N/A | Not present | Add 10X.md |
| Aider | tree-sitter AST + PageRank graph | Yes (file→symbol→file) | Manual (CONVENTIONS.md) | Yes (map-tokens budget) | Yes (graph ranking) | Run aider, auto repo-map |
| GPT Pilot | LLM-based (Importer) | Not present | LLM-inferred | Not present | LLM-heuristic | --import flag |
| SWE-agent | Reactive (bash/grep/filemap) | Not present | Not present | Not present | Not present | Point at repo |
| OpenHands | Manual (AGENTS.md + keyword skills) | Not present | Manual (AGENTS.md) | Keyword skills (lazy load) | Not present | Create AGENTS.md |
| Devin | DeepWiki + repo indexing + Knowledge | Architecture diagrams | Auto-generated + human-verified | .devin/wiki.json steering | Not explicit | 5-step structured onboarding |
| BMAD | LLM-discretionary | Not present | Manual (AGENTS.md) | Not present | Not present | Install + AGENTS.md |
| MetaGPT | File-level (old_code_doc) | Filename association | Not present | Changed-file detection | Not present | Greenfield-focused |
| Cursor | Vector embeddings | Not present | Semi-auto (/create-rule) | 5-min incremental sync | Not present | Auto-index on open |
| Cline | Per-session AST + regex | Not present | Manual (.clinerules) | Not present | Ad-hoc per session | Open + optional .clinerules |
| Continue.dev | Embeddings + AST + ripgrep | Not present | Manual (.continue/rules) | File watcher events | Implicit | Auto-index on open |
| Windsurf | 768-dim embeddings + M-Query | Not present | Manual (.windsurfrules) | Edit-triggered | Implicit | Auto-index on open |

### Non-Framework Tools

| Tool | Index Type | Graph Construction | Incremental | Hub Detection | Setup Overhead |
|------|-----------|-------------------|-------------|--------------|----------------|
| tree-sitter | CST/AST per file | Call graphs + dependency edges (via libraries) | Yes (core design) | Via PageRank on dependency graph | Install grammar packages |
| LSP | Semantic (type system) | Reference traversal → LSIF export | Yes (incremental compilation) | Via findReferences counts | Per-language server setup |
| ctags | Symbol definition index | None (definitions only, no references) | No (full regen) | Not present | Run ctags -R |

### Key Findings

1. **Aider's repo-map is the gold standard** for token-budgeted codebase intelligence: tree-sitter AST → bipartite file-symbol graph → PageRank scoring → top-N files within token budget. Language-agnostic, no server required.

2. **No framework auto-detects conventions.** All rely on manual convention files (.clinerules, .cursor/rules, CONVENTIONS.md, .windsurfrules, AGENTS.md). Cursor's `/create-rule` is the closest to semi-automated.

3. **Vector embeddings are the mainstream approach** (Cursor, Continue.dev, Windsurf) for semantic code retrieval, but none build explicit dependency graphs from them.

4. **LSP provides the highest-fidelity intelligence** (type-aware, reference-precise) but requires per-language server setup. Claude Code shipped LSP support in v2.0.74.

5. **Devin's structured onboarding** (5-step: connect → index → configure repo setup → verify Knowledge → create Playbooks) is the most systematic adoption workflow.

### Candidate Techniques — Codebase Intelligence

| ID | Technique | Source | Description |
|----|-----------|--------|-------------|
| C1 | tree-sitter + PageRank repo-map | Aider | Parse ASTs, build file-symbol-file graph, PageRank to score hubs, output within token budget |
| C2 | AGENTS.md-style context pre-encoding | OpenHands | Structured document encoding repo purpose, layout, entry points, CI/CD. Auto-loaded at session start |
| C3 | Trigger-conditioned context loading | Devin + OpenHands | Load context slices based on triggers (keywords, files touched, task type) rather than loading everything |
| C4 | Three-layer codebase index | Continue.dev | Embeddings (semantic) + AST (structural) + ripgrep (literal). Complementary query types |
| C5 | Incremental file-watcher reindexing | Continue.dev | Subscribe to filesystem events, reindex only affected files |
| C6 | Hierarchical wiki generation with steering | Devin DeepWiki | Auto-generate per-module wiki pages. Steering config controls priority for large codebases |
| C7 | Knowledge quality feedback loop | Devin | At UNIFY time, note which context items were referenced vs unused. Flag candidates for removal/improvement |
| C8 | Semi-automated convention capture | Cursor | LLM-assisted rule generation from code analysis, human-confirmed |
| C9 | Changed-file-triggered incremental update | MetaGPT | Track which files changed during session, update only those entries in project map |
| C10 | LSP-powered semantic analysis | LSP | findReferences for dependency counts, workspace/diagnostics for error debt, documentSymbol for structure |
| C11 | Structured onboarding workflow | Devin | Multi-step: connect → index → configure → verify → create playbooks |

---

## Decision Table

### Reconciliation Decisions

| ID | Technique | Decision | Rationale |
|----|-----------|----------|-----------|
| R1 | Post-session retrospective artifacts | **Adopt** | Direct enhancement to UNIFY — generate issue timeline + outcome evaluation + improvement notes |
| R2 | Per-task pass/fail gate | **Already adopted** | Implemented in Phase 39 (structured status: PASS/PASS_WITH_CONCERNS/BLOCKED) |
| R3 | Design-vs-implementation review | **Reject** | UNIFY already compares plan vs actual. Adding a separate review action is redundant |
| R4 | Archive signal triggering retrospective | **Adapt** | UNIFY already exists as the trigger point. Add auto-generation of retrospective artifacts within existing UNIFY flow |
| R5 | Persistent plan as live reconciliation doc | **Reject** | PLAN.md already serves this role. In-place mutation during execution would corrupt the original plan needed for comparison |
| R6 | Trajectory-to-pattern pipeline | **Reject** | Over-engineering for markdown-based single-agent system. SUMMARY.md captures lessons adequately |

### Session Continuity Decisions

| ID | Technique | Decision | Rationale |
|----|-----------|----------|-----------|
| S1 | Pluggable condenser | **Reject** | Requires programmatic infrastructure. PALS is markdown-based, context managed by host tool (Claude Code) |
| S2 | Dual-state commit pattern | **Reject** | Requires programmatic state management. PALS uses markdown files, not DB transactions |
| S3 | Offline changes detection on resume | **Adopt** | Simple file timestamp comparison. Resume workflow can check if tracked files changed since last session |
| S4 | Shadow Git checkpoint | **Reject** | Claude Code already has checkpoint/undo mechanisms. Adding a parallel git repo is redundant |
| S5 | Structured context handoff block | **Already adopted** | PALS handoff documents already use this pattern (HANDOFF-*.md) |
| S6 | 5-layer context assembly pipeline | **Adapt** | Formalize resume context loading as ordered pipeline: STATE.md → HANDOFF → active plan → project files → recent git |
| S7 | Autonomous memory generation | **Reject** | Against PALS philosophy of explicit, human-readable state. Autonomous generation creates noise |
| S8 | Interrupted-action recovery | **Adapt** | Add task-level progress tracking to STATE.md so resume can identify exactly which task was interrupted |
| S9 | File tracking metadata for staleness | **Adapt** | Track last-modified timestamps of key files in STATE.md. On resume, compare against current timestamps |
| S10 | Prev_state_id audit chain | **Reject** | Over-engineering. Git history + SUMMARY.md chain provides equivalent traceability |

### Codebase Intelligence Decisions

| ID | Technique | Decision | Rationale |
|----|-----------|----------|-----------|
| C1 | tree-sitter + PageRank repo-map | **Defer** | High value but requires programmatic implementation (tree-sitter parsing). Deferred to future milestone |
| C2 | AGENTS.md-style context pre-encoding | **Adapt** | map-codebase already generates a project map. Enhance output format to be more structured/loadable |
| C3 | Trigger-conditioned context loading | **Reject** | Requires programmatic dispatch. PALS loads context via markdown @-references, which is sufficient |
| C4 | Three-layer codebase index | **Reject** | Requires programmatic infrastructure beyond PALS scope |
| C5 | Incremental file-watcher reindexing | **Reject** | Requires programmatic infrastructure |
| C6 | Hierarchical wiki generation | **Adapt** | Enhance brownfield output to include per-module sections with entry points and dependency notes |
| C7 | Knowledge quality feedback loop | **Adopt** | At UNIFY time, note which brownfield/map artifacts were referenced during execution. Flag stale entries |
| C8 | Semi-automated convention capture | **Adapt** | Enhance brownfield onboarding to explicitly prompt for convention extraction during analysis |
| C9 | Changed-file-triggered incremental update | **Adapt** | At UNIFY time, note which files changed. Suggest map-codebase re-run if significant structural changes occurred |
| C10 | LSP-powered semantic analysis | **Defer** | High value but requires LSP server setup. Note as future enhancement when Claude Code LSP matures |
| C11 | Structured onboarding workflow | **Adapt** | Enhance brownfield-onboarding.md with clearer multi-step workflow (analyze → map → conventions → verify → plan) |

### Decision Summary

| Category | Adopt | Adapt | Reject | Already Adopted | Defer |
|----------|-------|-------|--------|----------------|-------|
| Reconciliation | 1 | 1 | 3 | 1 | 0 |
| Session Continuity | 1 | 3 | 5 | 1 | 0 |
| Codebase Intelligence | 1 | 4 | 3 | 0 | 2 |
| **Total** | **3** | **8** | **11** | **2** | **2** |

---

## Implementation Targets

Based on adopt/adapt decisions, improvements will be made to:

1. **unify-phase.md** — R1 (retrospective artifacts), R4 (auto-trigger), C7 (knowledge quality feedback), C9 (changed-file tracking)
2. **pause-work.md** — S9 (file tracking metadata for staleness)
3. **resume-project.md** — S3 (offline changes detection), S6 (ordered context assembly pipeline), S8 (interrupted-action recovery)
4. **map-codebase.md** — C2 (structured output format), C6 (per-module sections)
5. **brownfield-onboarding.md** — C8 (convention capture), C11 (structured onboarding workflow)
