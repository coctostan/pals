# Pi Skill Map

Maps the Pi adapter's command, skill, and workflow surfaces for PALS.

## Command → Skill → Workflow Mapping

In Pi:
- `~/.pi/agent/skills/pals/` holds the shared kernel files and canonical `/skill:paul-*` entry points
- `~/.pi/agent/extensions/pals-hooks.ts` provides the user-facing `/paul-*` command layer, lifecycle hooks, and bounded shortcut UX
- `~/.pi/agent/agents/` holds project-shipped helper agents such as `pals-implementer`
- shared workflow markdown remains the implementation truth behind all three surfaces
- the extension also exposes a bounded shortcut layer for high-frequency flow entry points while still routing back through `/paul-*` wrappers
- enabled modules are installed alongside the skills and recorded in `~/.pi/agent/skills/pals/modules.yaml`; TODD/WALT remain module overlays, not standalone Pi skills
- live module visibility in the Pi status/widget is dispatch-derived from recent shared workflow/reporting output plus shared artifacts; it remains adapter-only and never becomes an authoritative Pi-owned execution ledger
- the visible lifecycle surface stays centered on milestone, phase, loop, and next action; shortcuts remain separate routing affordances rather than extra persistent panel rows
- planning-oriented wrappers surface the shared collaboration model: `planning.default_collaboration`, per-run override, `exploratory` vs `direct-requirements`, and the 4-option review menu
- delegated APPLY stays task-bounded: Pi may surface `pals-implementer`, but parent APPLY keeps verification, fallback, checkpoints, module gates, GitHub Flow decisions, task status, and `.paul/*` authority; Helper Delegation is only for eligible bounded repo-local work and is protected by `Parent-owned task packet`, `structured helper report`, `Allowed files:`, `Forbidden files:`, `Fallback triggers:`, `Parent-run official verification:`, actual `changed-file diff` review, and `Authority: Derived aid only; no helper-owned .paul/* lifecycle writes.`
- artifact-slice loading is an adapter-side context aid behind explicit `/paul-*` activation: implemented slices are `current-lifecycle-state`, `active-roadmap-phase`, and `approved-plan-task-packet`; they are source-cited, freshness-marked, bounded, read-only, disposable, labeled `Derived aid only`, and never a new skill, workflow authority, hidden Pi state, or replacement for a full authoritative read
- workflow/resource capsule loading is another adapter-side context aid behind explicit `/paul-*` activation: implemented capsules are `plan-task-anatomy`, `checkpoint-type-orientation`, `module-dispatch-evidence-orientation`, and `github-flow-phase-orientation`; they cite installed resources, expose `Source type`, freshness, bounds, full authoritative read fallback, and `Derived aid only`, and never become a new skill, workflow authority, hidden Pi state, module/validation ledger, or replacement for installed workflow/reference reads
- guided workflow UX is an adapter-side reply-routing aid, not a standalone skill or workflow authority: it may surface `plan-review`, `apply-approval`, checkpoint, resume-next, continue-to-UNIFY, phase/milestone transition, and `merge-gate-routing` prompts, but it sends canonical transcript replies only after explicit confirm/select user action; notify-only mode sends no reply, and no auto-approval, no auto-continue, no skipped checkpoints, no UI-only lifecycle decisions, and no inferred merge intent are allowed

| Pi Command | Skill Name | Kernel Workflow(s) | Canonical Entry |
|------------|------------|--------------------|-----------------|
| /paul-init | paul-init | init-project | /skill:paul-init |
| /paul-plan | paul-plan | plan-phase | /skill:paul-plan |
| /paul-apply | paul-apply | apply-phase | /skill:paul-apply |
| /paul-unify | paul-unify | unify-phase | /skill:paul-unify |
| /paul-resume | paul-resume | resume-project | /skill:paul-resume |
| /paul-status | paul-status | roadmap-management (progress) | /skill:paul-status |
| /paul-fix | paul-fix | fix-loop | /skill:paul-fix |
| /paul-pause | paul-pause | pause-work | /skill:paul-pause |
| /paul-milestone | paul-milestone | create-milestone, complete-milestone | /skill:paul-milestone |
| /paul-discuss | paul-discuss | discuss-phase, discuss-milestone | /skill:paul-discuss |
| /paul-help | paul-help | (self-contained) | /skill:paul-help |

## Artifact-Slice Context Surface

Artifact-slice loading is produced by the Pi extension after explicit `/paul-*` or `/skill:paul-*` activation. It is not a separate Pi skill, not a kernel workflow, and not a shortcut command; it is an adapter-side context aid that helps orient the active conversation.

| Slice | Orientation role |
|-------|------------------|
| `current-lifecycle-state` | Targets current `.paul/STATE.md` lifecycle position and next action. |
| `active-roadmap-phase` | Targets the active `.paul/ROADMAP.md` milestone/phase routing without broad generic keyword matches or completed-history expansion. |
| `approved-plan-task-packet` | Targets approved PLAN task names, files, verification commands, acceptance criteria, boundaries, and artifact-slice handoff markers for APPLY orientation. |

