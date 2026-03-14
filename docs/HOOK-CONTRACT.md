# PALS Hook Contract

Hooks are the extension mechanism through which modules participate in the PLAN→APPLY→UNIFY lifecycle. This contract defines when hooks fire, what they receive, what they may do, and what must persist.

**References:** [ADAPTER-CONTRACT.md](ADAPTER-CONTRACT.md) (module hook dispatch), [MODULE-SPEC.md](MODULE-SPEC.md)

**Key principle:** "If a hook result matters to later phases or later harnesses, it must land in an artifact or be derivable from artifacts."

---

## Hook Overview Table

| Hook Point | Fires During | Workflow | Registered Modules (priority order) |
|------------|-------------|----------|--------------------------------------|
| pre-plan | PLANNING phase, before scope analysis | plan-phase | DEAN(50), TODD(100), IRIS(150), DOCS(200), DAVE(200), RUBY(250) |
| post-plan | After plan created, before state update | plan-phase | TODD(100) |
| pre-apply | After approval, before task execution | apply-phase | TODD(50), WALT(100) |
| post-task | After each task completes | apply-phase | TODD(100) |
| post-apply | After all tasks complete (or post-task block) | apply-phase | WALT(100), DEAN(150), DAVE(175), TODD(200), IRIS(250), DOCS(250), SKIP(300) |
| post-unify | After unify reconciliation | unify-phase | WALT(100), SKIP(200), RUBY(300) |

---

## General Dispatch Rules

### Priority Ordering

- Hooks execute in ascending priority order (lower number runs first)
- Priority is defined per-hook in each module's `module.yaml`
- No two modules should share the same priority at the same hook point

### Module Loading

- Read `modules.yaml` (or equivalent module registry)
- Only load modules that are enabled in project config (`pals.json`)
- Missing module registry = no hooks fire (no-op, no error)
- Disabled module = skip entirely

### Reference Loading

- Each hook loads ONLY its hook-specific `refs` from module.yaml, NOT all module references
- This minimizes context injection per dispatch
- Example: TODD's pre-plan loads `tdd-detection.md` and `tdd-plan-generation.md`, not all 5 TODD references

### Dispatch Logging

Format: `[dispatch] {hook-name}: {MODULE(priority) → outcome} | {MODULE(priority) → outcome} | ...`

Outcomes: `N inject keys`, `skip`, `block`, `N modifications`, `N annotations`

---

## Hook Specifications

### 1. pre-plan

**When:** During plan-phase, after phase identification but before scope analysis and plan creation.

**Input Context:**
- Phase info (number, name, focus from ROADMAP.md)
- Project context (from PROJECT.md)
- files_modified hint (if known from roadmap scope)

**Allowed Output Actions:**

| Action | Description |
|--------|-------------|
| `context_inject` | Add key-value data to planning context (e.g., tdd_candidates, dep_warnings, review_flags, doc_warnings, deploy_warning, debt_flags) |
| `type_suggestion` | Suggest non-default plan type (e.g., TODD suggests `tdd` if candidates found) — user confirms |
| `block` | Halt planning with reason (e.g., critical dependency vulnerability) |

**Persistence:** EPHEMERAL — context_inject data lives only in the current prompt/session. It influences the plan being created but is not persisted to artifacts. The plan itself captures the result.

**Current Registrations:**

| Module | Priority | Injects | Can Block? |
|--------|----------|---------|------------|
| DEAN | 50 | dep_warnings (severity counts) | Yes (critical vulns) |
| TODD | 100 | tdd_candidates, tdd_type | No |
| IRIS | 150 | review_flags (anti-pattern signatures) | No |
| DOCS | 200 | doc_warnings (stale/missing doc counts) | No |
| DAVE | 200 | deploy_warning (CI/CD config detected) | No |
| RUBY | 250 | debt_flags (file paths, debt types) | No |

---

### 2. post-plan

**When:** After PLAN.md is created, before STATE.md update. The plan exists on disk.

**Input Context:**
- Plan path (full file path to PLAN.md)
- Plan content (parsed plan structure)
- context_from_pre_plan (accumulated inject data from pre-plan hooks)

**Allowed Output Actions:**

| Action | Description |
|--------|-------------|
| `plan_modifications` | Restructure tasks in the plan (e.g., TODD restructures into RED-GREEN-REFACTOR) |

**Persistence:** PERSISTED — modifications are written directly into the PLAN.md file. The plan on disk is the authoritative version after post-plan hooks run.

**Current Registrations:**

| Module | Priority | Action | Can Block? |
|--------|----------|--------|------------|
| TODD | 100 | Restructure tasks to RED-GREEN-REFACTOR if plan type=tdd | No |

---

### 3. pre-apply

**When:** After user approves plan, after skill verification, after optional worktree setup, before first task execution.

**Input Context:**
- Plan content (approved PLAN.md)
- Project context (STATE.md, pals.json)

**Allowed Output Actions:**

| Action | Description |
|--------|-------------|
| `context_inject` | Add baseline data for later comparison (e.g., test_baseline from WALT, test file verification from TODD) |
| `block` | Halt apply with reason (e.g., TODD: test files missing and RED phase would be skipped) |

**Persistence:** EPHEMERAL (within session) — baseline data is carried through the apply session and passed to post-apply hooks for comparison. Not persisted to artifacts directly, but comparison results land in SUMMARY.md via post-apply.

**Current Registrations:**

| Module | Priority | Injects | Can Block? |
|--------|----------|---------|------------|
| TODD | 50 | Test file verification | Yes (RED phase skip) |
| WALT | 100 | test_baseline (total, passing, failing, test_command) | No |

---

### 4. post-task

**When:** After each individual task completes within apply-phase. Fires once per task.

