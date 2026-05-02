/**
 * Workflow / Resource Capsule Rendering — Pi Extension subsystem (S2)
 *
 * Bounded, read-only orientation capsules over PALS workflow + reference
 * resources (`kernel/references/plan-format.md`,
 * `kernel/references/checkpoints.md`, `kernel/references/module-dispatch.md`,
 * `kernel/references/git-strategy.md`) so the LLM can ground itself before
 * lifecycle work without ever treating the capsule as authority. Repo source
 * is preferred; installed-logical-resource fallback under
 * `$HOME/.pi/agent/skills/pals/<logicalSource>` is used when the repo source
 * is unavailable.
 *
 * Extracted from `drivers/pi/extensions/pals-hooks.ts` in Phase 246
 * (`.paul/phases/246-s2-workflow-resource-capsule-rendering-extraction/246-01-PLAN.md`)
 * per `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md` and the
 * original `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` S2 inventory.
 * Mirrors the Phase 239 S5 + Phase 243 S1 sibling-module pattern proven in
 * `drivers/pi/extensions/module-activity-parsing.ts` and
 * `drivers/pi/extensions/artifact-slice-rendering.ts`.
 *
 * Authority: Derived aid only. No Pi mutation, no .paul/* lifecycle writes.
 * The visible markers (`Workflow/resource capsules (read-only, bounded, activation-gated)`,
 * `Capsule: plan-task-anatomy`, `Capsule: checkpoint-type-orientation`,
 * `Capsule: module-dispatch-evidence-orientation`,
 * `Capsule: github-flow-phase-orientation`, `Source type:`,
 * `Authority: Derived aid only`) and the payload caps
 * (`MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS=6000`,
 * `MAX_WORKFLOW_RESOURCE_CAPSULE_LINES=5`) are the canonical contract surface
 * and MUST stay byte-exact and single-defined in this module.
 */

import { existsSync } from "fs";
import { join } from "path";
import {
  compactWhitespace,
  readFileOr,
  getFileFreshness,
  selectBoundedLines,
} from "./pals-hooks";

export const MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS = 6_000;
export const MAX_WORKFLOW_RESOURCE_CAPSULE_LINES = 5;
export const WORKFLOW_RESOURCE_CAPSULE_FALLBACK = "full authoritative read required before approved PLAN execution, APPLY/UNIFY, lifecycle writes, checkpoints, module reports/enforcement, GitHub Flow decisions, validation assessment, stale/conflicting output, or edits/actions based on capsule content.";
export const WORKFLOW_RESOURCE_CAPSULE_AUTHORITY = "Derived aid only; no hidden persistence, no telemetry, no cache-as-truth, no lifecycle authority, no module/validation/lifecycle ledger, no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent.";
export const WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS = [
  "Capsule: plan-task-anatomy",
  "Capsule: checkpoint-type-orientation",
  "Capsule: module-dispatch-evidence-orientation",
  "Capsule: github-flow-phase-orientation",
  "Source type:",
  "Authority: Derived aid only",
] as const;

type WorkflowResourceCapsule = {
  name: string;
  source: string;
  sourceType: string;
  freshness: string;
  bounds: string;
  lines: string[];
  fallback: string;
  authority: string;
};

type WorkflowResourceCapsuleSpec = {
  name: string;
  repoSource: string;
  logicalSource: string;
  sourceType: string;
  patterns: RegExp[];
  bounds: string;
};

