# Prompt-Shape Duplication Audit

_Date:_ 2026-03-27  
_Phase:_ 159 — Workflow Bloat Audit

## Scope
This audit looks for repeated prompt structure around hot artifacts rather than artifact size itself. The target question is: where do Pi skill shells, shared workflows, references, and extension behavior restate the same instructions closely enough to inflate recurring context cost?

## Pattern 1 — Pi skill shells restate workflow preambles that the shared workflow already owns
### Evidence
- `drivers/pi/skills/paul-plan/SKILL.md:21-35` says to read `STATE.md`, `ROADMAP.md`, `PROJECT.md`, optional `PRD.md`, then `plan-phase.md`, `PLAN.md`, `plan-format.md`, and `modules.yaml`.
- `kernel/workflows/plan-phase.md:18-24` immediately declares the same required-reading set again inside `<required_reading>`.
- `drivers/pi/skills/paul-apply/SKILL.md:21-34` restates `STATE.md` + current plan + `apply-phase.md` + `modules.yaml`.
- `kernel/workflows/apply-phase.md:17-20` then repeats the same core read contract inside its own `<required_reading>` block.
- `drivers/pi/skills/paul-resume/SKILL.md:20-36` says to read `STATE.md`, the full workflow, and handoffs; `kernel/workflows/resume-project.md:24-31, 46-69` then carries the full resume/handoff process.

### Why it matters
The skill shell does add command-local orientation, but most of its structural work is restating the workflow’s own preamble. That means each canonical command path begins with two nearby layers describing the same entry contract.

### Impact on recurring context cost
- Adds roughly **44-60 lines** of wrapper text per command before the shared workflow starts.
- Keeps the wrapper layer coupled to the workflow layer, so artifact lists and execution notes must stay synchronized in two places.

## Pattern 2 — The same hot artifact bundles are repeatedly declared across planning-adjacent workflows
### Evidence
Repeated `<required_reading>` bundles include:
- `plan-phase.md:18-24` → `STATE.md + ROADMAP.md + PROJECT.md + optional PRD + modules`
- `discuss-phase.md:21-25` → `STATE.md + PROJECT.md + optional PRD + ROADMAP.md`
- `discuss-milestone.md:19-23` → `STATE.md + PROJECT.md + optional PRD + MILESTONES.md`
- `roadmap-management.md:22-25` → `ROADMAP.md + STATE.md`
- `create-milestone.md:17-20` → `STATE.md + ROADMAP.md + milestone context`

Observed recurrence across workflow required-reading blocks:
- `STATE + PROJECT` in **7** workflows
- `STATE + ROADMAP` in **7** workflows
- `STATE + PROJECT + ROADMAP` in **5** workflows
- `STATE + PROJECT + PRD` in **4** workflows

### Why it matters
This is not just one workflow being verbose. The same live artifacts are being re-bundled as the default context set for planning, discussion, status, and milestone shaping.

### Impact on recurring context cost
`ROADMAP.md` in particular looks workflow-amplified: it is not a runtime-hot file like `STATE.md`, but it is repeatedly bundled whenever the workflow wants phase framing, status, or milestone scope.

## Pattern 3 — The `PROJECT.md` hot-path / `PRD.md` selective-read rule is repeated across multiple files
### Evidence
- `plan-phase.md:159-163` says to read `PROJECT.md` first as the hot-path brief and consult `PRD.md` selectively only when deeper framing materially helps.
- `discuss-phase.md:23-25, 113` repeats the same model for phase discussion.
- `discuss-milestone.md:21-22, 111` repeats the same model for milestone shaping.
- `phase-assumptions.md:9, 66-67` repeats the same layered artifact rule again.

### Why it matters
The rule itself is good. Phase 158 already found `PROJECT.md` is behaving correctly as the compact brief. The duplication problem is not the policy; it is that the same policy is hand-restated in multiple planning-adjacent workflows.

### Impact on recurring context cost
This is a classic “good rule, repeated too many times” case. The rule protects context, but restating it everywhere consumes context too.

## Pattern 4 — Module-dispatch contract boilerplate is a major workflow-length driver
### Evidence
- `apply-phase.md:261-269` defines pre-apply dispatch.
- `apply-phase.md:465-484` defines post-apply advisory dispatch.
- `apply-phase.md:489-507` defines post-apply enforcement dispatch.
- `unify-phase.md:178-191` defines pre-unify dispatch.
- `unify-phase.md:278-291` defines post-unify dispatch.
- The same core ideas repeat each time: read `modules.yaml`, warn if missing, resolve hook details, sort by priority, load hook refs, follow descriptions, report skip/block/pass.

