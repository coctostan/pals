#!/bin/bash
set -uo pipefail

# ════════════════════════════════════════
# PALS Cross-Harness Validation Suite
# ════════════════════════════════════════
# Validates that PALS works identically across Claude Code and Pi adapters.
# Checks: installer parity, portability compliance, artifact spec, driver manifests.
#
# Usage: bash tests/cross-harness-validation.sh
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
  # $1 = description, $2 = condition (0=pass, nonzero=fail), $3 = optional detail
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

# ════════════════════════════════════════════════════════════════════
# CATEGORY 1: INSTALLER PARITY
# ════════════════════════════════════════════════════════════════════

section "INSTALLER PARITY"

# Create temp HOME dirs for each driver
TEMP_CC="$(mktemp -d)"
TEMP_PI="$(mktemp -d)"
TEMP_DIRS+=("$TEMP_CC" "$TEMP_PI")

# Set up the expected directories so driver detection works
mkdir -p "$TEMP_CC/.claude"
mkdir -p "$TEMP_PI/.pi"

# Run Claude Code installer in temp environment
CC_OUTPUT="$(HOME="$TEMP_CC" PALS_DRIVER=claude-code bash "$REPO_ROOT/install.sh" 2>&1)" || true
CC_EXIT=$?
tap_check "Claude Code installer exits successfully" "$CC_EXIT"

# Run Pi installer in temp environment
PI_OUTPUT="$(HOME="$TEMP_PI" PALS_DRIVER=pi bash "$REPO_ROOT/install.sh" 2>&1)" || true
PI_EXIT=$?
tap_check "Pi installer exits successfully" "$PI_EXIT"

# Compare kernel file counts
count_kernel_files() {
  local base_dir="$1"
  local count=0
  for subdir in workflows references templates rules; do
    if [ -d "$base_dir/$subdir" ]; then
      local c
      c=$(find "$base_dir/$subdir" -type f 2>/dev/null | wc -l | tr -d ' ')
      count=$((count + c))
    fi
  done
  echo "$count"
}

CC_KERNEL_DIR="$TEMP_CC/.pals"
PI_KERNEL_DIR="$TEMP_PI/.pi/agent/skills/pals"

CC_KERNEL_COUNT=$(count_kernel_files "$CC_KERNEL_DIR")
PI_KERNEL_COUNT=$(count_kernel_files "$PI_KERNEL_DIR")

if [ "$CC_KERNEL_COUNT" -eq "$PI_KERNEL_COUNT" ] && [ "$CC_KERNEL_COUNT" -gt 0 ]; then
  tap_ok "Kernel file counts match: Claude Code=$CC_KERNEL_COUNT, Pi=$PI_KERNEL_COUNT"
else
  tap_not_ok "Kernel file counts match" "Claude Code=$CC_KERNEL_COUNT, Pi=$PI_KERNEL_COUNT"
fi

# Compare per-category counts
for subdir in workflows references templates rules; do
  CC_COUNT=0
  PI_COUNT=0
  if [ -d "$CC_KERNEL_DIR/$subdir" ]; then
    CC_COUNT=$(find "$CC_KERNEL_DIR/$subdir" -type f 2>/dev/null | wc -l | tr -d ' ')
  fi
  if [ -d "$PI_KERNEL_DIR/$subdir" ]; then
    PI_COUNT=$(find "$PI_KERNEL_DIR/$subdir" -type f 2>/dev/null | wc -l | tr -d ' ')
  fi
  if [ "$CC_COUNT" -eq "$PI_COUNT" ] && [ "$CC_COUNT" -gt 0 ]; then
    tap_ok "Kernel $subdir count matches: $CC_COUNT"
  else
    tap_not_ok "Kernel $subdir count matches" "Claude Code=$CC_COUNT, Pi=$PI_COUNT"
  fi
done

# Compare modules.yaml — same module names
CC_MODULES_YAML="$CC_KERNEL_DIR/modules.yaml"
PI_MODULES_YAML="$PI_KERNEL_DIR/modules.yaml"

if [ -f "$CC_MODULES_YAML" ] && [ -f "$PI_MODULES_YAML" ]; then
  tap_ok "Both installers generate modules.yaml"

  # Extract module names (lines with leading 2-space indent followed by name:)
  CC_MODS=$(grep -E '^  [a-z]+:' "$CC_MODULES_YAML" | sed 's/:.*//' | tr -d ' ' | sort)
  PI_MODS=$(grep -E '^  [a-z]+:' "$PI_MODULES_YAML" | sed 's/:.*//' | tr -d ' ' | sort)

  if [ "$CC_MODS" = "$PI_MODS" ]; then
    MOD_COUNT=$(echo "$CC_MODS" | wc -l | tr -d ' ')
    tap_ok "Module sets match: $MOD_COUNT modules"
  else
    tap_not_ok "Module sets match" "CC: $(echo "$CC_MODS" | tr '\n' ',') vs Pi: $(echo "$PI_MODS" | tr '\n' ',')"
  fi
else
  if [ ! -f "$CC_MODULES_YAML" ]; then
    tap_not_ok "Claude Code generates modules.yaml" "File not found"
  else
    tap_ok "Claude Code generates modules.yaml"
  fi
  if [ ! -f "$PI_MODULES_YAML" ]; then
    tap_not_ok "Pi generates modules.yaml" "File not found"
  else
    tap_ok "Pi generates modules.yaml"
  fi
  tap_not_ok "Module sets match" "Cannot compare — missing modules.yaml"
fi
# Check Pi modules.yaml includes module overlays used by workflow dispatch
if [ -f "$PI_MODULES_YAML" ]; then
  if grep -q '^  todd:' "$PI_MODULES_YAML" && grep -q '^  walt:' "$PI_MODULES_YAML"; then
    tap_ok "Pi modules.yaml includes TODD and WALT overlays"
  else
    tap_not_ok "Pi modules.yaml includes TODD and WALT overlays" "Expected todd and walt entries in Pi modules.yaml"
  fi

if [ -f "$CC_MODULES_YAML" ] && [ -f "$PI_MODULES_YAML" ]; then
  if grep -q '^    hook_details:' "$CC_MODULES_YAML" \
    && grep -q '^    hook_details:' "$PI_MODULES_YAML" \
    && grep -q 'references/tdd-detection.md' "$CC_MODULES_YAML" \
    && grep -q 'references/tdd-detection.md' "$PI_MODULES_YAML" \
    && grep -q 'references/quality-runner.md' "$CC_MODULES_YAML" \
    && grep -q 'references/quality-runner.md' "$PI_MODULES_YAML"; then
    tap_ok "Both modules.yaml registries include hook metadata and refs"
  else
    tap_not_ok "Both modules.yaml registries include hook metadata and refs" "Expected hook_details with TODD/WALT refs in both installed registries"
  fi
fi

if [ -f "$CC_MODULES_YAML" ] && [ -f "$PI_MODULES_YAML" ] \
  && grep -Fq 'source selectors' "$CC_MODULES_YAML" \
  && grep -Fq 'source selectors' "$PI_MODULES_YAML" \
  && grep -Fq 'top-level function declarations' "$CC_MODULES_YAML" \
  && grep -Fq 'top-level function declarations' "$PI_MODULES_YAML" \
  && grep -Fq 'exported const / arrow bindings' "$CC_MODULES_YAML" \
  && grep -Fq 'exported const / arrow bindings' "$PI_MODULES_YAML" \
  && grep -Fq '.tsx' "$CC_MODULES_YAML" \
  && grep -Fq '.tsx' "$PI_MODULES_YAML" \
  && grep -Fq '.jsx' "$CC_MODULES_YAML" \
  && grep -Fq '.jsx' "$PI_MODULES_YAML" \
  && grep -Fq 'stable identifiers surfaced' "$CC_MODULES_YAML" \
  && grep -Fq 'stable identifiers surfaced' "$PI_MODULES_YAML" \
  && grep -Fq 'resolved-with-call-sites only' "$CC_MODULES_YAML" \
  && grep -Fq 'resolved-with-call-sites only' "$PI_MODULES_YAML"; then
  tap_ok "Both modules.yaml registries preserve CODI source-selector markers"
else
  tap_not_ok "Both modules.yaml registries preserve CODI source-selector markers" "Expected source-selector extraction markers in both installed CODI descriptions"
