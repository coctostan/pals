# Milestones

Completed milestone log for this project.

| Milestone | Completed | Duration | Stats |
|-----------|-----------|----------|-------|
| v0.1 Fork & Unify | 2026-03-11 | 1 day | 6 phases, 10 plans |
| v0.2 Polish | 2026-03-11 | 1 day | 1 phase, 1 plan |
| v0.3 Smart Context & Migration | 2026-03-11 | 1 day | 2 phases, 2 plans |
| v0.4 Kernel & Modules | 2026-03-12 | 2 days | 4 phases, 7 plans |
| v0.5 TODD & WALT Go Live | 2026-03-12 | 1 day | 3 phases, 3 plans |
| v0.6 Enhance & Expand | 2026-03-12 | 1 day | 5 phases, 5 plans |
| v0.7 Full Roster & Lifecycle Integration | 2026-03-12 | 1 day | 4 phases, 4 plans |
| v0.8 Configuration & Polish | 2026-03-12 | 1 day | 2 phases, 2 plans |
| v0.9 Observability & Context Health | 2026-03-13 | 1 day | 2 phases, 3 plans |
| v0.9.1 Release Readiness | 2026-03-13 | 1 day | 3 phases, 4 plans |
| v0.9.2 Competitive Intelligence | 2026-03-13 | 1 day | 1 phase, 1 plan |
| v1.0 Production Ready | 2026-03-13 | 1 day | 3 phases, 3 plans |
| **v1.1 Deep Competitive Audit** | 2026-03-14 | 2 days | 5 phases, 5 plans |
| **v1.2 Multi-Model Routing** | 2026-03-14 | 1 day | 2 phases, 2 plans |
| **v2.0 Portability & Cross-Harness** | 2026-03-14 | 1 day | 4 phases, 6 plans |
| **v2.1 Pi Runtime Integration** | 2026-03-14 | 1 day | 4 phases, 4 plans |
| **v2.3 Pi Interaction Model Refinement** | 2026-03-16 | 2 days | 3 phases, 3 plans |
| **v2.4 Pi Native UX Layer** | 2026-03-16 | 1 day | 3 phases, 3 plans |
| **v2.5 Pi Runtime Coherence & Guided Flow** | 2026-03-16 | 1 day | 3 phases, 3 plans |
| **v2.6 Collaborative Planning & PRD Depth** | 2026-03-17 | 17 hours | 3 phases, 4 plans |
| **v2.7 Module Reality Check & Visibility** | 2026-03-18 | 15h 24m | 4 phases, 4 plans |

---

## ✅ v2.7 Module Reality Check & Visibility

**Completed:** 2026-03-18
**Duration:** 15h 24m

### Stats

| Metric | Value |
|--------|-------|
| Phases | 4 (Phases 68-71) |
| Plans | 4 |
| Files changed | 23 unique workflow/spec/adapter/validation/state files |

### Key Accomplishments

- Audited the module system and confirmed the main trust problem was proof and visibility opacity rather than source-vs-installed drift.
- Hardened the durable post-unify evidence path so module contributions can persist into `SUMMARY.md` / `FIX-SUMMARY.md` after finalization.
- Established one shared reporting contract built around durable `module_reports` and non-blocking `side_effects`.
- Added bounded, dispatch-derived live module visibility to Pi's status/widget surfaces without creating Pi-owned execution truth.
- Closed the milestone with per-module recommendations and a layered proof model that preserves the roster and improves legibility instead of adding telemetry.

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Treat the module system as more wired than visible | 68 | Kept follow-on work focused on proof/reporting and UX instead of chasing registry drift |
| Finalize summary evidence after post-unify instead of treating the first SUMMARY write as final | 69 | Gave post-unify-capable modules a dependable durable reporting path |
| Use `module_reports` for persisted content and `side_effects` for non-blocking follow-on actions | 69 | Aligned workflows, specs, overlays, and validation around one evidence contract |
| Derive live module visibility from recent shared workflow/reporting signals rather than registry presence alone | 70 | Kept Pi visibility trustworthy without inventing a second execution ledger |
| Keep the module roster and improve legibility before considering merge/remove changes | 71 | Future work can focus on recommendation/report clarity instead of destabilizing module boundaries |
| Standardize a layered proof model across dispatch trace, durable reports, side effects, validation, and bounded Pi live visibility | 71 | Preserved artifact-first truth while making module participation easier to interpret |

---

## ✅ v2.6 Collaborative Planning & PRD Depth

**Completed:** 2026-03-17
**Duration:** 17 hours

### Stats

| Metric | Value |
|--------|-------|
| Phases | 3 (Phases 65-67) |
| Plans | 4 |
| Files changed | 40 unique workflow/template/doc/validation/state files |
| Validation checks | 162 passing total (53 cross-harness + 109 Pi) |

