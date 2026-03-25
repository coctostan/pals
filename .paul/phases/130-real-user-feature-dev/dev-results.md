# Real-User Development Results — Phase 130

**Date:** 2026-03-25
**Model:** openai-codex/gpt-5.4 (low thinking)
**Target:** pi-verify — 2 loops: cleanup (Phase 15) + feature dev (Phase 16)

---

## Loop 1: Adversarial Cleanup (Phase 15)

### L1 — Workflow Compliance
| Criteria | Result |
|----------|--------|
| Read SKILL.md | ✅ |
| Read modules.yaml | ✅ |
| Create proper PLAN.md | ✅ Well-structured with frontmatter, AC, tasks |
| Execute APPLY | ✅ Bait files removed, tests pass |
| Write SUMMARY.md | ✅ |
| Update STATE.md | ✅ |
| GitHub Flow: Feature branch | ✅ `feature/15-adversarial-cleanup` |
| GitHub Flow: Merge gate | ❌ Explicitly skipped ("I did not attempt the merge gate") |
| pals.json migration | Not observed (may have been done by sonnet in Phase 129) |
| Version alignment | ✅ Caught and resolved v1.0→v1.1 mismatch during milestone completion |

### L2 — Module Dispatch
| Hook | Fired? | Evidence |
|------|--------|----------|
| pre-plan advisory | ✅ | TODD, IRIS, DAVE, DOCS, RUBY all logged with context |
| pre-plan enforcement (DEAN) | ✅ | **Ran `pnpm audit --json`, BLOCKED on 2 criticals** |
| post-apply | Partial | DEAN baseline comparison logged |
| post-unify | Not evident in artifacts |

### L3 — Development Value
- DEAN correctly blocked and required override (consistent with sonnet behavior)
- TODD noted existing test coverage — no new tests needed for cleanup (correct)
- IRIS flagged bait files with anti-patterns (correct — they're being removed)
- Cleanup was straightforward — modules added overhead but confirmed clean state

---

## Loop 2: Feature Dev — /verify diff (Phase 16)

### L1 — Workflow Compliance
| Criteria | Result |
|----------|--------|
| Read SKILL.md | ✅ |
| Read modules.yaml | ✅ |
| Create proper PLAN.md | ✅ 3 tasks: types/commands, verify.ts impl, tests |
| Execute APPLY | ✅ with retry (hit TS error, debugged and fixed) |
| Write SUMMARY.md | ✅ |
| Update STATE.md | ✅ |
| GitHub Flow: Feature branch | ⚠️ Stayed on `feature/15-adversarial-cleanup` (didn't create new branch for Phase 16) |
| GitHub Flow: Merge gate | ❌ Skipped again |
| Tests added | ✅ 67→70 tests (3 new for diff feature) |

### L2 — Module Dispatch
| Hook | Fired? | Evidence |
|------|--------|----------|
| pre-plan advisory | ✅ | TODD suggested extending tests for diff, IRIS no blockers, DOCS noted README drift possible, RUBY suggested 2-3 tasks |
| pre-plan enforcement (DEAN) | ✅ | **Ran `pnpm audit --json`, BLOCKED, overridden** |
| post-apply (WALT) | ✅ | pnpm test + pnpm run check both green |
| post-apply (DEAN) | ✅ | Baseline unchanged: Δ=0 |
| post-unify | Not evident |

### L3 — Development Value
- **TODD was genuinely helpful:** "Phase 16 should extend tests for the new diff scope" — and GPT-5.4 did add 3 tests
- **DEAN was consistent** but noisy — same pre-existing vulns blocked every plan, requiring override each time
- **RUBY shaped the plan:** "scope is moderate and should stay to 2–3 tasks" — plan had exactly 3 tasks
- **Model self-corrected:** Hit a TS error during APPLY, debugged it, fixed it, got green
- **Real feature shipped:** /verify diff command works, tests pass

---

## GPT-5.4 vs Sonnet 4.6 vs Kimi K2.5

| Dimension | Kimi K2.5 | GPT-5.4 | Sonnet 4.6 |
|-----------|-----------|---------|------------|
| **L1: Workflow** | 71% | ~86% | 100% |
| **L2: Dispatch** | 12% | ~70% | 100% |
| **L3: Quality** | 0% | ~65% | 94% |
| **GitHub Flow** | ❌ Missed | ⚠️ Partial (branch yes, merge gate no) | ✅ Full |
| **DEAN execution** | Theoretical | ✅ Real `pnpm audit` | ✅ Real `pnpm audit` |
| **TODD value** | Theoretical | ✅ Shaped test coverage | ✅ Full TDD enforcement |
| **Post-apply hooks** | None | Partial (WALT/DEAN) | ✅ All 14 modules |
| **Post-unify hooks** | None | Not evident | ✅ WALT/SKIP/RUBY |
| **Self-correction** | N/A | ✅ Fixed TS error | N/A (no errors) |
| **Version awareness** | ❌ | ✅ Caught mismatch | ✅ Caught mismatch |

---

## Key Findings

1. **GPT-5.4 is a capable middle-tier PALS model.** It follows the workflow structure, executes real module dispatch (DEAN, TODD, WALT), and produces working code. It falls short on GitHub Flow merge gates and post-unify hooks.

2. **DEAN is consistently the most impactful module across all models.** Every model that actually runs `pnpm audit` gets value from it. The pre-existing vulnerability blocking is noisy but correct — a real user would want to know.

3. **TODD advisory during planning shaped GPT-5.4's test coverage.** The model added 3 tests specifically because TODD flagged the need during pre-plan. This is genuine development value.

4. **RUBY shaped plan scope.** "2-3 tasks with a focused change set" — the plan had exactly 3. Subtle but real planning influence.

5. **GitHub Flow merge gates remain the hardest workflow step.** Kimi skipped entirely, GPT-5.4 created branches but skipped gates, only Sonnet executed the full flow.

6. **Real development works through PALS.** GPT-5.4 built a genuinely useful feature (/verify diff), added tests, fixed a compile error, and shipped clean — all while following PALS structure. The workflow didn't hinder development.

---

## Evidence References

- Phase 15 PLAN: `gpt54-evidence/15-01-PLAN.md`
- Phase 15 SUMMARY: `gpt54-evidence/15-01-SUMMARY.md`
- Phase 16 PLAN: `gpt54-evidence/16-01-PLAN.md`
- Phase 16 SUMMARY: `gpt54-evidence/16-01-SUMMARY.md`
- pi-verify tests: 70/70 passing (was 67 before)
- Bait files: confirmed removed

---

*Analysis completed: 2026-03-25*
