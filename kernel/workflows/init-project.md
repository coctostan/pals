<purpose>
Initialize PAUL structure in a new project. Creates .paul/ directory with PROJECT.md, PRD.md, ROADMAP.md, STATE.md, and phases/ directory. Gathers layered project/product context conversationally before routing to planning.
</purpose>

<when_to_use>
- Starting PAUL in a project that doesn't have .paul/ directory
- User explicitly requests project initialization
- Beginning a new project from scratch
- Adopting PAUL into an existing codebase (brownfield)
</when_to_use>

<loop_context>
N/A - This is a setup workflow, not a loop phase.
After init, project is ready for first PLAN.
</loop_context>

<philosophy>
**Flow and momentum:** Init should feel like the natural start of work, not a chore.
- Ask questions conversationally
- Populate files from answers (user doesn't edit templates)
- End with ONE next action
- Build momentum into planning
</philosophy>

<references>
@src/templates/config.md
@src/references/sonarqube-integration.md
@src/references/brownfield-onboarding.md
</references>

<process>

<step name="check_existing" priority="first">
1. Check if .paul/ directory exists:
   ```bash
   ls .paul/ 2>/dev/null
   ```
2. If exists:
   - "PAUL already initialized in this project."
   - Route to `/paul:resume` or `/paul:progress`
   - Exit this workflow
3. If not exists: proceed with initialization
</step>

<step name="detect_existing_code">
**Detect whether this is a brownfield (existing codebase) or greenfield project.**

1. Check for common project indicators:
   ```bash
   ls package.json requirements.txt Cargo.toml go.mod pom.xml Gemfile pyproject.toml composer.json 2>/dev/null
   ls -d src/ lib/ app/ cmd/ pkg/ 2>/dev/null
   ```

2. **If indicators found** (brownfield detected):
   ```
   ════════════════════════════════════════
   Existing codebase detected:
   ════════════════════════════════════════

   Found: [list of detected files/directories]

   Mapping your codebase first helps me understand your project's
   architecture, conventions, and patterns before setting up PAUL.

   Map codebase now? (Recommended for existing projects) [Y/n]
   ```

   Wait for user response.

   **If yes (default):**
   - Run `/paul:map-codebase` workflow
   - After map completes, store `brownfield = true` and `codebase_mapped = true`
   - Continue to create_structure with brownfield context available

   **If no:**
   - Store `brownfield = true` and `codebase_mapped = false`
   - Continue to create_structure (user can map later via `/paul:map-codebase`)

3. **If no indicators found** (greenfield):
   - Store `brownfield = false`
   - Continue to create_structure
</step>

<step name="create_structure">
Create directories first (gives immediate feedback):
```bash
mkdir -p .paul/phases
```

Display:
```
PAUL structure created.

Before planning, I need to understand what you're building.
```
</step>

<step name="determine_planning_posture">
**Set the planning posture for onboarding.**

1. Determine the project default collaboration level:
   - If `pals.json` already exists and `planning.default_collaboration` is set, use it
   - Otherwise use `medium`
2. Ask whether this onboarding run is exploratory or direct-requirements:
   ```
   How should we shape this onboarding run?

   [1] Exploratory — the problem, users, or options still need shaping
   [2] Direct-requirements — you already know the requirements and want to move quickly
   ```
3. Ask for the planning collaboration level for this run and project default:
   ```
   Planning collaboration level?
   Current default: {default_collaboration}

   [1] low — minimal probing, keep momentum high
   [2] medium — clarify ambiguities, constraints, and success conditions
   [3] high — deeper shaping, assumptions, alternatives, and risks when useful
   ```
4. Apply this collaboration guidance to the remaining init conversation:
   - low → ask only for missing essentials or blockers
   - medium → clarify ambiguities and constraints before moving on
   - high → also probe target users, assumptions, alternatives, and risks when genuinely helpful
5. Store:
   - `planning_mode = exploratory | direct-requirements`
   - `collaboration_level = low | medium | high`
   - `default_collaboration = low | medium | high`
6. Note that later planning workflows may keep the project default or override it per run.
</step>

<step name="populate_from_codebase">
**Only runs if `brownfield = true` AND `codebase_mapped = true`.**

If codebase was mapped, read the findings to enrich the layered onboarding flow:

1. Read `.paul/codebase/STACK.md` — extract primary language, framework, and notable dependencies
2. Read `.paul/codebase/ARCHITECTURE.md` — extract current architecture, entry points, and existing capabilities
3. Read `.paul/codebase/CONVENTIONS.md` and `.paul/codebase/INTEGRATIONS.md` — extract constraints, integrations, and patterns to preserve
4. Use those findings as evidence while asking the user about:
   - current-state realities that must remain true
   - dependencies / integrations that shape the solution
   - constraints and conventions that should carry into planning
   - the future product direction beyond what today's code already does
5. Pre-populate the durable artifacts with the map findings:
   - `PROJECT.md` gets concise current-state, scope, constraint, and link context
   - `PRD.md` gets current-state vs desired-state framing, dependency detail, assumptions, and supporting references
   - Reference `.paul/codebase/` for detailed evidence instead of duplicating the full map

**If `brownfield = false` or `codebase_mapped = false`:** skip this step entirely.
</step>

<step name="gather_identity_and_framing">
**Ask ONE question at a time. Wait for response before next question.**

**Question 1: What is this project?**
```
What are you building, and how would you describe it in 1-2 sentences?

(Example: "A CLI tool for managing Docker containers across multiple environments")
```

Wait for user response. Store as `description`.
</step>

<step name="gather_users_and_needs">
**Question 2: Who is this for?**
```
Who are the primary users, and what do they need from this?

(Example: "Platform engineers who need a safer, faster way to manage container fleets")
```

Wait for user response. Store as `target_users_and_needs`.
</step>

<step name="gather_problem_opportunity">
**Question 3: What problem or opportunity matters most?**
```
What problem or opportunity is this addressing, and why does it matter now?

(If helpful, answer in terms of pain, opportunity, urgency, or desired outcome.)
```

Wait for user response. Store as `problem_opportunity` and `why_now`.
</step>

<step name="gather_scope_shape">
**Question 4: What is in and out?**
```
What is must-have for the first meaningful outcome, and what should be explicitly deferred or out of scope?
```

Wait for user response. Store as `must_have_scope`, `deferred_scope`, and `out_of_scope`.
</step>

<step name="gather_constraints_questions">
**Question 5: What else should the durable product definition remember?**
```
What constraints, dependencies, assumptions, open questions, or success signals should I capture?

{If brownfield context is available, also confirm the important current-state realities and integrations I found in the codebase map.}
```

Wait for user response. Store as:
- `constraints`
- `dependencies`
- `assumptions`
- `open_questions`
- `success_signals`
- `current_state_notes`

Derive `core_value` as a concise one-line summary of the main user + problem + outcome from the answers above. Confirm with the user if the synthesis is uncertain.
</step>

<step name="gather_project_name">
**Question 6: Project name**

Infer from:
1. Directory name
2. package.json name field
3. Ask if unclear

If obvious, confirm:
```
Project name: [inferred-name]

Is this correct? (yes/different name)
```

Store as `project_name`.
</step>

<step name="create_project_md">
Create `.paul/PROJECT.md` as the compact landing brief with gathered information:

```markdown
# Project: [project_name]

## Description
[description]

## Core Value
[core_value]

## Current State
| Attribute | Value |
|-----------|-------|
| Version | 0.1.0 |
| Status | Discovery / Onboarding |
| Last Updated | [YYYY-MM-DD] |

**Current system summary:**
- [current_state_notes or "New project"]

## Scope Snapshot
### Active
- [must_have_scope]

### Planned
- [deferred_scope or "To be refined during planning"]

### Out of Scope
- [out_of_scope or "None explicitly yet"]

## Target Users
**Primary:** [target_users_and_needs summary]

## Constraints
- [top constraints]

## Success Metrics
- [success_signals or "To be refined during planning"]

## Key Decisions
| Decision | Rationale | Date | Status |
|----------|-----------|------|--------|
| Layered artifact model (`PROJECT.md` + `PRD.md`) adopted at init | Keep hot-path context concise while preserving deeper product definition | [YYYY-MM-DD] | Active |

## Links
- `PRD.md` — deeper product-definition context
- `.paul/ROADMAP.md` — milestone and phase structure
- `.paul/codebase/` — brownfield evidence (if available)

---
*Created: [timestamp]*
```

Note: `PROJECT.md` should stay intentionally concise. Put deeper product framing, deferred items, assumptions, open questions, and dependency detail in `PRD.md`.
</step>

<step name="create_prd_md">
Create `.paul/PRD.md` with the deeper product-definition context gathered during onboarding:

```markdown
# Product Requirements: [project_name]

## Problem / Opportunity
[problem_opportunity]

## Why Now
[why_now]

## Current State / Existing System Context
[current_state_notes or brownfield evidence summary]

## Desired Outcome
[desired outcome implied by core_value and must_have_scope]

## Target Users and Needs
[target_users_and_needs]

## Requirements
### Must Have
- [must_have_scope]

### Should Have / Nice to Have
- [deferred_scope or "To be refined during planning"]

### Explicitly Deferred
- [deferred_scope or "None captured yet"]

### Out of Scope
- [out_of_scope or "None explicitly yet"]

## Constraints & Dependencies
### Constraints
- [constraints]

### Dependencies / Integrations
- [dependencies or brownfield integrations]

## Assumptions
- [assumptions or "None captured yet"]

## Open Questions
- [open_questions or "None captured yet"]

## Recommended Direction
[initial synthesis of the intended direction from onboarding]

## Supporting References
- `.paul/PROJECT.md`
- `.paul/codebase/` (if available)

---
*Created: [timestamp]*
```

Note: `PRD.md` is the deeper, selectively-read artifact for planning, discussion, research, and assumptions work.
</step>

<step name="create_roadmap_md">
Create `.paul/ROADMAP.md`:

```markdown
# Roadmap: [project_name]

## Overview
[description]

## Current Milestone
**v0.1 Initial Release** (v0.1.0)
Status: Not started
Phases: 0 of TBD complete

## Phases

| Phase | Name | Plans | Status | Completed |
|-------|------|-------|--------|-----------|
| 1 | TBD | TBD | Not started | - |

## Phase Details

Phases will be defined during `/paul:plan`.

---
*Roadmap created: [timestamp]*
```

Note: Phase details are populated during planning, not init.
</step>

<step name="create_state_md">
Create `.paul/STATE.md`:

```markdown
# Project State

## Project Reference

See: .paul/PROJECT.md (updated [timestamp])

**Core value:** [core_value]
**Current focus:** Project initialized — ready for planning

## Current Position

Milestone: v0.1 Initial Release
Phase: Not yet defined
Plan: None yet
Status: Ready to create roadmap and first PLAN
Last activity: [timestamp] — Project initialized

Progress:
- Milestone: [░░░░░░░░░░] 0%

## Loop Position

Current loop state:
```
PLAN ──▶ APPLY ──▶ UNIFY
  ○        ○        ○     [Ready for first PLAN]
```

## Accumulated Context

### Decisions
None yet.

### Deferred Issues
None yet.

### Blockers/Concerns
None yet.

## Session Continuity

Last session: [timestamp]
Stopped at: Project initialization complete
Next action: Run /paul:plan to define phases and first plan
Resume file: .paul/PROJECT.md

---
*STATE.md — Updated after every significant action*
```
</step>

<step name="prompt_integrations">
**Ask about optional integrations:**

```
Optional integrations:

Would you like to enable SonarQube code quality scanning?
(Requires SonarQube server and MCP server - can enable later)

[1] Yes, enable SonarQube
[2] Skip for now
```

Wait for user response.

**If "1" or "yes" or "enable":**

1. Prompt for project key:
   ```
   SonarQube project key?
   (Press Enter to use: [project_name])
   ```

   - If user presses Enter: use `project_name`
   - Otherwise: use provided key

2. Create `.paul/config.md`:
   ```markdown
   # Project Config

   **Project:** [project_name]
   **Created:** [timestamp]

   ## Project Settings

   ```yaml
   project:
     name: [project_name]
     version: 0.0.0
   ```

   ## Integrations

   ### SonarQube

   ```yaml
   sonarqube:
     enabled: true
     project_key: [project_key]
   ```

   ## Preferences

   ```yaml
   preferences:
     auto_commit: false
     verbose_output: false
   ```

   ---
   *Config created: [timestamp]*
   ```

3. Store `integrations_enabled = true`

**If "2" or "skip" or "no":**

Store `integrations_enabled = false`
(Don't create config.md - user can add later)
</step>

<step name="check_specialized_flows">
**Ask about specialized skills:**

```
Do you have specialized skills or commands for this project?
(e.g., /revops-expert, /frontend-design, custom workflows)

[1] Yes, configure now
[2] Skip for now (add later via /paul:flows)
```

Wait for user response.

**If "1" or "yes" or "configure":**

1. Store `specialized_flows_enabled = true`
2. Route to: @workflows/configure-special-flows.md
3. After completion, return to init confirmation
4. Store `skills_configured_count` from workflow output

**If "2" or "skip" or "no":**

Store `specialized_flows_enabled = false`
(User can add later via /paul:flows)
</step>

<step name="configure_modules">
**Ask about module configuration:**

```
Which PALS modules would you like to enable?
(All enabled by default — enter numbers to toggle, or press Enter to accept)

  [1] CARL   ✓  Session boundary manager (Pi extension)
  [2] TODD   ✓  Test-driven development enforcement
  [3] WALT   ✓  Quality gating & validation
  [4] DEAN   ✓  Dependency evaluation & audit notifier
  [5] IRIS   ✓  Intelligent review & inspection system
  [6] SKIP   ✓  Smart knowledge & information persistence
  [7] DAVE   ✓  Deploy automation & verification engine
  [8] RUBY   ✓  Refactor utility & better-code yielder
```

Wait for user response.

**If user presses Enter or says "all" or "defaults":**
- All modules enabled (default)
- Store `module_selections` with all enabled

**If user provides numbers (e.g., "4 5 7"):**
- Toggle those modules off (flip ✓ to ✗)
- Show updated list and confirm
- Store `module_selections` with updated states

**After confirmation, create `pals.json` in project root:**

```json
{
  "modules": {
    "carl": { "enabled": true, "description": "Session boundary manager (Pi extension)", "session_strategy": "phase-boundary", "continue_threshold": 0.4, "safety_ceiling": 0.8 },
    "todd": { "enabled": true, "description": "Test-driven development enforcement" },
    "walt": { "enabled": true, "description": "Quality gating & validation" },
    "dean": { "enabled": true, "description": "Dependency evaluation & audit notifier" },
    "iris": { "enabled": true, "description": "Intelligent review & inspection system" },
    "skip": { "enabled": true, "description": "Smart knowledge & information persistence" },
    "dave": { "enabled": true, "description": "Deploy automation & verification engine" },
    "ruby": { "enabled": true, "description": "Refactor utility & better-code yielder" }
  },
  "git": {
    "remote": null,
    "branching": "feature-per-phase",
    "worktree_isolation": false,
    "auto_push": false,
    "auto_pr": false,
    "ci_checks": false
  },
  "integrations": {
    "sonarqube": { "enabled": false, "project_key": "" }
  },
  "planning": {
    "default_collaboration": "medium"
  },
  "preferences": {
    "auto_commit": false,
    "verbose_output": false
  }
}
```

Adjust `enabled` values based on user's toggle selections.
Set `planning.default_collaboration` to the value chosen in determine_planning_posture (fallback: `medium`).
If SonarQube was enabled in the earlier integrations step, set `integrations.sonarqube.enabled: true` and populate `project_key`.
Git section will be populated by the configure_git step (next).

**Note:** This step is quick — accept defaults with Enter. Don't make it feel heavy.
</step>

<step name="configure_git">
**Ask about git/GH configuration:**

**1. Detect git repo:**
```bash
git rev-parse --git-dir 2>/dev/null
```

**If not a git repo:**
```
Not a git repo — git features disabled.
Run `git init` to enable later, then update pals.json git section.
```
- Set all git config to defaults (remote: null, auto_push: false, auto_pr: false, ci_checks: false)
- Skip remaining git questions
- Store `git_enabled = false`

**If git repo detected, ask ONE question at a time:**

**Question 1 — GitHub repo:**
```
GitHub repository?

[1] Yes — detect from remote
[2] Enter URL manually
[3] No GitHub repo (local only)
```

Wait for user response.

- If "1": Run `git remote get-url origin 2>/dev/null`
  - If remote found: Display "Detected: {URL}" and confirm
  - If no remote: "No remote found. Enter URL or choose [3]"
- If "2": Prompt for URL, store as `git_remote`
- If "3": Set `git_remote = null`

**Question 2 — Branching strategy (only if git repo detected):**
```
Branching strategy?

[1] Feature branch per phase (recommended)
    Creates feature/{phase-name}, merges on phase complete
[2] Direct to main
    All commits on main branch
```

Wait for user response.
- If "1": Store `git_branching = "feature-per-phase"`
- If "2": Store `git_branching = "direct-to-main"`

**Question 3 — Worktree Isolation (only if git repo detected):**
```
Use git worktrees during APPLY phase?
This creates an isolated copy for each phase — if something goes wrong,
discard the worktree instead of reverting commits.

[1] No (default) — work directly on current branch
[2] Yes — isolate each APPLY phase in a worktree
```

Wait for user response.
- If "1" or Enter: Store `git_worktree_isolation = false`
- If "2": Store `git_worktree_isolation = true`

**Question 4 — Automation (only if GH remote detected):**
```
Git automation? (Enter to accept defaults)

Auto-push after phase complete:      [yes/NO]
Auto-create PR on phase transition:  [yes/NO]
Wait for CI checks before merge:     [yes/NO]
```

- Defaults are NO for all (conservative)
- Accept "yes" or "y" to enable each
- Store as `git_auto_push`, `git_auto_pr`, `git_ci_checks`

**If no GH remote:** Skip Question 3, all automation defaults to false.

**Update pals.json git section with gathered values:**
```json
"git": {
  "remote": "{git_remote or null}",
  "branching": "{git_branching}",
  "worktree_isolation": {git_worktree_isolation},
  "auto_push": {git_auto_push},
  "auto_pr": {git_auto_pr},
  "ci_checks": {git_ci_checks}
}
```

Store `git_enabled = true` and `git_remote` for confirmation display.
</step>

<step name="confirm_and_route">
**Display confirmation with ONE next action:**

**Display based on enabled features:**

```
════════════════════════════════════════
PAUL INITIALIZED
════════════════════════════════════════

Project: [project_name]
Core value: [core_value]

Created:
  .paul/PROJECT.md        ✓
  .paul/PRD.md            ✓
  .paul/ROADMAP.md        ✓
  .paul/STATE.md          ✓
  pals.json               ✓  ([N] modules enabled)
  .paul/SPECIAL-FLOWS.md  ✓  (if specialized_flows_enabled: "[N] skills configured")
  .paul/phases/           ✓

Git: [remote URL or "local only"] | [branching strategy] | push:[yes/no] PR:[yes/no] CI:[yes/no]
Planning default: {default_collaboration} | This run: {planning_mode}, {collaboration_level} collaboration

────────────────────────────────────────
▶ NEXT: /paul:plan
  Define your phases and create your first plan.
────────────────────────────────────────

Type "yes" to proceed, or ask questions first.
```

**Note:** Only show SPECIAL-FLOWS.md line if specialized flows were enabled.
Only show Git line if `git_enabled = true`.
Always show pals.json with module count.

**Do NOT suggest multiple next steps.** ONE action only.
</step>

</process>

<output>
- `.paul/` directory structure
- `.paul/PROJECT.md` (compact landing brief populated from conversation)
- `.paul/PRD.md` (deeper product-definition artifact populated from conversation)
- `.paul/ROADMAP.md` (skeleton for planning)
- `.paul/STATE.md` (initialized state)
- `pals.json` (module configuration, git config, and user's selections)
- `.paul/SPECIAL-FLOWS.md` (if specialized flows enabled)
- `.paul/phases/` (empty directory)
- Clear routing to `/paul:plan`
</output>

<error_handling>
**Permission denied:**
- Report filesystem error
- Ask user to check permissions

**User declines to answer:**
- Use "[TBD]" placeholder
- Note that planning will ask for this information

**Partial creation failure:**
- Report what was created vs failed
- Offer to retry or clean up
</error_handling>
