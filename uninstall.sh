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

# ── 1. Detect and run driver uninstaller(s) ───────────────────────
# Mirrors install.sh support posture:
#   - PALS_DRIVER env var → uninstall that one explicit driver only
#   - PALS_DRIVER=all → explicit maintenance opt-in for all driver uninstallers
#   - Otherwise: prefer supported Pi cleanup when a Pi home surface exists
#   - Frozen legacy cleanup requires explicit opt-in

run_driver_uninstall() {
  local DRIVER="$1"
  local DRIVER_DIR="$PALS_ROOT/drivers/$DRIVER"
  local DRIVER_UNINSTALL="$DRIVER_DIR/uninstall.sh"
  if [ -f "$DRIVER_UNINSTALL" ]; then
    echo "  [ok] Uninstalling driver: $DRIVER"
    bash "$DRIVER_UNINSTALL"
  else
    echo "  [skip] No driver uninstaller for '$DRIVER'"
  fi
}

if [ -n "$PALS_DRIVER" ]; then
  if [ "$PALS_DRIVER" = "all" ]; then
    echo "  [info] PALS_DRIVER=all selected: explicit maintenance opt-in for all driver uninstallers."
    run_driver_uninstall "pi"
    run_driver_uninstall "claude-code"
    run_driver_uninstall "agent-sdk"
  else
    run_driver_uninstall "$PALS_DRIVER"
  fi
elif [ -d "$HOME/.pi" ]; then
  run_driver_uninstall "pi"
else
  echo "  [info] Pi is the supported default runtime for PALS."
  echo "  [info] No Pi home surface detected at ~/.pi; skipping driver-specific uninstall by default."
  echo "  [info] To clean up a frozen legacy driver explicitly, rerun with PALS_DRIVER=claude-code or PALS_DRIVER=agent-sdk."
  echo "  [info] For maintenance parity only, use PALS_DRIVER=all."
fi

# ── 2. Remove framework files ───────────────────────────────────
rm -rf "$HOME/.pals"
echo "  [ok] Removed ~/.pals/"

# ── 3. Summary ──────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "PALS uninstalled successfully."
echo "════════════════════════════════════════"
