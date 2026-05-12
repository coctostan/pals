# Knowledge Capture

Templates and guidelines for recording project knowledge with SKIP.

SKIP emits only source-backed knowledge. Do not fill template gaps by guessing.
If required evidence is missing, emit an incomplete-entry or skip note instead.

## Capture Templates

### Decision Record

```markdown
## [YYYY-MM-DD] [Decision title — what was decided]

**Type:** decision
**Phase:** [phase number and name]
**Related:** [files, PRs, issues affected]

**Context:** [What situation required this decision]

**Decision:** [What was chosen]

**Alternatives considered:**
- [Alternative A] — [why rejected]
- [Alternative B] — [why rejected]

**Rationale:** [Why this option was selected]

**Impact:** [What this affects going forward]
```

### Rationale Note

```markdown
## [YYYY-MM-DD] [Why we do X this way]

**Type:** rationale
**Phase:** [phase number and name]
**Related:** [files that implement this approach]

[Explanation of the reasoning behind an existing approach, pattern, or convention]

**Key factors:**
- [Factor 1]
- [Factor 2]

**Impact:** [What breaks or changes if this rationale no longer holds]
```

### Trade-off Analysis

```markdown
## [YYYY-MM-DD] [Trade-off title]

**Type:** trade-off
**Phase:** [phase number and name]
**Related:** [files affected]

**What we gained:** [Benefits of the chosen approach]

**What we accepted:** [Costs, limitations, or risks we took on]

**Conditions for revisiting:** [When should we reconsider this trade-off]
```

### Constraint Documentation

```markdown
## [YYYY-MM-DD] [Constraint title]

**Type:** constraint
**Phase:** [phase number and name]
**Related:** [files or systems affected]

**Source:** [Where this constraint comes from — legal, technical, organizational]

**Constraint:** [What limitation or requirement exists]

**Workarounds:** [How we work within this constraint]

**Expiration:** [When/if this constraint might be lifted, or "indefinite"]
```

### Lesson Learned

```markdown
## [YYYY-MM-DD] [Lesson title]

**Type:** lesson
**Phase:** [phase number and name]
**Related:** [files, PRs, or incidents involved]

**What happened:** [Brief description of the event or discovery]

**What we learned:** [The insight gained]

**How to apply:** [Concrete guidance for future work]
```

## Required Fields

Emit an entry only when source evidence supports every required field:

| Field | Purpose |
|-------|---------|
| **Source** | Path plus section or line range |
| **Date** | Capture date or source-event date |
| **Title** | Source-grounded summary |
| **Type** | decision, rationale, trade-off, constraint, or lesson |
| **Phase/Plan** | Lifecycle scope |
| **Context** | Why it mattered |
| **Content** | The decision, rationale, trade-off, constraint, or lesson |
| **Impact** | What it affects |

Optional fields may use `—`; required fields may not.

## Quality Guidelines

1. Cite source path/section.
2. Keep claims source-grounded.
3. Include alternatives only when sourced.
4. State impact only when sourced.
