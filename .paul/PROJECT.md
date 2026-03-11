# Project: pals

## Description
PALS - Project Automation & Lifecycle System. Based on PAUL and CARL along with their pals TODD and WALT. They team up to give users the agentic coding framework that makes development friendly.

## Core Value
The ultimate user friendly end-to-end Claude Code software development framework

## Requirements

### Must Have
- Unified ~/.pals/ directory structure housing all components
- /pals:* command namespace replacing /paul:*
- CARL as native component with /carl:* namespace retained
- TODD/WALT merged inline (not overlays)
- Single install script from git clone

### Should Have
- Clean migration path from existing PAUL/CARL installs
- Complete @-reference rewiring across all files

### Nice to Have
- Uninstall/cleanup script
- Getting-started documentation

### Validated
- ✓ Architecture fully mapped (111 files across 4 components) — Phase 1
- ✓ Unified structure designed (105 destinations, 6 consolidations) — Phase 1
- ✓ PALS repo structure created with 96 PAUL files migrated — Phase 2
- ✓ /pals:* command namespace replacing /paul:* — Phase 2
- ✓ All @-references rewritten to ~/.pals/ paths — Phase 2

## Constraints
- CARL remains architecturally independent (hook-level integration only)
- TODD/WALT have no standalone operation — always PALS-native
- /carl:* namespace preserved (not merged into /pals:*)

## Key Decisions

| Decision | Phase | Rationale |
|----------|-------|-----------|
| CARL is fully independent (hook-level integration) | 1 | No file-level refs between CARL and PAUL |
| TODD/WALT are embedded subsets, not overlays | 1 | All files inside paul-framework/, behavioral not structural |
| Flat workflows/ directory (no TODD/WALT subdirs) | 1 | Only 3 overlay files, all merge into parents |
| CARL gets own subdirectory (~/.pals/carl/) | 1 | Independent runtime config, not docs |
| /pals:* namespace, /carl:* retained | 1 | Unified brand + CARL independence |
| TODD workflows merge inline | 1 | TDD is a mode, not a system |

## Success Criteria
- The ultimate user friendly end-to-end Claude Code software development framework is achieved
- Single `git clone` + install script gets PALS working
- Full PLAN-APPLY-UNIFY loop works on test project

## Specialized Flows

See: .paul/SPECIAL-FLOWS.md

Quick Reference:
- /paul → Project planning & lifecycle management
- /carl → Context rules & domain configuration
- TODD → Test-driven development enforcement
- WALT → Quality gating & validation

---
*Created: 2026-03-11*
*Last updated: 2026-03-11 after Phase 1*
