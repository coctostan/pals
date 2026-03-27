<evidence_discipline>

## Purpose

Principles and anti-rationalization patterns for maintaining execution integrity. Referenced by apply-phase.md qualify step. Ensures completion claims are backed by evidence, not confidence.

## The Evidence Chain

No completion claim is valid without every link in the chain:

```
Execute → Verify (run command) → Read output → Compare to spec → THEN claim
```

Breaking any link produces a false completion:

| Broken Link | What You Did | Why It Fails |
|-------------|-------------|--------------|
| Skip verify | "It should work" | Hope is not evidence |
| Run verify, skip reading | "I ran it" | Ritual is not verification |
| Read output, skip comparison | "Tests pass" | Tests may be incomplete |
| Compare from memory | "I checked it" | Memory of checking is not verification |

## Anti-Rationalization Patterns

When the qualify step runs during APPLY, watch for these self-deception patterns:

| If you're thinking... | STOP. Instead... | Because... |
|---|---|---|
| "Should work now" | Run the verify command and read its output | Confidence is not evidence |
| "I already checked this" | Check it again, fresh | Memory of checking is not verification |
| "It's close enough" | Compare against the AC word by word | "Close" fails acceptance criteria |
| "The test passes" | Also compare against the spec | Tests can be incomplete |
| "This is a minor deviation" | Log it explicitly | Minor deviations compound into drift |
| "I'm confident it works" | Run it and prove it | Confidence without evidence is the #1 cause of false completions |
| "The plan is basically done" | Check each task's <done> criteria | "Basically" means "not actually" |
| "I'll fix this in the next task" | Fix it now or log the concern | Deferred fixes become forgotten gaps |

## PALS Core Principles

### Plans Are Prompts

PLAN.md is not a document that gets transformed into a prompt. PLAN.md IS the prompt. It contains the objective, context references, acceptance criteria, tasks with verification, and boundaries. When planning, you are writing the prompt that will execute the work.

### Loop Integrity

Every PLAN must complete the full loop:

```
PLAN ──▶ APPLY ──▶ UNIFY
```

Never leave a loop incomplete. UNIFY closes the loop, reconciles plan vs actual, updates state, and creates the audit trail that makes session handoff reliable. Orphan plans produce drift.

### Acceptance-Driven

Acceptance criteria are first-class, not afterthoughts. Every plan has numbered ACs in Given/When/Then format. Every task links to its ACs via `<done>`. SUMMARY maps results back to AC numbers. If you can't define "done" before starting, the scope isn't clear enough.

### Evidence Before Claims

The qualify step exists because execution memory is optimistic. After executing a task and running verify, re-read the actual files you created or modified. Compare against the spec line by line. Compare against the linked AC. Only then record a status. This is the operational expression of the evidence chain above.

### Scope Discipline

Target 2-3 tasks per plan. Quality degrades past ~50% context usage. If a plan needs more than 3 tasks, split it. Each plan should be independently executable. Prefer vertical slices (one feature end-to-end) over horizontal layers (all models, then all APIs).

### Modules Inform, Kernel Decides

Advisory modules (IRIS, DOCS, RUBY, SKIP) surface concerns — they never block. Enforcement modules (TODD, WALT, DEAN) can gate progression. The kernel orchestrates dispatch and presents results. Module output informs decisions; the workflow drives them.

### Deviations Are Data, Not Failure

Plans are guides. During APPLY: auto-fix bugs, auto-add critical security/correctness gaps, auto-fix blockers. Ask about architectural changes. Log enhancements as deferred. All deviations get recorded during UNIFY for the audit trail. A logged deviation is healthy; a hidden one compounds.

</evidence_discipline>
