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

## Dispatch Procedure

For hook `{hook_name}`:

1. Read `modules.yaml`. If not found, emit WARNING: `[dispatch] {hook_name}: modules.yaml NOT FOUND — module hooks will not fire. Run install.sh to regenerate.` and stop dispatch for this hook.
2. Look under `installed_modules.*.hook_details.{hook_name}`.
3. Keep only modules that define that hook.
4. Sort by `priority` ascending.
5. For each module, load only the listed `refs` for that hook.
6. Follow the hook `description` as the module-specific dispatch instruction.
7. Merge outputs in priority order.
8. If a module returns `action: block`, stop and surface the reason.

## Missing or Older Registries

If `modules.yaml` is missing, emit WARNING: `[dispatch] {hook}: modules.yaml NOT FOUND — module hooks will not fire. Run install.sh to regenerate.` Do NOT silently skip — the warning must be visible in the output.

If the registry exists but does not include `hook_details`, it is from an older install.
In that case:
- warn that module dispatch metadata is incomplete
- prefer reinstalling/upgrading PALS so the registry is regenerated
- only fall back to source `modules/{name}/module.yaml` when that source tree is actually available in the current environment

## Guardrails

- Do **not** assume every module reference should load; use only hook-specific `refs`.
- Do **not** treat source `modules/*/module.yaml` as authoritative over the installed registry when both exist.
- Do **not** fire hooks for modules absent from the installed registry, even if source manifests exist in the repo.
