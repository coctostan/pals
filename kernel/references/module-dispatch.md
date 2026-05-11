# Module Dispatch Reference

How PLAN/APPLY/UNIFY dispatch module overlays from the installed runtime registry.

## Purpose

`modules.yaml` is the **logical path** for the active installed module registry. It is not source-controlled in this repo, and it is not the same authority as source `modules/*/module.yaml` manifests.

Adapters resolve `modules.yaml` to the installed runtime location for the current harness. Workflows should use the logical path, not hardcoded home-directory or harness-specific install paths.

During PLAN/APPLY/UNIFY, the installed registry is authoritative for active modules, hook registration, priority ordering, and hook-local `refs`. Source manifests remain authoring/build inputs; they do not override installed dispatch state.

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

Lifecycle workflows are call sites for shared dispatch mechanics. At each dispatch call site, keep local instructions limited to:

- the hook name (`pre-plan`, `post-plan`, `pre-apply`, `post-task`, `post-apply`, `pre-unify`, `post-unify`)
- local cohort splits or phase-specific selection rules, such as `[dispatch] post-apply advisory` vs `[dispatch] post-apply enforcement`
- the context passed to modules, such as `files_modified`, plan content, apply annotations, summary path, and baselines
- outputs that must be preserved in PLAN/SUMMARY/STATE or returned to the next phase
- workflow-local STOP, override, checkpoint, and visible dispatch-line requirements

Do not restate generic registry mechanics in every workflow. Reference this file and keep local prose limited to hook-specific obligations and lifecycle authority.

## Shared Hook Taxonomy

### Hook classes

- **Advisory** hooks or cohorts never block. They may annotate, summarize, persist results, or skip with visible evidence.
- **Enforcement** hooks or cohorts may block when they produce evidence for a blocking condition. The workflow call site owns fix/override/stop handling.
- `post-apply` may be split into advisory and enforcement cohorts at the workflow call site. Use installed-registry priority ordering inside each cohort.

### Hook order and priority source

- Lifecycle order is fixed: `pre-plan` → `post-plan` → `pre-apply` → `post-task` → `post-apply` → `pre-unify` → `post-unify`.
- The installed registry is authoritative for hook priority: `installed_modules.*.hook_details.{hook}.priority`; lower numbers run first.
- Load only refs listed for this hook: `installed_modules.*.hook_details.{hook}.refs`.

### Evidence-line convention

- Every dispatch attempt emits a visible `[dispatch] ...` line, including when no modules are registered, a hook is skipped, the registry is stale, or `modules.yaml` is missing.
- If a workflow splits a hook into local labels, preserve that label in evidence, e.g. `[dispatch] post-apply advisory: ...`, `[dispatch] post-apply enforcement: ...`, or `[dispatch] post-unify: ...`.
- Any mandatory STOP/DO NOT SKIP rule stays inline at the workflow call site.

### Compact dispatch output

Dispatch output is compact by default while preserving required evidence.

- Routine skip/no-scope cases should be one compact skip line, e.g. `[dispatch] pre-plan advisory: ARIA skipped — no UI files in scope`.
- Compact skip lines are enough only when there are no warnings, blockers, failures, or durable artifacts to preserve.
- Expand for blocking findings, enforcement warnings, failed or ambiguous verification, changed baselines, user-facing decisions, or content that must be copied into PLAN/SUMMARY/STATE.
- Do not replace mandatory `[dispatch] ...` evidence with prose summaries.

## Dispatch Procedure

For hook `{hook_name}`, `{label}` is the visible dispatch label. By default `{label}` is `{hook_name}`; workflow-local cohorts may use labels such as `post-apply advisory` or `post-apply enforcement`.

1. Read logical `modules.yaml`. If missing, emit `[dispatch] {label}: modules.yaml NOT FOUND — module hooks will not fire. Run install.sh to regenerate.` Stop dispatch for this hook or cohort.
2. Require `installed_modules.*.hook_details.{hook_name}`. If hook metadata is missing or stale, emit a visible warning and prefer reinstall/regeneration.
3. Keep modules that define the hook, sort by priority ascending, and load only refs listed for that hook.
4. Follow each hook `description` in priority order. If an enforcement hook returns `action: block`, stop the cohort and let the workflow call site handle fix/override/stop.
5. Emit a visible `[dispatch] {label}: ...` line even when no modules fire, the registry is stale, or the hook is skipped.

## Durable Evidence Requirements and Destinations

- Missing or stale registry warnings, including `modules.yaml NOT FOUND`, must be emitted as `[dispatch] ...` evidence.
- PLAN records pre-plan/post-plan dispatch evidence when modules are enabled.
- APPLY retains advisory annotations, enforcement results, quality/test baselines, and task-level gate outcomes for UNIFY.
- UNIFY persists post-unify reports and side effects in `SUMMARY.md` `Module Execution Reports`; if post-unify dispatch is missing or skipped, record the warning before phase-completion routing.

## Guardrails

- Do **not** load every module reference; load only refs listed for the current hook.
- Do **not** treat source `modules/*/module.yaml` as authoritative over installed `modules.yaml`.
- Do **not** fire hooks for modules absent from installed `modules.yaml`, even if source manifests exist in the repo.
- Keep dispatch platform-agnostic and logical-path based; do not introduce harness-specific install paths or hidden runtime state.

## Project Config vs Installed Registry

The project's `pals.json` `modules` section records module preferences chosen during `/paul:init`. Runtime dispatch reads installed `modules.yaml`, not `pals.json`.

Until per-project runtime disable is implemented:
- installed modules dispatch regardless of project-level config;
- a project with only a subset of modules in `pals.json` still receives all installed dispatch hooks;
- `pals.json` module entries are project configuration metadata, not dispatch authority.
