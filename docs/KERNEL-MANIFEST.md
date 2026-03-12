# Kernel Manifest — File Classification

**Generated:** 2026-03-11
**Purpose:** Classify every PALS framework file as kernel, module, or shared

## Summary

| Category | Files | Description |
|----------|-------|-------------|
| Kernel | 48 | PAUL core loop, state management, lifecycle, commands |
| TODD Module | 5 | TDD enforcement (references + workflow overlay) |
| WALT Module | 7 | Quality gating (references + workflow) |
| CARL Module | 13 | Context rules (config + hook + commands) |
| Shared | 5 | Rules used by kernel and modules |
| **Total** | **78** | |

---

## Kernel (PAUL Core)

The kernel implements the plan/apply/unify loop, state management, project initialization, and lifecycle utilities. It is the minimum required to run PALS on any platform.

### Workflows (14 files)

| File | Role |
|------|------|
| `workflows/plan-phase.md` | PLAN phase — create executable plans |
| `workflows/apply-phase.md` | APPLY phase — execute approved plans |
| `workflows/unify-phase.md` | UNIFY phase — reconcile plan vs actual |
| `workflows/init-project.md` | Project initialization |
| `workflows/transition-phase.md` | Phase-to-phase transition |
| `workflows/complete-milestone.md` | Milestone completion |
| `workflows/create-milestone.md` | Milestone creation |
| `workflows/discuss-milestone.md` | Pre-milestone vision discussion |
| `workflows/discuss-phase.md` | Pre-phase vision discussion |
| `workflows/roadmap-management.md` | Roadmap updates (add/remove phase) |
| `workflows/pause-work.md` | Session pause + handoff creation |
| `workflows/resume-project.md` | Session resume from handoff |
| `workflows/verify-work.md` | UAT verification guidance |
| `workflows/phase-assumptions.md` | Surface assumptions before planning |

### References (6 files)

| File | Role |
|------|------|
| `references/loop-phases.md` | PLAN/APPLY/UNIFY loop semantics |
| `references/checkpoints.md` | Checkpoint types and execution protocol |
| `references/plan-format.md` | PLAN.md format specification |
| `references/work-units.md` | Task structure and sizing |
| `references/git-strategy.md` | Branch and commit strategy |
| `references/context-management.md` | Context pressure and cycling |

### Templates (17 files)

| File | Role |
|------|------|
| `templates/PROJECT.md` | Project definition template |
| `templates/STATE.md` | State tracking template |
| `templates/ROADMAP.md` | Roadmap template |
| `templates/MILESTONES.md` | Milestone archive template |
| `templates/PLAN.md` | Plan template |
| `templates/SUMMARY.md` | Summary template |
| `templates/HANDOFF.md` | Handoff document template |
| `templates/CONTEXT.md` | Milestone context template |
| `templates/ISSUES.md` | Deferred issues template |
| `templates/UAT-ISSUES.md` | UAT issues template |
| `templates/SPECIAL-FLOWS.md` | Specialized flows config template |
| `templates/config.md` | Project config template |
| `templates/milestone-archive.md` | Milestone archive entry template |
| `templates/milestone-context.md` | Milestone context handoff template |
| `templates/codebase/architecture.md` | Codebase doc: architecture |
| `templates/codebase/concerns.md` | Codebase doc: concerns |
| `templates/codebase/conventions.md` | Codebase doc: conventions |
| `templates/codebase/integrations.md` | Codebase doc: integrations |
| `templates/codebase/stack.md` | Codebase doc: stack |
| `templates/codebase/structure.md` | Codebase doc: structure |
| `templates/codebase/testing.md` | Codebase doc: testing |

### Commands (23 files)

