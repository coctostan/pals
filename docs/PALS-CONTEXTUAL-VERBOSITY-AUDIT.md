# PALS Contextual Verbosity Audit

Phase 230 baseline for v2.54 Contextual Verbosity Paring.

## Scope

Audited surfaces:

- Workflow/process guidance: `kernel/workflows/*.md`, `kernel/references/*.md`
- Pi skills: `drivers/pi/skills/*/SKILL.md`
- Module surfaces: `modules/*/module.yaml`, `modules/*/references/*.md`
- Lifecycle artifacts and session output: `.paul/STATE.md`, `.paul/ROADMAP.md`, `.paul/PROJECT.md`, `.paul/SPECIAL-FLOWS.md`, PLAN/APPLY/UNIFY replies
- User-facing docs/readme surfaces where they shape normal agent behavior
- Validation/evidence output expectations from `tests/*.sh`

Out of scope for Phase 230:

- Editing workflows, skills, modules, runtime files, validation scripts, dependency files, or GitHub Flow behavior
- Reducing approval gates, module evidence, validation truth, PR/CI safety, parent-owned APPLY checks, or `.paul/*` artifact authority
- Treating line count alone as waste; some verbosity is evidence-bearing and must stay visible

## Rubric

| Category | Definition | Default action |
|----------|------------|----------------|
| Required evidence | Output needed to prove lifecycle state, approvals, module dispatch, validation, GitHub Flow readiness, parent APPLY authority, or source/scope accounting. | Keep, but format compactly. |
| Useful context | Information that helps the next agent/user act correctly but is not itself proof. | Pare to the minimum needed for the next action. |
| Wasteful / redundant verbosity | Repeated explanations, full templates when a pointer is enough, broad option lists, decorative banners, duplicate hook mechanics, or restated policy that does not affect the current decision. | Pare or move behind an explicit request. |
| Deferred complexity | Verbose surfaces that are large but risky to change without a dedicated plan. | Defer with a narrow follow-up target. |

## Baseline Inventory

Measured APPLY-time inventory from repo files:

| Surface | Files | Lines | Verbosity signals |
|---------|-------|-------|-------------------|
| `kernel/workflows/*.md` | 21 | 7,754 | 125 display/option blocks, 96 numbered options, 74 bash blocks, 105 long lines |
| `kernel/references/*.md` | 19 | 3,904 | 12 bash blocks, 55 long lines |
| `drivers/pi/skills/*/SKILL.md` | 13 | 363 | Thin overall; 5 display/option blocks and 11 long lines |
| `modules/*/module.yaml` | 20 | 1,282 | 84 `MUST` markers; dense hook descriptions |
| `modules/*/references/*.md` | 56 | 4,800 | 140 long lines; mostly domain guidance |
| `tests/*.sh` | 2 | 3,049 | Large validation output surface; evidence-bearing |

Largest current workflow/process surfaces:

- `kernel/workflows/init-project.md` — 1,039 lines
- `kernel/workflows/map-codebase.md` — 592 lines
- `kernel/workflows/apply-phase.md` — 564 lines
- `kernel/workflows/unify-phase.md` — 524 lines
- `kernel/workflows/transition-phase.md` — 506 lines

Largest module/skill surfaces:

- `modules/codi/module.yaml` — 172 lines; complex but evidence-sensitive
- `modules/dean/references/vulnerability-audit.md` — 163 lines
- `modules/dave/references/pipeline-generation.md` — 150 lines
- `modules/codi/references/codi.md` — 147 lines
- `drivers/pi/skills/paul-review/SKILL.md` — 90 lines

## Preservation Boundaries

Keep these visible even when paring verbosity:

- Explicit user approval before APPLY
- Single next action routing in resume/status/pause flows
- PLAN/APPLY/UNIFY loop state and `.paul/*` lifecycle authority
- Module dispatch evidence lines, including skip and warning cases
- Blocking module output and fix/override/stop handling
- Fresh command-output truth from validation, install, Git, PR, and CI checks
- GitHub Flow branch/PR/CI/merge safety
- Parent-owned APPLY verification, fallback judgment, task status, checkpoints, GitHub Flow gates, and lifecycle writes
- Full authoritative read fallback when Pi artifact slices or summaries are only derived aids

## Workflow / Process Findings

