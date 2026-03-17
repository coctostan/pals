# PALS Artifact Specification

## Preamble

This document is the **normative specification** for all `.paul/` artifact types produced and consumed by the PALS (Project Automation & Lifecycle System) kernel, modules, and workflows. Any harness adapter that drives a PALS project must produce artifacts conforming to these schemas and must correctly interpret artifacts produced by other compliant adapters.

The guiding principle:

> **Artifacts are authoritative; prompts are interpretive.**

The portable runtime is not a specific prompt transcript or harness UX. The portable runtime is the `.paul/` artifacts, the workflow definitions, the module manifests, and the lifecycle and hook contracts. Different harnesses drive the same project by reading and writing the same artifacts.

**Related documents:**
- [HARNESS-PORTABILITY.md](HARNESS-PORTABILITY.md) -- design rationale for portability
- [ADAPTER-CONTRACT.md](ADAPTER-CONTRACT.md) -- what a harness adapter must do
- [LIFECYCLE-SPEC.md](LIFECYCLE-SPEC.md) -- state machine governing transitions
- [HOOK-CONTRACT.md](HOOK-CONTRACT.md) -- hook dispatch semantics

---

## 1. STATE.md

### Purpose

The project's living memory -- single source of truth for current position, accumulated context, and session continuity. Every workflow reads STATE.md as its first step.

### Location

`.paul/STATE.md`

### Required Sections

| Section | Contents |
|---------|----------|
| **Project Reference** | Pointer to PROJECT.md, core value one-liner, current focus (milestone + phase) |
| **Current Position** | Milestone name, phase X of Y, plan A of B, status, last activity timestamp, progress bars |
| **Loop Position** | Visual PLAN-->APPLY-->UNIFY state diagram using markers: `○` (pending), `◉` (active), `✓` (complete) |
| **Accumulated Context** | Three tables: Decisions (decision, phase, impact), Deferred Issues (issue, origin, effort, revisit), Blockers/Concerns (blocker, impact, resolution path) |
| **Session Continuity** | Last session timestamp, stopped at, next action, resume context |

### Optional Sections

| Section | Contents |
|---------|----------|
| **Performance Metrics** | Velocity (total plans, average duration, total time), per-phase breakdown table, recent trend |
| **Boundaries (Active)** | Protected elements from current PLAN.md |
| **Git State** | Current branch, PR info |

### Frontmatter

None. STATE.md uses markdown headings, not YAML frontmatter.

### Status Values

The `Status` field in Current Position uses one of:

| Value | Meaning |
|-------|---------|
| Ready to plan | No active plan; ready for next planning cycle |
| Planning | plan-phase workflow in progress |
| Approved | Plan created, awaiting user approval to apply |
| Applying | apply-phase workflow executing |
| Unifying | unify-phase workflow in progress |
| Complete | Loop closed; ready for next plan or milestone transition |
| Blocked | Cannot proceed; blocker documented in Accumulated Context |

### Created By

`init-project` workflow.

### Read By

**Every workflow.** STATE.md is the first file read in every PALS workflow. It provides instant context restoration.

### Written By

Every workflow updates at least Session Continuity. Specific updates:
- `plan-phase`: status, loop position, current position
- `apply-phase`: status, loop position, performance metrics
- `unify-phase`: accumulated context (decisions, deferred issues), status
- `pause-work`: session continuity
- `resume-project`: session continuity, status
- `transition-phase`: current position
- `complete-milestone`: current position, milestone progress

### Size Constraint

Target under 100 lines. STATE.md is a digest, not an archive. If sections grow too large, keep only the 3-5 most recent decisions, reference the issue tracker instead of listing all issues, and summarize instead of detailing.

### Portability Note

STATE.md is the primary artifact an adapter uses to determine loop position and next action. An adapter that can read and correctly interpret STATE.md can bootstrap into any project at any point in its lifecycle.

---

## 2. PROJECT.md

### Purpose
Compact hot-path project brief -- the landing artifact many workflows read first. Defines what is being built, why it matters, the current scope snapshot, top constraints, and where to find deeper product-definition context.

### Location
`.paul/PROJECT.md`

### Required Sections

| Section | Contents |
|---------|----------|
| **Description / What This Is** | One paragraph describing the product or feature (what, not how) |
| **Core Value** | Single sentence: what problem does this solve for whom |
| **Current State** | Short version / status / current-system summary |
| **Scope Snapshot** | Concise scope buckets: Validated, Active, Planned, Out of Scope |
| **Constraints** | Highest-impact constraints that shape planning |
| **Success Metrics** | Measurable outcomes defining project success |
| **Key Decisions** | Table: durable, high-signal decisions |
| **Links** | Pointers to `PRD.md`, roadmap, codebase evidence, or other deeper artifacts |

