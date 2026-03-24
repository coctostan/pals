# Module Hardening Retest — Before vs After

**Date:** 2026-03-24
**Model:** Kimi for Coding K2.5
**Test:** Same adversarial scenario (god function, unused import, doc drift, decision, fake API key)

## Per-Module Comparison

### IRIS — Code Review & Security
| Metric | Before (Phase 100) | After (Phase 108) |
|--------|-------------------|-------------------|
| Output | "No anti-patterns detected" | 5 specific findings with categories |
| God function | ❌ Not detected | ✅ "god-function: 6 parameters" |
| Deep nesting | ❌ Not detected | ✅ "deep-nesting: 4 levels" |
| Magic number | ❌ Not detected | ✅ "magic-number: 42 (2 instances)" |
| Complex function | ❌ Not detected | ✅ "complex-function: 64 lines" |
| Security pattern | ❌ Not detected | ✅ "security-pattern: sk-test-fake123" |
| **Grade** | **C** | **A** |

### RUBY — Debt Detection
| Metric | Before | After |
|--------|--------|-------|
| Output | "No debt flags detected" | 5 findings with severity levels |
| Cyclomatic complexity | ❌ Not measured | ✅ "12+ (HIGH)" with threshold |
| Lines per function | ❌ Not measured | ✅ "64 (HIGH)" with threshold |
| Parameter count | ❌ Not measured | ✅ "6 (HIGH)" with threshold |
| Refactor priority | ❌ None | ✅ "[URGENT]" |
| **Grade** | **C** | **A** |

### DOCS — Documentation Drift
| Metric | Before | After |
|--------|--------|-------|
| Output | "README.md exists" | Specific drift warnings per file |
| README drift | ❌ Generic | ✅ "README.md: NOT UPDATED — DRIFT" |
| CHANGELOG | ❌ Not checked | ✅ "CHANGELOG.md: NOT UPDATED — DRIFT" |
| File count | ❌ Not shown | ✅ "Files modified: 4" |
| **Grade** | **B** | **A-** |

### SKIP — Knowledge Extraction
| Metric | Before | After |
|--------|--------|-------|
| Output | "No decisions to extract" | Decision text quoted |
| Decision detection | ❌ Missed | ✅ Found and quoted |
| Structured format | ❌ None | ⚠️ Quoted but not full Decision Record template |
| **Grade** | **D** | **B+** |

### WALT — Quality Gating (enforcement)
| Metric | Before | After |
|--------|--------|-------|
| Blocking | ✅ Worked | ✅ Still works |
| Specificity | "2 lint warnings" | "src/index.ts:2 'existsSync' unused, src/tool.ts:7 'RETEST_MARKER' unused" |
| **Grade** | **A** | **A+** |

### TODD — TDD Enforcement (enforcement)
| Metric | Before | After |
|--------|--------|-------|
| Blocking | ✅ Worked | ✅ Still works |
| Output | "26/26 tests passing" | "Tests 26/26 passing" |
| **Grade** | **A+** | **A+** |

### DEAN — Dependency Audit
| Metric | Before | After |
|--------|--------|-------|
| Output | "27 advisories (non-blocking)" | Not adversarially tested this round |
| **Grade** | **B** | **B** (unchanged — hook upgraded but not retested) |

### DAVE — Deploy Verification
| Metric | Before | After |
|--------|--------|-------|
| Output | "CI config exists" | Not adversarially tested this round |
| **Grade** | **C+** | **C+** (unchanged — hook upgraded but not retested) |

## Two-Step Dispatch

| Test | Result |
|------|--------|
| Advisory modules run before enforcement | ✅ VERIFIED |
| IRIS/RUBY/DOCS/SKIP output visible when WALT blocks | ✅ VERIFIED |
| Enforcement still blocks correctly | ✅ VERIFIED |
| Structural separation (separate `<step>` blocks) | ✅ Working |

## Overall Grade Improvement

| Module | Before | After | Δ |
|--------|--------|-------|---|
| IRIS | C | **A** | +4 |
| RUBY | C | **A** | +4 |
| DOCS | B | **A-** | +2 |
| SKIP | D | **B+** | +3 |
| WALT | A | **A+** | +1 |
| TODD | A+ | **A+** | 0 |
| DEAN | B | B | 0 (not retested) |
| DAVE | C+ | C+ | 0 (not retested) |
