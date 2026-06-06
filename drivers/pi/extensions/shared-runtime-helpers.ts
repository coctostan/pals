/**
 * PALS Shared Runtime Helpers — Pi Extension (dependency leaf)
 *
 * Pure/derived filesystem and STATE helpers extracted from `pals-hooks.ts`
 * per the v2.72 Shared Runtime Helper Extraction milestone. This module is a
 * dependency LEAF: the orchestrator (`pals-hooks.ts`) and sibling extensions
 * import from here, never the reverse. Its only runtime imports are Node
 * `fs`/`path` built-ins.
 *
 * Authoritative spec: docs/PALS-SHARED-RUNTIME-HELPERS-CONTRACT.md (Phase 303).
 * It is derived/aid-only code — it reads and derives values, never owns or
 * mutates lifecycle authority, dispatches modules, routes commands, performs
 * git/validation, makes UI decisions, or introduces authority markers.
 *
 * Install: copy to ~/.pi/agent/extensions/shared-runtime-helpers.ts
 * Requires: Pi coding agent with extension support
 */

import { readFileSync, existsSync, statSync } from "fs";
import { join } from "path";

export type PalsStateSnapshot = {
  detected: boolean;
  milestone?: string;
  phase?: string;
  loop?: string;
  nextAction?: string;
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

export function extractLoopSignature(state: PalsStateSnapshot): string | undefined {
  if (!state.loop) return undefined;
  const marks = [...state.loop.matchAll(/[✓○]/g)].map((m) => m[0]);
  return marks.length >= 3 ? marks.join("") : undefined;
}

/**
 * No-op Pi extension factory.
 *
 * This module exports pure helpers consumed by other extensions; it registers
 * no Pi lifecycle hooks itself. The factory exists so the installer's `*.ts`
 * source-set rule and the Pi loader treat it as a valid extension.
 */
export default function (_pi: unknown): void {}
