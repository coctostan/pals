# Comparative Analysis: Upstream vs PALS

**Phase 146 — v2.31 OG PAUL and CARL Audit**
**Date:** 2026-03-26

---

## Classification Key

| Classification | Meaning |
|---------------|---------|
| **adopt** | Take this into PALS as-is or near-identical |
| **adapt** | Take the concept but modify for our architecture |
| **defer** | Valuable but not worth doing now |
| **reject** | Not compatible or not valuable for PALS |

---

## High-Priority Items

### Item 1: Execute/Qualify (E/Q) Loop

**Classification:** adapt

**Upstream:** After each task in APPLY: Execute → Report Status (DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED) → Qualify (re-read actual output, re-run verify fresh, compare against spec AND linked AC, score PASS/GAP/DRIFT) → loop on gaps until resolved (max 3 attempts). Includes an anti-rationalization table ("If you're thinking 'should work now'... STOP. Instead... run the verify command").

**Our current:** Execute → Run `<verify>` → Record structured status (PASS / PASS_WITH_CONCERNS / BLOCKED) → Ground-truth file check (`git diff`) → Divergence check. Bounded retry (max 2) with revert-and-refine on failure. Stuck detection for unproductive loops.

**Gap:** Two specific gaps:
1. **No explicit "re-read your own output" step.** Our verify runs the check command but doesn't mandate re-reading the files that were just created/modified before claiming completion. The upstream Qualify step forces the model to re-open files it just wrote and compare them against the spec line-by-line. This fights the well-documented "optimistic memory" problem where models remember writing correct code but actually produced something slightly different.
2. **No anti-rationalization guidance.** Upstream has a concrete table of common self-deception patterns with corrective actions. Our workflows don't explicitly address the "I'm confident it works" failure mode.

**What we already cover that upstream doesn't:**
- Ground-truth file check via `git diff` (upstream has no equivalent)
- Divergence check comparing actual vs planned files
- Stuck/loop detection for unproductive retry patterns
- Module dispatch hooks (TODD/WALT post-task enforcement)

**Rationale:** The E/Q loop's core insight — "trust the output, not your memory of producing it" — is genuinely valuable. But adopting the full E/Q framework would create redundancy with our existing verify + ground-truth + divergence + module dispatch pipeline. The right move is to **adapt** by adding the two missing elements (re-read mandate + anti-rationalization) into our existing apply-phase.md without restructuring the whole task execution flow.

**Phase 147 action:** Add a "qualify" substep after verify in apply-phase.md:
- After `<verify>` runs, add: "Re-read files you just created/modified. Compare actual content against `<action>` spec and linked AC. Do not trust execution memory."
- Add the anti-rationalization table from quality-principles.md as an inline reference in apply-phase.md (or as a new `references/evidence-discipline.md`).
- Keep our existing status names (PASS/PASS_WITH_CONCERNS/BLOCKED) — no need to add GAP/DRIFT since our bounded retry + stuck detection covers the same loop-and-fix behavior.

---

### Item 2: Plan Audit (`/paul:audit`)

**Classification:** defer

**Upstream:** Dedicated command + workflow (`audit-plan.md`) that runs between PLAN and APPLY. Assumes "senior principal engineer + compliance reviewer" role. 6-section structured review: executive verdict, what's solid, enterprise gaps, concrete upgrades, audit/compliance readiness, final release bar. Auto-applies must-have and strongly-recommended findings. Config-gated (`enterprise_plan_audit`).

**Our current:** IRIS module runs pre-plan advisory hooks (anti-pattern scan, file size check). Our plan-phase has validate_plan step (clarity test, section completeness, dual-goal verify/done). No dedicated plan audit between PLAN and APPLY.

**Gap:** We don't have a formal "audit the plan before execution" step. IRIS catches code-level anti-patterns but doesn't review the plan's architectural soundness, security posture, or compliance readiness.

**Rationale — defer, not adopt:**
1. **Audience mismatch.** The upstream audit assumes enterprise/regulated environments (SOC 2, ISO, legal). PALS is positioned as "the Linux of Harness Engineering" for individual developers and small teams. The enterprise audit framing would add weight without proportional value for most PALS users.
2. **Existing coverage.** Our module system (IRIS pre-plan, ARCH pre-plan, DEAN pre-plan enforcement) already catches many of the same concerns through different mechanisms — just not packaged as a single "audit" step.
3. **Optional by nature.** Even upstream makes this config-gated. Adding an optional command that most users won't use adds maintenance cost without usage.
4. **Better approach for PALS.** If we want plan auditing, it's more natural to enhance IRIS's pre-plan hook to include plan-level review (not just file-level anti-pattern scans) rather than adding a separate command and workflow.

