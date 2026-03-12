#!/bin/bash
set -e

# ════════════════════════════════════════
# PALS Claude Code Driver Installer
# ════════════════════════════════════════
# Installs Claude Code-specific files: commands, hooks, settings.json
# Called by root install.sh after kernel files are installed.
#
# Expected environment:
#   PALS_ROOT — path to the PALS git repo
#   HOME      — user home directory

if [ -z "$PALS_ROOT" ]; then
  echo "ERROR: PALS_ROOT not set. This script is called by the root installer."
  exit 1
fi

# ── 0. Detect and clean up legacy installation ────────────────────
LEGACY_DIR="$HOME/.claude/paul-framework"
if [ -d "$LEGACY_DIR" ]; then
  echo ""
  echo "  Legacy PAUL framework detected at ~/.claude/paul-framework/"
  echo "  PALS replaces this at ~/.pals/ — the legacy copy is no longer needed."
  echo ""
  printf "  Remove legacy installation? [y/N] "
  read -r REPLY < /dev/tty 2>/dev/null || REPLY="n"
  if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
    rm -rf "$LEGACY_DIR"
    echo "  [ok] Removed legacy ~/.claude/paul-framework/"
  else
    echo "  [skip] Legacy files left in place (can remove manually later)"
  fi
  echo ""
fi

# ── 1. Install kernel commands ───────────────────────────────────
mkdir -p "$HOME/.claude/commands/paul"
cp -R "$PALS_ROOT/kernel/commands/paul/"* "$HOME/.claude/commands/paul/"
KERNEL_CMD_COUNT=$(find "$PALS_ROOT/kernel/commands/paul" -name "*.md" | wc -l | tr -d ' ')
echo "  [ok] Kernel commands installed: $KERNEL_CMD_COUNT paul"

# ── 2. Install modules (manifest-driven) ─────────────────────────
# Python handles: module discovery, file installation, command installation,
# hook symlinks, settings.json registration, and modules.yaml generation.

python3 - "$PALS_ROOT" "$HOME" <<'PYEOF'
import sys, os, json, shutil
from datetime import datetime, timezone

pals_root = sys.argv[1]
home = sys.argv[2]
pals_dir = os.path.join(home, '.pals')
claude_dir = os.path.join(home, '.claude')
modules_src = os.path.join(pals_root, 'modules')

def parse_module_yaml(filepath):
    """Parse module.yaml without PyYAML. Handles the known manifest structure."""
    with open(filepath, 'r') as f:
        lines = f.readlines()

    result = {}
    path = []        # current key path (e.g., ['files', 'references'])
    indents = [0]    # indent level stack
    list_key = None  # key of current list being built
    list_items = []  # items in current list
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

    def _get_nested(d, keys):
        for k in keys:
            if k not in d:
                return None
            d = d[k]
        return d

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

            # Detect if this starts a list at a new key or continues existing
            if list_key is None:
                # Find which key this list belongs to by looking at path
                # The previous key: with empty/[] value is the list owner
                pass

            if ':' in item_content:
                # Dict item in list (e.g., "- name: carl:manager")
                entry = {}
                k, v = item_content.split(':', 1)
                entry[k.strip()] = v.strip().strip('"').strip("'")
                # Read continuation lines for this dict entry
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
                # Simple string item
                list_items.append(item_content.strip('"').strip("'"))
            continue

        # Not a list item — flush any pending list
        flush_list()

        # Handle key: value
        if ':' not in stripped:
            continue

        colon_pos = stripped.index(':')
        key = stripped[:colon_pos].strip()
        value = stripped[colon_pos + 1:].strip()

        # Adjust path based on indent
        while len(indents) > 1 and indent <= indents[-1]:
            path.pop()
            indents.pop()

        if value in ('', '>', '|'):
            # Check if next content is a list or nested map
            j = i
            while j < len(lines) and not lines[j].strip():
                j += 1
            if j < len(lines):
                peek = lines[j].strip()
                if peek.startswith('- '):
                    # Starting a list
                    list_key = key
                    list_items = []
                    list_indent = indent
                else:
                    # Nested map or multiline string
                    peek_indent = len(lines[j]) - len(lines[j].lstrip())
                    if ':' in peek and peek_indent > indent:
                        # Nested map
                        _set_nested(result, path + [key], {})
                        path.append(key)
                        indents.append(indent)
                    else:
                        # Multiline string
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


# ── Read pals.yaml for active modules ─────────────────────────────
pals_yaml = os.path.join(pals_root, 'pals.yaml')
config = parse_module_yaml(pals_yaml) if os.path.exists(pals_yaml) else {}
modules_config = config.get('modules', {})

# ── Discover and install modules ──────────────────────────────────
installed = {}
total_cmd_count = 0

