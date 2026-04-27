# Pi Runtime Capability Map

## Source Inputs

This map translates Phase 192's Pi-native support inventory into the Pi runtime primitives that are usable or relevant for later v2.45 architecture work.

| Source | Role in this map |
|---|---|
| `docs/PI-NATIVE-SUPPORT-INVENTORY.md` | Support-tier source of truth: Pi is supported; Claude Code and Agent SDK are frozen legacy or historical reference; `.paul/*` remains authoritative. |
| `drivers/pi/driver.yaml` | Declares Pi driver capabilities: `workflow_invoke`, `hook_register`, `state_read`, `state_write`, `user_interact`, and `command_register`. |
| `drivers/pi/extensions/README.md` | Documents the Pi command model, lifecycle hooks, guided workflow UX, live module visibility, CARL session boundaries, install surfaces, and guardrails. |
| `drivers/pi/skill-map.md` | Maps `/paul-*` commands to canonical `/skill:paul-*` skills, shared workflows, installed paths, shortcuts, module registry resolution, and helper-agent boundaries. |
| `drivers/pi/extensions/pals-hooks.ts` | Current implementation source for command registration, lifecycle UI, bounded context injection, guided workflow detection, module activity display, and CARL session management. |
| `.pi/agents/pals-implementer.md` and installed helper-agent surface | Optional task-bounded APPLY helper surface used only under parent workflow authority. |
| `pals.json` | Project configuration for GitHub Flow, guided workflow auto-present behavior, CARL thresholds, and helper-agent enablement. |

## Capability Classification Legend

| Classification | Meaning |
|---|---|
| `usable-now` | Implemented and safe to use under the current artifact-first workflow contract. |
| `design-candidate` | Existing primitive that can support Phase 194 architecture work, but needs design before becoming a stronger runtime-assistance surface. |
| `guardrail-only` | Capability should constrain or surface workflow safety rather than execute lifecycle decisions on its own. |
| `validation-redesign` | Current validation still protects useful invariants, but Pi-native architecture work should redesign what it checks or how it is exercised. |
| `out-of-scope` | Not a Phase 193/194 implementation target, or intentionally frozen because it belongs to legacy/non-Pi surfaces. |

## Runtime Capability Inventory

