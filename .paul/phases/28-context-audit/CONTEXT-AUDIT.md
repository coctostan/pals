# Context Audit — v0.9 Phase 28

**Date:** 2026-03-13
**Status:** Measurement complete, optimization pending

## Per-File Measurements

### TODD Module (5 references)
| File | Lines | Est. Tokens | Over 150? |
|------|-------|-------------|-----------|
| tdd-plan-generation.md | 302 | 2,074 | YES |
| tdd.md | 245 | 1,726 | YES |
| tdd-execution.md | 240 | 2,096 | YES |
| coverage-detection.md | 154 | 1,262 | YES |
| tdd-detection.md | 118 | 960 | - |
| **TODD Total** | **1,059** | **8,118** | **4 of 5** |

### WALT Module (7 references)
| File | Lines | Est. Tokens | Over 150? |
|------|-------|-------------|-----------|
| quality-detection.md | 376 | 3,614 | YES |
| quality-runner.md | 260 | 2,372 | YES |
| quality-lint.md | 243 | 2,161 | YES |
| quality-history.md | 176 | 1,226 | YES |
| quality-delta.md | 173 | 1,433 | YES |
| quality-trends.md | 163 | 1,407 | YES |
| quality-principles.md | 126 | 849 | - |
| **WALT Total** | **1,517** | **13,062** | **6 of 7** |

### DAVE Module (3 references)
| File | Lines | Est. Tokens | Over 150? |
|------|-------|-------------|-----------|
| pipeline-generation.md | 224 | 1,278 | YES |
| deploy-verification.md | 162 | 1,144 | YES |
| deploy-principles.md | 105 | 1,027 | - |
| **DAVE Total** | **491** | **3,448** | **2 of 3** |

### DEAN Module (3 references)
| File | Lines | Est. Tokens | Over 150? |
|------|-------|-------------|-----------|
| vulnerability-audit.md | 212 | 2,000 | YES |
| dependency-detection.md | 134 | 1,210 | - |
| dependency-principles.md | 57 | 635 | - |
| **DEAN Total** | **403** | **3,845** | **1 of 3** |

### RUBY Module (3 references)
| File | Lines | Est. Tokens | Over 150? |
|------|-------|-------------|-----------|
| refactor-patterns.md | 213 | 1,668 | YES |
| debt-detection.md | 111 | 1,070 | - |
| refactor-principles.md | 73 | 814 | - |
| **RUBY Total** | **397** | **3,552** | **1 of 3** |

### IRIS Module (3 references)
| File | Lines | Est. Tokens | Over 150? |
|------|-------|-------------|-----------|
| review-patterns.md | 164 | 2,278 | YES |
| inspection-checklists.md | 103 | 1,122 | - |
| review-principles.md | 75 | 766 | - |
| **IRIS Total** | **342** | **4,166** | **1 of 3** |

### SKIP Module (3 references)
| File | Lines | Est. Tokens | Over 150? |
|------|-------|-------------|-----------|
| knowledge-capture.md | 123 | 811 | - |
| knowledge-search.md | 110 | 999 | - |
| knowledge-principles.md | 65 | 716 | - |
| **SKIP Total** | **298** | **2,526** | **0 of 3** |

### Kernel Workflows (hook dispatch hosts)
| File | Lines | Est. Tokens |
|------|-------|-------------|
| apply-phase.md | 321 | 2,947 |
| unify-phase.md | 264 | 2,105 |
| plan-phase.md | 260 | 2,414 |
| **Kernel Total** | **845** | **7,466** |

## Per-Module Summary (ranked by weight)

| Rank | Module | Refs | Lines | Tokens | % of Total |
|------|--------|------|-------|--------|------------|
| 1 | WALT | 7 | 1,517 | 13,062 | 33.7% |
| 2 | TODD | 5 | 1,059 | 8,118 | 21.0% |
| 3 | DAVE | 3 | 491 | 3,448 | 8.9% |
| 4 | DEAN | 3 | 403 | 3,845 | 9.9% |
| 5 | RUBY | 3 | 397 | 3,552 | 9.2% |
| 6 | IRIS | 3 | 342 | 4,166 | 10.8% |
| 7 | SKIP | 3 | 298 | 2,526 | 6.5% |
| **Total** | | **27** | **4,507** | **38,717** | **100%** |

## Per-Hook-Point Aggregates

Based on module.yaml hook registrations, worst-case context load at each lifecycle point (all declared references loaded per module):

| Hook Point | Modules Firing | Total Refs Loaded | Total Lines | Total Tokens |
|------------|---------------|-------------------|-------------|-------------|
| pre-plan | DEAN, TODD, IRIS, DAVE, RUBY | 17 | 2,692 | 23,129 |
| post-plan | TODD | 5 | 1,059 | 8,118 |
| pre-apply | TODD, WALT | 12 | 2,576 | 21,180 |
| post-task | TODD | 5 | 1,059 | 8,118 |
| post-apply | WALT, DEAN, DAVE, IRIS, SKIP | 19 | 3,051 | 27,047 |
| post-unify | WALT, SKIP, RUBY | 13 | 2,212 | 19,140 |

**Worst hook point:** post-apply loads 19 references totaling ~27K tokens from 5 modules.

## Top 10 Heaviest Files

