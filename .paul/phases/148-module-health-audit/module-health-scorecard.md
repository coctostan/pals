# Module Health Scorecard

**Phase:** 148 — Module Health Audit
**Date:** 2026-03-26
**Scope:** All 18 installed modules in modules.yaml

---

## 1. Context Cost

### Summary
| Metric | Value |
|--------|-------|
| Total modules | 18 |
| Total YAML lines (modules.yaml) | 298 |
| Total reference file lines | 3,283 |
| **Total context lines** | **3,581** |
| Estimated tokens (all refs loaded) | ~28,600 |
| Phase 28 baseline (2026-03-13) | 2,550 lines |
| **Growth since Phase 28** | **+1,031 lines (+40.4%)** |
| Unique reference files | 32 |

### Per-Module Cost Table

| Module | Tier | YAML Lines | Ref Files | Ref Lines | Total Lines | Est. Tokens | Hooks |
|--------|------|-----------|-----------|-----------|-------------|-------------|-------|
| **walt** | Core | 23 | 5 | 540 | 563 | ~4,500 | pre-apply, post-apply, post-unify |
| **todd** | Core | 31 | 4 | 420 | 451 | ~3,600 | pre-plan, post-plan, pre-apply, post-task, post-apply |
| **arch** | Exp-I | 17 | 3 | 235 | 252 | ~2,000 | pre-plan, post-apply |
| **skip** | Original | 16 | 2 | 233 | 249 | ~2,000 | post-apply, post-unify |
| **dave** | Original | 15 | 2 | 224 | 239 | ~1,900 | pre-plan, post-apply |
| **docs** | Original | 15 | 2 | 187 | 202 | ~1,600 | pre-plan, post-apply |
| **ruby** | Original | 15 | 2 | 181 | 196 | ~1,600 | pre-plan, post-unify |
| **dean** | Original | 15 | 1 | 163 | 178 | ~1,400 | pre-plan, post-apply |
| **iris** | Original | 16 | 2 | 161 | 177 | ~1,400 | pre-plan, post-apply |
| **aria** | Exp-II | 15 | 1 | 120 | 135 | ~1,100 | pre-plan, post-apply |
| **dana** | Exp-II | 15 | 1 | 109 | 124 | ~1,000 | pre-plan, post-apply |
| **luke** | Exp-II | 15 | 1 | 107 | 122 | ~1,000 | pre-plan, post-apply |
| **reed** | Exp-III | 15 | 1 | 106 | 121 | ~970 | pre-plan, post-apply |
| **seth** | Exp-I | 15 | 1 | 106 | 121 | ~970 | pre-plan, post-apply |
| **gabe** | Exp-I | 15 | 1 | 101 | 116 | ~930 | pre-plan, post-apply |
| **vera** | Exp-III | 15 | 1 | 99 | 114 | ~910 | pre-plan, post-apply |
| **pete** | Exp-I | 15 | 1 | 96 | 111 | ~890 | pre-plan, post-apply |
| **omar** | Exp-III | 15 | 1 | 95 | 110 | ~880 | pre-plan, post-apply |

### Cost Distribution
- **Core enforcement (todd + walt):** 1,014 lines (28.3%) — justified, these are the backbone
- **Original modules (dean, iris, skip, dave, ruby, docs):** 1,241 lines (34.7%)
- **Expansion I (arch, seth, pete, gabe):** 600 lines (16.8%)
- **Expansion II (luke, aria, dana):** 381 lines (10.6%)
- **Expansion III (omar, reed, vera):** 345 lines (9.6%)

### Cost Per Hook Dispatch (what actually loads per lifecycle point)

Not all modules load at every hook. Worst-case per hook point:

| Hook Point | Modules | Est. Lines Loaded |
|------------|---------|-------------------|
| pre-plan | 14 modules (all except walt, skip) + refs | ~1,400 |
| post-plan | 1 module (todd only) | ~91 |
| pre-apply | 2 modules (todd, walt) | ~250 |
| post-task | 1 module (todd only) | ~98 |
| post-apply | 15 modules (all except ruby, skip) + refs | ~1,800 |
| post-unify | 3 modules (walt, skip, ruby) | ~400 |