**Input Context:**
- Task name and number
- Task result (PASS, PASS_WITH_CONCERNS, BLOCKED)
- Files modified by this task
- context_inject from pre-apply (e.g., baselines)

**Allowed Output Actions:**

| Action | Description |
|--------|-------------|
| `context_inject` | Add per-task annotations (e.g., test results) |
| `block` | Stop remaining tasks. IMPORTANT: post-apply hooks still fire even after a post-task block. |

**Persistence:** EPHEMERAL (within session) — annotations accumulate across tasks and feed into post-apply. Quality data from post-task blocks is captured in SUMMARY.md during unify.

**Blocking Behavior:** When a post-task block fires:
- Remaining tasks in the plan are SKIPPED
- post-apply hooks STILL FIRE (allowing quality reporting even on blocked execution)
- The block reason is surfaced to the user

**Current Registrations:**

| Module | Priority | Action | Can Block? |
|--------|----------|--------|------------|
| TODD | 100 | Run test suite; block if tests regress from previous task | Yes (test regression) |

---

### 5. post-apply

**When:** After ALL tasks complete, OR after a post-task block halts remaining tasks. Always fires if apply started.

**Input Context:**
- All task results (pass/fail/blocked per task)
- Files modified across all tasks
- context_inject from pre-apply (baselines for comparison)
- context_inject from post-task (accumulated per-task data)

**Allowed Output Actions:**

| Action | Description |
|--------|-------------|
| `annotations` | Quality reports, review findings, knowledge suggestions, etc. |
| `block` | Halt further progression with reason and optional remediation steps. User offered: fix/override/stop. |

**Persistence:** MIXED
- Annotations are carried to the finalize step and included in apply completion output
- Quality gate results persist to SUMMARY.md (via unify-phase Module Execution Reports)
- WALT quality data persists to quality-history.md
- SKIP knowledge suggestions are advisory (user decides to persist)

**Current Registrations:**

| Module | Priority | Action | Can Block? |
|--------|----------|--------|------------|
| WALT | 100 | Re-run tests + lint + typecheck; compare against baseline | Yes (regressions) |
| DEAN | 150 | Re-run dep audit; compare against pre-plan baseline | Yes (new critical/high vulns) |
| DAVE | 175 | Validate CI/CD config syntax if pipeline files modified | Yes (parse errors) |
| TODD | 200 | Run full test suite; suggest REFACTOR candidates | No |
| IRIS | 250 | Run 25 review patterns against changed files | No |
| DOCS | 250 | Check code changes against doc catalog for drift | No |
| SKIP | 300 | Scan for new decisions; suggest knowledge entries | No |

---

### 6. post-unify

**When:** After unify-phase reconciliation completes. SUMMARY.md is being finalized.

**Input Context:**
- SUMMARY.md content (accomplishments, decisions, deviations)
- Plan vs actual comparison results
- Accumulated annotations from post-apply

**Allowed Output Actions:**

| Action | Description |
|--------|-------------|
| `context_inject` | Advisory annotations for SUMMARY.md Module Execution Reports section |

**Persistence:** PERSISTED (to artifacts)
- WALT: Computes quality delta (before vs after), appends entry to quality-history.md with phase metadata
- SKIP: Extracts decisions/rationale from SUMMARY.md, creates knowledge entry suggestions
- RUBY: Scans SUMMARY.md files_modified for new debt patterns, reports refactor suggestions

**Blocking:** post-unify hooks CANNOT block. They are advisory only.

**Current Registrations:**

| Module | Priority | Action | Can Block? |
|--------|----------|--------|------------|
| WALT | 100 | Quality delta computation + history append | No |
| SKIP | 200 | Knowledge extraction + entry suggestions | No |
| RUBY | 300 | Debt scan + refactor suggestions | No |

---

## CARL: Platform Hooks (Not Lifecycle Hooks)

CARL does NOT use PALS lifecycle hooks. Its `hooks: {}` is empty in module.yaml.

CARL operates through platform-specific hooks:
- **Claude Code:** `UserPromptSubmit` shell hook (`carl-hook.py`)
- **Pi:** Would need a TypeScript extension mapping to `context` event

CARL's hook mechanism is adapter-specific and outside this contract's scope. This contract covers only PALS lifecycle hooks dispatched by kernel workflows.

---

## Persistence Summary

| Category | Examples | Survives Session? | Survives Harness Switch? |
|----------|---------|-------------------|--------------------------|
| Ephemeral | context_inject during plan/apply | No | No |
| Session-scoped | pre-apply baselines carried to post-apply | Within session | No |
| Artifact-persisted | WALT quality-history, SUMMARY.md reports | Yes | Yes |

**Rule:** If a hook output matters beyond the current session or current harness, it MUST be written to an artifact. Ephemeral injection is acceptable only for within-session guidance that gets captured in the resulting artifact (e.g., pre-plan suggestions influence the PLAN.md, which is persisted).

---

## Adapter Implementation Notes

A harness adapter implementing hook dispatch must:

1. Read the module registry to discover active modules and their hook registrations
2. Sort by priority (ascending) at each hook point
3. Load only the hook-specific refs (not all module references)
4. Pass the correct input context for each hook point
5. Respect blocking semantics (especially: post-task block does not prevent post-apply)
6. Log dispatch outcomes for observability
7. Ensure artifact-persisted outcomes land in the correct files

The mechanism by which hooks execute varies by adapter:
- **Claude Code:** LLM reads hook instructions from module refs and follows them inline
- **Pi:** TypeScript extension could map pi events to PALS hook dispatch
- **Agent SDK:** Programmatic hook dispatch via query() API

The hook CONTRACT (when, what input, what output, what persists) is the same regardless of mechanism.

---

*Hook Contract — v2.0 Portability & Cross-Harness*
*Created: 2026-03-14*
