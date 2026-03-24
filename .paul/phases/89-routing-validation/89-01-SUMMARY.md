---
phase: 89-routing-validation
plan: 01
completed: 2026-03-23T21:25:00-0400
duration: ~5 minutes
---

## Objective
Add behind-base routing priority to resume's git-aware routing table and upgrade init's gh CLI validation from presence-only to authentication-aware.

## What Was Built

| File | Purpose | Change |
|------|---------|--------|
| kernel/workflows/resume-project.md | Behind-base routing priority | +3 lines: new routing table entry at position 2, explanatory note |
| kernel/workflows/init-project.md | Auth-aware gh validation | +18 lines: two-tier detection (version + auth status), two-tier warning messaging |

## Acceptance Criteria Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Behind-base routing is explicit and prioritized | ✅ PASS | `BEHIND_COUNT > 0` entry at line 143, before reviews/merge entries |
| AC-2 | Behind-base takes precedence over merge readiness | ✅ PASS | Position 2 in table (after CI failing, before reviews at 144 and merge at 145) |
| AC-3 | Init validates gh authentication, not just CLI presence | ✅ PASS | `gh auth status` check added after `gh --version`; `gh_authenticated` variable tracked |
| AC-4 | Init messaging is clear about auth failure | ✅ PASS | Distinct messages: "requires the `gh` CLI" vs "`gh` CLI is installed but not authenticated" |

## Verification Results

```
BEHIND_COUNT > 0 count in resume: 2 (table entry + note)
Update branch from base text: present
Behind-base line 143, ready-to-merge line 145: correct order ✓
gh auth status in init: 1 occurrence
gh_authenticated tracked: 5 occurrences (stored, checked in two-tier warning)
gh --version preserved: 1 (first-tier check intact)
Two distinct warning messages: ✓ (CLI missing vs not authenticated)
Only resume-project.md and init-project.md modified: ✓
```

## Deviations
None. Plan executed exactly as written.

## Next Phase
Phase 90 — Status Parity & Config Clarity
