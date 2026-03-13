# Refactor Patterns

RUBY's catalog of common refactoring patterns with when to apply them and what smells they address.

## Pattern Catalog

### Extract Function

**Addresses:** Long function, duplicated logic, unclear intent
**When:** A block of code within a function does one identifiable thing.

```
BEFORE:
  function processOrder(order) {
    // validate
    if (!order.items) throw new Error(...)
    if (order.total < 0) throw new Error(...)
    // calculate
    let subtotal = 0
    for (const item of order.items) { subtotal += item.price * item.qty }
    let tax = subtotal * 0.08
    // save
    db.save({ ...order, subtotal, tax })
  }

AFTER:
  function processOrder(order) {
    validateOrder(order)
    const { subtotal, tax } = calculateTotals(order.items)
    db.save({ ...order, subtotal, tax })
  }
```

**Guideline:** If you need a comment to explain what a block does, it should probably be a function with that comment as its name.

### Extract Variable

**Addresses:** Complex expressions, magic numbers, unclear conditionals
**When:** An expression is hard to read or used multiple times.

```
BEFORE:
  if (user.age >= 18 && user.country === 'US' && !user.banned && user.emailVerified)

AFTER:
  const isEligible = user.age >= 18 && user.country === 'US'
  const isInGoodStanding = !user.banned && user.emailVerified
  if (isEligible && isInGoodStanding)
```

### Simplify Nesting (Guard Clauses)

**Addresses:** Deep nesting, arrow code, complex control flow
**When:** Multiple levels of if/else create deeply indented code.

```
BEFORE:
  function getDiscount(user) {
    if (user) {
      if (user.membership) {
        if (user.membership.active) {
          return user.membership.discount
        } else {
          return 0
        }
      } else {
        return 0
      }
    } else {
      return 0
    }
  }

AFTER:
  function getDiscount(user) {
    if (!user) return 0
    if (!user.membership) return 0
    if (!user.membership.active) return 0
    return user.membership.discount
  }
```

**Guideline:** Invert conditions and return early. Handle edge cases first, then the happy path flows naturally.

### Replace Magic Values with Constants

**Addresses:** Magic numbers, magic strings, unclear thresholds
**When:** Hardcoded values appear without explanation.

```
BEFORE:
  if (response.status === 429) { sleep(60000) }
  if (password.length < 8) { reject() }

AFTER:
  const RATE_LIMIT_STATUS = 429
  const RATE_LIMIT_BACKOFF_MS = 60_000
  const MIN_PASSWORD_LENGTH = 8

  if (response.status === RATE_LIMIT_STATUS) { sleep(RATE_LIMIT_BACKOFF_MS) }
  if (password.length < MIN_PASSWORD_LENGTH) { reject() }
```

### Consolidate Duplicates

**Addresses:** Copy-paste code, repeated conditionals
**When:** The same logic appears in 2+ places AND represents the same concern.

```
BEFORE:
  // In file A:
  const fullName = user.firstName + ' ' + user.lastName
  // In file B:
  const displayName = user.firstName + ' ' + user.lastName
  // In file C:
  const name = user.firstName + ' ' + user.lastName

AFTER:
  function formatFullName(user) {
    return user.firstName + ' ' + user.lastName
  }
```

**Warning:** Only consolidate if the duplication represents the SAME concern. Two identical code blocks that serve different purposes should remain separate — they may diverge later.

### Replace Conditional with Polymorphism

**Addresses:** Type-based switch/if chains, feature envy
**When:** The same type-checking conditional appears in multiple places.

```
BEFORE:
  function calculateArea(shape) {
    switch (shape.type) {
      case 'circle': return Math.PI * shape.radius ** 2
      case 'rectangle': return shape.width * shape.height
      case 'triangle': return 0.5 * shape.base * shape.height
    }
  }

AFTER:
  class Circle { area() { return Math.PI * this.radius ** 2 } }
  class Rectangle { area() { return this.width * this.height } }
  class Triangle { area() { return 0.5 * this.base * this.height } }
```

**Guideline:** Only worth it when the same switch appears in 3+ places. A single switch is fine.

### Decompose Conditional

**Addresses:** Complex boolean expressions, unclear predicates
**When:** A conditional expression is hard to read.

```
BEFORE:
  if (date.getMonth() >= 5 && date.getMonth() <= 8 && !isHoliday(date) && employee.department !== 'essential')

AFTER:
  function isSummerSchedule(date) {
    return date.getMonth() >= 5 && date.getMonth() <= 8
  }
  function canTakeSummerHours(date, employee) {
    return isSummerSchedule(date) && !isHoliday(date) && employee.department !== 'essential'
  }
```

### Move Function

**Addresses:** Feature envy, inappropriate intimacy
**When:** A function uses more data from another module than from its own.

**Guideline:** Functions should live where their data lives. If `formatUserAddress()` is in the `order` module but only touches `user` data, move it to the `user` module.

### Inline Temp

**Addresses:** Unnecessary indirection, single-use variables that obscure
**When:** A variable is assigned once and used immediately, adding no clarity.

```
BEFORE:
  const basePrice = order.getBasePrice()
  return basePrice > 1000

AFTER:
  return order.getBasePrice() > 1000
```

**Warning:** Only inline if the variable name adds NO information. If `isExpensiveOrder` is clearer than the raw expression, keep it.

## Pattern-to-Smell Mapping

| Smell | Recommended Pattern(s) |
|-------|----------------------|
| Long function | Extract function |
| Deep nesting | Guard clauses (simplify nesting) |
| Magic numbers/strings | Replace magic values with constants |
| Copy-paste code | Consolidate duplicates |
| Complex conditional | Decompose conditional, extract variable |
| Type-based switch chains | Replace conditional with polymorphism |
| Feature envy | Move function |
| God object | Extract function → extract class/module |
| Unclear naming | Rename (variable, function, class) |
| Dead code | Delete it (verify unused first) |
| Shotgun surgery | Move related code together (consolidate module) |
| Long parameter list | Introduce parameter object |

## Safe Transformation Principles

1. **One refactoring at a time.** Apply a single pattern, verify tests pass, then consider the next.
2. **Tests are your safety net.** Run tests after every transformation. If tests break, revert immediately.
3. **Commit after each successful refactoring.** Small commits make it easy to bisect and revert.
4. **Refactoring is reversible.** If the result isn't clearly better, undo it. No sunk cost.
5. **Measure improvement.** Compare complexity metrics before and after. If metrics don't improve, the refactoring may not be worthwhile.
