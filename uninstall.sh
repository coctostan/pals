#!/bin/bash
set -e

# ════════════════════════════════════════
# PALS Uninstaller
# ════════════════════════════════════════
# Delegates to the active driver's uninstaller, then removes ~/.pals/

PALS_ROOT="$(cd "$(dirname "$0")" && pwd)"
export PALS_ROOT

# ── Check if installed ───────────────────────────────────────────
if [ ! -d "$HOME/.pals" ]; then
  echo "PALS not installed, nothing to remove."
  exit 0
fi

echo "Uninstalling PALS ..."

# ── 1. Detect and run driver uninstaller ─────────────────────────
# Same detection order as install.sh
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
DRIVER_UNINSTALL="$DRIVER_DIR/uninstall.sh"

if [ -f "$DRIVER_UNINSTALL" ]; then
  bash "$DRIVER_UNINSTALL"
else
  echo "  [skip] No driver uninstaller for '$DRIVER'"
fi

# ── 2. Remove framework files ───────────────────────────────────
rm -rf "$HOME/.pals"
echo "  [ok] Removed ~/.pals/"

# ── 3. Summary ──────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "PALS uninstalled successfully."
echo "════════════════════════════════════════"
