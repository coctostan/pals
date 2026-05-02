/**
 * Module Activity Parsing — Pi Extension subsystem (S5)
 *
 * Pure transcript parsing for PALS module dispatch evidence and Module Execution
 * Reports. Extracted from `drivers/pi/extensions/pals-hooks.ts` in Phase 239
 * (plan 239-01) per `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md`.
 *
 * Authority: Derived aid only. No Pi mutation, no filesystem I/O, no `.paul/*`
 * lifecycle writes. The `DISPATCH_MARKER` and `MODULE_REPORTS_HEADER` literals
 * are the canonical markers that the lifecycle UI relies on; they MUST stay
 * exact strings and live single-defined in this module.
 */

import { compactWhitespace, MAX_WIDGET_MODULE_DETAILS } from "./pals-hooks";

export const DISPATCH_MARKER = "[dispatch]";
export const MODULE_REPORTS_HEADER = "Module Execution Reports";

export type ModuleActivityEntry = {
  name: string;
  detail?: string;
};

export type RecentModuleActivity = {
  source: "dispatch" | "report";
  stage: string;
  stageLabel: string;
  entries: ModuleActivityEntry[];
};

export function compactModuleDetail(detail?: string): string | undefined {
  const compact = compactWhitespace(detail);
  if (!compact) return undefined;
  return compact.length > 48 ? `${compact.slice(0, 47)}…` : compact;
}

export function normalizeModuleEntryName(value?: string): string | undefined {
  const cleaned = compactWhitespace(value)?.replace(/[^A-Za-z0-9_-]/g, "");
  return cleaned ? cleaned.toUpperCase() : undefined;
}

export function formatModuleStageLabel(stage?: string): string {
  const compact = compactWhitespace(stage);
  if (!compact) return "recent activity";
  return compact === "module-reports" ? "module reports" : compact;
}

export function parseModuleActivityEntries(raw: string): ModuleActivityEntry[] {
  const cleaned = raw.trim().replace(/^\{/, "").replace(/\}$/, "");
  if (!cleaned) return [];

  return cleaned
    .split(/\s+\|\s+/)
    .map((part) => {
      const match = compactWhitespace(part)?.match(/^([A-Za-z0-9_-]+)(?:\(\d+\))?(?:\s*→\s*(.+))?$/);
      if (!match) return undefined;
      const name = normalizeModuleEntryName(match[1]);
      if (!name) return undefined;
      return {
        name,
        detail: compactModuleDetail(match[2]),
      };
    })
    .filter(Boolean) as ModuleActivityEntry[];
}

export function extractDispatchModuleActivity(text: string): RecentModuleActivity | undefined {
  const lines = text
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);

  for (let i = lines.length - 1; i >= 0; i--) {
    const line = lines[i]!;
    if (!line.startsWith(DISPATCH_MARKER)) continue;
    const match = line.match(/^\[dispatch\]\s*([^:]+):\s*(.+)$/);
    if (!match) continue;

    const stage = compactWhitespace(match[1]);
    const entries = parseModuleActivityEntries(match[2]);
    if (!stage || entries.length === 0) continue;

    return {
      source: "dispatch",
      stage,
      stageLabel: formatModuleStageLabel(stage),
      entries,
    };
  }

  return undefined;
}

export function extractModuleReportActivity(text: string): RecentModuleActivity | undefined {
  if (!text.includes(MODULE_REPORTS_HEADER)) return undefined;

  const lines = text.split(/\r?\n/).map((line) => line.trim());
  const headerIndex = lines.findIndex((line) => line.includes(MODULE_REPORTS_HEADER));
  if (headerIndex < 0) return undefined;

  const entries: ModuleActivityEntry[] = [];
  for (let i = headerIndex + 1; i < lines.length && entries.length < MAX_WIDGET_MODULE_DETAILS; i++) {
    const line = lines[i]!;
    if (!line) continue;
    if (/^##\s+/.test(line) && !line.includes(MODULE_REPORTS_HEADER)) break;

    const headingMatch = line.match(/^#{3,4}\s+(?:.+?\(([A-Z][A-Z0-9_-]+)\)|([A-Z][A-Z0-9_-]+))(?:\s|$)/);
    if (headingMatch) {
      const name = normalizeModuleEntryName(headingMatch[1] ?? headingMatch[2]);
      if (name && !entries.some((entry) => entry.name === name)) entries.push({ name });
      continue;
    }

    const bulletMatch = line.match(/^-\s*([A-Z][A-Z0-9_-]+)\s*:\s*(.+)$/);
    if (bulletMatch) {
      const name = normalizeModuleEntryName(bulletMatch[1]);
      if (name && !entries.some((entry) => entry.name === name)) {
        entries.push({ name, detail: compactModuleDetail(bulletMatch[2]) });
      }
    }
  }

  if (entries.length === 0) return undefined;
  return {
    source: "report",
    stage: "module-reports",
    stageLabel: formatModuleStageLabel("module-reports"),
    entries,
  };
}

export function extractRecentModuleActivity(recentAssistantTexts: string[]): RecentModuleActivity | undefined {
  for (const text of recentAssistantTexts) {
    const dispatchActivity = extractDispatchModuleActivity(text);
    if (dispatchActivity) return dispatchActivity;

    const reportActivity = extractModuleReportActivity(text);
    if (reportActivity) return reportActivity;
  }

  return undefined;
}

export function formatModuleEntryList(
  entries: ModuleActivityEntry[],
  limit: number,
  separator: string,
  includeDetails = false,
): string | undefined {
  if (entries.length === 0) return undefined;

  const visible = entries.slice(0, limit).map((entry) => {
    if (!includeDetails || !entry.detail) return entry.name;
    return `${entry.name} → ${entry.detail}`;
  });
  const overflow = entries.length > limit ? `${separator}+${entries.length - limit}` : "";
  return `${visible.join(separator)}${overflow}`;
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
