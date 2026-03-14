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

# ── 2. Detect and run driver installer(s) ─────────────────────────
# Strategy:
#   - PALS_DRIVER env var → install that one driver only
#   - Otherwise: auto-detect ALL available harnesses and install for each
#   - Multiple drivers can coexist (different install paths, no conflict)
#   - Fallback: claude-code if nothing detected

DRIVERS_INSTALLED=0

run_driver() {
  local DRIVER="$1"
  local DRIVER_DIR="$PALS_ROOT/drivers/$DRIVER"
  local DRIVER_INSTALL="$DRIVER_DIR/install.sh"
  if [ ! -d "$DRIVER_DIR" ]; then
    echo "  [WARN] Driver '$DRIVER' not found at $DRIVER_DIR"
    return 1
  fi
  if [ ! -f "$DRIVER_INSTALL" ]; then
    echo "  [skip] Driver '$DRIVER' has no install.sh"
    return 0
  fi
  echo "  [ok] Installing driver: $DRIVER"
  bash "$DRIVER_INSTALL"
  DRIVERS_INSTALLED=$((DRIVERS_INSTALLED + 1))
}

if [ -n "$PALS_DRIVER" ]; then
  # Explicit override: install only the specified driver
  run_driver "$PALS_DRIVER"
else
  # Auto-detect: install for every detected harness
  if [ -d "$HOME/.claude" ]; then
    run_driver "claude-code"
  fi
  if [ -d "$HOME/.pi" ]; then
    run_driver "pi"
  fi
  if [ -n "$ANTHROPIC_AGENT_SDK" ]; then
    run_driver "agent-sdk"
  fi
  # Fallback: if nothing detected, default to claude-code
  if [ $DRIVERS_INSTALLED -eq 0 ]; then
    echo "  [info] No harness detected, defaulting to claude-code"
    run_driver "claude-code"
  fi
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
if [ -d "$HOME/.claude/commands/paul" ]; then
  check_path ~/.pals/modules.yaml
  check_path ~/.claude/commands/paul
  check_path ~/.claude/settings.json
fi
if [ -d "$HOME/.pi/agent/skills/pals" ]; then
  check_path ~/.pi/agent/skills/pals/workflows
  check_path ~/.pi/agent/skills/pals/modules.yaml
fi

if [ $ERRORS -gt 0 ]; then
  echo ""
  echo "INSTALL FAILED: $ERRORS validation errors above."
  exit 1
fi

# ── 4. Summary ──────────────────────────────────────────────────
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
" 2>/dev/null || echo "0")

echo ""
echo "════════════════════════════════════════"
echo "PALS installed successfully!"
echo "════════════════════════════════════════"
echo ""
echo "  Drivers installed:    $DRIVERS_INSTALLED"
echo "  ~/.pals/              Framework (kernel + $MODULE_COUNT modules)"
if [ -d "$HOME/.claude/commands/paul" ]; then
  PALS_CMD_COUNT=$(find ~/.claude/commands/paul -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  echo "  ~/.claude/commands/   $PALS_CMD_COUNT kernel commands + module commands"
  echo "  ~/.claude/hooks/      Platform hooks (symlinks)"
fi
if [ -d "$HOME/.pi/agent/skills/pals" ]; then
  echo "  ~/.pi/agent/skills/   Pi skill (kernel + modules)"
fi
echo ""
echo "Start a new session in your harness to use PALS."
