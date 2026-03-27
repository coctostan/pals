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
**Three init flows (v2.26):**
- **Quick mode** (~1 question): User says "quick" / "--quick" / "just init" → infer project name, ask "what are you building?", default everything, create all artifacts, route to /paul:plan
- **Greenfield** (~8 questions): No source files → merged identity/problem question, simplified constraints, silent module defaults, silent planning posture defaults, explicit v0.1 milestone
- **Brownfield** (~12+ questions): Source files found → codebase mapping offer, planning posture questions, separate identity + problem questions, full constraints capture, grouped module toggle with descriptions

All three flows create the same artifacts: PROJECT.md, PRD.md, ROADMAP.md, STATE.md, pals.json, phases/
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
   a. Check if pals.json exists and needs migration (see `migrate_pals_json` step below)
   b. If migration was needed and performed, show results and offer:
      - "Config updated. Continue to /paul:resume or /paul:plan?"
   c. If no migration needed:
      - "PAUL already initialized in this project."
      - Route to `/paul:resume` or `/paul:progress`
   d. Exit this workflow (do NOT re-initialize)
3. If not exists: proceed with initialization
</step>
<step name="migrate_pals_json" priority="after-check-existing">
**Migrate an existing pals.json to the current schema. Runs when .paul/ exists.**

1. Read existing pals.json:
   ```bash
   cat pals.json 2>/dev/null
   ```
   If pals.json does not exist: skip migration entirely (init will create it fresh).

2. Read the canonical schema from `references/pals-json-schema.md` for the expected field list.

3. Read installed `modules.yaml` to discover all currently installed modules.

