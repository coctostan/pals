#!/bin/bash
set -e

# ════════════════════════════════════════
# PALS Uninstaller
# ════════════════════════════════════════
# Removes all PALS-installed files from ~/.pals/ and ~/.claude/

# ── Check if installed ───────────────────────────────────────────
if [ ! -d "$HOME/.pals" ]; then
  echo "PALS not installed, nothing to remove."
  exit 0
fi

echo "Uninstalling PALS ..."

# ── 1. Remove framework files ───────────────────────────────────
rm -rf "$HOME/.pals"
echo "  [ok] Removed ~/.pals/"

# ── 2. Remove commands ──────────────────────────────────────────
rm -rf "$HOME/.claude/commands/pals"
rm -rf "$HOME/.claude/commands/carl"
echo "  [ok] Removed ~/.claude/commands/pals/ and carl/"

# ── 3. Remove hook ──────────────────────────────────────────────
rm -f "$HOME/.claude/hooks/carl-hook.py"
echo "  [ok] Removed ~/.claude/hooks/carl-hook.py"

# ── 4. Deregister hook from settings.json ────────────────────────
SETTINGS_FILE="$HOME/.claude/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
  python3 - "$SETTINGS_FILE" <<'PYEOF'
import json, sys, os

settings_path = sys.argv[1]

with open(settings_path, 'r') as f:
    settings = json.load(f)

changed = False

if 'hooks' in settings and 'UserPromptSubmit' in settings['hooks']:
    original_len = len(settings['hooks']['UserPromptSubmit'])
    settings['hooks']['UserPromptSubmit'] = [
        entry for entry in settings['hooks']['UserPromptSubmit']
        if not any('carl-hook' in h.get('command', '') for h in entry.get('hooks', []))
    ]
    if len(settings['hooks']['UserPromptSubmit']) < original_len:
        changed = True

    # Clean up empty structures
    if not settings['hooks']['UserPromptSubmit']:
        del settings['hooks']['UserPromptSubmit']
    if not settings['hooks']:
        del settings['hooks']

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')

if changed:
    print("  [ok] Hook deregistered from settings.json")
else:
    print("  [skip] No hook entry found in settings.json")
PYEOF
fi

# ── 5. Summary ──────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "PALS uninstalled successfully."
echo "════════════════════════════════════════"