fi
  if grep -q '^  walt:' "$CC_MODULES_YAML" \
    && grep -q '^  skip:' "$CC_MODULES_YAML" \
    && grep -q '^  ruby:' "$CC_MODULES_YAML" \
    && grep -q '^  walt:' "$PI_MODULES_YAML" \
    && grep -q '^  skip:' "$PI_MODULES_YAML" \
    && grep -q '^  ruby:' "$PI_MODULES_YAML" \
    && grep -q 'references/quality-history.md' "$CC_MODULES_YAML" \
    && grep -q 'references/knowledge-search.md' "$CC_MODULES_YAML" \
    && grep -q 'references/refactor-patterns.md' "$CC_MODULES_YAML" \
    && grep -q 'references/quality-history.md' "$PI_MODULES_YAML" \
    && grep -q 'references/knowledge-search.md' "$PI_MODULES_YAML" \
    && grep -q 'references/refactor-patterns.md' "$PI_MODULES_YAML"; then
    tap_ok "Both modules.yaml registries preserve post-unify metadata for durable evidence modules"
  else
    tap_not_ok "Both modules.yaml registries preserve post-unify metadata for durable evidence modules" "Expected WALT/SKIP/RUBY post-unify refs in both installed registries"
  fi
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 1A: SHARED APPLY / REV BOUNDARIES
# ════════════════════════════════════════════════════════════════════

section "SHARED APPLY / REV BOUNDARIES"

CC_APPLY_WORKFLOW="$CC_KERNEL_DIR/workflows/apply-phase.md"
PI_APPLY_WORKFLOW="$PI_KERNEL_DIR/workflows/apply-phase.md"

if [ -f "$CC_APPLY_WORKFLOW" ] && [ -f "$PI_APPLY_WORKFLOW" ] \
  && grep -Fq 'subagent_type: "pals-implementer"' "$CC_APPLY_WORKFLOW" \
  && grep -Fq 'subagent_type: "pals-implementer"' "$PI_APPLY_WORKFLOW" \
  && grep -Fq '.pi/agents/pals-implementer.md' "$CC_APPLY_WORKFLOW" \
  && grep -Fq '.pi/agents/pals-implementer.md' "$PI_APPLY_WORKFLOW" \
  && grep -Fq 'lifecycle reminder' "$CC_APPLY_WORKFLOW" \
  && grep -Fq 'lifecycle reminder' "$PI_APPLY_WORKFLOW" \
  && grep -Fq 'parent owns verification, module gates, fallback, and state/report writes' "$CC_APPLY_WORKFLOW" \
  && grep -Fq 'parent owns verification, module gates, fallback, and state/report writes' "$PI_APPLY_WORKFLOW" \
  && grep -Fq 'delegation may be used for a single eligible task or sequential task step' "$CC_APPLY_WORKFLOW" \
  && grep -Fq 'delegation may be used for a single eligible task or sequential task step' "$PI_APPLY_WORKFLOW" \
  && grep -Fq 'ambiguous, exploratory, cross-repo, checkpointed, or non-equivalent work stays inline' "$CC_APPLY_WORKFLOW" \
  && grep -Fq 'ambiguous, exploratory, cross-repo, checkpointed, or non-equivalent work stays inline' "$PI_APPLY_WORKFLOW"; then
  tap_ok "Both installed shared apply workflows preserve delegated pals-implementer guardrails"
else
  tap_not_ok "Both installed shared apply workflows preserve delegated pals-implementer guardrails" "Expected pals-implementer agent-path, parent-authority, and broadened bounded-delegation markers in both installed apply-phase.md files"
fi

CC_INIT_WORKFLOW="$CC_KERNEL_DIR/workflows/init-project.md"
PI_INIT_WORKFLOW="$PI_KERNEL_DIR/workflows/init-project.md"
CC_SCHEMA_REF="$CC_KERNEL_DIR/references/pals-json-schema.md"
PI_SCHEMA_REF="$PI_KERNEL_DIR/references/pals-json-schema.md"

if [ -f "$CC_INIT_WORKFLOW" ] && [ -f "$PI_INIT_WORKFLOW" ] \
  && grep -Fq '"agents": {' "$CC_INIT_WORKFLOW" \
  && grep -Fq '"agents": {' "$PI_INIT_WORKFLOW" \
  && grep -Fq '"implementer": { "enabled": true, "model": null }' "$CC_INIT_WORKFLOW" \
  && grep -Fq '"implementer": { "enabled": true, "model": null }' "$PI_INIT_WORKFLOW" \
  && grep -Fq '**agents:** Add `agents.implementer: { "enabled": true, "model": null }` if missing' "$CC_INIT_WORKFLOW" \
  && grep -Fq '**agents:** Add `agents.implementer: { "enabled": true, "model": null }` if missing' "$PI_INIT_WORKFLOW"; then
  tap_ok "Both installed shared init workflows preserve explicit implementer config defaults"
else
  tap_not_ok "Both installed shared init workflows preserve explicit implementer config defaults" "Expected implementer config defaults in both installed init-project.md files"
fi

if [ -f "$CC_SCHEMA_REF" ] && [ -f "$PI_SCHEMA_REF" ] \
  && grep -Fq '## agents' "$CC_SCHEMA_REF" \
  && grep -Fq '## agents' "$PI_SCHEMA_REF" \
  && grep -Fq '`agents.implementer.enabled`' "$CC_SCHEMA_REF" \
  && grep -Fq '`agents.implementer.enabled`' "$PI_SCHEMA_REF" \
  && grep -Fq '`agents.implementer.model`' "$CC_SCHEMA_REF" \
  && grep -Fq '`agents.implementer.model`' "$PI_SCHEMA_REF"; then
  tap_ok "Both installed schema references document implementer config fields"
else
  tap_not_ok "Both installed schema references document implementer config fields" "Expected agents.implementer markers in both installed pals-json-schema.md files"
fi

tap_file_contains_all \
  "Shared review command keeps REV entry routed through /paul:review" \
  "$REPO_ROOT/kernel/commands/paul/review.md" \
  '/paul:review'

if [ -f "$REPO_ROOT/kernel/workflows/unify-phase.md" ] \
  && [ -f "$REPO_ROOT/drivers/pi/skills/paul-review/SKILL.md" ] \
  && grep -Fq 'subagent_type: "code-reviewer"' "$REPO_ROOT/kernel/workflows/unify-phase.md" \
  && grep -Fq 'code-reviewer' "$REPO_ROOT/drivers/pi/skills/paul-review/SKILL.md" \
  && grep -Fq 'On-demand only' "$REPO_ROOT/drivers/pi/skills/paul-review/SKILL.md"; then
  tap_ok "Shared workflow and Pi review skill keep REV separate from delegated APPLY"
else
  tap_not_ok "Shared workflow and Pi review skill keep REV separate from delegated APPLY" "Expected code-reviewer and on-demand review markers in shared review surfaces"
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 1B: DURABLE MODULE EVIDENCE PATH
# ════════════════════════════════════════════════════════════════════

section "DURABLE MODULE EVIDENCE PATH"

if grep -q 'finalize_summary' "$REPO_ROOT/kernel/workflows/unify-phase.md" \
  && grep -q 'Module Execution Reports' "$REPO_ROOT/kernel/workflows/unify-phase.md" \
  && grep -q 'module_reports' "$REPO_ROOT/kernel/workflows/unify-phase.md" \
  && grep -q 'FIX-SUMMARY' "$REPO_ROOT/kernel/workflows/fix-loop.md" \
  && grep -q 'module_reports' "$REPO_ROOT/kernel/workflows/fix-loop.md"; then
  tap_ok "Shared workflows preserve a durable summary path for post-unify module evidence"
else
  tap_not_ok "Shared workflows preserve a durable summary path for post-unify module evidence" "Expected finalize_summary + module_reports markers in unify/fix workflows"
fi

if grep -q 'Module Execution Reports' "$REPO_ROOT/kernel/templates/SUMMARY.md" \
  && grep -q 'module_reports' "$REPO_ROOT/docs/HOOK-CONTRACT.md" \
  && grep -q 'module_reports' "$REPO_ROOT/docs/MODULE-SPEC.md" \
  && grep -q 'Module Execution Reports' "$REPO_ROOT/docs/ARTIFACT-SPEC.md"; then
  tap_ok "Shared template and specs describe one durable module reporting contract"
else
  tap_not_ok "Shared template and specs describe one durable module reporting contract" "Expected Module Execution Reports / module_reports markers across template and specs"
fi

