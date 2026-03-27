# REV Module Design

**Phase:** 151 — Research & Design
**Date:** 2026-03-27

---

## 1. Review Prompt Structure

### Context Assembly

The reviewer subagent receives a structured prompt built from:

| Context Layer | Source | Always/Optional |
|---------------|--------|-----------------|
| **Diff** | `git diff {base}...HEAD` or `git diff --cached` | Always |
| **Changed files (full)** | Read each file in the diff | Always |
| **AGENTS.md** | Project root `AGENTS.md` (if exists) | Always |
| **Relevant test files** | Test files for changed source files | Optional (include if they exist) |
| **PLAN.md** | Current plan (if reviewing plan's output) | Optional (on-demand only) |

**Scope determines the diff base:**

| Scope | Diff Command | When |
|-------|-------------|------|
| Current plan | `git diff {branch-base}...HEAD` | Default for `/paul:review` during active plan |
| Specific files | `git diff HEAD -- {files}` + full file read | User specifies files |
| Full branch | `git diff {base_branch}...HEAD` | PR-level review |
| Uncommitted | `git diff` + `git diff --cached` | Quick check before commit |

### Review Dimensions

The reviewer checks 8 dimensions, each with specific instructions:

| # | Dimension | What to Check | Severity Guide |
|---|-----------|---------------|----------------|
| 1 | **Correctness** | Does the code do what the diff claims? Logic errors, off-by-ones, wrong comparisons, null handling | Critical if wrong behavior, Important if edge case |
| 2 | **Edge Cases** | Null/undefined, empty inputs, concurrent access, boundary values, error paths | Important if likely, Minor if unlikely |
| 3 | **Naming & Clarity** | Would someone new understand this in 6 months? Misleading names, unclear intent, missing comments on non-obvious logic | Minor unless actively misleading |
| 4 | **Architecture Fit** | Does this change belong here structurally? Layer violations, wrong module, responsibility creep | Important if structural, Minor if cosmetic |
| 5 | **Performance** | O(n²) hiding, unnecessary re-renders, N+1 queries, large allocations in hot paths | Critical if production impact, Important if detectable |
| 6 | **Security Surface** | New attack vectors, unvalidated input, auth gaps, secrets exposure, injection risks | Critical if exploitable, Important if surface expanded |
| 7 | **Test Coverage** | Are important paths tested? Are tests testing the right thing? Are edge cases from dimension 2 covered? | Important if untested critical path, Minor if untested edge case |
| 8 | **Rollback Safety** | If this breaks in prod, how hard is it to undo? DB migrations, API contract changes, state mutations | Important if irreversible, Minor if easily reverted |

### Output Format

The reviewer returns structured findings:

```markdown
## Code Review: {scope_description}

### Summary
{1-3 sentence overall assessment}

### Findings

#### Critical
- **[{file}:{line}] {title}** — {description}. Fix: {suggestion}.

#### Important
- **[{file}:{line}] {title}** — {description}. Consider: {suggestion}.

#### Minor
- **[{file}:{line}] {title}** — {description}.

### Strengths
- {what's done well — positive reinforcement}

### Verdict
{READY / NOT READY (Critical issues) / READY WITH CONCERNS (Important issues only)}
```

### Prompt Template

```
You are reviewing code changes in the project "{project_name}".

## Context
{AGENTS.md content if exists, otherwise project description}

## Changes to Review
{git diff output}

## Full Changed Files
{full content of each changed file}

## Test Files (if any)
{test files related to changed files}

## Review Instructions
Review these changes across 8 dimensions:
1. Correctness — logic errors, wrong behavior
2. Edge cases — null, empty, boundary, concurrent
3. Naming & clarity — readability in 6 months
4. Architecture fit — does this belong here?
5. Performance — hidden cost, hot path issues
6. Security surface — new attack vectors
7. Test coverage — are the right things tested?
8. Rollback safety — reversibility if broken

For each finding, provide:
- Severity: Critical / Important / Minor
- Location: file:line
- Description: what's wrong
- Suggestion: how to fix (for Critical/Important)

End with a verdict: READY / NOT READY / READY WITH CONCERNS.
Be thorough but not pedantic. Flag real issues, not style preferences.
```

---

## 2. Module Interface

### REV Module Structure

```
modules/rev/
├── module.yaml          # Module manifest
├── references/
│   ├── review-prompt.md     # The prompt template (from Section 1)
│   └── review-checklist.md  # The 8 dimensions with examples
```

### module.yaml Design

```yaml
name: rev
display_name: REV
description: >
  Review Engine & Verification. Thorough code review via subagent
  dispatch — spawns an isolated reviewer with fresh context for
  unbiased, senior-dev-level review.
version: 1.0.0

dependencies:
  kernel: ">=2.0.0"
  modules: []
  external:
    - name: pi-subagents
      package: "@tintinweb/pi-subagents"
      required: false
      check: "Agent tool available"

hooks:
  on-demand:
    priority: 100
    description: >-
      Triggered by /paul:review command. NOT a lifecycle hook —
      does not fire automatically during PLAN/APPLY/UNIFY.
      See review-prompt.md for the full review prompt template.
    refs:
      - references/review-prompt.md
      - references/review-checklist.md

files:
  references:
    - references/review-prompt.md
    - references/review-checklist.md
  workflows: []
  templates: []
  config: []
  rules: []

commands:
  - name: review
    description: "Run thorough code review via subagent"

platform: {}
```

### Key Design Decision: No Lifecycle Hooks

REV does NOT register for pre-plan, post-apply, or post-unify hooks. Reasons:
- **IRIS already handles post-apply** (lightweight, fast, inline)
- **REV is expensive** — spawns a subagent, uses significant tokens
- **REV should be deliberate** — user triggers it when ready, not on every loop iteration

REV fires at exactly two points:
1. **On-demand:** User runs `/paul:review`
2. **PR-level:** Optionally triggered in unify merge gate (configurable)

### Dependency Detection

Before dispatching, check for pi-subagents:

```
1. Check if Agent tool is available in current session
2. If available: proceed with subagent dispatch
3. If not available:
   ⚠️ REV requires pi-subagents for isolated code review.
   Install: pi install npm:@tintinweb/pi-subagents

   Options:
   [1] Skip review (continue without REV)
   [2] Run in-session review (same model, no isolation — degraded mode)

   If "2": fall back to in-session review using the same prompt template
   but without subagent isolation. Note: this loses the fresh-context benefit.
```

### Relationship to IRIS

| | IRIS | REV |
|---|------|-----|
| **When** | Every post-apply (automatic) | On-demand + PR-level (deliberate) |
| **How** | Inline grep/ESLint | Subagent with fresh context |
| **Depth** | Surface (patterns, smells) | Deep (8 dimensions, file:line findings) |
| **Cost** | Low (seconds, minimal tokens) | High (30-60s, significant tokens) |
| **Model** | Same model (inline) | Configurable (different model possible) |
| **Blocks** | Never (advisory) | Configurable (can block on Critical) |

---

## 3. IRIS `any` Bug Fix

**Problem:** Phase 149 removed `eval(` from IRIS pre-plan grep but left `any` in the pattern:
```
grep -rn 'TODO\|FIXME\|HACK\|XXX\|any' {files_modified}
```
The bare `any` matches literally everywhere — massive false positives.

**Decision:** Remove `any` entirely. The original intent was to detect TypeScript `any` type usage, but:
- `any` as a bare grep pattern has unacceptable false positive rate
- TypeScript `any` detection belongs in ESLint (`@typescript-eslint/no-explicit-any`), which IRIS already runs in post-apply
- The pre-plan hook is for quick anti-pattern signatures, not language-specific type checks

**Fix for Phase 152:**
```
grep -rn 'TODO\|FIXME\|HACK\|XXX' {files_modified}
```

---

## 4. pals.json Config Schema

### Exact JSON Structure

```json
{
  "modules": {
    "rev": {
      "enabled": true,
      "description": "Thorough code review via subagent",
      "model": null,
      "pr_review": false,
      "pr_review_block_on_critical": true
    }
  }
}
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | boolean | `true` | Enable/disable REV module |
| `description` | string | — | Module description |
| `model` | string \| null | `null` | Reviewer model. `null` = use agent definition default. Can be fuzzy: `"opus"`, `"gpt-5"`, or full ID. |
| `pr_review` | boolean | `false` | Run REV automatically in merge gate |
| `pr_review_block_on_critical` | boolean | `true` | Block merge if reviewer finds Critical issues |

### Relationship to Agent .md File

Two layers of config:

1. **`~/.pi/agent/agents/code-reviewer.md`** — defines the agent's tools, default model, and system prompt. This is the pi-subagents layer. User controls it globally.
2. **`pals.json modules.rev`** — PALS-specific config. Controls when REV fires, whether it blocks, and can override the model.

Resolution order for model:
1. `pals.json modules.rev.model` (if set) → passed as model override in x) call
2. Agent .md `model` field → used by pi-subagents if no override
3. Session default → fallback if neither is set

### Init Changes

Add REV to:
- `init-project.md` configure_modules brownfield toggle list
- `init-project.md` pals.json template
- Default: `enabled: true, pr_review: false` (opt-in for PR-level)

---

## 5. Subagent Dispatch Pattern

### Agent() Call Structure

```javascript
Agent({
  subagent_type: "code-reviewer",
  prompt: `${assembled_review_prompt}`,
  description: "Code review: {scope}",
  run_in_background: false,
  model: pals_json_rev_model || undefined,  // override if set
})
```

**Foreground mode** (`run_in_background: false`):
- Blocks until review completes
- Results displayed inline
- User sees progress in pi-subagents widget
- Appropriate for on-demand `/paul:review`

**Background mode** (`run_in_background: true`):
- Could be used for PR-level review in merge gate
- But merge gate needs the result to decide block/pass
- **Decision: always foreground.** The review is a blocking operation in both use cases.

### Task Prompt Assembly

The workflow instruction in `/paul:review` (or merge gate hook) assembles the prompt:

```
1. Determine scope → get diff command
2. Run diff command → capture output
3. Read changed files in full
4. Read AGENTS.md if exists
5. Find related test files (*.test.*, *.spec.* matching changed file names)
6. Read review-prompt.md template
7. Substitute placeholders: {project_name}, {diff}, {changed_files}, {test_files}, {agents_md}
8. Invoke Agent() with assembled prompt
9. Parse output → extract verdict
10. Present findings to user
```

### Error Handling

| Error | Response |
|-------|----------|
| Agent tool not available | Offer degraded in-session mode or skip |
| Subagent timeout | Display partial output if available + "Review timed out — try with fewer files" |
| Subagent crash (exit code ≠ 0) | Display stderr + "Review failed — check pi-subagents installation" |
| Empty/unhelpful output | "Review produced no actionable findings — may need more context. Try reviewing specific files." |
| Diff too large (>5000 lines) | "Diff is very large ({N} lines). Review specific files instead? [1] Proceed anyway [2] Pick files" |

---

## 6. UX Design

### `/paul:review` Command Flow

```
════════════════════════════════════════
CODE REVIEW
════════════════════════════════════════

What should I review?

[1] Current plan's changes (diff since branch start)
[2] Specific files (you pick)
[3] Full branch vs {base_branch}
[4] Uncommitted changes
════════════════════════════════════════
```

After scope selection:

```
────────────────────────────────────────
Gathering context...
  Diff: {N} files, {M} lines changed
  Context: {K} files loaded
  Tests: {T} test files found
────────────────────────────────────────
Dispatching reviewer ({model})...
```

Then the Agent tool renders its live progress widget (from pi-subagents). When done:

```
════════════════════════════════════════
REVIEW COMPLETE
════════════════════════════════════════

{reviewer's structured output — findings, strengths, verdict}

────────────────────────────────────────
Verdict: {READY / NOT READY / READY WITH CONCERNS}
────────────────────────────────────────
```

### PR-Level Integration (Merge Gate)

Adds an optional step between `merge_gate_pr` (Gate 2: CI passing) and `merge_gate_merge` (Gate 3: merge):

```
<step name="merge_gate_review" priority="after-merge-gate-pr" condition="rev_pr_review_enabled">
  1. Check pals.json: modules.rev.pr_review
  2. If false or REV disabled: skip silently
  3. If true:
     - Assemble full-branch diff review prompt
     - Dispatch Agent() with code-reviewer
     - Parse verdict
     - If CRITICAL findings AND pr_review_block_on_critical=true:
       ⛔ MERGE GATE: Code review found Critical issues.
       {list critical findings}
       Fix before merging.
     - If IMPORTANT/MINOR only: display findings as advisory, proceed
     - If READY: display "Code review: ✓ READY" and proceed
```

Merge gate display becomes 5 steps (was 4):
```
────────────────────────────────────────
1. PR exists:     ✓
2. CI passing:    ✓
3. Code review:   ✓ READY / ⚠️ CONCERNS / ⛔ BLOCKED
4. Reviews:       ✓ / skipped
5. PR merged:     ✓
────────────────────────────────────────
```

### PALS Skill

New skill: `drivers/pi/skills/paul-review/SKILL.md`

```yaml
---
name: paul-review
description: "Run thorough code review via REV subagent"
---
```

The skill reads REV's review-prompt.md, assembles context, and dispatches. It also registers as a `/paul:review` command in the Pi extension.

---

## 7. Implementation Roadmap (Phase 152)

### Ordered Task List

| # | Task | Files | Depends On |
|---|------|-------|------------|
| 1 | Create REV module (module.yaml + references) | `modules/rev/module.yaml`, `modules/rev/references/review-prompt.md`, `modules/rev/references/review-checklist.md` | — |
| 2 | Fix IRIS `any` bug | `modules/iris/module.yaml` | — |
| 3 | Add REV to init-project.md | `kernel/workflows/init-project.md` | Task 1 |
| 4 | Create /paul:review skill | `drivers/pi/skills/paul-review/SKILL.md` | Task 1 |
| 5 | Add merge gate review step to unify-phase.md | `kernel/workflows/unify-phase.md` | Task 1 |
| 6 | Add REV to Pi extension commands | `drivers/pi/extensions/pals-hooks.ts` | Task 4 |
| 7 | Reinstall and verify | `drivers/pi/install.sh` | Tasks 1-6 |

**Plan splitting:** Tasks 1-3 could be Plan 01, Tasks 4-6 Plan 02, Task 7 in both. Or all in one plan if under 3 tasks (combine 1+2+3 as "Module + Init", 4+5+6 as "Skill + Hooks + Extension", 7 as verification in both).

### Recommended Phase 152 Plan Structure

**Plan 152-01:** Create REV module, fix IRIS, update init
- Task 1: Create modules/rev/ (module.yaml, review-prompt.md, review-checklist.md)
- Task 2: Fix IRIS any bug + add REV to init-project.md
- Task 3: Reinstall, verify module deploys

**Plan 152-02:** Wire /paul:review + merge gate + extension
- Task 1: Create paul-review skill + add merge gate review step
- Task 2: Update Pi extension, reinstall, verify end-to-end

---

*Generated: 2026-03-27 — Phase 151 Research & Design*
