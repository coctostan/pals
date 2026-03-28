# Workflow Read-Surface Inventory

_Date:_ 2026-03-27  
_Phase:_ 159 — Workflow Bloat Audit

## Scope and method
This inventory stays in the workflow lane opened by Phase 158. It reviews the repo source copies of the Pi extension, Pi skill shells, and the highest-signal shared workflows to identify where hot artifacts are re-pulled into context.

Primary evidence sources:
- `drivers/pi/extensions/pals-hooks.ts:168-187, 471-483, 659-680, 1274-1290`
- `drivers/pi/extensions/README.md:54-58, 135-139`
- `drivers/pi/skills/paul-plan/SKILL.md:21-35`
- `drivers/pi/skills/paul-apply/SKILL.md:21-34`
- `drivers/pi/skills/paul-resume/SKILL.md:20-36`
- `drivers/pi/skills/paul-status/SKILL.md:21-28`
- `kernel/workflows/plan-phase.md:18-24, 158-159`
- `kernel/workflows/apply-phase.md:17-20, 261-269, 465-490`
- `kernel/workflows/resume-project.md:24-31, 46-69`
- `kernel/workflows/roadmap-management.md:22-45`
- `kernel/workflows/discuss-phase.md:21-25, 113`
- `kernel/workflows/discuss-milestone.md:19-23, 111`

## Surface inventory

| Surface | Lines | Primary artifact pulls | Why it re-enters context | Hotness |
|---|---:|---|---|---|
| `drivers/pi/extensions/pals-hooks.ts` | 1331 | `STATE.md` | Runtime parses `.paul/STATE.md`, builds bounded injection, derives next action, and detects guided workflow moments from canonical prompts plus state | **Hot** |
| `drivers/pi/extensions/README.md` | 174 | `STATE.md`, `modules.yaml` | Documents the same runtime contract: guided workflow markers, `before_agent_start` injection, additive-only Pi behavior, authoritative `.paul/*` semantics | Cold docs, but duplicates the runtime model |
| `drivers/pi/skills/paul-plan/SKILL.md` | 60 | `STATE.md`, `ROADMAP.md`, `PROJECT.md`, optional `PRD.md`, `modules.yaml` | Wrapper immediately re-lists the planning artifact bundle, then routes into `plan-phase.md`, `PLAN.md`, and `plan-format.md` | **Hot** when planning |
| `kernel/workflows/plan-phase.md` | 374 | `STATE.md`, `ROADMAP.md`, `PROJECT.md`, optional `PRD.md`, prior summary, `modules.yaml` | Shared planning authority; repeats the read bundle and then adds planning posture, module dispatch, template, review, and state-update rules | **Hot** when planning |
| `drivers/pi/skills/paul-apply/SKILL.md` | 57 | `STATE.md`, current `PLAN.md`, `modules.yaml` | Wrapper restates approval, workflow load, and module-registry load before delegating to `apply-phase.md` | **Hot** when executing |
| `kernel/workflows/apply-phase.md` | 723 | `STATE.md`, current `PLAN.md`, `modules.yaml` | Core APPLY logic. Even before task execution it carries GitHub Flow preflight, skill checks, worktree setup, and repeated module-dispatch blocks | **Hot** when executing |
| `drivers/pi/skills/paul-resume/SKILL.md` | 50 | `STATE.md`, handoffs | Wrapper re-reads state, asks for active/archive handoff discovery, then routes into `resume-project.md` | **Hot** on fresh-session resume |
| `kernel/workflows/resume-project.md` | 268 | `STATE.md`, handoffs, `modules.yaml` | Resume routing depends on `STATE.md`, then spends substantial space on handoff discovery, fallback, archive lifecycle, and git-aware routing | **Hot** on resume |
| `drivers/pi/skills/paul-status/SKILL.md` | 49 | `STATE.md`, `ROADMAP.md`, `pals.json` | Thin status wrapper over roadmap-management routing | Warm recurring |
| `kernel/workflows/roadmap-management.md` | 456 | `STATE.md`, `ROADMAP.md` | Status/progress logic repeatedly pairs live state with the roadmap phase table and git-aware routing | Warm recurring |
| `drivers/pi/skills/paul-milestone/SKILL.md` | 53 | `STATE.md`, `ROADMAP.md`, milestone context, `MILESTONES.md` | Wrapper for create/complete milestone paths | Warm planning surface |
| `kernel/workflows/create-milestone.md` | 285 | `STATE.md`, `ROADMAP.md`, milestone context | Milestone creation reuses state + roadmap and later points resume routing back at `ROADMAP.md` | Warm planning surface |
| `kernel/workflows/discuss-phase.md` | 288 | `STATE.md`, `PROJECT.md`, optional `PRD.md`, `ROADMAP.md` | Discussion path explicitly bundles all planning artifacts and repeats the `PROJECT.md` hot-path / `PRD.md` selective-read rule | Warm planning surface |
| `kernel/workflows/discuss-milestone.md` | 305 | `STATE.md`, `PROJECT.md`, optional `PRD.md`, `MILESTONES.md` | Milestone discussion does the same selective-brief pattern with prior milestone history added | Warm planning surface |
| `kernel/workflows/pause-work.md` | 299 | `STATE.md`, `PROJECT.md`, handoffs | Pause path uses state for current position, then creates richer handoff artifacts for future resume | Warm continuity surface |
| `kernel/workflows/unify-phase.md` | 614 | `STATE.md`, current `PLAN.md`, `modules.yaml` | UNIFY needs loop state and plan truth, then adds two more large module-dispatch sections and transition routing | Warm but heavy |

