/**
 * PALS Hooks — Pi Extension
 *
 * Bridges Pi lifecycle events to PALS workflows. Registers /paul-* commands
 * as Pi-native convenience wrappers and injects only minimal project context
 * so the LLM can follow PALS workflows correctly.
 *
 * Install: copy to ~/.pi/agent/extensions/pals-hooks.ts
 * Requires: Pi coding agent with extension support
 */

import { readFileSync, existsSync } from "fs";
import { join } from "path";
import { Key } from "@mariozechner/pi-tui";

// -- Helpers --

const PALS_STATUS_ID = "pals-lifecycle";
const PALS_WIDGET_ID = "pals-lifecycle";
const PRIMARY_QUICK_ACTION_LIMIT = 3;
const MAX_QUICK_ACTIONS = 5;

type PalsStateSnapshot = {
  detected: boolean;
  milestone?: string;
  phase?: string;
  loop?: string;
  nextAction?: string;
};

type CommandDef = {
  name: string;
  description: string;
  skill: string;
  guidance: string;
};

type QuickActionDef = {
  id: string;
  commandName: CommandDef["name"];
  label: string;
  shortcutHint: string;
};

function readFileOr(path: string, fallback: string): string {
  try {
    return existsSync(path) ? readFileSync(path, "utf-8") : fallback;
  } catch {
    return fallback;
  }
}

function compactWhitespace(value?: string): string | undefined {
  return value?.replace(/\s+/g, " ").trim() || undefined;
}

function parsePalsState(cwd: string): PalsStateSnapshot {
  const statePath = join(cwd, ".paul", "STATE.md");
  const content = readFileOr(statePath, "");
  if (!content) return { detected: false };

  const milestoneMatch = content.match(/Milestone:\s*(.+)/);
  const phaseMatch = content.match(/Phase:\s*(.+)/);
  const loopHeaderMatch = content.match(/PLAN\s+──▶\s+APPLY\s+──▶\s+UNIFY/);
  const loopStateMatch = content.match(/PLAN\s+──▶\s+APPLY\s+──▶\s+UNIFY\s*\n\s*([^\n]+)/);
  const nextMatch = content.match(/Next action:\s*(.+)/);

  return {
    detected: true,
    milestone: compactWhitespace(milestoneMatch?.[1]),
    phase: compactWhitespace(phaseMatch?.[1]),
    loop: loopHeaderMatch
      ? compactWhitespace(`PLAN ──▶ APPLY ──▶ UNIFY ${loopStateMatch?.[1] ?? ""}`)
      : undefined,
    nextAction: compactWhitespace(nextMatch?.[1]),
  };
}

function getCommand(name: CommandDef["name"]): CommandDef | undefined {
  return COMMANDS.find((cmd) => cmd.name === name);
}

function toWrapperCommand(commandText?: string): string | undefined {
  const trimmed = compactWhitespace(commandText);
  if (!trimmed) return undefined;
  if (trimmed.startsWith("/paul-")) return trimmed;
  if (trimmed.startsWith("/skill:paul-")) {
    return trimmed.replace("/skill:", "/");
  }
  return undefined;
}

