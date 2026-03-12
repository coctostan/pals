#!/bin/bash
set -e

# ════════════════════════════════════════
# PALS Installer
# ════════════════════════════════════════
# Deploys PALS framework from git clone to ~/.pals/
# Then delegates to the active driver for platform-specific setup.
# Usage: git clone <repo> && cd pals && ./install.sh

PALS_ROOT="$(cd "$(dirname "$0")" && pwd)"
export PALS_ROOT

# ── Validate repo structure ──────────────────────────────────────
if [ ! -d "$PALS_ROOT/kernel/workflows" ] || [ ! -d "$PALS_ROOT/modules" ] || [ ! -d "$PALS_ROOT/drivers" ]; then
  echo "ERROR: install.sh must be run from the PALS repo root."
  echo "Expected directories: kernel/workflows/, modules/, drivers/"
  exit 1
fi

echo "Installing PALS from $PALS_ROOT ..."

# ── 1. Install kernel files to ~/.pals/ ──────────────────────────
mkdir -p ~/.pals/workflows ~/.pals/references ~/.pals/templates ~/.pals/rules

# Kernel framework files (always overwrite on upgrade)
cp -R "$PALS_ROOT/kernel/workflows/"* ~/.pals/workflows/
cp -R "$PALS_ROOT/kernel/references/"* ~/.pals/references/
cp -R "$PALS_ROOT/kernel/templates/"* ~/.pals/templates/
cp -R "$PALS_ROOT/kernel/rules/"* ~/.pals/rules/

echo "  [ok] Kernel files installed to ~/.pals/"

# ── 2. Detect and run driver installer ───────────────────────────
# Driver detection order:
#   1. PALS_DRIVER env var (explicit override)
#   2. ~/.claude/ directory presence → claude-code
#   3. ANTHROPIC_AGENT_SDK env var → agent-sdk
#   4. Fallback: claude-code (default)

if [ -n "$PALS_DRIVER" ]; then
  DRIVER="$PALS_DRIVER"
elif [ -d "$HOME/.claude" ]; then
  DRIVER="claude-code"
elif [ -n "$ANTHROPIC_AGENT_SDK" ]; then
  DRIVER="agent-sdk"
else
  DRIVER="claude-code"
fi

DRIVER_DIR="$PALS_ROOT/drivers/$DRIVER"
if [ ! -d "$DRIVER_DIR" ]; then
  echo "ERROR: Driver '$DRIVER' not found at $DRIVER_DIR"
  echo "Available drivers:"
  ls -1 "$PALS_ROOT/drivers/"
  exit 1
fi

DRIVER_INSTALL="$DRIVER_DIR/install.sh"
if [ ! -f "$DRIVER_INSTALL" ]; then
  echo "  [skip] Driver '$DRIVER' has no install.sh — kernel-only installation"
else
  echo "  [ok] Driver detected: $DRIVER"
  bash "$DRIVER_INSTALL"
fi

# ── 3. Validation ───────────────────────────────────────────────
ERRORS=0

check_path() {
  if [ ! -e "$1" ]; then
    echo "  [FAIL] Missing: $1"
    ERRORS=$((ERRORS + 1))
  fi
}

check_path ~/.pals/workflows
check_path ~/.pals/references
check_path ~/.pals/templates
check_path ~/.pals/rules

# Driver-specific validation
if [ "$DRIVER" = "claude-code" ]; then
  check_path ~/.pals/modules.yaml
  check_path ~/.claude/commands/paul
  check_path ~/.claude/settings.json
fi

if [ $ERRORS -gt 0 ]; then
  echo ""
  echo "INSTALL FAILED: $ERRORS validation errors above."
  exit 1
fi

# ── 4. Summary ──────────────────────────────────────────────────
PALS_CMD_COUNT=$(find ~/.claude/commands/paul -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
MODULE_COUNT=$(python3 -c "
import os
m = os.path.join(os.path.expanduser('~'), '.pals', 'modules.yaml')
count = 0
if os.path.exists(m):
    with open(m) as f:
        for line in f:
            if line.startswith('  ') and ':' in line and not line.strip().startswith(('version', 'installed', 'hooks', 'platform')):
                count += 1
print(count)
")

echo ""
echo "════════════════════════════════════════"
echo "PALS installed successfully!"
echo "════════════════════════════════════════"
echo ""
echo "  Driver:               $DRIVER"
echo "  ~/.pals/              Framework (kernel + $MODULE_COUNT modules)"
echo "  ~/.pals/modules.yaml  Installed module registry"
if [ "$DRIVER" = "claude-code" ]; then
  echo "  ~/.claude/commands/   $PALS_CMD_COUNT kernel commands + module commands"
  echo "  ~/.claude/hooks/      Platform hooks (symlinks)"
fi
echo ""
echo "Start a new Claude Code session to use PALS."