### Optional Sections

| Section | Contents |
|---------|----------|
| **Target Users** | Summary-level primary/secondary users and needs |
| **Specialized Flows** | Reference to SPECIAL-FLOWS.md with quick-reference summary |

### Frontmatter
None.

### Created By
`init-project` workflow.

### Read By
Orientation and hot-path workflows first (`resume-project`, status/help-style routing, planning entry points), plus `plan-phase`, discussion workflows, and `apply-phase`.

### Written By
- `init-project`: initial creation with description, core value, scope snapshot, and links
- Milestone / planning workflows: update scope snapshot when durable scope changes
- `unify-phase`: updates Key Decisions and other concise durable summaries

### Portability Note
`PROJECT.md` is intentionally concise. Adapters must preserve its role as the hot-path landing brief and should not expand it into the full product-definition artifact. Detailed framing, deferred scope, assumptions, open questions, and dependency depth belong in `PRD.md`.

---

## 2A. PRD.md

### Purpose
Deeper, selectively-read product-definition artifact. Preserves richer problem framing, current-state vs desired-state context, detailed requirement buckets, deferred items, assumptions, open questions, dependencies, and supporting references.

### Location
`.paul/PRD.md`

### Required Sections

| Section | Contents |
|---------|----------|
| **Problem / Opportunity** | What problem or opportunity this work addresses |
| **Why Now** | Urgency, timing, or strategic context |
| **Current State / Existing System Context** | Current-system reality, especially for brownfield adoption |
| **Desired Outcome** | The intended future state |
| **Requirements** | Deeper requirement buckets including must-have, should-have, deferred, and out-of-scope |
| **Constraints & Dependencies** | Important constraints, integrations, and dependencies |
| **Assumptions** | Assumptions worth preserving across sessions |
| **Open Questions** | Unresolved questions that affect planning or discovery |
| **Recommended Direction** | Chosen direction and major rationale |
| **Supporting References** | Links to source artifacts such as `PROJECT.md`, codebase docs, or research |

### Optional Sections

| Section | Contents |
|---------|----------|
| **Target Users and Needs** | Richer user/problem framing than the hot-path brief requires |
| **Brownfield Evidence Notes** | Summarized evidence from `.paul/codebase/` artifacts |

### Frontmatter
None.

### Created By
`init-project` workflow or later durable product-definition updates.

### Read By
Selectively by `plan-phase`, `discuss-phase`, `discuss-milestone`, `phase-assumptions`, and research/discovery workflows when deeper product context materially helps the work.

### Written By
- `init-project`: initial creation from onboarding answers
- later planning/discovery workflows when durable product-definition conclusions change

### Portability Note
`PRD.md` is additive and portable. Legacy repos without `PRD.md` remain valid; adapters must not require destructive migration. When `PRD.md` exists, adapters should preserve its deeper-context role and avoid duplicating its full contents back into `PROJECT.md`.

---

## 3. ROADMAP.md

### Purpose

Phase structure -- milestones and phases providing high-level structure, not detailed tasks. Tracks what phases exist, their status, and their grouping into milestones.

### Location

`.paul/ROADMAP.md`

### Required Sections

| Section | Contents |
|---------|----------|
| **Overview** | One paragraph describing the project journey |
| **Current Milestone** | Name, version, status, phase count, phases table |
| **Completed Milestones** | Collapsible sections with phase tables for each completed milestone |

### Phases Table Columns

| Column | Description |
|--------|-------------|
| Phase | Phase number (integer or decimal) |
| Name | Descriptive phase name |
| Plans | Number of plans in this phase |
| Status | Current phase status |
| Completed | Completion date or `-` |

### Phase Status Values

| Value | Meaning |
|-------|---------|
| Not started | Phase has not begun |
| Planning | plan-phase in progress for this phase |
| In progress | At least one plan is being applied |
| Complete | All plans complete (includes completion date) |
| Deferred | Pushed to later milestone (with reason) |
| Skipped | Determined unnecessary (with reason) |

### Milestone Status Values

| Value | Meaning |
|-------|---------|
| Not started | Milestone defined but no phases begun |
| In Progress | At least one phase is active |
| Complete | All phases complete |

### Phase Numbering

