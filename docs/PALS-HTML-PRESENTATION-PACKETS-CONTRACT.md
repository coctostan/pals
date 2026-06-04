# PALS HTML Presentation Packets Contract

## Purpose

This contract defines the v2.71 implementation boundary for **HTML presentation packets**: static, PALS-owned human-review briefs for milestone, PLAN, APPLY, and UNIFY moments.

Presentation packets improve reviewability by turning authoritative lifecycle evidence into a readable HTML brief. They do not replace `.paul/*`, PLAN/APPLY/UNIFY, module reports, git state, command output, or approved workflow decisions. The goal is to help a human quickly understand what happened, what needs review, and where the evidence lives.

The goal is **not** to revive a live Plannotator-style UI, create a browser-driven lifecycle surface, introduce external presentation dependencies, or let generated HTML decide lifecycle state.

## Source Authority

This contract is the authoritative implementation boundary for v2.71 HTML presentation packet work.

After Phase 299 UNIFY:

1. `docs/PALS-HTML-PRESENTATION-PACKETS-CONTRACT.md` is the authoritative spec for packet authority, storage, packet types, audience modes, static HTML rules, source inputs, citations, and non-goals.
2. `kernel/templates/HTML-PRESENTATION-PACKET.md` is the authoritative template model for packet instances.
3. Phases 300-302 wire generation, surfacing, and validation against this fixed spec. If a downstream phase and this contract conflict, this contract wins for v2.71 planning and APPLY work unless the user explicitly revises it.

## Doctrine

Use this framing across v2.71:

> Derived briefs, authoritative artifacts.

Default rule:

> Read authoritative artifacts, render cited static HTML, and never let packet content decide lifecycle state.

Presentation packets are review aids. They summarize and cite evidence; they do not create evidence, own evidence, or override evidence.

## Packet Storage

Generated packet instances live under this exact storage convention:

```text
.paul/presentation-packets/{phase-or-milestone}/{packet-id}.html
```

Example:

```text
.paul/presentation-packets/299-presentation-contract-template-model/299-01-plan.html
```

Storage rules:

- `.paul/presentation-packets/` contains durable derived review artifacts.
- Packet instances are **not hot-path lifecycle truth** and are excluded from STATE/PROJECT/ROADMAP/MILESTONES hot-artifact byte budgets.
- Packet instances may be regenerated, replaced, archived, or discarded without changing lifecycle state.
- Packet storage does not make packet content authoritative. Authority stays with cited source artifacts and command outputs.
- Packet filenames should be stable, lowercase, and lifecycle-scoped, such as `milestone-brief.html`, `299-01-plan.html`, `299-01-apply.html`, or `299-01-unify.html`.

## Packet Types

### Milestone Packet

**Review question:** What is this milestone trying to accomplish, and what context should a reviewer carry into planning?

**Required source inputs:**

- `.paul/STATE.md` bounded current-position and loop-position facts
- `.paul/ROADMAP.md` current milestone and phase details
- `.paul/PROJECT.md` bounded current focus, constraints, and current decisions when relevant

**Optional source inputs:**

- `.paul/MILESTONES.md` milestone index
- relevant milestone archive summaries
- strategic assessment artifacts when explicitly cited by STATE/ROADMAP or the user

**Expected review sections:** milestone goal, phase lineup, current status, constraints, decisions, risks, and next lifecycle action.

### PLAN Packet

**Review question:** Is this PLAN executable, bounded, and ready for APPLY approval?

**Required source inputs:**

- approved PLAN frontmatter, objective, acceptance criteria, tasks, boundaries, verification, and module dispatch sections
- `.paul/STATE.md` current plan and loop-position facts
- `.paul/ROADMAP.md` target phase detail

**Optional source inputs:**

- selected source/context files named by the PLAN
- prior SUMMARY files only when they are direct dependencies

**Expected review sections:** goal, scope, files modified, acceptance criteria, ordered tasks, boundaries, module dispatch, verification plan, risks, and approval question.

### APPLY Packet

**Review question:** What changed during APPLY, what passed, what remains concerning, and what evidence supports completion?

**Required source inputs:**

- approved PLAN tasks and verification commands
- changed-file list and relevant git diff summary
- parent-run task verification results
- post-task and post-apply module evidence when available
- `.paul/STATE.md` current APPLY status

**Optional source inputs:**

- helper reports from `pals-implementer` when delegation was used
- command logs, quality baselines, and module annotations retained for UNIFY

**Expected review sections:** task results, files changed, verification evidence, module reports, deviations, risks/concerns, and UNIFY readiness.

### UNIFY Packet

**Review question:** Does the SUMMARY accurately reconcile plan vs. actual work, and is the phase ready to close or route forward?

**Required source inputs:**