Artifact-slice targeting chooses active lifecycle, active roadmap phase/current milestone, and approved plan task-packet lines. Deterministic deduplication trims duplicate lifecycle/roadmap/plan orientation facts across the bounded PALS context payload while keeping the first cited occurrence.

These slices preserve the visible `Slice:`, `Source:`, `Freshness:`, `Bounds:`, `Content:`, `Fallback:`, and `Authority:` schema. Duplicate trimming does not remove source citations, freshness markers, fallback markers, or `Derived aid only` authority language. The slices remain source-cited, freshness-marked, bounded, read-only, disposable, and labeled `Derived aid only`. They do not create hidden Pi state, approvals, lifecycle writes, APPLY/UNIFY completion, GitHub Flow proof, helper delegation authority, guided-workflow authority, install/dependency/CI behavior, or a Pi-owned module/validation ledger.

A full authoritative read remains required before edits, approved PLAN execution, lifecycle writes, stale/ambiguous/contested facts, decisions, GitHub Flow gates, validation pass/fail, module completion, APPLY completion, or UNIFY completion. Shared workflows plus `.paul/*` artifacts remain authoritative.

## Workflow/Resource Capsule Context Surface

Workflow/resource capsule loading is produced by the Pi extension after explicit `/paul-*` or `/skill:paul-*` activation. It is not a separate Pi skill, not a kernel workflow, not a shortcut command, and not workflow authority; it is an adapter-side context aid over installed resources.

| Capsule | Orientation role |
|---------|------------------|
| `plan-task-anatomy` | Orients PLAN task anatomy from installed plan-format resources. |
| `checkpoint-type-orientation` | Orients checkpoint categories while preserving checkpoint blocking and transcript-visible user intent. |
| `module-dispatch-evidence-orientation` | Orients module-dispatch evidence conventions without replacing module reports or enforcement. |
| `github-flow-phase-orientation` | Orients GitHub Flow phase reminders without replacing git/gh command evidence. |

These capsules remain source-cited, include `Source type`, freshness-marked, bounded, read-only, disposable, and labeled `Derived aid only`. A full authoritative read remains required before approved PLAN execution, APPLY/UNIFY, lifecycle writes, checkpoints, module reports/enforcement, GitHub Flow decisions, validation assessment, stale/conflicting output, or edits/actions based on capsule content.

Validation classes: `Workflow/Resource Capsule Context — Pi-Supported Runtime` covers runtime and Pi documentation markers; `Workflow/Resource Capsule Context — Shared Invariant` covers `.paul/*` authority, PLAN/APPLY/UNIFY, checkpoint blocking, module evidence, GitHub Flow safety, parent-owned APPLY, command-output truth, STOP/DO NOT SKIP exclusion from capsule authority, and full authoritative read fallback.

Workflow/resource capsules do not create hidden Pi state, approvals, lifecycle writes, APPLY/UNIFY completion, module completion, GitHub Flow proof, validation pass/fail proof, or a Pi-owned module/validation ledger. Shared workflows, installed workflow/reference reads, `.paul/*` artifacts, transcript-visible user intent, module reports, GitHub Flow command evidence, validation command output, and parent-owned APPLY remain authoritative.
Validation Classification/report surfacing is discovery-only in Pi: docs may name Pi-Supported Runtime, Shared Invariant, Frozen Legacy Parity, Runtime Lens, Guided UI Safety, Helper Delegation, GitHub Flow Safety, and Artifact / Process, may cite the current command baseline (Pi 203/203, cross-harness 119/119), and may surface the Pi-first by default install posture with explicit `PALS_DRIVER=claude-code`, `PALS_DRIVER=agent-sdk`, and `PALS_DRIVER=all` frozen legacy/source-only opt-ins, but `.paul/*` artifacts plus fresh validation command output remain authoritative. Pi discovery must not become a hidden or Pi-owned validation ledger.

## Internal Workflows (not standalone skills)

These are invoked by other workflows and do not need their own skill entry point:

| Workflow | Invoked By |
|----------|-----------|
| transition-phase | unify-phase, complete-milestone |
| verify-work | apply-phase |
| phase-assumptions | plan-phase |
| consider-issues | unify-phase |
| configure-special-flows | init-project |
| map-codebase | init-project |
| research | plan-phase, apply-phase |
| discovery | plan-phase, apply-phase |
| debug | internal diagnostic |
| discuss-milestone | paul-discuss (context detection) |
| discuss-phase | paul-discuss (context detection) |

