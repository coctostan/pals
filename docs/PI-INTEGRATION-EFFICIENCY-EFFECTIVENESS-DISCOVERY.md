# Pi Integration Efficiency & Effectiveness Discovery

## Status

| Field | Value |
|---|---|
| Milestone | v2.53 Pi Integration Efficiency & Effectiveness Exploration |
| Phase | 226 — Pi Integration Efficiency Discovery |
| Plan | 226-01 |
| Artifact status | Discovery input for Phase 227 candidate design |
| Implementation status | Discovery documentation only; no runtime behavior change, no validation-script change, no dependency/CI change, no GitHub Flow automation change, no helper-delegation semantic change, no install-surface change, no lifecycle-authority change, and no `.paul/*` authority change are authorized by this artifact. |

## Purpose

This artifact identifies current Pi integration efficiency and effectiveness hotspots so Phase 227 can design a bounded improvement candidate from observed friction rather than broad assumptions.

The discovery question is: **which Pi-native integration change is most likely to reduce model context burden and improve lifecycle reliability while preserving artifact-first PALS authority?**

## Source Inputs

| Source | Evidence used | Discovery relevance |
|---|---|---|
| `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` | Context-cost surface model, non-negotiable guardrails, assistance components, read/citation contract, rejected designs, and spike backlog. | Defines where repeated context is spent and what reduction paths are safe. |
| `docs/PI-NATIVE-ARCHITECTURE-PROPOSAL.md` | Target architecture, authority boundaries, promoted patterns, deferred/rejected options, and migration roadmap. | Confirms Pi may assist with context, routing, guided UX, module visibility, session continuity, and delegation only as derived aids. |
| `docs/PI-NATIVE-IMPLEMENTATION-FINDINGS.md` | Settled decisions, promoted patterns, workstream seeds, open questions, and rejected options. | Provides the existing candidate set and known implementation-readiness order. |
| `docs/PI-NATIVE-IMPLEMENTATION-WORKSTREAMS.md` | Workstream readiness, likely repo surfaces, validation expectations, dependencies, and open questions. | Helps rank hotspots by evidence readiness and implementation risk. |
| `docs/PI-NATIVE-IMPLEMENTATION-PLAN.md` | Acceptance-criteria families, validation classes, command-output evidence, durable artifact evidence, and explicit deferrals. | Supplies proof requirements for any later design or spike. |
| `drivers/pi/extensions/README.md` | Current Pi command model, guided workflow UX, artifact slices, workflow/resource capsules, live module visibility, CARL, shortcuts, and install boundaries. | Shows which integration surfaces already exist and where friction may remain. |
| `drivers/pi/skill-map.md` | Command/skill/workflow mapping, context-surface inventories, shortcut routing, collaboration flow notes, and authority notes. | Confirms current adapter surfaces and canonical routing relationships. |
| `drivers/pi/extensions/pals-hooks.ts` | Constants and type/function map for activation-gated context payloads, artifact slices, capsules, guided workflow detection, module visibility, and CARL. | Read-only implementation evidence for current surface shape; not edited in Phase 226. |
| `.paul/phases/225-evidence-reconciliation-milestone-closure/225-01-SUMMARY.md` | v2.52 closure evidence, Pi 205/205, cross-harness 121/121, command-output truth, and deferred validation-script size debt. | Defines the current validation baseline and confirms validation-script size debt is separate future driver-quality scope. |

## Authority Boundaries

These boundaries are discovery constraints, not optional preferences:

- `.paul/*` artifacts remain lifecycle truth. Pi widgets, runtime context payloads, helper-agent transcripts, notifications, shortcuts, and UI selections are derived aids only.
- PLAN/APPLY/UNIFY remains authoritative: PLAN defines approved work, APPLY executes and verifies under parent control, and UNIFY reconciles durable artifacts.
- Command-output truth remains authoritative for validation. Docs, copied baselines, reports, Pi surfaces, and summaries can explain posture but cannot mark current validation pass/fail.
- Installed `modules.yaml`, `[dispatch] ...` evidence, PLAN/SUMMARY module reports, and STATE decisions remain module evidence. Pi must not create a hidden module ledger.
- GitHub Flow gates remain explicit and command-evidence-backed. Pi may surface branch/PR/CI/routing status but must not bypass base sync, CI, reviews, merge, or cleanup gates.
- Parent APPLY owns helper eligibility, official verification, fallback judgment, checkpoints, module gates, task classification, GitHub Flow decisions, and `.paul/*` lifecycle writes.
- Explicit user approval and checkpoint behavior must remain transcript-visible or artifact-visible. Pi must not auto-approve, auto-continue, skip checkpoints, or infer merge intent.
- Full authoritative reads remain required for edits, approved PLAN execution, lifecycle writes, GitHub Flow decisions, validation pass/fail, stale/ambiguous/contested facts, and any decision that changes lifecycle semantics.
- Phase 226 authorizes discovery documentation only. It does not authorize runtime/source/test/install/dependency/CI/GitHub Flow/helper/lifecycle-authority changes.