### Key Accomplishments

- Audited the current planning and onboarding lifecycle, grounding collaboration and PRD-depth gaps in concrete PALS workflow and artifact behavior.
- Implemented a shared low / medium / high collaboration model with project defaults, per-run overrides, and explicit exploratory vs direct-requirements language.
- Added a 4-option pre-plan review flow (quick recap, detailed recap, full plan, no review needed) across shared workflows and Pi guided UX.
- Rolled out a layered durable artifact model with compact hot-path `PROJECT.md` context plus selectively-read `PRD.md` depth.
- Updated shared docs, adapter contracts, and validation so the layered onboarding model remains portable and legacy-safe across harnesses.

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Keep artifact-first shared markdown workflows as lifecycle truth while improving collaborative definition behavior | 65 | Preserved the existing authority model while targeting the real planning/onboarding weakness |
| Add low / medium / high collaboration levels with project default plus per-run override | 65 | Introduced bounded collaboration depth across init, milestone discussion, and phase planning |
| Add a 4-option pre-plan review choice before APPLY routing | 65 | Added progressive disclosure without changing execution-loop semantics |
| Keep planning collaboration shared-workflow driven via `pals.json` `planning.default_collaboration` plus per-run overrides | 66 | Preserved portability while making collaboration behavior configurable and explicit |
| Adopt a layered durable artifact model with compact `PROJECT.md` hot-path context plus selectively-read `PRD.md` depth | 67 | Increased product-definition depth without bloating the hot path |
| Keep `PRD.md` additive and legacy-safe for existing repos | 67 | Avoided destructive migration while codifying the new portable contract |

---

## ✅ v2.5 Pi Runtime Coherence & Guided Flow

**Completed:** 2026-03-16
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 3 (Phases 62-64) |
| Plans | 3 |
| Files changed | 6 unique tracked adapter/docs/validation/state files |
| Validation checks | 106 Pi checks passing at milestone close |

### Key Accomplishments

- Refined the Pi runtime model so explicit command entry is the strongest activation signal and `before_agent_start` is the primary bounded injection point
- Added bounded Pi-native guided workflow UX for approvals, checkpoints, resume routing, and phase/milestone transitions while keeping shared artifacts authoritative
- Polished lifecycle readability with semantic notify levels and a compact loop badge in the status bar
- Clarified Pi installation boundaries across skills, kernel markdown, extension, and installed `modules.yaml` overlays
- Expanded the Pi validation suite from 93 to 106 checks across runtime coherence, guided workflow UX, and readability/documentation guarantees

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Make `before_agent_start` the primary workflow-context decision point and keep `context` support-only | 62 | Preserves one bounded automatic injection path while keeping `.paul/*` authoritative |
| Keep guided workflow detection marker-driven and route explicit continuations through `pi.sendUserMessage(...)` | 63 | Improves UX without creating Pi-owned lifecycle branches or hidden state |
| Use `matchAll(/[✓○]/g)` for loop badge extraction and reserve `"success"` for confirmed sends/routes | 64 | Keeps UX enrichment simple, robust, and bounded to additive cosmetic changes |

---

## ✅ v2.4 Pi Native UX Layer

**Completed:** 2026-03-16
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 3 (Phases 59-61) |
| Plans | 3 |
| Files changed | 10 unique adapter/docs/validation files |
| Validation checks | 137 (90 Pi + 47 cross-harness, all pass) |

### Key Accomplishments

- Added an always-visible Pi lifecycle surface that derives milestone, phase, loop state, and next action from `.paul/STATE.md` without creating Pi-only workflow truth
- Added bounded quick actions and keyboard shortcuts that route through `/paul-*` wrappers while preserving `/skill:paul-*` as the canonical workflow surface
- Polished Pi lifecycle wording and discovery guidance so the visible UX stays low-clutter while remaining explicit about workflow ownership and lifecycle truth
- Clarified that TODD and WALT load in Pi as installed `modules.yaml` overlays and workflow dispatch, not as standalone Pi skills
- Expanded validation to 90 Pi checks and 47 cross-harness checks, confirming interoperability across Pi and Claude Code-oriented PALS usage

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Reuse one shared lifecycle snapshot for Pi notifications, status, widget, and injected context | 59 | Keeps lifecycle semantics aligned across all visible Pi surfaces and reduces drift |
| Keep Pi quick actions bounded and route shortcut entry points through the existing wrapper layer | 60 | Preserves low-clutter UX while avoiding Pi-only workflow semantics or duplicate routing logic |
| Explain TODD/WALT as installed module overlays from `modules.yaml`, not standalone Pi skills | 61 | Resolves first-run Pi ambiguity without changing canonical workflow ownership |

---

## ✅ v2.3 Pi Interaction Model Refinement

**Completed:** 2026-03-16
**Duration:** 2 days (2026-03-15 to 2026-03-16)