if grep -q 'module_report' "$REPO_ROOT/modules/walt/workflows/apply-phase-quality.md" \
  && grep -q 'post-unify:' "$REPO_ROOT/modules/ruby/module.yaml" && grep -q 'json {changed_files}' "$REPO_ROOT/modules/ruby/module.yaml"; then
  tap_ok "Post-unify module overlays align with the durable reporting model"
else
  tap_not_ok "Post-unify module overlays align with the durable reporting model" "Expected WALT module_report markers plus RUBY post-unify changed_files analysis markers"
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 2: PORTABILITY COMPLIANCE
# ════════════════════════════════════════════════════════════════════

section "PORTABILITY COMPLIANCE"

KERNEL_DIR="$REPO_ROOT/kernel"

# Check for @~/ references (old Claude Code-specific pattern)
AT_TILDE_HITS=$(grep -r '@~/' "$KERNEL_DIR" 2>/dev/null | wc -l | tr -d ' ')
tap_check "No @~/ references in kernel files" "$( [ "$AT_TILDE_HITS" -eq 0 ] && echo 0 || echo 1 )" "Found $AT_TILDE_HITS occurrences"

# Check for @.paul/ references (old Claude Code-specific pattern)
AT_PAUL_HITS=$(grep -r '@\.paul/' "$KERNEL_DIR" 2>/dev/null | wc -l | tr -d ' ')
tap_check "No @.paul/ references in kernel files" "$( [ "$AT_PAUL_HITS" -eq 0 ] && echo 0 || echo 1 )" "Found $AT_PAUL_HITS occurrences"

# Check for ~/.pals/ hardcoded paths (should use kernel/ prefix)
HARDCODED_PALS_HITS=$(grep -rn '~/.pals/' "$KERNEL_DIR" 2>/dev/null | grep -v '# ' | grep -v 'Migration Reference' | wc -l | tr -d ' ')
tap_check "No ~/.pals/ hardcoded paths in kernel files" "$( [ "$HARDCODED_PALS_HITS" -eq 0 ] && echo 0 || echo 1 )" "Found $HARDCODED_PALS_HITS occurrences"

# Check for Claude Code tool-specific language
TOOL_LANG_HITS=0
for pattern in "Use the Read tool" "Use Bash to" "Use Grep to" "Use Edit to" "Use Write to" "Use the Glob"; do
  HITS=$(grep -ri "$pattern" "$KERNEL_DIR" 2>/dev/null | wc -l | tr -d ' ')
  TOOL_LANG_HITS=$((TOOL_LANG_HITS + HITS))
done
tap_check "No harness-specific tool language in kernel files" "$( [ "$TOOL_LANG_HITS" -eq 0 ] && echo 0 || echo 1 )" "Found $TOOL_LANG_HITS occurrences"

# Check module files too
MODULE_DIR="$REPO_ROOT/modules"
if [ -d "$MODULE_DIR" ]; then
  MOD_AT_TILDE=$(grep -r '@~/' "$MODULE_DIR" 2>/dev/null | wc -l | tr -d ' ')
  tap_check "No @~/ references in module files" "$( [ "$MOD_AT_TILDE" -eq 0 ] && echo 0 || echo 1 )" "Found $MOD_AT_TILDE occurrences"

  MOD_AT_PAUL=$(grep -r '@\.paul/' "$MODULE_DIR" 2>/dev/null | wc -l | tr -d ' ')
  tap_check "No @.paul/ references in module files" "$( [ "$MOD_AT_PAUL" -eq 0 ] && echo 0 || echo 1 )" "Found $MOD_AT_PAUL occurrences"

  MOD_HARDCODED=$(grep -rn '~/.pals/' "$MODULE_DIR" 2>/dev/null | grep -v '# ' | wc -l | tr -d ' ')
  tap_check "No ~/.pals/ hardcoded paths in module files" "$( [ "$MOD_HARDCODED" -eq 0 ] && echo 0 || echo 1 )" "Found $MOD_HARDCODED occurrences"
else
  tap_ok "No module directory (skip module portability checks)"
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 2B: SHARED COLLABORATIVE PLANNING MODEL
# ════════════════════════════════════════════════════════════════════

section "SHARED COLLABORATIVE PLANNING MODEL"

if grep -R 'default_collaboration' "$KERNEL_DIR/workflows" "$REPO_ROOT/kernel/commands/paul" >/dev/null 2>&1 \
  && grep -R 'exploratory' "$KERNEL_DIR/workflows" "$REPO_ROOT/kernel/commands/paul" >/dev/null 2>&1 \
  && grep -R 'direct-requirements' "$KERNEL_DIR/workflows" "$REPO_ROOT/kernel/commands/paul" >/dev/null 2>&1; then
  tap_ok "Shared planning workflows document collaboration defaults and mode selection"
else
  tap_not_ok "Shared planning workflows document collaboration defaults and mode selection" "Expected default_collaboration plus exploratory/direct-requirements markers in shared kernel planning files"
fi

if grep -R 'Quick recap' "$KERNEL_DIR/workflows" >/dev/null 2>&1 \
  && grep -R 'Detailed recap' "$KERNEL_DIR/workflows" >/dev/null 2>&1 \
  && grep -R 'Full plan' "$KERNEL_DIR/workflows" >/dev/null 2>&1 \
  && grep -R 'No review needed' "$KERNEL_DIR/workflows" >/dev/null 2>&1; then
  tap_ok "Shared planning workflows expose the 4-option review menu across harnesses"
else
  tap_not_ok "Shared planning workflows expose the 4-option review menu across harnesses" "Expected review-menu wording in shared kernel workflows"
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 2C: CONTEXT-DIET REGRESSION GUARDRAILS
# ════════════════════════════════════════════════════════════════════

section "CONTEXT-DIET REGRESSION GUARDRAILS"

HOT_WORKFLOW_LINE_CEILING=1711
CC_PLAN_WORKFLOW="$CC_KERNEL_DIR/workflows/plan-phase.md"
CC_APPLY_WORKFLOW="$CC_KERNEL_DIR/workflows/apply-phase.md"
CC_UNIFY_WORKFLOW="$CC_KERNEL_DIR/workflows/unify-phase.md"
CC_MODULE_DISPATCH="$CC_KERNEL_DIR/references/module-dispatch.md"
CC_GIT_STRATEGY="$CC_KERNEL_DIR/references/git-strategy.md"
PI_PLAN_WORKFLOW="$PI_KERNEL_DIR/workflows/plan-phase.md"
PI_APPLY_WORKFLOW="$PI_KERNEL_DIR/workflows/apply-phase.md"
PI_UNIFY_WORKFLOW="$PI_KERNEL_DIR/workflows/unify-phase.md"
PI_MODULE_DISPATCH="$PI_KERNEL_DIR/references/module-dispatch.md"
PI_GIT_STRATEGY="$PI_KERNEL_DIR/references/git-strategy.md"
REPO_PLAN_WORKFLOW="$REPO_ROOT/kernel/workflows/plan-phase.md"
REPO_APPLY_WORKFLOW="$REPO_ROOT/kernel/workflows/apply-phase.md"
REPO_UNIFY_WORKFLOW="$REPO_ROOT/kernel/workflows/unify-phase.md"
REPO_MODULE_DISPATCH="$REPO_ROOT/kernel/references/module-dispatch.md"
REPO_GIT_STRATEGY="$REPO_ROOT/kernel/references/git-strategy.md"
REPO_ROADMAP="$REPO_ROOT/.paul/ROADMAP.md"
# Phase 191 anti-regrowth budgets: active ROADMAP <=120 lines;
# post-190 hot workflow/reference source set was 1901 lines, so 2100
# catches broad regrowth without failing harmless small edits.
ACTIVE_ROADMAP_LINE_CEILING=120
HOT_CONTEXT_SOURCE_SET_LINE_CEILING=2100
GITHUB_FLOW_JQ_DUPLICATION_CEILING=6

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
  "Claude Code installed hot workflows stay under the Phase 186 pre-compression ceiling" \
  "$HOT_WORKFLOW_LINE_CEILING" \
  "$CC_PLAN_WORKFLOW" \
  "$CC_APPLY_WORKFLOW" \
  "$CC_UNIFY_WORKFLOW"

