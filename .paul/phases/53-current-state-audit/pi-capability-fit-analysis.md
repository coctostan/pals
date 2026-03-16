# Pi Capability Fit Analysis

## Evaluation method

This analysis compares the current PALS Pi port against Pi’s documented behavior in:
- `README.md`
- `docs/skills.md`
- `docs/extensions.md`
- relevant examples under `examples/extensions/`

Classifications used:
- **Correct and aligned**
- **Correct but thin/basic**
- **Plausible but uncertain**
- **Likely suboptimal or incorrect**

---

## 1. Skill discovery, structure, naming, and invocation

### Current PALS usage
- PALS installs skills under `~/.pi/agent/skills/pals/{skill-name}/SKILL.md`
- Each skill uses lowercase hyphenated names like `paul-plan`, matching the parent directory
- Skills are thin wrappers that point to shared workflow/reference/template files via relative paths

### Pi docs / evidence
- Pi loads skills from `~/.pi/agent/skills/` and recursive `SKILL.md` files under subdirectories (`docs/skills.md`)
- Skills register as `/skill:name` commands (`docs/skills.md`)
- Name must match the parent directory and use lowercase letters, numbers, and hyphens (`docs/skills.md`)
- Skills are meant to be progressively disclosed, with only name/description always in context and full `SKILL.md` loaded on demand (`docs/skills.md`)

### Assessment
**Correct and aligned**

### Why
- The file placement and naming strategy match Pi’s documented skill discovery rules
- The thin-wrapper design fits Pi’s skill model well because Pi expects skills to instruct the model how to proceed, often by reading other files or assets
- Using skills as the stable user-facing entry point is one of the most idiomatic parts of the current Pi port

### Caveats
- Pi docs note that models do not always load full skills reliably without prompting or explicit `/skill:name` invocation; thin wrappers therefore work best when users or command wrappers invoke them explicitly

---

## 2. Using skills to wrap shared markdown artifacts

### Current PALS usage
Pi-facing skills delegate into shared workflow/reference/template markdown through relative paths like `../workflows/plan-phase.md`.

### Pi docs / evidence
- Skills are self-contained capability packages, but everything beyond `SKILL.md` is freeform (`docs/skills.md`)
- Pi explicitly expects skills to reference scripts/assets relative to the skill directory (`docs/skills.md`)
- README presents Pi as a harness extended by skills, extensions, and prompt templates rather than forcing logic into Pi internals

### Assessment
**Correct and aligned**

### Why
- Pi’s skill model is permissive enough for wrapper-style skills
- Relative-path delegation is a strong fit for artifact compatibility and reusability
- This is a clean way to keep behavior in shared markdown while still giving Pi native skill discovery

### Caveats
- The design is correct, but wrapper-thinness can make the Pi experience feel less “native” than it could be

---

## 3. Slash command registration and routing to skills

### Current PALS usage
The extension registers `/paul-*` commands using `pi.registerCommand()` and each handler forwards to `/skill:paul-*` using `pi.sendUserMessage()`.

### Pi docs / evidence
- Extensions can register custom commands with `pi.registerCommand()` (`README.md`, `docs/extensions.md`)
- `pi.sendUserMessage()` sends a real user message and always triggers a turn (`docs/extensions.md`)
- Input processing order explicitly distinguishes extension commands from skill expansion, meaning commands can act as wrappers around skills (`docs/extensions.md` input event section)
- Example command extensions in `examples/extensions/commands.ts` show standard command registration shape and richer command affordances like argument completions

### Assessment
**Correct but thin/basic**

### Why
- The pattern is valid and documented
- Wrapping `/skill:...` behind `/paul-*` is a sensible ergonomic layer that preserves skill-based behavior as the source of truth

### Caveats
- Command handlers currently do the minimum possible work: forward text and exit
- No argument completions, no richer routing, no `waitForIdle()` use, no command discovery helper, and no special handling for command/session context
- This is a solid first pass, but not a maximally Pi-native command experience yet

---

## 4. Extension entrypoint style and API usage

### Current PALS usage
The extension exports a default function and uses Node built-ins (`fs`, `path`) plus Pi APIs.

### Pi docs / evidence
- Pi extensions are TypeScript modules exporting a default function receiving `ExtensionAPI` (`docs/extensions.md`)
- TypeScript is supported without compilation via jiti (`docs/extensions.md`)
- Node built-ins are available (`docs/extensions.md`)
- Extensions can be single-file or directory-based (`docs/extensions.md`)

### Assessment
**Correct and aligned**

### Why
- The extension structure exactly matches Pi’s documented extension model
- Using a single-file extension is reasonable for a small adapter

