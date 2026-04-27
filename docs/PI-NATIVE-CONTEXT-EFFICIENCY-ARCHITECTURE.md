# Pi-Native Context-Efficiency Architecture

## Source Inputs

| Source | Role in this architecture |
|---|---|
| `docs/PI-RUNTIME-CAPABILITY-MAP.md` | Primary Phase 193 input: classifies current Pi runtime capabilities, lifecycle mappings, guardrails, and Phase 194 design questions. |
| `docs/PI-NATIVE-SUPPORT-INVENTORY.md` | Support-tier source: Pi is the active supported runtime; Claude Code and Agent SDK are frozen legacy; `.paul/*` artifacts remain authoritative. |
| `.paul/phases/193-pi-runtime-capability-mapping/193-01-SUMMARY.md` | Immediate prior-phase reconciliation: records the decision that Pi runtime assistance must stay derived, bounded, and artifact-backed. |
| `kernel/references/context-management.md` | Current hot/warm/cold read guidance, context brackets, active ROADMAP window convention, and plan sizing heuristics. |
| `docs/REFERENCE-RESOLUTION.md` | Portable reference model for project artifacts, kernel resources, and module resources. |
| `drivers/pi/skill-map.md` | Pi command, skill, workflow, module registry, helper-agent, and resource-install surface map. |
| `drivers/pi/extensions/README.md` | Pi command model, guided workflow UX, lifecycle hooks, live module visibility, CARL session boundaries, and installation boundaries. |
| `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/PROJECT.md`, `.paul/phases/**` | Authoritative lifecycle artifacts that Pi may summarize or route from, but never replace. |
| Installed `modules.yaml` and `kernel/references/module-dispatch.md` | Runtime module registry and evidence contract for PLAN/APPLY/UNIFY dispatch. |

## Design Problem

PALS has already reduced recurring context cost by archiving cold history, compacting active lifecycle artifacts, and centralizing repeated workflow prose. Phase 194 addresses the next layer: Pi can assist with repeated orientation, routing, and artifact/resource lookup at runtime, but only if those assists remain explicitly derived from shared artifacts and workflow evidence.

The repeated costs are:

- **Prompt cost:** slash command wrappers, skill wrappers, and lifecycle prompts repeatedly restate routing and guardrail prose.
- **Workflow cost:** PLAN/APPLY/UNIFY workflows must stay authoritative, but every run currently re-loads enough workflow prose for the model to orient itself.
- **Artifact cost:** STATE, PROJECT, ROADMAP, PLAN, SUMMARY, and handoff artifacts are markdown truth, but fresh sessions often reread overlapping slices.
- **Module-dispatch cost:** module registry metadata, hook refs, and `[dispatch] ...` evidence are necessary, but the model repeatedly reconstructs which modules matter.
- **GitHub Flow cost:** branch, PR, CI, review, merge, and base-sync gates must remain visible but should not require repeated prose expansion when status can be derived.
- **Session continuity cost:** CARL bootstrap, handoffs, and resume context reduce loss across sessions, but stale or duplicate context must not become hidden state.
- **Helper-agent review cost:** delegated APPLY can reduce parent model context during bounded tasks, but parent review and official verification still need compact, inspectable evidence.

The architecture goal is not to hide these sources. It is to make Pi load, summarize, display, or route from them in smaller, cited slices so the model spends context on current work rather than repeatedly rediscovering lifecycle state.

## Context-Cost Surface Model

