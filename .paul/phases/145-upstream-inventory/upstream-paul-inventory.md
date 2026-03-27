# Upstream PAUL Inventory

**Repo:** https://github.com/ChristopherKahler/paul
**Version:** v1.2 (Quality & Depth)
**Last commit:** a7c295e — 2026-03-24 — `feat(v1.2): Quality & Depth — enhanced init, E/Q loop, diagnostic routing, quick-track`
**Total files:** 102
**Our PALS equivalent tree:** `kernel/` directory

---

## Status Key

| Status | Meaning |
|--------|---------|
| **equivalent** | Same concept, similar content — both repos have it |
| **diverged** | Same concept, significantly different implementation |
| **novel** | No PALS counterpart — upstream only |
| **superseded** | PALS has a more advanced version |

---

## Root Files (5 files)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `README.md` | NPM-publishable README with install via `npx paul-framework`. Covers loop, commands, philosophy. | `README.md` | diverged | Upstream is NPM-published; ours covers modules/drivers/architecture. Their "Why PAUL" framing is strong. |
| `package.json` | NPM package config for `paul-framework` | `package.json` (ours) | diverged | Upstream is NPM-published via `npx paul-framework`; ours isn't NPM-published |
| `LICENSE` | MIT | `LICENSE` | equivalent | Same |
| `PAUL-VS-GSD.md` | Comparison doc: PAUL vs GSD (Get Shit Done framework) | None | novel | Marketing/positioning doc. Shows upstream value prop: loop integrity, context management, acceptance-driven. Interesting framing but not functional. |
| `.gitignore` | Standard gitignore | `.gitignore` | equivalent | Same |

## Assets (1 file)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `assets/terminal.svg` | Terminal screenshot for README | None | novel | Visual asset for NPM listing |

## Bin (1 file)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `bin/install.js` | NPM-based installer (`npx paul-framework`) | `drivers/pi/install.sh`, `install.sh` | diverged | Upstream is Node.js NPM installer; ours is shell-based per driver. Their JS installer handles cross-platform (Win/Mac/Linux). |

## CARL Integration (2 files)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `src/carl/PAUL` | CARL satellite manifest — identifies this as a PAUL project for CARL auto-detection | None (our CARL is a PALS module) | diverged | Upstream CARL treats PAUL as a "satellite" it discovers. Our CARL is integrated as a module within PALS. Different architecture. |
| `src/carl/PAUL.manifest` | CARL manifest with project metadata, paths, relationships | None | diverged | Upstream has CARL ↔ PAUL discovery system ("BASE" satellite detection). We don't need this — CARL is inside PALS. |

## Commands (28 files)

