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

# Check extension installed
EXT_PATH="$TEMP_HOME/.pi/agent/extensions/pals-hooks.ts"
if [ -f "$EXT_PATH" ]; then
  tap_ok "Extension installed: ~/.pi/agent/extensions/pals-hooks.ts"
else
  tap_not_ok "Extension installed" "pals-hooks.ts not found in extensions dir"
fi

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

  # Guardrail: keep a single automatic context injection site
  PUSH_COUNT=$(grep -c 'messages.push' "$EXT_SRC" 2>/dev/null || echo 0)
  if [ "$PUSH_COUNT" -eq 1 ]; then
    tap_ok "Extension keeps a single automatic context injection site"
  else
    tap_not_ok "Extension keeps a single automatic context injection site" "Found $PUSH_COUNT messages.push call(s)"
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
