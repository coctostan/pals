# Context Bloat Findings Matrix

_Date:_ 2026-03-28  
_Phase:_ 160 — Findings & Recommendation Package

## Purpose
This matrix combines the Phase 158 artifact-side audit and the Phase 159 workflow-side audit into one decision surface. It preserves the distinction between:
- **artifact cost** — what is large, dense, or repeatedly read
- **workflow amplification** — what surrounding wrappers, workflows, and duplicated contracts add on top
- **combined effects** — where both mechanisms reinforce each other

## Combined findings matrix

| Finding | Lane | Confidence | Primary evidence | Heat relevance | Recurring context impact | Candidate reduction direction |
|---|---|---|---|---|---|---|
| `STATE.md` is the primary hot artifact because Pi parses and reuses it directly | artifact | Confirmed | `pi-hot-path-read-analysis.md`; `158-artifact-growth-hot-path-report.md` | Hot | Highest recurring pressure; Pi runtime, wrappers, and workflows all depend on it | Preserve authority role, but consider a stricter hot/cold split inside `STATE.md` so routing-critical content stays compact |
| `ROADMAP.md` is the strongest secondary pressure point | artifact | Confirmed | `artifact-footprint-inventory.md`; `pi-hot-path-read-analysis.md`; `158-artifact-growth-hot-path-report.md` | Warm-to-hot | High recurring pressure when planning, status, milestone, and roadmap flows pull it repeatedly | Re-layer around a smaller active window and move older milestone detail into colder rollups/indexes |
| `PROJECT.md` is relatively healthy as the compact brief | artifact | Confirmed | `artifact-footprint-inventory.md`; `pi-hot-path-read-analysis.md`; `158-artifact-growth-hot-path-report.md` | Warm | Moderate, but comparatively efficient for its role | Preserve the compact-brief posture; do not use `PROJECT.md` as a sink for roadmap or history reduction |
| `MILESTONES.md` is large but mostly cold | artifact | Confirmed | `artifact-footprint-inventory.md`; `158-artifact-growth-hot-path-report.md` | Cold | Low recurring pressure in normal Pi use; mainly a density/history issue | Treat as archive-layering work, not an immediate hot-path fix |
| Archived handoffs are a real growth mechanism but mostly fallback-only | artifact | Confirmed | `artifact-footprint-inventory.md`; `pi-hot-path-read-analysis.md`; `158-artifact-growth-hot-path-report.md` | Cold | Low recurring pressure except resume fallback scenarios | Add archive segmentation or indexing later; not a first-wave recurring-context fix |
| Historical accumulation dominates total `.paul/` footprint | artifact | Confirmed | `artifact-footprint-inventory.md`; `158-artifact-growth-hot-path-report.md` | Cold overall | High disk/history growth, but not the main day-to-day Pi context driver | Keep separate from hot-path fixes; do not let archive size distract from repeated-read pressure |
| Pi skill shells restate workflow entry contracts already owned by shared workflows | workflow | Confirmed | `workflow-read-surface-inventory.md`; `prompt-shape-duplication-audit.md`; `159-workflow-bloat-report.md` | Hot on command entry | Moderate recurring overhead on every major route before project-specific context loads | Thin wrappers to command-local deltas only |
| Planning-adjacent workflows repeatedly bundle the same hot artifacts | workflow | Confirmed | `workflow-read-surface-inventory.md`; `prompt-shape-duplication-audit.md`; `159-workflow-bloat-report.md` | Hot / Warm | High amplification around `STATE.md`, `ROADMAP.md`, and `PROJECT.md` | Narrow required-reading bundles; default to `STATE.md`, pull `ROADMAP.md`/`PROJECT.md` only when genuinely needed or by narrower scope |
| The `PROJECT.md` first / `PRD.md` selective-read rule is correct but over-repeated | workflow | Confirmed | `prompt-shape-duplication-audit.md`; `159-workflow-bloat-report.md` | Warm planning | Moderate duplication cost without adding new semantics | Centralize the rule once per route family instead of re-explaining it in multiple nearby files |
| Module-dispatch protocol prose is a major workflow bulk driver | workflow | Confirmed | `workflow-read-surface-inventory.md`; `prompt-shape-duplication-audit.md`; `159-workflow-bloat-report.md` | Warm but heavy | High baseline route cost, especially in APPLY/UNIFY, before project-specific work begins | Compress the repeated dispatch protocol into a smaller shared contract/reference pattern while preserving visible dispatch logs |
| Resume/handoff continuity explanation is duplicated across wrapper, workflow, and reference layers | workflow | Confirmed | `prompt-shape-duplication-audit.md`; `159-workflow-bloat-report.md` | Hot on resume | High cost in low-context fresh-session scenarios | Collapse continuity explanation toward one implementation layer and keep wrappers minimal |
| Authority/additive disclaimers are repeated across docs, runtime payloads, and nearby prose | workflow | Plausible | `prompt-shape-duplication-audit.md`; `159-workflow-bloat-report.md` | Warm support | Moderate duplication; likely safe to trim if one authoritative statement remains | Centralize the stable authority/additive rule once per route/layer instead of repeating full explanations nearby |
| Guided workflow markers are intentionally duplicated and should mostly be preserved | workflow | Confirmed | `prompt-shape-duplication-audit.md`; `159-workflow-bloat-report.md` | Hot parser contract | Necessary bounded duplication; the problem is surrounding prose, not the markers | Preserve marker strings and target surrounding explanation first |
| `ROADMAP.md` cost is compounded by both size and workflow bundling | combined | Confirmed | `158-artifact-growth-hot-path-report.md`; `159-workflow-bloat-report.md` | Warm-to-hot | One of the strongest overall reduction opportunities because artifact density and workflow recurrence reinforce each other | Pair roadmap active-window compaction with narrower planning/status read discipline |
| `STATE.md` pressure is driven more by recurrence than by raw size | combined | Confirmed | `pi-hot-path-read-analysis.md`; `159-workflow-bloat-report.md` | Hot | Very high recurring pressure, but not a blanket “file too big” problem | Preserve authority and optimize within-file hot/cold separation plus surrounding workflow discipline |
| Context pain is created by both base artifacts and workflow layering, not by either lane alone | combined | Confirmed | `158-artifact-growth-hot-path-report.md`; `159-workflow-bloat-report.md` | Mixed | Highest-level explanation for user pain; fixes should be ranked across both lanes | Prefer combined prioritization instead of single-lane cleanup campaigns |
| Some planning/status paths may only need narrower roadmap windows rather than full-artifact reads | combined | Plausible | `pi-hot-path-read-analysis.md`; `159-workflow-bloat-report.md` | Warm | Potentially high leverage, but not yet token-trace-proven for every route | Test narrow-window reading rules before larger artifact redesign |
| Runtime token cost per route has not been empirically traced end-to-end | combined | Open | `158-artifact-growth-hot-path-report.md`; `159-workflow-bloat-report.md` | Mixed | Limits precision of expected savings, but not directionality | Keep future validation targeted; do not block bounded cleanup on missing full token telemetry |

