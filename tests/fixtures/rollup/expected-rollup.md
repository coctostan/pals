# Field Harvest Cross-Deployment Roll-Up

> **Derived aid — not lifecycle truth.** Aggregated from committed `.paul/field-harvest/*-MODULE-LEDGER.md` and `UNPARSEABLE.md` by `tools/rollup-field-harvest.sh` per `docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md` §10. Warm, derived, regenerable, byte-budget-exempt; never hand-edited.
>
> These counts measure **recorded dispatch evidence**. They do not measure module value, do not rank modules, and are not sufficient grounds to demote, disable, or reconfigure one. `rows harvested` is not `dispatches that occurred`. Phase 308 proposals must cite source SUMMARYs, not roll-up totals alone.

## Coverage

| Deployment | Rows | Unparseable | Unparseable Share |
|---|---:|---:|---:|
| alpha | 6 | 2 | 25% |
| beta | 2 | 8 | 80% |
| **Total** | **8** | **10** | **56%** |

## Module Reach

| Module | alpha | beta | Total |
|---|---:|---:|---:|
| ARCH | 2 | — | 2 |
| DEAN | 1 | — | 1 |
| SKIP | — | 1 | 1 |
| TODD | 1 | — | 1 |
| WALT | 2 | 1 | 3 |

## Status Distribution

| Module | PASS | PASS_WITH_CONCERNS | WARN | BLOCK | SKIP | NOTE |
|---|---:|---:|---:|---:|---:|---:|
| ARCH | 1 | 0 | 1 | 0 | 0 | 0 |
| DEAN | 0 | 0 | 0 | 1 | 0 | 0 |
| SKIP | 0 | 0 | 0 | 0 | 0 | 1 |
| TODD | 1 | 0 | 0 | 0 | 0 | 0 |
| WALT | 1 | 1 | 0 | 0 | 1 | 0 |

## Unparseable Reasons

| Deployment | Reason | Count |
|---|---|---:|
| alpha | no-dispatch-evidence | 1 |
| alpha | unmapped-status | 1 |
| beta | no-dispatch-evidence | 4 |
| beta | unknown-module | 1 |
| beta | unmapped-status | 1 |
| beta | unrecognized-dispatch-shape | 2 |
