# PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT

**Status:** v2.61 Phase 261 — docs-only extraction contract for the S8 `command-routing` Pi extension subsystem. Phase 262 will execute the bounded source extraction; Phase 261 itself does not modify any runtime, source, test, install, dependency, CI, kernel workflow, or installed runtime copy.

**Authority:** Derived aid only. This artifact catalogues the existing S8 surface in `drivers/pi/extensions/pals-hooks.ts` so Phase 262 can preserve every `/paul-*` command-registration call shape byte-for-byte. It does not change runtime behavior, lifecycle authority, validation truth, or `.paul/*` artifact authority. The `.paul/*` artifacts and parent APPLY remain authoritative for lifecycle decisions; Pi UI, command registration, and message delivery are derived aids that route around the calm lifecycle surface.

## Purpose

PALS is continuing the Pi extension sibling-module extraction wave after S5 (Phase 239 — `module-activity-parsing.ts`), S1 (Phase 243 — `artifact-slice-rendering.ts`), S2 (Phase 246 — `workflow-resource-capsule-rendering.ts`), S3 (Phase 250 — `guided-workflow-detection.ts`), S7 (Phase 254 — `pals-context-injection.ts`), and S6 (Phase 258 — `lifecycle-ui.ts`) shipped. S8 owns the user-facing Pi `/paul-*` command surface: command-definition table, command lookup, wrapper-command translation, command-signal detection, quick-action selection and bounding, command-activation marking, and command/shortcut registration on Pi.

S8 is the **highest user-visible blast radius** of any remaining extraction candidate (it defines the entire `/paul-*` entry surface, the Ctrl+Alt quick-action shortcuts, and how `pi.sendUserMessage` is invoked to deliver canonical `/skill:*` routing). It is the **second runtime-coupled sibling extraction** after S6 (registers commands and shortcuts on Pi rather than purely producing strings). The Phase 257 → Phase 258 byte-sequence preservation discipline (the literal `pals-lifecycle` UI-element identifier was preserved exactly through the S6 move) is the model: every `/paul-*` command name, every Ctrl+Alt shortcut binding, and every command-routing constant value MUST be preserved byte-for-byte through Phase 262 extraction.

## Evidence Base

- `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` — original S1–S8 inventory; the S8 row cites `getCommand`, `toWrapperCommand`, `detectCommandSignal`, `getQuickActions`, and `COMMANDS` as the S8 surface and notes "any extraction must preserve current `/paul-*` names, shortcuts, canonical replies, and quick-action ordering" plus "highest user-visible blast radius. Should not be the first spike". The classification row marks S8 as **runtime-coupled, risky → higher practical risk**. The "should not be the first spike" precondition is now satisfied by S5/S1/S2/S3/S7/S6 shipping with byte-sequence preservation.
- `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md` — current S1/S2/S3/S5/S6/S7 extraction state and S4/S8 deferrals. Phase 261 promotes S8 from "Deferred; highest user-visible command/shortcut surface" to a bounded Phase 262 contract target.
- `docs/PI-NATIVE-LIFECYCLE-UI-EXTRACTION-CONTRACT.md` — S6 contract precedent for the runtime-coupled second-extraction shape; this artifact mirrors that one-to-one with S8 specifics.
- `docs/PI-NATIVE-PALS-CONTEXT-INJECTION-EXTRACTION-CONTRACT.md` — S7 contract precedent for the marker/identifier-preservation extraction shape; established the type-only back-import pattern and the TAP-assertion repoint pattern that Phase 262 may need.
- `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md` — canonical reply schema, no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, no inferred merge intent, and validation classes. The canonical `/paul-*` → `/skill:paul-*` routing rule is the second-most-important S8 boundary because S8 owns the wrapper-to-skill translation; it must continue to flow through `pi.sendUserMessage` exactly once per command activation.
- `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md` — preserved deferral of full Claude Code / Agent SDK driver removal until cross-harness validation decomposition lands; v2.61 must not touch this contract.
- `.paul/phases/258-bounded-s6-submodule-extraction/258-01-SUMMARY.md` — most-recent runtime sibling extraction; established the byte-sequence preservation discipline (the literal `pals-lifecycle` value was preserved exactly through the move) that Phase 262 must replicate for every `/paul-*` command name and Ctrl+Alt shortcut binding.
- `.paul/phases/257-s6-extraction-contract-bounded-submodule-plan/257-01-SUMMARY.md` and `.paul/phases/253-s7-extraction-contract-bounded-submodule-plan/253-01-SUMMARY.md` — most-recent S* contract phase precedents; this artifact mirrors their docs-only shape one-to-one.

## S8 Subsystem Boundary

### Cited Functions (per `PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` S8 row)

Each is a top-level `function` declaration in `drivers/pi/extensions/pals-hooks.ts`:

- `getCommand(name: CommandDef["name"]): CommandDef | undefined` — pure command-table lookup by name; consumes only `COMMANDS`.
- `toWrapperCommand(commandText?: string): string | undefined` — pure `/skill:paul-*` ↔ `/paul-*` translator; consumes `compactWhitespace`.
- `detectCommandSignal(value?: string): string | undefined` — pure regex-based command-signal extractor over user prompts; consumes `compactWhitespace`.
- `getQuickActions(state: PalsStateSnapshot): QuickActionDef[]` — pure quick-action selection; consumes `getCommand`, `toWrapperCommand`, and `MAX_QUICK_ACTIONS`.

