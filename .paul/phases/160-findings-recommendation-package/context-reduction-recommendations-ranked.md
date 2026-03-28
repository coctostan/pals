# Context Reduction Recommendations — Ranked

_Date:_ 2026-03-28  
_Phase:_ 160 — Findings & Recommendation Package

## Ranking method
Recommendations are ranked using four factors:
1. **expected context-value** — likely reduction in recurring Pi context pressure
2. **evidence strength** — how directly Phases 158-159 support the move
3. **implementation risk** — chance of destabilizing workflow behavior or authority semantics
4. **authority safety** — whether `.paul/*` remains the clear lifecycle truth source

## Tactical-now
These are the highest-confidence, bounded next moves.

### 1) Narrow required-reading bundles around `ROADMAP.md`
- **Rank:** 1
- **Type:** tactical-now
- **Problem addressed:** `ROADMAP.md` is the main warm-path artifact, and workflow bundling makes it more expensive than its size alone would suggest.
- **Proposed change:** Update planning/status/milestone routes so `ROADMAP.md` is pulled only where the route genuinely needs full milestone/phase framing, or by narrower windows/sections when possible.
- **Expected user/context value:** High. This targets one of the strongest combined artifact + workflow amplifiers.
- **Implementation risk:** Medium. Read-discipline changes can accidentally remove useful planning context if done too aggressively.
- **Evidence strength:** Strongly confirmed by Phases 158 and 159.
- **Authority-safety posture:** Strong. `ROADMAP.md` remains authoritative; the change is about narrower use, not replacement.
- **Recommended timing:** First implementation wave.
- **Why now:** It attacks the highest-value secondary pressure point without changing the authority model.

### 2) Thin Pi skill shells to true command-local deltas
- **Rank:** 2
- **Type:** tactical-now
- **Problem addressed:** Pi wrappers repeat workflow entry contracts that the shared workflows immediately restate.
- **Proposed change:** Keep only command-local orientation, route hints, and workflow paths in Pi skill shells; remove repeated artifact lists and process prose that the shared workflow already owns.
- **Expected user/context value:** High on frequently used routes like plan/apply/resume.
- **Implementation risk:** Low-to-medium. The main risk is making wrappers too terse for reliable command-local orientation.
- **Evidence strength:** Strongly confirmed by Phase 159.
- **Authority-safety posture:** Strong. This simplifies the wrapper layer without touching lifecycle truth.
- **Recommended timing:** First implementation wave.
- **Why now:** It is one of the safest workflow-only reductions available.

### 3) Trim repeated continuity and authority prose while preserving one strong statement per layer
- **Rank:** 3
- **Type:** tactical-now
- **Problem addressed:** Resume/handoff explanation and additive-authority disclaimers are described in too many nearby places.
- **Proposed change:** Keep one strong authoritative statement per route/layer, then remove nearby restatements that do not add unique meaning.
- **Expected user/context value:** Medium-to-high, especially on resume/fresh-session paths.
- **Implementation risk:** Low. The semantics are already stable and reinforced structurally.
- **Evidence strength:** Confirmed for continuity duplication; plausible-to-strong for authority-disclaimer overuse.
- **Authority-safety posture:** Strong, if one clear statement is retained.
- **Recommended timing:** First implementation wave.
- **Why now:** It reduces prompt density without changing behavior.

### 4) Preserve guided markers and `PROJECT.md` compact-brief behavior explicitly
- **Rank:** 4
- **Type:** tactical-now (preserve)
- **Problem addressed:** Some duplication looks tempting to trim but is actually useful and stabilizing.
- **Proposed change:** Treat canonical guided markers and the `PROJECT.md`-first / `PRD.md`-selective model as explicit preserve-by-design constraints in the next milestone.
- **Expected user/context value:** Medium. This prevents false savings that would break parser reliability or recreate bloat elsewhere.
- **Implementation risk:** Low.
- **Evidence strength:** Strongly confirmed by Phases 158 and 159.
- **Authority-safety posture:** Very strong.
- **Recommended timing:** Immediate guardrail in any follow-on work.
- **Why now:** Reduction work needs non-goals as much as goals.

## Structural-later
These are good candidates, but they should follow the tactical-now work or be validated carefully first.

