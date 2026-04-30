---
name: paul-fix
description: "Quick fix with three modes: standard (compressed loop), fast-forward (zero overhead), and hotfix (execute first, document after). For ad-hoc fixes outside the main phase loop."
---

# PAUL Fix

Run the quick-fix side loop.

## Canonical workflow
- `../workflows/fix-loop.md`
- `../references/fix-types.md`

## Default output
- Concise by default: name the fix mode, current status, required evidence, and one next action.
- Expand for blockers, skipped hooks, hotfix risk, failed verification, or user request.

## Command-local notes
- Supports `standard`, `fast-forward`, and `hotfix` modes.
- `standard` compresses plan/apply/unify; `fast-forward` intentionally skips hooks; `hotfix` executes first and documents retroactively.
- Fixes are side-loop work, not normal phase progression.
- Record the fix in `STATE.md` regardless of mode.
