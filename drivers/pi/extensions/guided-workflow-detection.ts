/**
 * Guided Workflow Detection — Pi Extension subsystem (S3)
 *
 * Pure detection for PALS guided workflow moments: planning review, APPLY
 * approval, checkpoints, resume-next routing, phase/milestone transitions,
 * Continue to UNIFY, and merge-gate-routing prompts. Extracted from
 * `drivers/pi/extensions/pals-hooks.ts` in Phase 250
 * (`.paul/phases/250-bounded-s3-submodule-extraction/250-01-PLAN.md`) per
 * `docs/PI-NATIVE-GUIDED-WORKFLOW-DETECTION-EXTRACTION-CONTRACT.md` and
 * `docs/PI-NATIVE-GUIDED-WORKFLOW-EVIDENCE-CONTRACT.md`.
 *
 * Authority: Derived aid only. This module detects transcript-visible workflow
 * affordances but never sends canonical replies, approves work, persists
 * lifecycle state, no inferred merge intent, or writes `.paul/*` artifacts.
 */

import { compactWhitespace, extractLoopSignature } from "./pals-hooks";
import type { PalsStateSnapshot } from "./pals-hooks";

export const GUIDED_WORKFLOW_LOOKBACK = 5;
export const GUIDED_WORKFLOW_SIGNATURE_BYTES = 240;

export type GuidedWorkflowOption = {
  id: string;
  label: string;
  canonicalResponse: string;
};

export type GuidedWorkflowMoment = {
  kind:
    | "plan-review"
    | "apply-approval"
    | "checkpoint-decision"
    | "checkpoint-human-verify"
    | "checkpoint-human-action"
    | "resume-next"
    | "phase-transition"
    | "milestone-transition"
    | "merge-gate-routing"
    | "continue-to-unify";
  title: string;
  summary: string;
  signature: string;
  ui: "confirm" | "select" | "notify";
  confirmResponse?: string;
  options?: GuidedWorkflowOption[];
};

export function summarizeWorkflowPrompt(text: string, fallback: string): string {
  const lines = text
    .split(/\r?\n/)
    .map((line) => compactWhitespace(line))
    .filter(Boolean) as string[];

  const filtered = lines.filter((line) => {
    if (/^[═─]+$/.test(line)) return false;
    if (line === "```" || line === "---" || line === "Options:" || line === "What's next?") return false;
    if (line.startsWith("[")) return false;
    if (line.startsWith("CHECKPOINT:")) return false;
    if (line.startsWith("Continue to APPLY?")) return false;
    if (line.startsWith("Continue to UNIFY?")) return false;
    if (line.startsWith("▶ NEXT:")) return false;
    return true;
  });

  return filtered.slice(0, 3).join(" | ") || fallback;
}

export function extractNextActionSummary(text: string): string {
  const lines = text
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);
  const nextIndex = lines.findIndex((line) => line.includes("▶ NEXT:"));
  const command = nextIndex >= 0 ? compactWhitespace(lines[nextIndex].replace(/^.*▶ NEXT:\s*/, "")) : undefined;
  const detail = nextIndex >= 0 ? compactWhitespace(lines[nextIndex + 1]) : undefined;

  return compactWhitespace([
    command ? `Next: ${command}` : undefined,
    detail,
  ].filter(Boolean).join(" — ")) ?? "A shared PALS workflow exposed a single next action.";
}

export function isValidOptionId(id: string): boolean {
  const trimmed = id.trim();
  // Accept: purely numeric ("1", "2", "42")
  if (/^\d+$/.test(trimmed)) return true;
  // Accept: known PALS canonical responses
  const knownResponses = new Set([
    "yes", "no", "approved", "pause", "stop", "continue",
    "go", "skip", "override", "ready", "done",
  ]);
  if (knownResponses.has(trimmed.toLowerCase())) return true;
  // Accept: option-{id} patterns from checkpoint decisions
  if (/^option-[a-z0-9]+$/i.test(trimmed)) return true;
  // Reject everything else (code patterns like "id", "slug", "name", "...params")
  return false;
}

export function parseGuidedWorkflowOptions(text: string): GuidedWorkflowOption[] {
  const options: GuidedWorkflowOption[] = [];
  const seen = new Set<string>();

  const addOption = (id?: string, label?: string): void => {
    const cleanId = compactWhitespace(id)?.replace(/:$/, "");
    const cleanLabel = compactWhitespace(label?.replace(/\s*\|\s*$/, ""));
    if (!cleanId || !cleanLabel || !isValidOptionId(cleanId) || seen.has(cleanId)) return;
    seen.add(cleanId);
    options.push({ id: cleanId, label: cleanLabel, canonicalResponse: cleanId });
  };

  for (const line of text.split(/\r?\n/)) {
    const inlineMatches = Array.from(line.matchAll(/\[([^\]]+)\]\s*([^|\n]+)/g));
    if (inlineMatches.length > 0) {
      for (const match of inlineMatches) {
        addOption(match[1], match[2]);
      }
      continue;
    }

    const blockMatch = line.match(/^\s*\[([^\]]+)\]:\s*(.+)$/);
    if (blockMatch) addOption(blockMatch[1], blockMatch[2]);
  }

  return options;
}