## Artifact pull counts in the workflow layer
Across the inspected workflow files with `<required_reading>` sections:
- `.paul/STATE.md` appears in **12 of 14** workflow required-reading blocks.
- `.paul/ROADMAP.md` appears in **7 of 14** workflow required-reading blocks.
- `.paul/PROJECT.md` appears in **8 of 14** workflow required-reading blocks.
- `.paul/PRD.md` appears in **4 of 14** workflow required-reading blocks, usually with selective-read wording.
- `modules.yaml` appears in **3 core workflows** (`plan-phase`, `apply-phase`, `unify-phase`), but those workflows then repeat module-registry handling in multiple later steps.

Across the Pi skill shells:
- **10 of 12** skill shells open with a `Read project state:` step.
- **9** explicitly list `.paul/STATE.md`.
- `paul-plan`, `paul-status`, `paul-milestone`, and `paul-discuss` also bring `ROADMAP.md` into the wrapper layer before the shared workflow even starts.

## Reused read bundles
The repeated hot bundles are not identical in every file, but the same combinations recur:
- `STATE + PROJECT` appears together in **7** workflow required-reading blocks.
- `STATE + ROADMAP` appears together in **7** workflow required-reading blocks.
- `STATE + PROJECT + ROADMAP` appears together in **5** workflow required-reading blocks.
- `STATE + PROJECT + PRD` appears together in **4** workflow required-reading blocks.

This means the same live artifacts are not just authoritative; they are repeatedly bundled as the default planning/discussion context set.

## Declared route budgets before project-specific reads
These are rough, static line-count budgets from the files the route explicitly tells the model to read before doing phase-specific work:

| Route | Declared scaffolding load |
|---|---:|
| `/paul:plan` | **1,345 lines** = `paul-plan/SKILL.md` (60) + `plan-phase.md` (374) + `PLAN.md` template (337) + `plan-format.md` (263) + installed `modules.yaml` (311) |
| `/paul:apply` | **1,091 lines** minimum = `paul-apply/SKILL.md` (57) + `apply-phase.md` (723) + installed `modules.yaml` (311) |
| `/paul:resume` | **753 lines** = `paul-resume/SKILL.md` (50) + `resume-project.md` (268) + `context-management.md` (219) + `loop-phases.md` (216) |

These budgets do **not** include the actual project artifacts (`STATE.md`, `ROADMAP.md`, current `PLAN.md`, handoff files) that the route then reads on top.

## Hot / Warm / Cold classification
### Hot
These surfaces are likely to recur in normal Pi use and directly amplify hot artifacts:
- `drivers/pi/extensions/pals-hooks.ts`
- `drivers/pi/skills/paul-plan/SKILL.md`
- `kernel/workflows/plan-phase.md`
- `drivers/pi/skills/paul-apply/SKILL.md`
- `kernel/workflows/apply-phase.md`
- `drivers/pi/skills/paul-resume/SKILL.md`
- `kernel/workflows/resume-project.md`

### Warm
These surfaces are important but less per-turn or less per-loop:
- `drivers/pi/skills/paul-status/SKILL.md` + `kernel/workflows/roadmap-management.md`
- milestone/discussion workflows
- `pause-work.md`
- `unify-phase.md`

### Cold
These files document or map the behavior rather than driving day-to-day context directly:
- `drivers/pi/extensions/README.md`
- `drivers/pi/skill-map.md`

## Read-surface findings
1. **The extension makes `STATE.md` hot in runtime, not just in markdown workflows.** `parsePalsState()` and `before_agent_start` make it the live source for milestone, phase, loop, and next-action extraction.
2. **Planning paths are the broadest workflow-side bundlers.** `plan-phase.md`, `discuss-phase.md`, and `discuss-milestone.md` consistently pull `STATE.md` plus roadmap/brief artifacts together.
3. **`ROADMAP.md` is mainly a warm-path amplifier.** It is not as runtime-central as `STATE.md`, but status, milestone, and planning surfaces repeatedly call for it.
4. **Resume/handoff logic is concentrated rather than universal, but it is dense.** `resume-project.md` and `pause-work.md` carry most of the handoff lifecycle weight.
5. **Module dispatch adds repeated workflow-side overhead to plan/apply/unify even before actual module work is needed.** The registry is conceptually one source, but the dispatch contract is restated in each large workflow.

## Bottom line
The main workflow-side pull points are not random. They cluster around three layers:
1. **Pi runtime/state layer** — `pals-hooks.ts` keeps `STATE.md` hot.
2. **Pi wrapper layer** — skill shells restate which artifacts and workflow files to load.
3. **Shared workflow layer** — plan/apply/resume/status/milestone workflows re-declare overlapping artifact bundles and then add large process prose on top.

That is enough evidence to move from “artifacts are read often” to “workflow layering itself is adding recurring context pressure around the same artifacts.”