- **Integer phases** (1, 2, 3): Planned milestone work, created during milestone definition.
- **Decimal phases** (2.1, 2.2): Urgent insertions between existing phases, marked with `[INSERTED]`.
- Phase numbers are globally unique and monotonically increasing within a project.
- Execution order follows numeric sorting: 1, 2, 2.1, 2.2, 3, 3.1, 4.

### Frontmatter

None.

### Created By

`init-project` workflow (initial milestone), `create-milestone` workflow (subsequent milestones).

### Read By

`plan-phase`, milestone workflows, `progress` command.

### Written By

- `create-milestone`: adds new milestone section with phases
- `plan-phase`: updates phase status to "Planning" or "In progress"
- `transition-phase`: updates phase status, moves to next phase
- `complete-milestone`: marks milestone complete, moves phases to Completed Milestones

### Portability Note

Phase numbering is globally unique and monotonically increasing. Adapters must not reuse or reorder phase numbers. The phases table is the authoritative record of what phases exist and their status.

---

## 4. PLAN.md

### Purpose

Executable plan for a phase -- everything needed for APPLY phase execution. Contains the goal, context references, acceptance criteria, task definitions, boundaries, and verification steps.

### Location

`.paul/phases/{NN}-{phase-name}/{NN}-{plan}-PLAN.md`

Example: `.paul/phases/45-artifact-lifecycle-spec/45-01-PLAN.md`

### Frontmatter

All fields are required.

```yaml
---
phase: XX-name          # Phase identifier matching ROADMAP.md (e.g., "45-artifact-lifecycle-spec")
plan: NN                # Zero-padded plan number within phase (e.g., "01", "02")
type: execute           # execute | tdd | research
wave: N                 # Execution wave number (integer, 1, 2, 3...). Pre-computed at plan time.
depends_on: []          # Array of plan IDs this plan requires (e.g., ["01-01"]). Empty = parallel candidate.
files_modified: []      # Array of file paths this plan modifies. For conflict detection.
autonomous: true        # true if no checkpoints; false if has checkpoint tasks requiring user interaction
---
```

| Field | Type | Description |
|-------|------|-------------|
| `phase` | string | Phase identifier, format `{NN}-{kebab-name}` |
| `plan` | string | Zero-padded plan number |
| `type` | string | One of: `execute`, `tdd`, `research` |
| `wave` | integer | Execution wave for parallel scheduling |
| `depends_on` | array of strings | Plan IDs this plan requires as input |
| `files_modified` | array of strings | File paths modified by this plan |
| `autonomous` | boolean | Whether the plan can run without user interaction |

### Required Sections

Plans use XML-style section tags.

| Section | Tag | Contents |
|---------|-----|----------|
| **Objective** | `<objective>` | Goal (specific, measurable), Purpose (connection to PROJECT.md value), Output (artifacts created/modified) |
| **Context** | `<context>` | References to project files and source files needed for execution |
| **Acceptance Criteria** | `<acceptance_criteria>` | Given/When/Then (BDD gherkin format) for each criterion |
| **Tasks** | `<tasks>` | Task definitions (see Task Types below) |
| **Boundaries** | `<boundaries>` | DO NOT CHANGE (protected files/patterns), SCOPE LIMITS (explicit exclusions) |
| **Verification** | `<verification>` | Checklist of overall completion checks |
| **Success Criteria** | `<success_criteria>` | Measurable completion conditions |
| **Output** | `<output>` | SUMMARY.md location to create upon completion |

### Optional Sections

| Section | Tag | Contents |
|---------|-----|----------|
| **Skills** | `<skills>` | Required/optional skills from SPECIAL-FLOWS.md with invocation checklist |

### Task Types

| Type | Use Case | Behavior |
|------|----------|----------|
| `auto` | Work the AI can do independently | Fully autonomous execution |
| `checkpoint:decision` | Implementation choices requiring human input | Pauses, presents options, waits for selection |
| `checkpoint:human-verify` | Visual or functional verification | Pauses, presents verification steps, waits for approval |
| `checkpoint:human-action` | Truly unavoidable manual steps (rare) | Pauses, describes action, waits for confirmation |

### Auto Task Required Fields

Every `<task type="auto">` must contain:

| Field | Tag | Description |
|-------|-----|-------------|
| Name | `<name>` | Action-oriented description of the outcome |
| Files | `<files>` | Files created or modified by this task |
| Action | `<action>` | Specific implementation instructions (what to do, what to avoid and why) |
| Verify | `<verify>` | How to prove the task worked (command, check, observable) |
| Done | `<done>` | Measurable acceptance criteria, links to AC-N |

