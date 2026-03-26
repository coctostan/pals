# Project: pi-bench

## Description
pi-bench is a Pi extension for benchmarking how different LLMs perform within Pi on the same coding task. It sends identical prompts to multiple models and compares response latency, token usage, and output behavior inside Pi.

## Core Value
Help Pi users choose the best model for their use case by comparing latency, token usage, and output behavior on the same task inside Pi.

## Current State
| Attribute | Value |
|-----------|-------|
| Version | 0.2.0 |
| Status | MVP+ |
| Last Updated | 2026-03-25 |

**Current system summary:**
- Pi extension implemented in TypeScript.
- `/bench` benchmarks the same prompt across multiple models and renders structured comparison output in Pi.
- Benchmark runs are now persisted locally and reviewable via `/bench history`.

## Scope Snapshot
### Validated
- [x] `/bench` command benchmarks 2+ models on the same prompt and reports latency/token comparisons — Phase 1
- [x] Benchmark runs are saved to `.bench-history.json` and viewable via `/bench history` — Phase 2

### Active
- [ ] Validate runtime behavior across real Pi model providers, especially token/latency metadata shape

### Planned
- [ ] Output quality scoring
- [ ] CI integration
- [ ] Advanced benchmark analytics and filtering

### Out of Scope
- None explicitly beyond deferred items.

## Target Users
**Primary:** Pi users who work with multiple models and need side-by-side latency, token cost, and output quality comparisons.

## Constraints
- Depends on Pi extension APIs and Pi model registry behavior.
- Runtime metadata availability still varies by provider/model.

## Success Metrics
- `/bench` runs against at least 2 models.
- Results are shown in structured comparison output with latency and token data.
- Benchmark history can be reviewed without rerunning the benchmark.

## Key Decisions
| Decision | Rationale | Date | Status |
|----------|-----------|------|--------|
| Layered artifact model (`PROJECT.md` + `PRD.md`) adopted at init | Keep hot-path context concise while preserving deeper product definition | 2026-03-25 | Active |
| Store default benchmark models in `package.json` under `piBench.defaultModels` | Keep MVP configuration minimal and local to the extension package | 2026-03-25 | Active |
| Use `ctx.modelRegistry` + `complete(...)` for benchmark execution | Matches documented Pi APIs and avoids unsupported assumptions about `pi.switchModel` | 2026-03-25 | Active |
| Render benchmark output as markdown in the Pi editor | Keeps MVP output deterministic without building custom UI first | 2026-03-25 | Active |
| Persist benchmark runs in repo-local `.bench-history.json` | Add lightweight history without introducing external storage | 2026-03-25 | Active |
| Keep `/bench history` text-first and limit-capable | Preserve simplicity while making saved runs inspectable inside Pi | 2026-03-25 | Active |

## Links
- `PRD.md` — deeper product-definition context
- `.paul/ROADMAP.md` — milestone and phase structure
- `.paul/quality-history.md` — quality trend across phases

---
*PROJECT.md — compact landing brief; keep it intentionally concise*
*Last updated: 2026-03-25 after Phase 2*