| Surface | Temperature | Cost driver | Current source | Safe reduction path | Authority boundary |
|---|---|---|---|---|---|
| Current lifecycle state | Hot | Every lifecycle action needs phase, loop marks, plan path, next action, blockers, and current decisions. | `.paul/STATE.md` | Pi may inject or display a bounded state slice after explicit PALS activation. | `.paul/STATE.md` remains authoritative; injected/displayed state must cite it and be refreshable. |
| Active milestone routing | Hot/warm | ROADMAP identifies current phase and near-future scope, but completed history is cold. | `.paul/ROADMAP.md`; roadmap archives | Keep current milestone and phase detail inline; use Pi status/next-action surfaces for routing hints. | ROADMAP remains the planning route; Pi must not infer phase transitions independently. |
| Project constraints and decisions | Warm | PROJECT contains current product posture and constraints; full history lives in archives. | `.paul/PROJECT.md`; `.paul/archive/project/**` | Use PROJECT as the hot brief and open archives only for concrete dependencies. | Pi summaries cannot override current PROJECT decisions or archive authority. |
| Approved plan execution packet | Hot during APPLY | APPLY needs tasks, acceptance criteria, boundaries, files, and verification commands. | `.paul/phases/**/{plan}-PLAN.md` | Pi may surface task-local slices and checkpoint prompts. | PLAN.md remains the approved executable prompt; task boundaries and verification stay parent-owned. |
| Prior results | Warm | New phases often need immediate prior decisions but not full prior plans. | Prior `SUMMARY.md` files | Prefer SUMMARY over prior PLAN; show concise phase handoff slices. | SUMMARY is reconciliation truth; Pi must preserve path citations. |
| Shared workflow semantics | Hot/warm | Skills need enough PLAN/APPLY/UNIFY rules to act safely. | Installed `workflows/**`, `references/**`, `templates/**` | Expose short installed workflow/resource capsules that point back to full files. | Full shared workflow markdown remains the semantic authority when there is ambiguity. |
| Module dispatch | Hot during hooks | Hook ordering, refs, evidence, and gate outcomes recur in every loop. | Installed `modules.yaml`; module refs; PLAN/SUMMARY reports | Pi may render hook-local summaries and recent module activity derived from `[dispatch]` lines and reports. | Installed registry and durable PLAN/SUMMARY reports remain evidence truth; no Pi-owned module ledger. |
| GitHub Flow gates | Hot at APPLY/UNIFY/status | Branch/PR/CI/readiness state is repetitive but safety-critical. | `pals.json`, git/gh state, `kernel/references/git-strategy.md` | Pi may show current branch/PR/CI status and route the next canonical action. | Shared workflow and git/PR evidence own merge gates; Pi must not bypass or auto-merge. |
| Guided workflow prompts | Hot at user decision points | The same APPLY approval, review menu, checkpoint, and UNIFY continuation prompts recur. | Shared workflow output; `.paul/STATE.md`; Pi guided UX | Pi may present `confirm`/`select` UI and send canonical replies. | User intent must remain explicit and visible in transcript/artifacts. |
| Session continuity | Hot at fresh-session boundary | Fresh sessions need enough context to resume without rereading everything. | `.paul/STATE.md`; active/archived handoffs; CARL bootstrap | CARL may bootstrap compact context and route `/skill:paul-resume`. | Resume reads STATE first; handoffs are context, not authority over newer state. |
| Helper-agent delegation | Hot during bounded implementation | Parent context can be consumed by mechanical file edits, but parent must still review. | PLAN task packet; `pals-implementer` report; git diff; verification output | Use structured task packets and compact result reports. | Parent APPLY owns eligibility, verification, fallback, module gates, checkpoints, and `.paul/*` writes. |
| Validation surfaces | Warm/hot at gates | Existing Pi and cross-harness scripts are large but protect important invariants. | `tests/pi-end-to-end-validation.sh`; `tests/cross-harness-validation.sh` | Keep scripts as command checks; redesign future assertions around Pi-native behavior and shared invariants. | Test output is evidence; Pi summaries cannot mark validation passed without command results. |
| Historical archives | Cold | Full history is large and rarely needed for immediate execution. | `.paul/archive/**`; `.paul/handoffs/archive/**` | Index and cite; open full archives only for concrete decision dependencies. | Archives remain authoritative historical truth, not disposable summaries. |
| Runtime-derived context lenses | Transient | Pi can derive useful slices, but hidden context can become stale or over-trusted. | Pi extension context/status/widget/hooks | Keep lenses bounded, cited, and disposable; trim duplicates. | Runtime lenses are never lifecycle state or durable evidence. |

