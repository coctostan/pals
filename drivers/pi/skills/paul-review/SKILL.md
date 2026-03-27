---
name: paul-review
description: "Run thorough code review via REV subagent — spawns an isolated reviewer with fresh context for unbiased, senior-dev-level review across 8 dimensions."
---

# PAUL Review

Run a thorough code review by dispatching an isolated reviewer subagent.

## What This Does

Assembles diff context and changed files, then dispatches a `code-reviewer` subagent (via pi-subagents Agent() tool) with the full review prompt template. The reviewer checks 8 dimensions (correctness, edge cases, naming, architecture, performance, security, test coverage, rollback safety) and returns structured findings with a verdict.

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`
   - File: `pals.json` (check `modules.rev` config — enabled, model, pr_review settings)

2. Read the installed module references:
   - File: `../modules/rev/references/review-prompt.md` (prompt template with placeholders)
   - File: `../modules/rev/references/review-checklist.md` (8 dimensions with severity guides)

3. Present scope selection:
   ```
   ════════════════════════════════════════
   CODE REVIEW
   ════════════════════════════════════════

   What should I review?

   [1] Current plan's changes (diff since branch start)
   [2] Specific files (you pick)
   [3] Full branch vs base_branch
   [4] Uncommitted changes
   ════════════════════════════════════════
   ```
   Wait for user selection. Map to diff command per review-prompt.md scope table.

4. Assemble context:
   - Run the diff command for the selected scope
   - Read each changed file in full
   - Read `AGENTS.md` from project root (if exists)
   - Find related test files (`*.test.*`, `*.spec.*` matching changed file names)

5. Check pi-subagents dependency:
   - Verify the `Agent` tool is available in the current session
   - If not available:
     ```
     ⚠️ REV requires pi-subagents for isolated code review.
     Install: pi install npm:@tintinweb/pi-subagents

     [1] Skip review
     [2] Run in-session review (same model, no isolation — degraded mode)
     ```
   - If "2": use the prompt template inline without subagent dispatch

6. Build prompt from review-prompt.md template:
   - Substitute `{project_name}`, `{diff}`, `{changed_files}`, `{test_files}`, `{agents_md}`
   - If diff exceeds 5000 lines, warn and offer to pick specific files

7. Dispatch reviewer:
   - Use `Agent()` with `subagent_type: "code-reviewer"`, `run_in_background: false`
   - If `pals.json modules.rev.model` is set (not null), pass as `model` override
   - Display: `Dispatching reviewer ({model})...`

8. Display results:
   ```
   ════════════════════════════════════════
   REVIEW COMPLETE
   ════════════════════════════════════════

   {reviewer's structured output — findings, strengths, verdict}

   ────────────────────────────────────────
   Verdict: {READY / NOT READY / READY WITH CONCERNS}
   ────────────────────────────────────────
   ```

## Key Behavior

- On-demand only — NOT a lifecycle hook. Does not fire during PLAN/APPLY/UNIFY.
- Foreground dispatch — blocks until review completes
- Configurable model via `pals.json modules.rev.model` (null = agent default)
- Graceful degradation if pi-subagents not installed

## Output

- Reviewer findings displayed inline with severity, location, and suggestions
- Verdict: READY / NOT READY / READY WITH CONCERNS
