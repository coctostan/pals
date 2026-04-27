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