tap_hot_workflow_line_ceiling \
  "Claude Code installed hot workflow/reference set stays under post-190 anti-regrowth budget" \
  "$HOT_CONTEXT_SOURCE_SET_LINE_CEILING" \
  "$CC_PLAN_WORKFLOW" \
  "$CC_APPLY_WORKFLOW" \
  "$CC_UNIFY_WORKFLOW" \
  "$CC_MODULE_DISPATCH" \
  "$CC_GIT_STRATEGY"

tap_hot_workflow_line_ceiling \
  "Pi installed hot workflows stay under the Phase 186 pre-compression ceiling" \
  "$HOT_WORKFLOW_LINE_CEILING" \
  "$PI_PLAN_WORKFLOW" \
  "$PI_APPLY_WORKFLOW" \
  "$PI_UNIFY_WORKFLOW"

tap_hot_workflow_line_ceiling \
  "Pi installed hot workflow/reference set stays under post-190 anti-regrowth budget" \
  "$HOT_CONTEXT_SOURCE_SET_LINE_CEILING" \
  "$PI_PLAN_WORKFLOW" \
  "$PI_APPLY_WORKFLOW" \
  "$PI_UNIFY_WORKFLOW" \
  "$PI_MODULE_DISPATCH" \
  "$PI_GIT_STRATEGY"

tap_hot_workflow_line_ceiling \
  "Repo source hot workflows stay under the Phase 186 pre-compression ceiling" \
  "$HOT_WORKFLOW_LINE_CEILING" \
  "$REPO_PLAN_WORKFLOW" \
  "$REPO_APPLY_WORKFLOW" \
  "$REPO_UNIFY_WORKFLOW"

tap_hot_workflow_line_ceiling \
  "Repo source hot workflow/reference install-equivalent set stays under post-190 anti-regrowth budget" \
  "$HOT_CONTEXT_SOURCE_SET_LINE_CEILING" \
  "$REPO_PLAN_WORKFLOW" \
  "$REPO_APPLY_WORKFLOW" \
  "$REPO_UNIFY_WORKFLOW" \
  "$REPO_MODULE_DISPATCH" \
  "$REPO_GIT_STRATEGY"

for workflow_dir_label in "Claude Code installed:$CC_KERNEL_DIR" "Pi installed:$PI_KERNEL_DIR" "Repo source:$REPO_ROOT/kernel"; do
  label="${workflow_dir_label%%:*}"
  root="${workflow_dir_label#*:}"

  tap_file_contains_all \
    "$label plan workflow keeps targeted-read and review-menu guardrails" \
    "$root/workflows/plan-phase.md" \
    'target phase detail' \
    'planning.default_collaboration' \
    'Would you like to see the plan?'

  tap_file_contains_all \
    "$label apply workflow keeps parent-owned APPLY and checkpoint guardrails" \
    "$root/workflows/apply-phase.md" \
    'parent owns verification, module gates, fallback, and state/report writes' \
    'subagent_type: "pals-implementer"' \
    'checkpoint:*' \
    'ambiguous, exploratory, cross-repo, checkpointed, or non-equivalent work stays inline'

  tap_file_contains_all \
    "$label apply workflow keeps Helper Delegation parent-acceptance markers" \
    "$root/workflows/apply-phase.md" \
    'Parent-owned task packet' \
    'Allowed files:' \
    'Forbidden files:' \
    'Fallback triggers:' \
    'Parent-run official verification:' \
    'structured helper report' \
    'changed-file diff check' \
    'Authority: Derived aid only; no helper-owned .paul/* lifecycle writes.'

  tap_file_contains_all \
    "$label unify workflow keeps post-unify evidence and GitHub Flow merge-gate guardrails" \
    "$root/workflows/unify-phase.md" \
    'post-unify' \
    'Module Execution Reports' \
    'MERGE GATE' \
    'gh pr checks' \
    'gh pr merge' \
    'modules.yaml NOT FOUND'

  tap_file_contains_all \
    "$label module-dispatch reference keeps shared evidence-contract guardrails" \
    "$root/references/module-dispatch.md" \
    'Workflow Call-Site Contract' \
    'Durable Evidence Requirements' \
    'Project Config vs Installed Registry' \
    'Do not restate generic registry mechanics'


  tap_file_contains_all \
    "$label git-strategy reference keeps shared GitHub Flow ownership markers" \
    "$root/references/git-strategy.md" \
    'GitHub Flow' \
    'GIT_WORKFLOW' \
    'auto_pr' \
    'merge gate'
done

DELEGATED_APPLY_CONTRACT="$REPO_ROOT/docs/PI-NATIVE-DELEGATED-APPLY-PACKET-REPORT-CONTRACT.md"

tap_file_contains_all \
  "Delegated APPLY contract preserves v2.50 Shared Invariant closure markers" \
  "$DELEGATED_APPLY_CONTRACT" \
  '.paul/*' \
  'parent-owned APPLY' \
  'module evidence' \
  'checkpoint' \
  'GitHub Flow safety' \
  'helper reports as review input' \
  'Parent-run official verification:' \
  'changed-file diff' \
  'command-output truth' \
  'Helper Delegation' \
  'Shared Invariant' \
  'old count' \
  'new count' \
  'validation class affected' \
  'shared-invariant preservation rationale' \
  'Authority: Derived aid only; no helper-owned .paul/* lifecycle writes.'

# ════════════════════════════════════════════════════════════════════
# CATEGORY 2C: CODI PLAN-PHASE DISTRIBUTION
# ════════════════════════════════════════════════════════════════════

section "CODI PLAN-PHASE DISTRIBUTION"

CC_PLAN_WORKFLOW="$CC_KERNEL_DIR/workflows/plan-phase.md"
PI_PLAN_WORKFLOW="$PI_KERNEL_DIR/workflows/plan-phase.md"
CC_CODI_REF="$CC_KERNEL_DIR/references/codi.md"
PI_CODI_REF="$PI_KERNEL_DIR/references/codi.md"

if [ -f "$CC_PLAN_WORKFLOW" ] && [ -f "$PI_PLAN_WORKFLOW" ] \
  && grep -Fq 'codi_seed_candidates' "$CC_PLAN_WORKFLOW" \
  && grep -Fq 'codi_seed_candidates' "$PI_PLAN_WORKFLOW" \
  && grep -Fq 'upcoming plan context block' "$CC_PLAN_WORKFLOW" \
  && grep -Fq 'upcoming plan context block' "$PI_PLAN_WORKFLOW" \
  && grep -Fq 'source selectors' "$CC_PLAN_WORKFLOW" \
  && grep -Fq 'source selectors' "$PI_PLAN_WORKFLOW" \
  && grep -Fq 'source-file mention order' "$CC_PLAN_WORKFLOW" \
  && grep -Fq 'source-file mention order' "$PI_PLAN_WORKFLOW" \
  && grep -Fq 'declaration order within each file' "$CC_PLAN_WORKFLOW" \
  && grep -Fq 'declaration order within each file' "$PI_PLAN_WORKFLOW" \
  && grep -Fq 'stable extracted identifiers' "$CC_PLAN_WORKFLOW" \
  && grep -Fq 'stable extracted identifiers' "$PI_PLAN_WORKFLOW" \
  && grep -Fq 'CODI may skip cleanly and planning continues' "$CC_PLAN_WORKFLOW" \
  && grep -Fq 'CODI may skip cleanly and planning continues' "$PI_PLAN_WORKFLOW"; then
  tap_ok "Both installed shared plan workflows preserve CODI source-selector markers"
else
  tap_not_ok "Both installed shared plan workflows preserve CODI source-selector markers" "Expected codi_seed_candidates, upcoming plan context block, source-selector ordering, and safe-skip markers in both installed plan-phase.md files"
fi

if [ -f "$CC_INIT_WORKFLOW" ] && [ -f "$PI_INIT_WORKFLOW" ] \
  && grep -Fq '"codi": { "enabled": true, "description": "Codegraph-driven structural injection (safe skip when codegraph is unavailable)" }' "$CC_INIT_WORKFLOW" \
  && grep -Fq '"codi": { "enabled": true, "description": "Codegraph-driven structural injection (safe skip when codegraph is unavailable)" }' "$PI_INIT_WORKFLOW"; then
  tap_ok "Both installed shared init workflows expose CODI default-on config guidance"
else
  tap_not_ok "Both installed shared init workflows expose CODI default-on config guidance" "Expected CODI default-on config block in both installed init-project.md files"
fi

