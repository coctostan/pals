/**
 * Guided Workflow Delivery — Pi Extension subsystem (S4)
 *
 * Canonical guided-workflow reply delivery and display configuration for
 * PALS runtime moments detected by `guided-workflow-detection.ts`.
 *
 * Authority: Derived aid only. This module presents optional Pi UI affordances
 * and sends transcript-visible canonical replies only after explicit mapped user
 * choice. It never approves work, continues workflows, completes checkpoints,
 * infers merge intent, persists lifecycle state, or writes `.paul/*` artifacts.
 */

import { join } from "path";
import { compactWhitespace, readFileOr } from "./pals-hooks";
import type { GuidedWorkflowMoment } from "./guided-workflow-detection";

export type GuidedWorkflowAutoPresent = {
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

export type GuidedWorkflowConfig = {
  auto_present: GuidedWorkflowAutoPresent;
};

export const GUIDED_WORKFLOW_DEFAULTS: GuidedWorkflowAutoPresent = {
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

export function sendCanonicalWorkflowResponse(pi: any, ctx: any, canonicalResponse?: string): void {
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

export async function presentGuidedWorkflowMoment(
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

export function loadGuidedWorkflowConfig(cwd: string): GuidedWorkflowConfig {
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

export function shouldAutoPresent(config: GuidedWorkflowConfig, momentKind: GuidedWorkflowMoment["kind"]): boolean {
  // Map hyphenated moment kind to underscored display-config key; this is not lifecycle state.
  const configKey = momentKind.replace(/-/g, "_") as keyof GuidedWorkflowAutoPresent;
  return config.auto_present[configKey] ?? true;
}

/** No-op Pi extension factory */
export default function (_pi: unknown): void {}