### Stats

| Metric | Value |
|--------|-------|
| Phases | 3 (Phases 56-58) |
| Plans | 3 |
| Files changed | 11 unique adapter/research files |
| Validation checks | 81 (all pass) |

### Key Accomplishments

- Evaluated Pi event and context-injection options and selected a hybrid event model that keeps `.paul/*` artifacts authoritative
- Improved `/paul-*` command routing and discoverability while preserving `/skill:paul-*` as the canonical Pi skill surface
- Added guardrails so Pi command UX improvements do not materially increase automatic workflow-context injection overhead
- Cleaned up remaining Pi adapter metadata, uninstall/operator wording, and help/discovery surfaces so they match the implemented extension-enabled model
- Expanded the Pi end-to-end validation suite from 75 to 81 checks, covering command/discovery alignment and consistency-contract expectations

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Prefer a hybrid Pi event model over a single-hook redesign | 56 | Clarifies responsibility split across orientation, activation, and injection without creating Pi-only truth |
| Keep `/paul-*` as Pi-native convenience wrappers and `/skill:paul-*` as canonical entry points | 57 | Improves discoverability without forking workflow semantics into TypeScript |
| Keep added routing guidance brief and command-local | 57 | Preserves command discoverability gains without materially increasing Pi runtime context load |
| Keep Phase 58 focused on wording, metadata, and validation only | 58 | Closes the milestone with low-risk consistency work instead of reopening behavior changes |
| Extend validation to cover consistency claims | 58 | Makes future Pi adapter drift easier to detect and correct |

---

## ✅ v2.1 Pi Runtime Integration

**Completed:** 2026-03-14
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 4 (Phases 49-52) |
| Plans | 4 |
| Files created | ~15 (skills, extension, validation, report) |
| Validation checks | 75 (all pass) |

### Key Accomplishments

- Generated 11 Pi SKILL.md entry points mapping 21 PALS workflows to user-facing skills, with skill-map.md as the canonical mapping reference
- Built thin TypeScript extension (143 lines) with 11 /paul-* commands via registerCommand, session_start detection, and context injection hooks
- Updated Pi installer to deploy skills to ~/.pi/agent/skills/pals/{name}/ and extension to ~/.pi/agent/extensions/
- Updated driver.yaml to reflect full 6/6 capability support (added hook_register and command_register)
- Created 75-check TAP validation suite proving end-to-end Pi integration: installer deployment, skill structure, extension structure, driver manifest accuracy
- All 75 validation checks pass — Pi adapter is proven production-ready

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| 11 skills (not 21) — only user-facing commands | 49 | Internal workflows invoked by skill instructions |
| ../workflows/ relative paths in skills | 49 | Skills installed as siblings of kernel dirs |
| Commands delegate to /skill:paul-* via notify | 50 | Keeps extension thin; skills have full instructions |
| Inline Pi API types (no SDK import) | 50 | No build step; runs in Pi's runtime |
| Context hook checks last 5 messages | 50 | Balance detection accuracy and performance |

---

## ✅ v2.0 Portability & Cross-Harness

**Completed:** 2026-03-14
**Duration:** 1 day

### Stats

| Metric | Value |
|--------|-------|
| Phases | 4 (Phases 45-48) |
| Plans | 6 |
| Files created | ~15 (specs, drivers, validation) |
| Key specs | 5 normative documents |

### Key Accomplishments

- Created 5 normative specification documents: ARTIFACT-SPEC.md (8 artifact schemas), LIFECYCLE-SPEC.md (7 states, 7 transitions), HOOK-CONTRACT.md, ADAPTER-CONTRACT.md, HARNESS-PORTABILITY.md
- Converted all 53+ kernel and module files to portable reference convention — zero @~/.pals/, @.paul/, or ~/.pals/ hardcoded patterns remain
- Created REFERENCE-RESOLUTION.md documenting portable kernel/ prefix convention with per-harness resolution table
- Built Pi adapter: driver manifest (4/6 capabilities), installer targeting ~/.pi/agent/skills/pals/, uninstaller
- Rewrote root installer for multi-driver support — installs for ALL detected harnesses simultaneously
- Created and passed 45-check cross-harness validation suite proving installer parity, portability compliance, artifact spec conformance, and driver manifest completeness

### Key Decisions

| Decision | Phase | Impact |
|----------|-------|--------|
| Artifacts are authoritative; prompts are interpretive | 45 | Core portability principle |
| kernel/ prefix for portable references | 46 | Adapters resolve to install location |
| Install for ALL detected harnesses | 47 | No silent override, no conflict |
| Pi: no hook_register or command_register | 47 | Simpler adapter, can extend later |
| TAP format for validation output | 48 | Machine-parseable, CI-ready |

---

*Milestones log created: 2026-03-12*