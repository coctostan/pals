/**
 * Command Routing — Pi Extension subsystem (S8)
 *
 * Owns the `/paul-*` command-definition surface (the twelve-entry `COMMANDS`
 * table), the wrapper-to-skill translation rule, the command-signal
 * extractor, the quick-action selector, and — under Disposition A — the
 * closure factories that route command activations through
 * `pi.sendUserMessage` and register Pi quick-action shortcuts via
 * `pi.registerShortcut`. Extracted from `drivers/pi/extensions/pals-hooks.ts`
 * in Phase 262
 * (`.paul/phases/262-bounded-s8-submodule-extraction/262-01-PLAN.md`) per
 * `docs/PI-NATIVE-COMMAND-ROUTING-EXTRACTION-CONTRACT.md` and
 * `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`.
 *
 * Authority: Derived aid only. This module routes command activations and
 * registers shortcut wrappers, but never sends canonical guided-workflow
 * replies (S4 owns that), never approves work, never persists lifecycle
 * state, never infers merge intent, never auto-continues, never skips
 * checkpoints, never drives lifecycle decisions from UI, and never writes
 * `.paul/*` artifacts (the no-UI-only-lifecycle-decisions invariant). The
 * twelve `/paul-*` `name`/`description`/`skill`/`guidance` byte sequences in
 * `COMMANDS`, the four command-routing constant values, the
 * `detectCommandSignal` regex literal, the `routeCommand` body's canonical
 * `/paul-*` → `/skill:paul-*` translation rule, the `toWrapperCommand`
 * translation rule, and the `getQuickActions` priority order are
 * single-defined here so consumers continue to recognize the command
 * surface unchanged.
 */

import type { ActivationState, PalsStateSnapshot } from "./pals-hooks";
import { compactWhitespace } from "./pals-hooks";

export type CommandDef = {
  name: string;
  description: string;
  skill: string;
  guidance: string;
};

export type QuickActionDef = {
  id: string;
  commandName: CommandDef["name"];
  label: string;
  shortcutHint: string;
};

export const COMMAND_ACTIVATION_TURN_BUDGET = 3;
export const PROMPT_ACTIVATION_TURN_BUDGET = 1;
export const PRIMARY_QUICK_ACTION_LIMIT = 3;
export const MAX_QUICK_ACTIONS = 5;

export const COMMANDS: CommandDef[] = [
  {
    name: "paul-init",
    description: "Set up PALS lifecycle files for this project",
    skill: "paul-init",
    guidance: "Pi convenience wrapper → canonical /skill:paul-init",
  },
  {
    name: "paul-plan",
    description: "Plan the next PALS phase",
    skill: "paul-plan",
    guidance: "Pi convenience wrapper → canonical /skill:paul-plan",
  },
  {
    name: "paul-apply",
    description: "Execute the approved PALS plan",
    skill: "paul-apply",
    guidance: "Pi convenience wrapper → canonical /skill:paul-apply",
  },
  {
    name: "paul-unify",
    description: "Reconcile completed work and close the loop",
    skill: "paul-unify",
    guidance: "Pi convenience wrapper → canonical /skill:paul-unify",
  },
  {
    name: "paul-resume",
    description: "Resume PALS work from current project state",
    skill: "paul-resume",
    guidance: "Pi convenience wrapper → canonical /skill:paul-resume",
  },
  {
    name: "paul-status",
    description: "Show current PALS status and next action",
    skill: "paul-status",
    guidance: "Pi convenience wrapper → canonical /skill:paul-status",
  },
  {
    name: "paul-fix",
    description: "Run a quick PALS fix flow",
    skill: "paul-fix",
    guidance: "Pi convenience wrapper → canonical /skill:paul-fix",
  },
  {
    name: "paul-pause",
    description: "Create a PALS handoff before stopping",
    skill: "paul-pause",
    guidance: "Pi convenience wrapper → canonical /skill:paul-pause",
  },
  {
    name: "paul-milestone",
    description: "Create or complete a PALS milestone",
    skill: "paul-milestone",
    guidance: "Pi convenience wrapper → canonical /skill:paul-milestone",
  },
  {
    name: "paul-discuss",
    description: "Discuss scope before planning in PALS",
    skill: "paul-discuss",
    guidance: "Pi convenience wrapper → canonical /skill:paul-discuss",
  },
  {
    name: "paul-help",
    description: "Show Pi command and skill guidance for PALS",
    skill: "paul-help",
    guidance: "Pi convenience wrapper → canonical /skill:paul-help",
  },
  {
    name: "paul-review",
    description: "Run thorough code review via REV subagent",
    skill: "paul-review",
    guidance: "Pi convenience wrapper → canonical /skill:paul-review",
  },
];

