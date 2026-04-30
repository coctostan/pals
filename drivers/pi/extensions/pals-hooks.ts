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

// -- Helpers --

const PALS_STATUS_ID = "pals-lifecycle";
const PALS_WIDGET_ID = "pals-lifecycle";
const PRIMARY_QUICK_ACTION_LIMIT = 3;
const MAX_QUICK_ACTIONS = 5;

const PRIMARY_INJECTION_EVENT = "before_agent_start";
const SUPPORTING_CONTEXT_EVENT = "context";
const PALS_CONTEXT_CUSTOM_TYPE = "pals-context";
const LEGACY_PALS_CONTEXT_HEADER = "## PALS Context (auto-injected)";
const STATE_AUTHORITY_TAG = "[PALS_STATE_AUTHORITY=.paul/STATE.md]";
const ACTIVATION_SIGNAL_TAG = "[PALS_ACTIVATION_SIGNAL]";

const ACTIVATION_WINDOW_MS = 15 * 60 * 1000;
const COMMAND_ACTIVATION_TURN_BUDGET = 3;
const PROMPT_ACTIVATION_TURN_BUDGET = 1;
const GUIDED_WORKFLOW_LOOKBACK = 5;
const GUIDED_WORKFLOW_SIGNATURE_BYTES = 240;
const RECENT_MODULE_ACTIVITY_LOOKBACK = 3;
const MAX_VISIBLE_MODULES = 3;
const MAX_WIDGET_MODULE_DETAILS = 4;
const DISPATCH_MARKER = "[dispatch]";
const MODULE_REPORTS_HEADER = "Module Execution Reports";
const MAX_ARTIFACT_SLICE_CHARS = 3_000;
const MAX_ARTIFACT_SLICE_LINES = 8;
const ARTIFACT_SLICE_SOURCE_STATE = ".paul/STATE.md";
const ARTIFACT_SLICE_SOURCE_ROADMAP = ".paul/ROADMAP.md";
const ARTIFACT_SLICE_FALLBACK = "full authoritative read required before edits, approved PLAN execution, lifecycle writes, stale/ambiguous/contested facts, decisions, GitHub Flow gates, validation pass/fail, module completion, APPLY completion, or UNIFY completion.";
const ARTIFACT_SLICE_AUTHORITY = "Derived aid only; shared .paul/* artifacts and markdown workflows remain authoritative. No hidden persistence, cache, telemetry, report, or Pi-owned lifecycle/module/validation ledger.";
const ARTIFACT_SLICE_SCHEMA_MARKERS = [
  "Slice: current-lifecycle-state",
  "Slice: active-roadmap-phase",
  "Slice: approved-plan-task-packet",
  "Artifact slices (read-only, bounded)",
  "Fallback: full authoritative read",
  "Authority: Derived aid only",
] as const;
const MAX_WORKFLOW_RESOURCE_CAPSULE_CHARS = 6_000;
const MAX_WORKFLOW_RESOURCE_CAPSULE_LINES = 5;
const WORKFLOW_RESOURCE_CAPSULE_FALLBACK = "full authoritative read required before approved PLAN execution, APPLY/UNIFY, lifecycle writes, checkpoints, module reports/enforcement, GitHub Flow decisions, validation assessment, stale/conflicting output, or edits/actions based on capsule content.";
const WORKFLOW_RESOURCE_CAPSULE_AUTHORITY = "Derived aid only; no hidden persistence, no telemetry, no cache-as-truth, no lifecycle authority, no module/validation/lifecycle ledger, no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent.";
const WORKFLOW_RESOURCE_CAPSULE_SCHEMA_MARKERS = [
  "Capsule: plan-task-anatomy",
  "Capsule: checkpoint-type-orientation",
  "Capsule: module-dispatch-evidence-orientation",
  "Capsule: github-flow-phase-orientation",
  "Source type:",
  "Authority: Derived aid only",
] as const;

// -- CARL Session Boundary Manager constants --
const CARL_NEW_SESSION_TIMEOUT_MS = 10_000;
const CARL_DEFAULT_CONTINUE_THRESHOLD = 0.4;
const CARL_DEFAULT_SAFETY_CEILING = 0.8;
const CARL_DEFAULT_STRATEGY: CarlConfig["session_strategy"] = "phase-boundary";

type PalsStateSnapshot = {
  detected: boolean;
  milestone?: string;
  phase?: string;
  loop?: string;
  nextAction?: string;
};

