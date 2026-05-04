/**
 * PALS Context Injection — Pi Extension subsystem (S7)
 *
 * Owns the PALS context payload assembly, the injection-gating predicate,
 * and the message-stream housekeeping (legacy filter → latest-only
 * normalize → change gate) for the `before_agent_start` and `context` Pi
 * events. Extracted from `drivers/pi/extensions/pals-hooks.ts` in Phase 254
 * (`.paul/phases/254-bounded-s7-submodule-extraction/254-01-PLAN.md`) per
 * `docs/PI-NATIVE-PALS-CONTEXT-INJECTION-EXTRACTION-CONTRACT.md` and
 * `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`.
 *
 * Authority: Derived aid only. This module assembles and normalizes the
 * bounded PALS context payload but never sends canonical replies, approves
 * work, persists lifecycle state, infers merge intent, auto-continues,
 * skips checkpoints, or writes `.paul/*` artifacts. The exact byte
 * sequences `[PALS_STATE_AUTHORITY=.paul/STATE.md]` and
 * `[PALS_ACTIVATION_SIGNAL]`, the legacy header
 * `## PALS Context (auto-injected)`, the custom-message-type identity
 * `pals-context`, and the `before_agent_start`/`context` event names are
 * preserved exactly so /paul-resume consumers continue to recognize the
 * authority and activation signals unchanged.
 */

import { renderArtifactSlices } from "./artifact-slice-rendering";
import { renderWorkflowResourceCapsules } from "./workflow-resource-capsule-rendering";
import type { PalsStateSnapshot, ActivationState } from "./pals-hooks";

export const PRIMARY_INJECTION_EVENT = "before_agent_start";
export const SUPPORTING_CONTEXT_EVENT = "context";
export const PALS_CONTEXT_CUSTOM_TYPE = "pals-context";
export const LEGACY_PALS_CONTEXT_HEADER = "## PALS Context (auto-injected)";
export const STATE_AUTHORITY_TAG = "[PALS_STATE_AUTHORITY=.paul/STATE.md]";
export const ACTIVATION_SIGNAL_TAG = "[PALS_ACTIVATION_SIGNAL]";

export function shouldInjectPalsContext(state: PalsStateSnapshot, activation: ActivationState | undefined): boolean {
  return Boolean(state.detected && activation && activation.turnsRemaining > 0);
}

export function buildPalsContextPayload(state: PalsStateSnapshot, activation: ActivationState, cwd: string): string {
  return [
    "## PALS Context (bounded injection)",
    "",
    STATE_AUTHORITY_TAG,
    `${ACTIVATION_SIGNAL_TAG} ${activation.signal} (${activation.source})`,
    state.phase ? `Phase: ${state.phase}` : "Phase: unknown",
    state.loop ? `Loop: ${state.loop}` : "Loop: unknown",
    state.nextAction ? `Next action: ${state.nextAction}` : null,
    "Delegated APPLY may use repo-local `pals-implementer` only for eligible bounded tasks; parent APPLY remains authoritative for verification, module enforcement, fallback, and `.paul/*` lifecycle writes.",
    "",
    "Use shared .paul/* artifacts and loaded SKILL.md/workflow instructions as the authoritative lifecycle source.",
    "",
    ...renderArtifactSlices(cwd, state),
    "",
    ...renderWorkflowResourceCapsules(cwd),
  ]
    .filter(Boolean)
    .join("\n");
}

export function isLegacyPalsContextMessage(message: any): boolean {
  return message?.role === "user" && typeof message?.content === "string" && message.content.includes(LEGACY_PALS_CONTEXT_HEADER);
}

export function isPalsContextMessage(message: any): boolean {
  if (message?.customType === PALS_CONTEXT_CUSTOM_TYPE) return true;
  return isLegacyPalsContextMessage(message);
}

export function keepOnlyLatestPalsContextMessage(messages: any[]): any[] {
  let latestIndex = -1;
  for (let i = 0; i < messages.length; i++) {
    if (isPalsContextMessage(messages[i])) latestIndex = i;
  }

  if (latestIndex < 0) return messages;
  return messages.filter((message, index) => !isPalsContextMessage(message) || index === latestIndex);
}

export function messagesChanged(previous: any[], next: any[]): boolean {
  if (previous.length !== next.length) return true;
  for (let i = 0; i < previous.length; i++) {
    if (previous[i] !== next[i]) return true;
  }
  return false;
}

// No-op Pi extension factory
export default function (_pi: unknown): void {}