function getWorkflowResourceCapsuleSpecs(): WorkflowResourceCapsuleSpec[] {
  return [
    {
      name: "plan-task-anatomy",
      repoSource: "kernel/references/plan-format.md",
      logicalSource: "references/plan-format.md",
      sourceType: "installed-resource-orientation",
      patterns: [/^#/, /^##/, /task/i, /acceptance/i, /verification/i],
      bounds: `repo-relative kernel/references/plan-format.md or logical references/plan-format.md; first ${MAX_WORKFLOW_RESOURCE_CAPSULE_LINES} bounded orientation lines; max payload ${MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS} chars`,
    },
    {
      name: "checkpoint-type-orientation",
      repoSource: "kernel/references/checkpoints.md",
      logicalSource: "references/checkpoints.md",
      sourceType: "installed-resource-orientation",
      patterns: [/^#/, /^##/, /checkpoint:human-verify/i, /checkpoint:decision/i, /checkpoint:human-action/i],
      bounds: `repo-relative kernel/references/checkpoints.md or logical references/checkpoints.md; checkpoint type names only; first ${MAX_WORKFLOW_RESOURCE_CAPSULE_LINES} bounded orientation lines`,
    },
    {
      name: "module-dispatch-evidence-orientation",
      repoSource: "kernel/references/module-dispatch.md",
      logicalSource: "references/module-dispatch.md",
      sourceType: "installed-resource-orientation",
      patterns: [/^#/, /^##/, /evidence/i, /dispatch/i, /modules.yaml/i],
      bounds: `repo-relative kernel/references/module-dispatch.md or logical references/module-dispatch.md; evidence-orientation markers only; first ${MAX_WORKFLOW_RESOURCE_CAPSULE_LINES} bounded lines`,
    },
    {
      name: "github-flow-phase-orientation",
      repoSource: "kernel/references/git-strategy.md",
      logicalSource: "references/git-strategy.md",
      sourceType: "installed-resource-orientation",
      patterns: [/^#/, /^##/, /APPLY preflight/i, /APPLY postflight/i, /UNIFY merge-gate/i],
      bounds: `repo-relative kernel/references/git-strategy.md or logical references/git-strategy.md; phase-orientation markers only; first ${MAX_WORKFLOW_RESOURCE_CAPSULE_LINES} bounded lines`,
    },
  ];
}

function resolveWorkflowResourceCapsuleSource(cwd: string, spec: WorkflowResourceCapsuleSpec): { path: string; displaySource: string; sourceType: string } | undefined {
  const repoPath = join(cwd, spec.repoSource);
  if (existsSync(repoPath)) {
    return {
      path: repoPath,
      displaySource: `${spec.repoSource} (logical installed: ${spec.logicalSource})`,
      sourceType: `repo-source; ${spec.sourceType}`,
    };
  }

  const installedRoot = join(process.env.HOME ?? "", ".pi", "agent", "skills", "pals");
  const installedPath = join(installedRoot, spec.logicalSource);
  if (existsSync(installedPath)) {
    return {
      path: installedPath,
      displaySource: spec.logicalSource,
      sourceType: `installed-logical-resource; ${spec.sourceType}`,
    };
  }

  return undefined;
}

function buildWorkflowResourceCapsule(cwd: string, spec: WorkflowResourceCapsuleSpec): WorkflowResourceCapsule {
  const resolved = resolveWorkflowResourceCapsuleSource(cwd, spec);
  const content = resolved ? readFileOr(resolved.path, "") : "";
  const lines = content ? selectBoundedLines(content, spec.patterns, MAX_WORKFLOW_RESOURCE_CAPSULE_LINES) : [];
  const source = resolved?.displaySource ?? `${spec.repoSource} (logical installed: ${spec.logicalSource})`;

  return {
    name: spec.name,
    source,
    sourceType: resolved?.sourceType ?? `unavailable; ${spec.sourceType}`,
    freshness: resolved ? getFileFreshness(resolved.path) : "unavailable",
    bounds: spec.bounds,
    lines: lines.length > 0
      ? lines
      : [`unavailable-source note: no bounded capsule content available from ${source}; ${WORKFLOW_RESOURCE_CAPSULE_FALLBACK}`],
    fallback: WORKFLOW_RESOURCE_CAPSULE_FALLBACK,
    authority: WORKFLOW_RESOURCE_CAPSULE_AUTHORITY,
  };
}

export function renderWorkflowResourceCapsules(cwd: string): string[] {
  const capsules = getWorkflowResourceCapsuleSpecs().map((spec) => buildWorkflowResourceCapsule(cwd, spec));
  const rendered = [
    "Workflow/resource capsules (read-only, bounded, activation-gated)",
    `Bounds: MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS=${MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS}; MAX_WORKFLOW_RESOURCE_CAPSULE_LINES=${MAX_WORKFLOW_RESOURCE_CAPSULE_LINES}`,
    `Fallback: ${WORKFLOW_RESOURCE_CAPSULE_FALLBACK}`,
    `Authority: ${WORKFLOW_RESOURCE_CAPSULE_AUTHORITY}`,
  ];

  for (const capsule of capsules) {
    rendered.push(`Capsule: ${capsule.name}`);
    rendered.push(`Source: ${capsule.source}`);
    rendered.push(`Source type: ${capsule.sourceType}`);
    rendered.push(`Freshness: ${capsule.freshness}`);
    rendered.push(`Bounds: ${capsule.bounds}`);
    rendered.push("Content:");
    rendered.push(...capsule.lines.map((line) => `- ${line}`));
    rendered.push(`Fallback: ${capsule.fallback}`);
    rendered.push(`Authority: ${capsule.authority}`);
  }

  const joined = rendered.join("\n");
  if (joined.length <= MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS) return rendered;
  return joined.slice(0, MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS).split(/\n/).concat("[workflow/resource capsule truncated at MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS; full authoritative read required]");
}

/**
 * No-op Pi extension factory.
 *
 * This module is a helper consumed by `drivers/pi/extensions/pals-hooks.ts`;
 * the default export exists only to satisfy Pi's extension loader, which
 * scans every `*.ts` file in `~/.pi/agent/extensions/` for a default-
 * exported factory function. Real extension behavior lives in
 * `pals-hooks.ts`. This factory MUST remain a no-op so it never mutates Pi
 * state, registers tools, subscribes to events, or owns lifecycle authority.
 *
 * Authority: Derived aid only.
 */
export default function (_pi: unknown): void {}
