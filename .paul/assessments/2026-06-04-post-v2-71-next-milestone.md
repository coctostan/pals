# Strategic Assessment — Post-v2.71 Next Milestone

**Generated:** 2026-06-04
**Milestone boundary:** after v2.71 HTML Presentation Packets — Human Review Briefs, before the next milestone
**Capability detection:** all five lenses inspected; build sub-check skipped not applicable (no build tooling); optional complexity/duplication analyzers skipped not applicable (no analyzer tooling); data/output lens partial for stale workguard run logs
**Status:** Non-authoritative — informs the next milestone discussion

> See `docs/PALS-STRATEGIC-ASSESSMENT-CONTRACT.md` for lens definitions, capability-detection rules, and authority stance.

## Findings

### Vision alignment

**Strategic question:** Is recent work still serving the project's stated purpose, or has it drifted?

**Evidence gathered:** Core value remains **"The Linux of Harness Engineering — minimal kernel, modular pals, universal drivers."** Recent milestone themes stay tightly aligned:

- v2.69 reduced Pi runtime context burden (S4 extraction) and ranked the next offload target.
- v2.70 added the optional, non-authoritative strategic-assessment checkpoint.
- v2.71 shipped optional, static, derived HTML review briefs for all four lifecycle moments while explicitly preserving `.paul/*` lifecycle authority and PLAN/APPLY/UNIFY ownership.

**Finding:** alignment remains strong. v2.71 followed the same discipline as the prior wave — additive, optional, non-authoritative, validation-guarded surfaces that never displace artifact-first truth. No new drift signal appeared.

### Trajectory

**Strategic question:** Is the project converging toward its goals or sprawling away from them?

**Evidence gathered:** Convergence pattern since v2.56 continues: sibling extraction, context diet, workflow/module compression, validation hygiene, strategy-before-build, and now optional human-review surfaces. Deferred debt stays explicit in STATE:

- Future module candidates (`ci-generation.md`, `sonarqube-integration.md`), shelved Agent SDK hook dispatch, tree-sitter repo map, and cross-file narrative duplication remain open.
- Phase 295 (v2.69) ranked **shared filesystem/state helper extraction** as the next contract-first context-offload target; **v2.70 and v2.71 did not consume it**, so it carries forward intact.

**Finding:** trajectory is converging, not sprawling. The standing runtime-offload backlog item is now two milestones old and still unaddressed — the clearest "next logical step" signal. Decision churn remains controlled and validation is green.

### Codebase reality

**Strategic question:** What state is the code actually in?

**Evidence gathered:** Lightweight inspection found:

- Shape remains documentation/artifact-heavy (patch/json/md dominate the tree; only 9 TypeScript + 12 shell source files in the live surface).
- Largest source files by line count:
  - `tests/pi-end-to-end-validation.sh` — 2,812 lines
  - `tests/cross-harness-validation.sh` — 2,249 lines
  - `migrate.sh` — 552 lines
  - `drivers/pi/extensions/pals-hooks.ts` — 546 lines
  - `drivers/pi/extensions/guided-workflow-detection.ts` — 356 lines
  - `tests/helpers/module_instruction_semantics.sh` — 345 lines
  - `tests/helpers/artifact_consistency.sh` — 314 lines
- TODO/FIXME/HACK markers in live `.ts`/`.sh` source: **0** — no fresh unresolved code debt.
- Optional complexity/duplication analyzers: skipped not applicable — no package manifest, ESLint/TypeScript config, or analyzer tooling.

**Finding:** `pals-hooks.ts` still holds 546 lines of runtime orchestration plus shared helpers (unchanged since v2.69 — the new v2.71 packet wiring lived in kernel workflows + a template, not the hooks file). The two shell validation suites grew (2,733→2,812 and 2,136→2,249) as v2.70/v2.71 added marker checks — the dominant and growing maintenance hotspot. Shared-helper concentration in `pals-hooks.ts` is the second hotspot.

### Buildable/runnable reality

**Strategic question:** Does the project actually build, test, and run right now?

**Capability detection:**

- Build tooling: skipped not applicable — no `package.json`, `Makefile`, `tsconfig.json`, `.eslintrc*`, Dockerfile, or CI workflow directory.
- Test/validation tooling: present — shell validation harnesses under `tests/` + helpers under `tests/helpers/`.

**Validation run in this assessment (fresh):**

- `bash tests/pi-end-to-end-validation.sh` — PASS, **342/342**.
- `bash tests/cross-harness-validation.sh` — PASS, **253/253**.
- `bash tests/helpers/artifact_consistency.sh` — PASS.

**Finding:** the project is runnable through its validation harnesses (not a conventional build system, consistent with PALS architecture). Fresh validation is fully green at the post-v2.71 baseline.

### Data & outputs

