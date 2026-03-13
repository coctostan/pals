# Knowledge Capture

Templates and guidelines for recording project knowledge with SKIP.

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

Every knowledge entry MUST have:

| Field | Purpose |
|-------|---------|
| **Date** | When the knowledge was captured (YYYY-MM-DD) |
| **Title** | Clear, searchable summary |
| **Type** | One of: decision, rationale, trade-off, constraint, lesson |
| **Phase** | Where in the project lifecycle this arose |
| **Content** | The actual knowledge (varies by type) |

Optional but recommended:

| Field | Purpose |
|-------|---------|
| **Related** | Links to files, PRs, issues |
| **Impact** | What this affects going forward |
| **Alternatives** | What else was considered (for decisions) |

## Capture Guidelines

1. **Use the right template.** Match the knowledge type to the template — this makes searching easier later.
2. **Be specific in titles.** "Chose flat workflow structure" beats "Workflow decision".
3. **Include alternatives for decisions.** Future readers need to know what was rejected and why.
4. **State impact explicitly.** "This means all new modules must..." helps people understand consequences.
5. **Keep entries independent.** Each entry should be understandable without reading others.