## Path Strategy
Skills are installed to `~/.pi/agent/skills/pals/{skill-name}/SKILL.md`.
Kernel files are installed to `~/.pi/agent/skills/pals/` with the same directory structure as the source repo kernel:
- `~/.pi/agent/skills/pals/workflows/`
- `~/.pi/agent/skills/pals/references/`
- `~/.pi/agent/skills/pals/templates/`
- `~/.pi/agent/skills/pals/rules/`
The extension is installed to Pi's extension directory — separate from the skill tree:
- `~/.pi/agent/extensions/{name}.ts` for every repo-owned `drivers/pi/extensions/*.ts` sibling — Pi extension surface (command registration, lifecycle hooks, guided workflow UX); the installer applies a source-set rule over `drivers/pi/extensions/*.ts`, currently `pals-hooks.ts` plus the Phase 239 first-spike S5 extraction `module-activity-parsing.ts` per `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md`. The uninstaller mirrors the source set and never broad-deletes unrelated Pi extensions. Driver manifest audit (Phase 241): `drivers/pi/driver.yaml` already lists `extensions/` as a directory entry under `files`, which is sufficient for multi-file extension packaging — no per-file manifest edit is required, and `driver.yaml` remains unchanged unless contrary evidence arises later.
Project-shipped helper agents are installed to Pi's agent directory:
- `~/.pi/agent/agents/pals-implementer.md` — bounded implementation worker used only when parent `/skill:paul-apply` delegates an eligible repo-local task
This means PALS uses three Pi install surfaces: skill/kernel files under `~/.pi/agent/skills/pals/`, the extension under `~/.pi/agent/extensions/`, and helper agents under `~/.pi/agent/agents/`. Removing one surface does not move lifecycle truth into Pi; shared workflows plus `.paul/*` remain authoritative, and `uninstall.sh` handles the coordinated cleanup.
Pi currently executes file reads from the project workspace, so the Pi installer materializes canonical skill references as absolute install-root paths inside the installed `SKILL.md` files. Source-controlled Pi skills still use portable `../...` references, but the installed copies resolve to paths like:
- Workflows: `~/.pi/agent/skills/pals/workflows/{name}.md`
- References: `~/.pi/agent/skills/pals/references/{name}.md`
- Templates: `~/.pi/agent/skills/pals/templates/{name}.md`
- Rules: `~/.pi/agent/skills/pals/rules/{name}.md`
- Module registry: `~/.pi/agent/skills/pals/modules.yaml`

`pals-implementer` is not a second APPLY authority. It exists so parent APPLY can offload an eligible bounded repo-local task or sequential task step and then resume parent-owned verification and lifecycle handling.

Helper Delegation must remain parent-authoritative: parent APPLY creates the task packet, lists allowed/forbidden files, reviews the structured helper report, compares reported files with the actual changed-file diff, reruns official verification, dispatches module gates, handles fallback/checkpoints/GitHub Flow decisions, and writes lifecycle artifacts. Helper output is review input, not command-output truth.

Enabled module manifests are materialized into `~/.pi/agent/skills/pals/modules.yaml` during install. PLAN/APPLY/UNIFY then use that registry to decide which module hook semantics to dispatch from shared markdown references. This is how Pi loads TODD/WALT today: as installed module overlays, not separate `/skill:*` entries, and the installed Pi skills point at that registry via absolute install-root paths rather than repo-local lookup.
That same shared workflow/reporting contract now powers bounded live module visibility in the Pi status/widget. The extension only derives a recent module activity snapshot from canonical signals such as `[dispatch] ...` and `Module Execution Reports`; it does not persist its own module history or claim authoritative proof independently of shared artifacts.

## Shortcut-Enabled Entry Points

The Pi extension exposes a small shortcut layer for the visible lifecycle surface. The persistent lifecycle surface itself stays centered on milestone, phase, loop, and next action:
- `Ctrl+Alt+N` → current next action
- `Ctrl+Alt+S` → `/paul-status`
- `Ctrl+Alt+R` → `/paul-resume`
- `Ctrl+Alt+H` → `/paul-help`
- `Ctrl+Alt+M` → `/paul-milestone`

These shortcuts are discovery and routing affordances only, not extra persistent panel rows. They remain adapter-only and preserve `/skill:paul-*` as the canonical entry layer.
## Collaboration Flow Notes

Planning-oriented Pi entry points stay aligned with shared workflow truth:
- `init`, `discuss`, `milestone`, and `plan` all respect `planning.default_collaboration`
- each run may keep the default or override it to `low`, `medium`, or `high`
- planning runs explicitly distinguish `exploratory` vs `direct-requirements`
- Pi guided workflow UX may surface the review menu (`Quick recap`, `Detailed recap`, `Full plan`, `No review needed`) but still sends canonical numeric replies through normal message flow only after explicit confirm/select user action; UI state alone is not lifecycle evidence

## Design Decisions

- **11 skills, not 21**: Only user-facing commands become skills. Internal workflows are invoked by the skill's instructions.
- **Progressive disclosure**: Pi loads name+description at startup, full SKILL.md on demand. Keep descriptions concise (under 1024 chars).
- **No @ syntax**: Pi has no @ file references. Skills use "Read file X" instructions.
- **Plain text interaction**: Skill behavior stays plain-text-first even though the extension may use lightweight Pi notifications for command guidance.

---
*Created: 2026-03-14 — Phase 49, v2.1 Pi Runtime Integration*
