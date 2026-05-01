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

EXT_DIR="$HOME/.pi/agent/extensions"
# Resolve the repo-owned Pi extension source set so uninstall removes only files
# whose basename matches a repo extension. This generalizes the earlier per-file
# special cases (pals-hooks.ts, module-activity-parsing.ts).
PALS_ROOT_RESOLVED=""
if [ -n "${PALS_ROOT:-}" ] && [ -d "$PALS_ROOT/drivers/pi/extensions" ]; then
  PALS_ROOT_RESOLVED="$PALS_ROOT"
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  CANDIDATE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
  if [ -d "$CANDIDATE_ROOT/drivers/pi/extensions" ]; then
    PALS_ROOT_RESOLVED="$CANDIDATE_ROOT"
  fi
fi

echo ""
echo "  This will remove:"
echo "    - Canonical Pi skills under ~/.pi/agent/skills/pals/"
echo "    - Repo-owned Pi extension *.ts files installed under ~/.pi/agent/extensions/ (by basename)"
echo "    - ~/.pi/agent/skills/pals/"
if [ -n "$PALS_ROOT_RESOLVED" ]; then
  for ext_src in "$PALS_ROOT_RESOLVED/drivers/pi/extensions"/*.ts; do
    [ -f "$ext_src" ] || continue
    echo "    - $EXT_DIR/$(basename "$ext_src") (if present)"
  done
else
  # Fallback list: known current PALS extension files when source set is unavailable.
  echo "    - $EXT_DIR/pals-hooks.ts (if present)"
  echo "    - $EXT_DIR/module-activity-parsing.ts (if present)"
fi
printf "  Continue? [y/N] "
read -r REPLY < /dev/tty 2>/dev/null || REPLY="n"

if [ "$REPLY" != "y" ] && [ "$REPLY" != "Y" ]; then
  echo "  [skip] Uninstall cancelled."
  exit 0
fi

rm -rf "$SKILL_DIR"
echo "  [ok] Removed ~/.pi/agent/skills/pals/"

# Generalized extension removal: iterate the repo-owned extension source set when
# available, otherwise fall back to known current PALS extension basenames. Never
# broad-delete unrelated Pi extensions.
EXT_REMOVED_COUNT=0
if [ -n "$PALS_ROOT_RESOLVED" ]; then
  for ext_src in "$PALS_ROOT_RESOLVED/drivers/pi/extensions"/*.ts; do
    [ -f "$ext_src" ] || continue
    ext_base="$(basename "$ext_src")"
    target="$EXT_DIR/$ext_base"
    if [ -f "$target" ]; then
      rm -f "$target"
      echo "  [ok] Removed $target"
      EXT_REMOVED_COUNT=$((EXT_REMOVED_COUNT + 1))
    else
      echo "  [skip] $target not present"
    fi
  done
else
  for ext_base in pals-hooks.ts module-activity-parsing.ts; do
    target="$EXT_DIR/$ext_base"
    if [ -f "$target" ]; then
      rm -f "$target"
      echo "  [ok] Removed $target"
      EXT_REMOVED_COUNT=$((EXT_REMOVED_COUNT + 1))
    else
      echo "  [skip] $target not present"
    fi
  done
fi
echo "  [ok] Pi extensions removed: $EXT_REMOVED_COUNT files"

echo "  Pi driver uninstall complete."
