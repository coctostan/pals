# Pi Port Inventory

## Scope

This inventory captures the current PALS Pi adapter as implemented in `drivers/pi/`, with attention to:
- Pi integration surface used
- artifact compatibility / cross-platform implications
- obvious simplifications, assumptions, or limitations

## Current adapter model

The current Pi port is a **thin adapter** over shared PALS artifacts.

At a high level it works like this:
1. **Shared kernel and module markdown** are installed into Pi’s skill root so Pi can load the same workflows, references, templates, and rules used by other harnesses.
2. **11 Pi-facing skills** act as user-discoverable entry points and delegate into shared workflow markdown via relative paths.
3. A **TypeScript extension** registers `/paul-*` slash commands and translates them into `/skill:paul-*` user messages.
4. The same extension adds light **session_start** and **context** behavior so Pi surfaces PALS state and injects minimal workflow context.
5. A Pi-specific **installer/uninstaller** deploys the skill tree and extension into Pi’s expected directories.

This design is strongly adapter-oriented: most behavioral intelligence remains in shared markdown artifacts, while Pi-specific code handles discovery, command ergonomics, and minimal runtime glue.

---

## 1. Driver manifest

### File
- `drivers/pi/driver.yaml`

### What it does
Declares the Pi driver identity, version, installable files, and supported capability flags.

### Evidence
- Declares platform metadata: `name: pi`, `platform: pi`, `version: 2.0.0`
- Advertises all six core driver capabilities as true:
  - `workflow_invoke: true`
  - `hook_register: true`
  - `state_read: true`
  - `state_write: true`
  - `user_interact: true`
  - `command_register: true`
- Sets Pi framework directory to `~/.pi/agent/skills/pals`
- Lists packaged assets: installer, uninstaller, skill map, `skills/`, `extensions/`

### Pi surface relied on
- Declarative driver metadata for PALS’ own cross-harness architecture, not a native Pi runtime feature by itself

### Artifact compatibility contribution
- Keeps the Pi adapter declarative and separate from shared artifacts
- Reinforces that Pi is an adapter over the same kernel/module artifact model used elsewhere

### Limitations / notes
- The manifest is for PALS’ internal portability model, not something Pi itself consumes directly
- Capability flags are optimistic abstractions over Pi features; correctness depends on the installer + extension actually realizing them

---

## 2. Installer

### File
- `drivers/pi/install.sh`

### What it does
Installs shared kernel files, Pi-facing skill entry points, the Pi extension, and module resources into Pi’s global directories.

### Evidence
- Creates `~/.pi/agent/skills/pals/{workflows,references,templates,rules}`
- Copies shared kernel files from `kernel/`
- Copies all Pi skill entrypoints from `drivers/pi/skills/*/SKILL.md`
- Copies `drivers/pi/extensions/pals-hooks.ts` to `~/.pi/agent/extensions/pals-hooks.ts`
- Reads `pals.json` to determine enabled modules
- Copies module resources into the Pi skill tree and generates `modules.yaml`

### Pi surface relied on
- Pi global skill discovery under `~/.pi/agent/skills/`
- Pi global extension discovery under `~/.pi/agent/extensions/`

### Artifact compatibility contribution
- Central design strength: installs **shared markdown artifacts** into Pi rather than forking them
- Preserves relative-path skill → workflow/template/reference structure so changes to shared markdown can flow across harnesses
- Enables module reuse without Pi-specific copies of each module’s logic

### Limitations / notes
- Installer comment says Pi “uses skills (not slash commands or hooks)” even though the same script also installs a command/hook extension; comment is outdated relative to current implementation
- Installation is global-only; there is no Pi project-local install path in the PALS installer today
- Module installation copies assets into Pi’s skill tree with basename flattening for categories, which may be sufficient now but could create naming collision risk if different modules later ship same-named files
- Uses a custom Python YAML parser, which minimizes dependencies but adds maintenance surface

---

## 3. Uninstaller

### File
- `drivers/pi/uninstall.sh`

### What it does
Removes the PALS Pi skill tree and extension file from the user’s Pi directories after interactive confirmation.

