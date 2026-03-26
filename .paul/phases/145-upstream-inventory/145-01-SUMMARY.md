---
phase: 145-upstream-inventory
plan: 01
type: research
completed: 2026-03-26T00:00:00Z
---

# Phase 145 Plan 01: Upstream Inventory — Summary

## What Was Planned
Produce structured inventories of ChristopherKahler/paul (v1.2) and ChristopherKahler/carl (v2.0.1), cataloging every file with purpose, PALS equivalent, status, and notes.

## What Was Built

### Deliverables
1. **`upstream-paul-inventory.md`** — 246-line catalog of all 102 upstream PAUL files
2. **`upstream-carl-inventory.md`** — 148-line catalog of all 20 upstream CARL files

### PAUL Inventory Results (102 files)
| Status | Count | % |
|--------|-------|---|
| Equivalent | 58 | 57% |
| Diverged | 8 | 8% |
| Novel | 11 | 11% |
| Superseded | 26 | 25% |

### CARL Inventory Results (20 files)
| Status | Count | % |
|--------|-------|---|
| Equivalent | 2 | 10% |
| Diverged | 7 | 35% |
| Novel | 11 | 55% |
| Superseded | 0 | 0% |

## Key Findings

### Upstream PAUL — Notable Novel/Diverged Items
1. **Execute/Qualify (E/Q) Loop** — v1.2's key addition. After each task: Execute → Report Status (DONE/DONE_WITH_CONCERNS/NEEDS_CONTEXT/BLOCKED) → Qualify (re-read output, re-run verify, compare to AC) → Score (PASS/GAP/DRIFT) → loop on gaps. Our version has structured status but no explicit qualify-and-loop.
2. **`/paul:audit` + `audit-plan.md`** — Enterprise plan audit between PLAN and APPLY. Senior principal engineer role. Auto-applies must-have findings. Config-gated.
3. **`quality-principles.md`** — Standalone philosophy reference: "Plans are prompts", "Solo developer Claude", "Loop first". Concepts embedded in our workflows but not extracted.
4. **Quick-track in UNIFY** — Single-task/no-boundary plans get compressed SUMMARY.
5. **`quality-gate.md`** — Active SonarQube workflow (we have the reference but no workflow).
6. **`tdd.md`** — Standalone TDD guide with clear when-to/when-not-to heuristics.
7. **NPM distribution** — `npx paul-framework` cross-platform install.

### Upstream CARL — Fundamentally Different Product
The two CARLs have diverged into entirely different tools:
- **Upstream CARL** = General-purpose contextual rule injection system (domains, keywords, rules, MCP server)
- **Our CARL** = PALS-specific session boundary manager (phase detection, thresholds, auto-resume)

Novel upstream CARL concepts:
1. **MCP Server** with 4 tool groups — runtime domain/rule/decision management
2. **Rule staging pipeline** — proposed rules go through approval before activation
3. **Formal JSON Schema** for carl.json validation
4. **Domain-based keyword matching** — rules load/unload based on prompt content
5. **Context brackets** — behavior adaptation at FRESH/MODERATE/DEPLETED levels
6. **Migration tooling** — automated v1→v2 config migration script

### What PALS Has That Upstream Doesn't
- **18-module system** (TODD, WALT, DEAN, IRIS, SKIP, DAVE, RUBY, DOCS, ARCH, SETH, PETE, GABE, LUKE, ARIA, DANA, OMAR, REED, VERA)
- **Multi-driver architecture** (Pi, Claude Code, Agent SDK)
- **GitHub Flow enforcement** with merge gate
- **Lightweight fix loop** (3 modes)
- **Collaboration levels** and progressive review
- **Layered onboarding** (quick/greenfield/brownfield)

## Acceptance Criteria Results
| AC | Result | Evidence |
|----|--------|----------|
| AC-1: PAUL Inventory Complete | ✅ PASS | 102 files cataloged with all 5 fields |
| AC-2: CARL Inventory Complete | ✅ PASS | 20 files cataloged with all 5 fields |
| AC-3: Novel Content Flagged | ✅ PASS | 12 PAUL items + 10 CARL items flagged for Phase 146 |

## Deviations
None — executed exactly as planned.

## Decisions
None required during this research phase.

## Items for Phase 146 (Comparative Analysis)

### High-Priority Review
1. **E/Q Loop** — Should we adopt the explicit Qualify step after each task?
2. **Plan Audit** — Should we add a `/paul:audit` command or extend IRIS?
3. **Upstream CARL capabilities** — Any MCP/domain/staging concepts worth adopting?

### Medium-Priority Review
4. **Quality principles reference** — Should we extract a standalone philosophy doc?
5. **Quick-track UNIFY** — Should standard plans get compressed SUMMARY when simple?
6. **Formal JSON Schema** — Should we add machine-readable pals.json validation?
7. **NPM distribution** — Should PALS be NPM-publishable?

### Low-Priority / Skip Candidates
8. **SonarQube workflow** — Niche integration, existing reference is sufficient
9. **BASE satellite system** — Not relevant to our architecture
10. **PAUL-VS-GSD.md** — Marketing doc, not functional
