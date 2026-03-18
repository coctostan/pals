# Phase 71: Proof & Visibility Guidance

This document defines the recommended long-term balance between module proof, live visibility, validation, and end-report summaries after Phases 68-70.

## Core Recommendation
Use a **layered proof model**:
- **dispatch logs** for in-session traceability,
- **`Module Execution Reports`** for durable end-of-loop evidence,
- **`side_effects`** for non-blocking follow-on actions,
- **validation suites** for contract-level confidence,
- **Pi live visibility** for bounded real-time legibility.

Do **not** collapse these into a single ledger, telemetry system, or Pi-owned source of truth.

## Governing Principles
1. **Artifacts remain authoritative.** If a module result matters beyond the immediate moment, it must land in shared artifacts or be derivable from them.
2. **Live visibility is not proof by itself.** Pi can surface recent activity, but it should stay adapter-only and non-authoritative.
3. **Silence is sometimes correct.** Conditional and advisory modules should not be forced to appear on every run.
4. **Durability belongs at loop close.** The summary is where persistent proof should become legible, especially for post-unify modules.
5. **Validation should prove contracts, not simulate telemetry.** The test suites should keep proving the evidence path and guardrails, not pretend to be runtime observability.

## Recommended Roles by Surface

| Surface | What it is for | What it should claim | What it should not claim |
|--------|-----------------|----------------------|--------------------------|
| **`[dispatch] ...` logs** | Immediate in-session trace of which hook stage ran and which modules participated | "These modules were invoked at this stage in this session output" | Full durable proof across sessions, or a complete historical audit trail |
| **`Module Execution Reports`** | Durable summary evidence carried into `SUMMARY.md` / `FIX-SUMMARY.md` | "These module outputs materially survived finalization and belong in the end report" | That every enabled module ran, or that omitted modules necessarily failed |
| **`side_effects`** | Non-blocking follow-on actions such as history updates or suggestion capture | "This module also performed or suggested a follow-on action" | Durable proof on their own unless also summarized in a report block |
| **Validation suites** | Deterministic proof that the shared contract, registry semantics, and adapter guardrails remain intact | "The system still preserves the intended evidence/visibility path" | Live execution proof for every runtime/session permutation |
| **Pi live visibility** | Compact real-time legibility in status/widget surfaces | "Here is the most recent trustworthy module activity signal available right now" | Persistent module truth, hidden history, or stronger authority than shared artifacts |

## Recommended Proof Model

### 1. Dispatch logs = short-lived execution trace
Dispatch output such as:
- `[dispatch] pre-plan: ...`
- `[dispatch] post-apply: ...`
- `[dispatch] post-unify: ...`

should remain the first layer of visibility during an active run.

Recommendation:
- keep dispatch wording canonical and compact
- use it as the primary live signal for Pi
- do not try to retain every dispatch event as a durable history store

Why:
- dispatch lines are perfect for "what just fired"
- they are a poor fit for long-lived cross-session truth

### 2. `Module Execution Reports` = durable proof
`Module Execution Reports` should remain the single durable summary surface for module participation that materially matters after loop close.

Recommendation:
- preserve the Phase 69 rule that finalization happens after post-unify work can contribute
- keep `module_reports` as the durable input for this section
- continue omitting the section entirely when no module evidence survives finalization

Why:
- this preserves one clear end-of-loop proof surface
- it prevents summaries from implying stronger evidence than actually exists

### 3. `side_effects` = visible but secondary
`side_effects` should remain a separate category from durable module reports.

Recommendation:
- treat `side_effects` as support information, not as equivalent to report blocks
- summarize them only when they materially help the user understand what happened
- keep them non-blocking and avoid forcing every side effect into a large permanent ledger

Examples:
- WALT appending quality history
- SKIP producing knowledge-entry suggestions
- follow-on notes that are useful but not the main proof artifact

### 4. Validation = contract assurance
Validation should keep answering:
- does the durable evidence path still exist?
- does Pi still derive live module visibility from canonical shared signals?
- do docs/specs/template/workflows still agree?

Recommendation:
- keep validation static, deterministic, and contract-oriented
- extend only when a new contract or guardrail is added
- avoid tests that imply registry presence alone proves execution
- avoid tests that require hidden adapter state or flaky live-agent simulations

### 5. Pi live visibility = bounded situational awareness
Pi status/widget surfaces should remain a convenience layer over shared workflow/reporting output plus shared artifacts.

Recommendation:
- keep live visibility derived-only
- keep it bounded to recent trustworthy signals
- let it clear naturally when no trustworthy signal exists
- do not persist module activity via `appendEntry` or a custom Pi ledger

Why:
- Pi is best at making the current run legible
- shared artifacts are still the long-term source of truth

## End-Report Guidance

## What `SUMMARY.md` / `FIX-SUMMARY.md` should do
End reports should make module participation legible **without pretending every module was active**.

Recommended rules:
1. Include `## Module Execution Reports` only when durable module evidence survives finalization.
2. Give each contributing module its own subsection.
3. Prefer concise, outcome-oriented wording over raw hook mechanics.
4. Preserve the difference between:
   - **durable report content** (`module_reports`)
   - **recorded follow-on actions** (`side_effects`)
5. If a module was enabled but produced no durable evidence, do **not** invent a filler subsection just to prove coverage.

### Recommended subsection posture
- **WALT**: durable quality delta / quality posture belongs here
- **SKIP**: durable knowledge-capture summary belongs here; optional suggestions may be referenced as side effects
- **RUBY**: durable debt/refactor guidance belongs here when post-unify review produced something worth preserving
- **TODD / DEAN / DAVE / DOCS / IRIS**: persist only if their outputs materially survive through the existing reporting path; avoid forced boilerplate

### Recommended omission rule
Absence of a module subsection should mean only:
- no durable module report survived finalization for that run

It should **not** be interpreted as:
- the module is fake
- the module never ran
- the adapter failed

## Visibility Guidance by Time Horizon

### Now
- keep the current layered proof model
- use dispatch logs for live traceability
- use `Module Execution Reports` for durable evidence
- keep Pi live visibility derived and lightweight
- improve report wording for proof-bearing modules where value is easiest to miss

### Later
- refine summary language and validation messaging so users better understand conditional vs durable vs advisory module behavior
- selectively improve late-surface modules such as SKIP and RUBY where post-unify value can otherwise feel invisible

### Defer
- telemetry pipelines
- cross-session module-history ledgers
- Pi-owned execution truth
- forced module dashboards
- merge/remove decisions driven only by visibility anxiety rather than evidence

## Recommended Guardrails
- Do not infer module execution from registry presence alone.
- Do not use Pi to persist its own module activity history.
- Do not treat advisory modules as failures when they remain silent off-path.
- Do not reopen the Phase 69 `module_reports` / `side_effects` split unless evidence shows an actual contradiction.
- Do not add summary boilerplate that claims more certainty than the artifacts support.

## Bottom Line
The right long-term model is not "more telemetry."
It is **clearer separation of roles**:
- dispatch for immediate trace,
- `Module Execution Reports` for durable proof,
- `side_effects` for non-blocking follow-on actions,
- validation for contract confidence,
- Pi for bounded live legibility.

That balance preserves portability, keeps `.paul/*` authoritative, and makes module participation understandable without creating a second execution ledger.
