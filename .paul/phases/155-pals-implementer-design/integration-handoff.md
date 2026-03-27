# Phase 155 Design — Integration Handoff

## Intent

Turn the Phase 155 design decisions into an executable handoff for:
- **Phase 156** — implementation of the repo-controlled PALS-native implementer path
- **Phase 157** — validation that the implemented path preserves APPLY semantics and authority boundaries

This handoff assumes the design decisions in:
- `pals-implementer-contract.md`
- `prompt-and-module-strategy.md`

---

## Phase 156 Integration Targets

Phase 156 should implement the smallest additive slice that proves the design without broadening scope.

### Likely repo-controlled targets

#### 1. Repo-local agent definition
- `.pi/agents/pals-implementer.md`

Purpose:
- create a dedicated custom agent identity for bounded APPLY task execution
- encode stable role/defaults, not live lifecycle state

#### 2. Pi driver / skill routing surfaces
- `drivers/pi/skills/paul-apply/SKILL.md`
- `kernel/workflows/apply-phase.md`

Purpose:
- document and wire the parent-controlled delegation model
- define where task-level `Agent()` dispatch is allowed
- define fallback to inline APPLY

#### 3. Pi extension behavior only if strictly needed
- `drivers/pi/extensions/pals-hooks.ts`

Purpose:
- only update if implementation requires additive Pi-native ergonomics or bounded routing support
- do not make the extension the source of lifecycle truth

#### 4. Project/runtime configuration surfaces if implementation needs them
- `pals.json`
- related schema/reference docs if config fields are introduced

Purpose:
- optionally add a repo-controlled implementer config block for model/routing defaults
- do not overload REV-only config for implementation routing

#### 5. Validation fixtures or example artifacts
- `.paul/phases/156-.../` phase outputs
- any repo-local fixtures needed to prove `Agent()` dispatch or fallback behavior

Purpose:
- make the new path demonstrable and reviewable in-repo

---

## Implementation Order

### 1. Create the dedicated custom agent file
Implement `.pi/agents/pals-implementer.md` first.

Reason:
- it defines the stable execution role
- it avoids dependence on the generic runtime-global `implementer`
- it gives Phase 156 a concrete dispatch target

### 2. Add parent-side dispatch logic in APPLY
Update the parent APPLY path so it can:
- decide whether a task is eligible for delegation
- assemble the task packet
- call `Agent()` with the repo-local agent type
- capture and interpret the result
- fall back inline when needed

This is the core implementation step.

### 3. Keep module and verification authority in the parent
Before adding any extra ergonomics, ensure:
- pre-apply hooks still run in the parent
- post-task and post-apply checks still run in the parent
- task completion is still judged by the parent
- `.paul/*` updates remain parent-authored

### 4. Add optional config only if needed
If Phase 156 needs model/routing configuration, add the narrowest possible repo-controlled fields.

Example scope:
- implementer enabled/disabled toggle
- default model override
- possibly a bounded strategy flag for delegation eligibility

Do not add a large agent-routing framework.

### 5. Add any Pi UX refinements last
Only after the execution contract works should Phase 156 consider additive Pi-facing ergonomics.

Examples:
- clearer status text around delegated tasks
- reporting that fallback occurred
- no new Pi-owned lifecycle state

---

## Risks and Constraints

### Risks and Constraints

#### Risk 1 — Generic runtime drift
The runtime-global `implementer` may keep existing and evolving independently of this repo.

Constraint:
- Phase 156 must not depend on its semantics
- the repo-local `pals-implementer` must be the authoritative execution identity for this feature

#### Risk 2 — Hidden authority shift
It is easy to accidentally move verification or state ownership into the subagent.

Constraint:
- parent remains authoritative for verification, module enforcement, STATE updates, and SUMMARY generation

#### Risk 3 — Over-delegation
Delegating a full APPLY loop instead of bounded tasks would blur checkpoint handling, fallback, and module discipline.

Constraint:
- Phase 156 should implement task-bounded delegation only

#### Risk 4 — Ambient-context dependence
If the implementer only works when it happens to inherit conversation context, the design is not robust.

Constraint:
- the parent task packet must be sufficient on its own
- `inherit_context` should remain optional, not foundational

#### Risk 5 — Module propagation confusion
The audit did not prove automatic module overlays inside subagents.

Constraint:
- treat modules as parent-orchestrated unless explicitly validated otherwise
- do not claim TODD/WALT/DEAN equivalence from agent-file presence alone

#### Risk 6 — REV regression
The project already has a mature deliberate subagent path for review.

Constraint:
- implementation must not change `code-reviewer` dispatch behavior or REV config semantics

#### Risk 7 — Pi-only truth creep
Adapter convenience work can quietly become a second lifecycle engine.