### Caveats
- The extension uses `pi: any` instead of importing `ExtensionAPI` types. This is not wrong, but it is less idiomatic and forfeits the type-safety Pi explicitly exposes in docs/examples

---

## 5. `session_start` usage

### Current PALS usage
On `session_start`, the extension detects a PALS project, parses `.paul/STATE.md`, and shows a short notification with phase/loop/next action.

### Pi docs / evidence
- `session_start` is a documented session event fired on initial session load (`docs/extensions.md`)
- Official examples use `ctx.ui.notify(...)` during `session_start` (`docs/extensions.md` quick start)

### Assessment
**Correct and aligned**

### Why
- This is a direct and idiomatic use of a documented session event
- It meaningfully improves session awareness without modifying the shared artifact model

### Caveats
- It only fires on initial session load, not necessarily on every workflow pivot users might care about
- The notification is useful but shallow; Pi offers more UI surface than a single notification

---

## 6. `context` hook usage for workflow-state injection

### Current PALS usage
The extension hooks `context`, checks recent messages for PALS workflow activity via regex, then appends a context message summarizing phase/loop/next action.

### Pi docs / evidence
- `context` is documented as firing before each LLM call and may non-destructively modify `event.messages` (`docs/extensions.md`)
- The example shows filtering/modifying message arrays and returning `{ messages }` (`docs/extensions.md`)
- `before_agent_start` can also inject a persistent message or modify the system prompt (`docs/extensions.md`)

### Assessment
**Correct but thin/basic**

### Why
- The hook choice itself is valid; Pi explicitly documents `context` for non-destructive message modification
- Injecting PALS state before LLM calls is a reasonable use of the event

### Caveats
- The current trigger heuristic is lightweight and somewhat brittle:
  - only inspects the last 5 messages
  - relies on regexes over recent plain text
  - injects a small generic summary rather than richer structured context
- There may be a better fit in `before_agent_start` for turn-scoped prompt augmentation or a combination of `input` + `context`, depending on desired semantics
- The extension currently pushes a `role: "user"` message, whereas Pi docs for `before_agent_start` show custom injected messages/system-prompt modification as first-class options. The current approach is plausible, but not obviously the most idiomatic or strongest use of Pi’s prompt-shaping surface

---

## 7. UI usage (`ctx.ui.notify` only)

### Current PALS usage
The extension uses only `ctx.ui.notify()`.

### Pi docs / evidence
- Pi exposes broad UI capabilities: `notify`, `confirm`, `input`, `select`, `setStatus`, `setWidget`, `setHeader`, custom UI, etc. (`docs/extensions.md`)
- README notes that extensions can replace/add headers, widgets, and status/footer UI
- Examples show richer usage such as selectors (`commands.ts`) and header customization (`custom-header.ts`)

### Assessment
**Correct but thin/basic**

### Why
- `notify` is correct and supported
- For a first-pass adapter, minimal UI is understandable

### Caveats
- PALS currently leaves a lot of Pi-native UI affordances unused:
  - status widgets for active PALS phase/loop state
  - richer command pickers or selectors
  - guided decision UI for workflow checkpoints
  - discoverability helpers around loaded commands/skills
- None of this is required for correctness, but it does limit how “native” the Pi experience feels

---

## 8. Extension discovery / installation location

### Current PALS usage
Installs the extension globally to `~/.pi/agent/extensions/pals-hooks.ts`.

### Pi docs / evidence
- Global auto-discovery path is `~/.pi/agent/extensions/*.ts` (`docs/extensions.md`)
- Project-local extension path `.pi/extensions/*.ts` is also supported (`docs/extensions.md`)
- Auto-discovered extensions are reloadable with `/reload` (`docs/extensions.md`)

### Assessment
**Correct and aligned**

### Why
- The global install path is exactly one of Pi’s documented extension locations

### Caveats
- The adapter does not currently offer a project-local installation mode, even though Pi supports one
- Global-only installation is reasonable for PALS as a reusable framework, but it is a deliberate product choice rather than a Pi limitation

---

## 9. Skill installation location

### Current PALS usage
Installs PALS skills globally to `~/.pi/agent/skills/pals/...`.

### Pi docs / evidence
- `~/.pi/agent/skills/` is a documented global skill location (`docs/skills.md`)
- Pi also supports project-local skill locations like `.pi/skills/` (`docs/skills.md`)

### Assessment
**Correct and aligned**

### Why
- Placement is fully compliant with Pi discovery rules

### Caveats
- Like the extension, the installer does not exploit project-local installation options

---

## 10. State handling inside the extension