### Commands present in both repos

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `src/commands/add-phase.md` | Add a new phase to current milestone | `kernel/commands/paul/add-phase.md` | superseded | Ours includes module awareness |
| `src/commands/apply.md` | Execute an approved plan | `kernel/commands/paul/apply.md` | superseded | Ours has module dispatch, GitHub Flow, worktree support |
| `src/commands/assumptions.md` | Surface AI assumptions about a phase before planning | `kernel/commands/paul/assumptions.md` | equivalent | Same concept — pre-planning assumption surfacing |
| `src/commands/complete-milestone.md` | Complete current milestone | `kernel/commands/paul/complete-milestone.md` | equivalent | Similar |
| `src/commands/config.md` | Project configuration | `kernel/commands/paul/config.md` | superseded | Ours manages 18+ modules via pals.json |
| `src/commands/consider-issues.md` | Review deferred issues with codebase context | `kernel/commands/paul/consider-issues.md` | equivalent | Same concept — triage ISSUES.md and UAT files |
| `src/commands/discover.md` | Research technical options before planning | `kernel/commands/paul/discover.md` | equivalent | Same concept — produces DISCOVERY.md |
| `src/commands/discuss-milestone.md` | Discuss next milestone scope | `kernel/commands/paul/discuss-milestone.md` | superseded | Ours has collaboration levels, context handoff |
| `src/commands/discuss.md` | Discuss phase scope before planning | `kernel/commands/paul/discuss.md` | superseded | Ours has collaboration levels |
| `src/commands/flows.md` | Configure specialized workflow integrations | `kernel/commands/paul/flows.md` | equivalent | Same — SPECIAL-FLOWS.md management |
| `src/commands/handoff.md` | Generate session handoff document | `kernel/commands/paul/handoff.md` | equivalent | Same concept |
| `src/commands/help.md` | Help command | `kernel/commands/paul/help.md` | equivalent | Same |
| `src/commands/init.md` | Initialize project | `kernel/commands/paul/init.md` | superseded | Ours has 3 flows (quick/greenfield/brownfield), module config, GitHub Flow |
| `src/commands/map-codebase.md` | Map codebase structure | `kernel/commands/paul/map-codebase.md` | equivalent | Same concept |
| `src/commands/milestone.md` | Create milestone | `kernel/commands/paul/milestone.md` | superseded | Ours has collaboration levels, review menu |
| `src/commands/pause.md` | Pause work with handoff | `kernel/commands/paul/pause.md` | superseded | Ours has GitHub Flow git state capture |
| `src/commands/plan-fix.md` | Plan fixes for UAT issues from verify | `kernel/commands/paul/plan-fix.md` | equivalent | Same concept — post-verify fix planning |
| `src/commands/plan.md` | Create execution plan | `kernel/commands/paul/plan.md` | superseded | Ours has module dispatch, collaboration levels, review menu |
| `src/commands/progress.md` | Show project progress with routing | `kernel/commands/paul/progress.md` | equivalent | Same concept |
| `src/commands/remove-phase.md` | Remove a future phase | `kernel/commands/paul/remove-phase.md` | equivalent | Same |
| `src/commands/research-phase.md` | Research unknowns for a phase using subagents | `kernel/commands/paul/research-phase.md` | equivalent | Same — subagent-based phase research |
| `src/commands/research.md` | Research a topic | `kernel/commands/paul/research.md` | equivalent | Same |
| `src/commands/resume.md` | Resume work from handoff | `kernel/commands/paul/resume.md` | superseded | Ours has GitHub Flow git-aware routing |
| `src/commands/unify.md` | Close the loop — reconcile plan vs actual | `kernel/commands/paul/unify.md` | superseded | Ours has module dispatch, merge gate, module reports |
| `src/commands/verify.md` | Guide manual user acceptance testing | `kernel/commands/paul/verify.md` | equivalent | Same — UAT workflow |

### Commands ONLY in upstream (3 files) — NOVEL

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `src/commands/audit.md` | Enterprise-grade architectural audit on PLAN.md before APPLY. Senior principal engineer + compliance review. Auto-applies must-have fixes. Produces AUDIT.md. | None | **NOVEL** | Interesting intermediate step between PLAN and APPLY. Our IRIS module does review patterns but not a formal plan audit. Config-gated (`enterprise_plan_audit`). |
| `src/commands/register.md` | Generate paul.json satellite manifest for BASE discovery | None | novel | Specific to upstream's BASE satellite system. Not relevant to PALS — we don't have BASE. |
| `src/commands/status.md` | **DEPRECATED** — redirects to `/paul:progress` | `drivers/pi/skills/paul-status/SKILL.md` | diverged | Upstream deprecated status in favor of progress. We have both `/paul:status` (Pi skill) and `/paul:progress` (kernel command). |

### Commands ONLY in PALS (8 files) — Our additions

| Our Command | Purpose | Notes |
|-------------|---------|-------|
| `coverage.md` | TODD coverage dashboard | Module-specific |
| `deploy.md` | DAVE deploy automation | Module-specific |
| `deps.md` | DEAN dependency audit | Module-specific |
| `fix.md` | Lightweight fix loop (3 modes) | Our innovation — not in upstream |
| `knowledge.md` | SKIP knowledge persistence | Module-specific |
| `quality.md` | WALT quality trends | Module-specific |
| `refactor.md` | RUBY refactoring | Module-specific |
| `review.md` | IRIS code review | Module-specific |

## Workflows (23 files)