| Capability | Repo surface(s) | Current behavior | Classification | Lifecycle implication |
|---|---|---|---|---|
| Command registration | `drivers/pi/driver.yaml`; `drivers/pi/extensions/pals-hooks.ts`; `drivers/pi/extensions/README.md` | Pi registers `/paul-*` commands and routes them through extension handlers. | `usable-now` | Gives Pi a native entry layer for lifecycle actions without redefining shared workflow semantics. |
| Canonical skill routing | `drivers/pi/extensions/pals-hooks.ts`; `drivers/pi/skill-map.md`; installed `~/.pi/agent/skills/pals/{skill}/SKILL.md` | Each `/paul-*` wrapper sends the corresponding `/skill:paul-*` command; skills then load shared workflow markdown. | `usable-now` | Keeps `/skill:paul-*` and shared workflows as implementation truth while Pi improves command discovery and activation. |
| Installed kernel/resource resolution | `drivers/pi/install.sh`; `drivers/pi/skill-map.md`; installed `~/.pi/agent/skills/pals/workflows/**`, `references/**`, `templates/**`, `rules/**` | Installer materializes shared kernel resources into Pi's skill tree and rewrites installed skill references to absolute install-root paths. | `usable-now` | Allows Pi skills to load canonical resources reliably while preserving source-controlled shared workflows as the portable lifecycle contract. |
| Installed `modules.yaml` registry | `drivers/pi/install.sh`; installed `~/.pi/agent/skills/pals/modules.yaml`; `kernel/references/module-dispatch.md` | Enabled module overlays are materialized into an installed registry with hook metadata, priority, descriptions, and refs. | `usable-now` | PLAN/APPLY/UNIFY can dispatch module guidance from the registry and persist visible evidence without exposing TODD/WALT/etc. as standalone Pi skills. |
| Lifecycle status/widget | `pals-hooks.ts` `parsePalsState`, `renderLifecycleStatus`, `renderLifecycleWidget`, `syncLifecycleUi`; `.paul/STATE.md` | Pi reads `.paul/STATE.md` and shows milestone, phase, loop marks, next action, and bounded module activity in status/widget surfaces. | `usable-now` | Improves orientation and reduces repeated status reads, but display remains derived from authoritative artifacts. |
| Shortcut-enabled entry points | `drivers/pi/extensions/README.md`; `drivers/pi/skill-map.md`; `pals-hooks.ts` shortcut handlers | `Ctrl+Alt+N/S/R/H/M` routes to next action, status, resume, help, or milestone commands. | `usable-now` | Speeds common lifecycle entry without adding persistent workflow state or alternate semantics. |
| Bounded context injection | `pals-hooks.ts` `before_agent_start`, `buildPalsContextPayload`, `context` hook; `.paul/STATE.md` | Explicit `/paul-*` or `/skill:paul-*` activation triggers one bounded hidden context payload containing state authority, activation signal, phase, loop, next action, and parent-APPLY reminder. | `design-candidate` | Current behavior is safe and small; Phase 194 can evaluate richer artifact/tool-assisted loading if `.paul/*` remains authoritative and injection stays bounded. |
| Supporting context trimming | `pals-hooks.ts` `context` hook, `keepOnlyLatestPalsContextMessage`, legacy context marker handling | Pi removes legacy/duplicate PALS context messages and keeps only the latest recognized PALS context payload. | `usable-now` | Reduces context pollution without changing workflow decisions or lifecycle artifacts. |
| Guided workflow UX | `pals-hooks.ts` `detectGuidedWorkflowMoment`, `presentGuidedWorkflowMoment`; `pals.json` `guided_workflow.auto_present`; extension README | Pi recognizes canonical workflow prompts such as plan review, APPLY approval, checkpoints, resume next, and continue-to-UNIFY, then may show `notify`, `confirm`, or `select` UI and send canonical user replies. | `guardrail-only` | Can reduce prompt friction, but must never auto-continue, skip checkpoints, or treat UI state as lifecycle truth. |
| Live module visibility | `pals-hooks.ts` module activity parsers/renderers; `Module Execution Reports`; `[dispatch] ...` lines | Pi derives recent module activity from shared workflow output or summary reports and shows a bounded module list in the lifecycle surface. | `usable-now` | Improves visibility of module activity while proof remains dispatch/report evidence in PLAN/SUMMARY/STATE. |
| CARL session boundaries | `pals-hooks.ts` `loadCarlConfig`, `carlMonitorSafetyCeiling`, `carlEvaluatePhaseCompletion`, `buildCarlBootstrapPrompt`; `pals.json` `modules.carl` | Pi monitors loop signatures and context pressure, then can create a fresh session and bootstrap `/skill:paul-resume` at phase completion or safety boundary. | `usable-now` | Supports autonomous session continuity, but resume routing still depends on `.paul/STATE.md` and handoff artifacts. |
| Helper-agent delegation | `.pi/agents/pals-implementer.md`; `drivers/pi/skill-map.md`; apply workflow; `pals.json` `agents.implementer` | Parent APPLY may delegate eligible bounded repo-local auto tasks to `pals-implementer`, then inspects, verifies, and owns fallback and `.paul/*` writes. | `guardrail-only` | Delegation can reduce parent context pressure, but the parent workflow remains the authoritative APPLY executor and verifier. |
| User interaction | `drivers/pi/driver.yaml`; `pals-hooks.ts` UI `notify`, `confirm`, `select`; guided workflow config | Pi can present native notifications and lightweight choices for canonical workflow moments. | `design-candidate` | Useful for Phase 194 prompt/UI reduction, as long as canonical user-visible replies still flow through shared workflow prompts. |
| State read/write capability | `drivers/pi/driver.yaml`; `.paul/STATE.md`; shared workflows; `pals-hooks.ts` read-only status/context derivation | Driver declares read/write, but current extension behavior primarily reads shared artifacts; shared workflows perform authoritative lifecycle writes. | `guardrail-only` | Pi may read artifacts for status/routing; authoritative writes should stay in PLAN/APPLY/UNIFY workflows unless a future design makes writes explicit, auditable, and artifact-backed. |
| Shell/tool execution via parent workflows | Shared workflow markdown; Pi agent tool surface; apply/unify verification steps | Pi provides the agent harness/tool environment; workflows decide which project commands, validations, git commands, and edits run. | `guardrail-only` | Runtime tools are execution means, not workflow authority. The parent workflow owns command selection, verification, module gates, and fallback decisions. |
| GitHub Flow surfacing | `pals.json`; `kernel/references/git-strategy.md`; resume/status/apply/unify workflows; Pi status/next-action surfaces | Workflows enforce branch, PR, CI, review, merge, and base-sync rules; Pi can surface current branch/next action and route commands. | `guardrail-only` | Pi UI or shortcuts must not bypass branch/PR/CI/merge gates or hide merge-gate evidence. |
| Validation/CI surfacing | `tests/pi-end-to-end-validation.sh`; `tests/cross-harness-validation.sh`; GitHub Flow CI config/state | Pi validation is active; cross-harness validation remains useful but partly frozen-legacy/parity-oriented. | `validation-redesign` | Phase 194/195 should keep invariant protection while redesigning checks around Pi-native runtime assistance rather than Claude parity. |
| Claude Code and Agent SDK runtime parity | `drivers/claude-code/**`; `kernel/commands/paul/*.md`; `drivers/agent-sdk/**`; portability docs | Existing non-Pi compatibility files remain reference/frozen surfaces, not active support targets. | `out-of-scope` | Later phases may decide retention/removal, but Phase 193 mapping should not optimize around preserving active parity. |