if [ -f "$CC_SCHEMA_REF" ] && [ -f "$PI_SCHEMA_REF" ] \
  && grep -Fq '`modules.codi.enabled`' "$CC_SCHEMA_REF" \
  && grep -Fq '`modules.codi.enabled`' "$PI_SCHEMA_REF" \
  && grep -Fq '`modules.codi.description`' "$CC_SCHEMA_REF" \
  && grep -Fq '`modules.codi.description`' "$PI_SCHEMA_REF" \
  && grep -Fq 'CODI is safe to leave enabled by default' "$CC_SCHEMA_REF" \
  && grep -Fq 'CODI is safe to leave enabled by default' "$PI_SCHEMA_REF"; then
  tap_ok "Both installed schema references document CODI config fields"
else
  tap_not_ok "Both installed schema references document CODI config fields" "Expected CODI config-field and safe-default markers in both installed pals-json-schema.md files"
fi

if [ -f "$CC_CODI_REF" ] && [ -f "$PI_CODI_REF" ] \
  && grep -Fq 'When CODI helps' "$CC_CODI_REF" \
  && grep -Fq 'When CODI helps' "$PI_CODI_REF" \
  && grep -Fq 'TS/JS-touching indexed code' "$CC_CODI_REF" \
  && grep -Fq 'TS/JS-touching indexed code' "$PI_CODI_REF" \
  && grep -Fq 'boundary specificity' "$CC_CODI_REF" \
  && grep -Fq 'boundary specificity' "$PI_CODI_REF" \
  && grep -Fq 'resolved-with-call-sites only' "$CC_CODI_REF" \
  && grep -Fq 'resolved-with-call-sites only' "$PI_CODI_REF" \
  && grep -Fq 'source selectors' "$CC_CODI_REF" \
  && grep -Fq 'source selectors' "$PI_CODI_REF" \
  && grep -Fq 'top-level function declarations' "$CC_CODI_REF" \
  && grep -Fq 'top-level function declarations' "$PI_CODI_REF" \
  && grep -Fq 'exported const / arrow bindings' "$CC_CODI_REF" \
  && grep -Fq 'exported const / arrow bindings' "$PI_CODI_REF" \
  && grep -Fq 'source-file mention order' "$CC_CODI_REF" \
  && grep -Fq 'source-file mention order' "$PI_CODI_REF" \
  && grep -Fq 'declaration order within each file' "$CC_CODI_REF" \
  && grep -Fq 'declaration order within each file' "$PI_CODI_REF" \
  && grep -Fq 'stable identifiers surfaced' "$CC_CODI_REF" \
  && grep -Fq 'stable identifiers surfaced' "$PI_CODI_REF" \
  && grep -Fq 'pi-codegraph' "$CC_CODI_REF" \
  && grep -Fq 'pi-codegraph' "$PI_CODI_REF" \
  && grep -Fq '.codegraph/' "$CC_CODI_REF" \
  && grep -Fq '.codegraph/' "$PI_CODI_REF" \
  && grep -Fq 'CODI is enabled but no codegraph index detected' "$CC_CODI_REF" \
  && grep -Fq 'CODI is enabled but no codegraph index detected' "$PI_CODI_REF" \
  && grep -Fq 'planning continues cleanly' "$CC_CODI_REF" \
  && grep -Fq 'planning continues cleanly' "$PI_CODI_REF"; then
  tap_ok "Both installed CODI references preserve source-selector and safe-setup markers"
else
  tap_not_ok "Both installed CODI references preserve source-selector and safe-setup markers" "Expected source-selector and safe-setup markers in both installed codi.md refs"
fi

if grep -Fq 'codi_seed_candidates' "$REPO_ROOT/kernel/workflows/plan-phase.md" \
  && grep -Fq 'upcoming plan context block' "$REPO_ROOT/kernel/workflows/plan-phase.md" \
  && grep -Fq 'declaration order within each file' "$REPO_ROOT/kernel/workflows/plan-phase.md" \
  && grep -Fq 'source selectors' "$REPO_ROOT/modules/codi/module.yaml" \
  && grep -Fq 'top-level function declarations' "$REPO_ROOT/modules/codi/module.yaml" \
  && grep -Fq 'resolved-with-call-sites only' "$REPO_ROOT/modules/codi/module.yaml" \
  && grep -Fq 'source selectors' "$REPO_ROOT/modules/codi/references/codi.md" \
  && grep -Fq 'stable extracted identifiers' "$REPO_ROOT/modules/codi/references/codi.md" \
  && grep -Fq 'When CODI helps' "$REPO_ROOT/modules/codi/references/codi.md" \
  && grep -Fq 'CODI is enabled but no codegraph index detected' "$REPO_ROOT/drivers/pi/install.sh" \
  && grep -Fq '"codi": { "enabled": true, "description": "Codegraph-driven structural injection (safe skip when codegraph is unavailable)" }' "$REPO_ROOT/kernel/workflows/init-project.md" \
  && grep -Fq '`modules.codi.enabled`' "$REPO_ROOT/kernel/references/pals-json-schema.md" \
  && grep -Fq 'Setup & Safe-Skip Distribution' "$REPO_ROOT/modules/codi/references/codi.md" \
  && grep -Fq '### CODI setup (optional)' "$REPO_ROOT/README.md" \
  && grep -Fq 'TS/JS-touching indexed code' "$REPO_ROOT/README.md" \
  && grep -Fq '"codi": {' "$REPO_ROOT/pals.json"; then
  tap_ok "Repo source surfaces retain the CODI source-selector contract"
else
  tap_not_ok "Repo source surfaces retain the CODI source-selector contract" "Expected Phase 174 source-selector markers across repo plan workflow, module manifest, module ref, init workflow, schema ref, README, and pals.json"
fi

# Phase 176: CODI post-unify dispatch-outcome instrumentation — cross-harness
CC_CODI_INSTRUMENTATION_REF="$CC_KERNEL_DIR/references/codi-instrumentation.md"
PI_CODI_INSTRUMENTATION_REF="$PI_KERNEL_DIR/references/codi-instrumentation.md"

if [ -f "$CC_KERNEL_DIR/modules.yaml" ] && [ -f "$PI_KERNEL_DIR/modules.yaml" ] \
  && grep -Fq 'CODI-HISTORY.md' "$CC_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'CODI-HISTORY.md' "$PI_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'references/codi-instrumentation.md' "$CC_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'references/codi-instrumentation.md' "$PI_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'no-dispatch-found' "$CC_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'no-dispatch-found' "$PI_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'finalize_summary' "$CC_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'finalize_summary' "$PI_KERNEL_DIR/modules.yaml"; then
  tap_ok "Both installed modules.yaml registries carry the CODI post-unify dispatch-outcome hook"
else
  tap_not_ok "Both installed modules.yaml registries carry the CODI post-unify dispatch-outcome hook" "Expected Phase 176 post-unify hook markers (CODI-HISTORY.md, codi-instrumentation.md, no-dispatch-found, finalize_summary) in both installed modules.yaml files"
fi

if [ -f "$CC_CODI_INSTRUMENTATION_REF" ] && [ -f "$PI_CODI_INSTRUMENTATION_REF" ]; then
  tap_ok "Both installed CODI instrumentation references exist"
else
  tap_not_ok "Both installed CODI instrumentation references exist" "Expected codi-instrumentation.md in both installed references dirs"
fi

if [ -f "$CC_CODI_INSTRUMENTATION_REF" ] && [ -f "$PI_CODI_INSTRUMENTATION_REF" ] \
  && grep -Fq '## Outcome taxonomy' "$CC_CODI_INSTRUMENTATION_REF" \
  && grep -Fq '## Outcome taxonomy' "$PI_CODI_INSTRUMENTATION_REF" \
  && grep -Fq 'no-dispatch-found' "$CC_CODI_INSTRUMENTATION_REF" \
  && grep -Fq 'no-dispatch-found' "$PI_CODI_INSTRUMENTATION_REF" \
  && grep -Fq '.paul/CODI-HISTORY.md' "$CC_CODI_INSTRUMENTATION_REF" \
  && grep -Fq '.paul/CODI-HISTORY.md' "$PI_CODI_INSTRUMENTATION_REF" \
  && grep -Fq '| Plan | Date | Outcome | R | U | K | Symbols | blast_radius |' "$CC_CODI_INSTRUMENTATION_REF" \
  && grep -Fq '| Plan | Date | Outcome | R | U | K | Symbols | blast_radius |' "$PI_CODI_INSTRUMENTATION_REF"; then
  tap_ok "Both installed CODI instrumentation references document schema, taxonomy, and history path"
