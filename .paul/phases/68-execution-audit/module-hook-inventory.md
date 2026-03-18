# Module Hook Inventory

## Scope
This inventory records **declared lifecycle capability** from source manifests and **current runtime registry shape** from the installed Pi module registry.

### Evidence reviewed
- `modules/*/module.yaml`
- `kernel/references/module-dispatch.md`
- `docs/REFERENCE-RESOLUTION.md`
- `/Users/maxwellnewman/.pi/agent/skills/pals/modules.yaml`

### Important context
- Shared workflows refer to the logical registry path `kernel/modules.yaml`; that file is **not source-controlled in this repo** and is resolved by the adapter at install/runtime.
- For the current Pi environment, the active installed registry is `/Users/maxwellnewman/.pi/agent/skills/pals/modules.yaml`.
- This artifact stays at the **declared capability / installed registry reality** level. It does **not** infer that hooks definitely fired during a particular run.

## Inventory Summary
- Total source modules reviewed: **9**
- Modules participating in PAUL lifecycle hooks: **8** (`dave`, `dean`, `docs`, `iris`, `ruby`, `skip`, `todd`, `walt`)
- Modules intentionally outside PAUL lifecycle dispatch: **1** (`carl`)
- Source vs installed Pi registry comparison: **all hook names, priorities, descriptions, and ref lists match for the current Pi install**
- Notable absence: **no module currently declares `pre-unify`** in source or in the installed Pi registry

## Compact Hook Matrix
Legend: priority number = hook declared; `—` = not declared; `platform-only` = outside PAUL lifecycle dispatch.

| Module | Lifecycle participation | pre-plan | post-plan | pre-apply | post-task | post-apply | pre-unify | post-unify | Notes |
|--------|-------------------------|----------|-----------|-----------|-----------|------------|-----------|------------|-------|
| carl | No | platform-only | platform-only | platform-only | platform-only | platform-only | platform-only | platform-only | Uses platform hook config, not PAUL lifecycle hooks |
| dave | Yes | 200 | — | — | — | 175 | — | — | Deploy/pipeline advisory overlays |
| dean | Yes | 50 | — | — | — | 150 | — | — | Dependency audit overlays |
| docs | Yes | 200 | — | — | — | 250 | — | — | Documentation drift overlays |
| iris | Yes | 150 | — | — | — | 250 | — | — | Review-pattern overlays |
| ruby | Yes | 250 | — | — | — | — | — | 300 | Refactor/debt overlays |
| skip | Yes | — | — | — | — | 300 | — | 200 | Knowledge-capture overlays |
| todd | Yes | 100 | 100 | 50 | 100 | 200 | — | — | TDD enforcement overlays |
| walt | Yes | — | — | 100 | — | 100 | — | 100 | Quality/baseline/history overlays |

## Dispatch Order by Hook (Current Pi Registry)

| Hook | Installed order | Notes |
|------|------------------|-------|
| `pre-plan` | `dean(50)` → `todd(100)` → `iris(150)` → `dave(200)` → `docs(200)` → `ruby(250)` | Six modules can participate before plan generation |
| `post-plan` | `todd(100)` | Only TODD can restructure plans after creation |
| `pre-apply` | `todd(50)` → `walt(100)` | TDD discipline before quality baseline |
| `post-task` | `todd(100)` | Only TODD currently hooks every task |
| `post-apply` | `walt(100)` → `dean(150)` → `dave(175)` → `todd(200)` → `docs(250)` → `iris(250)` → `skip(300)` | Seven modules can annotate/block after APPLY |
| `pre-unify` | none | Shared workflow stage exists, but no module currently registers for it |
| `post-unify` | `walt(100)` → `skip(200)` → `ruby(300)` | Three modules can run after UNIFY state/summary work |

## Source vs Installed Registry Detail

### carl
- **Source manifest:** `hooks: {}` with explicit note that CARL does not use PAUL lifecycle hooks.
- **Installed Pi registry:** `hooks: []` and no `hook_details`.
- **Comparison:** Match.
- **Interpretation:** CARL is intentionally outside PLAN/APPLY/UNIFY dispatch and instead uses platform hook wiring.

