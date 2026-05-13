# Refactor Patterns

RUBY's catalog of refactoring patterns — what to apply, when, and what smells they address.

## Pattern Catalog

### Extract Function
**Smell:** Long function, duplicated logic, unclear intent
**When:** A code block does one identifiable thing. If you need a comment to explain it, it should be a function.
```
BEFORE: function processOrder(order) { /* validate */ ... /* calculate */ ... /* save */ ... }
AFTER:  function processOrder(order) { validateOrder(order); const totals = calculateTotals(order); db.save({...order, ...totals}); }
```

### Extract Pure Core (Pure Core, Explicit Effects)
**Smell:** Business rules, validation, decisions, or data transformations are mixed with side effects such as I/O, persistence, network calls, filesystem/process/env access, logging, timers, randomness, or framework callbacks.
**When:** A behavior can be described as pure input-to-output logic and separating it would reduce coupling or make tests clearer while preserving local project idioms.
**How:** Characterize existing behavior first, extract deterministic logic into a named helper/module/function, pass dependencies/state/time/random/config as explicit inputs where practical, leave side effects in the shell/boundary, and rerun tests after each step.
**Safety:** This is advisory, behavior-preserving, and test-backed. Do not force functional programming, rewrite class/OOP designs, broaden scope, or replace readable imperative code with clever functional chains.
```
BEFORE: async function handle(req) { const user = await db.get(req.id); const status = user.age >= 18 ? 'adult' : 'minor'; logger.info(status); return status; }
AFTER:  function classifyUser(user) { return user.age >= 18 ? 'adult' : 'minor'; } // shell handles db/logging
```

### Extract Variable
**Smell:** Complex expressions, magic numbers, unclear conditionals
**When:** Expression is hard to read or used multiple times. Name reveals intent.

### Guard Clauses (Simplify Nesting)
**Smell:** Deep nesting, arrow code
**When:** Multiple if/else levels. Invert conditions, return early, handle edge cases first.

### Replace Magic Values with Constants
**Smell:** Hardcoded numbers/strings without explanation
**When:** `429`, `60000`, `8` appear without context. Name them: `RATE_LIMIT_STATUS`, `MIN_PASSWORD_LENGTH`.

### Consolidate Duplicates
**Smell:** Copy-paste code in 2+ places
**When:** Same logic appears multiple times AND represents the same concern. **WARNING:** Only consolidate if duplication represents the SAME concern. Two identical code blocks serving different purposes should remain separate — they may diverge later. Premature DRY creates coupling.

### Replace Conditional with Polymorphism
**Smell:** Type-based switch/if chains in multiple places
**When:** Same type-checking conditional in 3+ places. Single switch is fine as-is.

### Decompose Conditional
**Smell:** Complex boolean expressions
**When:** Conditional is hard to read. Extract predicates into named functions.

### Move Function
**Smell:** Feature envy, inappropriate intimacy
**When:** Function uses more data from another module than its own. Move it where data lives.

### Inline Temp
**Smell:** Unnecessary single-use variable
**When:** Variable assigned once, used immediately, adds no clarity. Keep if name adds information.

## Pattern-to-Smell Mapping

| Smell | Pattern |
|-------|---------|
| Long function | Extract function, Extract Pure Core when decisions are mixed with effects |
| Deep nesting | Guard clauses |
| Magic numbers/strings | Constants |
| Copy-paste code | Consolidate duplicates |
| Complex conditional | Decompose conditional, extract variable, Extract Pure Core for pure decision logic |
| Type switch chains | Polymorphism |
| Feature envy | Move function |
| God object | Extract function → extract class/module |
| Unclear naming | Rename |
| Dead code | Delete (verify unused first) |
| Shotgun surgery | Consolidate module |
| Long parameter list | Parameter object |

## Safety Checklist

Before suggesting a refactor:
1. Cite changed-source evidence.
2. Use only measured metrics.
3. Mark blast radius unknown unless bounded caller/import evidence was read.
4. Prefer mechanical, behavior-preserving changes.
5. For Extract Pure Core, require test-backed evidence or characterization coverage before and after the extraction.
6. Do not own commits, lifecycle state, or execution decisions.