### Cited Top-Level Constant

- `COMMANDS: CommandDef[]` — top-level command-definition table; **twelve entries** (the original modularization-contract S8 row described the surface as "the `/paul-*` command surface" without enumerating count; the live source has twelve entries, including the post-Phase-234 addition of `paul-review`). See "Twelve `/paul-*` Command Catalogue" below for the byte-for-byte enumeration.

### Closure-Routing Surface (must also be catalogued as S8)

The runtime invocation surface of S8 lives as closures inside `registerPalsLifecycleHooks` in `pals-hooks.ts`. They were the Phase 234 audit's "command routing" cluster's runtime invocation surface and must be catalogued as S8 even though they are not in the original modularization-contract S8 row:

- `routeCommand` — closure: `const routeCommand = (commandName: CommandDef["name"], args = "", ctx?: any): void => {…}`. Looks up the command via `getCommand`, marks activation via `markActivation`, builds the canonical `/skill:` reply, notifies, and invokes `pi.sendUserMessage(skillCmd)`.
- `routeWrapperCommand` — closure: `const routeWrapperCommand = (commandText: string, ctx?: any): void => {…}`. Wraps `toWrapperCommand` + `routeCommand`.
- `registerQuickActionShortcut` — closure: `const registerQuickActionShortcut = (shortcut, description, handler) => { pi.registerShortcut(shortcut, { description, handler: async (ctx) => { handler(ctx); } }); }`.

### Top-Level Command-Routing Constants

Each is a single-defined top-level `const` in `pals-hooks.ts` and must remain exact-string single-defined:

- `COMMAND_ACTIVATION_TURN_BUDGET = 3` — consumed by `routeCommand`.
- `PROMPT_ACTIVATION_TURN_BUDGET = 1` — consumed by the `before_agent_start` Pi hook handler (lifecycle-side; not S8-private but the value is referenced from the S8 routing path).
- `PRIMARY_QUICK_ACTION_LIMIT = 3` — surfaced as a guardrail TAP assertion at `tests/pi-end-to-end-validation.sh` line 815 over `EXT_SRC = pals-hooks.ts`; Phase 262 MUST repoint the TAP assertion if the constant moves.
- `MAX_QUICK_ACTIONS = 5` — consumed by `getQuickActions`; same guardrail TAP assertion.

### Top-Level Inline Types

Both are inline (not currently exported) in `pals-hooks.ts`:

- `type CommandDef = { name: string; description: string; skill: string; guidance: string }`.
- `type QuickActionDef = { id: string; commandName: CommandDef["name"]; label: string; shortcutHint: string }`.

Phase 262 MUST `export` both types from the new sibling so consumers (or repointed TAP assertions) can reference them by symbol.

## Twelve `/paul-*` Command Catalogue

Every `/paul-*` command-registration call shape is catalogued here exactly so Phase 262 extraction can preserve them byte-for-byte. The full twelve-entry `COMMANDS` array, captured verbatim from `drivers/pi/extensions/pals-hooks.ts` (top-level `const COMMANDS: CommandDef[]`):

| `name` | `description` | `skill` | `guidance` |
|--------|---------------|---------|------------|
| `paul-init` | `Set up PALS lifecycle files for this project` | `paul-init` | `Pi convenience wrapper → canonical /skill:paul-init` |
| `paul-plan` | `Plan the next PALS phase` | `paul-plan` | `Pi convenience wrapper → canonical /skill:paul-plan` |
| `paul-apply` | `Execute the approved PALS plan` | `paul-apply` | `Pi convenience wrapper → canonical /skill:paul-apply` |
| `paul-unify` | `Reconcile completed work and close the loop` | `paul-unify` | `Pi convenience wrapper → canonical /skill:paul-unify` |
| `paul-resume` | `Resume PALS work from current project state` | `paul-resume` | `Pi convenience wrapper → canonical /skill:paul-resume` |
| `paul-status` | `Show current PALS status and next action` | `paul-status` | `Pi convenience wrapper → canonical /skill:paul-status` |
| `paul-fix` | `Run a quick PALS fix flow` | `paul-fix` | `Pi convenience wrapper → canonical /skill:paul-fix` |
| `paul-pause` | `Create a PALS handoff before stopping` | `paul-pause` | `Pi convenience wrapper → canonical /skill:paul-pause` |
| `paul-milestone` | `Create or complete a PALS milestone` | `paul-milestone` | `Pi convenience wrapper → canonical /skill:paul-milestone` |
| `paul-discuss` | `Discuss scope before planning in PALS` | `paul-discuss` | `Pi convenience wrapper → canonical /skill:paul-discuss` |
| `paul-help` | `Show Pi command and skill guidance for PALS` | `paul-help` | `Pi convenience wrapper → canonical /skill:paul-help` |
| `paul-review` | `Run thorough code review via REV subagent` | `paul-review` | `Pi convenience wrapper → canonical /skill:paul-review` |

**Phase 262 MUST preserve every `name`, `description`, `skill`, and `guidance` byte sequence above unchanged.** In every observed entry, `skill` matches `name` byte-for-byte; Phase 262 MUST keep this 1:1 mapping unless a future plan (not Phase 262) explicitly approves a divergence.

