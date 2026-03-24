# Module Improvement Action Items — Ranked by Impact

## Ranking Criteria
- **User value:** How much does this improvement help the developer?
- **Gap size:** How far is current behavior from the spec?
- **Effort:** How hard is the fix?
- **Risk:** Could the change break existing behavior?

---

## Tier 1: High Impact, Clear Gap

### AI-1: SKIP should produce structured knowledge entries, not just "decision found"
- **Module:** SKIP
- **Current:** Outputs "decision extracted" with no structure
- **Spec says:** knowledge-capture.md has 5 rich templates (Decision Record, Rationale Note, Trade-off Analysis, Constraint Documentation, Lesson Learned) with required fields (date, title, type, phase, content)
- **Fix:** Update SKIP's post-apply and post-unify hook descriptions and refs to explicitly instruct: "Format extracted decisions using the Decision Record template from knowledge-capture.md. Include: context, decision, alternatives considered, rationale, impact."
- **Effort:** Small — reference file + hook description wording
- **Impact:** Transforms SKIP from "detection" to "documentation" — the whole point of knowledge persistence

### AI-2: DAVE should validate CI config syntax, not just detect file existence
- **Module:** DAVE
- **Current:** Outputs "CI/CD config exists" or "CI config unchanged"
- **Spec says:** pipeline-generation.md has full templates for Node.js/Python/Go/Rust CI. deploy-verification.md has health checks, rollback criteria, canary deployment specs.
- **Fix:** Update DAVE's post-apply hook to: 1) Parse YAML syntax of .github/workflows/*.yml — `yq` or `node -e "require('yaml')"`. 2) Check for common CI mistakes (missing `runs-on`, no checkout step, etc.). 3) On pre-plan, if no CI exists, suggest generating one from templates.
- **Effort:** Medium — hook description changes + possibly a new validation ref
- **Impact:** Makes DAVE genuinely useful instead of a file-existence flag

### AI-3: IRIS should use real linting tools, not just grep
- **Module:** IRIS
- **Current:** Uses `grep -n` for pattern names, produces file:line but based on string matching
- **Spec says:** review-patterns.md has 25+ patterns across Code Smells, Security Concerns, Performance Anti-Patterns, Maintainability Issues
- **Fix:** Update IRIS's post-apply hook to: 1) Run `eslint --rule 'complexity: [warn, 10]'` for cyclomatic complexity. 2) Run `eslint-plugin-security` or `grep` for hardcoded secrets (current approach works here). 3) Check function length via AST tools or enhanced grep with line counting.
- **Effort:** Medium — the grep approach works for many patterns but ESLint integration would be much stronger
- **Impact:** Higher confidence results — real tool output vs string matching estimates

### AI-4: RUBY should use real complexity tools, not wc -l estimates
- **Module:** RUBY  
- **Current:** Uses `wc -l` for line counts, `grep -c` for parameter counts, "estimated" complexity
- **Spec says:** debt-detection.md has thresholds: cyclomatic 1-10 acceptable, 11-20 warning, >20 critical. Also: eslint `complexity` rule, `radon` for Python, `gocyclo` for Go.
- **Fix:** Update RUBY's hook to: 1) For TypeScript/JavaScript: run `eslint --rule 'complexity: [warn, 10]'` on changed files. 2) Parse output for actual cyclomatic complexity numbers. 3) Fall back to line counting only when no tool available.
- **Effort:** Medium — similar to IRIS fix, could share the eslint invocation
- **Impact:** Real numbers instead of estimates — "cyclomatic: 14" instead of "estimated 12+"

---

## Tier 2: Medium Impact, Solid Improvement

### AI-5: DOCS should check more than just README
- **Module:** DOCS
- **Current:** Checks if README.md was updated when code changes
- **Spec says:** doc-detection.md has "Standard Doc Patterns" including CHANGELOG, API docs, config docs, plus "Proximity Mapping" for nearby docs
- **Fix:** Expand doc catalog to include: CHANGELOG.md, docs/, API.md, CONTRIBUTING.md. Use proximity mapping: if src/verify.ts changes, check if docs/verify.md or nearby JSDoc was updated.
- **Effort:** Small — expand the grep patterns in hook description
- **Impact:** Catches more doc drift, especially in larger projects

