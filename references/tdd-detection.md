<overview>
TDD candidate detection heuristics for plan creation. Used by plan-phase.md (via tdd-plan-generation.md) to suggest or confirm TDD suitability during planning.

**Core heuristic:** Can you write `expect(fn(input)).toBe(output)` before writing `fn`?
If yes → TDD candidate. If no → standard plan.
</overview>

<decision_tree>

## TDD Candidate Detection

```
Is the work primarily...

├─ Business logic with defined inputs/outputs?
│  └─ STRONG TDD candidate
│
├─ API endpoint with request/response contract?
│  └─ STRONG TDD candidate
│
├─ Data transformation, parsing, or formatting?
│  └─ STRONG TDD candidate
│
├─ Validation rules or constraints?
│  └─ STRONG TDD candidate
│
├─ Algorithm with testable behavior?
│  └─ STRONG TDD candidate
│
├─ State machine or workflow logic?
│  └─ STRONG TDD candidate
│
├─ Utility function with clear specification?
│  └─ STRONG TDD candidate
│
├─ Mixed scope (some testable logic + some UI/config)?
│  └─ MODERATE — split into TDD plan (logic) + execute plan (UI/config)
│
├─ UI layout, styling, or visual components?
│  └─ SKIP TDD — use type: execute
│
├─ Configuration or environment changes?
│  └─ SKIP TDD — use type: execute
│
├─ Glue code connecting existing tested components?
│  └─ SKIP TDD — use type: execute
│
├─ Simple CRUD with no business logic?
│  └─ SKIP TDD — use type: execute
│
├─ Exploratory prototyping?
│  └─ SKIP TDD — use type: research or execute
│
└─ One-off scripts or migrations?
   └─ SKIP TDD — use type: execute
```

</decision_tree>

<signals>

## Positive Signals (Favor TDD)

- **Defined contract:** Inputs and outputs are known before implementation
- **Behavioral specification:** "Given X, when Y, then Z" is natural to describe
- **Edge cases matter:** Empty inputs, boundaries, error states need explicit handling
- **Regression risk:** Feature will be modified later and must not break
- **Design uncertainty:** TDD forces interface design before implementation
- **Multiple consumers:** Function/module used by different parts of the system

## Negative Signals (Skip TDD)

- **Visual output:** Result is "does it look right?" not "does it return X?"
- **Integration-heavy:** Success depends on external services, not local logic
- **Trivial logic:** Pass-through, simple mapping, no branching
- **Volatile requirements:** Spec will change before tests stabilize
- **Framework boilerplate:** Code follows framework conventions with no custom logic

</signals>

<recommendation_format>

## Output Format

When detecting TDD candidates during plan creation, produce:

```
TDD Assessment: [STRONG | MODERATE | SKIP]

Signals:
  + [positive signal 1]
  + [positive signal 2]
  - [negative signal, if any]

Recommendation: [Create TDD plan | Split into TDD + execute plans | Use standard execute plan]
```

**STRONG:** All or most positive signals present. Create `type: tdd` plan.
**MODERATE:** Mixed signals. Split scope — TDD for testable logic, execute for the rest.
**SKIP:** Primarily negative signals. Use `type: execute`, add tests after if needed.

</recommendation_format>

<mixed_scope>

## Handling Mixed-Scope Phases

When a phase contains both TDD-suitable and non-TDD work:

1. **Split into separate plans** — one `type: tdd`, one `type: execute`
2. TDD plan covers the testable logic (business rules, transforms, validation)
3. Execute plan covers the non-testable work (UI, config, glue code)
4. Set `depends_on` only if genuine dependency exists between them
5. If independent, they can run as parallel Wave 1 candidates

**Do NOT force TDD on non-TDD work.** The goal is design quality through testing, not test coverage metrics.

</mixed_scope>