## Current Pi Integration Surfaces

| Surface | Current evidence | Efficiency value | Effectiveness value | Authority risk to preserve |
|---|---|---|---|---|
| Artifact slices | `drivers/pi/extensions/README.md` documents `current-lifecycle-state`, `active-roadmap-phase`, and `approved-plan-task-packet`; `drivers/pi/extensions/pals-hooks.ts` defines bounded slice schema markers, freshness, fallback, and authority text. | Reduces repeated STATE/ROADMAP/PLAN orientation reads after explicit PALS activation. | Improves resume/apply orientation by showing cited lifecycle slices. | Slices must stay read-only, bounded, source-cited, activation-gated, disposable, and full-read-backed. |
| Workflow/resource capsules | `drivers/pi/extensions/README.md` and `drivers/pi/skill-map.md` document capsules for plan task anatomy, checkpoint orientation, module-dispatch evidence, and GitHub Flow phase orientation. | Reduces repeated loading of stable workflow/reference reminder prose. | Helps users and agents remember task/checkpoint/module/GitHub Flow constraints. | Capsules must not replace full workflow reads for blocking semantics, lifecycle writes, checkpoints, APPLY/UNIFY, module enforcement, or merge gates. |
| Guided workflow UX | `drivers/pi/extensions/README.md` documents plan-review, apply-approval, checkpoints, resume-next, continue-to-UNIFY, phase/milestone transition, and merge-gate routing. | Reduces prompt friction at repeated decision points. | Can improve reliability when canonical replies are explicit and transcript-visible. | No auto-approval, no auto-continue, no skipped checkpoint, no UI-only decision, no inferred merge intent. |
| Live module visibility | `drivers/pi/extensions/README.md` documents module activity derived from `[dispatch]` lines and Module Execution Reports; `drivers/pi/skill-map.md` says it is adapter-only. | Reduces repeated reconstruction of recent module activity. | Helps catch missing module evidence or stale dispatch surfaces earlier. | Must not become a Pi-owned module ledger or mark hooks complete without PLAN/SUMMARY evidence. |
| CARL session continuity | `drivers/pi/extensions/README.md` documents phase-boundary session rollover, safety valve, bootstrap, and auto-resume. | Reduces context loss and handoff burden near session boundaries. | Improves continuity when STATE remains authoritative and stale handoffs are subordinate. | CARL bootstrap is context, not lifecycle truth; `/skill:paul-resume` must still read STATE. |
| Command and shortcut routing | `drivers/pi/skill-map.md` documents `/paul-*` wrappers, canonical `/skill:paul-*`, and Ctrl+Alt shortcuts for next/status/resume/help/milestone. | Reduces command discovery and routing overhead. | Improves user flow by keeping one canonical skill path behind convenience wrappers. | Shortcuts and wrappers must not create new workflow semantics or persistent hidden state. |
| Helper delegation | `drivers/pi/extensions/README.md` and `drivers/pi/skill-map.md` document parent-owned task packets, structured reports, allowed/forbidden files, fallback triggers, and parent-run verification. | Can reduce parent context spent on bounded mechanical edits. | Can improve throughput if reports are complete and parent verification is compact. | Parent APPLY remains authoritative; helper output is review input only. |
| Validation/report surfacing | `drivers/pi/extensions/README.md` and v2.52 summary document validation-classification/report context and command-output truth. | Helps explain validation posture without rerereading entire validation docs. | Prevents copied counts/docs from being mistaken for current pass/fail proof when warnings are explicit. | Fresh command output remains validation truth; validation-script size debt remains separate unless explicitly planned. |
| GitHub Flow/status surfacing | `docs/PI-NATIVE-CONTEXT-EFFICIENCY-ARCHITECTURE.md` and `drivers/pi/extensions/README.md` describe branch/PR/CI status lenses and merge-gate route assistance. | Reduces repeated git/gh state reconstruction. | Improves safety when the next canonical action is surfaced without bypass paths. | GitHub Flow commands and shared workflow gates remain authoritative. |
| Install-surface posture | v2.52 summary and `drivers/pi/extensions/README.md` preserve Pi-supported runtime posture and explicit frozen legacy/source-only opt-ins. | Reduces support-surface ambiguity for future Pi-native work. | Keeps current work focused on Pi without deleting frozen historical evidence. | Do not reopen legacy parity or install cleanup in Phase 226. |

## Ranked Hotspots

