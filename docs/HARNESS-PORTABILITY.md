# PALS Harness Portability Notes

> **Status: historical/frozen reference.** This document preserves prior cross-harness design thinking, artifact-first constraints, and hidden-state warnings. It is no longer the active product roadmap for current PALS development. Pi-native architecture work should use `docs/PI-NATIVE-SUPPORT-INVENTORY.md` for current support-tier classification and follow-up decisions.

## Goal

PALS should become a **portable artifact-driven workflow kernel** whose state and process can move between harnesses (Claude Code, pi, Codex, future adapters) without migrating project data.

The key idea is:

> **Artifacts are authoritative; prompts are interpretive.**

In other words, the portable runtime is not a specific prompt transcript or harness UX. The portable runtime is:

- the `.paul/` artifacts
- the workflow definitions
- the module manifests
- the lifecycle and hook contracts

Different harnesses should be able to drive the same project by reading and writing the same artifacts.

---

## What portability means

Portability does **not** require word-for-word identical outputs. No LLM-based harness will guarantee that.

Portability **does** require:

- the same artifact set
- the same artifact semantics
- the same lifecycle transitions
- the same module participation rules
- the ability to resume work in another harness using only the artifacts plus core PALS definitions

Success looks like this:

- Start a PLAN/APPLY/UNIFY loop in one harness
- Continue it in another harness
- Return to the first harness later
- Never migrate `.paul/`
- Never lose process state because it lived only in hidden conversational context

---

## What should remain portable and canonical

### Project artifacts

These should be treated as the canonical portable runtime state:

- `.paul/STATE.md`
- `.paul/PROJECT.md`
- `.paul/ROADMAP.md`
- `.paul/MILESTONES.md`
- `.paul/SPECIAL-FLOWS.md`
- `.paul/phases/{phase}/{plan}-PLAN.md`
- `.paul/phases/{phase}/{plan}-SUMMARY.md`
- handoff files

### Kernel resources

These should remain source-of-truth process definitions:

- `kernel/workflows/*`
- `kernel/templates/*`
- `kernel/references/*`
- `kernel/rules/*`

### Module resources

These should remain source-of-truth extension points:

- `modules/*/module.yaml`
- `modules/*/references/*`
- `modules/*/workflows/*`
- module config/resources where applicable

---

## What must be abstracted in base PALS

To make portability real, base PALS should abstract the following.

### 1. Artifact schema

The artifact formats need to become explicitly normative.

For each major `.paul/` file, define:

- purpose
- required sections
- optional sections
- frontmatter keys
- allowed state values
- what workflow may create/update it
- what later workflows may depend on it

This becomes the actual portability contract.

**Recommended addition:** `docs/ARTIFACT-SPEC.md`

---

### 2. Lifecycle state machine

The PLAN → APPLY → UNIFY loop needs a more formal contract.

Define:

- valid loop states
- valid transitions
- invalid transitions
- required preconditions per transition
- required postconditions per transition
- what artifacts must be read or written at each step

This lets multiple harnesses derive the same process state from the same artifacts.

**Recommended addition:** `docs/LIFECYCLE-SPEC.md`

---

### 3. Harness primitive interface

Base PALS should stop depending on Claude-specific primitives like:

- slash commands as the core invocation model
- Claude tool names
- `AskUserQuestion`
- `~/.claude/...` assumptions

Instead, define a small harness-independent primitive vocabulary such as:

- read artifact
- write artifact
- edit artifact
- execute shell command
- ask user for freeform input
- ask user to choose from options
- ask user to confirm
- invoke workflow by name
- dispatch module hook
- load reference resource

The adapter for each harness maps its native UX/tools onto these primitives.

**Recommended update:** strengthen `docs/DRIVER-SPEC.md` or create `docs/HARNESS-PRIMITIVES.md`

---

### 4. Hook dispatch contract

Hooks are already conceptually defined, but portability depends on making them more operationally explicit.

For each hook, define:

- when it fires
- input context shape
- allowed outputs
- merge behavior
- blocking behavior
- whether outputs must persist to artifacts or are only in-memory/prompt-time