## Non-Negotiable Guardrails

- `.paul/*` artifacts remain the lifecycle source of truth. Pi extension memory, widgets, context messages, helper-agent transcripts, and UI selections are derived aids only.
- PLAN/APPLY/UNIFY remains the authoritative loop: PLAN defines approved work, APPLY executes and verifies under parent control, and UNIFY reconciles results into durable artifacts.
- Module evidence remains visible through `[dispatch] ...` lines and durable PLAN/SUMMARY/STATE reports. Pi may display this evidence but must not keep an independent module execution ledger.
- GitHub Flow gates remain explicit. Pi shortcuts, status displays, or guided UI must not bypass branch, PR, CI, review, merge, base-sync, or cleanup rules.
- Parent APPLY owns verification, fallback, checkpoint handling, module enforcement, task result judgment, and lifecycle artifact writes even when `pals-implementer` performs bounded work.
- User approval and checkpoint decisions must remain explicit canonical replies. Pi UI can reduce friction, but must never silently continue, approve, merge, or skip human verification/action gates.
- Context injection must be activation-gated, bounded, deduplicated, and source-cited. Ambient broad PALS context injection for unrelated prompts is out of bounds.
- Full authoritative markdown reads remain required whenever a summary is ambiguous, stale, contested, or used for a decision that changes lifecycle semantics.
- Frozen legacy surfaces can be referenced for history or shared invariant protection, but Phase 194 must not optimize around active Claude Code or Agent SDK parity.
- Phase 194 is design-only: no commands, hooks, tools, dialogs, validation rewrites, dependency changes, legacy deletions, or workflow semantic changes.

## Architecture Overview

The architecture uses a layered model. Each layer may reduce context cost, but authority flows upward only from durable artifacts and workflow evidence.

```text
┌────────────────────────────────────────────────────────────┐
│ Pi presentation and routing surfaces                       │
│ status/widget, shortcuts, guided UI, bounded context lens  │
└──────────────────────────────▲─────────────────────────────┘
                               │ derived, cited, disposable
┌──────────────────────────────┴─────────────────────────────┐
│ Transient context lenses and task packets                   │
│ artifact slices, workflow capsules, module evidence lens,  │
│ GitHub Flow lens, CARL bootstrap, helper-agent reports      │
└──────────────────────────────▲─────────────────────────────┘
                               │ reads and summarizes
┌──────────────────────────────┴─────────────────────────────┐
│ Installed resources and external evidence                  │
│ workflows, references, templates, modules.yaml, git/gh,    │
│ validation command output                                  │
└──────────────────────────────▲─────────────────────────────┘
                               │ interpreted by workflows
┌──────────────────────────────┴─────────────────────────────┐
│ Authoritative project artifacts                            │
│ .paul/STATE.md, PROJECT.md, ROADMAP.md, PLAN, SUMMARY,     │
│ handoffs, archives                                          │
└────────────────────────────────────────────────────────────┘
```

The important property is reversibility: every Pi-derived context slice must be traceable back to a path, command output, or explicit user reply. If a model or reviewer cannot answer “what artifact or evidence did this come from?”, that slice is not safe enough to reduce authoritative reads.

## Assistance Components