**Strategic question:** What is the project producing, and is that output healthy and trending well?

**Evidence gathered:**

- `.paul/phases/` contains **296 phase directories**, latest numeric phases 299–302 for v2.71.
- QUALITY trend stays green/stable-to-improving: v2.69 Pi 331/331 + XH 235/235; v2.70 Pi 336/336 + XH 241/241; v2.71 Pi 342/342 + XH 253/253. Counts rise as each milestone adds marker guardrails.
- v2.71 added a new derived output stream: optional HTML packets under `.paul/presentation-packets/` (static, source-cited, budget-exempt, never committed as `.html`).
- `runs/workguards/` historical run logs remain present but stale (latest ~2026-05-14), so they are not the primary current output source.

**Finding:** durable lifecycle outputs are healthy and current; validation trends green and rising. Workguard run logs remain stale — informational only.

## Strategic Options

- **Shared filesystem/state helper extraction** — High value, moderate risk. Targets repeated helper logic anchored in `pals-hooks.ts` (still 546 lines after v2.71). Directly executes the standing v2.69 Phase 295 ranking. Requires a contract-first inventory, import-cycle prevention, and strict authority boundaries: pure/derived helpers only; no lifecycle writes, command routing, module dispatch, validation, approvals, or user-message ownership.
- **Validation suite decomposition** — Medium-high value, moderate risk (rising). The two validation scripts are now the largest and fastest-growing files (2,812 + 2,249 lines) and keep growing with every milestone's guardrails. Decomposition could cap maintenance context. Risk: validation command output is authoritative, TAP counts must stay explicit, helper abstraction must not hide failures.
- **CARL/session-boundary helper extraction** — Medium-high value, moderate-high risk. Distinct from runtime registration but closer to lifecycle flow than pure helpers. Best sequenced after shared-helper extraction clarifies imports/boundaries.
- **Cross-file narrative single-source/deduplication** — Medium planning value, low-to-moderate risk if docs-only. Addresses explicit deferred debt across STATE/PROJECT/MILESTONES/ROADMAP, but risks re-litigating artifact authority; keep separate from runtime extraction.
- **New module candidate (`ci-generation.md` / `sonarqube-integration.md`)** — Medium value, low-moderate risk. Expands the modular-pals surface (on-vision), but adds breadth rather than reducing the existing runtime/validation hotspots.

## Ranked Recommendation

**Recommended next target (non-authoritative):** Shared filesystem/state helper extraction, starting with a contract-first phase for a minimal `shared-runtime-helpers` sibling.

**Why this ranks first:** It is the best balance of value, evidence, and safety, and the evidence has only strengthened since the post-v2.70 assessment. It is now the **twice-deferred** Phase 295 source-backed ranking (v2.70 and v2.71 both passed it over), it addresses a real, unchanged hotspot in `pals-hooks.ts` (still 546 lines), it directly serves the core value of modular runtime surfaces, and it can be bounded tightly enough to avoid lifecycle-authority drift. It also creates a safer foundation for later CARL/session-boundary extraction. The one rising alternative worth flagging is validation-suite decomposition: the two test scripts are now the largest and fastest-growing files in the repo and may deserve their own milestone soon.

> Non-authoritative: this recommendation informs the milestone discussion but does not decide it. Only a future approved PLAN authorizes implementation.

## Actionable Points

Concrete handoff items that feed into the milestone feature discussion (`explore_features` / `synthesize_scope`).

- [ ] If the user chooses runtime context offload, name the milestone around **shared runtime helper extraction**, not broad `pals-hooks.ts` cleanup.
- [ ] Start with a docs-first contract phase inventorying exact helper symbols, current import users, allowed helper responsibilities, and cycle-avoidance rules.
- [ ] Keep implementation scope pure/derived: file reads, string normalization, freshness/line-selection helpers, and type definitions only; explicitly exclude `.paul/*` writes, lifecycle state ownership, module dispatch, git/validation, approval/continue behavior, command routing, UI decisions, and canonical user-message delivery.
- [ ] Require focused guardrails: helper exports exist, imports repointed, duplicate definitions removed, no new authority markers in the helper sibling, plus fresh Pi e2e, cross-harness, artifact consistency, and `git diff --check` evidence in the future APPLY/UNIFY.
- [ ] Consider scoping **validation-suite decomposition** as the milestone-after-next: the two test scripts (2,812 + 2,249 lines) are the largest, fastest-growing files and are accumulating maintenance cost with each milestone's guardrails.
- [ ] If the user prefers non-runtime work, keep narrative-deduplication and new-module-candidate work in separate milestones rather than combining them with helper extraction.

---

*This artifact is durable posterity under `.paul/assessments/`; it is not a hot-path lifecycle artifact and is not subject to STATE/PROJECT/ROADMAP/MILESTONES byte budgets.*
