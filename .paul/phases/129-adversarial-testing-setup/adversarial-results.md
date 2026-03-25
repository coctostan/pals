# Adversarial Testing Results — Phase 129

**Date:** 2026-03-25
**Target project:** pi-verify (v1.0, 9 source files, 6 test files)
**Adversarial payload:** Module-bait code (security holes, no tests, complex functions, API endpoints, console.logs, hardcoded values)

---

## Level 1 — PAUL Workflow Compliance

| Criteria | Kimi (kimi-for-coding K2.5) | Sonnet (sonnet-4-6) |
|----------|---------------------------|---------------------|
| Read SKILL.md | ✅ Yes | ✅ Yes |
| Read modules.yaml | ✅ Yes (301 lines) | ✅ Yes |
| Create proper PLAN.md (frontmatter, objective, AC, tasks) | ✅ Yes — well-structured | ✅ Yes — well-structured |
| Execute APPLY (files created, verify steps run) | ✅ Yes — 4 tasks completed | ✅ Yes — 3 tasks completed |
| Write SUMMARY.md | ✅ Yes — detailed | ✅ Yes — very detailed |
| Update STATE.md at transitions | ✅ Yes (had one edit error, recovered) | ✅ Yes |
| Complete MILESTONE workflow | ✅ Completed v1.0, created v1.1 | ✅ Completed v1.0, created v1.1 |
| **GitHub Flow: Create feature branch** | ❌ **Stayed on main** | ✅ `feature/14-module-bait-implementation` |
| **GitHub Flow: Push + Create PR** | ❌ No | ✅ PR #10 created |
| **GitHub Flow: Merge gate** | ❌ N/A | ✅ Merged after UNIFY |
| Review menu offered | ✅ Yes (4 options) | ✅ Yes (4 options) |
| MILESTONE-CONTEXT.md consumed | ✅ Yes — parsed correctly | ✅ Yes — parsed correctly |
| pals.json migration | ❌ Did not run | ✅ Migrated to v2.0.0 (10 new modules) |
| Git commit during workflow | ❌ No commits | ✅ Multiple commits at transitions |

**Level 1 Score:** Kimi 10/14 | Sonnet 14/14

---

## Level 2 — Module Dispatch

| Hook Point | Kimi | Sonnet |
|-----------|------|--------|
| **pre-plan advisory** | ✅ 11 [dispatch] markers in PLAN.md | ✅ Logged with real tool output |
| **pre-plan enforcement (DEAN)** | Documented but no `pnpm audit` run | ✅ **Ran `pnpm audit --json`, parsed JSON, BLOCKED on 2 criticals** |
| **post-plan (TODD)** | Not evident in artifacts | ✅ TODD suggested TDD type, correctly overridden |
| **pre-apply (TODD/WALT baselines)** | Not evident | ✅ WALT baseline recorded (67/67 tests) |
| **post-task (TODD)** | Not evident | ✅ Ran `pnpm test` after each task |
| **post-apply advisory** (IRIS, DOCS, RUBY, SKIP, + newer modules) | ❌ Listed as "Expected" — never executed | ✅ **All 11 advisory modules fired with file:line output** |
| **post-apply enforcement** (WALT, DEAN, TODD) | ❌ Listed as "Pending" — never executed | ✅ **WALT: 67/67, lint ✓, typecheck ✓. DEAN: Δ=0. TODD: gap flagged** |
| **post-unify** (WALT, SKIP, RUBY) | Not evident | ✅ **WALT appended quality-history.md. SKIP captured decisions. RUBY ran debt check** |

**Key difference:** Kimi **documented what modules should do** but didn't actually run them. The dispatch markers in its PLAN.md are theoretical — they describe expected behavior, not actual execution. Sonnet **ran actual shell commands** (pnpm audit, pnpm test, grep for patterns) and produced real findings with file:line references.

**Level 2 Score:** Kimi 1/8 (pre-plan markers only) | Sonnet 8/8

---

## Level 3 — Module Output Quality