### dave
- **Source hooks:**
  - `pre-plan (200)` → `references/pipeline-generation.md`
  - `post-apply (175)` → `references/deploy-verification.md`
- **Installed Pi registry hooks:** identical
- **Comparison:** Match.
- **Declared role:** deploy / CI-CD detection before planning; deploy verification after apply.

### dean
- **Source hooks:**
  - `pre-plan (50)` → `references/vulnerability-audit.md`
  - `post-apply (150)` → `references/vulnerability-audit.md`
- **Installed Pi registry hooks:** identical
- **Comparison:** Match.
- **Declared role:** dependency audit before planning and regression check after apply.

### docs
- **Source hooks:**
  - `pre-plan (200)` → `references/doc-detection.md`
  - `post-apply (250)` → `references/doc-drift.md`
- **Installed Pi registry hooks:** identical
- **Comparison:** Match.
- **Declared role:** documentation detection before planning and drift audit after apply.

### iris
- **Source hooks:**
  - `pre-plan (150)` → `references/review-patterns.md`
  - `post-apply (250)` → `references/review-patterns.md`, `references/inspection-checklists.md`
- **Installed Pi registry hooks:** identical
- **Comparison:** Match.
- **Declared role:** review-pattern hints before planning and review findings after apply.

### ruby
- **Source hooks:**
  - `pre-plan (250)` → `references/debt-detection.md`
  - `post-unify (300)` → `references/refactor-patterns.md`
- **Installed Pi registry hooks:** identical
- **Comparison:** Match.
- **Declared role:** debt scanning before planning and refactor suggestion side effects after unify.

### skip
- **Source hooks:**
  - `post-apply (300)` → `references/knowledge-capture.md`
  - `post-unify (200)` → `references/knowledge-capture.md`, `references/knowledge-search.md`
- **Installed Pi registry hooks:** identical
- **Comparison:** Match.
- **Declared role:** knowledge capture suggestions after apply and after unify.

### todd
- **Source hooks:**
  - `pre-plan (100)` → `references/tdd-detection.md`, `references/tdd-plan-generation.md`
  - `post-plan (100)` → `references/tdd-plan-generation.md`
  - `pre-apply (50)` → `references/tdd-execution.md`
  - `post-task (100)` → `references/tdd-execution.md`
  - `post-apply (200)` → `references/tdd.md`
- **Installed Pi registry hooks:** identical
- **Comparison:** Match.
- **Declared role:** the deepest lifecycle participant; spans planning, execution enforcement, and post-apply feedback.

### walt
- **Source hooks:**
  - `pre-apply (100)` → `references/quality-runner.md`, `references/quality-detection.md`
  - `post-apply (100)` → `references/quality-runner.md`, `references/quality-lint.md`
  - `post-unify (100)` → `references/quality-delta.md`, `references/quality-history.md`
- **Installed Pi registry hooks:** identical
- **Comparison:** Match.
- **Declared role:** quality baseline before apply, regression gating after apply, history tracking after unify.

## Notable Absences and Non-Mismatches
- **No source-vs-installed mismatches were found** in the current Pi environment.
- **No module declares `pre-unify`** even though the shared workflow defines a `pre-unify` dispatch stage.
- **No module besides `todd` declares `post-plan` or `post-task`**, so those lifecycle points are effectively TODD-specific today.
- **`carl` is not a missing lifecycle participant**; it is intentionally modeled as a separate platform-hook subsystem.
- **The installed Pi registry is the runtime truth for this audit**, because the repo intentionally does not carry a source `kernel/modules.yaml` file.

## Inventory Conclusion
The current module catalog is internally consistent:
- source manifests and the installed Pi registry agree,
- the lifecycle-participating modules are clearly defined,
- and today’s declared hook coverage concentrates on `pre-plan`, `post-apply`, and `post-unify`, with `post-plan` and `post-task` reserved to TODD and `pre-unify` unused.