| Component | Authoritative source | Allowed runtime assistance | Forbidden ownership | Evidence destination | Lifecycle surfaces |
|---|---|---|---|---|---|
| Artifact-indexed context loading | `.paul/STATE.md`, `.paul/PROJECT.md`, `.paul/ROADMAP.md`, active PLAN/SUMMARY files, archive indexes | Load named slices such as current loop, active phase, next action, current decisions, prior summary highlights, or active roadmap section. Return compact text with source paths. | Owning lifecycle state, inventing missing decisions, hiding stale source age, or replacing full reads for contested decisions. | Transcript output with cited paths; later PLAN/SUMMARY notes when materially used. | PLAN, APPLY, UNIFY, RESUME, STATUS |
| Workflow/resource capsules | Installed `workflows/**`, `references/**`, `templates/**`, `rules/**` | Present short summaries of hook-local obligations, task anatomy, checkpoint semantics, or GitHub Flow recipes with links to full installed resources. | Rewriting workflow semantics, silently shortening mandatory STOP/DO NOT SKIP rules, or making capsules the final source of truth. | PLAN/SUMMARY dispatch notes when used; full workflow path citations. | PLAN, APPLY, UNIFY |
| Module-dispatch evidence lens | Installed `modules.yaml`; `[dispatch] ...` lines; `Module Execution Reports`; module refs | Show active hook cohort, module order, skip/pass/block evidence, and recent module activity in a compact view. | Maintaining a separate Pi-owned ledger, marking hooks complete without workflow evidence, or bypassing module refs. | PLAN `<module_dispatch>` and SUMMARY `Module Execution Reports`. | PLAN, APPLY, UNIFY, STATUS |
| Guided workflow reply UI | Shared workflow prompts; `.paul/STATE.md`; user interaction transcript | Convert known prompts into Pi `confirm`/`select` affordances and send exact canonical replies such as `1`, `approved`, `yes`, or selected option id. | Auto-continuing, approving, skipping checkpoints, hiding user intent, or creating UI-only decisions. | Visible transcript reply; relevant STATE/SUMMARY decision rows for checkpoint decisions. | PLAN review, APPLY approval, checkpoints, continue-to-UNIFY |
| GitHub Flow status lens | `pals.json`; git branch/ahead-behind state; `gh pr` state; `kernel/references/git-strategy.md` | Display branch, base, PR URL/state, CI state, and one next canonical action. | Creating merge-anyway paths, hiding failing CI, treating UI readiness as merge authorization, or skipping base-sync. | Git command output, PR URL/state, STATE Git State, SUMMARY merge-gate report. | APPLY preflight/postflight, UNIFY merge gate, RESUME/STATUS |
| CARL/session continuity lens | `.paul/STATE.md`; handoff files; CARL bootstrap prompt; `pals.json` CARL config | Bootstrap fresh sessions with bounded state, route `/skill:paul-resume`, and identify whether a handoff is active or archived. | Treating handoff content as newer than STATE, persisting hidden session memory as truth, or skipping resume workflow. | STATE Session Continuity; archived handoff lifecycle; transcript bootstrap. | RESUME, PAUSE, phase boundary, safety boundary |
| Helper-agent task packet/report compression | Approved PLAN task; parent APPLY instructions; `pals-implementer` report; git diff; verification output | Create bounded task packets, require structured reports, and summarize changed files/commands/verification for parent review. | Letting the helper own `.paul/*` writes, checkpoints, official verification, fallback, module gates, or APPLY completion judgment. | Parent APPLY notes; git diff; verification results; SUMMARY task/deviation report. | APPLY |
| Validation redesign hooks | Existing validation scripts; future Pi behavior tests; shared invariant checks | Surface which validations are Pi-supported, shared-invariant, or frozen-legacy parity; run commands and summarize results. | Marking validation green without command output, deleting shared invariants for convenience, or blocking Pi-native design solely for frozen parity. | Command output logs; SUMMARY verification table; WALT quality history. | APPLY, UNIFY, CI |

## Read Model and Citation Contract

### Read tiers