**Future consideration:** If PALS expands into enterprise/team use, revisit this. The 6-section audit structure is well-designed and could become an IRIS enhancement or a new module.

---

### Item 3: Upstream CARL Capabilities

**Classification:** reject (for domain/MCP/staging); adapt (for one concept)

**Upstream CARL** is a fundamentally different product from our CARL:

| Capability | Upstream | Ours | Assessment |
|-----------|----------|------|-----------|
| **Domain-based rule injection** | Keywords in prompts trigger domain-specific rules | N/A — our CARL is session boundary only | **Reject.** Different product. Our module system handles contextual behavior (18 modules with hooks). Adding domain/keyword matching would duplicate module dispatch. |
| **MCP server** | 4 tool groups for runtime management | N/A | **Reject.** Adds runtime dependency (Node.js MCP server). Our Pi extension model is simpler. MCP is interesting technology but PALS shouldn't depend on it. |
| **Rule staging pipeline** | Proposed rules → review → approve/kill | N/A | **Reject.** Rule governance is relevant for standalone CARL but not for PALS modules, which are configured via pals.json and dispatched via workflows. |
| **Context brackets** | FRESH/MODERATE/DEPLETED behavior adaptation | CARL thresholds (continue_threshold, safety_ceiling) | **Already covered.** Our CARL triggers session boundaries at thresholds. Upstream adapts behavior within sessions. Our modules + CARL combined cover this. |
| **Formal JSON schema** | `carl.schema.json` with JSON Schema validation | `pals-json-schema.md` (informal reference) | **See Item 6 below.** |
| **Migration tooling** | `migrate-v1-to-v2.sh` for config migration | plan-phase `check_config_version` step | **Adapt concept.** We have schema version checking in plan-phase but no automated migration script. Worth noting for future schema changes. |

**Rationale:** The two CARLs have diverged so far that "adoption" would mean building a new product, not updating existing code. Our CARL (session boundary manager) + our module system (18 modules with lifecycle hooks) collectively cover more ground than upstream CARL's domain/rule system — just organized differently. The only transferable concept is the migration tooling pattern.

**Phase 147 action:** None for CARL capabilities. Note migration tooling pattern for future use.

---

## Medium-Priority Items

### Item 4: Quality Principles Reference

**Classification:** adapt

**Upstream:** Standalone `quality-principles.md` with 9 principles: solo_developer_claude, plans_are_prompts, loop_first, acceptance_driven, evidence_before_claims, scope_control, claude_automates, deviation_rules, ship_fast, anti_enterprise. Clean, opinionated, quotable.

**Our current:** These principles are embedded across our workflows (plan-phase.md has clarity test, apply-phase.md has structured status, etc.) but not extracted as a standalone document.

**Gap:** No single reference that captures PALS philosophy. New users or contributors must read multiple workflow files to understand the governing principles.

