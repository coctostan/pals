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

import { readFileSync, existsSync, statSync } from "fs";
import { join } from "path";
import { Key } from "@mariozechner/pi-tui";
import {
  RecentModuleActivity,
  extractRecentModuleActivity,
  formatModuleEntryList,
} from "./module-activity-parsing";
import { renderArtifactSlices } from "./artifact-slice-rendering";
import { renderWorkflowResourceCapsules } from "./workflow-resource-capsule-rendering";
import {
  GUIDED_WORKFLOW_LOOKBACK,
  GuidedWorkflowMoment,
  detectGuidedWorkflowMoment,
} from "./guided-workflow-detection";
import {
  PALS_STATUS_ID,
  PALS_WIDGET_ID,
  renderLoopBadge,
  renderCompactLoopSummary,
  renderLifecycleActionLabel,
  renderModuleActivity,
  renderModuleActivityDetails,
  renderLifecycleStatus,
  renderLifecycleWidget,
  syncLifecycleUi,
} from "./lifecycle-ui";

// -- Helpers --

import {
  PRIMARY_INJECTION_EVENT,
  SUPPORTING_CONTEXT_EVENT,
  PALS_CONTEXT_CUSTOM_TYPE,
  LEGACY_PALS_CONTEXT_HEADER,
  STATE_AUTHORITY_TAG,
  ACTIVATION_SIGNAL_TAG,
  shouldInjectPalsContext,
  buildPalsContextPayload,
  isLegacyPalsContextMessage,
  isPalsContextMessage,
  keepOnlyLatestPalsContextMessage,
  messagesChanged,
} from "./pals-context-injection";

import {
  COMMANDS,
  PROMPT_ACTIVATION_TURN_BUDGET,
  toWrapperCommand,
  detectCommandSignal,
  makeRouteCommand,
  makeRouteWrapperCommand,
  makeRegisterQuickActionShortcut,
} from "./command-routing";

const ACTIVATION_WINDOW_MS = 15 * 60 * 1000;
export const RECENT_MODULE_ACTIVITY_LOOKBACK = 3;
export const MAX_VISIBLE_MODULES = 3;
export const MAX_WIDGET_MODULE_DETAILS = 4;

// -- CARL Session Boundary Manager constants --
const CARL_NEW_SESSION_TIMEOUT_MS = 10_000;
const CARL_DEFAULT_CONTINUE_THRESHOLD = 0.4;
const CARL_DEFAULT_SAFETY_CEILING = 0.8;
const CARL_DEFAULT_STRATEGY: CarlConfig["session_strategy"] = "phase-boundary";

export type PalsStateSnapshot = {
  detected: boolean;
  milestone?: string;
  phase?: string;
  loop?: string;
  nextAction?: string;
};


export type ActivationState = {
  source: "command" | "prompt";
  signal: string;
  expiresAt: number;
  turnsRemaining: number;
};

// -- Activation state (Phase 262 inline → export promotion; module-private let; three top-level export functions) --

let activationState: ActivationState | undefined;

export function markActivation(
  source: ActivationState["source"],
  signal: string,
  turns: number,
): void {
  activationState = {
    source,
    signal,
    turnsRemaining: turns,
    expiresAt: Date.now() + ACTIVATION_WINDOW_MS,
  };
}

export function getActiveActivation(): ActivationState | undefined {
  if (!activationState) return undefined;
  if (activationState.turnsRemaining <= 0 || activationState.expiresAt < Date.now()) {
    activationState = undefined;
    return undefined;
  }
  return activationState;
}

export function consumeActivationTurn(): void {
  if (!activationState) return;
  activationState.turnsRemaining -= 1;
  if (activationState.turnsRemaining <= 0) {
    activationState = undefined;
  }
}

type CarlConfig = {
  session_strategy: "phase-boundary" | "always-fresh" | "manual";
  continue_threshold: number;
  continue_threshold_tokens?: number;
  safety_ceiling: number;
  safety_ceiling_tokens?: number;
};

