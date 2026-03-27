# Pi Hot-Path Read Analysis

_Date:_ 2026-03-27  
_Phase:_ 158 — Artifact Growth & Hot-Path Audit

## Scope

This analysis maps which `.paul/*` artifacts are repeatedly re-entered through Pi-era lifecycle surfaces:

- Pi extension injection / lifecycle visibility
- Pi skill entry-point required reading
- shared workflow required-reading
- archival / fallback-only access

The goal is to separate files that are large **and** repeatedly pulled into active Pi flows from files that are merely large because they preserve history.

## Evidence summary

### 1) Pi extension injection / lifecycle visibility

`drivers/pi/extensions/pals-hooks.ts` is the strongest hot-path signal in the repo because it reads and reuses `.paul/STATE.md` directly rather than only documenting it.

Key evidence:
- `drivers/pi/extensions/pals-hooks.ts:169-177` reads `.paul/STATE.md` inside `parsePalsState(...)`.
- `drivers/pi/extensions/pals-hooks.ts:435-448` re-parses state for lifecycle status/widget refresh.
- `drivers/pi/extensions/pals-hooks.ts:471-483` builds the bounded PALS context payload from `.paul/STATE.md`.
- `drivers/pi/extensions/README.md:54, 73, 136-139` documents that Pi inspects `.paul/STATE.md` for guided workflow markers, phase detection, and the primary `before_agent_start` injection path.

Observed effect:
- `.paul/STATE.md` is not just a workflow prerequisite; it is a **runtime-adjacent operational input** for Pi.
- No comparable direct extension read path was found for `.paul/ROADMAP.md`, `.paul/PROJECT.md`, or `.paul/MILESTONES.md`.

### 2) Pi skill entry-point required reading

Pi skill wrappers repeatedly name the same authority artifacts before handing off to shared workflows.

High-signal examples:
- `drivers/pi/skills/paul-apply/SKILL.md:21-22` → `.paul/STATE.md`
- `drivers/pi/skills/paul-resume/SKILL.md:20-24` → `.paul/STATE.md`
- `drivers/pi/skills/paul-status/SKILL.md:21-24` → `.paul/STATE.md`, `.paul/ROADMAP.md`
- `drivers/pi/skills/paul-plan/SKILL.md:21-25` → `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/PROJECT.md`, `.paul/PRD.md` selectively
- `drivers/pi/skills/paul-discuss/SKILL.md:22-27` → `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/PROJECT.md`, `.paul/PRD.md` selectively, `.paul/MILESTONES.md` optionally
- `drivers/pi/skills/paul-milestone/SKILL.md:28-39` → `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/MILESTONES.md`

Observed effect:
- `STATE.md` is the most frequently repeated skill-entry file.
- `ROADMAP.md` is the next most common skill-entry companion, especially for planning / status / milestone flows.
- `PROJECT.md` is common in discuss / plan, but not broadly present in status / resume / apply.
- `MILESTONES.md` appears only in milestone-history-sensitive flows.

### 3) Shared workflow required-reading

Shared workflows reinforce the same read pattern, especially for planning and resume.

High-signal examples:
- `kernel/workflows/plan-phase.md:18-24` requires `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/PROJECT.md`, and `.paul/PRD.md` selectively.
- `kernel/workflows/plan-phase.md:159-170` explicitly says to read `.paul/PROJECT.md` first as the hot-path brief, then read `.paul/PRD.md` selectively only if deeper framing is needed.
- `kernel/workflows/plan-phase.md:176-180` checks `.paul/SPECIAL-FLOWS.md` only conditionally.
- `kernel/workflows/resume-project.md:46-69` treats handoffs as active-first and archive-fallback-only.
- `kernel/workflows/roadmap-management.md:23, 43` reads `.paul/ROADMAP.md` for roadmap operations.
- `kernel/workflows/pause-work.md:149` lists `.paul/ROADMAP.md` as phase overview context.

Observed effect:
- Shared workflows already try to keep `PROJECT.md` hotter than `PRD.md`.
- `ROADMAP.md` is a frequent shared-workflow companion, but unlike `STATE.md`, it is not part of extension-time parsing.
- `SPECIAL-FLOWS.md` and archived handoffs are support-path, not default hot-path.

## Hot / Warm / Cold classification