Important principle:

> If a hook result matters to later phases or later harnesses, it should either land in an artifact or be derivable from artifacts.

This avoids portability depending on hidden prompt context.

---

### 5. Resource/path resolution

Base PALS should stop treating installed filesystem locations like `~/.pals` or `~/.claude` as normative.

Instead, separate:

- logical kernel resources
- logical module resources
- project artifacts
- adapter-specific install/discovery paths

In other words, `kernel/workflows/plan-phase.md` is the portable resource; `~/.pals/workflows/plan-phase.md` is just one adapter installation detail.

---

### 6. Command surface vs workflow surface

Commands should be treated as **adapter UX**, not kernel truth.

The portable thing is:

- `plan-phase`
- `apply-phase`
- `unify-phase`
- `transition-phase`

The non-portable thing is how a harness exposes them:

- slash command
- extension command
- skill
- prompt template
- API call
- menu item

PALS should define workflow identities, inputs, preconditions, and artifact effects. Each harness can choose its own invocation UX.

---

## What should remain non-normative

These can vary by harness without breaking portability:

- exact prose generated in plans/summaries
- how prompts are shown to the user
- command names and menus
- selection widgets / interactive UX
- continuation prompts like “press 1 to continue”
- adapter-specific installation paths

The system should care about structure and state, not literal wording.

---

## Design principle for portable PALS

A good way to think about the architecture:

### Layer 1 — Artifact contract
What files exist, what they mean, and what state they encode.

### Layer 2 — Workflow contract
What each workflow does: inputs, preconditions, postconditions, artifacts touched, and transitions caused.

### Layer 3 — Module contract
What hooks exist, how modules participate, and how module outputs compose.

### Layer 4 — Adapter contract
How a harness provides file access, shell execution, user interaction, workflow invocation, hook dispatch, and UX.

If these four layers stay cleanly separated, PALS becomes transportable.

---

## Practical recommendations for base PALS

### A. Add an artifact spec
Create a dedicated spec for `.paul/` and related outputs.

### B. Strengthen the driver spec
Make adapter obligations more explicit and less descriptive.

### C. Remove normative Claude-path assumptions
Treat installed paths and Claude-specific integration details as adapter implementation details.

### D. Make workflow side effects explicit
For each workflow, define:

- artifacts read
- artifacts written
- required state change
- hooks that may fire

### E. Add artifact validation
Create a validator or audit workflow that checks:

- required sections
- frontmatter keys
- state consistency
- plan/summary pairing
- roadmap/phase consistency
- loop coherence

Validation matters more than prose identity.

### F. Persist important hook outcomes to artifacts
If a decision, override, quality annotation, or deviation matters later, it should not live only in model context.

---

## Suggested near-term refactor checklist

### High impact, low-medium effort
1. Add `docs/ARTIFACT-SPEC.md`
2. Tighten `docs/DRIVER-SPEC.md` into a more normative harness primitive contract
3. Remove or demote Claude-specific paths/tool names in base specs
4. Document commands as adapter UX over workflow identities

### High impact, medium effort
5. Add `docs/LIFECYCLE-SPEC.md`
6. Make workflow preconditions/postconditions explicit
7. Clarify which hook outputs must persist into artifacts

### High impact, higher effort
8. Build an artifact validator
9. Build parity tests using fixture `.paul/` states across adapters
10. Ensure cross-harness resume works without hidden state

---

## Portability success criterion

PALS portability is successful when:

- a project can move from one harness to another
- the new harness can reconstruct process state from `.paul/` plus core PALS resources
- no adapter needs hidden conversational state to know what should happen next
- the same artifact set continues to drive planning, execution, reconciliation, and resume

---

## Summary

To make workflow artifacts transportable across harnesses, base PALS should formalize and abstract:

1. artifact schemas
2. lifecycle/transition rules
3. harness primitives
4. hook dispatch semantics
5. resource/path resolution
6. commands as adapter UX, not kernel truth

The portable runtime should be:

- `.paul/` artifacts
- workflow definitions
- module manifests
- lifecycle rules

Harnesses should become thin execution surfaces over that shared kernel.