| Module | Kimi Output | Sonnet Output |
|--------|------------|---------------|
| **DEAN** | "baseline recorded" (theoretical) | **`pnpm audit --json` → 2 critical CVEs (basic-ftp, fast-xml-parser), BLOCKED plan, delta comparison post-apply Δ=0** |
| **TODD** | "skip (no tests planned)" | **Detected node:test framework, suggested TDD, flagged coverage gap for new files post-apply** |
| **WALT** | Not executed | **Pre-apply baseline 67/67 → post-apply 67/67 + lint ✓ + typecheck ✓ + format ✓ → post-unify quality-history.md entry** |
| **SETH** | "hardcoded secrets expected" | Pre-plan: 0 (new files, no content). Post-apply: findings merged into IRIS output |
| **IRIS** | "eval, magic numbers expected" | **`eval()` at admin-api.ts:22, hardcoded secrets at :10-12, console.log(req) at :33** |
| **OMAR** | "console.log secrets expected" | **BLOCK: console.log("Login attempt:", req) at :33 — password field in log** |
| **GABE** | "no validation expected" | **WARN: /admin/execute — no input validation (no Zod/Joi)** |
| **LUKE** | "UI bait planned" | **WARN: 16 inline style attributes, 13 hardcoded hex colors in dashboard.ts** |
| **ARIA** | "a11y violations expected" | **BLOCK: <img> at :41 without alt; BLOCK: <input> at :48 without label** |
| **PETE** | "N+1 patterns expected" | **WARN: for...await N+1 at db-helpers.ts:40** |
| **DANA** | "query patterns expected" | **WARN: N+1 at db-helpers.ts:40, findAll without limit at :51** |
| **REED** | "no timeouts expected" | **WARN: fetch(url) at db-helpers.ts:64 — no timeout/AbortController** |
| **DOCS** | Not executed | **README.md: NOT UPDATED — DRIFT** |
| **RUBY** | Not executed | **Post-unify: all files <300 lines, no critical debt** |
| **SKIP** | Not executed | **Decision captured: DEAN block override** |
| **DAVE** | Not executed | **.github/workflows/ detected, no CI files in scope — skip (correct)** |
| **ARCH** | Not executed | Not evident (may have been subsumed by other modules) |

**Level 3 Score:** Kimi 0/16 (all theoretical) | Sonnet 15/16

---

## Summary Comparison

| Dimension | Kimi K2.5 | Sonnet 4.6 |
|-----------|-----------|------------|
| **L1: PAUL Workflow** | 71% (10/14) — Good structure, missed GitHub Flow + migration | **100% (14/14)** — Full compliance including GitHub Flow |
| **L2: Module Dispatch** | 12% (1/8) — Pre-plan markers only, all post-apply theoretical | **100% (8/8)** — Every hook point fired with real output |
| **L3: Module Quality** | 0% (0/16) — All "expected" descriptions, zero actual execution | **94% (15/16)** — Real findings with file:line evidence |
| **GitHub Flow** | ❌ Missed entirely | ✅ Full lifecycle (branch → push → PR → merge) |
| **Real tool execution** | ❌ No `pnpm audit`, no `pnpm test`, no `grep` for patterns | ✅ pnpm audit, pnpm test, grep, pnpm lint, pnpm format |

---

## Key Findings

1. **Kimi understands PALS workflow structure** but treats module dispatch as documentation, not execution. It correctly describes what each module SHOULD do but doesn't actually run the commands.

2. **Sonnet treats module descriptions as executable instructions.** When modules.yaml says "run pnpm audit --json", sonnet runs `pnpm audit --json`. When it says "grep for patterns", sonnet runs grep. This is the fundamental difference.

3. **GitHub Flow is model-dependent.** Kimi ignored the github-flow config entirely. Sonnet created branches, pushed, created PRs, and ran merge gates.

4. **pals.json migration is model-dependent.** Sonnet detected the schema_version mismatch and migrated. Kimi did not.

5. **Both models handle the PAUL lifecycle (PLAN→APPLY→UNIFY) competently.** The workflow structure is followed by both. The gap is in the depth of execution.

6. **DEAN blocking is a real differentiator.** Sonnet's DEAN actually blocked plan creation with CVE details. This is the kind of value that makes modules worth having.

---

## Evidence References

- Kimi PLAN: `kimi-evidence/14-01-PLAN.md`
- Kimi SUMMARY: `kimi-evidence/14-01-SUMMARY.md`
- Sonnet PLAN: `sonnet-evidence/14-01-PLAN.md`
- Sonnet SUMMARY: `sonnet-evidence/14-01-SUMMARY.md`
- Sonnet quality-history: `sonnet-evidence/quality-history.md`

---

*Analysis completed: 2026-03-25*
