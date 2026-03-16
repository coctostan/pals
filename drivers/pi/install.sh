#!/bin/bash
set -e

# ════════════════════════════════════════
# PALS Pi Driver Installer
# ════════════════════════════════════════
# Installs PALS kernel, Pi skills, and the Pi extension into Pi's runtime directories.
# Pi uses skills as the canonical workflow entry surface and the extension as the
# Pi-native command/hook layer, so this installer copies both and generates a
# modules.yaml registry for module-backed references.
#
# Expected environment:
#   PALS_ROOT — path to the PALS git repo
#   HOME      — user home directory

if [ -z "$PALS_ROOT" ]; then
  echo "ERROR: PALS_ROOT not set. This script is called by the root installer."
  exit 1
fi

# ── Target directory ─────────────────────────────────────────────
SKILL_DIR="$HOME/.pi/agent/skills/pals"

# ── 1. Create skill directory structure ──────────────────────────
mkdir -p "$SKILL_DIR/workflows"
mkdir -p "$SKILL_DIR/references"
mkdir -p "$SKILL_DIR/templates"
mkdir -p "$SKILL_DIR/rules"
echo "  [ok] Skill directory created: ~/.pi/agent/skills/pals/"

# ── 2. Copy kernel files ────────────────────────────────────────
KERNEL_DIR="$PALS_ROOT/kernel"
KERNEL_FILE_COUNT=0

for subdir in workflows references templates rules; do
  src="$KERNEL_DIR/$subdir"
  dst="$SKILL_DIR/$subdir"
  if [ -d "$src" ]; then
    cp -R "$src/"* "$dst/" 2>/dev/null || true
    count=$(find "$src" -type f 2>/dev/null | wc -l | tr -d ' ')
    KERNEL_FILE_COUNT=$((KERNEL_FILE_COUNT + count))
  fi
done

echo "  [ok] Kernel files installed: $KERNEL_FILE_COUNT files"

# ── 3. Copy Pi skill files ───────────────────────────────────────
PI_SKILLS_DIR="$PALS_ROOT/drivers/pi/skills"
SKILL_COUNT=0

