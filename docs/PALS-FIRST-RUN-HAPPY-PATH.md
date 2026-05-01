# PALS First-Run Happy Path — One Tiny Plan/Apply/Unify Loop

**Phase:** 240 Product Happy Path + Scenario Evidence
**Plan:** 240-01
**Status:** Active — first-run scenario evidence

This document walks one concrete tiny end-to-end PALS loop on a toy project and names exactly what PALS protected or saved at each step. It exists to make the product story tangible, not to replace any command, validation, or `.paul/*` lifecycle artifact.

## Purpose

Phase 234's maintainability and product-reality audit (`docs/PALS-MAINTAINABILITY-PRODUCT-REALITY-AUDIT.md`) ranked "first-run product story is dense" as weakness #5: a new user can understand that PALS is safe before they feel what it does for them. Adoption needs a simpler happy path. The audit's critical-review companion (`docs/PALS-CRITICAL-REVIEW-NEXT-ROADMAP.md`) recommended a single small scenario doc that shows what PALS protects and saves in one concrete loop, kept small enough not to become another brittle validation surface.

This is that doc. It walks `init → plan → apply → unify` on a deliberately tiny scenario. It is reading material, not code, not a benchmark, and not a contract. Read once. Then run the real commands on a real project. Trust those commands' output, not this prose.

### Reading map

If the rest of this doc is more time than you have, three pointers cover most of what a first-run user needs:

- For lifecycle truth on a live project: read `.paul/STATE.md`, then the latest `.paul/phases/{phase}/{plan}-SUMMARY.md`. Those two files describe the current position.
- For the command surface: read `README.md` Quick Start. The `/paul:init`, `/paul:plan`, `/paul:apply`, `/paul:unify` chain is the entire loop.
- For the protections this doc names: read the five subsections under **Walkthrough — Five Named Protections** below. Each one is short and tied to one step of the loop.

Everything else here is context, examples, and friction notes — useful but not essential to running PALS.

## Authority and Non-Goals

Authority: Derived aid only.

`.paul/*` artifacts (`STATE.md`, `ROADMAP.md`, `MILESTONES.md`, `PROJECT.md`, `PRD.md`, `phases/{phase}/{plan}-PLAN.md`, `phases/{phase}/{plan}-SUMMARY.md`, `CODI-HISTORY.md`, `quality-history.md`, `handoffs/**`) and the project's own validation command output remain the only sources of lifecycle truth. The walkthrough below is orientation prose; it is not a command, not a workflow, not a contract clause, and not a substitute for any of them.

Concretely, this scenario does NOT replace or relax:

- `/paul:init`, `/paul:plan`, `/paul:apply`, `/paul:unify`, `/paul:resume`, `/paul:fix`, `/paul:status`, `/paul:milestone`, `/paul:review`, `/paul:pause`, `/paul:unpause`, `/paul:help`, or any other `/paul-*` / `/skill:paul-*` command surface. Real lifecycle work runs through those commands.
- Full authoritative reads of `.paul/*` artifacts before edits, before approving a plan, before APPLY, before lifecycle writes, on stale or ambiguous facts, on decisions, and on validation pass/fail. Pi artifact-slice context is itself a derived aid only — the full read is still required.
- Parent-owned APPLY. `pals-implementer` and any other helper agent are bounded delegates only. Helpers do not own `.paul/*` writes, official validation authority, module gate satisfaction, checkpoint completion, GitHub Flow / CI / review / merge readiness, or lifecycle truth.
- Module evidence. ARCH, IRIS, RUBY, SETH, DEAN, DAVE, PETE, REED, VERA, OMAR, LUKE, ARIA, GABE, DANA, DOCS, TODD, WALT, CODI run their advisory and enforcement hooks. Their reports are recorded; the parent decides PASS / BLOCK by reading them.
- GitHub Flow gates. Branching, push, PR creation, CI, review, base-branch sync, and merge intent require real `git` / `gh` command output. The Pi guided workflow may surface routing prompts, but it sends a canonical transcript reply only after explicit confirm/select user action. No auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent.
- Validation command output. `bash tests/<your-suite>.sh`, `npm test`, `pytest`, `cargo test`, `go test`, `eslint`, `tsc --noEmit`, etc. — whatever the project actually uses — produce the only count-of-record pass/fail evidence.