type GuidedWorkflowAutoPresent = {
  plan_review: boolean;
  apply_approval: boolean;
  continue_to_unify: boolean;
  checkpoint_decision: boolean;
  checkpoint_human_verify: boolean;
  checkpoint_human_action: boolean;
  resume_next: boolean;
  phase_transition: boolean;
  milestone_transition: boolean;
  merge_gate_routing: boolean;
};

type GuidedWorkflowConfig = {
  auto_present: GuidedWorkflowAutoPresent;
};

const GUIDED_WORKFLOW_DEFAULTS: GuidedWorkflowAutoPresent = {
  plan_review: false,
  apply_approval: false,
  continue_to_unify: true,
  checkpoint_decision: true,
  checkpoint_human_verify: true,
  checkpoint_human_action: true,
  resume_next: true,
  phase_transition: false,
  milestone_transition: false,
  merge_gate_routing: true,
};

// Guided workflow runtime guardrails: no auto-approval, no auto-continue,
// no skipped checkpoints, no UI-only lifecycle decisions, no inferred merge intent.
// notify-only mode never sends a canonical reply; guided_workflow.auto_present is display behavior only.
// Widgets, notifications, and runtime memory are not lifecycle authority; .paul/* artifacts stay authoritative.

type CarlState = {
  stashedCmdCtx: any | undefined;
  dispatching: boolean;
  previousLoopSignature: string | undefined;
  pauseAtNextBoundary: boolean;
};

export function readFileOr(path: string, fallback: string): string {
  try {
    return existsSync(path) ? readFileSync(path, "utf-8") : fallback;
  } catch {
    return fallback;
  }
}

export function compactWhitespace(value?: string): string | undefined {
  return value?.replace(/\s+/g, " ").trim() || undefined;
}

