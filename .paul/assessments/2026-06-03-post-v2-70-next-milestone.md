# Strategic Assessment — Post-v2.70 Next Milestone

**Generated:** 2026-06-03
**Milestone boundary:** after v2.70 Strategic Milestone Assessment, before the next milestone
**Capability detection:** all five lenses inspected; build sub-check skipped not applicable due no build tooling; optional complexity/duplication analyzers skipped not applicable due no analyzer tooling; data/output lens partial for stale workguard run logs
**Status:** Non-authoritative — informs the next milestone discussion

> See `docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md` for lens definitions, capability-detection rules, and authority stance.

## Findings

### Vision alignment

**Strategic question:** Is recent work still serving the project's stated purpose, or has it drifted?

**Evidence gathered:** PROJECT/ROADMAP/MILESTONES state the core value as **"The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers"**. Recent milestone themes remain tightly aligned:

- v2.67 cleared validation and hot-artifact hygiene debt so the lifecycle framework stayed runnable and trustworthy.
- v2.68 retracted Plannotator live surfaces, preserving artifact-first authority and avoiding UI-authority drift.
- v2.69 reduced Pi runtime context burden by extracting S4 guided workflow delivery and ranking the next context-offload target.
- v2.70 added the optional strategic-assessment checkpoint while keeping it non-authoritative, main-session-only, and budget-exempt.

**Finding:** alignment is strong. Recent work repeatedly protects the same axis: minimal kernel, modular Pi runtime surfaces, artifact-first lifecycle truth, and validation-backed guardrails. The only visible drift signal, Plannotator, was corrected by v2.68 rather than allowed to compound.

### Trajectory

**Strategic question:** Is the project converging toward its goals or sprawling away from them?

**Evidence gathered:** Milestone history and decision rows show a convergence pattern since v2.56: repeated sibling extraction, context diet, workflow/module instruction compression, validation hygiene, and strategy-before-build planning. Deferred debt is explicit rather than hidden:

- Remaining deferred issues in STATE include future module candidates (`ci-generation.md`, `sonarqube-integration.md`), shelved Agent SDK hook dispatch, tree-sitter repo map, and cross-file narrative duplication.
- S4 moved from deferred integration point to shipped v2.69 scope.
- v2.66 Plannotator expansion was deliberately retracted in v2.68.
- Phase 295 already ranked **shared filesystem/state helper extraction** as the next contract-first context-offload target.

**Finding:** trajectory is converging, not sprawling. The main risk is not product drift; it is local maintenance concentration in a few large validation/runtime files and repeated artifact narrative. Decision churn appears controlled: retractions and deferrals are documented, and validation is green.

### Codebase reality

**Strategic question:** What state is the code actually in?

**Evidence gathered:** Lightweight repository inspection found:

- Tracked repository: **1,262 files**, **12,158,947 bytes**.
- Shape is documentation/artifact-heavy: **1,209 Markdown files** totaling **11,652,765 bytes**; **12 shell files** totaling **330,965 bytes**; **9 TypeScript files** totaling **79,106 bytes**.
- Runtime/test source slice inspected (`drivers/**/*.ts`, `tests/**/*.sh`, root `*.sh`): **17 files**, **8,479 lines**.
- Largest source files by line count:
  - `tests/pi-end-to-end-validation.sh` — 2,733 lines
  - `tests/cross-harness-validation.sh` — 2,136 lines
  - `migrate.sh` — 552 lines
  - `drivers/pi/extensions/pals-hooks.ts` — 546 lines
  - `drivers/pi/extensions/guided-workflow-detection.ts` — 356 lines
  - `tests/helpers/module_instruction_semantics.sh` — 345 lines
  - `tests/helpers/artifact_consistency.sh` — 314 lines
- Marker scan by live-ish areas:
  - `drivers/`: 2 matches, both in frozen/reference Agent SDK surfaces (`drivers/agent-sdk/pals-agent.py`, `drivers/agent-sdk/README.md`) around unimplemented hook dispatch.
  - `tests/`: 0 matches.
  - `kernel/`: 17 matches, mostly examples/template/instruction language about marker detection rather than unresolved code debt.
  - `docs/`: 2 matches in the strategic-assessment contract describing the scan lens.
- Optional complexity/duplication analyzers: skipped not applicable — no package manifest, ESLint config, TypeScript config, or analyzer tooling detected.

**Finding:** the live Pi TypeScript surface is reasonably modular after the S1-S8/S4 extraction wave, but `pals-hooks.ts` still carries 546 lines of runtime orchestration plus shared helpers. The highest maintenance hotspots are the two shell validation suites and the remaining shared-helper concentration in `pals-hooks.ts`. No fresh unresolved marker debt appears in tests or live Pi runtime source.

### Buildable/runnable reality

**Strategic question:** Does the project actually build, test, and run right now?

**Capability detection:**

- Build tooling: skipped not applicable — no `package.json`, `Makefile`, `tsconfig.json`, `.eslintrc*`, Dockerfile, or CI workflow directory detected.
- Test/validation tooling: present — shell validation harnesses under `tests/` and helper checks under `tests/helpers/`.