This doc also does NOT claim PALS is universally faster, universally safer, or universally cheaper. It describes what PALS *did* in the documented loop only. Generalizations require real evidence on real projects, which this scenario does not provide.

## Scenario Setup

Imagine a tiny repo. Pick whatever stack you like — the scenario does not depend on it. For concreteness, picture either:

- A two-file Node project: `package.json` plus `src/greet.js` exporting one function `greet(name)` that returns a string. Tests under `test/greet.test.js` run via `npm test` and currently pass.
- Or a one-file Python project: `greet.py` exposing `def greet(name) -> str`, plus a `tests/test_greet.py` run via `pytest`.
- Or even a single-file documentation repo: `README.md` with a typo in the project name.

The scenario is the same shape regardless of stack: there is one obvious change to make, the project has its own real verification command, and the change is small enough to follow without losing track of what PALS is doing. Pick the change that fits. For this walkthrough, assume the change is "rename the function `greet` to `greet_user` and update the one test that calls it" — small, multi-file, not just cosmetic, and verifiable by the project's own tests.

The user opens a Pi session in the toy project root and runs `/paul:init` for the first time.

### Pre-walkthrough: what `/paul:init` lays down

Before the loop starts, `/paul:init` writes the lifecycle skeleton at `.paul/`:

- `.paul/STATE.md` — authoritative lifecycle state (current milestone, phase, plan, loop position, decisions, session continuity).
- `.paul/PROJECT.md` — project context: language, structure, conventions, authority rules.
- `.paul/PRD.md` — product requirements (what is being built and why).
- `.paul/ROADMAP.md` — milestones broken into phases.
- `.paul/MILESTONES.md` — milestone-level rollup.
- `.paul/phases/` — empty directory ready to receive `{phase}-{slug}/{NN-MM}-PLAN.md` and `{NN-MM}-SUMMARY.md` per loop.
- `.paul/handoffs/` — for pause/resume continuity files.
- `.paul/CODI-HISTORY.md` and `.paul/quality-history.md` — module-owned append logs that grow one row per UNIFY.

Nothing in the project source has been touched yet. `/paul:init` writes only under `.paul/` (plus a project-root `pals.json` configuration file). The user reads `.paul/STATE.md` and `.paul/ROADMAP.md`, edits the milestone framing if needed, and then proceeds to the first plan.

## Walkthrough — Five Named Protections

Each subsection below shows one PALS step on the toy scenario, then names what PALS protected or saved at that step. The protections are listed in the order they activate during a normal loop.

### 1. Plan approval boundary

After `/paul:init` writes `.paul/STATE.md`, `.paul/PROJECT.md`, `.paul/ROADMAP.md`, and the rest of the lifecycle skeleton, the user runs `/paul:plan`. PALS reads `.paul/STATE.md` and `.paul/ROADMAP.md`, runs the pre-plan module dispatch (CODI symbol extraction, ARCH layer detection, DEAN dependency check, DOCS doc-drift check, etc.), and produces an executable plan at `.paul/phases/{phase}/{plan}-PLAN.md` with frontmatter, tasks, boundaries, acceptance criteria, verification commands, and a clearly named scope.

The plan is then presented to the user for approval. Nothing in the project has been modified yet. The user reads the plan, edits it if needed, and explicitly approves it ("approved", "execute", "go"). Only then does APPLY begin.

What PALS protected here is the **plan approval boundary**. There is no "auto-execute on first plausible plan" path. Even when the user delegates plan creation to a helper, the boundary is parent-owned and explicit. This is the moment that prevents an agent from rewriting half the toy project on a misread of intent. The plan is also a durable artifact — if the user closes the session and returns later, the same approved plan can be executed without re-deriving it from chat context.

Concretely on the toy scenario, the user sees something like:

```
Plan ready at .paul/phases/01-rename-greet-function/01-01-PLAN.md
  Tasks: 2 (rename function in src/greet.js; update test/greet.test.js)
  Boundaries: do not modify package.json, do not touch README.md
  Verify: npm test reports 5 passed
Approve execution? [yes / edit plan / no]
```

