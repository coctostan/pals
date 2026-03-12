# Knowledge Principles

SKIP captures the **why** behind project decisions — the context that code and git history alone cannot preserve.

## What to Capture

### Knowledge Types

| Type | Description | Example |
|------|-------------|---------|
| **Decision** | A choice made between alternatives | "Chose Zustand over Redux for state management" |
| **Rationale** | The reasoning behind an approach | "We use flat workflows because TODD/WALT steps are inline" |
| **Trade-off** | Acknowledged costs of a decision | "Accepted slower builds for better type safety" |
| **Constraint** | External limitations shaping design | "CARL must remain architecturally independent" |
| **Lesson** | Insight gained from experience | "Mocked tests passed but prod migration failed" |

### What NOT to Capture

- Implementation details (code captures these)
- Who changed what (git blame captures this)
- Task status or progress (STATE.md captures this)
- Bug fixes or debugging steps (commit messages capture these)

## When to Capture

| Lifecycle Phase | Capture Opportunities |
|-----------------|----------------------|
| **PLAN** | Design decisions, architecture choices, scope trade-offs, rejected alternatives |
| **APPLY** | Implementation decisions, unexpected constraints discovered, approach pivots |
| **UNIFY** | Retrospective insights, lessons learned, deferred rationale |
| **Ad hoc** | Anytime context would be lost — especially verbal discussions, Slack decisions, PR comments |

## Storage Format

Knowledge entries are stored in `KNOWLEDGE.md` at the project root (or `.paul/KNOWLEDGE.md` for PAUL-managed projects).

### Entry Structure

```markdown
## [YYYY-MM-DD] [Title]

**Type:** decision | rationale | trade-off | constraint | lesson
**Phase:** [phase number and name, or "ad hoc"]
**Related:** [file paths, PR numbers, or issue IDs]

[Content — the actual knowledge being preserved]

**Alternatives considered:** [if decision or trade-off]
**Impact:** [what this affects going forward]
```

### Organization

- Entries are chronological (newest first)
- Each entry is self-contained (readable without prior entries)
- Related entries can cross-reference by date and title
- No nested hierarchy — flat list with type tags for filtering

## Principles

1. **Capture the why, not the what.** Code shows what was built. SKIP shows why it was built that way.
2. **Write for your future self.** In 3 months, will this entry explain the decision without needing to ask someone?
3. **Prefer too much context over too little.** You can always skip an entry when searching. You can't recover context that was never written down.
4. **Capture at the moment of decision.** Context fades fast. Record decisions when they're fresh, not retroactively.
5. **Link to artifacts.** Reference file paths, PRs, commits, or issues so knowledge connects to code.