### 5) Re-layer `ROADMAP.md` around a smaller active window
- **Rank:** 5
- **Type:** structural-later
- **Problem addressed:** `ROADMAP.md` is both large enough to matter and reused often enough to amplify that size.
- **Proposed change:** Keep current milestone plus immediate next phases in the live roadmap, and shift older milestone detail into colder rollups, indexes, or archived milestone views.
- **Expected user/context value:** High if done well.
- **Implementation risk:** Medium-to-high. Roadmap restructuring can affect planning, status, milestone, and transition flows.
- **Evidence strength:** Strong.
- **Authority-safety posture:** Strong if the live roadmap remains authoritative for active work.
- **Recommended timing:** Second wave, after workflow-side narrowing proves where the real remaining pain is.
- **Why later:** It is valuable, but broader and more coupled than wrapper/read-discipline cleanup.

### 6) Introduce a stricter hot/cold split inside `STATE.md`
- **Rank:** 6
- **Type:** structural-later
- **Problem addressed:** `STATE.md` is operationally hot because Pi repeatedly parses it, even though the file is not huge.
- **Proposed change:** Keep top-of-file routing-critical data compact and move long-tail historical density into linked companions or colder sections that Pi/runtime paths do not need every time.
- **Expected user/context value:** High on the hottest path.
- **Implementation risk:** High. `STATE.md` is the most sensitive authority artifact in Pi-era flows.
- **Evidence strength:** Strong on the problem, but the right split still needs careful design.
- **Authority-safety posture:** Medium-to-strong, depending on whether the split keeps one clear authoritative state surface.
- **Recommended timing:** Second wave, after safer workflow-side reductions land.
- **Why later:** This touches the hottest artifact and should not be the first experiment.

### 7) Compress repeated module-dispatch protocol into a reusable contract
- **Rank:** 7
- **Type:** structural-later
- **Problem addressed:** APPLY/UNIFY carry large amounts of duplicated dispatch procedure prose.
- **Proposed change:** Replace repeated dispatch boilerplate with a smaller shared protocol/reference pattern while preserving visible dispatch logs, missing-registry warnings, and hook ordering clarity.
- **Expected user/context value:** Medium-to-high on heavy lifecycle routes.
- **Implementation risk:** High. Existing verbosity may be helping model compliance.
- **Evidence strength:** Strong on duplication, weaker on the safe lower bound for shortening.
- **Authority-safety posture:** Strong if dispatch evidence remains explicit.
- **Recommended timing:** Second wave with validation.
- **Why later:** This is a prime compression target, but it needs proof that shorter wording still executes reliably.

### 8) Segment cold archives as an archive-management track, not a hot-path track
- **Rank:** 8
- **Type:** structural-later
- **Problem addressed:** `.paul/phases/`, archived handoffs, and milestone rollups dominate total footprint.
- **Proposed change:** Introduce indexing, segmentation, or archive compaction for cold historical material.
- **Expected user/context value:** Medium overall; lower direct Pi hot-path benefit than the higher-ranked items.
- **Implementation risk:** Medium.
- **Evidence strength:** Strong for total footprint, weak for direct recurring-context benefit.
- **Authority-safety posture:** Strong.
- **Recommended timing:** Separate archive-management effort after hot-path work.
- **Why later:** Important for corpus growth, but not the first answer to everyday Pi context pain.

## Combined strategy recommendation

### Recommended next milestone shape
The best next move is **not** artifact-only or workflow-only.

It should be a **combined reduction milestone** with this sequencing:
1. **Workflow-first tactical cleanup**
   - narrow `ROADMAP.md` reads
   - thin Pi wrappers
   - trim duplicated continuity/authority prose
   - preserve markers and `PROJECT.md` explicitly
2. **Measure the remaining pain after those changes**
   - confirm whether `ROADMAP.md` still needs structural compaction
   - confirm whether `STATE.md` needs a hot/cold split
3. **Then do structural artifact work only where the tactical pass leaves clear residual pressure**

This sequencing is preferred because it captures large likely savings without risking the hottest authority files first.

## What should be preserved
- `.paul/*` remains the authoritative lifecycle source
- `STATE.md` remains the authoritative operational state artifact
- `PROJECT.md` remains the compact brief rather than becoming a new history sink
- guided workflow marker strings remain stable unless a better parser contract is proven
- archive growth and hot-path cost remain treated as separate problems

## What should not be done next
- Do not launch a blanket rewrite of all `.paul/*` artifacts
- Do not treat archive size as proof of hot-path pain
- Do not replace lifecycle truth with Pi-owned state, memory, or telemetry
- Do not start with a risky `STATE.md` redesign before safer workflow-side reductions land
- Do not trim guided markers just because they are duplicated; they are part of a working parser contract

## Bottom line
The ranking supports a practical order:
1. **reduce workflow amplification first where the evidence is strongest and risk is lowest**
2. **then restructure the specific artifacts that still prove too expensive after that**
3. **keep authority and parser-stability rules explicit so reduction work does not become semantic drift**
