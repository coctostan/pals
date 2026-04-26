# Module Dispatch Reference

How PLAN/APPLY/UNIFY should resolve enabled module overlays from the installed registry.

## Purpose

`modules.yaml` is a **logical path** for the active installed module registry.
It is not a source-controlled file in this repo.

Adapters resolve it to their installed runtime location for the current harness.
Examples live in `docs/REFERENCE-RESOLUTION.md`; the workflow should rely on the logical `modules.yaml` path, not a hardcoded install path.

Workflows should treat that installed registry as authoritative for which modules are active.

## Registry Shape

The installed `modules.yaml` contains:
- `installed_modules.{name}.version`
- `installed_modules.{name}.hooks` — flat hook-name list for quick discovery
- `installed_modules.{name}.hook_details.{hook}` — runtime hook metadata:
  - `priority`
  - `description`
  - `refs`
- optional `platform_hooks`

Example:

```yaml
installed_modules:
  todd:
    version: "1.0.0"
    hooks: [pre-plan, post-plan, pre-apply, post-task, post-apply]
    hook_details:
      pre-plan:
        priority: 100
        description: "Scan planned files for test files/frameworks"
        refs:
          - references/tdd-detection.md
          - references/tdd-plan-generation.md
```

## Workflow Call-Site Contract

Lifecycle workflows are call sites for this shared contract. Each workflow step should specify only:

- the hook name (`pre-plan`, `post-plan`, `pre-apply`, `post-task`, `post-apply`, `pre-unify`, `post-unify`)
- the phase-specific module list or selection rule, including advisory vs blocking semantics
- the context passed to modules (`files_modified`, plan content, apply annotations, summary path, baselines)
- the outputs that must be preserved in PLAN/SUMMARY/STATE or returned to the next phase
- the exact blocking behavior, user override options, and mandatory visible dispatch log line

Do not restate generic registry mechanics in every workflow. Reference this file and keep local prose limited to hook-specific obligations.

## Dispatch Procedure

For hook `{hook_name}`:

1. Read `modules.yaml`. If not found, emit WARNING: `[dispatch] {hook_name}: modules.yaml NOT FOUND — module hooks will not fire. Run install.sh to regenerate.` and stop dispatch for this hook.
2. Require registry metadata at `installed_modules.*.hook_details.{hook_name}`; stale registries without `hook_details` must warn and prefer reinstall/regeneration.
3. Keep only modules that define the hook, sort by `priority` ascending, and load only that hook's listed `refs`.
4. Follow each hook `description`, merge outputs in priority order, and stop only when a module returns `action: block`.
5. Emit a visible `[dispatch] {hook_name}: ...` log even when no modules fire, the registry is stale, or the hook is skipped.

## Durable Evidence Requirements

- `modules.yaml NOT FOUND` and stale-registry warnings must be visible; never silently skip dispatch.
- PLAN must record pre-plan/post-plan dispatch evidence when modules are enabled.
- APPLY must retain advisory annotations, enforcement results, quality/test baselines, and task-level gate outcomes for UNIFY.
- UNIFY must persist post-unify reports and side effects in `SUMMARY.md` `Module Execution Reports`; if post-unify dispatch is missing or skipped, record the warning in the summary before phase-completion routing.

## Guardrails

- Do **not** assume every module reference should load; use only hook-specific `refs`.
- Do **not** treat source `modules/*/module.yaml` as authoritative over the installed registry when both exist.
- Do **not** fire hooks for modules absent from the installed registry, even if source manifests exist in the repo.
- Keep dispatch platform-agnostic and logical-path based; do not introduce harness-specific installed paths or hidden runtime state.
## Project Config vs Installed Registry

The project's `pals.json` `modules` section records which modules the user chose during `/paul:init`.
However, **runtime dispatch reads only `modules.yaml`** (the installed registry), not the project's `pals.json`.

This means:
- All installed modules dispatch regardless of project-level config
- A project with only 8 modules in its `pals.json` still gets all 18 dispatching
- Per-project module disable at runtime is a planned future feature

Until per-project disable is implemented, `pals.json` modules section is informational only.