else
  tap_not_ok "Both installed CODI instrumentation references document schema, taxonomy, and history path" "Expected Outcome taxonomy, no-dispatch-found, CODI-HISTORY.md path, and canonical header row in both installed codi-instrumentation.md refs"
fi

# Drift guard: 5 pre-plan skip-log strings must be verbatim in both installed CODI manifests
if [ -f "$CC_KERNEL_DIR/modules.yaml" ] && [ -f "$PI_KERNEL_DIR/modules.yaml" ] \
  && grep -Fq 'no extractable symbols in phase scope' "$CC_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'no extractable symbols in phase scope' "$PI_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'codegraph tools unavailable' "$CC_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'codegraph tools unavailable' "$PI_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'impact loop errored:' "$CC_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'impact loop errored:' "$PI_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'impact returned empty blast radius for all symbols' "$CC_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'impact returned empty blast radius for all symbols' "$PI_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'impact × N symbols → R resolved, U unresolved, K total call-sites, injected blast_radius' "$CC_KERNEL_DIR/modules.yaml" \
  && grep -Fq 'impact × N symbols → R resolved, U unresolved, K total call-sites, injected blast_radius' "$PI_KERNEL_DIR/modules.yaml"; then
  tap_ok "Both installed CODI manifests preserve all 5 pre-plan skip-log strings (drift guard)"
else
  tap_not_ok "Both installed CODI manifests preserve all 5 pre-plan skip-log strings (drift guard)" "Expected all 5 pre-plan skip-log strings + success-log template in both installed CODI manifests"
fi

# Phase 176 repo-source contract: manifest, new ref, seed history, and cross-reference pointer live in the repo
if [ -f "$REPO_ROOT/modules/codi/module.yaml" ] \
  && grep -Fq 'post-unify:' "$REPO_ROOT/modules/codi/module.yaml" \
  && grep -Fq 'CODI-HISTORY.md' "$REPO_ROOT/modules/codi/module.yaml" \
  && grep -Fq 'references/codi-instrumentation.md' "$REPO_ROOT/modules/codi/module.yaml" \
  && grep -Fq 'no-dispatch-found' "$REPO_ROOT/modules/codi/module.yaml" \
  && grep -Fq 'finalize_summary' "$REPO_ROOT/modules/codi/module.yaml" \
  && [ -f "$REPO_ROOT/modules/codi/references/codi-instrumentation.md" ] \
  && grep -Fq '## Outcome taxonomy' "$REPO_ROOT/modules/codi/references/codi-instrumentation.md" \
  && grep -Fq '| Plan | Date | Outcome | R | U | K | Symbols | blast_radius |' "$REPO_ROOT/modules/codi/references/codi-instrumentation.md" \
  && grep -Fq 'codi-instrumentation.md' "$REPO_ROOT/modules/codi/references/codi.md" \
  && [ -f "$REPO_ROOT/.paul/CODI-HISTORY.md" ] \
  && grep -Fq '| 175-01 | 2026-04-17 | injected | 4 | 0 | 10 | renderCompactLoopSummary, renderLifecycleStatus, syncLifecycleUi, renderLoopBadge | y |' "$REPO_ROOT/.paul/CODI-HISTORY.md"; then
  tap_ok "Repo source surfaces carry the CODI post-unify instrumentation contract (manifest hook, instrumentation ref, codi.md pointer, seeded CODI-HISTORY.md)"
else
  tap_not_ok "Repo source surfaces carry the CODI post-unify instrumentation contract" "Expected post-unify hook + CODI-HISTORY markers in modules/codi/module.yaml, codi-instrumentation.md ref with taxonomy + header row, pointer line in codi.md, and seeded 175-01 row in .paul/CODI-HISTORY.md"
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 3: ARTIFACT SPEC COMPLIANCE
# ════════════════════════════════════════════════════════════════════

section "ARTIFACT SPEC COMPLIANCE"

PAUL_DIR="$REPO_ROOT/.paul"

# STATE.md required sections
STATE_MD="$PAUL_DIR/STATE.md"
if [ -f "$STATE_MD" ]; then
  tap_ok "STATE.md exists"
  for section_name in "Project Reference" "Current Position" "Loop Position" "Accumulated Context" "Session Continuity"; do
    if grep -q "## $section_name" "$STATE_MD" 2>/dev/null; then
      tap_ok "STATE.md has '## $section_name' section"
    else
      tap_not_ok "STATE.md has '## $section_name' section" "Section not found"
    fi
  done
else
  tap_not_ok "STATE.md exists" "File not found at $STATE_MD"
fi

# README should describe multi-driver support, including Pi
README_MD="$REPO_ROOT/README.md"
if [ -f "$README_MD" ]; then
  if grep -q 'Claude Code · Pi · Agent SDK' "$README_MD" && grep -q 'Pi driver installs canonical skills plus an extension-backed command/hook layer' "$README_MD"; then
    tap_ok "README documents Claude Code and Pi driver surfaces"
  else
    tap_not_ok "README documents Claude Code and Pi driver surfaces" "Expected Pi multi-driver guidance in README.md"
  fi
fi

if [ -f "$README_MD" ] \
  && grep -Fq '"agents": {' "$README_MD" \
  && grep -Fq '"implementer": { "enabled": true, "model": null }' "$README_MD" \
  && grep -Fq 'Current top-level sections for a fresh generated config are `modules`, `agents`, `git`, `planning`, `preferences`, and `guided_workflow`' "$README_MD" \
  && grep -Fq 'eligible bounded repo-local work only' "$README_MD"; then
  tap_ok "README preserves the explicit implementer config and bounded helper-agent contract"
else
  tap_not_ok "README preserves the explicit implementer config and bounded helper-agent contract" "Expected agents.implementer config and bounded delegation wording in README.md"
fi

README_PI="$REPO_ROOT/drivers/pi/extensions/README.md"
SKILL_MAP_PI="$REPO_ROOT/drivers/pi/skill-map.md"
if [ -f "$README_PI" ] && [ -f "$SKILL_MAP_PI" ] \
  && grep -Fq 'three distinct PALS runtime surfaces' "$README_PI" \
  && grep -Fq 'Pi surfaces the helper only for eligible bounded repo-local work' "$README_PI" \
  && grep -Fq 'eligible bounded repo-local work' "$SKILL_MAP_PI" \
  && grep -Fq 'eligible bounded repo-local task or sequential task step' "$SKILL_MAP_PI"; then
  tap_ok "Repo Pi docs preserve the bounded helper-agent contract"
else
  tap_not_ok "Repo Pi docs preserve the bounded helper-agent contract" "Expected bounded helper-agent wording across drivers/pi/extensions/README.md and drivers/pi/skill-map.md"
fi

ARTIFACT_SLICE_CONTRACT="$REPO_ROOT/docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md"
PI_VALIDATION_SUITE="$REPO_ROOT/tests/pi-end-to-end-validation.sh"
CROSS_VALIDATION_SUITE="$REPO_ROOT/tests/cross-harness-validation.sh"
GUIDED_WORKFLOW_CONTRACT="$REPO_ROOT/docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md"

tap_file_contains_all \
  "Artifact-slice contract preserves command-output evidence reconciliation markers" \
  "$ARTIFACT_SLICE_CONTRACT" \
  'Command-Output Evidence' \
  'command output' \
  'TAP summary counts' \
  'SUMMARY must state old count, new count' \
  'old count' \
  'new count' \
  'validation class affected' \
  'shared-invariant preservation rationale'

tap_file_contains_all \
  "Guided workflow contract preserves v2.48 closure evidence baselines" \
  "$GUIDED_WORKFLOW_CONTRACT" \
  'Historical Phase 205/Phase 206 starting baseline: Pi 188/188' \
  'Historical Phase 205/Phase 206 starting baseline: cross-harness 104/104' \
  'Current post-Phase-207/208 v2.48 closure baseline: Pi 192/192 and cross-harness 108/108' \
  'canonical transcript' \
  'GitHub Flow evidence' \
  'command output' \
  'old count' \
  'new count' \
  'validation class affected' \
  'shared-invariant preservation rationale'

