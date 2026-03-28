# Phase 160 Findings & Recommendation Package Report

_Date:_ 2026-03-28  
_Milestone:_ v2.35 Context Bloat Audit & Reduction Strategy  
_Phase:_ 160 — Findings & Recommendation Package

## Executive summary
Phase 160 closes the context-bloat milestone by combining the two completed evidence lanes:
- **Phase 158** measured artifact growth and hot-path read pressure
- **Phase 159** measured workflow-side amplification around those same artifacts

The combined conclusion is narrower and stronger than a generic “PALS has too much markdown” claim:
- **historical accumulation is the main footprint problem**
- **`STATE.md` is the main recurring hot-path artifact**
- **`ROADMAP.md` is the clearest secondary pressure point because both artifact density and workflow bundling amplify it**
- **workflow layering adds meaningful recurring overhead on top of artifact cost**
- **the best next milestone is a bounded combined cleanup, not a redesign of lifecycle truth**

## What the milestone established

### 1) Artifact size and context pain are related, but not identical
The repo has a large historical corpus, but most of that mass lives in prior phase outputs, archived handoffs, and milestone rollups. Those matter for storage and long-term readability, but they are not the main source of repeated Pi context pressure.

### 2) `STATE.md` is operationally hot because Pi reuses it constantly
The main issue with `STATE.md` is not raw size. It is recurrence. Pi runtime surfaces and multiple workflow routes repeatedly depend on it.

### 3) `ROADMAP.md` is the strongest combined reduction target
Unlike `STATE.md`, `ROADMAP.md` is not runtime-parsed on every event. But it is large enough to matter and repeatedly pulled into planning, status, and milestone routes. That makes it the most obvious place where artifact density and workflow bundling reinforce each other.

### 4) Workflow duplication is a real multiplier
Wrapper preambles, repeated required-reading bundles, copied module-dispatch protocol, and duplicated continuity/authority prose all add recurring cost before project-specific work even begins.

### 5) Not all duplication is bad
Canonical guided markers and the `PROJECT.md` compact-brief model are doing real work and should be preserved unless a better contract is proven.

## Top recommendations

### Recommendation 1 — Narrow required-reading bundles around `ROADMAP.md`
This is the best first move because it targets the strongest confirmed combined amplifier without weakening artifact authority.

### Recommendation 2 — Thin Pi skill wrappers to command-local deltas
This is the safest workflow-only reduction and should land early.

### Recommendation 3 — Trim repeated continuity and authority prose
This is especially valuable on resume/fresh-session paths where duplicated explanation is expensive.

### Recommendation 4 — Treat preservation decisions as explicit guardrails
The next milestone should explicitly preserve:
- `STATE.md` authority
- `PROJECT.md` as the compact brief
- canonical guided markers
- artifact-first lifecycle truth

### Recommendation 5 — Delay hotter structural changes until after tactical cleanup
`ROADMAP.md` restructuring, `STATE.md` hot/cold splitting, and module-dispatch prose compression are valuable, but should come after the lower-risk workflow-side cleanup proves what pressure remains.

## Recommended next-step sequence

### Now
Run one implementation milestone focused on bounded reduction work:
1. narrow `ROADMAP.md` read discipline in planning/status/milestone routes
2. slim Pi wrappers to true command-local guidance
3. reduce repeated continuity/authority prose where one nearby source already owns the rule
4. preserve guided markers and `PROJECT.md` behavior explicitly as non-goals for trimming

### Next
After that tactical pass, evaluate the remaining pressure and decide whether to:
- re-layer `ROADMAP.md` into a smaller active window
- split `STATE.md` more cleanly into hot vs colder historical content
- compress module-dispatch protocol into a smaller reusable contract

### Later
Treat cold archive growth as a separate maintenance track:
- milestone history segmentation
- archived handoff indexing/compaction
- phase/archive organization improvements

## Guardrails
The next milestone should keep these constraints explicit:
- shared `.paul/*` artifacts remain the authoritative lifecycle source
- Pi remains additive, not the owner of workflow truth
- guided workflow markers remain stable unless a replacement parser contract is validated
- `PROJECT.md` must not become a history sink used to hide roadmap/state bloat elsewhere
- archive-growth work and hot-path work should remain separate categories even if both are eventually addressed

## What not to do
- **Do not** start with a risky `STATE.md` redesign before safer workflow-side reductions land
- **Do not** treat all `.paul/*` artifacts as equally expensive
- **Do not** use telemetry, Pi-owned persistence, or hidden runtime state as a shortcut around artifact discipline
- **Do not** trim canonical guided markers just because they appear in both workflow text and parser logic
- **Do not** reopen Phases 158 and 159 as discovery work unless new evidence appears

## Recommended next milestone
A reasonable follow-on milestone is:

**v2.36 Context Reduction Implementation — Workflow-First Pass**

Suggested focus:
- implement the top tactical recommendations from Phase 160
- preserve authority semantics explicitly
- validate that context reduction happened without harming guided workflow reliability
- defer hotter artifact restructures until the tactical pass is proven

## Handoff
Phase 160 provides the final decision package for v2.35.

A future milestone should begin from:
- `.paul/phases/160-findings-recommendation-package/context-bloat-findings-matrix.md`
- `.paul/phases/160-findings-recommendation-package/context-reduction-recommendations-ranked.md`
- this report

It should treat Phases 158 and 159 as closed evidence collection, not as open questions to be re-audited immediately.

## Bottom line
The correct recommendation is not “shrink everything.”

It is:
- **reduce workflow amplification first**
- **target `ROADMAP.md` as the clearest combined opportunity**
- **preserve `STATE.md` authority while delaying hotter structural changes until safer reductions land**
- **treat archive growth as a separate longer-term maintenance problem**
