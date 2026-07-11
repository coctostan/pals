<objective>
Manage PALS module configuration and integrations. View, enable, and disable modules and integrations via pals.json.

**When to use:**
- Toggle modules on/off
- Enable/disable SonarQube integration
- View current configuration
- Change project preferences
</objective>

<process>

**Step 1: Locate and read config**
1. Current project root (where .paul/ exists) — this is the per-project config
2. `kernel/pals.json` (global fallback)
The project root is the directory containing `.paul/`, NOT just the PALS source repo.
**Read the installed module registry** (`modules.yaml` at `../modules.yaml` relative to the skill) to discover all installed modules. This is the source of truth for which modules exist — not a hardcoded list.

Read pals.json and display the module dashboard:

```
════════════════════════════════════════
PALS CONFIGURATION
════════════════════════════════════════

Modules (from installed registry):
  For EACH module in modules.yaml installed_modules:
    - Read module name and description from the registry
    - Check if module exists in project pals.json
    - If exists: show [on] or [off] based on pals.json enabled field
    - If NOT in pals.json: show [on]* with footnote

  * = not in project config, using default: enabled

Integrations:
  SonarQube  [off]

Preferences:
  auto_commit: false
  verbose_output: false

────────────────────────────────────────
[1] Toggle a module
[2] Manage integrations
[3] Edit preferences
[4] View raw config
[5] Done
```

**Module efficacy (from ledger):**

When `.paul/MODULE-LEDGER.md` exists, read its normalized table and append a per-module efficacy view to the dashboard:

```
Module efficacy (from ledger):
  Module  dispatches | findings | actioned  Review
  ARIA            12 |        0 |        0  demotion candidate
  WALT            12 |        0 |        0  enforcement-exempt
```

- Count every valid module row as a dispatch, including `SKIP` and no-scope rows.
- Count `Finding? = yes` and `Actioned? = yes` independently; do not infer either value from status alone.
- Mark zero-finding advisory modules as `demotion candidate` for human review only.
- Never suggest demotion for WALT, DEAN, TODD, or SETH when the ledger shows that module ever had scope; display `enforcement-exempt` instead.
- Any enable/disable or demotion response requires explicit human approval before changing `pals.json`. Never auto-demote, auto-disable, or write config from efficacy output.
- If the ledger is absent, malformed, or contains no valid rows, omit this view and preserve current config behavior unchanged; a malformed ledger may produce a compact warning but must not block normal config use.

**Step 2: Handle user choice**

**[1] Toggle a module:**
```
Which module? (name or number)
  List ALL modules from installed modules.yaml registry,
  numbered sequentially. Show current on/off status from
  pals.json (default: on if not in config).
```
After user selects a module:
- If module not in pals.json yet: add it with current default state first
- Flip its `enabled` boolean in pals.json
- Write updated pals.json
- Show confirmation: `TODD [on] → [off]`
- Re-display dashboard
- Note: Module enable/disable in pals.json is informational until per-project runtime disable is implemented. All installed modules currently dispatch regardless.

**[2] Manage integrations:**
```
Integrations:

  [1] SonarQube  [off]

Select to toggle, or "back" to return.
```

If toggling SonarQube on:
- Prompt for project_key (default: directory name)
- Update pals.json with enabled: true and project_key
- Show: `SonarQube [off] → [on] (key: {project_key})`

If toggling SonarQube off:
- Update pals.json with enabled: false
- Show: `SonarQube [on] → [off]`

**[3] Edit preferences:**
```
Preferences:

  [1] auto_commit: false
  [2] verbose_output: false

Select to toggle, or "back" to return.
```

Toggle the selected boolean and write pals.json.

**[4] View raw config:**
Display the full pals.json contents.

**Step 3: Write changes**

After any modification:
1. Read current pals.json
2. Update the changed field
3. Write pals.json with `json.dumps(config, indent=2)`
4. Show confirmation of what changed
5. For efficacy-driven changes, confirm the user explicitly approved the exact module toggle; displaying a demotion candidate is not approval.

**Step 4: Completion**

```
════════════════════════════════════════
CONFIG SAVED
════════════════════════════════════════

Changes saved to pals.json.

Note: Run install.sh to apply module changes to your installation.
```

</process>

<output>
- pals.json updated with user's changes
- Dashboard display of current configuration
- Clear indication of what changed
- Optional per-module `dispatches | findings | actioned` read-out from `.paul/MODULE-LEDGER.md` when available
</output>
