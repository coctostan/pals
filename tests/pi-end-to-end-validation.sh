#!/bin/bash
set -uo pipefail

# ════════════════════════════════════════
# PALS Pi End-to-End Validation Suite
# ════════════════════════════════════════
# Validates that the Pi driver installer correctly deploys all artifacts
# and that skills, extension, and manifest are structurally valid.
#
# Usage: bash tests/pi-end-to-end-validation.sh
# Output: TAP format (Test Anything Protocol)
# Exit: 0 if all pass, 1 if any fail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PASS=0
FAIL=0
TOTAL=0

# ── TAP helpers ──────────────────────────────────────────────────

tap_ok() {
  TOTAL=$((TOTAL + 1))
  PASS=$((PASS + 1))
  echo "ok $TOTAL - $1"
}

tap_not_ok() {
  TOTAL=$((TOTAL + 1))
  FAIL=$((FAIL + 1))
  echo "not ok $TOTAL - $1"
  if [ -n "${2:-}" ]; then
    echo "  # $2"
  fi
}

tap_check() {
  if [ "$2" -eq 0 ]; then
    tap_ok "$1"
  else
    tap_not_ok "$1" "${3:-}"
  fi
}

tap_file_contains_all() {
  local description="$1"
  local file="$2"
  shift 2

  if [ ! -f "$file" ]; then
    tap_not_ok "$description" "File not found: $file"
    return
  fi

  local missing=()
  local pattern
  for pattern in "$@"; do
    if ! grep -Fq -- "$pattern" "$file" 2>/dev/null; then
      missing+=("$pattern")
    fi
  done

  if [ "${#missing[@]}" -eq 0 ]; then
    tap_ok "$description"
  else
    tap_not_ok "$description" "Missing marker(s): ${missing[*]}"
  fi
}

tap_file_contains_none() {
  local description="$1"
  local file="$2"
  shift 2

  if [ ! -f "$file" ]; then
    tap_not_ok "$description" "File not found: $file"
    return
  fi

  local present=()
  local pattern
  for pattern in "$@"; do
    if grep -Fq -- "$pattern" "$file" 2>/dev/null; then
      present+=("$pattern")
    fi
  done

  if [ "${#present[@]}" -eq 0 ]; then
    tap_ok "$description"
  else
    tap_not_ok "$description" "Unexpected marker(s): ${present[*]}"
  fi
}

tap_hot_workflow_line_ceiling() {
  local description="$1"
  local ceiling="$2"
  shift 2

  local total=0
  local file
  for file in "$@"; do
    if [ ! -f "$file" ]; then
      tap_not_ok "$description" "File not found: $file"
      return
    fi

    local count
    count=$(wc -l < "$file" | tr -d ' ')
    total=$((total + count))
  done

  if [ "$total" -le "$ceiling" ]; then
    tap_ok "$description"
  else
    tap_not_ok "$description" "Hot workflow total $total exceeds ceiling $ceiling"
  fi
}

tap_file_line_ceiling() {
  local description="$1"
  local file="$2"
  local ceiling="$3"

  if [ ! -f "$file" ]; then
    tap_not_ok "$description" "File not found: $file"
    return
  fi

  local count
  count=$(wc -l < "$file" | tr -d ' ')
  if [ "$count" -le "$ceiling" ]; then
    tap_ok "$description"
  else
    tap_not_ok "$description" "$file has $count lines; ceiling is $ceiling"
  fi
}

