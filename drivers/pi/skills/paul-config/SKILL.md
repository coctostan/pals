---
name: paul-config
description: "Manage PALS module configuration and integrations. View, enable, and disable modules and integrations via pals.json."
---

# PAUL Config

Manage PALS module configuration, integrations, and preferences.

## What This Does

Reads the project's `pals.json` and the installed module registry to:
- Show all installed modules with their enable/disable status
- Toggle modules on/off
- Manage integrations (SonarQube)
- Edit preferences (auto_commit, verbose_output)
- View raw config

## How to Execute

1. Read the config command definition:
   - File: `../commands/paul/config.md`
2. Read the installed module registry (MUST — installed at ../modules.yaml):
   - File: `../modules.yaml`
   - This is the source of truth for which modules exist
3. Follow the config command process:
   - Locate project pals.json (project root where .paul/ exists)
   - Read modules from installed modules.yaml (not a hardcoded list)
   - Display dashboard showing all installed modules with status
   - Handle user toggle/edit requests
   - Write updated pals.json

## Key Behavior

- Module list comes from installed modules.yaml, not hardcoded
- Modules not in project pals.json shown as `[on]*` (default: enabled)
- Toggling a module not yet in pals.json adds it first, then toggles
- Module enable/disable is informational until per-project runtime disable is implemented
- Never modifies modules.yaml — only reads it for the module list

## Output

- pals.json updated with user's changes
- Dashboard display of current configuration
- Clear indication of what changed
