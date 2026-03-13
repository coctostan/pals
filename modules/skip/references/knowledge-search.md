# Knowledge Search

Strategies and heuristics for finding relevant project knowledge with SKIP.

## Search Sources

SKIP searches across multiple knowledge repositories in the project:

| Source | What it Contains | Search Priority |
|--------|-----------------|-----------------|
| `KNOWLEDGE.md` | Explicit knowledge entries (primary store) | 1 — search first |
| `.paul/STATE.md` | Accumulated decisions table | 2 — project decisions |
| `.paul/phases/*/SUMMARY.md` | Per-plan decisions and deferred issues | 3 — phase-level context |
| `.paul/PROJECT.md` | Key decisions table, constraints | 4 — project-level |
| Git commit messages | Implementation context | 5 — last resort |

## Search Strategies

### Keyword Search

The simplest and most common search mode. Grep across knowledge sources for matching terms.

```
Search order:
1. KNOWLEDGE.md — grep for keyword in titles and content
2. STATE.md — grep Decisions table
3. SUMMARY files — grep decisions sections
4. PROJECT.md — grep Key Decisions table
```

### Type-Filtered Search

When the user knows what kind of knowledge they need:

| User Intent | Filter | Search Pattern |
|-------------|--------|---------------|
| "Why did we..." | `type: decision` or `type: rationale` | Search decision/rationale entries |
| "What alternatives..." | `type: decision` | Search alternatives-considered sections |
| "What are the limits..." | `type: constraint` | Search constraint entries |
| "What did we learn..." | `type: lesson` | Search lesson entries |
| "What trade-offs..." | `type: trade-off` | Search trade-off entries |

### Phase/Milestone Search

Scope search to a specific time period or project phase:

- **By phase:** Search entries where `Phase:` matches the target phase number
- **By milestone:** Search entries within the phase range for that milestone
- **By date range:** Search entries between two dates

### Context-Aware Search

When a user asks a question, infer the best search strategy:

| Question Pattern | Strategy |
|-----------------|----------|
| "Why did we choose X?" | Search decisions mentioning X |
| "What happened with X?" | Search all types mentioning X, chronological |
| "Can we change X?" | Search constraints and trade-offs mentioning X |
| "Has this come up before?" | Search lessons and rationale mentioning related terms |

## Retrieval Format

### Single Match

```
────────────────────────────────────────
[YYYY-MM-DD] [Title]
Type: [type] | Phase: [phase]

[Content excerpt — first 3-5 meaningful lines]

Related: [file paths or links]
────────────────────────────────────────
```

### Multiple Matches

```
Found [N] entries matching "[query]":

  1. [YYYY-MM-DD] [Title] (type: [type], phase: [phase])
  2. [YYYY-MM-DD] [Title] (type: [type], phase: [phase])
  3. [YYYY-MM-DD] [Title] (type: [type], phase: [phase])

Showing entry 1 of [N]:
[Full entry content]

Navigate: [next] for more, or specify entry number
```

### No Matches

```
No knowledge entries found matching "[query]".

Suggestions:
- Try broader terms: [suggested alternatives]
- Search by type: /paul:knowledge type:decision [query]
- Check STATE.md decisions: grep for related terms in .paul/STATE.md
- The knowledge may not have been captured yet — consider adding it with /paul:knowledge capture
```

## Search Heuristics

1. **Title matches rank highest.** A keyword in the title is a stronger signal than in the body.
2. **Recent entries rank higher.** More recent knowledge is more likely relevant to current work.
3. **Type-matched entries rank higher.** If the user asks "why", decision/rationale entries rank above lessons.
4. **Phase proximity matters.** Entries from the current or adjacent phases are more likely relevant.
5. **Cross-reference related entries.** If an entry has Related fields, surface connected knowledge.