### Created By

`plan-phase` workflow (with post-plan hook modifications from modules).

### Read By

`apply-phase` workflow.

### Portability Note

The `<context>` section uses `@`-references (e.g., `@.paul/PROJECT.md`) which are adapter-specific syntax for "read this file." The **logical** requirement is: "these files must be read and available as context before execution begins." Adapters translate `@`-references to their native file-reading mechanism.

---

## 5. SUMMARY.md

### Purpose

Plan completion documentation -- what was built, decisions made, deviations from plan, and readiness for next phase. Created during APPLY, finalized during UNIFY.

### Location

`.paul/phases/{NN}-{phase-name}/{NN}-{plan}-SUMMARY.md`

Example: `.paul/phases/44-implementation-validation/44-01-SUMMARY.md`

### Frontmatter

All fields should be present. Fields without values use empty arrays `[]` or appropriate defaults.

```yaml
---
phase: XX-name
plan: NN
subsystem: name                   # Primary category (auth, api, kernel, modules, etc.)
tags: []                          # Searchable keywords

requires:                         # Plans whose output was consumed (genuine data dependencies only)
  - phase: [prior phase ID]
    provides: [specific artifact consumed]
provides:                         # Capabilities/artifacts this plan creates for downstream use
  - [deliverable description]
affects:                          # Future phases/subsystems needing this context
  - [phase or subsystem name]

tech-stack:
  added: []                       # Libraries/tools/frameworks introduced
  patterns: []                    # Architectural patterns established

key-files:
  created: []                     # Key files created
  modified: []                    # Key files modified

key-decisions:                    # Quick-reference (detail in body)
  - "Decision: [brief summary]"

patterns-established:             # Conventions for future plans
  - "Pattern: [description]"

duration: Xmin
started: YYYY-MM-DDTHH:MM:SSZ
completed: YYYY-MM-DDTHH:MM:SSZ
---
```

### Required Sections

