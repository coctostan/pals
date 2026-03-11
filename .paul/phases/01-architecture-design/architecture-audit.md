# Architecture Audit: PAUL + CARL + TODD + WALT

**Generated:** 2026-03-11
**Purpose:** Complete inventory of all framework files for PALS unification

---

## Summary

| Component | Files | Location |
|-----------|-------|----------|
| PAUL Framework | 71 | ~/.claude/paul-framework/ (23 workflows, 19 refs, 24 templates, 5 rules) |
| PAUL Commands | 26 | ~/.claude/commands/paul/ |
| CARL Core | 5 | ~/.carl/ (manifest, global, context, commands, example) |
| CARL Commands | 9 | ~/.claude/commands/carl/ |
| **Total unique files** | **111** | |
| TODD (subset of PAUL) | 4 | Embedded: 2 workflows + 2 references |
| WALT (subset of PAUL) | 8 | Embedded: 1 workflow + 7 references |

---

## 1. PAUL Core (67 files)

### 1.1 Workflows (23 files) — ~/.claude/paul-framework/workflows/

| File | Purpose | Cross-References |
|------|---------|------------------|
| apply-phase.md | Execute approved PLAN — run tasks, handle checkpoints, record results | STATE.md, PLAN.md, apply-phase-tdd.md, quality-runner.md, quality-lint.md |
| apply-phase-tdd.md | TDD execution overlay — RED-GREEN-REFACTOR sequencing with atomic commits | tdd.md, plan-phase-tdd.md |
| complete-milestone.md | Mark milestone complete — archive, evolve PROJECT.md, update ROADMAP | STATE.md, PROJECT.md, ROADMAP.md, MILESTONES.md |
| configure-special-flows.md | Configure skill integrations — discover skills, map to work types | PROJECT.md, SPECIAL-FLOWS.md |
| consider-issues.md | Review deferred issues — categorize as resolved/urgent/natural-fit/can-wait | ISSUES.md, STATE.md |
| create-milestone.md | Define new milestone — create structure in ROADMAP, init phase dirs | STATE.md, ROADMAP.md, MILESTONE-CONTEXT.md |
| debug.md | Systematic debugging — persistent debug state surviving context resets | .paul/debug/*.md |
| discovery.md | Execute discovery at appropriate depth — produce DISCOVERY.md | DISCOVERY.md |
| discuss-milestone.md | Facilitate milestone vision articulation — create MILESTONE-CONTEXT.md | STATE.md, MILESTONE-CONTEXT.md |
| discuss-phase.md | Facilitate phase vision articulation — create CONTEXT.md handoff | STATE.md, CONTEXT.md |
| init-project.md | Initialize .paul/ structure — conversational setup | Templates: PROJECT.md, STATE.md, ROADMAP.md |
| map-codebase.md | Parallel Explore agents — produce .paul/codebase/ documents | codebase/*.md (7 documents) |
| pause-work.md | Create HANDOFF.md — enable seamless session resumption | STATE.md, PROJECT.md, HANDOFF.md |
| phase-assumptions.md | Surface Claude's assumptions about a phase — conversational only | STATE.md, ROADMAP.md |
| plan-phase.md | Create executable PLAN.md — objective, AC, tasks, boundaries | STATE.md, ROADMAP.md, plan-phase-tdd.md, tdd-detection.md |
| plan-phase-tdd.md | TDD overlay for planning — generate RED/GREEN/REFACTOR task structure | tdd.md, tdd-detection.md |
| quality-gate.md | Run SonarQube scan — check gates, update CONCERNS.md | sonarqube-integration.md |
| research.md | Research using subagents — save findings for review | subagent-criteria.md, research-quality-control.md |
| resume-project.md | Resume after session break — read STATE.md, route to next action | STATE.md, HANDOFF.md |
| roadmap-management.md | Dynamic roadmap modifications — add/remove phases mid-milestone | ROADMAP.md, STATE.md |
| transition-phase.md | Phase-level transition — evolve PROJECT.md, verify completion | STATE.md, PROJECT.md, ROADMAP.md |
| unify-phase.md | Reconcile plan vs actual — create SUMMARY.md, close loop | STATE.md, PLAN.md, SUMMARY.md, quality-delta.md, quality-history.md |
| verify-work.md | Guide manual UAT — extract deliverables, generate test checklist | SUMMARY.md, UAT.md |

### 1.2 References (19 files) — ~/.claude/paul-framework/references/

| File | Purpose | Cross-References |
|------|---------|------------------|
| checkpoints.md | Checkpoint types and execution protocol | plan-format.md, apply-phase.md |
| ci-generation.md | CI workflow generation from WALT quality profile | quality-detection.md, quality-runner.md, quality-lint.md |
| context-management.md | Context window strategies — FRESH/MODERATE/DEEP/CRITICAL brackets | work-units.md |
| git-strategy.md | Git integration — commit outcomes not process | apply-phase.md, unify-phase.md |
| loop-phases.md | PLAN/APPLY/UNIFY phase semantics | plan-phase.md, apply-phase.md, unify-phase.md |
| plan-format.md | PLAN.md structure specification — executable prompt format | plan-phase.md, apply-phase.md, checkpoints.md |
| quality-delta.md | WALT quality delta tracking for UNIFY | quality-runner.md, quality-lint.md, unify-phase.md |
| quality-detection.md | Quality tool detection heuristics — zero-config ecosystem scanning | quality-runner.md, quality-lint.md, ci-generation.md |
| quality-history.md | Historical quality tracking across plans | quality-delta.md, unify-phase.md |
| quality-lint.md | WALT lint/typecheck integration for APPLY | quality-detection.md, quality-delta.md, apply-phase.md |
| quality-principles.md | Core PAUL development principles | loop-phases.md, plan-format.md, work-units.md |
| quality-runner.md | WALT test runner for APPLY — baseline/result regression detection | quality-detection.md, quality-delta.md, apply-phase.md |
| research-quality-control.md | Quality assurance patterns for research subagents | research.md, subagent-criteria.md |
| sonarqube-integration.md | SonarQube integration details | quality-gate.md |
| specialized-workflow-integration.md | SPECIAL-FLOWS tracking reference | configure-special-flows.md, SPECIAL-FLOWS.md |
| subagent-criteria.md | Strategic criteria for subagent usage | research.md, map-codebase.md |
| tdd.md | TDD as design quality approach — RED-GREEN-REFACTOR | tdd-detection.md, plan-phase-tdd.md, apply-phase-tdd.md |
| tdd-detection.md | TDD candidate detection heuristics — STRONG/MODERATE/SKIP | tdd.md, plan-phase-tdd.md |
| work-units.md | Plan sizing guide — 50% context target | context-management.md, quality-principles.md |

### 1.3 Templates (19 files) — ~/.claude/paul-framework/templates/

| File | Purpose | Generated By |
|------|---------|-------------|
| codebase/architecture.md | ARCHITECTURE.md template | map-codebase.md |
| codebase/concerns.md | CONCERNS.md template | map-codebase.md |
| codebase/conventions.md | CONVENTIONS.md template | map-codebase.md |
| codebase/integrations.md | INTEGRATIONS.md template | map-codebase.md |
| codebase/stack.md | STACK.md template | map-codebase.md |
| codebase/structure.md | STRUCTURE.md template | map-codebase.md |
| codebase/testing.md | TESTING.md template | map-codebase.md |
| config.md | Project config template | init-project.md |
| CONTEXT.md | Phase discussion handoff template | discuss-phase.md |
| DEBUG.md | Debug session template | debug.md |
| DISCOVERY.md | Technical discovery template | discovery.md |
| HANDOFF.md | Session handoff template | pause-work.md |
| ISSUES.md | Deferred issues template | consider-issues.md |
| milestone-archive.md | Milestone archive template | complete-milestone.md |
| milestone-context.md | Milestone context handoff template | discuss-milestone.md |
| MILESTONES.md | Milestone log template | complete-milestone.md |
| PLAN.md | Executable plan template | plan-phase.md |
| PROJECT.md | Project brief template | init-project.md |
| RESEARCH.md | Research findings template | research.md |
| ROADMAP.md | Phase structure template | init-project.md, create-milestone.md |
| SPECIAL-FLOWS.md | Skill dependencies template | configure-special-flows.md |
| STATE.md | Living memory template | init-project.md |
| SUMMARY.md | Plan completion template | unify-phase.md |
| UAT-ISSUES.md | UAT issues template | verify-work.md |

### 1.4 Rules (5 files) — ~/.claude/paul-framework/rules/

| File | Purpose |
|------|---------|
| commands.md | Rules for command file structure (YAML frontmatter, naming) |
| references.md | Rules for reference file structure (no frontmatter, conceptual docs) |
| style.md | Universal style rules (imperative voice, no filler, brevity) |
| templates.md | Rules for template file structure (header, template block, docs) |
| workflows.md | Rules for workflow file structure (semantic XML, required sections) |

### 1.5 Skill Commands (26 files) — ~/.claude/commands/paul/

| Command | Workflow Target |
|---------|----------------|
| add-phase.md | roadmap-management.md |
| apply.md | apply-phase.md |
| assumptions.md | phase-assumptions.md |
| complete-milestone.md | complete-milestone.md |
| config.md | (standalone) |
| consider-issues.md | consider-issues.md |
| discover.md | discovery.md |
| discuss-milestone.md | discuss-milestone.md |
| discuss.md | discuss-phase.md |
| flows.md | configure-special-flows.md |
| handoff.md | pause-work.md |
| help.md | (standalone) |
| init.md | init-project.md |
| map-codebase.md | map-codebase.md |
| milestone.md | create-milestone.md |
| pause.md | pause-work.md |
| plan-fix.md | plan-format.md |
| plan.md | plan-phase.md |
| progress.md | (standalone) |
| remove-phase.md | roadmap-management.md |
| research-phase.md | research.md |
| research.md | research.md |
| resume.md | resume-project.md |
| status.md | [DEPRECATED → progress.md] |
| unify.md | unify-phase.md |
| verify.md | verify-work.md |

---

## 2. CARL System (14 files)

### 2.1 Core Domain Files (5 files) — ~/.carl/

| File | Purpose | Integration |
|------|---------|-------------|
| manifest | Domain registry — controls active domains, recall keywords, injection order | Hook system reads this to determine what to inject |
| global | Universal rules (9 rules) — foundational behaviors, never disabled | ALWAYS_ON=true in manifest |
| context | Dynamic context-aware rules — FRESH/MODERATE/DEPLETED brackets | ALWAYS_ON=true in manifest, auto-selects by context % |
| commands | Star-commands (*dev, *review, *brief, *plan, *discuss, *debug, *explain, *carl) | Activated via recall keywords in manifest |
| example-custom-domain | Template for creating custom domains | Reference only |

### 2.2 Skill Commands (9 files) — ~/.claude/commands/carl/

| File | Purpose |
|------|---------|
| manager.md | Root entry — list/add/create/edit/toggle/view/suggest/help |
| tasks/add-rule.md | Add rule to existing domain |
| tasks/create-domain.md | Create new domain with manifest entries |
| tasks/create-command.md | Create star-command in COMMANDS domain |
| tasks/edit-rule.md | Edit or delete existing rule |
| tasks/toggle-domain.md | Enable/disable domain via manifest |
| utils/manifest-parser.md | Reference for manifest format parsing |
| templates/domain-template.md | Template for domain file creation |
| templates/manifest-entries.md | Template for manifest entry types |

---

## 3. TODD — Test-Driven Development (4 files, embedded in PAUL)

| File | Category | Purpose |
|------|----------|---------|
| workflows/plan-phase-tdd.md | Workflow | TDD plan overlay — RED/GREEN/REFACTOR task structure |
| workflows/apply-phase-tdd.md | Workflow | TDD execution overlay — phase-gated sequencing, atomic commits |
| references/tdd-detection.md | Reference | Detection heuristics — STRONG/MODERATE/SKIP assessment |
| references/tdd.md | Reference | TDD principles — when to use, plan structure, execution flow |

**Integration into PAUL loop:**
- plan-phase.md → detects TDD candidate → delegates to plan-phase-tdd.md
- apply-phase.md → detects type:tdd → delegates to apply-phase-tdd.md
- unify-phase.md → audit_tdd_execution step → verifies RED/GREEN/REFACTOR commits

---

## 4. WALT — Quality Assurance & Gating (8 files, embedded in PAUL)

| File | Category | Purpose |
|------|----------|---------|
| workflows/quality-gate.md | Workflow | SonarQube scan — check gates, update CONCERNS.md |
| references/quality-detection.md | Reference | Tool detection — zero-config ecosystem scanning |
| references/quality-delta.md | Reference | Delta tracking — before/after metrics for UNIFY |
| references/quality-history.md | Reference | Historical tracking — cumulative trajectory across plans |
| references/quality-lint.md | Reference | Lint/typecheck integration — auto-fix, surface blockers |
| references/quality-principles.md | Reference | Core development principles |
| references/quality-runner.md | Reference | Test runner — baseline/result regression detection |
| references/research-quality-control.md | Reference | Research subagent quality assurance |

**Integration into PAUL loop:**
- apply-phase.md → walt_baseline step → quality-runner.md (before tasks)
- apply-phase.md → walt_post_apply step → quality-runner.md + quality-lint.md (after tasks)
- unify-phase.md → audit_quality_delta step → quality-delta.md → quality-history.md

---

## 5. Dependency Map

### Component Interaction Matrix

| From ↓ / To → | PAUL Core | CARL | TODD | WALT |
|----------------|-----------|------|------|------|
| **PAUL Core** | Internal refs | None (independent) | Conditional delegation | Embedded in apply/unify |
| **CARL** | None | Internal refs | None | None |
| **TODD** | Hooks into plan/apply/unify | None | Internal refs | None |
| **WALT** | Hooks into apply/unify | None | None | Internal refs |

### Key Findings

1. **CARL is fully independent** — no references to/from PAUL, TODD, or WALT. Integration is purely through Claude Code hooks (system-level, not file-level).

2. **TODD and WALT are embedded overlays** — they live inside the PAUL framework directory but are conditionally activated:
   - TODD: activated by plan type detection
   - WALT: activated by test/lint tool detection

3. **PAUL is the hub** — all other components integrate through PAUL's plan/apply/unify lifecycle.

4. **No TODD↔WALT dependency** — they operate independently during different lifecycle phases.

### Hub Files (coordinate multiple components)

| File | Components Coordinated |
|------|----------------------|
| apply-phase.md | PAUL + TODD (conditional) + WALT (quality gates) |
| unify-phase.md | PAUL + TODD (audit) + WALT (delta/history) |
| plan-phase.md | PAUL + TODD (detection/delegation) |

### Integration Mechanisms

| Mechanism | Used By | How |
|-----------|---------|-----|
| @-reference delegation | TODD → PAUL workflows | plan-phase.md delegates to plan-phase-tdd.md |
| Frontmatter conditional | TODD execution | type: tdd in PLAN.md triggers TDD apply |
| Step hooks | WALT in APPLY | walt_baseline and walt_post_apply steps in apply-phase.md |
| Step hooks | WALT in UNIFY | audit_quality_delta step in unify-phase.md |
| System hooks | CARL → Claude Code | UserPromptSubmit hook injects carl-rules |
| Manifest registry | CARL domains | ~/.carl/manifest controls domain loading |

---

## 6. Component Boundaries

### Purely PAUL (no TODD/WALT/CARL involvement)
- init-project.md, resume-project.md, pause-work.md
- discuss-phase.md, discuss-milestone.md, phase-assumptions.md
- create-milestone.md, complete-milestone.md, roadmap-management.md
- map-codebase.md, debug.md, discovery.md, research.md
- consider-issues.md, verify-work.md, configure-special-flows.md
- All templates, all rules, all non-quality/TDD references
- All skill commands (wrappers only)

### TODD Boundary
- 4 files total, all within ~/.claude/paul-framework/
- Activated conditionally via type detection
- No standalone operation — requires PAUL lifecycle

### WALT Boundary
- 8 files total, all within ~/.claude/paul-framework/
- quality-gate.md is somewhat standalone (SonarQube)
- Other 7 files are embedded in PAUL apply/unify steps
- No standalone operation — requires PAUL lifecycle

### CARL Boundary
- 14 files total, split between ~/.carl/ and ~/.claude/commands/carl/
- Fully standalone — operates independently of PAUL
- Integration is at Claude Code system level (hooks), not file level
- Has its own command namespace (/carl:*)

---

*Audit complete: 93 files mapped across 4 components*
*Ready for Plan 01-02: Unified PALS structure design*