## Cross-lane synthesis

### What is actually happening
1. **Artifacts create the base cost.**
   - `STATE.md` is the hot operational source.
   - `ROADMAP.md` is the main dense companion.
   - archives and historical phase files dominate footprint, but not day-to-day recurrence.

2. **Workflow layering multiplies that base cost.**
   - wrappers restate workflow preambles
   - planning/status/milestone flows re-bundle the same live artifacts
   - module dispatch contracts and continuity explanations add large fixed route budgets

3. **The strongest overall opportunities are not evenly distributed.**
   - `ROADMAP.md` is the clearest combined target
   - `STATE.md` needs precision optimization, not authority reduction
   - `PROJECT.md` and guided markers mostly belong on the preserve side

## Decision implications

### Immediate-action candidates
- Narrow planning/status required-reading bundles around `ROADMAP.md`
- Thin Pi wrapper shells to command-local deltas
- Trim repeated continuity/authority prose where a stronger nearby source already exists
- Preserve guided markers and `PROJECT.md` compact-brief behavior explicitly

### Structural-later candidates
- Re-layer `ROADMAP.md` into a smaller active window plus colder history
- Introduce a stricter hot/cold split inside `STATE.md` without weakening its authority role
- Compress module-dispatch protocol prose into a smaller reusable contract once compliance risk is understood
- Segment/index historical archives (`MILESTONES.md`, archived handoffs, older rollups) as a footprint problem, not a first-wave Pi hot-path problem

### Not recommended as a next move
- Blanket shrinking of all `.paul/*` artifacts
- Treating archives as the primary source of Pi context pain
- Replacing shared `.paul/*` authority with Pi-owned state or telemetry
- Aggressively removing guided workflow markers that the Pi parser depends on
