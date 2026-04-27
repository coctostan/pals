# PALS Archive Index

Archive files are durable project truth moved out of hot lifecycle artifacts to keep normal PLAN/APPLY/UNIFY context small. The live root artifacts remain the routing and current-context entry points; archived files hold older completed history that is still authoritative when linked from a live artifact.

## Archive Catalog

| Archive file | Source | Archived on | Scope | Still authoritative? | Return link |
|--------------|--------|-------------|-------|----------------------|-------------|
| [milestones/MILESTONES-v0-v2.42.md](milestones/MILESTONES-v0-v2.42.md) | `.paul/MILESTONES.md` | 2026-04-26 | Completed milestone detail through v2.42, including accomplishment and decision sections removed from the compact live milestone index. | Yes — historical milestone record. | [Live milestone index](../MILESTONES.md) |
| [project/PROJECT-HISTORY.md](project/PROJECT-HISTORY.md) | `.paul/PROJECT.md` | 2026-04-26 | Legacy validated requirements, detailed historical requirement/checklist content, and project decision history removed from the compact live project brief. | Yes — historical project/product record. | [Live project brief](../PROJECT.md) |
| [state/STATE-HISTORY-v0-v2.43.md](state/STATE-HISTORY-v0-v2.43.md) | `.paul/STATE.md` | 2026-04-26 | Historical accumulated context through v2.43 planning, including decisions, fixes, deviations, skill audits, and deferred issues removed from compact live state. | Yes — historical state record. | [Live state](../STATE.md) |
| [roadmap/ROADMAP-HISTORY-v0-v2.43.md](roadmap/ROADMAP-HISTORY-v0-v2.43.md) | `.paul/ROADMAP.md` | 2026-04-27 | Historical completed-milestone `<details>` blocks for v0.1 through v2.43 removed from the compact live roadmap during Phase 190 Plan 190-01. | Yes — historical roadmap record. | [Live roadmap](../ROADMAP.md) |

## Link Style for Hot Artifacts

Use short archive links in hot artifacts instead of re-embedding archived history:

- `Detailed history: [.paul/archive/milestones/MILESTONES-v0-v2.42.md](archive/milestones/MILESTONES-v0-v2.42.md)`
- `Project history: [.paul/archive/project/PROJECT-HISTORY.md](archive/project/PROJECT-HISTORY.md)`
- `State history: [.paul/archive/state/STATE-HISTORY-v0-v2.43.md](archive/state/STATE-HISTORY-v0-v2.43.md)`
- `Roadmap history: [.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md](archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md)`

Keep archive links explicit, repo-relative, and close to the compact summary they expand. Do not duplicate full archive content in the index or in hot artifacts.