**Key insight:** pre-plan and post-apply are the heavy dispatch points. 14-15 modules resolve at those hooks.

---

## 2. Overlap Matrix

### Shared Check Patterns

| Pattern | Modules | Verdict |
|---------|---------|---------|
| **wc -l (file size)** | arch, iris, luke, pete, ruby — **5 modules** | ⚠️ Excessive. Each checks for different thresholds (ARCH: 500, IRIS: 300, LUKE: 200/500, PETE: 500, RUBY: 300/500) but the check itself is identical. **Deduplicate:** One module (ARCH?) runs wc -l and shares results. Others reference the finding. |
| **hardcoded secrets** | iris (post-apply), seth (pre-plan & post-apply) | ⚠️ Redundant. SETH is the dedicated security module with deeper secret patterns (AKIA, private keys, API keys). IRIS's secret check is a subset. **Remove from IRIS** — SETH owns this. |
| **eval/exec** | iris (pre-plan), seth (post-apply) | ⚠️ Redundant. SETH checks eval/exec as a security concern with injection context. IRIS checks it as a code smell. **Remove from IRIS** — SETH's security framing is more actionable. |
| **ESLint invocation** | iris (post-apply), ruby (post-unify) | ✅ Acceptable. They share the ESLint run but split results by concern: IRIS takes code smells + security, RUBY takes complexity metrics. modules.yaml already documents this sharing. |
| **empty catch blocks** | luke (post-apply), omar (post-apply), reed (pre-plan) | ⚠️ 3 modules check the same thing. OMAR (observability) and REED (resilience) both care about error handling. LUKE checking UI catch blocks is tangential. **Keep in OMAR + REED** (different concerns), **remove from LUKE** (not a UX issue). |
| **N+1 queries** | dana (post-apply), pete (pre-plan) | ✅ Acceptable overlap. DANA checks from a data integrity perspective (schema/migration context). PETE checks from a performance perspective. Different concerns, different advice. |
| **secrets in logs** | omar (post-apply), seth (pre-plan), vera (post-apply) | ⚠️ 3 modules flag the same log-leaking pattern. VERA focuses on PII in logs, SETH on secrets in logs, OMAR on general console.log hygiene. **Consolidate:** SETH + VERA each keep their specific patterns. OMAR drops overlapping log-secrets check. |
| **input validation** | gabe (post-apply), seth (pre-plan) | ✅ Acceptable. GABE checks validation on API endpoints (contract concern). SETH checks validation as a security concern (injection prevention). Different framing, both useful. |

### Module Domain Overlap

| Domain | Modules | Assessment |
|--------|---------|------------|
| **UI files** | aria, luke | ✅ Clean split. ARIA = accessibility, LUKE = UX patterns. Both fire only on .tsx/.jsx/.vue/.svelte. No redundancy. |
| **API files** | gabe (primary), dean, docs, omar, ruby, seth, vera | GABE is the dedicated API module. Others check API files incidentally. No redundancy — each has a distinct concern. |
| **Data files** | dana (primary), gabe, pete, seth, vera | DANA is the dedicated data module. Others check schema/model files incidentally. Clean. |
| **CI/Deploy** | dave (primary) | DAVE is the only dedicated CI module. Others mention CI tangentially. Clean. |

---

## 3. pals.json Configuration Gap

### Current State
- **pals.json:** 8 modules (carl, todd, walt, dean, iris, skip, dave, ruby)
- **modules.yaml:** 18 installed modules (adds arch, aria, dana, docs, gabe, luke, omar, pete, reed, seth, vera)
- **Gap:** 11 modules are installed and dispatch but cannot be toggled on/off via pals.json

