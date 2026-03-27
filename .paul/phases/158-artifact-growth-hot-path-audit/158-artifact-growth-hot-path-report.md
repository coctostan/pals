# Phase 158 Artifact Growth & Hot-Path Report

_Date:_ 2026-03-27  
_Phase:_ 158 — Artifact Growth & Hot-Path Audit

## Executive summary

Phase 158 confirms that PALS has **two different artifact-cost problems**:

1. **Total artifact growth is dominated by historical accumulation** — especially `.paul/phases/`, archived handoffs, and milestone rollups.
2. **Active Pi context pressure is concentrated in a much smaller set of live authority files** — above all `.paul/STATE.md`, with `.paul/ROADMAP.md` as the main secondary companion.

Those are related, but they are not the same problem. The biggest files are not automatically the hottest files.

## Confirmed Findings

### Confirmed 1 — Historical artifacts dominate total footprint

Evidence:
- `.paul/` currently contains **534 files**, **82,241 lines**, and **3.66 MB**.
- `.paul/phases/` alone accounts for **63,827 lines** and **2.94 MB**.
- `.paul/handoffs/archive/` adds **9,436 lines** across **91 files**.
- `.paul/milestones/` adds **6,006 lines** across **18 files**.
- Together, phases + archived handoffs + milestone rollups contribute **96.4%** of all `.paul/` lines.

Implication:
- The main growth mechanism is long-lived accumulation, not runaway expansion of the core authority set.

### Confirmed 2 — `STATE.md` is the primary hot-path artifact in Pi-era flows

Evidence:
- `drivers/pi/extensions/pals-hooks.ts` directly parses `.paul/STATE.md` (`parsePalsState`) and reuses it for lifecycle UI and bounded context injection.
- The Pi extension README documents `.paul/STATE.md` as the authoritative source for guided workflow detection, phase detection, and `before_agent_start` injection.
- Within the selected Pi-era surfaces, `.paul/STATE.md` had the highest explicit reference count: **31 hits across 20 files**.

Implication:
- `STATE.md` creates recurring context cost because it is repeatedly consulted, not because it is especially large.
- Any artifact-side improvement that reduces hot-path repeated reads must account for `STATE.md` first.

### Confirmed 3 — `ROADMAP.md` is the strongest secondary hot-path pressure point

Evidence:
- `.paul/ROADMAP.md` is **628 lines**, materially larger than `STATE.md` and repeatedly named in plan / status / milestone / roadmap workflows.
- In the selected Pi-era surfaces, it had **16 explicit hits across 11 files**.
- It is common in Pi skill entry points (`paul-plan`, `paul-status`, `paul-discuss`, `paul-milestone`) and shared workflows (`plan-phase`, `roadmap-management`, `create-milestone`, `pause-work`, `transition-phase`).

Implication:
- `ROADMAP.md` is not as hot as `STATE.md`, but it is large enough and common enough to be a real context-cost candidate.

### Confirmed 4 — `PROJECT.md` is serving the intended “compact brief” role better than `ROADMAP.md`

Evidence:
- `plan-phase.md` explicitly says to read `.paul/PROJECT.md` first as the hot-path brief and consult `.paul/PRD.md` selectively only when deeper framing is required.
- `.paul/PROJECT.md` is **309 lines**, much smaller than `ROADMAP.md` and `MILESTONES.md`.
- It appears in discuss / plan flows, but not in the extension’s always-nearby runtime path.

Implication:
- The layered `PROJECT.md` + selective `PRD.md` design is directionally correct.
- `PROJECT.md` does not look like the main artifact-side bloat driver.

### Confirmed 5 — `MILESTONES.md` is large, but mostly cold

Evidence:
- `.paul/MILESTONES.md` is the largest live authority file at **739 lines**.
- In the selected Pi-era read surfaces, it appears only in milestone-history-sensitive flows (`paul-discuss`, `paul-milestone`, `discuss-milestone`).

Implication:
- `MILESTONES.md` is a real size/density issue, but not a primary repeated-read issue for day-to-day Pi lifecycle entry.
- Its pressure is mostly archival / historical rather than always-on hot path.

### Confirmed 6 — Archived handoffs are a real growth mechanism, but mostly cold

Evidence:
- `.paul/handoffs/archive/` now contains **91 files** and **9,436 lines**.
- `resume-project.md` checks active handoffs first and only falls back to archive when no active handoff is available.

Implication:
- Archived handoffs materially enlarge the artifact corpus.
- They are not a primary Pi hot-path burden except for resume fallback scenarios.

## Plausible Findings

### Plausible 1 — `ROADMAP.md` is closer to a problematic size/density threshold than `STATE.md`

Reasoning:
- `STATE.md` is hotter, but still only 153 lines.
- `ROADMAP.md` is much larger, frequently reused, and partially overlaps with information already archived in `.paul/milestones/*`.

Why still “plausible” rather than fully confirmed:
- Phase 158 shows recurrence and size, but not actual token-by-token cost under real model reads.
- Phase 159 still needs to separate artifact cost from prompt / workflow duplication around the same file.

### Plausible 2 — `MILESTONES.md` and milestone rollups may be duplicating too much retained history in the live tree

Reasoning:
- `MILESTONES.md` is large on its own, and `.paul/milestones/` adds 18 milestone rollup files on top.
- That suggests a likely duplication / layering opportunity.