### AI-6: DEAN should test blocking on critical vulnerabilities
- **Module:** DEAN
- **Current:** Runs real `pnpm audit`, compares baselines, found +4 new advisories — but never actually blocked
- **Spec says:** "block if new critical/high vulnerabilities introduced"
- **Fix:** Update DEAN's post-apply hook to explicitly: 1) Parse `pnpm audit --json` severity levels. 2) Block on `critical` or `high` severity. 3) Warn on `moderate`. 4) Ignore `low`.
- **Effort:** Small — hook description clarification
- **Impact:** Makes DEAN a real security gate, not just a counter

### AI-7: WALT should track quality history over time
- **Module:** WALT
- **Current:** Records quality delta in post-unify ("Δ0 tests, stable baseline")
- **Spec says:** quality-history.md defines a persistent quality ledger with trends, streaks, regression detection, and stall detection
- **Fix:** Update WALT's post-unify hook to append entries to `.paul/quality-history.md` with: date, phase, test counts, lint results, coverage (if available), trend direction.
- **Effort:** Small-medium — needs a persistent file and append logic
- **Impact:** Enables quality trend analysis across milestones

---

## Tier 3: Lower Impact, Nice to Have

### AI-8: TODD should suggest TDD plan restructuring more aggressively
- **Module:** TODD
- **Current:** Detects TDD candidates but says "plan type remains execute" — never restructures to RED-GREEN-REFACTOR
- **Spec says:** post-plan hook: "If plan type is tdd, restructure tasks into RED-GREEN-REFACTOR sequence with phase gates"
- **Fix:** Lower the threshold for suggesting TDD type. When test files exist covering planned changes, suggest: "This plan modifies tested code. Consider `type: tdd` for RED-GREEN-REFACTOR sequence."
- **Effort:** Small — hook description adjustment
- **Impact:** More TDD enforcement, but depends on model following suggestion

### AI-9: IRIS/RUBY should share a single ESLint invocation
- **Module:** IRIS + RUBY
- **Current:** Both do separate grep-based scanning
- **Fix:** Create a shared "quality scan" step that runs ESLint once with complexity + security + unused rules, then splits results to IRIS (patterns) and RUBY (debt metrics).
- **Effort:** Medium — needs reference file restructuring
- **Impact:** Efficiency — one tool run instead of two grep sessions

### AI-10: DAVE should offer CI generation for projects without it
- **Module:** DAVE
- **Current:** Only detects existing CI
- **Spec says:** pipeline-generation.md has full templates for Node/Python/Go/Rust
- **Fix:** On pre-plan, if no CI config exists: "No CI detected. Would you like DAVE to generate a GitHub Actions workflow?" Then inject the appropriate template from pipeline-generation.md.
- **Effort:** Medium — needs conditional logic in hook + template selection
- **Impact:** Great for new projects, less useful for existing ones

---

## Priority Ranking

| Rank | Item | Module | Effort | Impact | Rationale |
|------|------|--------|--------|--------|-----------|
| **1** | AI-1 | SKIP | Small | High | Biggest gap between spec and reality. Templates exist but aren't used. |
| **2** | AI-6 | DEAN | Small | High | Security blocking is critical. Small hook description change. |
| **3** | AI-2 | DAVE | Medium | High | Transforms from file-checker to actual CI validator. |
| **4** | AI-3 | IRIS | Medium | High | Real tools >> grep estimates for code review. |
| **5** | AI-4 | RUBY | Medium | High | Real complexity numbers >> wc -l estimates. |
| **6** | AI-5 | DOCS | Small | Medium | Quick win — expand doc patterns beyond README. |
| **7** | AI-7 | WALT | Small-Med | Medium | Quality trends are valuable long-term. |
| **8** | AI-8 | TODD | Small | Low | TODD already works well — this is optimization. |
| **9** | AI-9 | IRIS/RUBY | Medium | Medium | Efficiency improvement, not new capability. |
| **10** | AI-10 | DAVE | Medium | Medium | Useful but narrow audience (new projects only). |