| Rank | Hotspot | Observed friction | Likely Pi integration improvement | Expected efficiency gain | Expected effectiveness / reliability gain | Implementation risk | Evidence readiness | Phase 228 spike fit |
|---:|---|---|---|---|---|---|---|---|
| 1 | Artifact-slice targeting and deduplication | Current slices exist, but fresh sessions and lifecycle prompts still repeat overlapping STATE/ROADMAP/PLAN orientation. Slice payloads can also risk duplication with bounded injection and manual reads. | Design smarter slice selection rules, duplicate trimming evidence, and clearer freshness/fallback markers for current lifecycle, active roadmap, approved plan, prior summary decisions, and module evidence. | High: directly reduces repeated hot-context reads. | High: better source-cited orientation reduces stale/ambiguous resume and APPLY setup mistakes. | Medium: touches Pi extension and validation if implemented, but builds on proven pattern. | High: prior architecture, workstream, README, skill-map, and code constants already document the pattern. | Best candidate: implementation-ready, foundational, bounded if limited to one or two slice improvements. |
| 2 | Guided workflow prompt/reply reliability | Repeated plan review, APPLY approval, checkpoint, continue-to-UNIFY, and merge-gate prompts consume user and model attention. Reliability depends on exact canonical replies staying transcript-visible. | Harden detection/reporting around guided moments and explicit canonical reply evidence; possibly improve prompt summaries and no-auto-continue proof. | Medium: fewer manual prompt interpretation turns. | High: reduces accidental skipped approvals/checkpoints and improves auditability. | Medium: can affect user interaction paths; validation must prove no auto-approval or UI-only decision. | High: current README, skill-map, and implementation constants already name supported moments. | Strong candidate if Phase 227 prefers reliability over context-cost reduction. |
| 3 | Module-dispatch evidence lens | PLAN/APPLY/UNIFY repeatedly reconstruct module cohorts, hook results, and whether evidence was recorded. Current live visibility is bounded but may not directly support planning/review questions. | Design a more useful recent-module evidence lens derived only from `[dispatch]` lines, PLAN/SUMMARY reports, and installed registry metadata. | Medium: reduces repeated module evidence scanning. | High: makes missing or stale module evidence easier to notice. | Medium: must avoid Pi-owned module ledger semantics. | Medium-high: current module visibility exists and docs define evidence boundaries. | Good candidate if scoped to display/summary contract, not lifecycle ownership. |
| 4 | CARL bootstrap and resume precision | Fresh-session bootstrap is useful but stale handoff/state mismatches still require careful interpretation; bootstrap can be too broad or too sparse. | Improve bootstrap contents and resume routing clarity around STATE authority, handoff freshness, phase boundary reason, and exactly one next action. | Medium: lowers fresh-session reorientation cost. | Medium-high: fewer stale-handoff or wrong-next-action mistakes. | Medium: session-boundary behavior is safety-critical but can stay mostly documentation/format-oriented. | Medium: README documents current CARL behavior; recent session boundary evidence exists. | Good candidate if bounded to bootstrap wording/markers and validation. |
| 5 | Helper report inspection ergonomics | Delegated APPLY can reduce context, but parent review still requires comparing report fields, changed files, diff scope, and official verification. | Improve packet/report compression or parent review checklist visibility while preserving parent-owned verification. | Medium-high for implementation-heavy tasks; low for docs-only phases. | High when delegation is used; reduces acceptance of malformed helper output. | Medium-high: helper delegation authority boundaries are strict. | Medium: contracts exist, but implementation value depends on actual delegated workload. | Better for a future implementation-heavy milestone than immediate Phase 228 unless selected deliberately. |
| 6 | Shortcut / next-action routing | Shortcuts reduce entry friction, but next-action routing can still require STATE, ROADMAP, git, and prompt context alignment. | Improve one-action routing display with source/freshness and GitHub Flow awareness. | Medium: fewer routing turns. | Medium: fewer wrong command choices at phase or PR boundaries. | Medium: routing must not bypass workflow gates. | Medium: shortcut model and resume/status routing are documented. | Secondary candidate; likely pairs with CARL/status lens work. |
| 7 | GitHub Flow status lens | Git state is repetitive and safety-critical. Current workflows already surface branch/base/PR/CI state, but lens improvements could reduce manual checks. | Design a cited branch/PR/CI lens that surfaces exactly one canonical next action while deferring gate authority to workflows and git/gh output. | Medium: reduces repeated git status/gh parsing. | High near PR/merge gates. | Medium-high: merge-gate bypass risk if poorly scoped. | Medium: architecture and workflow references define requirements. | Good later candidate, especially when a milestone targets GitHub Flow friction. |
| 8 | Validation/report classification surfacing | Validation docs and reports explain posture, but current pass/fail still requires command output. Validation-script size debt is known and deferred. | Improve discoverability of validation classes and report freshness without changing scripts. | Low-medium: helps orientation, not runtime context directly. | Medium: reduces confusion between explanatory reports and command-output truth. | Low if docs-only; high if scripts change. | Medium: v2.51/v2.52 evidence is strong, but size debt is separate. | Good docs/design candidate; not the best Phase 228 spike unless scoped as surfacing only. |

