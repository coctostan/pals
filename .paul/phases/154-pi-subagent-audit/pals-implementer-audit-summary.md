# Phase 154 Audit: PALS Implementer Audit Summary

## Phase 155 framing

Phase 155 should treat this audit as confirmation that the desired PALS-native implementer does **not** already exist as a clean repo-controlled path. The design phase needs to define it deliberately.

## Confirmed Findings

1. **Current deliberate custom-subagent usage is REV-first, not APPLY-first.**
   - The only explicit current repo-controlled custom subagent dispatch in live PALS Pi files is `code-reviewer` via `/paul-review` and optional UNIFY merge-gate review.
2. **Research/discovery already uses subagents, but in read-only roles.**
   - `research.md` and `map-codebase.md` show `Explore` / `general-purpose` usage for analysis, not execution.
3. **Current `implementer` is runtime-global and generic.**
   - `~/.pi/agent/agents/implementer.md` exists, but it is just a generic strict-TDD agent definition. It is not PALS-aware.
4. **Repo-controlled PALS does not currently route APPLY through `implementer`, `worker`, or `spec-reviewer`.**
   - No audited repo call sites in `drivers/` or `kernel/` dispatch those names.
5. **Current project config only meaningfully shapes REV.**
   - `pals.json` has `modules.rev.*` and guided-workflow config, but no generic `agents` block for implementation routing.
6. **Module authority still lives in shared workflows and installed `modules.yaml`.**
   - The Pi extension and current global `implementer` file do not show full TODD/WALT/DEAN propagation into an execution subagent.
7. **Bounded PALS context injection exists, but it is intentionally small.**
   - The Pi extension injects phase/loop/next-action context and an authority reminder, not a full APPLY prompt or module overlay set.

## Gaps

### Gap 1: No repo-controlled PALS-native implementer dispatch

Current state:
- inline APPLY is still the canonical execution path
- no current workflow file dispatches `implementer` as the APPLY engine

Desired future state:
- a repo-controlled implementation path that can behave like inline APPLY while using a fresh context window

### Gap 2: Current `implementer` prompt is not PALS-aware

Current `implementer.md` includes:
- strict TDD
- small scoped changes
- commit when tests pass

It does **not** include:
- `.paul/*` authority
- plan-task execution semantics
- task verification requirements
- checkpoint handling
- deviation logging
- APPLY → UNIFY handoff expectations
- installed module registry loading
- explicit TODD/WALT/DEAN discipline

### Gap 3: Module reach is not established for execution subagents

Current evidence supports:
- parent workflow module dispatch
- minimal workflow-context injection

Current evidence does **not** support:
- automatic module prompt assembly inside `implementer`
- active extension loading that reproduces APPLY semantics
- subagent-side enforcement equivalent to inline APPLY

### Gap 4: Agent-definition state is inconsistent

- `implementer.md` is active and inspectable
- `code-reviewer.md`, `worker.md`, and `spec-reviewer.md` are missing at expected active paths
- historical copies exist only in `oldAgents/`

That means the runtime surface is partially file-backed and partially opaque. Phase 155 should not assume current agent definitions are cleanly normalized.

### Gap 5: Project config cannot currently declare an implementation strategy

The current `pals.json` can:
- configure REV behavior
- configure guided workflow UX

It cannot currently:
- choose inline APPLY vs subagent APPLY
- configure an implementer model/path cleanly
- declare module-propagation strategy for an execution subagent

## Constraints

Phase 155 must preserve these constraints from the approved milestone/phase context:

- `.paul/*` remains authoritative
- additive-only changes
- preserve REV behavior
- Pi-only scope is acceptable
- do not require every subagent to become PALS-aware
- inline APPLY remains the reference model

Additional audit-derived constraint:

- Do not treat current generic `implementer` / `worker` behavior as authoritative PALS semantics without repo-controlled wiring and explicit module/lifecycle contracts.

## Recommendations

1. **Do not use generic `implementer` or `worker` as the canonical PALS APPLY path yet.**
   - They may be useful runtime primitives, but they are not yet a proven PALS execution model.
2. **Keep inline APPLY as the behavioral reference.**
   - Phase 155 should define equivalence against inline APPLY, not against current generic subagent prompts.
3. **Design a deliberate PALS-native execution contract before implementation.**
   - Prompt assembly
   - context strategy
   - module propagation
   - verification/reporting ownership
   - state/summarization handoff
4. **Treat observed `worker` / `implementer` session behavior as exploratory runtime evidence only.**
   - Carry it forward as an input, not as a settled design fact.
5. **Normalize file-backed agent evidence as part of design risk management.**
   - Phase 155 should decide whether active agent definitions need cleanup/standardization or whether PALS should rely on explicit runtime parameters instead.

## Open Questions

1. **Agent identity:** Should Phase 155 introduce a dedicated `pals-implementer` agent type, or intentionally reuse `implementer` with a repo-controlled prompt assembly contract?
2. **Context strategy:** Should the implementer rely on bounded inherited context, explicit prompt assembly, `inherit_context`, or a hybrid?
3. **Module strategy:** How do TODD/WALT/DEAN semantics reach the implementer — prompt text, installed extensions, parent orchestration, or staged parent/subagent handoff?
4. **Verification ownership:** Which verification stays in the parent APPLY workflow, and which checks may run inside the implementer?
5. **State ownership:** How are STATE/SUMMARY/deviation records preserved if implementation work happens in a fresh subagent session?
6. **Model control:** Where should model override live — `pals.json`, agent file defaults, explicit dispatch call, or layered resolution like REV?
7. **Tooling contract:** Should the implementer keep full edit/bash tooling, and under what boundaries?
8. **Extension loading:** Does the implementer need explicit extensions for PALS discipline, or should PALS remain prompt/workflow driven?
9. **Runtime hygiene:** Are missing active files for `code-reviewer`, `worker`, and `spec-reviewer` acceptable, or should agent-definition layout be normalized first?
10. **Fallback mode:** If a dedicated implementer path fails or is unavailable, what is the exact fallback to inline APPLY?

## Phase 155 design input checklist

Phase 155 should leave with explicit answers for:

- the chosen implementer dispatch model
- the prompt/context assembly recipe
- module reach and enforcement boundaries
- how equivalence to inline APPLY will be evaluated
- how PALS artifacts remain authoritative even when execution happens in a fresh subagent window

## Final recommendation for now

Use the current audit result operationally as follows:

- **Canonical execution today:** inline APPLY
- **Canonical review subagent today:** `code-reviewer`
- **Canonical research subagents today:** `Explore`, `general-purpose`
- **Status of generic `implementer` / `worker`:** available runtime tools, but not yet trusted PALS implementation semantics
