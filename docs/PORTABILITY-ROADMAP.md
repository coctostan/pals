# PALS Portability Roadmap

> **Status: historical/frozen reference.** This roadmap preserves prior cross-harness portability planning, artifact-first constraints, and hidden-state warnings. It is no longer the active product roadmap for current PALS development. Pi-native architecture work should use `docs/PI-NATIVE-SUPPORT-INVENTORY.md` for current support-tier classification and follow-up decisions.

## Objective

Make PALS portable across harnesses while preserving the same `.paul/` artifacts as the authoritative runtime state.

Success means a project can move between harnesses without migrating or reinterpreting its workflow artifacts.

---

## Guiding principle

> **Artifacts are authoritative; prompts are interpretive.**

Portable:
- `.paul/` files
- workflow identities
- module manifests
- lifecycle rules
- hook semantics

Adapter-specific:
- command UX
- prompt wording
- installation paths
- interactive UI style

---

## Phase 1 — Formalize the portable contract

### 1. Add artifact spec
Create `docs/ARTIFACT-SPEC.md` covering:
- `.paul/STATE.md`
- `.paul/PROJECT.md`
- `.paul/ROADMAP.md`
- `.paul/MILESTONES.md`
- `.paul/SPECIAL-FLOWS.md`
- `*-PLAN.md`
- `*-SUMMARY.md`
- handoff files

For each artifact, define:
- purpose
- required sections
- optional sections
- frontmatter keys
- who writes it
- who reads it

### 2. Add lifecycle spec
Create `docs/LIFECYCLE-SPEC.md` covering:
- loop states
- phase states
- valid transitions
- invalid transitions
- transition preconditions
- transition postconditions
- artifact obligations per step

### 3. Clarify workflow identities
Make kernel workflows the portable units:
- `init-project`
- `plan-phase`
- `apply-phase`
- `unify-phase`
- `transition-phase`
- etc.

Document command names as adapter UX, not kernel truth.

---

## Phase 2 — Separate core from adapter assumptions

### 4. Strengthen driver/harness abstraction
Update `docs/DRIVER-SPEC.md` or add `docs/HARNESS-PRIMITIVES.md`.

Define portable primitives such as:
- read file
- write file
- edit file
- run shell command
- ask user for input
- ask user to choose
- ask user to confirm
- invoke workflow
- dispatch hook
- load reference

### 5. Remove normative Claude-specific assumptions from base docs
Demote these to adapter concerns:
- `~/.claude/...`
- Claude tool names
- `AskUserQuestion`
- slash-command syntax as the core invocation model

### 6. Normalize resource resolution
Define logical categories:
- kernel resources
- module resources
- project artifacts
- adapter-installed paths

Do not make installed locations like `~/.pals` normative in core contracts.

---

## Phase 3 — Make hooks portable

### 7. Tighten hook contract
For each hook, define:
- when it fires
- input shape
- allowed outputs
- merge order
- blocking behavior
- persistence expectations

### 8. Persist important hook outcomes
Anything needed across harnesses should be:
- written to artifacts, or
- derivable from artifacts

Examples:
- decisions
- overrides
- deviations
- quality annotations
- skill audit results

---

## Phase 4 — Enforce the contract

### 9. Build artifact validation
Add a validator or audit workflow that checks:
- required sections
- frontmatter validity
- loop consistency
- roadmap consistency
- plan/summary pairing
- phase numbering and status coherence

### 10. Add parity fixtures
Create sample project states and verify that multiple adapters:
- read the same `.paul/` inputs
- produce valid `.paul/` outputs
- preserve lifecycle state

The goal is structural parity, not identical prose.

---

## Phase 5 — Ship adapters

### 11. Keep adapters thin
Each adapter should:
- map harness UX to portable primitives
- invoke live kernel workflows
- respect module manifests
- read/write the same `.paul/` artifacts

### 12. Recommended first portability target
Implement the first non-Claude adapter against the formalized contracts, not against Claude-specific command behavior.

---

## Deliverables checklist

### Core docs
- [ ] `docs/ARTIFACT-SPEC.md`
- [ ] `docs/LIFECYCLE-SPEC.md`
- [ ] Updated `docs/DRIVER-SPEC.md` or new `docs/HARNESS-PRIMITIVES.md`
- [ ] Updated portability notes in architecture docs

### Core behavior
- [ ] Workflow identities documented independently of commands
- [ ] Hook persistence expectations clarified
- [ ] Resource/path abstraction documented

### Tooling
- [ ] Artifact validator
- [ ] Fixture-based parity tests

### Adapter readiness
- [ ] Base PALS no longer depends normatively on Claude-only assumptions
- [ ] Same `.paul/` artifacts drive process across harnesses

---

## Exit criteria

PALS portability is ready when:
- a project can move between harnesses using only `.paul/` plus base PALS definitions
- adapters do not require hidden conversational state to understand current workflow state
- generated artifacts validate against the same core contract
- commands remain harness-specific while workflows and artifacts remain shared