| Finding | Classification | Recommendation |
|---------|----------------|----------------|
| Workflow files often embed full shell recipes, display banners, and option menus inline. | Useful context mixed with redundant verbosity | Phase 231 should prefer compact call-site obligations plus reference pointers; keep exact commands only where they are required execution contracts. |
| Status/resume/milestone/plan flows repeat long interaction scaffolds. | Pare | Keep one standard output shape per workflow and avoid restating alternatives unless the user must choose. |
| APPLY and UNIFY are verbose because they carry enforcement, delegation, GitHub Flow, and module-gate authority. | Required evidence | Do not aggressively shrink authority sections; instead pare examples and repeated rationale around them. |
| `init-project.md` and `map-codebase.md` are large orientation surfaces. | Deferred complexity | Audit separately before rewriting; they likely need structure-preserving compaction, not blanket shortening. |
| Planning/review menus can cause routine answer bloat. | Pare | Default replies should show the chosen next action and only one compact review menu when a decision is required. |

## Skill Findings

| Finding | Classification | Recommendation |
|---------|----------------|----------------|
| Pi skill wrappers are already thin compared with workflows. | Keep | Preserve wrapper model; avoid moving workflow detail back into skills. |
| Some skill descriptions and command-local notes still encourage broad explanations. | Pare | Phase 232 should add a minimal-verbosity default to every PALS skill: answer first, show one next action, expand only on request or when evidence/blockers require it. |
| `paul-review` is the longest skill because review scope is broad. | Useful context | Pare framing language but preserve review dimensions and blocking/severity semantics. |
| Help/config/status skills are likely user-facing verbosity hotspots. | Pare | Make default output compact; route deeper explanation behind explicit help/detail requests. |

## Module Findings

| Finding | Classification | Recommendation |
|---------|----------------|----------------|
| Module manifests use dense `MUST` instructions to preserve enforcement semantics. | Required evidence | Do not remove blocking semantics. Phase 231/232 should only shorten duplicate wording and improve structured summaries. |
| Advisory modules can flood output with tables even when no relevant files changed. | Pare | Standardize compact skip lines for no-scope cases while preserving one visible dispatch evidence line. |
| CODI has long, precise failure-handling contracts. | Required evidence / deferred | Keep until separately refactored; CODI's partial-success and classifier-safety details are fragile. |
| Module references are numerous but mostly load-on-demand. | Useful context | Keep load-on-demand behavior; avoid copying reference prose into normal replies. |

## Lifecycle / Evidence Findings

| Finding | Classification | Recommendation |
|---------|----------------|----------------|
| `.paul/STATE.md` accumulates detailed historical phase bullets. | Useful context / deferred | Future work can compact old entries, but keep current position, loop state, decisions, git state, and session continuity hot. |
| PLAN/SUMMARY artifacts are intentionally detailed. | Required evidence | Keep artifact detail; pare conversational summaries around them instead of deleting durable evidence. |
| Validation scripts produce large output. | Required evidence | Keep command truth; human-facing replies should summarize pass/fail counts and paths, not paste full output unless needed. |
| Workguard/source-accounting evidence can add boilerplate. | Required evidence | Show only outcome fields by default (`changed`, `outside_allowed`, `over_budget`, report path); expand on failure. |

## Phase 231 Inputs

Prioritized process/workflow work:

1. Add a shared contextual-verbosity rule to workflow references: concise by default, expand for blockers, evidence failures, explicit review, or user request.
2. Pare workflow reply templates to one next action and compact evidence summaries.
3. Centralize repeated review/menu/banner language so workflows reference one terse pattern.
4. Add compact skip/evidence output guidance for module dispatch call sites.
5. Leave APPLY/UNIFY authority sections intact unless a change preserves approval, verification, module, and GitHub Flow semantics verbatim.

## Phase 232 Inputs

Prioritized skill work:

1. Update every `drivers/pi/skills/*/SKILL.md` with a minimal-verbosity default.
2. Preserve canonical workflow links and command-local guardrails; remove explanatory filler from skill wrappers.
3. Ensure resume/status/milestone/help skills present exactly one next action by default.
4. Keep `paul-review` thoroughness available, but make the wrapper concise and defer detailed review prose to the referenced prompt/checklist.
5. Validate installed skill wrappers remain thin and still point to authoritative workflow files.

## Keep / Pare / Defer Summary

| Keep | Pare | Defer |
|------|------|-------|
| Approval gates, module evidence, validation truth, GitHub Flow gates, parent APPLY authority, `.paul/*` truth | Repeated banners, repeated option menus, copied template blocks, conversational restatements, no-scope module noise | Deep compaction of `init-project.md`, `map-codebase.md`, CODI manifest complexity, validation-script size debt |

## Verification Notes

Phase 230 should verify this artifact with focused marker checks, existing Pi and cross-harness validation when feasible, and changed-file scope checks. Any later implementation phase should treat this audit as input, not authority to weaken lifecycle safeguards.