### Workflows present in both repos

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `src/workflows/apply-phase.md` | Execute approved plan | `kernel/workflows/apply-phase.md` | diverged | **Key difference:** Upstream v1.2 introduces **Execute/Qualify (E/Q) loop** — after each task: Execute → Report Status → Qualify against spec → Score (PASS/GAP/DRIFT) → loop on gaps. Our version uses structured status (PASS/PASS_WITH_CONCERNS/BLOCKED) but without the explicit qualify-and-loop pattern. |
| `src/workflows/complete-milestone.md` | Complete milestone | `kernel/workflows/complete-milestone.md` | equivalent | Similar |
| `src/workflows/configure-special-flows.md` | Configure skill integrations | `kernel/workflows/configure-special-flows.md` | equivalent | Same |
| `src/workflows/consider-issues.md` | Issue triage | `kernel/workflows/consider-issues.md` | equivalent | Same |
| `src/workflows/create-milestone.md` | Create milestone | `kernel/workflows/create-milestone.md` | superseded | Ours has collaboration levels, review menu |
| `src/workflows/debug.md` | Systematic debugging with persistent state | `kernel/workflows/debug.md` | equivalent | Same concept — DEBUG.md as debugging brain |
| `src/workflows/discovery.md` | Technical discovery | `kernel/workflows/discovery.md` | equivalent | Same |
| `src/workflows/discuss-milestone.md` | Discuss milestone scope | `kernel/workflows/discuss-milestone.md` | superseded | Ours has collaboration levels |
| `src/workflows/discuss-phase.md` | Discuss phase scope | `kernel/workflows/discuss-phase.md` | superseded | Ours has collaboration levels |
| `src/workflows/init-project.md` | Initialize project | `kernel/workflows/init-project.md` | superseded | Ours has 3 init flows, module config, brownfield detection, GitHub Flow |
| `src/workflows/map-codebase.md` | Map codebase | `kernel/workflows/map-codebase.md` | equivalent | Same |
| `src/workflows/pause-work.md` | Pause with handoff | `kernel/workflows/pause-work.md` | superseded | Ours has git state capture |
| `src/workflows/phase-assumptions.md` | Surface assumptions | `kernel/workflows/phase-assumptions.md` | equivalent | Same |
| `src/workflows/plan-phase.md` | Create plan | `kernel/workflows/plan-phase.md` | superseded | Ours has module dispatch, collaboration levels, review menu |
| `src/workflows/research.md` | Research workflow | `kernel/workflows/research.md` | equivalent | Same |
| `src/workflows/resume-project.md` | Resume work | `kernel/workflows/resume-project.md` | superseded | Ours has GitHub Flow git-aware routing |
| `src/workflows/roadmap-management.md` | Roadmap operations | `kernel/workflows/roadmap-management.md` | equivalent | Same |
| `src/workflows/transition-phase.md` | Phase transition | `kernel/workflows/transition-phase.md` | equivalent | Similar |
| `src/workflows/unify-phase.md` | Reconcile plan vs actual | `kernel/workflows/unify-phase.md` | diverged | **Key difference:** Upstream v1.2 introduces **quick-track** — single-task plans with no boundaries get compressed SUMMARY. Also references E/Q qualify results. Our version has module dispatch, merge gate, module reports. |

### Workflows ONLY in upstream (3 files)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `src/workflows/audit-plan.md` | Enterprise-grade plan audit with 6-section structured review. Auto-applies must-have/strongly-recommended findings. | None | **NOVEL** | Interesting quality gate between PLAN and APPLY. Reviews: API design, security, error handling, testing strategy, scaling, compliance. Classifies findings as must-have/strongly-recommended/can-defer. Could complement our IRIS module. |
| `src/workflows/quality-gate.md` | SonarQube integration — run scans, check gates, update CONCERNS.md | None (our WALT module is different) | **NOVEL** | SonarQube-specific quality scanning via MCP. Our WALT does inline quality gating (tests/lint/typecheck) but not SonarQube integration. We have `sonarqube-integration.md` as a reference but no active workflow. |
| `src/workflows/register-manifest.md` | Generate paul.json for BASE satellite discovery | None | novel | Specific to BASE system — not relevant to PALS |

### Workflows ONLY in PALS (1 file)

| Our Workflow | Purpose | Notes |
|--------------|---------|-------|
| `fix-loop.md` | Lightweight fix loop (standard/fast-forward/hotfix) | Our innovation |

