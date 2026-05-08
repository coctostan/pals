# Phase 267 Handoff: Selective Artifact Loading

Date: 2026-05-08
Source: Post-Phase-266 resume discussion
Status: Recommended Phase 267 scope input

## Problem

Phase 266 reduced the size of this project's hot `.paul/*` markdown artifacts, but it did not change PALS behavior. PALS workflows can still load too much context when they ask agents to read whole lifecycle artifacts instead of only the sections needed for the active command.

The next fix should make PALS load pertinent artifact slices by default, not rely only on making the files smaller.

## Decision

Add a simple behavioral rule to PALS workflows:

> Do not full-read hot `.paul/*` artifacts by default. Locate the relevant heading, marker, phase row, plan ID, resume file, or status line first, then read only the smallest useful line window around that location. Expand only when required fields are missing or contradictory. Full-file reads are fallback-only for rewrite, audit, repair, or whole-artifact validation.

Do not bloat the workflow text with tool-compatibility detail. The workflow should state the behavior; the active Pi/native tools can determine how to satisfy it.

## Hot artifacts covered

- `.paul/STATE.md`
- `.paul/PROJECT.md`
- `.paul/MILESTONES.md`
- `.paul/ROADMAP.md`

Archive/history files are cold path and should be read only when the current task explicitly depends on historical detail.

## Proposed Phase 267 scope

Phase 267 should become:

**Selective Artifact Loading + Anti-Regrowth Guardrails + v2.62 Closure**

This still fits the v2.62 milestone because the milestone goal is reduced PALS hot-path context cost.

## Workflow update targets

Patch the highest-impact workflows first:

- `kernel/workflows/resume-project.md`
- `kernel/workflows/plan-phase.md`
- `kernel/workflows/apply-phase.md`
- `kernel/workflows/unify-phase.md`
- `kernel/workflows/pause-work.md`
- `kernel/workflows/roadmap-management.md`
- `kernel/workflows/create-milestone.md`
- `kernel/workflows/transition-phase.md`

## Acceptance criteria proposal

- Hot `.paul/*` artifacts are no longer described as blanket full-file required reads in hot workflows.
- Workflows instruct agents to locate relevant headings/markers/rows first and read bounded windows.
- Archive/history files are explicitly cold-path only.
- Full-file reads require a reason: rewrite, audit, repair, or whole-artifact validation.
- A validation guardrail prevents regrowth of blanket-read wording for hot artifacts in PALS workflow docs.

## Phase 266 UNIFY note

Phase 266 UNIFY should record this explicitly:

> Phase 266 compacted project lifecycle artifacts and fixed the inherited ROADMAP line-budget validation failure, but it did not alter PALS loading behavior. Selective Artifact Loading is handed off to Phase 267 so PALS loads only pertinent artifact slices by default.
