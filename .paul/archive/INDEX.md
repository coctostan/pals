# PALS Archive Index

Archive files are durable project truth moved out of hot lifecycle artifacts to keep normal PLAN/APPLY/UNIFY context small. The live root artifacts remain the routing and current-context entry points; archived files hold older completed history that is still authoritative when linked from a live artifact.

## Archive Catalog

| Archive file | Source | Archived on | Scope | Still authoritative? | Return link |
|--------------|--------|-------------|-------|----------------------|-------------|
| [milestones/MILESTONES-v0-v2.42.md](milestones/MILESTONES-v0-v2.42.md) | `.paul/MILESTONES.md` | 2026-04-26 | Completed milestone detail through v2.42, including accomplishment and decision sections removed from the compact live milestone index. | Yes — historical milestone record. | [Live milestone index](../MILESTONES.md) |
| [project/PROJECT-HISTORY.md](project/PROJECT-HISTORY.md) | `.paul/PROJECT.md` | 2026-04-26 | Legacy validated requirements, detailed historical requirement/checklist content, and project decision history removed from the compact live project brief. | Yes — historical project/product record. | [Live project brief](../PROJECT.md) |

## Link Style for Hot Artifacts

Use short archive links in hot artifacts instead of re-embedding archived history:

- `Detailed history: [.paul/archive/milestones/MILESTONES-v0-v2.42.md](archive/milestones/MILESTONES-v0-v2.42.md)`
- `Project history: [.paul/archive/project/PROJECT-HISTORY.md](archive/project/PROJECT-HISTORY.md)`

Keep archive links explicit, repo-relative, and close to the compact summary they expand. Do not duplicate full archive content in the index or in hot artifacts.