## Lifecycle Mapping

Pi runtime primitives are most useful when they make the existing lifecycle easier to follow, not when they replace lifecycle ownership. The shared markdown workflows and `.paul/*` artifacts remain the authority boundary for every lifecycle surface below.

| Lifecycle surface | Useful Pi primitive(s) | Allowed assistance | Must remain authoritative outside Pi |
|---|---|---|---|
| PLAN | `/paul-plan` command registration; canonical `/skill:paul-plan` routing; installed workflow/resource resolution; bounded context injection; guided planning review UI | Route users into the canonical planning skill, inject compact state context after explicit activation, surface the review menu, and reduce repeated discovery prose. | PLAN.md content, acceptance criteria, module-dispatch evidence, approval gating, and `.paul/STATE.md` loop updates remain workflow/artifact-owned. |
| APPLY | `/paul-apply` routing; helper-agent discovery; tool execution in parent workflow; guided checkpoint and continue prompts | Execute approved tasks through the parent workflow, optionally delegate bounded repo-local work to `pals-implementer`, and use Pi UI for canonical checkpoint responses. | Parent APPLY owns official verification, fallback, checkpoints, module enforcement, task results, and `.paul/*` lifecycle writes. |
| UNIFY | `/paul-unify` routing; guided continue-to-UNIFY prompt; module report visibility; GitHub Flow gate surfacing | Route from APPLY completion into reconciliation, show recent module activity, and surface merge/CI state for awareness. | SUMMARY.md creation, AC result reconciliation, post-unify module persistence, STATE/ROADMAP updates, and merge-gate decisions remain shared-workflow-owned. |
| Module dispatch | Installed `modules.yaml`; hook refs; live module visibility from `[dispatch]` and `Module Execution Reports` | Resolve enabled hook guidance from installed registry, display bounded recent module activity, and keep skip/warning evidence visible. | The installed registry and workflow-dispatched reports remain evidence truth; Pi must not keep an independent module execution ledger. |
| GitHub Flow | Status/next-action UI; command shortcuts; `pals.json` git config surfaced through workflows | Surface branch/base/PR/CI state and route the next canonical command. | Branch creation, push, PR creation, CI handling, review checks, merge gate, base sync, and branch cleanup remain workflow/git evidence owned. |
| Session continuity and handoffs | CARL session boundary manager; bootstrap prompt; `/paul-resume` routing; `.paul/STATE.md` parsing | Detect phase-complete or safety-boundary moments, create a fresh session, bootstrap current state, and route immediately to resume. | `.paul/STATE.md`, active/archived handoff files, resume routing, and consumed-handoff lifecycle remain authoritative artifacts/workflow responsibilities. |
| Context injection and compaction | `before_agent_start` bounded payload; supporting `context` hook; duplicate context trimming | Inject one compact state payload after explicit PALS activation and remove stale duplicate PALS context messages. | Full workflow interpretation, artifact reads, plan/task decisions, and persistent context summaries must remain visible and artifact-backed. |
| Delegated APPLY | Installed `pals-implementer` agent; parent-owned task packet; result report | Offload clear bounded repo-local auto tasks when parent can inspect equivalent output and run official verification. | Parent workflow owns eligibility, task packet scope, file-scope review, official verification, module gates, fallback, checkpoints, and `.paul/*` writes. |
| User interaction | Pi `notify`, `confirm`, and `select`; shortcut layer; guided workflow moment detection | Reduce typing and improve timing for canonical prompts such as APPLY approval, checkpoint decisions, human verification, and continue-to-UNIFY. | User intent must still be explicit and sent as canonical workflow replies; Pi UI must not silently continue or infer approval. |