**Rationale:** The `evidence_before_claims` principle with its anti-rationalization table is particularly strong and directly supports Item 1 (E/Q adapt). The `plans_are_prompts` framing is useful for explaining why PLAN.md is structured the way it is. Extracting our own principles doc (not copying upstream's) would improve onboarding and provide an anchor for the anti-rationalization guidance.

**Phase 147 action:** Create `kernel/references/quality-principles.md` with PALS-specific principles. Incorporate the anti-rationalization table from upstream. Adapt for our module-aware, multi-driver architecture. Don't copy — write fresh with our philosophy.

---

### Item 5: Quick-Track UNIFY

**Classification:** adapt

**Upstream:** Plans with single task + no boundaries section → `is_quick_fix = true` → compressed SUMMARY (frontmatter + one-section summary, no full AC table, no deviations section).

**Our current:** Fix-loop fast-forward mode skips ALL hooks and produces minimal output. But standard plans (even single-task ones) always get full SUMMARY with all sections. There's no middle ground.

**Gap:** A standard single-task plan (not a fix) produces the same heavyweight SUMMARY as a 3-task multi-file plan. This is unnecessary overhead for simple work.

**Rationale:** Quick-track is a sensible optimization that matches our existing pattern (fix-loop fast-forward = zero overhead). The gap is between "full overhead" standard plans and "zero overhead" fixes. Adding a compressed SUMMARY path for simple standard plans reduces bureaucratic weight without losing traceability.

**Phase 147 action:** Add quick-track detection to `unify-phase.md`: if plan has ≤1 task AND no boundaries section AND no checkpoints, use compressed SUMMARY format. Keep full module dispatch — only compress the SUMMARY document itself.

---

### Item 6: Formal JSON Schema

**Classification:** defer

**Upstream:** `carl.schema.json` — machine-readable JSON Schema for carl.json validation. Includes required fields, types, enums, descriptions.

**Our current:** `kernel/references/pals-json-schema.md` — human-readable markdown describing pals.json structure. No machine-readable validation.

**Gap:** pals.json config errors are only caught when a workflow reads a field and gets unexpected data. A formal schema would catch errors at init/migration time.

**Rationale — defer:**
1. **Low incident rate.** We haven't had config validation issues reported. The `check_config_version` step in plan-phase catches missing fields.
2. **Runtime dependency.** JSON Schema validation requires a validator library or external tool. Adds complexity.
3. **Maintenance cost.** Schema must stay in sync with pals.json structure. Every module addition or config change requires schema update.
4. **Value is real but not urgent.** Worth doing when PALS has external contributors or users who hand-edit pals.json frequently.

**Future consideration:** When/if PALS publishes an NPM package or gains external users, add formal schema validation to the init workflow.

---

### Item 7: NPM Distribution

**Classification:** defer

**Upstream:** `npx paul-framework` — cross-platform install via NPM. Node.js installer handles Windows/Mac/Linux, creates directory structure, copies files.

**Our current:** Shell-based `install.sh` per driver. Pi driver installs via Pi skill system. Claude Code driver uses shell scripts.

**Gap:** No single cross-platform install command. Users must clone the repo and run shell scripts.

**Rationale — defer:**
1. **Architecture mismatch.** Upstream has one target (Claude Code). We have multiple drivers (Pi, Claude Code, Agent SDK). NPM install would need to handle driver selection.
2. **Pi is primary.** Most PALS usage is through Pi, which has its own skill installation mechanism.
3. **Premature optimization.** Our user base is small. Shell scripts work. NPM publishing adds CI/CD, versioning, and package maintenance overhead.
4. **Future milestone candidate.** When PALS is ready for public distribution, NPM + Pi package registry would be the right channels.

---

## Low-Priority Items

### Item 8: SonarQube Workflow

**Classification:** reject

**Upstream:** Active workflow (`quality-gate.md`) that runs SonarQube scans via MCP, checks gates, updates CONCERNS.md.

**Our current:** `kernel/references/sonarqube-integration.md` reference file (documentation only). WALT module handles quality gating inline (tests, lint, typecheck).

**Rationale:** SonarQube is a niche enterprise integration. Our WALT module + DEAN dependency audit + IRIS code review collectively cover quality gating without requiring a SonarQube server. The existing reference file is sufficient for users who want to integrate SonarQube independently.

---

### Item 9: BASE Satellite System

**Classification:** reject

**Upstream:** `paul.json` manifest + `register-manifest.md` workflow for BASE workspace management auto-detection.

**Our current:** N/A — PALS doesn't have a BASE system.

**Rationale:** BASE is upstream-specific infrastructure for managing multiple PAUL projects in a workspace. Not relevant to PALS architecture. Our pals.json serves project-level configuration without needing external discovery.

---

### Item 10: PAUL-VS-GSD.md

**Classification:** reject

**Upstream:** Competitive positioning document comparing PAUL to GSD (Get Shit Done framework).

**Our current:** N/A

**Rationale:** Marketing/positioning document. Not functional. The core insight ("execution without reconciliation creates drift") is already embodied in our loop discipline. No action needed.

---

## Summary of Classifications

| # | Item | Classification | Phase 147 Action |
|---|------|---------------|------------------|
| 1 | E/Q Loop | **adapt** | Add qualify substep + anti-rationalization to apply-phase.md |
| 2 | Plan Audit | defer | None now; consider IRIS enhancement later |
| 3 | CARL Capabilities | reject | None (fundamentally different product) |
| 4 | Quality Principles | **adapt** | Create kernel/references/quality-principles.md |
| 5 | Quick-Track UNIFY | **adapt** | Add compressed SUMMARY path to unify-phase.md |
| 6 | Formal JSON Schema | defer | Consider when external users arrive |
| 7 | NPM Distribution | defer | Consider for public distribution milestone |
| 8 | SonarQube Workflow | reject | Existing reference is sufficient |
| 9 | BASE Satellite | reject | Not relevant to PALS |
| 10 | PAUL-VS-GSD | reject | Not functional |

## Phase 147 Scope

**3 items to implement:**
1. **Adapt E/Q Loop** → Add qualify substep + anti-rationalization reference to apply-phase.md
2. **Adapt Quality Principles** → Create kernel/references/quality-principles.md
3. **Adapt Quick-Track UNIFY** → Add compressed SUMMARY detection to unify-phase.md

**Estimated impact:** 3 files modified/created. Low risk — additive changes to existing workflows.
