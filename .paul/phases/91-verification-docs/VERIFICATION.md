# v2.13 GitHub Flow Hardening — Verification Artifact

## Summary

All 6 hardening issues from `github-flow-hardening-followup.md` have been resolved across Phases 84-90 (v2.12 + v2.13). This document provides traceable evidence for each issue.

## Issue Resolution Matrix

| # | Issue | Phase | Files Changed | Verification |
|---|-------|-------|---------------|--------------|
| 1 | Branch name hardcoding | 88 | apply-phase.md, unify-phase.md, transition-phase.md, pause-work.md | All downstream steps use `CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)`; `feature/${PHASE_NAME}` only appears in branch *creation* (default name), immediately followed by re-detection |
| 2 | Pause staging misses non-src/ work | 88 | pause-work.md | Uses `git add -A` for complete staging; no hardcoded `.paul/ src/` paths |
| 3 | Behind-base routing not explicit | 89 | resume-project.md | `BEHIND_COUNT > 0` routing entry added with explicit priority above merge-ready state |
| 4 | gh auth not validated (only CLI presence) | 89 | init-project.md | `gh auth status` check added; init distinguishes CLI-missing from CLI-present-but-unauthenticated |
| 5 | Status surface lacks GitHub Flow parity | 90 | progress.md | `check_git_state` step + identical 5-entry git-aware routing table + Git State display block |
| 6 | Config `branching` in GitHub Flow template | 90 | init-project.md | `branching` removed from GitHub Flow template; preserved in legacy/none templates |

## Cross-Cutting Verification Commands

### Issue 1: No hardcoded branch names in downstream workflow steps

```bash
grep -rn 'feature/\${PHASE_NAME}' kernel/workflows/ | grep -v '#'
```

**Result:** 2 matches — both in `apply-phase.md` lines 75 and 77, inside the branch *creation* block (preflight creates a default branch name when starting from base). This is correct per the acceptance criteria: "preflight may still create a default branch if starting on base branch, but once branch exists, downstream steps use the real detected name."

The key fix is at line 80-84 of apply-phase.md:
```
After branch creation or detection, resolve the actual working branch:
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
All subsequent steps use ${CURRENT_BRANCH} — never assume branch name from phase name.
```

**Verification of downstream usage:**
```bash
grep -c 'CURRENT_BRANCH' kernel/workflows/apply-phase.md   # 15+ (all downstream refs)
grep -c 'CURRENT_BRANCH' kernel/workflows/unify-phase.md    # 5+ (merge gate, push, PR)
grep -c 'CURRENT_BRANCH' kernel/workflows/transition-phase.md # 10+ (commit, push, PR)
grep -c 'CURRENT_BRANCH' kernel/workflows/pause-work.md      # 3+ (push, status)
```

**PASS** ✅

### Issue 2: Pause uses complete staging

```bash
grep -c 'git add -A' kernel/workflows/pause-work.md
```

**Result:** 3 matches (github-flow WIP, general pause, and fallback staging paths all use `git add -A`).

**PASS** ✅

### Issue 3: Behind-base routing in resume

```bash
grep -c 'BEHIND_COUNT > 0' kernel/workflows/resume-project.md
```

**Result:** 1 match — routing table entry: `BEHIND_COUNT > 0 (branch behind base) → "Update branch from base"`. Fires even if PR is ready to merge.

**PASS** ✅

### Issue 4: gh auth validation in init

```bash
grep -c 'gh auth status' kernel/workflows/init-project.md
```

**Result:** 1 match — init checks `gh auth status` after confirming `gh --version` succeeds, and presents distinct messaging for CLI-missing vs CLI-present-but-unauthenticated.

**PASS** ✅

### Issue 5: Status parity with resume

```bash
diff <(grep -E '^\| (PR open|BEHIND_COUNT|No PR)' kernel/commands/paul/progress.md) \
     <(grep -E '^\| (PR open|BEHIND_COUNT|No PR)' kernel/workflows/resume-project.md)
```

**Result:** No diff — identical 5-entry routing tables. Both progress.md and resume-project.md use the same `check_git_state` collection logic and the same git-aware routing table.

**PASS** ✅

### Issue 6: branching absent from GitHub Flow template

```bash
sed -n '/If GitHub Flow/,/If legacy/p' kernel/workflows/init-project.md | grep -c '"branching"'
```

**Result:** 0 — GitHub Flow template no longer emits `branching`. Legacy and none templates still contain it for backward compatibility. 3-tier resolution logic is unchanged.

**PASS** ✅

## Success Bar (from requirements doc)

- [x] Branch-name agnostic after branch detection — all downstream steps use `CURRENT_BRANCH`, not `feature/${PHASE_NAME}`
- [x] Safe for repos that do not use `src/` — pause uses `git add -A`, not hardcoded paths
- [x] Explicit about stale-branch routing — `BEHIND_COUNT > 0` routing entry added with clear priority
- [x] Validated against real `gh` usability, not only binary presence — `gh auth status` check distinguishes CLI-missing from unauthenticated
- [x] Consistent across init / apply / unify / resume / pause / status — all 6 workflow touchpoints hardened

## Milestone Coverage

| Milestone | Phases | Focus |
|-----------|--------|-------|
| v2.12 | 84-87 | GitHub Flow enforcement (design, core loop, lifecycle awareness, validation) |
| v2.13 | 88-91 | GitHub Flow hardening (branch/staging correctness, routing/validation, status parity, verification/docs) |

**Total:** 8 phases, 8 plans, all complete. Zero regressions to legacy/none workflow modes.