| Artifact | Classification | Why |
|---|---|---|
| `.paul/STATE.md` | **Hot** | Directly parsed by the Pi extension (`drivers/pi/extensions/pals-hooks.ts:169-177, 435-448, 471-483`), repeatedly referenced by Pi skills (`paul-apply`, `paul-plan`, `paul-resume`, `paul-status`, `paul-unify`, etc.), and required by core shared workflows including `resume-project.md` and `plan-phase.md`. |
| `.paul/ROADMAP.md` | **Warm-to-hot** | Repeatedly required by planning / status / milestone / roadmap workflows and Pi wrappers (`drivers/pi/skills/paul-status/SKILL.md:21-24`, `drivers/pi/skills/paul-plan/SKILL.md:21-25`, `kernel/workflows/plan-phase.md:18-24`, `kernel/workflows/roadmap-management.md:23,43`), but not directly parsed by the extension on every lifecycle event. |
| `.paul/PROJECT.md` | **Warm** | Intentionally treated as the planning hot-path brief (`kernel/workflows/plan-phase.md:159-163`) and repeatedly named in discuss / plan flows, but not part of extension-time lifecycle parsing and less universal than `STATE.md`. |
| `.paul/MILESTONES.md` | **Cold** | Large, but mostly historical. It appears in discuss / milestone history flows (`drivers/pi/skills/paul-discuss/SKILL.md:22-27`, `drivers/pi/skills/paul-milestone/SKILL.md:34-39`, `kernel/workflows/discuss-milestone.md:23`) rather than always-on lifecycle entry points. |
| `.paul/PRD.md` | **Cold-to-warm (selective)** | Explicitly marked selective in discuss / plan flows (`drivers/pi/skills/paul-plan/SKILL.md:21-25`, `kernel/workflows/plan-phase.md:18-24,159-163`). Important when needed, but not default every-run context. |
| `.paul/SPECIAL-FLOWS.md` | **Cold / support-only** | Checked conditionally during planning (`kernel/workflows/plan-phase.md:176-180`) rather than loaded broadly. |
| `.paul/HANDOFF*.md` active | **Warm support-path** | Used by resume when present, but not part of always-on Pi extension parsing. |
| `.paul/handoffs/archive/*` | **Cold** | Resume treats archived handoffs as fallback only after checking active handoffs first (`kernel/workflows/resume-project.md:46-69`). |

## Relative heat by explicit mention count in Pi-era surfaces

Using the selected Pi extension, Pi skills, shared workflows, and templates only:

| Artifact | Explicit hits | Distinct files | Main path types |
|---|---:|---:|---|
| `.paul/STATE.md` | 31 | 20 | extension runtime, Pi skills, shared workflows, templates |
| `.paul/ROADMAP.md` | 16 | 11 | Pi skills, shared workflows, templates |
| `.paul/PROJECT.md` | 13 | 9 | Pi skills, shared workflows, templates |
| `.paul/PRD.md` | 6 | 4 | selective planning / discussion support |
| `.paul/MILESTONES.md` | 3 | 3 | milestone-history / discussion only |
| `.paul/SPECIAL-FLOWS.md` | 1 | 1 | conditional planning support |

## Read-path map by entry type

### Pi extension injection / lifecycle visibility
- Primary artifact: `STATE.md`
- Why: direct parse, status/widget rendering, bounded context payload, guided-workflow detection
- Conclusion: this is the clearest repeated context re-entry path

### Pi skill entry-point required reading
- Primary artifacts: `STATE.md`, `ROADMAP.md`
- Secondary artifact: `PROJECT.md`
- Conditional artifacts: `PRD.md`, `MILESTONES.md`
- Conclusion: skill wrappers repeatedly name the same authority files before deeper workflow logic begins

### Shared workflow required-reading
- Primary artifacts: `STATE.md`, `ROADMAP.md`, `PROJECT.md`
- Conditional artifacts: `PRD.md`, `SPECIAL-FLOWS.md`, handoffs
- Conclusion: workflow design already tries to keep deeper product context selective, but `STATE.md` and `ROADMAP.md` recur heavily

### Archival / reference-only access
- Primary artifacts: archived handoffs, `MILESTONES.md`, older milestone rollups
- Conclusion: these are large, but usually not hot unless the user is resuming historical context or auditing prior milestones

## What is causing repeat-read pressure

1. **`STATE.md` is the only confirmed always-nearby hot artifact.**
   Its pressure comes from recurrence, not from raw file size.

2. **`ROADMAP.md` is the most important secondary pressure source.**
   It appears broadly enough in planning / status / milestone paths that its 628-line size is more likely to matter than `PROJECT.md`'s 309-line size.

3. **`PROJECT.md` is intentionally positioned as a compact hot-path brief.**
   That design is directionally correct; it shows up in planning flows, but less universally than `STATE.md` or `ROADMAP.md`.

4. **`MILESTONES.md` is big, but mostly not hot.**
   Its problem is accumulation and density, not repeated injection into everyday Pi lifecycle entry.

5. **Archived handoffs are clearly cold inventory, not primary hot-path context.**
   They matter for footprint and resume fallbacks, but they are not being pulled on every Pi lifecycle surface.

## Boundary for Phase 159

This file is about **read-path mechanics**, not whether the surrounding workflow prose is too verbose. The evidence so far supports two separate follow-on questions:

- **Artifact lane (Phase 158 / 160):** which authority files are too large or too dense for how often they are reused?
- **Workflow lane (Phase 159):** which prompts, wrappers, or lifecycle instructions are causing redundant reads or redundant textual restatement around those same artifacts?