### Eleven-vs-Twelve `CMD_COUNT` Known Mismatch

`tests/pi-end-to-end-validation.sh` line 792 currently asserts `CMD_COUNT == 11` over the `EXPECTED_SKILLS` array at lines 48–58 (which lists eleven `paul-*` skill names without `paul-review`). The live `COMMANDS` array in `pals-hooks.ts` has **twelve** entries; the `detectCommandSignal` regex literal in `pals-hooks.ts` line 226 already enumerates all twelve. Phase 262 MUST surface this discrepancy from command output rather than silently change the assertion. The Phase 262 reconciliation discipline is: if the test assertion needs to move from 11 to 12 to match the moved `COMMANDS` array, the change must be a deliberate count reconciliation reported in the Phase 262 SUMMARY, not an incidental edit.

## Pi-Runtime Mutation Invocation Rule

`pi.registerCommand`, `pi.registerShortcut`, and `pi.sendUserMessage` are the only Pi-runtime mutation entry points the S8 surface touches. The current registration call shapes — captured here as literal code-fence blocks for byte-for-byte preservation — are:

### Command registration loop (currently lines 742–750 of `pals-hooks.ts`)

```typescript
// Register all /paul-* slash commands as Pi-native discovery wrappers.
for (const cmd of COMMANDS) {
  pi.registerCommand(cmd.name, {
    description: cmd.description,
    handler: async (args: string, ctx: any) => {
      carlState.stashedCmdCtx = ctx;
      routeCommand(cmd.name, args, ctx);
    },
  });
}
```

Phase 262 MUST keep this loop byte-for-byte inside `registerPalsLifecycleHooks` in `pals-hooks.ts` so command registration continues to fire from the same lifecycle entry point. The `carlState.stashedCmdCtx = ctx` assignment inside the registration handler is **CARL-coupling** and MUST be preserved regardless of whether the closure factory itself moves.

### Five Ctrl+Alt quick-action shortcut invocations (currently lines 752–763 of `pals-hooks.ts`)

```typescript
registerQuickActionShortcut(Key.ctrlAlt("n"), "Run the current next PALS action", (ctx) => {
  const nextWrapper = toWrapperCommand(parsePalsState(ctx?.cwd ?? process.cwd()).nextAction);
  if (!nextWrapper) {
    ctx?.ui?.notify("No PALS next action is available.", "warning");
    return;
  }
  routeWrapperCommand(nextWrapper, ctx);
});
registerQuickActionShortcut(Key.ctrlAlt("s"), "Open PALS status", (ctx) => routeCommand("paul-status", "", ctx));
registerQuickActionShortcut(Key.ctrlAlt("r"), "Resume PALS work", (ctx) => routeCommand("paul-resume", "", ctx));
registerQuickActionShortcut(Key.ctrlAlt("h"), "Open PALS help", (ctx) => routeCommand("paul-help", "", ctx));
registerQuickActionShortcut(Key.ctrlAlt("m"), "Open PALS milestone flow", (ctx) => routeCommand("paul-milestone", "", ctx));
```

Phase 262 MUST keep these five invocations byte-for-byte inside `registerPalsLifecycleHooks` in `pals-hooks.ts`. The five shortcut bindings (`Key.ctrlAlt("n" | "s" | "r" | "h" | "m")`), the five description strings, the `Ctrl+Alt+N` / `+S` / `+R` / `+H` / `+M` shortcut-hint strings (in `getQuickActions`), and the priority order (next-action first if present, then status/resume/help/milestone, deduplicated by `commandName`, capped at `MAX_QUICK_ACTIONS`) are the entire user-visible Pi shortcut surface.

### `routeCommand` body (currently lines 693–702 of `pals-hooks.ts`)

```typescript
const routeCommand = (commandName: CommandDef["name"], args = "", ctx?: any): void => {
  const cmd = getCommand(commandName);
  if (!cmd) return;
  const trimmedArgs = args.trim();
  const wrapperCmd = `/${commandName}${trimmedArgs ? " " + trimmedArgs : ""}`;
  markActivation("command", wrapperCmd, COMMAND_ACTIVATION_TURN_BUDGET);
  const skillCmd = `/skill:${cmd.skill}${trimmedArgs ? " " + trimmedArgs : ""}`;
  ctx?.ui?.notify(`${cmd.guidance} — routing now`, "success");
  pi.sendUserMessage(skillCmd);
};
```

Phase 262 MUST preserve this body byte-for-byte. The translation rule `/paul-${name}` → `/skill:${cmd.skill}` and the `markActivation("command", wrapperCmd, COMMAND_ACTIVATION_TURN_BUDGET)` call shape are the canonical-routing rule's runtime invariant.

### `toWrapperCommand` translation rule (currently lines 212–220 of `pals-hooks.ts`)

The input is normalized via `compactWhitespace`. The output rule is:
- If trimmed input starts with `/paul-`, return it as-is.
- If trimmed input starts with `/skill:paul-`, replace the `/skill:` prefix with `/` and return.
- Else return `undefined`.

Phase 262 MUST preserve these three branches and the `/skill:paul-` → `/paul-` direction byte-for-byte.

### `detectCommandSignal` regex literal (currently line 226 of `pals-hooks.ts`)