### Why This Matters
- Users cannot disable expansion modules they don't need (e.g., ARIA on a backend-only project)
- `pals.json` doesn't reflect reality — it shows 8 modules, but 18 actually fire
- `/paul:config` dashboard shows incomplete module roster

### Recommendation
Add all 18 modules to pals.json during Phase 149. Group by concern for readability:
```
Core: todd, walt, carl
Security: dean, seth
Code Quality: iris, ruby, arch
Testing: todd (already core)
Documentation: docs, skip
API: gabe
UI/UX: luke, aria
Data: dana
Infrastructure: dave, omar, reed
Privacy: vera
Performance: pete
```

Enable all by default. Users disable per-project (e.g., disable aria, luke, dana for CLI tool projects).

---

## 4. Effectiveness Grades

### Grading Criteria
- **Relevance** (A-D): How often does this concern apply across PALS projects?
- **Actionability** (A-D): When fired, does the output help the developer?
- **Distinctness** (A-D): How unique is this module's contribution vs others?

### Grade Table

| Module | Relevance | Actionability | Distinctness | Overall | Recommendation |
|--------|-----------|---------------|--------------|---------|----------------|
| **todd** | A | A | A | **A** | KEEP — core TDD enforcement, 5 hooks, proven across E2E |
| **walt** | A | A | A | **A** | KEEP — core quality gate, proven regression catcher |
| **dean** | A | A | A | **A** | KEEP — every project has deps, baseline mechanism works well |
| **seth** | A | A | A | **A** | KEEP — security is universal; dedicated secret/injection scanner |
| **iris** | B | B | C | **B-** | TRIM — overlap with SETH (secrets, eval) and wc -l (5 modules). Remove overlapping checks, keep code smell focus. |
| **docs** | B | B | A | **B+** | KEEP — unique doc-drift detection, no overlap |
| **skip** | B | B | A | **B+** | KEEP — unique knowledge capture, no overlap |
| **arch** | B | B | B | **B** | TRIM — wc -l overlaps with 4 others. Architecture pattern detection is unique and useful. Trim reference files. |
| **ruby** | B | B | B | **B** | TRIM — ESLint shared with IRIS is fine, but wc -l overlaps. Trim pre-plan to not repeat file-size checks. |
| **dave** | B | B | A | **B** | KEEP — unique CI/deploy focus, no overlap |
| **gabe** | C | B | A | **B-** | KEEP — unique API contract focus, but only relevant for API projects. Context cost is low (116 lines). |
| **luke** | C | B | B | **B-** | TRIM — empty catch check overlaps OMAR/REED, wc -l overlaps. UI pattern detection is unique. Remove overlapping checks. |
| **aria** | C | B | A | **B** | KEEP — unique accessibility focus, clean domain. Only fires on UI files (self-selecting). |
| **dana** | C | B | A | **B** | KEEP — unique data/migration safety. N+1 overlap with PETE is acceptable (different framing). |
| **pete** | C | B | B | **B-** | KEEP — unique performance focus. N+1 overlap with DANA acceptable. wc -l should reference ARCH. |
| **omar** | C | B | C | **C+** | TRIM — secrets-in-logs overlaps SETH/VERA, empty-catch overlaps REED. Console.log detection is unique but low value. Reduce to console.log + structured logger check only. |
| **reed** | C | B | B | **B-** | KEEP — unique resilience focus (timeouts, retries, shutdown). Empty-catch overlap with OMAR is acceptable (different concern). |
| **vera** | C | B | B | **B-** | KEEP — unique privacy/PII focus. Secrets-in-logs overlap with OMAR/SETH is the PII-specific variant (emails, phones, SSNs). |

### Grade Distribution
| Grade | Count | Modules |
|-------|-------|---------|
| A | 4 | todd, walt, dean, seth |
| B+ | 2 | docs, skip |
| B | 4 | arch, ruby, dave, aria |
| B- | 5 | iris, gabe, luke, pete, reed |
| C+ | 1 | omar |
| D | 0 | — |

