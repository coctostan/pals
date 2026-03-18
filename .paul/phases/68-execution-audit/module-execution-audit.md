# PLAN / APPLY / UNIFY Module Execution Audit

## Audit Labels
- **Confirmed dispatch path** — the shared workflow contains the lifecycle dispatch step and the current installed Pi registry contains matching `hook_details` for that hook.
- **Registry-dependent runtime** — actual firing still depends on running inside an installed harness that resolves the logical `kernel/modules.yaml` path to a real installed registry.
- **Intentionally absent** — the module does not declare that lifecycle hook.
- **Invisible / not surfaced** — the module may be wired, but current user-facing surfaces do not explicitly show that it ran or what it produced.

## Execution Baseline

### 1) Shared workflows do define lifecycle dispatch stages
The shared kernel workflows explicitly define module dispatch at:
- `pre-plan` and `post-plan`
- `pre-apply`, `post-task`, and `post-apply`
- `pre-unify` and `post-unify`

### 2) Runtime dispatch depends on installed registry resolution
`kernel/references/module-dispatch.md` makes `kernel/modules.yaml` a **logical** path, not a repo file. It also says:
- the installed registry is authoritative when present
- dispatch is a **no-op** if `kernel/modules.yaml` is missing
- source `modules/*/module.yaml` should not override the installed registry when both exist

### 3) Current repo vs current Pi install
- **Repo checkout:** `kernel/modules.yaml` is absent
- **Current Pi install:** `/Users/maxwellnewman/.pi/agent/skills/pals/modules.yaml` exists and contains matching `hook_details`

### 4) Validation evidence stops short of proving live hook firing
Current validation proves:
- installed `modules.yaml` exists
- installed registry contains `hook_details` and reference paths
- Pi extension renders persistent lifecycle UI and guided workflow moments

Current validation does **not** provide end-to-end proof that every declared module hook fired during a real PLAN/APPLY/UNIFY run with visible user output.

## Dispatch Reality by Module

| Module | PLAN | APPLY | UNIFY | Current execution reading |
|--------|------|-------|-------|---------------------------|
| carl | Intentionally absent | Intentionally absent | Intentionally absent | Separate platform-hook subsystem, not a PAUL lifecycle module |
| dave | Confirmed dispatch path via `pre-plan`; runtime remains registry-dependent | Confirmed dispatch path via `post-apply`; runtime remains registry-dependent | Intentionally absent | Shared workflows + current Pi registry agree |
| dean | Confirmed dispatch path via `pre-plan`; runtime remains registry-dependent | Confirmed dispatch path via `post-apply`; runtime remains registry-dependent | Intentionally absent | Shared workflows + current Pi registry agree |
| docs | Confirmed dispatch path via `pre-plan`; runtime remains registry-dependent | Confirmed dispatch path via `post-apply`; runtime remains registry-dependent | Intentionally absent | Shared workflows + current Pi registry agree |
| iris | Confirmed dispatch path via `pre-plan`; runtime remains registry-dependent | Confirmed dispatch path via `post-apply`; runtime remains registry-dependent | Intentionally absent | Shared workflows + current Pi registry agree |
| ruby | Confirmed dispatch path via `pre-plan`; runtime remains registry-dependent | Intentionally absent | Confirmed dispatch path via `post-unify`; runtime remains registry-dependent | Shared workflows + current Pi registry agree |
| skip | Intentionally absent | Confirmed dispatch path via `post-apply`; runtime remains registry-dependent | Confirmed dispatch path via `post-unify`; runtime remains registry-dependent | Shared workflows + current Pi registry agree |
| todd | Confirmed dispatch path via `pre-plan` + `post-plan`; runtime remains registry-dependent | Confirmed dispatch path via `pre-apply` + `post-task` + `post-apply`; runtime remains registry-dependent | Intentionally absent | Deepest lifecycle participant in current registry |
| walt | Intentionally absent | Confirmed dispatch path via `pre-apply` + `post-apply`; runtime remains registry-dependent | Confirmed dispatch path via `post-unify`; runtime remains registry-dependent | Shared workflows + current Pi registry agree |

## Lifecycle Interpretation

### PLAN
- PLAN has the broadest early advisory footprint: `dean`, `todd`, `iris`, `dave`, `docs`, and `ruby` all have confirmed dispatch paths in the current Pi registry.
- Only `todd` has a current `post-plan` path, so it is the only module that can explicitly restructure a plan after the kernel writes it.
- Even when these hooks are wired, their effect is mostly **implicit** to the user unless the assistant narrates how the plan changed.

### APPLY
- APPLY is the densest execution stage:
  - `todd` can act before apply, after each task, and after apply
  - `walt` can act before and after apply
  - `dean`, `dave`, `docs`, `iris`, and `skip` can contribute after apply
- This means APPLY is where the strongest module activity is *declared* today.
- However, proof of actual live firing still depends on the installed harness resolving the registry and on the runtime surfacing outcomes.