### Why it matters
The module system is real behavior, not just prose, but the dispatch scaffolding has been copied into every major lifecycle workflow. That grows the workflow files even when the actual per-phase module behavior is relatively small.

### Impact on recurring context cost
This is the clearest example of workflow bloat that is independent of artifact size. `apply-phase.md` is **723 lines** and `unify-phase.md` is **614 lines`; repeated dispatch protocol is one major reason.

## Pattern 5 — Resume/handoff continuity is described at three different layers
### Evidence
- `kernel/references/context-management.md:135-182` explains light vs full continuity, `STATE.md` session continuity, `HANDOFF.md`, and session commands.
- `drivers/pi/skills/paul-resume/SKILL.md:26-36` repeats active-vs-archived handoff selection and archive-after-resume behavior in shorter wrapper form.
- `kernel/workflows/resume-project.md:46-69` then gives the full active/archive handoff detection process again.
- `pause-work.md:16-24, 29-35, 169-170` carries the companion side of the same continuity model.

### Why it matters
The concept is valid, but the lifecycle guidance is fragmented across a reference doc, a wrapper shell, and the workflow implementation. That raises the resume path’s text surface before the actual user-specific handoff content even loads.

### Impact on recurring context cost
Resume is one of the most likely fresh-session entry points, so duplicated continuity prose is expensive in exactly the scenario where context is already scarce.

## Pattern 6 — Authority/additive disclaimers are restated in docs, runtime payload, and guided UX
### Evidence
- `drivers/pi/extensions/README.md:54-58` says guided workflow is additive only and `.paul/*` remains authoritative.
- `drivers/pi/extensions/README.md:135-139` repeats the event-hook model and again says the extension is not the architectural center of injection.
- `drivers/pi/extensions/pals-hooks.ts:471-483` injects a bounded PALS payload that again says delegated APPLY is bounded and shared `.paul/*` artifacts remain authoritative.
- `drivers/pi/extensions/pals-hooks.ts:659-660` comments that guided workflow detection uses recent assistant messages plus authoritative `STATE.md` context.

### Why it matters
The safety message is directionally correct and should remain somewhere. The issue is that the same “authoritative `.paul/*`, additive-only Pi layer” explanation is repeated in multiple nearby layers.

### Impact on recurring context cost
This is low-risk duplication to trim because it is conceptually stable and already reinforced by code structure. It likely does not need to appear in full form in every nearby surface.

## Pattern 7 — Guided workflow prompts are intentionally duplicated across shared workflow output and extension parsing
### Evidence
- `plan-phase.md:279-286` emits the review menu: `Would you like to see the plan?` with options 1-4.
- `plan-phase.md:335-349` emits `Continue to APPLY?`.
- `apply-phase.md:665-679` emits `Continue to UNIFY?`.
- `drivers/pi/extensions/README.md:54-56` says the extension inspects canonical markers such as `Would you like to see the plan?`, `Continue to APPLY`, `Continue to UNIFY`, `CHECKPOINT:`, and `▶ NEXT:`.
- `drivers/pi/extensions/pals-hooks.ts:659-680` contains the actual parser for those same planning-review strings.

### Why it matters
This duplication is partly intentional: the extension needs stable markers from the shared workflow output. So this is not “waste” in the same sense as repeated boilerplate. It is still a recurring prompt-shape multiplier because the same semantics exist in both emitted workflow text and parser logic.

### Impact on recurring context cost
This is probably a **bounded** rather than **eliminable** duplication. The optimization target is surrounding explanatory prose, not the canonical markers themselves.

## Pattern 8 — Some duplication is healthy and should not be treated as pure waste
Not all repetition is bad.

Healthy duplication includes:
- canonical review / continue prompts that the extension must detect reliably
- one authoritative workflow plus a minimal command-local wrapper
- selective-read reminders for `PRD.md` when they prevent a larger context mistake

The audit therefore distinguishes between:
- **structural duplication worth reducing** — repeated boilerplate, repeated read bundles, repeated dispatch protocol
- **stability duplication worth preserving** — canonical markers and a small amount of guardrail wording

## Summary
The strongest recurring prompt-shape bloat patterns are:
1. wrapper shells restating workflow preambles
2. repeated hot artifact bundles across planning/status/milestone flows
3. repeated `PROJECT.md` / `PRD.md` layering guidance
4. copied module-dispatch scaffolding across APPLY and UNIFY
5. repeated continuity/handoff explanation around resume flows
6. repeated authority/additive disclaimers around the Pi adapter

That is enough to treat workflow wording and layering as a real multiplier on top of the artifact-side cost isolated in Phase 158.