**No modules warrant cutting.** All serve a distinct primary purpose. The issue is duplication of secondary checks, not module-level redundancy.

---

## 5. Recommendations

### Priority Action List for Phase 149

#### P1: Fix pals.json Gap (high impact, low risk)
Add all 18 modules to pals.json with enable/disable. Group by concern. All enabled by default.
**Estimated impact:** Users can finally disable irrelevant modules (e.g., ARIA/LUKE on backend projects).

#### P2: Deduplicate wc -l File Size Checks (5 modules → 1 primary)
Currently: ARCH, IRIS, LUKE, PETE, RUBY all run `wc -l` independently.
**Fix:** ARCH runs wc -l as the primary file-size checker (it already has the richest threshold model). Other modules reference ARCH's finding or skip if ARCH already flagged.
**Estimated savings:** ~20 lines of duplicated description across 4 modules.

#### P3: Remove Security Checks from IRIS (SETH owns security)
Currently: IRIS checks hardcoded secrets and eval/exec — same patterns SETH checks with more context.
**Fix:** Remove secret/eval grep from IRIS hook descriptions. IRIS focuses purely on code smells (TODO/FIXME, complexity, unused vars).
**Estimated savings:** ~15 lines of description in IRIS + clearer separation.

#### P4: Clean Up Log-Secrets Overlap (3 modules → 2)
Currently: OMAR, SETH, VERA all check for sensitive data in logs.
**Fix:** SETH checks for secrets (tokens, API keys, passwords). VERA checks for PII (emails, SSNs, phones). OMAR drops secrets-in-logs and focuses on console.log hygiene + structured logger detection.
**Estimated savings:** ~10 lines of description in OMAR.

#### P5: Remove Empty-Catch from LUKE (not a UX concern)
Currently: LUKE checks empty catch blocks alongside OMAR and REED.
**Fix:** Remove empty-catch grep from LUKE post-apply. LUKE focuses on UI-specific checks (size, design tokens, inline styles, loading states).
**Estimated savings:** ~5 lines of description in LUKE.

#### P6: Trim Heavyweight Reference Files
Top 5 costliest reference files:
| File | Lines | Module(s) |
|------|-------|-----------|
| vulnerability-audit.md | 163 | dean |
| pipeline-generation.md | 150 | dave |
| tdd-detection.md | 139 | todd |
| quality-detection.md | 133 | walt |
| knowledge-capture.md | 123 | skip |

Review each for trimming. Phase 28 budget was 150 lines per ref file — all within budget but some may have grown stale.

#### P7: Consider Domain-Selective Loading
For projects that are purely backend (no UI), modules like ARIA and LUKE always return "No UI files — skipping." This is harmless (costs only their ~15 YAML description lines) but adds dispatch noise.
**Option:** Add a `domains` field to pals.json (e.g., `["api", "ui", "data", "cli"]`) and skip modules whose domain doesn't match. Low priority — the skip cost is minimal.

---

## 6. Summary Statistics

| Metric | Current | After P1-P6 (Est.) |
|--------|---------|---------------------|
| Modules in pals.json | 8 | 18 |
| Overlapping checks | 8 patterns, 13 modules | 2 patterns, 4 modules (N+1, ESLint — acceptable) |
| Total context lines | 3,581 | ~3,500 (modest reduction — overlap is in descriptions, not ref files) |
| Modules graded A | 4 | 4 |
| Modules recommended TRIM | 5 (iris, arch, ruby, luke, omar) | 0 (after fixes) |
| Modules recommended CUT | 0 | 0 |
| Modules recommended MERGE | 0 | 0 |

### Key Finding
The 18-module roster is **not bloated** — every module has a distinct primary domain. The problem is **secondary check duplication**: 5 modules checking file size, 3 modules checking secrets in logs, 3 checking empty catches. Fixing the overlaps is a description-editing exercise, not a structural change.

---

*Generated: 2026-03-26 — Phase 148 Module Health Audit*