Constraint:
- any Pi changes must remain additive presentation/routing support around `.paul/*`

---

## Migration Constraints

Phase 156 should preserve current behavior for ordinary APPLY work unless the new path is explicitly selected and validated.

That implies:
- inline APPLY continues to work as before
- no requirement to install or trust a global `implementer`
- graceful degradation if `Agent()` or `pi-subagents` is unavailable
- no breaking changes to existing REV, research, or map-codebase flows

---

## Cross-Reference Map

### Contract → implementation implications
- `pals-implementer-contract.md` / **Parent Responsibilities**
  - Phase 156 must keep verification, module dispatch, and lifecycle writes in the parent
- `pals-implementer-contract.md` / **Fallback**
  - Phase 156 must implement a clear inline fallback path
- `pals-implementer-contract.md` / **Equivalence to Inline APPLY**
  - Phase 157 must validate behavioral equivalence, not just successful dispatch

### Strategy → implementation implications
- `prompt-and-module-strategy.md` / **Prompt Assembly**
  - Phase 156 must build a task packet explicitly, not depend on ambient context only
- `prompt-and-module-strategy.md` / **Agent File Contract**
  - `.pi/agents/pals-implementer.md` must hold stable defaults, not task-specific state
- `prompt-and-module-strategy.md` / **Module Participation Model**
  - parent keeps WALT/DEAN/TODD enforcement authority
- `prompt-and-module-strategy.md` / **Model Resolution**
  - config layering should be parent-controlled and minimal

---

## Phase 157 Validation Matrix

### Phase 157 Validation Matrix

| Area | What must be proven | Expected result |
|---|---|---|
| `Agent()` routing | Parent APPLY can dispatch a bounded task to `pals-implementer` through `Agent()` | Delegation works without changing lifecycle authority |
| `.pi/agents` compatibility | Repo-local custom agent definition is discovered and used correctly | No dependency on runtime-global `implementer` |
| Prompt sufficiency | Delegated task succeeds with explicit task packet and minimal inherited context | `inherit_context` is optional, not required |
| Parent authority | Parent still owns verification, module dispatch, STATE updates, and SUMMARY generation | `.paul/*` remains authoritative |
| TODD/WALT/DEAN discipline | Module enforcement still occurs at parent boundaries | No false claim of automatic subagent parity |
| Checkpoint handling | Tasks needing human checkpointing remain parent-blocked | No hidden checkpoint delegation |
| Fallback | Missing/failed subagent path returns control to inline APPLY cleanly | Loop continues without ambiguity |
| REV preservation | `/paul-review` and any REV merge-gate path remain unchanged | No regression in review behavior |
| Resume integrity | A later `/paul-resume` still makes sense from `.paul/*` alone | No hidden subagent-only state required |
| Reporting fidelity | Parent can explain what changed, what ran, and what passed/failed | UNIFY has enough durable evidence |

---

## Suggested Validation Scenarios

### Scenario 1 — Happy-path delegated task
- delegate one eligible non-checkpoint task
- verify the subagent returns structured results
- verify the parent runs official task verification and module hooks afterward

### Scenario 2 — Missing subagent availability
- simulate absent `Agent()` / unavailable `pi-subagents`
- verify the parent falls back inline without losing plan progress

### Scenario 3 — Incomplete subagent result
- simulate weak or partial reporting from the subagent
- verify the parent rejects blind completion and either retries or falls back

### Scenario 4 — Checkpoint-bearing task
- ensure parent does not blindly delegate a task whose correct execution depends on checkpoint handling

### Scenario 5 — REV non-regression
- run the existing review path and confirm implementation work did not alter it

### Scenario 6 — Resume and UNIFY continuity
- after delegated work, confirm `STATE.md`, APPLY reporting, and later UNIFY still read as a normal PALS loop with no hidden context dependency

---

## Ready for Implementation Checklist

### Ready for Implementation Checklist
- [ ] A dedicated repo-local `pals-implementer` agent file path is chosen
- [ ] Task-bounded delegation, not whole-loop delegation, is the implementation scope
- [ ] Parent-owned verification and module enforcement rules are preserved
- [ ] Inline APPLY fallback behavior is specified before coding begins
- [ ] Any new `pals.json` surface is minimal and repo-controlled
- [ ] REV behavior is explicitly protected from collateral changes
- [ ] Phase 157 validation will test authority, fallback, and resume integrity rather than dispatch alone

---

## Implementation Posture

Phase 156 should be judged successful if it introduces a deliberate repo-controlled execution path that is:
- additive
- parent-controlled
- fallback-safe
- Pi-native where useful
- still subordinate to `.paul/*` lifecycle truth

That is the correct handoff from Phase 155 into implementation and proof.