```typescript
const match = compact.match(/\/(?:skill:)?(paul-(?:init|plan|apply|unify|resume|status|fix|pause|milestone|discuss|help|review))(?:\s+(.+))?/i);
```

This regex enumerates all twelve command names matching the `COMMANDS` array. **Phase 262 MUST keep this regex byte-for-byte**, including the `(?:skill:)?` prefix branch and the `i` flag. If `COMMANDS` ever gains or loses an entry, the regex enumeration MUST be updated in lockstep — but Phase 262 itself does not gain or lose entries.

### `getQuickActions` priority order

The current priority order, captured here for Phase 262 byte-preservation:

1. **Next-action** (if `state.nextAction` resolves to a known `commandName` via `toWrapperCommand` + `getCommand`): `id="next-action"`, `commandName=<resolved>`, `label="Next"`, `shortcutHint="Ctrl+Alt+N"`.
2. **Status** (always pushed): `id="status"`, `commandName="paul-status"`, `label="Status"`, `shortcutHint="Ctrl+Alt+S"`.
3. **Resume** (always pushed): `id="resume"`, `commandName="paul-resume"`, `label="Resume"`, `shortcutHint="Ctrl+Alt+R"`.
4. **Help** (always pushed): `id="help"`, `commandName="paul-help"`, `label="Help"`, `shortcutHint="Ctrl+Alt+H"`.
5. **Milestone** (always pushed): `id="milestone"`, `commandName="paul-milestone"`, `label="Milestone"`, `shortcutHint="Ctrl+Alt+M"`.

Final result is deduplicated by `commandName` (preserving first occurrence) and capped at `MAX_QUICK_ACTIONS = 5`. Phase 262 MUST preserve the exact id/label/shortcutHint byte sequences and the dedupe-then-cap order.

## Shared-Input Disposition

`compactWhitespace` and `parsePalsState` are NOT S8-private. Both are exported from `pals-hooks.ts` per the canonical sibling-import discipline (`compactWhitespace` since Phase 246 outcome; `parsePalsState` since the Phase 258 `inline → export` promotion ratification). Phase 262 MUST import these from `./pals-hooks` value-side rather than duplicating them.

The activation-state surface (`markActivation`, `getActiveActivation`, `consumeActivationTurn`, the `activationState` closure variable) is owned by `pals-hooks.ts`'s `registerPalsLifecycleHooks` closure scope; it is conceptually a parsing/lifecycle authority concern, not a command-surface concern. Phase 262 MUST:

- Import `markActivation` from `./pals-hooks` value-side. This requires promoting `markActivation` from inline closure to top-level export — **the third application of the Phase 258 `inline → export` promotion pattern** (after Phase 254's single-symbol `ActivationState` type promotion and Phase 258's four-symbol value/type promotion of `MAX_VISIBLE_MODULES`, `RECENT_MODULE_ACTIVITY_LOOKBACK`, `parsePalsState`, `collectRecentAssistantTexts`). The promotion MUST be bounded and reviewable: `markActivation` gains only the `export` keyword and moves out of the `registerPalsLifecycleHooks` closure to a top-level function in `pals-hooks.ts`; its body is unchanged. `getActiveActivation` and `consumeActivationTurn` may stay inside `registerPalsLifecycleHooks` if Phase 262 does not need them; if it does, the same `inline → export` discipline applies.
- Import `ActivationState` type-only from `./pals-hooks`. `ActivationState` is already `export type ActivationState` in `pals-hooks.ts` (since Phase 254). This follows the type-only back-import precedent now ratified twice (Phase 254, Phase 258).

`PalsStateSnapshot` (used as the `getQuickActions` parameter type) is already a type-only export from `./pals-hooks` per Phase 258 outcome; Phase 262 imports it the same way.

## Pi-UI / S4 Boundary

S8 is a UI surface (it owns the `/paul-*` command entry surface and the Ctrl+Alt shortcut surface). Extracting it MUST NOT introduce any code path where command activation drives lifecycle state without a transcript-visible canonical reply (the **no-UI-only-lifecycle-decisions** invariant verified shipped in Phase 258).

S4 canonical reply delivery (`sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`) is **forbidden scope** for Phase 262: these stay inline in `pals-hooks.ts`. The canonical-reply path that S4 owns must NOT be touched by S8 work. The S4/S8 separation is structurally clean: S4 sends canonical workflow replies (e.g., `Yes, run APPLY`) in response to displayed guided-workflow moments; S8 sends canonical skill routing (`/skill:paul-*`) in response to `/paul-*` command activations. Both flow through `pi.sendUserMessage` but at different invocation sites for different purposes.

Every `/paul-*` activation MUST continue to result in exactly one `pi.sendUserMessage(skillCmd)` invocation flowing through normal user-message delivery, not silent state mutation. No auto-approval, no auto-continue, no skipped checkpoints, no inferred merge intent, no UI-only lifecycle decisions, and no merge-anyway path are allowed.

## Allowed Phase 262 Extraction Shape

Phase 262 will create a sibling module `drivers/pi/extensions/command-routing.ts` following the S5/S1/S2/S3/S7/S6 sibling-module recipe applied a seventh time:

