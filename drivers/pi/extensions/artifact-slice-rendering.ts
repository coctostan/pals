/**
 * Artifact Slice Rendering — Pi Extension subsystem (S1)
 *
 * Bounded, read-only artifact-slice targeting and deduplication for PALS
 * orientation context. Renders deterministic slices over `.paul/STATE.md`,
 * `.paul/ROADMAP.md`, and the active approved PLAN.md so the LLM can ground
 * itself before lifecycle work without ever treating the slice as authority.
 *
 * Extracted from `drivers/pi/extensions/pals-hooks.ts` in Phase 243
 * (`.paul/phases/243-bounded-submodule-extraction-wave/243-01-PLAN.md`) per
 * `docs/PI-NATIVE-EXTENSION-EXTRACTION-TARGET-BASELINE.md` and the original
 * `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` S1 inventory. Mirrors
 * the Phase 239 S5 sibling-module pattern proven in
 * `drivers/pi/extensions/module-activity-parsing.ts`.
 *
 * Authority: Derived aid only. No Pi mutation, no .paul/* lifecycle writes.
 * The visible markers (`Slice: current-lifecycle-state`, `Slice: active-roadmap-phase`,
 * `Slice: approved-plan-task-packet`, `Artifact slices (read-only, bounded)`,
 * `Fallback: full authoritative read`, `Authority: Derived aid only`) and the
 * payload caps (`MAX_ARTIFACT_SLICE_CHARS=3000`, `MAX_ARTIFACT_SLICE_LINES=8`)
 * are the canonical contract surface and MUST stay byte-exact and single-defined
 * in this module.
 */

import { join } from "path";
import {
  compactWhitespace,
  readFileOr,
  getFileFreshness,
  selectBoundedLines,
  escapeRegExp,
} from "./pals-hooks";
import type { PalsStateSnapshot } from "./pals-hooks";

export const MAX_ARTIFACT_SLICE_CHARS = 3_000;
export const MAX_ARTIFACT_SLICE_LINES = 8;
export const ARTIFACT_SLICE_SOURCE_STATE = ".paul/STATE.md";
export const ARTIFACT_SLICE_SOURCE_ROADMAP = ".paul/ROADMAP.md";
export const ARTIFACT_SLICE_FALLBACK = "full authoritative read required before edits, approved PLAN execution, lifecycle writes, stale/ambiguous/contested facts, decisions, GitHub Flow gates, validation pass/fail, module completion, APPLY completion, or UNIFY completion.";
export const ARTIFACT_SLICE_AUTHORITY = "Derived aid only; shared .paul/* artifacts and markdown workflows remain authoritative. No hidden persistence, cache, telemetry, report, or Pi-owned lifecycle/module/validation ledger.";
export const ARTIFACT_SLICE_SCHEMA_MARKERS = [
  "Slice: current-lifecycle-state",
  "Slice: active-roadmap-phase",
  "Slice: approved-plan-task-packet",
  "Artifact slices (read-only, bounded)",
  "Fallback: full authoritative read",
  "Authority: Derived aid only",
] as const;

export type ArtifactSlice = {
  name: string;
  source: string;
  freshness: string;
  bounds: string;
  lines: string[];
  fallback: string;
  authority: string;
};

export type ArtifactSliceSpec = {
  name: string;
  source: string;
  patterns: RegExp[];
  bounds: string;
};

export function normalizeArtifactSliceLine(line: string): string {
  return compactWhitespace(line).toLowerCase();
}

export function deduplicateArtifactSliceLines(lines: string[], emittedKeys: Set<string>): string[] {
  const deduplicated: string[] = [];
  for (const line of lines) {
    const key = normalizeArtifactSliceLine(line);
    if (!key) continue;
    if (emittedKeys.has(key)) continue;
    emittedKeys.add(key);
    deduplicated.push(line);
  }
  return deduplicated;
}