### Evidence
- Removes `~/.pi/agent/skills/pals/`
- Removes `~/.pi/agent/extensions/pals-hooks.ts`
- Uses a tty confirmation prompt before deletion

### Pi surface relied on
- Pi’s global resource locations for skills and extensions

### Artifact compatibility contribution
- Keeps cleanup scoped to Pi-installed adapter assets only
- Does not touch shared repo source files or Claude Code assets

### Limitations / notes
- No granular uninstall; removes the full Pi adapter wholesale
- No handling for future multi-file extension directories if the extension outgrows the single-file model

---

## 4. Skill map

### File
- `drivers/pi/skill-map.md`

### What it does
Documents the mapping from user-facing Pi skills to underlying shared workflows and explains the path strategy.

### Evidence
- Maps 11 user-facing skills to shared workflow names
- Separates internal workflows that do not get standalone skills
- Documents install path strategy and relative references like `../workflows/{name}.md`
- Records key decisions such as “11 skills, not 21” and “No @ syntax”

### Pi surface relied on
- Pi skill discovery and `/skill:name` invocation model

### Artifact compatibility contribution
- This file captures the central adapter strategy: shared kernel artifacts live alongside Pi skill wrappers, and wrappers delegate via relative paths instead of copied logic
- Makes cross-harness reuse an explicit design decision instead of accidental behavior

### Limitations / notes
- This is documentation, not executable enforcement
- Some design notes are already partly outdated now that the extension does register commands and uses `ctx.ui.notify`

---

## 5. Pi-facing SKILL.md entry points

### Files
- `drivers/pi/skills/paul-apply/SKILL.md`
- `drivers/pi/skills/paul-discuss/SKILL.md`
- `drivers/pi/skills/paul-fix/SKILL.md`
- `drivers/pi/skills/paul-help/SKILL.md`
- `drivers/pi/skills/paul-init/SKILL.md`
- `drivers/pi/skills/paul-milestone/SKILL.md`
- `drivers/pi/skills/paul-pause/SKILL.md`
- `drivers/pi/skills/paul-plan/SKILL.md`
- `drivers/pi/skills/paul-resume/SKILL.md`
- `drivers/pi/skills/paul-status/SKILL.md`
- `drivers/pi/skills/paul-unify/SKILL.md`

### What they do
Expose Pi-discoverable skills with concise descriptions and thin execution instructions that route into shared workflow markdown.

### Evidence
Representative pattern across files:
- Valid Agent Skills style frontmatter: `name: paul-plan`, `description: ...`
- Explicit instruction to read shared files via relative paths such as:
  - `../workflows/plan-phase.md`
  - `../templates/PLAN.md`
  - `../references/plan-format.md`
- The skills are intentionally thin and mostly describe:
  - which project files to read
  - which workflow file to load
  - what high-level behavior to follow

Special case:
- `paul-help` is more self-contained and presents a user-oriented command guide rather than a workflow wrapper

### Pi surface relied on
- Pi skill discovery from `~/.pi/agent/skills/.../SKILL.md`
- Pi `/skill:name` invocation behavior
- Pi progressive disclosure model where only name/description are always in prompt and full skill text is loaded on demand

### Artifact compatibility contribution
- This is one of the strongest cross-platform choices in the adapter:
  - Pi gets native skill discovery
  - the real behavior still lives in shared markdown artifacts
  - changes to shared workflow/reference/template markdown can propagate without rewriting Pi logic
- Minimizes platform divergence by keeping Pi wrappers extremely thin

### Limitations / notes
- The current skills are mostly wrappers, so the Pi experience depends heavily on the model following instructions to read additional files correctly
- Some user-facing command examples in `paul-help` prefer `/skill:paul-*`, while the extension separately adds `/paul-*`; this creates a dual-surface UX
- The wrappers are intentionally basic and do not yet exploit richer Pi-specific assets like local helper scripts, custom tools, or structured per-skill setup

---

## 6. Pi extension

### Files
- `drivers/pi/extensions/pals-hooks.ts`
- `drivers/pi/extensions/README.md`

### What it does
Adds Pi-native runtime glue:
- registers `/paul-*` slash commands
- on session start, detects a PALS project and notifies the user with a short summary
- on `context`, injects lightweight PALS state when recent messages suggest an active PALS workflow