- Single-defined `COMMANDS: CommandDef[]` (twelve entries) in the new sibling.
- Single-defined `CommandDef` and `QuickActionDef` types with `export` so the line-815 `EXT_SRC` TAP guardrail (and any other repointed TAP assertions) can reference them by symbol.
- Single-defined `COMMAND_ACTIVATION_TURN_BUDGET = 3`, `PROMPT_ACTIVATION_TURN_BUDGET = 1`, `PRIMARY_QUICK_ACTION_LIMIT = 3`, `MAX_QUICK_ACTIONS = 5` constants in the new sibling. (`PROMPT_ACTIVATION_TURN_BUDGET` is currently consumed by the `before_agent_start` Pi hook handler in `pals-hooks.ts`; if Phase 262 moves it to the new sibling, the hook handler imports it value-side.)
- The four cited S8 functions (`getCommand`, `toWrapperCommand`, `detectCommandSignal`, `getQuickActions`) in the new sibling, each with `export` so the registration loop and any TAP assertion can reference them.
- The same loader-compat invariant used by every prior sibling: a no-op default-exported factory `export default function (_pi: unknown): void {}` preceded by JSDoc carrying the literal phrase `No-op Pi extension factory`.
- Explicit imports from `./pals-hooks` only where needed: type-only for `ActivationState` and `PalsStateSnapshot`; value imports for `compactWhitespace`, `parsePalsState`, and `markActivation` (after `inline → export` promotion).
- Phase 262 deliberately omits `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `extractTextContent`, `collectRecentAssistantTexts`, `extractLoopSignature`, and `formatCarlContextPressure` from the import surface — the moved S8 code does not reference them, and keeping the sibling-import surface honest is the canonical sibling-import discipline.

### Disposition A vs Disposition B for Closure-Routing Factories

Phase 262 MUST pick exactly ONE of two dispositions for the closure factories `routeCommand` / `routeWrapperCommand` / `registerQuickActionShortcut`:

**Disposition A (preferred — full sibling extraction):** the three closure factories move to `drivers/pi/extensions/command-routing.ts` as exported factory functions. Each factory accepts `pi`, `markActivation`, and the CARL-context setter (or the relevant subset) explicitly so the closures no longer need to be defined inside `registerPalsLifecycleHooks`. The registration loop and the five Ctrl+Alt invocation sites stay in `pals-hooks.ts` and call the imported factories. This produces the largest LOC reduction in `pals-hooks.ts` and the cleanest single-responsibility sibling.

**Disposition B (minimal sibling extraction — safe fallback):** only the four pure functions (`getCommand`, `toWrapperCommand`, `detectCommandSignal`, `getQuickActions`), the `COMMANDS` array, the four constants, and the two types move to `drivers/pi/extensions/command-routing.ts`. The closure factories `routeCommand` / `routeWrapperCommand` / `registerQuickActionShortcut` stay inline inside `registerPalsLifecycleHooks` in `pals-hooks.ts`, importing the moved pure functions value-side from `./command-routing`.

**Disposition A is the default.** Disposition B is the safe fallback only if Disposition A surfaces unexpected closure-state coupling during Phase 262 implementation (for example, if `routeCommand`'s `pi` reference cannot be cleanly threaded through a factory parameter without breaking another Pi extension contract). Phase 262 SUMMARY MUST record which disposition was used and why.

In either disposition, the registration loop and the five Ctrl+Alt invocation sites stay byte-for-byte inside `registerPalsLifecycleHooks` in `pals-hooks.ts` so command and shortcut registration continues to fire from the same lifecycle entry point.

## Forbidden Scope (Phase 262)

Phase 262 MUST NOT modify or approve modification of:

- **S4 canonical reply delivery:** `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent`. These stay inline in `pals-hooks.ts`. The canonical-reply path that S4 owns is not S8 scope.
- **Previously extracted siblings:** S5 (`module-activity-parsing.ts`), S1 (`artifact-slice-rendering.ts`), S2 (`workflow-resource-capsule-rendering.ts`), S3 (`guided-workflow-detection.ts`), S7 (`pals-context-injection.ts`), S6 (`lifecycle-ui.ts`). These are all forbidden from re-extraction or modification by Phase 262.
- **Install/uninstall/driver manifest:** `drivers/pi/install.sh`, `drivers/pi/uninstall.sh`, `drivers/pi/driver.yaml` are governed by the source-set rule already covering `drivers/pi/extensions/*.ts` (the new sibling installs by basename without per-file installer edits). Phase 262 MUST NOT modify these manifests beyond what the source-set rule already permits.
- **Dependency manifests, CI configuration, kernel workflow sources, module registry files.**
- **Validation suites:** `tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh`, `tests/helpers/artifact_consistency.sh` are touched only for TAP-assertion repoint discipline (see "TAP-assertion repoint discipline" below); broader refactors are out of scope.
- **Telemetry, hidden state, runtime ledgers, cache-as-truth.**
- **Auto-approval, auto-continue, skipped checkpoints, UI-only lifecycle decisions, inferred merge intent.**
- **Claude Code driver, Agent SDK driver** (still frozen since v2.52; full removal still blocked on cross-harness validation decomposition per `PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`).
- **Lifecycle authority:** `.paul/*` artifact authority, transcript-visible canonical replies, no auto-approval, no auto-continue, no skipped checkpoints, no inferred merge intent, GitHub Flow gates, parent-owned APPLY, and module evidence remain authoritative; Phase 262 MUST NOT alter any of these.

## TAP-Assertion Repoint Discipline

The Phase 254 / Phase 258 TAP-assertion repoint precedent applies. The known repoint candidates for Phase 262 are:

- **Bounded-quick-action TAP guardrail at `tests/pi-end-to-end-validation.sh` line 815:** asserts `PRIMARY_QUICK_ACTION_LIMIT = 3` + `MAX_QUICK_ACTIONS = 5` definition strings exist verbatim in `EXT_SRC = pals-hooks.ts`. Under Disposition A or B, these constants move to the new sibling; the TAP assertion MUST be repointed to the new sibling source path (or split into a new sibling-aware assertion) such that the net assertion count is unchanged and the byte-equivalent guardrail still fires.
- **Shortcut-count guardrail at `tests/pi-end-to-end-validation.sh` line 814:** counts `Key.ctrlAlt("[nsrhm]")` occurrences in `EXT_SRC = pals-hooks.ts`. Because the five Ctrl+Alt invocation sites stay in `pals-hooks.ts` under both Disposition A and Disposition B, this assertion MUST remain pointed at `pals-hooks.ts` and continue to count 5.
- **Registration-count guardrail at `tests/pi-end-to-end-validation.sh` line 799:** counts `registerCommand` calls in `EXT_SRC = pals-hooks.ts`. The registration loop stays in `pals-hooks.ts` under both dispositions, so this assertion MUST also remain pointed at `pals-hooks.ts`.
- **All-eleven-commands assertion at `tests/pi-end-to-end-validation.sh` line 792:** asserts `CMD_COUNT == 11` over `EXPECTED_SKILLS` lines 48–58 by checking each name appears in `EXT_SRC = pals-hooks.ts`. Under both dispositions, the moved `COMMANDS` array is the source of truth; the assertion MUST be repointed at the new sibling source path (or, if `paul-review` reconciliation is part of Phase 262, the EXPECTED_SKILLS array gains `paul-review` and the count moves to 12). Either way, this is a deliberate count reconciliation, not an incidental edit, and MUST be reported in the Phase 262 SUMMARY.
- **Surfacing TAP assertions** added by Phase 263 will reference `command-routing` and the new sibling path; the contract reserves that surfacing scope for Phase 263 and not Phase 262.

The repoint discipline is **byte-equivalent, not merely semantically equivalent**: the new assertion must check the same byte sequence in the moved source file, not a paraphrased equivalent.

## Phase 262 Handoff

Phase 262 will perform the bounded source extraction. Required Phase 262 actions:

1. **Apply the `inline → export` promotion to `markActivation`** (third application of the pattern). Add `export` to the function declaration, move it from the `registerPalsLifecycleHooks` closure to a top-level function in `pals-hooks.ts`, body unchanged. Also export `getActiveActivation` and `consumeActivationTurn` if Phase 262 needs them; otherwise leave them inline.
2. **Create `drivers/pi/extensions/command-routing.ts`** following the allowed Phase 262 extraction shape above (Disposition A by default).
3. **Move S8 surface to the new sibling** per the chosen disposition, preserving every byte sequence catalogued in this contract (twelve `/paul-*` names, five Ctrl+Alt shortcut bindings, four command-routing constants, four cited functions, two types, the canonical regex, the `routeCommand` body, the `toWrapperCommand` translation rule, the `getQuickActions` priority order).
4. **Repoint TAP assertions** per the discipline above.
5. **Run validation in this order:** `bash tests/helpers/artifact_consistency.sh`, `bash tests/pi-end-to-end-validation.sh`, `bash tests/cross-harness-validation.sh`, `git diff --check`. Reconcile any count change from command output.
6. **Run install verification:** `PALS_ROOT="$PWD" bash drivers/pi/install.sh` reports the new sibling alongside the existing 7 files; expected install count is 7 → 8.
7. **Record outcome in Phase 262 SUMMARY:** which disposition (A or B), which TAP assertions were repointed, the eleven-vs-twelve `CMD_COUNT` reconciliation choice, byte-sequence preservation evidence, and module execution reports.

## Acceptance Checklist (Phase 261 — this contract)

- [x] The contract names every `/paul-*` `name` byte sequence verbatim (twelve entries).
- [x] The contract names every `description` / `skill` / `guidance` byte sequence per entry.
- [x] The contract captures the registration loop, the five Ctrl+Alt invocations, the `routeCommand` body, the `toWrapperCommand` translation rule, the `detectCommandSignal` regex literal, and the `getQuickActions` priority order as literal code-fence blocks or fully-enumerated tables.
- [x] The contract names the four command-routing constants with exact-string single-defined values (`COMMAND_ACTIVATION_TURN_BUDGET = 3`, `PROMPT_ACTIVATION_TURN_BUDGET = 1`, `PRIMARY_QUICK_ACTION_LIMIT = 3`, `MAX_QUICK_ACTIONS = 5`).
- [x] The contract names `CommandDef` and `QuickActionDef` as the two inline types and requires Phase 262 to `export` both from the new sibling.
- [x] The contract states the shared-input disposition for `compactWhitespace` (value-import from `./pals-hooks`), `parsePalsState` (value-import from `./pals-hooks`), `markActivation` (value-import from `./pals-hooks` after `inline → export` promotion — the third application of the pattern), and `ActivationState` (type-only back-import from `./pals-hooks`).
- [x] The contract states the Pi-runtime mutation invocation rule (registration loop + five Ctrl+Alt invocations stay byte-for-byte inside `registerPalsLifecycleHooks` in `pals-hooks.ts`).
- [x] The contract states the canonical `/paul-*` → `/skill:paul-*` routing rule with the exact `routeCommand` body.
- [x] The contract states the explicit Disposition A vs Disposition B choice with Disposition A as the default.
- [x] The contract reinforces the no-UI-only-lifecycle-decisions invariant and protects S4 canonical reply delivery, transcript-visible canonical replies, no auto-approval, no auto-continue, no skipped checkpoints, no inferred merge intent, `.paul/*` authority, GitHub Flow evidence, module evidence, and command-output validation truth.
- [x] The contract enumerates the forbidden Phase 262 scope.
- [x] The contract flags the eleven-vs-twelve `CMD_COUNT` known mismatch in `tests/pi-end-to-end-validation.sh` line 792 / `EXPECTED_SKILLS` lines 48–58 for Phase 262 to reconcile from command output.
- [x] The contract names the allowed Phase 262 sibling-module shape (loader-compat no-op default factory with literal `No-op Pi extension factory` JSDoc, single-defined `COMMANDS` table with all twelve entries, single-defined constants and types with `export`, helper-import tightening to only `compactWhitespace` / `parsePalsState` / `markActivation` value and `ActivationState` / `PalsStateSnapshot` type-only).
- [x] The contract names the install behavior (7 → 8 Pi extension files).
- [x] The contract names the TAP-assertion repoint discipline (byte-equivalent, not paraphrased) and identifies the four known repoint candidates.

## Notes on Validation Baseline

At Phase 261 close, the v2.61 milestone-creation commit `63607289` introduced a pre-existing `Repo ROADMAP stays within active-window line budget` regression (`.paul/ROADMAP.md` is currently 133 lines; ceiling is 120) that is **inherited from `main` before Phase 261 PLAN was drafted**. This affects both `tests/pi-end-to-end-validation.sh` (`not ok 98`) and `tests/cross-harness-validation.sh` (`not ok 31`). The Phase 261 reconciled-from-command-output baseline is therefore:

- Pi: **234 / 1 / 235** (the inherited `not ok 98` ROADMAP line-budget failure is unchanged by Phase 261).
- Cross-harness: **136 / 1 / 137** (the inherited `not ok 31` ROADMAP line-budget failure is unchanged by Phase 261).
- Install: **7 Pi extension files** (unchanged).

Phase 261 success is defined as: no NEW failures introduced, both inherited failures unchanged, install count unchanged, `git diff --check` clean, artifact_consistency PASS, changed-file scope = docs-only plus `.paul/*` lifecycle artifacts. The inherited regression is flagged in the Phase 261 SUMMARY for Phase 264 / v2.62 reconciliation (Phase 264 closure phase or an earlier `/paul:fix` may trim the ROADMAP active window to ≤120 lines; that work is out of Phase 261 scope).

## Status After Phase 262

Phase 262 closed this contract by extracting S8 `command-routing` to `drivers/pi/extensions/command-routing.ts` per the Phase 261 specification. (This is the first `## Status After Phase NNN` section on this contract; the contract was created in Phase 261 with content sections only, so Phase 263 establishes the closure-record convention here for the first time on this contract — mirroring how `docs/PI-NATIVE-LIFECYCLE-UI-EXTRACTION-CONTRACT.md` carried `## Status After Phase 257` from Phase 257 forward, and Phase 259 added `## Status After Phase 258` to it.)

- **Contract closed for Phase 262.** Four cited S8 functions (`getCommand`, `toWrapperCommand`, `detectCommandSignal`, `getQuickActions`) extracted to `drivers/pi/extensions/command-routing.ts` with no signature change; twelve-entry `COMMANDS` array preserved byte-for-byte (every `name` / `description` / `skill` / `guidance` field unchanged); four command-routing constants single-defined as exact-string values (`COMMAND_ACTIVATION_TURN_BUDGET = 3`, `PROMPT_ACTIVATION_TURN_BUDGET = 1`, `PRIMARY_QUICK_ACTION_LIMIT = 3`, `MAX_QUICK_ACTIONS = 5`); canonical `detectCommandSignal` regex literal preserved byte-for-byte (including the `(?:skill:)?` prefix branch and the `i` flag); `routeCommand` body's translation rule `/paul-${name}` → `/skill:${cmd.skill}` preserved byte-for-byte; `toWrapperCommand` three-branch translation rule preserved byte-for-byte; `getQuickActions` priority order preserved byte-for-byte; loader-compat invariant satisfied (the literal `No-op Pi extension factory` JSDoc phrase plus `export default function (_pi: unknown): void {}`).
- **Helper-import tightening applied:** only `compactWhitespace` value-imported from `./pals-hooks` because Disposition A's factory parameter pattern threads `markActivation` through the factory dependency, and the moved S8 code does not reference `parsePalsState`, `readFileOr`, `getFileFreshness`, `selectBoundedLines`, `escapeRegExp`, `extractTextContent`, `collectRecentAssistantTexts`, or `extractLoopSignature`.
- **Type-only back-imports for `ActivationState` and `PalsStateSnapshot`** (Phase 254 / Phase 258 precedent ratified ×3; the back-import is erased at runtime so the dependency graph stays acyclic).
- **Disposition A shipped** (full sibling extraction with closure factories `makeRouteCommand` / `makeRouteWrapperCommand` / `makeRegisterQuickActionShortcut` moved as exported factory functions). Disposition B safe fallback was not needed because the closure-state coupling threaded cleanly through factory dependency parameters (`pi`, `markActivation`, `routeCommand`).
- **4-symbol `inline → export` promotion applied** (`let activationState` module-private + `markActivation` / `getActiveActivation` / `consumeActivationTurn` top-level `export function` — first time the closed-over `let` was moved alongside three closure functions in lockstep). This establishes the durable rule: **if `body unchanged` is required on a closure that closes over a `let`, the `let` and all sibling closures over the same `let` MUST move together.**
- **Eleven-vs-twelve `CMD_COUNT` reconciliation 11 → 12** with `paul-review` added to `EXPECTED_SKILLS` as a deliberate count change driven by the contract's reconciliation intent (not silent expansion).
- **TAP-assertion repoint discipline applied byte-equivalently:** 4 named TAP repoints applied (line-792 `CMD_COUNT == 11 → 12` repointed to `EXT_COMMAND_ROUTING`; line-808 split with shortcut count staying at `EXT_SRC` and `Ctrl+Alt+N` hint repointed to `EXT_COMMAND_ROUTING`; line-815 quick-action constants repointed to `EXT_COMMAND_ROUTING`; line-814+799 ctrl+alt count and `registerCommand` count staying at `EXT_SRC`); 4 collateral TAP repoints applied (`canonical /skill:paul-` guidance repointed to `EXT_COMMAND_ROUTING`; `markActivation("command"...)` + `COMMAND_ACTIVATION_TURN_BUDGET` repointed to `EXT_COMMAND_ROUTING` with `ACTIVATION_SIGNAL_TAG` staying at `EXT_SRC`; `confirm/select` + `sendUserMessage` staying at `EXT_SRC` with `approved` repointed to `EXT_COMMAND_ROUTING` / `EXT_GUIDED_WORKFLOW_DETECTION`; `routing now ... "success"` repointed to `EXT_COMMAND_ROUTING`); 2 in-place predicate adjustments (`SKILL_COUNT 11 → 12`; `paul-review references workflow files` widened to allow `subagent` / `Canonical references` because `paul-review` wraps a `code-reviewer` subagent rather than a kernel workflow); 1 new bounded `EXT_COMMAND_ROUTING` source-shape TAP block added.
- **+5 vs planned +1 Pi count delta surfaced as bounded discovery:** `EXPECTED_SKILLS` + `paul-review` ripples through the line-223 per-skill loop +4 `paul-review` iterations, plus +1 from the new `EXT_COMMAND_ROUTING` source-shape block. Reconciled from command output as deliberate count change.
- **12-iteration registration loop preserved by call shape** (`for (const cmd of COMMANDS) { pi.registerCommand(cmd.name, ...) }` byte-for-byte at the same call site in `pals-hooks.ts`, including the `carlState.stashedCmdCtx = ctx` CARL-coupling assignment).
- **Five `Key.ctrlAlt("[nsrhm]")` invocations preserved by call shape** at the same call site in `pals-hooks.ts`.
- **`before_agent_start` handler call sites preserved** (`markActivation("prompt"...)`, `getActiveActivation()`, `consumeActivationTurn()` continue to fire from the lifecycle handler in `pals-hooks.ts`).
- **No-UI-only-lifecycle-decisions invariant verified shipped:** `command-routing.ts` performs no `.paul/*` writes, no `pi.sendUserMessage` calls outside the `routeCommand` factory body, and no S4 canonical-reply identifier invocations.
- **Install reports `[ok] Pi extensions installed: 8 files`** (7 → 8); the source-set rule auto-installed the new sibling.
- **Pi e2e validation reconciled-from-command-output:** Pi 239/240 (234/235 → 239/240 with the bounded `EXT_COMMAND_ROUTING` TAP block + 8 in-flight repointed pre-existing assertions + 2 in-place predicate adjustments + 4 `paul-review` per-skill iterations); the 1 inherited Path A `not ok 102` is unchanged — was `not ok 98`, renumbered by `EXPECTED_SKILLS` expansion (same test, no semantic change).
- **Cross-harness validation:** 136/137 unchanged with the same inherited `not ok 31`.
- **Artifact consistency:** PASS. **`git diff --check`:** clean.
- **PR #177 squash-merged 2026-05-07 as `19555747`.**
- **Phase 263** owns user-facing-doc surfacing (this phase is recording the closure record).
- **Phase 264** will own evidence closure + next-roadmap decision and reconciliation/escalation of the Path A inherited regression (`not ok 102` Pi / `not ok 31` cross-harness).
- **S4 canonical reply delivery deferral preserved:** `sendCanonicalWorkflowResponse`, `presentGuidedWorkflowMoment`, `loadGuidedWorkflowConfig`, `shouldAutoPresent` remain inline in `pals-hooks.ts` as the integration point.
- **Full Claude Code / Agent SDK driver removal still blocked** per `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`.
