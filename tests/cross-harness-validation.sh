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
  && grep -q 'durable post-unify report' "$REPO_ROOT/modules/ruby/module.yaml"; then
  tap_ok "Post-unify module overlays align with the durable reporting model"
else
  tap_not_ok "Post-unify module overlays align with the durable reporting model" "Expected durable post-unify reporting markers in WALT workflow and RUBY manifest"
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