tap_file_contains_all \
  "Repo Pi docs preserve artifact-slice full-read and authority boundaries" \
  "$README_PI" \
  'current-lifecycle-state' \
  'active-roadmap-phase' \
  'approved-plan-task-packet' \
  'source-cited' \
  'freshness-marked' \
  'Derived aid only' \
  'full authoritative read' \
  'no hidden Pi state' \
  'Pi-owned lifecycle/module/validation ledger'

tap_file_contains_all \
  "Shared Invariant docs preserve guided workflow authority boundaries" \
  "$README_MD" \
  'canonical transcript reply' \
  'explicit confirm/select user action' \
  'Notify-only mode sends no reply' \
  'no auto-approval' \
  'no auto-continue' \
  'no skipped checkpoints' \
  'no UI-only lifecycle decisions' \
  'no inferred merge intent' \
  'GitHub Flow decisions still require git/gh command evidence'

tap_file_contains_all \
  "GitHub Flow Safety docs keep merge-gate routing non-authoritative" \
  "$README_PI" \
  'merge-gate-routing' \
  'route assistance' \
  'must not run git/gh commands' \
  'bypass CI or review checks' \
  'infer merge intent' \
  'GitHub Flow command evidence'

tap_file_contains_all \
  "Artifact / Process docs preserve command-output truth for guided workflow evidence" \
  "$SKILL_MAP_PI" \
  'adapter-side reply-routing aid' \
  'not a standalone skill or workflow authority' \
  'canonical transcript replies' \
  'UI state alone is not lifecycle evidence' \
  'full authoritative read'

tap_file_contains_all \
  "Validation scripts preserve guided workflow command-output truth markers" \
  "$PI_VALIDATION_SUITE" \
  'Guided UI Safety' \
  'Pi-Supported Runtime' \
  'canonical replies' \
  'no-auto boundaries'

tap_file_contains_all \
  "Validation suites preserve artifact-slice evidence reconciliation markers" \
  "$PI_VALIDATION_SUITE" \
  'Artifact-slice runtime-lens contract' \
  'Fallback: full authoritative read' \
  'GitHub Flow gates' \
  'validation pass/fail' \
  'module completion'

tap_file_contains_all \
  "Cross-harness suite preserves artifact-slice shared-evidence markers" \
  "$CROSS_VALIDATION_SUITE" \
  'Artifact-slice contract preserves command-output evidence reconciliation markers' \
  'command-output evidence' \
  'module evidence' \
  'GitHub Flow evidence' \
  'no hidden Pi state' \
  'Pi-owned lifecycle/module/validation ledger'


tap_file_contains_all \
  "Workflow/resource capsule docs preserve shared authority and validation-class markers" \
  "$README_MD" \
  'Workflow/Resource Capsule Context' \
  'Workflow/Resource Capsule Context — Pi-Supported Runtime' \
  'Workflow/Resource Capsule Context — Shared Invariant' \
  'full authoritative read' \
  'STOP/DO NOT SKIP' \
  'checkpoint blocking' \
  'module evidence' \
  'GitHub Flow safety' \
  'parent-owned APPLY' \
  'command-output truth'

tap_file_contains_all \
  "Validation suites preserve workflow/resource capsule evidence and non-authority markers" \
  "$PI_VALIDATION_SUITE" \
  'Workflow/resource capsule runtime markers preserve schema, fallback, and non-authority' \
  'Workflow/resource capsule Pi docs preserve source, fallback, and validation-class markers' \
  'Workflow/resource capsule skill map frames capsules as adapter-side context aids' \
  'Capsule:' \
  'Source type' \
  'Derived aid only' \
  'command-output truth' \
  'parent-owned APPLY'


tap_file_contains_all \
  "Workflow/resource capsule contract closure evidence preserves shared invariant boundaries" \
  "$REPO_ROOT/docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md" \
  'Phase 210/211 historical baseline' \
  'Phase 212 closure-entry baseline' \
  'PR #127' \
  'Pi 196/196' \
  'cross-harness 111/111' \
  'Pi 197/197' \
  'cross-harness 112/112' \
  '.paul/*' \
  'STOP/DO NOT SKIP' \
  'checkpoint blocking' \
  'module evidence' \
  'GitHub Flow safety' \
  'parent-owned APPLY' \
  'command-output truth' \
  'validation class affected' \
  'shared-invariant preservation rationale' \
  'full authoritative read'

# Kernel layered-artifact assets
if [ -f "$REPO_ROOT/kernel/templates/PRD.md" ]; then
  tap_ok "Kernel includes PRD.md template"
else
  tap_not_ok "Kernel includes PRD.md template" "File not found at kernel/templates/PRD.md"
fi

if grep -q 'PRD.md' "$REPO_ROOT/docs/ARTIFACT-SPEC.md" 2>/dev/null   && grep -q 'PRD.md' "$REPO_ROOT/docs/ADAPTER-CONTRACT.md" 2>/dev/null   && grep -q 'templates/PRD.md' "$REPO_ROOT/docs/KERNEL-MANIFEST.md" 2>/dev/null; then
  tap_ok "Shared docs describe the layered PROJECT.md + PRD.md contract"
else
  tap_not_ok "Shared docs describe the layered PROJECT.md + PRD.md contract" "Expected PRD.md references in artifact/adapter/manifest docs"
fi

# PROJECT.md required sections
PROJECT_MD="$PAUL_DIR/PROJECT.md"
if [ -f "$PROJECT_MD" ]; then
  tap_ok "PROJECT.md exists"
  for section_name in "Description" "Core Value"; do
    if grep -qi "## $section_name\|^## .*$section_name" "$PROJECT_MD" 2>/dev/null; then
      tap_ok "PROJECT.md has '$section_name' section"
    else
      tap_not_ok "PROJECT.md has '$section_name' section" "Section not found"
    fi
  done

  if grep -q '## Scope Snapshot' "$PROJECT_MD" 2>/dev/null; then
    tap_ok "PROJECT.md uses hot-path scope snapshot structure"
  else
    tap_ok "Legacy PROJECT.md without hot-path scope snapshot is allowed"
  fi
else
  tap_not_ok "PROJECT.md exists" "File not found at $PROJECT_MD"
fi

PRD_MD="$PAUL_DIR/PRD.md"
if [ -f "$PRD_MD" ]; then
  tap_ok "PRD.md exists"
  for section_name in "Problem / Opportunity" "Requirements" "Open Questions"; do
    if grep -qi "## $section_name\|^## .*$section_name" "$PRD_MD" 2>/dev/null; then
      tap_ok "PRD.md has '$section_name' section"
    else
      tap_not_ok "PRD.md has '$section_name' section" "Section not found"
    fi
  done
else
  tap_ok "PRD.md optional for legacy projects"
fi

# ROADMAP.md required sections
ROADMAP_MD="$PAUL_DIR/ROADMAP.md"
if [ -f "$ROADMAP_MD" ]; then
  tap_ok "ROADMAP.md exists"
  if grep -q "## Overview" "$ROADMAP_MD" 2>/dev/null; then
    tap_ok "ROADMAP.md has 'Overview' section"
  else
    tap_not_ok "ROADMAP.md has 'Overview' section" "Section not found"
  fi
  if grep -q "## Milestones\|## Current Milestone\|### v" "$ROADMAP_MD" 2>/dev/null; then
    tap_ok "ROADMAP.md has milestone sections"
  else
    tap_not_ok "ROADMAP.md has milestone sections" "No milestone sections found"
  fi
  # Check for phase table in current milestone
  if grep -q '| Phase |' "$ROADMAP_MD" 2>/dev/null; then
    tap_ok "ROADMAP.md has phase table in current milestone"
  else
    tap_not_ok "ROADMAP.md has phase table in current milestone" "No phase table found"
  fi
else
  tap_not_ok "ROADMAP.md exists" "File not found at $ROADMAP_MD"
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 4: DRIVER MANIFEST COMPLETENESS
# ════════════════════════════════════════════════════════════════════

section "DRIVER MANIFESTS"

DRIVERS_DIR="$REPO_ROOT/drivers"