export function detectExplicitCanonicalResponse(text: string): string | undefined {
  const patterns = [
    /On\s+"([^"]+)"\s+continue/i,
    /Type\s+"([^"]+)"\s+to\s+proceed/i,
    /Type\s+"([^"]+)"\s+to\s+continue/i,
    /Reply\s+"([^"]+)"/i,
    /Respond\s+with\s+"([^"]+)"/i,
    /resume-signal[^\n"]*"([^"]+)"/i,
  ];

  for (const pattern of patterns) {
    const match = text.match(pattern);
    const response = compactWhitespace(match?.[1]);
    if (response) return response;
  }

  return undefined;
}

export function isMergeGateRoutingPrompt(text: string): boolean {
  const hasGitStateMarker = /(Git State|GitHub Flow|Merge gate|Branch:|Base:|PR:|CI:|Sync:)/i.test(text);
  const hasMergeRouteMarker =
    /merge-gate-routing|merge[- ]gate|Fix CI|CI:\s*(failing|passing|pending)|CI failing|CI passing|reviews? pending|ready to merge|Merge PR|gh pr|Update branch|behind base|rebase origin|delete branch|cleanup/i.test(
      text,
    );
  return hasGitStateMarker && hasMergeRouteMarker;
}

export function extractMergeGateRoutingSummary(text: string): string {
  const nextAction = extractNextActionSummary(text);
  if (nextAction !== "A PALS next action is available.") {
    return nextAction;
  }
  return summarizeWorkflowPrompt(
    text,
    "GitHub Flow routing is visible; use only explicit workflow options or the canonical transcript prompt.",
  );
}

export function makeGuidedWorkflowSignature(kind: GuidedWorkflowMoment["kind"], state: PalsStateSnapshot, text: string): string {
  return compactWhitespace(
    `${kind} | ${state.phase ?? "unknown-phase"} | ${state.loop ?? "unknown-loop"} | ${text.slice(0, GUIDED_WORKFLOW_SIGNATURE_BYTES)}`,
  ) ?? kind;
}

// Guided workflow layer: detect canonical prompts like Continue to APPLY, Continue to UNIFY,
// CHECKPOINT, ▶ NEXT, and merge-gate-routing handoffs from recent assistant messages plus authoritative STATE.md context.
export function detectGuidedWorkflowMoment(
  state: PalsStateSnapshot,
  recentAssistantTexts: string[],
): GuidedWorkflowMoment | undefined {
  if (!state.detected) return undefined;

  for (const text of recentAssistantTexts) {
    const hasPlanningReviewMenu =
      text.includes("Quick recap")
      && text.includes("Detailed recap")
      && text.includes("Full plan")
      && text.includes("No review needed");

    if (hasPlanningReviewMenu && (/Would you like to see the plan\?/i.test(text) || /Would you like to review/i.test(text))) {
      const parsedOptions = parseGuidedWorkflowOptions(text);
      const options = parsedOptions.length > 0
        ? parsedOptions
        : [
            { id: "1", label: "Quick recap", canonicalResponse: "1" },
            { id: "2", label: "Detailed recap", canonicalResponse: "2" },
            { id: "3", label: "Full plan", canonicalResponse: "3" },
            { id: "4", label: "No review needed", canonicalResponse: "4" },
          ];
      return {
        kind: "plan-review",
        title: "Planning review",
        summary:
          compactWhitespace(
            [
              state.phase ? `Phase: ${state.phase}` : undefined,
              "Choose how much planning detail to review before continuing.",
            ]
              .filter(Boolean)
              .join(" | "),
          ) ?? "Choose how much planning detail to review before continuing.",
        signature: makeGuidedWorkflowSignature("plan-review", state, text),
        ui: "select",
        options,
      };
    }

    if (text.includes("Continue to APPLY?")) {
      return {
        kind: "apply-approval",
        title: "Continue to APPLY?",
        summary:
          compactWhitespace(
            [
              state.phase ? `Phase: ${state.phase}` : undefined,
              "Pi can route your explicit approval back through the canonical workflow.",
            ]
              .filter(Boolean)
              .join(" | "),
          ) ?? "The approved plan is ready for APPLY.",
        signature: makeGuidedWorkflowSignature("apply-approval", state, text),
        ui: "select",
        options: [
          { id: "1", label: "Approved, run APPLY", canonicalResponse: "approved" },
          { id: "2", label: "Questions first", canonicalResponse: "2" },
          { id: "3", label: "Pause here", canonicalResponse: "3" },
        ],
      };
    }

    if (text.includes("Continue to UNIFY?")) {
      // Don't match if loop is already complete — text is stale from a previous output
      const loopSig = extractLoopSignature(state);
      if (loopSig === "✓✓✓") continue;
      return {
        kind: "continue-to-unify",
        title: "Continue to UNIFY?",
        summary:
          compactWhitespace(
            [
              state.phase ? `Phase: ${state.phase}` : undefined,
              "APPLY finished; Pi can send the canonical continuation reply for UNIFY.",
            ]
              .filter(Boolean)
              .join(" | "),
          ) ?? "APPLY completed and UNIFY is ready.",
        signature: makeGuidedWorkflowSignature("continue-to-unify", state, text),
        ui: "select",
        options: [
          { id: "1", label: "Yes, run UNIFY", canonicalResponse: "1" },
          { id: "2", label: "Pause here", canonicalResponse: "2" },
        ],
      };
    }

    if (text.includes("CHECKPOINT: Decision Required")) {
      const options = parseGuidedWorkflowOptions(text);
      return {
        kind: "checkpoint-decision",
        title: "CHECKPOINT: Decision Required",
        summary: summarizeWorkflowPrompt(text, "A shared PALS workflow is waiting for a decision."),
        signature: makeGuidedWorkflowSignature("checkpoint-decision", state, text),
        ui: options.length > 0 ? "select" : "notify",
        options,
      };
    }

    if (text.includes("CHECKPOINT: Human Verification")) {
      return {
        kind: "checkpoint-human-verify",
        title: "CHECKPOINT: Human Verification",
        summary: summarizeWorkflowPrompt(text, "A shared PALS workflow is waiting for your human verification."),
        signature: makeGuidedWorkflowSignature("checkpoint-human-verify", state, text),
        ui: "confirm",
        confirmResponse: "approved",
      };
    }

    if (text.includes("CHECKPOINT: Human Action Required")) {
      const confirmResponse = detectExplicitCanonicalResponse(text);
      return {
        kind: "checkpoint-human-action",
        title: "CHECKPOINT: Human Action Required",
        summary: summarizeWorkflowPrompt(
          text,
          "Complete the required human action first, then resume through the shared workflow prompt.",
        ),
        signature: makeGuidedWorkflowSignature("checkpoint-human-action", state, text),
        ui: confirmResponse ? "confirm" : "notify",
        confirmResponse,
      };
    }

    if (isMergeGateRoutingPrompt(text)) {
      const options = parseGuidedWorkflowOptions(text);
      return {
        kind: "merge-gate-routing",
        title: "GitHub Flow route",
        summary: extractMergeGateRoutingSummary(text),
        signature: makeGuidedWorkflowSignature("merge-gate-routing", state, text),
        ui: options.length > 0 ? "select" : "notify",
        options,
      };
    }

    if (text.includes("▶ NEXT:") && /Type\s+"yes"\s+to\s+proceed/i.test(text)) {
      return {
        kind: "resume-next",
        title: "PALS next step ready",
        summary: extractNextActionSummary(text),
        signature: makeGuidedWorkflowSignature("resume-next", state, text),
        ui: "confirm",
        confirmResponse: "yes",
      };
    }

    if (/PHASE\s+\d+\s+COMPLETE/i.test(text)) {
      const options = parseGuidedWorkflowOptions(text);
      if (options.length > 0) {
        return {
          kind: "phase-transition",
          title: "Phase complete",
          summary: summarizeWorkflowPrompt(text, "The next phase is ready for planning."),
          signature: makeGuidedWorkflowSignature("phase-transition", state, text),
          ui: "select",
          options,
        };
      }
    }

    if (text.includes("MILESTONE COMPLETE") && text.includes("What's next?")) {
      const options = parseGuidedWorkflowOptions(text);
      return {
        kind: "milestone-transition",
        title: "Milestone complete",
        summary: summarizeWorkflowPrompt(text, "The milestone is complete and waiting for an explicit next step."),
        signature: makeGuidedWorkflowSignature("milestone-transition", state, text),
        ui: options.length > 0 ? "select" : "notify",
        options,
      };
    }
  }

  return undefined;
}

// No-op Pi extension factory
export default function (_pi: unknown): void {}
