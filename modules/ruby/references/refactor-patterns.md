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
| Long function | Extract function |
| Deep nesting | Guard clauses |
| Magic numbers/strings | Constants |
| Copy-paste code | Consolidate duplicates |
| Complex conditional | Decompose conditional, extract variable |
| Type switch chains | Polymorphism |
| Feature envy | Move function |
| God object | Extract function → extract class/module |
| Unclear naming | Rename |
| Dead code | Delete (verify unused first) |
| Shotgun surgery | Consolidate module |
| Long parameter list | Parameter object |

## Safe Transformation Principles

1. One refactoring at a time. Verify tests pass, then consider next.
2. Tests are your safety net. Run after every transform. Break = revert.
3. Commit after each successful refactoring. Small commits = easy bisect/revert.
4. Refactoring is reversible. Not clearly better = undo.
5. Measure improvement. If metrics don't improve, reconsider.
