#!/bin/bash
set -e

# ════════════════════════════════════════
# PALS Installer
# ════════════════════════════════════════
# Deploys PALS framework from git clone to ~/.pals/ and ~/.claude/
# Usage: git clone <repo> && cd pals && ./install.sh

PALS_ROOT="$(cd "$(dirname "$0")" && pwd)"

# ── Validate repo structure ──────────────────────────────────────
if [ ! -d "$PALS_ROOT/workflows" ] || [ ! -d "$PALS_ROOT/carl" ]; then
  echo "ERROR: install.sh must be run from the PALS repo root."
  echo "Expected directories: workflows/, carl/"
  exit 1
fi

echo "Installing PALS from $PALS_ROOT ..."

# ── 1. Create ~/.pals/ directory structure ───────────────────────
mkdir -p ~/.pals/workflows ~/.pals/references ~/.pals/templates ~/.pals/rules ~/.pals/carl

# Copy framework files (always overwrite on upgrade)
cp -R "$PALS_ROOT/workflows/"* ~/.pals/workflows/
cp -R "$PALS_ROOT/references/"* ~/.pals/references/
cp -R "$PALS_ROOT/templates/"* ~/.pals/templates/
cp -R "$PALS_ROOT/rules/"* ~/.pals/rules/

echo "  [ok] Framework files installed to ~/.pals/"

# ── 2. Install CARL domains (preserve user config) ──────────────
for item in "$PALS_ROOT/carl/"*; do
  name="$(basename "$item")"
  dest="$HOME/.pals/carl/$name"
  if [ -e "$dest" ]; then
    echo "  [skip] ~/.pals/carl/$name (user config preserved)"
  else
    if [ -d "$item" ]; then
      cp -R "$item" "$dest"
    else
      cp "$item" "$dest"
    fi
    echo "  [ok] ~/.pals/carl/$name"
  fi
done

# ── 3. Install commands ─────────────────────────────────────────
mkdir -p ~/.claude/commands/paul ~/.claude/commands/carl

cp -R "$PALS_ROOT/commands/paul/"* ~/.claude/commands/paul/
# carl commands have subdirectories (tasks/, templates/)
cp -R "$PALS_ROOT/commands/carl/"* ~/.claude/commands/carl/

PALS_CMD_COUNT=$(find "$PALS_ROOT/commands/paul" -name "*.md" | wc -l | tr -d ' ')
CARL_CMD_COUNT=$(find "$PALS_ROOT/commands/carl" -name "*.md" | wc -l | tr -d ' ')
echo "  [ok] Commands installed: $PALS_CMD_COUNT paul, $CARL_CMD_COUNT carl"

# ── 4. Install hooks ────────────────────────────────────────────
mkdir -p ~/.claude/hooks

ln -sf "$PALS_ROOT/hooks/carl-hook.py" ~/.claude/hooks/carl-hook.py
chmod +x "$PALS_ROOT/hooks/carl-hook.py"

echo "  [ok] Hook symlinked: ~/.claude/hooks/carl-hook.py"

# ── 5. Register hook in settings.json ───────────────────────────
SETTINGS_FILE="$HOME/.claude/settings.json"
HOOK_CMD="python3 $HOME/.claude/hooks/carl-hook.py"

python3 - "$SETTINGS_FILE" "$HOOK_CMD" <<'PYEOF'
import json, sys, os

settings_path = sys.argv[1]
hook_cmd = sys.argv[2]

# Load or create settings
if os.path.exists(settings_path):
    with open(settings_path, 'r') as f:
        settings = json.load(f)
else:
    settings = {}

# Ensure hooks structure exists
if 'hooks' not in settings:
    settings['hooks'] = {}
if 'UserPromptSubmit' not in settings['hooks']:
    settings['hooks']['UserPromptSubmit'] = []

# Check if carl-hook already registered
already_registered = False
for entry in settings['hooks']['UserPromptSubmit']:
    for hook in entry.get('hooks', []):
        if 'carl-hook' in hook.get('command', ''):
            already_registered = True
            break

if not already_registered:
    settings['hooks']['UserPromptSubmit'].append({
        "hooks": [
            {
                "type": "command",
                "command": hook_cmd
            }
        ]
    })

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)
    f.write('\n')

if already_registered:
    print("  [skip] Hook already registered in settings.json")
else:
    print("  [ok] Hook registered in settings.json")
PYEOF

# ── 6. Validation ───────────────────────────────────────────────
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
check_path ~/.pals/carl
check_path ~/.claude/commands/paul
check_path ~/.claude/commands/carl
check_path ~/.claude/hooks/carl-hook.py
check_path ~/.claude/settings.json

if [ $ERRORS -gt 0 ]; then
  echo ""
  echo "INSTALL FAILED: $ERRORS validation errors above."
  exit 1
fi

# ── 7. Summary ──────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "PALS installed successfully!"
echo "════════════════════════════════════════"
echo ""
echo "  ~/.pals/         Framework files"
echo "  ~/.claude/commands/paul/  $PALS_CMD_COUNT commands"
echo "  ~/.claude/commands/carl/  $CARL_CMD_COUNT commands"
echo "  ~/.claude/hooks/          CARL hook (symlink)"
echo ""
echo "Start a new Claude Code session to use PALS."