| Rank | File | Module | Lines | Tokens |
|------|------|--------|-------|--------|
| 1 | quality-detection.md | WALT | 376 | 3,614 |
| 2 | tdd-plan-generation.md | TODD | 302 | 2,074 |
| 3 | quality-runner.md | WALT | 260 | 2,372 |
| 4 | tdd.md | TODD | 245 | 1,726 |
| 5 | quality-lint.md | WALT | 243 | 2,161 |
| 6 | tdd-execution.md | TODD | 240 | 2,096 |
| 7 | pipeline-generation.md | DAVE | 224 | 1,278 |
| 8 | refactor-patterns.md | RUBY | 213 | 1,668 |
| 9 | vulnerability-audit.md | DEAN | 212 | 2,000 |
| 10 | quality-history.md | WALT | 176 | 1,226 |

## Findings

### Critical Issues
1. **WALT is 34% of total context** — 7 references, 1,517 lines. Heaviest module by far.
2. **TODD is 21% of total** — 5 references, 1,059 lines. Second heaviest.
3. **15 of 27 files exceed 150-line cap** — over half need trimming.
4. **pre-plan loads 5 modules (~23K tokens)** — significant context overhead before planning even starts.
5. **post-apply loads 5 modules (~27K tokens)** — heaviest single hook point.

### Redundancy Patterns
- Every module has a `*-principles.md` with similar structure (purpose, philosophy, guidelines). These share boilerplate patterns.
- Detection files across modules (quality-detection, tdd-detection, dependency-detection, debt-detection) follow identical structures with framework-specific tables.
- Several files repeat "when to use" / "when not to use" patterns that could be more concise.

### Optimization Targets
- **Must trim (>200 lines):** 7 files — quality-detection, tdd-plan-generation, quality-runner, tdd, quality-lint, tdd-execution, pipeline-generation
- **Should trim (150-200):** 8 files — refactor-patterns, vulnerability-audit, quality-history, quality-delta, quality-trends, review-patterns, deploy-verification, coverage-detection
- **OK (<150):** 12 files — no changes needed

---

## After Optimization

### Before vs After (optimized files only)

| File | Module | Before | After | Reduction |
|------|--------|--------|-------|-----------|
| quality-detection.md | WALT | 376 | 133 | -65% |
| tdd-plan-generation.md | TODD | 302 | 91 | -70% |
| quality-runner.md | WALT | 260 | 107 | -59% |
| tdd.md | TODD | 245 | 77 | -69% |
| quality-lint.md | WALT | 243 | 98 | -60% |
| tdd-execution.md | TODD | 240 | 81 | -66% |
| pipeline-generation.md | DAVE | 224 | 141 | -37% |
| refactor-patterns.md | RUBY | 213 | 66 | -69% |
| vulnerability-audit.md | DEAN | 212 | 107 | -50% |
| quality-history.md | WALT | 176 | 86 | -51% |
| quality-delta.md | WALT | 173 | 84 | -51% |
| review-patterns.md | IRIS | 164 | 58 | -65% |
| quality-trends.md | WALT | 163 | 83 | -49% |
| deploy-verification.md | DAVE | 162 | 74 | -54% |
| coverage-detection.md | TODD | 154 | 64 | -58% |

### Per-Module Before vs After

| Module | Before | After | Reduction | Files |
|--------|--------|-------|-----------|-------|
| WALT | 1,517 | 717 | -53% | 7 (6 trimmed, 1 already OK) |
| TODD | 1,059 | 431 | -59% | 5 (4 trimmed, 1 already OK) |
| DAVE | 491 | 320 | -35% | 3 (2 trimmed, 1 already OK) |
| DEAN | 403 | 298 | -26% | 3 (1 trimmed, 2 already OK) |
| RUBY | 397 | 250 | -37% | 3 (1 trimmed, 2 already OK) |
| IRIS | 342 | 236 | -31% | 3 (1 trimmed, 2 already OK) |
| SKIP | 298 | 298 | 0% | 3 (0 trimmed — all under 150) |
| **Total** | **4,507** | **2,550** | **-43%** | **27 (15 trimmed)** |

### System Totals Before vs After

| Category | Before Lines | After Lines | Before Tokens | After Tokens |
|----------|-------------|-------------|---------------|-------------|
| Module references | 4,507 | 2,550 | ~38,717 | ~21,930 |
| Kernel workflows | 845 | 845 | ~7,466 | ~7,466 |
| **System total** | **5,352** | **3,395** | **~46,183** | **~29,396** |

**Total reduction: 1,957 lines (43%), ~16,787 tokens saved**

### Per-Hook-Point After Optimization

| Hook Point | Modules | Before Tokens | After Tokens | Reduction |
|------------|---------|---------------|-------------|-----------|
| pre-plan | DEAN, TODD, IRIS, DAVE, RUBY | ~23,129 | ~13,100 | -43% |
| post-plan | TODD | ~8,118 | ~3,700 | -54% |
| pre-apply | TODD, WALT | ~21,180 | ~9,900 | -53% |
| post-task | TODD | ~8,118 | ~3,700 | -54% |
| post-apply | WALT, DEAN, DAVE, IRIS, SKIP | ~27,047 | ~16,600 | -39% |
| post-unify | WALT, SKIP, RUBY | ~19,140 | ~10,900 | -43% |

## Context Budgets

Based on findings and optimization results:

| Module Type | Max References | Max Lines/Module | Max Lines/File |
|-------------|---------------|-----------------|----------------|
| Core (TODD, WALT) | 5-7 | 750 | 150 |
| Standard (DEAN, IRIS, SKIP, DAVE, RUBY) | 3 | 350 | 150 |
| Platform (CARL) | N/A (no lifecycle hooks) | N/A | 150 |

**Per-file hard cap: 150 lines.** No reference file should exceed this.

**Per-hook-point advisory: ~15K tokens.** If a hook point exceeds this after adding a new module, the module should consolidate references.

**New module guidance:** A new module should target ≤3 reference files totaling ≤300 lines.