if [ -d "$PI_SKILLS_DIR" ]; then
  for skill_dir_path in "$PI_SKILLS_DIR"/*/; do
    skill_name="$(basename "$skill_dir_path")"
    if [ -f "$skill_dir_path/SKILL.md" ]; then
      mkdir -p "$SKILL_DIR/$skill_name"
      cp "$skill_dir_path/SKILL.md" "$SKILL_DIR/$skill_name/SKILL.md"
      SKILL_COUNT=$((SKILL_COUNT + 1))
    fi
  done
fi

echo "  [ok] Pi skills installed: $SKILL_COUNT skills"

# ── 4. Copy Pi extension ─────────────────────────────────────────
EXT_SRC="$PALS_ROOT/drivers/pi/extensions/pals-hooks.ts"
EXT_DIR="$HOME/.pi/agent/extensions"

if [ -f "$EXT_SRC" ]; then
  mkdir -p "$EXT_DIR"
  cp "$EXT_SRC" "$EXT_DIR/pals-hooks.ts"
  echo "  [ok] Pi extension installed: ~/.pi/agent/extensions/pals-hooks.ts"
else
  echo "  [skip] No pals-hooks.ts extension found"
fi

# ── 5. Module discovery and installation ─────────────────────────
# Python handles: reading pals.json, parsing module.yaml manifests,
# copying module files, and generating modules.yaml registry.

python3 - "$PALS_ROOT" "$HOME" <<'PYEOF'
import sys, os, json, shutil
from datetime import datetime, timezone

pals_root = sys.argv[1]
home = sys.argv[2]
skill_dir = os.path.join(home, '.pi', 'agent', 'skills', 'pals')
modules_src = os.path.join(pals_root, 'modules')


def parse_module_yaml(filepath):
    """Parse module.yaml without PyYAML. Handles the known manifest structure."""
    with open(filepath, 'r') as f:
        lines = f.readlines()

    result = {}
    path = []
    indents = [0]
    list_key = None
    list_items = []
    list_indent = 0

    def flush_list():
        nonlocal list_key, list_items, list_indent
        if list_key is not None:
            _set_nested(result, path + [list_key], list_items)
            list_key = None
            list_items = []
            list_indent = 0

    def _set_nested(d, keys, value):
        for k in keys[:-1]:
            if k not in d:
                d[k] = {}
            d = d[k]
        d[keys[-1]] = value

    i = 0
    while i < len(lines):
        raw = lines[i]
        stripped = raw.strip()
        i += 1

        if not stripped or stripped.startswith('#'):
            continue

        indent = len(raw) - len(raw.lstrip())

        # Handle list items
        if stripped.startswith('- '):
            item_content = stripped[2:].strip()

            if ':' in item_content:
                entry = {}
                k, v = item_content.split(':', 1)
                entry[k.strip()] = v.strip().strip('"').strip("'")
                while i < len(lines):
                    next_raw = lines[i]
                    next_stripped = next_raw.strip()
                    next_indent = len(next_raw) - len(next_raw.lstrip())
                    if not next_stripped or next_stripped.startswith('#'):
                        i += 1
                        continue
                    if next_indent <= indent or next_stripped.startswith('- '):
                        break
                    if ':' in next_stripped:
                        nk, nv = next_stripped.split(':', 1)
                        entry[nk.strip()] = nv.strip().strip('"').strip("'")
                    i += 1
                list_items.append(entry)
            else:
                list_items.append(item_content.strip('"').strip("'"))
            continue

        flush_list()

        if ':' not in stripped:
            continue

        colon_pos = stripped.index(':')
        key = stripped[:colon_pos].strip()
        value = stripped[colon_pos + 1:].strip()

        while len(indents) > 1 and indent <= indents[-1]:
            path.pop()
            indents.pop()

        if value in ('', '>', '|'):
            j = i
            while j < len(lines) and not lines[j].strip():
                j += 1
            if j < len(lines):
                peek = lines[j].strip()
                if peek.startswith('- '):
                    list_key = key
                    list_items = []
                    list_indent = indent
                else:
                    peek_indent = len(lines[j]) - len(lines[j].lstrip())
                    if ':' in peek and peek_indent > indent:
                        _set_nested(result, path + [key], {})
                        path.append(key)
                        indents.append(indent)
                    else:
                        text_parts = []
                        while j < len(lines):
                            nl = lines[j].strip()
                            ni = len(lines[j]) - len(lines[j].lstrip())
                            if nl and ni <= indent:
                                break
                            if nl:
                                text_parts.append(nl)
                            j += 1
                        _set_nested(result, path + [key], ' '.join(text_parts))
                        i = j
            else:
                _set_nested(result, path + [key], {})
        elif value == '[]':
            _set_nested(result, path + [key], [])
        elif value == '{}':
            _set_nested(result, path + [key], {})
        elif value.startswith('[') and value.endswith(']'):
            items = [x.strip().strip('"').strip("'") for x in value[1:-1].split(',') if x.strip()]
            _set_nested(result, path + [key], items)
        else:
            v = value.strip('"').strip("'")
            if v == 'true': v = True
            elif v == 'false': v = False
            _set_nested(result, path + [key], v)

    flush_list()
    return result


def copy_file(src, dst):
    """Copy a single file, creating parent dirs."""
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    if os.path.isdir(src):
        if os.path.exists(dst):
            shutil.rmtree(dst)
        shutil.copytree(src, dst)
    else:
        shutil.copy2(src, dst)


# ── Read pals.json for active modules ─────────────────────────────
pals_json_path = os.path.join(pals_root, 'pals.json')
if os.path.exists(pals_json_path):
    with open(pals_json_path, 'r') as f:
        pals_config = json.load(f)
else:
    pals_config = {}
modules_config = pals_config.get('modules', {})

# ── Discover and install modules ──────────────────────────────────
if not os.path.isdir(modules_src):
    print("  [skip] No modules directory found")
    sys.exit(0)

installed = {}

for mod_name in sorted(os.listdir(modules_src)):
    mod_dir = os.path.join(modules_src, mod_name)
    manifest_path = os.path.join(mod_dir, 'module.yaml')

    if not os.path.isdir(mod_dir) or not os.path.exists(manifest_path):
        continue

    # Check enabled status (default: true if not in config)
    mod_cfg = modules_config.get(mod_name, {})
    if isinstance(mod_cfg, dict) and mod_cfg.get('enabled') is False:
        print(f"  [skip] {mod_name} module (disabled in pals.json)")
        continue

    manifest = parse_module_yaml(manifest_path)
    display = manifest.get('display_name', mod_name.upper())
    version = manifest.get('version', 'unknown')
    files_section = manifest.get('files', {})

    # ── Copy module files: references, workflows, templates, rules ──
    file_categories = {
        'references': os.path.join(skill_dir, 'references'),
        'workflows':  os.path.join(skill_dir, 'workflows'),
        'templates':  os.path.join(skill_dir, 'templates'),
        'rules':      os.path.join(skill_dir, 'rules'),
    }
    for category, dest_dir in file_categories.items():
        file_list = files_section.get(category, [])
        if not isinstance(file_list, list):
            continue
        for rel_path in file_list:
            src = os.path.join(mod_dir, rel_path)
            if os.path.exists(src):
                dst = os.path.join(dest_dir, os.path.basename(rel_path))
                copy_file(src, dst)

    # ── Config files (preserve existing user config) ─────────────
    config_files = files_section.get('config', [])
    if isinstance(config_files, list):
        for rel_path in config_files:
            src = os.path.join(mod_dir, rel_path)
            if not os.path.exists(src):
                continue
            dst = os.path.join(skill_dir, mod_name, os.path.basename(rel_path))
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            if os.path.exists(dst):
                print(f"  [skip] {mod_name}/{os.path.basename(rel_path)} (user config preserved)")
            else:
                copy_file(src, dst)

    # ── Track installed module ────────────────────────────────────
    lifecycle_hooks = list(manifest.get('hooks', {}).keys()) if isinstance(manifest.get('hooks'), dict) else []
    installed[mod_name] = {
        'version': version,
        'hooks': lifecycle_hooks,
    }

    print(f"  [ok] {display} module installed")

# ── Generate modules.yaml ─────────────────────────────────────────
now = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
lines = ['kernel_version: "2.0.0"', 'installed_modules:']

for name in sorted(installed):
    info = installed[name]
    lines.append(f'  {name}:')
    lines.append(f'    version: "{info["version"]}"')
    lines.append(f'    installed_at: "{now}"')
    hooks_str = ', '.join(info['hooks'])
    lines.append(f'    hooks: [{hooks_str}]')

modules_yaml_path = os.path.join(skill_dir, 'modules.yaml')
with open(modules_yaml_path, 'w') as f:
    f.write('\n'.join(lines) + '\n')

print(f"  [ok] modules.yaml generated ({len(installed)} modules)")
PYEOF

# ── 6. Summary ───────────────────────────────────────────────────
echo ""
echo "  Pi driver installation complete."
echo "  Skill path: ~/.pi/agent/skills/pals/"