| File | Role |
|------|------|
| `commands/paul/plan.md` | /paul:plan command |
| `commands/paul/apply.md` | /paul:apply command |
| `commands/paul/unify.md` | /paul:unify command |
| `commands/paul/init.md` | /paul:init command |
| `commands/paul/milestone.md` | /paul:milestone command |
| `commands/paul/complete-milestone.md` | /paul:complete-milestone command |
| `commands/paul/discuss-milestone.md` | /paul:discuss-milestone command |
| `commands/paul/discuss.md` | /paul:discuss command |
| `commands/paul/add-phase.md` | /paul:add-phase command |
| `commands/paul/remove-phase.md` | /paul:remove-phase command |
| `commands/paul/progress.md` | /paul:progress command |
| `commands/paul/verify.md` | /paul:verify command |
| `commands/paul/pause.md` | /paul:pause command |
| `commands/paul/resume.md` | /paul:resume command |
| `commands/paul/handoff.md` | /paul:handoff command |
| `commands/paul/config.md` | /paul:config command |
| `commands/paul/flows.md` | /paul:flows command |
| `commands/paul/help.md` | /paul:help command |
| `commands/paul/assumptions.md` | /paul:assumptions command |
| `commands/paul/consider-issues.md` | /paul:consider-issues command |
| `commands/paul/plan-fix.md` | /paul:plan-fix command |
| `commands/paul/research.md` | /paul:research command |
| `commands/paul/research-phase.md` | /paul:research-phase command |

### Exploration Workflows (kernel utilities — 4 files)

| File | Role |
|------|------|
| `workflows/research.md` | Research unknowns with subagents |
| `workflows/discovery.md` | Technical discovery workflow |
| `workflows/map-codebase.md` | Codebase mapping workflow |
| `workflows/consider-issues.md` | Deferred issue triage |

### Exploration Commands (kernel utilities — 3 files)

| File | Role |
|------|------|
| `commands/paul/discover.md` | /paul:discover command |
| `commands/paul/map-codebase.md` | /paul:map-codebase command |

### Other Kernel References (3 files)

| File | Role |
|------|------|
| `references/subagent-criteria.md` | Subagent delegation rules |
| `references/research-quality-control.md` | Research quality standards |
| `references/specialized-workflow-integration.md` | How special flows integrate |

---

## TODD Module (TDD Enforcement)

TODD enforces test-driven development via RED-GREEN-REFACTOR phases. Hooks into plan creation and apply execution.

### References (4 files)

| File | Role | Hooks Into |
|------|------|------------|
| `references/tdd.md` | TDD philosophy and approach | — |
| `references/tdd-detection.md` | Heuristics for TDD candidate detection | pre-plan |
| `references/tdd-plan-generation.md` | How TDD plans are structured | post-plan |
| `references/tdd-execution.md` | RED-GREEN-REFACTOR execution rules | pre-apply, post-task |

### Workflow Overlays (1 file)

| File | Role | Hooks Into |
|------|------|------------|
| `workflows/plan-phase-tdd.md`* | TDD plan structure overlay | plan-phase |

*Note: This file is referenced in plan-phase.md but not yet present as a standalone file. Currently integrated as a conditional path within plan-phase.md. During kernelization, this should be extracted as a module-provided overlay.

### Hook Points

| Hook | TODD Behavior |
|------|---------------|
| pre-plan | Detect TDD candidates via heuristics |
| post-plan | Structure plan as RED-GREEN-REFACTOR if TDD type |
| pre-apply | Enforce RED phase (tests written first) |
| post-task | Enforce GREEN phase (tests pass) |
| post-apply | Enforce REFACTOR phase (cleanup opportunity) |

---

## WALT Module (Quality Gating)

WALT enforces quality standards through test regression detection, linting, and type checking. Hooks into apply execution.

### References (6 files)

| File | Role | Hooks Into |
|------|------|------------|
| `references/quality-principles.md` | Quality philosophy and approach | — |
| `references/quality-runner.md` | Test runner integration and regression detection | pre-apply, post-apply |
| `references/quality-detection.md` | Test runner auto-detection heuristics | pre-apply |
| `references/quality-lint.md` | Lint/typecheck/format gate rules | post-apply |
| `references/quality-delta.md` | Delta analysis (before/after comparison) | post-apply |
| `references/quality-history.md` | Quality trend tracking over time | post-unify |