export function parsePalsState(cwd: string): PalsStateSnapshot {
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

export function getFileFreshness(path: string): string {
  try {
    return existsSync(path) ? statSync(path).mtime.toISOString() : "unavailable";
  } catch {
    return "unavailable";
  }
}

export function selectBoundedLines(content: string, patterns: RegExp[], maxLines: number): string[] {
  const selected: string[] = [];
  for (const line of content.split(/\r?\n/)) {
    const compact = compactWhitespace(line);
    if (!compact) continue;
    if (patterns.some((pattern) => pattern.test(compact))) selected.push(compact);
    if (selected.length >= maxLines) break;
  }
  return selected;
}

export function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function buildSessionOrientationSummary(state: PalsStateSnapshot): string {
  return [
    "PALS project detected.",
    state.milestone ? `Milestone: ${state.milestone}` : null,
    state.phase ? `Phase: ${state.phase}` : null,
    state.loop ? `Loop: ${state.loop}` : null,
    state.nextAction ? `Next: ${state.nextAction}` : null,
    "Persistent lifecycle UI stays centered on milestone, phase, loop, and next action.",
    `Activation model: explicit /paul-* entry is strongest signal; ${PRIMARY_INJECTION_EVENT} handles primary injection and ${SUPPORTING_CONTEXT_EVENT} stays support-only.`,
    "Guided workflow UX watches canonical prompts like Would you like to see the plan?, Continue to APPLY, CHECKPOINT, Continue to UNIFY, and ▶ NEXT.",
    "Modules load from modules.yaml and workflow dispatch; Pi does not expose standalone TODD/WALT skills.",
    "Delegated APPLY stays prompt/workflow-first: eligible bounded tasks may use repo-local `pals-implementer`, but parent APPLY still owns verification, module gates, fallback, and `.paul/*` updates.",
  ]
    .filter(Boolean)
    .join(" | ");
}

function extractTextContent(message: any): string | undefined {
  if (!message) return undefined;
  if (typeof message.content === "string") return message.content.trim() || undefined;
  if (!Array.isArray(message.content)) return undefined;

  const text = message.content
    .filter((block: any) => block?.type === "text")
    .map((block: any) => block.text ?? "")
    .join("\n")
    .trim();

  return text || undefined;
}

export function collectRecentAssistantTexts(ctx: any, event: any, limit = GUIDED_WORKFLOW_LOOKBACK): string[] {
  const texts: string[] = [];
  const seen = new Set<string>();

  const pushText = (message: any): void => {
    const text = extractTextContent(message);
    if (!text || seen.has(text)) return;
    seen.add(text);
    texts.push(text);
  };

  const eventMessages = Array.isArray(event?.messages) ? [...event.messages].reverse() : [];
  for (const message of eventMessages) {
    if (message?.role === "assistant") pushText(message);
    if (texts.length >= limit) return texts;
  }

  const branchEntries = typeof ctx?.sessionManager?.getBranch === "function" ? [...ctx.sessionManager.getBranch()].reverse() : [];
  for (const entry of branchEntries) {
    const message = entry?.type === "message" ? entry.message : entry;
    if (message?.role === "assistant") pushText(message);
    if (texts.length >= limit) break;
  }

  return texts;
}


function sendCanonicalWorkflowResponse(pi: any, ctx: any, canonicalResponse?: string): void {
  // Canonical guided workflow replies have one transcript-visible send path:
  // explicit confirm/select result → sendCanonicalWorkflowResponse → pi.sendUserMessage.
  const response = compactWhitespace(canonicalResponse);
  if (!response) return;

  if (ctx?.isIdle?.() === false) {
    pi.sendUserMessage(response, { deliverAs: "followUp" });
    return;
  }

  pi.sendUserMessage(response);
}

async function presentGuidedWorkflowMoment(
  moment: GuidedWorkflowMoment,
  ctx: any,
  pi: any,
  config?: GuidedWorkflowConfig,
): Promise<void> {
  if (!ctx?.hasUI) return;
  const autoPresent = config ? shouldAutoPresent(config, moment.kind) : true;

  if (!autoPresent) {
    // guided_workflow.auto_present is display behavior only; disabling it never approves,
    // continues, completes checkpoints, records validation, or creates lifecycle state.
    ctx.ui.notify(
      `PALS workflow: ${moment.title} — respond in the chat prompt when ready. ${moment.summary}`,
      "info",
    );
    return;
  }

  if (moment.ui === "notify") {
    // notify-only mode never sends a canonical reply and never creates UI-only lifecycle decisions.
    ctx.ui.notify(`${moment.title}: ${moment.summary}`, "info");
    return;
  }

  ctx.ui.notify(`PALS guided workflow: ${moment.summary}`, "info");
  if (moment.ui === "confirm" && moment.confirmResponse) {
    const ok = await ctx.ui.confirm(
      moment.title,
      `${moment.summary}\n\nSend canonical reply "${moment.confirmResponse}" through normal user-message flow?`,
    );
    if (ok) {
      ctx.ui.notify(`PALS guided workflow → sending "${moment.confirmResponse}"`, "success");
      sendCanonicalWorkflowResponse(pi, ctx, moment.confirmResponse);
    }
    return;
  }
  if (moment.ui === "select" && moment.options && moment.options.length > 0) {
    const optionLabels = moment.options.map((option) => `[${option.id}] ${option.label}`);
    const choice = await ctx.ui.select(moment.title, optionLabels);
    const selected = moment.options.find((option) => choice === `[${option.id}] ${option.label}`);
    // Arbitrary UI text is ignored; only displayed options mapped to known GuidedWorkflowOption ids can send.
    if (selected) {
      ctx.ui.notify(`PALS guided workflow → sending "${selected.canonicalResponse}"`, "success");
      sendCanonicalWorkflowResponse(pi, ctx, selected.canonicalResponse);
    }
    return;
  }
  ctx.ui.notify(`${moment.title}: respond in the canonical workflow prompt when ready.`, "info");
}

// -- CARL helpers and core functions --

function loadCarlConfig(cwd: string): CarlConfig {
  const palsJsonPath1 = join(cwd, ".paul", "pals.json");
  const palsJsonPath2 = join(cwd, "pals.json");
  const raw = readFileOr(palsJsonPath1, "") || readFileOr(palsJsonPath2, "");
  let carl: any = {};
  try {
    const parsed = raw ? JSON.parse(raw) : {};
    carl = parsed?.modules?.carl ?? {};
  } catch {
    // Invalid JSON — use defaults
  }

  const continueThresholdTokens =
    typeof carl.continue_threshold_tokens === "number" && Number.isFinite(carl.continue_threshold_tokens)
      ? carl.continue_threshold_tokens
      : undefined;
  const safetyCeilingTokens =
    typeof carl.safety_ceiling_tokens === "number" && Number.isFinite(carl.safety_ceiling_tokens)
      ? carl.safety_ceiling_tokens
      : undefined;

  return {
    session_strategy: ["phase-boundary", "always-fresh", "manual"].includes(carl.session_strategy)
      ? carl.session_strategy
      : CARL_DEFAULT_STRATEGY,
    continue_threshold: typeof carl.continue_threshold === "number" ? carl.continue_threshold : CARL_DEFAULT_CONTINUE_THRESHOLD,
    continue_threshold_tokens: continueThresholdTokens,
    safety_ceiling: typeof carl.safety_ceiling === "number" ? carl.safety_ceiling : CARL_DEFAULT_SAFETY_CEILING,
    safety_ceiling_tokens: safetyCeilingTokens,
  };
}

function loadGuidedWorkflowConfig(cwd: string): GuidedWorkflowConfig {
  const palsJsonPath1 = join(cwd, ".paul", "pals.json");
  const palsJsonPath2 = join(cwd, "pals.json");
  const raw = readFileOr(palsJsonPath1, "") || readFileOr(palsJsonPath2, "");
  let gw: any = {};
  try {
    const parsed = raw ? JSON.parse(raw) : {};
    gw = parsed?.guided_workflow?.auto_present ?? {};
  } catch {
    // Invalid JSON — use defaults
  }

  const autoPresent: GuidedWorkflowAutoPresent = { ...GUIDED_WORKFLOW_DEFAULTS };
  // guided_workflow.auto_present changes only whether Pi displays a guided UI affordance;
  // it must not skip prompts, mark approvals, persist checkpoint results, or infer merge intent.
  for (const key of Object.keys(GUIDED_WORKFLOW_DEFAULTS) as (keyof GuidedWorkflowAutoPresent)[]) {
    if (typeof gw[key] === "boolean") {
      autoPresent[key] = gw[key];
    }
  }

  return { auto_present: autoPresent };
}

function shouldAutoPresent(config: GuidedWorkflowConfig, momentKind: GuidedWorkflowMoment["kind"]): boolean {
  // Map hyphenated moment kind to underscored display-config key; this is not lifecycle state.
  const configKey = momentKind.replace(/-/g, "_") as keyof GuidedWorkflowAutoPresent;
  return config.auto_present[configKey] ?? true;
}

function formatCarlContextPressure(tokens: number, ratio: number): string {
  return `${tokens.toLocaleString()} tokens (${Math.round(ratio * 100)}%)`;
}

export function extractLoopSignature(state: PalsStateSnapshot): string | undefined {
  if (!state.loop) return undefined;
  const marks = [...state.loop.matchAll(/[✓○]/g)].map((m) => m[0]);
  return marks.length >= 3 ? marks.join("") : undefined;
}

function buildCarlBootstrapPrompt(state: PalsStateSnapshot, reason: string): string {
  return [
    "## PALS Session Bootstrap",
    "",
    "**Resuming from CARL autonomous session boundary.**",
    "",
    "### Current State",
    state.milestone ? `Milestone: ${state.milestone}` : null,
    state.phase ? `Phase: ${state.phase}` : null,
    state.loop ? `Loop: ${state.loop}` : null,
    state.nextAction ? `Next action: ${state.nextAction}` : null,
    "",
    `### Session Break Reason`,
    `CARL triggered a fresh session: ${reason}`,
    "",
    "### Resume",
    "Run /skill:paul-resume to continue.",
  ]
    .filter((line) => line !== null)
    .join("\n");
}
// -- Extension entry point --
export default function palsHooks(pi: any): void {
  let lastGuidedWorkflowSignature: string | undefined;

  // -- CARL Session Boundary Manager state --
  const carlState: CarlState = {
    stashedCmdCtx: undefined,
    dispatching: false,
    previousLoopSignature: undefined,
    pauseAtNextBoundary: false,
  };

  const carlCreateFreshSession = async (ctx: any, reason: string): Promise<boolean> => {
    if (!carlState.stashedCmdCtx) {
      ctx?.ui?.notify("CARL: No stashed command context — run a /paul-* command first to enable session management.", "warning");
      return false;
    }
    if (carlState.dispatching) return false;
    carlState.dispatching = true;
    try {
      const cwd = ctx?.cwd ?? process.cwd();
      const state = parsePalsState(cwd);
      const bootstrapContent = buildCarlBootstrapPrompt(state, reason);
      const sessionPromise = carlState.stashedCmdCtx.newSession({
        setup: async (sm: any) => {
          sm.appendMessage({
            role: "user",
            content: [{ type: "text", text: bootstrapContent }],
            timestamp: Date.now(),
          });
        },
      });
      const timeoutPromise = new Promise<{ cancelled: true }>((resolve) =>
        setTimeout(() => resolve({ cancelled: true }), CARL_NEW_SESSION_TIMEOUT_MS),
      );
      const result = await Promise.race([sessionPromise, timeoutPromise]);
      if (result?.cancelled) {
        ctx?.ui?.notify("CARL: Session creation timed out or was cancelled.", "warning");
        return false;
      }
      pi.sendUserMessage("/skill:paul-resume");
      return true;
    } catch (err) {
      ctx?.ui?.notify(`CARL: Session creation failed — ${err}`, "warning");
      return false;
    } finally {
      carlState.dispatching = false;
    }
  };

  const carlEvaluatePhaseCompletion = async (ctx: any): Promise<void> => {
    const cwd = ctx?.cwd ?? process.cwd();
    const state = parsePalsState(cwd);
    if (!state.detected) return;

    const signature = extractLoopSignature(state);
    if (!signature) return;
    if (signature === carlState.previousLoopSignature) return;
    carlState.previousLoopSignature = signature;

    if (signature !== "✓✓✓") return;

    const config = loadCarlConfig(cwd);
    if (config.session_strategy === "manual") return;

    const usage = ctx?.getContextUsage?.();
    const contextWindow = ctx?.model?.contextWindow ?? 200_000;
    const tokens = usage?.tokens ?? 0;
    const ratio = tokens / contextWindow;
    const pressure = formatCarlContextPressure(tokens, ratio);
    const reachedContinueThreshold =
      typeof config.continue_threshold_tokens === "number"
        ? tokens >= config.continue_threshold_tokens
        : ratio >= config.continue_threshold;

    if (config.session_strategy === "always-fresh" || reachedContinueThreshold) {
      ctx?.ui?.notify(`CARL: Phase complete, context at ${pressure}. Creating fresh session.`, "info");
      await carlCreateFreshSession(ctx, `phase-complete (${pressure})`);
    } else {
      ctx?.ui?.notify(`CARL: Phase complete, context at ${pressure} — continuing in same session.`, "info");
    }
  };

  const carlMonitorSafetyCeiling = (ctx: any): void => {
    const cwd = ctx?.cwd ?? process.cwd();
    const state = parsePalsState(cwd);
    if (!state.detected) return;

    const config = loadCarlConfig(cwd);
    if (config.session_strategy === "manual") return;
    if (carlState.pauseAtNextBoundary) return;

    const usage = ctx?.getContextUsage?.();
    const contextWindow = ctx?.model?.contextWindow ?? 200_000;
    const tokens = usage?.tokens ?? 0;
    const ratio = tokens / contextWindow;
    const reachedSafetyCeiling =
      typeof config.safety_ceiling_tokens === "number"
        ? tokens >= config.safety_ceiling_tokens
        : ratio >= config.safety_ceiling;

    if (reachedSafetyCeiling) {
      carlState.pauseAtNextBoundary = true;
      ctx?.ui?.notify(`CARL: Context pressure at ${formatCarlContextPressure(tokens, ratio)}. Will pause at next task boundary.`, "warning");
    }
  };

  const routeCommand = makeRouteCommand({ pi, markActivation });
  const routeWrapperCommand = makeRouteWrapperCommand({ routeCommand });
  const registerQuickActionShortcut = makeRegisterQuickActionShortcut({ pi });

  const maybePresentGuidedWorkflow = async (event: any, ctx: any): Promise<void> => {
    const cwd = ctx?.cwd ?? process.cwd();
    const state = parsePalsState(cwd);
    const recentAssistantTexts = collectRecentAssistantTexts(ctx, event);
    const guidedMoment = detectGuidedWorkflowMoment(state, recentAssistantTexts);
    if (!guidedMoment) {
      lastGuidedWorkflowSignature = undefined;
      return;
    }
    if (guidedMoment.signature === lastGuidedWorkflowSignature) return;
    lastGuidedWorkflowSignature = guidedMoment.signature;
    const gwConfig = loadGuidedWorkflowConfig(cwd);
    await presentGuidedWorkflowMoment(guidedMoment, ctx, pi, gwConfig);
  };

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

  // Session start: orientation + lifecycle surface refresh (no workflow injection).
  pi.on("session_start", async (_event: any, ctx: any) => {
    const cwd = ctx?.cwd ?? process.cwd();
    const state = parsePalsState(cwd);
    carlState.previousLoopSignature = extractLoopSignature(state);
    syncLifecycleUi(ctx);
    if (!state.detected) return;
    ctx?.ui?.notify(buildSessionOrientationSummary(state), "info");
  });

  // Primary workflow-context injection point.
  pi.on("before_agent_start", async (event: any, ctx: any) => {
    syncLifecycleUi(ctx);

    const promptSignal = detectCommandSignal(event?.prompt);
    if (promptSignal) {
      markActivation("prompt", promptSignal, PROMPT_ACTIVATION_TURN_BUDGET);
    }

    const cwd = ctx?.cwd ?? process.cwd();
    const state = parsePalsState(cwd);
    const activeActivation = getActiveActivation();

    if (!shouldInjectPalsContext(state, activeActivation)) return;

    const contextPayload = buildPalsContextPayload(state, activeActivation as ActivationState, cwd);
    consumeActivationTurn();

    return {
      message: {
        customType: PALS_CONTEXT_CUSTOM_TYPE,
        content: contextPayload,
        display: false,
      },
    };
  });

  pi.on("turn_end", async (_event: any, ctx: any) => {
    syncLifecycleUi(ctx);
    carlMonitorSafetyCeiling(ctx);
  });

  pi.on("agent_end", async (event: any, ctx: any) => {
    syncLifecycleUi(ctx);
    await maybePresentGuidedWorkflow(event, ctx);
    await carlEvaluatePhaseCompletion(ctx);
    if (carlState.pauseAtNextBoundary && carlState.stashedCmdCtx) {
      carlState.pauseAtNextBoundary = false;
      ctx?.ui?.notify("CARL: Safety boundary reached. Creating fresh session.", "warning");
      await carlCreateFreshSession(ctx, "safety-ceiling");
    }
  });

  // Supporting context hook: keep prior context bounded and trim legacy payloads.
  pi.on("context", async (event: any, ctx: any) => {
    syncLifecycleUi(ctx);

    const messages: any[] = event?.messages;
    if (!Array.isArray(messages) || messages.length === 0) return;

    const withoutLegacy = messages.filter((message) => !isLegacyPalsContextMessage(message));
    const normalized = keepOnlyLatestPalsContextMessage(withoutLegacy);

    if (messagesChanged(messages, normalized)) {
      return { messages: normalized };
    }
  });
}
