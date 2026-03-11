# Roadmap: pals

## Overview
PALS unifies PAUL (project lifecycle), CARL (context rules), TODD (TDD enforcement), and WALT (quality gating) into a single distributable framework for Claude Code. The journey goes from mapping the current scattered architecture, through restructuring and merging, to a clean installable package validated end-to-end.

## Milestones

### v0.1 Fork & Unify (Complete)
Phases: 6 of 6 complete — 2026-03-11

### v0.2 Polish (Complete)
Status: Complete
Phases: 1 of 1 complete — 2026-03-11

### v0.3 Smart Context & Migration (Current)
Status: Not started
Phases: 0 of 2 complete

## Phases (v0.3)

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 8 | Smart Installer | TBD | Not started | - |
| 9 | Auto Context Cycling | TBD | Not started | - |

## Phases (v0.2)

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 7 | Namespace & Cleanup | 1 | Complete | 2026-03-11 |

## Phases (v0.1 — Complete)

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 1 | Architecture & Design | 2 | Complete | 2026-03-11 |
| 2 | Fork & Restructure | 3 | Complete | 2026-03-11 |
| 3 | Merge TODD/WALT | 2 | Complete | 2026-03-11 |
| 4 | CARL Integration | 2 | Complete | 2026-03-11 |
| 5 | Install & Distribution | 2 | Complete | 2026-03-11 |
| 6 | End-to-End Validation | 1 | Complete | 2026-03-11 |

## Phase Details (v0.3)

### Phase 8: Smart Installer

**Goal:** Make install.sh upgrade-aware — detect and clean up legacy `~/.claude/paul-framework/` during install
**Depends on:** v0.2 complete
**Research:** No

**Scope:**
- Detect existing `~/.claude/paul-framework/` during install
- Offer to remove legacy installation
- Handle upgrade path cleanly (no data loss)

**Plans:**
- [ ] 08-01: Upgrade-aware installer with legacy cleanup

### Phase 9: Auto Context Cycling

**Goal:** Automate the pause → clear → resume cycle when context pressure reaches critical threshold
**Depends on:** Phase 8 (installer updated)
**Research:** Yes (need to determine if `/clear` can be triggered programmatically)

**Scope:**
- Research programmatic context clearing mechanism
- Enhance CARL hook to trigger auto-cycle at ~40% remaining
- Optimize handoff format for machine consumption (structured, minimal)
- Ensure no data loss during automated cycling

**Plans:**
- [ ] 09-01: Research context clearing mechanism
- [ ] 09-02: Implement auto context cycling

---

## Phase Details (v0.2 — Complete)

### Phase 7: Namespace & Cleanup

**Goal:** Remove /paul:* command duplication, standardize on /paul:* namespace, clean up leftover artifacts
**Depends on:** v0.1 complete
**Research:** No

**Scope:**
- Rename commands/pals/ → commands/paul/ in repo
- Batch replace /paul: → /paul: across all framework files
- Update install.sh and uninstall.sh for paul/ command paths
- Update README.md references
- Remove test-lifecycle.sh

**Plans:**
- [x] 07-01: Namespace rename and cleanup

---

## Phase Details (v0.1 — Complete)

### Phase 1: Architecture & Design

**Goal:** Map the current scattered structure across ~/.claude/, ~/.carl/, and ~/claude/todd/, then design the unified PALS layout
**Depends on:** Nothing (first phase)
**Research:** Likely (need to understand all component boundaries and interactions)

**Scope:**
- Audit all PAUL framework files (workflows, references, templates, rules)
- Audit CARL structure (manifest, domains, hooks, commands)
- Audit TODD/WALT subsystems (TDD workflows, quality gates)
- Design unified ~/.pals/ directory structure
- Define file mapping: source → destination for every file

**Plans:**
- [x] 01-01: Audit current architecture — map every file across PAUL, CARL, TODD, WALT
- [x] 01-02: Design unified PALS structure — directory layout, naming conventions, file mapping

### Phase 2: Fork & Restructure

**Goal:** Create the PALS repository structure and migrate core PAUL files
**Depends on:** Phase 1 (architecture design)
**Research:** Unlikely (internal restructuring)

**Scope:**
- Create PALS directory structure per Phase 1 design
- Migrate core PAUL workflows (plan, apply, unify, etc.)
- Migrate PAUL templates and references
- Update all internal @-references to new paths
- Migrate PAUL skill commands

**Plans:**
- [x] 02-01: Create directory structure and migrate core workflows
- [x] 02-02: Migrate templates, references, and rules
- [x] 02-03: Migrate and rewire skill commands

### Phase 3: Merge TODD/WALT

**Goal:** Integrate TODD (TDD) and WALT (quality) as native PALS workflow steps with names preserved
**Depends on:** Phase 2 (core structure exists)
**Research:** Unlikely (established patterns)

**Scope:**
- Merge TDD workflows into core plan/apply lifecycle
- Merge quality gate into core unify lifecycle
- Remove indirection — TODD/WALT steps run directly in core workflows
- Update references and detection heuristics

**Plans:**
- [x] 03-01: Merge TODD (TDD) into plan/apply workflows
- [x] 03-02: Merge WALT (quality) into unify workflow

### Phase 4: CARL Integration

**Goal:** Make CARL a native PALS component instead of a separate system
**Depends on:** Phase 2 (PALS structure exists)
**Research:** Likely (hook integration, manifest format decisions)

**Scope:**
- Integrate CARL domain/rule management into PALS
- Migrate global rules and manifest
- Wire CARL hooks into PALS lifecycle
- Update CARL commands to work within PALS namespace

**Plans:**
- [x] 04-01: Migrate CARL core (manifest, domains, global rules)
- [x] 04-02: Wire CARL hooks and commands into PALS namespace

### Phase 5: Install & Distribution

**Goal:** Single setup script that installs PALS from git clone
**Depends on:** Phases 2-4 (all components merged)
**Research:** Likely (Claude Code skill wiring, hook registration)

**Scope:**
- Create install/setup script
- Skill registration (symlink or copy to ~/.claude/commands/)
- Hook configuration
- Documentation for getting started
- Uninstall/cleanup script

**Plans:**
- [x] 05-01: Create install script and skill wiring
- [x] 05-02: Create getting-started docs and uninstall script

### Phase 6: End-to-End Validation

**Goal:** Full PLAN-APPLY-UNIFY loop on a test project using installed PALS
**Depends on:** Phase 5 (installable package)
**Research:** Unlikely (validation only)

**Scope:**
- Install PALS from scratch on test project
- Run complete lifecycle: init → plan → apply → unify
- Validate CARL rules activate correctly
- Validate TODD/WALT engage at correct lifecycle points
- Fix any integration issues discovered

**Plans:**
- [x] 06-01: Full lifecycle validation on test project

---
*Roadmap created: 2026-03-11*
*Last updated: 2026-03-11 — v0.3 milestone created*
