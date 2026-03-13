<fix_types>

## Purpose

Classification guide for the 3 fix modes available via `/paul:fix`. Helps users and modules determine which mode fits their situation.

## Fix Modes

### Standard Fix (compressed loop)

**When to use:** Multi-file bugs or changes needing some structure, but not full PLAN ceremony.

**What happens:**
1. Lightweight FIX.md created (objective + tasks + verify — no AC/boundaries/checkpoints)
2. Auto-approved and executed immediately (no separate `/paul:apply` step)
3. Post-apply hooks dispatch (WALT quality gate still fires)
4. Compressed SUMMARY auto-generated on completion
5. Post-unify hooks dispatch (quality history updated)
6. STATE.md accumulated context updated

**What's tracked:** FIX.md, FIX-SUMMARY.md, hook results, STATE.md entry
**Hooks fired:** post-apply, post-unify

---

### Fast-Forward

**When to use:** Trivial 1-file, obvious changes. Typos, config tweaks, single-line fixes.

**What happens:**
1. User confirms description (one prompt)
2. Fix executed directly (no plan file)
3. Git commit: `fix(ff): [description]`
4. One-line entry added to STATE.md accumulated context
5. Return to normal work

**What's tracked:** Git commit, one-line STATE.md entry
**Hooks fired:** None (zero overhead by design)

Inspired by OpenSpec's `/opsx:ff` command — even structured-workflow advocates need escape hatches for trivial changes.

---

### Hotfix (execute first, document later)

**When to use:** Urgent fixes where you act first, document after. Also for retroactive documentation of changes already made.

**What happens:**
1. If uncommitted changes exist: show diff, ask user to describe what was fixed
2. If no changes yet: user executes the fix, then proceeds
3. Git commit: `hotfix: [description]`
4. STATE.md flagged: `Pending retroactive UNIFY`
5. Next `/paul:unify` detects flag and generates SUMMARY from git log + description
6. Post-unify hooks fire normally

**What's tracked:** Git commit, retroactive SUMMARY, hook results, STATE.md entry
**Hooks fired:** post-unify (retroactive)

---

## Decision Matrix

| Criteria | Standard | Fast-Forward | Hotfix |
|----------|----------|--------------|--------|
| Files changed | 2+ | 1 | Any |
| Urgency | Normal | Low | High |
| Complexity | Moderate | Trivial | Any |
| Plan created? | Lightweight FIX.md | No | No (retroactive SUMMARY) |
| Hooks fire? | post-apply, post-unify | None | post-unify only |
| Tracked in STATE? | Yes (full entry) | Yes (one-line) | Yes (full entry) |
| SUMMARY created? | Yes (auto) | No | Yes (retroactive via UNIFY) |

## Auto-Classification Heuristics

The `/paul:fix` command recommends a mode based on:

| Signal | Recommendation |
|--------|----------------|
| Uncommitted changes detected | Hotfix |
| User mentions "urgent", "prod", "breaking" | Hotfix |
| User mentions 1 file or "typo", "config", "tweak" | Fast-forward |
| User describes multi-file issue | Standard |
| Default (no strong signals) | Standard |

User always has final say — recommendation is a suggestion, not enforcement.

## Relationship to /paul:plan-fix

`/paul:fix` and `/paul:plan-fix` serve different purposes:

| | /paul:fix | /paul:plan-fix |
|---|-----------|---------------|
| **Entry point** | Direct (user has a bug) | After `/paul:verify` finds UAT issues |
| **Source** | User description | UAT.md file |
| **Modes** | 3 (standard/ff/hotfix) | 1 (structured FIX.md) |
| **Scope** | Ad-hoc fixes | Systematic issue resolution |
| **Use when** | Bug found during development | After formal testing |

Both coexist — `/paul:fix` for ad-hoc, `/paul:plan-fix` for systematic.

</fix_types>
