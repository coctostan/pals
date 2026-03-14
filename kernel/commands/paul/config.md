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

Look for pals.json in this order:
1. Current project root (where .paul/ exists) — this is the per-project config
2. `kernel/pals.json` (global fallback)

If not found in the project root, create pals.json there with defaults (all modules enabled).
The project root is the directory containing `.paul/`, NOT just the PALS source repo.

Read pals.json and display the module dashboard:

```
════════════════════════════════════════
PALS CONFIGURATION
════════════════════════════════════════

Modules:
  CARL   [on]   Context rules & domain configuration
  TODD   [on]   Test-driven development enforcement
  WALT   [on]   Quality gating & validation
  DEAN   [on]   Dependency evaluation & audit notifier
  IRIS   [on]   Intelligent review & inspection system
  SKIP   [on]   Smart knowledge & information persistence
  DAVE   [on]   Deploy automation & verification engine
  RUBY   [on]   Refactor utility & better-code yielder

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

**Step 2: Handle user choice**

**[1] Toggle a module:**
```
Which module? (name or number)

  [1] CARL   [on]
  [2] TODD   [on]
  [3] WALT   [on]
  [4] DEAN   [on]
  [5] IRIS   [on]
  [6] SKIP   [on]
  [7] DAVE   [on]
  [8] RUBY   [on]
```

After user selects a module:
- Flip its `enabled` boolean in pals.json
- Write updated pals.json
- Show confirmation: `TODD [on] → [off]`
- Re-display dashboard
- Note: Changes take effect after next `install.sh` run

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
</output>
