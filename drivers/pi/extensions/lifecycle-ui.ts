/**
 * Lifecycle UI — Pi Extension subsystem (S6)
 *
 * Owns the visible Pi lifecycle status, lifecycle widget, loop-badge text,
 * action-label heuristics, module-activity rendering, and the
 * `syncLifecycleUi` UI-mutation entry point. Extracted from
 * `drivers/pi/extensions/pals-hooks.ts` in Phase 258
 * (`.paul/phases/258-bounded-s6-submodule-extraction/258-01-PLAN.md`) per
 * `docs/PI-NATIVE-LIFECYCLE-UI-EXTRACTION-CONTRACT.md` and
 * `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`.
 *
 * Authority: Derived aid only. This module renders authoritative `.paul/*`
 * and module-activity inputs into Pi UI surfaces; it never sends canonical
 * replies, approves work, persists lifecycle state, infers merge intent,
 * auto-continues, skips checkpoints, drives lifecycle decisions from UI,
 * or writes `.paul/*` artifacts (the no-UI-only-lifecycle-decisions
 * invariant). The exact byte sequence `pals-lifecycle` is single-defined
 * here as the runtime UI-element identifier for both the status surface
 * and the widget surface so consumers continue to recognize the lifecycle
 * UI unchanged.
 */

import type { PalsStateSnapshot } from "./shared-runtime-helpers";
import { compactWhitespace, parsePalsState } from "./shared-runtime-helpers";
import {
  MAX_WIDGET_MODULE_DETAILS,
  MAX_VISIBLE_MODULES,
  RECENT_MODULE_ACTIVITY_LOOKBACK,
  collectRecentAssistantTexts,
} from "./pals-hooks";
import type { RecentModuleActivity } from "./module-activity-parsing";
import {
  extractRecentModuleActivity,
  formatModuleEntryList,
} from "./module-activity-parsing";

export const PALS_STATUS_ID = "pals-lifecycle";
export const PALS_WIDGET_ID = "pals-lifecycle";

export function renderLoopBadge(loopString?: string): string | undefined {
  if (!loopString) return undefined;
  const marks = [...loopString.matchAll(/[✓○]/g)].map((m) => m[0]);
  if (marks.length < 3) return undefined;
  return `PLAN${marks[0]} APPLY${marks[1]} UNIFY${marks[2]}`;
}

export function renderCompactLoopSummary(loopString?: string): string | undefined {
  if (!loopString) return undefined;
  return `Loop: ${renderLoopBadge(loopString) ?? compactWhitespace(loopString)}`;
}

export function renderLifecycleActionLabel(state: PalsStateSnapshot): string {
  const nextAction = compactWhitespace(state.nextAction)?.toLowerCase() ?? "";
  const loopSignature = state.loop ? [...state.loop.matchAll(/[✓○]/g)].map((match) => match[0]).join("") : "";

  if (loopSignature === "✓✓✓") return "Complete";
  if (/address blocker|blocked|fix ci|failing|failure/.test(nextAction)) return "Blocked";
  if (/review|approve|checkpoint|human verification|human action|decision required|waiting/.test(nextAction)) return "Waiting";
  if (nextAction) return "Ready";
  return "Next";
}

export function renderModuleActivity(activity?: RecentModuleActivity): string | undefined {
  if (!activity) return undefined;
  const modules = formatModuleEntryList(activity.entries, MAX_VISIBLE_MODULES, ", ");
  if (!modules) return undefined;
  return `Modules: ${activity.stageLabel} • ${modules}`;
}

export function renderModuleActivityDetails(activity?: RecentModuleActivity): string[] {
  if (!activity) return [];

  const details = formatModuleEntryList(activity.entries, MAX_WIDGET_MODULE_DETAILS, " | ", true);
  if (!details) return [];
  return [
    `Recent module activity: ${activity.stageLabel}`,
    `Modules: ${details}`,
  ];
}

export function renderLifecycleStatus(state: PalsStateSnapshot, activity?: RecentModuleActivity): string | undefined {
  if (!state.detected) return undefined;
  const actionLabel = renderLifecycleActionLabel(state);
  const loopBadge = renderLoopBadge(state.loop);
  return [
    "PALS",
    state.milestone ? `Milestone: ${state.milestone}` : null,
    state.phase ? `Phase: ${state.phase}` : null,
    loopBadge ? `Loop: ${loopBadge}` : renderCompactLoopSummary(state.loop),
    state.nextAction ? `${actionLabel}: ${state.nextAction}` : null,
  ]
    .filter(Boolean)
    .join(" • ");
}

export function renderLifecycleWidget(state: PalsStateSnapshot, activity?: RecentModuleActivity): string[] | undefined {
  if (!state.detected) return undefined;
  return [
    state.milestone ? `PALS Milestone: ${state.milestone}` : "PALS Milestone: unknown",
    state.phase ? `Phase: ${state.phase}` : "Phase: unknown",
    state.loop ? `Loop: ${state.loop}` : "Loop: unknown",
    state.nextAction ? `Next action: ${state.nextAction}` : "Next action: unknown",
  ];
}

export function syncLifecycleUi(ctx: any): void {
  const cwd = ctx?.cwd ?? process.cwd();
  const state = parsePalsState(cwd);
  if (!state.detected) {
    ctx?.ui?.setStatus(PALS_STATUS_ID, undefined);
    ctx?.ui?.setWidget(PALS_WIDGET_ID, undefined);
    return;
  }

  const recentAssistantTexts = collectRecentAssistantTexts(ctx, undefined, RECENT_MODULE_ACTIVITY_LOOKBACK);
  const recentModuleActivity = extractRecentModuleActivity(recentAssistantTexts);
  ctx?.ui?.setStatus(PALS_STATUS_ID, renderLifecycleStatus(state, recentModuleActivity));
  ctx?.ui?.setWidget(PALS_WIDGET_ID, renderLifecycleWidget(state, recentModuleActivity));
}

// No-op Pi extension factory
export default function (_pi: unknown): void {}