export function extractPlanPath(nextAction?: string): string | undefined {
  const match = nextAction?.match(/\.paul\/phases\/[^\s`]+\/\d+-\d+-PLAN\.md/);
  return match?.[0];
}

export function buildArtifactSlice(cwd: string, spec: ArtifactSliceSpec): ArtifactSlice {
  const absolute = join(cwd, spec.source);
  const content = readFileOr(absolute, "");
  const lines = content ? selectBoundedLines(content, spec.patterns, MAX_ARTIFACT_SLICE_LINES) : [];
  return {
    name: spec.name,
    source: spec.source,
    freshness: getFileFreshness(absolute),
    bounds: spec.bounds,
    lines: lines.length > 0
      ? lines
      : [`unavailable-source note: no bounded slice content available from ${spec.source}; ${ARTIFACT_SLICE_FALLBACK}`],
    fallback: ARTIFACT_SLICE_FALLBACK,
    authority: ARTIFACT_SLICE_AUTHORITY,
  };
}

export function getArtifactSliceSpecs(state: PalsStateSnapshot): ArtifactSliceSpec[] {
  const phaseNumber = state.phase?.match(/^(\d+)/)?.[1];
  const planPath = extractPlanPath(state.nextAction);
  const activeRoadmapPatterns = [
    ...(phaseNumber
      ? [new RegExp(`^\\|\\s*${phaseNumber}\\s*\\|`), new RegExp(`Phase\\s+${phaseNumber}\\b`, "i")]
      : [/^\|\s*Phase\s*\|/i]),
    ...(state.milestone ? [new RegExp(escapeRegExp(state.milestone), "i")] : []),
  ];
  const specs: ArtifactSliceSpec[] = [
    {
      name: "current-lifecycle-state",
      source: ARTIFACT_SLICE_SOURCE_STATE,
      patterns: [/^Milestone:/, /^Phase:/, /^Plan:/, /^Status:/, /^Last activity:/, /^Next action:/, /^Resume file:/],
      bounds: `repo-relative ${ARTIFACT_SLICE_SOURCE_STATE}; first ${MAX_ARTIFACT_SLICE_LINES} matching lifecycle lines; max payload ${MAX_ARTIFACT_SLICE_CHARS} chars`,
    },
    {
      name: "active-roadmap-phase",
      source: ARTIFACT_SLICE_SOURCE_ROADMAP,
      patterns: activeRoadmapPatterns,
      bounds: `repo-relative ${ARTIFACT_SLICE_SOURCE_ROADMAP}; artifact-slice targeting selects active phase/current milestone markers only; no generic keyword or completed-history expansion; first ${MAX_ARTIFACT_SLICE_LINES} matching lines`,
    },
  ];

  if (planPath) {
    specs.push({
      name: "approved-plan-task-packet",
      source: planPath,
      patterns: [/^## Goal/, /^## Output/, /^<task/, /^<boundaries>/, /^## AC-/, /^\s*<name>/, /^\s*<files>/, /^\s*<verify>/, /artifact-slice targeting/i, /deduplication/i, /duplicate trimming/i, /full authoritative read/i],
      bounds: `repo-relative current PLAN path discovered from STATE next action; artifact-slice targeting selects task names, files, verification, acceptance criteria, boundaries, and handoff markers; first ${MAX_ARTIFACT_SLICE_LINES} matching lines; max payload ${MAX_ARTIFACT_SLICE_CHARS} chars`,
    });
  }

  return specs;
}

export function renderArtifactSlices(cwd: string, state: PalsStateSnapshot): string[] {
  const slices = getArtifactSliceSpecs(state).map((spec) => buildArtifactSlice(cwd, spec));
  const emittedArtifactSliceKeys = new Set<string>();
  const rendered = [
    "Artifact slices (read-only, bounded, activation-gated, artifact-slice targeting + deduplication enabled)",
    `Bounds: MAX_ARTIFACT_SLICE_CHARS=${MAX_ARTIFACT_SLICE_CHARS}; MAX_ARTIFACT_SLICE_LINES=${MAX_ARTIFACT_SLICE_LINES}`,
    `Fallback: ${ARTIFACT_SLICE_FALLBACK}`,
    `Authority: ${ARTIFACT_SLICE_AUTHORITY}`,
  ];

  for (const slice of slices) {
    const deduplicatedLines = deduplicateArtifactSliceLines(slice.lines, emittedArtifactSliceKeys);
    rendered.push(`Slice: ${slice.name}`);
    rendered.push(`Source: ${slice.source}`);
    rendered.push(`Freshness: ${slice.freshness}`);
    rendered.push(`Bounds: ${slice.bounds}; deterministic duplicate trimming preserves first cited occurrence`);
    rendered.push("Content:");
    rendered.push(...(deduplicatedLines.length > 0
      ? deduplicatedLines
      : [`duplicate-trim note: all bounded content from ${slice.source} duplicated an earlier artifact slice; ${ARTIFACT_SLICE_FALLBACK}`]
    ).map((line) => `- ${line}`));
    rendered.push(`Fallback: ${slice.fallback}`);
    rendered.push(`Authority: ${slice.authority}`);
  }

  const joined = rendered.join("\n");
  if (joined.length <= MAX_ARTIFACT_SLICE_CHARS) return rendered;
  return joined.slice(0, MAX_ARTIFACT_SLICE_CHARS).split(/\n/).concat("[artifact slice truncated at MAX_ARTIFACT_SLICE_CHARS; full authoritative read required]");
}