tap_pattern_count_at_most() {
  local description="$1"
  local pattern="$2"
  local ceiling="$3"
  shift 3

  local count=0
  local file
  for file in "$@"; do
    if [ ! -e "$file" ]; then
      tap_not_ok "$description" "Path not found: $file"
      return
    fi
  done

  count=$(grep -R "$pattern" "$@" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$count" -le "$ceiling" ]; then
    tap_ok "$description"
  else
    tap_not_ok "$description" "Pattern count $count exceeds ceiling $ceiling for $pattern"
  fi
}

section() {
  echo ""
  echo "# ════════════════════════════════════════"
  echo "# $1"
  echo "# ════════════════════════════════════════"
}

# ── Cleanup trap ─────────────────────────────────────────────────

TEMP_DIRS=()
cleanup() {
  for d in "${TEMP_DIRS[@]}"; do
    rm -rf "$d" 2>/dev/null || true
  done
}
trap cleanup EXIT

# ── Expected skills ──────────────────────────────────────────────

EXPECTED_SKILLS=(
  paul-apply
  paul-discuss
  paul-fix
  paul-help
  paul-init
  paul-milestone
  paul-pause
  paul-plan
  paul-resume
  paul-status
  paul-unify
)

# ════════════════════════════════════════════════════════════════════
# CATEGORY 1: INSTALLER DEPLOYMENT
# ════════════════════════════════════════════════════════════════════

section "INSTALLER DEPLOYMENT"

# Create temp HOME and run Pi installer
TEMP_HOME="$(mktemp -d)"
TEMP_DIRS+=("$TEMP_HOME")
mkdir -p "$TEMP_HOME/.pi"

PI_OUTPUT="$(PALS_ROOT="$REPO_ROOT" HOME="$TEMP_HOME" bash "$REPO_ROOT/drivers/pi/install.sh" 2>&1)" || true
PI_EXIT=$?
tap_check "Pi installer exits successfully" "$PI_EXIT" "Exit code: $PI_EXIT"

SKILL_DIR="$TEMP_HOME/.pi/agent/skills/pals"

# Check skill directory exists
if [ -d "$SKILL_DIR" ]; then
  tap_ok "Skill directory created: ~/.pi/agent/skills/pals/"
else
  tap_not_ok "Skill directory created" "Directory not found"
fi

# Check kernel subdirs have files
for subdir in workflows references templates rules; do
  if [ -d "$SKILL_DIR/$subdir" ]; then
    COUNT=$(find "$SKILL_DIR/$subdir" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [ "$COUNT" -gt 0 ]; then
      tap_ok "Kernel $subdir installed: $COUNT files"
    else
      tap_not_ok "Kernel $subdir installed" "Directory exists but empty"
    fi
  else
    tap_not_ok "Kernel $subdir installed" "Directory not found"
  fi
done

# Check all 11 skill directories exist with SKILL.md
SKILL_COUNT=0
for skill in "${EXPECTED_SKILLS[@]}"; do
  if [ -f "$SKILL_DIR/$skill/SKILL.md" ]; then
    SKILL_COUNT=$((SKILL_COUNT + 1))
  fi
done

if [ "$SKILL_COUNT" -eq 11 ]; then
  tap_ok "All 11 skill directories installed with SKILL.md"
else
  tap_not_ok "All 11 skill directories installed with SKILL.md" "Found $SKILL_COUNT of 11"
fi

# Check modules.yaml generated
if [ -f "$SKILL_DIR/modules.yaml" ]; then
  MOD_COUNT=$(grep -cE '^  [a-z]+:' "$SKILL_DIR/modules.yaml" 2>/dev/null || echo 0)
  tap_ok "modules.yaml generated with $MOD_COUNT modules"
else
  tap_not_ok "modules.yaml generated" "File not found"
fi

if [ -f "$SKILL_DIR/modules.yaml" ]; then
  if grep -q '^    hook_details:' "$SKILL_DIR/modules.yaml" \
    && grep -q '^      pre-plan:' "$SKILL_DIR/modules.yaml" \
    && grep -q 'references/tdd-detection.md' "$SKILL_DIR/modules.yaml" \
    && grep -q 'references/quality-runner.md' "$SKILL_DIR/modules.yaml"; then
    tap_ok "modules.yaml includes runtime hook metadata and refs"
  else
    tap_not_ok "modules.yaml includes runtime hook metadata and refs" "Expected hook_details with TODD/WALT refs in installed registry"
  fi
fi

tap_file_contains_all \
  "Installed modules.yaml preserves CODI source-selector and success-log markers" \
  "$SKILL_DIR/modules.yaml" \
  'source selectors' \
  'top-level function declarations' \
  'exported const / arrow bindings' \
  '.tsx' \
  '.jsx' \
  'stable identifiers surfaced' \
  'resolved-with-call-sites only'

# ════════════════════════════════════════════════════════════════════
# CATEGORY 1B: MODULE EXECUTION EVIDENCE
# ════════════════════════════════════════════════════════════════════

section "MODULE EXECUTION EVIDENCE"

if [ -f "$SKILL_DIR/modules.yaml" ]; then
  if grep -q '^  walt:' "$SKILL_DIR/modules.yaml" \
    && grep -q '^  skip:' "$SKILL_DIR/modules.yaml" \
    && grep -q '^  ruby:' "$SKILL_DIR/modules.yaml" \
    && grep -q 'references/quality-history.md' "$SKILL_DIR/modules.yaml" \
    && grep -q 'references/knowledge-search.md' "$SKILL_DIR/modules.yaml" \
    && grep -q 'references/refactor-patterns.md' "$SKILL_DIR/modules.yaml"; then
    tap_ok "Installed Pi modules.yaml preserves post-unify metadata for durable evidence modules"
  else
    tap_not_ok "Installed Pi modules.yaml preserves post-unify metadata for durable evidence modules" "Expected WALT/SKIP/RUBY post-unify refs in installed Pi registry"
  fi
else
  tap_not_ok "Installed Pi modules.yaml preserves post-unify metadata for durable evidence modules" "modules.yaml missing from installed Pi skill dir"
fi

PI_UNIFY="$SKILL_DIR/workflows/unify-phase.md"
PI_FIX="$SKILL_DIR/workflows/fix-loop.md"
PI_SUMMARY_TEMPLATE="$SKILL_DIR/templates/SUMMARY.md"

if [ -f "$PI_UNIFY" ] && [ -f "$PI_FIX" ] && [ -f "$PI_SUMMARY_TEMPLATE" ] \
  && grep -q 'finalize_summary' "$PI_UNIFY" \
  && grep -q 'module_reports' "$PI_UNIFY" \
  && grep -q 'FIX-SUMMARY' "$PI_FIX" \
  && grep -q 'module_reports' "$PI_FIX" \
  && grep -q 'Module Execution Reports' "$PI_SUMMARY_TEMPLATE"; then
  tap_ok "Installed Pi kernel preserves the durable summary evidence path"
else
  tap_not_ok "Installed Pi kernel preserves the durable summary evidence path" "Expected finalize_summary/module_reports markers in installed Pi workflows and summary template"
fi

# Check extension installed
EXT_PATH="$TEMP_HOME/.pi/agent/extensions/pals-hooks.ts"
if [ -f "$EXT_PATH" ]; then
  tap_ok "Extension installed: ~/.pi/agent/extensions/pals-hooks.ts"
else
  tap_not_ok "Extension installed" "pals-hooks.ts not found in extensions dir"
fi

AGENT_DIR="$TEMP_HOME/.pi/agent/agents"
IMPLEMENTER_AGENT="$AGENT_DIR/pals-implementer.md"

tap_file_contains_all \
  "Pi installer source copies repo-local agents into ~/.pi/agent/agents/" \
  "$REPO_ROOT/drivers/pi/install.sh" \
  'PI_AGENTS_DIR="$PALS_ROOT/.pi/agents"' \
  'AGENT_DIR="$HOME/.pi/agent/agents"' \
  'cp "$agent_path" "$AGENT_DIR/$(basename "$agent_path")"'

tap_file_contains_all \
  "Pi installer source documents the bounded CODI no-index recommendation" \
  "$REPO_ROOT/drivers/pi/install.sh" \
  '.codegraph' \
  'CODI is enabled but no codegraph index detected'

if [ -f "$IMPLEMENTER_AGENT" ]; then
  tap_ok "Pi installer installs ~/.pi/agent/agents/pals-implementer.md"
else
  tap_not_ok "Pi installer installs ~/.pi/agent/agents/pals-implementer.md" "File not found"
fi

tap_file_contains_all \
  "Installed pals-implementer agent preserves bounded parent-authority contract markers" \
  "$IMPLEMENTER_AGENT" \
  'Your parent APPLY workflow is authoritative' \
  'single bounded task or sequential task step' \
  'Treat the parent prompt as authoritative' \
  'Do not edit `.paul/*` lifecycle files' \
  'non-equivalent outcomes as reasons to stop and return control' \
  'Return control to the parent immediately when:'

# ════════════════════════════════════════════════════════════════════
# CATEGORY 2: SKILL STRUCTURAL VALIDITY
# ════════════════════════════════════════════════════════════════════

section "SKILL STRUCTURAL VALIDITY"

for skill in "${EXPECTED_SKILLS[@]}"; do
  SKILL_FILE="$SKILL_DIR/$skill/SKILL.md"

  if [ ! -f "$SKILL_FILE" ]; then
    tap_not_ok "$skill: SKILL.md exists" "File not found"
    continue
  fi

  # Check frontmatter exists (starts with ---)
  FIRST_LINE=$(head -1 "$SKILL_FILE" | tr -d '[:space:]')
  if [ "$FIRST_LINE" = "---" ]; then
    tap_ok "$skill: has YAML frontmatter"
  else
    tap_not_ok "$skill: has YAML frontmatter" "First line is not ---"
  fi

  # Check name field in frontmatter
  if head -20 "$SKILL_FILE" | grep -q '^name:'; then
    tap_ok "$skill: frontmatter has name field"
  else
    tap_not_ok "$skill: frontmatter has name field" "name: not found in frontmatter"
  fi

  # Check description field in frontmatter
  if head -20 "$SKILL_FILE" | grep -q '^description:'; then
    tap_ok "$skill: frontmatter has description field"
  else
    tap_not_ok "$skill: frontmatter has description field" "description: not found in frontmatter"
  fi

  # Check workflow reference (should reference at least one kernel workflow)
  if grep -q 'workflow' "$SKILL_FILE" 2>/dev/null; then
    tap_ok "$skill: references workflow files"
  else
    tap_not_ok "$skill: references workflow files" "No workflow reference found"
  fi
done

# ════════════════════════════════════════════════════════════════════
# CATEGORY 2A: THIN WRAPPER CONTRACT
# ════════════════════════════════════════════════════════════════════

section "THIN WRAPPER CONTRACT"

CORE_WRAPPER_SKILLS=(
  paul-apply
  paul-discuss
  paul-fix
  paul-init
  paul-milestone
  paul-pause
  paul-plan
  paul-resume
  paul-status
  paul-unify
)

for skill in "${CORE_WRAPPER_SKILLS[@]}"; do
  tap_file_contains_none \
    "Installed $skill wrapper omits duplicated read-bundle scaffolding" \
    "$SKILL_DIR/$skill/SKILL.md" \
    'Read project state:'
done

tap_file_contains_all \
  "Installed Pi apply skill keeps explicit approval and parent-owned APPLY guardrails in the thin wrapper" \
  "$SKILL_DIR/paul-apply/SKILL.md" \
  'explicit user approval' \
  'pals-implementer' \
  'single-task work the parent can still verify' \
  'official verify steps' \
  'module enforcement' \
  '.paul/*'

tap_file_contains_all \
  "Installed Pi discuss skill keeps collaboration-aware discussion semantics in the thin wrapper" \
  "$SKILL_DIR/paul-discuss/SKILL.md" \
  'planning.default_collaboration' \
  'exploratory' \
  'direct-requirements' \
  '4-option review menu'

tap_file_contains_all \
  "Installed Pi init skill keeps layered onboarding guardrails in the thin wrapper" \
  "$SKILL_DIR/paul-init/SKILL.md" \
  'greenfield' \
  'brownfield' \
  'planning.default_collaboration' \
  'one question at a time'

tap_file_contains_all \
  "Installed Pi milestone skill keeps create/complete routing semantics in the thin wrapper" \
  "$SKILL_DIR/paul-milestone/SKILL.md" \
  'create-milestone' \
  'complete-milestone' \
  'MILESTONE-CONTEXT.md'

tap_file_contains_all \
  "Installed Pi pause skill keeps self-contained handoff semantics in the thin wrapper" \
  "$SKILL_DIR/paul-pause/SKILL.md" \
  'HANDOFF' \
  'no prior context' \
  'git state' \
  'STATE.md'

tap_file_contains_all \
  "Installed Pi plan skill keeps collaboration and review-menu semantics in the thin wrapper" \
  "$SKILL_DIR/paul-plan/SKILL.md" \
  'planning.default_collaboration' \
  'exploratory' \
  'direct-requirements' \
  '4-option review menu'

tap_file_contains_all \
  "Installed Pi resume skill keeps authoritative single-next routing semantics in the thin wrapper" \
  "$SKILL_DIR/paul-resume/SKILL.md" \
  'STATE.md remains authoritative' \
  'exactly one next action' \
  '.paul/handoffs/archive/' \
  'Archive an active consumed handoff'

tap_file_contains_all \
  "Installed Pi status skill keeps read-only git-aware routing semantics in the thin wrapper" \
  "$SKILL_DIR/paul-status/SKILL.md" \
  'Read-only wrapper' \
  'github-flow' \
  'exactly one next action'

tap_file_contains_all \
  "Installed Pi fix skill keeps quick-fix mode semantics in the thin wrapper" \
  "$SKILL_DIR/paul-fix/SKILL.md" \
  'standard' \
  'fast-forward' \
  'hotfix' \
  'STATE.md'

tap_file_contains_all \
  "Installed Pi unify skill keeps reconciliation semantics in the thin wrapper" \
  "$SKILL_DIR/paul-unify/SKILL.md" \
  'SUMMARY.md' \
  'deviations' \
  'ROADMAP.md'

# ════════════════════════════════════════════════════════════════════
# CATEGORY 2B: DELEGATED APPLY / REV BOUNDARIES
# ════════════════════════════════════════════════════════════════════

section "DELEGATED APPLY / REV BOUNDARIES"

tap_file_contains_all \
  "Installed Pi apply skill documents repo-local pals-implementer delegation under parent authority" \
  "$SKILL_DIR/paul-apply/SKILL.md" \
  'pals-implementer' \
  'single-task work the parent can still verify' \
  'official verify steps' \
  'module enforcement' \
  '.paul/*'
tap_file_contains_all \
  "Installed shared apply workflow routes delegated APPLY through pals-implementer with parent-owned guardrails" \
  "$SKILL_DIR/workflows/apply-phase.md" \
  'subagent_type: "pals-implementer"' \
  '.pi/agents/pals-implementer.md' \
  'lifecycle reminder' \
  'parent owns verification, module gates, fallback, and state/report writes' \
  'delegation may be used for a single eligible task or sequential task step' \
  'ambiguous, exploratory, cross-repo, checkpointed, or non-equivalent work stays inline'

PI_INIT_WORKFLOW="$SKILL_DIR/workflows/init-project.md"
PI_SCHEMA_REF="$SKILL_DIR/references/pals-json-schema.md"

tap_file_contains_all \
  "Installed shared init workflow emits explicit implementer config defaults" \
  "$PI_INIT_WORKFLOW" \
  '"agents": {' \
  '"implementer": { "enabled": true, "model": null }' \
  '**agents:** Add `agents.implementer: { "enabled": true, "model": null }` if missing'

tap_file_contains_all \
  "Installed shared schema reference documents implementer config fields" \
  "$PI_SCHEMA_REF" \
  '## agents' \
  '`agents.implementer.enabled`' \
  '`agents.implementer.model`' \
  'Migration should add this block when missing'

tap_file_contains_all \
  "Shared review command keeps REV entry routed through /paul:review" \
  "$REPO_ROOT/kernel/commands/paul/review.md" \
  '/paul:review'

tap_file_contains_all \
  "Installed Pi review skill keeps REV on the code-reviewer, on-demand path" \
  "$SKILL_DIR/paul-review/SKILL.md" \
  'code-reviewer' \
  'On-demand only' \
  'NOT a lifecycle hook'


tap_file_contains_all \
  "Installed Pi review skill points at installed review prompt/checklist refs" \
  "$SKILL_DIR/paul-review/SKILL.md" \
  "$SKILL_DIR/references/review-prompt.md" \
  "$SKILL_DIR/references/review-checklist.md"

# ════════════════════════════════════════════════════════════════════
# CATEGORY 2C: SHARED WORKFLOW PROSE CONTRACT
# ════════════════════════════════════════════════════════════════════

section "SHARED WORKFLOW PROSE CONTRACT"

PI_ROADMAP="$SKILL_DIR/workflows/roadmap-management.md"
PI_PLAN="$SKILL_DIR/workflows/plan-phase.md"
PI_DISCUSS="$SKILL_DIR/workflows/discuss-phase.md"
PI_MILESTONE="$SKILL_DIR/workflows/create-milestone.md"
PI_APPLY="$SKILL_DIR/workflows/apply-phase.md"
PI_UNIFY="$SKILL_DIR/workflows/unify-phase.md"
PI_MODULE_DISPATCH="$SKILL_DIR/references/module-dispatch.md"
PI_GIT_STRATEGY="$SKILL_DIR/references/git-strategy.md"
HOT_WORKFLOW_LINE_CEILING=1711

tap_file_contains_all \
  "Installed shared roadmap workflow keeps slice-based status routing markers after prose cleanup" \
  "$PI_ROADMAP" \
  'git-aware routing' \
  'current milestone section' \
  'exactly ONE'

tap_file_contains_none \
  "Installed shared roadmap workflow drops the older numbered-option warning wording" \
  "$PI_ROADMAP" \
  'Do NOT show numbered options (1, 2, 3, 4).'

tap_file_contains_all \
  "Installed shared plan workflow keeps targeted-read and review-menu markers after prose cleanup" \
  "$PI_PLAN" \
  'target phase detail' \
  'planning.default_collaboration' \
  'Would you like to see the plan?'

tap_file_contains_all \
  "Installed shared discuss workflow keeps selected-phase posture markers after prose cleanup" \
  "$PI_DISCUSS" \
  'selected phase detail' \
  'planning.default_collaboration' \
  'direct-requirements'

tap_file_contains_none \
  "Installed shared discuss workflow drops older explanatory filler around phase-context setup" \
  "$PI_DISCUSS" \
  'This gives user context for the discussion.' \
  'This workflow gathers USER input about the phase.'

tap_file_contains_all \
  "Installed shared milestone workflow keeps one-question-at-a-time and review markers after prose cleanup" \
  "$PI_MILESTONE" \
  'one question at a time' \
  'planning.default_collaboration' \
  'Would you like to see the plan before I update ROADMAP.md?' 

# ════════════════════════════════════════════════════════════════════
# CATEGORY 2C: CONTEXT-DIET REGRESSION GUARDRAILS
# ════════════════════════════════════════════════════════════════════

section "CONTEXT-DIET REGRESSION GUARDRAILS"

# Phase 191 anti-regrowth budgets. These protect structural context-diet gains
# without pinning long prose: active ROADMAP window <=120 lines; the post-190
# source hot workflow/reference set was 1901 lines, so 2100 allows small edits
# while catching broad regrowth; duplicated inline GitHub Flow jq extraction
# should stay sparse after git-strategy.md centralization.
ACTIVE_ROADMAP_LINE_CEILING=120
HOT_CONTEXT_SOURCE_SET_LINE_CEILING=2100
GITHUB_FLOW_JQ_DUPLICATION_CEILING=6
REPO_ROADMAP="$REPO_ROOT/.paul/ROADMAP.md"
REPO_PLAN_WORKFLOW="$REPO_ROOT/kernel/workflows/plan-phase.md"
REPO_APPLY_WORKFLOW="$REPO_ROOT/kernel/workflows/apply-phase.md"
REPO_UNIFY_WORKFLOW="$REPO_ROOT/kernel/workflows/unify-phase.md"
REPO_MODULE_DISPATCH="$REPO_ROOT/kernel/references/module-dispatch.md"
REPO_GIT_STRATEGY="$REPO_ROOT/kernel/references/git-strategy.md"

tap_file_line_ceiling \
  "Repo ROADMAP stays within active-window line budget" \
  "$REPO_ROADMAP" \
  "$ACTIVE_ROADMAP_LINE_CEILING"

tap_file_contains_all \
  "Repo ROADMAP keeps authoritative completed-history archive pointers" \
  "$REPO_ROADMAP" \
  '.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md' \
  '.paul/MILESTONES.md' \
  'Detailed completed milestone history through v2.43 is archived'

tap_hot_workflow_line_ceiling \
  "Repo source hot workflow/reference set stays under post-190 anti-regrowth budget" \
  "$HOT_CONTEXT_SOURCE_SET_LINE_CEILING" \
  "$REPO_PLAN_WORKFLOW" \
  "$REPO_APPLY_WORKFLOW" \
  "$REPO_UNIFY_WORKFLOW" \
  "$REPO_MODULE_DISPATCH" \
  "$REPO_GIT_STRATEGY" \
  "$REPO_ROADMAP"

tap_pattern_count_at_most \
  "Repo workflows keep duplicated inline GitHub Flow jq extraction bounded" \
  'jq -r.*\.git' \
  "$GITHUB_FLOW_JQ_DUPLICATION_CEILING" \
  "$REPO_ROOT/kernel/workflows"

tap_hot_workflow_line_ceiling \
  "Installed hot PLAN/APPLY/UNIFY workflows stay under the Phase 186 pre-compression ceiling" \
  "$HOT_WORKFLOW_LINE_CEILING" \
  "$PI_PLAN" \
  "$PI_APPLY" \
  "$PI_UNIFY"

tap_hot_workflow_line_ceiling \
  "Installed hot workflow/reference set stays under post-190 anti-regrowth budget" \
  "$HOT_CONTEXT_SOURCE_SET_LINE_CEILING" \
  "$PI_PLAN" \
  "$PI_APPLY" \
  "$PI_UNIFY" \
  "$PI_MODULE_DISPATCH" \
  "$PI_GIT_STRATEGY"

tap_file_contains_all \
  "Installed plan workflow keeps targeted-read and review-menu guardrails" \
  "$PI_PLAN" \
  'target phase detail' \
  'planning.default_collaboration' \
  'Would you like to see the plan?'

tap_file_contains_all \
  "Installed apply workflow keeps parent-owned APPLY and checkpoint guardrails" \
  "$PI_APPLY" \
  'parent owns verification, module gates, fallback, and state/report writes' \
  'subagent_type: "pals-implementer"' \
  'checkpoint:*' \
  'ambiguous, exploratory, cross-repo, checkpointed, or non-equivalent work stays inline'

tap_file_contains_all \
  "Installed unify workflow keeps post-unify evidence and GitHub Flow merge-gate guardrails" \
  "$PI_UNIFY" \
  'post-unify' \
  'Module Execution Reports' \
  'MERGE GATE' \
  'gh pr checks' \
  'gh pr merge' \
  'modules.yaml NOT FOUND'

tap_file_contains_all \
  "Installed module-dispatch reference keeps shared evidence-contract guardrails" \
  "$PI_MODULE_DISPATCH" \
  'Workflow Call-Site Contract' \
  'Durable Evidence Requirements' \
  'Project Config vs Installed Registry' \
  'Do not restate generic registry mechanics'


tap_file_contains_all \
  "Installed git-strategy reference keeps shared GitHub Flow ownership markers" \
  "$PI_GIT_STRATEGY" \
  'GitHub Flow' \
  'GIT_WORKFLOW' \
  'auto_pr' \
  'merge gate'

# ════════════════════════════════════════════════════════════════════
# CATEGORY 2C: CODI PLAN-PHASE DISTRIBUTION
# ════════════════════════════════════════════════════════════════════

section "CODI PLAN-PHASE DISTRIBUTION"

PI_PLAN_WORKFLOW="$SKILL_DIR/workflows/plan-phase.md"
PI_INIT_WORKFLOW="$SKILL_DIR/workflows/init-project.md"
PI_SCHEMA_REF="$SKILL_DIR/references/pals-json-schema.md"
PI_CODI_REF="$SKILL_DIR/references/codi.md"
README_MAIN="$REPO_ROOT/README.md"
PALS_JSON="$REPO_ROOT/pals.json"

tap_file_contains_all \
  "Installed shared plan workflow keeps CODI source-selector markers" \
  "$PI_PLAN_WORKFLOW" \
  'codi_seed_candidates' \
  'upcoming plan context block' \
  'source selectors' \
  'source-file mention order' \
  'declaration order within each file' \
  'stable extracted identifiers' \
  'CODI may skip cleanly and planning continues'

tap_file_contains_all \
  "Installed shared init workflow exposes CODI default-on config guidance" \
  "$PI_INIT_WORKFLOW" \
  '"codi": { "enabled": true, "description": "Codegraph-driven structural injection (safe skip when codegraph is unavailable)" }' \
  'includes CODI safe-skip planning support'

tap_file_contains_all \
  "Installed shared schema reference documents CODI config fields" \
  "$PI_SCHEMA_REF" \
  '`modules.codi.enabled`' \
  '`modules.codi.description`' \
  'CODI is safe to leave enabled by default'

tap_file_contains_all \
  "Installed CODI reference keeps source-selector, value-envelope, and safe-setup markers" \
  "$PI_CODI_REF" \
  'When CODI helps' \
  'TS/JS-touching indexed code' \
  'boundary specificity' \
  'resolved-with-call-sites only' \
  'source selectors' \
  'top-level function declarations' \
  'exported const / arrow bindings' \
  'source-file mention order' \
  'declaration order within each file' \
  'stable identifiers surfaced' \
  'pi-codegraph' \
  '.codegraph/' \
  'CODI is enabled but no codegraph index detected' \
  'planning continues cleanly'

tap_file_contains_all \
  "README keeps the CODI user-facing setup contract" \
  "$README_MAIN" \
  '### CODI setup (optional)' \
  'modules.codi.enabled' \
  'TS/JS-touching indexed code' \
  'boundary specificity' \
  'pi-codegraph' \
  '.codegraph/' \
  'CODI is enabled but no codegraph index detected' \
  'planning continues cleanly'

tap_file_contains_all \
  "Repo pals.json dogfoods the CODI default-on block" \
  "$PALS_JSON" \
  '"codi": {' \
  'Codegraph-driven structural injection (safe skip when codegraph is unavailable)'

# Phase 176: CODI post-unify dispatch-outcome instrumentation
PI_CODI_INSTRUMENTATION_REF="$SKILL_DIR/references/codi-instrumentation.md"

tap_file_contains_all \
  "Installed modules.yaml carries CODI post-unify dispatch-outcome instrumentation hook" \
  "$SKILL_DIR/modules.yaml" \
  'CODI-HISTORY.md' \
  'references/codi-instrumentation.md' \
  'no-dispatch-found' \
  'post_unify_hooks' \
  'finalize_summary'

if [ -f "$PI_CODI_INSTRUMENTATION_REF" ]; then
  tap_ok "Installed CODI instrumentation reference exists at $PI_CODI_INSTRUMENTATION_REF"
else
  tap_not_ok "Installed CODI instrumentation reference exists" "File not found: $PI_CODI_INSTRUMENTATION_REF"
fi

tap_file_contains_all \
  "Installed CODI instrumentation reference documents schema, taxonomy, and read order" \
  "$PI_CODI_INSTRUMENTATION_REF" \
  '## Outcome taxonomy' \
  '## Data-source read order' \
  '## Plan-path resolution' \
  '## Hotfix behavior' \
  'no-dispatch-found' \
  'CODI-HISTORY.md' \
  '| Plan | Date | Outcome | R | U | K | Symbols | blast_radius |'

tap_file_contains_all \
  "CODI-HISTORY.md literal appears in both installed manifest and instrumentation ref" \
  "$PI_CODI_INSTRUMENTATION_REF" \
  '.paul/CODI-HISTORY.md' \
  'modules/codi/module.yaml post-unify hook'

# Phase 176 drift guard: all 5 pre-plan skip-log strings + success-log template
# must remain verbatim in the installed CODI manifest so the post-unify parser
# never silently falls through to no-dispatch-found on a renamed token.
tap_file_contains_all \
  "Installed CODI manifest preserves all pre-plan skip-log strings (drift guard)" \
  "$SKILL_DIR/modules.yaml" \
  'no extractable symbols in phase scope' \
  'codegraph tools unavailable' \
  'impact loop errored:' \
  'impact returned empty blast radius for all symbols' \
  'impact × N symbols → R resolved, U unresolved, K total call-sites, injected blast_radius'
# ════════════════════════════════════════════════════════════════════
# CATEGORY 3: EXTENSION STRUCTURAL VALIDITY
# ════════════════════════════════════════════════════════════════════

section "EXTENSION STRUCTURAL VALIDITY"

# Use source file for structural checks (same content as installed)
EXT_SRC="$REPO_ROOT/drivers/pi/extensions/pals-hooks.ts"

if [ ! -f "$EXT_SRC" ]; then
  tap_not_ok "Extension source exists" "pals-hooks.ts not found in repo"
else
  tap_ok "Extension source exists"

  # Check default export
  if grep -q 'export default function' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension exports default function"
  else
    tap_not_ok "Extension exports default function" "No 'export default function' found"
  fi

  # Check all 11 command registrations
  CMD_COUNT=0
  for skill in "${EXPECTED_SKILLS[@]}"; do
    # Commands use paul-* format (matching the name field in COMMANDS array)
    if grep -q "\"$skill\"" "$EXT_SRC" 2>/dev/null; then
      CMD_COUNT=$((CMD_COUNT + 1))
    fi
  done

  if [ "$CMD_COUNT" -eq 11 ]; then
    tap_ok "Extension registers all 11 /paul-* commands"
  else
    tap_not_ok "Extension registers all 11 /paul-* commands" "Found $CMD_COUNT of 11"
  fi

  # Check registerCommand usage
  REG_COUNT=$(grep -c 'registerCommand' "$EXT_SRC" 2>/dev/null || echo 0)
  if [ "$REG_COUNT" -gt 0 ]; then
    tap_ok "Extension uses registerCommand ($REG_COUNT calls)"
  else
    tap_not_ok "Extension uses registerCommand" "No registerCommand calls found"
  fi

  # Check shortcut registration for lifecycle entry points
  SHORTCUT_COUNT=$(grep -c 'registerQuickActionShortcut\|registerShortcut' "$EXT_SRC" 2>/dev/null || echo 0)
  if [ "$SHORTCUT_COUNT" -gt 0 ] && grep -q 'Ctrl+Alt+N' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension registers shortcut-enabled lifecycle entry points"
  else
    tap_not_ok "Extension registers shortcut-enabled lifecycle entry points" "Expected registerShortcut usage and Ctrl+Alt shortcut hints in extension source"
  fi
  # Guardrail: quick-action layer stays intentionally bounded
  CTRL_ALT_COUNT=$(grep -o 'Key.ctrlAlt("[nsrhm]")' "$EXT_SRC" 2>/dev/null | sort -u | wc -l | tr -d ' ')
  if [ "$CTRL_ALT_COUNT" -eq 5 ] && grep -q 'PRIMARY_QUICK_ACTION_LIMIT = 3' "$EXT_SRC" 2>/dev/null && grep -q 'MAX_QUICK_ACTIONS = 5' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension keeps the quick-action layer bounded (3 primary, 5 total)"
  else
    tap_not_ok "Extension keeps the quick-action layer bounded (3 primary, 5 total)" "Expected 5 unique Ctrl+Alt shortcuts plus explicit primary/total limits in extension source"
  fi

  # Check session_start event handler
  if grep -q 'session_start' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension handles session_start event"
  else
    tap_not_ok "Extension handles session_start event" "No session_start handler found"
  fi

  # Check context event handler
  if grep -q '"context"' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension handles context event"
  else
    tap_not_ok "Extension handles context event" "No context handler found"
  fi

  # Check always-visible lifecycle surfaces are wired in
  if grep -q 'setStatus' "$EXT_SRC" 2>/dev/null && grep -q 'setWidget' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension uses setStatus + setWidget for persistent lifecycle UI"
  else
    tap_not_ok "Extension uses setStatus + setWidget for persistent lifecycle UI" "Expected both setStatus and setWidget in extension source"
  fi

  # Check lifecycle fields are surfaced in the adapter contract
  if grep -q 'Milestone:' "$EXT_SRC" 2>/dev/null && grep -q 'Phase:' "$EXT_SRC" 2>/dev/null && grep -q 'Loop:' "$EXT_SRC" 2>/dev/null && grep -q 'Next action:' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension surfaces milestone, phase, loop, and next action"
  else
    tap_not_ok "Extension surfaces milestone, phase, loop, and next action" "Expected lifecycle field labels in extension source"
  fi

  # Guardrail: the persistent widget stays limited to the calm 4-line lifecycle hierarchy
  if grep -q 'PALS Milestone:' "$EXT_SRC" 2>/dev/null \
    && grep -q 'Phase:' "$EXT_SRC" 2>/dev/null \
    && grep -q 'Loop:' "$EXT_SRC" 2>/dev/null \
    && grep -q 'Next action:' "$EXT_SRC" 2>/dev/null \
    && ! grep -q 'Actions:' "$EXT_SRC" 2>/dev/null \
    && ! grep -q 'More:' "$EXT_SRC" 2>/dev/null \
    && ! grep -q 'PALS Lifecycle' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension keeps the lifecycle widget aligned to the calm 4-line hierarchy"
  else
    tap_not_ok "Extension keeps the lifecycle widget aligned to the calm 4-line hierarchy" "Expected PALS Milestone/Phase/Loop/Next action labels and no legacy Actions:/More:/PALS Lifecycle widget copy in pals-hooks.ts"
  fi

  # Guardrail: lifecycle UI refreshes stay within approved Pi adapter events
  if grep -q 'before_agent_start' "$EXT_SRC" 2>/dev/null && grep -q 'turn_end' "$EXT_SRC" 2>/dev/null && grep -q 'agent_end' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension refreshes lifecycle UI on approved adapter events"
  else
    tap_not_ok "Extension refreshes lifecycle UI on approved adapter events" "Expected before_agent_start, turn_end, and agent_end refresh hooks"
  fi

  # Check canonical routing guidance is present
  if grep -q 'canonical /skill:paul-' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension documents canonical /skill:paul-* routing"
  else
    tap_not_ok "Extension documents canonical /skill:paul-* routing" "Expected canonical routing guidance in extension source"
  fi

  # Guardrail: primary injection is centered on before_agent_start
  if grep -q 'PRIMARY_INJECTION_EVENT = "before_agent_start"' "$EXT_SRC" 2>/dev/null && grep -q 'pi.on("before_agent_start"' "$EXT_SRC" 2>/dev/null && grep -q 'customType: PALS_CONTEXT_CUSTOM_TYPE' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension uses before_agent_start as the primary context injection point"
  else
    tap_not_ok "Extension uses before_agent_start as the primary context injection point" "Expected before_agent_start marker, handler, and PALS context custom message injection"
  fi

  # Guardrail: explicit command routing participates in activation model
  if grep -q 'ACTIVATION_SIGNAL_TAG' "$EXT_SRC" 2>/dev/null && grep -q 'markActivation("command"' "$EXT_SRC" 2>/dev/null && grep -q 'COMMAND_ACTIVATION_TURN_BUDGET' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension models explicit command activation as strongest signal"
  else
    tap_not_ok "Extension models explicit command activation as strongest signal" "Expected activation markers and command-signal tracking in extension source"
  fi

  # Guardrail: keep a single bounded automatic injection path with context as support-only
  PUSH_COUNT=$(grep -c 'messages.push' "$EXT_SRC" 2>/dev/null || true)
  PALS_CONTEXT_INJECTION_COUNT=$(grep -c 'customType: PALS_CONTEXT_CUSTOM_TYPE\|customType: "pals-context"' "$EXT_SRC" 2>/dev/null || true)
  if [ "$PUSH_COUNT" -eq 0 ] && [ "$PALS_CONTEXT_INJECTION_COUNT" -eq 1 ] && grep -q 'pi.on("context"' "$EXT_SRC" 2>/dev/null && grep -q 'keepOnlyLatestPalsContextMessage' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension keeps one bounded automatic injection path and a support-only context hook"
  else
    tap_not_ok "Extension keeps one bounded automatic injection path and a support-only context hook" "Expected 0 messages.push, exactly one pals-context injection definition, and context normalization support"
fi

  # Artifact-slice spike contract: activation-gated, source-cited, fresh, bounded, and fallback-safe.
  tap_file_contains_all \
    "Extension preserves artifact-slice context loading guardrails" \
    "$EXT_SRC" \
    'Artifact slices (read-only, bounded)' \
    'Source:' \
    'Freshness:' \
    'Fallback: full authoritative read' \
    'MAX_ARTIFACT_SLICE_CHARS' \
    'MAX_ARTIFACT_SLICE_LINES' \
    'shouldInjectPalsContext' \
    '.paul/STATE.md' \
    '.paul/ROADMAP.md'

  tap_file_contains_all \
    "Extension docs preserve artifact-slice citation/freshness/fallback contract" \
    "$REPO_ROOT/drivers/pi/extensions/README.md" \
    'Artifact-Slice Context Loading' \
    'source-cited' \
    'freshness-marked' \
    'full authoritative read' \
    'no hidden Pi state'

  tap_file_contains_all \
    "Skill map frames artifact slices as adapter-side context aid" \
    "$REPO_ROOT/drivers/pi/skill-map.md" \
    'adapter-side context aid' \
    'source-cited' \
    'freshness-marked' \
    'hidden Pi state' \
    'full authoritative read'

  # Guided workflow contract: detect canonical workflow markers from shared prompts
  if grep -q 'Continue to APPLY' "$EXT_SRC" 2>/dev/null && grep -q 'Continue to UNIFY' "$EXT_SRC" 2>/dev/null && grep -q 'CHECKPOINT:' "$EXT_SRC" 2>/dev/null && grep -q '▶ NEXT:' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension detects canonical workflow markers for guided UX"
  else
    tap_not_ok "Extension detects canonical workflow markers for guided UX" "Expected Continue to APPLY/UNIFY, CHECKPOINT, and ▶ NEXT markers in extension source"
  fi

  # Guided workflow contract: explicit Pi UI drives canonical continuation replies
  if grep -Eq 'ctx\.ui\.(confirm|select)' "$EXT_SRC" 2>/dev/null && grep -q 'sendUserMessage' "$EXT_SRC" 2>/dev/null && grep -q 'approved' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension routes guided workflow responses through explicit UI and canonical user messages"
  else
    tap_not_ok "Extension routes guided workflow responses through explicit UI and canonical user messages" "Expected confirm/select UI plus canonical sendUserMessage routing in extension source"
  fi

  # Guardrail: guided workflow state remains derived-only and non-persistent
  if ! grep -q 'appendEntry(' "$EXT_SRC" 2>/dev/null && grep -q 'sessionManager' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension keeps guided workflow interpretation derived-only and non-persistent"
  else
    tap_not_ok "Extension keeps guided workflow interpretation derived-only and non-persistent" "Expected session-derived inspection and no appendEntry-based workflow persistence"
  fi

  # Live module visibility contract: bounded parser/renderer path for canonical workflow signals
  if grep -q 'extractRecentModuleActivity' "$EXT_SRC" 2>/dev/null \
    && grep -q 'renderModuleActivity' "$EXT_SRC" 2>/dev/null \
    && grep -q '\[dispatch\]' "$EXT_SRC" 2>/dev/null \
    && grep -q 'Module Execution Reports' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension derives recent module activity from canonical dispatch/report markers"
  else
    tap_not_ok "Extension derives recent module activity from canonical dispatch/report markers" "Expected extractRecentModuleActivity/renderModuleActivity plus [dispatch]/Module Execution Reports markers in pals-hooks.ts"
  fi

  # Live module visibility contract: reuse the existing lifecycle status/widget surfaces
  if grep -q 'collectRecentAssistantTexts(ctx, undefined, RECENT_MODULE_ACTIVITY_LOOKBACK)' "$EXT_SRC" 2>/dev/null \
    && grep -q 'renderLifecycleStatus(state, recentModuleActivity)' "$EXT_SRC" 2>/dev/null \
    && grep -q 'renderLifecycleWidget(state, recentModuleActivity)' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension wires recent module activity into the existing lifecycle status/widget"
  else
    tap_not_ok "Extension wires recent module activity into the existing lifecycle status/widget" "Expected recent module activity derivation to flow through the existing status/widget rendering path"
  fi

  # Guardrail: module visibility remains derived-only, bounded, and non-persistent
  if ! grep -q 'appendEntry(' "$EXT_SRC" 2>/dev/null \
    && grep -q 'RECENT_MODULE_ACTIVITY_LOOKBACK' "$EXT_SRC" 2>/dev/null \
    && grep -q 'collectRecentAssistantTexts' "$EXT_SRC" 2>/dev/null; then
    tap_ok "Extension keeps live module visibility derived-only and bounded"
  else
    tap_not_ok "Extension keeps live module visibility derived-only and bounded" "Expected bounded recent-message derivation and no appendEntry-based module persistence in pals-hooks.ts"
  fi
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 4: DRIVER MANIFEST ACCURACY
# ════════════════════════════════════════════════════════════════════

section "DRIVER MANIFEST ACCURACY"

DRIVER_YAML="$REPO_ROOT/drivers/pi/driver.yaml"

if [ ! -f "$DRIVER_YAML" ]; then
  tap_not_ok "Pi driver.yaml exists" "File not found"
else
  tap_ok "Pi driver.yaml exists"

  # Check all 6 capability fields
  for cap in workflow_invoke hook_register state_read state_write user_interact command_register; do
    if grep -q "$cap:" "$DRIVER_YAML" 2>/dev/null; then
      tap_ok "Pi manifest declares $cap"
    else
      tap_not_ok "Pi manifest declares $cap" "Field not found"
    fi
  done

  # Check capabilities are true (v2.1 added hook_register and command_register)
  for cap in workflow_invoke hook_register state_read state_write user_interact command_register; do
    CAP_VAL=$(grep "$cap:" "$DRIVER_YAML" 2>/dev/null | awk '{print $2}')
    if [ "$CAP_VAL" = "true" ]; then
      tap_ok "Pi manifest $cap = true"
    else
      tap_not_ok "Pi manifest $cap = true" "Value is '$CAP_VAL'"
    fi
  done

  # Check framework_dir matches installer target
  if grep -q 'framework_dir.*\.pi/agent/skills/pals' "$DRIVER_YAML" 2>/dev/null; then
    tap_ok "Pi manifest framework_dir matches installer target"
  else
    tap_not_ok "Pi manifest framework_dir matches installer target" "Expected ~/.pi/agent/skills/pals"
  fi

  # Check install.sh and uninstall.sh exist
  if [ -f "$REPO_ROOT/drivers/pi/install.sh" ]; then
    tap_ok "Pi driver: install.sh exists"
  else
    tap_not_ok "Pi driver: install.sh exists" "File not found"
  fi

  if [ -f "$REPO_ROOT/drivers/pi/uninstall.sh" ]; then
    tap_ok "Pi driver: uninstall.sh exists"
  else
    tap_not_ok "Pi driver: uninstall.sh exists" "File not found"
  fi

  # Check driver description reflects canonical skills + extension layer
  if grep -q 'canonical skills plus extension-backed command and hook surfaces' "$DRIVER_YAML" 2>/dev/null; then
    tap_ok "Pi manifest description reflects skills + extension model"
  else
    tap_not_ok "Pi manifest description reflects skills + extension model" "Expected updated driver description in drivers/pi/driver.yaml"
  fi
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 5: PI DISCOVERY SURFACES
# ════════════════════════════════════════════════════════════════════

section "PI DISCOVERY SURFACES"

README_PI="$REPO_ROOT/drivers/pi/extensions/README.md"
SKILL_MAP="$REPO_ROOT/drivers/pi/skill-map.md"
HELP_SKILL="$REPO_ROOT/drivers/pi/skills/paul-help/SKILL.md"
PI_INSTALLER="$REPO_ROOT/drivers/pi/install.sh"

if grep -q '/paul-\*' "$README_PI" && grep -q '/skill:paul-\*' "$README_PI" && grep -q 'canonical' "$README_PI"; then
  tap_ok "Extension README explains /paul-* vs canonical /skill:paul-*"
else
  tap_not_ok "Extension README explains /paul-* vs canonical /skill:paul-*" "Expected wrapper/canonical guidance in drivers/pi/extensions/README.md"
fi

if grep -q 'Quick Actions & Shortcuts' "$README_PI" && grep -q 'Ctrl+Alt+N' "$README_PI"; then
  tap_ok "Extension README documents shortcut-enabled entry points"
else
  tap_not_ok "Extension README documents shortcut-enabled entry points" "Expected quick-action shortcut guidance in drivers/pi/extensions/README.md"
fi

if grep -q 'before_agent_start' "$README_PI" && grep -q 'context' "$README_PI" && grep -q 'activation' "$README_PI" && grep -q 'authoritative' "$README_PI"; then
  tap_ok "Extension README documents refined activation/injection responsibility split"
else
  tap_not_ok "Extension README documents refined activation/injection responsibility split" "Expected before_agent_start/context/activation/authoritative wording in drivers/pi/extensions/README.md"
fi

if grep -qi 'Guided Workflow UX' "$README_PI" && grep -qi 'checkpoint' "$README_PI" && grep -qi 'canonical reply' "$README_PI" && grep -qi 'authoritative' "$README_PI"; then
  tap_ok "Extension README documents guided workflow guardrails"
else
  tap_not_ok "Extension README documents guided workflow guardrails" "Expected guided workflow, checkpoint, canonical reply, and authoritative wording in drivers/pi/extensions/README.md"
fi

if grep -q 'Command → Skill → Workflow Mapping' "$SKILL_MAP" && grep -q 'canonical' "$SKILL_MAP"; then
  tap_ok "Skill map documents command → skill → workflow model"
else
  tap_not_ok "Skill map documents command → skill → workflow model" "Expected command/skill/workflow guidance in drivers/pi/skill-map.md"
fi

if grep -q 'Shortcut-Enabled Entry Points' "$SKILL_MAP" && grep -q 'Ctrl+Alt+N' "$SKILL_MAP"; then
  tap_ok "Skill map documents shortcut-enabled entry points"
else
  tap_not_ok "Skill map documents shortcut-enabled entry points" "Expected shortcut guidance in drivers/pi/skill-map.md"
fi

if grep -q 'milestone, phase, loop, and next action' "$README_PI" \
  && grep -q 'entry points, not persistent widget rows' "$README_PI" \
  && ! grep -q 'secondary "More" line' "$README_PI"; then
  tap_ok "Extension README describes the calm lifecycle surface without legacy shortcut rows"
else
  tap_not_ok "Extension README describes the calm lifecycle surface without legacy shortcut rows" "Expected calm lifecycle wording, shortcut-as-entry-point guidance, and no legacy secondary More row language in drivers/pi/extensions/README.md"
fi

if grep -q 'milestone, phase, loop, and next action' "$SKILL_MAP" \
  && grep -q 'persistent panel rows' "$SKILL_MAP" \
  && grep -q 'milestone, phase, loop, and next action' "$HELP_SKILL"; then
  tap_ok "Pi discovery surfaces keep shortcuts framed as routing around the calm lifecycle surface"
else
  tap_not_ok "Pi discovery surfaces keep shortcuts framed as routing around the calm lifecycle surface" "Expected calm lifecycle wording across drivers/pi/skill-map.md and drivers/pi/skills/paul-help/SKILL.md"
fi
if grep -q 'modules.yaml' "$README_PI" && grep -q 'module overlays' "$SKILL_MAP" && grep -q 'TODD and WALT are module overlays' "$HELP_SKILL"; then
  tap_ok "Pi discovery surfaces explain module overlays vs standalone skills"
else
  tap_not_ok "Pi discovery surfaces explain module overlays vs standalone skills" "Expected modules.yaml/module overlay guidance across Pi README, skill map, and help skill"
fi
if [ -f "$SKILL_DIR/paul-plan/SKILL.md" ] \
  && grep -Fq "$SKILL_DIR/workflows/plan-phase.md" "$SKILL_DIR/paul-plan/SKILL.md" \
  && grep -Fq "$SKILL_DIR/modules.yaml" "$SKILL_DIR/paul-plan/SKILL.md" \
  && grep -Fq 'absolute install-root references rendered' "$PI_INSTALLER"; then
  tap_ok "Pi installer renders installed skill references to absolute install-root paths"
else
  tap_not_ok "Pi installer renders installed skill references to absolute install-root paths" "Expected installed Pi skills to point at the installed skill tree rather than repo-local lookup, and installer to document the render step"
fi

README_MAIN="$REPO_ROOT/README.md"
if [ -f "$README_MAIN" ] \
  && grep -Fq '"agents": {' "$README_MAIN" \
  && grep -Fq '"implementer": { "enabled": true, "model": null }' "$README_MAIN" \
  && grep -Fq 'Current top-level sections for a fresh generated config are `modules`, `agents`, `git`, `planning`, `preferences`, and `guided_workflow`' "$README_MAIN" \
  && grep -Fq 'eligible bounded repo-local work only' "$README_MAIN" \
  && grep -Fq 'single task or sequential task step' "$README_MAIN"; then
  tap_ok "README preserves explicit implementer config defaults and bounded delegation wording"
else
  tap_not_ok "README preserves explicit implementer config defaults and bounded delegation wording" "Expected agents.implementer config and bounded helper-agent wording in README.md"
fi

if [ -f "$README_PI" ] \
  && grep -Fq 'three distinct PALS runtime surfaces' "$README_PI" \
  && grep -Fq 'eligible bounded repo-local task needs isolated implementation work' "$README_PI" \
  && grep -Fq 'Pi surfaces the helper only for eligible bounded repo-local work' "$README_PI"; then
  tap_ok "Extension README keeps the helper-agent model bounded to the three-surface Pi runtime"
else
  tap_not_ok "Extension README keeps the helper-agent model bounded to the three-surface Pi runtime" "Expected three-surface and bounded helper-agent wording in drivers/pi/extensions/README.md"
fi

if [ -f "$SKILL_MAP" ] \
  && grep -Fq 'eligible bounded repo-local work' "$SKILL_MAP" \
  && grep -Fq 'eligible bounded repo-local task or sequential task step' "$SKILL_MAP"; then
  tap_ok "Skill map keeps helper-agent boundaries aligned with bounded delegated APPLY"
else
  tap_not_ok "Skill map keeps helper-agent boundaries aligned with bounded delegated APPLY" "Expected bounded repo-local helper-agent wording in drivers/pi/skill-map.md"
fi

if grep -q 'Use `/paul-\*`' "$HELP_SKILL" && grep -q 'canonical' "$HELP_SKILL" && grep -q 'Ctrl+Alt+N' "$HELP_SKILL"; then
  tap_ok "Pi help skill explains command layer, canonical skill layer, and shortcuts"
else
  tap_not_ok "Pi help skill explains command layer, canonical skill layer, and shortcuts" "Expected command-vs-skill and shortcut guidance in drivers/pi/skills/paul-help/SKILL.md"
fi

UNINSTALL_PI="$REPO_ROOT/drivers/pi/uninstall.sh"
if grep -qi 'canonical.*skill files' "$UNINSTALL_PI" && grep -qi 'extension-backed .*command.*/hook layer\|extension-backed .*command and hook layer' "$UNINSTALL_PI"; then
  tap_ok "Pi uninstall script explains skills + extension removal clearly"
else
  tap_not_ok "Pi uninstall script explains skills + extension removal clearly" "Expected canonical-skill and extension-layer wording in drivers/pi/uninstall.sh"
fi

if grep -qi 'Live Module Visibility' "$README_PI" \
  && grep -qi 'dispatch-derived' "$README_PI" \
  && grep -qi 'non-authoritative' "$README_PI"; then
  tap_ok "Extension README documents the live module visibility contract"
else
  tap_not_ok "Extension README documents the live module visibility contract" "Expected Live Module Visibility section with dispatch-derived and non-authoritative wording in drivers/pi/extensions/README.md"
fi

if grep -qi 'dispatch-derived' "$SKILL_MAP" \
  && grep -qi 'Module Execution Reports' "$SKILL_MAP" \
  && grep -qi 'authoritative' "$SKILL_MAP"; then
  tap_ok "Skill map documents live module visibility as derived-only adapter behavior"
else
  tap_not_ok "Skill map documents live module visibility as derived-only adapter behavior" "Expected dispatch-derived / Module Execution Reports / authoritative wording in drivers/pi/skill-map.md"
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 5B: COLLABORATIVE PLANNING MODEL
# ════════════════════════════════════════════════════════════════════

section "COLLABORATIVE PLANNING MODEL"

if grep -R 'default_collaboration' "$REPO_ROOT/kernel/workflows" "$REPO_ROOT/kernel/commands/paul" "$REPO_ROOT/drivers/pi/skills" >/dev/null 2>&1 \
  && grep -R 'low / medium / high' "$REPO_ROOT/kernel/workflows" "$REPO_ROOT/drivers/pi/skills" >/dev/null 2>&1; then
  tap_ok "Planning workflows and Pi skills document collaboration defaults + levels"
else
  tap_not_ok "Planning workflows and Pi skills document collaboration defaults + levels" "Expected default_collaboration and low / medium / high markers across shared workflows and Pi skills"
fi

if grep -R 'exploratory' "$REPO_ROOT/kernel/workflows" "$REPO_ROOT/kernel/commands/paul" "$REPO_ROOT/drivers/pi/skills" >/dev/null 2>&1 \
  && grep -R 'direct-requirements' "$REPO_ROOT/kernel/workflows" "$REPO_ROOT/kernel/commands/paul" "$REPO_ROOT/drivers/pi/skills" >/dev/null 2>&1; then
  tap_ok "Planning workflows and Pi skills document exploratory vs direct-requirements mode"
else
  tap_not_ok "Planning workflows and Pi skills document exploratory vs direct-requirements mode" "Expected exploratory/direct-requirements wording across shared workflows and Pi skills"
fi

if grep -R 'Quick recap' "$REPO_ROOT/kernel/workflows" "$REPO_ROOT/drivers/pi" >/dev/null 2>&1 \
  && grep -R 'Detailed recap' "$REPO_ROOT/kernel/workflows" "$REPO_ROOT/drivers/pi" >/dev/null 2>&1 \
  && grep -R 'Full plan' "$REPO_ROOT/kernel/workflows" "$REPO_ROOT/drivers/pi" >/dev/null 2>&1 \
  && grep -R 'No review needed' "$REPO_ROOT/kernel/workflows" "$REPO_ROOT/drivers/pi" >/dev/null 2>&1; then
  tap_ok "Planning workflows, Pi docs, and extension surface the 4-option review menu"
else
  tap_not_ok "Planning workflows, Pi docs, and extension surface the 4-option review menu" "Expected Quick recap / Detailed recap / Full plan / No review needed across kernel and Pi surfaces"
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 6: UX READABILITY & COLOR ENRICHMENT
# ════════════════════════════════════════════════════════════════════

section "UX READABILITY & COLOR ENRICHMENT"

EXT_SRC_P64="$REPO_ROOT/drivers/pi/extensions/pals-hooks.ts"
README_P64="$REPO_ROOT/drivers/pi/extensions/README.md"
SKILL_MAP_P64="$REPO_ROOT/drivers/pi/skill-map.md"

# Check routing notification uses "success" level
if grep -q 'routing now.*"success"\|"success".*routing now' "$EXT_SRC_P64" 2>/dev/null; then
  tap_ok "Extension uses 'success' notify level for command routing confirmations"
else
  tap_not_ok "Extension uses 'success' notify level for command routing confirmations" "Expected 'success' level on routing notify in pals-hooks.ts"
fi

# Check guided workflow send notifications do not use flat "info"
if ! grep -q 'PALS guided workflow.*sending.*"info"' "$EXT_SRC_P64" 2>/dev/null; then
  tap_ok "Guided workflow send notifications do not use flat 'info' level"
else
  tap_not_ok "Guided workflow send notifications do not use flat 'info' level" "Expected no 'info' level on guided-workflow send notifications in pals-hooks.ts"
fi

# Check renderLoopBadge function exists
if grep -q 'renderLoopBadge' "$EXT_SRC_P64" 2>/dev/null; then
  tap_ok "Extension defines renderLoopBadge for loop state readability"
else
  tap_not_ok "Extension defines renderLoopBadge for loop state readability" "Expected renderLoopBadge function in pals-hooks.ts"
fi

# Check loop badge is wired into status bar
if grep -q 'renderLoopBadge(state.loop)' "$EXT_SRC_P64" 2>/dev/null; then
  tap_ok "Extension wires loop badge into renderLifecycleStatus"
else
  tap_not_ok "Extension wires loop badge into renderLifecycleStatus" "Expected renderLoopBadge(state.loop) call inside renderLifecycleStatus"
fi

# Check Installation Boundaries section in README
if grep -q 'Installation Boundaries' "$README_P64" 2>/dev/null; then
  tap_ok "Extension README documents installation boundaries"
else
  tap_not_ok "Extension README documents installation boundaries" "Expected 'Installation Boundaries' section in drivers/pi/extensions/README.md"
fi

# Check README maps extension install path
if grep -q '~/.pi/agent/extensions/pals-hooks.ts' "$README_P64" 2>/dev/null; then
  tap_ok "Extension README maps the extension install path"
else
  tap_not_ok "Extension README maps the extension install path" "Expected ~/.pi/agent/extensions/pals-hooks.ts in Installation Boundaries section"
fi

# Check README maps skill/kernel install path
if grep -q '~/.pi/agent/skills/pals/' "$README_P64" 2>/dev/null; then
  tap_ok "Extension README maps the skill/kernel install path"
else
  tap_not_ok "Extension README maps the skill/kernel install path" "Expected ~/.pi/agent/skills/pals/ in Installation Boundaries section"
fi

# Check skill-map documents the extension install target
if grep -q '~/.pi/agent/extensions/pals-hooks.ts' "$SKILL_MAP_P64" 2>/dev/null; then
  tap_ok "Skill map documents the extension install target"
else
  tap_not_ok "Skill map documents the extension install target" "Expected ~/.pi/agent/extensions/pals-hooks.ts in drivers/pi/skill-map.md"
fi
# ════════════════════════════════════════════════════════════════════
# SUMMARY
# ════════════════════════════════════════════════════════════════════

echo ""
echo "# ════════════════════════════════════════"
echo "# SUMMARY"
echo "# ════════════════════════════════════════"
echo "1..$TOTAL"
echo "# Passed: $PASS"
echo "# Failed: $FAIL"
echo "# Total:  $TOTAL"

if [ "$FAIL" -eq 0 ]; then
  echo ""
  echo "# ALL CHECKS PASSED"
  exit 0
else
  echo ""
  echo "# $FAIL CHECK(S) FAILED"
  exit 1
fi
