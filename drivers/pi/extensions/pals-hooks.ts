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

export default function palsHooks(pi: any): void {
  // Register all /paul-* slash commands — delegate to skills
  for (const cmd of COMMANDS) {
    pi.registerCommand(cmd.name, {
      description: cmd.description,
      handler: async (args: string, ctx: any) => {
        const skillCmd = `/skill:${cmd.skill}${args ? " " + args : ""}`;
        pi.sendUserMessage(skillCmd);
      },
    });
  }

  // Session start: detect PALS project and show state
  pi.on("session_start", async (_event: any, ctx: any) => {
    const cwd = ctx?.cwd ?? process.cwd();
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

    ctx?.ui?.notify(summary, "info");
  });

  // Context hook: inject PALS state into messages when workflows are active
  pi.on("context", async (event: any, _ctx: any) => {
    const messages: any[] = event?.messages;
    if (!Array.isArray(messages) || messages.length === 0) return;

    // Check if a PALS workflow is active in recent messages
    const recentText = messages
      .slice(-5)
      .map((m: any) => (typeof m.content === "string" ? m.content : ""))
      .join(" ");
    const palsActive = /paul-(plan|apply|unify|resume|fix|init|status|pause|milestone|discuss|help)/i.test(recentText);

    if (!palsActive) return;

    const cwd = _ctx?.cwd ?? process.cwd();
    const state = parsePalsState(cwd);
    if (!state.detected) return;

    const contextLines = [
      "## PALS Context (auto-injected)",
      "",
      `**Phase:** ${state.phase ?? "unknown"}`,
      `**Loop:** ${state.loop ?? "unknown"}`,
      state.nextAction ? `**Next action:** ${state.nextAction}` : null,
      "",
      "Follow the loaded SKILL.md instructions. Read referenced workflow files for full process details.",
    ];

    const contextMsg = contextLines.filter(Boolean).join("\n");

    // Inject as a system message at the end of the messages array
    messages.push({ role: "user", content: contextMsg });

    return { messages };
  });
}