## Recommended Shortlist

1. **Artifact-slice targeting and deduplication** — highest combined efficiency/effectiveness value and strongest evidence readiness. It extends the proven context-efficiency pattern while preserving read-only, cited, bounded, full-read-backed authority.
2. **Guided workflow prompt/reply reliability** — strongest lifecycle reliability candidate. It is close to current Pi behavior and can prove explicit user intent, but needs careful no-auto-continue validation.
3. **Module-dispatch evidence lens** — strong evidence-quality candidate. It can reduce repeated module reconstruction and catch missing dispatch evidence, but must avoid creating a Pi-owned ledger.
4. **CARL bootstrap and resume precision** — strong session-continuity candidate if the immediate pain is fresh-session reorientation rather than steady-state APPLY efficiency.

## Candidate Pairings

Phase 227 should decide whether Phase 228 should spike one candidate or a very small pair:

- **Best single spike:** artifact-slice targeting and deduplication.
- **Best reliability spike:** guided workflow prompt/reply reliability.
- **Best evidence spike:** module-dispatch evidence lens.
- **Safe pair only if tightly bounded:** artifact-slice deduplication + CARL/resume precision, because both operate on activation/session orientation and can share citation/freshness rules.

Avoid pairing guided workflow changes with GitHub Flow routing or helper delegation in one spike; those combine user-intent, merge-safety, and parent-APPLY authority risks.

## Evidence Requirements for Future Design

Any Phase 227 design and Phase 228 spike should name:

- Exact repo surfaces expected to change.
- Validation classes affected: likely Runtime Lens, Pi-Supported Runtime, Shared Invariant, Guided UI Safety, Helper Delegation, GitHub Flow Safety, and/or Artifact / Process.
- Fresh command evidence required before declaring success.
- Marker checks for source citations, freshness, bounds, fallback-to-full-read language, and no hidden state.
- Proof that `.paul/*` writes remain workflow-owned.
- Proof that PLAN/APPLY/UNIFY remains authoritative.
- Proof that module evidence remains in installed registry plus PLAN/SUMMARY/STATE reports, not a Pi-owned ledger.
- Proof that GitHub Flow commands and merge gates remain authoritative.
- Proof that explicit user replies remain transcript-visible when guided workflow UX is touched.
- Validation count reconciliation if any future validation script changes.

## Non-goals

- No runtime behavior change in Phase 226.
- No validation-script change in Phase 226.
- No dependency, package manager, or CI change in Phase 226.
- No GitHub Flow automation change in Phase 226.
- No helper-delegation semantic change in Phase 226.
- No install-surface change in Phase 226.
- No lifecycle-authority change or `.paul/*` authority change in Phase 226.
- No frozen Claude Code / Agent SDK parity reopening.
- No validation-script size-debt refactor unless a later approved plan explicitly selects driver-quality scope.

## Phase 227 Handoff

Phase 227 should turn this discovery into an executable candidate design. Recommended focus:

### Recommended shortlist

1. Artifact-slice targeting and deduplication.
2. Guided workflow prompt/reply reliability.
3. Module-dispatch evidence lens.
4. CARL bootstrap and resume precision.

### Design questions

- Which single hotspot has the strongest current user/model friction evidence in recent v2.47-v2.52 runs?
- What exact slice, prompt, module-evidence, or bootstrap output should change?
- What output-size and freshness bounds are safe?
- What full-read fallback language is required?
- What validation classes and marker checks are mandatory?
- What is the smallest Phase 228 spike that can prove value without touching unrelated runtime surfaces?

### Evidence requirements

- Source-cited design inputs from this artifact and existing Pi-native docs.
- Explicit protected-file and non-goal list before implementation.
- Command-output validation plan before APPLY.
- Changed-file budget and Workguard scope.
- Validation count reconciliation if tests change.
- Clear fallback if the selected candidate is too broad or crosses authority boundaries.

### Non-goals for Phase 227 unless explicitly approved

- Do not implement code during design.
- Do not change validation scripts during candidate design.
- Do not combine helper delegation, GitHub Flow merge routing, and guided UI in one spike.
- Do not make Pi runtime context, widgets, or helper reports durable lifecycle truth.

## Conclusion

The highest-value v2.53 path is to start with **artifact-slice targeting and deduplication**, unless Phase 227 surfaces stronger immediate reliability evidence for guided workflow prompt/reply hardening. Artifact slices are the best first candidate because they directly address context efficiency, already have source-cited/activation-gated architecture, and can be bounded without weakening `.paul/*` authority, command-output truth, lifecycle gates, module evidence, parent-owned APPLY, GitHub Flow safety, or explicit approval/checkpoint behavior.
