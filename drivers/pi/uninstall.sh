#!/bin/bash
set -e

# ════════════════════════════════════════
# PALS Pi Driver Uninstaller
# ════════════════════════════════════════
# Removes PALS canonical skill files and the extension-backed command/hook layer from Pi directories.

SKILL_DIR="$HOME/.pi/agent/skills/pals"

if [ ! -d "$SKILL_DIR" ]; then
  echo "  PALS is not installed for Pi (no directory at ~/.pi/agent/skills/pals/)."
  exit 0
fi

echo ""
echo "  This will remove:"
echo "    - Canonical Pi skills under ~/.pi/agent/skills/pals/"
echo "    - Extension-backed /paul-* command and hook layer at ~/.pi/agent/extensions/pals-hooks.ts"
echo "    - ~/.pi/agent/skills/pals/"
echo "    - ~/.pi/agent/extensions/pals-hooks.ts (and ~/.pi/agent/extensions/module-activity-parsing.ts if present)"
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

rm -f "$HOME/.pi/agent/extensions/module-activity-parsing.ts"
echo "  [ok] Removed ~/.pi/agent/extensions/module-activity-parsing.ts (if present)"

echo "  Pi driver uninstall complete."
