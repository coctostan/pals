#!/bin/bash
set -e

# ════════════════════════════════════════
# PALS Pi Driver Uninstaller
# ════════════════════════════════════════
# Removes PALS skill files and extension from Pi directories.

SKILL_DIR="$HOME/.pi/agent/skills/pals"

if [ ! -d "$SKILL_DIR" ]; then
  echo "  PALS is not installed for Pi (no directory at ~/.pi/agent/skills/pals/)."
  exit 0
fi

echo ""
echo "  This will remove:"
echo "    - ~/.pi/agent/skills/pals/"
echo "    - ~/.pi/agent/extensions/pals-hooks.ts"
printf "  Continue? [y/N] "
read -r REPLY < /dev/tty 2>/dev/null || REPLY="n"

if [ "$REPLY" != "y" ] && [ "$REPLY" != "Y" ]; then
  echo "  [skip] Uninstall cancelled."
  exit 0
fi

rm -rf "$SKILL_DIR"
echo "  [ok] Removed ~/.pi/agent/skills/pals/"

rm -f "$HOME/.pi/agent/extensions/pals-hooks.ts"
echo "  [ok] Removed ~/.pi/agent/extensions/pals-hooks.ts"

echo "  Pi driver uninstall complete."
