---
phase: 272-pause-workflow-instruction-audit
plan: 02
type: fix
completed: 2026-05-10T01:03:56Z
---

## Fix Summary
**Issue:** PAUL workflow `<references>` still used legacy `@references/...`, `references/...`, `@src/templates/...`, and module-local `@references/...` forms. In Pi, those were being interpreted relative to the workflow file path, producing missing paths like `.../workflows/references/context-management.md`.
**Mode:** Standard fix

### Files Changed
| File | Change |
|------|--------|
| `kernel/workflows/*.md` | Normalized kernel reference/template paths to documented logical paths (`kernel/references/...`, `kernel/templates/...`). |
| `modules/todd/workflows/plan-phase-tdd.md` | Normalized TODD module references to `modules/todd/references/...`. |
| `modules/walt/workflows/apply-phase-quality.md` | Normalized WALT module references to `modules/walt/references/...`. |
| `.paul/QUALITY-HISTORY.md` | Recorded WALT post-unify quality evidence for this fix. |
| `~/.pi/agent/skills/pals/workflows/*` | Refreshed by `./install.sh` so the active Pi runtime uses the corrected paths. |
| `~/.pals/workflows/*` | Refreshed by `./install.sh` for cross-harness parity. |

### Verification
- `grep` found 0 legacy unresolved workflow reference forms in `kernel/workflows`.
- `grep` found 0 legacy unresolved workflow reference forms in `modules/*/workflows`.
- `grep` found 0 legacy unresolved workflow reference forms in installed Pi workflows at `~/.pi/agent/skills/pals/workflows`.
- Installed `resume-project.md` now uses:
  - `kernel/references/context-management.md`
  - `kernel/references/loop-phases.md`
- `./install.sh` completed successfully.
- `bash tests/pi-end-to-end-validation.sh` passed: 312/312.
- `bash tests/cross-harness-validation.sh` passed: 202/202.
- `git diff --check` passed.

### Result
Fix applied successfully. The specific missing-path errors should stop because PAUL workflow references now use adapter-resolvable logical paths instead of paths that can be misread under `workflows/references/`.

### Module Execution Reports
[dispatch] post-apply: ARCH skipped — markdown workflow/reference path normalization only, no import/layer boundary changes | ARIA skipped — no UI files | DANA skipped — no data/schema/migration files | DAVE skipped — no CI/deploy files | DEAN skipped — no dependency manifests changed | DOCS advisory — workflow docs changed; reference path convention remains documented in `docs/REFERENCE-RESOLUTION.md` | GABE skipped — no API files | IRIS advisory — no TODO/FIXME/HACK markers introduced by reference path normalization | LUKE skipped — no UI files | OMAR skipped — no runtime logging/observability code | PETE skipped — no performance-sensitive runtime code | REED skipped — no resilience/runtime code | SETH skipped — no security-sensitive code/secrets | TODD passed — validation suites passed | VERA skipped — no privacy/PII code | WALT passed — validation suites passed; no regressions.

[dispatch] post-unify: WALT → 1 quality-history side effect recorded in `.paul/QUALITY-HISTORY.md`; CODI skipped — no codegraph source symbols for markdown-only workflow path normalization; RUBY skipped — no runtime code complexity/file-size debt introduced; SKIP advisory — fix rationale captured in this summary and STATE entry.
