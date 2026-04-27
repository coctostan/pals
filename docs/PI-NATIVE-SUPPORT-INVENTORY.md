# Pi-Native Support Inventory

## Support Tier Decision

Pi is the active supported runtime for current PALS development. Current architecture work may rely on Pi skills, the Pi extension, and repo-shipped helper agents when they reduce model context burden while preserving the PLAN/APPLY/UNIFY lifecycle contract.

Claude Code and the Anthropic Agent SDK are unsupported/frozen historical surfaces for the current product direction. Their existing files remain useful as reference material and compatibility evidence, but v2.45 work should not preserve active parity with them unless a later explicit product decision reopens that support tier.

This decision does not move lifecycle authority into Pi. The `.paul/*` artifacts, shared workflow markdown, installed module registry evidence, and parent-owned APPLY verification remain the authoritative project runtime.

## Classification Legend

| Classification | Meaning |
|---|---|
| `active-pi` | Current supported runtime surface. Future architecture may improve this surface directly. |
| `frozen-legacy` | Existing non-Pi compatibility surface retained as historical code/reference, but not an active compatibility target. |
| `historical-reference` | Documentation or design rationale that remains useful but no longer states current product direction. |
| `future-decision` | Surface that should be revisited after Pi capability mapping and context-efficiency design. |
| `validation-redesign` | Validation surface that still protects important invariants but needs redesign for Pi-native support expectations. |

## Surface Inventory

| Surface | Path(s) | Current role | Classification | Follow-up implication |
|---|---|---|---|---|
| README and install messaging | `README.md`, `install.sh`, `uninstall.sh` | Public positioning, install entry point, and runtime expectations. | `active-pi` | Keep README Pi-first. Avoid promising active Claude Code or Agent SDK parity. Clarify frozen legacy surfaces where they still install or exist. |
| Claude command wrappers | `kernel/commands/paul/*.md`, `drivers/claude-code/**` | Legacy slash-command UX and Claude Code installation surface. | `frozen-legacy` | Do not delete during Phase 192. Later phases may decide whether wrappers stay as thin historical adapters, are archived, or are removed from active install paths. |
| Pi skill/kernel surface | `drivers/pi/skills/**`, `~/.pi/agent/skills/pals/` after install | Canonical Pi skill entry points and shared kernel/resource install surface. | `active-pi` | Phase 193 should map which Pi skill-loading and resource-resolution capabilities can reduce repeated workflow/reference reads. |
| Pi extension surface | `drivers/pi/extensions/pals-hooks.ts`, `drivers/pi/extensions/README.md` | Command registration, lifecycle hooks, guided workflow UX, status/widget display, derived module visibility. | `active-pi` | Phase 193 should inventory available extension hooks, UI affordances, command routing, state access, and safe context-injection points. |
| Pi helper agents | `.pi/agents/pals-implementer.md`, installed `~/.pi/agent/agents/pals-implementer.md` | Optional task-bounded delegated APPLY helper under parent authority. | `active-pi` | Preserve parent-owned APPLY. Later phases may improve task packets or reporting but must not let helper agents own `.paul/*` lifecycle truth. |
| Agent SDK driver | `drivers/agent-sdk/**` | Proof-of-concept headless workflow driver with known hook/checkpoint/session limits. | `frozen-legacy` | Retain as reference unless a later product decision revives SDK support. Do not optimize current architecture around SDK parity. |
| Portability documentation | `docs/HARNESS-PORTABILITY.md`, `docs/PORTABILITY-ROADMAP.md` | Earlier cross-harness design notes and roadmap. | `historical-reference` | Keep artifact-first and hidden-state warnings as constraints. Mark docs as frozen reference and route current support-tier decisions here. |
| Pi validation | `tests/pi-end-to-end-validation.sh` | Current structural regression suite for Pi installer, skills, extension, module dispatch, and context-diet guardrails. | `active-pi` | Keep as primary local validation while Phase 193/194 define Pi-native architecture. May need new tests for extension/tooling-assisted context reduction. |
| Cross-harness validation | `tests/cross-harness-validation.sh` | Historical parity and shared-kernel regression suite spanning Claude Code and Pi installs. | `validation-redesign` | Continue running while it protects shared invariants, but reclassify parity checks so they do not block Pi-native design solely to preserve frozen Claude/SDK behavior. |
| Module dispatch registry/reference | `modules/*/module.yaml`, installed `modules.yaml`, `kernel/references/module-dispatch.md` | Runtime hook registry and lifecycle evidence contract for PLAN/APPLY/UNIFY. | `future-decision` | Preserve installed registry as lifecycle evidence source. Phase 194 may design Pi-assisted dispatch context loading, but module evidence must stay visible and artifact-backed. |
| Shared workflow references | `kernel/workflows/**`, `kernel/references/**`, `kernel/templates/**`, `kernel/rules/**` | Lifecycle process definitions and guardrails used by installed skills. | `future-decision` | Phase 194 should identify which hot-path reads can move into Pi-native tooling, summaries, or indexed resources without hiding authority. |
| `.paul/*` lifecycle artifacts | `.paul/STATE.md`, `.paul/PROJECT.md`, `.paul/ROADMAP.md`, `.paul/MILESTONES.md`, `.paul/phases/**` | Authoritative project state, plans, summaries, decisions, and session continuity. | `active-pi` | Never replace with opaque Pi extension state. Pi may summarize or route from artifacts, but artifacts remain the source of truth. |
| GitHub Flow gates | `pals.json`, `kernel/references/git-strategy.md`, PLAN/APPLY/UNIFY workflows | Branch, PR, CI, merge, and transition safety model. | `future-decision` | Any Pi-native UI or automation must surface the same gate evidence and must not bypass merge-gate or parent APPLY obligations. |

## Guardrails for Later Phases

- Preserve artifact-first truth: `.paul/*` remains the authoritative lifecycle state, not Pi extension memory, hidden process state, or an agent transcript.
- Preserve module evidence: lifecycle hook dispatch must emit visible `[dispatch] ...` evidence and persist required reports through PLAN/SUMMARY/STATE as specified by the shared workflows.
- Preserve GitHub Flow safety: branch, PR, CI, review, merge, and base-sync gates remain explicit when `pals.json` selects `github-flow`.
- Preserve parent-owned APPLY: delegation to `pals-implementer` stays bounded and optional; the parent workflow owns official verification, module gates, checkpoints, fallback judgment, and `.paul/*` writes.
- Avoid hidden Pi-authoritative lifecycle state: Pi can provide commands, hooks, widgets, dialogs, and context assistance, but those surfaces must derive from shared artifacts and workflow evidence.
- Classify before removing: do not delete Claude Code, Agent SDK, or cross-harness validation surfaces until a later phase records a concrete retention/removal decision.

## Recommended Next Questions

1. Which Pi extension hooks can inject compact lifecycle context before agent startup without rereading full workflow/reference files?
2. Which Pi UI affordances can replace repeated prose prompts while still sending canonical user-visible decisions through the normal workflow?
3. Can installed skill descriptions, command metadata, or custom tools expose workflow summaries without making Pi state authoritative?
4. What subset of cross-harness validation should become Pi-native validation, and what should remain only as historical frozen-legacy regression coverage?
5. Which hot-path artifacts or references should be summarized, indexed, or tool-addressable in Phase 194 without weakening module dispatch, GitHub Flow, or APPLY guardrails?
6. What explicit product decision is required before deleting or archiving Claude Code wrappers or the Agent SDK proof of concept?
