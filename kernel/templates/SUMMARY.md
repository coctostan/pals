# SUMMARY.md Template

Template for `.paul/phases/{phase-number}-{name}/{phase}-{plan}-SUMMARY.md` — plan completion documentation.

**Purpose:** Document what was built, decisions made, deviations from plan, and readiness for next phase.

---

## File Template

```markdown
---
phase: XX-name                    # Phase identifier matching ROADMAP.md (e.g., "29-module-observability")
plan: NN                          # Plan number within phase (e.g., "01", "02")
subsystem: name                   # Primary category affected (auth, payments, ui, api, database, infra, testing, kernel, modules)
tags: []                          # Searchable keywords for knowledge retrieval (tech names, concepts, module names)

# Dependency graph — tracks what this plan consumed and produces
requires:                         # Plans whose output this plan used as input (not just "came before")
  - phase: [prior phase ID]       #   Only list genuine data dependencies
    provides: [specific artifact]  #   What from that phase was consumed
provides:                         # Capabilities/artifacts this plan creates for downstream use
  - [deliverable 1]               #   Be specific: "per-hook ref mapping in module.yaml" not "updates"
  - [deliverable 2]
affects:                          # Phase names or subsystems that will need this context in future plans
  - [phase or subsystem name]

# Tech tracking — what was added or established
tech-stack:
  added: []                       # Libraries, tools, or frameworks introduced (empty if none)
  patterns: []                    # Architectural patterns established (e.g., "per-hook ref loading")

key-files:
  created: []                     # Most important files created (not all files — just the key ones)
  modified: []                    # Most important files modified

key-decisions:                    # Quick-reference decisions (full detail in Decisions Made section)
  - "Decision: [brief summary]"

patterns-established:             # Conventions future plans should follow (feeds into project knowledge)
  - "Pattern: [description]"      #   e.g., "Every hook entry must include refs array"

# Metrics — populated at completion
duration: Xmin                    # Wall-clock time from apply start to completion
started: YYYY-MM-DDTHH:MM:SSZ    # ISO timestamp when apply began
completed: YYYY-MM-DDTHH:MM:SSZ  # ISO timestamp when apply finished
---

# Phase [X] Plan [Y]: [Name] Summary

**[Substantive one-liner describing outcome - what actually shipped]**

## Performance

| Metric | Value |
|--------|-------|
| Duration | [time] |
| Started | [ISO timestamp] |
| Completed | [ISO timestamp] |
| Tasks | [N] completed |
| Files modified | [N] |

## Acceptance Criteria Results

| Criterion | Status | Notes |
|-----------|--------|-------|
| AC-1: [Name] | Pass / Fail | [Details if needed] |
| AC-2: [Name] | Pass / Fail | [Details] |
| AC-3: [Name] | Pass / Fail | [Details] |

## Module Execution Reports
<!-- Finalized during UNIFY from one durable reporting path: -->
<!-- 1. carried-forward post-apply annotations -->
<!-- 2. any pre-unify context that materially informed reconciliation -->
<!-- 3. post-unify module_reports and recorded side_effects returned before loop close -->
<!-- Each contributing module gets its own persisted subsection here. -->
<!-- REQUIRED. If no module evidence survives finalization, this section MUST still be present. -->
<!-- State WHY no modules fired: registry not loaded, no hooks registered for this phase, or modules read but produced no output. -->
<!-- Do NOT omit this section. -->

<!-- Example subsection (from a test enforcement module):
### Test Execution
| Phase | Commit | Status |
|-------|--------|--------|
| RED | `{hash}` | ✓ Tests fail as expected |
| GREEN | `{hash}` | ✓ All tests pass |
| REFACTOR | `{hash}` / skipped | ✓ Tests still pass / N/A |
-->

<!-- Example subsection (from a quality gating module):
### Quality
| Metric | Before | After | Delta | Trajectory |
|--------|--------|-------|-------|------------|
| Tests passing | [N] | [N] | [+/-N] | [▲/●/▼] |
| Coverage | [N]% | [N]% | [+/-N]% | [▲/●/▼] |
| Lint issues | [N] | [N] | [+/-N] | [▲/●/▼] |
**Overall:** [▲ improved / ● stable / ▼ degraded / — not tracked]
-->

## Accomplishments

- [Most important outcome - specific, substantive]
- [Second key accomplishment]
- [Third if applicable]

## Task Commits

Each task committed atomically:

| Task | Commit | Type | Description |
|------|--------|------|-------------|
| Task 1: [name] | `abc123f` | feat | [What was done] |
| Task 2: [name] | `def456g` | feat | [What was done] |
| Task 3: [name] | `hij789k` | test | [What was done] |

Plan metadata: `lmn012o` (docs: complete plan)

## Files Created/Modified

| File | Change | Purpose |
|------|--------|---------|
| `path/to/file.ts` | Created | [What it does] |
| `path/to/another.ts` | Modified | [What changed] |

## Decisions Made

[Key decisions with brief rationale]

| Decision | Rationale | Impact |
|----------|-----------|--------|
| [What was decided] | [Why] | [Effect on future work] |

Or: "None - followed plan as specified"

## Deviations from Plan

### Summary

| Type | Count | Impact |
|------|-------|--------|
| Auto-fixed | [N] | [Brief assessment] |
| Scope additions | [N] | [Brief assessment] |
| Deferred | [N] | Logged to issues |

**Total impact:** [Brief assessment - e.g., "Essential fixes, no scope creep"]

### Auto-fixed Issues

**1. [Category] [Brief description]**
- **Found during:** Task [N] ([task name])
- **Issue:** [What was wrong]
- **Fix:** [What was done]
- **Files:** [Affected files]
- **Verification:** [How verified]
- **Commit:** [hash] (part of task commit)

[Repeat for each auto-fix]

### Deferred Items

Logged to issue tracker for future consideration:
- [Issue ID]: [Brief description] (discovered in Task [N])

Or: "None - plan executed exactly as written"

## Issues Encountered

[Problems during execution and how resolved]

| Issue | Resolution |
|-------|------------|
| [Problem] | [How solved] |

Or: "None"

## Next Phase Readiness

**Ready:**
- [What's ready for next phase]
- [Foundation established]

**Concerns:**
- [Potential issues for future phases]
- [Technical debt introduced]

**Blockers:**
- [Anything blocking next phase] or "None"

---
*Phase: XX-name, Plan: NN*
*Completed: [YYYY-MM-DD]*
```