## References (12 files)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `src/references/checkpoints.md` | Checkpoint types and handling | `kernel/references/checkpoints.md` | equivalent | Same |
| `src/references/context-management.md` | Context window strategies, brackets | `kernel/references/context-management.md` | equivalent | Same concept |
| `src/references/git-strategy.md` | Git workflow | `kernel/references/git-strategy.md` | superseded | Ours has full GitHub Flow with merge gate |
| `src/references/loop-phases.md` | Loop phase details including E/Q loop | `kernel/references/loop-phases.md` | diverged | **Key difference:** Upstream v1.2 adds E/Q loop documentation. Execute → Report Status (DONE/DONE_WITH_CONCERNS/NEEDS_CONTEXT/BLOCKED) → Qualify (re-read, re-run verify, compare to AC) → Score (PASS/GAP/DRIFT). Our version uses PASS/PASS_WITH_CONCERNS/BLOCKED without explicit qualify step. |
| `src/references/plan-format.md` | Plan format guide | `kernel/references/plan-format.md` | equivalent | Same |
| `src/references/quality-principles.md` | Core principles: solo-developer-claude, plans-are-prompts, loop-first | None as standalone file | **NOVEL** | Interesting philosophy doc. "Plans are prompts" — PLAN.md IS the prompt, not a doc that gets transformed. "Solo developer Claude" — no teams/ceremonies. These principles are embedded in our workflows but not extracted as a standalone reference. |
| `src/references/research-quality-control.md` | QA patterns for research subagents | `kernel/references/research-quality-control.md` | equivalent | Same |
| `src/references/sonarqube-integration.md` | SonarQube integration guide | `kernel/references/sonarqube-integration.md` | equivalent | Same — both have it as reference |
| `src/references/specialized-workflow-integration.md` | SPECIAL-FLOWS tracking | `kernel/references/specialized-workflow-integration.md` | equivalent | Same |
| `src/references/subagent-criteria.md` | When to use subagents | `kernel/references/subagent-criteria.md` | equivalent | Same |
| `src/references/tdd.md` | TDD philosophy and when to use | None as standalone file | **NOVEL** | Our TODD module handles TDD but as a module with hooks, not a standalone reference. Upstream's version is a clean, opinionated guide on when TDD improves quality vs when to skip it. |
| `src/references/work-units.md` | Plan sizing and context management | `kernel/references/work-units.md` | equivalent | Same |

## Rules (5 files)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `src/rules/commands.md` | Command naming/structure rules | `kernel/rules/commands.md` | equivalent | Same |
| `src/rules/references.md` | Reference file rules | `kernel/rules/references.md` | equivalent | Same |
| `src/rules/style.md` | Style rules | `kernel/rules/style.md` | equivalent | Same |
| `src/rules/templates.md` | Template rules | `kernel/rules/templates.md` | equivalent | Same |
| `src/rules/workflows.md` | Workflow rules | `kernel/rules/workflows.md` | equivalent | Same |

## Templates (19 files + 7 codebase templates)

### Standard Templates

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `src/templates/config.md` | Project config template | `kernel/templates/config.md` | equivalent | Same |
| `src/templates/CONTEXT.md` | Phase discussion context | `kernel/templates/CONTEXT.md` | equivalent | Same |
| `src/templates/DEBUG.md` | Debug session template | `kernel/templates/DEBUG.md` | equivalent | Same |
| `src/templates/DISCOVERY.md` | Discovery findings template | `kernel/templates/DISCOVERY.md` | equivalent | Same |
| `src/templates/HANDOFF.md` | Session handoff template | `kernel/templates/HANDOFF.md` | equivalent | Same |
| `src/templates/ISSUES.md` | Project issues log | `kernel/templates/ISSUES.md` | equivalent | Same |
| `src/templates/milestone-archive.md` | Milestone archive template | `kernel/templates/milestone-archive.md` | equivalent | Same |
| `src/templates/milestone-context.md` | Milestone context handoff | `kernel/templates/milestone-context.md` | equivalent | Same |
| `src/templates/MILESTONES.md` | Milestone log template | `kernel/templates/MILESTONES.md` | equivalent | Same |
| `src/templates/PLAN.md` | Plan template | `kernel/templates/PLAN.md` | superseded | Ours has module_dispatch, skills sections |
| `src/templates/PROJECT.md` | Project brief template | `kernel/templates/PROJECT.md` | superseded | Ours has layered model with PRD.md |
| `src/templates/RESEARCH.md` | Research findings template | `kernel/templates/RESEARCH.md` | equivalent | Same |
| `src/templates/ROADMAP.md` | Roadmap template | `kernel/templates/ROADMAP.md` | equivalent | Same |
| `src/templates/SPECIAL-FLOWS.md` | Specialized flows config | `kernel/templates/SPECIAL-FLOWS.md` | equivalent | Same |
| `src/templates/STATE.md` | Project state template | `kernel/templates/STATE.md` | superseded | Ours has GitHub Flow git state, module tracking |
| `src/templates/SUMMARY.md` | Plan summary template | `kernel/templates/SUMMARY.md` | superseded | Ours has module execution reports |
| `src/templates/UAT-ISSUES.md` | UAT issues template | `kernel/templates/UAT-ISSUES.md` | equivalent | Same |
| `src/templates/paul-json.md` | Satellite manifest template for BASE discovery | None | novel | Specific to BASE system |

