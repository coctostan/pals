/**
 * PALS Hooks — Pi Extension
 *
 * Bridges Pi lifecycle events to PALS workflows. Registers /paul-* commands
 * and injects project context so the LLM can follow PALS workflows correctly.
 *
 * Install: copy to ~/.pi/agent/extensions/pals-hooks.ts
 * Requires: Pi coding agent with extension support
 */

import { readFileSync, existsSync } from "fs";
import { join } from "path";

// -- Types (minimal Pi extension API surface) --

interface ExtensionAPI {
  registerCommand(name: string, opts: { description: string; handler: CommandHandler }): void;
  on(event: string, handler: (...args: any[]) => void | Promise<void>): void;
  appendEntry(entry: { type: string; content: string }): void;
}

type CommandHandler = (args: string, ctx: CommandContext) => void | Promise<void>;

interface CommandContext {
  ui: { notify(msg: string): void };
}

// -- Helpers --

function readFileOr(path: string, fallback: string): string {
  try {
    return existsSync(path) ? readFileSync(path, "utf-8") : fallback;
  } catch {
    return fallback;
  }
}

function parsePalsState(cwd: string): { detected: boolean; phase?: string; loop?: string; nextAction?: string } {
  const statePath = join(cwd, ".paul", "STATE.md");
  const content = readFileOr(statePath, "");
  if (!content) return { detected: false };

  const phaseMatch = content.match(/Phase:\s*(.+)/);
  const loopMatch = content.match(/PLAN\s+──▶\s+APPLY\s+──▶\s+UNIFY\s*\n\s*([^\n]+)/);
  const nextMatch = content.match(/Next action:\s*(.+)/);

  return {
    detected: true,
    phase: phaseMatch?.[1]?.trim(),
    loop: loopMatch?.[2]?.trim(),
    nextAction: nextMatch?.[1]?.trim(),
  };
}

function loadModuleNames(cwd: string): string[] {
  const modulesPath = join(cwd, "modules.yaml");
  const content = readFileOr(modulesPath, "");
  if (!content) return [];
  // Simple extraction: lines matching "  name: <value>"
  return [...content.matchAll(/^\s+name:\s*(.+)$/gm)].map((m) => m[1].trim());
}

// -- Command definitions --

const COMMANDS: Array<{ name: string; description: string; skill: string }> = [
  { name: "paul-init", description: "Initialize PALS in this project", skill: "paul-init" },
  { name: "paul-plan", description: "Create execution plan for current phase", skill: "paul-plan" },
  { name: "paul-apply", description: "Execute an approved plan", skill: "paul-apply" },
  { name: "paul-unify", description: "Reconcile plan vs actual and close the loop", skill: "paul-unify" },
  { name: "paul-resume", description: "Restore context and continue work", skill: "paul-resume" },
  { name: "paul-status", description: "Show project progress and next action", skill: "paul-status" },
  { name: "paul-fix", description: "Quick fix with compressed loop", skill: "paul-fix" },
  { name: "paul-pause", description: "Create handoff and prepare for session break", skill: "paul-pause" },
  { name: "paul-milestone", description: "Create or complete a milestone", skill: "paul-milestone" },
  { name: "paul-discuss", description: "Explore phase or milestone vision", skill: "paul-discuss" },
  { name: "paul-help", description: "Show available PAUL commands", skill: "paul-help" },
];

// -- Extension entry point --

export default function palsHooks(pi: ExtensionAPI): void {
  const cwd = process.cwd();

  // Register all /paul-* slash commands
  for (const cmd of COMMANDS) {
    pi.registerCommand(cmd.name, {
      description: cmd.description,
      handler: async (_args: string, ctx: CommandContext) => {
        ctx.ui.notify(`Run /skill:${cmd.skill} to execute this workflow`);
      },
    });
  }

  // Session start: detect PALS project and log state
  pi.on("session_start", () => {
    const state = parsePalsState(cwd);
    if (!state.detected) return;

    const summary = [
      "PALS project detected.",
      state.phase ? `Phase: ${state.phase}` : null,
      state.loop ? `Loop: ${state.loop}` : null,
      state.nextAction ? `Next: ${state.nextAction}` : null,
    ]
      .filter(Boolean)
      .join(" | ");

    pi.appendEntry({ type: "system", content: summary });
  });

  // Context hook: inject PALS state when workflows are active
  pi.on("context", (...args: any[]) => {
    const messages: Array<{ role: string; content: string }> = args[0] ?? [];

    // Check if a PALS workflow is active in recent messages
    const recentText = messages
      .slice(-5)
      .map((m) => m.content)
      .join(" ");
    const palsActive = /paul-(plan|apply|unify|resume|fix|init|status|pause|milestone|discuss|help)/i.test(recentText);

    if (!palsActive) return;

    const state = parsePalsState(cwd);
    if (!state.detected) return;

    const modules = loadModuleNames(cwd);

    const contextLines = [
      "## PALS Context (auto-injected)",
      "",
      `**Phase:** ${state.phase ?? "unknown"}`,
      `**Loop:** ${state.loop ?? "unknown"}`,
      state.nextAction ? `**Next action:** ${state.nextAction}` : null,
      modules.length > 0 ? `**Active modules:** ${modules.join(", ")}` : null,
      "",
      "Follow the loaded SKILL.md instructions. Read referenced workflow files for full process details.",
    ];

    const contextMsg = contextLines.filter(Boolean).join("\n");
    pi.appendEntry({ type: "system", content: contextMsg });
  });
}