### Workflow (1 file)

| File | Role | Hooks Into |
|------|------|------------|
| `workflows/quality-gate.md` | Quality gate execution workflow | post-apply |

### Hook Points

| Hook | WALT Behavior |
|------|---------------|
| pre-apply | Capture test baseline (before changes) |
| post-apply | Run tests, lint, typecheck; compare against baseline; gate on regressions |
| post-unify | Record quality delta in history |

---

## CARL Module (Context Rules)

CARL manages domain-driven context rules that inject into every prompt via hooks. Architecturally independent — hook-level integration only.

### Config (4 files)

| File | Role |
|------|------|
| `carl/manifest` | Domain registry with trigger keywords |
| `carl/global` | Global always-on rules |
| `carl/context` | Context bracket detection rules |
| `carl/commands` | Command-related rules |

### Example Domain (1 file)

| File | Role |
|------|------|
| `carl/example-custom-domain` | Template for creating custom domains |

### Hook (1 file)

| File | Role |
|------|------|
| `hooks/carl-hook.py` | UserPromptSubmit hook — session management, keyword matching, rule injection |

### Commands (8 files)

| File | Role |
|------|------|
| `commands/carl/manager.md` | /carl:manager command |
| `commands/carl/tasks/add-rule.md` | Add rule task |
| `commands/carl/tasks/create-domain.md` | Create domain task |
| `commands/carl/tasks/create-command.md` | Create command task |
| `commands/carl/tasks/edit-rule.md` | Edit rule task |
| `commands/carl/tasks/toggle-domain.md` | Toggle domain task |
| `commands/carl/templates/domain-template.md` | Domain file template |
| `commands/carl/templates/manifest-entries.md` | Manifest entry template |

### Hook Points

| Hook | CARL Behavior |
|------|---------------|
| (external) UserPromptSubmit | Inject `<carl-rules>` block with context bracket, loaded domains, rules |

*Note: CARL uses Claude Code's native hook system, not PAUL lifecycle hooks. This is by design — CARL operates independently of the plan/apply/unify loop.*

---

## Shared (Used by Kernel + Modules)

### Rules (5 files)

| File | Used By |
|------|---------|
| `rules/style.md` | All (universal writing conventions) |
| `rules/workflows.md` | Kernel + TODD (workflow structure rules) |
| `rules/commands.md` | Kernel + CARL (command structure rules) |
| `rules/references.md` | Kernel + all modules (reference format rules) |
| `rules/templates.md` | Kernel (template structure rules) |

---

## Other Top-Level Files

| File | Category | Role |
|------|----------|------|
| `install.sh` | Driver (Claude Code) | Installation script |
| `uninstall.sh` | Driver (Claude Code) | Uninstallation script |
| `README.md` | Shared | Getting started docs |
| `templates/DEBUG.md` | Kernel | Debug session template |
| `templates/DISCOVERY.md` | Kernel | Discovery document template |
| `templates/RESEARCH.md` | Kernel | Research document template |
| `references/ci-generation.md` | Future module? | CI/CD generation reference |
| `references/sonarqube-integration.md` | Future module? | SonarQube integration reference |
| `workflows/configure-special-flows.md` | Kernel | Special flows configuration workflow |
| `workflows/debug.md` | Kernel | Debug workflow |

---

## Ambiguous / Discussion Needed

| File | Current | Question |
|------|---------|----------|
| `references/ci-generation.md` | Unclaimed | Future DAVE module? Or kernel reference? |
| `references/sonarqube-integration.md` | Unclaimed | Future WALT extension? Or standalone module? |
| `workflows/plan-phase-tdd.md` | TODD | Referenced but may not exist as standalone file — needs extraction |

---

*Classification complete: 78 files audited, 0 orphans*