### Codebase Templates (7 files)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `src/templates/codebase/architecture.md` | Architecture analysis | `kernel/templates/codebase/architecture.md` | equivalent | Same |
| `src/templates/codebase/concerns.md` | Quality concerns | `kernel/templates/codebase/concerns.md` | equivalent | Same |
| `src/templates/codebase/conventions.md` | Code conventions | `kernel/templates/codebase/conventions.md` | equivalent | Same |
| `src/templates/codebase/integrations.md` | Integration docs | `kernel/templates/codebase/integrations.md` | equivalent | Same |
| `src/templates/codebase/stack.md` | Tech stack | `kernel/templates/codebase/stack.md` | equivalent | Same |
| `src/templates/codebase/structure.md` | Project structure | `kernel/templates/codebase/structure.md` | equivalent | Same |
| `src/templates/codebase/testing.md` | Testing setup | `kernel/templates/codebase/testing.md` | equivalent | Same |

---

## Summary Statistics

| Category | Total | Equivalent | Diverged | Novel | Superseded |
|----------|-------|------------|----------|-------|------------|
| Root files | 5 | 2 | 2 | 1 | 0 |
| Assets | 1 | 0 | 0 | 1 | 0 |
| Bin | 1 | 0 | 1 | 0 | 0 |
| CARL integration | 2 | 0 | 2 | 0 | 0 |
| Commands | 28 | 13 | 0 | 3 | 12 |
| Workflows | 23 | 11 | 2 | 3 | 7 |
| References | 12 | 8 | 1 | 2 | 1 |
| Rules | 5 | 5 | 0 | 0 | 0 |
| Templates | 26 | 19 | 0 | 1 | 6 |
| **Total** | **102** | **58** | **8** | **11** | **26** |

## Items Flagged for Phase 146 Review

### NOVEL — No PALS equivalent

1. **`/paul:audit` command + `audit-plan.md` workflow** — Enterprise-grade plan audit between PLAN and APPLY. 6-section structured review. Auto-applies must-have findings. Could complement IRIS module.
2. **`quality-gate.md` workflow** — SonarQube integration workflow. We have the reference file but no active workflow.
3. **`quality-principles.md` reference** — "Plans are prompts" and "Solo developer Claude" philosophy. Clean, opinionated principles doc.
4. **`tdd.md` reference** — Standalone TDD guide with clear "when to use / when to skip" heuristics. Our TODD module handles this but differently.
5. **`PAUL-VS-GSD.md`** — Competitive positioning doc (marketing, not functional).

### DIVERGED — Same concept, significant differences

6. **E/Q Loop (Execute/Qualify)** in `apply-phase.md` and `loop-phases.md` — Upstream v1.2's key innovation. After each task: Execute → Report Status → Qualify (re-read output, re-run verify, compare to AC) → Score (PASS/GAP/DRIFT) → loop on gaps. Our version has PASS/PASS_WITH_CONCERNS/BLOCKED but no explicit qualify-and-loop pattern.
7. **Quick-track** in `unify-phase.md` — Single-task plans with no boundaries get compressed SUMMARY. Our fix-loop has fast-forward mode but standard plans always get full SUMMARY.
8. **NPM distribution** — `npx paul-framework` cross-platform install. We use shell scripts per driver.

### Architectural differences

9. **CARL satellite model** — Upstream PAUL registers with CARL via manifests for auto-detection ("BASE" system). Our CARL is a module inside PALS.
10. **No module system** — Upstream PAUL has no TODD/WALT/DEAN/IRIS/SKIP/DAVE/RUBY/DOCS modules. Quality is handled by optional SonarQube + plan audit.
11. **No driver system** — Upstream is Claude Code only. No Pi, no Agent SDK.
12. **No GitHub Flow** — Upstream has basic git strategy but no branch/PR/merge/CI enforcement.