### UNIFY
- The shared workflow supports both `pre-unify` and `post-unify`, but the **current module catalog leaves `pre-unify` empty**.
- `walt`, `skip`, and `ruby` are the only modules with current `post-unify` paths.
- Because `create_summary` happens **before** `post-unify`, current post-unify work has a weaker path to user-visible reporting than post-apply work.

## Visibility Baseline

### Pi live lifecycle UI
The persistent Pi status bar/widget currently surfaces:
- milestone
- phase
- loop state
- next action
- quick actions / shortcuts

It does **not** surface:
- which modules were dispatched
- which modules blocked / warned / injected context
- any per-module metrics or annotations

### Guided workflow UX
The Pi extension watches for canonical prompts like:
- `Continue to APPLY`
- `Continue to UNIFY`
- `CHECKPOINT:`
- `▶ NEXT:`

This guided layer helps route canonical replies, but it does **not** display per-module execution status.

### Discovery / orientation surfaces
Pi discovery surfaces do explain that:
- enabled modules are installed into `modules.yaml`
- TODD/WALT are module overlays, not standalone Pi skills

That is **conceptual visibility**, not runtime visibility. It tells the user where modules come from, but not which ones actually ran in the current lifecycle step.

### APPLY completion surface
`kernel/workflows/apply-phase.md` says APPLY completion can include **module annotations from post-apply hooks**.
That means post-apply-capable modules (`walt`, `dean`, `dave`, `todd`, `docs`, `iris`, `skip`) have a textual reporting path **if** their annotations are actually collected and surfaced by the runtime.

### SUMMARY / end-report surface
`kernel/templates/SUMMARY.md` contains an optional `## Module Execution Reports` section.
But the current UNIFY workflow orders work as:
1. `pre-unify` dispatch
2. `create_summary`
3. state update
4. `post-unify` dispatch

That ordering matters because:
- no module currently registers `pre-unify`
- `post-unify` modules (`walt`, `skip`, `ruby`) run **after** summary creation
- `post-unify` is described as collecting `side_effects`, not as updating the already-created summary

So the current end-report path is:
- **partial / conditional** for post-apply modules
- **not proven** for post-unify-only outputs

## Module-by-Module Visibility Readout

| Module | Live Pi status/widget | Guided workflow UI | APPLY text output | SUMMARY / end report |
|--------|-----------------------|--------------------|-------------------|----------------------|
| carl | Not applicable to PAUL lifecycle | Not applicable | Not applicable | Not applicable |
| dave | Not surfaced | Not surfaced | Possible via `post-apply` annotations | Conditional / not guaranteed |
| dean | Not surfaced | Not surfaced | Possible via `post-apply` annotations | Conditional / not guaranteed |
| docs | Not surfaced | Not surfaced | Possible via `post-apply` annotations | Conditional / not guaranteed |
| iris | Not surfaced | Not surfaced | Possible via `post-apply` annotations | Conditional / not guaranteed |
| ruby | Not surfaced | Not surfaced | No current post-apply path | Not proven for `post-unify` output because hook runs after summary creation |
| skip | Not surfaced | Not surfaced | Possible via `post-apply` annotations | Not proven for `post-unify` output because hook runs after summary creation |
| todd | Not surfaced directly; only indirect via plan/task behavior | Not surfaced | Possible via `post-apply` annotations | Conditional / not guaranteed |
| walt | Not surfaced directly; no module row in persistent UI | Not surfaced | Possible via `post-apply` annotations | Not proven for `post-unify` output because hook runs after summary creation |

## Proven vs Conditional Conclusions

### Proven from code + installed registry
- The shared lifecycle workflows contain explicit dispatch stages for all seven hook points.
- The current Pi installed registry matches source manifests for all modules.
- Eight modules are wired into at least one PAUL lifecycle stage; `carl` is intentionally outside that model.
- PLAN and APPLY have the richest declared module participation today.

### Conditional / environment-dependent
- Actual runtime firing still depends on installed-registry resolution in the active harness.
- Because the repo does not contain `kernel/modules.yaml`, repo-only inspection cannot prove live dispatch on its own.
- Validation currently proves registry presence and UI wiring, not end-to-end module execution traces.

### Invisible or only partially surfaced today
- No persistent Pi lifecycle surface tells the user which module(s) ran.
- Early-stage hooks (`pre-plan`, `post-plan`, `pre-apply`, `post-task`) are especially invisible unless their effects are inferred from assistant narration.
- Post-unify-only outputs have no proven path into the current SUMMARY creation flow.

## Audit Conclusion
The current system is **more wired than visibly reported**.
- Hook declarations and installed Pi registry metadata are consistent.
- PLAN/APPLY/UNIFY dispatch paths exist in shared workflows.
- But the user-facing visibility story is much weaker than the wiring story: the live Pi UI remains lifecycle-centric rather than module-centric, and the current end-report flow only clearly supports post-apply-style annotations, not post-unify-only module results.