for driver in claude-code pi; do
  DRIVER_DIR="$DRIVERS_DIR/$driver"
  DRIVER_YAML="$DRIVER_DIR/driver.yaml"

  if [ -f "$DRIVER_YAML" ]; then
    tap_ok "$driver: driver.yaml exists"

    # Check required capability fields
    for cap in workflow_invoke state_read state_write user_interact; do
      if grep -q "$cap:" "$DRIVER_YAML" 2>/dev/null; then
        tap_ok "$driver: declares $cap capability"
      else
        tap_not_ok "$driver: declares $cap capability" "Field not found in driver.yaml"
      fi
    done

    # Check install.sh exists
    if [ -f "$DRIVER_DIR/install.sh" ]; then
      tap_ok "$driver: install.sh exists"
    else
      tap_not_ok "$driver: install.sh exists" "File not found"
    fi

    # Check uninstall.sh exists
    if [ -f "$DRIVER_DIR/uninstall.sh" ]; then
      tap_ok "$driver: uninstall.sh exists"
    else
      tap_not_ok "$driver: uninstall.sh exists" "File not found"
    fi
  else
    tap_not_ok "$driver: driver.yaml exists" "File not found at $DRIVER_YAML"
  fi
done

# Check Pi-specific capability differences are documented
PI_YAML="$DRIVERS_DIR/pi/driver.yaml"
if [ -f "$PI_YAML" ]; then
  HOOK_REG=$(grep 'hook_register:' "$PI_YAML" 2>/dev/null | tr -d ' ')
  CMD_REG=$(grep 'command_register:' "$PI_YAML" 2>/dev/null | tr -d ' ')
  if echo "$HOOK_REG" | grep -q 'true' && echo "$CMD_REG" | grep -q 'true'; then
    tap_ok "Pi driver: runtime capability extensions documented (hook_register=true, command_register=true)"
  else
    tap_not_ok "Pi driver: runtime capability extensions documented" "Expected hook_register: true and command_register: true"
  fi
fi

# ════════════════════════════════════════════════════════════════════
# CATEGORY 5: VALIDATION CLASSIFICATION INVENTORY
# ════════════════════════════════════════════════════════════════════

section "VALIDATION CLASSIFICATION INVENTORY"

# Validation Classification Inventory — Cross-Harness Suite
# Installer Parity => Frozen Legacy Parity / Shared Invariant
# Shared APPLY / REV Boundaries => Shared Invariant / Helper Delegation
# Durable Module Evidence Path => Shared Invariant / Artifact / Process
# Portability Compliance => Shared Invariant / Frozen Legacy Parity
# Shared Collaborative Planning Model => Shared Invariant / Guided UI Safety
# Context-Diet Regression Guardrails => Shared Invariant / Runtime Lens
# CODI Plan-Phase Distribution => Shared Invariant / Helper Delegation
# Artifact Spec Compliance => Shared Invariant / Artifact / Process
# Driver Manifest Completeness => Frozen Legacy Parity / Shared Invariant

tap_file_contains_all \
  "Cross-harness validation suite declares validation classification inventory" \
  "$REPO_ROOT/tests/cross-harness-validation.sh" \
  "Validation Classification Inventory — Cross-Harness Suite" \
  "Installer Parity => Frozen Legacy Parity / Shared Invariant" \
  "Shared APPLY / REV Boundaries => Shared Invariant / Helper Delegation" \
  "Durable Module Evidence Path => Shared Invariant / Artifact / Process" \
  "Portability Compliance => Shared Invariant / Frozen Legacy Parity" \
  "Shared Collaborative Planning Model => Shared Invariant / Guided UI Safety" \
  "Context-Diet Regression Guardrails => Shared Invariant / Runtime Lens" \
  "CODI Plan-Phase Distribution => Shared Invariant / Helper Delegation" \
  "Artifact Spec Compliance => Shared Invariant / Artifact / Process" \
  "Driver Manifest Completeness => Frozen Legacy Parity / Shared Invariant"

# Expected TAP total after Phase 229 v2.53 closure evidence reconciliation: 1..122
if grep -Fq "Validation Classification" "$REPO_ROOT/README.md" \
  && grep -Fq "Pi 203/203" "$REPO_ROOT/README.md" \
  && grep -Fq "cross-harness 119/119" "$REPO_ROOT/README.md" \
  && grep -Fq "Historical validation report" "$REPO_ROOT/docs/VALIDATION-REPORT.md" \
  && grep -Fq "current pass/fail proof" "$REPO_ROOT/docs/VALIDATION-REPORT.md" \
  && grep -Fq "bash tests/pi-end-to-end-validation.sh" "$REPO_ROOT/docs/VALIDATION-REPORT.md" \
  && grep -Fq "bash tests/cross-harness-validation.sh" "$REPO_ROOT/docs/VALIDATION-REPORT.md" \
  && grep -Fq "Phase 220 documentation/report surfacing boundary" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md"; then
  tap_ok "Cross-harness docs/report surfaces validation classification non-authoritatively"
else
  tap_not_ok "Cross-harness docs/report surfaces validation classification non-authoritatively" "Expected shared docs/report surfaces to preserve classification baseline and non-authority markers"
fi

if grep -Fq "Phase 218" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "Phase 219" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "Phase 220" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "Phase 221" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "v2.51 closure" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "PR #133" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "PR #134" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "PR #135" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "Shared Invariant" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "Artifact / Process" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "202→203" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "118→119" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "fresh command output remains authoritative" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "Legacy Retention / Install-Surface Cleanup moved to v2.52" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md"; then
  tap_ok "Cross-harness validation classification milestone closure evidence is reconciled"
else
  tap_not_ok "Cross-harness validation classification milestone closure evidence is reconciled" "Expected shared final v2.51 closure evidence, PR chain, class markers, count reconciliation, command-output truth, and cleanup handoff markers"
fi

if grep -Fq "frozen legacy/source-only" "$REPO_ROOT/README.md" \
  && grep -Fq "PALS_DRIVER=claude-code" "$REPO_ROOT/README.md" \
  && grep -Fq "PALS_DRIVER=agent-sdk" "$REPO_ROOT/README.md" \
  && grep -Fq "PALS_DRIVER=all" "$REPO_ROOT/README.md" \
  && grep -Fq "cross-harness 119/119" "$REPO_ROOT/docs/VALIDATION-REPORT.md" \
  && grep -Fq "Shared Invariant" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "Artifact / Process" "$REPO_ROOT/docs/PI-NATIVE-VALIDATION-CLASSIFICATION-CONTRACT.md" \
  && grep -Fq "command-output truth" "$REPO_ROOT/docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md"; then
  tap_ok "Cross-harness docs/report surfaces install cleanup posture non-authoritatively"
else
  tap_not_ok "Cross-harness docs/report surfaces install cleanup posture non-authoritatively" "Expected shared docs/report/contract surfaces to cite frozen legacy opt-ins, cross-harness 119/119 baseline, Shared Invariant / Artifact Process boundaries, and command-output truth"
fi

if grep -Fq "Phase 225 v2.52 closure evidence" "$REPO_ROOT/docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md" \
  && grep -Fq "PR #137" "$REPO_ROOT/docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md" \
  && grep -Fq "PR #138" "$REPO_ROOT/docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md" \
  && grep -Fq "PR #139" "$REPO_ROOT/docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md" \
  && grep -Fq "Shared Invariant" "$REPO_ROOT/docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md" \
  && grep -Fq "Artifact / Process" "$REPO_ROOT/docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md" \
  && grep -Fq "Frozen Legacy Parity" "$REPO_ROOT/docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md" \
  && grep -Fq "command-output truth remains authoritative" "$REPO_ROOT/docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md" \
  && grep -Fq "120→121" "$REPO_ROOT/docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md"; then
  tap_ok "Cross-harness v2.52 closure evidence preserves shared cleanup boundaries"
else
  tap_not_ok "Cross-harness v2.52 closure evidence preserves shared cleanup boundaries" "Expected v2.52 closure, PR #137/#138/#139, Shared Invariant / Artifact Process / Frozen Legacy Parity, command-output truth, and cross-harness 120→121 markers"
fi

# Phase 229 v2.53 closure guardrail — localized marker-only validation for shared milestone closure invariants.
tap_file_contains_all \
  "Cross-harness v2.53 closure evidence preserves shared authority boundaries" \
  "$REPO_ROOT/docs/PI-INTEGRATION-EFFECTIVENESS-CANDIDATE-DESIGN.md" \
  "v2.53 closure" \
  "PR #141" \
  "PR #142" \
  "PR #143" \
  "cross-harness validation 121/121" \
  "121→122" \
  ".paul/* authority" \
  "PLAN/APPLY/UNIFY authority" \
  "module evidence" \
  "GitHub Flow safety" \
  "parent-owned APPLY" \
  "explicit approval/checkpoint boundaries" \
  "command-output truth" \
  "full authoritative read fallback"
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
