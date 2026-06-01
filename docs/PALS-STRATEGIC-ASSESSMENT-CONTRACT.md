# PALS Strategic Milestone Assessment Contract

## Purpose

This contract defines the v2.70 implementation boundary for the optional **strategic-assessment checkpoint** in PALS milestone discussion.

Today PALS jumps from milestone completion straight to "what do you want to build next?" with no standing step that takes stock of project reality first. This checkpoint inserts an optional, collaborative pause into `/paul:discuss` (milestone mode) — between recapping prior accomplishments and exploring the next milestone's features — that gathers evidence across five lenses, surfaces strategic options, and produces a single ranked (but non-authoritative) recommendation to inform the discussion.

The checkpoint systematizes the ad-hoc "take stock and rank the next target" move proven manually in Phase 295 (`.paul/phases/295-context-offload-measurement-next-target-ranking/`). The goal is to make that move repeatable and capability-detecting so it works on arbitrary projects, not just PALS itself. The goal is **not** to add a blocking gate, a subagent, a Pi UI surface, or a new authoritative lifecycle artifact.

## Source Authority

This contract is the authoritative implementation boundary for v2.70 strategic-assessment work.

After Phase 296 UNIFY:

1. `docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md` is the authoritative spec for the checkpoint's lenses, capability detection, output format, and authority stance.
2. `kernel/templates/STRATEGIC-ASSESSMENT.md` is the authoritative output-artifact shape the workflow instantiates.
3. Phase 297 wires this checkpoint into `discuss-milestone.md` against this fixed spec; Phase 298 owns validation. If a downstream phase and this contract conflict, the contract wins for v2.70 planning and APPLY work unless the user explicitly revises the contract.

## Doctrine

Use this framing across v2.70:

> Take stock before you build.

The checkpoint answers one strategic question before feature discussion begins:

> Given where this project actually is — its vision, trajectory, code, build health, and outputs — what is the highest-value thing to build next?

Default rule:

> Gather lightweight evidence across all five lenses, detect and run only the capabilities that exist, present findings and options honestly, and recommend a single next target without claiming authority over the decision.

## Scope & Placement

The strategic-assessment checkpoint:

- runs **inside** `kernel/workflows/discuss-milestone.md` (milestone mode of `/paul:discuss`), inserted between the prior-accomplishments recap and the "what do you want to build next?" feature exploration;
- is **OPTIONAL** and **NON-BLOCKING** — the user may skip it, and it never gates milestone discussion or any lifecycle transition;
- is **main-session collaborative only** — it runs in the active session as a conversation. It uses **NO subagents** and **NO Pi UI surfaces** (no driver, no extension, no rich review panel);
- is **capability-detecting** — it inspects what the project actually has (build tooling, tests, metrics, generated data) and adapts, so it works on arbitrary projects rather than assuming a PALS-shaped repo;
- is **lightweight by default** — code inspection favors fast signals (file counts, largest files, TODO/FIXME grep, build/test status) with optional deeper dives only when the conversation warrants, keeping the checkpoint conversational rather than an exhaustive audit.

Placement is advisory input to a discussion, not a phase in the PLAN/APPLY/UNIFY loop.

## The Five Evidence Lenses

The checkpoint gathers evidence across five lenses, in this order. Each lens MUST state (a) its strategic question, (b) the evidence it gathers, and (c) its capability-detection behavior (what to run if the capability is present, and how to skip gracefully with an explicit "not applicable" note when it is absent).

### 1. Vision alignment

**Strategic question:** Is recent work still serving the project's stated purpose, or has it drifted?

**Evidence gathered:** The project's Core Value and Success Criteria (from `PROJECT.md` or equivalent) compared against the themes of the last N completed milestones (from `ROADMAP.md`/`MILESTONES.md` or equivalent history).

**Capability detection:** If a vision/purpose statement and milestone history exist, summarize alignment and note drift. If no explicit vision statement exists, infer intent lightly from the README or top-level docs and mark the lens `partial`; if neither exists, skip with `not applicable — no stated vision or milestone history found`.

### 2. Trajectory

**Strategic question:** Is the project converging toward its goals or sprawling away from them?

**Evidence gathered:** Convergence-vs-sprawl signals — milestone-theme drift over time, accumulation of deferred debt or "later" items, and decision-log churn or re-litigation of previously settled decisions.

**Capability detection:** If milestone history and a decision log exist, report drift and churn trends. If only partial history exists, report what is available and mark the rest `partial`. If no history or decision record exists, skip with `not applicable — insufficient history to assess trajectory`.

### 3. Codebase reality

**Strategic question:** What state is the code actually in?

