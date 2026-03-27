# Artifact Footprint Inventory

_Date:_ 2026-03-27  
_Phase:_ 158 — Artifact Growth & Hot-Path Audit

## Scope and method

This inventory measures the current `.paul/` tree as it exists in-repo. Counts below use a direct filesystem scan of every file under `.paul/`, with line counts taken from text content and byte counts from on-disk file size.

## Corpus totals

| Metric | Value |
|---|---:|
| Total files under `.paul/` | 534 |
| Total lines under `.paul/` | 82,241 |
| Total bytes under `.paul/` | 3,659,245 |

## Major footprint buckets

| Bucket | Files | Lines | % of lines | Bytes | % of bytes | Notes |
|---|---:|---:|---:|---:|---:|---|
| authority (`STATE.md`, `ROADMAP.md`, `PROJECT.md`, `MILESTONES.md`, `SPECIAL-FLOWS.md`) | 5 | 1,870 | 2.3% | 121,711 | 3.3% | Live lifecycle / planning context |
| `.paul/phases/` | 411 | 63,827 | 77.6% | 2,939,330 | 80.3% | Dominant historical growth area |
| `.paul/handoffs/archive/` | 91 | 9,436 | 11.5% | 338,653 | 9.3% | Session-history accumulation |
| `.paul/milestones/` | 18 | 6,006 | 7.3% | 201,672 | 5.5% | Per-milestone rollups / archived roadmap views |
| `.paul/references/` | 3 | 794 | 1.0% | 44,962 | 1.2% | Static reference material |
| `.paul/fixes/` | 2 | 69 | 0.1% | 3,066 | 0.1% | Small |
| root misc | 4 | 239 | 0.3% | 9,851 | 0.3% | Draft / scratch artifacts |

## Authority files: live but comparatively small

| File | Lines | Bytes | Observations |
|---|---:|---:|---|
| `.paul/MILESTONES.md` | 739 | 39,745 | Largest authority artifact, but historical rather than turn-by-turn operational |
| `.paul/ROADMAP.md` | 628 | 22,137 | Large enough to matter when repeatedly read during planning / status flows |
| `.paul/PROJECT.md` | 309 | 37,871 | Intended hot-path brief; materially smaller than roadmap / milestones |
| `.paul/STATE.md` | 153 | 19,761 | Operationally hot, but not large in absolute terms |
| `.paul/SPECIAL-FLOWS.md` | 41 | 2,197 | Tiny, conditional |

## Largest files in the corpus

| Rank | File | Lines | Bytes | Class |
|---:|---|---:|---:|---|
| 1 | `.paul/MILESTONES.md` | 739 | 39,745 | authority / milestone history |
| 2 | `.paul/milestones/v2.34-ROADMAP.md` | 628 | 22,776 | archived milestone roadmap |
| 3 | `.paul/ROADMAP.md` | 628 | 22,137 | live roadmap |
| 4 | `.paul/milestones/v2.33-ROADMAP.md` | 627 | 21,878 | archived milestone roadmap |
| 5 | `.paul/milestones/v2.28-ROADMAP.md` | 570 | 19,489 | archived milestone roadmap |
| 6 | `.paul/milestones/v2.27-ROADMAP.md` | 560 | 19,189 | archived milestone roadmap |
| 7 | `.paul/milestones/v2.26-ROADMAP.md` | 548 | 18,669 | archived milestone roadmap |
| 8 | `.paul/milestones/v2.25-ROADMAP.md` | 532 | 18,110 | archived milestone roadmap |
| 9 | `.paul/milestones/v2.24-ROADMAP.md` | 519 | 17,642 | archived milestone roadmap |
| 10 | `.paul/phases/34-competitive-research/competitive-analysis.md` | 481 | 31,427 | historical phase research |

## Directory concentration

| Directory / file group | Files | Lines | Bytes |
|---|---:|---:|---:|
| `.paul/phases` | 411 | 63,827 | 2,939,330 |
| `.paul/handoffs` | 91 | 9,436 | 338,653 |
| `.paul/milestones` | 18 | 6,006 | 201,672 |
| `.paul/references` | 3 | 794 | 44,962 |
| `.paul/MILESTONES.md` | 1 | 739 | 39,745 |
| `.paul/ROADMAP.md` | 1 | 628 | 22,137 |
| `.paul/PROJECT.md` | 1 | 309 | 37,871 |
| `.paul/STATE.md` | 1 | 153 | 19,761 |

## Active vs historical material

| Slice | Files | Lines | Bytes | Interpretation |
|---|---:|---:|---:|---|
| Current Phase 158 workspace | 1 | 218 | 14,445 | Active work footprint is tiny right now |
| Archived handoffs (latest 10 only) | 10 | 1,119 | 39,381 | Archive growth is steady and additive |
| Historical phases + milestone rollups + archived handoffs | 520 | 79,269 | 3,479,655 | 96.4% of all `.paul/` lines are historical accumulation rather than live authority |

## What is actually large

### Authority files that are both live and non-trivial
- `.paul/ROADMAP.md` — 628 lines
- `.paul/MILESTONES.md` — 739 lines
- `.paul/PROJECT.md` — 309 lines
- `.paul/STATE.md` — 153 lines

### Archive classes that dominate footprint even if they are not always hot-path
- `.paul/phases/` is the primary bloat source by a wide margin: 63,827 lines across 411 files.
- `.paul/handoffs/archive/` is the second largest history class: 9,436 lines across 91 files.
- `.paul/milestones/` adds another 6,006 lines of mostly historical rollups.

## Interpretation

1. **The artifact corpus is large because of historical accumulation, not because live authority files are enormous.**
   The dominant mass is in prior phase outputs, archived handoffs, and milestone rollups.

2. **Live authority is small as a share of total footprint, but some live files are now dense enough to matter when repeatedly re-read.**
   `ROADMAP.md` and `MILESTONES.md` are the clearest examples; `STATE.md` is smaller but operationally important.

3. **Current active work is not the footprint problem.**
   The current phase workspace contains only the Phase 158 plan so far; the bulk comes from long-lived accumulation.

4. **The inventory separates disk growth from context pressure.**
   Large historical artifacts exist, but this file alone does not claim they are hot-path. That question is handled in `pi-hot-path-read-analysis.md`.

## Decision-useful takeaways

- If the concern is **total artifact growth**, the main targets are historical `phases/`, archived handoffs, and milestone rollups.
- If the concern is **active lifecycle context cost**, the likely pressure points are the smaller set of live authority files: `STATE.md`, `ROADMAP.md`, and `PROJECT.md`.
- `handoffs/archive` is already large enough to warrant classification as a real growth mechanism even if most of it is cold.
