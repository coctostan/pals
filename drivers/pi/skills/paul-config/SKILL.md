---
name: paul-config
description: "Manage PALS module configuration and integrations. View, enable, and disable modules and integrations via pals.json."
---

# PAUL Config

Manage PALS module configuration, integrations, and preferences.

## Canonical command
- `../commands/paul/config.md`
- `../modules.yaml`

## Default output
- Concise by default: show the requested config view/change, evidence source, and one next action.
- Expand for migration, invalid config, write failures, or user-requested detail.

## Command-local notes
- Read project `pals.json` and the installed `../modules.yaml`; the installed registry is the module list source of truth.
- Update only `pals.json`; never modify `modules.yaml`.
- Modules missing from `pals.json` display as `[on]*` by default.
- Toggling a missing module adds it to `pals.json` first, then applies the requested state.
- Per-project module enable/disable is informational until runtime disable is implemented.
- Supported surfaces: module toggles, SonarQube integration, preferences, raw config view.