Why still “plausible”:
- Phase 158 measured growth but did not perform content-diff analysis between the live milestone log and per-milestone rollups.

### Plausible 3 — Archived handoffs have crossed the threshold where segmentation or indexing would help

Reasoning:
- 91 archived handoffs is enough that archive growth is no longer trivial.
- Resume already treats them as fallback only, which means a large amount of retained text is intentionally cold.

Why still “plausible”:
- Phase 158 did not test whether the current archive size causes practical discovery or resume friction beyond raw footprint.

## Open Questions

### Open 1 — How much of perceived Pi context bloat comes from artifact size vs workflow wording around the same artifacts?

Phase 158 isolated the artifact side. It did **not** measure how much duplication is coming from wrapper skills, shared workflows, guided UX markers, or repeated explanatory prose.

### Open 2 — How often does `ROADMAP.md` get read in practice versus merely listed as required-reading?

The repo clearly marks it as required in many places, but Phase 158 did not instrument runtime read frequency.

### Open 3 — Which `STATE.md` sections are genuinely required on the hot path?

The file is operationally hot, but Phase 158 did not yet separate routing-critical content from historical / decision-log density inside `STATE.md` itself.

## Candidate Fix Directions

These are artifact-side recommendations only. They do **not** implement changes and they do **not** attempt to solve workflow-prose issues that belong to Phase 159.

### 1) Keep `STATE.md` authoritative, but consider a stricter hot/cold split inside it

Candidate direction:
- Preserve the current “live routing” role of `STATE.md`.
- Explore moving long-tail historical detail (especially old decision ledger weight) into a linked companion artifact while keeping the top of `STATE.md` optimized for phase / loop / next-action / session continuity.

Why this is bounded:
- It targets artifact density, not workflow semantics.

### 2) Re-layer `ROADMAP.md` around a smaller active window

Candidate direction:
- Keep the current milestone and immediate next phases in the hot path.
- Shift older milestone detail toward per-milestone archived rollups, summaries, or compact indexes so the live roadmap stops acting as a long history file.

Why this is bounded:
- It addresses artifact layering without changing lifecycle truth.

### 3) Segment `MILESTONES.md` as a durable archive rather than a forever-growing hot-path-adjacent file

Candidate direction:
- Retain a compact live milestone ledger and move older milestone records into version-windowed or date-windowed milestone history artifacts.

Why this is bounded:
- It targets historical accumulation while preserving durable records.

### 4) Treat archived handoffs as a managed cold archive

Candidate direction:
- Add an index, periodic compaction strategy, or older-archive segmentation so `.paul/handoffs/archive/` remains browseable without growing as one undifferentiated bucket.

Why this is bounded:
- Resume logic already treats archive as fallback-only; this would align storage shape with actual access pattern.

### 5) Preserve `PROJECT.md` as the compact brief and resist expanding it to absorb other history

Candidate direction:
- Keep `PROJECT.md` intentionally short and stable.
- Do not “solve” roadmap / milestone / state bloat by turning `PROJECT.md` into another long-lived history sink.

Why this matters:
- Phase 158 found `PROJECT.md` is one of the few artifacts already behaving roughly as intended.

### 6) Use explicit hot / warm / cold artifact classes in later design work

Candidate direction:
- Future artifact redesign should treat:
  - `STATE.md` as **hot**
  - `ROADMAP.md` / `PROJECT.md` as **warm**
  - `MILESTONES.md`, archived handoffs, historical phase outputs as mostly **cold**

Why this matters:
- The measurement shows that “largest” and “most expensive in context” are not the same ranking.

## What stays in the artifact lane vs Phase 159

### Stays in the artifact lane
- authority-file compaction
- live/archive layering
- milestone / handoff segmentation
- hot/cold artifact boundaries
- reducing duplication between live files and archive rollups

### Hand off to Phase 159 workflow audit
- whether wrapper skills and workflows restate too much surrounding prose
- whether required-reading lists are broader than necessary for the same task
- whether Pi guided UX surfaces add unnecessary textual repetition around already-authoritative artifacts
- whether read-order / prompt-shape, rather than artifact design, is causing the user’s perceived bloat

## Phase 159 Hand-off

Phase 159 should assume the following as already established:

1. **The artifact corpus is big mainly because history accumulates.**
   Re-doing raw size measurement should not be necessary.

2. **`STATE.md` is the confirmed hot artifact.**
   Workflow audit should treat it as the key repeated-read anchor.

3. **`ROADMAP.md` is the main warm-path file to watch.**
   If workflow bloat is amplifying artifact cost, `ROADMAP.md` is the likely secondary amplifier.

4. **`MILESTONES.md` and archived handoffs are mainly growth / density issues, not primary hot-path issues.**
   Workflow audit should not over-focus on them unless it finds real recurrence evidence.

5. **The next open question is not “are artifacts growing?” but “how much extra cost comes from workflow behavior around those artifacts?”**

## Bottom line

Phase 158 does **not** support a blanket conclusion that “all `.paul/*` artifacts are too big.”

It supports a narrower, stronger conclusion:
- **Historical accumulation is the main footprint problem.**
- **`STATE.md` is the main repeat-read hot-path artifact.**
- **`ROADMAP.md` is the most credible secondary artifact-side context-cost candidate.**
- **Most other large artifacts are cold enough that they should be treated as archive / layering problems, not immediate hot-path problems.**