function getQuickActions(state: PalsStateSnapshot): QuickActionDef[] {
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

function renderQuickActionSummary(state: PalsStateSnapshot): string | undefined {
  const actions = getQuickActions(state).slice(0, PRIMARY_QUICK_ACTION_LIMIT);
  if (actions.length === 0) return undefined;
  return `Actions: ${actions.map((action) => `${action.label} ${action.shortcutHint}`).join(" | ")}`;
}
function renderLifecycleStatus(state: PalsStateSnapshot): string | undefined {
  if (!state.detected) return undefined;
  return [
    "PALS",
    state.phase ? `Phase: ${state.phase}` : null,
    state.nextAction ? `Next: ${state.nextAction}` : null,
    renderQuickActionSummary(state),
  ]
    .filter(Boolean)
    .join(" • ");
}
function renderLifecycleWidget(state: PalsStateSnapshot): string[] | undefined {
  if (!state.detected) return undefined;

  const quickActions = getQuickActions(state);

  const primaryActions = quickActions.slice(0, PRIMARY_QUICK_ACTION_LIMIT);
  const secondaryActions = quickActions.slice(PRIMARY_QUICK_ACTION_LIMIT);
  const actionLines = [
    primaryActions.length > 0 ? `Actions: ${primaryActions.map((action) => `${action.label} ${action.shortcutHint}`).join(" | ")}` : null,
    secondaryActions.length > 0 ? `More: ${secondaryActions.map((action) => `${action.label} ${action.shortcutHint}`).join(" | ")}` : null,
  ].filter(Boolean) as string[];
  const lines = [
    "PALS Lifecycle",
    state.milestone ? `Milestone: ${state.milestone}` : "Milestone: unknown",
    state.phase ? `Phase: ${state.phase}` : "Phase: unknown",
    state.loop ? `Loop: ${state.loop}` : "Loop: unknown",
    state.nextAction ? `Next action: ${state.nextAction}` : "Next action: unknown",
    ...actionLines,
  ];
  return lines;
}
function syncLifecycleUi(ctx: any): void {
  const cwd = ctx?.cwd ?? process.cwd();
  const state = parsePalsState(cwd);
  if (!state.detected) {
    ctx?.ui?.setStatus(PALS_STATUS_ID, undefined);
    ctx?.ui?.setWidget(PALS_WIDGET_ID, undefined);
    return;
  }
  ctx?.ui?.setStatus(PALS_STATUS_ID, renderLifecycleStatus(state));
  ctx?.ui?.setWidget(PALS_WIDGET_ID, renderLifecycleWidget(state));
}

// -- Command definitions --

const COMMANDS: CommandDef[] = [
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
];

// -- Extension entry point --
export default function palsHooks(pi: any): void {
  const routeCommand = (commandName: CommandDef["name"], args = "", ctx?: any): void => {
    const cmd = getCommand(commandName);
    if (!cmd) return;
    const trimmedArgs = args.trim();
    const skillCmd = `/skill:${cmd.skill}${trimmedArgs ? " " + trimmedArgs : ""}`;
    ctx?.ui?.notify(`${cmd.guidance} — routing now`, "info");
    pi.sendUserMessage(skillCmd);
  };

  const routeWrapperCommand = (commandText: string, ctx?: any): void => {
    const wrapper = toWrapperCommand(commandText);
    if (!wrapper) return;

    const commandName = wrapper.slice(1).split(/\s+/, 1)[0] as CommandDef["name"];
    const args = wrapper.replace(/^\/paul-[^\s]+\s*/, "");
    routeCommand(commandName, args, ctx);
  };
  const registerQuickActionShortcut = (
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
  // Register all /paul-* slash commands as Pi-native discovery wrappers.
  for (const cmd of COMMANDS) {
    pi.registerCommand(cmd.name, {
      description: cmd.description,
      handler: async (args: string, ctx: any) => {
        routeCommand(cmd.name, args, ctx);
      },
    });
  }

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
  // Session start: detect PALS project, show state, and render persistent lifecycle UI.
  pi.on("session_start", async (_event: any, ctx: any) => {
    const cwd = ctx?.cwd ?? process.cwd();
    const state = parsePalsState(cwd);
    syncLifecycleUi(ctx);
    if (!state.detected) return;
    const summary = [
      "PALS project detected.",
      state.milestone ? `Milestone: ${state.milestone}` : null,
      state.phase ? `Phase: ${state.phase}` : null,
      state.loop ? `Loop: ${state.loop}` : null,
      state.nextAction ? `Next: ${state.nextAction}` : null,
      renderQuickActionSummary(state),
      "Modules load from modules.yaml and workflow dispatch; Pi does not expose standalone TODD/WALT skills.",
    ]
      .filter(Boolean)
      .join(" | ");
    ctx?.ui?.notify(summary, "info");
  });

  // Keep the visible lifecycle surface aligned with shared artifact state.
  pi.on("before_agent_start", async (_event: any, ctx: any) => {
    syncLifecycleUi(ctx);
  });

  pi.on("turn_end", async (_event: any, ctx: any) => {
    syncLifecycleUi(ctx);
  });

  pi.on("agent_end", async (_event: any, ctx: any) => {
    syncLifecycleUi(ctx);
  });

  // Context hook: inject minimal PALS state only when workflows are active.
  pi.on("context", async (event: any, ctx: any) => {
    const messages: any[] = event?.messages;
    if (!Array.isArray(messages) || messages.length === 0) return;

    const recentText = messages
      .slice(-5)
      .map((m: any) => (typeof m.content === "string" ? m.content : ""))
      .join(" ");
    const palsActive = /paul-(plan|apply|unify|resume|fix|init|status|pause|milestone|discuss|help)/i.test(recentText);

    if (!palsActive) return;

    syncLifecycleUi(ctx);

    const cwd = ctx?.cwd ?? process.cwd();
    const state = parsePalsState(cwd);
    if (!state.detected) return;

    const contextLines = [
      "## PALS Context (auto-injected)",
      "",
      state.milestone ? `**Milestone:** ${state.milestone}` : null,
      `**Phase:** ${state.phase ?? "unknown"}`,
      `**Loop:** ${state.loop ?? "unknown"}`,
      state.nextAction ? `**Next action:** ${state.nextAction}` : null,
      "",
      "Follow the loaded SKILL.md instructions. Read referenced workflow files for full process details.",
    ];

    const contextMsg = contextLines.filter(Boolean).join("\n");
    messages.push({ role: "user", content: contextMsg });
    return { messages };
  });
}