for mod_name in sorted(os.listdir(modules_src)):
    mod_dir = os.path.join(modules_src, mod_name)
    manifest_path = os.path.join(mod_dir, 'module.yaml')

    if not os.path.isdir(mod_dir) or not os.path.exists(manifest_path):
        continue

    # Check active status (default: true if not in config)
    mod_cfg = modules_config.get(mod_name, {})
    if isinstance(mod_cfg, dict) and mod_cfg.get('active') is False:
        print(f"  [skip] {mod_name} module (disabled in pals.yaml)")
        continue

    manifest = parse_module_yaml(manifest_path)
    display = manifest.get('display_name', mod_name.upper())
    version = manifest.get('version', 'unknown')
    files_section = manifest.get('files', {})

    # ── Files: references, workflows, templates, rules ────────────
    file_categories = {
        'references': os.path.join(pals_dir, 'references'),
        'workflows':  os.path.join(pals_dir, 'workflows'),
        'templates':  os.path.join(pals_dir, 'templates'),
        'rules':      os.path.join(pals_dir, 'rules'),
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

    # ── Files: config (preserve existing user config) ─────────────
    config_files = files_section.get('config', [])
    if isinstance(config_files, list):
        for rel_path in config_files:
            src = os.path.join(mod_dir, rel_path)
            if not os.path.exists(src):
                continue
            dst = os.path.join(pals_dir, mod_name, os.path.basename(rel_path))
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            if os.path.exists(dst):
                print(f"  [skip] ~/.pals/{mod_name}/{os.path.basename(rel_path)} (user config preserved)")
            else:
                copy_file(src, dst)

    # ── Commands ──────────────────────────────────────────────────
    commands = manifest.get('commands', [])
    if isinstance(commands, list):
        for cmd in commands:
            if not isinstance(cmd, dict):
                continue
            cmd_file = cmd.get('file', '')
            if not cmd_file:
                continue
            src = os.path.join(mod_dir, cmd_file)
            if not os.path.exists(src):
                continue
            # Strip "commands/" prefix to get relative install path
            rel = cmd_file[len('commands/'):] if cmd_file.startswith('commands/') else cmd_file
            dst = os.path.join(claude_dir, 'commands', rel)
            copy_file(src, dst)
            total_cmd_count += 1

    # ── Platform hooks (symlink + settings.json registration) ─────
    platform_hooks = []
    platform = manifest.get('platform', {})
    if isinstance(platform, dict):
        cc = platform.get('claude_code', {})
        if isinstance(cc, dict):
            hooks_list = cc.get('hooks', [])
            if isinstance(hooks_list, list):
                for hook_def in hooks_list:
                    if not isinstance(hook_def, dict):
                        continue
                    source = hook_def.get('source', '')
                    event = hook_def.get('event', '')
                    command = hook_def.get('command', '')

                    # Symlink hook file
                    if source:
                        src = os.path.join(mod_dir, source)
                        basename = os.path.basename(source)
                        dst = os.path.join(claude_dir, 'hooks', basename)
                        os.makedirs(os.path.dirname(dst), exist_ok=True)
                        if os.path.islink(dst) or os.path.exists(dst):
                            os.remove(dst)
                        os.symlink(src, dst)
                        os.chmod(src, 0o755)
                        print(f"  [ok] Hook symlinked: ~/.claude/hooks/{basename}")

                    # Register in settings.json
                    if event and command:
                        hook_cmd = command.replace('~', home)
                        settings_path = os.path.join(claude_dir, 'settings.json')

                        settings = {}
                        if os.path.exists(settings_path):
                            with open(settings_path, 'r') as f:
                                settings = json.load(f)

                        settings.setdefault('hooks', {}).setdefault(event, [])

                        # Check if already registered
                        hook_id = os.path.basename(source).replace('.py', '') if source else mod_name
                        already = any(
                            hook_id in h.get('command', '')
                            for entry in settings['hooks'][event]
                            for h in entry.get('hooks', [])
                        )

                        if not already:
                            settings['hooks'][event].append({
                                "hooks": [{"type": "command", "command": hook_cmd}]
                            })

                        with open(settings_path, 'w') as f:
                            json.dump(settings, f, indent=2)
                            f.write('\n')

                        status = "skip" if already else "ok"
                        msg = "already registered" if already else f"registered ({event})"
                        print(f"  [{status}] Hook {msg} in settings.json")

                        platform_hooks.append(event)

    # ── Track installed module ────────────────────────────────────
    lifecycle_hooks = list(manifest.get('hooks', {}).keys()) if isinstance(manifest.get('hooks'), dict) else []
    installed[mod_name] = {
        'version': version,
        'hooks': lifecycle_hooks,
        'platform_hooks': platform_hooks,
    }

    print(f"  [ok] {display} module installed")

# ── Generate modules.yaml ─────────────────────────────────────────
now = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
lines = ['kernel_version: "0.4.0"', 'installed_modules:']

for name in sorted(installed):
    info = installed[name]
    lines.append(f'  {name}:')
    lines.append(f'    version: "{info["version"]}"')
    lines.append(f'    installed_at: "{now}"')
    hooks_str = ', '.join(info['hooks'])
    lines.append(f'    hooks: [{hooks_str}]')
    if info['platform_hooks']:
        ph_str = ', '.join(info['platform_hooks'])
        lines.append(f'    platform_hooks: [{ph_str}]')

modules_yaml_path = os.path.join(pals_dir, 'modules.yaml')
with open(modules_yaml_path, 'w') as f:
    f.write('\n'.join(lines) + '\n')

print(f"  [ok] modules.yaml generated ({len(installed)} modules)")
if total_cmd_count > 0:
    print(f"  [ok] Module commands installed: {total_cmd_count}")
PYEOF