---

## Section Specifications

### Frontmatter
**Purpose:** Machine-readable metadata for automatic context assembly.

| Field | Purpose |
|-------|---------|
| `phase`, `plan` | Identification |
| `subsystem` | Primary categorization (auth, api, ui, etc.) |
| `tags` | Searchable tech keywords |
| `requires` | What prior phases this depended on |
| `provides` | What this plan delivers |
| `affects` | Future phases that need this context |
| `tech-stack` | Libraries added, patterns established |
| `key-files` | Important files for context references |
| `key-decisions` | Quick-reference decisions (detail in body) |
| `patterns-established` | Conventions future phases should follow |
| `duration`, `started`, `completed` | Performance metrics |

### One-liner Requirements

**Must be substantive:**

| Good | Bad |
|------|-----|
| "JWT auth with refresh rotation using jose library" | "Phase complete" |
| "Prisma schema with User, Session, Product models" | "Authentication implemented" |
| "Dashboard with real-time metrics via SSE" | "All tasks done" |

The one-liner should tell someone what actually shipped.

### Acceptance Criteria Results
**Purpose:** Verify all AC from PLAN.md were met.
**Contains:** Each AC with pass/fail status and notes.
**Requirement:** All must pass for plan to be complete.

### Module Execution Reports
**Purpose:** Persist durable evidence of module contributions across APPLY and UNIFY.
**Contains:** Module-specific subsections with carried-forward annotations, reconciliation context, post-unify reports, and any recorded side effects worth preserving in the summary.
**When included:** ALWAYS. This section is REQUIRED. If no modules fired, state why (registry not loaded, no hooks registered, etc.).
**Update:** Drafted during UNIFY reconciliation and finalized after post-unify hooks, before the summary is closed.

### Deviations Section
**Purpose:** Document unplanned work and its handling.

**Auto-fixed:** Issues discovered and resolved during execution.
- Include: category, what was wrong, fix, verification
- Must be essential fixes, not scope creep

**Deferred:** Items logged for future consideration.
- Include: issue ID, brief description, origin task

**Note:** Separate from "Issues Encountered" which documents problems with planned work.

### Next Phase Readiness
**Purpose:** Prepare context for next PLAN phase.

**Ready:** What's available for next phase to build on.
**Concerns:** Potential issues to watch for.
**Blockers:** Anything preventing next phase (usually "None").