| Section | Contents |
|---------|----------|
| **One-liner** | Substantive outcome description (bold, immediately after heading). Must describe what actually shipped, not "phase complete." |
| **Performance** | Table: duration, started, completed, tasks completed, files modified |
| **Acceptance Criteria Results** | Table: criterion name, pass/fail status, notes |
| **Accomplishments** | Bullet list of key outcomes |
| **Files Created/Modified** | Table: file path, change type, purpose |
| **Decisions Made** | Table: decision, rationale, impact. Or "None -- followed plan as specified" |
| **Deviations from Plan** | Summary table (auto-fixed, scope additions, deferred counts), detail subsections for auto-fixed issues and deferred items |
| **Next Phase Readiness** | Ready (what's available), Concerns (potential issues), Blockers (anything preventing next phase) |

### Optional Sections

| Section | Contents |
|---------|----------|
| **Module Execution Reports** | Populated during UNIFY from module hook annotations. Module-specific subsections (e.g., Test Execution from TODD, Quality metrics from WALT). |
| **Task Commits** | Table: task name, commit hash, type, description |
| **Issues Encountered** | Table: issue, resolution |
| **Retrospective** | Issue timeline, outcome evaluation, improvement notes |

### Created By

`apply-phase` workflow (initial creation with results).

### Read By

`unify-phase` (for reconciliation), next `plan-phase` (only if genuine dependency exists -- not reflexive chaining).

### Written By

- `apply-phase`: creates initial SUMMARY with performance, acceptance criteria results, accomplishments, files, deviations
- `unify-phase`: finalizes with module execution reports, reconciled decisions, deferred issues

### Portability Note

Frontmatter enables automated context assembly. Adapters must preserve the frontmatter structure so that downstream workflows can use `requires`, `provides`, `affects`, and `tags` fields to determine which prior SUMMARY files are relevant context for a new plan. The frontmatter is machine-readable; the body sections are human-readable.

---

## 6. HANDOFF.md

### Purpose

Session transfer document -- enables context restoration in a fresh session with no prior context. Designed to be the single entry point for a new session.

### Location
Active handoffs are created at: `.paul/HANDOFF-{context}.md`
Examples:
- `.paul/HANDOFF-2026-03-14-v2.0-discussion.md`
- `.paul/HANDOFF-2026-03-13-v08-complete.md`

Archived handoffs move to: `.paul/handoffs/archive/`

### Required Sections

| Section | Contents |
|---------|----------|
| **READ THIS FIRST** | Project name, core value. Opens with: "You have no prior context. This document tells you everything." |
| **Current State** | Milestone, phase X of Y, plan status, loop position diagram |
| **What Was Done** | Bullet list of accomplishments from this session |
| **What's Next** | Immediate next action, following action |
| **Key Files** | Table: file path, purpose (always includes STATE.md, ROADMAP.md, current plan) |
| **Resume Instructions** | Steps to resume, including loop-position-based guidance and `/paul:resume` shortcut |

### Optional Sections

| Section | Contents |
|---------|----------|
| **What's In Progress** | Work started but not completed |
| **Key Decisions** | Table: decision, rationale (decisions made this session) |
| **Additional Context** | Platform references, research findings, discussion notes |
| **File Tracking** | Last commit hash, key file statuses |

### Frontmatter

None. Uses markdown headings with bold metadata fields at the top (Date, Status).

### Created By

`pause-work` workflow (triggered by `/paul:pause` or `/paul:handoff`).

### Read By

`resume-project` workflow (triggered by `/paul:resume`).

### Lifecycle
Created as an active handoff in `.paul/`, then typically archived after successful resume or later cleanup. Archived handoffs in `.paul/handoffs/archive/` remain valid historical context and may be read by resume workflows as fallback when no active handoff is available.

### Portability Note

Handoffs are harness-neutral by design. They describe state and context, not harness-specific commands. The loop position diagram and resume instructions use universal concepts (plan, apply, unify) that any adapter can interpret. A handoff created by one harness should be consumable by a different harness.

---

## 7. SPECIAL-FLOWS.md

### Purpose

Project-level skill and workflow configuration. Declares which skills (external capabilities, specialized workflows) are required or optional for the project.

### Location

`.paul/SPECIAL-FLOWS.md`

### Required Sections

| Section | Contents |
|---------|----------|
| **Project-Level Skills / Dependencies** | Table: work type, skill/command, priority, when required |

### Optional Sections

| Section | Contents |
|---------|----------|
| **Skill Details** | Per-skill breakdown: scope, commands, integration |
| **Phase Overrides** | Table: phase, additional skills, notes (skills needed for specific phases beyond defaults) |
| **Templates & Assets** | Table: asset type, location, when used |
| **Verification Checklist** | UNIFY skill audit template: expected skill, invoked?, gap?, notes |
| **Amendment History** | Table: date, change, reason |

### Priority Values

| Value | Meaning |
|-------|---------|
| `required` | Gap documented during UNIFY if not invoked for matching work types |
| `optional` | Informational only, no gap logged if unused |

### Frontmatter

None.

### Created By

`init-project` workflow, `configure-special-flows` workflow.

### Read By

`plan-phase` (populates the `<skills>` section in PLAN.md), `apply-phase` (skill verification gate -- required skills must be loaded before execution proceeds).

### Portability Note

Skill names (e.g., `/paul`, `/carl`) are adapter-specific UX conventions. The portable concept is "required workflow dependency" -- a named capability that must be available during certain work types. Adapters map skill names to their native invocation mechanism.

---

## 8. MILESTONE-CONTEXT.md

### Purpose

Temporary handoff artifact from `discuss-milestone` to `create-milestone`. Persists milestone discussion context across session boundaries (e.g., `/clear`).

### Location

`.paul/MILESTONE-CONTEXT.md`

### Required Sections

| Section | Contents |
|---------|----------|
| **Features to Build** | Feature list with descriptions -- the substance of the milestone |
| **Scope** | Suggested milestone name (version + theme), estimated phase count, one-sentence focus |
| **Phase Mapping** | Table: phase number, focus, features -- rough feature-to-phase breakdown |

### Optional Sections

| Section | Contents |
|---------|----------|
| **Constraints** | Technical or business constraints identified during discussion |
| **Additional Context** | Discussion notes, research findings, user preferences |

### Frontmatter

None. Uses a `Generated` date and `Status` field at the top.

### Created By

`discuss-milestone` workflow.

### Read By

`create-milestone` workflow.

### Lifecycle

**TEMPORARY.** Deleted after `create-milestone` successfully creates the milestone and updates ROADMAP.md. This artifact is not committed to version control. It exists solely to persist context across session boundaries during the milestone planning process.

### Portability Note

This artifact exists purely for cross-session persistence during milestone planning. Its temporary nature means adapters do not need to support long-term storage or versioning. The content captures the *what* and *why* of a milestone, not the *how*.

---

## Artifact Relationships

The following diagram shows how artifacts reference and depend on each other:

```
PROJECT.md ◄──────────── STATE.md ────────────► ROADMAP.md
(hot-path brief)          (references both)      (phase position)
     │                          │
     │                          └──► current PLAN.md / next action
     ▼
  PRD.md ───── selective deeper context ─────► PLAN.md
(deeper product definition)                   (execution plan)
     │                                            │
     │                                            ▼
     └──────── may inform discussion / research  SUMMARY.md
                                                  (plan completion)

HANDOFF.md ─── snapshots ──► STATE.md
(session transfer)         (current position)
       │
       └── references ──► current PLAN.md

SPECIAL-FLOWS.md ──► read by plan-phase ──► populates PLAN.md
                                             skills section

MILESTONE-CONTEXT.md ──► consumed by ──► creates entries in ──► ROADMAP.md
(temporary)               create-milestone
```

**Key relationships:**

- **STATE.md** references PROJECT.md (hot-path brief) and ROADMAP.md (phase position). It is the hub artifact.
- **PROJECT.md** is the concise landing brief. It should point to PRD.md rather than duplicating deep product-definition detail.
- **PRD.md** carries the deeper durable product-definition layer and is read selectively by planning/discovery workflows when its depth materially helps.
- **PLAN.md** references PROJECT.md (always), ROADMAP.md (for phase info), STATE.md (for position), and source files. It may also reference PRD.md selectively when deeper product context is needed.
- **SUMMARY.md** references its corresponding PLAN.md. It may reference prior SUMMARY.md files, but only when a genuine data dependency exists (e.g., types or exports from a prior plan are consumed).
- **HANDOFF.md** snapshots the current STATE.md and references the current PLAN.md. It is a point-in-time capture for session transfer.
- **ROADMAP.md** tracks all phases. PLAN.md and SUMMARY.md files exist within phase directories (`phases/{NN}-{name}/`).
- **SPECIAL-FLOWS.md** feeds into PLAN.md via plan-phase (populates the skills section).
- **MILESTONE-CONTEXT.md** feeds into ROADMAP.md via create-milestone, then is deleted.

---

## Validation Rules

These rules define consistency constraints that must hold across artifacts at any point in the lifecycle.

### Plan-Summary Pairing

Every PLAN.md must have a corresponding SUMMARY.md when the plan is complete. Specifically:
- If a file `.paul/phases/{NN}-{name}/{NN}-{plan}-PLAN.md` exists and the plan's phase status in ROADMAP.md is "Complete", then `.paul/phases/{NN}-{name}/{NN}-{plan}-SUMMARY.md` must also exist.
- A SUMMARY.md must never exist without a corresponding PLAN.md.

### Loop Position Consistency

STATE.md loop position must be consistent with the existence of artifact files:
- If loop shows PLAN `✓` (complete), at least one PLAN.md must exist for the current phase.
- If loop shows APPLY `✓` (complete), a SUMMARY.md must exist (or be in progress) for the current plan.
- If loop shows UNIFY `✓` (complete), the SUMMARY.md must have been finalized.

### Roadmap-Filesystem Consistency

ROADMAP.md phase status must match the actual plan files in phase directories:
- A phase marked "Complete" must have all its plans' SUMMARY.md files present.
- A phase marked "Not started" must not have any PLAN.md files in its directory.
- Phase directories follow the naming convention `{NN}-{phase-name}` matching the ROADMAP.md phase identifier.

### Frontmatter Completeness

- All frontmatter fields marked as required in a PLAN.md must be present and non-empty.
- All frontmatter fields in a SUMMARY.md should be present. Fields without values use empty arrays `[]` or appropriate type defaults.

### Core Value Preservation

The core value string in STATE.md (Project Reference section) must match the Core Value in PROJECT.md. If they diverge, PROJECT.md is authoritative.

### Layered Product Definition Consistency

- `PROJECT.md` remains the concise hot-path brief. If `PRD.md` exists, `PROJECT.md` should link to it instead of duplicating its full contents.
- `PRD.md` is optional for legacy repos. Its absence alone must not invalidate an existing project.
- If `PRD.md` exists, it must not replace lifecycle state tracked by `STATE.md` / `ROADMAP.md`.
- Adapters and validation should treat the `PROJECT.md` + `PRD.md` model as shared portable behavior, not a harness-specific extension.

---

*Artifact Specification -- v2.0 Portability & Cross-Harness*
*Created: 2026-03-14*
