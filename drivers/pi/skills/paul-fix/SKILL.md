---
name: paul-fix
description: "Quick fix with three modes: standard (compressed loop), fast-forward (zero overhead), and hotfix (execute first, document after). For ad-hoc fixes outside the main phase loop."
---

# PAUL Fix

Apply a quick fix without full PLAN-APPLY-UNIFY overhead.

## What This Does

Three modes for different fix scenarios:
- **Standard**: Compressed plan-apply-unify in one pass
- **Fast-forward**: Zero overhead, just fix it (skips all hooks)
- **Hotfix**: Execute the fix first, document retroactively

## How to Execute

1. Read project state:
   - File: `.paul/STATE.md`

2. Read the full workflow definition:
   - File: `../workflows/fix-loop.md`

3. Read the fix types reference:
   - File: `../references/fix-types.md`

4. Follow the fix-loop workflow:
   - Detect fix mode from user input or ask
   - Standard: create mini-plan, execute, unify
   - Fast-forward: just make the change, log to STATE.md
   - Hotfix: execute immediately, retroactive UNIFY after

## Key Behavior

- Fixes are side-loops, not phase progression
- Fast-forward skips ALL hooks by design
- Record fix in STATE.md regardless of mode
- Main loop integrity is preserved

## Output

- Fix applied
- STATE.md updated with fix record
- Main loop position unchanged