export function getCommand(name: CommandDef["name"]): CommandDef | undefined {
  return COMMANDS.find((cmd) => cmd.name === name);
}

export function toWrapperCommand(commandText?: string): string | undefined {
  const trimmed = compactWhitespace(commandText);
  if (!trimmed) return undefined;
  if (trimmed.startsWith("/paul-")) return trimmed;
  if (trimmed.startsWith("/skill:paul-")) {
    return trimmed.replace("/skill:", "/");
  }
  return undefined;
}

export function detectCommandSignal(value?: string): string | undefined {
  const compact = compactWhitespace(value);
  if (!compact) return undefined;

  const match = compact.match(/\/(?:skill:)?(paul-(?:init|plan|apply|unify|resume|status|fix|pause|milestone|discuss|help|review))(?:\s+(.+))?/i);
  if (!match) return undefined;

  const command = `/${match[1].toLowerCase()}`;
  const args = compactWhitespace(match[2]);
  return args ? `${command} ${args}` : command;
}

export function getQuickActions(state: PalsStateSnapshot): QuickActionDef[] {
  const actions: QuickActionDef[] = [];
  const nextWrapper = toWrapperCommand(state.nextAction);
  const nextCommandName = nextWrapper?.slice(1).split(/\s+/, 1)[0] as CommandDef["name"] | undefined;
  if (nextCommandName && getCommand(nextCommandName)) {
    actions.push({
      id: "next-action",
      commandName: nextCommandName,
      label: "Next",
      shortcutHint: "Ctrl+Alt+N",
    });
  }

  actions.push(
    { id: "status", commandName: "paul-status", label: "Status", shortcutHint: "Ctrl+Alt+S" },
    { id: "resume", commandName: "paul-resume", label: "Resume", shortcutHint: "Ctrl+Alt+R" },
    { id: "help", commandName: "paul-help", label: "Help", shortcutHint: "Ctrl+Alt+H" },
    { id: "milestone", commandName: "paul-milestone", label: "Milestone", shortcutHint: "Ctrl+Alt+M" },
  );

  return actions
    .filter((action, index, all) => all.findIndex((candidate) => candidate.commandName === action.commandName) === index)
    .slice(0, MAX_QUICK_ACTIONS);
}

// -- Closure factories (Disposition A) --

export function makeRouteCommand(deps: {
  pi: any;
  markActivation: (source: ActivationState["source"], signal: string, turns: number) => void;
}): (commandName: CommandDef["name"], args?: string, ctx?: any) => void {
  const { pi, markActivation } = deps;
  return (commandName: CommandDef["name"], args = "", ctx?: any): void => {
    const cmd = getCommand(commandName);
    if (!cmd) return;
    const trimmedArgs = args.trim();
    const wrapperCmd = `/${commandName}${trimmedArgs ? " " + trimmedArgs : ""}`;
    markActivation("command", wrapperCmd, COMMAND_ACTIVATION_TURN_BUDGET);
    const skillCmd = `/skill:${cmd.skill}${trimmedArgs ? " " + trimmedArgs : ""}`;
    ctx?.ui?.notify(`${cmd.guidance} — routing now`, "success");
    pi.sendUserMessage(skillCmd);
  };
}

export function makeRouteWrapperCommand(deps: {
  routeCommand: ReturnType<typeof makeRouteCommand>;
}): (commandText: string, ctx?: any) => void {
  const { routeCommand } = deps;
  return (commandText: string, ctx?: any): void => {
    const wrapper = toWrapperCommand(commandText);
    if (!wrapper) return;

    const commandName = wrapper.slice(1).split(/\s+/, 1)[0] as CommandDef["name"];
    const args = wrapper.replace(/^\/paul-[^\s]+\s*/, "");
    routeCommand(commandName, args, ctx);
  };
}

export function makeRegisterQuickActionShortcut(deps: {
  pi: any;
}): (shortcut: string, description: string, handler: (ctx: any) => void) => void {
  const { pi } = deps;
  return (
    shortcut: string,
    description: string,
    handler: (ctx: any) => void,
  ): void => {
    pi.registerShortcut(shortcut, {
      description,
      handler: async (ctx: any) => {
        handler(ctx);
      },
    });
  };
}

// No-op Pi extension factory
export default function (_pi: unknown): void {}