4. Compare existing pals.json against expected fields. For each missing field:
   - **modules:** For each module in `modules.yaml` not present in `pals.json.modules`, add it with `{ "enabled": true, "description": "..." }` using the description from the module's manifest.
   - **git fields:** Add missing git fields with their schema defaults. Do NOT overwrite existing values. Special case: if `git.branching` exists but `git.workflow` does not, add `git.workflow: "legacy"` (preserves the user's existing behavior).
   - **planning:** Add `planning.default_collaboration: "medium"` if missing.
   - **preferences:** Add `preferences.auto_commit: false`, `preferences.verbose_output: false` if missing.
   - **guided_workflow:** Add `guided_workflow.auto_present` with safe defaults (plan_review: false, apply_approval: false, continue_to_unify: true, checkpoint_*: true, resume_next: true, phase_transition: false, milestone_transition: false) if missing.
   - **integrations:** Add `integrations.sonarqube: { "enabled": false, "project_key": "" }` if missing.

5. Set `schema_version` to the current `kernel_version` from installed `modules.yaml` (e.g., `"schema_version": "2.0.0"`).

6. Write updated pals.json (preserving all existing values, only adding new fields + version stamp).

6. Display migration summary:
   ```
   ════════════════════════════════════════
   pals.json migrated to current schema
   ════════════════════════════════════════

   Added modules: {list of new module names, or "none"}
   Added git fields: {list of new field names, or "none"}
   Added sections: {planning, preferences, integrations, guided_workflow — whichever were missing}
   Preserved: {count} existing settings unchanged

   No existing values were overwritten.
   ════════════════════════════════════════
   ```

7. If nothing was missing: skip the summary, output "pals.json is up to date."
</step>

<step name="detect_quick_mode" priority="after-check-existing">
**Detect quick init mode.**

Check if the user's init request contains "quick", "fast", "--quick", or "just init":
- Store `quick_mode = true` if detected
- Store `quick_mode = false` otherwise

**If `quick_mode = false`:** proceed to `detect_existing_code` normally.

**If `quick_mode = true`:**

1. Infer project name:
   - From `package.json` `name` field if it exists
   - Otherwise from current directory name: `basename $(pwd)`
   - Store as `project_name`
   - Display: `Project name: {project_name}`

2. Ask ONE question:
   ```
   Quick init mode — one question only.

   What are you building? (1-2 sentences)
   ```
   Wait for response. Store as `description`.

3. Apply all defaults:
   - `brownfield = false`
   - `planning_mode = "direct-requirements"`
   - `collaboration_level = "medium"`, `default_collaboration = "medium"`
   - `target_users_and_needs = "TBD — refine during planning"`
   - `problem_opportunity = description`, `why_now = "TBD"`
   - `must_have_scope = "TBD — define during first /paul:plan"`
   - `deferred_scope = "TBD"`, `out_of_scope = "TBD"`
   - `constraints = "None captured"`, `dependencies = "TBD"`
   - `assumptions = "TBD"`, `open_questions = "TBD"`
   - `success_signals = "TBD"`, `current_state_notes = "New project"`
   - Derive `core_value` from `description`
   - `module_selections` = all 19 modules enabled
   - `integrations_enabled = false`
   - `specialized_flows_enabled = false`
   - Detect git repo (`git rev-parse --git-dir 2>/dev/null`):
     - If git repo found: `git_enabled = true`, `git_workflow = "none"`, all automation = false
     - If no git repo: `git_enabled = false`, `git_workflow = "none"`, all automation = false

4. Skip directly to artifact creation:
   - Execute: `create_structure`
   - Execute: `create_project_md`
   - Execute: `create_prd_md`
   - Execute: `create_roadmap_md`
   - Execute: `create_state_md`
   - Create `pals.json` with all defaults (all modules enabled, git workflow "none", SonarQube disabled, medium collaboration)
   - Execute: `create_agents_md`
   - Execute: `confirm_and_route`

5. **Skip all of these steps:**
   - `detect_existing_code`
   - `determine_planning_posture`
   - `populate_from_codebase`
   - `gather_identity_and_framing`
   - `gather_users_and_needs`
   - `gather_scope_shape`
   - `gather_constraints_questions`
   - `gather_project_name`
   - `prompt_integrations`
   - `check_specialized_flows`
   - `configure_modules`
   - `configure_git`
</step>
<step name="detect_existing_code">
**Detect whether this is a brownfield (existing codebase) or greenfield project.**

1. Check for common project indicators:
   ```bash
   ls package.json requirements.txt Cargo.toml go.mod pom.xml Gemfile pyproject.toml composer.json 2>/dev/null
   ls -d src/ lib/ app/ cmd/ pkg/ 2>/dev/null
   ```
2. **If indicators found**, verify actual source files exist (not just empty directories):
   ```bash
   find src lib app cmd pkg -type f \( -name '*.ts' -o -name '*.js' -o -name '*.py' -o -name '*.rs' -o -name '*.go' -o -name '*.java' -o -name '*.rb' -o -name '*.php' -o -name '*.c' -o -name '*.cpp' -o -name '*.swift' \) 2>/dev/null | head -1
   ```
3. **If indicators found AND source files exist** (brownfield confirmed):
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
4. **If indicators found but NO source files exist** (scaffolding only):
   ```
   Project scaffolding detected but no source files found.
   Treating as greenfield project.
   ```
   - Store `brownfield = false`
   - Continue to create_structure
5. **If no indicators found** (greenfield):
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
   - If `pals.json` already exists and `planning.default_collaboration` is set, use it
   - Otherwise use `medium`
2. **If greenfield (`brownfield = false`):**
   - Default silently: `planning_mode = "direct-requirements"`, `collaboration_level = "medium"`, `default_collaboration = "medium"`
   - Display: "Greenfield project — using direct-requirements mode with medium collaboration."
   - Skip questions 2-3 below. Continue to gather_identity_and_framing.

3. **If brownfield (`brownfield = true`):**
   Ask whether this onboarding run is exploratory or direct-requirements:
   ```
   How should we shape this onboarding run?
   [2] Direct-requirements — you already know the requirements and want to move quickly
   ```

4. Ask for the planning collaboration level for this run and project default:
   ```
   Planning collaboration level?
   Current default: {default_collaboration}
   [2] medium — clarify ambiguities, constraints, and success conditions
   [3] high — deeper shaping, assumptions, alternatives, and risks when useful
   ```

5. Apply this collaboration guidance to the remaining init conversation:
   - low → ask only for missing essentials or blockers
   - medium → clarify ambiguities and constraints before moving on
   - high → also probe target users, assumptions, alternatives, and risks when genuinely helpful
6. Store:
   - `planning_mode = exploratory | direct-requirements`
   - `collaboration_level = low | medium | high`
   - `default_collaboration = low | medium | high`
7. Note that later planning workflows may keep the project default or override it per run.
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
**Question 1: What is this project and why?**

**If greenfield:**
```
What are you building, and what problem or opportunity is it addressing?

(Example: "A CLI tool for managing Docker containers — platform engineers need a safer way to manage container fleets across environments")
```
Wait for user response. Parse into `description`, `problem_opportunity`, and `why_now`.

**If brownfield:**
Ask as two separate questions for richer context:

*Question 1a:*
```
What are you building, and how would you describe it in 1-2 sentences?
```
Wait for user response. Store as `description`.
*Question 1b:*
```
What problem or opportunity is this addressing, and why does it matter now?
```
Wait for user response. Store as `problem_opportunity` and `why_now`.
</step>

<step name="gather_users_and_needs">
**Question 2: Who is this for?**
```
Who are the primary users, and what do they need from this?

(Example: "Platform engineers who need a safer, faster way to manage container fleets")
```

Wait for user response. Store as `target_users_and_needs`.
</step>

<step name="gather_scope_shape">
**Question 3: What is in and out?**
```
What is must-have for the first meaningful outcome, and what should be explicitly deferred or out of scope?
```

Wait for user response. Store as `must_have_scope`, `deferred_scope`, and `out_of_scope`.
</step>
<step name="gather_constraints_questions">
**Greenfield: simplified optional prompt**
**Brownfield: full context capture**

**If greenfield:**
```
Any constraints or key decisions to capture? (press Enter to skip)

(Example: "Must use TypeScript, no external auth services, deploy to Vercel")
```
Wait for user response. Store as `constraints`.
Default the rest: `dependencies = "TBD"`, `assumptions = "TBD"`, `open_questions = "TBD"`, `success_signals = "TBD"`, `current_state_notes = "New project"`.

**If brownfield:**
```
What constraints, dependencies, assumptions, open questions, or success signals should I capture?
```
Wait for user response. Store as:
- `constraints`
- `dependencies`
- `assumptions`
- `open_questions`
- `success_signals`
- `current_state_notes`
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

Note: Phase details are populated during planning, not init. The "v0.1 Initial Release" milestone is explicitly created here — no separate `/paul:milestone` invocation is needed. Users can customize via `/paul:milestone` later.
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

Milestone: v0.1 Initial Release (created during init)
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
Next action: Run /paul:plan to define phases and first plan for v0.1
Resume file: .paul/PROJECT.md

---
*STATE.md — Updated after every significant action*
```
</step>

<step name="create_agents_md">
**Generate a lean AGENTS.md at the project root.**

This file follows the AGENTS.md convention — focused on what models can't infer from file structure alone.

1. Build the PALS Workflow section:
   - Read `pals.json` modules: collect names where `enabled: true`
   - Read `pals.json` git.workflow (github-flow / legacy / none)
   - Format as comma-separated module list and workflow label

2. Use standard Boundaries section (same for all PALS projects — always/ask/never rules).

3. Leave Project Conventions as a placeholder with guidance comments.

4. Write to project root:
   ```markdown
   # [project_name]

   ## PALS Workflow

   This project uses [PALS](https://github.com/coctostan/pals) — a project automation & lifecycle system.

   - **Lifecycle:** PLAN → APPLY → UNIFY loop
   - **State:** `.paul/STATE.md` tracks current position
   - **Commands:** `/paul:plan`, `/paul:apply`, `/paul:unify`, `/paul:fix`
   - **Git workflow:** [git_workflow from pals.json]
   - **Active modules:** [comma-separated enabled module names]

   ## Boundaries

   ### Always Do
   - Run tests before marking work complete
   - Follow the PLAN → APPLY → UNIFY loop
   - Check `.paul/STATE.md` for current project position before starting work

   ### Ask First
   - Before modifying files outside the current plan scope
   - Before adding new dependencies
   - Before changing architecture patterns

   ### Never Do
   - Commit secrets, API keys, or credentials
   - Skip the UNIFY phase after APPLY
   - Modify `.paul/` files directly — use `/paul:*` commands

   ## Project Conventions

   <!-- Add project-specific conventions that AI agents should follow. -->
   <!-- Examples: naming patterns, import style, architecture decisions, domain terms. -->
   <!-- This section is yours — PALS won't overwrite it during regeneration. -->

   - [Add your conventions here]
   ```

5. Display: `AGENTS.md generated ✓`
</step>

<step name="prompt_integrations">
**Integrations default to disabled during init.**

SonarQube and other integrations are not asked about during init to reduce onboarding friction.

- Store `integrations_enabled = false`
- SonarQube defaults to `{ "enabled": false, "project_key": "" }` in pals.json
- Display nothing (silent default)

Note: Users can enable integrations later via `/paul:config`.
</step>

<step name="check_specialized_flows">
**Specialized flows skipped during init.**

Specialized skills configuration is not asked about during init to reduce onboarding friction.

- Store `specialized_flows_enabled = false`
- No SPECIAL-FLOWS.md created during init
- Display nothing (silent default)

Note: Users can configure specialized flows later via `/paul:flows`.
</step>

<step name="configure_modules">
**Module configuration — greenfield skips, brownfield gets grouped descriptions.**

**If greenfield (`brownfield = false`):**
- All 19 modules enabled by default (silent)
- Display: "All 19 modules enabled by default. (Adjust later via /paul:config)"
- Skip the interactive toggle question
- Store `module_selections` with all enabled
- Continue to configure_git

**If brownfield (`brownfield = true`):**
```
Which PALS modules would you like to enable?
(All enabled by default — enter numbers to toggle, or press Enter to accept)
Quality & Testing:
  [1]  TODD  ✓  Enforces test coverage and TDD workflows
  [2]  WALT  ✓  Gates quality (tests, lint, typecheck pass/fail)

Security & Dependencies:
  [3]  DEAN  ✓  Audits dependencies for known vulnerabilities
  [4]  SETH  ✓  Scans for hardcoded secrets and injection risks

Code Quality:
  [5]  IRIS  ✓  Reviews code for anti-patterns and smells
  [6]  RUBY  ✓  Flags technical debt and refactoring candidates

Architecture & APIs:
  [7]  ARCH  ✓  Detects architecture patterns and boundary violations
  [8]  GABE  ✓  Reviews API contracts and conventions

UI & Accessibility:
  [9]  LUKE  ✓  UI/UX pattern detection and review
  [10] ARIA  ✓  Accessibility assessment and enforcement

Data & Infrastructure:
  [11] DANA  ✓  Data patterns and migration safety
  [12] DAVE  ✓  CI/CD config validation and deploy checks
  [13] PETE  ✓  Performance pattern detection

Observability & Resilience:
  [14] OMAR  ✓  Logging and observability review
  [15] REED  ✓  Resilience patterns (timeouts, retries, error handling)

Privacy & Session:
  [16] VERA  ✓  PII detection and privacy compliance
  [17] CARL  ✓  Session boundary manager (Pi extension)

Knowledge & Documentation:
  [18] SKIP  ✓  Captures decisions, rationale, and lessons learned
  [19] DOCS  ✓  Documentation drift detection and lifecycle oversight
```

Wait for user response.
**If user presses Enter or says "all" or "defaults":**
- All modules enabled (default)
- Store `module_selections` with all enabled
- Toggle those modules off (flip ✓ to ✗)
- Show updated list and confirm
- Store `module_selections` with updated states
**After confirmation, create `pals.json` in project root:**
```json
{
  "schema_version": "2.0.0",
  "modules": {
    "carl": { "enabled": true, "description": "Session boundary manager (Pi extension)", "session_strategy": "phase-boundary", "continue_threshold": 0.4, "safety_ceiling": 0.8 },
    "todd": { "enabled": true, "description": "Test-driven development enforcement" },
    "walt": { "enabled": true, "description": "Quality gating & validation" },
    "dean": { "enabled": true, "description": "Dependency evaluation & audit notifier" },
    "iris": { "enabled": true, "description": "Intelligent review & inspection system" },
    "skip": { "enabled": true, "description": "Smart knowledge & information persistence" },
    "dave": { "enabled": true, "description": "Deploy automation & verification engine" },
    "ruby": { "enabled": true, "description": "Refactor utility & better-code yielder" },
    "arch": { "enabled": true, "description": "Architecture pattern detection & boundary enforcement" },
    "seth": { "enabled": true, "description": "Security evaluation & threat hunting" },
    "pete": { "enabled": true, "description": "Performance evaluation & tuning expert" },
    "gabe": { "enabled": true, "description": "Gateway & API boundary expert" },
    "luke": { "enabled": true, "description": "UI/UX pattern detection & review" },
    "aria": { "enabled": true, "description": "Accessibility assessment & enforcement" },
    "dana": { "enabled": true, "description": "Data pattern detection & migration safety" },
    "omar": { "enabled": true, "description": "Observability & logging review" },
    "reed": { "enabled": true, "description": "Resilience pattern detection & review" },
    "vera": { "enabled": true, "description": "Privacy assessment & PII protection" },
    "docs": { "enabled": true, "description": "Documentation drift detection & lifecycle oversight" }
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
  },
  "guided_workflow": {
    "auto_present": {
      "plan_review": false,
      "apply_approval": false,
      "continue_to_unify": true,
      "checkpoint_decision": true,
      "checkpoint_human_verify": true,
      "checkpoint_human_action": true,
      "resume_next": true,
      "phase_transition": false,
      "milestone_transition": false
    }
}
```
Adjust `enabled` values based on user's toggle selections.
Set `planning.default_collaboration` to the value chosen in determine_planning_posture (fallback: `medium`).
Git section will be populated by the configure_git step (next).
**Note:** This step is quick — accept defaults with Enter for brownfield, or fully silent for greenfield.
</step>

<step name="configure_git">
**Ask about git/GH configuration:**
**0. Detect `gh` CLI availability and authentication:**
```bash
gh --version 2>/dev/null
```
- If command fails: `gh_available = false`, `gh_authenticated = false`
- If command succeeds: `gh_available = true`, then check authentication:
```bash
gh auth status 2>/dev/null
```
- If auth check succeeds: `gh_authenticated = true`
- If auth check fails: `gh_authenticated = false`
- Store both `gh_available` and `gh_authenticated` for later use
**1. Detect git repo:**
```bash
git rev-parse --git-dir 2>/dev/null
```
**If not a git repo:**
```
Not a git repo — git features disabled.
Run `git init` to enable later, then update pals.json git section.
```
- Set `workflow: "none"` and all git config to defaults
- Skip remaining git questions
- Store `git_enabled = false`
**If git repo detected, ask ONE question at a time:**
**Question 1 — GitHub repo:**
```
GitHub repository?
[2] Enter URL manually
[3] No GitHub repo (local only)
```

Wait for user response.
- If "1": Run `git remote get-url origin 2>/dev/null`
  - If remote found: Display "Detected: {URL}" and confirm
  - If no remote: "No remote found. Enter URL or choose [3]"
- If "2": Prompt for URL, store as `git_remote`
- If "3": Set `git_remote = null`
**Question 2 — Git workflow (only if git repo detected):**
```
Git workflow?

[1] GitHub Flow (recommended for GitHub repos)
    Feature branches, PRs, CI gates, merge-before-next-phase
[2] Feature branch per phase
    Creates feature/{phase-name}, merges on phase complete (no enforcement)
[3] Direct to main
    All commits on main branch (no enforcement)
```

Wait for user response.

**If "1" (GitHub Flow):**
- If `gh_available = false`:
  ```
  ⚠️  GitHub Flow requires the `gh` CLI for PR/CI operations.
  Install: https://cli.github.com/
  [2] Choose a different workflow
  ```
  If "2": re-present Question 2
- If `gh_available = true` but `gh_authenticated = false`:
  ```
  ⚠️  `gh` CLI is installed but not authenticated.
  GitHub Flow requires authentication for PR creation, CI checks, and merging.
  Run: `gh auth login`

  [1] Continue anyway (enforcement features will fail until authenticated)
  [2] Choose a different workflow
  ```
  If "2": re-present Question 2
- If `git_remote = null`:
  ```
  ⚠️  GitHub Flow requires a GitHub remote.
  Enter remote URL, or choose a different workflow.
  ```
  Prompt for URL or re-present Question 2
- Detect base branch:
  ```bash
  git remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}'
  ```
  If detected, use it. Otherwise default to `"main"`.
- Store:
  - `git_workflow = "github-flow"`
  - `git_base_branch = "{detected or main}"`
  - `git_merge_method = "squash"`
  - `git_auto_push = true`
  - `git_auto_pr = true`
  - `git_ci_checks = true`
  - `git_delete_branch_on_merge = true`
  - `git_update_branch_when_behind = true`
  - `git_require_pr_before_next_phase = true`
  - `git_require_reviews = false`
  - `git_worktree_isolation = false`
- Skip Questions 3 and 4 — GitHub Flow defaults handle them

**If "2" (Feature branch per phase):**
- Store `git_workflow = "legacy"`, `git_branching = "feature-per-phase"`
- Continue to Questions 3 and 4

**If "3" (Direct to main):**
- Store `git_workflow = "legacy"`, `git_branching = "direct-to-main"`
- Set `git_worktree_isolation = false`, `git_auto_push = false`, `git_auto_pr = false`, `git_ci_checks = false`
- Skip Questions 3 and 4 — direct-to-main has no branch isolation or remote automation
- Display: "Direct-to-main workflow — branch isolation and automation questions skipped."

**Question 3 — Worktree Isolation (only for feature-per-phase workflow):**

Note: This question is ONLY asked when the user chose "Feature branch per phase" (option 2). It is skipped for GitHub Flow (handled by defaults) and Direct to main (no branch isolation needed).

```
Use git worktrees during APPLY phase?
This creates an isolated copy for each phase — if something goes wrong,
discard the worktree instead of reverting commits.
[2] Yes — isolate each APPLY phase in a worktree
```
Wait for user response.
- If "1" or Enter: Store `git_worktree_isolation = false`
- If "2": Store `git_worktree_isolation = true`
**Question 4 — Automation (only for feature-per-phase workflow with GH remote):**

Note: This question is ONLY asked when ALL of these are true:
- User chose "Feature branch per phase" (option 2)
- `git_remote` is not null (a GitHub remote was configured)

Skipped when: direct-to-main (no branches to PR), no remote (can't push/PR), or GitHub Flow (handled by defaults).

```
Git automation? (Enter to accept defaults)
Auto-create PR on phase transition:  [yes/NO]
Wait for CI checks before merge:     [yes/NO]
```
- Defaults are NO for all (conservative)
- Accept "yes" or "y" to enable each
- Store as `git_auto_push`, `git_auto_pr`, `git_ci_checks`
**If skipped** (no remote or direct-to-main): Set `git_auto_push = false`, `git_auto_pr = false`, `git_ci_checks = false`.

**Update pals.json git section with gathered values:**

**If github-flow:**
```json
"git": {
  "workflow": "github-flow",
  "remote": "{git_remote}",
  "base_branch": "{git_base_branch}",
  "merge_method": "squash",
  "worktree_isolation": false,
  "auto_push": true,
  "auto_pr": true,
  "ci_checks": true,
  "delete_branch_on_merge": true,
  "update_branch_when_behind": true,
  "require_pr_before_next_phase": true,
  "require_reviews": false
}
```

**If legacy:**
```json
"git": {
  "workflow": "legacy",
  "remote": "{git_remote or null}",
  "branching": "{git_branching}",
  "worktree_isolation": {git_worktree_isolation},
  "auto_push": {git_auto_push},
  "auto_pr": {git_auto_pr},
  "ci_checks": {git_ci_checks}
}
```

**If none (no git repo):**
```json
"git": {
  "workflow": "none",
  "remote": null,
  "branching": "feature-per-phase",
  "worktree_isolation": false,
  "auto_push": false,
  "auto_pr": false,
  "ci_checks": false
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

{If quick_mode = true: "Mode: Quick init — all defaults applied"}

Created:
  .paul/PROJECT.md        ✓
  .paul/PRD.md            ✓
  .paul/ROADMAP.md        ✓
  .paul/STATE.md          ✓
  pals.json               ✓  ([N] modules enabled)
  AGENTS.md               ✓  (PALS workflow + boundaries)
  .paul/phases/           ✓

Milestone: v0.1 Initial Release (default — customize via /paul:milestone)

Git: [remote URL or "local only"] | {git_workflow} | push:[yes/no] PR:[yes/no] CI:[yes/no]
Planning default: {default_collaboration} | This run: {planning_mode}, {collaboration_level} collaboration

────────────────────────────────────────
▶ NEXT: /paul:plan — Define your phases and create your first plan.
────────────────────────────────────────

Type "yes" to proceed, or ask questions first.
```

**Note:** Only show Git line if `git_enabled = true`.
Always show pals.json with module count.
Integrations and specialized flows can be added later via `/paul:config` and `/paul:flows`.

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