**Evidence gathered:** Repository size and recent growth, complexity hotspots and largest files, TODO/FIXME/HACK density, presence and shape of tests, and obvious duplication or dead code. Depth is lightweight by default — counts, largest-file listing, and marker grep — with optional deeper dives on request.

**Capability detection:** Always available for any repository with source files. Run available lightweight inspections (line counts, largest files, marker grep). Skip optional deeper analyzers (complexity tools, duplication detectors) gracefully when they are not installed, noting `optional analyzer not present — using lightweight signals`. If the repository has no source files (docs-only), report that and mark the lens `partial`.

### 4. Buildable/runnable reality

**Strategic question:** Does the project actually build, test, and run right now?

**Evidence gathered:** Current build status, test pass/fail counts, validation/lint state, and overall executable/output health.

**Capability detection:** Detect build and test tooling (package scripts, Makefile targets, test runners, validation harnesses). Run what exists and report results. For each capability that is absent, skip with an explicit `not applicable — no {build|test|validation} tooling detected` note rather than failing or fabricating a result. Never invent pass/fail counts.

### 5. Data & outputs

**Strategic question:** What is the project producing, and is that output healthy and trending well?

**Evidence gathered:** Generated data, logs, benchmark or validation results, and their trend over time (improving, flat, regressing).

**Capability detection:** Detect output locations (results directories, benchmark/validation logs, history files). Summarize present outputs and their trend. Skip with `not applicable — no generated data or output history found` when the project produces no inspectable outputs. Never fabricate trends from absent data.

## Capability Detection

The checkpoint follows one general rule across all lenses:

> Detect what exists, run it, and skip what is absent with an explicit "not applicable" note — never fail the checkpoint and never fabricate evidence.

Concretely:

- Probe for each capability (vision doc, milestone history, decision log, source files, build/test/validation tooling, output/data locations) before using it.
- When a capability is present, run the lightweight inspection and report measured evidence.
- When a capability is absent or a tool is unavailable, record a one-line `skipped: not applicable — <reason>` for that lens or sub-check and continue.
- Partial availability is reported as `partial`, not as a pass or a failure.
- The checkpoint degrades gracefully on arbitrary projects: a minimal repo yields a short assessment with several lenses marked not applicable, which is a valid outcome.

## Output Format

The checkpoint produces a four-part output, always in this fixed order:

1. **Findings** — evidence-backed observations, organized by the five lenses (in lens order), with not-applicable lenses noted explicitly.
2. **Strategic options** — candidate next directions, each with its tradeoffs (cost, risk, value, dependencies).
3. **Ranked recommendation** — a single recommended next target, explicitly tagged **non-authoritative**, with the reasoning that ranks it above the alternatives.
4. **Actionable points** — concrete handoff items that feed directly into the milestone feature discussion (`explore_features` / `synthesize_scope`).

The output is instantiated from the template at `kernel/templates/STRATEGIC-ASSESSMENT.md` and written to a durable artifact at `.paul/assessments/{date}-{slug}.md`.

## Authority & Boundaries

- The ranked recommendation is **non-authoritative**. It informs the milestone discussion; it does not decide it. No work is authorized by an assessment — only a future approved PLAN authorizes implementation. This mirrors the Phase 295 precedent, where take-stock-and-rank produced guidance, not a commitment.
- Assessment documents are **durable posterity artifacts** stored under `.paul/assessments/{date}-{slug}.md`. They are **NOT hot-path lifecycle artifacts**: they are not `STATE.md`, `PROJECT.md`, `ROADMAP.md`, or `MILESTONES.md`, and they are **NOT subject to the hot-artifact byte budgets** that govern those files.
- `.paul/*` lifecycle authority is unchanged. STATE/PROJECT/ROADMAP/MILESTONES remain the only lifecycle truth, and PLAN/APPLY/UNIFY ownership is unchanged. The checkpoint reads these artifacts for evidence but does not write lifecycle state.
- The checkpoint is collaborative and main-session only: no subagents, no Pi UI, no background automation.

## Out of Scope for v2.70

Deliberately deferred as optional future sub-checks (the five lenses are the v2.70 baseline; these may be added later without reopening the contract):

- dependency and security posture as a dedicated lens;
- git-activity churn signals (commit cadence, hotspots by change frequency);
- external-context drift (upstream dependencies, ecosystem changes).

Also out of scope for v2.70:

- any driver, Pi-extension, or UI work;
- workflow wiring into `discuss-milestone.md` (that is **Phase 297**);
- validation harness changes (that is **Phase 298**) — this contract deliberately does not name specific TAP/validation test names, and describes validation intent only generically.

## Status

Phase 296: contract + template authored; workflow integration pending (Phase 297); validation pending (Phase 298).