### Lifecycle Guardrails

- `.paul/*` artifacts remain the lifecycle source of truth; Pi extension memory, UI state, context messages, and helper-agent transcripts are derived aids only.
- PLAN/APPLY/UNIFY retains the authoritative loop: define and approve work, execute and verify work, then reconcile and persist results.
- Module evidence stays visible through `[dispatch] ...` lines and durable reports; live module visibility is only a display of those shared signals.
- GitHub Flow gates cannot be bypassed by Pi shortcuts, UI automation, or next-action routing.
- Parent APPLY owns verification, fallback, checkpoint handling, module enforcement, and lifecycle artifact writes even when `pals-implementer` helps with bounded implementation.

## Phase 194 Design Inputs

The current Pi runtime already has enough primitives to support a context-efficiency architecture, but the next phase should design explicit boundaries before increasing automation.

| Design input | Candidate opportunity | Boundary to preserve |
|---|---|---|
| Artifact-indexed context loading | Let Pi or a Pi-adjacent tool load compact slices of `.paul/STATE.md`, active ROADMAP sections, PLAN/SUMMARY artifacts, and installed workflow refs on demand instead of repeatedly injecting long prose. | Tool output must cite artifact paths and never become hidden memory. |
| Command-aware activation | Use explicit `/paul-*` or `/skill:paul-*` activation as the strongest signal for bounded PALS context payloads. | No ambient broad context injection for unrelated prompts. |
| Workflow-summary resources | Expose short, canonical summaries of PLAN/APPLY/UNIFY and module dispatch semantics from installed resources. | Summaries must point back to shared workflow/reference files and cannot override them. |
| Guided workflow responses | Use Pi `confirm`/`select` to reduce friction at known canonical prompts. | Every continuation must still be an explicit canonical user reply. |
| Module-dispatch assistance | Use installed `modules.yaml` metadata to present hook-local guidance and recent module evidence compactly. | PLAN/SUMMARY/STATE remain the durable evidence destinations; Pi must not keep a separate module ledger. |
| Helper-agent task packets | Improve parent-owned task packet templates for `pals-implementer` and structured result checks. | Parent APPLY still owns eligibility, verification, fallback, and lifecycle writes. |
| GitHub Flow status surfacing | Surface branch/PR/CI/readiness in status and guided next-action displays. | Merge-gate enforcement and CI failure handling stay in shared workflows. |
| Session continuity | Use CARL bootstrap prompts plus archived handoffs to reduce fresh-session reloading. | Resume always reads `.paul/STATE.md` first and treats handoff files as context, not authority over newer state. |