The project files are still untouched at this prompt. `yes` is required, not assumed.

### 2. Scoped implementation

The user runs `/paul:apply .paul/phases/{phase}/{plan}-PLAN.md`. APPLY reads the approved plan, performs the GitHub Flow preflight (creates the feature branch, refreshes base, checks behind/ahead), runs pre-apply baselines (the project's own test/lint commands), and executes the plan tasks in order. For the toy scenario, that means editing `src/greet.js` to rename the function, updating the call in the test, and nothing else.

If a task tried to edit a file outside the plan's `<files>` list — say, adding a config change, or touching `package.json`, or rewriting the README — the boundary check stops it. Workguard scope reports plus the per-task `<files>` ground-truth check (post-task, `git diff --name-only` is compared against the planned file list) catch out-of-scope edits before they accumulate. Helper-delegated work runs the same gates: the parent inspects the helper's structured report, runs `git diff --name-only`, and rejects the result if files outside `Allowed files:` were touched.

What PALS protected here is **scoped implementation**. The plan said "rename one function and update one test"; APPLY did exactly that. Out-of-scope edits trigger boundary handling instead of silently piling up. This is what makes a multi-task plan reviewable: every change has a named place in the plan, and changes without one are visible.

Concretely, after APPLY, the user can run:

```
$ git diff --name-only
src/greet.js
test/greet.test.js
```

That list matches the plan's `<files>` exactly. If `package.json` had appeared there, APPLY would have flagged the divergence and stopped before marking the task complete.

### 3. Verification command truth

After tasks execute, APPLY runs the post-apply enforcement cohort. WALT compares the project's actual test/lint/typecheck command output against the pre-apply baseline. The toy project's `npm test` (or `pytest`, or whatever the suite is) runs end-to-end and reports its own pass/fail counts. SETH grep-checks for new secrets or injection patterns. DEAN re-checks dependency posture. DOCS confirms no doc drift. TODD confirms test infrastructure is intact.

PASS for the phase is not "the agent thinks it worked." PASS is the project's own verification command exiting 0 with the expected count. If `npm test` reports `Tests: 1 failed, 4 passed` instead of the previous `Tests: 5 passed`, APPLY does not mark the phase as complete. It surfaces the regression and offers fix / skip / stop. The user makes the call.

What PALS protected here is **verification command truth**. There is no "narrative PASS" — no claim that the change is fine because it looks fine. The project's existing verification command is the count-of-record. PALS records the baseline before APPLY, re-runs the same command after APPLY, and compares. This is also what keeps PALS honest across sessions: a future SUMMARY can cite specific count deltas, not vibes.

On the toy scenario, the recorded evidence reads like:

```
Pre-APPLY baseline: npm test → Tests: 5 passed
Post-APPLY result:  npm test → Tests: 5 passed
WALT: no regression vs baseline.
```

If the post-APPLY line had said `4 passed, 1 failed`, the phase would have stayed at APPLY ✓ → UNIFY ○ until the user fixed the regression or explicitly accepted the deviation as a documented decision.

### 4. Summary / lifecycle continuity

The user runs `/paul:unify .paul/phases/{phase}/{plan}-PLAN.md`. UNIFY reconciles plan-vs-actual: it reads the approved plan and the recorded execution evidence, lists deviations and decisions, captures helper reports, runs the post-unify hooks (CODI appends a row to `.paul/CODI-HISTORY.md`, WALT appends a row to `.paul/quality-history.md`), enforces the GitHub Flow merge gate (if applicable), and writes a durable SUMMARY at `.paul/phases/{phase}/{plan}-SUMMARY.md`.

The SUMMARY is human-readable and self-contained. It records what was actually done, which acceptance criteria were met, which tasks deviated and why, what the validation count was before and after, what decisions were taken (with their rationale), and what is carried forward to the next phase. It cites the plan, the validation command output, the module reports, the PR (if a github-flow remote is configured), and the relevant `.paul/*` artifacts.

What PALS protected here is **summary / lifecycle continuity**. A future session — same project, same person, weeks later — can open `.paul/phases/{phase}/{plan}-SUMMARY.md` and reconstruct what happened without re-running the loop, without re-reading every diff, and without depending on chat history that may no longer exist. The SUMMARY is the lifecycle artifact, not the chat. This is the difference between an agent run that leaves no trace and a project that accumulates its own institutional memory.

### 5. Resume state

The user closes the session. Maybe it is end of day; maybe a meeting; maybe a week off. Later, in a fresh Pi session with no prior context, the user opens the toy project and runs `/paul:resume`.

`/paul:resume` reads `.paul/STATE.md` (the authoritative lifecycle truth file), checks for active or archived handoffs in `.paul/HANDOFF*.md` and `.paul/handoffs/archive/HANDOFF*.md`, optionally surfaces git/PR state for github-flow projects, and reports exactly one suggested next action: continue to the next phase's PLAN, finish a UNIFY, address a blocker, or merge an open PR.

What PALS protected here is **resume state**. The cost of stopping is small. The user did not have to remember which phase was active, which plan was approved, which task was last executed, whether the PR was open, whether CI was passing, whether a checkpoint was waiting, or whether a handoff existed. STATE.md plus the latest SUMMARY plus `.paul/handoffs/` carry the position. The user redirects only when the suggested next action is wrong.

This is also why parent-owned APPLY matters across sessions, not just within one. The next session inherits a tree of `.paul/*` artifacts that were written by the parent under explicit approval, not opaque helper state. Lifecycle truth survives the session boundary because it was never bound to the session in the first place.

Concretely, the resume report on the toy scenario looks like:

```
Project: toy-greet
Phase: 1 of 1 — Rename greet function
Plan: 01-01 — completed
  PLAN ✓   APPLY ✓   UNIFY ✓
NEXT: /paul:milestone (close this milestone) or /paul:plan (next phase)
```

The user did not have to remember any of that.

## After the Loop — Durable Artifacts

When the toy loop finishes, the project root contains the source change (`src/greet.js`, `test/greet.test.js`) and an updated `.paul/` tree. The lifecycle artifacts that survive the session are:

- `.paul/STATE.md` — updated to show `PLAN ✓ APPLY ✓ UNIFY ✓` for plan `01-01`, with the next-action pointer cleared or updated.
- `.paul/phases/01-rename-greet-function/01-01-PLAN.md` — the approved plan, frozen as the binding scope of record.
- `.paul/phases/01-rename-greet-function/01-01-SUMMARY.md` — the durable reconciliation: tasks executed, validation deltas, deviations, decisions, module reports, optional PR reference, carry-forward.
- `.paul/CODI-HISTORY.md` — one new row per UNIFY (R/U/K counts and blast-radius outcome, or a `skipped-no-symbols` row when no extractable symbols apply).
- `.paul/quality-history.md` — one new row per UNIFY (validation count delta, regression direction, source command).
- `.paul/handoffs/archive/` — any handoff consumed during resume is archived here so future sessions can still trace the pause/resume chain.

The source-control story is equally bounded: `git log --oneline` shows one or more commits authored against the feature branch (when `git.workflow: "github-flow"` is on), and — if a remote is configured — a PR was opened, CI ran, and the merge gate cleared before `main` advanced. Without a remote, the same evidence shape is local: branch, commits, validation output. Either way, the project state is reconstructible from the artifacts above; no part of the loop depends on chat scrollback.

A reviewer joining the project the next day reads `.paul/STATE.md`, then the latest `01-01-SUMMARY.md`, then — if needed — the underlying plan and command output. That sequence answers "where is the project, and how did it get here?" without re-running the loop.

## What This Scenario Does NOT Prove

This walkthrough is one toy loop with one tiny change. It is bounded by intent.

- **Not a benchmark.** It does not measure how fast PALS finishes a phase, how cheap it is in tokens, or how it compares to any other tool. Those questions need real projects, real measurement, and command-output evidence.
- **Not a universal-speedup claim.** PALS does not promise to be faster on every task. Some tasks are slower under PALS *because* of the plan/approve/verify cadence. That is the point. The cost is intentional.
- **Not a proof that PALS prevents all drift.** The plan approval boundary, scope checks, and validation gates catch many failure modes; they do not catch every failure mode. A poorly written plan can still ship a wrong change. A bypass of `.paul/*` (deleting STATE.md, force-merging without UNIFY, hand-editing artifacts) breaks the guarantees. The protections rely on running the loop, not on the existence of the files.
- **Not a substitute for real validation runs.** Reading this doc does not replace running `bash tests/pi-end-to-end-validation.sh`, `bash tests/cross-harness-validation.sh`, `npm test`, `pytest`, `cargo test`, the project's lints, its typechecks, its security scans, or any other validation surface. Validation is command output, not narrative.
- **Not a runtime-behavior guarantee for users with different stacks.** The toy scenario uses a generic "rename function" change; real projects have monorepos, build systems, generated code, integration tests with external services, CI matrices, secret stores, and a hundred other variables. The shape of the protections holds; the specifics of what happens in your project depend on your project.
- **Not a contract surface.** This doc has no enforcement weight. It is not graded by `tests/cross-harness-validation.sh` beyond a single marker-presence assertion that confirms it exists with the expected derived-aid language and the five named protections above. It does not appear in `docs/PI-NATIVE-*-CONTRACT.md` and it does not gate any phase.
- **Not a replacement for `.paul/*` reads.** When the agent or the user needs lifecycle truth, the answer is in `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/MILESTONES.md`, `.paul/phases/{phase}/{plan}-PLAN.md`, `.paul/phases/{phase}/{plan}-SUMMARY.md`, `.paul/handoffs/`, and the matching command output. Not in this doc.

## Onboarding Friction Notes

These are the rough edges the Phase 240 scenario surfaces. Naming them is part of the audit's recommended output, so they are listed here even though Phase 240 does not fix them. They are candidates for later phases, and they are visible to a real first-run user.

- **Install path is heavy for a toy project.** `./install.sh` performs full canonical-skill / Pi-extension / agent installation and assumes an existing Pi runtime. A user who only wants to *try* PALS on a one-file scenario currently sets up the supported runtime first. A bounded "demo-mode" or "ephemeral install" path is not in scope today; users who do not already run Pi pay setup cost before they get to the loop.
- **Eighteen modules is a lot to absorb on day one.** Each module is bounded and most are advisory, but the names, hook timing, and dispatch evidence form a real cognitive load on the first phase. A new user typically only sees a small subset of module reports actually fire on a tiny doc-only or rename-only change; the architecture is wider than the typical session.
- **GitHub Flow gates are non-bypassable, including for first-run experimentation.** That is an intentional safety property, but a first-run user on a personal toy project can be surprised that PALS expects a feature branch, a PR (when remote is configured), CI, and merge checks even for a one-line change. The remedy is to run the toy project against a local-only github-flow config or with `git.workflow: "none"`; that workflow toggle is itself something a new user has to discover.
- **No bundled "demo project" preset.** This scenario is described in prose. A user has to materialize their own toy repo and pick a real change. A future phase could ship an opt-in tiny example repository (separate from the production install path) so the walkthrough can run end-to-end without imagination. This is explicitly out of Phase 240 scope per the tier contract — adding a fixture would create a new validation surface against the audit's caution about brittle scenario suites.
- **First-run users may not realize how much state lives in `.paul/*`.** The lifecycle artifacts are the durable contract; chat is not. A new user can spend the first session treating the chat as the source of truth and only later discover that STATE.md / ROADMAP.md / SUMMARY.md were the load-bearing surfaces all along. The reframing happens organically by the third or fourth phase, but a more explicit early signpost would shorten the gap.

---

Created: Phase 240 / Plan 240-01.
Derived aid only. `.paul/*` artifacts and command-output validation remain authoritative lifecycle truth. This doc does not replace `/paul:init`, `/paul:plan`, `/paul:apply`, `/paul:unify`, `/paul:resume`, full authoritative reads, parent-owned APPLY, lifecycle writes, GitHub Flow gates, module evidence, validation command output, no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, or no inferred merge intent.

For lifecycle truth, run the real commands; for context, read the real `.paul/*` artifacts; this doc is only the reading-map orientation that points to both.
