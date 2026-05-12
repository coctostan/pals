# Knowledge Search

Strategies and heuristics for finding relevant project knowledge with SKIP.

## Search Sources

Use the smallest source set that matches the explicit query.

| Source | Use |
|--------|-----|
| `.paul/knowledge/` | Default first source |
| `.paul/STATE.md` | Only for current accumulated decisions |
| `.paul/phases/*/SUMMARY.md` | Only recent or explicitly named summaries |
| `.paul/ROADMAP.md` | Only current phase/milestone context |

Do not scan all summaries unless the user asks for historical coverage.

## Search Strategies

### Keyword Search

1. Search `.paul/knowledge/`.
2. Add STATE, ROADMAP, or summaries only when named by the query/current
   lifecycle context.
3. For summaries, use explicitly named summaries first, otherwise recent only.
4. Return at most 5 matches by default.

### Context-Aware Search

Use explicit context only: current phase, scoped files, module names, or supplied
error text. Do not infer unstated topics.

## Retrieval Format

### Single Match

```text
[YYYY-MM-DD] [Title]
Type: [type] | Phase: [phase]
Source: [path#section or line range]

[Source excerpt, max 5 lines]

Related: [source-listed paths only, or —]
```

### Multiple Matches

```text
Showing [N] matches for "[query]" (max 5):
1. [YYYY-MM-DD] [Title] (type: [type], phase: [phase], source: [path#section])
2. ...
```

### No Matches

```text
No knowledge entries found for "[query]" in searched sources: [sources].
```

## Search Heuristics

1. Rank title matches first.
2. Rank exact path/module matches next.
3. Rank recent entries next.
4. Rank requested type next.
5. Do not follow related links unless requested.
