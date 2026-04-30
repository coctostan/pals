---
name: paul-review
description: "Run thorough code review via REV subagent — spawns an isolated reviewer with fresh context for unbiased, senior-dev-level review across 8 dimensions."
---

# PAUL Review

Run an on-demand REV review by dispatching an isolated `code-reviewer` subagent.

## Canonical references
- `../references/review-prompt.md`
- `../references/review-checklist.md`

## Default output
- Concise by default: show scope, reviewer dispatch status, findings summary, verdict, and one next action.
- Expand for critical/high findings, unavailable subagent support, oversized diffs, degraded review mode, or user request.

## Command-local notes
- Read `.paul/STATE.md` and `pals.json` (`modules.rev.enabled`, `model`, `pr_review`, blocking settings).
- Ask for one review scope: current plan changes, specific files, branch vs base, or uncommitted changes; map scope using `review-prompt.md`.
- Assemble diff, changed files, optional `AGENTS.md`, and related `*.test.*` / `*.spec.*` files.
- Dispatch `Agent({ subagent_type: "code-reviewer", run_in_background: false })`; pass `modules.rev.model` when configured.
- Review dimensions stay in the referenced checklist: correctness, edge cases, naming, architecture, performance, security, test coverage, rollback safety.
- If `Agent` is unavailable, offer skip or degraded in-session review; label degraded mode clearly.
- Preserve structured findings with severity, location, suggestion, strengths, and verdict: `READY`, `READY WITH CONCERNS`, or `NOT READY`.
- On-demand only — NOT a lifecycle hook; REV does not fire automatically during PLAN/APPLY/UNIFY.