type CommandDef = {
  name: string;
  description: string;
  skill: string;
  guidance: string;
};

type QuickActionDef = {
  id: string;
  commandName: CommandDef["name"];
  label: string;
  shortcutHint: string;
};

type ActivationState = {
  source: "command" | "prompt";
  signal: string;
  expiresAt: number;
  turnsRemaining: number;
};


type ArtifactSlice = {
  name: string;
  source: string;
  freshness: string;
  bounds: string;
  lines: string[];
  fallback: string;
  authority: string;
};

type ArtifactSliceSpec = {
  name: string;
  source: string;
  patterns: RegExp[];
  bounds: string;
};

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

type GuidedWorkflowOption = {
  id: string;
  label: string;
  canonicalResponse: string;
};

type GuidedWorkflowMoment = {
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

type ModuleActivityEntry = {
  name: string;
  detail?: string;
};

type RecentModuleActivity = {
  source: "dispatch" | "report";
  stage: string;
  stageLabel: string;
  entries: ModuleActivityEntry[];
};

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

function readFileOr(path: string, fallback: string): string {
  try {
    return existsSync(path) ? readFileSync(path, "utf-8") : fallback;
  } catch {
    return fallback;
  }
}

function compactWhitespace(value?: string): string | undefined {
  return value?.replace(/\s+/g, " ").trim() || undefined;
}

function parsePalsState(cwd: string): PalsStateSnapshot {
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

function getFileFreshness(path: string): string {
  try {
    return existsSync(path) ? statSync(path).mtime.toISOString() : "unavailable";
  } catch {
    return "unavailable";
  }
}

function selectBoundedLines(content: string, patterns: RegExp[], maxLines = MAX_ARTIFACT_SLICE_LINES): string[] {
  const selected: string[] = [];
  for (const line of content.split(/\r?\n/)) {
    const compact = compactWhitespace(line);
    if (!compact) continue;
    if (patterns.some((pattern) => pattern.test(compact))) selected.push(compact);
    if (selected.length >= maxLines) break;
  }
  return selected;
}

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function normalizeArtifactSliceLine(line: string): string {
  return compactWhitespace(line).toLowerCase();
}

function deduplicateArtifactSliceLines(lines: string[], emittedKeys: Set<string>): string[] {
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

function extractPlanPath(nextAction?: string): string | undefined {
  const match = nextAction?.match(/\.paul\/phases\/[^\s`]+\/\d+-\d+-PLAN\.md/);
  return match?.[0];
}

function buildArtifactSlice(cwd: string, spec: ArtifactSliceSpec): ArtifactSlice {
  const absolute = join(cwd, spec.source);
  const content = readFileOr(absolute, "");
  const lines = content ? selectBoundedLines(content, spec.patterns) : [];
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

function getArtifactSliceSpecs(state: PalsStateSnapshot): ArtifactSliceSpec[] {
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

function renderArtifactSlices(cwd: string, state: PalsStateSnapshot): string[] {
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

function renderWorkflowResourceCapsules(cwd: string): string[] {
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

function getCommand(name: CommandDef["name"]): CommandDef | undefined {
  return COMMANDS.find((cmd) => cmd.name === name);
}

function toWrapperCommand(commandText?: string): string | undefined {
  const trimmed = compactWhitespace(commandText);
  if (!trimmed) return undefined;
  if (trimmed.startsWith("/paul-")) return trimmed;
  if (trimmed.startsWith("/skill:paul-")) {
    return trimmed.replace("/skill:", "/");
  }
  return undefined;
}

function detectCommandSignal(value?: string): string | undefined {
  const compact = compactWhitespace(value);
  if (!compact) return undefined;

  const match = compact.match(/\/(?:skill:)?(paul-(?:init|plan|apply|unify|resume|status|fix|pause|milestone|discuss|help|review))(?:\s+(.+))?/i);
  if (!match) return undefined;

  const command = `/${match[1].toLowerCase()}`;
  const args = compactWhitespace(match[2]);
  return args ? `${command} ${args}` : command;
}

function getQuickActions(state: PalsStateSnapshot): QuickActionDef[] {
  const actions: QuickActionDef[] = [];
  const nextWrapper = toWrapperCommand(state.nextAction);
  const nextCommandName = nextWrapper?.slice(1).split(/\s+/, 1)[0] as CommandDef["name"] | undefined;
  if (nextCommandName && getCommand(nextCommandName)) {
    actions.push({
      id: "next-action",
      commandName: nextCommandName,
      label: "Next",
      shortcutHint: "Ctrl+Alt+N",
    });
  }

  actions.push(
    { id: "status", commandName: "paul-status", label: "Status", shortcutHint: "Ctrl+Alt+S" },
    { id: "resume", commandName: "paul-resume", label: "Resume", shortcutHint: "Ctrl+Alt+R" },
    { id: "help", commandName: "paul-help", label: "Help", shortcutHint: "Ctrl+Alt+H" },
    { id: "milestone", commandName: "paul-milestone", label: "Milestone", shortcutHint: "Ctrl+Alt+M" },
  );

  return actions
    .filter((action, index, all) => all.findIndex((candidate) => candidate.commandName === action.commandName) === index)
    .slice(0, MAX_QUICK_ACTIONS);
}


function renderLoopBadge(loopString?: string): string | undefined {
  if (!loopString) return undefined;
  const marks = [...loopString.matchAll(/[✓○]/g)].map((m) => m[0]);
  if (marks.length < 3) return undefined;
  return `PLAN${marks[0]} APPLY${marks[1]} UNIFY${marks[2]}`;
}

function renderCompactLoopSummary(loopString?: string): string | undefined {
  if (!loopString) return undefined;
  return `Loop: ${renderLoopBadge(loopString) ?? compactWhitespace(loopString)}`;
}

function renderLifecycleActionLabel(state: PalsStateSnapshot): string {
  const nextAction = compactWhitespace(state.nextAction)?.toLowerCase() ?? "";
  const loopSignature = state.loop ? [...state.loop.matchAll(/[✓○]/g)].map((match) => match[0]).join("") : "";

  if (loopSignature === "✓✓✓") return "Complete";
  if (/address blocker|blocked|fix ci|failing|failure/.test(nextAction)) return "Blocked";
  if (/review|approve|checkpoint|human verification|human action|decision required|waiting/.test(nextAction)) return "Waiting";
  if (nextAction) return "Ready";
  return "Next";
}
function compactModuleDetail(detail?: string): string | undefined {
  const compact = compactWhitespace(detail);
  if (!compact) return undefined;
  return compact.length > 48 ? `${compact.slice(0, 47)}…` : compact;
}

function normalizeModuleEntryName(value?: string): string | undefined {
  const cleaned = compactWhitespace(value)?.replace(/[^A-Za-z0-9_-]/g, "");
  return cleaned ? cleaned.toUpperCase() : undefined;
}

function formatModuleStageLabel(stage?: string): string {
  const compact = compactWhitespace(stage);
  if (!compact) return "recent activity";
  return compact === "module-reports" ? "module reports" : compact;
}

function parseModuleActivityEntries(raw: string): ModuleActivityEntry[] {
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

function extractDispatchModuleActivity(text: string): RecentModuleActivity | undefined {
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

function extractModuleReportActivity(text: string): RecentModuleActivity | undefined {
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

function extractRecentModuleActivity(recentAssistantTexts: string[]): RecentModuleActivity | undefined {
  for (const text of recentAssistantTexts) {
    const dispatchActivity = extractDispatchModuleActivity(text);
    if (dispatchActivity) return dispatchActivity;

    const reportActivity = extractModuleReportActivity(text);
    if (reportActivity) return reportActivity;
  }

  return undefined;
}

function formatModuleEntryList(
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

function renderModuleActivity(activity?: RecentModuleActivity): string | undefined {
  if (!activity) return undefined;
  const modules = formatModuleEntryList(activity.entries, MAX_VISIBLE_MODULES, ", ");
  if (!modules) return undefined;
  return `Modules: ${activity.stageLabel} • ${modules}`;
}

function renderModuleActivityDetails(activity?: RecentModuleActivity): string[] {
  if (!activity) return [];

  const details = formatModuleEntryList(activity.entries, MAX_WIDGET_MODULE_DETAILS, " | ", true);
  if (!details) return [];
  return [
    `Recent module activity: ${activity.stageLabel}`,
    `Modules: ${details}`,
  ];
}

function renderLifecycleStatus(state: PalsStateSnapshot, activity?: RecentModuleActivity): string | undefined {
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

function renderLifecycleWidget(state: PalsStateSnapshot, activity?: RecentModuleActivity): string[] | undefined {
  if (!state.detected) return undefined;
  return [
    state.milestone ? `PALS Milestone: ${state.milestone}` : "PALS Milestone: unknown",
    state.phase ? `Phase: ${state.phase}` : "Phase: unknown",
    state.loop ? `Loop: ${state.loop}` : "Loop: unknown",
    state.nextAction ? `Next action: ${state.nextAction}` : "Next action: unknown",
  ];
}
function syncLifecycleUi(ctx: any): void {
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

function shouldInjectPalsContext(state: PalsStateSnapshot, activation: ActivationState | undefined): boolean {
  return Boolean(state.detected && activation && activation.turnsRemaining > 0);
}

function buildPalsContextPayload(state: PalsStateSnapshot, activation: ActivationState, cwd: string): string {
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

function isLegacyPalsContextMessage(message: any): boolean {
  return message?.role === "user" && typeof message?.content === "string" && message.content.includes(LEGACY_PALS_CONTEXT_HEADER);
}

function isPalsContextMessage(message: any): boolean {
  if (message?.customType === PALS_CONTEXT_CUSTOM_TYPE) return true;
  return isLegacyPalsContextMessage(message);
}

function keepOnlyLatestPalsContextMessage(messages: any[]): any[] {
  let latestIndex = -1;
  for (let i = 0; i < messages.length; i++) {
    if (isPalsContextMessage(messages[i])) latestIndex = i;
  }

  if (latestIndex < 0) return messages;
  return messages.filter((message, index) => !isPalsContextMessage(message) || index === latestIndex);
}

function messagesChanged(previous: any[], next: any[]): boolean {
  if (previous.length !== next.length) return true;
  for (let i = 0; i < previous.length; i++) {
    if (previous[i] !== next[i]) return true;
  }
  return false;
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

function collectRecentAssistantTexts(ctx: any, event: any, limit = GUIDED_WORKFLOW_LOOKBACK): string[] {
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

function summarizeWorkflowPrompt(text: string, fallback: string): string {
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

function extractNextActionSummary(text: string): string {
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

function isValidOptionId(id: string): boolean {
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
function parseGuidedWorkflowOptions(text: string): GuidedWorkflowOption[] {
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

function detectExplicitCanonicalResponse(text: string): string | undefined {
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

function isMergeGateRoutingPrompt(text: string): boolean {
  const hasGitStateMarker = /(Git State|GitHub Flow|Merge gate|Branch:|Base:|PR:|CI:|Sync:)/i.test(text);
  const hasMergeRouteMarker =
    /merge-gate-routing|merge[- ]gate|Fix CI|CI:\s*(failing|passing|pending)|CI failing|CI passing|reviews? pending|ready to merge|Merge PR|gh pr|Update branch|behind base|rebase origin|delete branch|cleanup/i.test(
      text,
    );
  return hasGitStateMarker && hasMergeRouteMarker;
}

function extractMergeGateRoutingSummary(text: string): string {
  const nextAction = extractNextActionSummary(text);
  if (nextAction !== "A PALS next action is available.") {
    return nextAction;
  }
  return summarizeWorkflowPrompt(
    text,
    "GitHub Flow routing is visible; use only explicit workflow options or the canonical transcript prompt.",
  );
}

function makeGuidedWorkflowSignature(kind: GuidedWorkflowMoment["kind"], state: PalsStateSnapshot, text: string): string {
  return compactWhitespace(
    `${kind} | ${state.phase ?? "unknown-phase"} | ${state.loop ?? "unknown-loop"} | ${text.slice(0, GUIDED_WORKFLOW_SIGNATURE_BYTES)}`,
  ) ?? kind;
}

// Guided workflow layer: detect canonical prompts like Continue to APPLY, Continue to UNIFY,
// CHECKPOINT, ▶ NEXT, and merge-gate-routing handoffs from recent assistant messages plus authoritative STATE.md context.
function detectGuidedWorkflowMoment(
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

function extractLoopSignature(state: PalsStateSnapshot): string | undefined {
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
// -- Command definitions --

const COMMANDS: CommandDef[] = [
  {
    name: "paul-init",
    description: "Set up PALS lifecycle files for this project",
    skill: "paul-init",
    guidance: "Pi convenience wrapper → canonical /skill:paul-init",
  },
  {
    name: "paul-plan",
    description: "Plan the next PALS phase",
    skill: "paul-plan",
    guidance: "Pi convenience wrapper → canonical /skill:paul-plan",
  },
  {
    name: "paul-apply",
    description: "Execute the approved PALS plan",
    skill: "paul-apply",
    guidance: "Pi convenience wrapper → canonical /skill:paul-apply",
  },
  {
    name: "paul-unify",
    description: "Reconcile completed work and close the loop",
    skill: "paul-unify",
    guidance: "Pi convenience wrapper → canonical /skill:paul-unify",
  },
  {
    name: "paul-resume",
    description: "Resume PALS work from current project state",
    skill: "paul-resume",
    guidance: "Pi convenience wrapper → canonical /skill:paul-resume",
  },
  {
    name: "paul-status",
    description: "Show current PALS status and next action",
    skill: "paul-status",
    guidance: "Pi convenience wrapper → canonical /skill:paul-status",
  },
  {
    name: "paul-fix",
    description: "Run a quick PALS fix flow",
    skill: "paul-fix",
    guidance: "Pi convenience wrapper → canonical /skill:paul-fix",
  },
  {
    name: "paul-pause",
    description: "Create a PALS handoff before stopping",
    skill: "paul-pause",
    guidance: "Pi convenience wrapper → canonical /skill:paul-pause",
  },
  {
    name: "paul-milestone",
    description: "Create or complete a PALS milestone",
    skill: "paul-milestone",
    guidance: "Pi convenience wrapper → canonical /skill:paul-milestone",
  },
  {
    name: "paul-discuss",
    description: "Discuss scope before planning in PALS",
    skill: "paul-discuss",
    guidance: "Pi convenience wrapper → canonical /skill:paul-discuss",
  },
  {
    name: "paul-help",
    description: "Show Pi command and skill guidance for PALS",
    skill: "paul-help",
    guidance: "Pi convenience wrapper → canonical /skill:paul-help",
  },
  {
    name: "paul-review",
    description: "Run thorough code review via REV subagent",
    skill: "paul-review",
    guidance: "Pi convenience wrapper → canonical /skill:paul-review",
  },
];

// -- Extension entry point --
export default function palsHooks(pi: any): void {
  let activationState: ActivationState | undefined;
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

  const markActivation = (
    source: ActivationState["source"],
    signal: string,
    turns: number,
  ): void => {
    activationState = {
      source,
      signal,
      turnsRemaining: turns,
      expiresAt: Date.now() + ACTIVATION_WINDOW_MS,
    };
  };

  const getActiveActivation = (): ActivationState | undefined => {
    if (!activationState) return undefined;
    if (activationState.turnsRemaining <= 0 || activationState.expiresAt < Date.now()) {
      activationState = undefined;
      return undefined;
    }
    return activationState;
  };

  const consumeActivationTurn = (): void => {
    if (!activationState) return;
    activationState.turnsRemaining -= 1;
    if (activationState.turnsRemaining <= 0) {
      activationState = undefined;
    }
  };

  const routeCommand = (commandName: CommandDef["name"], args = "", ctx?: any): void => {
    const cmd = getCommand(commandName);
    if (!cmd) return;
    const trimmedArgs = args.trim();
    const wrapperCmd = `/${commandName}${trimmedArgs ? " " + trimmedArgs : ""}`;
    markActivation("command", wrapperCmd, COMMAND_ACTIVATION_TURN_BUDGET);
    const skillCmd = `/skill:${cmd.skill}${trimmedArgs ? " " + trimmedArgs : ""}`;
    ctx?.ui?.notify(`${cmd.guidance} — routing now`, "success");
    pi.sendUserMessage(skillCmd);
  };

  const routeWrapperCommand = (commandText: string, ctx?: any): void => {
    const wrapper = toWrapperCommand(commandText);
    if (!wrapper) return;

    const commandName = wrapper.slice(1).split(/\s+/, 1)[0] as CommandDef["name"];
    const args = wrapper.replace(/^\/paul-[^\s]+\s*/, "");
    routeCommand(commandName, args, ctx);
  };

  const registerQuickActionShortcut = (
    shortcut: string,
    description: string,
    handler: (ctx: any) => void,
  ): void => {
    pi.registerShortcut(shortcut, {
      description,
      handler: async (ctx: any) => {
        handler(ctx);
      },
    });
  };

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