### Open Design Questions

1. Which artifact slices should be tool-addressable by name, and which should remain normal markdown reads?
2. Should Pi expose a dedicated lifecycle-context tool, or should installed skills keep using ordinary file reads with better summaries?
3. How can guided workflow UI prove that user approval was explicit and canonical in transcripts/artifacts?
4. What module evidence should appear in the status/widget versus only in PLAN/SUMMARY reports?
5. Can helper-agent reports be made machine-checkable enough to reduce parent review context without weakening parent verification?
6. Which validation checks should become Pi-native runtime behavior tests rather than cross-harness parity checks?

## Validation and Redesign Notes

| Validation surface | Keep protecting | Redesign input for Pi-native architecture |
|---|---|---|
| `tests/pi-end-to-end-validation.sh` | Pi install structure, skill wrapper shape, extension command/hook surfaces, module registry generation, lifecycle UI markers, context-diet guardrails, and bounded helper-agent language. | Add checks for any Phase 194 context-loading tools, artifact-slice outputs, guided UI behavior, and explicit authority boundaries. |
| `tests/cross-harness-validation.sh` | Shared kernel invariants, module evidence contract, artifact spec basics, GitHub Flow guardrails, and context-diet ceilings that remain harness-independent. | Reclassify or retire checks whose only purpose is active Claude Code parity; keep shared-invariant checks that still protect Pi. |
| GitHub Flow CI/status checks | PR readiness, CI state, and merge-safety visibility. | If Pi surfaces richer PR state, tests should assert that UI/status cannot bypass workflow merge gates. |
| Module-dispatch validation | Installed registry metadata, hook refs, and durable report markers. | If Pi adds compact module guidance, validate it derives from installed `modules.yaml` and still emits workflow evidence. |
| CARL/session validation | Fresh-session bootstrap and resume routing from state/handoff artifacts. | Validate safety-boundary and phase-boundary behavior without depending on hidden Pi state. |

Validation should move from "Pi plus cross-harness parity" toward "Pi-supported runtime plus shared invariant protection." Cross-harness checks can remain during the transition, but they should not block a Pi-native design solely because a frozen legacy surface does not receive equivalent new behavior.

## Non-Goals for Phase 193

- Do not implement new Pi commands, hooks, tools, dialogs, context compaction, or lifecycle UI behavior.
- Do not edit `drivers/pi/extensions/pals-hooks.ts`, installed skills, shared workflows, module references, validation scripts, or GitHub Flow mechanics.
- Do not move lifecycle authority from `.paul/*` artifacts into Pi extension state, helper agents, UI widgets, or hidden context messages.
- Do not delete, archive, or redesign Claude Code, Agent SDK, portability, or cross-harness files in this phase.
- Do not decide the final Phase 194 architecture; this map only supplies inputs and guardrails.

## Recommended Next Questions

1. What is the smallest Pi-native context-efficiency architecture that reduces hot-path reads while preserving explicit artifact citations?
2. Should Phase 194 prioritize lifecycle-context tools, installed resource summaries, guided UI, helper-agent packet improvements, or validation redesign first?
3. Which current repeated reads are pure orientation cost and safe to replace with Pi-derived summaries?
4. Where must the model still read the full authoritative markdown because summarization would hide important lifecycle semantics?
5. How should PALS record Pi-assisted context decisions in PLAN/SUMMARY artifacts so future sessions can audit what happened?
6. Which frozen legacy surfaces should remain untouched until the final v2.45 proposal, and which should receive explicit retention/removal options?