- approved PLAN
- resulting SUMMARY
- APPLY verification and module reports
- `.paul/STATE.md` loop-position facts
- `.paul/ROADMAP.md` phase/milestone status facts

**Optional source inputs:**

- quality history rows
- CODI/RUBY/SKIP history rows
- git/PR/CI evidence in github-flow projects

**Expected review sections:** acceptance criteria results, actual files changed, deviations, decisions, validation, module execution reports, lifecycle updates, and next action.

## Audience Modes

Audience mode changes packet density only. It never changes authority, source requirements, or citation obligations.
Canonical audience mode names are lowercase: `quick brief`, `reviewer brief`, and `full evidence brief`.

### Quick brief

A compact scan for immediate routing. Include the lifecycle moment, one-paragraph summary, key status, top risks, validation headline, and next action. Omit deep evidence tables unless a blocker or warning must be visible.

### Reviewer brief

The default human review mode. Include summary, review focus, source map, task/AC status, decisions, risks, validation evidence, module notes, and open questions. This mode should be readable without opening every cited artifact, while still citing each source.

### Full evidence brief

A dense audit packet. Include all reviewer-brief sections plus expanded source map, task evidence, command outputs or summaries, module dispatch reports, changed-file inventory, git/PR/CI state, and explicit absent-source notes.

## Static HTML Rules

Every packet instance is a complete static HTML document.

Required rules:

- Use `<!doctype html>` and a single self-contained HTML document.
- Use semantic headings and landmarks (`header`, `main`, `section`, `footer`) so the packet is accessible and printable.
- Inline CSS is allowed and preferred for portability.
- No JavaScript.
- No network assets.
- No external CSS, fonts, images, embeds, or runtime dependencies.
- Escape all user, artifact, command, diff, and source content before inserting it into HTML.
- Preserve source paths and line/section labels as text; do not turn absent evidence into claims.
- Use readable default styling for terminal-adjacent review: high contrast, printable layout, wrapped preformatted evidence, and clear warning/blocker callouts.

## Source Inputs and Citations

Packets must cite every material input they summarize.

Allowed source categories:

- `.paul/*` lifecycle artifacts, especially bounded STATE/ROADMAP/PROJECT/MILESTONES windows
- PLAN and SUMMARY files
- module dispatch reports and module history files
- git state, PR/CI state, and command outputs gathered by the parent workflow
- repo source files explicitly selected by the plan, task, or workflow
- durable evidence artifacts explicitly referenced by STATE, ROADMAP, PLAN, SUMMARY, or the user

Citation rules:

- Cite artifact path and section, line range, command, or evidence label when available.
- Mark missing optional inputs as `not available — <reason>`.
- Mark skipped checks as `skipped — <reason>`.
- Never fabricate pass/fail counts, CI status, reviewer decisions, command output, source contents, or lifecycle state.
- If sources conflict, the packet must say so and identify the authoritative source rather than resolving by itself.

## Authority & Boundaries

Presentation packets are derived, static, review-only artifacts.

Authoritative sources remain:

- `.paul/STATE.md` for current lifecycle truth
- `.paul/ROADMAP.md` and `.paul/MILESTONES.md` for milestone/phase routing
- approved PLAN files for execution scope
- SUMMARY files for reconciliation
- module dispatch reports for module evidence
- parent-run command outputs for validation truth
- git/PR/CI state for github-flow routing and merge readiness

Presentation packets must not:

- approve APPLY
- mark a task complete
- mark UNIFY complete
- block or unblock a lifecycle transition
- merge or close a PR
- rewrite `.paul/*` lifecycle state
- replace command-output evidence
- serve as the only source for a decision

If a packet differs from its cited artifact, the cited artifact wins.

## Non-Goals for v2.71

v2.71 does not introduce:

- live Plannotator-style UI
- Pi extension presentation panels
- browser automation requirements
- JavaScript-driven review surfaces
- external presentation/rendering dependencies
- hidden runtime state
- telemetry or analytics
- packet-driven lifecycle decisions
- packet generation in Phase 299
- workflow wiring in Phase 299
- validation harness changes in Phase 299

## Status

- Phase 299: contract + template model authored.
- Phase 300: milestone + PLAN packet generation wired (`create-milestone.md` `render_milestone_packet`, `plan-phase.md` `review_plan`).
- Phase 301: APPLY + UNIFY packet generation wired (`apply-phase.md` `finalize`, `unify-phase.md` `render_unify_packet`).
- Phase 302: surfacing docs + validation guardrails added; the v2.71 HTML presentation packets boundary is closed. All four packet surfaces (milestone, PLAN, APPLY, UNIFY) are wired as optional, non-blocking, derived, source-cited, and non-authoritative; packets never decide lifecycle state.
