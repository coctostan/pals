# Field Harvest Cross-Deployment Roll-Up

> **Derived aid — not lifecycle truth.** Aggregated from committed `.paul/field-harvest/*-MODULE-LEDGER.md` and `UNPARSEABLE.md` by `tools/rollup-field-harvest.sh` per `docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md` §10. Warm, derived, regenerable, byte-budget-exempt; never hand-edited.
>
> These counts measure **recorded dispatch evidence**. They do not measure module value, do not rank modules, and are not sufficient grounds to demote, disable, or reconfigure one. `rows harvested` is not `dispatches that occurred`. Phase 308 proposals must cite source SUMMARYs, not roll-up totals alone.

## Coverage

| Deployment | Rows | Unparseable | Unparseable Share |
|---|---:|---:|---:|
| hybrid-energy-reasoner | 76 | 17 | 18% |
| pals | 226 | 270 | 54% |
| quark | 73 | 121 | 62% |
| **Total** | **375** | **408** | **52%** |

## Module Reach

| Module | hybrid-energy-reasoner | pals | quark | Total |
|---|---:|---:|---:|---:|
| ARCH | 3 | 5 | 2 | 10 |
| ARIA | 1 | 2 | 2 | 5 |
| CODI | 9 | 58 | 5 | 72 |
| DANA | 1 | 2 | 2 | 5 |
| DAVE | 6 | 3 | 2 | 11 |
| DEAN | 7 | 8 | 8 | 23 |
| DOCS | 5 | 10 | 2 | 17 |
| GABE | 1 | 2 | 2 | 5 |
| IRIS | 1 | 10 | 2 | 13 |
| LUKE | 1 | 2 | 2 | 5 |
| OMAR | 1 | 2 | 2 | 5 |
| PETE | 5 | 2 | 2 | 9 |
| REED | 1 | 2 | 2 | 5 |
| REV | — | — | 1 | 1 |
| RUBY | 7 | 37 | 7 | 51 |
| SETH | 5 | 3 | 2 | 10 |
| SKIP | 5 | 35 | 6 | 46 |
| TODD | 6 | 8 | 7 | 21 |
| VERA | 1 | 3 | 2 | 6 |
| WALT | 10 | 32 | 13 | 55 |

## Status Distribution

| Module | PASS | PASS_WITH_CONCERNS | WARN | BLOCK | SKIP | NOTE |
|---|---:|---:|---:|---:|---:|---:|
| ARCH | 6 | 1 | 2 | 0 | 1 | 0 |
| ARIA | 0 | 0 | 0 | 0 | 5 | 0 |
| CODI | 1 | 0 | 0 | 0 | 60 | 11 |
| DANA | 0 | 0 | 0 | 0 | 5 | 0 |
| DAVE | 2 | 0 | 5 | 0 | 4 | 0 |
| DEAN | 17 | 0 | 1 | 0 | 3 | 2 |
| DOCS | 14 | 0 | 0 | 0 | 1 | 2 |
| GABE | 0 | 0 | 0 | 0 | 5 | 0 |
| IRIS | 11 | 0 | 0 | 0 | 1 | 1 |
| LUKE | 0 | 0 | 0 | 0 | 5 | 0 |
| OMAR | 2 | 0 | 0 | 0 | 3 | 0 |
| PETE | 7 | 0 | 0 | 0 | 2 | 0 |
| REED | 0 | 0 | 0 | 0 | 5 | 0 |
| REV | 0 | 0 | 0 | 0 | 0 | 1 |
| RUBY | 6 | 6 | 0 | 1 | 9 | 29 |
| SETH | 9 | 0 | 0 | 0 | 1 | 0 |
| SKIP | 0 | 0 | 0 | 0 | 3 | 43 |
| TODD | 17 | 0 | 0 | 0 | 4 | 0 |
| VERA | 3 | 0 | 0 | 0 | 3 | 0 |
| WALT | 35 | 1 | 0 | 0 | 3 | 16 |

## Unparseable Reasons

| Deployment | Reason | Count |
|---|---|---:|
| hybrid-energy-reasoner | ambiguous-module-set | 1 |
| hybrid-energy-reasoner | no-dispatch-evidence | 1 |
| hybrid-energy-reasoner | unmapped-status | 13 |
| hybrid-energy-reasoner | unrecognized-dispatch-shape | 2 |
| pals | excluded-foreign-evidence | 6 |
| pals | no-dispatch-evidence | 119 |
| pals | unknown-module | 2 |
| pals | unmapped-status | 111 |
| pals | unrecognized-dispatch-shape | 32 |
| quark | no-dispatch-evidence | 81 |
| quark | unknown-module | 2 |
| quark | unmapped-status | 12 |
| quark | unrecognized-dispatch-shape | 26 |