**Validation run in this assessment:**

- `bash tests/pi-end-to-end-validation.sh` — PASS, **336/336**.
- `bash tests/cross-harness-validation.sh` — PASS, **241/241**.
- `bash tests/helpers/artifact_consistency.sh` — PASS.

**Finding:** the project is runnable through its validation harnesses, not through a conventional build system. That is consistent with current PALS architecture. Fresh validation is fully green.

### Data & outputs

**Strategic question:** What is the project producing, and is that output healthy and trending well?

**Evidence gathered:**

- `.paul/phases/` contains **290 phase directories**, latest numeric phases 296–298 for v2.70.
- `.paul/QUALITY-HISTORY.md` trends from v2.67 closure through v2.70 as green/stable-to-improving: v2.67 Pi 335/335 + XH 246/246; v2.68 Pi 328/328 + XH 234/234 after intentional Plannotator assertion removal; v2.69 Pi 331/331 + XH 235/235; v2.70 Pi 336/336 + XH 241/241.
- `.paul/CODI-HISTORY.md` records recent v2.70 CODI outcomes as no-symbol/no-dispatch, consistent with docs/workflow/validation scope rather than source-selector injection.
- `runs/workguards/` has **146** historical run directories, but latest listed workguard run is from 2026-05-14 (`phase-288-plan`), so this output stream is partial/stale for the latest milestones.
- Roadmap archives exist for selected closures including v2.67 and v2.70.

**Finding:** durable lifecycle outputs are healthy and current. Validation trends are green. Workguard run logs are present but stale, so they should not be treated as the primary current output source.

## Strategic Options

- **Shared filesystem/state helper extraction** — High value, moderate risk. Targets repeated helper imports currently anchored in `pals-hooks.ts` and could reduce future runtime-edit context. Requires a contract-first inventory, import-cycle prevention, and strict authority boundaries: pure/derived helpers only; no lifecycle writes, command routing, module dispatch, validation, approvals, or user-message ownership.
- **Validation helper/script decomposition** — Medium value, moderate risk. The two largest source files are validation scripts, and decomposition could reduce maintenance context. Risk is high enough to keep separate: validation command output is authoritative, TAP counts must remain explicit, and helper abstraction must not hide failures.
- **CARL/session-boundary helper extraction** — Medium-high value, moderate-high risk. Conceptually distinct from runtime registration, but closer to lifecycle flow than pure helpers. Best after shared helper extraction clarifies imports and boundaries.
- **Cross-file narrative single-source/deduplication** — Medium planning value, low-to-moderate risk if docs-only. This addresses explicit deferred debt across STATE/PROJECT/MILESTONES/ROADMAP, but it risks re-litigating artifact authority and should not be mixed with runtime extraction.
- **Documentation/contract consolidation before runtime work** — Medium planning value, low runtime risk. Could index the extraction contracts and reduce broad doc rereads, but by itself does not reduce runtime file concentration.

## Ranked Recommendation

**Recommended next target (non-authoritative):** Shared filesystem/state helper extraction, starting with a contract-first phase for a minimal `shared-runtime-helpers` sibling.

**Why this ranks first:** It is the best balance of value, evidence, and safety. It directly follows the v2.69 Phase 295 source-backed ranking, addresses a real remaining hotspot in `pals-hooks.ts`, supports the core value of modular runtime surfaces, and can be bounded tightly enough to avoid lifecycle-authority drift. It also creates a safer foundation for later CARL/session-boundary extraction if the user still wants that direction.

> Non-authoritative: this recommendation informs the milestone discussion but does not decide it. Only a future approved PLAN authorizes implementation.

## Actionable Points

Concrete handoff items that feed into the milestone feature discussion (`explore_features` / `synthesize_scope`).

- [ ] If the user chooses runtime context offload, name the milestone around **shared runtime helper extraction** rather than broad `pals-hooks.ts` cleanup.
- [ ] Start with a docs-first contract phase that inventories exact helper symbols, current import users, allowed helper responsibilities, and cycle-avoidance rules.
- [ ] Keep implementation scope pure/derived: file reads, string normalization, freshness/line-selection helpers, and type definitions only; explicitly exclude `.paul/*` writes, lifecycle state ownership, module dispatch, git/validation, approval/continue behavior, command routing, UI decisions, and canonical user-message delivery.
- [ ] Require focused guardrails: helper exports exist, imports repointed, duplicate definitions removed, no new authority markers in the helper sibling, plus fresh Pi e2e, cross-harness, artifact consistency, and `git diff --check` evidence in the future APPLY/UNIFY.
- [ ] If the user prefers non-runtime work, split validation-suite decomposition or narrative-deduplication into separate milestones rather than combining them with helper extraction.

---

*This artifact is durable posterity under `.paul/assessments/`; it is not a hot-path lifecycle artifact and is not subject to STATE/PROJECT/ROADMAP/MILESTONES byte budgets.*