### Evidence
`pals-hooks.ts`:
- registers 11 commands in a `COMMANDS` array
- each command handler calls `pi.sendUserMessage(`/skill:${cmd.skill}`...)`
- `session_start` parses `.paul/STATE.md` and calls `ctx?.ui?.notify(...)`
- `context` inspects last 5 messages and, when matching a PALS workflow regex, appends a context message with phase/loop/next action

`extensions/README.md` documents:
- installation to `~/.pi/agent/extensions/pals-hooks.ts`
- registered commands
- `session_start` and `context` hook behavior

### Pi surface relied on
- `pi.registerCommand()`
- `pi.sendUserMessage()`
- `pi.on("session_start")`
- `pi.on("context")`
- `ctx.ui.notify()`

### Artifact compatibility contribution
- Commands are wrappers over skills, not alternate implementations
- Context injection reads `.paul/STATE.md`, which is a shared artifact central to all harnesses
- Keeps Pi-native ergonomics at the edge while leaving workflow semantics in shared files

### Limitations / notes
- The extension is deliberately thin and does not use Pi’s richer extension surface (custom tools, state persistence, richer UI, command completions, session labels, project-local extension placement, etc.)
- The `context` hook injects as a user-role message and relies on recent-text regex detection, which is simple but heuristic
- `parsePalsState()` extracts only phase, loop, and next action; it ignores richer state available in `STATE.md`
- No persistent extension state is recorded with `pi.appendEntry()`
- No use of `pi.getCommands()` or argument completions to improve command discoverability
- The extension is installed globally rather than optionally project-locally

---

## 7. Module deployment model inside Pi

### Implemented by
- `drivers/pi/install.sh`

### What it does
Installs enabled PALS modules into the Pi skill tree and generates a `modules.yaml` registry.

### Evidence
- Reads `pals.json`
- Discovers `modules/*/module.yaml`
- Copies module `references`, `workflows`, `templates`, and `rules`
- Preserves module config files if already present
- Generates `~/.pi/agent/skills/pals/modules.yaml`

### Pi surface relied on
- Primarily file-based resource loading inside the skill tree

### Artifact compatibility contribution
- Preserves the shared PALS module model rather than inventing Pi-specific module logic
- Allows the same workflow markdown to refer to module artifacts installed under the same root structure

### Limitations / notes
- `kernel/modules.yaml` is not present in the repo root during planning/runtime here; the Pi installer generates a runtime `modules.yaml` under the installed skill tree instead
- This is consistent with PALS’ install-time composition model, but it means some workflow wording that references `kernel/modules.yaml` is conceptual rather than literally matching repo layout

---

## 8. Runtime behavior visible to Pi users today

### Current user surfaces
1. `/skill:paul-*` commands from Pi skill discovery
2. `/paul-*` slash commands from the extension
3. session-start notification when `.paul/STATE.md` is detected
4. invisible context augmentation during active PALS workflow turns

### Strengths
- Users can discover PALS through Pi-native skills
- Users also get a cleaner `/paul-*` namespace without needing to remember `/skill:`
- Shared artifacts remain the source of truth

### Simplifications
- The adapter currently favors **minimal glue over deep Pi-native behavior**
- It does not attempt to recreate Claude Code behavior through richer Pi extension features yet

---

## Summary assessment of the current implementation

### Confirmed strengths
- Thin-adapter architecture is consistent and intentional
- Shared workflow/reference/template markdown remains the source of truth
- Pi-native skills are used for discovery and invocation
- Extension-based `/paul-*` commands improve ergonomics without forking logic
- Installer correctly targets Pi’s global skill and extension directories

### Confirmed simplifications / likely weak spots
- Extension behavior is minimal and heuristic
- Command UX is basic despite Pi exposing richer command APIs
- Skill wrappers are correct but intentionally thin, so the Pi experience depends on extra file-loading discipline from the model
- Current docs and comments have small signs of drift from the newer extension-enabled design

### Bottom line
The Pi port is currently a **basic but coherent first-pass adapter**. Its strongest property is artifact compatibility. Its main tradeoff is that it uses only a narrow slice of Pi’s native runtime capabilities so far.