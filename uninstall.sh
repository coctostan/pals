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

# ── 1. Remove module artifacts from ~/.claude/ (manifest-driven) ──
# Reads modules.yaml to find module commands and platform hooks,
# then removes them from ~/.claude/ before wiping ~/.pals/.

python3 - "$HOME" <<'PYEOF'
import json, sys, os

home = sys.argv[1]
pals_dir = os.path.join(home, '.pals')
claude_dir = os.path.join(home, '.claude')
modules_yaml = os.path.join(pals_dir, 'modules.yaml')

if not os.path.exists(modules_yaml):
    print("  [skip] No modules.yaml found — skipping per-module cleanup")
    sys.exit(0)

# Parse modules.yaml to find installed modules
with open(modules_yaml) as f:
    lines = f.readlines()

modules = {}
current_mod = None
for line in lines:
    stripped = line.strip()
    if line.startswith('  ') and not line.startswith('    ') and ':' in stripped:
        key = stripped.split(':')[0].strip()
        if key not in ('kernel_version',):
            current_mod = key
            modules[current_mod] = {}
    elif current_mod and line.startswith('    ') and ':' in stripped:
        k, v = stripped.split(':', 1)
        modules[current_mod][k.strip()] = v.strip()

# For each module, remove commands and hooks from ~/.claude/
for mod_name in modules:
    # Remove command directories
    cmd_dir = os.path.join(claude_dir, 'commands', mod_name)
    if os.path.isdir(cmd_dir):
        import shutil
        shutil.rmtree(cmd_dir)
        print(f"  [ok] Removed ~/.claude/commands/{mod_name}/")

    # Remove hook symlinks
    hooks_dir = os.path.join(claude_dir, 'hooks')
    if os.path.isdir(hooks_dir):
        for f_name in os.listdir(hooks_dir):
            link_path = os.path.join(hooks_dir, f_name)
            if os.path.islink(link_path):
                target = os.readlink(link_path)
                if f'/modules/{mod_name}/' in target:
                    os.remove(link_path)
                    print(f"  [ok] Removed hook symlink: ~/.claude/hooks/{f_name}")

# Deregister all PALS-related hooks from settings.json
settings_path = os.path.join(claude_dir, 'settings.json')
if os.path.exists(settings_path):
    with open(settings_path, 'r') as f:
        settings = json.load(f)

    changed = False
    if 'hooks' in settings:
        for event in list(settings['hooks'].keys()):
            original_len = len(settings['hooks'][event])
            settings['hooks'][event] = [
                entry for entry in settings['hooks'][event]
                if not any(
                    'pals' in h.get('command', '').lower() or
                    any(mn in h.get('command', '') for mn in modules)
                    for h in entry.get('hooks', [])
                )
            ]
            if len(settings['hooks'][event]) < original_len:
                changed = True
            if not settings['hooks'][event]:
                del settings['hooks'][event]
        if not settings['hooks']:
            del settings['hooks']

    with open(settings_path, 'w') as f:
        json.dump(settings, f, indent=2)
        f.write('\n')

    if changed:
        print("  [ok] Hooks deregistered from settings.json")
    else:
        print("  [skip] No hook entries found in settings.json")
PYEOF

# ── 2. Remove framework files ───────────────────────────────────
rm -rf "$HOME/.pals"
echo "  [ok] Removed ~/.pals/"

# ── 3. Remove kernel commands ────────────────────────────────────
rm -rf "$HOME/.claude/commands/paul"
echo "  [ok] Removed ~/.claude/commands/paul/"

# ── 4. Clean up stale namespaces ─────────────────────────────────
if [ -d "$HOME/.claude/commands/pals" ]; then
  rm -rf "$HOME/.claude/commands/pals"
  echo "  [ok] Removed stale ~/.claude/commands/pals/"
fi

# ── 5. Remove legacy PAUL framework (pre-PALS installation) ──────
if [ -d "$HOME/.claude/paul-framework" ]; then
  rm -rf "$HOME/.claude/paul-framework"
  echo "  [ok] Removed legacy ~/.claude/paul-framework/"
fi

# ── 6. Summary ──────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
echo "PALS uninstalled successfully."
echo "════════════════════════════════════════"