| Tier | Use for | Examples | Citation requirement |
|---|---|---|---|
| Full authoritative read | Decisions, edits, semantic ambiguity, plan approval, task execution, merge gates, or contested facts. | Current PLAN tasks, workflow STOP rules, STATE before lifecycle writes, GitHub Flow gate details. | Cite exact path and, when useful, section or line range. |
| Bounded artifact slice | Orientation, next-action routing, current phase summary, prior result lookup, or dispatch recap. | STATE Current Position, ROADMAP current milestone, prior SUMMARY decisions, Module Execution Reports. | Cite source path and slice label. |
| Installed resource capsule | Repeated workflow/reference reminder where the full file has stable semantics and no ambiguity. | Task anatomy, checkpoint protocol, module-dispatch evidence convention, GitHub Flow preflight summary. | Cite installed logical path and capsule version/source section. |
| Runtime lens | UI/status/context injection for low-risk orientation. | Current branch display, lifecycle widget, recent module activity, CARL bootstrap payload. | Cite source artifact or command evidence inside the lens output. |
| Cold archive lookup | Historical decisions only when a concrete dependency requires them. | Archived roadmap history, old handoffs, project history. | Cite archive path; do not summarize as current state unless STATE/PROJECT still agrees. |

### Citation rules

- Every Pi-assisted context output should include `Source:` or equivalent path citations for artifact-derived claims.
- Runtime lenses should include freshness markers when the source can change during the session, especially git/PR/CI state and STATE loop position.
- If the model will edit a file, it must read that file normally and use anchored edits where available; a summary is not enough.
- If a summary conflicts with an artifact, trust the artifact and record the discrepancy for UNIFY or STATE repair.
- If a user decision changes lifecycle semantics, record it in durable artifacts through the workflow rather than relying on transcript memory.

### What can be summarized safely

- Current lifecycle orientation: milestone, phase, plan, loop marks, next action.
- Active ROADMAP current milestone and near-future phase rows.
- Prior SUMMARY accomplishments, decisions, deviations, blockers, and validation baseline.
- Installed module hook order, hook-local refs, and recent dispatch evidence.
- GitHub Flow status after running explicit git/gh commands.
- Repeated prompt menus and checkpoint reply formats, when the underlying workflow prompt is still visible.

### What still requires full markdown or command reads

- Approved PLAN tasks, boundaries, verification, and acceptance criteria before APPLY.
- Workflow instructions that include blocking behavior, override paths, or lifecycle writes.
- STATE before updating lifecycle position or resolving resume routing.
- SUMMARY/ROADMAP changes during UNIFY or phase transition.
- GitHub Flow merge gates and CI state before merge.
- Any artifact whose summary is stale, missing citations, or used for a new product/support-tier decision.

## Risks and Rejected Designs

| Rejected design | Why rejected | Safer alternative |
|---|---|---|
| Opaque Pi memory as lifecycle state | Breaks portable markdown truth and makes future sessions unauditable. | Derived lenses over `.paul/*` with path citations. |
| Telemetry-owned context engine | Moves authority into hidden runtime observations and risks privacy/scope creep. | User-visible artifact slices and command outputs only. |
| Auto-approval or auto-continue UI | Violates explicit approval and checkpoint invariants. | Guided UI sends explicit canonical replies after user choice. |
| Hidden module execution ledger | Splits evidence between Pi and PLAN/SUMMARY artifacts. | Render recent activity from installed registry plus durable reports. |
| Merge-gate bypass from status widget | Risks merging behind-base or failing-CI work. | Status lens shows one next canonical workflow action only. |
| Helper-agent-owned APPLY | Undermines parent verification, fallback, module gates, and `.paul/*` writes. | Parent-owned task packets and structured helper reports. |
| Full replacement of workflow reads with short summaries | Summaries can omit blocking semantics or edge cases. | Capsules for orientation; full reads for authority and ambiguity. |
| Active Claude Code / Agent SDK parity constraint | Conflicts with Phase 192 support-tier reset and preserves unnecessary context burden. | Preserve historical references and shared invariants; optimize Pi-supported runtime. |