### Current PALS usage
The extension reparses `.paul/STATE.md` on demand and stores no persistent runtime state.

### Pi docs / evidence
- Pi exposes `pi.appendEntry()` and session reconstruction patterns for persistent extension state (`docs/extensions.md`)
- `ctx.sessionManager` can read current session state (`docs/extensions.md`)

### Assessment
**Correct but thin/basic**

### Why
- Reading `.paul/STATE.md` directly is coherent with PALS’ artifact-first architecture
- Avoiding private extension state reduces drift risk and keeps the artifact model authoritative

### Caveats
- Pi does offer session persistence and richer session metadata tools that could complement artifact-state without replacing it
- Today’s extension does not use those capabilities at all, so it gains no Pi-native memory/annotation ergonomics beyond raw artifact rereads

---

## 11. Use of Pi command ergonomics and discoverability features

### Current PALS usage
Commands have descriptions, but no argument completions, command introspection, or richer selection UI.

### Pi docs / evidence
- `pi.registerCommand()` supports `getArgumentCompletions` (`docs/extensions.md`)
- `pi.getCommands()` is available for listing slash commands programmatically (`docs/extensions.md`)
- `examples/extensions/commands.ts` demonstrates a selector-based command browser with source filtering and path display

### Assessment
**Correct but thin/basic**

### Why
- Baseline command registration is valid

### Caveats
- PALS is not yet using Pi’s stronger command ergonomics even though they are well-supported
- This is one of the clearest areas where “works” and “best possible Pi usage” diverge

---

## 12. Extension comments / docs consistency with actual runtime

### Current PALS usage
Some comments in adapter docs/script text still describe a skill-only Pi integration model.

### Pi docs / evidence
- Pi clearly supports both skills and command-registering extensions (`README.md`, `docs/extensions.md`)

### Assessment
**Likely suboptimal or incorrect**

### Why
- The runtime implementation is more capable than some adapter comments/descriptions imply
- Example: installer commentary saying Pi uses skills “not slash commands or hooks” is no longer true for the actual shipped adapter

### Caveats
- This is documentation drift rather than runtime breakage, but it matters for audit clarity and future maintenance

---

## 13. Overall fit with Pi’s philosophy

### Current PALS usage
PALS brings plan/apply/unify workflow structure into Pi using skills and a light extension layer.

### Pi docs / evidence
- README explicitly says Pi intentionally omits built-in plan mode and expects users/extensions/packages to build workflows like this
- Pi emphasizes extensibility via skills and extensions rather than enforcing one baked-in workflow

### Assessment
**Correct and aligned**

### Why
- PALS is philosophically well-matched to Pi: Pi wants frameworks like this to be built as add-ons
- Using skills + extension glue rather than trying to force PALS into undocumented Pi behavior is the right broad direction

### Caveats
- Being philosophically aligned does not mean the current adapter fully exploits Pi’s extension surface yet

---

## Consolidated classification

| Area | Classification | Notes |
|------|----------------|-------|
| Skill discovery and naming | Correct and aligned | Strong fit with Pi’s documented skill model |
| Thin skills wrapping shared markdown | Correct and aligned | Excellent for artifact compatibility |
| `/paul-*` command wrappers | Correct but thin/basic | Valid but minimal |
| Extension structure and loading | Correct and aligned | Matches Pi extension model |
| `session_start` notification | Correct and aligned | Good documented use |
| `context` injection | Correct but thin/basic | Valid, but heuristic and minimal |
| UI usage | Correct but thin/basic | Leaves richer Pi UI unused |
| Global install locations | Correct and aligned | Fully documented paths |
| State handling strategy | Correct but thin/basic | Artifact-first, but Pi-native state features unused |
| Command ergonomics/discoverability | Correct but thin/basic | Major underused capability area |
| Adapter docs/comments consistency | Likely suboptimal or incorrect | Some drift from actual extension-enabled design |
| Overall Pi philosophical fit | Correct and aligned | PALS is the kind of workflow Pi expects to be layered on |

---

## Bottom line

The current Pi port is **not misusing Pi**. The core choices — skills for discovery, extensions for commands/runtime glue, shared markdown as source of truth — are broadly correct and align with both Pi docs and Pi’s philosophy.

The main current limitation is not correctness; it is **depth**.

PALS is using a **narrow but valid slice** of Pi’s capabilities:
- enough to work
- enough to preserve artifact compatibility
- not enough yet to claim “best possible” Pi-native UX

That makes the current port best described as:

> **correct, coherent, and artifact-safe — but intentionally basic and likely under-optimized for native Pi ergonomics.**